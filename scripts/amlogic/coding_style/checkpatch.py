#!/usr/bin/env python2

import json
import logging
import os.path
import re
import pprint
import sys

__author__ = 'lawrence'

MAX_TRAILING_SPACES_MSGS_PER_FILE = 1000
MAX_MIXED_TABS_MSGS_PER_FILE = 1000
MAX_SPACING_MSGS_PER_FILE = 1000
MAX_INDENT_MSGS_PER_FILE = 1000

INDENT_UNKNOWN = 0
INDENT_SPACES = 1
INDENT_TABS = 2

class ChangedFile:
    SOURCE_EXT = ['.c', '.cpp', '.cc', '.h', '.java', '.mk', '.xml']
    C_JAVA_EXT = ['.c', '.cpp', '.java']
    TEXT_RESOURCE_EXT = ['.rc', '.prop', '.te', '.kl', '.cfg', '.conf', '.dtd']
    BINARY_RESOURCE_EXT = ['.txt', '.so', '.ko', '.apk', '.png', '.jpg', '.jpeg', '.gif']

    def __init__(self, filename=None, is_new=False, mode=None):
        self.filename = filename
        self.file_ext = None
        if filename:
            self.on_update_filename()
        self.is_new = is_new
        self.mode = mode
        self.formattable_carriage_returns = False
        self.comments = {}

    def on_update_filename(self):
        if not self.filename:
            logging.error("couldn't get filename")
            return
        self.file_ext = os.path.splitext(self.filename)[1].lower()

    def is_source(self):
        #if self.file_ext in self.SOURCE_EXT:
        #    return True
        return True # return true directly, doesn't check file type
        if self.filename:
            b = os.path.basename(self.filename)
            if (b and (
                    b.startswith("Kconfig") or
                    b == "Makefile")):
                return True
        return False

    def is_binary_resource(self):
        if self.file_ext in self.BINARY_RESOURCE_EXT:
            return True
        return False

    def is_text_resource(self):
        if self.file_ext in self.TEXT_RESOURCE_EXT:
            return True
        return False

    def has_errors(self):
        if self.comments:
            return True
        # same as add_file_comments:
        if self.mode == 755 and self.should_not_be_executable():
            return True
        if self.formattable_carriage_returns and self.should_not_have_carriage_return():
            return True
        return False

    def should_check_line_diff(self):
        if self.is_source() or self.is_text_resource():
            return True
        return False

    def should_not_be_executable(self):
        return self.is_source() or self.is_text_resource() or self.is_binary_resource()

    def should_not_have_carriage_return(self):
        if self.is_new:
            if self.is_source() or self.is_text_resource():
                return True
        return False

    def should_check_statement_spacing(self):
        if self.file_ext in self.C_JAVA_EXT:
            return True
        return False

    def should_check_indent(self):
        if self.file_ext in self.C_JAVA_EXT:
            return True
        return False

    def add_file_comments(self):
        if self.mode == 755 and self.should_not_be_executable():
            self.append_comment(0, "{} file should not be executable".format(self.file_ext))
        if self.formattable_carriage_returns and self.should_not_have_carriage_return():
            self.append_comment(0, "{} file should not have carriage returns (DOS line endings)".format(self.file_ext))

    def append_comment(self, line, msg):
        if line in self.comments:
            self.comments[line] += "\n\n"
            self.comments[line] += msg
        else:
            self.comments[line] = msg


    # types of files/checks
    # source/resource:
    #       should be non-executable            (new/changed source + .ko, etc)
    #   source:
    #       should not have carriage return     (new source + text resources)
    #   text resource:
    #       should not have trailing spaces     (source + text resources)
    #       should not have mixed spaces/tabs   (source + text resources)
    #   source + syntax
    #       should have space in if statements  (source c/java)
    #       added line indent should match context
    # *could be imported code - warn only..?


