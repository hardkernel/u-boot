/**********************************************************************
 *
 * Filename:	memtest.c
 *
 * Description: General-purpose memory testing functions.
 *
 * Notes:	   This software can be easily ported to systems with
 *			  different data bus widths by redefining 'unsigned int'.
 *
 *
 * Copyright (c) 1998 by Michael Barr.  This software is placed into
 * the public domain and may be used for any purpose.  However, this
 * notice must not be changed or removed and no warranty is either
 * expressed or implied by its publication or distribution.
 **********************************************************************/

#define MEM_TEST_DEBUG 0

#include <stdio.h>

/**********************************************************************
 *
 * Function:	memTestDataBus()
 *
 * Description: Test the data bus wiring in a memory region by
 *			  performing a walking 1's test at a fixed address
 *			  within that region.  The address (and hence the
 *			  memory region) is selected by the caller.
 *
 * Notes:
 *
 * Returns:	 0 if the test succeeds.
 *			  A non-zero result is the first pattern that failed.
 *
 **********************************************************************/
unsigned int
memTestDataBus(volatile unsigned int * address)
{
	unsigned int pattern;
	unsigned int data;
	unsigned int ret = 0;
	/*
	 * Perform a walking 1's test at the given address.
	 */
	for (pattern = 1; pattern != 0; pattern <<= 1)
	{
		/*
		 * Write the test pattern.
		 */
		*address = pattern;
		data = *address;
		/*
		 * Read it back (immediately is okay for this test).
		 */
		if (data != pattern)
		{
#if (MEM_TEST_DEBUG)
			//printf("  memTestDataBus - write: 0x%8x, read back: 0x%8x\n", pattern, data);
			serial_puts("  memTestDataBus - write: 0x");
			serial_put_hex(pattern, 32);
			serial_puts(", read back: 0x");
			serial_put_hex(data, 32);
			serial_puts("\n");
			ret = 1;
#else
			return (pattern);
#endif
		}
	}
	return (ret);
} /* memTestDataBus() */


/**********************************************************************
 *
 * Function:	memTestAddressBus()
 *
 * Description: Test the address bus wiring in a memory region by
 *			  performing a walking 1's test on the relevant bits
 *			  of the address and checking for aliasing. This test
 *			  will find single-bit address failures such as stuck
 *			  -high, stuck-low, and shorted pins.  The base address
 *			  and size of the region are selected by the caller.
 *
 * Notes:	   For best results, the selected base address should
 *			  have enough LSB 0's to guarantee single address bit
 *			  changes.  For example, to test a 64-Kbyte region,
 *			  select a base address on a 64-Kbyte boundary.  Also,
 *			  select the region size as a power-of-two--if at all
 *			  possible.
 *
 * Returns:	 NULL if the test succeeds.
 *			  A non-zero result is the first address at which an
 *			  aliasing problem was uncovered.  By examining the
 *			  contents of memory, it may be possible to gather
 *			  additional information about the problem.
 *
 **********************************************************************/
