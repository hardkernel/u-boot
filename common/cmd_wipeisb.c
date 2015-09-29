#include <common.h>
#include <amlogic/storage_if.h>

#ifndef PAGE_SIZE
#define PAGE_SIZE 4096
#endif

unsigned char w_buf[PAGE_SIZE];
extern int has_instaboot_part(void);
static int do_wipeisb(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	int rc = 0;
	u64 partSz = 0;

	if (!has_instaboot_part())
		return 0;
	rc = store_get_partititon_size((unsigned char*)"instaboot", &partSz);
	if (rc || !partSz) {
	    printf("can not get instaboot part size\n");
	    return -1;
	}

	memset(w_buf, 0, PAGE_SIZE);
	rc = store_write_ops((unsigned char*)"instaboot",
		w_buf, 0, PAGE_SIZE);
	if (rc) {
	    printf("wipe instaboot header error\n");
	    return -1;
	}
	return 0;
}

U_BOOT_CMD(
   wipeisb,         //command name
   1,               //maxargs
   0,               //repeatable
   do_wipeisb,   //command function
   "wipeisb",
   "wipe the insaboot image header"
);

