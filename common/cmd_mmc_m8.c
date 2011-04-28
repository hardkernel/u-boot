/*
 * (C) Copyright 2003
 * Kyle Harris, kharris@nexus-tech.net
 *
 * See file CREDITS for list of people who contributed to this
 * project.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
 * MA 02111-1307 USA
 */

#include <common.h>
#include <malloc.h>
#include <command.h>
#include <linux/ctype.h>
#include <mmc.h>
#include <partition_table.h>
#include <emmc_partitions.h>

unsigned emmc_cur_partition = 0;

static int get_off_size(struct mmc * mmc, char * name, uint64_t offset, uint64_t  size, u64 * blk, u64 * cnt, u64 * sz_byte)
{
	struct partitions *part_info = NULL;
	uint64_t off = 0;
	int blk_shift = 0;
	 
	blk_shift =  ffs(mmc->read_bl_len) - 1;
	// printf("blk_shift:%d , off:0x%llx , size:0x%llx.\n ",blk_shift,off,size );
	part_info = find_mmc_partition_by_name(name);
	if(part_info == NULL){
		printf("get partition info failed !!\n");
		return -1;
	}
	off = part_info->offset + offset;

	// printf("part_info->offset:0x%llx , off:0x%llx , size:0x%llx.\n",part_info->offset ,off,size);
	
	*blk = off >>  blk_shift ;
	*cnt = size >>  blk_shift ;
	*sz_byte = size - ((*cnt)<<blk_shift) ;

	// printf("get_partition_off_size : blk:0x%llx , cnt:0x%llx.\n",*blk,*cnt);
	return 0;
}

static int get_partition_size(unsigned char* name, uint64_t* addr)
{
	struct partitions *part_info = NULL;
	part_info = find_mmc_partition_by_name(name);
	if(part_info == NULL){
		printf("get partition info failed !!\n");
		return -1;
	}
	
    *addr = part_info->size >> 9; // unit: 512 bytes
	return 0;
}

static inline int isstring(char *p)
{
	char *endptr = p;
	while (*endptr != '\0') {
		if (!(((*endptr >= '0') && (*endptr <= '9')) 
			|| ((*endptr >= 'a') && (*endptr <= 'f'))
			|| ((*endptr >= 'A') && (*endptr <= 'F'))
			|| (*endptr == 'x') || (*endptr == 'X')))
			return 1;
		endptr++;
	}

	return 0;
}


#ifndef CONFIG_GENERIC_MMC
static int curr_device = -1;

int do_mmc (cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	int dev;

	if (argc < 2)
		return cmd_usage(cmdtp);

	if (strcmp(argv[1], "init") == 0) {
		if (argc == 2) {
			if (curr_device < 0)
				dev = 1;
			else
				dev = curr_device;
		} else if (argc == 3) {
			dev = (int)simple_strtoul(argv[2], NULL, 10);
		} else {
			return cmd_usage(cmdtp);
		}

		if (mmc_legacy_init(dev) != 0) {
			puts("No MMC card found\n");
			return 1;
		}

		curr_device = dev;
		printf("mmc%d is available\n", curr_device);
	} else if (strcmp(argv[1], "device") == 0) {
		if (argc == 2) {
			if (curr_device < 0) {
				puts("No MMC device available\n");
				return 1;
			}
		} else if (argc == 3) {
			dev = (int)simple_strtoul(argv[2], NULL, 10);

#ifdef CONFIG_SYS_MMC_SET_DEV
			if (mmc_set_dev(dev) != 0)
				return 1;
#endif
			curr_device = dev;
		} else {
			return cmd_usage(cmdtp);
		}

		printf("mmc%d is current device\n", curr_device);
	} else {
		return cmd_usage(cmdtp);
	}

	return 0;
}

U_BOOT_CMD(
	mmc, 3, 1, do_mmc,
	"MMC sub-system",
	"init [dev] - init MMC sub system\n"
	"mmc device [dev] - show or set current device"
);
#else /* !CONFIG_GENERIC_MMC */

