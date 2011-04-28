#include <config.h>
#include <common.h>
#include <asm/arch/io.h>
#include <command.h>
#include <malloc.h>
#include <amlogic/gpio.h>
extern int gpio_debug;
int do_gpio(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	int pin,val;
	int i;
	for(i=0;i<argc;i++)
		printf("%s\n",argv[i]);
	printf("argc=%d\n",argc);
	if(!strcmp(argv[1],"debug")){
		gpio_debug=simple_strtoul(argv[2], NULL, 16);;
		return 0;
	}
	pin=gpioname_to_pin(argv[1]);
	if(pin<0){
		printf("wrong gpio number %s\n",argv[1]);
		goto out;
	}
	if(argc<3||argc>5)
		goto out;
	printf("pin=%d\n",pin);
	
	if(!strcmp(argv[2],"out"))
	{
		if(!strcmp(argv[3],"high"))
		{
			amlogic_gpio_direction_output(pin,1);
			if(argv[4]){
				if(!strcmp(argv[4],"pp"))
					amlogic_set_pull_up(pin,1,1);
				else if (!strcmp(argv[4],"pd"))
					amlogic_set_pull_up(pin,0,1);
				else if (!strcmp(argv[3],"hz"))
					amlogic_set_highz(pin);
				else
					goto out;
			}
		}
		else if(!strcmp(argv[3],"low"))
		{
			amlogic_gpio_direction_output(pin,0);
			if(argv[4]){
				if(!strcmp(argv[4],"pp"))
					amlogic_set_pull_up(pin,1,1);
				else if (!strcmp(argv[4],"pd"))
					amlogic_set_pull_up(pin,0,1);
				else if (!strcmp(argv[3],"hz"))
					amlogic_set_highz(pin);
				else
					goto out;
			}
		}
		else
			goto out;
	}
	else if(!strcmp(argv[2],"in"))
	{
		amlogic_gpio_direction_input(pin);
		if(argv[3]){
			if(!strcmp(argv[3],"pp"))
				amlogic_set_pull_up(pin,1,1);
			else if (!strcmp(argv[3],"pd"))
				amlogic_set_pull_up(pin,0,1);
			else if (!strcmp(argv[3],"hz"))
				amlogic_set_highz(pin);
			else
				goto out;
		}
		udelay(100);
		val=amlogic_get_value(pin);
		printf("get %s val=%d,%s\n",argv[1],val,val==1? "high":"low");
	}
	else if(!strcmp(argv[2],"get"))
	{
		val=amlogic_get_value(pin);
		printf("get %s val=%d,%s\n",argv[1],val,val==1? "high":"low");
	}
	else
		goto out;
	return 0;
out:
		printf ("Unknown operation\n");
		return cmd_usage(cmdtp);
}

U_BOOT_CMD(
	gset,	5,	1,	do_gpio,
	"gpio commands",
	"GPIONAME out high/low [pp/pd/hz]\n"
	"gset GPIONAME in [pp/pd/hz]\n"
	"gset GPIONAME get\n"
	"gset debug 1/0-- open debug\n"
);

/****************************************************/

