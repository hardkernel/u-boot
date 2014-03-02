/*
 * Copyright (C) 2014 Suriyan Ramasami <suriyan.r@gmail.com>
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
#define BOOTSCAN_ANDROID_BOOTCMD	CONFIG_BOOTCOMMAND
#define BOOTSCAN_ANDROID_LABEL	"Android"
#define BOOTSCAN_ANDROID_SYSTEM	"Android-Sys"
#define BOOTSCAN_ANDROID_SYS_IMAGES	"system_aa", ""
#define BOOTSCAN_ANDROID_BOOTSCR	"boot.scr"
#define BOOTSCAN_BOOTBASEDIRS	"/boot/", "/", ""
#define BOOTSCAN_BOOTIMAGES	"zImage", "uImage", ""
#define BOOTSCAN_BOOTINITRDS	"uInitrd", ""
#define BOOTSCAN_BOOTINIS	"boot.ini", "boot.scr", ""
#define BOOTSCAN_ROOTFS		"/bin/uname", "/etc/passwd", "/etc/issue", ""

#define BOOTSCAN_PROMPT_BOOTCMD \
	"setenv bootcmd echo Dropping you to u-boot"

#define BOOTSCAN_OPTIONS_HEADER \
	"#  Boot Dev   Image        Label       " \
	"| Root Dev   Label        UUID         " \
	"\n" \
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

#define BOOTSCAN_BANNER1 \
"\n" \
"                       ___    _           _     _\n" \
"                      /___\\__| |_ __ ___ (_) __| |\n" \
"                     //  // _` | '__/ _ \\| |/ _` |\n" \
"                    / \\_// (_| | | | (_) | | (_| |\n" \
"                    \\___/ \\__,_|_|  \\___/|_|\\__,_|\n" \
"\n"
#define BOOTSCAN_BANNER2 \
"                       _  _   _  _   _ ____\n" \
"                      | || | | || | / |___ \\\n" \
"                      | || |_| || |_| | __) |\n" \
"                      |__   _|__   _| |/ __/\n" \
"                         |_|    |_| |_|_____|\n"

typedef enum { UNKNOWN, LINUX_ROOTFS, ANDROID_INSTALLER } rootfs_t;
/*
 * 
 * bootimage is null string if no boot image found, or
 * 	is ANDROID_BOOT_LABEL if this is an Android boot device, or
 * 	is the full path to the linux kernel image.
 * chardev is the string which represent the device in Linux identifiable
 * 	form. Example: mmcblk0p1 for mmc interface, 0 device, 1 partition.
 * 	Another example would be sda1 for a usb or ide interface, first
 * 	device and the first partition.
 * rootfs specifies if this bootable is also contains the root filesystem
 * 	wrt linux. LINUX_ROOTFS implies it hosts a linux root file system.
 * 	ANDROID_INSTALLER implies it hosts an Android installer image.
 * 	In this case we also mark bootimage as BOOTSCAB_ANDROI_SYSTEM.
 */ 
struct bootscan_bootables {
	char interface[5];
	int device;
	int partition;
	char label[32];
	char uuid[37];
	char bootimage[64];
	char bootinitrd[64];
	char bootini[64];
	char fstype; /* 'e' => extXfs, 'f' => fat, '0' => invalid */
	char chardev[16];
	rootfs_t rootfs;
};

/*
 * This stores the mapping of choice to actual pair of indexes.
 * The first index is for the boot image
 * The second index is for the root device.
 */
#define BOOTSCAN_MAX_BOOTPAIRS \
	(BOOTSCAN_MAX_BOOTABLES * BOOTSCAN_MAX_BOOTABLES)

static int choice_pairs[BOOTSCAN_MAX_BOOTPAIRS][2];

