
/*
 * drivers/usb/gadget/aml_tiny_usbtool/burn_func.c
 *
 * Copyright (C) 2015 Amlogic, Inc. All rights reserved.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 * more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
*/

#include <common.h>
#include "usb_pcd.h"
#include <common.h>

#include <nand.h>
#include <div64.h>
#include <jffs2/jffs2.h>
//#include <asm/arch/nand.h>
#include <linux/types.h>
#include <linux/err.h>
#include <linux/ctype.h>
#include <command.h>
#include <watchdog.h>
#include <malloc.h>
#include <linux/mtd/mtd.h>
#include <asm/byteorder.h>
//#include <amlogic/efuse.h>
#include <linux/string.h>
#include <usb.h>


//#define HDCP_PRINT
#define SECUKEY_BYTES          512
#define AML_KEY_NAMELEN    16
#define HDCP_KEY_LEN            288
#define HDCP2LC128_LEN        36
#define HDCP2KEY_LEN            862
#define HDCP2_KEY_TOTAL_LEN (HDCP2LC128_LEN+HDCP2KEY_LEN)
#define HDCP2LC128_NAME     "hdcp2lc128"
#define HDCP2KEY_NAME         "hdcp2key"
// pctool version >= 1.6.32,return 3 status when read
#define PCTOOL_VERSION_1632 (unsigned long)1632

static unsigned long sPctoolVersion = 0;

#ifdef WRITE_TO_EFUSE_ENABLE
#define WRITE_EFUSE         0
#define READ_EFUSE           1
#define EFUSE_VERSION_MESON3        "01:02:03"
#define EFUSE_VERSION_MESON6        "02"
#define EFUSE_READ_TEST_ENABLE      1
#ifdef CONFIG_AML_MESON3
extern int do_efuse_usb(int argc, char * const argv[], char *buf);
#elif defined(CONFIG_AML_MESON6)
extern int cmd_efuse(int argc, char * const argv[], char *buf);
#endif
#endif

extern int usb_get_update_result(void);

#if defined(WRITE_TO_NAND_EMMC_ENABLE) || defined(WRITE_TO_NAND_ENABLE)
static int sInitedSecukey = 0;
extern int uboot_key_initial(char *device);
extern ssize_t uboot_get_keylist(char *keyname);
extern ssize_t uboot_key_read(char *keyname, char *keydata);
extern ssize_t uboot_key_write(char *keyname, char *keydata);
int ensure_secukey_init(void);
int cmd_secukey(int argc, char *argv[], char *buf);
#endif


#if defined(CONFIG_SECURE_STORAGE_BURNED)
#include <amlogic/secure_storage.h>
static int sInitedSecurestore = 0;
extern int securestore_key_init( char *seed,int len);
extern int securestore_key_query(char *keyname, unsigned int *query_return);
extern int securestore_key_read(char *keyname,char *keybuf,unsigned int keylen,unsigned int *reallen);
extern int securestore_key_write(char *keyname, char *keybuf,unsigned int keylen,int keytype);
extern int securestore_key_uninit(void);
int ensure_securestore_key_init(char *seed, int seed_len);
int cmd_securestore(int argc, char *argv[], char *buf);
#endif

void hdcpDataEncryption(const int len, const char *input, char *out);
void hdcpDataDecryption(const int len, const char *input, char *out);

extern void _mdelay(unsigned long ms);
extern void _udelay(unsigned int us);


/* hdcp key verify code */
#define DWORD unsigned int  //4 bytes
#define BYTE unsigned char   //1 byte
#define SHA1_MAC_LEN 20

typedef struct {
        DWORD state[5];
        DWORD count[2];
        BYTE buffer[64];
} SHA1_CTX;

void SHA1Reset(SHA1_CTX *context);
void SHA1Input(SHA1_CTX *context, BYTE *data, DWORD len);
void SHA1Result(SHA1_CTX *context, BYTE *digest);//20
void SHA1Transform_H(DWORD *state, BYTE *buffer); //5  64

#define rol(value, bits) (((value) << (bits)) | ((value) >> (32 - (bits))))

/* blk0() and blk() perform the initial expand. */
/* I got the idea of expanding during the round function from SSLeay */

#define blk0(i) (workspace[i] = (rol(block->l[i], 24) & 0xFF00FF00) | \
        (rol(block->l[i], 8) & 0x00FF00FF))
#define blk(i) (workspace[i & 15] = rol(block->l[(i + 13) & 15] ^ \
        block->l[(i + 8) & 15] ^ block->l[(i + 2) & 15] ^ block->l[i & 15], 1))

/* (R0+R1), R2, R3, R4 are the different operations used in SHA1 */
#define R0(v,w,x,y,z,i) \
        z += (((w & (x ^ y)) ^ y) + blk0(i) + 0x5A827999 + rol(v, 5)); \
        w = rol(w, 30);
#define R1(v,w,x,y,z,i) \
        z += (((w & (x ^ y)) ^ y) + blk(i) + 0x5A827999 + rol(v, 5)); \
        w = rol(w, 30);
#define R2(v,w,x,y,z,i) \
        z += ((w ^ x ^ y) + blk(i) + 0x6ED9EBA1 + rol(v, 5)); w = rol(w, 30);
#define R3(v,w,x,y,z,i) \
        z += ((((w | x) & y) | (w & x)) + blk(i) + 0x8F1BBCDC + rol(v, 5)); \
        w = rol(w, 30);
#define R4(v,w,x,y,z,i) \
        z += ((w ^ x ^ y) + blk(i) + 0xCA62C1D6 + rol(v, 5)); \
        w=rol(w, 30);

/*********************************************************************/
static int parse_line (char *line, char *argv[])
{
	int nargs = 0;

#ifdef DEBUG_PARSER
	printf ("parse_line: \"%s\"\n", line);
#endif
	while (nargs < CONFIG_SYS_MAXARGS) {

		/* skip any white space */
		while ((*line == ' ') || (*line == '\t')) {
			++line;
		}

		if (*line == '\0') {	/* end of line, no more args	*/
			argv[nargs] = NULL;
#ifdef DEBUG_PARSER
		printf ("parse_line: nargs=%d\n", nargs);
#endif
			return (nargs);
		}

		argv[nargs++] = line;	/* begin of argument string	*/

		/* find end of string */
		while (*line && (*line != ' ') && (*line != '\t')) {
			++line;
		}

		if (*line == '\0') {	/* end of line, no more args	*/
			argv[nargs] = NULL;
#ifdef DEBUG_PARSER
		printf ("parse_line: nargs=%d\n", nargs);
#endif
			return (nargs);
		}

		*line++ = '\0';		/* terminate current arg	 */
	}

	printf ("** Too many args (max. %d) **\n", CONFIG_SYS_MAXARGS);

#ifdef DEBUG_PARSER
	printf ("parse_line: nargs=%d\n", nargs);
#endif
	return (nargs);
}

/* Hash a single 512-bit block. This is the core of the algorithm. */
void SHA1Transform_H(DWORD *state, BYTE *buffer)
{
        DWORD a, b, c, d, e;
        typedef union {
                BYTE c[64];
                DWORD l[16];
        } CHAR64LONG16;
        CHAR64LONG16 *block;

        DWORD workspace[16];
        block = (CHAR64LONG16 *)workspace;
        memcpy(block, buffer, 64);

        /* Copy context->state[] to working vars */
        a = state[0];
        b = state[1];
        c = state[2];
        d = state[3];
        e = state[4];
        /* 4 rounds of 20 operations each. Loop unrolled. */
        R0(a,b,c,d,e, 0); R0(e,a,b,c,d, 1); R0(d,e,a,b,c, 2); R0(c,d,e,a,b, 3);_udelay(100);
        R0(b,c,d,e,a, 4); R0(a,b,c,d,e, 5); R0(e,a,b,c,d, 6); R0(d,e,a,b,c, 7);_udelay(100);
        R0(c,d,e,a,b, 8); R0(b,c,d,e,a, 9); R0(a,b,c,d,e,10); R0(e,a,b,c,d,11);_udelay(100);
        R0(d,e,a,b,c,12); R0(c,d,e,a,b,13); R0(b,c,d,e,a,14); R0(a,b,c,d,e,15);_udelay(100);
        R1(e,a,b,c,d,16); R1(d,e,a,b,c,17); R1(c,d,e,a,b,18); R1(b,c,d,e,a,19);_udelay(100);
        R2(a,b,c,d,e,20); R2(e,a,b,c,d,21); R2(d,e,a,b,c,22); R2(c,d,e,a,b,23);_udelay(100);
        R2(b,c,d,e,a,24); R2(a,b,c,d,e,25); R2(e,a,b,c,d,26); R2(d,e,a,b,c,27);_udelay(100);
        R2(c,d,e,a,b,28); R2(b,c,d,e,a,29); R2(a,b,c,d,e,30); R2(e,a,b,c,d,31);_udelay(100);
        R2(d,e,a,b,c,32); R2(c,d,e,a,b,33); R2(b,c,d,e,a,34); R2(a,b,c,d,e,35);_udelay(100);
        R2(e,a,b,c,d,36); R2(d,e,a,b,c,37); R2(c,d,e,a,b,38); R2(b,c,d,e,a,39);_udelay(100);
        R3(a,b,c,d,e,40); R3(e,a,b,c,d,41); R3(d,e,a,b,c,42); R3(c,d,e,a,b,43);_udelay(100);
        R3(b,c,d,e,a,44); R3(a,b,c,d,e,45); R3(e,a,b,c,d,46); R3(d,e,a,b,c,47);_udelay(100);
        R3(c,d,e,a,b,48); R3(b,c,d,e,a,49); R3(a,b,c,d,e,50); R3(e,a,b,c,d,51);_udelay(100);
        R3(d,e,a,b,c,52); R3(c,d,e,a,b,53); R3(b,c,d,e,a,54); R3(a,b,c,d,e,55);_udelay(100);
        R3(e,a,b,c,d,56); R3(d,e,a,b,c,57); R3(c,d,e,a,b,58); R3(b,c,d,e,a,59);_udelay(100);
        R4(a,b,c,d,e,60); R4(e,a,b,c,d,61); R4(d,e,a,b,c,62); R4(c,d,e,a,b,63);_udelay(100);
        R4(b,c,d,e,a,64); R4(a,b,c,d,e,65); R4(e,a,b,c,d,66); R4(d,e,a,b,c,67);_udelay(100);
        R4(c,d,e,a,b,68); R4(b,c,d,e,a,69); R4(a,b,c,d,e,70); R4(e,a,b,c,d,71);_udelay(100);
        R4(d,e,a,b,c,72); R4(c,d,e,a,b,73); R4(b,c,d,e,a,74); R4(a,b,c,d,e,75);_udelay(100);
        R4(e,a,b,c,d,76); R4(d,e,a,b,c,77); R4(c,d,e,a,b,78); R4(b,c,d,e,a,79);_udelay(100);
        /* Add the working vars back into context.state[] */
        state[0] += a;
        state[1] += b;
        state[2] += c;
        state[3] += d;
        state[4] += e;
        /* Wipe variables */
        a = b = c = d = e = 0;

        memset(block, 0, 64);
}


/* SHA1Reset - Initialize new context */

void SHA1Reset(SHA1_CTX *context)
{
        /* SHA1 initialization constants */
        context->state[0] = 0x67452301;
        context->state[1] = 0xEFCDAB89;
        context->state[2] = 0x98BADCFE;
        context->state[3] = 0x10325476;
        context->state[4] = 0xC3D2E1F0;
        context->count[0] = context->count[1] = 0;
}


/* Run your data through this. */

void SHA1Input(SHA1_CTX* context, BYTE *_data, DWORD len)
{
        DWORD i, j;
        BYTE *data = _data;

        j = (context->count[0] >> 3) & 63;
        if ((context->count[0] += len << 3) < (len << 3))
                context->count[1]++;
        context->count[1] += (len >> 29);
        if ((j + len) > 63) {
                memcpy(&context->buffer[j], data, (i = 64-j));
                SHA1Transform_H(context->state, context->buffer);
                for ( ; i + 63 < len; i += 64) {
                        SHA1Transform_H(context->state, &data[i]);
                }
                j = 0;
        }
        else i = 0;
        memcpy(&context->buffer[j], &data[i], len - i);

}


/* Add padding and return the message digest. */

void SHA1Result(SHA1_CTX *context, BYTE *digest)
{
        DWORD i;
        BYTE finalcount[8];

        for (i = 0; i < 8; i++) {
                finalcount[i] = (BYTE)
                        ((context->count[(i >= 4 ? 0 : 1)] >>
                          ((3-(i & 3)) * 8) ) & 255);  /* Endian independent */
        }
        SHA1Input(context, (BYTE *) "\200", 1);
        while ((context->count[0] & 504) != 448) {
                SHA1Input(context, (BYTE *) "\0", 1);
        }
        SHA1Input(context, finalcount, 8);  /* Should cause a SHA1Transform_H()
                                              */
        for (i = 0; i < 20; i++) {
                digest[i] = (BYTE)
                        ((context->state[i >> 2] >> ((3 - (i & 3)) * 8)) &
                         255);
        }
        /* Wipe variables */
        i = 0;
        memset(context->buffer, 0, 64);
        memset(context->state, 0, 20);
        memset(context->count, 0, 8);
        memset(finalcount, 0, 8);
}
 /**************************************************************************
 * NOTES:       Test Vectors (from FIPS PUB 180-1) to verify implementation
 *              1- Input : "abc"
 *              Output : A9993E36 4706816A BA3E2571 7850C26C 9CD0D89D
 *              2- Input : "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq"
 *              Output : 84983E44 1C3BD26E BAAE4AA1 F95129E5 E54670F1
 *              2- Input : A million repetitions of 'a' - not applied (memory shortage)
 *              Output : 34AA973C D4C4DAA4 F61EEB2B DBAD2731 6534016F
 *              More test vectors can be obtained from FIPS web site
 ***************************************************************************/
