#ifndef PANEL_TYPICAL_TIMING_H
#define PANEL_TYPICAL_TIMING_H
#include <amlogic/lcdoutc.h>

//*****************************************
// Define LCD Typical Timing Parameters
//*****************************************
#define MODEL_NAME            "B140XTN02" /** lcd model name */

#define ACITVE_AREA_WIDTH     309 /** lcd active_area or display_area horizontal size(unit in mm, you can find it on the home page of lcd spec) */
#define ACITVE_AREA_HEIGHT    173 /** lcd active_area or display_area vertical size(unit in mm, you can find it on the home page of lcd spec) */
#define LCD_TYPE              LCD_DIGITAL_EDP /** lcd interface(LCD_DIGITAL_MIPI, LCD_DIGITAL_LVDS, LCD_DIGITAL_EDP, LCD_DIGITAL_TTL) */
#define LCD_BITS              6 /** lcd bits(6, 8) */
#define BITS_OPTION           0 /** bits_option(0=only support one mode as LCD_BITS define, 1=both support 6/8bit) */

#define H_ACTIVE              1366 /** horizontal resolution */
#define V_ACTIVE              768 /** vertical resolution */
#define H_PERIOD              1598 /** horizontal period(htotal) */
#define V_PERIOD              798 /** vertical period(vtotal) */

#define	LCD_CLK               76300000 /** clock(unit in Hz, both support clk and frame_rate, >200 regard as clk, <200 regard as frame_rate) */
#define CLK_POL               0 /** clk_polarity(only valid for TTL) */
#define HS_WIDTH              5 /** hsync_width */
#define HS_BACK_PORCH         120 /** hsync_backporch(include hsync_width) */
#define HS_POL                1 /** hsync_polarity(0=negative, 1=positive) */
#define VS_WIDTH              1 /** vsync_width */
#define VS_BACK_PORCH         22 /** vsync_backporch(include vsync_width) */
#define VS_POL                1 /** vsync_polarity(0=negative, 1=positive) */
#define VSYNC_H_ADJUST_SIGN   0 /** 0=positive,1=negative */
#define VSYNC_H_ADJUST        0  /** vertical_hbegin_adjust */
//************************************************
// EDP config
//************************************************
#define LCD_EDP_CONFIG
#define MAX_LANE_COUNT        1

#endif