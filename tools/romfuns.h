#include<stdio.h>
struct romboot_s {
    const char * cpu;
    int (* write)(FILE * spl,FILE * in ,FILE * out);
    int (* write_ex)(FILE * spl,FILE * in ,FILE * out,unsigned addr);
};
/* tools/m1_romboot.c */
int m1_write(FILE *spl, FILE *in, FILE *out);
int a3_write(FILE *spl, FILE *in, FILE *out);
/* tools/m3_romboot.c */
int m3_write(FILE *spl, FILE *in, FILE *out);
int m3_write_ex(FILE *spl, FILE *in, FILE *out,unsigned addr);
/* tools/m6_romboot.c */
int m6_write(FILE *spl, FILE *in, FILE *out);
int m6_write_ex(FILE *spl, FILE *in, FILE *out,unsigned addr);
/* tools/m8_romboot.c */
int m8_write(FILE *spl, FILE *in, FILE *out);
int m8_write_crypto(FILE *spl, FILE *in, FILE *out);
int m8_write_ex(FILE *spl, FILE *in, FILE *out,unsigned addr);
/* tools/m6tvd_romboot.c */
int m6tvd_write(FILE *spl, FILE *in, FILE *out);
int m6tvd_write_ex(FILE *spl, FILE *in, FILE *out,unsigned addr);
int m6tvd_write_crypto(FILE *spl, FILE *in, FILE *out);