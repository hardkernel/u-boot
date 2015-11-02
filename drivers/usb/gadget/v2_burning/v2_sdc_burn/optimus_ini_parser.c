/*
 * \file        optimus_ini_parser.c
 * \brief       ini parsing utilities for sdc burnning
 *
 * \version     1.0.0
 * \date        2013-7-11
 * \author      Sam.Wu <yihui.wu@amlgic.com>
 *
 * Copyright (c) 2013 Amlogic. All Rights Reserved.
 *
 */
#include "optimus_sdc_burn_i.h"

#define dbg(fmt ...)  //printf("[INI]"fmt)
#define msg           DWN_MSG
#define err           DWN_ERR

#define MAX_ARGS    4
#define is_space_char(c) ('\t' == c || ' ' == c)
#define is_delimeter(c)  ('[' == c || ']' == c || '=' == c)

#define is_valid_char(c) ( ('0' <= c && '9' >= c) || ('_' == c)\
                        || ('a' <= c && 'z' >= c) || ('A' <= c && 'Z' >= c) ) \
                        || ('.' == c) || ('\\' == c) || ('/' == c) || ('-' == c) \
                        || (':' == c)

static int line_is_valid(const char* line)
{
    char c = 0;

    while (c = *line++, c)
    {
        int ret = is_delimeter(c) || is_valid_char(c) || is_space_char(c);

        if (!ret) {
            err("invalid chars! ascii val(0x%x)\n", c);
            return 0;
        }
    }

    return 1;//line is valid
}

//valid lines type: set or key/value pair
enum _INI_LINE_TYPE{
    INI_LINE_TYPE_ERR       = 0,
    INI_LINE_TYPE_SET          ,
    INI_LINE_TYPE_KE_VALUE     ,
};

//this func is used after line_is_valid
static int line_2_words(char* line, char* argv[], const int maxWords)
{
    int nargs = 0;
    char cur = 0;

    for (cur = *line; is_space_char(cur); cur = *++line) {}

    argv[nargs++] = line;
    for (;cur = *line, cur; ++line)
    {
        if (!is_space_char(cur)) continue;
        //following do with space character

        *line = 0;
        for (cur = *++line; is_space_char(cur) && cur; cur = *++line) {}//ignore all space between words

        if (!cur) break;//line ended

        argv[nargs++] = line;
        if (maxWords <= nargs) {
            err("too many words num %d, max is %d\n", nargs, maxWords);
            return 0;
        }
    }

    return nargs;
}

//step1:first loop to seprate buffer to lines
int _optimus_parse_buf_2_lines(char* pTextBuf, const unsigned textSz,
                const char* lines[], unsigned* totalLineNum, const unsigned MaxLines)
{
        const char* curLine = pTextBuf;
        char* pTemp = pTextBuf;
        unsigned i = 0;
        unsigned lineNum = 0;

        pTextBuf[textSz] = '\0';
        //loop to seprate buffer to lines
        for (i = 0; i < textSz ; i++, ++pTemp)
        {
                char c = *pTemp;
                const int isFileEnd = i + 1 >= textSz;

                if (MaxLines <= lineNum) {
                        DWN_ERR("total line number %d too many, at most %d lines!\n", lineNum, MaxLines);
                        break;
                }

                if ('\r' != c && '\n' != c) {
                        continue;
                }
                *pTemp = 0;///

                if (isFileEnd) {
                        dbg("fileend:curLine=[%s]\n", curLine);
                        lines[lineNum++] = curLine;
                        break;//End to read file if file ended
                }

                if ('\r' == c) //for DOS \r\n mode
                {
                        if ('\n' == pTemp[1])
                        {
                                lines[lineNum++] = curLine;

                                ++pTemp;
                                curLine = pTemp + 1;
                                ++i;//skip '\n' which follows '\r'
                        }
                        else
                        {
                                DWN_ERR("Syntax error at line %d, DOS end \\r\\n, but \\r%x\n", lineNum + 1, pTemp[1]);
                                return __LINE__;
                        }
                }
                else if('\n' == c)//for UNIX '\n' mode
                {
                        lines[lineNum++] = curLine;
                        curLine = pTemp + 1;
                }

                dbg("Get Line[%03d]: %s\n", lineNum, lines[lineNum - 1]);
        }

        *totalLineNum = lineNum;
        return 0;
}