unsigned int
memTestAddressBus(volatile unsigned int * baseAddress, unsigned int nBytes)
{
	unsigned int addressMask = (nBytes/sizeof(unsigned int) - 1);
	unsigned int offset;
	unsigned int testOffset;

	unsigned int pattern	 = (unsigned int) 0xAAAAAAAA;
	unsigned int antipattern = (unsigned int) 0x55555555;

	unsigned int data1, data2;

	/* align the mask address */
	unsigned int temp_i=1, temp_j=0;
	temp_j = addressMask;
	do {
		temp_i=(temp_i<<1);
		temp_j=(temp_j>>1);
	}while((temp_j));
	addressMask=((temp_i)-1);

	unsigned int ret = 0;

	/*
	 * Write the default pattern at each of the power-of-two offsets.
	 */
	for (offset = 1; (offset & addressMask) != 0; offset <<= 1)
	{
		baseAddress[offset] = pattern;
	}

	/*
	 * Check for address bits stuck high.
	 */
	testOffset = 0;
	baseAddress[testOffset] = antipattern;

	for (offset = 1; (offset & addressMask) != 0; offset <<= 1)
	{
		data1 = baseAddress[offset];
		data2 = baseAddress[offset];
		if (data1 != data2)
		{
#if (MEM_TEST_DEBUG)
			//printf("  memTestAddressBus - read twice different[offset]: 0x%8x-0x%8x\n", data1, data2);
			serial_puts("  memTestAddressBus - read twice different[offset]: 0x");
			serial_put_hex(data1, 32);
			serial_puts("-0x");
			serial_put_hex(data2, 32);
			serial_puts("\n");
#endif
			ret = 1;
		}
		if (data1 != pattern)
		{
#if (MEM_TEST_DEBUG)
			/*printf("  memTestAddressBus - write[0x%8x]: 0x%8x, read[0x%8x]: 0x%8x\n", \
				offset, pattern, offset, data1);
			*/
			serial_puts("  memTestAddressBus - write[0x");
			serial_put_hex(offset, 32);
			serial_puts("]: 0x");
			serial_put_hex(pattern, 32);
			serial_puts(", read[0x");
			serial_put_hex(offset, 32);
			serial_puts("]: 0x");
			serial_put_hex(data1, 32);
			serial_puts("\n");
			ret = 1;
#else
			return ((unsigned int)(unsigned long) &baseAddress[offset]);
#endif
		}
	}

	baseAddress[testOffset] = pattern;

	/*
	 * Check for address bits stuck low or shorted.
	 */
	for (testOffset = 1; (testOffset & addressMask) != 0; testOffset <<= 1)
	{
		baseAddress[testOffset] = antipattern;

		if (baseAddress[0] != pattern)
		{
#if (MEM_TEST_DEBUG)
			/*printf("  memTestAddressBus2 - write baseAddress[0x%8x]: 0x%8x, read baseAddress[0]: 0x%8x\n", \
				testOffset, antipattern, baseAddress[0]);
			*/
			serial_puts("  memTestAddressBus2 - write baseAddress[0x");
			serial_put_hex(testOffset, 32);
			serial_puts("]: 0x");
			serial_put_hex(antipattern, 32);
			serial_puts(", read baseAddress[0]: 0x");
			serial_put_hex(baseAddress[0], 32);
			serial_puts("\n");
			ret = 1;
#else
			return ((unsigned int)(unsigned long) &baseAddress[testOffset]);
#endif
		}

		for (offset = 1; (offset & addressMask) != 0; offset <<= 1)
		{
			data1 = baseAddress[offset];
			if ((data1 != pattern) && (offset != testOffset))
			{
#if (MEM_TEST_DEBUG)
				/*printf("  memTestAddressBus3 - write baseAddress[0x%8x]: 0x%8x, read baseAddress[0x%8x]: 0x%8x\n", \
					testOffset, antipattern, testOffset, data1);
				*/
				serial_puts("  memTestAddressBus3 - write baseAddress[0x");
				serial_put_hex(testOffset, 32);
				serial_puts("]: 0x");
				serial_put_hex(antipattern, 32);
				serial_puts(", read baseAddress[0x");
				serial_put_hex(testOffset, 32);
				serial_puts("]: 0x");
				serial_put_hex(data1, 32);
				serial_puts("\n");
				ret = 1;
#else
				return ((unsigned int)(unsigned long) &baseAddress[testOffset]);
#endif
			}
		}

		baseAddress[testOffset] = pattern;
	}
	return (ret);
}   /* memTestAddressBus() */


