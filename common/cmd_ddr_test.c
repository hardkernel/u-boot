#include <common.h>

#include <asm/io.h>
#include <asm/arch/io.h>
#include <asm/arch/register.h>

#define TDATA32F 0xffffffff
#define TDATA32A 0xaaaaaaaa
#define TDATA325 0x55555555

static void ddr_write(void *buff, unsigned m_length)
{
    unsigned *p;
    unsigned i, j, n;
    unsigned m_len = m_length;

    p = (unsigned *)buff;

    while(m_len)
    {
        for(j=0;j<32;j++)
        {
            if(m_len >= 128)
                n = 32;
            else
                n = m_len>>2;

            for(i = 0; i < n; i++)
            {
                switch(i)
                {
                    case 0:
                    case 9:
                    case 14:
                    case 25:
                    case 30:
                        *(p+i) = TDATA32F;
                        break;
                    case 1:
                    case 6:
                    case 8:
                    case 17:
                    case 22:
                        *(p+i) = 0;
                        break;
                    case 16:
                    case 23:
                    case 31:
                        *(p+i) = TDATA32A;
                        break;
                    case 7:
                    case 15:
                    case 24:
                        *(p+i) = TDATA325;
                        break;
                    case 2:
                    case 4:
                    case 10:
                    case 12:
                    case 19:
                    case 21:
                    case 27:
                    case 29:
                        *(p+i) = 1<<j;
                        break;
                    case 3:
                    case 5:
                    case 11:
                    case 13:
                    case 18:
                    case 20:
                    case 26:
                    case 28:
                        *(p+i) = ~(1<<j);
                        break;
                }
            }

            if(m_len > 128)
            {
                m_len -= 128;
                p += 32;
            }
            else
            {
                p += (m_len>>2);
                m_len = 0;
                break;
            }
        }
    }
}

static void ddr_read(void *buff, unsigned m_length)
{
    unsigned *p;
    unsigned i, j, n;
    unsigned m_len = m_length;

    p = (unsigned *)buff;

    while(m_len)
    {
        for(j=0;j<32;j++)
        {
            if(m_len >= 128)
                n = 32;
            else
                n = m_len>>2;

            for(i = 0; i < n; i++)
            {
                switch(i)
                {
                    case 0:
                    case 9:
                    case 14:
                    case 25:
                    case 30:
                        if(*(p+i) != TDATA32F)
                            printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned)(m_length - m_len + i), TDATA32F);
                        break;
                    case 1:
                    case 6:
                    case 8:
                    case 17:
                    case 22:
                        if(*(p+i) != 0)
                            printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned)(m_length - m_len + i), 0);
                        break;
                    case 16:
                    case 23:
                    case 31:
                        if(*(p+i) != TDATA32A)
                            printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned)(m_length - m_len + i), TDATA32A);
                        break;
                    case 7:
                    case 15:
                    case 24:
                        if(*(p+i) != TDATA325)
                            printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned)(m_length - m_len + i), TDATA325);
                        break;
                    case 2:
                    case 4:
                    case 10:
                    case 12:
                    case 19:
                    case 21:
                    case 27:
                    case 29:
                        if(*(p+i) != 1<<j)
                            printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned)(m_length - m_len + i), 1<<j);
                        break;
                    case 3:
                    case 5:
                    case 11:
                    case 13:
                    case 18:
                    case 20:
                    case 26:
                    case 28:
                        if(*(p+i) != ~(1<<j))
                            printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned)(m_length - m_len + i), ~(1<<j));
                        break;
                }
            }

            if(m_len > 128)
            {
                m_len -= 128;
                p += 32;
            }
            else
            {
                p += (m_len>>2);
                m_len = 0;
                break;
            }
        }
    }
}

#define DDR_TEST_START_ADDR CONFIG_SYS_MEMTEST_START
#define DDR_TEST_SIZE 0x2000000

int do_ddr_test(cmd_tbl_t *cmdtp, int flag, int argc, char *argv[])
{
    char *endp;
    unsigned long loop = 1;
    unsigned char lflag = 0;
    unsigned start_addr = DDR_TEST_START_ADDR;

    if(!argc)
        goto DDR_TEST_START;

    if (strcmp(argv[1], "l") == 0){
        lflag = 1;
    }
    else if (strcmp(argv[1], "h") == 0){
        goto usage;
    }
    else{
        loop = simple_strtoul(argv[1], &endp, 10);
        if (*argv[1] == 0 || *endp != 0)
            loop = 1;
    }
    
    if(argc > 2){
        start_addr = simple_strtoul(argv[2], &endp, 16);
        if (*argv[2] == 0 || *endp != 0)
            start_addr = DDR_TEST_START_ADDR;
    }
    
DDR_TEST_START:

    do{
        if(lflag)
            loop = 888;
        printf("\rStart writing at 0x%08x - 0x%08x...", start_addr, start_addr + DDR_TEST_SIZE);
        ddr_write((void *)start_addr, DDR_TEST_SIZE);
	    printf("\rEnd write.                                 ");
	    printf("\rStart 1st reading...                       ");
	    ddr_read((void *)start_addr, DDR_TEST_SIZE);
	    printf("\rEnd 1st read.                              ");
	    printf("\rStart 2nd reading...                       ");
	    ddr_read((void *)start_addr, DDR_TEST_SIZE);
	    printf("\rEnd 2nd read.                              ");
	    printf("\rStart 3rd reading...                       ");
	    ddr_read((void *)start_addr, DDR_TEST_SIZE);
	    printf("\rEnd 3rd read.                              \n");
	  }while(--loop);

	  return 0;

usage:
	cmd_usage(cmdtp);
	return 1;
}

U_BOOT_CMD(
	ddrtest,	5,	1,	do_ddr_test,
	"DDR test function",
	"ddrtest [LOOP] [ADDR].Default address is 0x8d000000\n"
);
