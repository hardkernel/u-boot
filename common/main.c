/*
 * (C) Copyright 2000
 * Wolfgang Denk, DENX Software Engineering, wd@denx.de.
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

/* #define	DEBUG	*/

#include <common.h>
#include <autoboot.h>
#include <cli.h>
#include <version.h>

#ifdef CONFIG_MDUMP_COMPRESS
#include <ramdump.h>
#endif
DECLARE_GLOBAL_DATA_PTR;

/*
 * Board-specific Platform code can reimplement show_boot_progress () if needed
 */
__weak void show_boot_progress(int val) {}

static void modem_init(void)
{
#ifdef CONFIG_MODEM_SUPPORT
	debug("DEBUG: main_loop:   gd->do_mdm_init=%lu\n", gd->do_mdm_init);
	if (gd->do_mdm_init) {
		char *str = getenv("mdm_cmd");

		setenv("preboot", str);  /* set or delete definition */
		mdm_init(); /* wait for modem connection */
	}
#endif  /* CONFIG_MODEM_SUPPORT */
}

static void run_preboot_environment_command(void)
{
#ifdef CONFIG_PREBOOT
	char *p;

	p = getenv("preboot");
	if (p != NULL) {
# ifdef CONFIG_AUTOBOOT_KEYED
		int prev = disable_ctrlc(1);	/* disable Control C checking */
# endif

		run_command_list(p, -1, 0);

# ifdef CONFIG_AUTOBOOT_KEYED
		disable_ctrlc(prev);	/* restore Control C checking */
# endif
	}
#endif /* CONFIG_PREBOOT */
}

/* We come here after U-Boot is initialised and ready to process commands */
void main_loop(void)
{
	const char *s;

	bootstage_mark_name(BOOTSTAGE_ID_MAIN_LOOP, "main_loop");
#ifdef CONFIG_MDUMP_COMPRESS
	ramdump_init();
#endif

#ifndef CONFIG_SYS_GENERIC_BOARD
	puts("Warning: Your board does not use generic board. Please read\n");
	puts("doc/README.generic-board and take action. Boards not\n");
	puts("upgraded by the late 2014 may break or be removed.\n");
#endif

	modem_init();
#ifdef CONFIG_VERSION_VARIABLE
	setenv("ver", version_string);  /* set version variable */
#endif /* CONFIG_VERSION_VARIABLE */

	cli_init();

	run_preboot_environment_command();

#if defined(CONFIG_UPDATE_TFTP)
	update_tftp(0UL);
#endif /* CONFIG_UPDATE_TFTP */

	s = bootdelay_process();
	if (cli_process_fdt(&s))
		cli_secure_boot_cmd(s);

#if defined(CONFIG_AML_UBOOT_AUTO_TEST)
	//stick 0 and stick 1 will be used to check the boot process of uboot
	//stick 0 is the start counter (0xC8834400 + 0x7C<<2) = 0xc88345f0
	//stick 1 is the end counter   (0xC8834400 + 0x7D<<2) = 0xc88345f4
	if (*((volatile unsigned int*)(0xc88345f0)))
	{
		printf("\n\naml log : TE = %d\n",*((volatile unsigned int*)0xc1109988));
		*((volatile unsigned int*)(0xc88345f4)) += 1; //stick 1
		printf("\n\naml log : Boot success %d times @ %d\n",*((volatile unsigned int*)(0xc88345f4)),
			*((volatile unsigned int*)(0xc88345f0))); //stick 0 set in bl2_main.c
		int ndelay = 10;
		int nabort = 0;
		while (ndelay)
		{
			udelay(1);
			if (tstc())
			switch (getc())
			{
			//case 0x20: /* Space */
			case 0x0d: /* Enter */
				nabort = 1;
				break;
			}
			ndelay -= 1;
		}
		if (!nabort)
			run_command("reset",0);
	}
#endif //#if defined(CONFIG_AML_UBOOT_AUTO_TEST)


	autoboot_command(s);

	cli_loop();
}