void SHA1_Perform(BYTE *indata, DWORD inlen, BYTE *outdata) //calculate SHA-1 API
{
    SHA1_CTX sha;
    SHA1Reset(&sha);
    SHA1Input(&sha, indata, inlen);
    SHA1Result(&sha, outdata);
}

typedef struct
{
    unsigned char ksv[5];
    unsigned char rsv[3];
    unsigned char dpk[280];
    unsigned char sha[20];
}hdcp_llc_file;


#if defined(WRITE_TO_EFUSE_ENABLE)
static int _cmd_efuse(int argc, char * const argv[], char *buf)
{
    int i, action = -1;
    efuseinfo_item_t info;
    char *title;
    char *s;
    char *end;

    if (!strncmp(argv[1], "read", 4))
        action = READ_EFUSE;
    else if(!strncmp(argv[1], "write", 5))
        action = WRITE_EFUSE;
    else {
        printf("%s arg error\n", argv[1]);
        return -1;
    }

    //efuse read
    if (action == READ_EFUSE) {
        title = argv[2];
        if (efuse_getinfo(title, &info) < 0)
            return -1;

        memset(buf, 0, EFUSE_BYTES);
        efuse_read_usr(buf, info.data_len, (loff_t *)&info.offset);
        printf("info.data_len=%d\n", info.data_len);
        printf("%s is:\n", title);
        for (i=0; i<(info.data_len); i++)
            printf("%02x:", buf[i]);
        printf("\n");
    }

    //efuse write
    else if(action == WRITE_EFUSE) {
        if (argc < 4) {
            printf("arg count error\n");
            return -1;
        }
        title = argv[2];
        if (efuse_getinfo(title, &info) < 0)
            return -1;
        if (!(info.we)) {
            printf("%s write unsupport now. \n", title);
            return -1;
        }

        memset(buf, 0, info.data_len);
        s = argv[3];

        //for usb burn key to efuse
        if (!strncmp(title, "usid", strlen("usid")))	        //burn usid data(format:"xxxx...", it's string)
            memcpy(buf, s, strlen(s));
        else if(!strncmp(title, "hdcp", strlen("hdcp"))) //burn hdcp data(format:xx xx, it's data)
            memcpy(buf, s, HDCP_KEY_LEN);
        else {                          //burn version, mac, mac_bt, mac_wifi, customerid(format:"xx:xx:xx...", it's string)
            for (i=0; i<info.data_len; i++) {
                buf[i] = s ? simple_strtoul(s, &end, 16) : 0;
                if (s)
                    s = (*end) ? end+1 : end;
            }
            if (*s) {
                printf("error: The wriiten data length is too large.\n");
                return -1;
            }
        }

        if (efuse_write_usr(buf, info.data_len, (loff_t*)&info.offset) < 0) {
            printf("error: efuse write fail.\n");
            return -1;
        }
        else
            printf("%s written done.\n", info.title);
    }
    else {
        printf("arg error\n");
        return -1;
    }

    return 0;
}
static int run_efuse_cmd(int argc, char *argv[], char *buff)
{
   int ret = -1;

#ifdef CONFIG_AML_MESON3
   ret = do_efuse_usb(argc, argv, buff);
#elif defined(CONFIG_AML_MESON6)
   //ret = cmd_efuse(argc, argv, buff);
   ret = _cmd_efuse(argc, argv, buff);
#endif

   return ret;
}

#if defined(EFUSE_READ_TEST_ENABLE)
static int test_efuse_read(int argc, char *argv[], char *cmpBuff)
{
   int i = 0, j = 0, ret = -1;
   int hdcp_flag = 0, hdcp_key_len = 288;
   char *hdcp = NULL;
   char efuse_data[SECUKEY_BYTES], reBuff[SECUKEY_BYTES], tmpBuf[SECUKEY_BYTES];

   printf("-----Test efuse read commond:\n");
   for (i=0; i<argc; i++)
      printf("argv[%d]=%s\n", i, argv[i]);

   if (!strncmp(argv[0], "efuse", 5) && !strncmp(argv[1], "read", 4) &&
      (!strncmp(argv[2], "version", 7) ||!strncmp(argv[2], "mac_wifi", 8) ||
      !strncmp(argv[2], "mac_bt", 6) ||!strncmp(argv[2], "mac", 3) ||
      !strncmp(argv[2], "usid", 4) ||!strncmp(argv[2], "hdcp", 4))) {
      goto run;
   }
   else {
      printf("test efuse read commond not mach\n");
      return -3;
   }

run:
   memset(efuse_data, 0, sizeof(efuse_data));
   memset(reBuff, 0, sizeof(reBuff));
   memset(tmpBuf, 0, sizeof(tmpBuf));

   ret = run_efuse_cmd(argc, argv, reBuff);
   if (!ret) {
      // test efuse read version
      if (!strncmp(argv[1], "read", strlen("read")) && !strncmp(argv[2], "version", strlen("version"))) {
#ifdef CONFIG_AML_MESON3
         sprintf(efuse_data, "%02x:%02x:%02x", reBuff[0], reBuff[1], reBuff[2]);
#elif defined(CONFIG_AML_MESON6)
         sprintf(efuse_data, "%02x", reBuff[0]);
#endif
         if (!strncmp(efuse_data, cmpBuff, strlen(cmpBuff))) {
            printf("test efuse read version success,read version=%s\n", efuse_data);
            return 0;
         }
         else {
            printf("test efuse read version success,read version=%s, but not mach %s\n", efuse_data, cmpBuff);
            return -1;
         }
      }
      // test efuse read mac/mac_bt/mac_wifi
      else if(!strncmp(argv[1], "read", strlen("read")) && (!strncmp(argv[2], "mac", strlen("mac")) ||
         !strncmp(argv[2], "mac_bt", strlen("mac_bt")) ||!strncmp(argv[2], "mac_wifi", strlen("mac_wifi")))) {
         sprintf(efuse_data, "%02x:%02x:%02x:%02x:%02x:%02x", reBuff[0], reBuff[1], reBuff[2], reBuff[3], reBuff[4], reBuff[5]);
         if (!strncmp(efuse_data, cmpBuff, strlen(cmpBuff))) {
            printf("test efuse read %s success,read %s=%s\n", argv[2], argv[2], efuse_data);
            return 0;
         }
         else {
            printf("test efuse read %s success,read %s=%s, but not mach %s\n", argv[2], argv[2], efuse_data, cmpBuff);
            return -1;
         }
      }
      // test efuse read usid
      else if(!strncmp(argv[1], "read", strlen("read")) && !strncmp(argv[2], "usid", strlen("usid"))) {
         for (i=0; i<strlen(cmpBuff); i++) {
            sprintf(tmpBuf, "%c", reBuff[i]);
            sprintf(&efuse_data[j], "%s", tmpBuf);
            j += strlen(tmpBuf);
            memset(tmpBuf, 0, sizeof(tmpBuf));
         }
         if (!strncmp(efuse_data, cmpBuff, strlen(cmpBuff))) {
            printf("test efuse read usid success,read usid=%s\n", efuse_data);
            return 0;
         }
         else {
            printf("test efuse read usid success,read usid=%s, but not mach %s\n", efuse_data, cmpBuff);
            return -1;
         }
      }
      // test efuse read hdcp
      else if(!strncmp(argv[1], "read", strlen("read")) && !strncmp(argv[2], "hdcp", strlen("hdcp"))) {
         hdcp = cmpBuff;
         for (i=0; i<hdcp_key_len; i++) {
            if (reBuff[i] != *hdcp ++) {
               hdcp_flag = 1;
               break;
            }
         }
         if (!hdcp_flag) {
            printf("test efuse read hdcp success\n");
            printf("read hdcp is:\n");
            for (i=0; i<hdcp_key_len; i++)
               printf("%02x:", reBuff[i]);
            printf("\n");
            return 0;
         }
         else {
            printf("test efuse read hdcp success,but not mach\n");
            return -1;
         }
      }
   }
   else {
      printf("test efuse read %s fail\n", argv[2]);
      return -2;
   }

   return ret;
}
#endif    /* EFUSE_READ_TEST_ENABLE */
#endif    /* WRITE_TO_EFUSE_ENABLE  */


int burn_board(const char *dev, void *mem_addr, u64 offset, u64 size)
{
	char	str[128];
	printf("burn_board!!!\n");
	printf("CMD: dev=%s, mem_addr=0x%llx, offset=0x%llx, size=0x%llx\n", dev, (unsigned long long)mem_addr, offset, size);
	if (!strncmp("nand", (const char *)(unsigned long long)(*dev), 4))
	{
		sprintf(str, "nand erase 0x%llx 0x%llx}", offset, size);
		printf("command:    %s\n", str);
		run_command(str, 0);
		sprintf(str, "nand write 0x%llx 0x%llx 0x%llx}", (unsigned long long)mem_addr, offset, size);
		printf("command:    %s\n", str);
		run_command(str, 0);
	}
	else if(!strncmp("spi", (const char *)(unsigned long long)(*dev), 3))
	{
		run_command("sf probe 2", 0);
		sprintf(str, "sf erase 0x%llx 0x%llx}", offset, size);
		printf("command:    %s\n", str);
		run_command(str, 0);
		sprintf(str, "sf write 0x%llx 0x%llx 0x%llx}", (unsigned long long)mem_addr, offset, size);
		printf("command:    %s\n", str);
		run_command(str, 0);
	}
	else if(!strncmp("emmc", (const char *)(unsigned long long)(*dev), 4))
	{
		sprintf(str, "mmc write 1 0x%llx 0x%llx 0x%llx}", (unsigned long long)mem_addr, offset, size);
		printf("command:    %s\n", str);
		run_command(str, 0);
	}
	else
	{
		printf("Invalid Argument!\n");
		return -1;
	}
	return 0;
}

static int usb_bootm(const void *addr)
{
	char cmd[128];
	memset(cmd, 0, sizeof(cmd));
	sprintf(cmd, "bootm %llx", (unsigned long long)addr);
	return run_command(cmd, 0);
}

u32 checkcum_32(const unsigned char *buf, u32 len)
{
	u32 fake_len, chksum = 0;
	u32 *ptr = (u32 *)buf;
	int i;
	printf("buf=0x%08llx, len=0x%x\n", (unsigned long long)buf, len);
	if (len%4)
	{
		fake_len = len - len%4 + 4;
		memset((void *)(buf+len), 0, (fake_len-len));
	}
	else
	{
		fake_len = len;
	}
	printf("fake_len=0x%x\n", fake_len);
	for (i=0; i<fake_len; i+=4, ptr++)
	{
		chksum += *ptr;
	}
	return chksum;
}