static void print_mmcinfo(struct mmc *mmc)
{
	printf("Device: %s\n", mmc->name);
	printf("Manufacturer ID: %x\n", mmc->cid[0] >> 24);
	printf("OEM: %x\n", (mmc->cid[0] >> 8) & 0xffff);
	printf("Name: %c%c%c%c%c \n", mmc->cid[0] & 0xff,
			(mmc->cid[1] >> 24), (mmc->cid[1] >> 16) & 0xff,
			(mmc->cid[1] >> 8) & 0xff, mmc->cid[1] & 0xff);

	printf("Tran Speed: %d\n", mmc->tran_speed);
	printf("Rd Block Len: %d\n", mmc->read_bl_len);

	printf("%s version %d.%d\n", IS_SD(mmc) ? "SD" : "MMC",
			(mmc->version >> 4) & 0xf, mmc->version & 0xf);

	printf("High Capacity: %s\n", mmc->high_capacity ? "Yes" : "No");
	printf("Capacity: %lld\n", mmc->capacity);
	printf("Boot Part Size: %lld\n", mmc->boot_size);

	printf("Bus Width: %d-bit\n", mmc->bus_width);
}

int do_mmcinfo (cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	struct mmc *mmc;
	int dev_num;

	if (argc < 2)
		dev_num = 0;
	else
		dev_num = simple_strtoul(argv[1], NULL, 0);

	mmc = find_mmc_device(dev_num);

	if (mmc) {
		if(mmc_init(mmc))
			return 1;
		print_mmcinfo(mmc);
		return 0;
	}

	return 1;
}

U_BOOT_CMD(mmcinfo, 2, 0, do_mmcinfo,
	"mmcinfo <dev num>-- display MMC info",
	""
);