def check(filename):
    """
    Checks unified diff.
    :param filename: diff file to check
    :return: 0 on patch errors, 1 on no patch errors, < 0 on other errors
    """
    if not filename:
        return -1

    try:
        with open(filename) as fp:
            return check_fp(fp)
    except OSError:
        logging.error(" failed to open? OSError %s", filename)
        return -2
    except IOError:
        logging.error(" failed to open? IOError %s", filename)
        return -3
    return -4


# TODO split checks into separate functions
def check_fp(fp):
    file_sections = []
    f = None
    check_lines = False
    check_statement_spacing = False
    trailing_sp_msg_count = 0
    mixed_tabs_msg_count = 0
    spacing_msg_count = 0
    in_line_diff = False
    section_line_start = 0
    section_line_start_err = False
    cur_line = 0
    for line in fp:
        if line.startswith("diff"):
            if f and f.has_errors():
                f.add_file_comments()
                file_sections.append(f)
            # start of new file
            f = ChangedFile()
            check_lines = False
            trailing_sp_msg_count = 0
            mixed_tabs_msg_count = 0
            spacing_msg_count = 0
            indent_msg_count = 0
            context_indent = INDENT_UNKNOWN
            in_line_diff = False

            # get filename
            # might fail on paths like "dir b/file.txt"
            m = re.match(r"^diff --git a/(.*) b/.*", line)
            if m:
                f.filename = m.group(1)
                f.on_update_filename()
                check_lines = f.should_check_line_diff()
                check_statement_spacing = f.should_check_statement_spacing()
                check_indent = f.should_check_indent()
        elif line.startswith("new file mode "):
            f.is_new = True
            if line.startswith("100755", len("new file mode ")):
                f.mode = 755
        elif line.startswith("new mode 100755"):
            f.mode = 755
        elif f and not f.filename and line.startswith("+++ b/"):
            # get filename if previously failed for some reason
            f.filename = line[len("+++ b/"):].rstrip('\r\n ')
            f.on_update_filename()
            check_lines = f.should_check_line_diff()
            check_statement_spacing = f.should_check_statement_spacing()
            check_indent = f.should_check_indent()
        else:
            if not check_lines:
                continue
            if line.startswith("@@ "):
                # keep track of line numbers
                # @@ -584,7 +681,7 @@
                m = re.match(r"^@@ -\d+(?:,\d+)? \+(\d+)(?:,\d+)?\ @@", line)
                try:
                    section_line_start = int(m.group(1))
                except ValueError:
                    logging.error("failed to parse section line start")
                    section_line_start_err = True
                in_line_diff = True
                cur_line = section_line_start - 1  # next line is the start
                continue
            if in_line_diff:
                # keep track of line numbers
                if line[0] in ' +':
                    cur_line += 1
                # get last context line's indent
                if line[0] == " ":
                    if line.startswith("    ", 1):
                        context_indent = INDENT_SPACES
                    elif line.startswith("\t", 1):
                        context_indent = INDENT_TABS
            if line[0] == '+' and line[1] != '+':
                if check_lines and not section_line_start_err:
                    if (f.is_new and
                            not f.formattable_carriage_returns and
                                line[-2] == '\r'):
                        f.formattable_carriage_returns = True

                    if trailing_sp_msg_count < MAX_TRAILING_SPACES_MSGS_PER_FILE:
                        if (line.endswith(" \n") or
                                line.endswith(" \r\n") or
                                line.endswith("\t\n") or
                                line.endswith("\t\r\n")):
                            f.append_comment(cur_line, "trailing spaces")
                            trailing_sp_msg_count += 1

                    if mixed_tabs_msg_count < MAX_MIXED_TABS_MSGS_PER_FILE:
                        if re.match(r" +\t", line[1:]) or re.match(r"\t+ +\t", line[1:]):
                            # tab space can be correct, but not space tab and tab space tab
                            f.append_comment(cur_line, "possibly incorrect mixed spaces then tabs indentation")
                            mixed_tabs_msg_count += 1

                    if check_statement_spacing and spacing_msg_count < MAX_SPACING_MSGS_PER_FILE:
                        m = re.match(r"\s*(if|while|for|switch)", line[1:])
                        if (m):
                            # line starts with if|while|for|switch
                            keyword = m.group(1)
                            # check parenthesis/brace spacing. if( -> if (    or    ){ -> ) {
                            m = re.match(r"\s*(?:if|while|for|switch)( ?)\(.*\)( ?)(\{?)", line[1:])
                            if (m):
                                keyword_sp, brace_space, brace = m.groups()
                                if keyword_sp != ' ' or (
                                                brace == '{' and brace_space != ' '):
                                    f.append_comment(cur_line,
                                                     "%s (...) %s  // spacing around parenthesis" % (keyword, brace))
                                    spacing_msg_count += 1

                            # check binary operator spacing on if|while line
                            # cpplint.py: match = Search(r'[^<>=!\s](==|!=|<=|>=|\|\|)[^<>=!\s,;\)]', line
                            if keyword in ['if', 'while']:
                                m = re.search(r"[^<>=!\s](==|!=|<=|>=|\|\||&&)[^<>=!\s,;\)]", line[1:])
                                if (m):
                                    f.append_comment(cur_line, "spacing around %s" % m.group(1))
                                    spacing_msg_count += 1
                            continue
                        # do{ -> do {
                        elif re.match(r"\s*do\{", line[1:]):
                            f.append_comment(cur_line, 'do {')
                            spacing_msg_count += 1

                    if check_indent and indent_msg_count < MAX_INDENT_MSGS_PER_FILE:
                        if ((context_indent == INDENT_SPACES and line.startswith("\t", 1)) or
                                (context_indent == INDENT_TABS and line.startswith("    ", 1))):
                            f.append_comment(cur_line, "make sure indent style matches rest of file")
                            indent_msg_count += 1

    if f and f.has_errors():
        f.add_file_comments()
        file_sections.append(f)

    if False:
        for f in file_sections:
            assert isinstance(f, ChangedFile)
            if f.comments:
                print f.filename
                pprint.pprint(f.comments)
                print "---"
    json_ret = file_comments_to_review(file_sections)
    if json_ret:
        print json_ret
        return 0
    else:
        return 1

