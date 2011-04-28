#include <common.h>
#include <linux/ctype.h>
#include <malloc.h>
#include <linux/types.h>
#include <linux/err.h>
#include <linux/rand_ext.h>


int do_random_gen(cmd_tbl_t * cmdtp, int flag, int argc, char *argv[])
{
	unsigned int seed,len,addr;
	const char *cmd;
	if (argc < 3)
		goto usage;
	cmd = argv[1];
	if((strcmp(cmd,"gen")) && (strcmp(cmd,"read"))){
		goto usage;
	}
	if(!strcmp(cmd,"gen")){
		seed = simple_strtoul(argv[2], NULL, 16);
		len = simple_strtoul(argv[3], NULL, 16);
		if(argc >=5){
			addr = simple_strtoul(argv[4], NULL, 16);
		}
		else{
			addr = 0x82000000;
		}
		//seed += get_ticks();
		if(len == 0){
			len = 1;
		}
		if(random_generate(seed,(unsigned char *)addr,len) < 0){
			printf("%s:%d,random generate fail\n",__func__,__LINE__);
			return 1;
		}
	}
	if(!strcmp(cmd,"read")){
		printf("not support \n");
	}
	return 0;
usage:
	cmd_usage(cmdtp);
	return 1;
}


U_BOOT_CMD(randomb, CONFIG_SYS_MAXARGS, 1, do_random_gen,
	"randomb sub-system",
	"gen seed len [addr] - generate random according of seed, seed:uint type,input,len : generate data len(byte unit)\n"
	"randomb  read len [addr] - read random\n"
);
