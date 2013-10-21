/*
 * Copyright (C) 2013 Suriyan Ramasami <suriyan.r@gmail.com>
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#include <common.h>

#if defined(CONFIG_MENU)
/* Menu related code begins here */

/* Added to use the various usb and extXfs interfaces */
#include <usb.h>
#include <ext4fs.h>
#include <menu.h>

#define BOOTSCAN_MAX_DEVICES        10
#define BOOTSCAN_MAX_PARTITIONS     10
#define BOOTSCAN_MAX_BOOTABLES      10

#define BOOTSCAN_EXIT 1
#define BOOTSCAN_SHOW 2

#if 0
#define BOOTSCAN_DFLT_BOOTARGS \
	"setenv bootargs ${console} ubi.mtd=2,2048 " \
	"root=ubi0:root rootfstype=ubifs debug"

#define BOOTSCAN_DFLT_BOOTCMD \
	"setenv bootcmd nand read.e 0x800000 0x100000 0x600000"
#else
#define BOOTSCAN_DFLT_BOOTARGS	CONFIG_BOOTARGS
#define BOOTSCAN_DFLT_BOOTCMD	CONFIG_BOOTCOMMAND
#endif

#define BOOTSCAN_PROMPT_BOOTCMD \
	"setenv bootcmd echo Dropping you to u-boot"

#define BOOTSCAN_CHOSEN_BOOTARGS \
	"setenv bootargs ${console} ${mem} rootwait " \
	"root=${" BOOTSCAN_ROOT "} ${hdtv_type} ${hdtv_format}"

#define BOOTSCAN_OPTIONS_HEADER \
	"#  Root       Iface  Dev  Part  FS  FileName         " \
	"Label          UUID\n" \
	BOOTSCAN_OPTIONS_DIVIDER

#define BOOTSCAN_OPTIONS_DIVIDER \
	"--------------------------------------------------------------" \
	"----------------"

#define BOOTSCAN_DFLT_NOBOOTABLES \
	"* Last boot options (None, and no bootables found!)"

#define BOOTSCAN_BOOTARGS	"bootscan_bootargs"
#define UBOOT_BOOTARGS		"bootargs"
#define BOOTSCAN_BOOTCMD	"bootscan_bootcmd"
#define UBOOT_BOOTCMD		"bootcmd"
#define BOOTSCAN_CHOICE		"bootscan_choice"
#define BOOTSCAN_ROOT		"bootscan_root"

struct bootscan_bootables {
	char interface[5];
	int device;
	int partition;
	char label[32];
	char uuid[37];
	char bootimage[64];
	char bootinitrd[64];
	char bootscr[64];
	char fstype; /* 'e' => extXfs, '0' => invalid */
	char rootdev[16];
};

char *vars[] = { "initrd_high", "fdt_high", "hdtv_type",
		 "hdtv_format", "console", "mem", "" };
char *var_defaults[] = { "0xffffffff", "0xffffffff", "hdmi",
			 "720p60hz", "tty1 ttySAC1,115200n8", "" };
char var_values[sizeof(vars) / sizeof((vars)[0])][64];

static void bootscan_menuprint(void *print_buffer)
{
	printf("%s\n", (char *)print_buffer);
}

/* Return non zero if we got some variables in the env.
 * boot.scr has been loaded at address ptr. It is of length len.
 * What we need to do is try to grab variables like
 * a. initrd_high
 * b. fdt_high
 * c. hdtv_type
 * d. hdtv_format
 * e. mem
 * f. console (multiple definitions)
 * Once we have these variables we shall do a setenv of them
 * Examples:
 * a. setenv initrd_high initrd_high=<whatever>
 * b. etc
 * f. setenv console <console=xyz console=abc ...>
 * Our bootargs shall be setenv bootargs ${console} ${initrd_high}
 * 	${fdt_high} ${mem} ${hdtv_type} ${hdtv_format} root...
 */