//abandon comments lines and space lines,
//but not decrease thie line numbers
int _optimus_abandon_ini_comment_lines(char* lines[], const unsigned lineNum)
{
    unsigned lineIndex = 0;
    for (lineIndex = 0; lineIndex < lineNum ; lineIndex++)
    {
        int isSpaceLine = 1;
        char c = 0;
        char* thisLine = lines[lineIndex];

        while (c = *thisLine++, c)
        {
            //escape space and tab
            if (is_space_char(c))
            {
                continue;
            }

            isSpaceLine = 0;//no space line
            //test if frist char is comment delimeter
            if (';' == c)
            {
                lines[lineIndex] = NULL;//invalid comment lines
            }
        }

        //if all character is space or tab, also invlalid it
        if (isSpaceLine)
        {
            lines[lineIndex] = NULL;
        }
    }

    return 0;
}

//Return value is the valid line numbers
//1, Read the whole file content to buffer
//2, parse file content to lines
//3, parse each valid line
int parse_ini_file_2_valid_lines(const char* filePath, char* iniBuf, const unsigned bufSz, char* lines[])
{
    const int MaxLines = 1024;//
    int ret = 0;
    unsigned fileSz = bufSz;
    unsigned lineNum = 0;
    int hFile = -1;
    unsigned readLen = 0;

    fileSz = (unsigned)do_fat_get_fileSz(filePath);
    if (!fileSz) {
            err("File %s not exist in sdcard??\n", filePath);
            return 0;
    }
    if (fileSz >= bufSz) {
            err("file size 0x%x illegal, > bufSz 0x%x\n", fileSz, bufSz);
            return 0;
    }
    DWN_MSG("ini sz 0x%xB\n", fileSz);

    hFile = do_fat_fopen(filePath);
    if (hFile < 0) {
            err("Fail to open file %s\n", filePath);
            return 0;
    }

    readLen = do_fat_fread(hFile, (u8*)iniBuf, fileSz);
    if (readLen != fileSz) {
            err("failed to load cfg file, want size 0x%x, but 0x%x\n", fileSz, readLen);
            do_fat_fclose(hFile);
            return 0;
    }
    iniBuf[fileSz] = 0;

    do_fat_fclose(hFile);

    dbg("\\r is 0x%x\t, \\n is 0x%x\n", '\r', '\n');

    //step1:first loop to seprate buffer to lines
    ret = _optimus_parse_buf_2_lines(iniBuf, fileSz, (const char**)lines, &lineNum, MaxLines);
    if (ret) {
            err("Fail to parse buf to lines.ret=%d\n", ret);
            return 0;
    }

    //step 2: abandon comment or space lines
    ret = _optimus_abandon_ini_comment_lines(lines, lineNum);

    return lineNum;
}

