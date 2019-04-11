#include <command.h>
#include <common.h>
#include "LD_usbbt.h"

extern int fwGetFileSize(const char *file_path);
extern int fwReadFileToBuffer(const char *file_path, unsigned char data_buf[]);

int vfs_mount(char *volume)
{
	return 0;
}

/* Amlogic need to implement. */
unsigned long vfs_getsize(char *filedir)
{
	int fileSize = 0;
	fileSize = fwGetFileSize(filedir);
	if (fileSize > 0)
	{
		printf("vfs_getsize %s size is %d\n", filedir, fileSize);
		return fileSize;
	}

	printf("vfs_getsize %s failed\n", filedir);
	return 0;
}

/* Amlogic need to implement. */
int vfs_read(void *addr, char *filedir, unsigned int offset, unsigned int size)
{
	int ret = -1;
	ret = fwReadFileToBuffer(filedir, addr);
	if (ret > 0)
	{
		printf("vfs_read load %s to buffer success\n", filedir);
		return 0;
	}
	printf("vfs_read load %s failed\n", filedir);
	return -1;
}