static int process_scr(void *ptr, int len) {
	char *startptr = (char *) ptr;
	char *endptr = &startptr[len];
	char *sep = " \t=\n\"\r;%{}'$";
	char *beg, *end;
	int i;
	int retval = 0;
	char *s;
	char cmd[128];

	end = startptr;
	while (end < endptr) {
		beg = strsep(&end, sep);
		// Now beg has beginning of a possible string. end points 
		// to end of that possible string
		if (end == NULL) {
			end = beg + 1;
			continue;
		}
		if ((end - beg) < 3) {
			// At least 3 characters long ?
			continue;
		}
		// Got a potential word. Check it out
		debug("Got word: %s\n", beg);
		i = 0;
		while (vars[i][0] != '\0') {
			if (strcmp(vars[i], beg) == 0) {
				// We got a word hit.
				debug("Got a word hit: %s\n", beg);
				// Now extract the following word
				do {
					beg = strsep(&end, sep);
					if (end == NULL)
						end = beg + 1;
				} while (strlen(beg) == 0);
				debug("Extracted word: %s\n", beg);
				// cat it over in its entry if its not the same
				if (strcmp(beg, vars[i])) {
					if (strlen(var_values[i])) {
						// multiple console lines
						strcat(var_values[i], " ");
						strcat(var_values[i], vars[i]);
						strcat(var_values[i], "=");
					}
					strcat(var_values[i], beg);
				}
			}
			i++;
		}
	}

#ifdef DEBUG
	// Lets print out what we got!
	debug("-------------- Words extracted -----------------------\n");
	i = 0;
	while (vars[i][0] != '\0') {
		debug("%s : %s\n", vars[i], var_values[i]);
		i++;
	}
	debug("------------------------------------------------------\n");
#endif

	// Lets setenv the variables
	i = 0;
	while (vars[i][0] != '\0') {
		if (var_values[i][0] == '\0') {
			// We possibly dont set mem on our own
			// if boot.scr does not refer to it.
			if (strcmp(vars[i], "mem") == 0) {
				i++;
				continue;
			}
			beg = var_defaults[i];
		}
		else
			beg = var_values[i];
		// Generate the env string
		sprintf(cmd, "%s=%s", vars[i], beg);
		debug("Generated env string: %s\n", cmd);
		s = getenv(vars[i]);
		if ( (s == NULL)  || strcmp(s, cmd)) {
			setenv(vars[i], cmd);
			retval = 1;
			debug("setenv %s %s\n", vars[i], cmd);
		}
		else {
			debug("Env same value: %s = %s\n", vars[i], s);
		}
		i++;
	}

	return retval;
}

/*
 * We shall use bootscan_<> variables to capture the state of past menu
 * choices.
 * bootscan_bootargs corresponds to bootargs
 * bootscan_bootcmd corresponds to bootcmd
 * bootscan_choice corresponds to the last choice that was picked
 * bootscan_choice will be NULL the first time and also
 * if a choice was never made. In that case we should pick
 * to boot from the 1st bootable option if present. Note that this
 * condition is handled in bootscan_menu()
*/
static int evaluate_env()
{
	char *s;
	int len;
	char command[128];

	debug("Entering %s\n", __func__);
	run_command("run " BOOTSCAN_BOOTARGS, 0);
	s = getenv(UBOOT_BOOTARGS);
	printf(UBOOT_BOOTARGS " is %s\n", s);
	run_command("run " BOOTSCAN_BOOTCMD, 0);
	s = getenv(UBOOT_BOOTCMD);
	printf(UBOOT_BOOTCMD " is %s\n", s);
	if (run_command("run " UBOOT_BOOTCMD, 0) != 0) {
		/* We failed to boot, present the menu */
		return BOOTSCAN_SHOW;
	}
	if (strncmp(s, "echo", 4) == 0) {
		/* User wants the u-boot prompt */
		return BOOTSCAN_EXIT;
	}
	sprintf(command, "bootm %x", CONFIG_BOOTSCAN_SYS_LOAD_ADDR);

	/*
	 * Check if we have to boot with the initrd. Easy check is to 
	 * see if there is a ';' in UBOOT_BOOTCMD
	 */
	if (strchr(s, ';')) {
		len = strlen(command);
		sprintf(&command[len], " %x", CONFIG_BOOTSCAN_INITRD_LOAD_ADDR);
	}
	debug("Issuing command: %s\n", command);
	run_command(command, 0);

	/* We are here, we failed to boot */
	return BOOTSCAN_SHOW;
}

