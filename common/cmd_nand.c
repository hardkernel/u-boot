/*
 * Driver for NAND support, Rick Bronson
 * borrowed heavily from:
 * (c) 1999 Machine Vision Holdings, Inc.
 * (c) 1999, 2000 David Woodhouse <dwmw2@infradead.org>
 *
 * Added 16-bit nand support
 * (C) 2004 Texas Instruments
 */

#include <common.h>
#include <linux/ctype.h>
#include <linux/mtd/mtd.h>
#include <command.h>
#include <watchdog.h>
#include <malloc.h>
#include <asm/byteorder.h>
#include <jffs2/jffs2.h>
#include <nand.h>
#include <asm/arch/nand.h>
#include <div64.h>
#include <linux/err.h>

#if defined(CONFIG_CMD_MTDPARTS)

/* partition handling routines */
int mtdparts_init(void);
int id_parse(const char *id, const char **ret_id, u8 *dev_type, u8 *dev_num);
int find_dev_and_part(const char *id, struct mtd_device **dev,
		      u8 *part_num, struct part_info **part);
#endif

static int nand_protect = 1;

static int nand_dump(nand_info_t *nand, loff_t off, int only_oob)
{
	int i;
	loff_t addr;
	u_char *datbuf, *oobbuf, *p;
    printf("%s\n", __func__);
	if(off < nand_info[0]->writesize*256*4)
	{
	    nand = nand_info[0];
        }
        else
        {
            nand = nand_info[1];
        }
	datbuf = malloc(nand->writesize + nand->oobsize);
	
	if (!datbuf) {
		puts("No memory for page buffer\n");
		return 1;
	}
    oobbuf = malloc(nand->oobsize);
    if (!oobbuf) {
        free(datbuf);
		puts("No memory for page buffer\n");
		return 1;
	}
	addr = ~((loff_t)nand->writesize - 1);
	addr &= off;
	struct mtd_oob_ops ops;
	memset(&ops, 0, sizeof(ops));
	ops.datbuf = datbuf;
	ops.oobbuf = oobbuf; /* must exist, but oob data will be appended to ops.datbuf */
	ops.len = nand->writesize;
	ops.ooblen = nand->oobsize;
	ops.mode = MTD_OOB_RAW;
	i = nand->read_oob(nand, addr, &ops);
	if (i < 0) {
		printf("Error (%d) reading page %09llx\n", i, off);
		free(datbuf);
		free(oobbuf);
		return 1;
	}
	printf("Page %09llx dump,page size %d:\n", off,nand->writesize);
	i = (nand->writesize + nand->oobsize) >> 4;
	p = datbuf;

	while (i--) {
		if (!only_oob)
			printf("\t%02x %02x %02x %02x %02x %02x %02x %02x"
			       "  %02x %02x %02x %02x %02x %02x %02x %02x\n",
			       p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7],
			       p[8], p[9], p[10], p[11], p[12], p[13], p[14],
			       p[15]);
		p += 16;
	}
	/*printf("OOB oob size %d:\n",nand->oobsize);
	i = nand->oobsize >> 3;
	while (i--) {
		printf("\t%02x %02x %02x %02x %02x %02x %02x %02x\n",
		       p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7]);
		p += 8;
	}*/
	free(datbuf);
	free(oobbuf);

	return 0;
}

/* ------------------------------------------------------------------------- */

static inline int isstring(char *p)
{
	char *endptr = p;
	while (*endptr != '\0') {
		if (!(((*endptr >= '0') && (*endptr <= '9')) 
			|| ((*endptr >= 'a') && (*endptr <= 'f'))
			|| ((*endptr >= 'A') && (*endptr <= 'F'))
			|| (*endptr == 'x') || (*endptr == 'X')))
			return 1;
		endptr++;
	}

	return 0;
}

static inline int str2long(char *p, ulong *num)
{
	char *endptr;
	*num = simple_strtoul(p, &endptr, 16);
	return (*p != '\0' && *endptr == '\0') ? 1 : 0;
}
static inline int str2longlong(char *p, unsigned long long *num)
{
	char *endptr;
    
	*num = simple_strtoull(p, &endptr, 16);
	if(*endptr!='\0')
	{
	    switch(*endptr)
	    {
	        case 'g':
	        case 'G':
	            *num<<=10;
	        case 'm':
	        case 'M':
	            *num<<=10;
	        case 'k':
	        case 'K':
	            *num<<=10;
	            endptr++;
	            break;
	    }
	}
	
	return (*p != '\0' && *endptr == '\0') ? 1 : 0;
}

