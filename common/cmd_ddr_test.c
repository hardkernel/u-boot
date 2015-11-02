#include <common.h>

#include <asm/io.h>
#include <asm/arch/io.h>
//#include <asm/arch/register.h>
//#include <asm/arch-g9tv/mmc.h>	//jiaxing debug

//extern	void aml_cache_disable(void);

#define TDATA32F 0xffffffff
#define TDATA32A 0xaaaaaaaa
#define TDATA325 0x55555555
unsigned error_count =0;
unsigned error_outof_count_flag=0;

//#define readl(addr)	(*((volatile unsigned *)addr))	//rd_reg(addr)
//#define writel(data ,addr)	(*((volatile unsigned *)addr))=(data)	//wr_reg(addr, data)

//#define wr_reg(addr, data)	(*((volatile unsigned *)addr))=(data)
//#define rd_reg(addr)		(*((volatile unsigned *)addr))



static void ddr_write(void *buff, unsigned m_length)
{
	unsigned *p;
	unsigned i, j, n;
	unsigned m_len = m_length;

	p = (unsigned *)buff;

	while (m_len)
	{
		for (j=0;j<32;j++)
		{
			if (m_len >= 128)
				n = 32;
			else
				n = m_len>>2;

			for (i = 0; i < n; i++)
			{
				switch (i)
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

			if (m_len > 128)
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

	while (m_len)
	{
		for (j=0;j<32;j++)
		{
			if (m_len >= 128)
				n = 32;
			else
				n = m_len>>2;

			for (i = 0; i < n; i++)
			{
				if ((error_outof_count_flag) && (error_count))
				{
				 printf("Error data out of count");
				 m_len=0;
				 break;
				}
				switch (i)
				{
					case 0:
					case 9:
					case 14:
					case 25:
					case 30:
						if (*(p+i) != TDATA32F)
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned)(m_length - m_len + i), TDATA32F);
							}
						break;
					case 1:
					case 6:
					case 8:
					case 17:
					case 22:
						if (*(p+i) != 0) {error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned)(m_length - m_len + i), 0);
						}break;
					case 16:
					case 23:
					case 31:
						if (*(p+i) != TDATA32A) {error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned)(m_length - m_len + i), TDATA32A);
						} break;
					case 7:
					case 15:
					case 24:
						if (*(p+i) != TDATA325) {error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned)(m_length - m_len + i), TDATA325);
						} break;
					case 2:
					case 4:
					case 10:
					case 12:
					case 19:
					case 21:
					case 27:
					case 29:
						if (*(p+i) != 1<<j) {error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned)(m_length - m_len + i), 1<<j);
						} break;
					case 3:
					case 5:
					case 11:
					case 13:
					case 18:
					case 20:
					case 26:
					case 28:
						if (*(p+i) != ~(1<<j)) {error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned)(m_length - m_len + i), ~(1<<j));
						} break;
				}
			}

			if (m_len > 128)
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

