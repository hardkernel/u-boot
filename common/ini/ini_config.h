#ifndef __INI_CONFIG_H__
#define __INI_CONFIG_H__

#if (!defined(CC_COMPILE_IN_PC) && !defined(CC_COMPILE_IN_ANDROID))
    #define CC_COMPILE_IN_UBOOT
    #define CC_INI_IO_USE_UNIFY_KEY
#endif

#if (defined CC_COMPILE_IN_PC)
    #define CC_UBOOT_RW_SIMULATE
#endif

#if (defined CC_COMPILE_IN_PC || defined CC_COMPILE_IN_ANDROID)
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <ctype.h>
    #include <errno.h>
    #include <fcntl.h>
    #include <unistd.h>
    #include <sys/stat.h>
#elif (defined CC_COMPILE_IN_UBOOT)
    #include <common.h>
    #include <command.h>
    #include <environment.h>
    #include <linux/ctype.h>
    #include <linux/string.h>
    #include <malloc.h>
    #include <amlogic/keyunify.h>
    #include <ext4fs.h>
    #include <linux/stat.h>
    #include <malloc.h>
    #include <fs.h>
    #include <emmc_partitions.h>
#endif

#endif //__INI_CONFIG_H__
