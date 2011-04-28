#ifndef PANEL_TYPICAL_TIMING_H
#define PANEL_TYPICAL_TIMING_H
#include <amlogic/lcdoutc.h>

//*****************************************
// Define LCD Typical Timing Parameters
// TTL bridge to LVDS
//*****************************************
#define MODEL_NAME			"HM185WX3"

#define ACITVE_AREA_WIDTH	410	/** lcd active_area or display_area horizontal size(unit in mm, you can find it on the home page of lcd spec) */
#define ACITVE_AREA_HEIGHT	230	/** lcd active_area or display_area vertical size(unit in mm, you can find it on the home page of lcd spec) */
#define LCD_TYPE			LCD_DIGITAL_TTL   /** lcd interface(LCD_DIGITAL_MIPI, LCD_DIGITAL_LVDS, LCD_DIGITAL_EDP, LCD_DIGITAL_TTL) */
#define LCD_BITS			8	/** lcd bits(6, 8) */
#define BITS_OPTION			1	/** bits_option(0=only support one mode as LCD_BITS define, 1=both support 6/8bit) */

#define H_ACTIVE			1368	/** horizontal resolution */
#define V_ACTIVE			768		/** vertical resolution */
#define H_PERIOD			1560	/** horizontal period(htotal) */
#define V_PERIOD			806		/** vertical period(vtotal) */

#define	LCD_CLK				78000000	/** clock(unit in Hz, both support clk and frame_rate, >200 regard as clk, <200 regard as frame_rate) */
#define CLK_POL				1	/** clk_polarity(only valid for TTL) */
#define HS_WIDTH			10	/** hsync_width */
#define HS_BACK_PORCH		70	/** hsync_backporch(include hsync_width) */
#define HS_POL				0	/** hsync_polarity(0=negative, 1=positive) */
#define VS_WIDTH			2	/** vsync_width */
#define VS_BACK_PORCH		20	/** vsync_backporch(include vsync_width) */
#define VS_POL				0	/** vsync_polarity(0=negative, 1=positive) */
#define VSYNC_H_ADJUST_SIGN 0  /** 0=positive,1=negative */
#define VSYNC_H_ADJUST  0  /** vertical_hbegin_adjust */
//************************************************

#endif