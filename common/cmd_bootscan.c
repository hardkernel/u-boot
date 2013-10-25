/*
 * Copyright (C) 2013 Suriyan Ramasami <suriyan.r@gmail.com>
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#include <common.h>
#include <malloc.h>

#if defined(CONFIG_MENU)
/* Menu related code begins here */

/* Added to use the various usb and extXfs interfaces */
#include <usb.h>
#include <ext4fs.h>
#include <fat.h>
#include <menu.h>
#include <hush.h>

#define BOOTSCAN_MAX_DEVICES        10
#define BOOTSCAN_MAX_PARTITIONS     10
#define BOOTSCAN_MAX_BOOTABLES      10

#define BOOTSCAN_EXIT 1
#define BOOTSCAN_SHOW 2

#define BOOTSCAN_DFLT_BOOTARGS	CONFIG_BOOTARGS \
	" console=tty1 console=ttySAC1,115200 hdtv_type=hdmi" \
	" hdtv_format=720p60hz"
#define BOOTSCAN_DFLT_BOOTCMD	CONFIG_BOOTCOMMAND
#define BOOTSCAN_ANDROID_LABEL	"Android"
#define BOOTSCAN_ANDROID_BOOTSCR	"boot.scr"

#define BOOTSCAN_PROMPT_BOOTCMD \
	"setenv bootcmd echo Dropping you to u-boot"

#define BOOTSCAN_OPTIONS_HEADER \
	"#  Root       Iface  Dev  Part  FS  FileName           " \
	"Label        UUID\n" \
	BOOTSCAN_OPTIONS_DIVIDER

#define BOOTSCAN_OPTIONS_DIVIDER \
	"--------------------------------------------------------------" \
	"----------------"

#define BOOTSCAN_DFLT_NOBOOTABLES \
	"* Last boot options (None, and no bootables found!)"

#define UBOOT_BOOTARGS		"bootargs"
#define BOOTSCAN_BOOTCMD	"bootscan_bootcmd"
#define UBOOT_BOOTCMD		"bootcmd"
#define BOOTSCAN_CHOICE		"bootscan_choice"
#define BOOTSCAN_ROOT		"bootscan_root"

#define BOOTSCAN_BANNER \
"                       ___    _           _     _\n" \
"                      /___\\__| |_ __ ___ (_) __| |\n" \
"                     //  // _` | '__/ _ \\| |/ _` |\n" \
"                    / \\_// (_| | | | (_) | | (_| |\n" \
"                    \\___/ \\__,_|_|  \\___/|_|\\__,_|\n" \
"\n" \
"                       _  _   _  _   _ ____\n" \
"                      | || | | || | / |___ \\\n" \
"                      | || |_| || |_| | __) |\n" \
"                      |__   _|__   _| |/ __/\n" \
"                         |_|    |_| |_|_____|\n"

struct bootscan_bootables {
	char interface[5];
	int device;
	int partition;
	char label[32];
	char uuid[37];
	char bootimage[64];
	char bootinitrd[64];
	char bootinit[64];
	char fstype; /* 'e' => extXfs, 'f' => fat, '0' => invalid */
	char rootdev[16];
};

static void display_banner()
{
	puts(BOOTSCAN_BANNER);
}

static void bootscan_menuprint(void *print_buffer)
{
	printf("%s\n", (char *) print_buffer);
}

/*
 * We have got a string made up of possibly many lines.
 * We need to execute these.
 * We make sure that boot is not executed, by commenting it out
 */