#ifdef DEBUG
static void debug_print_bootlist(struct bootscan_bootables b[])
{
	int i;

	printf("bootscan_bootables entries as below:\n");
	for (i = 0; i < BOOTSCAN_MAX_BOOTABLES; i++) {
		if (b[i].fstype == '0')
			break;
		printf("%d interface: %s device: %d partition: %d label: %s "
		       "uuid: %s bootimage: %s bootinitrd: %s bootini: %s "
		       "fstype: %c chardev: %s rootfs: %d\n",
			i,
			b[i].interface,
			b[i].device,
			b[i].partition,
			b[i].label,
			b[i].uuid,
			b[i].bootimage,
			b[i].bootinitrd,
			b[i].bootini,
			b[i].fstype,
			b[i].chardev,
			b[i].rootfs);
	}

}
#endif

static void display_banner(void)
{
	puts(BOOTSCAN_BANNER1);
	puts(BOOTSCAN_BANNER2);
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
		if (strlen(line) < 4) break;
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
static int evaluate_env(void)
{
	char *s;
	int len;
	char command[256];

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
 * The check is to see if bootimage is BOOTSCAN_ANDROID_LABEL
 */
static int is_android_partition(struct bootscan_bootables b)
{
	debug("%s - b.fstype: %c b.bootimage: %s b.bootini: %s b.label: %s\n",
	       __func__, b.fstype, b.bootimage, b.bootini, b.label);

	if ( (strcmp(b.bootimage, BOOTSCAN_ANDROID_LABEL) == 0) ||
	     (strcmp(b.bootimage, BOOTSCAN_ANDROID_SYSTEM) == 0) ) {
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
 * That is how we did it before.
 * In the new format, we just run the default bootcmd which we have as
 * BOOTSCAN_ANDROID_BOOTCMD which is the default bootcmd of the system
 * set as CONFIG_BOOTCOMMAND
 * We do handle a new case when its an Android System installer.
 * This is identified as .rootfs == ANDROID_INSTALLER
 */
static void run_android(struct bootscan_bootables b)
{
	char command[128];

	if (b.rootfs == ANDROID_INSTALLER) {
		sprintf(command, "fatload %s %d:%d %x %s",
			b.interface, b.device, b.partition,
			CONFIG_BOOTSCAN_SYS_LOAD_ADDR, b.bootini);
		debug("Issuing command: %s\n", command);
		if (run_command(command, 0) != 0) {
			/* Could not load boot.scr */
			printf("Error reading %s\n", b.bootini);
			return;
		}
		sprintf(command, "source %x", CONFIG_BOOTSCAN_SYS_LOAD_ADDR);
		debug("Issuing command: %s\n", command);
		run_command(command, 0);
		/* This should not return */
		return;
	}

	run_command(BOOTSCAN_ANDROID_BOOTCMD, 0);

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
	int index, call_saveenv = 0, booti, rooti;
	ulong len;

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
			/* If nothing chosen and last choice is NULL */
			/* But in the case there are no options we should */
			/* choose '+' -> U-boot prompt */
			if ( (bootlist[0].fstype == '\0') ||
			     (bootlist[0].fstype == '0') )
				choice = "+";
			else
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
	debug("handle_choice: index: %d\n", index);

	/*
	 * Convert this index into a pair of indices.
	 * booti and rooti.
	 */
	booti = choice_pairs[index][0];
	rooti = choice_pairs[index][1];

	/* Check if this index is valid. As we set it when no choice is 
	 * chosen by user and we are using his last choice options.
	 */
	if ( (bootlist[booti].fstype == '0') || 
	     (bootlist[booti].fstype == '\0') ) {
		index = 0;
		booti = choice_pairs[index][0];
		rooti = choice_pairs[index][1];
		
		/* If that is also not valid ? */
		if ((bootlist[booti].fstype == '0') ||
	             (bootlist[booti].fstype == '\0') ) {
			/* Give them the u-boot prompt! */
			setenv(BOOTSCAN_BOOTCMD, BOOTSCAN_PROMPT_BOOTCMD);
			saveenv();
			return BOOTSCAN_EXIT;
		}

	}
	debug("handle_choice: booti: %d rooti: %d\n", booti, rooti);

	/* Check if its Android.
 	 */
	if (is_android_partition(bootlist[booti]))
	{
		run_android(bootlist[booti]);

		/* If we return we failed to boot */
		return BOOTSCAN_SHOW;
	}

	/*
	 * This is where the root device is set.
	 * At least one of UUID or label will be valid
	 * Currently we go by device name, followed by LABEL and
	 * then by UUID. For LABEL and UUID we need initrd that
	 * ArchLinuxArm does not have.
	 * Its more convenient if Distros use LABEL to boot.
	 */
	if (bootlist[rooti].chardev[0] != '\0')
		sprintf(command, "/dev/%s", bootlist[rooti].chardev);
	else if (bootlist[rooti].label[0] != '\0')
		sprintf(command, "%s", bootlist[rooti].label);
		else
			sprintf(command, "%s", bootlist[rooti].uuid);

	s = getenv(BOOTSCAN_ROOT);
	if ( (s == NULL) || (strcmp(s, command) != 0) ) {
		setenv(BOOTSCAN_ROOT, command);
		call_saveenv = 1;
	}

	switch (bootlist[booti].fstype) {
	case 'e':
		strcpy(load_command, "ext4load");
		break;
	case 'f':
		strcpy(load_command, "fatload");
		break;
	default:
		return BOOTSCAN_EXIT;
	}

	/* Lets process the boot init file for gems */
	len = 0;
	if (bootlist[booti].bootini[0] != '\0') {
		sprintf(command, "%s %s %d:%d %x %s",
			load_command,
			bootlist[booti].interface,
			bootlist[booti].device,
			bootlist[booti].partition,
			CONFIG_BOOTSCAN_SYS_LOAD_ADDR,
			bootlist[booti].bootini);
		debug("Issuing command: %s\n", command);
		if (run_command(command, 0) != 0) {
			/* Could not load boot.scr */
			printf("Error reading %s ... ignoring\n", 
				bootlist[booti].bootini);
		}
		else {
			s = getenv("filesize");
			len = simple_strtoul(s, NULL, 16);
			debug("Read %x bytes from %s\n", (int) len,
			       bootlist[booti].bootini);
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
		bootlist[booti].interface,
		bootlist[booti].device,
		bootlist[booti].partition,
		CONFIG_BOOTSCAN_SYS_LOAD_ADDR,
		bootlist[booti].bootimage);
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
	if (bootlist[booti].bootinitrd[0] != '\0') {
		sprintf(command, "%s %s %d:%d %x %s",
			load_command,
			bootlist[booti].interface,
			bootlist[booti].device,
			bootlist[booti].partition,
			CONFIG_BOOTSCAN_INITRD_LOAD_ADDR,
			bootlist[booti].bootinitrd);
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
		bootlist[booti].interface,
		bootlist[booti].device,
		bootlist[booti].partition,
		CONFIG_BOOTSCAN_SYS_LOAD_ADDR,
		bootlist[booti].bootimage);
	if (bootlist[booti].bootinitrd[0] != '\0') {
		sprintf(command, "setenv bootcmd '%s %s %d:%d %x %s"
			"; %s %s %d:%d %x %s'", 
			load_command,
			bootlist[booti].interface,
			bootlist[booti].device,
			bootlist[booti].partition,
			CONFIG_BOOTSCAN_SYS_LOAD_ADDR,
			bootlist[booti].bootimage,
			load_command,
			bootlist[booti].interface,
			bootlist[booti].device,
			bootlist[booti].partition,
			CONFIG_BOOTSCAN_INITRD_LOAD_ADDR,
			bootlist[booti].bootinitrd);
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
	char	initrd = '.';
	char	bootscr = '.';
	int	len;
	char	*str;

	if (b.bootinitrd[0])
		initrd = 'I';
	if (b.bootini[0]) {
		bootscr = 's'; /* Mark it as an scr for now */
		/* Lets check if its a .ini file */
		len = strlen(b.bootini);
		if (strcmp(&b.bootini[len - 4], BOOTSCAN_EXT_INI) == 0) {
			bootscr = 'i';
		}
	}
	/* Just get the name of file stripping away the full path */
	str = strrchr(b.bootimage, '/');
	if (str == NULL)
		str = b.bootimage;
	else
		str++;
	sprintf(bid, "%s[%c%c]", str, initrd, bootscr);
	debug("%s bid generated is: %s\n", __func__, bid);
	return;
}

static int bootscan_menu(struct bootscan_bootables bootlist[], int bootdelay)
{
	int index, i, j;
	struct menu *m;
	char menu_key[BOOTSCAN_MAX_BOOTPAIRS][5];
	char menu_entry[BOOTSCAN_MAX_BOOTPAIRS][128];
	char *menu_choice;
	char *last_menu_choice;
	char choice_menu_entry[64];
	char choice_menu[3];
	char bid[64];

	display_banner();
	puts(BOOTSCAN_OPTIONS_DIVIDER "\n");
	m = menu_create(BOOTSCAN_OPTIONS_HEADER, 60, 1, bootscan_menuprint,
			NULL, NULL);

	/*
	 * Best is to allow each image to boot with each rootfs.
	 * For Android we do no such thing.
	 * To accomplish this we need to scan the list for a boot image.
	 * On getting a bootimage, we then scan the same list for root file
	 * systems that we can pair it with.
	 */
	index = 0;
	for (i = 0; i < BOOTSCAN_MAX_BOOTABLES; i++) {
		if (bootlist[i].fstype == '0')
			break;
		if (bootlist[i].bootimage[0] == '\0')
			continue;
		/*
		 *  We are here -> we have a valid boot image.
		 *  In case of Android we don't need a rootfs. It does
		 *  its own crazy thing.
		 */
		if (is_android_partition(bootlist[i])) {
			char *filler = "----";
			snprintf(menu_key[index], sizeof(menu_key[index]),
				 "%d", index);
			snprintf(menu_entry[index],
				 sizeof(menu_entry[index]),
				 "%d  %-10.10s %-12.12s %-12.12s|"
				 " %-10.10s %-12.12s %-12.12s",
				 index,
				 bootlist[i].chardev,
				 bootlist[i].bootimage,
				 bootlist[i].label,
				 filler, filler, filler);
			if (menu_item_add(m, menu_key[index],
			    menu_entry[index]) != 1) {
				menu_destroy(m);
				return BOOTSCAN_EXIT;
			}
			choice_pairs[index][0] = i;
			choice_pairs[index][1] = i;
			debug("index: %d choice_pairs[%d][0]: %d choice_pairs[%d][1]: %d\n", index, index, choice_pairs[index][0], index, choice_pairs[index][1]);
			index++;
			continue;
		}

		for (j = 0; j < BOOTSCAN_MAX_BOOTABLES; j++) {
			if (bootlist[j].fstype == '0')
				break;
			if (bootlist[j].rootfs == UNKNOWN)
				continue;
			/* We are here, we have a valid rootfs */
			snprintf(menu_key[index], sizeof(menu_key[index]),
				 "%d", index);
			generate_bid(bootlist[i], bid);
			if (bootlist[j].rootfs != UNKNOWN) {
				snprintf(menu_entry[index],
					 sizeof(menu_entry[index]),
					 "%d  %-10.10s %-12.12s %-12.12s|"
					 " %-10.10s %-12.12s %-12.12s",
					 index,
					 bootlist[i].chardev,
					 bid,
					 bootlist[i].label,
					 bootlist[j].chardev,
					 bootlist[j].label,
					 bootlist[j].uuid);

			}
			if (menu_item_add(m, menu_key[index],
			    menu_entry[index]) != 1) {
				menu_destroy(m);
				return BOOTSCAN_EXIT;
			}
			choice_pairs[index][0] = i;
			choice_pairs[index][1] = j;
			debug("index: %d choice_pairs[%d][0]: %d choice_pairs[%d][1]: %d\n", index, index, choice_pairs[index][0], index, choice_pairs[index][1]);
			index++;
		}
	}

	/* This is to just to add a nice line at the end of the list */
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
 * Checks for the existence of the file with name fname
 * Returns 1 if file is present, 0 otherwise
 */
static int check_for_file(struct bootscan_bootables bootlist[],
			  int *bootindex, char *fname)
{
	if (bootlist[*bootindex].fstype == 'f') {
		ALLOC_CACHE_ALIGN_BUFFER(char, fatbuf, 512);

		/* check if fname exists - read some bytes from it */
		if (do_fat_read_at(fname, 0, fatbuf, 1, LS_NO) == 1)
		{
			debug("%s: f %s exists\n", __func__, fname);
			return 1;
		}
		else 
			debug("%s: f %s does not exist!\n", __func__, fname);
	}

	/* Ext checks */
	if ( (bootlist[*bootindex].fstype == 'e')  &&
	     (ext4fs_open(fname) != -1) ) {
		debug("%s: e %s exists\n", __func__, fname);
		return 1;
	}

	return 0;
}

/*
 * For Android, the checks we do are as follows:
 * 1. There is a file called boot.scr
 * 2. There is a directory called android
 * Assume that the base directory is "/"
 * The above is not true for the official android image:
 * - OdroidU2_SD_image_25-Apr-2013.zip
 * It seems to have a corrupted first fat partition without any sensible
 * files.
 * So the new logic would be:
 * 1. If fat partition and no kernel image assume its Android.
 * returns 1 if Android is detected, 0 otherwise.
 * Above does not work for an Android system image installer.
 * They have a zImage, a boot.scr file and Android system installer files
 * like system_aa etc.
 * Hence newer logic:
 * 1. Is a FAT partition
 * 2. Has a Android system image like system_aa
 * If 2. is true then its Android system installer. Special case.
 * 	Here we also mark it as an installer image with rootfs
 * 	set to ANDROIDSYSTEM.
 * If 2 is not true but there exists a linux boot image (zImage) then
 * its not an Android partition.
 * If fall through here => Android partition.
 *
 */
static int populate_android(struct bootscan_bootables bootlist[],
			    int *bootindex)
{
	char *images[] = { BOOTSCAN_BOOTIMAGES };
	char *aimages[] = { BOOTSCAN_ANDROID_SYS_IMAGES };
	char *inis[] = { BOOTSCAN_BOOTINIS };
	int findex, bindex;
	int isandroid = 0;

	if (bootlist[*bootindex].fstype != 'f')
		return 0;

	/* It is a fat partition */
	/* Lets check if there is an android system image */
	findex = 0;
	while (aimages[findex][0] != '\0') {
		if (check_for_file(bootlist, bootindex, aimages[findex]) == 1) {
			/* We hit on an Android system image install */
			/* This should have a boot.ini or a boot.scr */
			bindex = 0;
			while (inis[bindex][0] != '\0') {
				if (check_for_file(bootlist, bootindex, 
					inis[bindex]) == 1) {
					/* We got the ini */
					isandroid = 1;
					bootlist[*bootindex].rootfs = ANDROID_INSTALLER;
					strcpy(bootlist[*bootindex].bootini,
					       inis[bindex]);
					break;
				}
				bindex++;
			}
		}
		if (isandroid == 1)
			break;
		findex++;
	}

	/* Lets check if there is a linux image */
	findex = 0;
	while ( (isandroid != 1) && (images[findex][0] != '\0') ) {
		if (check_for_file(bootlist, bootindex, images[findex]) == 1) {
			/* We hit on a linux image. Cant be Android! */
			return 0;
		}
		findex++;
	}

	/* We are here cause no linux images were found or we found an */
	/* Android system installer image */
	/* Mark this as Android and return 1 */
	/* Lets dummy mark the image file as Android */
	if (isandroid)
		strcpy(bootlist[*bootindex].bootimage,
			BOOTSCAN_ANDROID_SYSTEM);
	else
		strcpy(bootlist[*bootindex].bootimage,
		       BOOTSCAN_ANDROID_LABEL);
	(*bootindex)++;

	return 1;
}

/*
 * limux kernel image, boot.ini/scr init files and the initrd
 * are assumed to be in the same directory.
 * The rootfs check is done by searching for certain system critical
 * files.
 */
static int populate_linux(struct bootscan_bootables bootlist[],
			  int *bootindex)
{
	char *images[] = { BOOTSCAN_BOOTIMAGES };
	char *initrds[] = { BOOTSCAN_BOOTINITRDS };
	char *inis[] = { BOOTSCAN_BOOTINIS };
	char *basedirs[] = { BOOTSCAN_BOOTBASEDIRS };
	char *rootfs[] = { BOOTSCAN_ROOTFS };
	int bdindex = 0;
	int findex;
	int found, updated = 0;

	/* Lets check for a linux rootfs */
	findex = 0;
	bootlist[*bootindex].rootfs = UNKNOWN;
	while (rootfs[findex][0] != '\0') {
		/* rootfs[] already contains full path */
		if (check_for_file(bootlist, bootindex,
		    rootfs[findex]) == 0) {
			findex++;
			continue;
		}
		/* This contains the linux rootfs */
		bootlist[*bootindex].rootfs = LINUX_ROOTFS;
		break;
	}

	/* Now lets check for the linux image related stuff */
	while (basedirs[bdindex][0] != '\0') {
		/* Lets check if there is a linux image */
		found = 0;
		findex = 0;
		while (images[findex][0] != '\0') {
			/* Generate the full path for the file */
			strcpy(bootlist[*bootindex].bootimage,
			       basedirs[bdindex]);
			strcat(bootlist[*bootindex].bootimage,
			       images[findex]);
			if (check_for_file(bootlist, bootindex, 
			    bootlist[*bootindex].bootimage) == 0) {
				findex++;
				bootlist[*bootindex].bootimage[0] = '\0';
				continue;
			}
			debug("linux: %s\n", bootlist[*bootindex].bootimage);
			found = 1;
			break;
		}
		if (found == 0) {
			/*
			 * If a linux image is not found, even if an initrd
			 * exists or a ini/scr file exists, its still not
			 * bootable. So, don't check for initrd etc.
			 * We just move on to the next base directory.
			 */
			bdindex++;
			continue;
		}

		/*
 		 * We are here implies we have a linux image.
  		 * Lets check if there is an initrd
  		 */
		findex = 0;
		while (initrds[findex][0] != '\0') {
			/* Generate the full path for the file */
			strcpy(bootlist[*bootindex].bootinitrd,
			       basedirs[bdindex]);
			strcat(bootlist[*bootindex].bootinitrd,
			       initrds[findex]);
			if (check_for_file(bootlist, bootindex, 
			    bootlist[*bootindex].bootinitrd) == 0) {
				findex++;
				bootlist[*bootindex].bootinitrd[0] = '\0';
				continue;
			}
			debug("initrd %s\n", bootlist[*bootindex].bootinitrd);
			break;
		}

		/* Lets check if there are any init files */
		findex = 0;
		while (inis[findex][0] != '\0') {
			/* Generate the full path for the file */
			strcpy(bootlist[*bootindex].bootini,
			       basedirs[bdindex]);
			strcat(bootlist[*bootindex].bootini,
			       inis[findex]);
			if (check_for_file(bootlist, bootindex, 
			    bootlist[*bootindex].bootini) == 0) {
				findex++;
				bootlist[*bootindex].bootini[0] = '\0';
				continue;
			}
			debug("ini %s\n", bootlist[*bootindex].bootini);
			break;
		}

		bdindex++;
		(*bootindex)++;
		updated = 1;
		if (*bootindex >= BOOTSCAN_MAX_BOOTABLES)
			break;
		/* Prep next bootlist structure */
		memcpy(&bootlist[*bootindex], &bootlist[*bootindex - 1],
		       sizeof(struct bootscan_bootables));
	}

	/*
	 * Handle the case when its only a rootfs. updated == 0.
	 */
	if ((updated == 0) && (bootlist[*bootindex].rootfs == LINUX_ROOTFS)) {
		(*bootindex)++;
		if (*bootindex < BOOTSCAN_MAX_BOOTABLES) {
			/* Prep next bootlist structure */
			memcpy(&bootlist[*bootindex], &bootlist[*bootindex - 1],
			       sizeof(struct bootscan_bootables));
		}
	}

	return 1;
}

/*
 * Reworked this so that it doesn’t break the older images. Before we had 
 * an assumption that the partition holding the boot image in an ext partition
 * is the same as the one holding the root fs in the case of Linux. 
 * This broke the older Linux images (Android would work), as the fat partition
 * contained the boot.ini/scr and the linux image.
 *
 * We now break away from this and make it more generic.
 * 1. For scanning for linux image and the boot.ini/scr file we assume they
 *    are present in the same directory. Hence we have a BOOTSCAN_BOOTBASEDIRS
 *    which contians those directories - typically / and /boot.
 * 2. The linux image names = zImage, uImage
 * 3. initrd: uInitrd
 * 4. Name of ini/scr files: boot.ini, boot.scr
 * The above takes care of the location of the linux kernel and its supporting
 * files - could be any partition type - fat/ext
 * 
 */
static void populate_bootfiles(struct bootscan_bootables bootlist[],
			       int *bootindex)
{
	/* First do the Android check */
	if (populate_android(bootlist, bootindex))
		return;

	/* Lets do the Linux checks now */
	populate_linux(bootlist, bootindex);
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

	part = bootlist[*bootindex].partition;

	/* Get the partition structure */
	if (get_partition_info(dev_desc, part, &disk_part))
		return;

	debug("Working on partition: %d\n", part);
	/* Try to check if its extX */
	if (ext4fs_probe(dev_desc, &disk_part) == 0) {
		bootlist[*bootindex].fstype = 'e';
		/* Update uuid and label from partition structure*/
		strcpy(bootlist[*bootindex].label, (char *) disk_part.name);
		strcpy(bootlist[*bootindex].uuid, disk_part.uuid);
		debug("disk_part.name: %s disk_part.uuid: %s\n", 
		      disk_part.name, disk_part.uuid);
		populate_bootfiles(bootlist, bootindex);
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
		populate_bootfiles(bootlist, bootindex);
		return;
	}
}

static void populate_devices(struct bootscan_bootables bootlist[],
			     int *bootindex)
{
	block_dev_desc_t *dev_desc;
	int device;
	int part;

	/* Populate bootlist from each device and the partitions within */
	for (device = 0; device < BOOTSCAN_MAX_DEVICES; device++) {
		dev_desc = get_dev(bootlist[*bootindex].interface, device);
		if (dev_desc == NULL)
			continue;
		bootlist[*bootindex].device = device;
		debug("Working on device: %d\n", device);
		for (part = 0; part < BOOTSCAN_MAX_PARTITIONS; part++) {
			bootlist[*bootindex].partition = part;
			populate_partitions(bootlist, dev_desc, bootindex);
		}
	}
}

static void gen_set_ncip(char ncip[20])
{
	int i, len;

	len = strlen(ncip) - 1;
	while (len) {
		if (ncip[len] == '.') {
			/* Make that .227 as long as its not .227 */
			if (strcmp(&ncip[len], ".227") == 0)
				strcpy(&ncip[len], ".228");
			else
				strcpy(&ncip[len], ".227");
			setenv("ncip", ncip);
			break;
		}
		len--;
	}
}

static void bootscan_netconsole()
{
	char *tmp, ncip[20];

	/* Lets initialize stuff for netconsole */
	if (!is_eth_dev_on_usb_host())
		return

	/* Issue a dhcp first */
	setenv("abcdtest", "no");
	setenv("autoload", "no");
	run_command("dhcp", 0);

	/* Check if ipaddr is set - either thru dhcp or static */
	tmp = getenv("ipaddr");
	if (tmp == NULL)
		return;

	tmp = getenv("ncip");
	if (tmp == NULL) {
		/* Generate an ncip based on ipaddress */
		tmp = getenv("ipaddr");
		strcpy(ncip, tmp);
		gen_set_ncip(ncip);
	}

	setenv("nc_test", "ping ${ncip}");
	setenv("nc_start", "setenv stdin serial,nc; setenv stdout serial,nc; setenv stderr serial,nc; version");
	run_command("run nc_test nc_start", 0);
}

/* bootlist[] can hold a max of BOOTSCAN_MAX_BOOTABLES entries */
static void populate_bootlist(struct bootscan_bootables bootlist[])
{
	/* Order is important - mimic how linux would number the devices */
	char *interfaces[] = { "mmc", "ide", "usb", "" };
	char mmcdrive, usbdrive;
	int bootindex;
	int i;

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

	bootscan_netconsole();

	/* This scans the partitions in the IDE storage */
#if defined(CONFIG_CMD_IDE)
	ide_init();
#endif /* CONFIG_CMD_IDE */

	/* Populate bootlist from each interface */
	while ((interfaces[i][0] != '\0') &&
	       (bootindex < BOOTSCAN_MAX_BOOTABLES)) {
		strcpy(bootlist[bootindex].interface, interfaces[i]);
		debug("Working on interface: %s\n", interfaces[i]);
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
	 * Lets set the drive letter and update chardev
	 * Note that for ide and usb we use sdXY
	 * If we switch to mmc, then the device used is mmcblkXpY
	 */
        usbdrive = 'a';
	mmcdrive = '0';
	/* Prep the first entry */
	if (strcmp(bootlist[0].interface, "mmc") == 0) {
		/* Its mmc, its mmcblk + dev + 'p' + part */
		sprintf(bootlist[0].chardev, "mmcblk%cp%d",
			mmcdrive, bootlist[0].partition);
	}
	else {
		sprintf(bootlist[0].chardev, "sd%c%d", usbdrive,
			bootlist[0].partition);
	}

	/* Lets get on with the rest of the entries */
        for (i = 1; i < bootindex; i++) {
                if (bootlist[i].fstype == '0')
                        break;
		/* Lets update chardev 
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
			sprintf(bootlist[i].chardev, "mmcblk%cp%d",
				mmcdrive, bootlist[i].partition);
		}
		else {
			sprintf(bootlist[i].chardev, "sd%c%d", usbdrive,
				bootlist[i].partition);
		}
	}

}

int menu_show(int bootdelay)
{
	struct bootscan_bootables bootlist[BOOTSCAN_MAX_BOOTABLES];
	int retval;

	memset(bootlist, 0, sizeof(bootlist));
	populate_bootlist(bootlist);
#ifdef DEBUG
	debug_print_bootlist(bootlist);
#endif
	do {
		retval = bootscan_menu(bootlist, bootdelay);
		if (retval == BOOTSCAN_EXIT)
			evaluate_env();
	} while (retval == BOOTSCAN_SHOW);

	return 0;
}

int do_bootscan(cmd_tbl_t *cmdtp, int flag, int argc, char *const argv[])
{
	menu_show(0);
	return 0;
}

U_BOOT_CMD(
	bootscan, 1, 1, do_bootscan,
	"Scan media for boot image",
	"    - display an user selectable list of bootable options"
);

#endif /* CONFIG_MENU */

