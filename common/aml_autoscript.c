#include <common.h>
#include <command.h>

int aml_autoscript(void)
{
	int	i = 0;
	char	str[128];
#ifdef SCAN_MMC_PARTITION
	if(run_command ("mmcinfo", 0))
	{
		printf("##aml_autoscript---ERROR: SD card not find!!!\n");
	}
	else
	{
		for(i = 0; i < SCAN_MMC_PARTITION; i++)
		{
			sprintf(str, "fatexist mmc 0:%d %s", (i + 1), AML_AUTOSCRIPT);
			if(!run_command (str, 0))
			{
				sprintf(str, "fatload mmc 0:%d ${loadaddr} %s", (i + 1), AML_AUTOSCRIPT);
				run_command (str, 0);
				run_command ("source ${loadaddr}", 0);
				return	0;
			}
		}
	}
#endif
#ifdef SCAN_USB_PARTITION
	if(!run_command ("usb start", 0))
	{
		printf("##aml_autoscript---ERROR: USB device not find!!!\n");
	}
	else
	{
		for(i = 0; i < SCAN_USB_PARTITION; i++)
		{
			sprintf(str, "fatexist usb 0:%d %s", (i + 1), AML_AUTOSCRIPT);
			if(!run_command (str, 0))
			{
				sprintf(str, "fatload usb 0:%d ${loadaddr} %s", (i + 1), AML_AUTOSCRIPT);
				run_command (str, 0);
				run_command ("source ${loadaddr}", 0);
				return	0;
			}
		}
	}
#endif
	return -1;
}
