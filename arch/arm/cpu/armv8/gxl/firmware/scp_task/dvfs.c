#include "config.h"
#include "registers.h"
#include "task_apis.h"

#include "dvfs.h"
#include <dvfs_board.c>

void get_dvfs_info(unsigned int domain,
		unsigned char *info_out, unsigned int *size_out)
{
	get_dvfs_info_board(domain, info_out, size_out);
	return;
}