static int
arg_off_size(int argc, char *argv[], nand_info_t *nand, loff_t *off, loff_t *size)
{
	int idx = nand_curr_device;
/*#if defined(CONFIG_CMD_MTDPARTS)
	struct mtd_device *dev;
	struct part_info *part;
	u8 pnum;
	//printf("sizeof=%d\n",sizeof(loff_t));
	if (argc >= 1 && !(str2longlong(argv[0], (unsigned long long*)off))) {
		if ((mtdparts_init() == 0) &&
		    (find_dev_and_part(argv[0], &dev, &pnum, &part) == 0)) {
			if (dev->id->type != MTD_DEV_TYPE_NAND) {
				puts("not a NAND device\n");
				return -1;
			}
			*off = part->offset;
			if (argc >= 2) {
				if (!(str2longlong(argv[1], (unsigned long long *)size))) {
					printf("'%s' is not a number\n", argv[1]);
					return -1;
				}
				if (*size > part->size)
					*size = part->size;
			} else {
				*size = part->size;
			}
			idx = dev->id->num;
			nand = nand_info[idx];
			goto out;
		}
	}
#endif*/
	if (argc >= 1) {
		if (!(str2longlong(argv[0], (unsigned long long*)off))) {
			printf("'%s' is not a number\n", argv[0]);
			return -1;
		}
	} else {
		*off = 0;
	}

	if (argc >= 2) {
		if (!(str2longlong(argv[1], (unsigned long long *)size))) {
			printf("'%s' is not a number\n", argv[1]);
			return -1;
		}
	} else {
		*size = nand->size - *off;
	}

#if defined(CONFIG_CMD_MTDPARTS)
out:
#endif
	//printf("device %d ", idx);
	if (*size == nand->size)
		puts("whole chip\n");
	else
		printf("offset 0x%llx, size 0x%llx\n", *off, *size);


	return 0;
}

#ifdef CONFIG_CMD_NAND_LOCK_UNLOCK
static void print_status(ulong start, ulong end, ulong erasesize, int status)
{
	printf("%08lx - %08lx: %08lx blocks %s%s%s\n",
		start,
		end - 1,
		(end - start) / erasesize,
		((status & NAND_LOCK_STATUS_TIGHT) ?  "TIGHT " : ""),
		((status & NAND_LOCK_STATUS_LOCK) ?  "LOCK " : ""),
		((status & NAND_LOCK_STATUS_UNLOCK) ?  "UNLOCK " : ""));
}

static void do_nand_status(nand_info_t *nand)
{
	ulong block_start = 0;
	ulong off;
	int last_status = -1;

	struct nand_chip *nand_chip = nand->priv;
	/* check the WP bit */
	nand_chip->cmdfunc(nand, NAND_CMD_STATUS, -1, -1);
	printf("device is %swrite protected\n",
		(nand_chip->read_byte(nand) & 0x80 ?
		"NOT " : ""));

	for (off = 0; off < nand->size; off += nand->erasesize) {
		int s = nand_get_lock_status(nand, off);

		/* print message only if status has changed */
		if (s != last_status && off != 0) {
			print_status(block_start, off, nand->erasesize,
					last_status);
			block_start = off;
		}
		last_status = s;
	}
	/* Print the last block info */
	print_status(block_start, off, nand->erasesize, last_status);
}
#endif

static void nand_print_info(int idx)
{
	nand_info_t *nand = nand_info[idx];
	struct nand_chip *chip = nand->priv;
	printf("Device %d: ", idx);
	if (chip->numchips > 1)
		printf("%dx ", chip->numchips);
#ifdef CONFIG_MTD_DEVICE
	printf("%s, %s sector size %u KiB\n",
	       nand->name, nand->info, nand->erasesize >> 10);
#else
	printf("%s, sector size %u KiB\n",
	       nand->name, nand->erasesize >> 10);
#endif
}