static void process_bootini(char *buffer, ulong len) {
char *line = buffer;
char *beg = buffer;
char savechar;

	/* Scan thru the buffer and spot the boot command */
	debug("%s buffer: %p len: %x\n", __func__, buffer, (int) len);
	while (beg < &buffer[len]) {
		/* Get a line, note that we need to replace the \0 to \n
   		 *  back when we are done */
		line = strsep(&beg, "\n");
		if (line == NULL) break;
		debug("line: %s\n", line);
		/* and remove leading white spaces */
		line = skip_spaces(line);
		/* Check if the character after "boot" is some white noice */
		if ((line[4] < 33) || (line[4] > 126)) {
			savechar = line[4];
			line[4] = '\0';
		}
		/* Check if it is the boot command */
		if (strcmp(line, "boot") == 0) {
			/* It sure is! Comment it out! */
			line[0] = '#';
		}
		if (savechar != '\0')
			line[4] = savechar;

		/* Revert back the '\n' caused by strsep */
		beg[-1] = '\n';
	}
	buffer[len] = '\0';

#ifdef DEBUG
	puts(buffer);
#endif

	/* We just have to run these commands now */
#ifdef CONFIG_SYS_HUSH_PARSER
	parse_string_outer(buffer, FLAG_PARSE_SEMICOLON);
#else
	Need to define CONFIG_SYS_HUSH_PARSER
#endif

#ifdef DEBUG
	run_command("printenv", 0);
#endif
}

/*
 * Most of the code in this function is from common/cmd_source.c
 * ptr points to the data
 * len is the length of data
 * If successful it returns a pointer to the text data.
 * A NULL return implies it was not successful
 * If successful it also updates the len variable to the length of text.
 */
