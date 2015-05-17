/**********************************************************************
 *
 * Filename:    memtest.h
 *
 * Description: Memory-testing module API.
 *
 * Notes:       The memory tests can be easily ported to systems with
 *              different data bus widths by redefining 'unsigned int' type.
 *
 *
 * Copyright (c) 2000 by Michael Barr.  This software is placed into
 * the public domain and may be used for any purpose.  However, this
 * notice must not be changed or removed and no warranty is either
 * expressed or implied by its publication or distribution.
 **********************************************************************/

#ifndef _memtest_h
#define _memtest_h


/*
 * Define NULL pointer value.
 */
#ifndef NULL
#define NULL  (void *) 0
#endif

/*
 * Set the data bus width.
 */
//typedef unsigned int unsigned int;

/*
 * Function prototypes.
 */

unsigned int memTestDataBus(volatile unsigned int * address);
unsigned int memTestAddressBus(volatile unsigned int * baseAddress, unsigned int nBytes);
unsigned int memTestDevice(volatile unsigned int * baseAddress, unsigned int nBytes);

#endif /* _memtest_h */