int usb_run_command (const char *cmd, char* buff)
{
	int ret = -1, flag = 0;
	u64 addr = 0, length = 0;
	u32 crc_value, crc_verify = 0;
	int argc;
	char *argv[CONFIG_SYS_MAXARGS + 1];	/* NULL terminated	*/
	printf("\n\n---Tool cmd: %s\n", cmd);

	memset(buff, 0, CMD_BUFF_SIZE);
	if (strncmp(cmd,"get update result",(sizeof("get update result")-1)) == 0) {
		ret = usb_get_update_result();
		if (!ret)
		{
			strcpy(buff, "success");
		}
		else
		{
			strcpy(buff, "fail");
		}
		return ret;
	}
	else if(strncmp(cmd,"usb_bootm",(sizeof("usb_bootm")-1)) == 0){
		addr = *((u32*)(&cmd[60]));
		strcpy(buff, "okay");
		usb_bootm((const void *)addr);
		strcpy(buff, "fail");
		return -1;
	}
	else if(strncmp(cmd,"crc",(sizeof("crc")-1)) == 0){
		if ((argc = parse_line ((char *)cmd, argv)) == 0) {
			return -1;	/* no command at all */
		}
		addr = simple_strtoul (argv[1], NULL, 16);
		length = simple_strtoul (argv[2], NULL, 10);
		crc_verify = simple_strtoul (argv[3], NULL, 16);
		//crc_value = crc32 (0, (const uchar *) addr, length);
		crc_value = checkcum_32((const unsigned char *)addr, length);
		printf("crc_value=0x%x\n", crc_value);
		if (crc_verify == crc_value)
		{
			strcpy(buff, "success");
		}
		else
		{
			strcpy(buff, "failed");
		}
	}
	else if(strncmp(cmd,"cmd_in_mem",(sizeof("cmd_in_mem")-1)) == 0){
		char *cmd_in_mem = NULL;
		/* Extract arguments */
		if ((argc = parse_line ((char *)cmd, argv)) == 0) {
			return -1;	/* no command at all */
		}
		cmd_in_mem = (char *)simple_strtoul(argv[1], NULL, 0);
		printf("cmd_in_mem: %s\n", cmd_in_mem);
		if (run_command(cmd_in_mem, flag))
		{
			strcpy(buff, "fail");
			return -1;
		}
		else
		{
			strcpy(buff, "okay");
		}
	}
/*
  *    pctool version >= 1.6.32,teturn 3 status in read
  *    "pctool version:"
  *
  *	burn keys to efuse/nand/emmc common command:
  *	"efuse read version"
  *	"efuse write version"
  *	"efuse read mac"
  *	"efuse write mac xx:xx:xx:xx:xx:xx"
  *	"efuse read bt_mac"
  *	"efuse write bt_mac xx:xx:xx:xx:xx:xx"
  *	"efuse read wifi_mac"
  *	"efuse write wifi_mac xx:xx:xx:xx:xx:xx"
  *	"efuse read usid"
  *	"efuse write usid xxxxx..."
  *	"read hdcp"
  *	"write hdcp:"   (hdcp key datas form 0x82000000 address)
  *	"read hdcp2"
  *	"write hdcp2:" (hdcp2 key datas form 0x82000000 address)
  *
  *	or: burn keys to efuse/nand private command:
  *	"secukey_efuse/secukey_nand read version"
  *	"secukey_efuse/secukey_nand write version"
  *	"secukey_efuse/secukey_nand read mac"
  *	"secukey_efuse/secukey_nand write mac xx:xx:xx:xx:xx:xx"
  *	"secukey_efuse/secukey_nand read bt_mac"
  *	"secukey_efuse/secukey_nand write bt_mac xx:xx:xx:xx:xx:xx"
  *	"secukey_efuse/secukey_nand read wifi_mac"
  *	"secukey_efuse/secukey_nand write wifi_mac xx:xx:xx:xx:xx:xx"
  *	"secukey_efuse/secukey_nand read usid"
  *	"secukey_efuse/secukey_nand write usid xxxxx..."
  *	"secukey_efuse/secukey_nand read hdcp"
  *	"secukey_efuse/secukey_nand write hdcp:" (hdcp key datas form 0x82000000 address)
  *	"secukey_nand read boardid"
  *	"secukey_nand write boardid:"    (boardid key datas form 0x82000000 address)
  *	"secukey_nand read serialno"
  *	"secukey_nand write serialno:"    (serialno key datas form 0x82000000 address)
  *	"secukey_nand read MFG_Serialno"
  *	"secukey_nand write MFG_Serialno:"    (MFG_Serialno key datas form 0x82000000 address)
  *
  *    // for key to securestorage
  *	"efuse write random"   (random datas form 0x82000000 address)
  *	"efuse read widevinekeybox"
  *	"efuse write widevinekeybox"     (widevinekeybox datas form 0x82000000 address)
  *	"efuse read PlayReadykeybox"
  *	"efuse write PlayReadykeybox"   (PlayReadykeybox datas form 0x82000000 address)
  *	"efuse read MobiDRMPrivate"
  *	"efuse write MobiDRMPrivate"     (MobiDRMPrivate datas form 0x82000000 address)
  *	"efuse read MobiDRMPublic"
  *	"efuse write MobiDRMPublic"       (MobiDRMPublic datas form 0x82000000 address)
  *
  **/
      else if(!strncmp(cmd, "pctool version:", strlen("pctool version:")) ||!strncmp(cmd, "efuse", strlen("efuse")) ||
            !strncmp(cmd, "read hdcp2", strlen("read hdcp2")) ||!strncmp(cmd, "write hdcp2:", strlen("write hdcp2:")) ||
            !strncmp(cmd, "read hdcp", strlen("read hdcp")) ||!strncmp(cmd, "write hdcp:", strlen("write hdcp:")) ||
            !strncmp(cmd, "secukey_efuse", strlen("secukey_efuse")) ||!strncmp(cmd, "secukey_nand", strlen("secukey_nand"))) {
            int i = 0, key_device_index = -1, random_len = 0;
            char widevinekeybox_verify_data_receive[20], widevinekeybox_verify_data_calculate[20];
            char PlayReadykeybox_verify_data_receive[20], PlayReadykeybox_verify_data_calculate[20];
            char MobiDRMPrivate_verify_data_receive[20], MobiDRMPrivate_verify_data_calculate[20];
            char MobiDRMPublic_verify_data_receive[20], MobiDRMPublic_verify_data_calculate[20];
            char key_data[SECUKEY_BYTES], hdcp_verify_data_receive[20], hdcp_verify_data_calculate[20];
            char hdcp2lc128[HDCP2LC128_LEN], hdcp2key[HDCP2KEY_LEN], hdcp2TotalData[HDCP2_KEY_TOTAL_LEN];
            char hdcp2_verify_data_receive[20], hdcp2_verify_data_calculate[20];
            char *random = NULL;

            enum {
                RANDOM_MAX_LEN = 32,
                WIDEVINEKEYBOX_MAX_LEN  = 128,
                PLAYREADYKEYBOX_MAX_LEN  = 16*1024, // max:16k
                MOBIDRMPRIVATE_MAX_LEN = 1200,
                MOBIDRMPUBLIC_MAX_LEN = 300,
            };

            //added to remover warnning

            if (!strncmp(cmd, "pctool version:", strlen("pctool version:"))) {
                sPctoolVersion = simple_strtoul((char *)(cmd+strlen("pctool version:")), 0, 10);
                sprintf(buff, "success:(sPctoolVersion:%d)", (int)sPctoolVersion);
                printf("%s\n", buff);
                return 0;
            }

            /* Extract arguments */
            if (!strncmp(cmd, "read hdcp2", 10) || !strncmp(cmd, "write hdcp2:", 12)) {
                char cmd_hdcp2[50] = {0};
                strncpy(cmd_hdcp2, cmd, strlen(cmd));
                sprintf((char *)cmd, "%s %s", "flash", cmd_hdcp2);  // add parameter for hdcp2 command
                printf("Actual cmd:%s\n", cmd);
            }
            else if(!strncmp(cmd, "read hdcp", 9) || !strncmp(cmd, "write hdcp:", 11)) {
                char cmd_hdcp[50] = {0};
                strncpy(cmd_hdcp, cmd, strlen(cmd));
                sprintf((char *)cmd, "%s %s", "efuse", cmd_hdcp);  // add parameter for hdcp command
                printf("Actual cmd:%s\n", cmd);
            }

            if ((argc = parse_line ((char *)cmd, argv)) == 0) {
               return -1;	/* no command at all */
            }

            memset(key_data, 0, sizeof(key_data));
            memset(hdcp_verify_data_receive, 0, sizeof(hdcp_verify_data_receive));
            memset(hdcp_verify_data_calculate, 0, sizeof(hdcp_verify_data_calculate));
            memset(hdcp2lc128, 0, sizeof(hdcp2lc128));
            memset(hdcp2key, 0, sizeof(hdcp2key));
            memset(hdcp2TotalData, 0, sizeof(hdcp2TotalData));
            memset(hdcp2_verify_data_receive, 0, sizeof(hdcp2_verify_data_receive));
            memset(hdcp2_verify_data_calculate, 0, sizeof(hdcp2_verify_data_calculate));
            memset(widevinekeybox_verify_data_receive, 0, sizeof(widevinekeybox_verify_data_receive));
            memset(widevinekeybox_verify_data_calculate, 0, sizeof(widevinekeybox_verify_data_calculate));
            memset(PlayReadykeybox_verify_data_receive, 0, sizeof(PlayReadykeybox_verify_data_receive));
            memset(PlayReadykeybox_verify_data_calculate, 0, sizeof(PlayReadykeybox_verify_data_calculate));
            memset(MobiDRMPrivate_verify_data_receive, 0, sizeof(MobiDRMPrivate_verify_data_receive));
            memset(MobiDRMPrivate_verify_data_calculate, 0, sizeof(MobiDRMPrivate_verify_data_calculate));
            memset(MobiDRMPublic_verify_data_receive, 0, sizeof(MobiDRMPublic_verify_data_receive));
            memset(MobiDRMPublic_verify_data_calculate, 0, sizeof(MobiDRMPublic_verify_data_calculate));


#if defined(WRITE_TO_NAND_EMMC_ENABLE) || defined(WRITE_TO_NAND_ENABLE) || defined(WRITE_TO_EFUSE_ENABLE)
            char* hdcp = NULL;
#endif

/* Burn key to efuse */
/* ---Command process */
#ifdef  WRITE_TO_EFUSE_ENABLE
            if (strncmp(argv[0], "efuse", strlen("efuse")) && strncmp(argv[0], "secukey_efuse", strlen("secukey_efuse"))) {
               sprintf(buff, "%s", "failed:(code compiled burn to efuse,but cmd not mach with pc send)");
               printf("%s\n", buff);
               return -1;
            }
            printf("burn key to efuse. convert command...\n");
            if (!strncmp(argv[0], "secukey_efuse", strlen("secukey_efuse")))
               argv[0] = "efuse";

            if (!strncmp(argv[1], "write", strlen("write")) && !strncmp(argv[2], "version", strlen("version"))) {
               argc ++;
#ifdef CONFIG_AML_MESON3
               argv[3] = EFUSE_VERSION_MESON3;
               printf("CONFIG_AML_MESON3 VERSION(version:%s)\n",argv[3]);
#elif defined(CONFIG_AML_MESON6)
               argv[3] = EFUSE_VERSION_MESON6;
               printf("CONFIG_AML_MESON6 VERSION(version:%s)\n",argv[3]);
#endif
            }

            if (!strncmp(argv[2], "bt_mac", strlen("bt_mac")))
               strncpy(argv[2], "mac_bt", strlen("mac_bt"));

            if (!strncmp(argv[2], "wifi_mac", strlen("wifi_mac")))
               strncpy(argv[2], "mac_wifi", strlen("mac_wifi"));

            if (!strncmp(argv[1], "write", strlen("write")) && !strncmp(argv[2], "hdcp:", strlen("hdcp:"))) {
#define HDCP_DATA_ADDR	(volatile unsigned long *)(0x82000000)	//get hdcp data from address:0x82000000
               hdcp = (char *)HDCP_DATA_ADDR;
               printf("receive %d hdcp key datas from address:0x82000000:\n", HDCP_KEY_LEN);
               for (i=0; i<HDCP_KEY_LEN; i++) {                                            //read 288 hdcp datas
                  key_data[i] = *hdcp++;
                  printf("%.2x:", key_data[i]);
               }
               printf("\nreceive 20 hdcp key verify datas:\n");
               for (i=0; i<20; i++) {											     //read 20 hdcp verify datas
                  hdcp_verify_data_receive[i] = *hdcp++;
                  printf("%.2x:", hdcp_verify_data_receive[i]);
               }
               printf("\n");

               printf("start to verify %d hdcp key datas...\n", HDCP_KEY_LEN);
               SHA1_Perform(key_data, HDCP_KEY_LEN, hdcp_verify_data_calculate);
               printf("verify & get 20 hdcp verify datas:\n");
               for (i=0; i<20; i++)
                    printf("%.2x:", hdcp_verify_data_calculate[i]);
               printf("\n");

               int ret = memcmp(hdcp_verify_data_receive, hdcp_verify_data_calculate, 20);
               if (ret == 0) {
                    printf("hdcp datas verify success\n");
                    argv[0] = "efuse";
                    argv[1] = "write";
                    argv[2] = "hdcp";
                    argv[3] = key_data;
                    argc = 4;
               }
               else {
                    sprintf(buff, "%s", "failed:(hdcp datas verify failed)");
                    printf("%s\n", buff);
                    return -1;
               }
            }
#endif   /* WRITE_TO_EFUSE_ENABLE */


#if defined(WRITE_TO_NAND_EMMC_ENABLE) || defined(WRITE_TO_NAND_ENABLE)
             char* hdcp2 = NULL;
#endif

/* Burn key to nand/emmc */
/* ---Command process */
#if defined(WRITE_TO_NAND_EMMC_ENABLE) || defined(WRITE_TO_NAND_ENABLE)
            if (strncmp(argv[0], "efuse", strlen("efuse")) && strncmp(argv[0], "secukey_nand", strlen("secukey_nand")) &&
                strncmp(argv[0], "flash", strlen("flash"))) {
               sprintf(buff, "%s", "failed:(code compiled burn to flash,but cmd not mach with pc send)");
               printf("%s\n", buff);
               return -1;
            }

            printf("burn key to flash. convert command...\n");
            if (!strncmp(argv[0], "efuse", strlen("efuse"))||!strncmp(argv[0], "secukey_nand", strlen("secukey_nand")))
               argv[0] = "flash";

            if (!strncmp(argv[2], "bt_mac", strlen("bt_mac")))
               strncpy(argv[2], "mac_bt", strlen("mac_bt"));

            if (!strncmp(argv[2], "wifi_mac", strlen("wifi_mac")))
               strncpy(argv[2], "mac_wifi", strlen("mac_wifi"));

            if (!strncmp(argv[1], "write", strlen("write")) && !strncmp(argv[2], "hdcp2:", strlen("hdcp2:"))) {
#define HDCP2_DATA_ADDR	(volatile unsigned long *)(0x82000000)
               hdcp2 = (char *)HDCP2_DATA_ADDR;
               printf("receive %d %s datas from address:0x82000000:\n", HDCP2LC128_LEN, HDCP2LC128_NAME);
               memcpy((char *)hdcp2lc128, (char *)hdcp2, HDCP2LC128_LEN);
#ifdef HDCP_PRINT
               for (i=0; i<HDCP2LC128_LEN; i++) {
                  printf("%.2x:", hdcp2lc128[i]);
               }
               printf("\n");
#else
               printf("receive %d %s datas ok !!!\n", HDCP2LC128_LEN, HDCP2LC128_NAME);
#endif

               printf("receive %d %s datas from address:0x82000024:\n", HDCP2KEY_LEN, HDCP2KEY_NAME);
               memcpy((char *)hdcp2key, (char *)(hdcp2+HDCP2LC128_LEN), HDCP2KEY_LEN);
#ifdef HDCP_PRINT
               for (i=0; i<HDCP2KEY_LEN; i++) {
                  printf("%.2x:", hdcp2key[i]);
               }
               printf("\n");
#else
               printf("receive %d %s datas ok !!!\n", HDCP2KEY_LEN, HDCP2KEY_NAME);
#endif

               printf("receive 20 hdcp2(%s & %s) verify datas:\n", HDCP2LC128_NAME, HDCP2KEY_NAME);
               memcpy((char *)hdcp2_verify_data_receive, (char *)(hdcp2+HDCP2_KEY_TOTAL_LEN), 20);
               for (i=0; i<20; i++) {
                  printf("%.2x:", hdcp2_verify_data_receive[i]);
               }

               printf("\nstart to verify %d hdcp2(%s & %s) datas...\n", HDCP2_KEY_TOTAL_LEN, HDCP2LC128_NAME, HDCP2KEY_NAME);
               memcpy((char *)hdcp2TotalData, (char *)hdcp2lc128, HDCP2LC128_LEN);
               memcpy((char *)(hdcp2TotalData+HDCP2LC128_LEN), (char *)hdcp2key, HDCP2KEY_LEN);
               SHA1_Perform((unsigned char *)hdcp2TotalData, HDCP2_KEY_TOTAL_LEN, (unsigned char *)hdcp2_verify_data_calculate);
               printf("verify & get 20 hdcp2(%s & %s) verify datas:\n", HDCP2LC128_NAME, HDCP2KEY_NAME);
               for (i=0; i<20; i++)
                    printf("%.2x:", hdcp2_verify_data_calculate[i]);
               printf("\n");

               ret = memcmp(hdcp2_verify_data_receive, hdcp2_verify_data_calculate, 20);
               if (ret == 0) {
                    printf("hdcp2(%s & %s) datas verify success\n", HDCP2LC128_NAME, HDCP2KEY_NAME);
                    argv[0] = "flash";
                    argv[1] = "write";
                    argv[2] = "hdcp2";
                    argv[3] = hdcp2TotalData;
                    argc = 4;
               }
               else {
                    sprintf(buff, "failed:(hdcp2<%s & %s> datas verify failed)", HDCP2LC128_NAME, HDCP2KEY_NAME);
                    printf("%s\n", buff);
                    return -1;
               }
            }

           if (!strncmp(argv[1], "write", strlen("write")) && !strncmp(argv[2], "hdcp:", strlen("hdcp:"))) {
#define HDCP_DATA_ADDR	(volatile unsigned long *)(0x82000000)
               hdcp = (char *)HDCP_DATA_ADDR;
               printf("receive %d hdcp key datas from address:0x82000000:\n", HDCP_KEY_LEN);
               for (i=0; i<HDCP_KEY_LEN; i++) {
                  key_data[i] = *hdcp++;
#ifdef HDCP_PRINT
                  printf("%.2x:", key_data[i]);
#endif
               }
               printf("\nreceive %d hdcp datas ok !!!\n", HDCP_KEY_LEN);

               printf("receive 20 hdcp key verify datas:\n");
               for (i=0; i<20; i++) {
                  hdcp_verify_data_receive[i] = *hdcp++;
                  printf("%.2x:", hdcp_verify_data_receive[i]);
               }
               printf("\n");

               printf("start to verify %d hdcp key datas...\n", HDCP_KEY_LEN);
               SHA1_Perform((unsigned char *)key_data, HDCP_KEY_LEN, (unsigned char *)hdcp_verify_data_calculate);
               printf("verify & get 20 hdcp verify datas:\n");
               for (i=0; i<20; i++)
                    printf("%.2x:", hdcp_verify_data_calculate[i]);
               printf("\n");

               ret = memcmp(hdcp_verify_data_receive, hdcp_verify_data_calculate, 20);
               if (ret == 0) {
                    printf("hdcp datas verify success\n");
                    argv[0] = "flash";
                    argv[1] = "write";
                    argv[2] = "hdcp";
                    argv[3] = key_data;
                    argc = 4;
               }
               else {
                    sprintf(buff, "%s", "failed:(hdcp datas verify failed)");
                    printf("%s\n", buff);
                    return -1;
               }
            }

            if (!strncmp(argv[1], "write", strlen("write")) && !strncmp(argv[2], "boardid:", strlen("boardid:"))) {
#define BOARDID_DATA_ADDR	(volatile unsigned long *)(0x82000000)//get boardid data from address:0x82000000
               char length[4] = {0};
               char* boardid = (char *)BOARDID_DATA_ADDR;
               for (i=0; i<4; i++) {
                  length[i] = *boardid++;
                  //printf("length[%d]=0x%02x\n", i, length[i]);
               }
               int boardid_key_len = (int)((length[3]<<24)|(length[2]<<16)|(length[1]<<8)|(length[0]));
               printf("boardid_key_len=%d(maximum length limit is %d)\n", boardid_key_len, SECUKEY_BYTES);
               memcpy(key_data, boardid, boardid_key_len);
               printf("receive %d boardid key datas from address:0x82000000:\n%s\n", boardid_key_len, key_data);
               argv[0] = "flash";
               argv[1] = "write";
               argv[2] = "boardid";
               argv[3] = key_data;
               argc = 4;
            }

            if (!strncmp(argv[1], "write", strlen("write")) && !strncmp(argv[2], "serialno:", strlen("serialno:"))) {
#define SERIALNO_DATA_ADDR	(volatile unsigned long *)(0x82000000)//get serialno data from address:0x82000000
               char length[4] = {0};
               char* serialno = (char *)SERIALNO_DATA_ADDR;
               for (i=0; i<4; i++) {
                  length[i] = *serialno++;
                  //printf("length[%d]=0x%02x\n", i, length[i]);
               }
               int serialno_key_len = (int)((length[3]<<24)|(length[2]<<16)|(length[1]<<8)|(length[0]));
               printf("serialno_key_len=%d(maximum length limit is %d)\n", serialno_key_len, SECUKEY_BYTES);
               memcpy(key_data, serialno, serialno_key_len);
               printf("receive %d serialno key datas from address:0x82000000:\n%s\n", serialno_key_len, key_data);
               argv[0] = "flash";
               argv[1] = "write";
               argv[2] = "serialno";
               argv[3] = key_data;
               argc = 4;
            }

             if (!strncmp(argv[1], "write", strlen("write")) && !strncmp(argv[2], "MFG_Serialno:", strlen("MFG_Serialno:"))) {
#define MFG_SERIALNO_DATA_ADDR	(volatile unsigned long *)(0x82000000)//get MFG_Serialno data from address:0x82000000
               char length[4] = {0};
               char* MFG_Serialno = (char *)MFG_SERIALNO_DATA_ADDR;
               for (i=0; i<4; i++) {
                  length[i] = *MFG_Serialno++;
                  //printf("length[%d]=0x%02x\n", i, length[i]);
               }
               int MFG_Serialno_key_len = (int)((length[3]<<24)|(length[2]<<16)|(length[1]<<8)|(length[0]));
               printf("MFG_Serialno_key_len=%d(maximum length limit is %d)\n", MFG_Serialno_key_len, SECUKEY_BYTES);
               memcpy(key_data, MFG_Serialno, MFG_Serialno_key_len);
               printf("receive %d MFG_Serialno key datas from address:0x82000000:\n%s\n", MFG_Serialno_key_len, key_data);
               argv[0] = "flash";
               argv[1] = "write";
               argv[2] = "MFG_Serialno";
               argv[3] = key_data;
               argc = 4;
            }
#endif   /* WRITE_TO_NAND_EMMC_ENABLE || WRITE_TO_NAND_ENABLE */

#ifdef CONFIG_SECURE_STORAGE_BURNED
            int widevinekeybox_len=0, PlayReadykeybox_len=0, MobiDRMPublic_len=0, MobiDRMPrivate_len=0;
#endif

/* Burn key to securestorage */
/* ---Command process */
#if defined(CONFIG_SECURE_STORAGE_BURNED)
            if (!strncmp(argv[2], "random", strlen("random")) || !strncmp(argv[2], "widevinekeybox", strlen("widevinekeybox")) ||
                !strncmp(argv[2], "PlayReadykeybox", strlen("PlayReadykeybox")) || !strncmp(argv[2], "MobiDRMPrivate", strlen("MobiDRMPrivate")) ||
                !strncmp(argv[2], "MobiDRMPublic", strlen("MobiDRMPublic"))) {
                argv[0] = "securestorage";
                printf("burn key to %s. convert command...\n", argv[0]);

                if (!strncmp(argv[1], "write", strlen("write")) && !strncmp(argv[2], "random", strlen("random"))) {
#define RANDOM_DATA_ADDR	(volatile unsigned long *)(0x82000000)//get random data from address:0x82000000
                    random = (char *)RANDOM_DATA_ADDR;
                    char length[4] = {0}, random_data[RANDOM_MAX_LEN] = {0};
                    for (i=0; i<4; i++) {
                        length[i] = *random++;
                        //printf("length[%d]=0x%02x\n", i, length[i]);
                    }
                    random_len = (int)((length[3]<<24)|(length[2]<<16)|(length[1]<<8)|(length[0]));
                    if (random_len > RANDOM_MAX_LEN || random_len <= 0) {
                        sprintf(buff, "random_len=%d(maximum length limit is %d)", random_len, RANDOM_MAX_LEN);
                        printf("%s\n", buff);
                        return -1;
                    }
                    printf("receive %d random datas from address:0x82000000:\n", random_len);
                    memcpy((char *)random_data, (char *)random, random_len);
                    for (i=0; i<random_len; i++) {
                        printf("%02x:", random_data[i]);
                    }
                    printf("\n");

                    argv[3] = random_data;
                    argc = 4;
                }

                if (!strncmp(argv[1], "write", strlen("write")) && !strncmp(argv[2], "widevinekeybox", strlen("widevinekeybox"))) {
#define WIDEVINE_KEYBOX_DATA_ADDR	(volatile unsigned long *)(0x82000000)//get widevinekeybox data from address:0x82000000
                    char* widevinekeybox = (char *)WIDEVINE_KEYBOX_DATA_ADDR;
                    char length[4] = {0}, widevinekeybox_data[WIDEVINEKEYBOX_MAX_LEN] = {0};
                    for (i=0; i<4; i++) {
                        length[i] = *widevinekeybox++;
                        //printf("length[%d]=0x%02x\n", i, length[i]);
                    }
                    int widevinekeybox_len = (int)((length[3]<<24)|(length[2]<<16)|(length[1]<<8)|(length[0]));
                    if (widevinekeybox_len > WIDEVINEKEYBOX_MAX_LEN || widevinekeybox_len <= 0) {
                        sprintf(buff, "widevinekeybox_len=%d(maximum length limit is %d)", widevinekeybox_len, WIDEVINEKEYBOX_MAX_LEN);
                        printf("%s\n", buff);
                        return -1;
                    }

                    printf("receive %d widevinekeybox datas from address:0x82000000:\n", widevinekeybox_len);
                    memcpy((char *)widevinekeybox_data, (char *)widevinekeybox, widevinekeybox_len);
#ifdef KEYBOX_PRINT
                    for (i=0; i<widevinekeybox_len; i++) {
                        printf("%02x:", widevinekeybox_data[i]);
                    }
#else
                    printf("receive %d widevinekeybox datas ok !!!", widevinekeybox_len);
#endif

                    printf("\nreceive 20 widevinekeybox verify datas:\n");
                    memcpy((char *)widevinekeybox_verify_data_receive, (char *)(widevinekeybox+widevinekeybox_len), 20);
                    for (i=0; i<20; i++) {
                        printf("%02x:", widevinekeybox_verify_data_receive[i]);
                    }
                    printf("\n");

                    printf("start to verify %d widevinekeybox datas...\n", widevinekeybox_len);
                    SHA1_Perform((unsigned char *)widevinekeybox_data, widevinekeybox_len, (unsigned char *)widevinekeybox_verify_data_calculate);
                    printf("verify & get 20 widevinekeybox verify datas:\n");
                    for (i=0; i<20; i++)
                        printf("%02x:", widevinekeybox_verify_data_calculate[i]);
                    printf("\n");

                    ret = memcmp(widevinekeybox_verify_data_receive, widevinekeybox_verify_data_calculate, 20);
                    if (ret == 0) {
                        printf("widevinekeybox datas verify success\n");
                        argv[3] = widevinekeybox_data;
                        argc = 4;
                    }
                    else {
                        sprintf(buff, "%s", "failed:(widevinekeybox datas verify failed)");
                        printf("%s\n", buff);
                        return -1;
                    }
                }

               if (!strncmp(argv[1], "write", strlen("write")) && !strncmp(argv[2], "PlayReadykeybox", strlen("PlayReadykeybox"))) {
#define PLAYREADY_KEYBOX_DATA_ADDR	(volatile unsigned long *)(0x82000000)//get PlayReadykeybox data from address:0x82000000
                    char* PlayReadykeybox = (char *)PLAYREADY_KEYBOX_DATA_ADDR;
                    char length[4] = {0}, PlayReadykeybox_data[PLAYREADYKEYBOX_MAX_LEN] = {0};
                    for (i=0; i<4; i++) {
                        length[i] = *PlayReadykeybox++;
                        //printf("length[%d]=0x%02x\n", i, length[i]);
                    }
                    int PlayReadykeybox_len = (int)((length[3]<<24)|(length[2]<<16)|(length[1]<<8)|(length[0]));
                    if (PlayReadykeybox_len > PLAYREADYKEYBOX_MAX_LEN || PlayReadykeybox_len <= 0) {
                        sprintf(buff, "PlayReadykeybox_len=%d(maximum length limit is %d)", PlayReadykeybox_len, PLAYREADYKEYBOX_MAX_LEN);
                        printf("%s\n", buff);
                        return -1;
                    }

                    printf("receive %d PlayReadykeybox datas from address:0x82000000:\n", PlayReadykeybox_len);
                    memcpy((char *)PlayReadykeybox_data, (char *)PlayReadykeybox, PlayReadykeybox_len);
#ifdef KEYBOX_PRINT
                    for (i=0; i<PlayReadykeybox_len; i++) {
                        printf("%02x:", PlayReadykeybox_data[i]);
                    }
#else
                    printf("receive %d PlayReadykeybox datas ok !!!", PlayReadykeybox_len);
#endif

                    printf("\nreceive 20 PlayReadykeybox verify datas:\n");
                    memcpy((char *)PlayReadykeybox_verify_data_receive, (char *)(PlayReadykeybox+PlayReadykeybox_len), 20);
                    for (i=0; i<20; i++) {
                        printf("%02x:", PlayReadykeybox_verify_data_receive[i]);
                    }
                    printf("\n");

                    printf("start to verify %d PlayReadykeybox datas...\n", PlayReadykeybox_len);
                    SHA1_Perform((unsigned char *)PlayReadykeybox_data, PlayReadykeybox_len, (unsigned char *)PlayReadykeybox_verify_data_calculate);
                    printf("verify & get 20 PlayReadykeybox verify datas:\n");
                    for (i=0; i<20; i++)
                        printf("%02x:", PlayReadykeybox_verify_data_calculate[i]);
                    printf("\n");

                    ret = memcmp(PlayReadykeybox_verify_data_receive, PlayReadykeybox_verify_data_calculate, 20);
                    if (ret == 0) {
                        printf("PlayReadykeybox datas verify success\n");
                        argv[3] = PlayReadykeybox_data;
                        argc = 4;
                    }
                    else {
                        sprintf(buff, "%s", "failed:(PlayReadykeybox datas verify failed)");
                        printf("%s\n", buff);
                        return -1;
                    }
                }

               if (!strncmp(argv[1], "write", strlen("write")) && !strncmp(argv[2], "MobiDRMPrivate", strlen("MobiDRMPrivate"))) {
#define MOBIDRMPRIVATE_DATA_ADDR	(volatile unsigned long *)(0x82000000)//get MobiDRMPrivate data from address:0x82000000
                    char* MobiDRMPrivate = (char *)MOBIDRMPRIVATE_DATA_ADDR;
                    char length[4] = {0}, MobiDRMPrivate_data[MOBIDRMPRIVATE_MAX_LEN] = {0};
                    for (i=0; i<4; i++) {
                        length[i] = *MobiDRMPrivate++;
                        //printf("length[%d]=0x%02x\n", i, length[i]);
                    }

                    MobiDRMPrivate_len = (int)((length[3]<<24)|(length[2]<<16)|(length[1]<<8)|(length[0]));
                    if (MobiDRMPrivate_len > MOBIDRMPRIVATE_MAX_LEN || MobiDRMPrivate_len <= 0) {
                        sprintf(buff, "MobiDRMPrivate_len=%d(maximum length limit is %d)", MobiDRMPrivate_len, MOBIDRMPRIVATE_MAX_LEN);
                        printf("%s\n", buff);
                        return -1;
                    }

                    printf("receive %d MobiDRMPrivate datas from address:0x82000000:\n", MobiDRMPrivate_len);
                    memcpy((char *)MobiDRMPrivate_data, (char *)MobiDRMPrivate, MobiDRMPrivate_len);
#ifdef KEYBOX_PRINT
                    for (i=0; i<MobiDRMPrivate_len; i++) {
                        printf("%02x:", MobiDRMPrivate_data[i]);
                    }
#else
                    printf("receive %d MobiDRMPrivate datas ok !!!", MobiDRMPrivate_len);
#endif

                    printf("\nreceive 20 MobiDRMPrivate verify datas:\n");
                    memcpy((char *)MobiDRMPrivate_verify_data_receive, (char *)(MobiDRMPrivate+MobiDRMPrivate_len), 20);
                    for (i=0; i<20; i++) {
                        printf("%02x:", MobiDRMPrivate_verify_data_receive[i]);
                    }
                    printf("\n");

                    printf("start to verify %d MobiDRMPrivate datas...\n", MobiDRMPrivate_len);
                    SHA1_Perform((unsigned char *)MobiDRMPrivate_data, MobiDRMPrivate_len, (unsigned char *)MobiDRMPrivate_verify_data_calculate);
                    printf("verify & get 20 MobiDRMPrivate verify datas:\n");
                    for (i=0; i<20; i++)
                        printf("%02x:", MobiDRMPrivate_verify_data_calculate[i]);
                    printf("\n");

                    ret = memcmp(MobiDRMPrivate_verify_data_receive, MobiDRMPrivate_verify_data_calculate, 20);
                    if (ret == 0) {
                        printf("MobiDRMPrivate datas verify success\n");
                        argv[3] = MobiDRMPrivate_data;
                        argc = 4;
                    }
                    else {
                        sprintf(buff, "%s", "failed:(MobiDRMPrivate datas verify failed)");
                        printf("%s\n", buff);
                        return -1;
                    }
                }

               if (!strncmp(argv[1], "write", strlen("write")) && !strncmp(argv[2], "MobiDRMPublic", strlen("MobiDRMPublic"))) {
#define MOBIDRMPUBLIC_DATA_ADDR	(volatile unsigned long *)(0x82000000)//get MobiDRMPublic data from address:0x82000000
                    char* MobiDRMPublic = (char *)MOBIDRMPUBLIC_DATA_ADDR;
                    char length[4] = {0}, MobiDRMPublic_data[MOBIDRMPUBLIC_MAX_LEN] = {0};
                    for (i=0; i<4; i++) {
                        length[i] = *MobiDRMPublic++;
                        //printf("length[%d]=0x%02x\n", i, length[i]);
                    }
                    int MobiDRMPublic_len = (int)((length[3]<<24)|(length[2]<<16)|(length[1]<<8)|(length[0]));
                    if (MobiDRMPublic_len > MOBIDRMPUBLIC_MAX_LEN || MobiDRMPublic_len <= 0) {
                        sprintf(buff, "MobiDRMPublic_len=%d(maximum length limit is %d)", MobiDRMPublic_len, MOBIDRMPUBLIC_MAX_LEN);
                        printf("%s\n", buff);
                        return -1;
                    }

                    printf("receive %d MobiDRMPublic datas from address:0x82000000:\n", MobiDRMPublic_len);
                    memcpy((char *)MobiDRMPublic_data, (char *)MobiDRMPublic, MobiDRMPublic_len);
#ifdef KEYBOX_PRINT
                    for (i=0; i<MobiDRMPublic_len; i++) {
                        printf("%02x:", MobiDRMPublic_data[i]);
                    }
#else
                    printf("receive %d MobiDRMPublic datas ok !!!", MobiDRMPublic_len);
#endif

                    printf("\nreceive 20 MobiDRMPublic verify datas:\n");
                    memcpy((char *)MobiDRMPublic_verify_data_receive, (char *)(MobiDRMPublic+MobiDRMPublic_len), 20);
                    for (i=0; i<20; i++) {
                        printf("%02x:", MobiDRMPublic_verify_data_receive[i]);
                    }
                    printf("\n");

                    printf("start to verify %d MobiDRMPublic datas...\n", MobiDRMPublic_len);
                    SHA1_Perform((unsigned char *)MobiDRMPublic_data, MobiDRMPublic_len, (unsigned char *)MobiDRMPublic_verify_data_calculate);
                    printf("verify & get 20 MobiDRMPublic verify datas:\n");
                    for (i=0; i<20; i++)
                        printf("%02x:", MobiDRMPublic_verify_data_calculate[i]);
                    printf("\n");

                    ret = memcmp(MobiDRMPublic_verify_data_receive, MobiDRMPublic_verify_data_calculate, 20);
                    if (ret == 0) {
                        printf("MobiDRMPublic datas verify success\n");
                        argv[3] = MobiDRMPublic_data;
                        argc = 4;
                    }
                    else {
                        sprintf(buff, "%s", "failed:(MobiDRMPublic datas verify failed)");
                        printf("%s\n", buff);
                        return -1;
                    }
                }
            }
#endif   /* CONFIG_SECURE_STORAGE_BURNED */

            //printf argv[0]--argv[argc-1]
            if (!strncmp(argv[1], "write", strlen("write")) &&  !strncmp(argv[2], "hdcp2", strlen("hdcp2"))) {
               for (i=0; i<argc-1; i++) printf("argv[%d]=%s\n", i, argv[i]) ;
               printf("argv[3]=");

#ifdef HDCP_PRINT
               hdcp2 = argv[3];
               for (i=0; i<HDCP2_KEY_TOTAL_LEN; i++) printf("%02x:", *hdcp2 ++) ;
               printf("\n");
#else
               printf("......\n");
#endif
            }
            else if(!strncmp(argv[1], "write", strlen("write")) &&  !strncmp(argv[2], "hdcp", strlen("hdcp"))) {
               for (i=0; i<argc-1; i++) printf("argv[%d]=%s\n", i, argv[i]) ;
               printf("argv[3]=");
#ifdef HDCP_PRINT
               hdcp = argv[3];
               for (i=0; i<HDCP_KEY_LEN; i++) printf("%02x:", *hdcp ++) ;
               printf("\n");
#else
               printf("......\n");
#endif
            }
            else if(!strncmp(argv[1], "write", strlen("write")) &&  !strncmp(argv[2], "random", strlen("random"))) {
               for (i=0; i<argc-1; i++) printf("argv[%d]=%s\n", i, argv[i]) ;
               random = argv[3];
               printf("argv[3]=");
               for (i=0; i<random_len; i++) printf("%02x:", *random ++) ;
               printf("\n");
            }
            else if(!strncmp(argv[1], "write", strlen("write")) &&  !strncmp(argv[2], "widevinekeybox", strlen("widevinekeybox"))) {
               for (i=0; i<argc-1; i++) printf("argv[%d]=%s\n", i, argv[i]) ;
               printf("argv[3]=");
#ifdef KEYBOX_PRINT
               widevinekeybox = argv[3];
               for (i=0; i<widevinekeybox_len; i++) printf("%02x:", *widevinekeybox ++) ;
               printf("\n");
#else
               printf("......\n");
#endif
            }
            else if(!strncmp(argv[1], "write", strlen("write")) &&  !strncmp(argv[2], "PlayReadykeybox", strlen("PlayReadykeybox"))) {
               for (i=0; i<argc-1; i++) printf("argv[%d]=%s\n", i, argv[i]) ;
               printf("argv[3]=");
#ifdef KEYBOX_PRINT
               PlayReadykeybox = argv[3];
               for (i=0; i<PlayReadykeybox_len; i++) printf("%02x:", *PlayReadykeybox ++) ;
               printf("\n");
#else
               printf("......\n");
#endif
            }
            else if(!strncmp(argv[1], "write", strlen("write")) &&  !strncmp(argv[2], "MobiDRMPrivate", strlen("MobiDRMPrivate"))) {
               for (i=0; i<argc-1; i++) printf("argv[%d]=%s\n", i, argv[i]) ;
               printf("argv[3]=");
#ifdef KEYBOX_PRINT
               MobiDRMPrivate = argv[3];
               for (i=0; i<MobiDRMPrivate_len; i++) printf("%02x:", *MobiDRMPrivate ++) ;
               printf("\n");
#else
               printf("......\n");
#endif
            }
            else if(!strncmp(argv[1], "write", strlen("write")) &&  !strncmp(argv[2], "MobiDRMPublic", strlen("MobiDRMPublic"))) {
               for (i=0; i<argc-1; i++) printf("argv[%d]=%s\n", i, argv[i]) ;
               printf("argv[3]=");
#ifdef KEYBOX_PRINT
               MobiDRMPublic = argv[3];
               for (i=0; i<MobiDRMPublic_len; i++) printf("%02x:", *MobiDRMPublic ++) ;
               printf("\n");
#else
               printf("......\n");
#endif
            }
            else
               for (i=0; i<argc; i++)  printf("argv[%d]=%s\n", i,argv[i]) ;

            if (!strncmp(argv[2], "version", strlen("version")) ||!strncmp(argv[2], "mac_wifi", strlen("mac_wifi")) ||!strncmp(argv[2], "mac_bt", strlen("mac_bt")) ||
                !strncmp(argv[2], "mac", strlen("mac")) ||!strncmp(argv[2], "usid", strlen("usid")) ||!strncmp(argv[2], "hdcp2", strlen("hdcp2")) ||
                !strncmp(argv[2], "hdcp", strlen("hdcp")) || !strncmp(argv[2], "boardid", strlen("boardid")) ||
                !strncmp(argv[2], "serialno", strlen("serialno")) || !strncmp(argv[2], "MFG_Serialno", strlen("MFG_Serialno")))
                key_device_index = 1;   // flash -> efuse or nand or emmc
            else if(!strncmp(argv[2], "random", strlen("random")) ||!strncmp(argv[2], "widevinekeybox", strlen("widevinekeybox")) ||
                !strncmp(argv[2], "PlayReadykeybox", strlen("PlayReadykeybox")) ||!strncmp(argv[2], "MobiDRMPrivate", strlen("MobiDRMPrivate")) ||
                !strncmp(argv[2], "MobiDRMPublic", strlen("MobiDRMPublic")))
                key_device_index = 2;   // securestorage
            else
                key_device_index = -1; // none command



/* Burn key to efuse */
/* ---The actual function to read & write operation */
#ifdef  WRITE_TO_EFUSE_ENABLE
            /* read/write version */
            if (!strncmp(argv[1], "read", strlen("read")) && !strncmp(argv[2], "version", strlen("version"))) {
               int flag = 0;
               ret = run_efuse_cmd(argc, argv, buff);
#ifdef CONFIG_AML_MESON3
               if (!ret) {
                  for (i=0; i<3; i++) {
                     if (buff[i] != 0x00) {
                        flag = 1;
                        break;
                     }
                  }
                  if (flag) {
                     sprintf(key_data, "%02x:%02x:%02x", buff[0], buff[1], buff[2]);
                     printf("version=%s\n", key_data);
                     sprintf(buff, "success:(%s)", key_data);
                  }
                  else {
                     if (sPctoolVersion >= PCTOOL_VERSION_1632)
                        sprintf(buff, "%s", "okay:(version has been not writen)");
                     else
                        sprintf(buff, "%s", "failed:(version has been not writen)");
                  }
               }
               else {
                  sprintf(buff, "failed:(%s %s %s failed)", argv[0], argv[1], argv[2]);
                  printf("%s\n", buff);
                  return -1;
               }
#elif defined(CONFIG_AML_MESON6)
               if (!ret) {
                  if (buff[0] != 0x00) {
                     sprintf(key_data, "%02x", buff[0]);
                     printf("version=%s\n", key_data);
                     sprintf(buff, "success:(%s)", key_data);
                  }
                  else {
                     if (sPctoolVersion >= PCTOOL_VERSION_1632)
                        sprintf(buff, "%s", "okay:(version has been not writen)");
                     else
                        sprintf(buff, "%s", "failed:(version has been not writen)");
                  }
               }
               else {
                  sprintf(buff, "failed:(%s %s %s failed)", argv[0], argv[1], argv[2]);
                  printf("%s\n", buff);
                  return -1;
               }
#endif
            }
            else if(!strncmp(argv[1], "write", strlen("write")) && !strncmp(argv[2], "version", strlen("version"))) {
               ret = run_efuse_cmd(argc, argv, buff);
               if (!ret) {
#ifndef EFUSE_READ_TEST_ENABLE
                  sprintf(buff, "success:(%s)", argv[3]);
#else
                  argv[1] = "read";
                  argc = 3;
                  ret = test_efuse_read(argc, argv, argv[3]);
                  if (!ret)
                     sprintf(buff, "success:(%s)", argv[3]);
                  else if(ret == -1) {
                     sprintf(buff, "%s", "failed:(efuse write success,but test read data not match write)");
                     printf("%s\n", buff);
                     return -1;
                  }
                  else if(ret == -2) {
                     sprintf(buff, "%s", "failed:(efuse write success,but test read fail)");
                     printf("%s\n", buff);
                     return -1;
                  }
#endif
               }
               else {
                  sprintf(buff, "failed:(%s %s %s failed)", argv[0], argv[1], argv[2]);
                  printf("%s\n", buff);
                  return -1;
               }
            }

            /* read/write mac/mac_bt/mac_wifi */
            else if(!strncmp(argv[1], "read", strlen("read")) && (!strncmp(argv[2], "mac", strlen("mac")) ||
               !strncmp(argv[2], "mac_bt", strlen("mac_bt")) ||!strncmp(argv[2], "mac_wifi", strlen("mac_wifi")))) {
               ret = run_efuse_cmd(argc, argv, buff);
               if (!ret) {
                  for (i=0; i<6; i++) {
                     if (buff[i] != 0x00) {
                        flag = 1;
                        break;
                     }
                  }
                  if (flag) {
                     sprintf(key_data, "%02x:%02x:%02x:%02x:%02x:%02x", buff[0],buff[1],buff[2],buff[3],buff[4],buff[5]);
                     printf("%s_key_data=%s\n", argv[2], key_data);
                     sprintf(buff, "success:(%s)", key_data);
                  }
                  else {
                     if (sPctoolVersion >= PCTOOL_VERSION_1632)
                        sprintf(buff, "okay:(%s has been not writen)", argv[2]);
                     else
                        sprintf(buff, "failed:(%s has been not writen)", argv[2]);
                  }
               }
               else {
                  sprintf(buff, "failed:(%s %s %s failed)", argv[0], argv[1], argv[2]);
                  printf("%s\n", buff);
                  return -1;
               }
            }
            else if(!strncmp(argv[1], "write", strlen("write")) && (!strncmp(argv[2], "mac", strlen("mac")) ||
               !strncmp(argv[2], "mac_bt", strlen("mac_bt")) ||!strncmp(argv[2], "mac_wifi", strlen("mac_wifi")))) {
               ret = run_efuse_cmd(argc, argv, buff);
               if (!ret) {
#ifndef EFUSE_READ_TEST_ENABLE
                  sprintf(buff, "success:(%s)", argv[3]);
#else
                  argv[1] = "read";
                  argc = 3;
                  ret = test_efuse_read(argc, argv, argv[3]);
                  if (!ret)
                     sprintf(buff, "success:(%s)", argv[3]);
                  else if(ret == -1) {
                     sprintf(buff, "%s", "failed:(efuse write success,but test read data not match write)");
                     printf("%s\n", buff);
                     return -1;
                  }
                  else if(ret == -2) {
                     sprintf(buff, "%s", "failed:(efuse write success,but test read fail)");
                     printf("%s\n", buff);
                     return -1;
                  }
#endif
               }
               else {
                  sprintf(buff, "failed:(%s %s %s failed)", argv[0], argv[1], argv[2]);
                  printf("%s\n", buff);
                  return -1;
               }
            }

            /* read/write usid */
            else if(!strncmp(argv[1], "read", strlen("read")) && !strncmp(argv[2], "usid", strlen("usid"))) {
               int usid_flag = 0;
               ret = run_efuse_cmd(argc, argv, buff);
               if (!ret) {
                  for (i=0; i<strlen(buff); i++) {
                     if (buff[i] != 0x00) {
                        usid_flag = 1;
                        break;
                     }
                  }
                  if (usid_flag) {
                     printf("usid_key_data=%s\n", buff);
                     memcpy(key_data, buff, strlen(buff));
                     sprintf(buff, "success:(%s)", key_data);
                  }
                  else {
                     if (sPctoolVersion >= PCTOOL_VERSION_1632)
                        sprintf(buff, "%s", "okay:(usid has been not writen)");
                     else
                        sprintf(buff, "%s", "failed:(usid has been not writen)");
                  }
               }
               else {
                  sprintf(buff, "failed:(%s %s %s failed)", argv[0], argv[1], argv[2]);
                  printf("%s\n", buff);
                  return -1;
               }
            }
            else if(!strncmp(argv[1], "write", strlen("write")) && !strncmp(argv[2], "usid", strlen("usid"))) {
               ret = run_efuse_cmd(argc, argv, buff);
               if (!ret) {
#ifndef EFUSE_READ_TEST_ENABLE
                  sprintf(buff, "success:(%s)", argv[3]);
#else
                  argv[1] = "read";
                  argc = 3;
                  ret = test_efuse_read(argc, argv, argv[3]);
                  if (!ret)
                     sprintf(buff, "success:(%s)", argv[3]);
                  else if(ret == -1) {
                     sprintf(buff, "%s", "failed:(efuse write success,but test read data not match write)");
                     printf("%s\n", buff);
                     return -1;
                  }
                  else if(ret == -2) {
                     sprintf(buff, "%s", "failed:(efuse write success,but test read fail)");
                     printf("%s\n", buff);
                     return -1;
                  }
#endif
               }
               else {
                  sprintf(buff, "failed:(%s %s %s failed)", argv[0], argv[1], argv[2]);
                  printf("%s\n", buff);
                  return -1;
               }
            }

            /* read/write hdcp */
            else if(!strncmp(argv[1], "read", strlen("read")) && !strncmp(argv[2], "hdcp", strlen("hdcp"))) {
               int hdcp_flag = 0;
               ret = run_efuse_cmd(argc, argv, buff);
               if (!ret) {
                  for (i=0; i<HDCP_KEY_LEN; i++) {
                     if (buff[i] != 0x00) {
                        hdcp_flag = 1;
                        break;
                     }
                  }
                  if (hdcp_flag) {
                     printf("hdcp_key_data is:\n");
                     for (i=0; i<HDCP_KEY_LEN; i++)
                        printf("%.2x:", buff[i]);
                     printf("\n");
                     sprintf(buff, "%s", "success:(hdcp has been writen)");
                  }
                  else {
                     if (sPctoolVersion >= PCTOOL_VERSION_1632)
                        sprintf(buff, "%s", "okay:(hdcp has been not writen)");
                     else
                        sprintf(buff, "%s", "failed:(hdcp has been not writen)");
                  }
               }
               else {
                  sprintf(buff, "failed:(%s %s %s failed)", argv[0], argv[1], argv[2]);
                  printf("%s\n", buff);
                  return -1;
               }
            }
            else if(!strncmp(argv[1], "write", strlen("write")) && !strncmp(argv[2], "hdcp", strlen("hdcp"))) {
               ret = run_efuse_cmd(argc, argv, buff);
               if (!ret) {
#ifndef EFUSE_READ_TEST_ENABLE
                  sprintf(buff, "%s", "success:(efuse write hdcp success)");
#else
                  argv[1] = "read";
                  argc = 3;
                  ret = test_efuse_read(argc, argv, argv[3]);
                  if (!ret)
                     sprintf(buff, "%s", "success:(efuse write hdcp success)");
                  else if(ret == -1) {
                     sprintf(buff, "%s", "failed:(efuse write success,but test read data not match write)");
                     printf("%s\n", buff);
                     return -1;
                  }
                  else if(ret == -2) {
                     sprintf(buff, "%s", "failed:(efuse write success,but test read fail)");
                     printf("%s\n", buff);
                     return -1;
                  }
#endif
               }
               else {
                  sprintf(buff, "failed:(%s %s %s failed)", argv[0], argv[1], argv[2]);
                  printf("%s\n", buff);
                  return -1;
               }
            }

#if !defined(CONFIG_SECURE_STORAGE_BURNED)
            /* no command mach */
            else {
               sprintf(buff, "%s", "failed:(No command mached)");
               printf("%s\n", buff);
               return -1;
            }
#endif
#endif   /* WRITE_TO_EFUSE_ENABLE */


/* Burn key to nand/emmc */
/* ---The actual function to read & write operation */
#if defined(WRITE_TO_NAND_EMMC_ENABLE) || defined(WRITE_TO_NAND_ENABLE)
            /* read/write version */
            if (!strncmp(argv[1], "read", strlen("read")) && !strncmp(argv[2], "version", strlen("version"))) {
                if (sPctoolVersion >= PCTOOL_VERSION_1632)
                    sprintf(buff, "okay:(%s has been not initialized)", argv[0]);
                else
                    sprintf(buff, "failed:(%s has been not initialized)", argv[0]);
            }
            else if(!strncmp(argv[1], "write", strlen("write")) && !strncmp(argv[2], "version", strlen("version"))) {
               ret = ensure_secukey_init();
               if (ret == 0) {                                            //init nand/emmc success.
                  sprintf(buff, "success:(init %s success)", argv[0]);
               }
               else if(ret == 1) {                                     //nand/emmc already inited.
                  sprintf(buff, "success:(%s already inited)", argv[0]);
               }
               else {                                                       //init nand/emmc failed!!
                  sprintf(buff, "failed:(init %s failed)", argv[0]);
                  printf("%s\n", buff);
                  return -1;
               }
            }

            /* read/write mac/mac_bt/mac_wifi/usid*/
            else if(!strncmp(argv[1], "read", strlen("read")) && (!strncmp(argv[2], "mac", strlen("mac")) ||
               !strncmp(argv[2], "mac_bt", strlen("mac_bt")) ||!strncmp(argv[2], "mac_wifi", strlen("mac_wifi")) ||
               !strncmp(argv[2], "usid", strlen("usid")))) {
               ret = cmd_secukey(argc, argv, buff);
               if (!ret) {
                    printf("%s_key_data=%s\n", argv[2], buff);
                     memcpy(key_data, buff, strlen(buff));
                     sprintf(buff, "success:(%s)", key_data);
                }
                else if(ret == 1) {
                    if (sPctoolVersion >= PCTOOL_VERSION_1632)
                        sprintf(buff, "okay:(%s has been not writen)", argv[2]);
                    else
                        sprintf(buff, "failed:(%s has been not writen)", argv[2]);
               }
               else {
                  sprintf(buff, "failed:(%s %s %s failed)", argv[0], argv[1], argv[2]);
                  printf("%s\n", buff);
                  return -1;
               }
            }
            else if(!strncmp(argv[1], "write", strlen("write")) && (!strncmp(argv[2], "mac", strlen("mac")) ||
               !strncmp(argv[2], "mac_bt", strlen("mac_bt")) ||!strncmp(argv[2], "mac_wifi", strlen("mac_wifi")) ||
               !strncmp(argv[2], "usid", strlen("usid")))) {
               for (i=0; i<4; i++) buff[i] = (char)((strlen(argv[3]) >> (i*8)) & 0xff) ;
               ret = cmd_secukey(argc, argv, buff);
               if (!ret)
                  sprintf(buff, "success:(%s)", argv[3]);
               else {
                  sprintf(buff, "failed:(%s %s %s failed)", argv[0], argv[1], argv[2]);
                  printf("%s\n", buff);
                  return -1;
               }
            }

            /* read/write hdcp2 */
            /* two keys: hdcp2lc128, hdcp2key */
            else if(!strncmp(argv[1], "read", strlen("read")) && !strncmp(argv[2], "hdcp2", strlen("hdcp2"))) {
               char rKeyHdcp2Data[HDCP2_KEY_TOTAL_LEN] = {0};
               argv[2] = (char *)HDCP2LC128_NAME;
               printf("need to convert command again.cmd:\"%s %s %s\"\n", argv[0], argv[1], argv[2]);

               ret = cmd_secukey(argc, argv, rKeyHdcp2Data);
               if (!ret) {
#ifdef HDCP_PRINT
                    char hdcp2lc128Decryption[HDCP2LC128_LEN] = {0};
                    printf("start to decrypt %s...\n", HDCP2LC128_NAME);
                    hdcpDataDecryption(HDCP2LC128_LEN, rKeyHdcp2Data, hdcp2lc128Decryption);
                    printf("%s is:\n", argv[2]);
                    for (i=0; i<HDCP2LC128_LEN; i++)
                        printf("%.2x:", hdcp2lc128Decryption[i]);
                    printf("\n");
#endif
                    printf("%s has been writen,continue to read %s\n", HDCP2LC128_NAME, HDCP2KEY_NAME);
                    memset(rKeyHdcp2Data, 0, sizeof(rKeyHdcp2Data));
                    argv[2] = (char *)HDCP2KEY_NAME;
                    printf("need to convert command again.cmd:\"%s %s %s\"\n", argv[0], argv[1], argv[2]);

                    ret = cmd_secukey(argc, argv, rKeyHdcp2Data);
                    if (!ret) {
#ifdef HDCP_PRINT
                        char hdcp2keyDecryption[HDCP2KEY_LEN] = {0};
                        printf("start to decrypt %s...\n", HDCP2KEY_NAME);
                        hdcpDataDecryption(HDCP2KEY_LEN, rKeyHdcp2Data, hdcp2keyDecryption);
                        printf("%s is:\n", argv[2]);
                        for (i=0; i<HDCP2KEY_LEN; i++)
                            printf("%.2x:", hdcp2keyDecryption[i]);
                        printf("\n");
#endif
                        sprintf(buff, "success:(%s & %s has been writen)", HDCP2LC128_NAME, HDCP2KEY_NAME);
                    }
                    else if(ret == 1) {
                         sprintf(buff, "failed:(%s has been writen,but %s has been not writen)", HDCP2LC128_NAME, HDCP2KEY_NAME);
                    }
                    else {
                      sprintf(buff, "failed:(%s %s %s failed)", argv[0], argv[1], argv[2]);
                      printf("%s\n", buff);
                      return -1;
                   }
                }
                else if(ret == 1) {
                     if (sPctoolVersion >= PCTOOL_VERSION_1632)
                        sprintf(buff, "okay:(%s has been not writen)", argv[2]);
                     else
                        sprintf(buff, "failed:(%s has been not writen)", argv[2]);
                }
                else {
                  sprintf(buff, "failed:(%s %s %s failed)", argv[0], argv[1], argv[2]);
                  printf("%s\n", buff);
                  return -1;
               }
            }
            else if(!strncmp(argv[1], "write", strlen("write")) && !strncmp(argv[2], "hdcp2", strlen("hdcp2"))) {
               char hdcp2lc128Encryption[HDCP2LC128_LEN] = {0};
               printf("start to encrypt %s...\n", HDCP2LC128_NAME);
               hdcpDataEncryption(HDCP2LC128_LEN, hdcp2lc128, hdcp2lc128Encryption);
               argv[2] = (char *)HDCP2LC128_NAME;
               argv[3] = (char *)hdcp2lc128Encryption;
               printf("need to convert command again.cmd:\"%s %s %s ...\"\n", argv[0], argv[1], argv[2]);

               for (i=0; i<4; i++) buff[i] = (char)((HDCP2LC128_LEN >> (i*8)) & 0xff) ;
               ret = cmd_secukey(argc, argv, buff);
               if (!ret) {
                  printf("success to write %s,continue to write %s\n", HDCP2LC128_NAME, HDCP2KEY_NAME);
                  char hdcp2keyEncryption[HDCP2KEY_LEN] = {0};
                  printf("start to encrypt %s...\n", HDCP2KEY_NAME);
                  hdcpDataEncryption(HDCP2KEY_LEN, hdcp2key, hdcp2keyEncryption);
                  argv[2] = (char *)HDCP2KEY_NAME;
                  argv[3] = (char *)hdcp2keyEncryption;
                  printf("need to convert command again.cmd:\"%s %s %s ...\"\n", argv[0], argv[1], argv[2]);

                  for (i=0; i<4; i++) buff[i] = (char)((HDCP2KEY_LEN >> (i*8)) & 0xff) ;
                  ret = cmd_secukey(argc, argv, buff);
                  if (!ret) {
                        sprintf(buff, "success:(%s %s %s & %s success)", argv[0], argv[1], HDCP2LC128_NAME, HDCP2KEY_NAME);
                  }
                  else {
                        sprintf(buff, "failed:(%s %s %s failed)", argv[0], argv[1], argv[2]);
                        printf("%s\n", buff);
                        return -1;
                  }
               }
               else {
                  sprintf(buff, "failed:(%s %s %s failed)", argv[0], argv[1], argv[2]);
                  printf("%s\n", buff);
                  return -1;
               }
            }

            /* read/write hdcp */
            else if(!strncmp(argv[1], "read", strlen("read")) && !strncmp(argv[2], "hdcp", strlen("hdcp"))) {
               ret = cmd_secukey(argc, argv, buff);
               if (!ret) {
#ifdef HDCP_PRINT
                    printf("hdcp_key_data is:\n");
                    for (i=0; i<HDCP_KEY_LEN; i++)
                        printf("%.2x:", buff[i]);
                    printf("\n");
#endif
                    sprintf(buff, "%s", "success:(hdcp has been writen)");
                }
                else if(ret == 1) {
                     if (sPctoolVersion >= PCTOOL_VERSION_1632)
                        sprintf(buff, "%s", "okay:(hdcp has been not writen)");
                     else
                        sprintf(buff, "%s", "failed:(hdcp has been not writen)");
                }
                else {
                  sprintf(buff, "failed:(%s %s %s failed)", argv[0], argv[1], argv[2]);
                  printf("%s\n", buff);
                  return -1;
               }
            }
            else if(!strncmp(argv[1], "write", strlen("write")) && !strncmp(argv[2], "hdcp", strlen("hdcp"))) {
               for (i=0; i<4; i++) buff[i] = (char)((HDCP_KEY_LEN >> (i*8)) & 0xff) ;
               ret = cmd_secukey(argc, argv, buff);
               if (!ret)
                  sprintf(buff, "success:(%s %s %s success)", argv[0], argv[1], argv[2]);
               else {
                  sprintf(buff, "failed:(%s %s %s failed)", argv[0], argv[1], argv[2]);
                  printf("%s\n", buff);
                  return -1;
               }
            }

            /* read/write boardid/serialno */
            else if(!strncmp(argv[1], "read", strlen("read")) && (!strncmp(argv[2], "boardid", strlen("boardid")) ||
                !strncmp(argv[2], "serialno", strlen("serialno")) || !strncmp(argv[2], "MFG_Serialno", strlen("MFG_Serialno")))) {
               ret = cmd_secukey(argc, argv, buff);
               if (!ret) {
                    printf("%s_key_data=%s\n", argv[2], buff);
                    memcpy(key_data, buff, strlen(buff));
                    if (!strncmp(argv[2], "MFG_Serialno", strlen("MFG_Serialno")))
                        sprintf(buff, "success:(%s)", key_data);
                    else
                        sprintf(buff, "success:(%s has been writen)", argv[2]);
                }
                else if(ret == 1) {
                     if (sPctoolVersion >= PCTOOL_VERSION_1632)
                        sprintf(buff, "okay:(%s has been not writen)", argv[2]);
                     else
                        sprintf(buff, "failed:(%s has been not writen)", argv[2]);
                }
                else {
                  sprintf(buff, "failed:(%s %s %s failed)", argv[0], argv[1], argv[2]);
                  printf("%s\n", buff);
                  return -1;
               }
            }
            else if(!strncmp(argv[1], "write", strlen("write")) && (!strncmp(argv[2], "boardid", strlen("boardid")) ||
                !strncmp(argv[2], "serialno", strlen("serialno")) || !strncmp(argv[2], "MFG_Serialno", strlen("MFG_Serialno")))) {
               for (i=0; i<4; i++) buff[i] = (char)((strlen(argv[3]) >> (i*8)) & 0xff) ;
               ret = cmd_secukey(argc, argv, buff);
               if (!ret)
                  sprintf(buff, "success:(%s %s %s success)", argv[0], argv[1], argv[2]);
               else {
                  sprintf(buff, "failed:(%s %s %s failed)", argv[0], argv[1], argv[2]);
                  printf("%s\n", buff);
                  return -1;
               }
            }

#if !defined(CONFIG_SECURE_STORAGE_BURNED)
            /* no command mach */
            else {
               sprintf(buff, "%s", "failed:(No command mached)");
               printf("%s\n", buff);
               return -1;
            }
#endif
#endif   /* WRITE_TO_NAND_EMMC_ENABLE || WRITE_TO_NAND_ENABLE */

if (key_device_index == 1) {
	printf("%s\n",buff);
	return 0;
}

/* Burn key to securestorage */
/* ---The actual function to read & write operation */
#if defined(CONFIG_SECURE_STORAGE_BURNED)
//            if(key_device_index == 1) {
//                printf("%s\n",buff);
//                return 0;
//            }

            /* init securestore device and write random at same time */
            if (!strncmp(argv[1], "write", strlen("write")) && !strncmp(argv[2], "random", strlen("random"))) {
               ret = ensure_securestore_key_init(key_data, random_len);
               if (ret == 0) {                                            //init securestorage and write random success
                  sprintf(buff, "success:(init %s and write random success)", argv[0]);
               }
               else if(ret == 1) {
                  sprintf(buff, "success:(%s already inited and writed random)", argv[0]);
               }
               else {                                                       //init securestorage or write random failed!!
                  sprintf(buff, "failed:(init %s or write random failed)", argv[0]);
                  printf("%s\n", buff);
                  return -1;
               }
            }

            /* read/write widevinekeybox */
            else if(!strncmp(argv[1], "read", strlen("read")) && !strncmp(argv[2], "widevinekeybox", strlen("widevinekeybox"))) {
               ret = cmd_securestore(argc, argv, buff);
               if (!ret) {
                  sprintf(buff, "%s", "success:(widevinekeybox has been writen)");
               }
               else if(ret == 1) {
                  sprintf(buff, "%s", "okay:(widevinekeybox has been not writen)");
               }
               else {
                  sprintf(buff, "failed:(%s %s %s failed)", argv[0], argv[1], argv[2]);
                  printf("%s\n", buff);
                  return -1;
               }
            }
            else if(!strncmp(argv[1], "write", strlen("write")) && !strncmp(argv[2], "widevinekeybox", strlen("widevinekeybox"))) {
               for (i=0; i<4; i++) buff[i] = (char)((widevinekeybox_len >> (i*8)) & 0xff) ;
               ret = cmd_securestore(argc, argv, buff);
               if (!ret) {
                  sprintf(buff, "success:(%s write widevinekeybox success)", argv[0]);
               }
               else {
                  sprintf(buff, "failed:(%s %s %s failed)", argv[0], argv[1], argv[2]);
                  printf("%s\n", buff);
                  return -1;
               }
            }

            /* read/write PlayReadykeybox */
            else if(!strncmp(argv[1], "read", strlen("read")) && !strncmp(argv[2], "PlayReadykeybox", strlen("PlayReadykeybox"))) {
               ret = cmd_securestore(argc, argv, buff);
               if (!ret) {
                  sprintf(buff, "%s", "success:(PlayReadykeybox has been writen)");
               }
               else if(ret == 1) {
                  sprintf(buff, "%s", "okay:(PlayReadykeybox has been not writen)");
               }
               else {
                  sprintf(buff, "failed:(%s %s %s failed)", argv[0], argv[1], argv[2]);
                  printf("%s\n", buff);
                  return -1;
               }
            }
            else if(!strncmp(argv[1], "write", strlen("write")) && !strncmp(argv[2], "PlayReadykeybox", strlen("PlayReadykeybox"))) {
               for (i=0; i<4; i++) buff[i] = (char)((PlayReadykeybox_len >> (i*8)) & 0xff) ;
               ret = cmd_securestore(argc, argv, buff);
               if (!ret) {
                  sprintf(buff, "success:(%s write PlayReadykeybox success)", argv[0]);
               }
               else {
                  sprintf(buff, "failed:(%s %s %s failed)", argv[0], argv[1], argv[2]);
                  printf("%s\n", buff);
                  return -1;
               }
            }

            /* read/write MobiDRMPrivate */
            else if(!strncmp(argv[1], "read", strlen("read")) && !strncmp(argv[2], "MobiDRMPrivate", strlen("MobiDRMPrivate"))) {
               ret = cmd_securestore(argc, argv, buff);
               if (!ret) {
                  sprintf(buff, "%s", "success:(MobiDRMPrivate has been writen)");
               }
               else if(ret == 1) {
                  sprintf(buff, "%s", "okay:(MobiDRMPrivate has been not writen)");
               }
               else {
                  sprintf(buff, "failed:(%s %s %s failed)", argv[0], argv[1], argv[2]);
                  printf("%s\n", buff);
                  return -1;
               }
            }
            else if(!strncmp(argv[1], "write", strlen("write")) && !strncmp(argv[2], "MobiDRMPrivate", strlen("MobiDRMPrivate"))) {
               for (i=0; i<4; i++) buff[i] = (char)((MobiDRMPrivate_len >> (i*8)) & 0xff) ;
               ret = cmd_securestore(argc, argv, buff);
               if (!ret) {
                  sprintf(buff, "success:(%s write MobiDRMPrivate success)", argv[0]);
               }
               else {
                  sprintf(buff, "failed:(%s %s %s failed)", argv[0], argv[1], argv[2]);
                  printf("%s\n", buff);
                  return -1;
               }
            }

            /* read/write MobiDRMPublic */
            else if(!strncmp(argv[1], "read", strlen("read")) && !strncmp(argv[2], "MobiDRMPublic", strlen("MobiDRMPublic"))) {
               ret = cmd_securestore(argc, argv, buff);
               if (!ret) {
                  sprintf(buff, "%s", "success:(MobiDRMPublic has been writen)");
               }
               else if(ret == 1) {
                  sprintf(buff, "%s", "okay:(MobiDRMPublic has been not writen)");
               }
               else {
                  sprintf(buff, "failed:(%s %s %s failed)", argv[0], argv[1], argv[2]);
                  printf("%s\n", buff);
                  return -1;
               }
            }
            else if(!strncmp(argv[1], "write", strlen("write")) && !strncmp(argv[2], "MobiDRMPublic", strlen("MobiDRMPublic"))) {
               for (i=0; i<4; i++) buff[i] = (char)((MobiDRMPublic_len >> (i*8)) & 0xff) ;
               ret = cmd_securestore(argc, argv, buff);
               if (!ret) {
                  sprintf(buff, "success:(%s write MobiDRMPublic success)", argv[0]);
               }
               else {
                  sprintf(buff, "failed:(%s %s %s failed)", argv[0], argv[1], argv[2]);
                  printf("%s\n", buff);
                  return -1;
               }
            }

            /* no command mach */
            else {
               sprintf(buff, "%s", "failed:(No command mached)");
               printf("%s\n", buff);
               return -1;
            }

            // set "reboot_mode=charging",because it has been set "reboot_mode=usb_burning" when recovery shutdown
            if (!strncmp(getenv("reboot_mode"), "usb_burning", strlen("usb_burning"))) {
                printf("reboot_mode=usb_burning, now set reboot_mode=charging.\n");
                setenv("reboot_mode", "charging");
                saveenv();
                if (!strncmp(getenv("reboot_mode"), "charging", strlen("charging")))
                    printf("set env reboot_mode=charging ok\n");
                else
                    printf("set env reboot_mode=charging fail,now reboot_mode is:%s\n", getenv("reboot_mode"));
            }
#endif   /* CONFIG_SECURE_STORAGE_BURNED */
      }
      else {
            if (run_command(cmd, flag)) {
                strcpy(buff, "fail");
                return -1;
            }
            else{
                strcpy(buff, "okay");
            }
      }
      printf("%s\n",buff);
      return 0;
}