int optimus_ini_trans_lines_2_usr_params(const char* const lines[], const unsigned lineNum,
                        int (*pCheckSetUseFul)(const char* setName),
                        int (*pParseCfgVal)(const char* setName, const char* keyName, const char* keyVal))
{
        const int MaxWordsALine = 32;
        char* wordsALine[MaxWordsALine];
        int ret = 0;
        int nwords = 0;
        unsigned i = 0;
        unsigned lineIndex = 0;
        const int MaxUsefulSets = 8;
        const char* cacheSetNames[MaxUsefulSets];
        const char* CurrentSetName = NULL;

        while (i < MaxUsefulSets) cacheSetNames[i++] = NULL;

        dbg("\nvalid lines:\n");
        for (lineIndex = 0; lineIndex < lineNum ; lineIndex++)
        {
                int lineType = INI_LINE_TYPE_ERR;
                const char* iniKey = NULL;
                const char* iniVal = NULL;
                const char* iniSet = NULL;

                const char* const curLine = lines[lineIndex];

                if (!curLine) continue;//comment or space lines

                if (!line_is_valid(curLine)) //only comment lines can contain non-ASCII letters
                {
                        err("line %d contain invalid chars\n", lineIndex + 1);
                        ret = __LINE__;
                        break;
                }
                dbg("%3d: %s\n",lineIndex, curLine);

                nwords = line_2_words((char*)curLine, wordsALine, MaxWordsALine);
                if (nwords <= 0) {
                        ret = __LINE__;
                        break;
                }
                if (nwords > 3) {
                        err("line %d error: ini support at most 3 words, but %d\n", lineIndex + 1, nwords);
                        ret = __LINE__;
                        break;
                }

                switch (nwords)
                {
                        case 3:
                                {
                                        if (!strcmp("=", wordsALine[1]))//k/v pair
                                        {
                                                lineType = INI_LINE_TYPE_KE_VALUE;
                                                iniKey = wordsALine[0]; iniVal = wordsALine[2];
                                                break;
                                        }
                                        else if(!strcmp("[" , wordsALine[0]) && !strcmp("]" , wordsALine[2]))//set line
                                        {
                                                lineType = INI_LINE_TYPE_SET;
                                                iniSet = wordsALine[1];
                                                break;
                                        }
                                        else
                                        {
                                                lineType = INI_LINE_TYPE_ERR;
                                                err("Ini syntax error when parse line %d\n", lineIndex + 1);
                                                ret = __LINE__; break;
                                        }
                                }
                                break;

                        case 2:
                                {
                                        if ('[' == wordsALine[0][0]) //set like "[set ]" or "[ set]"
                                        {
                                                if (!strcmp("]", wordsALine[1]))
                                                {
                                                        lineType = INI_LINE_TYPE_SET;
                                                        iniSet = wordsALine[0] + 1;
                                                        break;
                                                }
                                                else if (']' == wordsALine[1][strlen(wordsALine[1]) - 1] && !strcmp("[", wordsALine[0]))
                                                {
                                                        lineType = INI_LINE_TYPE_SET;
                                                        iniSet = wordsALine[1];
                                                        wordsALine[1][strlen(wordsALine[1]) - 1] = 0;
                                                        break;
                                                }
                                        }
                                        else if(!strcmp("=", wordsALine[1]))//k/v pair like "key = "
                                        {
                                                lineType = INI_LINE_TYPE_KE_VALUE;
                                                iniKey = wordsALine[0];
                                                break;
                                        }
                                        else if('=' == wordsALine[1][0])//k/v pair like "key =v" or "key= v"
                                        {
                                                lineType = INI_LINE_TYPE_KE_VALUE;
                                                iniKey = wordsALine[0];
                                                iniVal = wordsALine[1] + 1;
                                                break;
                                        }
                                        else if ('=' == wordsALine[0][strlen(wordsALine[0]) - 1])//k/v pair like "key= v"
                                        {
                                                wordsALine[0][strlen(wordsALine[0]) - 1] = 0;
                                                lineType = INI_LINE_TYPE_KE_VALUE;
                                                iniKey = wordsALine[0];
                                                iniVal = wordsALine[1];
                                        }
                                }
                                break;

                        case 1:
                                {
                                        char* word = wordsALine[0];
                                        char firstChar = word[0];
                                        char lastChar  = word[strlen(word) - 1];

                                        if ('[' == firstChar && ']' == lastChar)
                                        {
                                                lineType = INI_LINE_TYPE_SET;
                                                iniSet = word + 1;
                                                word[strlen(word) - 1] = 0;
                                                break;
                                        }
                                        else
                                        {
                                                char c = 0;

                                                iniKey = word;
                                                while (c = *word++, c)
                                                {
                                                        if ('=' == c)//TODO: not assert only delimeter in a line yet
                                                        {
                                                                lineType = INI_LINE_TYPE_KE_VALUE;
                                                                *--word = 0;
                                                                iniVal = ++word;
                                                                iniVal = *iniVal ? iniVal : NULL;
                                                                break;
                                                        }
                                                }
                                        }
                                }
                                break;

                        default:
                                break;
                }

                if (INI_LINE_TYPE_SET == lineType)
                {
                        int setIndex = 0;

                        dbg("set line, set is %s\n", iniSet);
                        CurrentSetName = NULL;
                        if ( !pCheckSetUseFul(iniSet) ) {//the set don't care
                                continue;
                        }

                        //Check the useful set name is not duplicated!
                        for (setIndex = 0; setIndex < MaxUsefulSets; ++setIndex) {
                                const char* pset = cacheSetNames[setIndex];
                                if (!pset) {
                                        CurrentSetName = cacheSetNames[setIndex] = iniSet;
                                        break;
                                }
                                if (!strcmp(pset, iniSet)) {
                                        ret = __LINE__;
                                        goto _set_duplicated;
                                }
                        }
                }
                else if(INI_LINE_TYPE_KE_VALUE == lineType && CurrentSetName)
                {
                        dbg("k/v line, key (%s), val (%s)\n", iniKey, iniVal);

                       ret = pParseCfgVal(CurrentSetName, iniKey, iniVal);
                       if (ret) {
                               goto _line_err;
                       }
                }
        }

        return ret;

_line_err:
        err("Fail to parse line %d\n", lineIndex + 1);
        return ret;

_set_duplicated:
        err("line %d err:set is duplicated!!\n", lineIndex + 1);
        return ret;
}


