#ifndef __REBOOT_H
#define __REBOOT_H

#include <asm/arch/sram.h>

#define reboot_mode *((volatile unsigned long*)(0xC9000000 + REBOOT_MODE_OFFSET))

/*
 * Commands accepted by the arm_machine_restart() system call.
 *
 * AMLOGIC_NORMAL_BOOT     			Restart system normally.
 * AMLOGIC_FACTORY_RESET_REBOOT      Restart system into recovery factory reset.
 * AMLOGIC_UPDATE_REBOOT			Restart system into recovery update.
 * AMLOGIC_CHARGING_REBOOT     		Restart system into charging.
 * AMLOGIC_CRASH_REBOOT   			Restart system with system crach.
 * AMLOGIC_FACTORY_TEST_REBOOT    	Restart system into factory test.
 * AMLOGIC_SYSTEM_SWITCH_REBOOT  	Restart system for switch other OS.
 * AMLOGIC_SAFE_REBOOT       			Restart system into safe mode.
 * AMLOGIC_LOCK_REBOOT  			Restart system into lock mode.
 * elvis.yu---elvis.yu@amlogic.com
 */
#define	AMLOGIC_NORMAL_BOOT					0x0
#define	AMLOGIC_FACTORY_RESET_REBOOT		0x01010101
#define	AMLOGIC_UPDATE_REBOOT				0x02020202
#define	AMLOGIC_CHARGING_REBOOT				0x03030303
#define	AMLOGIC_CRASH_REBOOT				0x04040404
#define	AMLOGIC_FACTORY_TEST_REBOOT		0x05050505
#define	AMLOGIC_SYSTEM_SWITCH_REBOOT		0x06060606
#define	AMLOGIC_SAFE_REBOOT					0x07070707
#define	AMLOGIC_LOCK_REBOOT					0x08080808
#define	AMLOGIC_REBOOT_CLEAR					0xdeaddead

#define reboot_mode_clear()		do{reboot_mode = AMLOGIC_REBOOT_CLEAR;}while(0)

#else

#define kernel_args *((volatile unsigned long*)0xC9001E00)

typedef enum kernel_cmd
{
    NORMAL_BOOT=0,
    SYSTEM_REBOOT,
    RECOVERY_BOOT,
}kernel_cmd_t;

kernel_cmd_t get_kernel_cmd(void);

#endif