#if defined(WRITE_TO_NAND_EMMC_ENABLE) || defined(WRITE_TO_NAND_ENABLE)
int ensure_secukey_init(void)
{
	int error = -1;

	if (sInitedSecukey) {
            printf("flash device already inited!!\n");
            return 1;
	}

	printf("should be inited first!\n");

	error = uboot_key_initial("auto");
       if (error >= 0) {
            printf("init key ok!!\n");
            sInitedSecukey = 1;
            return 0;
       }
       else
            printf("init key fail!!\n");

	return -1;
}

static char hex_to_asc(char para)
{
    if (para >= 0 && para <= 9)
        para = para + '0';
    else if(para >= 0xa && para <= 0xf)
        para = para + 'a' - 0xa;

    return para;
}

static char asc_to_hex(char para)
{
    if (para >= '0' && para <= '9')
        para = para - '0';
    else if(para >= 'a' && para <= 'f')
        para = para - 'a' + 0xa;
    else if(para >= 'A' && para <= 'F')
        para = para - 'A' + 0xa;

    return para;
}

/**
  *     cmd_secukey
  *     read: command in *argv[], and read datas saved in buf
  *     return: 0->success, 1->have not writen, -1->failed
  *
  *     write: command in *argv[], and datas length in buf
  *     return: 0->success, -1->failed
  **/