REPLY_MSG = "This is an automated message.\n\nIf you think these comments are incorrect, they can be ignored."
POSITIVE_REPLY_MSG = "This is an automated message.\n\nNo problems found."

def file_comments_to_array(changed_file):
    """
    Return a list of comments for a CommentInput entry from a ChangedFile
    :param changed_file: a ChangedFile object
    :return: a list of comments for CommentInput
    """
    ret = []
    assert isinstance(changed_file, ChangedFile)
    for line, msg in changed_file.comments.iteritems():
        ret.append({"line": line,
                    "message": msg})
    return ret

def file_comments_to_review(changed_files):
    """
    Create a JSON ReviewInput from a list of ChangedFiles
    :param changed_files: list of ChangedFiles
    :return: JSON ReviewInput string
    """
    review = {}
    review['comments'] = {}
    for f in changed_files:
        if f.filename and f.comments:

            c = file_comments_to_array(f)
            if not c:
                logging.error("no comments for file")
            review['comments'][f.filename] = c
    if review['comments']:
        review['message'] = REPLY_MSG
        review['labels'] = {'Verified': -1}
        review['notify'] = 'OWNER'
    else:
        del review['comments']
        review['message'] = POSITIVE_REPLY_MSG
        review['labels'] = {'Verified': +1}
        review['notify'] = 'OWNER'
    #return json.dumps(review, indent=2)
    return json.dumps(review)

if __name__ == '__main__':
    if len(sys.argv) == 2:
        r = check(sys.argv[1])
        sys.exit(r)
    else:
        sys.stderr.write("%s <patch filename>\n" % sys.argv[0])
    sys.exit(0)

