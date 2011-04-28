#ifndef _DEVFONT_H_
#define _DEVFONT_H_

#define OSD_COLOR2	2
#define OSD_COLOR4	4
#define OSD_COLOR8	8
#define OSD_COLOR16	16
#define OSD_COLOR24	24

typedef struct 
{
	unsigned int x;
	unsigned int y;
	unsigned int width;
	unsigned int height;
}RECT;

typedef struct {
	// character value
        unsigned short		character;
        // this character's font width
        unsigned short		width;
        // character's font bits map
        unsigned short 		offset;
}FONTINDEX;

typedef struct {
	///font name
	const char *font_name;
	///font size 
	unsigned short		font_size;
	///the characters max width in pixel of this font lib
	unsigned short		max_width;
	///define the character height in pixel
	unsigned short		font_height;
	///ascent (baseline) height
	unsigned short		font_ascent;
	///gaps between characters of this font
	unsigned char		font_gaps ;
	///total character number in this font lib
	unsigned short		characternum; 
	///Call back function of font lib, we will get the font data by call this function.
	unsigned char *		(*GetFontBitmap)(unsigned short ch, unsigned short *font_width) ; 
}FONT, *PFONT;

extern int DrawPixel(unsigned short x, unsigned short y, int color);
extern int DrawRect(unsigned short x, unsigned short y, unsigned short w, unsigned short h, int color);
extern int DrawFont(int x, int y, int font_width, int font_height, int font_color, unsigned char *font_data);
                      
extern int GetTextSize(const void *str, unsigned short cc, int *pwidth, int *pheight, int *word_length);
extern void DrawText(const void *str, unsigned short cc, unsigned short x, unsigned short y, int *pwidth, int *pheight, int font_color);
              
extern void AsciiPrintf(const char * print_strings, unsigned short x, unsigned short y, int font_color);
extern void SetFont(char *font_name);
extern int RegisterFont(PFONT new_font);
extern int UnregisterFont(PFONT del_font);
extern unsigned short GetCharWidth(char ch);

#endif
