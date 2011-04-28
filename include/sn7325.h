#ifndef _SN7325_H_
#define _SN7325_H_

/**
 * struct sn7325_platform_data - platform-specific SN7325 data
 * @pwr_rst:          power reset
 */
struct sn7325_platform_data {
       int (*pwr_rst)(void);
};

#define OD0     (1 << 0)
#define OD1     (1 << 1)
#define OD2     (1 << 2)
#define OD3     (1 << 3)
#define OD4     (1 << 4)
#define OD5     (1 << 5)
#define OD6     (1 << 6)
#define OD7     (1 << 7)
#define PP0     (1 << 8)
#define PP1     (1 << 9)
#define PP2     (1 << 10)
#define PP3     (1 << 11)
#define PP4     (1 << 12)
#define PP5     (1 << 13)
#define PP6     (1 << 14)
#define PP7     (1 << 15)

#endif