static char *process_bootscr(void *ptr, ulong *len) {
        image_header_t  *hdr;
	ulong           *data;
	char		*buf;

	switch(genimg_get_format(ptr)) {
	case IMAGE_FORMAT_LEGACY:
		hdr = (image_header_t *) ptr;

		if (!image_check_magic (hdr)) {
			puts ("Bad magic number\n");
			return NULL;
		}

		if (!image_check_hcrc (hdr)) {
			puts ("Bad header crc\n");
			return NULL;
		}

		if (!image_check_type (hdr, IH_TYPE_SCRIPT)) {
			puts ("Bad image type\n");
			return NULL;
                }

		/* get length of script */
		data = (ulong *)image_get_data (hdr);

		if ((*len = uimage_to_cpu (*data)) == 0) {
			puts ("Empty Script\n");
			return NULL;
                }

		/*
		 * scripts are just multi-image files with one component,
		 * seek past the zero-terminated sequence of image lengths
		 * to get to the actual image data
		 */
                while (*data++);

		/* NULL terminate the text just to be sure */
		buf = (char *) data;
		buf[*len] = '\0';
                break;

	default:
		puts("Wrong image format.\n");
		data = NULL;
		break;

	}

	debug("%s data start: %p len: %x\n", __func__, data, (int ) (*len));
	return (char *) data;
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
	char command[256];

	debug("Entering %s\n", __func__);

	s = getenv(UBOOT_BOOTCMD);
	if (strncmp(s, "echo", 4) == 0) {
		/* User wants the u-boot prompt */
		return BOOTSCAN_EXIT;
	}

	/* Modify the bootargs as set by boot.scr */
	s = getenv(UBOOT_BOOTARGS);
	debug("%s from boot.XXX is %s\n", UBOOT_BOOTARGS, s);
	if (s == NULL) {
		/* Case where bootargs is not set at all */
		s = BOOTSCAN_DFLT_BOOTARGS;
		setenv(UBOOT_BOOTARGS, s);
	}
	/* Add rootwait as Arch does not set it */
	sprintf(command, "%s rootwait root=", s);
	s = getenv(BOOTSCAN_ROOT);
	strcat(command, s);
	setenv(UBOOT_BOOTARGS, command);
	printf(UBOOT_BOOTARGS " is %s\n", command);

	run_command("run " BOOTSCAN_BOOTCMD, 0);
	s = getenv(UBOOT_BOOTCMD);
	printf(UBOOT_BOOTCMD " is %s\n", s);
	if (run_command("run " UBOOT_BOOTCMD, 0) != 0) {
		/* We failed to boot, present the menu */
		return BOOTSCAN_SHOW;
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

/*
 * Returns 0 if its not an Android partition else returns 1.
 */
static int is_android_partition(struct bootscan_bootables b)
{
	debug("%s - b.fstype: %c b.bootinit: %s b.label: %s\n",
	       __func__, b.fstype, b.bootinit, b.label);

	if ( (b.fstype == 'f') &&
	     (strcmp(b.bootinit, BOOTSCAN_ANDROID_BOOTSCR) == 0) &&
	     (strncmp(b.label, BOOTSCAN_ANDROID_LABEL,
		      strlen(BOOTSCAN_ANDROID_LABEL)) == 0) ) {
		debug("%s - its an Android partition\n", __func__);
		return 1;
	}
	debug("%s - its not an Android partition\n", __func__);
	return 0;
}

/* Here we attempt to run Android.
 * How?
 * load boot.scr and run it!
 * If we return from here => we failed to run Android
 */
static void run_android(struct bootscan_bootables b)
{
char command[128];

	sprintf(command, "fatload %s %d:%d %x %s",
		b.interface, b.device, b.partition,
		CONFIG_BOOTSCAN_SYS_LOAD_ADDR, b.bootinit);
	debug("Issuing command: %s\n", command);
	if (run_command(command, 0) != 0) {
		/* Could not load boot.scr */
		printf("Error reading %s\n", b.bootinit);
		return;
	}
	sprintf(command, "source %x", CONFIG_BOOTSCAN_SYS_LOAD_ADDR);
	debug("Issuing command: %s\n", command);
	run_command(command, 0);

	/* If we return here something wrong has happened and we 
	 * couldn't boot into Android
	 */
	return;
}

static int handle_choice(struct bootscan_bootables bootlist[], char *choice)
{
	char *s, *last_choice, *buffer;
	char command[128];
	char load_command[16];
	int index, call_saveenv = 0;
	ulong len;

	debug("Entering %s\n", __func__);

	last_choice = getenv(BOOTSCAN_CHOICE);
	if (last_choice == NULL) {
		/* User has not yet chosen before */
		setenv(BOOTSCAN_BOOTCMD, BOOTSCAN_DFLT_BOOTCMD);
		call_saveenv = 1;
		debug("bootscan: %s last_choice is NULL\n", __func__);
	}

	if ( (choice == NULL) || choice[0] == '*') {
		debug("bootscan: %s choice is null or default.\n", __func__);
		/* This is where we process it like '*' was chosen. Note
 		 * that we do have to validate the last choice for two
 		 * reasons:
 		 * 1. user would have changed boot.XXX and is rebooting
 		 * 2. user has removed some devices and hence the choice
 		 *    numbering is not valid anymore.
 		 */
	
		if (last_choice != NULL)
			choice = last_choice;
		else {
			/* Nothing here -> choose option 0 */
			choice = "0";
		}
	}
	printf("\nYou chose:\n%s\n", choice);

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
			if (call_saveenv)
				saveenv();
		}
		run_command(BOOTSCAN_PROMPT_BOOTCMD, 0);
		return BOOTSCAN_EXIT;
	}

	/* Steps to set the env variables to the chosen values */
	index = simple_strtoul(choice, NULL, 10);

	/* Check if this index is valid. As we set it when no choice is 
	 * chosen by user and we are using his last choice options.
	 */
	if ( (bootlist[index].fstype == '0') || 
	     (bootlist[index].fstype == '\0') ) {
		index = 0;
		/* If that is also not valid ? */
		if ((bootlist[index].fstype == '0') ||
	             (bootlist[index].fstype == '\0') ) {
			/* Give them the u-boot prompt! */
			setenv(BOOTSCAN_BOOTCMD, BOOTSCAN_PROMPT_BOOTCMD);
			saveenv();
			return BOOTSCAN_EXIT;
		}

	}

	/* Check if its Android. The check if its a fat partition and it
 	 * has a boot.scr file and its label is BOOTSCAN_ANDROID_LABEL
 	 */
	if (is_android_partition(bootlist[index]))
	{
		run_android(bootlist[index]);

		/* If we return we failed to boot */
		return BOOTSCAN_SHOW;
	}

	/* At least one of UUID or label will be valid */
	/* Currently we go by device name, followed by LABEL and
	 * then by UUID. For LABEL and UUID we need initrd that
	 * ArchLinuxArm does not have.
	 * Its more convenient if Distros use LABEL to boot.
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

	switch (bootlist[index].fstype) {
	case 'e':
		strcpy(load_command, "ext4load");
		break;
	default:
		return BOOTSCAN_EXIT;
	}

	/* Lets process the boot init file for gems */
	len = 0;
	if (bootlist[index].bootinit[0] != '\0') {
		sprintf(command, "%s %s %d:%d %x %s",
			load_command,
			bootlist[index].interface,
			bootlist[index].device,
			bootlist[index].partition,
			CONFIG_BOOTSCAN_SYS_LOAD_ADDR,
			bootlist[index].bootinit);
		debug("Issuing command: %s\n", command);
		if (run_command(command, 0) != 0) {
			/* Could not load boot.scr */
			printf("Error reading %s ... ignoring\n", 
				bootlist[index].bootinit);
		}
		else {
			s = getenv("filesize");
			len = simple_strtoul(s, NULL, 16);
			debug("Read %x bytes from %s\n", (int) len,
			       bootlist[index].bootinit);
		}
	}

	// Lets check if its an scr file
	if (len) {
		buffer = process_bootscr(
			       (void *) CONFIG_BOOTSCAN_SYS_LOAD_ADDR, &len);
		if (buffer == NULL) {
			/* Not a scr file, assume plain text */
			buffer = (char *) CONFIG_BOOTSCAN_SYS_LOAD_ADDR;
		}
		process_bootini(buffer, len);
	}

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

/*
 * Our job is to generate a string which holds the name of the bootfile.
 * If it has a initrd which goes along with it we append it with a []
 * Inside those brackets, we use the below indicators:
 * 'I' -> stands for boot image uses initrd.
 * 's' -> stands for - there is a scr file which shall be used.
 * 'i' -> stands for - there is a ini file which shall be used.
 * So the outcome could be: zImage[] - plain zImage
 * or zImage[I] - zImage with initrd.
 * or zImage[Ii] - zImage with initrd and ini file.
 * or zImage[Is] - zImage with initrd and scr file.
 */
#define BOOTSCAN_EXT_INI ".ini"
#define BOOTSCAN_EXT_SCR ".scr"
static void generate_bid(struct bootscan_bootables b, char *bid)
{
	char	initrd = ' ';
	char	bootscr = ' ';
	int	len;

	if (b.bootinitrd[0])
		initrd = 'I';
	if (b.bootinit[0]) {
		bootscr = 's'; /* Mark it as an scr for now */
		/* Lets check if its a .ini file */
		len = strlen(b.bootinit);
		if (strcmp(&b.bootinit[len - 4], BOOTSCAN_EXT_INI) == 0) {
			bootscr = 'i';
		}
	}
	sprintf(bid, "%s[%c%c]", b.bootimage, initrd, bootscr);
	debug("%s bid generated is: %s\n", __func__, bid);
	return;
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
	char bid[64];

	debug("Entering %s\n", __func__);
	display_banner();
	puts(BOOTSCAN_OPTIONS_DIVIDER "\n");
	m = menu_create(BOOTSCAN_OPTIONS_HEADER, 60, 1, bootscan_menuprint,
			NULL, NULL);

	for (index = 0; index < BOOTSCAN_MAX_BOOTABLES; index++) {
		if (bootlist[index].fstype == '0')
			break;
		snprintf(menu_key[index], sizeof(menu_key[index]), "%d", index);
		generate_bid(bootlist[index], bid);

		snprintf(menu_entry[index], sizeof(menu_entry[index]),
			 "%d  %-10s %-6s %d    %d     %c   %-18s %-12s %8.8s-",
			 index,
			 bootlist[index].rootdev,
			 bootlist[index].interface,
			 bootlist[index].device,
			 bootlist[index].partition,
			 bootlist[index].fstype,
			 bid,
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

	if (menu_item_add(m, "+", "+  UBoot prompt") != 1) {
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
 * If the volume label is "Android", and its a FAT partition, then
 * we only do the search for scrs.
 */
static void filesearch(struct bootscan_bootables bootlist[], int *bootindex)
{
	char *images[] = { "/boot/uImage", "/boot/zImage", "" };
	char *initrds[] = { "uInitrd", "" };
	char *scrs[] = { "boot.ini", "boot.scr", "" };
	char *s;
	int findex, index;

	debug("Entering %s\n", __func__);

	/* Lets do the Android check if its a FAT partition */
	if ( (bootlist[*bootindex].fstype == 'f') &&
	      (strncmp(bootlist[*bootindex].label, BOOTSCAN_ANDROID_LABEL,
		       strlen(BOOTSCAN_ANDROID_LABEL)) == 0)) {
		ALLOC_CACHE_ALIGN_BUFFER(char, fatbuf, 512);
		/* check if boot.scr exists -> read some bytes from file */
		debug("Android check\n");
		if (do_fat_read_at(BOOTSCAN_ANDROID_BOOTSCR, 0, fatbuf,
				   ARCH_DMA_MINALIGN, LS_NO)
					== ARCH_DMA_MINALIGN) {
			/* We got a hit, lets record it ! */
			debug(BOOTSCAN_ANDROID_BOOTSCR " exists!\n");
			strcpy(bootlist[*bootindex].bootinit,
			       BOOTSCAN_ANDROID_BOOTSCR);
			/* Lets dummy mark the image file as Android */
			strcpy(bootlist[*bootindex].bootimage,
			       BOOTSCAN_ANDROID_LABEL);
			(*bootindex)++;
		}
		else 
			debug(BOOTSCAN_ANDROID_BOOTSCR " - does not exist!\n");
		return;
	}

	/* Lets do the Linux checks now */
	findex = 0;
	while (images[findex][0] != '\0') {
		switch (bootlist[*bootindex].fstype) {
		case 'e':
			if (ext4fs_open(images[findex]) == -1) {
				findex++;
				continue;
			}
			break;

		case 'f':
			findex++;
			continue;

		default:
			/* Should not come here at all */
			debug("Unknown FS type: %c\n",
			      bootlist[*bootindex].fstype);
			findex++;
			continue;
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
		strcpy(bootlist[*bootindex].bootinit, images[findex]);
		s = strrchr(bootlist[*bootindex].bootinit, '/');
		while (scrs[index][0] != '\0') {
			strcpy(s + 1, scrs[index]);
			if (ext4fs_open(bootlist[*bootindex].bootinit) 
					== -1) {
				index++;
				continue;
			}
			debug("scr: %s\n", bootlist[*bootindex].bootinit);
			break;
		}
		/* If we didnt get a boot.scr let it be reflected */
		if (scrs[index][0] == '\0')
			bootlist[*bootindex].bootinit[0] = '\0';

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
	/* Below for fat fs */
	boot_sector bs;
	volume_info volinfo;
	int fatsize;

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
	else if (fat_set_blk_dev(dev_desc, &disk_part) == 0) {
		/* It looks like this is fat */
		if (read_bootsectandvi(&bs, &volinfo, &fatsize))
			return;
		bootlist[*bootindex].fstype = 'f';
		/* Update label name and uuid */
		strncpy(bootlist[*bootindex].label, volinfo.volume_label, 11);
		bootlist[*bootindex].label[11] = '\0';
		strcpy(bootlist[*bootindex].uuid, disk_part.uuid);
		debug("FAT label: %s uuid: %s\n", bootlist[*bootindex].label,
		      bootlist[*bootindex].uuid);
		filesearch(bootlist, bootindex);
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
	char *interfaces[] = { "mmc", "ide", "usb", "" };
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
		 * mmc -> mmc and device # change => mmcdrive++
		 * mmc -> XXX => usbdrive = 'a'
		 * ide -> usb => usbdrive++
		 * ide -> ide and device # change => usbdrive++
		 * usb -> usb and device # change => usbdrive++
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
			if (strcmp(bootlist[i-1].interface, "mmc") == 0)
				usbdrive = 'a';
			else
				mmcdrive = '0';
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
	memset(bootlist, 0, sizeof(bootlist));
	populate_bootlist(bootlist);
	do {
		retval = bootscan_menu(bootlist, bootdelay);
		if (retval == BOOTSCAN_EXIT)
			evaluate_env(bootlist);
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

