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

/* Bootloader Message
 *
 * This structure describes the content of a block in flash
 * that is used for recovery and the bootloader to talk to
 * each other.
 *
 * The command field is updated by linux when it wants to
 * reboot into recovery or to update radio or bootloader firmware.
 * It is also updated by the bootloader when firmware update
 * is complete (to boot into recovery for any final cleanup)
 *
 * The status field is written by the bootloader after the
 * completion of an "update-radio" or "update-hboot" command.
 *
 * The recovery field is only written by linux and used
 * for the system to send a message to recovery or the
 * other way around.
 */
struct bootloader_message {
        char command[32];
        char status[32];
        char recovery[1024];
};

static struct bootloader_message bcb;

int board_get_recovery_message(void)
{
        block_dev_desc_t *dev_desc;
        unsigned offset, bytes;

        dev_desc = get_dev_by_name("mmc0");
        if (NULL == dev_desc)
                return 0;

        board_find_partition("bcb", &offset, &bytes);

        dev_desc->block_read(dev_desc->dev, offset, 3, &bcb);

        if (0 == strncmp(bcb.recovery, "recovery", strlen("recovery"))) {
                if (0 > test_part_dos(dev_desc)) {
                        printf("Creating default partition...\n");
                        run_command("fdisk -c 0", 0);
                }
                return LINUX_REBOOT_CMD_RECOVERY;
        }

        return 0;
}

int board_set_recovery_message(void)
{
        block_dev_desc_t *dev_desc;
        unsigned offset, bytes;
        unsigned long bread;

        memset(&bcb, 0, sizeof(struct bootloader_message));
        sprintf(bcb.recovery, "recovery\n--show_text\n--update_package=%s\n",
                        "CACHE:update.zip\n");

        dev_desc = get_dev_by_name("mmc0");
        if (NULL == dev_desc)
                return 0;

        board_find_partition("bcb", &offset, &bytes);

        return dev_desc->block_write(dev_desc->dev, offset, 3, &bcb);
}
