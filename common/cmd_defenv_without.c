/*
 * \file        cmd_defenv_without.c
 * \brief       use this cmd but not 'env default',
 *               to reserve some envs after defaulting envs
 *
 * \version     1.0.0
 * \date        15/09/29
 * \author      Sam.Wu <yihui.wu@amlgic.com>
 *
 * Copyright (c) 2015 Amlogic. All Rights Reserved.
 *
 */
#include <config.h>
#include <common.h>
#include <command.h>
#include <environment.h>
#include <cli.h>
#include <errno.h>
#include <malloc.h>
#include <linux/stddef.h>
#include <asm/byteorder.h>

static const char*  const temp_for_compile[] = {"__test1","__test2","__test3",NULL};
extern const char * const _env_args_reserve_[0] __attribute__((weak, alias("temp_for_compile")));

#define ModPrefix(pre) printf(pre"[def_wi]")
#define debugP(fmt...) //ModPrefix("Dbg"),printf("L%d:", __LINE__),printf(fmt)
#define errorP(fmt...) ModPrefix("Err"), printf("L%d:", __LINE__),printf(fmt)
#define wrnP(fmt...)   ModPrefix("Err"), printf(fmt)
#define MsgP(fmt...)   ModPrefix("Err"), printf(fmt)

static int _reserve_env_list_after_defenv(const int reservNum, const char* const reservNameList[])
{
        int ret = 0;
        int index = 0;
        unsigned sumOfEnvVal = 0;//sum of strlen(getenv(env_i))
        const int MaxReservNum = CONFIG_SYS_MAXARGS - 1;
        const char* valListBuf[MaxReservNum];//store at most 64 envs
        char* tmpEnvBuf = NULL;

        if (reservNum > MaxReservNum) {
                errorP("max reserved env list num %d < wanted %d\n", MaxReservNum, reservNum);
                return __LINE__;
        }
        //1, cal the total buf size needed to save the envs
        for (index = 0; index < reservNum; ++index)
        {
                const char* cfgEnvKey = reservNameList[index];
                const char* cfgEnvVal = getenv(cfgEnvKey);

                if (cfgEnvVal) {
                        sumOfEnvVal += strlen(cfgEnvVal) + 1;
                }
                valListBuf[index] = cfgEnvVal;
        }

        //2, transfer the env values to buffer
        if (sumOfEnvVal)
        {
                tmpEnvBuf = (char*)malloc(sumOfEnvVal);
                if (!tmpEnvBuf) {
                        errorP("Fail in malloc(%d)\n", sumOfEnvVal);
                        return __LINE__;
                }
                memset(tmpEnvBuf, 0, sumOfEnvVal);

                char* tmpbuf    = tmpEnvBuf;
                for (index = 0; index < reservNum; ++index )
                {
                        const char*    valBeforeDef     = valListBuf[index];

                        if (!valBeforeDef) continue;

                        const unsigned thisValLen       = strlen(valBeforeDef) + 1;
                        memcpy(tmpbuf, valBeforeDef, thisValLen);
                        valListBuf[index] = tmpbuf;
                        tmpbuf += thisValLen ;
                        debugP("tmpEnvBuf=%p, tmpbuf=%p, thisValLen=%d\n", tmpEnvBuf, tmpbuf, thisValLen);
                        debugP("cp:k[%s]%s-->%s\n", reservNameList[index], valBeforeDef, tmpEnvBuf);
                }
        }

        set_default_env("## defenv_reserve\n");

        if (sumOfEnvVal)
        {
                for (index = 0; index < reservNum; ++index)
                {
                        const char* cfgEnvKey           = reservNameList[index];
                        const char* valAftDef           = valListBuf[index];

                        if (valAftDef)
                        {
                                setenv(cfgEnvKey, valAftDef);
                                debugP("set[%s=%s]\n", cfgEnvKey, valAftDef);
                        }
                }
        }

        if (tmpEnvBuf) free(tmpEnvBuf) ;
        return ret;
}

static int do_defenv_reserv(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
        int envListNum = argc - 1;
        const char** envListArr = (const char**)(argv + 1);

        if (!envListNum)
        {
                envListArr = (const char**)_env_args_reserve_;

                const char** pArr = (const char**)envListArr;
                while (*pArr++) ++envListNum;
        }

        int ret = _reserve_env_list_after_defenv(envListNum, envListArr);

        return ret ? CMD_RET_FAILURE : CMD_RET_SUCCESS;
}

U_BOOT_CMD(
   defenv_reserv,       //command name
   CONFIG_SYS_MAXARGS,  //maxargs
   0,                   //repeatable
   do_defenv_reserv,    //command function
   "reserve some specified envs after defaulting env",           //description
   "    argv: defenv_reserve <reserv_en0 reserv_env1 ...> \n"   //usage
   "    - e.g. \n"
   "        defenv_reserve :\n"   //usage
   "               NOT env list , reserv cfg array '_env_args_reserve_' in gxbb_p200.c\n"
   "        defenv_reserve reserv_en0, reserv_env1, ...\n"   //usage
   "               reserve specified envs after defaulting env\n"   //usage
);