int do_nand(cmd_tbl_t * cmdtp, int flag, int argc, char *argv[])
{
	int i, dev, ret = 0;
	ulong addr;
	loff_t off, size;
	char *cmd, *s;
	nand_info_t *nand;
#ifdef CONFIG_SYS_NAND_QUIET
	int quiet = CONFIG_SYS_NAND_QUIET;
#else
	int quiet = 0;
#endif
	const char *quiet_str = getenv("quiet");

#if ((defined CONFIG_AML_NAND_KEY) || (defined MX_REVD) || (defined CONFIG_SECURE_NAND))
	int chip_num , tmp_chip_num, error;
	nand = nand_info[nand_curr_device];
	struct mtd_info *mtd =nand;
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(nand);
#endif

	/* at least two arguments please */
	if (argc < 2)
		goto usage;

	if (quiet_str)
		quiet = simple_strtoul(quiet_str, NULL, 0) != 0;

	cmd = argv[1];
#ifdef CONFIG_AML_NAND_KEY
	if (strcmp(cmd, "key") == 0){
		aml_chip->key_protect = 1;		//force nand key can be erased 
		return 0;
	}
#endif
#ifdef CONFIG_SECURE_NAND
	if (strcmp(cmd, "secure") == 0){
		aml_chip->secure_protect = 1;		//force nand key can be erased
		return 0;
	}
#endif

#ifdef CONFIG_SECURE_NAND
		if (strcmp(cmd, "secure") == 0){
			aml_chip->secure_protect = 1;		//force nand key can be erased 
			return 0;
		}
#endif

	if(strcmp(cmd, "exist") == 0){
		if(nand_info[1]){
			printf("nand exist return 0\n");
			return 0;
		}
		else{
			printf("nand exist return 1\n");
			return 1;
		}
	}
#ifdef MX_REVD
	if (strcmp(cmd, "errstat") == 0){
	    printk("checking chiprev here\n");
        if(aml_chip->err_sts == NAND_CHIP_REVB_HY_ERR){
            printk("Must use RevD chip for Hynix 26nm/20nm nand boot without SPI!!!\n");
            return NAND_CHIP_REVB_HY_ERR;
        }
		return 0;
	}
#endif
#ifdef CONFIG_SECURE_NAND
		if (strcmp(cmd, "secure") == 0){
			aml_chip->secure_protect = 1;		//force nand key can be erased 
			return 0;
		}
#endif

	if (strcmp(cmd, "info") == 0) {
	#ifdef CONFIG_AML_NAND_KEY
		aml_chip->key_protect = 0;		//protect nand key can not be erased
	#endif
	#ifdef CONFIG_SECURE_NAND
		aml_chip->secure_protect = 0;		//protect nand secure can not be erased
	#endif

		putc('\n');
		for (i = 0; i < CONFIG_SYS_MAX_NAND_DEVICE; i++) {
			nand = nand_info[i];
			if (!nand) {
				nand_init();
				if (!nand)
					return -1;
			}
			if (nand->name)
				nand_print_info(i);
		}
		return 0;
	}
	if (strcmp(cmd, "init") == 0) {
		nand_init();
		return 0;
	}	
//cmd for nand test , if nand is ok , then trigger power off
	if (strcmp(cmd, "test") == 0) {
		int ret=-1;
		puts("\ntest the nand flash ***\n");
		for (i = 0; i < CONFIG_SYS_MAX_NAND_DEVICE; i++) {
			nand = nand_info[i];
			if (!nand) {
				ret=nand_test_init();
				printf("\n***nand_test_init()in NAND DEVICE %d returned:%d***\n ", i,ret);
				if (ret)
					return -1;	
			}
		}		
		return 0;
	}

	if (strcmp(cmd, "scrub_detect") == 0) {

		if (nand_curr_device < 0 || nand_curr_device >= (CONFIG_SYS_MAX_NAND_DEVICE+2)) {
			puts("\nno devices available\n");
			return 1;
		}
		nand = nand_info[nand_curr_device];

		aml_nand_stupid_dectect_badblock(nand);
		return 0;

	}

	if (strcmp(cmd, "device") == 0) {

		if (argc < 3) {
			putc('\n');
			if ((nand_curr_device < 0) ||
			    (nand_curr_device >= CONFIG_SYS_MAX_NAND_DEVICE))
				puts("no devices available\n");
			else
				nand_print_info(nand_curr_device);
			return 0;
		}
		dev = (int)simple_strtoul(argv[2], NULL, 10);
		if (dev < 0 || dev >= (CONFIG_SYS_MAX_NAND_DEVICE+1) || !nand_info[dev]->name) {
			puts("No such device\n");
			return 1;
		}
		printf("Device %d: %s", dev, nand_info[dev]->name);
		puts("... is now current device\n");
		nand_curr_device = dev;

#ifdef CONFIG_SYS_NAND_SELECT_DEVICE
		/*
		 * Select the chip in the board/cpu specific driver
		 */
		board_nand_select_device(nand_info[dev]->priv, dev);
#endif

		return 0;
	}

	if (strcmp(cmd, "bad") != 0 && strcmp(cmd, "erase") != 0 &&
	    strncmp(cmd, "dump", 4) != 0 &&
	    strncmp(cmd, "read", 4) != 0 && strncmp(cmd, "write", 5) != 0 &&
	    strcmp(cmd, "scrub") != 0 && strcmp(cmd, "markbad") != 0 &&
	    strcmp(cmd, "biterr") != 0 && strncmp(cmd, "rom_protect", 11) != 0 &&
	    strncmp(cmd, "wr_rd_cmp", 9) != 0 && strncmp(cmd, "rom_write", 9) != 0 && (strncmp(cmd, "rom_read", 8) != 0) &&
	    strcmp(cmd, "lock") != 0 && strcmp(cmd, "unlock") != 0 &&
	    strcmp(cmd, "factory_info") != 0 && strcmp(cmd, "show_para_page")&& strncmp(cmd, "scrub_safe", 10) != 0) //my_
	
			goto usage;

	/* the following commands operate on the current device */
	if (nand_curr_device < 0 || nand_curr_device >= (CONFIG_SYS_MAX_NAND_DEVICE+2)) {
		puts("\nno devices available\n");
		return 1;
	}

	nand = nand_info[nand_curr_device];
	if (!nand)
		return -1;

	if (strcmp(cmd, "bad") == 0) {
		printf("\nDevice %d bad blocks:\n", nand_curr_device);
		for (off = 0; off < nand->size; off += nand->erasesize)
			if (nand_block_isbad(nand, off))
				printf("  %09llx\n", off);
		return 0;
	}

	/*
	 * Syntax is:
	 *   0    1     2       3    4
	 *   nand erase [clean] [off size]
	 */
	if (strcmp(cmd, "erase") == 0 || strcmp(cmd, "scrub") == 0 || strcmp(cmd, "scrub_safe") == 0) { 
		nand_erase_options_t opts;
		int argc_cnt = 2;
        //printk("%s\n", argv[2]);
        /*
		if (isstring(argv[2])) {
			nand = get_mtd_device_nm(argv[2]);
			if (IS_ERR(nand)){
                printf("get nand device err\n");
				return 1;
			}
			argc_cnt++;
		}
		*/
		/* "clean" at index 2 means request to write cleanmarker */
		int clean = argc > argc_cnt && !strcmp("clean", argv[argc_cnt]);
		if (clean) 
			argc_cnt++;
		int o = argc_cnt;

		int scrub = !strncmp(cmd, "scrub",10);
		int scrub_safe =  !strncmp(cmd, "scrub_safe",10);
		
		if(scrub_safe)			
			printf("\nNAND %s: ", scrub_safe ? "scrub_safe" : "erase"); 
		else
			printf("\nNAND %s: ", scrub ? "scrub" : "erase");
		
		if (argv[argc_cnt])
		{
			if(!strcmp(argv[argc_cnt], "whole"))
			{
				off = 0;
				size = nand->size;
				printf("whole chip.\n");
			}
		}
		else
		{
			/* skip first two or three arguments, look for offset and size */
			if ((strcmp(cmd, "erase") == 0) && (argc < 3))
			{
				goto usage;
			}
                    if ((arg_off_size(argc - o, argv + o, nand, &off, &size) != 0))
                    {
                        return  1;
                    }
		}

		memset(&opts, 0, sizeof(opts));
		opts.offset = off;
		opts.length = size;
		opts.jffs2  = clean;
		opts.quiet  = quiet;

		if (scrub) {
			puts("Warning: "
			     "scrub option will erase all factory set "
			     "bad blocks!\n"
			     "         "
			     "There is no reliable way to recover them.\n"
			     "         "
			     "Use this command only for testing purposes "
			     "if you\n"
			     "         "
			     "are sure of what you are doing!\n"
			     "\nReally scrub this NAND flash? <y/N>\n");
			if(nand_protect)
			{
				if (getc() == 'y') {
					puts("y");
					if (getc() == '\r')
						opts.scrub = 1;
					else {
						puts("scrub aborted\n");
						return -1;
					}
				} else {
					puts("scrub aborted\n");
					return -1;
				}
			}
			else
			{
				opts.scrub = 1;
			}
		}
		else if(scrub_safe){
			puts("Warning: "
			     "scrub_safe option will erase all "
			     "bad blocks except factory bad blocks!\n");
			opts.scrub = 2; 	// indicate scrub_safe
		}
		ret = nand_erase_opts(nand, &opts);
		printf("%s\n", ret ? "ERROR" : "OK");
	#ifdef CONFIG_AML_NAND_KEY
		aml_chip->key_protect = 0;		//protect nand key can not be erased 
	#endif
	#ifdef CONFIG_SECURE_NAND
		aml_chip->secure_protect = 0;		//protect nand secure can not be erased 
	#endif

		return ret == 0 ? 0 : 1;
	}

	if (strncmp(cmd, "dump", 4) == 0) {
		if (argc < 3)
			goto usage;

		s = strchr(cmd, '.');
		//off = (loff_t)simple_strtoul(argv[2], NULL, 16);
		if (!(str2longlong(argv[2], (unsigned long long*)(&off))))
			return -1;

		if (s != NULL && strcmp(s, ".oob") == 0)
			ret = nand_dump(nand, off, 1);
		else
			ret = nand_dump(nand, off, 0);

		return ret == 0 ? 1 : 0;

	}

	if (strncmp(cmd, "read", 4) == 0 || strncmp(cmd, "write", 5) == 0) {
		int read;

		if (argc < 4)
			goto usage;

		if (isstring(argv[2])) {
			nand = get_mtd_device_nm(argv[2]);
			if (IS_ERR(nand))
				goto usage;
			addr = (ulong)simple_strtoul(argv[3], NULL, 16);
			read = strncmp(cmd, "read", 4) == 0; /* 1 = read, 0 = write */
			printf("\nNAND %s: %s ", read ? "read" : "write", argv[2]);
			if (argc == 4) {
				extern unsigned int get_mtd_size(char *name);
				off = 0;
				size = get_mtd_size(argv[2]);
			} else {
				if (arg_off_size(argc - 4, argv + 4, nand, &off, &size) != 0)
					return 1;
			}
		}
		else {
			addr = (ulong)simple_strtoul(argv[2], NULL, 16);
			read = strncmp(cmd, "read", 4) == 0; /* 1 = read, 0 = write */
			printf("\nNAND %s: ", read ? "read" : "write");
			if (arg_off_size(argc - 3, argv + 3, nand, &off, &size) != 0)
				return 1;
		}

#ifdef CONFIG_AMLROM_NANDBOOT
	if((read==0) && ((off)<(1024* nand->writesize)) && (nand_curr_device == 0)){
		printf("offset 0x%llx in aml-boot area ,abort\n", off);
		return -1;
	}	
#endif


		s = strchr(cmd, '.');
		if (!s || !strcmp(s, ".jffs2") ||
		    !strcmp(s, ".e") || !strcmp(s, ".i")) {
			if (read)
				ret = nand_read_skip_bad(nand, off, &size,
							 (u_char *)addr, 0);
			else
				ret = nand_write_skip_bad(nand, off, &size,
							  (u_char *)addr, 0);
		} else if (!strcmp(s, ".oob")) {
			/* out-of-band data */
			mtd_oob_ops_t ops = {
				.oobbuf = (u8 *)addr,
				.ooblen = size,
				.mode = MTD_OOB_RAW
			};

			if (read)
				ret = nand->read_oob(nand, off, &ops);
			else
				ret = nand->write_oob(nand, off, &ops);
		} else if (!strcmp(s, ".raw")) {
			if (read)
				ret = nand_read_skip_bad(nand, off, &size,
							 (u_char *)addr, 2);
			else
				ret = nand_write_skip_bad(nand, off, &size,
							  (u_char *)addr, 2);
		} else if (!strcmp(s, ".yaff1")) {
			if (read)
				ret = nand_read_skip_bad(nand, off, &size,
							 (u_char *)addr, 1);
			else
				ret = nand_write_skip_bad(nand, off, &size,
							  (u_char *)addr, 1);		
		} else {
			printf("Unknown nand command suffix '%s'.\n", s);
			return 1;
		}

		printf(" %llu bytes %s: %s\n", size,
		       read ? "read" : "written", ret ? "ERROR" : "OK");

		return ret == 0 ? 0 : 1;
	}

	if ( strncmp(cmd, "rom_protect", 9) == 0) {

		if (argc < 2)
			goto usage;

		if(strncmp(argv[2], "on", 2) == 0)
		{
			nand_protect = 1;
		}
		else	if(strncmp(argv[2], "off", 3) == 0)
		{
			nand_protect = 0;
		}
		else
		{
			goto usage;
		}
		return	0;
	}
	
	if (( strncmp(cmd, "rom_write", 9) == 0)||(strncmp(cmd, "rom_read", 8) == 0)) {
		int read=0;

		if(strncmp(cmd, "rom_read", 8) == 0)
			read = 1;
		if (argc < 4)
			goto usage;

		addr = (ulong)simple_strtoul(argv[2], NULL, 16);
		printf("\nNAND %s: ", read ? "rom_read" : "rom_write");
		nand_curr_device = 0;
		if (arg_off_size(argc - 3, argv + 3, nand, &off, &size) != 0)
			return 1;

		nand = nand_info[nand_curr_device];
		if (!nand)
			return 1;
		s = strchr(cmd, '.');
		if (!s ||!strcmp(s, ".e") || !strcmp(s, ".i")) {
			if (read){
				ret = romboot_nand_read(nand, off, &size,
							 (u_char *)addr);
			}
			else
				ret = romboot_nand_write(nand, off, (size_t * )&size,
							  (u_char *)addr, nand_protect);
		}else {
			printf("Unknown nand command suffix '%s'.\n", s);
			return 1;
		}

		printf(" %llu bytes %s: %s\n", (uint64_t)size,
		       read ? "read" : "written", ret ? "ERROR" : "OK");

		nand_curr_device = 1;
		return ret == 0 ? 0 : 1;
	}

	if ( strncmp(cmd, "wr_rd_cmp", 9) == 0) 
	{
		unsigned src,dst,i=0;
		if (argc < 6)
			goto usage;	

		src = (ulong)simple_strtoul(argv[2], NULL, 16);
		dst= (ulong)simple_strtoul(argv[3], NULL, 16);
		if (arg_off_size(argc - 4, argv + 4, nand, &off, &size) != 0)
			return 1;
		ret = nand_write_skip_bad(nand, off, &size,
				(u_char *)src, 0);
		if(ret)	
		{
			printf("write err\n");
			return 1;
		}

		ret = nand_read_skip_bad(nand, off, &size,
				(u_char *)dst, 0);

		if(ret)	
		{
			printf("read err\n");
			return 1;
		}

		for(i=0;i<size;i++)
		{
			if((*(u_char *)(src+i))!=(*(u_char *)(dst+i)))
			{
				printf("cmp err at byte  %d \n",i);
			}		
		}
		printf("cmp bytes %llu OK \n",size);
		return 0;
	}
	if (strcmp(cmd, "markbad") == 0) {
		argc -= 2;
		argv += 2;

		if (argc <= 0)
			goto usage;

		while (argc > 0) {
			addr = simple_strtoul(*argv, NULL, 16);

			if (nand->block_markbad(nand, addr)) {
				printf("block 0x%08lx NOT marked "
					"as bad! ERROR %d\n",
					addr, ret);
				ret = 1;
			} else {
				printf("block 0x%08lx successfully "
					"marked as bad\n",
					addr);
			}
			--argc;
			++argv;
		}
		return ret;
	}

	if (strcmp(cmd, "biterr") == 0) {
		/* todo */
		return 1;
	}

#ifdef CONFIG_CMD_NAND_LOCK_UNLOCK
	if (strcmp(cmd, "lock") == 0) {
		int tight = 0;
		int status = 0;
		if (argc == 3) {
			if (!strcmp("tight", argv[2]))
				tight = 1;
			if (!strcmp("status", argv[2]))
				status = 1;
		}
		if (status) {
			do_nand_status(nand);
		} else {
			if (!nand_lock(nand, tight)) {
				puts("NAND flash successfully locked\n");
			} else {
				puts("Error locking NAND flash\n");
				return 1;
			}
		}
		return 0;
	}

	if (strcmp(cmd, "unlock") == 0) {
		if (arg_off_size(argc - 2, argv + 2, nand, &off, &size) < 0)
			return 1;

		if (!nand_unlock(nand, off, size)) {
			puts("NAND flash successfully unlocked\n");
		} else {
			puts("Error unlocking NAND flash, "
			     "write and erase will probably fail\n");
			return 1;
		}
		return 0;
	}
#endif

    if(strcmp(cmd, "factory_info") == 0)
    {
        extern int nand_raw_read_nand_dev(nand_info_t *nand, loff_t offset, loff_t *length,
		       u_char *buffer, unsigned all,unsigned autodetect);
        unsigned b_offset, b_count, b_all=1;
        if (argc < 4)
			goto usage;

        addr = (ulong)simple_strtoul(argv[2], NULL, 16);
        b_offset = simple_strtoul(argv[3], NULL, 16);
        b_count = simple_strtoul(argv[4], NULL, 16);
        if(argc>4)
        {
            b_all = simple_strtoul(argv[5], NULL, 16);
        }
        b_all = b_all? 1: 0;
        
        ret = nand_raw_read_nand_dev(nand,b_offset,&b_count,(u_char *)addr ,b_all,1);
        return ret == 0 ? 0 : 1;
    }
#ifdef CONFIG_PARAMETER_PAGE
	if(strcmp(cmd, "show_para_page") == 0)
	{
		extern void display_para_page(struct parameter_page para_page,unsigned long log_level);
		extern struct parameter_page para_page;
		
		if((argc == 3) && (strcmp(argv[2], "1") == 0))
		{
			display_para_page(para_page, 1);
		}
		else
		{
			display_para_page(para_page, 0);
		}
		return 0;
	}
#endif
usage:
	cmd_usage(cmdtp);
	return 1;
}

