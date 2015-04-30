/*aml basic io module*/

#ifndef __BL2_IO_H_
#define __BL2_IO_H_

#define writel(val,reg) (*((volatile unsigned *)(reg)))=(val)
#define readl(reg)		(*((volatile unsigned *)(reg)))
#define setbits_le32(reg,val)	(*((volatile unsigned *)(reg)))|=(val)
#define clrbits_le32(reg,val)	(*((volatile unsigned *)(reg)))&=(~(val))
#define clrsetbits_le32(reg,clr,set)	{unsigned __v=readl(reg);__v&=(~(clr));__v|=(set);writel(__v,reg);}

#endif /*__BL2_IO_H_*/