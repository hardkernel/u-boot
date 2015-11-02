#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Amlogic gerrit code auto-fix script
# Author: xiaobo.gu@amlogic.com
# Init version: 2015.05.01

import sys, os
import json

MESSAGE_INFO_1 = "trailing spaces"
MESSAGE_INFO_2 = "spacing around parenthesis"
MESSAGE_INFO_3 = "spacing around =="
MESSAGE_INFO_4 = "spacing around !="
MESSAGE_INFO_5 = "do {"
MESSAGE_INFO_6 = "file should not be executable"
MESSAGE_INFO_7 = "possibly incorrect mixed spaces then tabs indentation"
MESSAGE_INFO_8 = "file should not have carriage returns"
MESSAGE_INFO_9 = "make sure indent style matches rest of file"
MESSAGE_INFO_10 = "spacing around &&"
MESSAGE_INFO_11 = "spacing around ||"
MESSAGE_INFO_12 = "spacing around >="
MESSAGE_INFO_13 = "spacing around <="

class fixer(object):
	def __init__(self, filename):
		self.filename = filename
		self.info_review = None
		self.info_comment = None
		self.info_labels = None
		self.cur_file_name = ""
		self.cur_file_lines = 0
		self.cur_file_content = ""
		self.cur_line_content = ""
		self.cur_line = 0
		self.cur_message = ""
		self.verified = -1

	def read_log(self):
		self.file_handle = open(self.filename)
		self.info_str = self.file_handle.read()
		self.file_handle.close()
		self.info_review = json.loads(self.info_str)
		self.info_comment = self.info_review.get("comments")
		self.info_labels = self.info_review.get("labels")

	def fix(self):
		self.verified = self.info_labels.get("Verified")
		if(1 == self.verified):
			print "Verified +1, Quit..."
			return
		for file_info in self.info_comment:
			print file_info
			#print self.cur_file_content
			#for line in self.cur_file_content:
			#	print line,
			# start fix for each warning line
			for message_info in self.info_comment[file_info]:
				self.cur_file_name = file_info
				self.cur_message = message_info.get("message")
				self.cur_line = (int)(message_info.get("line")) - 1 # index-1

				if (self.cur_line >= 0):
					# <0 always means line0 error,
					# that means file format error etc..
					# it's no need open the file
					cur_file = open(file_info) # open current file
					self.cur_file_content = cur_file.readlines() # get all content of current file, and split info lines
					cur_file.close() # close current file
					self.cur_file_lines = len(self.cur_file_content)
					self.cur_line_content = str(self.cur_file_content[self.cur_line])
				self.message_handler()
				if (self.cur_line >= 0):
					# <0 always means line0 error,
					# that means file format error etc..
					# it's no need write back current line
					self.cur_file_content[self.cur_line] = self.cur_line_content
					cur_file = open(file_info, 'w') # open current file
					cur_file.writelines(self.cur_file_content) # save file
					cur_file.close() # close current file

	def message_handler(self):
		if (self.cur_message.find(MESSAGE_INFO_1) >= 0):
			self.message_1()
		if (self.cur_message.find(MESSAGE_INFO_2) >= 0):
			self.message_2()
		if (self.cur_message.find(MESSAGE_INFO_3) >= 0):
			self.message_3()
		if (self.cur_message.find(MESSAGE_INFO_4) >= 0):
			self.message_4()
		if (self.cur_message.find(MESSAGE_INFO_5) >= 0):
			self.message_5()
		if (self.cur_message.find(MESSAGE_INFO_6) >= 0):
			self.message_6()
		if (self.cur_message.find(MESSAGE_INFO_7) >= 0):
			self.message_7()
		if (self.cur_message.find(MESSAGE_INFO_8) >= 0):
			self.message_8()
		if (self.cur_message.find(MESSAGE_INFO_9) >= 0):
			self.message_9()
		if (self.cur_message.find(MESSAGE_INFO_10) >= 0):
			self.message_10()
		if (self.cur_message.find(MESSAGE_INFO_11) >= 0):
			self.message_11()
		if (self.cur_message.find(MESSAGE_INFO_12) >= 0):
			self.message_12()
		if (self.cur_message.find(MESSAGE_INFO_13) >= 0):
			self.message_13()

	def message_1(self):
		# acknowledge bug: can not fix last line with last blank character
		'''MESSAGE_INFO_1 start'''
		#print "		-", self.cur_line, self.cur_line_content,
		cur_line_length = len(self.cur_line_content)
		#print "cur_line_length", cur_line_length
		#print self.cur_line_content
		for cur_length in range(cur_line_length-1):
			#print cur_length
			cur_char_pos = cur_line_length-2-cur_length
			#print cur_char_pos
			#print self.cur_line_content[cur_char_pos]
			#print self.cur_line_content
			#print self.cur_line_content[0:cur_char_pos], "test"
			if (self.cur_line_content[cur_char_pos] == ' ') or \
				(self.cur_line_content[cur_char_pos] == '	') :
				self.cur_line_content = self.cur_line_content[0:cur_char_pos] + '\n'
				#print self.cur_line_content
			else:
				break
		'''MESSAGE_INFO_1 end'''

	def message_2(self):
		'''MESSAGE_INFO_2 start'''
		cur_line_length = len(self.cur_line_content)
		# search parenthesis from left
		pare_pos_left = self.cur_line_content.find('(')
		#print "self.cur_line_content[pare_pos_left]:", self.cur_line_content[pare_pos_left-1]
		#print self.cur_line_content
		# insert blank char if doesn't have one
		if (pare_pos_left > 0) and (' ' != self.cur_line_content[pare_pos_left-1]):
			self.cur_line_content = self.cur_line_content[0:pare_pos_left] + ' ' + self.cur_line_content[pare_pos_left:cur_line_length]
		#print self.cur_line_content
		# re-calculate cur line length, maybe previous operations changed it's content
		cur_line_length = len(self.cur_line_content)
		# search parenthesis from right
		pare_pos_right = self.cur_line_content.rfind(')')
		if ((pare_pos_right+1) <= cur_line_length):
			#print "self.cur_line_content[pare_pos_right]:", self.cur_line_content[pare_pos_right+1]
			#print self.cur_line_content
			if (pare_pos_right > 0) and (' ' != self.cur_line_content[pare_pos_right+1]) and \
				('\n' != self.cur_line_content[pare_pos_right+1]):
				self.cur_line_content = self.cur_line_content[0:pare_pos_right+1] + ' ' + self.cur_line_content[pare_pos_right+1:cur_line_length]
			#print self.cur_line_content
		'''MESSAGE_INFO_2 end'''

	def message_3(self):
		self.message_space_around("==")

	def message_4(self):
		self.message_space_around("!=")

	def message_5(self):
		cur_line_length = len(self.cur_line_content)
		msg_pos = self.cur_line_content.find("do")
		#print "self.cur_line_content[msg_pos+2]", self.cur_line_content[msg_pos+2]
		if (' ' != self.cur_line_content[msg_pos+2]):
			self.cur_line_content = self.cur_line_content[0:msg_pos+2] + ' ' + self.cur_line_content[msg_pos+2:cur_line_length]

	def message_6(self):
		shell_cmd = "chmod -x " + self.cur_file_name
		os.system(shell_cmd)

	def message_7(self):
		cur_line_length = len(self.cur_line_content)
		cur_line_first_noblank_pos = 0
		# find out first non-blank(' '&'	') char
		for cur_char_pos in range(cur_line_length):
			if (' ' != self.cur_line_content[cur_char_pos]) and \
				('	' != self.cur_line_content[cur_char_pos]):
				cur_line_first_noblank_pos = cur_char_pos
				break
		#print self.cur_line_content
		# replace these 4' 's with tab, 1,2,3 blanks will be deleted
		no_blank_str = self.cur_line_content[0:cur_line_first_noblank_pos]
		no_blank_str = no_blank_str.replace("    ", "	")
		no_blank_str = no_blank_str.replace("   ", "")
		no_blank_str = no_blank_str.replace("  ", "")
		no_blank_str = no_blank_str.replace(" ", "")
		self.cur_line_content = no_blank_str + self.cur_line_content[cur_line_first_noblank_pos:cur_line_length]

	def message_8(self):
		shell_cmd = "dos2unix -o -f " + self.cur_file_name
		os.system(shell_cmd)

	def message_9(self):
		cur_line_length = len(self.cur_line_content)
		cur_line_first_noblank_pos = 0
		# find out first non-blank(' '&'	') char
		for cur_char_pos in range(cur_line_length):
			if (' ' != self.cur_line_content[cur_char_pos]) and \
				('	' != self.cur_line_content[cur_char_pos]):
				cur_line_first_noblank_pos = cur_char_pos
				break
		no_blank_str = self.cur_line_content[0:cur_line_first_noblank_pos]
		no_blank_str_tmp = no_blank_str.replace("    ", "	")
		if (no_blank_str_tmp == no_blank_str):
			no_blank_str = no_blank_str.replace("	", "    ")
		else:
			no_blank_str = no_blank_str_tmp
		#print self.cur_line_content
		self.cur_line_content = no_blank_str + self.cur_line_content[cur_line_first_noblank_pos:cur_line_length]
		#print self.cur_line_content

	def message_10(self):
		self.message_space_around("&&")

	def message_11(self):
		self.message_space_around("||")

	def message_12(self):
		self.message_space_around(">=")

	def message_13(self):
		self.message_space_around("<=")

	def message_space_around(self, symbol):
		replace_symbol = []
		replace_symbol.append(' ' + symbol + ' ')
		replace_symbol.append(' ' + symbol)
		replace_symbol.append(symbol + ' ')
		#print self.cur_line_content
		for rep in range(len(replace_symbol)):
			self.cur_line_content = self.cur_line_content.replace(replace_symbol[rep], symbol)
		self.cur_line_content = self.cur_line_content.replace(symbol, replace_symbol[0])
		#print self.cur_line_content

	def printf(self):
		#print "comment: ", self.info_comment
		#print "labels: ", self.info_labels
		for file_info in self.info_comment:
			print file_info
			for message_info in self.info_comment[file_info]:
				print "		", message_info

	def run(self):
		self.read_log()
		#self.printf()
		self.fix()

if __name__=='__main__':
	if len(sys.argv) != 2:
		print 'auto_fix.py [review_log_file]'
		exit(1)
	fixer = fixer(sys.argv[1])
	fixer.run()