///*
#define DDR_PATTERN_LOOP_1 32
#define DDR_PATTERN_LOOP_2 64
#define DDR_PATTERN_LOOP_3 96
static void ddr_write_pattern4_cross_talk_p(void *buff, unsigned m_length)
{
	unsigned *p;
 //	unsigned i, j, n;
	 unsigned i, n;
	unsigned m_len = m_length;
//#define ddr_pattern_loop 32
	p = (unsigned *)buff;

	while (m_len)
	{
		//	for(j=0;j<32;j++)
		{
			if (m_len >= 128*4)
				n = 32*4;
			else
				n = m_len>>2;

			for (i = 0; i < n; i++)
			{
				switch (i)
				{
					case 0:
					case 1:
					case 2:
					case 3:
					case 8:
					case 9:
					case 10:
					case 11:
				case 16:
					case 17:
					case 18:
					case 19:
					case 24:
					case 25:
					case 26:
					case 27:
				 //	case 30:
						*(p+i) = TDATA32F;
						break;
					case 4:
					case 5:
					case 6:
					case 7:
					case 12:
					case 13:
					case 14:
					case 15:
				case 20:
					case 21:
					case 22:
					case 23:
				case 28:
					case 29:
					case 30:
					case 31:
				 //	case 22:
						*(p+i) = 0;
						break;
				case DDR_PATTERN_LOOP_1+0:
					case DDR_PATTERN_LOOP_1+1:
					case DDR_PATTERN_LOOP_1+2:
					case DDR_PATTERN_LOOP_1+3:
					case DDR_PATTERN_LOOP_1+8:
					case DDR_PATTERN_LOOP_1+9:
					case DDR_PATTERN_LOOP_1+10:
					case DDR_PATTERN_LOOP_1+11:
				case DDR_PATTERN_LOOP_1+16:
					case DDR_PATTERN_LOOP_1+17:
					case DDR_PATTERN_LOOP_1+18:
					case DDR_PATTERN_LOOP_1+19:
					case DDR_PATTERN_LOOP_1+24:
					case DDR_PATTERN_LOOP_1+25:
					case DDR_PATTERN_LOOP_1+26:
					case DDR_PATTERN_LOOP_1+27:
				 //	case 30:
							*(p+i) = TDATA32A;
						break;
					case DDR_PATTERN_LOOP_1+4:
					case DDR_PATTERN_LOOP_1+5:
					case DDR_PATTERN_LOOP_1+6:
					case DDR_PATTERN_LOOP_1+7:
					case DDR_PATTERN_LOOP_1+12:
					case DDR_PATTERN_LOOP_1+13:
					case DDR_PATTERN_LOOP_1+14:
					case DDR_PATTERN_LOOP_1+15:
				case DDR_PATTERN_LOOP_1+20:
					case DDR_PATTERN_LOOP_1+21:
					case DDR_PATTERN_LOOP_1+22:
					case DDR_PATTERN_LOOP_1+23:
				case DDR_PATTERN_LOOP_1+28:
					case DDR_PATTERN_LOOP_1+29:
					case DDR_PATTERN_LOOP_1+30:
					case DDR_PATTERN_LOOP_1+31:
				*(p+i) = TDATA325;


						break;
				case DDR_PATTERN_LOOP_2+0:
		 case DDR_PATTERN_LOOP_2+1:
		 case DDR_PATTERN_LOOP_2+2:
		 case DDR_PATTERN_LOOP_2+3:
					*(p+i) =0xfe01fe01;
					break;
				case DDR_PATTERN_LOOP_2+4:
		 case DDR_PATTERN_LOOP_2+5:
		 case DDR_PATTERN_LOOP_2+6:
		 case DDR_PATTERN_LOOP_2+7:
					*(p+i) =0xfd02fd02;
					break;
				case DDR_PATTERN_LOOP_2+8:
		 case DDR_PATTERN_LOOP_2+9:
		 case DDR_PATTERN_LOOP_2+10:
		 case DDR_PATTERN_LOOP_2+11:
					*(p+i) =0xfb04fb04;
					break;
				case DDR_PATTERN_LOOP_2+12:
		 case DDR_PATTERN_LOOP_2+13:
		 case DDR_PATTERN_LOOP_2+14:
		 case DDR_PATTERN_LOOP_2+15:
					*(p+i) =0xf708f708;
					break;
				case DDR_PATTERN_LOOP_2+16:
		 case DDR_PATTERN_LOOP_2+17:
		 case DDR_PATTERN_LOOP_2+18:
		 case DDR_PATTERN_LOOP_2+19:
					*(p+i) =0xef10ef10;
					break;
				case DDR_PATTERN_LOOP_2+20:
		 case DDR_PATTERN_LOOP_2+21:
		 case DDR_PATTERN_LOOP_2+22:
		 case DDR_PATTERN_LOOP_2+23:
					*(p+i) =0xdf20df20;
					break;
				case DDR_PATTERN_LOOP_2+24:
		 case DDR_PATTERN_LOOP_2+25:
		 case DDR_PATTERN_LOOP_2+26:
		 case DDR_PATTERN_LOOP_2+27:
					*(p+i) =0xbf40bf40;
					break;
				case DDR_PATTERN_LOOP_2+28:
		 case DDR_PATTERN_LOOP_2+29:
		 case DDR_PATTERN_LOOP_2+30:
		 case DDR_PATTERN_LOOP_2+31:
					*(p+i) =0x7f807f80;
					break;
				case DDR_PATTERN_LOOP_3+0:
		 case DDR_PATTERN_LOOP_3+1:
		 case DDR_PATTERN_LOOP_3+2:
		 case DDR_PATTERN_LOOP_3+3:
					*(p+i) =0x00000100;
					break;
				case DDR_PATTERN_LOOP_3+4:
		 case DDR_PATTERN_LOOP_3+5:
		 case DDR_PATTERN_LOOP_3+6:
		 case DDR_PATTERN_LOOP_3+7:
					*(p+i) =0x00000200;
					break;
				case DDR_PATTERN_LOOP_3+8:
		 case DDR_PATTERN_LOOP_3+9:
		 case DDR_PATTERN_LOOP_3+10:
		 case DDR_PATTERN_LOOP_3+11:
					*(p+i) =0x00000400;
					break;
				case DDR_PATTERN_LOOP_3+12:
		 case DDR_PATTERN_LOOP_3+13:
		 case DDR_PATTERN_LOOP_3+14:
		 case DDR_PATTERN_LOOP_3+15:
					*(p+i) =0x00000800;
					break;
				case DDR_PATTERN_LOOP_3+16:
		 case DDR_PATTERN_LOOP_3+17:
		 case DDR_PATTERN_LOOP_3+18:
		 case DDR_PATTERN_LOOP_3+19:
					*(p+i) =0x00001000;
					break;
				case DDR_PATTERN_LOOP_3+20:
		 case DDR_PATTERN_LOOP_3+21:
		 case DDR_PATTERN_LOOP_3+22:
		 case DDR_PATTERN_LOOP_3+23:
					*(p+i) =0x00002000;
					break;
				case DDR_PATTERN_LOOP_3+24:
		 case DDR_PATTERN_LOOP_3+25:
		 case DDR_PATTERN_LOOP_3+26:
		 case DDR_PATTERN_LOOP_3+27:
					*(p+i) =0x00004000;
					break;
				case DDR_PATTERN_LOOP_3+28:
		 case DDR_PATTERN_LOOP_3+29:
		 case DDR_PATTERN_LOOP_3+30:
		 case DDR_PATTERN_LOOP_3+31:
					*(p+i) =0x00008000;
					break;


				}
			}

			if (m_len >( 128*4))
			{
				m_len -=( 128*4);
				p += 32*4;
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

static void ddr_write_pattern4_cross_talk_p2(void *buff, unsigned m_length)
{
	unsigned *p;
 //	unsigned i, j, n;
	 unsigned i, n;
	unsigned m_len = m_length;
//#define ddr_pattern_loop 32
	p = (unsigned *)buff;

	while (m_len)
	{
		//	for(j=0;j<32;j++)
		{
			if (m_len >= 128*4)
				n = 32*4;
			else
				n = m_len>>2;

			for (i = 0; i < n; i++)
			{


				switch (i)
				{
					 case 0:
			case DDR_PATTERN_LOOP_1+1:
			case DDR_PATTERN_LOOP_2+2:
			case DDR_PATTERN_LOOP_3+3:
								*(p+i) = 0xfe01fe01;
									break;
					 case 4:
			case DDR_PATTERN_LOOP_1+5:
			case DDR_PATTERN_LOOP_2+6:
			case DDR_PATTERN_LOOP_3+7:
							*(p+i) = 0xfd02fd02;
									 break;

					 case 8:
			case DDR_PATTERN_LOOP_1+9:
			case DDR_PATTERN_LOOP_2+10:
			case DDR_PATTERN_LOOP_3+11:
							*(p+i) = 0xfb04fb04;
						break;

					 case 12:
			case DDR_PATTERN_LOOP_1+13:
			case DDR_PATTERN_LOOP_2+14:
			case DDR_PATTERN_LOOP_3+15:
							*(p+i) = 0xf708f708;
						break;

					 case 16:
			case DDR_PATTERN_LOOP_1+17:
			case DDR_PATTERN_LOOP_2+18:
			case DDR_PATTERN_LOOP_3+19:
							*(p+i) = 0xef10ef10;
						break;

					 case 20:
			case DDR_PATTERN_LOOP_1+21:
			case DDR_PATTERN_LOOP_2+22:
			case DDR_PATTERN_LOOP_3+23:
							*(p+i) = 0xdf20df20;
						break;

					 case 24:
			case DDR_PATTERN_LOOP_1+25:
			case DDR_PATTERN_LOOP_2+26:
			case DDR_PATTERN_LOOP_3+27:
							*(p+i) = 0xbf40bf40;
			 break;

						case 28:
			case DDR_PATTERN_LOOP_1+29:
			case DDR_PATTERN_LOOP_2+30:
			case DDR_PATTERN_LOOP_3+31:
							*(p+i) = 0x7f807f80;
						break;


				default:

							*(p+i) = 0xff00ff00;
						break;

						break;


				}
			}

			if (m_len >( 128*4))
			{
				m_len -=( 128*4);
				p += 32*4;
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
static void ddr_read_pattern4_cross_talk_p(void *buff, unsigned m_length)
{
	unsigned *p;
	//	unsigned i, j, n;
	 unsigned i, n;
	unsigned m_len = m_length;

	p = (unsigned *)buff;

	while (m_len)
	{
		//	for(j=0;j<32;j++)
		{
			if (m_len >= 128*4)
				n = 32*4;
			else
				n = m_len>>2;

			for (i = 0; i < n; i++)
			{
			if ((error_outof_count_flag) && (error_count))
				{
				 printf("Error data out of count");
				 m_len=0;
				 break;
				}

				switch (i)
				{
					 case 0:
					case 1:
					case 2:
					case 3:
					case 8:
					case 9:
					case 10:
					case 11:
				case 16:
					case 17:
					case 18:
					case 19:
					case 24:
					case 25:
					case 26:
					case 27:
				 //	case 30:
					//		*(p+i) = TDATA32F;
						if (*(p+i) != TDATA32F)
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), TDATA32F);
													break;
							}
						 break;
					 case 4:
					case 5:
					case 6:
					case 7:
					case 12:
					case 13:
					case 14:
					case 15:
				case 20:
					case 21:
					case 22:
					case 23:
				case 28:
					case 29:
					case 30:
					case 31:
				 //	case 22:
					 //	*(p+i) = 0;
						if (*(p+i) != 0)
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), 0);
						break;}
						 break;
					case DDR_PATTERN_LOOP_1+0:
					case DDR_PATTERN_LOOP_1+1:
					case DDR_PATTERN_LOOP_1+2:
					case DDR_PATTERN_LOOP_1+3:
					case DDR_PATTERN_LOOP_1+8:
					case DDR_PATTERN_LOOP_1+9:
					case DDR_PATTERN_LOOP_1+10:
					case DDR_PATTERN_LOOP_1+11:
				case DDR_PATTERN_LOOP_1+16:
					case DDR_PATTERN_LOOP_1+17:
					case DDR_PATTERN_LOOP_1+18:
					case DDR_PATTERN_LOOP_1+19:
					case DDR_PATTERN_LOOP_1+24:
					case DDR_PATTERN_LOOP_1+25:
					case DDR_PATTERN_LOOP_1+26:
					case DDR_PATTERN_LOOP_1+27:
				 //	case 30:
					//		*(p+i) = TDATA32A;
						if (*(p+i) != TDATA32A)
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), TDATA32A);
						break;
							}
						 break;
						case DDR_PATTERN_LOOP_1+4:
					case DDR_PATTERN_LOOP_1+5:
					case DDR_PATTERN_LOOP_1+6:
					case DDR_PATTERN_LOOP_1+7:
					case DDR_PATTERN_LOOP_1+12:
					case DDR_PATTERN_LOOP_1+13:
					case DDR_PATTERN_LOOP_1+14:
					case DDR_PATTERN_LOOP_1+15:
				case DDR_PATTERN_LOOP_1+20:
					case DDR_PATTERN_LOOP_1+21:
					case DDR_PATTERN_LOOP_1+22:
					case DDR_PATTERN_LOOP_1+23:
				case DDR_PATTERN_LOOP_1+28:
					case DDR_PATTERN_LOOP_1+29:
					case DDR_PATTERN_LOOP_1+30:
					case DDR_PATTERN_LOOP_1+31:
			//	*(p+i) = TDATA325;
						if (*(p+i) != TDATA325)
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), TDATA325);
						break;
							}
						 break;
					 case DDR_PATTERN_LOOP_2+0:
		 case DDR_PATTERN_LOOP_2+1:
		 case DDR_PATTERN_LOOP_2+2:
		 case DDR_PATTERN_LOOP_2+3:
			//		*(p+i) =0xfe01fe01;
						if (*(p+i) !=0xfe01fe01)
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), 0xfe01fe01);
						break;
							}
						 break;
					case DDR_PATTERN_LOOP_2+4:
		 case DDR_PATTERN_LOOP_2+5:
		 case DDR_PATTERN_LOOP_2+6:
		 case DDR_PATTERN_LOOP_2+7:
				// 	*(p+i) =0xfd02fd02;
						if (*(p+i) != 0xfd02fd02)
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), 0xfd02fd02);
						break;
							}
						 break;
				case DDR_PATTERN_LOOP_2+8:
		 case DDR_PATTERN_LOOP_2+9:
		 case DDR_PATTERN_LOOP_2+10:
		 case DDR_PATTERN_LOOP_2+11:
				//	*(p+i) =0xfb04fb04;
				 if (*(p+i) != 0xfb04fb04)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), 0xfb04fb04);
					break;
					}
					break;
				case DDR_PATTERN_LOOP_2+12:
		 case DDR_PATTERN_LOOP_2+13:
		 case DDR_PATTERN_LOOP_2+14:
		 case DDR_PATTERN_LOOP_2+15:
				//	*(p+i) =0xf7b08f708;
					if (*(p+i) != 0xf708f708)
						{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), 0xf708f708);
					break;
						}
					break;
				case DDR_PATTERN_LOOP_2+16:
		 case DDR_PATTERN_LOOP_2+17:
		 case DDR_PATTERN_LOOP_2+18:
		 case DDR_PATTERN_LOOP_2+19:
				//	*(p+i) =0xef10ef10;
					if (*(p+i) != 0xef10ef10)
						{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), 0xef10ef10);
					break;
						}
					break;
				case DDR_PATTERN_LOOP_2+20:
		 case DDR_PATTERN_LOOP_2+21:
		 case DDR_PATTERN_LOOP_2+22:
		 case DDR_PATTERN_LOOP_2+23:
				//	*(p+i) =0xdf20df20;
					if (*(p+i) != 0xdf20df20)
						{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), 0xdf20df20);
					break;
						}
					break;
				case DDR_PATTERN_LOOP_2+24:
		 case DDR_PATTERN_LOOP_2+25:
		 case DDR_PATTERN_LOOP_2+26:
		 case DDR_PATTERN_LOOP_2+27:
			 //		*(p+i) =0xbf40bf40;
					if (*(p+i) != 0xbf40bf40)
						{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), 0xbf40bf40);
					break;
						}
					break;
				case DDR_PATTERN_LOOP_2+28:
		 case DDR_PATTERN_LOOP_2+29:
		 case DDR_PATTERN_LOOP_2+30:
		 case DDR_PATTERN_LOOP_2+31:
			//		*(p+i) =0x7f807f80;
					if (*(p+i) != 0x7f807f80)
						{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), 0x7f807f80);
					break;

						}
					break;
				case DDR_PATTERN_LOOP_3+0:
		 case DDR_PATTERN_LOOP_3+1:
		 case DDR_PATTERN_LOOP_3+2:
		 case DDR_PATTERN_LOOP_3+3:
				//	*(p+i) =0x00000100;
						if (*(p+i) != 0x00000100)
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), 0x00000100);
					break;
							}
						break;
				case DDR_PATTERN_LOOP_3+4:
		 case DDR_PATTERN_LOOP_3+5:
		 case DDR_PATTERN_LOOP_3+6:
		 case DDR_PATTERN_LOOP_3+7:
			 //		*(p+i) =0x00000100;
					if (*(p+i) != 0x00000200)
						{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), 0x00000200);
					break;
						}
					break;
				case DDR_PATTERN_LOOP_3+8:
		 case DDR_PATTERN_LOOP_3+9:
		 case DDR_PATTERN_LOOP_3+10:
		 case DDR_PATTERN_LOOP_3+11:
				//	*(p+i) =0x00000100;
				 if (*(p+i) != 0x00000400)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), 0x00000400);
					break;
					}
					break;
				case DDR_PATTERN_LOOP_3+12:
		 case DDR_PATTERN_LOOP_3+13:
		 case DDR_PATTERN_LOOP_3+14:
		 case DDR_PATTERN_LOOP_3+15:
				//	*(p+i) =0x00000100;
				 if (*(p+i) != 0x00000800)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), 0x00000800);
					break;
					}
					break;
				case DDR_PATTERN_LOOP_3+16:
		 case DDR_PATTERN_LOOP_3+17:
		 case DDR_PATTERN_LOOP_3+18:
		 case DDR_PATTERN_LOOP_3+19:
				//	*(p+i) =0xfffffeff;
				 if (*(p+i) != 0x00001000)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), 0x00001000);
					break;
					}
					break;
				case DDR_PATTERN_LOOP_3+20:
		 case DDR_PATTERN_LOOP_3+21:
		 case DDR_PATTERN_LOOP_3+22:
		 case DDR_PATTERN_LOOP_3+23:
				// 	*(p+i) =0xfffffeff;
				 if (*(p+i) != 0x00002000)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), 0x00002000);

					} break;
				case DDR_PATTERN_LOOP_3+24:
		 case DDR_PATTERN_LOOP_3+25:
		 case DDR_PATTERN_LOOP_3+26:
		 case DDR_PATTERN_LOOP_3+27:
				//	*(p+i) =0xfffffeff;
				 if (*(p+i) != 0x00004000)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), 0x00004000);
					break;
					}
					break;
				case DDR_PATTERN_LOOP_3+28:
		 case DDR_PATTERN_LOOP_3+29:
		 case DDR_PATTERN_LOOP_3+30:
		 case DDR_PATTERN_LOOP_3+31:
				//	*(p+i) =0xfffffeff;
				 if (*(p+i) != 0x00008000)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), 0x00008000);
					break;
					}
					break;



				}
			}

			if (m_len > 128*4)
			{
				m_len -= 128*4;
				p += 32*4;
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
//*/
static void ddr_read_pattern4_cross_talk_p2(void *buff, unsigned m_length)
{
	unsigned *p;
	//	unsigned i, j, n;
	 unsigned i, n;
	unsigned m_len = m_length;

	p = (unsigned *)buff;

	while (m_len)
	{
		//	for(j=0;j<32;j++)
		{
			if (m_len >= 128*4)
				n = 32*4;
			else
				n = m_len>>2;

			for (i = 0; i < n; i++)
			{
			if ((error_outof_count_flag) && (error_count))
				{
				 printf("Error data out of count");
				 m_len=0;
				 break;
				}

				switch (i)
				{
					 case 0:
			case DDR_PATTERN_LOOP_1+1:
			case DDR_PATTERN_LOOP_2+2:
			case DDR_PATTERN_LOOP_3+3:
							//	*(p+i) = 0xfe01fe01;
								if (*(p+i) != 0xfe01fe01)
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), 0xfe01fe01);
													break;
							}
									break;
					 case 4:
			case DDR_PATTERN_LOOP_1+5:
			case DDR_PATTERN_LOOP_2+6:
			case DDR_PATTERN_LOOP_3+7:
					//		*(p+i) = 0xfd02fd02;
								if (*(p+i) != 0xfd02fd02)
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), 0xfd02fd02);
													break;
							}
									 break;

					 case 8:
			case DDR_PATTERN_LOOP_1+9:
			case DDR_PATTERN_LOOP_2+10:
			case DDR_PATTERN_LOOP_3+11:
						//	*(p+i) = 0xfb04fb04;
								if (*(p+i) != 0xfb04fb04)
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), 0xfb04fb04);
													break;
							}
						break;

					 case 12:
			case DDR_PATTERN_LOOP_1+13:
			case DDR_PATTERN_LOOP_2+14:
			case DDR_PATTERN_LOOP_3+15:
					//		*(p+i) = 0xf708f708;
								if (*(p+i) != 0xf708f708)
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), 0xf708f708);
													break;
							}
						break;

					 case 16:
			case DDR_PATTERN_LOOP_1+17:
			case DDR_PATTERN_LOOP_2+18:
			case DDR_PATTERN_LOOP_3+19:
					//		*(p+i) = 0xef10ef10;
								if (*(p+i) != 0xef10ef10)
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), 0xef10ef10);
													break;
							}
						break;

					 case 20:
			case DDR_PATTERN_LOOP_1+21:
			case DDR_PATTERN_LOOP_2+22:
			case DDR_PATTERN_LOOP_3+23:
						//	*(p+i) = 0xdf20df20;
								if (*(p+i) != 0xdf20df20)
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), 0xdf20df20);
													break;
							}
						break;

					 case 24:
			case DDR_PATTERN_LOOP_1+25:
			case DDR_PATTERN_LOOP_2+26:
			case DDR_PATTERN_LOOP_3+27:
					//		*(p+i) = 0xbf40bf40;
								if (*(p+i) != 0xbf40bf40)
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), 0xbf40bf40);
													break;
							}
													break;
						case 28:
			case DDR_PATTERN_LOOP_1+29:
			case DDR_PATTERN_LOOP_2+30:
			case DDR_PATTERN_LOOP_3+31:
					//		*(p+i) = 0x7f807f80;
								if (*(p+i) != 0x7f807f80)
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), 0x7f807f80);
													break;
							}
						break;


				default:

						//	*(p+i) = 0xff00ff00;
							 if (*(p+i) != 0xff00ff00)
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), 0xff00ff00);
													break;
							}
						break;

						break;


				}
			}

			if (m_len > 128*4)
			{
				m_len -= 128*4;
				p += 32*4;
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

static void ddr_write_pattern4_cross_talk_n(void *buff, unsigned m_length)
{
	unsigned *p;
 //	unsigned i, j, n;
	 unsigned i, n;
	unsigned m_len = m_length;
//#define ddr_pattern_loop 32
	p = (unsigned *)buff;

	while (m_len)
	{
		//	for(j=0;j<32;j++)
		{
			if (m_len >= 128*4)
				n = 32*4;
			else
				n = m_len>>2;

			for (i = 0; i < n; i++)
			{
				switch (i)
				{
					case 0:
					case 1:
					case 2:
					case 3:
					case 8:
					case 9:
					case 10:
					case 11:
				case 16:
					case 17:
					case 18:
					case 19:
					case 24:
					case 25:
					case 26:
					case 27:
				 //	case 30:
						*(p+i) = ~TDATA32F;
						break;
					case 4:
					case 5:
					case 6:
					case 7:
					case 12:
					case 13:
					case 14:
					case 15:
				case 20:
					case 21:
					case 22:
					case 23:
				case 28:
					case 29:
					case 30:
					case 31:
				 //	case 22:
						*(p+i) = ~0;
						break;
				case DDR_PATTERN_LOOP_1+0:
					case DDR_PATTERN_LOOP_1+1:
					case DDR_PATTERN_LOOP_1+2:
					case DDR_PATTERN_LOOP_1+3:
					case DDR_PATTERN_LOOP_1+8:
					case DDR_PATTERN_LOOP_1+9:
					case DDR_PATTERN_LOOP_1+10:
					case DDR_PATTERN_LOOP_1+11:
				case DDR_PATTERN_LOOP_1+16:
					case DDR_PATTERN_LOOP_1+17:
					case DDR_PATTERN_LOOP_1+18:
					case DDR_PATTERN_LOOP_1+19:
					case DDR_PATTERN_LOOP_1+24:
					case DDR_PATTERN_LOOP_1+25:
					case DDR_PATTERN_LOOP_1+26:
					case DDR_PATTERN_LOOP_1+27:
				 //	case 30:
							*(p+i) = ~TDATA32A;
						break;
					case DDR_PATTERN_LOOP_1+4:
					case DDR_PATTERN_LOOP_1+5:
					case DDR_PATTERN_LOOP_1+6:
					case DDR_PATTERN_LOOP_1+7:
					case DDR_PATTERN_LOOP_1+12:
					case DDR_PATTERN_LOOP_1+13:
					case DDR_PATTERN_LOOP_1+14:
					case DDR_PATTERN_LOOP_1+15:
				case DDR_PATTERN_LOOP_1+20:
					case DDR_PATTERN_LOOP_1+21:
					case DDR_PATTERN_LOOP_1+22:
					case DDR_PATTERN_LOOP_1+23:
				case DDR_PATTERN_LOOP_1+28:
					case DDR_PATTERN_LOOP_1+29:
					case DDR_PATTERN_LOOP_1+30:
					case DDR_PATTERN_LOOP_1+31:
				*(p+i) =~TDATA325;


						break;
				case DDR_PATTERN_LOOP_2+0:
		 case DDR_PATTERN_LOOP_2+1:
		 case DDR_PATTERN_LOOP_2+2:
		 case DDR_PATTERN_LOOP_2+3:
					*(p+i) =~0xfe01fe01;
					break;
				case DDR_PATTERN_LOOP_2+4:
		 case DDR_PATTERN_LOOP_2+5:
		 case DDR_PATTERN_LOOP_2+6:
		 case DDR_PATTERN_LOOP_2+7:
					*(p+i) =~0xfd02fd02;
					break;
				case DDR_PATTERN_LOOP_2+8:
		 case DDR_PATTERN_LOOP_2+9:
		 case DDR_PATTERN_LOOP_2+10:
		 case DDR_PATTERN_LOOP_2+11:
					*(p+i) =~0xfb04fb04;
					break;
				case DDR_PATTERN_LOOP_2+12:
		 case DDR_PATTERN_LOOP_2+13:
		 case DDR_PATTERN_LOOP_2+14:
		 case DDR_PATTERN_LOOP_2+15:
					*(p+i) =~0xf708f708;
					break;
				case DDR_PATTERN_LOOP_2+16:
		 case DDR_PATTERN_LOOP_2+17:
		 case DDR_PATTERN_LOOP_2+18:
		 case DDR_PATTERN_LOOP_2+19:
					*(p+i) =~0xef10ef10;
					break;
				case DDR_PATTERN_LOOP_2+20:
		 case DDR_PATTERN_LOOP_2+21:
		 case DDR_PATTERN_LOOP_2+22:
		 case DDR_PATTERN_LOOP_2+23:
					*(p+i) =~0xdf20df20;
					break;
				case DDR_PATTERN_LOOP_2+24:
		 case DDR_PATTERN_LOOP_2+25:
		 case DDR_PATTERN_LOOP_2+26:
		 case DDR_PATTERN_LOOP_2+27:
					*(p+i) =~0xbf40bf40;
					break;
				case DDR_PATTERN_LOOP_2+28:
		 case DDR_PATTERN_LOOP_2+29:
		 case DDR_PATTERN_LOOP_2+30:
		 case DDR_PATTERN_LOOP_2+31:
					*(p+i) =~0x7f807f80;
					break;
				case DDR_PATTERN_LOOP_3+0:
		 case DDR_PATTERN_LOOP_3+1:
		 case DDR_PATTERN_LOOP_3+2:
		 case DDR_PATTERN_LOOP_3+3:
					*(p+i) =~0x00000100;
					break;
				case DDR_PATTERN_LOOP_3+4:
		 case DDR_PATTERN_LOOP_3+5:
		 case DDR_PATTERN_LOOP_3+6:
		 case DDR_PATTERN_LOOP_3+7:
					*(p+i) =~0x00000200;
					break;
				case DDR_PATTERN_LOOP_3+8:
		 case DDR_PATTERN_LOOP_3+9:
		 case DDR_PATTERN_LOOP_3+10:
		 case DDR_PATTERN_LOOP_3+11:
					*(p+i) =~0x00000400;
					break;
				case DDR_PATTERN_LOOP_3+12:
		 case DDR_PATTERN_LOOP_3+13:
		 case DDR_PATTERN_LOOP_3+14:
		 case DDR_PATTERN_LOOP_3+15:
					*(p+i) =~0x00000800;
					break;
				case DDR_PATTERN_LOOP_3+16:
		 case DDR_PATTERN_LOOP_3+17:
		 case DDR_PATTERN_LOOP_3+18:
		 case DDR_PATTERN_LOOP_3+19:
					*(p+i) =~0x00001000;
					break;
				case DDR_PATTERN_LOOP_3+20:
		 case DDR_PATTERN_LOOP_3+21:
		 case DDR_PATTERN_LOOP_3+22:
		 case DDR_PATTERN_LOOP_3+23:
					*(p+i) =~0x00002000;
					break;
				case DDR_PATTERN_LOOP_3+24:
		 case DDR_PATTERN_LOOP_3+25:
		 case DDR_PATTERN_LOOP_3+26:
		 case DDR_PATTERN_LOOP_3+27:
					*(p+i) =~0x00004000;
					break;
				case DDR_PATTERN_LOOP_3+28:
		 case DDR_PATTERN_LOOP_3+29:
		 case DDR_PATTERN_LOOP_3+30:
		 case DDR_PATTERN_LOOP_3+31:
					*(p+i) =~0x00008000;
					break;


				}
			}

			if (m_len >( 128*4))
			{
				m_len -=( 128*4);
				p += 32*4;
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


static void ddr_write_pattern4_cross_talk_n2(void *buff, unsigned m_length)
{
	unsigned *p;
 //	unsigned i, j, n;
	 unsigned i, n;
	unsigned m_len = m_length;
//#define ddr_pattern_loop 32
	p = (unsigned *)buff;

	while (m_len)
	{
		//	for(j=0;j<32;j++)
		{
			if (m_len >= 128*4)
				n = 32*4;
			else
				n = m_len>>2;

			for (i = 0; i < n; i++)
			{


				switch (i)
				{
					 case 0:
			case DDR_PATTERN_LOOP_1+1:
			case DDR_PATTERN_LOOP_2+2:
			case DDR_PATTERN_LOOP_3+3:
								*(p+i) = ~0xfe01fe01;
									break;
					 case 4:
			case DDR_PATTERN_LOOP_1+5:
			case DDR_PATTERN_LOOP_2+6:
			case DDR_PATTERN_LOOP_3+7:
							*(p+i) = ~0xfd02fd02;
									 break;

					 case 8:
			case DDR_PATTERN_LOOP_1+9:
			case DDR_PATTERN_LOOP_2+10:
			case DDR_PATTERN_LOOP_3+11:
							*(p+i) = ~0xfb04fb04;
						break;

					 case 12:
			case DDR_PATTERN_LOOP_1+13:
			case DDR_PATTERN_LOOP_2+14:
			case DDR_PATTERN_LOOP_3+15:
							*(p+i) = ~0xf708f708;
						break;

					 case 16:
			case DDR_PATTERN_LOOP_1+17:
			case DDR_PATTERN_LOOP_2+18:
			case DDR_PATTERN_LOOP_3+19:
							*(p+i) = ~0xef10ef10;
						break;

					 case 20:
			case DDR_PATTERN_LOOP_1+21:
			case DDR_PATTERN_LOOP_2+22:
			case DDR_PATTERN_LOOP_3+23:
							*(p+i) = ~0xdf20df20;
						break;

					 case 24:
			case DDR_PATTERN_LOOP_1+25:
			case DDR_PATTERN_LOOP_2+26:
			case DDR_PATTERN_LOOP_3+27:
							*(p+i) =~0xbf40bf40;
								break;
						case 28:
			case DDR_PATTERN_LOOP_1+29:
			case DDR_PATTERN_LOOP_2+30:
			case DDR_PATTERN_LOOP_3+31:
							*(p+i) = ~0x7f807f80;
						break;


				default:

							*(p+i) = ~0xff00ff00;
						break;

						break;


				}
			}

			if (m_len >( 128*4))
			{
				m_len -=( 128*4);
				p += 32*4;
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

static void ddr_read_pattern4_cross_talk_n(void *buff, unsigned m_length)
{
	unsigned *p;
	//	unsigned i, j, n;
	 unsigned i, n;
	unsigned m_len = m_length;

	p = (unsigned *)buff;

	while (m_len)
	{
		//	for(j=0;j<32;j++)
		{
			if (m_len >= 128*4)
				n = 32*4;
			else
				n = m_len>>2;

			for (i = 0; i < n; i++)
			{
				if ((error_outof_count_flag) && (error_count))
				{
				 printf("Error data out of count");
				 m_len=0;
					break;
				}
				switch (i)
				{
					 case 0:
					case 1:
					case 2:
					case 3:
					case 8:
					case 9:
					case 10:
					case 11:
				case 16:
					case 17:
					case 18:
					case 19:
					case 24:
					case 25:
					case 26:
					case 27:
				 //	case 30:
					//		*(p+i) = TDATA32F;
						if (*(p+i) !=~TDATA32F)
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), ~TDATA32F);
						break;
							}
						 break;
					 case 4:
					case 5:
					case 6:
					case 7:
					case 12:
					case 13:
					case 14:
					case 15:
				case 20:
					case 21:
					case 22:
					case 23:
				case 28:
					case 29:
					case 30:
					case 31:
				 //	case 22:
					 //	*(p+i) = 0;
						if (*(p+i) !=~0)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), ~0);
							}
						break;
					case DDR_PATTERN_LOOP_1+0:
					case DDR_PATTERN_LOOP_1+1:
					case DDR_PATTERN_LOOP_1+2:
					case DDR_PATTERN_LOOP_1+3:
					case DDR_PATTERN_LOOP_1+8:
					case DDR_PATTERN_LOOP_1+9:
					case DDR_PATTERN_LOOP_1+10:
					case DDR_PATTERN_LOOP_1+11:
				case DDR_PATTERN_LOOP_1+16:
					case DDR_PATTERN_LOOP_1+17:
					case DDR_PATTERN_LOOP_1+18:
					case DDR_PATTERN_LOOP_1+19:
					case DDR_PATTERN_LOOP_1+24:
					case DDR_PATTERN_LOOP_1+25:
					case DDR_PATTERN_LOOP_1+26:
					case DDR_PATTERN_LOOP_1+27:
				 //	case 30:
					//		*(p+i) = TDATA32A;
						if (*(p+i) != ~TDATA32A)
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i),~TDATA32A);
							}
						break;
						case DDR_PATTERN_LOOP_1+4:
					case DDR_PATTERN_LOOP_1+5:
					case DDR_PATTERN_LOOP_1+6:
					case DDR_PATTERN_LOOP_1+7:
					case DDR_PATTERN_LOOP_1+12:
					case DDR_PATTERN_LOOP_1+13:
					case DDR_PATTERN_LOOP_1+14:
					case DDR_PATTERN_LOOP_1+15:
				case DDR_PATTERN_LOOP_1+20:
					case DDR_PATTERN_LOOP_1+21:
					case DDR_PATTERN_LOOP_1+22:
					case DDR_PATTERN_LOOP_1+23:
				case DDR_PATTERN_LOOP_1+28:
					case DDR_PATTERN_LOOP_1+29:
					case DDR_PATTERN_LOOP_1+30:
					case DDR_PATTERN_LOOP_1+31:
			//	*(p+i) = TDATA325;
						if (*(p+i) != ~TDATA325)
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), ~TDATA325);
							}
						break;
					 case DDR_PATTERN_LOOP_2+0:
		 case DDR_PATTERN_LOOP_2+1:
		 case DDR_PATTERN_LOOP_2+2:
		 case DDR_PATTERN_LOOP_2+3:
			//		*(p+i) =0xfe01fe01;
						if (*(p+i) !=~0xfe01fe01)
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), ~0xfe01fe01);
							}
						break;
					case DDR_PATTERN_LOOP_2+4:
		 case DDR_PATTERN_LOOP_2+5:
		 case DDR_PATTERN_LOOP_2+6:
		 case DDR_PATTERN_LOOP_2+7:
				// 	*(p+i) =0xfd02fd02;
						if (*(p+i) != ~0xfd02fd02)
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), ~0xfd02fd02);
							}
						break;

				case DDR_PATTERN_LOOP_2+8:
		 case DDR_PATTERN_LOOP_2+9:
		 case DDR_PATTERN_LOOP_2+10:
		 case DDR_PATTERN_LOOP_2+11:
				//	*(p+i) =0xfb04fb04;
				 if (*(p+i) != ~0xfb04fb04)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), ~0xfb04fb04);
					}
					break;
				case DDR_PATTERN_LOOP_2+12:
		 case DDR_PATTERN_LOOP_2+13:
		 case DDR_PATTERN_LOOP_2+14:
		 case DDR_PATTERN_LOOP_2+15:
				//	*(p+i) =0xf7b08f708;
					if (*(p+i) != ~0xf708f708)
						{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), ~0xf708f708);
						}
					break;
				case DDR_PATTERN_LOOP_2+16:
		 case DDR_PATTERN_LOOP_2+17:
		 case DDR_PATTERN_LOOP_2+18:
		 case DDR_PATTERN_LOOP_2+19:
				//	*(p+i) =0xef10ef10;
					if (*(p+i) != ~0xef10ef10)
						{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), ~0xef10ef10);
						}
					break;
				case DDR_PATTERN_LOOP_2+20:
		 case DDR_PATTERN_LOOP_2+21:
		 case DDR_PATTERN_LOOP_2+22:
		 case DDR_PATTERN_LOOP_2+23:
				//	*(p+i) =0xdf20df20;
					if (*(p+i) != ~0xdf20df20)
						{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), ~0xdf20df20);
						}
					break;
				case DDR_PATTERN_LOOP_2+24:
		 case DDR_PATTERN_LOOP_2+25:
		 case DDR_PATTERN_LOOP_2+26:
		 case DDR_PATTERN_LOOP_2+27:
			 //		*(p+i) =0xbf40bf40;
					if (*(p+i) != ~0xbf40bf40)
						{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), ~0xbf40bf40);
						}
					break;
				case DDR_PATTERN_LOOP_2+28:
		 case DDR_PATTERN_LOOP_2+29:
		 case DDR_PATTERN_LOOP_2+30:
		 case DDR_PATTERN_LOOP_2+31:
			//		*(p+i) =0x7f807f80;
					if (*(p+i) != ~0x7f807f80)
						{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), ~0x7f807f80);
						}
					break;
					break;
				case DDR_PATTERN_LOOP_3+0:
		 case DDR_PATTERN_LOOP_3+1:
		 case DDR_PATTERN_LOOP_3+2:
		 case DDR_PATTERN_LOOP_3+3:
				//	*(p+i) =0x00000100;
						if (*(p+i) != ~0x00000100)
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), ~0x00000100);
							}
					break;
				case DDR_PATTERN_LOOP_3+4:
		 case DDR_PATTERN_LOOP_3+5:
		 case DDR_PATTERN_LOOP_3+6:
		 case DDR_PATTERN_LOOP_3+7:
			 //		*(p+i) =0x00000100;
					if (*(p+i) != ~0x00000200)
						{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), ~0x00000200);
						}
					break;
				case DDR_PATTERN_LOOP_3+8:
		 case DDR_PATTERN_LOOP_3+9:
		 case DDR_PATTERN_LOOP_3+10:
		 case DDR_PATTERN_LOOP_3+11:
				//	*(p+i) =0x00000100;
				 if (*(p+i) != ~0x00000400)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), ~0x00000400);
					}
					break;
				case DDR_PATTERN_LOOP_3+12:
		 case DDR_PATTERN_LOOP_3+13:
		 case DDR_PATTERN_LOOP_3+14:
		 case DDR_PATTERN_LOOP_3+15:
				//	*(p+i) =0x00000100;
				 if (*(p+i) != ~0x00000800)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), ~0x00000800);
					}
					break;
				case DDR_PATTERN_LOOP_3+16:
		 case DDR_PATTERN_LOOP_3+17:
		 case DDR_PATTERN_LOOP_3+18:
		 case DDR_PATTERN_LOOP_3+19:
				//	*(p+i) =0xfffffeff;
				 if (*(p+i) != ~0x00001000)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), ~0x00001000);
					}
					break;
				case DDR_PATTERN_LOOP_3+20:
		 case DDR_PATTERN_LOOP_3+21:
		 case DDR_PATTERN_LOOP_3+22:
		 case DDR_PATTERN_LOOP_3+23:
				// 	*(p+i) =0xfffffeff;
				 if (*(p+i) != ~0x00002000)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), ~0x00002000);
					}
					break;
				case DDR_PATTERN_LOOP_3+24:
		 case DDR_PATTERN_LOOP_3+25:
		 case DDR_PATTERN_LOOP_3+26:
		 case DDR_PATTERN_LOOP_3+27:
				//	*(p+i) =0xfffffeff;
				 if (*(p+i) != ~0x00004000)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), ~0x00004000);
					}
					break;
				case DDR_PATTERN_LOOP_3+28:
		 case DDR_PATTERN_LOOP_3+29:
		 case DDR_PATTERN_LOOP_3+30:
		 case DDR_PATTERN_LOOP_3+31:
				//	*(p+i) =0xfffffeff;
				 if (*(p+i) != ~0x00008000)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), ~0x00008000);
					}
					break;



				}
			}

			if (m_len > 128*4)
			{
				m_len -= 128*4;
				p += 32*4;
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


//*/
static void ddr_read_pattern4_cross_talk_n2(void *buff, unsigned m_length)
{
	unsigned *p;
	//	unsigned i, j, n;
	 unsigned i, n;
	unsigned m_len = m_length;

	p = (unsigned *)buff;

	while (m_len)
	{
		//	for(j=0;j<32;j++)
		{
			if (m_len >= 128*4)
				n = 32*4;
			else
				n = m_len>>2;

			for (i = 0; i < n; i++)
			{
			if ((error_outof_count_flag) && (error_count))
				{
				 printf("Error data out of count");
				 m_len=0;
				 break;
				}

				switch (i)
				{
					 case 0:
			case DDR_PATTERN_LOOP_1+1:
			case DDR_PATTERN_LOOP_2+2:
			case DDR_PATTERN_LOOP_3+3:
							//	*(p+i) = 0xfe01fe01;
								if (*(p+i) != ~0xfe01fe01)
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), ~0xfe01fe01);
													break;
							}
									break;
					 case 4:
			case DDR_PATTERN_LOOP_1+5:
			case DDR_PATTERN_LOOP_2+6:
			case DDR_PATTERN_LOOP_3+7:
					//		*(p+i) = 0xfd02fd02;
								if (*(p+i) != ~0xfd02fd02)
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), ~0xfd02fd02);
													break;
							}
									 break;

					 case 8:
			case DDR_PATTERN_LOOP_1+9:
			case DDR_PATTERN_LOOP_2+10:
			case DDR_PATTERN_LOOP_3+11:
						//	*(p+i) = 0xfb04fb04;
								if (*(p+i) != ~0xfb04fb04)
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), ~0xfb04fb04);
													break;
							}
						break;

					 case 12:
			case DDR_PATTERN_LOOP_1+13:
			case DDR_PATTERN_LOOP_2+14:
			case DDR_PATTERN_LOOP_3+15:
					//		*(p+i) = 0xf708f708;
								if (*(p+i) != ~0xf708f708)
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), ~0xf708f708);
													break;
							}
						break;

					 case 16:
			case DDR_PATTERN_LOOP_1+17:
			case DDR_PATTERN_LOOP_2+18:
			case DDR_PATTERN_LOOP_3+19:
					//		*(p+i) = 0xef10ef10;
								if (*(p+i) != ~0xef10ef10)
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), ~0xef10ef10);
													break;
							}
						break;

					 case 20:
			case DDR_PATTERN_LOOP_1+21:
			case DDR_PATTERN_LOOP_2+22:
			case DDR_PATTERN_LOOP_3+23:
						//	*(p+i) = 0xdf20df20;
								if (*(p+i) != ~0xdf20df20)
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), ~0xdf20df20);
													break;
							}
						break;

					 case 24:
			case DDR_PATTERN_LOOP_1+25:
			case DDR_PATTERN_LOOP_2+26:
			case DDR_PATTERN_LOOP_3+27:
					//		*(p+i) = 0xbf40bf40;
								if (*(p+i) != ~0xbf40bf40)
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), ~0xbf40bf40);
													break;
							}
								break;
						case 28:
			case DDR_PATTERN_LOOP_1+29:
			case DDR_PATTERN_LOOP_2+30:
			case DDR_PATTERN_LOOP_3+31:
					//		*(p+i) = 0x7f807f80;
								if (*(p+i) != ~0x7f807f80)
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), ~0x7f807f80);
													break;
							}
						break;


				default:

						//	*(p+i) = 0xff00ff00;
							 if (*(p+i) != ~0xff00ff00)
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), ~0xff00ff00);
													break;
							}
						break;

						break;


				}
			}

			if (m_len > 128*4)
			{
				m_len -= 128*4;
				p += 32*4;
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

static void ddr_write_pattern4_no_cross_talk(void *buff, unsigned m_length)
{
	unsigned *p;
 //	unsigned i, j, n;
	 unsigned i, n;
	unsigned m_len = m_length;
//#define ddr_pattern_loop 32
	p = (unsigned *)buff;

	while (m_len)
	{
		//	for(j=0;j<32;j++)
		{
			if (m_len >= 128*4)
				n = 32*4;
			else
				n = m_len>>2;

			for (i = 0; i < n; i++)
			{
				switch (i)
				{
					case 0:
					case 1:
					case 2:
					case 3:
				 *(p+i) = 0xff00ff00;
					 break;
				case 4:
					case 5:
					case 6:
					case 7:
				 *(p+i) = 0xffff0000;
					 break;

					case 8:
					case 9:
					case 10:
					case 11:
				 *(p+i) = 0xff000000;
					 break;
				case 12:
					case 13:
					case 14:
					case 15:
				 *(p+i) = 0xff00ffff;
					 break;

				case 16:
					case 17:
					case 18:
					case 19:
				 *(p+i) = 0xff00ffff;
					 break;
				case 20:
					case 21:
					case 22:
					case 23:
					*(p+i) = 0xff0000ff;
							break;
					case 24:
					case 25:
					case 26:
					case 27:
					*(p+i) = 0xffff0000;
						break;

				case 28:
					case 29:
					case 30:
					case 31:
								 *(p+i) = 0x00ff00ff;
							break;
				case DDR_PATTERN_LOOP_1+0:
		 case DDR_PATTERN_LOOP_1+1:
		 case DDR_PATTERN_LOOP_1+2:
		 case DDR_PATTERN_LOOP_1+3:
					*(p+i) =~0xff00ff00;
					break;
				case DDR_PATTERN_LOOP_1+4:
		 case DDR_PATTERN_LOOP_1+5:
		 case DDR_PATTERN_LOOP_1+6:
		 case DDR_PATTERN_LOOP_1+7:
					*(p+i) =~0xffff0000;
					break;
				case DDR_PATTERN_LOOP_1+8:
		 case DDR_PATTERN_LOOP_1+9:
		 case DDR_PATTERN_LOOP_1+10:
		 case DDR_PATTERN_LOOP_1+11:
					*(p+i) =~0xff000000;
					break;
				case DDR_PATTERN_LOOP_1+12:
		 case DDR_PATTERN_LOOP_1+13:
		 case DDR_PATTERN_LOOP_1+14:
		 case DDR_PATTERN_LOOP_1+15:
					*(p+i) =~0xff00ffff;
					break;
				case DDR_PATTERN_LOOP_1+16:
		 case DDR_PATTERN_LOOP_1+17:
		 case DDR_PATTERN_LOOP_1+18:
		 case DDR_PATTERN_LOOP_1+19:
					*(p+i) =~0xff00ffff;
					break;
				case DDR_PATTERN_LOOP_1+20:
		 case DDR_PATTERN_LOOP_1+21:
		 case DDR_PATTERN_LOOP_1+22:
		 case DDR_PATTERN_LOOP_1+23:
					*(p+i) =~0xff00ffff;
					break;
				case DDR_PATTERN_LOOP_1+24:
		 case DDR_PATTERN_LOOP_1+25:
		 case DDR_PATTERN_LOOP_1+26:
		 case DDR_PATTERN_LOOP_1+27:
					*(p+i) =~0xffff0000;
					break;
				case DDR_PATTERN_LOOP_1+28:
		 case DDR_PATTERN_LOOP_1+29:
		 case DDR_PATTERN_LOOP_1+30:
		 case DDR_PATTERN_LOOP_1+31:
					*(p+i) =~0x00ff00ff;
					break;

				case DDR_PATTERN_LOOP_2+0:
		 case DDR_PATTERN_LOOP_2+1:
		 case DDR_PATTERN_LOOP_2+2:
		 case DDR_PATTERN_LOOP_2+3:
					*(p+i) =0x00ff0000;
					break;
				case DDR_PATTERN_LOOP_2+4:
		 case DDR_PATTERN_LOOP_2+5:
		 case DDR_PATTERN_LOOP_2+6:
		 case DDR_PATTERN_LOOP_2+7:
					*(p+i) =0xff000000;
					break;
				case DDR_PATTERN_LOOP_2+8:
		 case DDR_PATTERN_LOOP_2+9:
		 case DDR_PATTERN_LOOP_2+10:
		 case DDR_PATTERN_LOOP_2+11:
					*(p+i) =0x0000ffff;
					break;
				case DDR_PATTERN_LOOP_2+12:
		 case DDR_PATTERN_LOOP_2+13:
		 case DDR_PATTERN_LOOP_2+14:
		 case DDR_PATTERN_LOOP_2+15:
					*(p+i) =0x000000ff;
					break;
				case DDR_PATTERN_LOOP_2+16:
		 case DDR_PATTERN_LOOP_2+17:
		 case DDR_PATTERN_LOOP_2+18:
		 case DDR_PATTERN_LOOP_2+19:
					*(p+i) =0x00ff00ff;
					break;
				case DDR_PATTERN_LOOP_2+20:
		 case DDR_PATTERN_LOOP_2+21:
		 case DDR_PATTERN_LOOP_2+22:
		 case DDR_PATTERN_LOOP_2+23:
					*(p+i) =0xff00ff00;
					break;
				case DDR_PATTERN_LOOP_2+24:
		 case DDR_PATTERN_LOOP_2+25:
		 case DDR_PATTERN_LOOP_2+26:
		 case DDR_PATTERN_LOOP_2+27:
					*(p+i) =0xff00ffff;
					break;
				case DDR_PATTERN_LOOP_2+28:
		 case DDR_PATTERN_LOOP_2+29:
		 case DDR_PATTERN_LOOP_2+30:
		 case DDR_PATTERN_LOOP_2+31:
					*(p+i) =0xff00ff00;
					break;
				case DDR_PATTERN_LOOP_3+0:
		 case DDR_PATTERN_LOOP_3+1:
		 case DDR_PATTERN_LOOP_3+2:
		 case DDR_PATTERN_LOOP_3+3:
					*(p+i) =~0x00ff0000;
					break;
				case DDR_PATTERN_LOOP_3+4:
		 case DDR_PATTERN_LOOP_3+5:
		 case DDR_PATTERN_LOOP_3+6:
		 case DDR_PATTERN_LOOP_3+7:
					*(p+i) =~0xff000000;
					break;
				case DDR_PATTERN_LOOP_3+8:
		 case DDR_PATTERN_LOOP_3+9:
		 case DDR_PATTERN_LOOP_3+10:
		 case DDR_PATTERN_LOOP_3+11:
					*(p+i) =~0x0000ffff;
					break;
				case DDR_PATTERN_LOOP_3+12:
		 case DDR_PATTERN_LOOP_3+13:
		 case DDR_PATTERN_LOOP_3+14:
		 case DDR_PATTERN_LOOP_3+15:
					*(p+i) =~0x000000ff;
					break;
				case DDR_PATTERN_LOOP_3+16:
		 case DDR_PATTERN_LOOP_3+17:
		 case DDR_PATTERN_LOOP_3+18:
		 case DDR_PATTERN_LOOP_3+19:
					*(p+i) =~0x00ff00ff;
					break;
				case DDR_PATTERN_LOOP_3+20:
		 case DDR_PATTERN_LOOP_3+21:
		 case DDR_PATTERN_LOOP_3+22:
		 case DDR_PATTERN_LOOP_3+23:
					*(p+i) =~0xff00ff00;
					break;
				case DDR_PATTERN_LOOP_3+24:
		 case DDR_PATTERN_LOOP_3+25:
		 case DDR_PATTERN_LOOP_3+26:
		 case DDR_PATTERN_LOOP_3+27:
					*(p+i) =~0xff00ffff;
					break;
				case DDR_PATTERN_LOOP_3+28:
		 case DDR_PATTERN_LOOP_3+29:
		 case DDR_PATTERN_LOOP_3+30:
		 case DDR_PATTERN_LOOP_3+31:
					*(p+i) =~0xff00ff00;
					break;


				}
			}

			if (m_len >( 128*4))
			{
				m_len -=( 128*4);
				p += 32*4;
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

static void ddr_read_pattern4_no_cross_talk(void *buff, unsigned m_length)
{
	unsigned *p;
	//	unsigned i, j, n;
	 unsigned i, n;
	unsigned m_len = m_length;

	p = (unsigned *)buff;
	while (m_len)
	{
		//	for(j=0;j<32;j++)
		{
			if (m_len >= 128*4)
				n = 32*4;
			else
				n = m_len>>2;

			for (i = 0; i < n; i++)
			{
				if ((error_outof_count_flag) && (error_count))
				{
				 printf("Error data out of count");
				 m_len=0;
					break;
				}
				switch (i)
				{
					case 0:
					case 1:
					case 2:
					case 3:
					//		if(*(p+i) !=~TDATA32F)

				if ( *(p+i) != 0xff00ff00)
					{error_count++;
					printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), 0xff00ff00);
					}
									 break;
				case 4:
					case 5:
					case 6:
					case 7:
						if ( *(p+i) != 0xffff0000)
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), 0xffff0000);
							}
					 break;

					case 8:
					case 9:
					case 10:
					case 11:
				// *(p+i) = 0xff000000;
				 if ( *(p+i) != 0xff000000)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), 0xff000000);
					}
					 break;
				case 12:
					case 13:
					case 14:
					case 15:
				// *(p+i) = 0xff00ffff;
				 if ( *(p+i) != 0xff00ffff)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), 0xff00ffff);
					}
					 break;

				case 16:
					case 17:
					case 18:
					case 19:
			//	 *(p+i) = 0xff00ffff;
				 if ( *(p+i) != 0xff00ffff)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), 0xff00ffff);
					}
					 break;
				case 20:
					case 21:
					case 22:
					case 23:
				//	*(p+i) = 0xff0000ff;
					if ( *(p+i) != 0xff0000ff)
						{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), 0xff0000ff);
						}
							break;
					case 24:
					case 25:
					case 26:
					case 27:
				//	*(p+i) = 0xffff0000;
					if ( *(p+i) != 0xffff0000)
						{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), 0xffff0000);
						}
						break;

				case 28:
					case 29:
					case 30:
					case 31:
								//	*(p+i) = 0x00ff00ff;
								 if ( *(p+i) != 0x00ff00ff)
									{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), 0x00ff00ff);
									}
							break;
				case DDR_PATTERN_LOOP_1+0:
		 case DDR_PATTERN_LOOP_1+1:
		 case DDR_PATTERN_LOOP_1+2:
		 case DDR_PATTERN_LOOP_1+3:
			 //		*(p+i) =~0xff00ff00;
				if ( *(p+i) != ~0xff00ff00)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), ~0xff00ff00);
					}
					break;
				case DDR_PATTERN_LOOP_1+4:
		 case DDR_PATTERN_LOOP_1+5:
		 case DDR_PATTERN_LOOP_1+6:
		 case DDR_PATTERN_LOOP_1+7:
				// 	*(p+i) =~0xffff0000;
				if ( *(p+i) != ~0xffff0000)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), ~0xffff0000);
					}
					break;
				case DDR_PATTERN_LOOP_1+8:
		 case DDR_PATTERN_LOOP_1+9:
		 case DDR_PATTERN_LOOP_1+10:
		 case DDR_PATTERN_LOOP_1+11:
				// 	*(p+i) =~0xff000000;
				if ( *(p+i) != ~0xff000000)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), ~0xff000000);
					}
					break;
				case DDR_PATTERN_LOOP_1+12:
		 case DDR_PATTERN_LOOP_1+13:
		 case DDR_PATTERN_LOOP_1+14:
		 case DDR_PATTERN_LOOP_1+15:
				//	*(p+i) =~0xff00ffff;
				if ( *(p+i) != ~0xff00ffff)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), ~0xff00ffff);
					}
					break;
				case DDR_PATTERN_LOOP_1+16:
		 case DDR_PATTERN_LOOP_1+17:
		 case DDR_PATTERN_LOOP_1+18:
		 case DDR_PATTERN_LOOP_1+19:
				//	*(p+i) =~0xff00ffff;
				if ( *(p+i) != ~0xff00ffff)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), ~0xff00ffff);
					}
					break;
				case DDR_PATTERN_LOOP_1+20:
		 case DDR_PATTERN_LOOP_1+21:
		 case DDR_PATTERN_LOOP_1+22:
		 case DDR_PATTERN_LOOP_1+23:
				//	*(p+i) =~0xff00ffff;
				if ( *(p+i) != ~0xff00ffff)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), ~0xff00ffff);
					}
					break;
				case DDR_PATTERN_LOOP_1+24:
		 case DDR_PATTERN_LOOP_1+25:
		 case DDR_PATTERN_LOOP_1+26:
		 case DDR_PATTERN_LOOP_1+27:
				//	*(p+i) =~0xffff0000;
				if ( *(p+i) != ~0xffff0000)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), ~0xffff0000);
					}
					break;
				case DDR_PATTERN_LOOP_1+28:
		 case DDR_PATTERN_LOOP_1+29:
		 case DDR_PATTERN_LOOP_1+30:
		 case DDR_PATTERN_LOOP_1+31:
			 //		*(p+i) =~0x00ff00ff;
				if ( *(p+i) != ~0x00ff00ff)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), ~0x00ff00ff);
					}
					break;

				case DDR_PATTERN_LOOP_2+0:
		 case DDR_PATTERN_LOOP_2+1:
		 case DDR_PATTERN_LOOP_2+2:
		 case DDR_PATTERN_LOOP_2+3:
			 //		*(p+i) =0x00ff0000;
				if ( *(p+i) != 0x00ff0000)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), 0x00ff0000);
					}
					break;
				case DDR_PATTERN_LOOP_2+4:
		 case DDR_PATTERN_LOOP_2+5:
		 case DDR_PATTERN_LOOP_2+6:
		 case DDR_PATTERN_LOOP_2+7:
			//		*(p+i) =0xff000000;
				if ( *(p+i) != 0xff000000)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), 0xff000000);
					}
					break;
				case DDR_PATTERN_LOOP_2+8:
		 case DDR_PATTERN_LOOP_2+9:
		 case DDR_PATTERN_LOOP_2+10:
		 case DDR_PATTERN_LOOP_2+11:
				// 	*(p+i) =0x0000ffff;
				if ( *(p+i) != 0x0000ffff)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), 0x0000ffff);
					}
					break;
				case DDR_PATTERN_LOOP_2+12:
		 case DDR_PATTERN_LOOP_2+13:
		 case DDR_PATTERN_LOOP_2+14:
		 case DDR_PATTERN_LOOP_2+15:
			//		*(p+i) =0x000000ff;
				if ( *(p+i) != 0x000000ff)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), 0x000000ff);
					}
					break;
				case DDR_PATTERN_LOOP_2+16:
		 case DDR_PATTERN_LOOP_2+17:
		 case DDR_PATTERN_LOOP_2+18:
		 case DDR_PATTERN_LOOP_2+19:
			//		*(p+i) =0x00ff00ff;
				if ( *(p+i) != 0x00ff00ff)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), 0x00ff00ff);
					}
					break;
				case DDR_PATTERN_LOOP_2+20:
		 case DDR_PATTERN_LOOP_2+21:
		 case DDR_PATTERN_LOOP_2+22:
		 case DDR_PATTERN_LOOP_2+23:
				//	*(p+i) =0xff00ff00;
				if ( *(p+i) != 0xff00ff00)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), 0xff00ff00);
					}
					break;
				case DDR_PATTERN_LOOP_2+24:
		 case DDR_PATTERN_LOOP_2+25:
		 case DDR_PATTERN_LOOP_2+26:
		 case DDR_PATTERN_LOOP_2+27:
			//		*(p+i) =0xff00ffff;
				if ( *(p+i) != 0xff00ffff)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), 0xff00ffff);
					}
					break;
				case DDR_PATTERN_LOOP_2+28:
		 case DDR_PATTERN_LOOP_2+29:
		 case DDR_PATTERN_LOOP_2+30:
		 case DDR_PATTERN_LOOP_2+31:
		//			*(p+i) =0xff00ff00;
				if ( *(p+i) != 0xff00ff00)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), 0xff00ff00);
					}
					break;
				case DDR_PATTERN_LOOP_3+0:
		 case DDR_PATTERN_LOOP_3+1:
		 case DDR_PATTERN_LOOP_3+2:
		 case DDR_PATTERN_LOOP_3+3:
				//	*(p+i) =~0x00ff0000;
				if ( *(p+i) != ~0x00ff0000)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), ~0x00ff0000);
					}
					break;
				case DDR_PATTERN_LOOP_3+4:
		 case DDR_PATTERN_LOOP_3+5:
		 case DDR_PATTERN_LOOP_3+6:
		 case DDR_PATTERN_LOOP_3+7:
			//		*(p+i) =~0xff000000;
				if ( *(p+i) != ~0xff000000)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), ~0xff000000);
					}
					break;
				case DDR_PATTERN_LOOP_3+8:
		 case DDR_PATTERN_LOOP_3+9:
		 case DDR_PATTERN_LOOP_3+10:
		 case DDR_PATTERN_LOOP_3+11:
			 //		*(p+i) =~0x0000ffff;
				if ( *(p+i) != ~0x0000ffff)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), ~0x0000ffff);
					}
					break;
				case DDR_PATTERN_LOOP_3+12:
		 case DDR_PATTERN_LOOP_3+13:
		 case DDR_PATTERN_LOOP_3+14:
		 case DDR_PATTERN_LOOP_3+15:
			//		*(p+i) =~0x000000ff;
				if ( *(p+i) != ~0x000000ff)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), ~0x000000ff);
					}
					break;
				case DDR_PATTERN_LOOP_3+16:
		 case DDR_PATTERN_LOOP_3+17:
		 case DDR_PATTERN_LOOP_3+18:
		 case DDR_PATTERN_LOOP_3+19:
			//		*(p+i) =~0x00ff00ff;
				if ( *(p+i) != ~0x00ff00ff)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), ~0x00ff00ff);
					}
					break;
				case DDR_PATTERN_LOOP_3+20:
		 case DDR_PATTERN_LOOP_3+21:
		 case DDR_PATTERN_LOOP_3+22:
		 case DDR_PATTERN_LOOP_3+23:
				//	*(p+i) =~0xff00ff00;
				if ( *(p+i) != ~0xff00ff00)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), ~0xff00ff00);
					}
					break;
				case DDR_PATTERN_LOOP_3+24:
		 case DDR_PATTERN_LOOP_3+25:
		 case DDR_PATTERN_LOOP_3+26:
		 case DDR_PATTERN_LOOP_3+27:
			 //		*(p+i) =~0xff00ffff;
				if ( *(p+i) != ~0xff00ffff)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), ~0xff00ffff);
					}
					break;
				case DDR_PATTERN_LOOP_3+28:
		 case DDR_PATTERN_LOOP_3+29:
		 case DDR_PATTERN_LOOP_3+30:
		 case DDR_PATTERN_LOOP_3+31:
			//		*(p+i) =~0xff00ff00;
				if ( *(p+i) != ~0xff00ff00)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), (unsigned int)(unsigned long)(p + i), ~0xff00ff00);
					}
					break;


				}
			}

			if (m_len >( 128*4))
			{
				m_len -=( 128*4);
				p += 32*4;
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

#define DDR_TEST_START_ADDR	0x10000000 //CONFIG_SYS_MEMTEST_START
#define DDR_TEST_SIZE 0x2000000
//#define DDR_TEST_SIZE 0x2000

int do_ddr_test(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	char *endp;
	unsigned long loop = 1;
	unsigned char lflag = 0;
	unsigned start_addr = DDR_TEST_START_ADDR;
	unsigned char simple_pattern_flag = 1;
	unsigned char cross_talk_pattern_flag = 1;
	unsigned char old_pattern_flag = 1;
	error_outof_count_flag =0;
	error_count =0;
	printf("\nargc== 0x%08x\n", argc);
	int i;
	for (i = 0;i<argc;i++)
		printf("\nargv[%d]=%s",i,argv[i]);

	if (!argc)
		goto DDR_TEST_START;

	if (argc == 2)
	{
		if (strcmp(argv[1], "l") == 0) {
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
	}

	//printf("\nLINE== 0x%08x\n", __LINE__);
	if (argc ==1) {
		start_addr = DDR_TEST_START_ADDR;
		loop = 1;
	}
	if (argc > 2) {
	//start_addr = simple_strtoul(argv[2], &endp, 16);
		if (*argv[2] == 0 || *endp != 0)
			start_addr = DDR_TEST_START_ADDR;
	}
	old_pattern_flag = 1;
	simple_pattern_flag = 1;
	cross_talk_pattern_flag = 1;
//printf("\nLINE== 0x%08x\n", __LINE__);
	if (argc ==2) {
		if ( (strcmp(argv[1], "s") == 0))
		{
			simple_pattern_flag = 1;
			old_pattern_flag=0;
			cross_talk_pattern_flag = 0;
		}
	else if ((strcmp(argv[1], "c") == 0))
		{
			simple_pattern_flag = 0;
			old_pattern_flag=0;
			cross_talk_pattern_flag = 1;
		}
	else if ( (strcmp(argv[1], "e") == 0))
		{
			error_outof_count_flag=1;
		}
	}
	if (argc >2) {
		if ( (strcmp(argv[1], "s") == 0) || (strcmp(argv[2], "s") == 0))
		{
			simple_pattern_flag = 1;
			old_pattern_flag=0;
			 cross_talk_pattern_flag = 0;
		}
	else if ((strcmp(argv[1], "c") == 0)||(strcmp(argv[2], "c") == 0))
		{
			simple_pattern_flag = 0;
			old_pattern_flag=0;
			 cross_talk_pattern_flag = 1;
		}
	else	if ( (strcmp(argv[1], "e") == 0)||(strcmp(argv[2], "e") == 0))
		{
			error_outof_count_flag=1;
			}
		}
//printf("\nLINE1== 0x%08x\n", __LINE__);
	if (argc > 3) {
		if ((strcmp(argv[1], "s") == 0) || (strcmp(argv[2], "s") == 0) || (strcmp(argv[3], "s") == 0))
		{
			simple_pattern_flag = 1;
			old_pattern_flag=0;
			 cross_talk_pattern_flag = 0;
		}
		if ((strcmp(argv[1], "c") == 0) || (strcmp(argv[2], "c") == 0) || (strcmp(argv[3], "c") == 0))
			{
			simple_pattern_flag = 0;
			old_pattern_flag=0;
			cross_talk_pattern_flag = 1;
		}
		if ((strcmp(argv[1], "e") == 0) || (strcmp(argv[2], "e") == 0) || (strcmp(argv[3], "e") == 0))
		{
		error_outof_count_flag=1;
		}
	}

		//	printf("\nLINE2== 0x%08x\n", __LINE__);
		//	printf("\nLINE3== 0x%08x\n", __LINE__);
		//	printf("\nLINE== 0x%08x\n", __LINE__);

DDR_TEST_START:

///*
	do {
		if (lflag)
			loop = 888;

		if (old_pattern_flag == 1)
			{
		//	printf("\nLINE== 0x%08x\n", __LINE__);
//printf("\nLINE== 0x%08x\n", __LINE__);
//printf("\nLINE== 0x%08x\n", __LINE__);
		printf("\rStart writing at 0x%08x - 0x%08x...", start_addr, start_addr + DDR_TEST_SIZE);
		ddr_write((void *)(unsigned long)start_addr, DDR_TEST_SIZE);
		printf("\rEnd write.								 ");
		printf("\rStart 1st reading...						");
		ddr_read((void *)(unsigned long)start_addr, DDR_TEST_SIZE);
		printf("\rEnd 1st read.								");
		printf("\rStart 2nd reading...						");
		ddr_read((void *)(unsigned long)start_addr, DDR_TEST_SIZE);
		printf("\rEnd 2nd read.								");
		printf("\rStart 3rd reading...						");
		ddr_read((void *)(unsigned long)start_addr, DDR_TEST_SIZE);
		printf("\rEnd 3rd read.								\n");
			}


if (simple_pattern_flag == 1)
{
			printf("\nStart *4 no cross talk pattern.								 ");
			printf("\nStart writing at 0x%08x - 0x%08x...", start_addr, start_addr + DDR_TEST_SIZE);
		ddr_write_pattern4_no_cross_talk((void *)(unsigned long)start_addr, DDR_TEST_SIZE);
		printf("\rEnd write.								 ");
		printf("\rStart 1st reading...						");
		ddr_read_pattern4_no_cross_talk((void *)(unsigned long)start_addr, DDR_TEST_SIZE);
		printf("\rEnd 1st read.								");
		printf("\rStart 2nd reading...						");
		ddr_read_pattern4_no_cross_talk((void *)(unsigned long)start_addr, DDR_TEST_SIZE);
		printf("\rEnd 2nd read.								");
		printf("\rStart 3rd reading...						");
		ddr_read_pattern4_no_cross_talk((void *)(unsigned long)start_addr, DDR_TEST_SIZE);
		printf("\rEnd 3rd read.								\n");
}

if (cross_talk_pattern_flag == 1)
{
			printf("\nStart *4	cross talk pattern p.								 ");
			printf("\nStart writing at 0x%08x - 0x%08x...", start_addr, start_addr + DDR_TEST_SIZE);
		ddr_write_pattern4_cross_talk_p((void *)(unsigned long)start_addr, DDR_TEST_SIZE);
		printf("\rEnd write.								 ");
		printf("\rStart 1st reading...						");
		ddr_read_pattern4_cross_talk_p((void *)(unsigned long)start_addr, DDR_TEST_SIZE);
		printf("\rEnd 1st read.								");
		printf("\rStart 2nd reading...						");
		ddr_read_pattern4_cross_talk_p((void *)(unsigned long)start_addr, DDR_TEST_SIZE);
		printf("\rEnd 2nd read.								");
		printf("\rStart 3rd reading...						");
		ddr_read_pattern4_cross_talk_p((void *)(unsigned long)start_addr, DDR_TEST_SIZE);
		printf("\rEnd 3rd read.								\n");

				printf("\nStart *4	cross talk pattern n.								 ");
			printf("\nStart writing at 0x%08x - 0x%08x...", start_addr, start_addr + DDR_TEST_SIZE);
		ddr_write_pattern4_cross_talk_n((void *)(unsigned long)start_addr, DDR_TEST_SIZE);
		printf("\rEnd write.								 ");
		printf("\rStart 1st reading...						");
		ddr_read_pattern4_cross_talk_n((void *)(unsigned long)start_addr, DDR_TEST_SIZE);
		printf("\rEnd 1st read.								");
		printf("\rStart 2nd reading...						");
		ddr_read_pattern4_cross_talk_n((void *)(unsigned long)start_addr, DDR_TEST_SIZE);
		printf("\rEnd 2nd read.								");
		printf("\rStart 3rd reading...						");
		ddr_read_pattern4_cross_talk_n((void *)(unsigned long)start_addr, DDR_TEST_SIZE);
		printf("\rEnd 3rd read.								\n");

///*
					printf("\nStart *4	cross talk pattern p2.								 ");
			printf("\nStart writing at 0x%08x - 0x%08x...", start_addr, start_addr + DDR_TEST_SIZE);
		ddr_write_pattern4_cross_talk_p2((void *)(unsigned long)start_addr, DDR_TEST_SIZE);
		printf("\rEnd write.								 ");
		printf("\rStart 1st reading...						");
		ddr_read_pattern4_cross_talk_p2((void *)(unsigned long)start_addr, DDR_TEST_SIZE);
		printf("\rEnd 1st read.								");
		printf("\rStart 2nd reading...						");
		ddr_read_pattern4_cross_talk_p2((void *)(unsigned long)start_addr, DDR_TEST_SIZE);
		printf("\rEnd 2nd read.								");
		printf("\rStart 3rd reading...						");
		ddr_read_pattern4_cross_talk_p2((void *)(unsigned long)start_addr, DDR_TEST_SIZE);
		printf("\rEnd 3rd read.								\n");

				printf("\nStart *4	cross talk pattern n2.								 ");
			printf("\nStart writing at 0x%08x - 0x%08x...", start_addr, start_addr + DDR_TEST_SIZE);
		ddr_write_pattern4_cross_talk_n2((void *)(unsigned long)start_addr, DDR_TEST_SIZE);
		printf("\rEnd write.								 ");
		printf("\rStart 1st reading...						");
		ddr_read_pattern4_cross_talk_n2((void *)(unsigned long)start_addr, DDR_TEST_SIZE);
		printf("\rEnd 1st read.								");
		printf("\rStart 2nd reading...						");
		ddr_read_pattern4_cross_talk_n2((void *)(unsigned long)start_addr, DDR_TEST_SIZE);
		printf("\rEnd 2nd read.								");
		printf("\rStart 3rd reading...						");
		ddr_read_pattern4_cross_talk_n2((void *)(unsigned long)start_addr, DDR_TEST_SIZE);
		printf("\rEnd 3rd read.								\n");
	//	*/

}


			printf("\Error count==0x%08x", error_count);
			printf("\n		\n");
		}while(--loop);
//*/

 printf("\rEnd ddr test.								\n");

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

/*

int ddr_test_s_cross_talk_pattern(int ddr_test_size)
{
unsigned start_addr = DDR_TEST_START_ADDR;
	error_outof_count_flag=1;
		error_count=0;

 printf("\rStart writing at 0x%08x - 0x%08x...", start_addr, start_addr + ddr_test_size);
		ddr_write((void *)(unsigned long)start_addr, ddr_test_size);
		printf("\rEnd write.								 ");
		printf("\rStart 1st reading...						");
		ddr_read((void *)(unsigned long)start_addr, ddr_test_size);
		printf("\rEnd 1st read.								");
		printf("\rStart 2nd reading...						");
		ddr_read((void *)(unsigned long)start_addr, ddr_test_size);

 printf("\nStart *4 no cross talk pattern.								 ");
			printf("\nStart writing at 0x%08x - 0x%08x...", start_addr, start_addr + ddr_test_size);
		ddr_write_pattern4_no_cross_talk((void *)(unsigned long)start_addr, ddr_test_size);
		printf("\rEnd write.								 ");
		printf("\rStart 1st reading...						");
		ddr_read_pattern4_no_cross_talk((void *)(unsigned long)start_addr, ddr_test_size);
		printf("\rEnd 1st read.								");
		printf("\rStart 2nd reading...						");
		ddr_read_pattern4_no_cross_talk((void *)(unsigned long)start_addr, ddr_test_size);

//if(cross_talk_pattern_flag==1)
{
			printf("\nStart *4	cross talk pattern p.								 ");
			printf("\nStart writing at 0x%08x - 0x%08x...", start_addr, start_addr + ddr_test_size);
		ddr_write_pattern4_cross_talk_p((void *)(unsigned long)start_addr, ddr_test_size);
		printf("\rEnd write.								 ");
		printf("\rStart 1st reading...						");
		ddr_read_pattern4_cross_talk_p((void *)(unsigned long)start_addr, ddr_test_size);
		printf("\rEnd 1st read.								");
		printf("\rStart 2nd reading...						");
		ddr_read_pattern4_cross_talk_p((void *)(unsigned long)start_addr, ddr_test_size);
		printf("\rEnd 2nd read.								");
		printf("\rStart 3rd reading...						");
		ddr_read_pattern4_cross_talk_p((void *)(unsigned long)start_addr, ddr_test_size);
		printf("\rEnd 3rd read.								\n");

				printf("\nStart *4	cross talk pattern n.								 ");
			printf("\nStart writing at 0x%08x - 0x%08x...", start_addr, start_addr + ddr_test_size);
		ddr_write_pattern4_cross_talk_n((void *)(unsigned long)start_addr, ddr_test_size);
		printf("\rEnd write.								 ");
		printf("\rStart 1st reading...						");
		ddr_read_pattern4_cross_talk_n((void *)(unsigned long)start_addr, ddr_test_size);
		printf("\rEnd 1st read.								");
		printf("\rStart 2nd reading...						");
		ddr_read_pattern4_cross_talk_n((void *)(unsigned long)start_addr, ddr_test_size);
		printf("\rEnd 2nd read.								");
		printf("\rStart 3rd reading...						");
		ddr_read_pattern4_cross_talk_n((void *)(unsigned long)start_addr, ddr_test_size);
		printf("\rEnd 3rd read.								\n");


}

if (error_count)
	return 1;
else
	return 0;
}


int do_ddr_test_fine_tune_dqs(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	printf("\nEnter Tune ddr dqs function\n");
 //	if(!argc)
	//	goto DDR_TUNE_DQS_START;
	printf("\nargc== 0x%08x\n", argc);
 // unsigned	loop = 1;
	unsigned	temp_count_i = 1;
	unsigned	temp_count_j= 1;
	unsigned	temp_count_k= 1;
	unsigned	temp_test_error= 0;


	 char *endp;
 // unsigned	*p_start_addr;
 unsigned	test_loop=1;
	unsigned	test_times=1;
	unsigned	reg_add=0;
	unsigned	reg_base_adj=0;
		 unsigned char channel_a_en = 0;
		unsigned char channel_b_en = 0;
		unsigned char testing_channel = 0;

	 #define	DATX8_DQ_LCD_BDL_REG_WIDTH	12

	 #define	DATX8_DQ_LANE_WIDTH	4
	 #define	CHANNEL_CHANNEL_WIDTH	2

		#define	CHANNEL_A	0
		#define	CHANNEL_B	1

		#define	CHANNEL_A_REG_BASE	0
		#define	CHANNEL_B_REG_BASE	0x2000

	#define	DATX8_DQ_LANE_LANE00	0
	#define	DATX8_DQ_LANE_LANE01	1
	#define	DATX8_DQ_LANE_LANE02	2
	#define	DATX8_DQ_LANE_LANE03	3

	 #define	DATX8_DQ_BDLR0	0
	 #define	DATX8_DQ_BDLR1	1
	 #define	DATX8_DQ_BDLR2	2
	 #define	DATX8_DQ_BDLR3	3
	 #define	DATX8_DQ_BDLR4	4
	 #define	DATX8_DQ_BDLR5	5
	 #define	DATX8_DQ_BDLR6	6
	 #define	DATX8_DQ_DXNLCDLR0	 7
	 #define	DATX8_DQ_DXNLCDLR1	 8
	 #define	DATX8_DQ_DXNLCDLR2	 9
	 #define	DATX8_DQ_DXNMDLR		10
	 #define	DATX8_DQ_DXNGTR			11


	 #define	DDR_CORSS_TALK_TEST_SIZE	0x20000

	 #define	DQ_LCD_BDL_REG_NUM_PER_CHANNEL	DATX8_DQ_LCD_BDL_REG_WIDTH*DATX8_DQ_LANE_WIDTH
		#define	DQ_LCD_BDL_REG_NUM	DQ_LCD_BDL_REG_NUM_PER_CHANNEL*CHANNEL_CHANNEL_WIDTH

	 unsigned	dq_lcd_bdl_reg_org[DQ_LCD_BDL_REG_NUM];
	 unsigned	dq_lcd_bdl_reg_left[DQ_LCD_BDL_REG_NUM];
	 unsigned	dq_lcd_bdl_reg_right[DQ_LCD_BDL_REG_NUM];
		unsigned	dq_lcd_bdl_reg_index[DQ_LCD_BDL_REG_NUM];

	 unsigned	dq_lcd_bdl_reg_left_min[DQ_LCD_BDL_REG_NUM];
	 unsigned	dq_lcd_bdl_reg_right_min[DQ_LCD_BDL_REG_NUM];

		unsigned	dq_lcd_bdl_temp_reg_value;
		unsigned	dq_lcd_bdl_temp_reg_value_dqs;
	 unsigned	dq_lcd_bdl_temp_reg_value_wdqd;
		unsigned	dq_lcd_bdl_temp_reg_value_rdqsd;
		// unsigned	dq_lcd_bdl_temp_reg_value_rdqsnd;
		unsigned	dq_lcd_bdl_temp_reg_lef_min_value;
		unsigned	dq_lcd_bdl_temp_reg_rig_min_value;
	//	unsigned	dq_lcd_bdl_temp_reg_value_dqs;
	// unsigned	dq_lcd_bdl_temp_reg_value_wdqd;
	//	unsigned	dq_lcd_bdl_temp_reg_value_rdqsd;

		unsigned	dq_lcd_bdl_temp_reg_lef;
		unsigned	dq_lcd_bdl_temp_reg_rig;
		unsigned	dq_lcd_bdl_temp_reg_center;
		unsigned	dq_lcd_bdl_temp_reg_windows;
		 unsigned	dq_lcd_bdl_temp_reg_center_min;
		unsigned	dq_lcd_bdl_temp_reg_windows_min;

		unsigned	ddr_test_size= DDR_CORSS_TALK_TEST_SIZE;

	//	#define DDR0_PUB_REG_BASE					0xc8836000
		//	#define DDR1_PUB_REG_BASE					0xc8836000


	 if (argc == 2)
		{
	if ((strcmp(argv[1], "a") == 0) || (strcmp(argv[1], "A") == 0))

	{channel_a_en = 1;
	}
	else if	((strcmp(argv[1], "b") == 0)||(strcmp(argv[1], "B") == 0))

	{channel_b_en = 1;
	}
	else
		{
	goto usage;
		}
		}
		if (argc > 2)
		{
	if ((strcmp(argv[1], "a") == 0) || (strcmp(argv[1], "A") == 0) || (strcmp(argv[2], "a") == 0) || (strcmp(argv[2], "A") == 0))

	{channel_a_en = 1;
	}
	 if	((strcmp(argv[1], "b") == 0) || (strcmp(argv[1], "B") == 0) || (strcmp(argv[2], "b") == 0) || (strcmp(argv[2], "B") == 0))

	{channel_b_en = 1;
	}
			}
			ddr_test_size = DDR_CORSS_TALK_TEST_SIZE;
	if (argc >3) {
	ddr_test_size = simple_strtoul(argv[3], &endp, 16);
		if (*argv[3] == 0 || *endp != 0)
			{
			ddr_test_size = DDR_CORSS_TALK_TEST_SIZE;
			}

	}
	if (argc >4) {
	test_loop = simple_strtoul(argv[4], &endp, 16);
		if (*argv[4] == 0 || *endp != 0)
			{
			test_loop = 1;
			}
		 if	((strcmp(argv[4], "l") == 0) || (strcmp(argv[4], "L") == 0))
			{
			test_loop = 100000;
			}
	}


		 printf("\nchannel_a_en== 0x%08x\n", channel_a_en);
		 printf("\nchannel_b_en== 0x%08x\n", channel_b_en);
			printf("\nddr_test_size== 0x%08x\n", ddr_test_size);
			printf("\ntest_loop== 0x%08x\n", test_loop);
if ( channel_a_en)
{
writel((readl(P_DDR0_CLK_CTRL)|0x12b), P_DDR0_CLK_CTRL);
}
if ( channel_b_en)
{
writel((readl(P_DDR1_CLK_CTRL)|0x12b), P_DDR1_CLK_CTRL);
}


//save and print org training dqs value
if (channel_a_en || channel_b_en)
{


	//dcache_disable();
 //serial_puts("\ndebug for ddrtest ,jiaxing disable dcache");

{
for ((testing_channel=0);(testing_channel<(channel_a_en+channel_b_en));(testing_channel++))
{
if (( channel_a_en) && ( channel_b_en == 0))
{
reg_base_adj=CHANNEL_A_REG_BASE;
}
else if(( channel_b_en)&&( channel_a_en==0))
{
reg_base_adj=CHANNEL_B_REG_BASE;
}
else if ((channel_a_en+channel_b_en)==2)
 {
if ( testing_channel == CHANNEL_A)
	{
reg_base_adj=CHANNEL_A_REG_BASE;
	}
else if( testing_channel==CHANNEL_B)
	{
reg_base_adj=CHANNEL_B_REG_BASE;
	}
 }

for ((temp_count_i=0);(temp_count_i<DATX8_DQ_LANE_WIDTH);(temp_count_i++))
	{

	if (temp_count_i == DATX8_DQ_LANE_LANE00)
		{
	reg_add=P_DDR0_PUB_DX0BDLR0+reg_base_adj;}

		else	if(temp_count_i==DATX8_DQ_LANE_LANE01)
		{
	reg_add=P_DDR0_PUB_DX1BDLR0+reg_base_adj;}

	else		 if(temp_count_i==DATX8_DQ_LANE_LANE02)
		{
	reg_add=P_DDR0_PUB_DX2BDLR0+reg_base_adj;}
	 else	if(temp_count_i==DATX8_DQ_LANE_LANE03)
		{
	reg_add=P_DDR0_PUB_DX3BDLR0+reg_base_adj;}



		for ((temp_count_j=0);(temp_count_j<DATX8_DQ_LCD_BDL_REG_WIDTH);(temp_count_j++))
		{
		dq_lcd_bdl_reg_org[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+temp_count_j]=readl(reg_add+4*temp_count_j);
dq_lcd_bdl_reg_index[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+temp_count_j]=reg_add+4*temp_count_j;
		printf("\n org add	0x%08x reg== 0x%08x\n",(reg_add+4*temp_count_j), (dq_lcd_bdl_reg_org[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+temp_count_j]));
dq_lcd_bdl_reg_left_min[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+temp_count_j]
 =dq_lcd_bdl_reg_org[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+temp_count_j];
dq_lcd_bdl_reg_right_min[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+temp_count_j]
 =dq_lcd_bdl_reg_org[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+temp_count_j];

		}
	}

}

}

}////save and print org training dqs value


for (test_times=0;(test_times<test_loop);(test_times++))
{
////tune and save training dqs value
if (channel_a_en || channel_b_en)

{
for ((testing_channel=0);(testing_channel<(channel_a_en+channel_b_en));(testing_channel++))
{

if (( channel_a_en) && ( channel_b_en == 0))
{
reg_base_adj=CHANNEL_A_REG_BASE;
}
else if(( channel_b_en)&&( channel_a_en==0))
{
reg_base_adj=CHANNEL_B_REG_BASE;
}
else if ((channel_a_en+channel_b_en)==2)
 {
if ( testing_channel == CHANNEL_A)
	{
reg_base_adj=CHANNEL_A_REG_BASE;
	}
else if( testing_channel==CHANNEL_B)
	{
reg_base_adj=CHANNEL_B_REG_BASE;
	}
 }

for ((temp_count_i=0);(temp_count_i<DATX8_DQ_LANE_WIDTH);(temp_count_i++))
{
	{

	if (temp_count_i == DATX8_DQ_LANE_LANE00)
		{
	reg_add=P_DDR0_PUB_DX0BDLR0+reg_base_adj;}

		else	if(temp_count_i==DATX8_DQ_LANE_LANE01)
		{
	reg_add=P_DDR0_PUB_DX1BDLR0+reg_base_adj;}

	else		 if(temp_count_i==DATX8_DQ_LANE_LANE02)
		{
	reg_add=P_DDR0_PUB_DX2BDLR0+reg_base_adj;}
	 else	if(temp_count_i==DATX8_DQ_LANE_LANE03)
		{
	reg_add=P_DDR0_PUB_DX3BDLR0+reg_base_adj;}
}

	for ((temp_count_k=0);(temp_count_k<2);(temp_count_k++))
		{

if (temp_count_k == 0)
{
	dq_lcd_bdl_temp_reg_value_dqs=readl(reg_add+4*DATX8_DQ_DXNLCDLR1);
		dq_lcd_bdl_temp_reg_value_wdqd=(dq_lcd_bdl_temp_reg_value_dqs&0xff);
		dq_lcd_bdl_temp_reg_value_rdqsd=((dq_lcd_bdl_temp_reg_value_dqs&0xff00))>>8;
	 //	dq_lcd_bdl_temp_reg_value_rdqsnd=((dq_lcd_bdl_temp_reg_value_dqs&0xff0000))>>16;

while (dq_lcd_bdl_temp_reg_value_wdqd>0)
{
temp_test_error=0;
dq_lcd_bdl_temp_reg_value_wdqd--;
	dq_lcd_bdl_temp_reg_value_dqs=(dq_lcd_bdl_temp_reg_value_wdqd|(dq_lcd_bdl_temp_reg_value_rdqsd<<8)|(dq_lcd_bdl_temp_reg_value_rdqsd<<16));
	 writel(dq_lcd_bdl_temp_reg_value_dqs,(reg_add+4*DATX8_DQ_DXNLCDLR1));
	temp_test_error=ddr_test_s_cross_talk_pattern(ddr_test_size);
	if (temp_test_error)
		{
		//printf("\nwdqd left edge detect \n");
		dq_lcd_bdl_temp_reg_value_wdqd++;
		break;
		}
}
printf("\nwdqd left edge detect \n");
printf("\nwdqd left edge==0x%08x\n ",dq_lcd_bdl_temp_reg_value_wdqd);
dq_lcd_bdl_temp_reg_value_dqs=(dq_lcd_bdl_temp_reg_value_wdqd|(dq_lcd_bdl_temp_reg_value_rdqsd<<8)|(dq_lcd_bdl_temp_reg_value_rdqsd<<16));
//only update dq_lcd_bdl_temp_reg_value_wdqd
dq_lcd_bdl_temp_reg_value=dq_lcd_bdl_reg_left[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1];
dq_lcd_bdl_temp_reg_value_dqs=((dq_lcd_bdl_temp_reg_value&0x00)|dq_lcd_bdl_temp_reg_value_wdqd);
dq_lcd_bdl_reg_left[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1]=dq_lcd_bdl_temp_reg_value_dqs;


dq_lcd_bdl_temp_reg_lef_min_value=dq_lcd_bdl_reg_left_min[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1];
if (dq_lcd_bdl_temp_reg_value_wdqd>(dq_lcd_bdl_temp_reg_lef_min_value&0xff)) 	//update wdqd min value
{
dq_lcd_bdl_reg_left_min[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1]
=((dq_lcd_bdl_temp_reg_lef_min_value&0xffff00)|dq_lcd_bdl_temp_reg_value_wdqd)	;
}


writel(dq_lcd_bdl_reg_org[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1],(reg_add+4*DATX8_DQ_DXNLCDLR1));

 dq_lcd_bdl_temp_reg_value_dqs=readl(reg_add+4*DATX8_DQ_DXNLCDLR1);
		dq_lcd_bdl_temp_reg_value_wdqd=(dq_lcd_bdl_temp_reg_value_dqs&0xff);
		dq_lcd_bdl_temp_reg_value_rdqsd=((dq_lcd_bdl_temp_reg_value_dqs&0xff00))>>8;


while (dq_lcd_bdl_temp_reg_value_wdqd<0xff)
{
temp_test_error=0;
dq_lcd_bdl_temp_reg_value_wdqd++;
	dq_lcd_bdl_temp_reg_value_dqs=(dq_lcd_bdl_temp_reg_value_wdqd|(dq_lcd_bdl_temp_reg_value_rdqsd<<8)|(dq_lcd_bdl_temp_reg_value_rdqsd<<16));
	 writel(dq_lcd_bdl_temp_reg_value_dqs,(reg_add+4*DATX8_DQ_DXNLCDLR1));
	temp_test_error=ddr_test_s_cross_talk_pattern(ddr_test_size);
	if (temp_test_error)
		{
		//printf("\nwdqd right edge detect \n");
		dq_lcd_bdl_temp_reg_value_wdqd--;
		break;
		}
}
printf("\nwdqd right edge detect \n");
printf("\nwdqd right edge==0x%08x\n ",dq_lcd_bdl_temp_reg_value_wdqd);
dq_lcd_bdl_temp_reg_value_dqs=(dq_lcd_bdl_temp_reg_value_wdqd|(dq_lcd_bdl_temp_reg_value_rdqsd<<8)|(dq_lcd_bdl_temp_reg_value_rdqsd<<16));
//only update dq_lcd_bdl_temp_reg_value_wdqd
dq_lcd_bdl_temp_reg_value=dq_lcd_bdl_reg_right[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1];
dq_lcd_bdl_temp_reg_value_dqs=((dq_lcd_bdl_temp_reg_value&0x00)|dq_lcd_bdl_temp_reg_value_wdqd);

dq_lcd_bdl_reg_right[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1]=dq_lcd_bdl_temp_reg_value_dqs;

dq_lcd_bdl_temp_reg_rig_min_value=dq_lcd_bdl_reg_right_min[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1];
if (dq_lcd_bdl_temp_reg_value_wdqd<(dq_lcd_bdl_temp_reg_rig_min_value&0xff)) 	//update wdqd min value
{
dq_lcd_bdl_reg_right_min[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1]
=((dq_lcd_bdl_temp_reg_rig_min_value&0xffff00)|dq_lcd_bdl_temp_reg_value_wdqd)	;
}



writel(dq_lcd_bdl_reg_org[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1],(reg_add+4*DATX8_DQ_DXNLCDLR1));


}
else if(temp_count_k==1)
{

 dq_lcd_bdl_temp_reg_value_dqs=readl(reg_add+4*DATX8_DQ_DXNLCDLR1);
		dq_lcd_bdl_temp_reg_value_wdqd=(dq_lcd_bdl_temp_reg_value_dqs&0xff);
		dq_lcd_bdl_temp_reg_value_rdqsd=((dq_lcd_bdl_temp_reg_value_dqs&0xff00))>>8;

while (dq_lcd_bdl_temp_reg_value_rdqsd>0)
{
temp_test_error=0;
dq_lcd_bdl_temp_reg_value_rdqsd--;
	dq_lcd_bdl_temp_reg_value_dqs=(dq_lcd_bdl_temp_reg_value_wdqd|(dq_lcd_bdl_temp_reg_value_rdqsd<<8)|(dq_lcd_bdl_temp_reg_value_rdqsd<<16));
	 writel(dq_lcd_bdl_temp_reg_value_dqs,(reg_add+4*DATX8_DQ_DXNLCDLR1));
	temp_test_error=ddr_test_s_cross_talk_pattern(ddr_test_size);
	if (temp_test_error)
		{
		//printf("\nrdqsd left edge detect \n");
		dq_lcd_bdl_temp_reg_value_rdqsd++;
		break;
		}
}
printf("\nrdqsd left edge detect \n");
printf("\nrdqsd left edge==0x%08x\n ",dq_lcd_bdl_temp_reg_value_rdqsd);
dq_lcd_bdl_temp_reg_value_dqs=(dq_lcd_bdl_temp_reg_value_wdqd|(dq_lcd_bdl_temp_reg_value_rdqsd<<8)|(dq_lcd_bdl_temp_reg_value_rdqsd<<16));
//only update dq_lcd_bdl_temp_reg_value_rdqsd rdqsnd
dq_lcd_bdl_temp_reg_value=dq_lcd_bdl_reg_left[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1];
dq_lcd_bdl_temp_reg_value_dqs=((dq_lcd_bdl_temp_reg_value&0x0000ff)|(dq_lcd_bdl_temp_reg_value_rdqsd<<8)|(dq_lcd_bdl_temp_reg_value_rdqsd<<16));

dq_lcd_bdl_reg_left[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1]=dq_lcd_bdl_temp_reg_value_dqs;


dq_lcd_bdl_temp_reg_lef_min_value=dq_lcd_bdl_reg_left_min[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1];
if (dq_lcd_bdl_temp_reg_value_rdqsd>((dq_lcd_bdl_temp_reg_lef_min_value>>8)&0xff)) 	//update wdqd min value
{
dq_lcd_bdl_reg_left_min[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1]
=((dq_lcd_bdl_temp_reg_lef_min_value&0xff)|(dq_lcd_bdl_temp_reg_value_rdqsd<<8)|(dq_lcd_bdl_temp_reg_value_rdqsd<<16))	;
}


writel(dq_lcd_bdl_reg_org[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1],(reg_add+4*DATX8_DQ_DXNLCDLR1));

 dq_lcd_bdl_temp_reg_value_dqs=readl(reg_add+4*DATX8_DQ_DXNLCDLR1);
		dq_lcd_bdl_temp_reg_value_wdqd=(dq_lcd_bdl_temp_reg_value_dqs&0xff);
		dq_lcd_bdl_temp_reg_value_rdqsd=((dq_lcd_bdl_temp_reg_value_dqs&0xff00))>>8;

while (dq_lcd_bdl_temp_reg_value_rdqsd<0xff)
{
temp_test_error=0;
dq_lcd_bdl_temp_reg_value_rdqsd++;
	dq_lcd_bdl_temp_reg_value_dqs=(dq_lcd_bdl_temp_reg_value_wdqd|(dq_lcd_bdl_temp_reg_value_rdqsd<<8)|(dq_lcd_bdl_temp_reg_value_rdqsd<<16));
	 writel(dq_lcd_bdl_temp_reg_value_dqs,(reg_add+4*DATX8_DQ_DXNLCDLR1));
	temp_test_error=ddr_test_s_cross_talk_pattern(ddr_test_size);
	if (temp_test_error)
		{
		//printf("\nrdqsd right edge detect \n");
		dq_lcd_bdl_temp_reg_value_rdqsd--;
		break;
		}
}
printf("\nrdqsd right edge detect \n");
printf("\nrdqsd right edge==0x%08x\n ",dq_lcd_bdl_temp_reg_value_rdqsd);
dq_lcd_bdl_temp_reg_value_dqs=(dq_lcd_bdl_temp_reg_value_wdqd|(dq_lcd_bdl_temp_reg_value_rdqsd<<8)|(dq_lcd_bdl_temp_reg_value_rdqsd<<16));
//only update dq_lcd_bdl_temp_reg_value_rdqsd rdqsnd
dq_lcd_bdl_temp_reg_value=dq_lcd_bdl_reg_right[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1];
dq_lcd_bdl_temp_reg_value_dqs=((dq_lcd_bdl_temp_reg_value&0x0000ff)|(dq_lcd_bdl_temp_reg_value_rdqsd<<8)|(dq_lcd_bdl_temp_reg_value_rdqsd<<16));
dq_lcd_bdl_reg_right[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1]=dq_lcd_bdl_temp_reg_value_dqs;


dq_lcd_bdl_temp_reg_rig_min_value=dq_lcd_bdl_reg_right_min[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1];
if (dq_lcd_bdl_temp_reg_value_rdqsd<((dq_lcd_bdl_temp_reg_rig_min_value>>8)&0xff)) 	//update wdqd min value
{
dq_lcd_bdl_reg_right_min[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1]
=((dq_lcd_bdl_temp_reg_rig_min_value&0xff)|(dq_lcd_bdl_temp_reg_value_rdqsd<<8)|(dq_lcd_bdl_temp_reg_value_rdqsd<<16))	;
}



writel(dq_lcd_bdl_reg_org[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1],(reg_add+4*DATX8_DQ_DXNLCDLR1));




	}

 }
}

}
}

////tune and save training dqs value




////calculate and print	dqs value
for ((testing_channel=0);(testing_channel<(channel_a_en+channel_b_en));(testing_channel++))
{
if (( channel_a_en) && ( channel_b_en == 0))
{
reg_base_adj=CHANNEL_A_REG_BASE;
}
else if(( channel_b_en)&&( channel_a_en==0))
{
reg_base_adj=CHANNEL_B_REG_BASE;
}
else if ((channel_a_en+channel_b_en)==2)
 {
if ( testing_channel == CHANNEL_A)
	{
reg_base_adj=CHANNEL_A_REG_BASE;
	}
else if( testing_channel==CHANNEL_B)
	{
reg_base_adj=CHANNEL_B_REG_BASE;
	}
 }
reg_add=P_DDR0_PUB_DX0BDLR0+reg_base_adj;


	for ((temp_count_j=0);(temp_count_j<DQ_LCD_BDL_REG_NUM_PER_CHANNEL);(temp_count_j++))
		{
	 //	dq_lcd_bdl_reg_index[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+temp_count_j]=reg_add+4*temp_count_j;

			printf("\n org add	0x%08x reg== 0x%08x\n",(dq_lcd_bdl_reg_index[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_j]), (dq_lcd_bdl_reg_org[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_j]));
		}

	for ((temp_count_j=0);(temp_count_j<DQ_LCD_BDL_REG_NUM_PER_CHANNEL);(temp_count_j++))
		{
			printf("\n lef add	0x%08x reg== 0x%08x\n",(dq_lcd_bdl_reg_index[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_j]), (dq_lcd_bdl_reg_left[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_j]));
		}

	for ((temp_count_j=0);(temp_count_j<DQ_LCD_BDL_REG_NUM_PER_CHANNEL);(temp_count_j++))
		{
			printf("\n rig add	0x%08x reg== 0x%08x\n",(dq_lcd_bdl_reg_index[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_j]), (dq_lcd_bdl_reg_right[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_j]));
		}

printf("\n ddrtest size ==0x%08x, test times==0x%08x,test_loop==0x%08x\n",ddr_test_size,(test_times+1),test_loop);
printf("\n add	0x00000000 reg==	org			lef			rig			center		win			lef_m		 rig_m		 min_c		 min_win		\n");
for ((temp_count_i=0);(temp_count_i<DATX8_DQ_LANE_WIDTH);(temp_count_i++))
{
	{

	if (temp_count_i == DATX8_DQ_LANE_LANE00)
		{
	reg_add=P_DDR0_PUB_DX0BDLR0+reg_base_adj+DATX8_DQ_DXNLCDLR1*4;}

		else	if(temp_count_i==DATX8_DQ_LANE_LANE01)
		{
	reg_add=P_DDR0_PUB_DX1BDLR0+reg_base_adj+DATX8_DQ_DXNLCDLR1*4;}

	else		 if(temp_count_i==DATX8_DQ_LANE_LANE02)
		{
	reg_add=P_DDR0_PUB_DX2BDLR0+reg_base_adj+DATX8_DQ_DXNLCDLR1*4;}
	 else	if(temp_count_i==DATX8_DQ_LANE_LANE03)
		{
	reg_add=P_DDR0_PUB_DX3BDLR0+reg_base_adj+DATX8_DQ_DXNLCDLR1*4;}
}

dq_lcd_bdl_temp_reg_lef=(dq_lcd_bdl_reg_left[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1]);
dq_lcd_bdl_temp_reg_rig=(dq_lcd_bdl_reg_right[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1]);

if (test_times == 0)
{
(dq_lcd_bdl_reg_left_min[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1])=dq_lcd_bdl_temp_reg_lef;
(dq_lcd_bdl_reg_right_min[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1])=dq_lcd_bdl_temp_reg_rig;

}
dq_lcd_bdl_temp_reg_lef_min_value=(dq_lcd_bdl_reg_left_min[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1]);
dq_lcd_bdl_temp_reg_rig_min_value=(dq_lcd_bdl_reg_right_min[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1]);


//dq_lcd_bdl_temp_reg_value_wdqd=(dq_lcd_bdl_temp_reg_value&0x0000ff);
	dq_lcd_bdl_temp_reg_center=( (((dq_lcd_bdl_temp_reg_lef&0xff)+(dq_lcd_bdl_temp_reg_rig&0xff))/2)
	|(((((dq_lcd_bdl_temp_reg_lef>>8)&0xff)+((dq_lcd_bdl_temp_reg_rig>>8)&0xff))/2)<<8)
	|(((((dq_lcd_bdl_temp_reg_lef>>16)&0xff)+((dq_lcd_bdl_temp_reg_rig>>8)&0xff))/2)<<16) );

	dq_lcd_bdl_temp_reg_windows=( (((dq_lcd_bdl_temp_reg_rig&0xff)-(dq_lcd_bdl_temp_reg_lef&0xff)))
	|(((((dq_lcd_bdl_temp_reg_rig>>8)&0xff)-((dq_lcd_bdl_temp_reg_lef>>8)&0xff)))<<8)
	|(((((dq_lcd_bdl_temp_reg_rig>>16)&0xff)-((dq_lcd_bdl_temp_reg_lef>>8)&0xff)))<<16) );


		dq_lcd_bdl_temp_reg_center_min=( (((dq_lcd_bdl_temp_reg_lef_min_value&0xff)+(dq_lcd_bdl_temp_reg_rig_min_value&0xff))/2)
	|(((((dq_lcd_bdl_temp_reg_lef_min_value>>8)&0xff)+((dq_lcd_bdl_temp_reg_rig_min_value>>8)&0xff))/2)<<8)
	|(((((dq_lcd_bdl_temp_reg_lef_min_value>>16)&0xff)+((dq_lcd_bdl_temp_reg_rig_min_value>>8)&0xff))/2)<<16) );

	dq_lcd_bdl_temp_reg_windows_min=( (((dq_lcd_bdl_temp_reg_rig_min_value&0xff)-(dq_lcd_bdl_temp_reg_lef_min_value&0xff)))
	|(((((dq_lcd_bdl_temp_reg_rig_min_value>>8)&0xff)-((dq_lcd_bdl_temp_reg_lef_min_value>>8)&0xff)))<<8)
	|(((((dq_lcd_bdl_temp_reg_rig_min_value>>16)&0xff)-((dq_lcd_bdl_temp_reg_lef_min_value>>8)&0xff)))<<16) );

printf("\n add	0x%08x reg==	0x%08x	0x%08x	0x%08x	0x%08x	0x%08x	0x%08x	0x%08x	0x%08x	0x%08x\n",
	(dq_lcd_bdl_reg_index[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1]),
		(dq_lcd_bdl_reg_org[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1]),
		(dq_lcd_bdl_reg_left[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1]),
		(dq_lcd_bdl_reg_right[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1]),
		dq_lcd_bdl_temp_reg_center,dq_lcd_bdl_temp_reg_windows,
		(dq_lcd_bdl_reg_left_min[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1]),
		(dq_lcd_bdl_reg_right_min[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1]),
		dq_lcd_bdl_temp_reg_center_min,dq_lcd_bdl_temp_reg_windows_min
);
		}


}

}




 return 0;

usage:
	cmd_usage(cmdtp);
	return 1;

}




U_BOOT_CMD(
	ddr_tune_dqs,	5,	1,	do_ddr_test_fine_tune_dqs,
	"DDR tune dqs function",
	"ddr_tune_dqs a 0 0x80000 3 or ddr_tune_dqs b 0 0x80000 5 or ddr_tune_dqs a b 0x80000 l\n dcache off ? \n"
);

*/