int do_mmcops(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	int rc = 0;

	switch (argc) {
	case 3:
		if (strcmp(argv[1], "rescan") == 0) {
			int dev = simple_strtoul(argv[2], NULL, 10);
			if(dev < 0){
                printf("Cannot find dev.\n");
				return 1;
			}
			struct mmc *mmc = find_mmc_device(dev);

			if (!mmc)
				return 1;

			return mmc_init(mmc);
		} else if (strncmp(argv[1], "part", 4) == 0) {
			int dev = simple_strtoul(argv[2], NULL, 10);
			block_dev_desc_t *mmc_dev;
			struct mmc *mmc = find_mmc_device(dev);

			if (!mmc) {
				puts("no mmc devices available\n");
				return 1;
			}
			mmc_init(mmc);
			mmc_dev = mmc_get_dev(dev);
			if (mmc_dev != NULL &&
			    mmc_dev->type != DEV_TYPE_UNKNOWN) {
				print_part(mmc_dev);
				return 0;
			}

			puts("get mmc type error!\n");
			return 1;
		} else if (strcmp(argv[1], "erase") == 0) {
			char *name = NULL;
			int dev;
			u32 n=0;
			bool is_part = false;//is argv[2] partition name 
			bool protect_cache = false;
            int blk_shift;
			u64 cnt=0, blk =0,start_blk =0;
            struct partitions *part_info;

			if(isstring(argv[2])){
				if (!strcmp(argv[2], "whole")) {
					name = "logo";
					dev = find_dev_num_by_partition_name (name);
				}else if(!strcmp(argv[2], "non_cache")){
					name = "logo";
					dev = find_dev_num_by_partition_name (name);
					protect_cache = true;
				} 
				else{
					name = argv[2];						
					dev = find_dev_num_by_partition_name (name);
					is_part = true;
				}
			}else if(isdigit(argv[2][0])){
				dev = simple_strtoul(argv[2], NULL, 10);
			}else{
                printf("Input is invalid, nothing happen.\n");
                return 1;
            }
			
			if(dev < 0){
				printf("Cannot find dev.\n");
				return 1;
			}
			struct mmc *mmc = find_mmc_device(dev);

			if (!mmc)
				return 1;

			mmc_init(mmc);

            blk_shift = ffs(mmc->read_bl_len) -1;
			if(is_part){ // erase only one partition
                if (emmckey_is_protected(mmc) 
                        && (strncmp(name, MMC_RESERVED_NAME, sizeof(MMC_RESERVED_NAME)) == 0x00)) {
                    printf("\"%s-partition\" is been protecting and should no be erased!\n", MMC_RESERVED_NAME);
                    return 1;
                }

				part_info = find_mmc_partition_by_name(name);
				if(part_info == NULL){
					return 1;
                }
				
				blk = part_info->offset>> blk_shift;
				if(emmc_cur_partition && !strncmp(name, "bootloader", strlen("bootloader"))){
				    
				    cnt = mmc->boot_size>> blk_shift;
				}
				else
				    cnt = part_info->size>> blk_shift;				
                n = mmc->block_dev.block_erase(dev, blk, cnt);
			} else { // erase the whole card if possible
                if (emmckey_is_protected(mmc)) {
                    part_info = find_mmc_partition_by_name(MMC_RESERVED_NAME);
                    if(part_info == NULL){
                        return 1;
                    }
                    blk = part_info->offset;
                    if (blk > 0) { // it means: there should be other partitions before reserve-partition.
                        blk -= PARTITION_RESERVED;
                    }
                    blk >>= blk_shift;				
                    
                    n=0;
                    
                    // (1) erase all the area before reserve-partition
                    if (blk > 0) {
                        n = mmc->block_dev.block_erase(dev, 0, blk);
                        // printf("(1) erase blk: 0 --> %llx %s\n", blk, (n == 0) ? "OK" : "ERROR");
                    }
                    if (n == 0) { // not error
                        // (2) erase all the area after reserve-partition
                        if(protect_cache){
			    part_info = find_mmc_partition_by_name(MMC_CACHE_NAME);
			    if(part_info == NULL){
                       	        return 1;
                 	             }
			}
		     start_blk = (part_info->offset + part_info->size + PARTITION_RESERVED) >> blk_shift;
                        u64 erase_cnt = (mmc->capacity >> blk_shift) - 1 - start_blk;
                        n = mmc->block_dev.block_erase(dev, start_blk, erase_cnt);
                        // printf("(2) erase blk: %#llx --> %#llx %s\n", start_blk, start_blk+erase_cnt, (n == 0) ? "OK" : "ERROR");
                    }
                } else {
                    n = mmc->block_dev.block_erase(dev, 0, 0); // erase the whole card
                }
                
                //erase boot partition
                if(mmc->boot_size && (n == 0)){
                    
                    for(cnt=0;cnt<2;cnt++){
                        rc = mmc_switch_partition(mmc, cnt+1);
                        if(rc != 0){
                            printf("mmc switch %s failed\n", (cnt == 0)?"boot0":"boot1");
                            break;
                        }
                        
                        n = mmc->block_dev.block_erase(dev, 0, mmc->boot_size>>blk_shift);      
                        if(n != 0){
                            printf("mmc erase %s failed\n", (cnt == 0)?"boot0":"boot1");
                            break;                            
                        }                  
                    }
                    
                    rc = mmc_switch_partition(mmc, 0);    
                    if(rc != 0){
                        printf("mmc switch back to user failed\n");
                    }                    
                }
            }

			// printf("dev # %d, %s, # %#llx blocks erased %s\n",
                    // dev, (is_part == 0) ? "card":(argv[2]) , 
                    // (cnt == 0) ? (int)(mmc->block_dev.lba): cnt ,
                    // (n == 0) ? "OK" : "ERROR");
			return (n == 0) ? 0 : 1;
		} else {
			return cmd_usage(cmdtp);
        }

	case 0:
	case 1:
	case 4:
        if(strcmp(argv[1], "switch")==0){
            int dev = simple_strtoul(argv[2], NULL, 10);
            struct mmc* mmc = find_mmc_device(dev);
            if(!mmc) {
                puts("no mmc devices available\n");
                return 1;
            }
            mmc_init(mmc);
            if(strcmp(argv[3], "boot0")==0){
                rc = mmc_switch_partition(mmc, 1);
                if(rc == 0)
                    emmc_cur_partition = 1;
            }
            else if(strcmp(argv[3], "boot1")==0){
                rc = mmc_switch_partition(mmc, 2);
                if(rc == 0)
                    emmc_cur_partition = 2;
            }
            else if(strcmp(argv[3], "user")==0){
                rc = mmc_switch_partition(mmc, 0);
                if(rc == 0)
                    emmc_cur_partition = 0;
            }
            return rc;
        }
                
        if(strcmp(argv[1], "size")==0){
            char *name;
            uint64_t* addr =NULL;
            name = argv[2];
            addr = (uint64_t *)simple_strtoul(argv[3], NULL, 16);
            return get_partition_size(name, addr);
        }
        
        return cmd_usage(cmdtp);

	case 2:
		if (!strcmp(argv[1], "list")) {
			print_mmc_devices('\n');
			return 0;
		}

        if(strcmp(argv[1], "env")==0){
            printf("herh\n");
            env_relocate();
            return 0 ;
        }

 #ifdef CONFIG_SECURITYKEY
        if(strcmp(argv[1], "key")==0){
            struct mmc* mmc;
            char *name = "logo";
            int dev = find_dev_num_by_partition_name (name);
            mmc = find_mmc_device(dev);
            if(!mmc){
                printf("device %d is invalid\n",dev);
                return 1;
            }
            mmc->key_protect = 0;
#ifdef CONFIG_STORE_COMPATIBLE
	   info_disprotect |= DISPROTECT_KEY;  //disprotect
#endif
            return 0;
        }
#endif
        return cmd_usage(cmdtp);

	default: /* at least 5 args */
		if (strcmp(argv[1], "read") == 0) {
            int dev;
            void *addr =NULL;
            u32 flag =0;
            u64 cnt =0,n =0, blk =0, sz_byte =0;
            char *name;
            u64 offset =0,size =0;

			if(argc != 6){
				printf("Input is invalid, nothing happen.\n");
				return 1;
			}
			
            if(isstring(argv[2])){
                name = argv[2];
                dev = find_dev_num_by_partition_name (name);
                addr = (void *)simple_strtoul(argv[3], NULL, 16);
                size = simple_strtoull(argv[5], NULL, 16);
                offset  = simple_strtoull(argv[4], NULL, 16);
                // printf("offset %llx size %llx\n",offset,size);
                flag = 1;
                if((strcmp(argv[2], "card") == 0)){
                    flag = 2;
                }
            }else{
                dev = simple_strtoul(argv[2], NULL, 10);
                addr = (void *)simple_strtoul(argv[3], NULL, 16);
                cnt = simple_strtoull(argv[5], NULL, 16);
                blk = simple_strtoull(argv[4], NULL, 16);
            }
            if(dev < 0){
				printf("Cannot find dev.\n");
                return 1;
            }
            struct mmc *mmc = find_mmc_device(dev);

            if (!mmc)
                return 1;

            if(flag == 1){ // emmc or tsd
                /*printf("offset %#llx size %#llx\n",offset,size);*/
                get_off_size(mmc, name, offset, size, &blk, &cnt, &sz_byte);
            }
            else if(flag == 2){ // card
                int blk_shift = ffs( mmc->read_bl_len) -1;
                cnt = size >> blk_shift;
                blk = offset >> blk_shift;
				sz_byte = size - (cnt<<blk_shift);
            }


            // printf("MMC read: dev # %d, block # %#llx, count # %#llx ...\n",
                    // dev, blk, cnt);

            mmc_init(mmc);

            n = mmc->block_dev.block_read(dev, blk, cnt, addr);

			//read sz_byte bytes
			if ((n == cnt) && (sz_byte != 0)) {
                // printf("sz_byte=%#llx bytes\n",sz_byte);
				void *addr_tmp = kmalloc(mmc->read_bl_len, GFP_KERNEL);
				void *addr_byte = (void *)(addr+cnt*(mmc->read_bl_len));
				ulong start_blk = blk+cnt;

                if (addr_tmp == NULL) {
                    printf("mmc read: kmalloc fail\n");
                    return 1;
                }

				if (mmc->block_dev.block_read(dev, start_blk, 1, addr_tmp) != 1) { // read 1 block
                    kfree(addr_tmp);
                    printf("mmc read 1 block fail\n");
					return 1;
                }

				memcpy(addr_byte, addr_tmp, sz_byte);
				kfree(addr_tmp);
			}			

            /* flush cache after read */
            //flush_cache((ulong)addr, cnt * 512); /* FIXME */

            if (n != cnt) {
                printf("MMC read: dev # %d, block # %#llx, count # %#llx, byte_size # %#llx ERROR!\n",
                        dev, blk, cnt, sz_byte);
                // printf("%#llx blocks read: %s\n",
                // n, (n==cnt) ? "OK" : "ERROR");
            }
            return (n == cnt) ? 0 : 1;
		} else if (strcmp(argv[1], "write") == 0) {
			int dev;
			void *addr =NULL;
			u32 flag =0;
			u64 cnt =0,n =0, blk =0,sz_byte =0;
			char *name;
			u64 offset =0,size =0;

			if(argc != 6){
				printf("Input is invalid, nothing happen.\n");
				return 1;
			}

			if(isstring(argv[2])){
				name = argv[2];
				dev = find_dev_num_by_partition_name (name);
				addr = (void *)simple_strtoul(argv[3], NULL, 16);
				offset  = simple_strtoull(argv[4], NULL, 16);
				size = simple_strtoull(argv[5], NULL, 16);
				flag = 1;
				if((strcmp(argv[2], "card") == 0)){
					flag = 2;
				}
			}else{
				dev = simple_strtoul(argv[2], NULL, 10);
				addr = (void *)simple_strtoul(argv[3], NULL, 16);
				blk = simple_strtoull(argv[4], NULL, 16);
				cnt = simple_strtoull(argv[5], NULL, 16);	
			}
			if(dev < 0){
				printf("Cannot find dev.\n");
				return 1;
			}
			struct mmc *mmc = find_mmc_device(dev);

			if(flag == 1){ // tsd or emmc
				get_off_size(mmc, name, offset, size, &blk, &cnt, &sz_byte);
			}
			else if(flag == 2){ // card
				int blk_shift = ffs( mmc->read_bl_len) -1;
				cnt = size >> blk_shift;
				blk = offset >> blk_shift;
				sz_byte = size - (cnt<<blk_shift);
			}

			if (!mmc)
				return 1;

			// printf("MMC write: dev # %d, block # %#llx, count # %#llx ... ",
				// dev, blk, cnt);

			mmc_init(mmc);

			n = mmc->block_dev.block_write(dev, blk, cnt, addr);

			//write sz_byte bytes
			if ((n == cnt) && (sz_byte != 0)) {
                // printf("sz_byte=%#llx bytes\n",sz_byte);
				void *addr_tmp = kmalloc(mmc->write_bl_len, GFP_KERNEL);
				void *addr_byte = (void*)(addr+cnt*(mmc->write_bl_len));
				ulong start_blk = blk+cnt;

                if (addr_tmp == NULL) {
                    printf("mmc write: kmalloc fail\n");
                    return 1;
                }

				if (mmc->block_dev.block_read(dev, start_blk, 1, addr_tmp) != 1) { // read 1 block
                    kfree(addr_tmp);
                    printf("mmc read 1 block fail\n");
					return 1;
                }

				memcpy(addr_tmp, addr_byte, sz_byte);
				if (mmc->block_dev.block_write(dev, start_blk, 1, addr_tmp) != 1) { // write 1 block
                    kfree(addr_tmp);
                    printf("mmc write 1 block fail\n");
					return 1;
                }
				kfree(addr_tmp);
			}			

            if(cnt != n) {
                printf("%#llx blocks , %#llx bytes written: ERROR\n", n, sz_byte);
            }
			return (n == cnt) ? 0 : 1;
		}
		else if (strcmp(argv[1], "erase") == 0) {

			int dev;
			u32 flag=0;
			u64 cnt = 0, blk = 0, n = 0, sz_byte =0; 
			char *name;
			u64 offset_addr =0, size=0;

			if(argc != 5){
				printf("Input is invalid, nothing happen.\n");
				return 1;
			}

			if(isstring(argv[2])){
				name = argv[2];
				dev = find_dev_num_by_partition_name (name);				
				offset_addr = simple_strtoull(argv[3], NULL, 16);
				size = simple_strtoull(argv[4], NULL, 16);				
				flag = 1;
				if((strcmp(argv[2], "card") == 0)){
					flag = 2;
				}
			}else if(isdigit(argv[2][0])){
				dev = simple_strtoul(argv[2], NULL, 10);
				blk = simple_strtoull(argv[3], NULL, 16);
				cnt = simple_strtoull(argv[4], NULL, 16);
			}
			
			if(dev < 0){
				printf("Cannot find dev.\n");
				return 1;
			}

			struct mmc *mmc = find_mmc_device(dev);

			if(flag == 1){ // mmc write logo add offset size
				struct partitions *part_info  = find_mmc_partition_by_name(name);

				if(offset_addr >= part_info->size){
					printf("Start address out #%s# partition'address region,(addr_byte < 0x%llx)\n",
					name, part_info->size);
					return 1;
				}
				if((offset_addr+size) > part_info->size){
					printf("End address exceeds #%s# partition,(offset = 0x%llx,size = 0x%llx)\n",
					name, part_info->offset,part_info->size);
					return 1;
				}
				get_off_size(mmc, name, offset_addr, size, &blk, &cnt, &sz_byte);
			}
			else if(flag == 2){				
				int tmp_shift = ffs( mmc->read_bl_len) -1;	
				cnt = size >> tmp_shift;
				blk = offset_addr >> tmp_shift;	
				sz_byte = size - (cnt<<tmp_shift);
			}
						
			if (!mmc)
				return 1;

			printf("MMC erase: dev # %d, start_erase_address(in block) # %#llx, several blocks will be erased ...\n ",
				dev, blk);

			mmc_init(mmc);

	      	if (cnt != 0)
				n = mmc->block_dev.block_erase(dev, blk, cnt);

			printf("dev # %d, %s, several blocks erased %s\n",
                    dev, (flag == 0) ? " ":(argv[2]),(n == 0) ? "OK" : "ERROR");
			
		  	return (n == 0) ? 0 : 1;
		  
	 	} else
			rc = cmd_usage(cmdtp);

		return rc;
	}
}

U_BOOT_CMD(
	mmc, 6, 1, do_mmcops,
	"MMC sub system",
	"read  <partition name> ram_addr addr_byte# cnt_byte\n"
	"mmc write <partition name> ram_addr addr_byte# cnt_byte\n"
	"mmc erase <partition name> addr_byte# cnt_byte\n"
	"mmc erase <partition name>/<device num>\n"
	"mmc rescan <device num>\n"
	"mmc part <device num> - show partition infomation of mmc\n"
	"mmc list - lists available devices\n"
	"mmc switch <device num> <part name> - part name : boot0, boot1, user");
#endif