static int handle_choice(struct bootscan_bootables bootlist[], char *choice)
{
	char *s, *last_choice;
	char command[128];
	char load_command[16];
	int index, call_saveenv;
	int len;

	debug("Entering %s\n", __func__);
	call_saveenv = 0;
	if (choice == NULL) {
		/* Exit menu and let it do its auto boot */
		debug("bootscan: %s choice is null.\n", __func__);
		return BOOTSCAN_EXIT;
	}
	printf("\nYou chose: %s\n", choice);

	last_choice = getenv(BOOTSCAN_CHOICE);
	if (last_choice == NULL) {
		/* User has not yet chosen before */
		setenv(BOOTSCAN_BOOTARGS, BOOTSCAN_DFLT_BOOTARGS);
		setenv(BOOTSCAN_BOOTCMD, BOOTSCAN_DFLT_BOOTCMD);
		call_saveenv = 1;
		debug("bootscan: %s last_choice is NULL\n", __func__);
	}
	if (choice[0] == '*') {
		/* User wants same thing that was chosen the last time */
		debug("bootscan: %s choice is *\n", __func__);
		return BOOTSCAN_EXIT;
	}
	if (last_choice && strcmp(choice, last_choice) != 0) {
		/* Save the choice chosen */
		setenv(BOOTSCAN_CHOICE, choice);
		call_saveenv = 1;
	}
	if (choice[0] == '+') {
		/* User wants u-boot prompt */
		debug("bootscan: %s choice is +\n", __func__);
		s = getenv(BOOTSCAN_BOOTCMD);
		if ( (s == NULL) || 
		     (strcmp(s, BOOTSCAN_PROMPT_BOOTCMD) !=  0) ) {
			setenv(BOOTSCAN_BOOTCMD, BOOTSCAN_PROMPT_BOOTCMD);
			saveenv();
		}
		return BOOTSCAN_EXIT;
	}

	/* Steps to set the env variables to the chosen values */
	index = simple_strtoul(choice, NULL, 10);

	/* At least one of UUID or label will be valid */
	/* Currently we go by device name, followed by LABEL and
	 * then by UUID. For LABEL and UUID we need initrd that
	 * ArchLinuxArm does not have.
	 */
	if (bootlist[index].rootdev[0] != '\0')
		sprintf(command, "/dev/%s", bootlist[index].rootdev);
	else if (bootlist[index].label[0] != '\0')
		sprintf(command, "%s", bootlist[index].label);
		else
			sprintf(command, "%s", bootlist[index].uuid);

	s = getenv(BOOTSCAN_ROOT);
	if ( (s == NULL) || (strcmp(s, command) != 0) ) {
		setenv(BOOTSCAN_ROOT, command);
		call_saveenv = 1;
	}

	s = getenv(BOOTSCAN_BOOTARGS);
	if ( (s == NULL) || (strcmp(s, BOOTSCAN_CHOSEN_BOOTARGS) != 0) ) {
		setenv(BOOTSCAN_BOOTARGS, BOOTSCAN_CHOSEN_BOOTARGS);
		call_saveenv = 1;
	}

	switch (bootlist[index].fstype) {
	case 'e':
		strcpy(load_command, "ext4load");
		break;
	default:
		return BOOTSCAN_EXIT;
	}

	/* Lets process the boot.scr file for gems */
	len = 0;
	if (bootlist[index].bootscr[0] != '\0') {
		sprintf(command, "%s %s %d:%d %x %s",
			load_command,
			bootlist[index].interface,
			bootlist[index].device,
			bootlist[index].partition,
			CONFIG_BOOTSCAN_SYS_LOAD_ADDR,
			bootlist[index].bootscr);
		debug("Issuing command: %s\n", command);
		if (run_command(command, 0) != 0) {
			/* Could not load boot.scr */
			printf("Error reading %s ... ignoring\n", 
				bootlist[index].bootscr);
		}
		else {
			s = getenv("filesize");
			len = (int) simple_strtoul(s, NULL, 16);
			debug("Read %d bytes from %s\n", len,
			       bootlist[index].bootscr);
		}
	}

	// We call process_scr() even in the absence of a boot.scr file
	// as it sets some default values.
	call_saveenv += process_scr((void *) CONFIG_BOOTSCAN_SYS_LOAD_ADDR,
				     len);

	/* Lets try to load and check the boot image */
	sprintf(command, "%s %s %d:%d %x %s",
		load_command,
		bootlist[index].interface,
		bootlist[index].device,
		bootlist[index].partition,
		CONFIG_BOOTSCAN_SYS_LOAD_ADDR,
		bootlist[index].bootimage);
	debug("Issuing command: %s\n", command);
	if (run_command(command, 0) != 0) {
		/* Could not load boot image */
		printf("Selected image could not be loaded ...\n");
		return BOOTSCAN_SHOW;
	}
	sprintf(command, "iminfo %x", CONFIG_BOOTSCAN_SYS_LOAD_ADDR);
	debug("Issuing command: %s\n", command);
	if (run_command(command, 0) != 0) {
		/* The image is not a valid image */
		printf("Selected image is not valid ...\n");
		return BOOTSCAN_SHOW;
	}

	/* Lets try to load the initrd if any */
	if (bootlist[index].bootinitrd[0] != '\0') {
		sprintf(command, "%s %s %d:%d %x %s",
			load_command,
			bootlist[index].interface,
			bootlist[index].device,
			bootlist[index].partition,
			CONFIG_BOOTSCAN_INITRD_LOAD_ADDR,
			bootlist[index].bootinitrd);
		debug("Issuing command: %s\n", command);
		if (run_command(command, 0) != 0) {
			/* Could not load initrd */
			printf("Selected image could not be loaded ...\n");
			return BOOTSCAN_SHOW;
		}
		sprintf(command, "iminfo %x", CONFIG_BOOTSCAN_INITRD_LOAD_ADDR);
		debug("Issuing command: %s\n", command);
		if (run_command(command, 0) != 0) {
			/* The image is not a valid image */
			printf("Selected image is not valid ...\n");
			return BOOTSCAN_SHOW;
		}
	}

	/* We generate these commands for unattended booting the
	 * next time the user does not choose an option
	 */
	sprintf(command, "setenv bootcmd %s %s %d:%d %x %s",
		load_command,
		bootlist[index].interface,
		bootlist[index].device,
		bootlist[index].partition,
		CONFIG_BOOTSCAN_SYS_LOAD_ADDR,
		bootlist[index].bootimage);
	if (bootlist[index].bootinitrd[0] != '\0') {
		sprintf(command, "setenv bootcmd '%s %s %d:%d %x %s"
			"; %s %s %d:%d %x %s'", 
			load_command,
			bootlist[index].interface,
			bootlist[index].device,
			bootlist[index].partition,
			CONFIG_BOOTSCAN_SYS_LOAD_ADDR,
			bootlist[index].bootimage,
			load_command,
			bootlist[index].interface,
			bootlist[index].device,
			bootlist[index].partition,
			CONFIG_BOOTSCAN_INITRD_LOAD_ADDR,
			bootlist[index].bootinitrd);
	}
	debug(BOOTSCAN_BOOTCMD " is set as: %s\n", command);
	s = getenv(BOOTSCAN_BOOTCMD);
	if ( (s == NULL) || (strcmp(s, command) != 0) ) {
		setenv(BOOTSCAN_BOOTCMD, command);
		call_saveenv = 1;
	}
	if (call_saveenv)
		saveenv();
	return BOOTSCAN_EXIT;
}

