/*
 * Header file for SHA1 firmware
 *
 * Copyright (c) 2010  Samsung Electronics
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 */
 
#ifndef __ACE_FW_SHA1_H__
#define __ACE_FW_SHA1_H__


#ifdef __cplusplus
extern "C" {
#endif

#if (defined(CONFIG_S5PV210) || defined(CONFIG_S5PC110) || defined(CONFIG_S5PV310) || defined(CONFIG_S5PC210))
	
/*****************************************************************
	Functions
*****************************************************************/
int ace_hash_sha1_digest (
	unsigned char*		pOut,
	unsigned char*		pBufAddr,
	unsigned int		bufLen
);
#endif

#ifdef __cplusplus
}
#endif

#endif 

