#ifndef __INSTABOOT_H_
#define __INSTABOOT_H_

#define __NEW_UTS_LEN 64

struct new_utsname {
	char sysname[__NEW_UTS_LEN + 1];
	char nodename[__NEW_UTS_LEN + 1];
	char release[__NEW_UTS_LEN + 1];
	char version[__NEW_UTS_LEN + 1];
	char machine[__NEW_UTS_LEN + 1];
	char domainname[__NEW_UTS_LEN + 1];
};

struct instaboot_info {
	struct new_utsname uts;
	unsigned int version_code;
};
#define INSTABOOT_SIG	"INSTABOOT"

extern int get_instaboot_header(struct instaboot_info* ib_info);
extern int fdt_instaboot(void *fdt);

#endif /* __INSTABOOT_H_ */
