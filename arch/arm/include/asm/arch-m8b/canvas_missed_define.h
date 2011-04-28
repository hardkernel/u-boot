//#define DC_CAV_CTRL               0x1300

//#define DC_CAV_LVL3_GRANT         0x1304
//#define DC_CAV_LVL3_GH            0x1308
  // this is a 32 bit grant regsiter.
  // each bit grant a thread ID for LVL3 use.

//#define DC_CAV_LVL3_FLIP          0x130c
//#define DC_CAV_LVL3_FH            0x1310
  // this is a 32 bit FLIP regsiter.
  // each bit to define  a thread ID for LVL3 use.

//#define DC_CAV_LVL3_CTRL0         0x1314
//#define DC_CAV_LVL3_CTRL1         0x1318
//#define DC_CAV_LVL3_CTRL2         0x131c
//#define DC_CAV_LVL3_CTRL3         0x1320
//#define DC_CAV_LUT_DATAL          0x1324
    #define CANVAS_ADDR_LMASK       0x1fffffff
    #define CANVAS_WIDTH_LMASK		0x7
    #define CANVAS_WIDTH_LWID		3
    #define CANVAS_WIDTH_LBIT		29
//#define DC_CAV_LUT_DATAH          0x1328
	#define CANVAS_WIDTH_HMASK		0x1ff
	#define CANVAS_WIDTH_HBIT		0
	#define CANVAS_HEIGHT_MASK		0x1fff
	#define CANVAS_HEIGHT_BIT		9
	#define CANVAS_YWRAP			(1<<23)
	#define CANVAS_XWRAP			(1<<22)
    #define CANVAS_ADDR_NOWRAP      0x00
    #define CANVAS_ADDR_WRAPX       0x01
    #define CANVAS_ADDR_WRAPY       0x02
    #define CANVAS_BLKMODE_MASK     3
    #define CANVAS_BLKMODE_BIT      24
    #define CANVAS_BLKMODE_LINEAR   0x00
    #define CANVAS_BLKMODE_32X32    0x01
    #define CANVAS_BLKMODE_64X32    0x02
//#define DC_CAV_LUT_ADDR           0x132c
    #define CANVAS_LUT_INDEX_BIT    0
    #define CANVAS_LUT_INDEX_MASK   0x7
    #define CANVAS_LUT_WR_EN        (0x2 << 8)
    #define CANVAS_LUT_RD_EN        (0x1 << 8)
//#define DC_CAV_LVL3_MODE          0x1330