U_BOOT_CMD(nand, CONFIG_SYS_MAXARGS, 1, do_nand,
	"NAND sub-system",
	"info - show available NAND devices\n"
	"test - test available NAND devices\n"
	"nand device [dev] - show or set current device\n"
	"nand read - addr off|partition size\n"
	"nand write - addr off|partition size\n"
	"    read/write 'size' bytes starting at offset 'off'\n"
	"    to/from memory address 'addr', skipping bad blocks.\n"
	"nand erase [clean|whole] [off size] - erase 'size' bytes from\n"
	"    offset 'off' (entire device if not specified)\n"
	"nand bad - show bad blocks\n"
	"nand scrub_safe - clean NAND erasing bad blocks except factory bad blocks\n"	
	"       -just do it (SAFE)!!\n"
	"nand dump[.oob] off - dump page\n"
	"nand scrub_detect - detect bad blk again\n"
	"nand scrub - really clean NAND erasing bad blocks (UNSAFE)\n"
	"nand markbad off [...] - mark bad block(s) at offset (UNSAFE)\n"
	"nand biterr off - make a bit error at offset (UNSAFE)"
#ifdef CONFIG_CMD_NAND_LOCK_UNLOCK
	"\n"
	"nand lock [tight] [status]\n"
	"    bring nand to lock state or display locked pages\n"
	"nand unlock [offset] [size] - unlock section"
#endif
	"\n"	
	"nand  rom_protect  on/off \n"
	"nand  wr_rd_cmp  src dst  off|partition size \n"
	"nand  rom_write  addr off|partition size\n"
	"nand  factory_info addr block_offset block_count part|all\n"
#ifdef CONFIG_PARAMETER_PAGE
	"nand  show_para_page 0|1\n"
#endif
	"nand  errstat \n"
	"nand init\n"
);