static int bootscan_menu(struct bootscan_bootables bootlist[], int bootdelay)
{
	int index;
	struct menu *m;
	char menu_key[BOOTSCAN_MAX_BOOTABLES][5];
	char menu_entry[BOOTSCAN_MAX_BOOTABLES][128];
	char *menu_choice;
	char *last_menu_choice;
	char choice_menu_entry[64];
	char choice_menu[3];
	char bootimagedisp[64];

	debug("Entering %s\n", __func__);
	puts(BOOTSCAN_OPTIONS_DIVIDER "\n");
	m = menu_create(BOOTSCAN_OPTIONS_HEADER, 60, 1, bootscan_menuprint,
			NULL, NULL);
	for (index = 0; index < BOOTSCAN_MAX_BOOTABLES; index++) {
		if (bootlist[index].fstype == '0')
			break;
		snprintf(menu_key[index], sizeof(menu_key[index]), "%d", index);
		/* We put a [I] next to boot image to indicate it has initrd */
		if (bootlist[index].bootinitrd[0] == '\0')
			strcpy(bootimagedisp, bootlist[index].bootimage);
		else
			sprintf(bootimagedisp, "%s[I]",
			        bootlist[index].bootimage);

		snprintf(menu_entry[index], sizeof(menu_entry[index]),
			 "%d  %-10s %-6s %d    %d     %c   %-16s %-14s %8.8s-",
			 index,
			 bootlist[index].rootdev,
			 bootlist[index].interface,
			 bootlist[index].device,
			 bootlist[index].partition,
			 bootlist[index].fstype,
			 bootimagedisp,
			 bootlist[index].label,
			 bootlist[index].uuid);
		if (menu_item_add(m, menu_key[index], menu_entry[index]) != 1) {
			menu_destroy(m);
			return BOOTSCAN_EXIT;
		}
	}

	/* This is to just add a nice line at the end of the list */
	if (menu_item_add(m, "-", BOOTSCAN_OPTIONS_DIVIDER) != 1) {
		menu_destroy(m);
		return BOOTSCAN_EXIT;
	}

	/* Prep for what should be the default menu choice */
	/* If chosen before, choose the last boot options */
	/* If nothing chosen yet, then choose the first bootable option */
	/* If nothing chosen yet, and no first bootable option, then ? */
	last_menu_choice = getenv(BOOTSCAN_CHOICE);
	sprintf(choice_menu, "*");
	if (last_menu_choice) {
		sprintf(choice_menu_entry, "* Last boot options:\n(%s)",
			last_menu_choice);
	} else {
		/* There was no last boot option */
		/* If there is at least 1 boot entry, make that the default */
		if (bootlist[0].fstype != '0') {
			setenv(BOOTSCAN_CHOICE, menu_entry[0]);
			sprintf(choice_menu_entry, menu_entry[0]);
		} else {
			/* This is answer to the ? asked above */
			sprintf(choice_menu_entry, BOOTSCAN_DFLT_NOBOOTABLES);
		}
	}
	if (menu_item_add(m, choice_menu, choice_menu_entry) != 1) {
		menu_destroy(m);
		return BOOTSCAN_EXIT;
	}
	/* Mark this as the default choice. */
	menu_default_set(m, "*");
	if (menu_item_add(m, "+", "+ UBoot prompt") != 1) {
		menu_destroy(m);
		return BOOTSCAN_EXIT;
	}

	menu_get_choice(m, (void **)&menu_choice);
	return handle_choice(bootlist, menu_choice);
}

