/*
 * (C) Copyright 2014 Hardkernel Co,.Ltd
 *
 * See file CREDITS for list of people who contributed to this
 * project.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
 * MA 02111-1307 USA
 */

#include <common.h>
#include <command.h>

#ifdef CONFIG_SYS_HUSH_PARSER
#include <hush.h>
#endif

static const char* magicstr = "ODROIDC-UBOOT-CONFIG";
static char *load_cmd =
    "if fatload mmc 0:1 $loadaddr boot.ini;"
    " then echo Loading boot.ini from mmc0:1 (vfat);"
    " else if ext4load mmc 0:1 $loadaddr /boot/boot.ini;"
    " then echo Loading boot.ini from mmc0:1 (ext4);"
    " else if ext4load mmc 0:2 $loadaddr /boot/boot.ini;"
    " then echo Loading boot.init from mmc0:2 (ext4);"
    " fi;fi;fi";

int do_fat_cfgload(cmd_tbl_t * cmdtp, int flag, int argc, char *argv[])
{
    unsigned char *fp;
    unsigned long filesize = 0;
    unsigned char cmd[512], skip = 0, first = 1;
    unsigned int wpos = 0;

    fp = (char *)simple_strtoul(getenv("loadaddr"), NULL, 16);
    if (0 == fp)
        fp = CONFIG_SYS_LOAD_ADDR;

    setenv("filesize", "0");

#ifndef CONFIG_SYS_HUSH_PARSER
    run_command(load_cmd, 0);
#else
    parse_string_outer(load_cmd, FLAG_PARSE_SEMICOLON
            | FLAG_EXIT_FROM_LOOP);
#endif

    filesize = getenv_ulong("filesize", 16, 0);
    if (0 == filesize) {
        printf("Failed to load boot.init, maybe empty file?\n");
        return 0;
    }

    if (filesize > 64 * 1024) {
        printf("boot.ini exceeds 64kB, size=%d\n", filesize);
        return 0;
    }

    printf("Executing the script...\n");

    while (1) {
        if (*fp == '#') {
            skip = 1;
        }
        else {
            skip = 0;
            wpos = 0;
            memset(cmd, 0x00, sizeof(cmd));
        }

        while (*fp != 0x0a) {
            if ((*fp != 0x0d) && (!skip))
                cmd[wpos++] = *fp;

            fp++;
            if (filesize)
                filesize--;
            else
                break;
        }

        if (wpos) {
            if (wpos < sizeof(cmd)) {
                if (first) {
                    if (!strncmp(cmd, magicstr, strlen(magicstr))) {
                        first = 0;
                    }
                    else {
                        printf("It's not boot.ini for ODROID\n");
                        return 0;
                    }
                }
                else {
                    printf("%s\n", cmd);
#ifndef CONFIG_SYS_HUSH_PARSER
                    run_command(cmd, 0);
#else
                    parse_string_outer(cmd, FLAG_PARSE_SEMICOLON
                            | FLAG_EXIT_FROM_LOOP);
#endif
                }
            }
            wpos = 0;
        }

        fp++;
        if (filesize)
            filesize--;
        else
            break;
    }

    return 1;
}

U_BOOT_CMD( cfgload, 1, 0, do_fat_cfgload,
        "cfgload - boot.ini textfile load from FAT32/ext4\n",
        "<interface(only support mmc 0:1/0:2)>\n"
        "   - boot.ini file load from FAT32/ext4 on 'interface'\n"
        "Will attempt boot from: \n"
        "   fat mmc 0:1 /boot.ini\n"
        "   ext4 0:1 /boot/boot.ini\n"
        "   ext4 0:2 /boot/boot.ini\n"
        "on the above sequence\n"
        );

/* vim: set ts=4 sw=4 tw=80: */