static int nand_load_image(cmd_tbl_t *cmdtp, nand_info_t *nand,
			   ulong offset, ulong addr, char *cmd)
{
	int r;
	char *ep, *s;
	loff_t cnt;
	image_header_t *hdr;
#if defined(CONFIG_FIT)
	const void *fit_hdr = NULL;
#endif

	s = strchr(cmd, '.');
	if (s != NULL &&
	    (strcmp(s, ".jffs2") && strcmp(s, ".e") && strcmp(s, ".i"))) {
		printf("Unknown nand load suffix '%s'\n", s);
		show_boot_progress(-53);
		return 1;
	}

	printf("\nLoading from %s, offset 0x%lx\n", nand->name, offset);

	cnt = nand->writesize;
	r = nand_read_skip_bad(nand, offset, &cnt, (u_char *) addr, 0);
	if (r) {
		puts("** Read error\n");
		show_boot_progress (-56);
		return 1;
	}
	show_boot_progress (56);

	switch (genimg_get_format ((void *)addr)) {
	case IMAGE_FORMAT_LEGACY:
		hdr = (image_header_t *)addr;

		show_boot_progress (57);
		image_print_contents (hdr);

		cnt = image_get_image_size (hdr);
		break;
#if defined(CONFIG_FIT)
	case IMAGE_FORMAT_FIT:
		fit_hdr = (const void *)addr;
		puts ("Fit image detected...\n");

		cnt = fit_get_size (fit_hdr);
		break;
#endif
	default:
		show_boot_progress (-57);
		puts ("** Unknown image type\n");
		return 1;
	}
	show_boot_progress (57);

	r = nand_read_skip_bad(nand, offset, &cnt, (u_char *) addr, 0);
	if (r) {
		puts("** Read error\n");
		show_boot_progress (-58);
		return 1;
	}
	show_boot_progress (58);

#if defined(CONFIG_FIT)
	/* This cannot be done earlier, we need complete FIT image in RAM first */
	if (genimg_get_format ((void *)addr) == IMAGE_FORMAT_FIT) {
		if (!fit_check_format (fit_hdr)) {
			show_boot_progress (-150);
			puts ("** Bad FIT image format\n");
			return 1;
		}
		show_boot_progress (151);
		fit_print_contents (fit_hdr);
	}
#endif

	/* Loading ok, update default load address */

	load_addr = addr;

#ifdef CONFIG_AML_SECU_BOOT_V2
	extern int g_nIMGReadFlag;
	g_nIMGReadFlag = 0;
#endif //#ifdef CONFIG_AML_SECU_BOOT_V2

	/* Check if we should attempt an auto-start */
	if (((ep = getenv("autostart")) != NULL) && (strcmp(ep, "yes") == 0)) {
		char *local_args[2];
		//extern int do_bootm(cmd_tbl_t *, int, int, char *[]);

		local_args[0] = cmd;
		local_args[1] = NULL;

		printf("Automatic boot of image at addr 0x%08lx ...\n", addr);
		do_bootm(cmdtp, 0, 1, local_args);
		return 1;
	}
	return 0;
}