int cmd_secukey(int argc, char *argv[], char *buf)
{
    int i = 0, j = 0, ret = 0, error = -1, secukey_len = 0;
    char *secukey_cmd = NULL, *secukey_name = NULL, *secukey_data = NULL;
    char namebuf[AML_KEY_NAMELEN], databuf[4096], listkey[1024];

    /* at least two arguments please */
    if (argc < 2)
        goto err;

    memset(namebuf, 0, sizeof(namebuf));
    memset(databuf, 0, sizeof(databuf));
    memset(listkey, 0, sizeof(listkey));

    secukey_cmd = (char *)argv[1];
    if (sInitedSecukey) {
        if (argc > 2 && argc < 5) {
            if (!strncmp(secukey_cmd, "read", strlen("read"))) {
                if (argc > 3)
                    goto err;
                ret = uboot_get_keylist(listkey);
                printf("all key names list are(ret=%d):\n%s", ret, listkey);
                secukey_name = (char *)argv[2];
                strncpy(namebuf, secukey_name, strlen(secukey_name));
                error = uboot_key_read(namebuf, databuf);
                if (error >= 0) {    //read success
                    if (strncmp(namebuf, HDCP2KEY_NAME, strlen(HDCP2KEY_NAME)) != 0) {
                        memset(buf, 0, SECUKEY_BYTES);
                        for (i=0,j=0; i<SECUKEY_BYTES*2; i+=2,j++) {
                            buf[j]= (((asc_to_hex(databuf[i]))<<4) | (asc_to_hex(databuf[i+1])));
                        }
                    }
                    else {
                        memset(buf, 0, HDCP2_KEY_TOTAL_LEN);
                        for (i=0,j=0; i<HDCP2_KEY_TOTAL_LEN*2; i+=2,j++) {
                            buf[j]= (((asc_to_hex(databuf[i]))<<4) | (asc_to_hex(databuf[i+1])));
                        }
                    }
                    printf("read ok!!\n");
                    return 0;
                }
                else {                      // read error or have not been writen
                    if (!strncmp(namebuf, "mac_bt", 6) || !strncmp(namebuf, "mac_wifi", 8))
                        ;
                    else if(!strncmp(namebuf, "mac", 3)) {
                        memset(namebuf, 0, sizeof(namebuf));
                        sprintf(namebuf, "%s", "mac\n");
                    }

                    if (strstr(listkey, namebuf)) {
                        printf("find %s, but read error!!\n", namebuf);
                        goto err;       // read error
                    }
                    else {
                        printf("not find %s, and it doesn't be writen before!!\n", namebuf);
                        return 1;       // has been not writen
                    }
                }
            }
            else if(!strncmp(secukey_cmd, "write", strlen("write"))) {
                if (argc != 4)
                    goto err;
                secukey_name = (char *)argv[2];
                secukey_data = (char *)argv[3];
                strncpy(namebuf, secukey_name, strlen(secukey_name));
                secukey_len = (int)((buf[3]<<24)|(buf[2]<<16)|(buf[1]<<8)|(buf[0]));
                printf("write %s key's length is: %d bytes\n", namebuf, secukey_len);
                for (i=0,j=0; i<secukey_len; i++,j++) {
                    databuf[j]= hex_to_asc((secukey_data[i]>>4) & 0x0f);
                    databuf[++j]= hex_to_asc((secukey_data[i]) & 0x0f);
                    //printf("%02x:%02x:", databuf[j-1], databuf[j]);
                }
                error = uboot_key_write(namebuf, databuf);
                if (error >= 0) {
                    printf("write ok!!\n");
                    return 0;
                }
                else {
                    printf("write error!!\n");
                    goto err;
                }
            }
        }
    }
    else {
        printf("flash device uninitialized!!\n");
        goto err;
    }

err:
    return -1;
}
#endif


