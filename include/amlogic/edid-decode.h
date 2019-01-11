#ifndef EDID_DECODE_H
#define EDID_DECODE_H

#undef DEBUG_EDID
#ifdef  DEBUG_EDID
# define DEBUGF(fmt, args...)	printf(fmt ,##args)
#else
# define DEBUGF(fmt, args...)
#endif

#define DEBUG_DUMPEDID

#define EDID_ERR_RETRY		1
#define EDID_ERR_NO_VALID_EDID	2

extern int parse_edid(unsigned char *edid, unsigned int blk_len, unsigned char count);
extern char *select_best_resolution(void);

#endif