int do_nandboot(cmd_tbl_t * cmdtp, int flag, int argc, char *argv[])
{
	char *boot_device = NULL;
	int idx;
	ulong addr, offset = 0;
#if defined(CONFIG_CMD_MTDPARTS)
	struct mtd_device *dev;
	struct part_info *part;
	u8 pnum;

	if (argc >= 2) {
		char *p = (argc == 2) ? argv[1] : argv[2];
		if (!(str2long(p, &addr)) && (mtdparts_init() == 0) &&
		    (find_dev_and_part(p, &dev, &pnum, &part) == 0)) {
			if (dev->id->type != MTD_DEV_TYPE_NAND) {
				puts("Not a NAND device\n");
				return 1;
			}
			if (argc > 3)
				goto usage;
			if (argc == 3)
				addr = simple_strtoul(argv[1], NULL, 16);
			else
				addr = CONFIG_SYS_LOAD_ADDR;
			return nand_load_image(cmdtp, nand_info[dev->id->num],
					       part->offset, addr, argv[0]);
		}
	}
#endif

	show_boot_progress(52);
	switch (argc) {
	case 1:
		addr = CONFIG_SYS_LOAD_ADDR;
		boot_device = getenv("bootdevice");
		break;
	case 2:
		addr = simple_strtoul(argv[1], NULL, 16);
		boot_device = getenv("bootdevice");
		break;
	case 3:
		addr = simple_strtoul(argv[1], NULL, 16);
		boot_device = argv[2];
		break;
	case 4:
		addr = simple_strtoul(argv[1], NULL, 16);
		boot_device = argv[2];
		offset = simple_strtoul(argv[3], NULL, 16);
		break;
	default:
#if defined(CONFIG_CMD_MTDPARTS)
usage:
#endif
		cmd_usage(cmdtp);
		show_boot_progress(-53);
		return 1;
	}

	show_boot_progress(53);
	if (!boot_device) {
		puts("\n** No boot device **\n");
		show_boot_progress(-54);
		return 1;
	}
	show_boot_progress(54);

	idx = simple_strtoul(boot_device, NULL, 16);

	if (idx < 0 || idx >= CONFIG_SYS_MAX_NAND_DEVICE || !nand_info[idx]->name) {
		printf("\n** Device %d not available\n", idx);
		show_boot_progress(-55);
		return 1;
	}
	show_boot_progress(55);

	return nand_load_image(cmdtp, nand_info[idx], offset, addr, argv[0]);
}

U_BOOT_CMD(nboot, 4, 1, do_nandboot,
	"boot from NAND device",
	"[partition] | [[[loadAddr] dev] offset]"
);