/*
 * Here we assume that the /boot directory holds the linux image and
 * if an initrd is being used, it exists in the same directory - /boot
 * This implies that inited names are without path - just file name!
 * Same goes for the boot.scr file.
 */
static void filesearch(struct bootscan_bootables bootlist[], int *bootindex)
{
	char *images[] = { "/boot/uImage", "/boot/zImage", "" };
	char *initrds[] = { "uInitrd", "" };
	char *scrs[] = { "boot.scr", "" };
	char *s;
	
	int findex, index;

	debug("Entering %s\n", __func__);
	findex = 0;
	while (images[findex][0] != '\0') {
		switch (bootlist[*bootindex].fstype) {
		case 'e':
			if (ext4fs_open(images[findex]) == -1) {
				findex++;
				continue;
			}
			break;

		default:
			break;
		}

		/* Got a hit, record it */
		strcpy(bootlist[*bootindex].bootimage, images[findex]);

		/* Lets check if there is an initrd in the same directory */
		index = 0;
		strcpy(bootlist[*bootindex].bootinitrd, images[findex]);
		s = strrchr(bootlist[*bootindex].bootinitrd, '/');
		while (initrds[index][0] != '\0') {
			strcpy(s + 1, initrds[index]);
			debug("initrd %s\n", bootlist[*bootindex].bootinitrd);
			if (ext4fs_open(bootlist[*bootindex].bootinitrd) 
					== -1) {
				index++;
				continue;
			}
			break;
		}
		/* If we didnt get an initrd let it be reflected */
		if (initrds[index][0] == '\0')
			bootlist[*bootindex].bootinitrd[0] = '\0';

		/* Lets check if there is a boot.scr in the same dir */
		index = 0;
		strcpy(bootlist[*bootindex].bootscr, images[findex]);
		s = strrchr(bootlist[*bootindex].bootscr, '/');
		while (scrs[index][0] != '\0') {
			strcpy(s + 1, scrs[index]);
			if (ext4fs_open(bootlist[*bootindex].bootscr) 
					== -1) {
				index++;
				continue;
			}
			debug("scr: %s\n", bootlist[*bootindex].bootscr);
			break;
		}
		/* If we didnt get a boot.scr let it be reflected */
		if (scrs[index][0] == '\0')
			bootlist[*bootindex].bootscr[0] = '\0';

		findex++;
		(*bootindex)++;
		if (*bootindex >= BOOTSCAN_MAX_BOOTABLES)
			break;
		/* Prep next bootlist structure */
		memcpy(&bootlist[*bootindex], &bootlist[*bootindex - 1],
		       sizeof(struct bootscan_bootables));
	}
}