/**********************************************************************
 *
 * Function:	memTestDevice()
 *
 * Description: Test the integrity of a physical memory device by
 *			  performing an increment/decrement test over the
 *			  entire region.  In the process every storage bit
 *			  in the device is tested as a zero and a one.  The
 *			  base address and the size of the region are
 *			  selected by the caller.
 *
 * Notes:
 *
 * Returns:	 NULL if the test succeeds.
 *
 *			  A non-zero result is the first address at which an
 *			  incorrect value was read back.  By examining the
 *			  contents of memory, it may be possible to gather
 *			  additional information about the problem.
 *
 **********************************************************************/
#define AML_DEBUG_ROM
unsigned int
memTestDevice(volatile unsigned int * baseAddress, unsigned int nBytes)
{

	unsigned int offset;
	unsigned int nWords = nBytes / sizeof(unsigned int);
	unsigned int ret = 0;
	unsigned int data;
	unsigned int pattern;
	unsigned int antipattern;
	serial_puts("\nTotal Size 0x");
	serial_put_hex(nBytes, 32);
	serial_puts("\n");

	/*
	 * Fill memory with a known pattern.
	 */
	for (pattern = 1, offset = 0; offset < nWords; pattern++, offset++)
	{
		baseAddress[offset] = pattern;
#ifdef AML_DEBUG_ROM
		if ((offset&0x3ffff) == 0)
		{
			serial_puts("\r0x");
			serial_put_hex(offset<<2, 32);
		}
#endif

	}
	serial_puts("\n");

	/*
	 * Check each location and invert it for the second pass.
	 */
	for (pattern = 1, offset = 0; offset < nWords; pattern++, offset++)
	{
		data = baseAddress[offset];
		if ( data!= pattern)
		{
#if (MEM_TEST_DEBUG)
			/*printf("  memTestDevice - write baseAddress[0x%8x]: 0x%8x, read baseAddress[0x%8x]: 0x%8x\n", \
				offset, pattern, offset, data);
			*/
			serial_puts("  memTestDevice - write baseAddress[0x");
			serial_put_hex(offset, 32);
			serial_puts("]: 0x");
			serial_put_hex(pattern, 32);
			serial_puts(", read baseAddress[0x");
			serial_put_hex(offset, 32);
			serial_puts("]: 0x");
			serial_put_hex(data, 32);
			serial_puts("\n");
			ret = 1;
#else
			return ((unsigned int)(unsigned long) &baseAddress[offset]);
#endif
		}

		antipattern = ~pattern;
		baseAddress[offset] = antipattern;
#ifdef AML_DEBUG_ROM
		if ((offset&0x3ffff) == 0)
		{
			serial_puts("\r0x");
			serial_put_hex((offset<<2), 32);
		}
#endif

	}
	serial_puts("\n");

	/*
	 * Check each location for the inverted pattern and zero it.
	 */
	for (pattern = 1, offset = 0; offset < nWords; pattern++, offset++)
	{
		antipattern = ~pattern;
		data = baseAddress[offset];
		if (data != antipattern)
		{
#if (MEM_TEST_DEBUG)
			/*printf("  memTestDevice2 - write baseAddress[0x%8x]: 0x%8x, read baseAddress[0x%8x]: 0x%8x\n", \
				offset, antipattern, offset, data);
			*/
			serial_puts("  memTestDevice2 - write baseAddress[0x");
			serial_put_hex(offset, 32);
			serial_puts("]: 0x");
			serial_put_hex(pattern, 32);
			serial_puts(", read baseAddress[0x");
			serial_put_hex(offset, 32);
			serial_puts("]: 0x");
			serial_put_hex(data, 32);
			serial_puts("\n");
			ret = 1;
#else
			return ((unsigned int)(unsigned long) &baseAddress[offset]);
#endif
		}
#ifdef AML_DEBUG_ROM
		if ((offset&0x3ffff) == 0)
		{
			serial_puts("\r0x");
			serial_put_hex((offset<<2), 32);
		}
#endif

	}
#undef AML_DEBUG_ROM
	serial_puts("\n");

	return (ret);
}   /* memTestDevice() */