#if defined(CONFIG_SECURE_STORAGE_BURNED)
int ensure_securestore_key_init(char *seed, int seed_len)
{
    int ret = -1;

    if (sInitedSecurestore) {
        printf("securestore key already inited and seed already writed!!\n");
        return 1;
    }

    printf("start to init securestore key and write seed!!\n");

    ret = securestore_key_init(seed, seed_len);
    if (ret == 0) {
        printf("init securestore key and write seed ok!!\n");
        sInitedSecurestore = 1;
        ret = 0;
    }
    else {
        printf("init securestore key or write seed error\n");
        ret = -1;
    }

    return ret;
}

/**
  *     cmd_securestore
  *     read: command in *argv[], don't allow to read datas
  *     return: 0->success, 1->have not writen, -1->failed
  *
  *     write: command in *argv[], and datas length in buf
  *     return: 0->success, -1->failed
  **/
int cmd_securestore(int argc, char *argv[], char *buf)
{
    int error = -1;
    unsigned int key_status = 0, sstorekey_len = 0;
    char *sstorekey_cmd, *sstorekey_name, *sstorekey_data;
    char name_buf[20], data_buf[4096];

    /* at least two arguments please */
    if (argc < 2)
        goto err;

    memset(name_buf, 0, sizeof(name_buf));
    memset(data_buf, 0, sizeof(data_buf));

    sstorekey_cmd = argv[1];
    if (sInitedSecurestore) {
        if (argc > 2 && argc < 5) {
            if (!strncmp(sstorekey_cmd, "read", strlen("read"))) {
                if (argc > 3)
                    goto err;
                sstorekey_name = argv[2];
                strncpy(name_buf, sstorekey_name, strlen(sstorekey_name));
                error = securestore_key_query(name_buf, &key_status);
                if (!error) {
                    printf("key_status=%d\n", key_status);
                    if (key_status == 0) {             //key has been not writen
                        printf("%s has been not writen!!\n", name_buf);
                        return 1;
                    }
                    else if(key_status == 1) {    //key has been writen
                        printf("%s has been writen!!\n", name_buf);
                        return 0;
                    }
                    else {
                        printf("key_status: %d,reserved\n", key_status);
                        return -1;
                    }
                }
                else {
                    printf("err :%d,%s:%d\n", error, __func__, __LINE__);
                    return -1;
                }
            }
            else if(!strncmp(sstorekey_cmd, "write", strlen("write"))) {
                if (argc != 4)
                    goto err;
                sstorekey_name = argv[2];
                sstorekey_data = argv[3];
                strncpy(name_buf, sstorekey_name, strlen(sstorekey_name));
                sstorekey_len = (int)((buf[3]<<24)|(buf[2]<<16)|(buf[1]<<8)|(buf[0]));
                printf("write %s key's length is: %d\n", name_buf, sstorekey_len);
                error = securestore_key_write(name_buf, sstorekey_data, sstorekey_len, 0);
                if (!error) {
                    if (!securestore_key_query(name_buf, &key_status))
                        printf("after write, query key_status=%d\n", key_status);
                    printf("write %s ok!!\n", name_buf);
                    return 0;
                }
                else {
                    printf("write %s error!!\n", name_buf);
                    goto err;
                }
            }
        }
    }
    else {
        printf("securestore device or securestore key uninitialized!!\n");
        goto err;
    }

err:
    return -1;
}
#endif

char generalDataChange(const char input)
{
	int i;
	char result = 0;

	for (i=0; i<8; i++) {
         if ((input & (1<<i)) != 0)
            result |= (1<<(7-i));
         else
            result &= ~(1<<(7-i));
	}

	return result;
}

void hdcpDataEncryption(const int len, const char *input, char *out)
{
     int i = 0;

     for (i=0; i<len; i++)
         *out++ = generalDataChange(*input++);
}

void hdcpDataDecryption(const int len, const char *input, char *out)
{
     int i = 0;

     for (i=0; i<len; i++)
         *out++ = generalDataChange(*input++);
}