static void populate_partitions(struct bootscan_bootables *bootlist,
				block_dev_desc_t *dev_desc,
				int *bootindex)
{
	int part;
	disk_partition_t disk_part;

	debug("Entering %s\n", __func__);
	part = bootlist[*bootindex].partition;

	/* Get the partition structure */
	debug(" Calling get_partition_info()\n");
	if (get_partition_info(dev_desc, part, &disk_part))
		return;

	/* Try to check if its extX */
	debug(" Calling ext4fs_probe()\n");
	if (ext4fs_probe(dev_desc, &disk_part) == 0) {
		debug(" Back from ext4fs_probe()\n");
		bootlist[*bootindex].fstype = 'e';
		/* Update uuid and label from partition structure*/
		strcpy(bootlist[*bootindex].label, (char *) disk_part.name);
		strcpy(bootlist[*bootindex].uuid, disk_part.uuid);
		debug("disk_part.name: %s disk_part.uuid: %s\n", 
		      disk_part.name, disk_part.uuid);
		filesearch(bootlist, bootindex);
		ext4fs_close();
		return;
	}
}

static void populate_devices(struct bootscan_bootables bootlist[],
			     int *bootindex)
{
	block_dev_desc_t *dev_desc;
	int device;
	int part;

	debug("Entering %s\n", __func__);
	/* Populate bootlist from each device and the partitions within */
	for (device = 0; device < BOOTSCAN_MAX_DEVICES; device++) {
		dev_desc = get_dev(bootlist[*bootindex].interface, device);
		if (dev_desc == NULL)
			continue;
		bootlist[*bootindex].device = device;
		for (part = 0; part < BOOTSCAN_MAX_PARTITIONS; part++) {
			bootlist[*bootindex].partition = part;
			populate_partitions(bootlist, dev_desc, bootindex);
		}
	}
}

