/*
 * arch/arm/cpu/armv8/g12b/firmware/scp_task/gpio_key.h
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

#ifndef __ARCH_G12B_GPIO_KEY_H__
#define __ARCH_G12B_GPIO_KEY_H__

#ifdef CONFIG_GPIO_WAKEUP
int gpio_detect_key(void);
int init_gpio_key(void);

unsigned int gpio_wakeup_keyno;
#endif

#endif /* __ARCH_G12B_GPIO_KEY_H__ */
