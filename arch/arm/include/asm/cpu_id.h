/*cpu id*/

/*cpu short id stored inside chip, all m8x=0x19*/
#define MESON_CPU_ID_IN_REG_A3		0x13
#define MESON_CPU_ID_IN_REG_CS2		0x14
#define MESON_CPU_ID_IN_REG_M3		0x15
#define MESON_CPU_ID_IN_REG_M6		0x16
#define MESON_CPU_ID_IN_REG_M6TV	0x17
#define MESON_CPU_ID_IN_REG_M6TVL	0x18
#define MESON_CPU_ID_IN_REG_M8		0x19
#define MESON_CPU_ID_IN_REG_M6TVD	0x1a
#define MESON_CPU_ID_IN_REG_M8BABY	0x1b
#define MESON_CPU_ID_IN_REG_G9TV	0x1c

/*cpu long id stored inside chip, only for m8x*/
#define MESON_CPU_ID_IN_REG_M8_REVA		0x11111111
#define MESON_CPU_ID_IN_REG_M8_REVB		0x11111113
#define MESON_CPU_ID_IN_REG_M8_REVC		0x11111133
#define MESON_CPU_ID_IN_REG_M8M2_REVA	0x11111112

#define MESON_CPU_ID_REG_ADDR		0xc1107d4c /*short id address, all m8x=0x19*/
#define MESON8X_CPU_ID_REG_ADDR		0xc11081a8 /*long id address, only for m8x*/

/*chip id type define, return 1 or 0*/
#define IS_MESON_M8_CPU				((MESON_CPU_ID_IN_REG_M8_REVA == readl(MESON8X_CPU_ID_REG_ADDR)) || \
									(MESON_CPU_ID_IN_REG_M8_REVB == readl(MESON8X_CPU_ID_REG_ADDR)) || \
									(MESON_CPU_ID_IN_REG_M8_REVC == readl(MESON8X_CPU_ID_REG_ADDR)))
#define IS_MESON_M8BABY_CPU			((MESON_CPU_ID_IN_REG_M8BABY == readl(MESON_CPU_ID_REG_ADDR)))
#define IS_MESON_M8M2_CPU			((MESON_CPU_ID_IN_REG_M8M2_REVA == readl(MESON8X_CPU_ID_REG_ADDR)))