/* bootlist[] can hold a max of BOOTSCAN_MAX_BOOTABLES entries */
static void populate_bootlist(struct bootscan_bootables bootlist[])
{
	/* Order is important - mimic how linux would number the devices */
	char *interfaces[] = { "ide", "usb", "mmc", "" };
	char mmcdrive, usbdrive;
	int bootindex;
	int i;

	debug("Entering %s\n", __func__);
	bootindex = 0;
	i = 0;

	/* Lets initialize the usb subsystem */
	run_command("usb start", 0);

#if defined(CONFIG_USB_KEYBOARD)
# if defined(CONFIG_CONSOLE_MUX)
	run_command("setenv stdin serial,usbkbd", 0);
# else
	run_command("setenv stdin usbkbd", 0);
# endif
#endif

	/* This scans the partitions in the IDE storage */
#if defined(CONFIG_CMD_IDE)
	ide_init();
#endif /* CONFIG_CMD_IDE */

	/* Populate bootlist from each interface */
	while ((interfaces[i][0] != '\0') &&
	       (bootindex < BOOTSCAN_MAX_BOOTABLES)) {
		strcpy(bootlist[bootindex].interface, interfaces[i]);
		populate_devices(bootlist, &bootindex);
		i++;
	}
	if (bootindex < BOOTSCAN_MAX_BOOTABLES) {
		/* End marker of list */
		bootlist[bootindex].fstype = '0';
	}

	/* No boot list! */
	if (bootlist[0].fstype == '0') return;

        /*
	 * Lets set the drive letter and update rootdev
	 * Note that for ide and usb we use sdXY
	 * If we switch to mmc, then the device used is mmcblkXpY
	 */
        usbdrive = 'a';
	mmcdrive = '0';
	/* Prep the first entry */
	if (strcmp(bootlist[0].interface, "mmc") == 0) {
		/* Its mmc, its mmcblk + dev + 'p' + part */
		sprintf(bootlist[0].rootdev, "mmcblk%cp%d",
			mmcdrive, bootlist[0].partition);
	}
	else {
		sprintf(bootlist[0].rootdev, "sd%c%d", usbdrive,
			bootlist[0].partition);
	}

	/* Lets get on with the rest of the entries */
        for (i = 1; i < bootindex; i++) {
                if (bootlist[i].fstype == '0')
                        break;
		/* Lets update rootdev 
		 * Logic is as follows -
		 * ide -> usb => usbdrive++
		 * ide -> ide and device # change => usbdrive++
		 * usb -> usb and device # change => usbdrive++
		 * mmc -> mmc and device # change => mmcdrive++
		 * XXX -> mmc => mmcdrive = '0'
		 */
		if (strcmp(bootlist[i].interface, bootlist[i-1].interface)
			   == 0) {
			/* Same interface => check for device # change */
			if (bootlist[i].device != bootlist[i-1].device) {
				usbdrive++;
				mmcdrive++;
			}
		}
		else {
			/* The interface has changed */
			if (strcmp(bootlist[i].interface, "mmc") == 0)
				mmcdrive = '0';
			else
				usbdrive++;
		}
		if (strcmp(bootlist[i].interface, "mmc") == 0) {
			/* Its mmc, its mmcblk + dev + 'p' + part */
			sprintf(bootlist[i].rootdev, "mmcblk%cp%d",
				mmcdrive, bootlist[i].partition);
		}
		else {
			sprintf(bootlist[i].rootdev, "sd%c%d", usbdrive,
				bootlist[i].partition);
		}
        }

}

int menu_show(int bootdelay)
{
	struct bootscan_bootables bootlist[BOOTSCAN_MAX_BOOTABLES];
	int retval;

	debug("Entering %s\n", __func__);
	populate_bootlist(bootlist);
	do {
		retval = bootscan_menu(bootlist, bootdelay);
		if (retval == BOOTSCAN_EXIT)
			evaluate_env();
	} while (retval == BOOTSCAN_SHOW);

	return 0;
}

int do_bootscan(cmd_tbl_t *cmdtp, int flag, int argc, char *const argv[])
{
	debug("Entering %s\n", __func__);
	menu_show(0);
	return 0;
}

U_BOOT_CMD(
	bootscan, 1, 1, do_bootscan,
	"Scan media for boot image",
	"    - display an user selectable list of bootable options"
);

#endif /* CONFIG_MENU */

