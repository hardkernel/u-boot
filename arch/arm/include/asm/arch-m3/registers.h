/*
 *
 * arch/arm/include/asm/arch-m1/registers.h
 *
 *  Copyright (C) 2010 AMLOGIC, INC.
 *
 * License terms: GNU General Public License (GPL) version 2
 * Basic register address definitions in physical memory and
 * some block defintions for core devices like the timer.
 * copy from linux kernel
 */

#ifndef __MACH_MESSON_ONE_REGS_H
#define __MACH_MESSON_ONE_REGS_H

#define IO_CBUS_BASE			  0xc1100000
#define IO_AXI_BUS_BASE			0xc1300000
#define IO_AHB_BUS_BASE			0xc9000000
#define IO_APB_BUS_BASE			0xc8000000

#define MESON_PERIPHS1_VIRT_BASE	0xc1108400
#define MESON_PERIPHS1_PHYS_BASE	0xc1108400

#define MESON_PERIPHS1_VIRT_BASE	0xc1108400
#define MESON_PERIPHS1_PHYS_BASE	0xc1108400

#define CBUS_REG_OFFSET(reg) ((reg) << 2)
#define CBUS_REG_ADDR(reg)	 (IO_CBUS_BASE + CBUS_REG_OFFSET(reg))

#define AXI_REG_OFFSET(reg)  ((reg) << 2)
#define AXI_REG_ADDR(reg)	 (IO_AXI_BUS_BASE + AXI_REG_OFFSET(reg))

#define AHB_REG_OFFSET(reg)  ((reg) << 2)
#define AHB_REG_ADDR(reg)	 (IO_AHB_BUS_BASE + AHB_REG_OFFSET(reg))

#define APB_REG_OFFSET(reg)  (reg)
#define APB_REG_ADDR(reg)	 (IO_APB_BUS_BASE + APB_REG_OFFSET(reg))
#define APB_REG_ADDR_VALID(reg) (((unsigned long)(reg) & 3) == 0)

//c_stb_define.h
// synopsys translate_off
// synopsys translate_on
// There are two instantiations under one CBUS slave.  Each CBUS slave can support
// 256 registers.  Each demux is allocated 128 registers so set the offset in
// the middle
// Copy this define but don't add a base address
// process_header_copy_only_on 
// process_header_copy_only_off 
//========================================================================
//  STB TOP Registers				    (8'hf0 - 8'hf7)
//========================================================================
// bit 22 -- invert fec_error for S2P1
// bit 21 -- invert fec_data for S2P1
// bit 20 -- invert fec_sync for S2P1
// bit 19 -- invert fec_valid for S2P1
// bit 18 -- invert fec_clk for S2P1
// bit 17:16 -- fec_s_sel for S2P1  00 - select TS0, 01 -- select TS1, 10 -- select TS2, 11 - reserved
// Bit 15 -- enable_des_pl_clk
// Bit 14:13 -- reserved
// Bit 12:10 -- ts_out_select, 0-TS0, 1-TS1, 2-TS2, 3,4-Reserved, 5-S2P1, 6-S2P0, 7-File
// bit 9:8 -- des_i_sel 00 -- select_fec_0, 01 -- select_fec_1, 10 -- select_fec_2, 11 - reserved
// bit 7 -- enable_des_pl
// bit 6 -- invert fec_error for S2P0
// bit 5 -- invert fec_data for S2P0
// bit 4 -- invert fec_sync for S2P0
// bit 3 -- invert fec_valid for S2P0
// bit 2 -- invert fec_clk for S2P0
// bit 1:0 -- fec_s_sel for S2P0  00 - select TS0, 01 -- select TS1, 10 -- select TS2, 11 - reserved
// 15:8 -- TS_package_length_sub_1 (default : 187)
//  7:0 -- fec_sync_byte (default : 0x47)
// Bit 23:16 -- file_m2ts_skip_bytes
// Bit 15:8 -- des_out_dly
// Bit 7:6 -- transport_scrambling_control_odd // should be 3
// Bit 5 -- ts_hiu_enable
// Bit 4:0 -- fec_clk_div
// Bit 13:8 -- des ts pl state   -- Read Only
// Bit 3:0 PID index to 8 PID to get key-set
// auto increse after TS_PL_PID_DATA read/write
// Bit 13 -- PID match disble
// Bit 12:0 -- PID
// process_header_no_copy_on   
//
// NOTE:  Don't process the demux registers using the standard create_headers.... perl script.
//        Instead, since the demux has multiple instances (and many registers) use a separate
//        script to create a separate stb_define.h for C-code.  
//========================================================================
//  STB Registers				    (8'h00 - 8'h4f)
//
//========================================================================
// STB registers are 8'h0x
// Bit 15:0 -- version number : 0x0002  (v0.01)
#define STB_VERSION                                0x1600
#define STB_VERSION_2                              0x1650
#define STB_VERSION_3                              0x16a0
#define STB_TEST_REG                               0x1601
#define STB_TEST_REG_2                             0x1651
#define STB_TEST_REG_3                             0x16a1
// Bit 15 -- fec_core_select 1 - select descramble output
// Bit 14:12 -  fec_select 0-TS0, 1-TS1, 2-TS2, 3,4-Reserved, 5-S2P1, 6-S2P0, 7-File 
// Bit 11 -- FEC_CLK
// Bit 10 -- SOP
// Bit 9 -- D_VALID
// Bit 8 -- D_FAIL
// Bit 7:0 -- D_DATA 7:0
#define FEC_INPUT_CONTROL                          0x1602
#define FEC_INPUT_CONTROL_2                        0x1652
#define FEC_INPUT_CONTROL_3                        0x16a2
    /*----------- bit define -----------*/
    #define FEC_CORE_SEL               15
    #define FEC_SEL                    12
    #define FEC_INPUT_FEC_CLK          11
    #define FEC_INPUT_SOP              10
    #define FEC_INPUT_D_VALID           9
    #define FEC_INPUT_D_FAIL            8
#define FEC_INPUT_DATA                             0x1603
#define FEC_INPUT_DATA_2                           0x1653
#define FEC_INPUT_DATA_3                           0x16a3
// bit 31 -- enable_free_clk_fec_data_valid
// bit 30 -- enable_free_clk_stb_reg
// bit 29:21 -- reserved
// bit 20 (bit 4) -- Bypass use recoder path
// bit 19 (bit 3) -- clear_PID_continuity_counter_valid
// bit 18 (bit 2) -- Disable Splicing
// bit 17 (bit 1) -- Insert PES_STRONG_SYNC in Audio PES
// bit 16 (bit 0) -- Insert PES_STRONG_SYNC in Video PES
// Bit 15 - do not trust section length
// Bit 14 - om cmd push even zero
// Bit 13 - reserved
// Bit 12 - SUB, OTHER PES interrupt at beginning of PES
// Bit 11 - discard_av_package -- for ts_recorder use only 
// Bit 10 - ts_recorder_select  0:after PID filter 1:before PID filter
// Bit 9 - ts_recorder_enable
// Bit 8 - (table_id == 0xff) means section_end
// Bit 7 - do not send uncomplete section
// Bit 6 - do not discard duplicate package
// Bit 5 - search SOP when trasport_error_indicator
// Bit 4 - stb demux enable
// Bit 3 - do not reset state machine on SOP
// Bit 2 - search SOP when error happened ( when ignore_fail_n_sop, will have this case)
// Bit 1 - do not use SOP input ( check FEC sync byte instead )
// Bit 0 - ignore fec_error bit when non sop ( check error on SOP only)
#define DEMUX_CONTROL                              0x1604
#define DEMUX_CONTROL_2                            0x1654
#define DEMUX_CONTROL_3                            0x16a4
    /*----------- bit define -----------*/
    #define BYPASS_USE_RECODER_PATH                 20
    #define CLEAR_PID_CONTINUITY_COUNTER_VALID      19
    #define DISABLE_SPLICING                        18
    #define INSERT_AUDIO_PES_STRONG_SYNC            17
    #define INSERT_VIDEO_PES_STRONG_SYNC            16
    #define SECTION_LENGTH_UNTRUSTY                 15
    #define OM_CMD_PUSH_EVEN_ZERO                   14
    #define OTHER_INT_AT_PES_BEGINING               12
    #define DISCARD_AV_PACKAGE                      11
    #define TS_RECORDER_SELECT                      10
    #define TS_RECORDER_ENABLE                      9
    #define SECTION_END_WITH_TABLE_ID               8
    #define SEND_COMPLETE_SECTION_ONLY              7
    #define KEEP_DUPLICATE_PACKAGE                  6
    #define SEACH_SOP_ON_TRANSPORT_ERROR            5
    #define STB_DEMUX_ENABLE                        4
    #define NO_RESET_ON_SOP                         3
    #define SEARCH_SOP_ON_ERROR                     2
    #define NOT_USE_OF_SOP_INPUT                    1
    #define IGNORE_NONSOP_FEC_ERROR                 0
// bit 15:8 demux package length - 1 ( default : 187 )
// bit 7:0 default is 0x47
#define FEC_SYNC_BYTE                              0x1605
#define FEC_SYNC_BYTE_2                            0x1655
#define FEC_SYNC_BYTE_3                            0x16a5
// bit 31:16 -- filter memory write data hi[31:16]
// bit 15:0 -- filter memory write data low [15:0]
#define FM_WR_DATA                                 0x1606
#define FM_WR_DATA_2                               0x1656
#define FM_WR_DATA_3                               0x16a6
// bit 31:24 -- advanced setting hi
// bit 23:16 -- advanced setting low
// bit 15 -- filter memory write data request
// bit 7:0 -- filter memory write addr
#define FM_WR_ADDR                                 0x1607
#define FM_WR_ADDR_2                               0x1657
#define FM_WR_ADDR_3                               0x16a7
// bit 13:8 demux state  -- read only
// bit 7:4 -- maxnum section filter compare address
// bit 3:0 -- maxnum PID filter compare address
#define MAX_FM_COMP_ADDR                           0x1608
#define MAX_FM_COMP_ADDR_2                         0x1658
#define MAX_FM_COMP_ADDR_3                         0x16a8
// bit 15 - transport_error_indicator
// bit 14 - payload_unit_start_indicator
// bit 13 - transport_priority
// bit 12:0 - PID
#define TS_HEAD_0                                  0x1609
#define TS_HEAD_0_2                                0x1659
#define TS_HEAD_0_3                                0x16a9
// bit 7:6 transport_scrambling_control
// bit 5:4 adaptation_field_control
// bit 3:0 continuity_counter
#define TS_HEAD_1                                  0x160a
#define TS_HEAD_1_2                                0x165a
#define TS_HEAD_1_3                                0x16aa
// bit 15:12 -- om_cmd_count (read only)
// bit  11:9 -- overflow_count // bit  11:9 -- om_cmd_wr_ptr (read only)
// bit   8:6 -- om_overwrite_count // bit   8:6 -- om_cmd_rd_ptr (read only)
// bit   5:3 -- type_stb_om_w_rd (read only)
// bit     2 -- unit_start_stb_om_w_rd (read only)
// bit     1 -- om_cmd_overflow (read only)
// bit     0 -- om_cmd_pending (read) 
// bit     0 -- om_cmd_read_finished (write)
#define OM_CMD_STATUS                              0x160b
#define OM_CMD_STATUS_2                            0x165b
#define OM_CMD_STATUS_3                            0x16ab
// bit 15:9 // bit 14:8 -- count_stb_om_w_rd  (read only)
// bit 8:0  // bit  7:0 -- start_stb_om_wa_rd (read only)
#define OM_CMD_DATA                                0x160c
#define OM_CMD_DATA_2                              0x165c
#define OM_CMD_DATA_3                              0x16ac
// bit 11:0 -- offset for section data
#define OM_CMD_DATA2                               0x160d
#define OM_CMD_DATA2_2                             0x165d
#define OM_CMD_DATA2_3                             0x16ad
// bit 31:16 -- base address for section buffer group 0 (*0x400 to get real address)
// bit 15:0 -- base address for section buffer group 1 (*0x400 to get real address)
#define SEC_BUFF_01_START                          0x160e
#define SEC_BUFF_01_START_2                        0x165e
#define SEC_BUFF_01_START_3                        0x16ae
// bit 31:16 -- ba2e address for section buffer group 2 (*0x400 to get real address)
// bit 15:0 -- base address for section buffer group 3 (*0x400 to get real address)
#define SEC_BUFF_23_START                          0x160f
#define SEC_BUFF_23_START_2                        0x165f
#define SEC_BUFF_23_START_3                        0x16af
// bit 3:0 -- section buffer size for group 0 (bit used,  for example, 10 means 1K)
// bit 7:4 -- section buffer size for group 1
// bit 11:8 -- section buffer size for group 2
// bit 15:12 -- section buffer size for group 3
#define SEC_BUFF_SIZE                              0x1610
#define SEC_BUFF_SIZE_2                            0x1660
#define SEC_BUFF_SIZE_3                            0x16b0
// section buffer busy status for buff 31:0 ( Read Only )
#define SEC_BUFF_BUSY                              0x1611
#define SEC_BUFF_BUSY_2                            0x1661
#define SEC_BUFF_BUSY_3                            0x16b1
// section buffer write status for buff 31:0 -- Read
// clear buffer status ( buff READY and BUSY ) -- write
#define SEC_BUFF_READY                             0x1612
#define SEC_BUFF_READY_2                           0x1662
#define SEC_BUFF_READY_3                           0x16b2
// bit 4:0 -- SEC_BUFFER_INDEX   RW
// bit 12:8 -- SEC_BUFFER_NUMBER for the INDEX buffer  Read_Only
// bit 14 -- output_section_buffer_valid
// bit 15 -- section_reset_busy (Read Only)
#define SEC_BUFF_NUMBER                            0x1613
#define SEC_BUFF_NUMBER_2                          0x1663
#define SEC_BUFF_NUMBER_3                          0x16b3
// bit 9:5 -- BYPASS PID number
// bit 4:0 -- PCR PID number
#define ASSIGN_PID_NUMBER                          0x1614
#define ASSIGN_PID_NUMBER_2                        0x1664
#define ASSIGN_PID_NUMBER_3                        0x16b4
// bit 15:0 -- stream_id filter bit enable
// bit 7:0 -- stream_id filter target
#define VIDEO_STREAM_ID                            0x1615
#define VIDEO_STREAM_ID_2                          0x1665
#define VIDEO_STREAM_ID_3                          0x16b5
#define AUDIO_STREAM_ID                            0x1616
#define AUDIO_STREAM_ID_2                          0x1666
#define AUDIO_STREAM_ID_3                          0x16b6
#define SUB_STREAM_ID                              0x1617
#define SUB_STREAM_ID_2                            0x1667
#define SUB_STREAM_ID_3                            0x16b7
#define OTHER_STREAM_ID                            0x1618
#define OTHER_STREAM_ID_2                          0x1668
#define OTHER_STREAM_ID_3                          0x16b8
// bit 12 -- PCR_EN
// bit 11:0 -- PCR90K_DIV
#define PCR90K_CTL                                 0x1619
#define PCR90K_CTL_2                               0x1669
#define PCR90K_CTL_3                               0x16b9
// bit 15:0 -- PCR[31:0] R/W
#define PCR_DEMUX                                  0x161a
#define PCR_DEMUX_2                                0x166a
#define PCR_DEMUX_3                                0x16ba
// bit 15:0 -- VPTS[31:0] R/W
#define VIDEO_PTS_DEMUX                            0x161b
#define VIDEO_PTS_DEMUX_2                          0x166b
#define VIDEO_PTS_DEMUX_3                          0x16bb
// bit 15:0 -- VDTS[31:0] R/W
#define VIDEO_DTS_DEMUX                            0x161c
#define VIDEO_DTS_DEMUX_2                          0x166c
#define VIDEO_DTS_DEMUX_3                          0x16bc
// bit 15:0 -- APTS[31:0] R/W
#define AUDIO_PTS_DEMUX                            0x161d
#define AUDIO_PTS_DEMUX_2                          0x166d
#define AUDIO_PTS_DEMUX_3                          0x16bd
// bit 15:0 -- SPTS[31:0] R/W
#define SUB_PTS_DEMUX                              0x161e
#define SUB_PTS_DEMUX_2                            0x166e
#define SUB_PTS_DEMUX_3                            0x16be
// read -- status, write 1 clear status
// bit 15 -- SUB_PTS[32]
// bit 14 -- AUDIO_PTS[32]
// bit 13 -- VIDEO_DTS[32]
// bit 12 -- VIDEO_PTS[32]
// bit 3 -- sub_pts_ready
// bit 2 -- audio_pts_ready
// bit 1 -- video_dts_ready
// bit 0 -- video_pts_ready
#define STB_PTS_DTS_STATUS                         0x161f
#define STB_PTS_DTS_STATUS_2                       0x166f
#define STB_PTS_DTS_STATUS_3                       0x16bf
    /*----------- bit define -----------*/
    #define SUB_PTS_READY              3
    #define AUDIO_PTS_READY            2
    #define VIDEO_DTS_READY            1
    #define VIDEO_PTS_READY            0
// bit 3:0 --
//  0 -- adaptation_field_length[7:0], adaption_field_byte_1[7:0] 
//  1 -- stream_id[7:0], pes_header_bytes_left[7:0]
//  2 -- pes_package_bytes_left[15:0]
//  3 -- pes_ctr_byte[7:0], pes_flag_byte[7:0]
// 
#define STB_DEBUG_INDEX                            0x1620
#define STB_DEBUG_INDEX_2                          0x1670
#define STB_DEBUG_INDEX_3                          0x16c0
// read only
#define STB_DEBUG_DATAUT_O                         0x1621
#define STB_DEBUG_DATAUT_O_2                       0x1671
#define STB_DEBUG_DATAUT_O_3                       0x16c1
// default : 0x807f
// bit 15:9  -- MAX OM DMA COUNT  (default: 0x40) 
// bit 8:0   -- LAST ADDR OF OM ADDR (default: 127)
#define STBM_CTL_O                                 0x1622
#define STBM_CTL_O_2                               0x1672
#define STBM_CTL_O_3                               0x16c2
// 15:0  WRITE 1 CLEAR to clear interrupt source
// 9 -- splicing_point
// 8 -- other_PES_int
// 7 -- sub_PES_int 
// 6 -- discontinuity
// 5 -- duplicated_pack_found
// 4 -- New PDTS ready
// 3 -- om_cmd_buffer ready for access
// 2 -- section buffer ready 
// 1 -- transport_error_indicator
// 0 -- TS ERROR PIN 
#define STB_INT_STATUS                             0x1623
#define STB_INT_STATUS_2                           0x1673
#define STB_INT_STATUS_3                           0x16c3
    /*----------- bit define -----------*/
    #define PCR_READY                  11
    #define AUDIO_SPLICING_POINT       10
    #define VIDEO_SPLICING_POINT       9
    #define OTHER_PES_READY            8
    #define SUB_PES_READY              7
    #define DIS_CONTINUITY_PACKET      6
    #define DUPLICATED_PACKET          5
    #define NEW_PDTS_READY             4
    #define OM_CMD_READ_PENDING        3
    #define SECTION_BUFFER_READY       2
    #define TS_ERROR_PACKAGE           1
    #define TS_ERROR_PIN               0
// Bit 5:3 - demux om write endian control for bypass
// Bit 2:0 - demux om write endian control for section
// When Bit 31 - 1 write will indicate all type use sepertate endian (Write Only)
// Bit 23:21 - demux om write endian control for OTHER_PES_PACKET
// Bit 20:18 - demux om write endian control for SCR_ONLY_PACKET
// Bit 17:15 - demux om write endian control for SUB_PACKET
// Bit 14:12 - demux om write endian control for AUDIO_PACKET
// Bit 11:9  - demux om write endian control for VIDEO_PACKET
// 
// When Bit 31 - 0 write will indicate all type else use Bit 8:6
// Bit 8:6 - demux om write endian control for else
#define DEMUX_ENDIAN                               0x1624
#define DEMUX_ENDIAN_2                             0x1674
#define DEMUX_ENDIAN_3                             0x16c4
    /*----------- bit define -----------*/
    #define OTHER_ENDIAN               6
    #define BYPASS_ENDIAN              3
    #define SECTION_ENDIAN             0
// Bit 15:8 -- last_burst_threshold
// Bit 7 -- use hi_bsf interface
// Bit 6:2 - fec_clk_div
// Bit 1 ts_source_sel 
// Bit 0 - Hiu TS generate enable 
#define TS_HIU_CTL                                 0x1625
#define TS_HIU_CTL_2                               0x1675
#define TS_HIU_CTL_3                               0x16c5
    /*----------- bit define -----------*/
    #define LAST_BURST_THRESHOLD       8
    #define USE_HI_BSF_INTERFACE       7
// bit 15:0 -- base address for section buffer start (*0x10000 to get real base)
#define SEC_BUFF_BASE                              0x1626
#define SEC_BUFF_BASE_2                            0x1676
#define SEC_BUFF_BASE_3                            0x16c6
// bit 11 -- mask bit for OTHER_PES_AHB_DMA_EN
// bit 10 -- mask bit for SUB_AHB_DMA_EN
// bit 9 -- mask bit for BYPASS_AHB_DMA_EN
// bit 8 -- mask bit for SECTION_AHB_DMA_EN
// bit 7 -- mask bit for recoder stream
// bit 6:0 -- mask bit for each type
#define DEMUX_MEM_REQ_EN                           0x1627
#define DEMUX_MEM_REQ_EN_2                         0x1677
#define DEMUX_MEM_REQ_EN_3                         0x16c7
    /*----------- bit define -----------*/
    #define OTHER_PES_AHB_DMA_EN       11
    #define SUB_AHB_DMA_EN             10
    #define BYPASS_AHB_DMA_EN          9
    #define SECTION_AHB_DMA_EN         8
    #define DISCARD_PACKET             7
    #define OTHER_PES_PACKET           6
    #define SCR_ONLY_PACKET            5
    #define BYPASS_PACKET              4
    #define SECTION_PACKET             3
    #define SUB_PACKET                 2
    #define AUDIO_PACKET               1
    #define VIDEO_PACKET               0
// bit 31:0 -- vb_wr_ptr for video PDTS 
#define VIDEO_PDTS_WR_PTR                          0x1628
#define VIDEO_PDTS_WR_PTR_2                        0x1678
#define VIDEO_PDTS_WR_PTR_3                        0x16c8
// bit 31:0 -- ab_wr_ptr for audio PDTS
#define AUDIO_PDTS_WR_PTR                          0x1629
#define AUDIO_PDTS_WR_PTR_2                        0x1679
#define AUDIO_PDTS_WR_PTR_3                        0x16c9
// bit 20:0 -- SB_WRITE_PTR (sb_wr_ptr << 3 == byte write position)
#define SUB_WR_PTR                                 0x162a
#define SUB_WR_PTR_2                               0x167a
#define SUB_WR_PTR_3                               0x16ca
// bit 19:0 -- SB_START (sb_start << 12 == byte address);  
#define SB_START                                   0x162b
#define SB_START_2                                 0x167b
#define SB_START_3                                 0x16cb
// bit 20:0 -- SB_SIZE (sb_size << 3 == byte size, 16M maximun) 
#define SB_LAST_ADDR                               0x162c
#define SB_LAST_ADDR_2                             0x167c
#define SB_LAST_ADDR_3                             0x16cc
// bit 31:0 -- sb_wr_ptr for sub PES
#define SB_PES_WR_PTR                              0x162d
#define SB_PES_WR_PTR_2                            0x167d
#define SB_PES_WR_PTR_3                            0x16cd
// bit 31:16 -- ob_wr_ptr for other PES
// bit 20:0 -- OB_WRITE_PTR (ob_wr_ptr << 3 == byte write position)
#define OTHER_WR_PTR                               0x162e
#define OTHER_WR_PTR_2                             0x167e
#define OTHER_WR_PTR_3                             0x16ce
// bit 19:0 -- OB_START (ob_start << 12 == byte address);  
#define OB_START                                   0x162f
#define OB_START_2                                 0x167f
#define OB_START_3                                 0x16cf
// bit 20:0 -- OB_SIZE (ob_size << 3 == byte size, 16M maximun) 
#define OB_LAST_ADDR                               0x1630
#define OB_LAST_ADDR_2                             0x1680
#define OB_LAST_ADDR_3                             0x16d0
// bit 31:0 -- ob_wr_ptr for sub PES
#define OB_PES_WR_PTR                              0x1631
#define OB_PES_WR_PTR_2                            0x1681
#define OB_PES_WR_PTR_3                            0x16d1
// 15:0  DEMUX interrupt MASK
// 9 -- splicing_point
// 8 -- other_PES_int
// 7 -- sub_PES_int 
// 6 -- discontinuity
// 5 -- duplicated_pack_found
// 4 -- New PDTS ready
// 3 -- om_cmd_buffer ready for access
// 2 -- section buffer ready 
// 1 -- transport_error_indicator
// 0 -- TS ERROR PIN 
#define STB_INT_MASK                               0x1632
#define STB_INT_MASK_2                             0x1682
#define STB_INT_MASK_3                             0x16d2
// 31:16 VIDEO PID filter data
//15 -- splicing VIDEO PID change enable 
//14:10 -- VIDEO PID FILTER ADDRESS
// 9 -- PES splicing active (Read Only) 
// 8 -- splicing active (Read Only)
// 7:0  splicing countdown (Read Only)
#define VIDEO_SPLICING_CTL                         0x1633
#define VIDEO_SPLICING_CTL_2                       0x1683
#define VIDEO_SPLICING_CTL_3                       0x16d3
// 31:16 AUDIO PID filter data
//15 -- splicing AUDIO PID change enable 
//14:10 -- AUDIO PID FILTER ADDRESS
// 9 -- PES splicing active (Read Only) 
// 8 -- splicing active (Read Only)
// 7:0  splicing countdown (Read Only)
#define AUDIO_SPLICING_CTL                         0x1634
#define AUDIO_SPLICING_CTL_2                       0x1684
#define AUDIO_SPLICING_CTL_3                       0x16d4
// 23:16 M2TS_SKIP_BYTES
// 15:8 LAST TS PACKAGE BYTE COUNT (Read Only)
// 7:0  PACKAGE BYTE COUNT (Read Only)
#define TS_PACKAGE_BYTE_COUNT                      0x1635
#define TS_PACKAGE_BYTE_COUNT_2                    0x1685
#define TS_PACKAGE_BYTE_COUNT_3                    0x16d5
// 15:0 2 bytes strong sync add to PES
#define PES_STRONG_SYNC                            0x1636
#define PES_STRONG_SYNC_2                          0x1686
#define PES_STRONG_SYNC_3                          0x16d6
// bit 15 -- stb_om_ren
// bit 14:11 -- reserved
// bit  10:0 -- OM_DATA_RD_ADDR
#define OM_DATA_RD_ADDR                            0x1637
#define OM_DATA_RD_ADDR_2                          0x1687
#define OM_DATA_RD_ADDR_3                          0x16d7
// bit 15:0 -- OM_DATA_RD
#define OM_DATA_RD                                 0x1638
#define OM_DATA_RD_2                               0x1688
#define OM_DATA_RD_3                               0x16d8
// AUTO STOP SETTING for 32 channels
// 4-nbits per channel
// when write
// bit 3 -- set section active
// bit 2:0 -- auto stop after count (0 means never stop)
// when read
// bit 3 -- current active status (1 - active, 0 - stopped )
// bit 2:0 -- count down to auto stop
// section 31:24
#define SECTION_AUTO_STOP_3                        0x1639
#define SECTION_AUTO_STOP_3_2                      0x1689
#define SECTION_AUTO_STOP_3_3                      0x16d9
// section 23:16
#define SECTION_AUTO_STOP_2                        0x163a
#define SECTION_AUTO_STOP_2_2                      0x168a
#define SECTION_AUTO_STOP_2_3                      0x16da
// section 15:8
#define SECTION_AUTO_STOP_1                        0x163b
#define SECTION_AUTO_STOP_1_2                      0x168b
#define SECTION_AUTO_STOP_1_3                      0x16db
// section 7:0
#define SECTION_AUTO_STOP_0                        0x163c
#define SECTION_AUTO_STOP_0_2                      0x168c
#define SECTION_AUTO_STOP_0_3                      0x16dc
// bit 31:0 reset channel status - each bit reset each channel 
// read -- 32 channel status 
#define DEMUX_CHANNEL_RESET                        0x163d
#define DEMUX_CHANNEL_RESET_2                      0x168d
#define DEMUX_CHANNEL_RESET_3                      0x16dd
#define DEMUX_SCRAMBLING_STATE                     0x163e
#define DEMUX_SCRAMBLING_STATE_2                   0x168e
#define DEMUX_SCRAMBLING_STATE_3                   0x16de
#define DEMUX_CHANNEL_ACTIVITY                     0x163f
#define DEMUX_CHANNEL_ACTIVITY_2                   0x168f
#define DEMUX_CHANNEL_ACTIVITY_3                   0x16df
// bit 4 -- video_stamp_use_dts
// bit 3 -- audio_stamp_sync_1_en 
// bit 2 -- audio_stamp_insert_en 
// bit 1 -- video_stamp_sync_1_en 
// bit 0 -- video_stamp_insert_en 
#define DEMUX_STAMP_CTL                            0x1640
#define DEMUX_STAMP_CTL_2                          0x1690
#define DEMUX_STAMP_CTL_3                          0x16e0
#define DEMUX_VIDEO_STAMP_SYNC_0                   0x1641
#define DEMUX_VIDEO_STAMP_SYNC_0_2                 0x1691
#define DEMUX_VIDEO_STAMP_SYNC_0_3                 0x16e1
#define DEMUX_VIDEO_STAMP_SYNC_1                   0x1642
#define DEMUX_VIDEO_STAMP_SYNC_1_2                 0x1692
#define DEMUX_VIDEO_STAMP_SYNC_1_3                 0x16e2
#define DEMUX_AUDIO_STAMP_SYNC_0                   0x1643
#define DEMUX_AUDIO_STAMP_SYNC_0_2                 0x1693
#define DEMUX_AUDIO_STAMP_SYNC_0_3                 0x16e3
#define DEMUX_AUDIO_STAMP_SYNC_1                   0x1644
#define DEMUX_AUDIO_STAMP_SYNC_1_2                 0x1694
#define DEMUX_AUDIO_STAMP_SYNC_1_3                 0x16e4
// Write : Bit[4:0] secter filter number for reset
// Read  : select according to output_section_buffer_valid : 
//         per bit per section buffer valid status
//         or section_buffer_ignore
#define DEMUX_SECTION_RESET                        0x1645
#define DEMUX_SECTION_RESET_2                      0x1695
#define DEMUX_SECTION_RESET_3                      0x16e5
// process_header_no_copy_off   
// synopsys translate_off
// synopsys translate_on



//pctl.H
#define PCTL_SCFG_ADDR 				0x000
#define PCTL_SCTL_ADDR 				0x004
#define PCTL_STAT_ADDR 				0x008
#define PCTL_MCMD_ADDR 				0x040
#define PCTL_POWCTL_ADDR 			0x044
#define PCTL_POWSTAT_ADDR 			0x048
#define PCTL_MCFG_ADDR 				0x080
#define PCTL_PPCFG_ADDR 			0x084
#define PCTL_MSTAT_ADDR 			0x088
#define PCTL_ODTCFG_ADDR 			0x08c
#define PCTL_DQSECFG_ADDR 			0x090
#define PCTL_DTUPDES_ADDR 			0x094
#define PCTL_DTUNA_ADDR 			0x098
#define PCTL_DTUNE_ADDR 			0x09c
#define PCTL_DTUPRD0_ADDR 			0x0a0
#define PCTL_DTUPRD1_ADDR 			0x0a4
#define PCTL_DTUPRD2_ADDR 			0x0a8
#define PCTL_DTUPRD3_ADDR 			0x0ac
#define PCTL_DTUAWDT_ADDR 			0x0b0
#define PCTL_TOGCNT1U_ADDR 			0x0c0
#define PCTL_TINIT_ADDR 			0x0c4
#define PCTL_TRSTH_ADDR 			0x0c8
#define PCTL_TOGCNT100N_ADDR 		0x0cc
#define PCTL_TREFI_ADDR 			0x0d0
#define PCTL_TMRD_ADDR 				0x0d4
#define PCTL_TRFC_ADDR 				0x0d8
#define PCTL_TRP_ADDR 				0x0dc
#define PCTL_TRTW_ADDR 				0x0e0 //aa
#define PCTL_TAL_ADDR 				0x0e4
#define PCTL_TCL_ADDR 				0x0e8
#define PCTL_TCWL_ADDR 				0x0ec
#define PCTL_TRAS_ADDR 				0x0f0
#define PCTL_TRC_ADDR 				0x0f4
#define PCTL_TRCD_ADDR 				0x0f8
#define PCTL_TRRD_ADDR 				0x0fc
#define PCTL_TRTP_ADDR 				0x100
#define PCTL_TWR_ADDR 				0x104
#define PCTL_TWTR_ADDR 				0x108
#define PCTL_TEXSR_ADDR 			0x10c
#define PCTL_TXP_ADDR 				0x110
#define PCTL_TXPDLL_ADDR 			0x114 //aa
#define PCTL_TZQCS_ADDR 			0x118 //aa
#define PCTL_TZQCSI_ADDR 			0x11c //aa
#define PCTL_TDQS_ADDR 				0x120 
#define PCTL_TCKSRE_ADDR 			0x124
#define PCTL_TCKSRX_ADDR 			0x128
#define PCTL_TCKE_ADDR 				0x12c
#define PCTL_TMOD_ADDR 				0x130
#define PCTL_TRSTL_ADDR 			0x134
#define PCTL_TZQCL_ADDR 			0x138
#define PCTL_DWLCFG0_ADDR 			0x170
#define PCTL_DWLCFG1_ADDR 			0x174
#define PCTL_DWLCFG2_ADDR 			0x178
#define PCTL_DWLCFG3_ADDR 			0x17c
#define PCTL_ECCCFG_ADDR 			0x180
#define PCTL_ECCTST_ADDR 			0x184
#define PCTL_ECCCLR_ADDR 			0x188
#define PCTL_ECCLOG_ADDR 			0x18c
#define PCTL_ADDRMAP_ADDR 			0x1c0
#define PCTL_IDDEC0_ADDR 			0x1c4
#define PCTL_IDDEC1_ADDR 			0x1c8
#define PCTL_DTUWACTL_ADDR 			0x200
#define PCTL_DTURACTL_ADDR 			0x204
#define PCTL_DTUCFG_ADDR 			0x208
#define PCTL_DTUECTL_ADDR 			0x20c
#define PCTL_DTUWD0_ADDR 			0x210
#define PCTL_DTUWD1_ADDR 			0x214
#define PCTL_DTUWD2_ADDR 			0x218
#define PCTL_DTUWD3_ADDR 			0x21c
#define PCTL_DTUWDM_ADDR 			0x220
#define PCTL_DTURD0_ADDR 			0x224
#define PCTL_DTURD1_ADDR 			0x228
#define PCTL_DTURD2_ADDR 			0x22c
#define PCTL_DTURD3_ADDR 			0x230
#define PCTL_DTULFSRWD_ADDR 		0x234
#define PCTL_DTULFSRRD_ADDR 		0x238
#define PCTL_DTUEAF_ADDR 			0x23c
#define PCTL_PHYCR_ADDR 			0x240
#define PCTL_PHYSR_ADDR 			0x244
#define PCTL_IOCR_ADDR 				0x248
#define PCTL_RSLR0_ADDR 			0x24c
#define PCTL_RSLR1_ADDR 			0x250
#define PCTL_RSLR2_ADDR 			0x254
#define PCTL_RSLR3_ADDR 			0x258
#define PCTL_RDGR0_ADDR 			0x25c
#define PCTL_RDGR1_ADDR 			0x260
#define PCTL_RDGR2_ADDR 			0x264
#define PCTL_RDGR3_ADDR 			0x268
#define PCTL_ZQCR_ADDR 				0x26c
#define PCTL_ZQSR_ADDR 				0x270
#define PCTL_DLLCR_ADDR 			0x280
#define PCTL_DLLCR0_ADDR 			0x284
#define PCTL_DLLCR1_ADDR 			0x288
#define PCTL_DLLCR2_ADDR 			0x28c
#define PCTL_DLLCR3_ADDR 			0x290
#define PCTL_DLLCR4_ADDR 			0x294
#define PCTL_DLLCR5_ADDR 			0x298
#define PCTL_DLLCR6_ADDR 			0x29c
#define PCTL_DLLCR7_ADDR 			0x2a0
#define PCTL_DLLCR8_ADDR 			0x2a4
#define PCTL_DLLCR9_ADDR 			0x2a8
#define PCTL_DQTR0_ADDR 			0x2c0
#define PCTL_DQTR1_ADDR 			0x2c4
#define PCTL_DQTR2_ADDR 			0x2c8
#define PCTL_DQTR3_ADDR 			0x2cc
#define PCTL_DQTR4_ADDR 			0x2d0
#define PCTL_DQTR5_ADDR 			0x2d4
#define PCTL_DQTR6_ADDR 			0x2d8
#define PCTL_DQTR7_ADDR 			0x2dc
#define PCTL_DQTR8_ADDR 			0x2e0
#define PCTL_DQSTR_ADDR 			0x2e4
#define PCTL_DQSNTR_ADDR 			0x2e8
#define PCTL_PHYPVTCFG_ADDR 		0x300
#define PCTL_PHYPVTSTAT_ADDR 		0x304
#define PCTL_PHYTUPDON_ADDR 		0x308
#define PCTL_PHYTUPDDLY_ADDR 		0x30c
#define PCTL_PVTTUPDON_ADDR 		0x310
#define PCTL_PVTTUPDDLY_ADDR 		0x314
#define PCTL_PHYPVTUPDI_ADDR 		0x318
#define PCTL_SCHCFG_ADDR 			0x380
#define PCTL_IPVR_ADDR 				0x3f8
#define PCTL_IPTR_ADDR 				0x3fc


#define MMC_DDR_CTRL        0x1000 
#define MMC_REQ_CTRL        0x1004 
#define MMC_ARB_CTRL        0x1008 
#define MMC_ARB_CTRL1       0x100c 

#define MMC_QOS0_CTRL  0x1010
   //bit 31     qos enable.
   //bit 26     1 : danamic change the bandwidth percentage. 0 : fixed bandwidth.  all 64. 
   //bit 25       grant mode. 1 grant clock cycles. 0 grant data cycles.
   //bit 24       leakybucket counter goes to 0. When no req or no other request. 
   //bit 21:16    bankwidth requirement. unit 1/64. 
   //bit 15:0.    after stop the re_enable threadhold.

#define MMC_QOS0_MAX   0x1014
#define MMC_QOS0_MIN   0x1018
#define MMC_QOS0_LIMIT 0x101c
#define MMC_QOS0_STOP  0x1020
#define MMC_QOS1_CTRL  0x1024
#define MMC_QOS1_MAX   0x1028
#define MMC_QOS1_MIN   0x102c
#define MMC_QOS1_STOP  0x1030
#define MMC_QOS1_LIMIT 0x1034
#define MMC_QOS2_CTRL  0x1038
#define MMC_QOS2_MAX   0x103c
#define MMC_QOS2_MIN   0x1040
#define MMC_QOS2_STOP  0x1044
#define MMC_QOS2_LIMIT 0x1048
#define MMC_QOS3_CTRL  0x104c
#define MMC_QOS3_MAX   0x1050
#define MMC_QOS3_MIN   0x1054
#define MMC_QOS3_STOP  0x1058
#define MMC_QOS3_LIMIT 0x105c
#define MMC_QOS4_CTRL  0x1060
#define MMC_QOS4_MAX   0x1064
#define MMC_QOS4_MIN   0x1068
#define MMC_QOS4_STOP  0x106c
#define MMC_QOS4_LIMIT 0x1070
#define MMC_QOS5_CTRL  0x1074
#define MMC_QOS5_MAX   0x1078
#define MMC_QOS5_MIN   0x107c
#define MMC_QOS5_STOP  0x1080
#define MMC_QOS5_LIMIT 0x1084
#define MMC_QOS6_CTRL  0x1088
#define MMC_QOS6_MAX   0x108c
#define MMC_QOS6_MIN   0x1090
#define MMC_QOS6_STOP  0x1094
#define MMC_QOS6_LIMIT 0x1098
#define MMC_QOS7_CTRL  0x109c
#define MMC_QOS7_MAX   0x10a0
#define MMC_QOS7_MIN   0x10a4
#define MMC_QOS7_STOP  0x10a8
#define MMC_QOS7_LIMIT 0x10ac

#define MMC_QOSMON_CTRL     0x10b0
#define MMC_QOSMON_TIM      0x10b4
#define MMC_QOSMON_MST      0x10b8
#define MMC_MON_CLKCNT      0x10bc
#define MMC_ALL_REQCNT      0x10c0
#define MMC_ALL_GANTCNT     0x10c4
#define MMC_ONE_REQCNT      0x10c8
#define MMC_ONE_CYCLE_CNT   0x10cc
#define MMC_ONE_DATA_CNT    0x10d0



#define DC_CAV_CTRL               0x1300

#define DC_CAV_LVL3_GRANT         0x1304
#define DC_CAV_LVL3_GH            0x1308
  // this is a 32 bit grant regsiter.
  // each bit grant a thread ID for LVL3 use.

#define DC_CAV_LVL3_FLIP          0x130c
#define DC_CAV_LVL3_FH            0x1310
  // this is a 32 bit FLIP regsiter.
  // each bit to define  a thread ID for LVL3 use.

#define DC_CAV_LVL3_CTRL0         0x1314
#define DC_CAV_LVL3_CTRL1         0x1318
#define DC_CAV_LVL3_CTRL2         0x131c
#define DC_CAV_LVL3_CTRL3         0x1320
#define DC_CAV_LUT_DATAL          0x1324
    #define CANVAS_ADDR_LMASK       0x1fffffff
    #define CANVAS_WIDTH_LMASK		0x7
    #define CANVAS_WIDTH_LWID		3
    #define CANVAS_WIDTH_LBIT		29
#define DC_CAV_LUT_DATAH          0x1328
	#define CANVAS_WIDTH_HMASK		0x1ff
	#define CANVAS_WIDTH_HBIT		0
	#define CANVAS_HEIGHT_MASK		0x1fff
	#define CANVAS_HEIGHT_BIT		9
	#define CANVAS_YWRAP			(1<<23)
	#define CANVAS_XWRAP			(1<<22)
    #define CANVAS_ADDR_NOWRAP      0x00
    #define CANVAS_ADDR_WRAPX       0x01
    #define CANVAS_ADDR_WRAPY       0x02
    #define CANVAS_BLKMODE_MASK     3
    #define CANVAS_BLKMODE_BIT      24
    #define CANVAS_BLKMODE_LINEAR   0x00
    #define CANVAS_BLKMODE_32X32    0x01
    #define CANVAS_BLKMODE_64X32    0x02
#define DC_CAV_LUT_ADDR           0x132c
    #define CANVAS_LUT_INDEX_BIT    0
    #define CANVAS_LUT_INDEX_MASK   0x7
    #define CANVAS_LUT_WR_EN        (0x2 << 8)
    #define CANVAS_LUT_RD_EN        (0x1 << 8)
#define DC_CAV_LVL3_MODE          0x1330
#define MMC_PROT_ADDR             0x1334 
#define MMC_PROT_SELH             0x1338 
#define MMC_PROT_SELL             0x133c 
#define MMC_PROT_CTL_STS          0x1340 
#define MMC_INT_STS               0x1344 
#define MMC_PHY_CTRL              0x1380
#define MMC_APB3_CTRL             0x1384

#define MMC_REQ0_CTRL             0x1388
   // bit 31,            request in enable.
   // 30:24:             cmd fifo counter when request generate to dmc arbitor if there's no lbrst.
   // 23:16:             waiting time when request generate to dmc arbitor if there's o lbrst.
   // 15:8:              how many write rsp can hold in the whole dmc pipe lines.
   // 7:0:               how many read data can hold in the whole dmc pipe lines.

#define MMC_REQ1_CTRL             0x138c
#define MMC_REQ2_CTRL             0x1390
#define MMC_REQ3_CTRL             0x1394
#define MMC_REQ4_CTRL             0x1398
#define MMC_REQ5_CTRL             0x139c
#define MMC_REQ6_CTRL             0x13a0
#define MMC_REQ7_CTRL             0x13a4


//
// Reading file:  ./register_map.h
//
// synopsys translate_off
// synopsys translate_on
//
// Reading file:  stb_define.h
//
// synopsys translate_off
// synopsys translate_on
// -----------------------------------------------
// CBUS_BASE:  STB_CBUS_BASE = 0x16
// -----------------------------------------------
// There are two instantiations under one CBUS slave.  Each CBUS slave can support
// 256 registers.  Each demux is allocated 128 registers so set the offset in
// the middle
// Copy this define but don't add a base address
#define SECOND_DEMUX_OFFSET_0  0x50
#define THIRD_DEMUX_OFFSET_0   0xa0
//========================================================================
//  STB TOP Registers				    (8'hf0 - 8'hf7)
//========================================================================
// bit 22 -- invert fec_error for S2P1
// bit 21 -- invert fec_data for S2P1
// bit 20 -- invert fec_sync for S2P1
// bit 19 -- invert fec_valid for S2P1
// bit 18 -- invert fec_clk for S2P1
// bit 17:16 -- fec_s_sel for S2P1  00 - select TS0, 01 -- select TS1, 10 -- select TS2, 11 - reserved
// Bit 15 -- enable_des_pl_clk
// Bit 14:13 -- reserved
// Bit 12:10 -- ts_out_select, 0-TS0, 1-TS1, 2-TS2, 3,4-Reserved, 5-S2P1, 6-S2P0, 7-File
// bit 9:8 -- des_i_sel 00 -- select_fec_0, 01 -- select_fec_1, 10 -- select_fec_2, 11 - reserved
// bit 7 -- enable_des_pl
// bit 6 -- invert fec_error for S2P0
// bit 5 -- invert fec_data for S2P0
// bit 4 -- invert fec_sync for S2P0
// bit 3 -- invert fec_valid for S2P0
// bit 2 -- invert fec_clk for S2P0
// bit 1:0 -- fec_s_sel for S2P0  00 - select TS0, 01 -- select TS1, 10 -- select TS2, 11 - reserved
#define STB_TOP_CONFIG                             0x16f0
    /*----------- bit define -----------*/
    #define TS_OUTPUT_SOURCE            10
    #define DES_INPUT_SEL               8
    #define ENABLE_DES_PL               7
    #define INVERT_FEC_ERROR            6
    #define INVERT_FEC_DATA             5
    #define INVERT_FEC_SYNC             4
    #define INVERT_FEC_VALID            3
    #define INVERT_FEC_CLK              2
    #define FEC_SERIAL_SEL              0
// 15:8 -- TS_package_length_sub_1 (default : 187)
//  7:0 -- fec_sync_byte (default : 0x47)
#define TS_TOP_CONFIG                              0x16f1
    /*----------- bit define -----------*/
    #define TS_PACKAGE_LENGTH_SUB_1     8
    #define FEC_DEFAULT_SYNC_BYTE       0
// Bit 23:16 -- file_m2ts_skip_bytes
// Bit 15:8 -- des_out_dly
// Bit 7:6 -- transport_scrambling_control_odd // should be 3
// Bit 5 -- ts_hiu_enable
// Bit 4:0 -- fec_clk_div
#define TS_FILE_CONFIG                             0x16f2
    /*----------- bit define -----------*/
    #define DES_OUT_DLY                 8
    #define TRANSPORT_SCRAMBLING_CONTROL_ODD         6
    #define TS_HIU_ENABLE               5
    #define FEC_FILE_CLK_DIV            0
// Bit 13:8 -- des ts pl state   -- Read Only
// Bit 3:0 PID index to 8 PID to get key-set
// auto increse after TS_PL_PID_DATA read/write
#define TS_PL_PID_INDEX                            0x16f3
    /*----------- bit define -----------*/
    #define DES_TS_PL_STATE             8
// Bit 13 -- PID match disble
// Bit 12:0 -- PID
#define TS_PL_PID_DATA                             0x16f4
    /*----------- bit define -----------*/
    #define PID_MATCH_LOW                0
    #define PID_MATCH_DISABLE_LOW        13
    #define PID_MATCH_HIGH               16
    #define PID_MATCH_DISABLE_HIGH       29
#define COMM_DESC_KEY0                             0x16f5
#define COMM_DESC_KEY1                             0x16f6
#define COMM_DESC_KEY_RW                           0x16f7
//
// NOTE:  Don't process the demux registers using the standard create_headers.... perl script.
//        Instead, since the demux has multiple instances (and many registers) use a separate
//        script to create a separate stb_define.h for C-code.  
//========================================================================
//  STB Registers				    (8'h00 - 8'h4f)
//
//========================================================================
// STB registers are 8'h0x
// Bit 15:0 -- version number : 0x0002  (v0.01)
// Bit 15 -- fec_core_select 1 - select descramble output
// Bit 14:12 -  fec_select 0-TS0, 1-TS1, 2-TS2, 3,4-Reserved, 5-S2P1, 6-S2P0, 7-File 
// Bit 11 -- FEC_CLK
// Bit 10 -- SOP
// Bit 9 -- D_VALID
// Bit 8 -- D_FAIL
// Bit 7:0 -- D_DATA 7:0
// bit 31 -- enable_free_clk_fec_data_valid
// bit 30 -- enable_free_clk_stb_reg
// bit 29:21 -- reserved
// bit 20 (bit 4) -- Bypass use recoder path
// bit 19 (bit 3) -- clear_PID_continuity_counter_valid
// bit 18 (bit 2) -- Disable Splicing
// bit 17 (bit 1) -- Insert PES_STRONG_SYNC in Audio PES
// bit 16 (bit 0) -- Insert PES_STRONG_SYNC in Video PES
// Bit 15 - do not trust section length
// Bit 14 - om cmd push even zero
// Bit 13 - reserved
// Bit 12 - SUB, OTHER PES interrupt at beginning of PES
// Bit 11 - discard_av_package -- for ts_recorder use only 
// Bit 10 - ts_recorder_select  0:after PID filter 1:before PID filter
// Bit 9 - ts_recorder_enable
// Bit 8 - (table_id == 0xff) means section_end
// Bit 7 - do not send uncomplete section
// Bit 6 - do not discard duplicate package
// Bit 5 - search SOP when trasport_error_indicator
// Bit 4 - stb demux enable
// Bit 3 - do not reset state machine on SOP
// Bit 2 - search SOP when error happened ( when ignore_fail_n_sop, will have this case)
// Bit 1 - do not use SOP input ( check FEC sync byte instead )
// Bit 0 - ignore fec_error bit when non sop ( check error on SOP only)
// bit 15:8 demux package length - 1 ( default : 187 )
// bit 7:0 default is 0x47
// bit 31:16 -- filter memory write data hi[31:16]
// bit 15:0 -- filter memory write data low [15:0]
// bit 31:24 -- advanced setting hi
// bit 23:16 -- advanced setting low
// bit 15 -- filter memory write data request
// bit 7:0 -- filter memory write addr
// bit 13:8 demux state  -- read only
// bit 7:4 -- maxnum section filter compare address
// bit 3:0 -- maxnum PID filter compare address
// bit 15 - transport_error_indicator
// bit 14 - payload_unit_start_indicator
// bit 13 - transport_priority
// bit 12:0 - PID
// bit 7:6 transport_scrambling_control
// bit 5:4 adaptation_field_control
// bit 3:0 continuity_counter
// bit 15:12 -- om_cmd_count (read only)
// bit  11:9 -- overflow_count // bit  11:9 -- om_cmd_wr_ptr (read only)
// bit   8:6 -- om_overwrite_count // bit   8:6 -- om_cmd_rd_ptr (read only)
// bit   5:3 -- type_stb_om_w_rd (read only)
// bit     2 -- unit_start_stb_om_w_rd (read only)
// bit     1 -- om_cmd_overflow (read only)
// bit     0 -- om_cmd_pending (read) 
// bit     0 -- om_cmd_read_finished (write)
// bit 15:9 // bit 14:8 -- count_stb_om_w_rd  (read only)
// bit 8:0  // bit  7:0 -- start_stb_om_wa_rd (read only)
// bit 11:0 -- offset for section data
// bit 31:16 -- base address for section buffer group 0 (*0x400 to get real address)
// bit 15:0 -- base address for section buffer group 1 (*0x400 to get real address)
// bit 31:16 -- ba2e address for section buffer group 2 (*0x400 to get real address)
// bit 15:0 -- base address for section buffer group 3 (*0x400 to get real address)
// bit 3:0 -- section buffer size for group 0 (bit used,  for example, 10 means 1K)
// bit 7:4 -- section buffer size for group 1
// bit 11:8 -- section buffer size for group 2
// bit 15:12 -- section buffer size for group 3
// section buffer busy status for buff 31:0 ( Read Only )
// section buffer write status for buff 31:0 -- Read
// clear buffer status ( buff READY and BUSY ) -- write
// bit 4:0 -- SEC_BUFFER_INDEX   RW
// bit 12:8 -- SEC_BUFFER_NUMBER for the INDEX buffer  Read_Only
// bit 14 -- output_section_buffer_valid
// bit 15 -- section_reset_busy (Read Only)
// bit 9:5 -- BYPASS PID number
// bit 4:0 -- PCR PID number
// bit 15:0 -- stream_id filter bit enable
// bit 7:0 -- stream_id filter target
// bit 12 -- PCR_EN
// bit 11:0 -- PCR90K_DIV
// bit 15:0 -- PCR[31:0] R/W
// bit 15:0 -- VPTS[31:0] R/W
// bit 15:0 -- VDTS[31:0] R/W
// bit 15:0 -- APTS[31:0] R/W
// bit 15:0 -- SPTS[31:0] R/W
// read -- status, write 1 clear status
// bit 15 -- SUB_PTS[32]
// bit 14 -- AUDIO_PTS[32]
// bit 13 -- VIDEO_DTS[32]
// bit 12 -- VIDEO_PTS[32]
// bit 3 -- sub_pts_ready
// bit 2 -- audio_pts_ready
// bit 1 -- video_dts_ready
// bit 0 -- video_pts_ready
// bit 3:0 --
//  0 -- adaptation_field_length[7:0], adaption_field_byte_1[7:0] 
//  1 -- stream_id[7:0], pes_header_bytes_left[7:0]
//  2 -- pes_package_bytes_left[15:0]
//  3 -- pes_ctr_byte[7:0], pes_flag_byte[7:0]
// 
// read only
// default : 0x807f
// bit 15:9  -- MAX OM DMA COUNT  (default: 0x40) 
// bit 8:0   -- LAST ADDR OF OM ADDR (default: 127)
// 15:0  WRITE 1 CLEAR to clear interrupt source
// 9 -- splicing_point
// 8 -- other_PES_int
// 7 -- sub_PES_int 
// 6 -- discontinuity
// 5 -- duplicated_pack_found
// 4 -- New PDTS ready
// 3 -- om_cmd_buffer ready for access
// 2 -- section buffer ready 
// 1 -- transport_error_indicator
// 0 -- TS ERROR PIN 
// Bit 5:3 - demux om write endian control for bypass
// Bit 2:0 - demux om write endian control for section
// When Bit 31 - 1 write will indicate all type use sepertate endian (Write Only)
// Bit 23:21 - demux om write endian control for OTHER_PES_PACKET
// Bit 20:18 - demux om write endian control for SCR_ONLY_PACKET
// Bit 17:15 - demux om write endian control for SUB_PACKET
// Bit 14:12 - demux om write endian control for AUDIO_PACKET
// Bit 11:9  - demux om write endian control for VIDEO_PACKET
// 
// When Bit 31 - 0 write will indicate all type else use Bit 8:6
// Bit 8:6 - demux om write endian control for else
// Bit 15:8 -- last_burst_threshold
// Bit 7 -- use hi_bsf interface
// Bit 6:2 - fec_clk_div
// Bit 1 ts_source_sel 
// Bit 0 - Hiu TS generate enable 
// bit 15:0 -- base address for section buffer start (*0x10000 to get real base)
// bit 11 -- mask bit for OTHER_PES_AHB_DMA_EN
// bit 10 -- mask bit for SUB_AHB_DMA_EN
// bit 9 -- mask bit for BYPASS_AHB_DMA_EN
// bit 8 -- mask bit for SECTION_AHB_DMA_EN
// bit 7 -- mask bit for recoder stream
// bit 6:0 -- mask bit for each type
// bit 31:0 -- vb_wr_ptr for video PDTS 
// bit 31:0 -- ab_wr_ptr for audio PDTS
// bit 20:0 -- SB_WRITE_PTR (sb_wr_ptr << 3 == byte write position)
// bit 19:0 -- SB_START (sb_start << 12 == byte address);  
// bit 20:0 -- SB_SIZE (sb_size << 3 == byte size, 16M maximun) 
// bit 31:0 -- sb_wr_ptr for sub PES
// bit 31:16 -- ob_wr_ptr for other PES
// bit 20:0 -- OB_WRITE_PTR (ob_wr_ptr << 3 == byte write position)
// bit 19:0 -- OB_START (ob_start << 12 == byte address);  
// bit 20:0 -- OB_SIZE (ob_size << 3 == byte size, 16M maximun) 
// bit 31:0 -- ob_wr_ptr for sub PES
// 15:0  DEMUX interrupt MASK
// 9 -- splicing_point
// 8 -- other_PES_int
// 7 -- sub_PES_int 
// 6 -- discontinuity
// 5 -- duplicated_pack_found
// 4 -- New PDTS ready
// 3 -- om_cmd_buffer ready for access
// 2 -- section buffer ready 
// 1 -- transport_error_indicator
// 0 -- TS ERROR PIN 
// 31:16 VIDEO PID filter data
//15 -- splicing VIDEO PID change enable 
//14:10 -- VIDEO PID FILTER ADDRESS
// 9 -- PES splicing active (Read Only) 
// 8 -- splicing active (Read Only)
// 7:0  splicing countdown (Read Only)
// 31:16 AUDIO PID filter data
//15 -- splicing AUDIO PID change enable 
//14:10 -- AUDIO PID FILTER ADDRESS
// 9 -- PES splicing active (Read Only) 
// 8 -- splicing active (Read Only)
// 7:0  splicing countdown (Read Only)
// 23:16 M2TS_SKIP_BYTES
// 15:8 LAST TS PACKAGE BYTE COUNT (Read Only)
// 7:0  PACKAGE BYTE COUNT (Read Only)
// 15:0 2 bytes strong sync add to PES
// bit 15 -- stb_om_ren
// bit 14:11 -- reserved
// bit  10:0 -- OM_DATA_RD_ADDR
// bit 15:0 -- OM_DATA_RD
// AUTO STOP SETTING for 32 channels
// 4-nbits per channel
// when write
// bit 3 -- set section active
// bit 2:0 -- auto stop after count (0 means never stop)
// when read
// bit 3 -- current active status (1 - active, 0 - stopped )
// bit 2:0 -- count down to auto stop
// section 31:24
// section 23:16
// section 15:8
// section 7:0
// bit 31:0 reset channel status - each bit reset each channel 
// read -- 32 channel status 
// bit 4 -- video_stamp_use_dts
// bit 3 -- audio_stamp_sync_1_en 
// bit 2 -- audio_stamp_insert_en 
// bit 1 -- video_stamp_sync_1_en 
// bit 0 -- video_stamp_insert_en 
// Write : Bit[4:0] secter filter number for reset
// Read  : select according to output_section_buffer_valid : 
//         per bit per section buffer valid status
//         or section_buffer_ignore
// synopsys translate_off
// synopsys translate_on
//
// Closing file:  stb_define.h
//
//
// Reading file:  periphs_reg.h
//
// $periphs/rtl/periphs_core register defines for the 
// APB bus
// -------------------------------------------------------------------
// PSEL Group #0:  0x000 ~ 0xFF
// -------------------------------------------------------------------
// -----------------------------------------------
// CBUS_BASE:  PERIPHS0_CBUS_BASE = 0x20
// -----------------------------------------------
// The following are handled by $periphs/rtl/periphs_reg.v
#define PREG_CTLREG0_ADDR                          0x2000
// ----------------------------
// Dummy regs to keep XIF ports from being synthesized away
// ----------------------------
#define XIF_DUMMY_0                                0x2001
#define XIF_DUMMY_1                                0x2002
#define XIF_DUMMY_2                                0x2003
#define XIF_DUMMY_3                                0x2004
#define XIF_DUMMY_4                                0x2005
// ----------------------------
#define PREG_JTAG_GPIO_ADDR                        0x200b
// ----------------------------
// Pre-defined GPIO addresses
// ----------------------------
#define PREG_EGPIO_EN_N                            0x200c
#define PREG_EGPIO_O                               0x200d
#define PREG_EGPIO_I                               0x200e
// ----------------------------
#define PREG_FGPIO_EN_N                            0x200f
#define PREG_FGPIO_O                               0x2010
#define PREG_FGPIO_I                               0x2011
// ----------------------------
#define PREG_GGPIO_EN_N                            0x2012
#define PREG_GGPIO_O                               0x2013
#define PREG_GGPIO_I                               0x2014
// ----------------------------
#define PREG_HGPIO_EN_N                            0x2015
#define PREG_HGPIO_O                               0x2016
#define PREG_HGPIO_I                               0x2017
// ----------------------------
// Pre-defined GPIO addresses
// ----------------------------
#define PREG_PAD_GPIO0_EN_N                        0x200c
#define PREG_PAD_GPIO0_O                           0x200d
#define PREG_PAD_GPIO0_I                           0x200e
// ----------------------------
#define PREG_PAD_GPIO1_EN_N                        0x200f
#define PREG_PAD_GPIO1_O                           0x2010
#define PREG_PAD_GPIO1_I                           0x2011
// ----------------------------
#define PREG_PAD_GPIO2_EN_N                        0x2012
#define PREG_PAD_GPIO2_O                           0x2013
#define PREG_PAD_GPIO2_I                           0x2014
// ----------------------------
#define PREG_PAD_GPIO3_EN_N                        0x2015
#define PREG_PAD_GPIO3_O                           0x2016
#define PREG_PAD_GPIO3_I                           0x2017
// ----------------------------
#define PREG_PAD_GPIO4_EN_N                        0x2018
#define PREG_PAD_GPIO4_O                           0x2019
#define PREG_PAD_GPIO4_I                           0x201a
// ----------------------------
#define PREG_PAD_GPIO5_EN_N                        0x201b
#define PREG_PAD_GPIO5_O                           0x201c
#define PREG_PAD_GPIO5_I                           0x201d
// ----------------------------
// unused `define PREG_IGPIO_EN_N                     8'h18
// unused `define PREG_IGPIO_O                        8'h19
// unused `define PREG_IGPIO_I                        8'h1a
// ----------------------------
// unused `define PREG_JGPIO_EN_N                     8'h1b
// unused `define PREG_JGPIO_O                        8'h1c
// unused `define PREG_JGPIO_I                        8'h1d
// ----------------------------
// A9 and L2 chche
// ----------------------------
#define A9_CFG0                                    0x2020
#define A9_CFG1                                    0x2021
#define A9_CFG2                                    0x2022
#define A9_PERIPH_BASE                             0x2023
#define A9_L2_REG_BASE                             0x2024
#define A9_L2_STATUS                               0x2025
#define A9_POR_CFG                                 0x2026
// ----------------------------
// Pin Mux  (9)
// ----------------------------
#define PERIPHS_PIN_MUX_0                          0x202c
#define PERIPHS_PIN_MUX_1                          0x202d
#define PERIPHS_PIN_MUX_2                          0x202e
#define PERIPHS_PIN_MUX_3                          0x202f
#define PERIPHS_PIN_MUX_4                          0x2030
#define PERIPHS_PIN_MUX_5                          0x2031
#define PERIPHS_PIN_MUX_6                          0x2032
#define PERIPHS_PIN_MUX_7                          0x2033
#define PERIPHS_PIN_MUX_8                          0x2034
#define PERIPHS_PIN_MUX_9                          0x2035
#define PERIPHS_PIN_MUX_10                         0x2036
#define PERIPHS_PIN_MUX_11                         0x2037
#define PERIPHS_PIN_MUX_12                         0x2038
// ----------------------------
// Pad conntrols
// ----------------------------
#define PAD_PULL_UP_REG0                           0x203b
#define PAD_PULL_UP_REG1                           0x203c
#define PAD_PULL_UP_REG2                           0x203d
#define PAD_PULL_UP_REG3                           0x203e
// ----------------------------
// Random (2)
// ----------------------------
#define RAND64_ADDR0                               0x2040
#define RAND64_ADDR1                               0x2041
// ---------------------------
// Ethernet (1)
// ----------------------------
#define PREG_ETHERNET_ADDR0                        0x2042
// ---------------------------
// AM_ANALOG_TOP
// ----------------------------
#define PREG_AM_ANALOG_ADDR                        0x2043
// ---------------------------
// Mali55 (1)
// ----------------------------
#define PREG_MALI_BYTE_CNTL                        0x2044
// ---------------------------
// WIFI (1)
// ----------------------------
#define PREG_WIFI_CNTL                             0x2045
// ---------------------------
// SATA 
// ----------------------------
#define PREG_SATA_REG0                             0x2050
#define PREG_SATA_REG1                             0x2051
#define PREG_SATA_REG2                             0x2052
#define PREG_SATA_REG3                             0x2053
#define PREG_SATA_REG4                             0x2054
#define PREG_SATA_REG5                             0x2055
// ---------------------------
// am_analog_top
// ----------------------------
#define AM_ANALOG_TOP_REG0                         0x206e
// ---------------------------
// Sticky regs
// ----------------------------
#define PREG_STICKY_REG0                           0x207c
#define PREG_STICKY_REG1                           0x207d
// ---------------------------
// AM Ring Oscillator 
// ----------------------------
#define AM_RING_OSC_REG0                           0x207f
// -------------------------------------------------------------------
// PSEL Group #1:  0x400 ~ 0x7FF
// -------------------------------------------------------------------
// -----------------------------------------------
// CBUS_BASE:  PERIPHS1_CBUS_BASE = 0x21
// -----------------------------------------------
// ----------------------------
// $usb/rtl/usb_reg.v   (8)
// ----------------------------

#define USB_ADDR0                                  0x2100
#define USB_ADDR1                                  0x2101
#define USB_ADDR2                                  0x2102
#define USB_ADDR3                                  0x2103
#define USB_ADDR4                                  0x2104
#define USB_ADDR5                                  0x2105
#define USB_ADDR6                                  0x2106
// ----------------------------
// Smart Card (8)
// ----------------------------
#define SMARTCARD_REG0                             0x2110
#define SMARTCARD_REG1                             0x2111
#define SMARTCARD_REG2                             0x2112
#define SMARTCARD_STATUS                           0x2113
#define SMARTCARD_INTR                             0x2114
#define SMARTCARD_REG5                             0x2115
#define SMARTCARD_REG6                             0x2116
#define SMARTCARD_FIFO                             0x2117
// ----------------------------
// IR Remote (8)
// ----------------------------
#define IR_DEC_LDR_ACTIVE                          0x2120
#define IR_DEC_LDR_IDLE                            0x2121
#define IR_DEC_LDR_REPEAT                          0x2122
#define IR_DEC_BIT_0                               0x2123
#define IR_DEC_REG0                                0x2124
#define IR_DEC_FRAME                               0x2125
#define IR_DEC_STATUS                              0x2126
#define IR_DEC_REG1                                0x2127
// ----------------------------
// WIFI
// ----------------------------
#define WIFI_ADC_SAMPLING                          0x212e
#define WIFI_ADC_READBACK                          0x212f
// ----------------------------
// UART0
// ----------------------------
#define UART0_WFIFO                                0x2130
#define UART0_RFIFO                                0x2131
#define UART0_CONTROL                              0x2132
#define UART0_STATUS                               0x2133
#define UART0_MISC                                 0x2134
// ----------------------------
// UART1
// ----------------------------
#define UART1_WFIFO                                0x2137
#define UART1_RFIFO                                0x2138
#define UART1_CONTROL                              0x2139
#define UART1_STATUS                               0x213a
#define UART1_MISC                                 0x213b
// ----------------------------
// Dynamic pin sampling
// ----------------------------
#define DYNAMIC_PIN_SAMPLE_REG0                    0x213c
#define DYNAMIC_PIN_SAMPLE_REG1                    0x213d
// ----------------------------
// I2C Master (8)
// ----------------------------
#define I2C_M_0_CONTROL_REG                        0x2140
    #define     I2C_M_MANUAL_SDA_I        26
    #define     I2C_M_MANUAL_SCL_I        25
    #define     I2C_M_MANUAL_SDA_O        24
    #define     I2C_M_MANUAL_SCL_O        23
    #define     I2C_M_MANUAL_EN           22
    #define     I2C_M_DELAY_MSB           21
    #define     I2C_M_DELAY_LSB           12
    #define     I2C_M_DATA_CNT_MSB        11
    #define     I2C_M_DATA_CNT_LSB        8
    #define     I2C_M_CURR_TOKEN_MSB      7
    #define     I2C_M_CURR_TOKEN_LSB      4
    #define     I2C_M_ERROR               3
    #define     I2C_M_STATUS              2
    #define     I2C_M_ACK_IGNORE          1
    #define     I2C_M_START               0
#define I2C_M_0_SLAVE_ADDR                         0x2141
#define I2C_M_0_TOKEN_LIST0                        0x2142
#define I2C_M_0_TOKEN_LIST1                        0x2143
#define I2C_M_0_WDATA_REG0                         0x2144
#define I2C_M_0_WDATA_REG1                         0x2145
#define I2C_M_0_RDATA_REG0                         0x2146
#define I2C_M_0_RDATA_REG1                         0x2147
// ----------------------------
// I2C Master 
// ----------------------------
#define I2C_M_1_CONTROL_REG                        0x2148
#define I2C_M_1_SLAVE_ADDR                         0x2149
#define I2C_M_1_TOKEN_LIST0                        0x214a
#define I2C_M_1_TOKEN_LIST1                        0x214b
#define I2C_M_1_WDATA_REG0                         0x214c
#define I2C_M_1_WDATA_REG1                         0x214d
#define I2C_M_1_RDATA_REG0                         0x214e
#define I2C_M_1_RDATA_REG1                         0x214f
// ----------------------------
// I2C Slave (3)
// ----------------------------
#define I2C_S_CONTROL_REG                          0x2150
#define I2C_S_SEND_REG                             0x2151
#define I2C_S_RECV_REG                             0x2152
#define I2C_S_CNTL1_REG                            0x2153
// ----------------------------
// PWM / DS A/B
// ----------------------------
#define PWM_PWM_A                                  0x2154
#define PWM_PWM_B                                  0x2155
#define PWM_MISC_REG_AB                            0x2156
#define PWM_DELTA_SIGMA_AB                         0x2157
// ---------------------------
// EFUSE (4)
// ----------------------------
#define EFUSE_CNTL0                                0x2158
#define EFUSE_CNTL1                                0x2159
#define EFUSE_CNTL2                                0x215a
#define EFUSE_CNTL3                                0x215b
#define EFUSE_CNTL4                                0x215c
// ---------------------------------------------
// Separate APB slave that shares the CBUS/APB
// register space of the static registers
// ---------------------------------------------
#define ATAPI_IDEREG0                              0x2160
   #define IDE_UDMA_PIO_STATE         15
   #define IDE_BUSY                   14
   #define IDE_ERROR_BIT              13
   #define IDE_DMARQ_BIT              12
   #define IDE_IORDY_BIT              11
   #define IDE_IORDY_EN_BIT           10
   #define IDE_DIS_CSEL_BIT            9
   #define IDE_CSEL_BIT                8
   #define IDE_IRQ14                   2
   #define IDE_ATAPI_GPIO_EN           3
   #define IDE_DMARQ_FULL              1
   #define IDE_ENABLE                  0
#define ATAPI_IDEREG1                              0x2161
#define ATAPI_IDEREG2                              0x2162
    #define IDE_XFER_CNT_MSB_BIT      18
    #define IDE_XFER_CNT_LSB_BIT       0
#define ATAPI_CYCTIME                              0x2163
#define ATAPI_IDETIME                              0x2164
#define ATAPI_PIO_TIMING                           0x2165
#define ATAPI_TABLE_ADD_REG                        0x2166
#define ATAPI_IDEREG3                              0x2167
#define ATAPI_UDMA_REG0                            0x2168
#define ATAPI_UDMA_REG1                            0x2169
// Room for registers here
#define TRANS_PWMA_REG0                            0x2170
#define TRANS_PWMA_REG1                            0x2171
#define TRANS_PWMA_MUX0                            0x2172
#define TRANS_PWMA_MUX1                            0x2173
#define TRANS_PWMA_MUX2                            0x2174
#define TRANS_PWMA_MUX3                            0x2175
#define TRANS_PWMA_MUX4                            0x2176
#define TRANS_PWMA_MUX5                            0x2177
#define TRANS_PWMB_REG0                            0x2178
#define TRANS_PWMB_REG1                            0x2179
#define TRANS_PWMB_MUX0                            0x217a
#define TRANS_PWMB_MUX1                            0x217b
#define TRANS_PWMB_MUX2                            0x217c
#define TRANS_PWMB_MUX3                            0x217d
#define TRANS_PWMB_MUX4                            0x217e
#define TRANS_PWMB_MUX5                            0x217f
// ----------------------------
// NAND (21)
// ----------------------------


#define NAND_CMD                                ((0xc1108600-IO_CBUS_BASE)>>2)
#define NAND_CFG                                ((0xc1108604-IO_CBUS_BASE)>>2)
#define NAND_DADR                               ((0xc1108608-IO_CBUS_BASE)>>2)
#define NAND_IADR                               ((0xc110860c-IO_CBUS_BASE)>>2)
#define NAND_BUF                                ((0xc1108610-IO_CBUS_BASE)>>2)
#define NAND_INFO                               ((0xc1108614-IO_CBUS_BASE)>>2)
#define NAND_DC                                 ((0xc1108618-IO_CBUS_BASE)>>2)
#define NAND_ADR                                ((0xc110861c-IO_CBUS_BASE)>>2)
#define NAND_DL                                 ((0xc1108620-IO_CBUS_BASE)>>2)
#define NAND_DH                                 ((0xc1108624-IO_CBUS_BASE)>>2)
// ----------------------------
// PWM / DS C/D
// ----------------------------
#define PWM_PWM_C                                  0x2194
#define PWM_PWM_D                                  0x2195
#define PWM_MISC_REG_CD                            0x2196
#define PWM_DELTA_SIGMA_CD                         0x2197
// ----------------------------
// SAR ADC (16)
// ----------------------------
#define SAR_ADC_REG0                               0x21a0
#define SAR_ADC_CHAN_LIST                          0x21a1
#define SAR_ADC_AVG_CNTL                           0x21a2
#define SAR_ADC_REG3                               0x21a3
#define SAR_ADC_DELAY                              0x21a4
#define SAR_ADC_LAST_RD                            0x21a5
#define SAR_ADC_FIFO_RD                            0x21a6
#define SAR_ADC_AUX_SW                             0x21a7
#define SAR_ADC_CHAN_10_SW                         0x21a8
#define SAR_ADC_DETECT_IDLE_SW                     0x21a9
#define SAR_ADC_DELTA_10                           0x21aa
// ----------------------------
// CTouch (16)
// ----------------------------
#define CTOUCH_REG0                                0x21b0
#define CTOUCH_REG1                                0x21b1
#define CTOUCH_FIFO                                0x21b2
#define CTOUCH_REG3                                0x21b3
#define CTOUCH_INIT_CLK0                           0x21b4
#define CTOUCH_INIT_CLK1                           0x21b5
#define CTOUCH_REG6                                0x21b6
#define CTOUCH_GND_SW_MASK                         0x21b7
#define CTOUCH_MSR_TB_SEL                          0x21b8
#define CTOUCH_CAP_THRESH0                         0x21b9
#define CTOUCH_CAP_THRESH1                         0x21ba
#define CTOUCH_CHAN_LIST0                          0x21bb
#define CTOUCH_CHAN_LIST1                          0x21bc
#define CTOUCH_MSR_TB0                             0x21bd
#define CTOUCH_MSR_TB1                             0x21be
#define CTOUCH_REG15                               0x21bf
// ---------------------------
// RTC (4)
// ---------------------------
//#define RTC_ADDR0                                  0x21d0
//#define RTC_ADDR1                                  0x21d1
//#define RTC_ADDR2                                  0x21d2
//#define RTC_ADDR3                                  0x21d3
//#define RTC_ADDR4                                  0x21d4
// ----------------------------
// clock measure (4)
// ----------------------------
#define MSR_CLK_REG0                               0x21d7
#define MSR_CLK_REG1                               0x21d8
#define MSR_CLK_REG2                               0x21d9
// ----------------------------
// LED PWM
// ----------------------------
#define LED_PWM_REG0                               0x21da
#define LED_PWM_REG1                               0x21db
#define LED_PWM_REG2                               0x21dc
#define LED_PWM_REG3                               0x21dd
#define LED_PWM_REG4                               0x21de
// ----------------------------
// VGHL PWM
// ----------------------------
#define VGHL_PWM_REG0                              0x21e0
#define VGHL_PWM_REG1                              0x21e1
#define VGHL_PWM_REG2                              0x21e2
#define VGHL_PWM_REG3                              0x21e3
#define VGHL_PWM_REG4                              0x21e4
// -------------------------------------------------------------------
// PSEL Group #2:  0x800 ~ 0xbFF
// -------------------------------------------------------------------
// -----------------------------------------------
// CBUS_BASE:  PERIPHS2_CBUS_BASE = 0x22
// -----------------------------------------------
// ----------------------------
// AUDIN (64)
// ----------------------------
#define AUDIN_SPDIF_MODE                           0x2200
    #define SPDIF_EN        31
    #define SPDIF_IRQ_ITV   24              // 31 :24 do we need this?
    #define SPDIF_TIE_0     23
    #define SPDIF_BIT_ORDER 19
    #define SPDIF_CHNL_ORDER 18
    #define SPDIF_DATA_TYPE_SEL 17
    #define SPDIF_PATH_SEL      16
    #define SPDIF_XTDCLK_UPD_ITVL  13   //15:13
    #define SPDIF_CLKNUM_54U       0     //12:0 
#define AUDIN_SPDIF_FS_CLK_RLTN                    0x2201
    #define SPDIF_CLKNUM_192K  24     //29:24 
    #define SPDIF_CLKNUM_96K   18     //23:18 
    #define SPDIF_CLKNUM_48K   12     //17:12 
    #define SPDIF_CLKNUM_44K   6     // 11:6
    #define SPDIF_CLKNUM_32K   0     // 5:0
#define AUDIN_SPDIF_CHNL_STS_A                     0x2202
#define AUDIN_SPDIF_CHNL_STS_B                     0x2203
#define AUDIN_SPDIF_MISC                           0x2204
#define AUDIN_SPDIF_NPCM_PCPD                      0x2205
#define AUDIN_SPDIF_END                            0x220f
#define AUDIN_I2SIN_CTRL                           0x2210
    #define I2SIN_DIR       0    // I2S CLK and LRCLK direction. 0 : input 1 : output.
    #define I2SIN_CLK_SEL    1    // I2S clk selection : 0 : from pad input. 1 : from AIU.
    #define I2SIN_LRCLK_SEL 2
    #define I2SIN_POS_SYNC  3
    #define I2SIN_LRCLK_SKEW 4    // 6:4
    #define I2SIN_LRCLK_INVT 7
    #define I2SIN_SIZE       8    //9:8 : 0 16 bit. 1 : 18 bits 2 : 20 bits 3 : 24bits.
    #define I2SIN_CHAN_EN   10    //13:10. 
    #define I2SIN_EN        15
#define AUDIN_I2S_END                              0x221f
#define AUDIN_FIFO0_START                          0x2220
#define AUDIN_FIFO0_END                            0x2221
#define AUDIN_FIFO0_PTR                            0x2222
#define AUDIN_FIFO0_INTR                           0x2223
#define AUDIN_FIFO0_RDPTR                          0x2224
#define AUDIN_FIFO0_CTRL                           0x2225
    #define AUDIN_FIFO0_EN       0
    #define AUDIN_FIFO0_RST      1
    #define AUDIN_FIFO0_LOAD     2 
    #define AUDIN_FIFO0_DIN_SEL  3
            // 0     spdifIN
            // 1     i2Sin
            // 2     delsigIN
            // 3     HDMI in
            // 4     DEMODULATOR IN
    #define AUDIN_FIFO0_D32b     6
    #define AUDIN_FIFO0_h24b     7
    #define AUDIN_FIFO0_ENDIAN   8
    #define AUDIN_FIFO0_CHAN     11
    #define AUDIN_FIFO0_UG       15
    #define AUDIN_FIFO0_DEST     16 
               // 0    DDR SDRAM
               // 1    PARSER.
    #define AUDIN_FIFO0_OV_MASK  17 
    #define AUDIN_FIFO0_INT_MASK 18 
    #define AUDIN_FIFO0_HOLD0_EN  19
    #define AUDIN_FIFO0_HOLD1_EN  20
    #define AUDIN_FIFO0_HOLD2_EN  21
    #define AUDIN_FIFO0_HOLD0_SEL 22   // 23:22
    #define AUDIN_FIFO0_HOLD1_SEL 24   // 25:24
    #define AUDIN_FIFO0_HOLD2_SEL 26   // 27:26
    #define AUDIN_FIFO0_HOLD_LVL  28   // 27:26
#define AUDIN_FIFO0_LVL0                           0x2226
#define AUDIN_FIFO0_LVL1                           0x2227
#define AUDIN_FIFO0_LVL2                           0x2228
#define AUDIN_FIFO1_START                          0x2229
#define AUDIN_FIFO1_END                            0x222a
#define AUDIN_FIFO1_PTR                            0x222b
#define AUDIN_FIFO1_INTR                           0x222c
#define AUDIN_FIFO1_RDPTR                          0x222d
#define AUDIN_FIFO1_CTRL                           0x222e
    #define AUDIN_FIFO1_EN       0
    #define AUDIN_FIFO1_RST      1
    #define AUDIN_FIFO1_LOAD     2 
    #define AUDIN_FIFO1_DIN_SEL  3
    #define AUDIN_FIFO1_D32b     6
    #define AUDIN_FIFO1_h24b     7
    #define AUDIN_FIFO1_ENDIAN   8
    #define AUDIN_FIFO1_CHAN     11
    #define AUDIN_FIFO1_UG       15
    #define AUDIN_FIFO1_DEST     16 
    #define AUDIN_FIFO1_OV_MASK  17 
    #define AUDIN_FIFO1_INT_MASK 18 
#define AUDIN_FIFO1_LVL0                           0x222f
#define AUDIN_FIFO1_LVL1                           0x2230
#define AUDIN_FIFO1_LVL2                           0x2231
#define AUDIN_FIFO0_REQID                          0x2233
#define AUDIN_FIFO1_REQID                          0x2234
#define AUDIN_FIFO_INT                             0x2232
#define AUDIN_ADDR_END                             0x223f
// ----------------------------
// BT656 (32)
// ----------------------------
#define BT_CTRL                                    0x2240
    #define BT_SOFT_RESET           31      // Soft reset
    #define BT_JPEG_START           30  
    #define BT_JPEG_IGNORE_BYTES    18     //20:18
    #define BT_JPEG_IGNORE_LAST     17
    #define BT_UPDATE_ST_SEL        16 
    #define BT_COLOR_REPEAT         15
    #define BT_VIDEO_MODE           13     // 14:13
    #define BT_AUTO_FMT             12   
    #define BT_PROG_MODE            11
    #define BT_JPEG_MODE            10
    #define BT_XCLK27_EN_BIT        9      // 1 : xclk27 is input.     0 : xclk27 is output.
    #define BT_FID_EN_BIT           8       // 1 : enable use FID port.
    #define BT_CLK27_SEL_BIT        7       // 1 : external xclk27      0 : internal clk27.
    #define BT_CLK27_PHASE_BIT      6       // 1 : no inverted          0 : inverted.
    #define BT_ACE_MODE_BIT         5       // 1 : auto cover error by hardware.
    #define BT_SLICE_MODE_BIT       4       // 1 : no ancillay flag     0 : with ancillay flag.
    #define BT_FMT_MODE_BIT         3       // 1 : ntsc                 0 : pal.
    #define BT_REF_MODE_BIT         2       // 1 : from bit stream.     0 : from ports.
    #define BT_MODE_BIT             1       // 1 : BT656 model          0 : SAA7118 mode.
    #define BT_EN_BIT               0       // 1 : enable.
#define BT_VBISTART                                0x2241
#define BT_VBIEND                                  0x2242
#define BT_FIELDSADR                               0x2243
#define BT_LINECTRL                                0x2244
#define BT_VIDEOSTART                              0x2245
#define BT_VIDEOEND                                0x2246
#define BT_SLICELINE0                              0x2247
#define BT_SLICELINE1                              0x2248
#define BT_PORT_CTRL                               0x2249
  #define BT_HSYNC_PHASE      0
  #define BT_VSYNC_PHASE      1
  #define BT_HSYNC_PULSE      2
  #define BT_VSYNC_PULSE      3
  #define BT_FID_PHASE        4
  #define BT_FID_HSVS         5
  #define BT_IDQ_EN           6
  #define BT_IDQ_PHASE        7
  #define BT_D8B              8
  #define BT_10BTO8B          9
  #define BT_FID_DELAY       10    //12:10
  #define BT_VSYNC_DELAY     13    //
  #define BT_HSYNC_DELAY     16
#define BT_SWAP_CTRL                               0x224a
#define BT_ANCISADR                                0x224b
#define BT_ANCIEADR                                0x224c
#define BT_AFIFO_CTRL                              0x224d
#define BT_601_CTRL0                               0x224e
#define BT_601_CTRL1                               0x224f
#define BT_601_CTRL2                               0x2250
#define BT_601_CTRL3                               0x2251
#define BT_FIELD_LUMA                              0x2252
#define BT_RAW_CTRL                                0x2253
#define BT_STATUS                                  0x2254
#define BT_INT_CTRL                                0x2255
#define BT_ANCI_STATUS                             0x2256
#define BT_VLINE_STATUS                            0x2257
#define BT_AFIFO_PTR                               0x2258
#define BT_JPEGBYTENUM                             0x2259
#define BT_ERR_CNT                                 0x225a
#define BT_JPEG_STATUS0                            0x225b
#define BT_JPEG_STATUS1                            0x225c
#define BT656_ADDR_END                             0x225f
// ----------------------------
// BLKMV (9)
// ----------------------------
#define NDMA_CNTL_REG0                             0x2270
    #define NDMA_STATUS                 26
    #define NDMA_PERIODIC_INT_DLY_MSB   25
    #define NDMA_PERIODIC_INT_DLY_LSB   16
    #define NDMA_PERIODIC_INT_EN        15
    #define NDMA_ENABLE                 14
    #define NDMA_AHB_DELAY_MSB          13
    #define NDMA_AHB_DELAY_LSB          0
#define NDMA_TABLE_ADD_REG                         0x2272
#define NDMA_TDES_KEY_LO                           0x2273
#define NDMA_TDES_KEY_HI                           0x2274
#define NDMA_TDES_CONTROL                          0x2275
#define NDMA_AES_CONTROL                           0x2276
#define NDMA_AES_RK_FIFO                           0x2277
#define NDMA_CRC_OUT                               0x2278
#define NDMA_THREAD_REG                            0x2279
#define NDMA_THREAD_TABLE_START0                   0x2280
#define NDMA_THREAD_TABLE_CURR0                    0x2281
#define NDMA_THREAD_TABLE_END0                     0x2282
#define NDMA_THREAD_TABLE_START1                   0x2283
#define NDMA_THREAD_TABLE_CURR1                    0x2284
#define NDMA_THREAD_TABLE_END1                     0x2285
#define NDMA_THREAD_TABLE_START2                   0x2286
#define NDMA_THREAD_TABLE_CURR2                    0x2287
#define NDMA_THREAD_TABLE_END2                     0x2288
#define NDMA_THREAD_TABLE_START3                   0x2289
#define NDMA_THREAD_TABLE_CURR3                    0x228a
#define NDMA_THREAD_TABLE_END3                     0x228b
#define NDMA_CNTL_REG1                             0x228c
// -------------------------------------------------------------------
// PSEL Group #3:  0xc00 ~ 0xFFF
// -------------------------------------------------------------------
// -----------------------------------------------
// CBUS_BASE:  PERIPHS3_CBUS_BASE = 0x23
// -----------------------------------------------
// ---------------------------
// STREAM (8)
// ---------------------------
// bit 31:24 -- event_length
// bit 23:22 -- bus_1st_sel_1  //00-gpio, 01-reserved, 10-addr, 11-data 
// bit 21:20 -- bus_2nd_sel_1
// bit 19:18 -- bus_1st_sel_0
// bit 17:16 -- bus_2nd_sel_0
// bit 15:0 -- set output value (output 1 will read according to external input) 
#define STREAM_EVENT_INFO                          0x2300
// bit 31    -- force_parity_1
// bit 30    -- LSB_first
// bit 31:20 -- reserved
// bit 19:16 -- toggle point index
// bit 15:8  -- output togle point1
// bit 7:0   -- output togle point0 (0xff means input) 
#define STREAM_OUTPUT_CONFIG                       0x2301
// bit 31:24 -- clock_divide_ext
// bit 23:20 -- s_bus_start ( sclk, sdataout, sdatain)  // 0 means no s_bus used
// bit 19    -- no_sclk_on_pin // will use internal write clock and read clock (like RS232) 
// bit 18    -- invert_sclk_in
// bit 17    -- sdata_send_busy  // indicate one data is sending -- read only
// bit 16    -- one_sdata_received // set when one sdata is received, can write 0 to clear 
// bit 15    -- sdata_parity  // (write -- 0-even, 1-odd) (read -- received parity check)
// bit 14    -- sdata_send_type  // 0 -- 8 bits  1 -- 32 bits ( for fujitsu only )
// bit 13    -- sdata_receive_type // 0 -- 8 bits only  1 -- 8/32 bits 
// bit 12    -- invert_request_out
// bit 11:8  -- request_out_sel  // 0 means disable output
// bit 7:0   --  stop_request_count 
#define C_D_BUS_CONTROL                            0x2302
// bit 31:0  -- serial data (write: output one data, read: input data)
#define C_DATA                                     0x2303
// bit 31:28 bus_width_1
// bit 27:24 bus_start_pin_1
// bit 23:16 bus_sel_chang_point_1 
// bit 15:12 bus_width_0
// bit 11:08 bus_start_pin_0
// bit 07:00 bus_sel_chang_point_0 
#define STREAM_BUS_CONFIG                          0x2304
// bit 31:24 clock_divide
// bit 23:20 clock_output_sel  -- 0 means disable clock output
// bit 19 -- inc_event_addr
// bit 18 -- async_fifo_endian
// bit 17 -- send_to_async_fifo
// bit 16 -- data_in_serial_lsb
// bit 15 -- invert_no_wait_condition_0
// bit 14 -- invert_no_wait_condition_1
// bit 13 -- invert_no_wait_condition_2
// bit 12 -- invert_data_bus
// bit 11 -- invert_clock_in
// bit 10 -- event_wait_clk_en
// bit 9 -- data_in_serial
// bit 8 -- invert_data_in_clk 
// bit 7:4  -- data_in_begin
// bit 3:0  -- data_in_clk_sel
#define STREAM_DATA_IN_CONFIG                      0x2305
// wait condition and irq should not be connected to 0, 0 means disable)
// bit 31:28 -- no_wait_condition_0   (0 means disable this condition)
// bit 27:24 -- no_wait_condition_1   (0 means disable this condition)
// bit 23:20 -- no_wait_condition_2   (0 means disable this condition)
// bit 19:16 -- irq_input_sel         (0 means disable this interrupt)
// bit 15:13 -- interrupt_status (read) clear status (write) (ext 0, ext 1, transfer end)
// bit 12 -- enable_sdata_irq
// bit 11 -- invert_irq_0
// bit 10 -- invert_irq_1
// bit  9 -- enable_transfer_end_irq
// bit  8 -- enable_second_ext_irq
// bit 7:0 -- no_wait_condition_check_point (0xff means no check)
#define STREAM_WAIT_IRQ_CONFIG                     0x2306
// bit 31:24 -- event address
// bit 23:16 -- event data
// bit 15:1 -- event repeat times  (0 means one time event)
// bit 0  -- Start Event (write) event_busy (read)
#define STREAM_EVENT_CTL                           0x2307
// ---------------------------
// SDIO (8)
// ---------------------------
// `define C_SDIO_HIGH16                   8'h00 
// bit 31:0 -- cmd_argument/MS_SHORT_DATA_WRITE
#define CMD_ARGUMENT                               0x2308
// bit 31:24 -- repeat_package_times/MS_SHORT_DATA_WRITE_NUMBER
// bit 21   -- use_int_window
// bit 20   -- cmd_send_data/MS_HAVE_LONG_DATA_WRITE
// bit 19   -- check_busy_on_dat0 (used for R1b response)
// bit 18   -- response_crc7_from_8
// bit 17   -- response_have_data/MS_HAVE_LONG_DATA_READ
// bit 16   -- response_do_not_have_crc7/MS_SHORT_DATA_DO_NOT_HAVE_CRC16
// bit 15:8 -- cmd_response_bits (00 means no response) /MS_SHORT_DATA_READ_NUMBER
// bit 7:0 -- cmd_command/MS_TPC
#define CMD_SEND                                   0x2309
// bit 31:29 -- sdio_write_CRC_ok_status
// bit 28:23 -- sdio_write_Nwr
// bit 22:21 -- m_endian
// bit 20    -- bus_width
// bit 19    -- data_latch_at_negedge (normally at posedge)
// bit 18    -- do_not_delay_data (normally delay one clock)
// bit 17:12 -- cmd_argument_bits (before CRC, normally : 39) 
// bit 11 -- cmd_out_at_posedge (normally at negedge)
// bit 10 -- cmd_disable_CRC
// bit 9:0 -- cmd_clk_divide
#define SDIO_CONFIG                                0x230a
// bit 31:19 -- sdio_timing_out_count
// bit 18 -- arc_timing_out_int_en
// bit 17 -- amrisc_timing_out_int_en
// bit 16 -- sdio_timig_out_int   -- write 1 clear this int bit
// bit 15:12 -- sdio_status_info  -- used for change infor between ARC and Amrisc
// bit 11 -- sdio_set_soft_int -- write 1 to this bit will set sdio_soft_int , read out is m_req_sdio
// bit 10 -- sdio_soft_int   -- write 1 clear this int bit
// bit 9 -- sdio_cmd_int   -- write 1 clear this int bit
// bit 8 -- sdio_if_int   -- write 1 clear this int bit
// bit 7 -- sdio_data_write_crc16_ok -- Read-Only
// bit 6 -- sdio_data_read_crc16_ok  -- Read-Only
// bit 5 -- sdio_response_crc7_ok    -- Read-Only
// bit 4 -- sdio_cmd_busy            -- Read-Only
// bit 3:0 -- sdio_status            -- Read-Only
#define SDIO_STATUS_IRQ                            0x230b
// bit 31 -- halt_hole 0 -- 8 bits 1 -- 16 bits
// bit 30 -- force_halt
// bit 29:24 -- sdio_force_data_read (read_only)
// bit 23:22 -- disable_mem_halt (write and read)
// bit 21:16 -- sdio_force_output_en 
// bit 15 -- soft_reset
// bit 14 -- sdio_force_enable
// bit 13:8 -- sdio_force_data/sdio_read_data
// bit 7:6 -- sdio_if_int_config 
// bit 5 -- arc_soft_int_en
// bit 4 -- arc_cmd_int_en
// bit 3 -- arc_if_int_en
// bit 2 -- amrisc_soft_int_en
// bit 1 -- amrisc_cmd_int_en
// bit 0 -- amrisc_if_int_en
#define SDIO_IRQ_CONFIG                            0x230c
// bit 27:16 -- data_catch_finish_point
// (
// bit 15:12 -- response_read_index  
// bit 9 -- data_catch_readout_en
// bit 8 -- write_read_out_index
// ) this bits only write when write_read_out_index = 1
// bit 11 -- sdio_1_data_swap01 
// bit 10 -- sdio_0_data_on_1 
// bit 7:6 -- data_catch_level 
// bit 5 -- stream_8_bits_mode
// bit 4 -- stream_enable
// bit 3 -- ms_sclk_always
// bit 2 -- ms_enable
// bit 1:0 -- SDIO_port_sel //00-sdio1, 01-sdio2, 02-sdio3
#define SDIO_MULT_CONFIG                           0x230d
// bit 31:0 -- m_addr_sdio
#define SDIO_M_ADDR                                0x230e
// bit 31    -- CRC_status_4line
// bit 30    -- data_rw_do_not_have_crc16/MS_LONG_DATA_DO_NOT_HAVE_CRC16
// bit 29:16 -- data_rw_number/MS_LONG_DATA_NUMBER 
// bit 15:0 -- cmd_argument_ext/MS_SHORT_DATA_EXTENSION
#define SDIO_EXTENSION                             0x230f
// ----------------------------
// ASYNC FIFO (4)
// ----------------------------
#define ASYNC_FIFO_REG0                            0x2310
#define ASYNC_FIFO_REG1                            0x2311
    #define ASYNC_FIFO_FLUSH_STATUS     31
    #define ASYNC_FIFO_ERR              30
    #define ASYNC_FIFO_FIFO_EMPTY       29
    #define ASYNC_FIFO_TO_HIU           24
    #define ASYNC_FIFO_FLUSH            23
    #define ASYNC_FIFO_RESET            22
    #define ASYNC_FIFO_WRAP_EN          21
    #define ASYNC_FIFO_FLUSH_EN         20
    #define ASYNC_FIFO_RESIDUAL_MSB     19
    #define ASYNC_FIFO_RESIDUAL_LSB     15
    #define ASYNC_FIFO_FLUSH_CNT_MSB    14
    #define ASYNC_FIFO_FLUSH_CNT_LSB    0
#define ASYNC_FIFO_REG2                            0x2312
    #define ASYNC_FIFO_FIFO_FULL        26
    #define ASYNC_FIFO_FILL_STATUS      25
    #define ASYNC_FIFO_SOURCE_MSB       24
    #define ASYNC_FIFO_SOURCE_LSB       23
    #define ASYNC_FIFO_ENDIAN_MSB       22
    #define ASYNC_FIFO_ENDIAN_LSB       21
    #define ASYNC_FIFO_FILL_EN          20
    #define ASYNC_FIFO_FILL_CNT_MSB     19
    #define ASYNC_FIFO_FILL_CNT_LSB     0
#define ASYNC_FIFO_REG3                            0x2313
    #define ASYNC_FLUSH_SIZE_IRQ_MSB    15
    #define ASYNC_FLUSH_SIZE_IRQ_LSB    0
// ----------------------------
// ASYNC FIFO (4)
// ----------------------------
#define ASYNC_FIFO2_REG0                           0x2314
#define ASYNC_FIFO2_REG1                           0x2315
#define ASYNC_FIFO2_REG2                           0x2316
#define ASYNC_FIFO2_REG3                           0x2317
// ----------------------------
// SPI 
// ----------------------------
#define SPI_FLASH_CMD                              0x2320
    #define SPI_FLASH_READ    31
    #define SPI_FLASH_WREN    30
    #define SPI_FLASH_WRDI    29
    #define SPI_FLASH_RDID    28
    #define SPI_FLASH_RDSR    27
    #define SPI_FLASH_WRSR    26
    #define SPI_FLASH_PP      25
    #define SPI_FLASH_SE      24
    #define SPI_FLASH_BE      23
    #define SPI_FLASH_CE      22
    #define SPI_FLASH_DP      21
    #define SPI_FLASH_RES     20
    #define SPI_HPM           19
    #define SPI_FLASH_USR     18
    #define SPI_FLASH_USR_ADDR 15
    #define SPI_FLASH_USR_DUMMY 14
    #define SPI_FLASH_USR_DIN   13
    #define SPI_FLASH_USR_DOUT   12
    #define SPI_FLASH_USR_DUMMY_BLEN   10
    #define SPI_FLASH_USR_CMD     0
#define SPI_FLASH_ADDR                             0x2321
    #define SPI_FLASH_BYTES_LEN 24
    #define SPI_FLASH_ADDR_START 0
#define SPI_FLASH_CTRL                             0x2322
    #define SPI_ENABLE_AHB    17
    #define SPI_SST_AAI       16
    #define SPI_RES_RID       15
    #define SPI_FREAD_DUAL    14
    #define SPI_READ_READ_EN  13
    #define SPI_CLK_DIV0      12
    #define SPI_CLKCNT_N      8
    #define SPI_CLKCNT_H      4
    #define SPI_CLKCNT_L      0
#define SPI_FLASH_CTRL1                            0x2323
#define SPI_FLASH_STATUS                           0x2324
#define SPI_FLASH_CTRL2                            0x2325
#define SPI_FLASH_CLOCK                            0x2326
#define SPI_FLASH_USER                             0x2327
#define SPI_FLASH_USER1                            0x2328
#define SPI_FLASH_USER2                            0x2329
#define SPI_FLASH_USER3                            0x232a
#define SPI_FLASH_USER4                            0x232b
#define SPI_FLASH_SLAVE                            0x232c
#define SPI_FLASH_SLAVE1                           0x232d
#define SPI_FLASH_SLAVE2                           0x232e
#define SPI_FLASH_SLAVE3                           0x232f
#define SPI_FLASH_C0                               0x2330
#define SPI_FLASH_C1                               0x2331
#define SPI_FLASH_C2                               0x2332
#define SPI_FLASH_C3                               0x2333
#define SPI_FLASH_C4                               0x2334
#define SPI_FLASH_C5                               0x2335
#define SPI_FLASH_C6                               0x2336
#define SPI_FLASH_C7                               0x2337
#define SPI_FLASH_B8                               0x2338
#define SPI_FLASH_B9                               0x2339
#define SPI_FLASH_B10                              0x233a
#define SPI_FLASH_B11                              0x233b
#define SPI_FLASH_B12                              0x233c
#define SPI_FLASH_B13                              0x233d
#define SPI_FLASH_B14                              0x233e
#define SPI_FLASH_B15                              0x233f
// ----------------------------
// SPI #2
// ----------------------------
#define SPI2_FLASH_CMD                             0x2360
#define SPI2_FLASH_ADDR                            0x2361
#define SPI2_FLASH_CTRL                            0x2362
#define SPI2_FLASH_CTRL1                           0x2363
#define SPI2_FLASH_STATUS                          0x2364
#define SPI2_FLASH_CTRL2                           0x2365
#define SPI2_FLASH_CLOCK                           0x2366
#define SPI2_FLASH_USER                            0x2367
#define SPI2_FLASH_USER1                           0x2368
#define SPI2_FLASH_USER2                           0x2369
#define SPI2_FLASH_USER3                           0x236a
#define SPI2_FLASH_USER4                           0x236b
#define SPI2_FLASH_SLAVE                           0x236c
#define SPI2_FLASH_SLAVE1                          0x236d
#define SPI2_FLASH_SLAVE2                          0x236e
#define SPI2_FLASH_SLAVE3                          0x236f
#define SPI2_FLASH_C0                              0x2370
#define SPI2_FLASH_C1                              0x2371
#define SPI2_FLASH_C2                              0x2372
#define SPI2_FLASH_C3                              0x2373
#define SPI2_FLASH_C4                              0x2374
#define SPI2_FLASH_C5                              0x2375
#define SPI2_FLASH_C6                              0x2376
#define SPI2_FLASH_C7                              0x2377
#define SPI2_FLASH_B8                              0x2378
#define SPI2_FLASH_B9                              0x2379
#define SPI2_FLASH_B10                             0x237a
#define SPI2_FLASH_B11                             0x237b
#define SPI2_FLASH_B12                             0x237c
#define SPI2_FLASH_B13                             0x237d
#define SPI2_FLASH_B14                             0x237e
#define SPI2_FLASH_B15                             0x237f
//
// Closing file:  periphs_reg.h
//
//
// Reading file:  isa_reg.h
//
// $isa/rtl/isa_core register defines for the APB bus
// CBUS base slave address
// -----------------------------------------------
// CBUS_BASE:  ISA_CBUS_BASE = 0x26
// -----------------------------------------------
// Up to 256 registers for this base
#define ISA_DEBUG_REG0                             0x2600
#define ISA_DEBUG_REG1                             0x2601
#define ISA_DEBUG_REG2                             0x2602
#define ISA_PLL_CLK_SIM0                           0x2608
#define ISA_CNTL_REG0                              0x2609
// -----------------------------------------------------------
#define AUD_ARC_IRQ_IN0_INTR_STAT                  0x2610
#define AUD_ARC_IRQ_IN0_INTR_STAT_CLR              0x2611
#define AUD_ARC_IRQ_IN0_INTR_MASK                  0x2612
#define AUD_ARC_IRQ_IN0_INTR_FIRQ_SEL              0x2613
#define AUD_ARC_IRQ_IN1_INTR_STAT                  0x2614
#define AUD_ARC_IRQ_IN1_INTR_STAT_CLR              0x2615
#define AUD_ARC_IRQ_IN1_INTR_MASK                  0x2616
#define AUD_ARC_IRQ_IN1_INTR_FIRQ_SEL              0x2617
#define AUD_ARC_IRQ_IN2_INTR_STAT                  0x2618
#define AUD_ARC_IRQ_IN2_INTR_STAT_CLR              0x2619
#define AUD_ARC_IRQ_IN2_INTR_MASK                  0x261a
#define AUD_ARC_IRQ_IN2_INTR_FIRQ_SEL              0x261b
#define AUD_ARC_IRQ_IN3_INTR_STAT                  0x261c
#define AUD_ARC_IRQ_IN3_INTR_STAT_CLR              0x261d
#define AUD_ARC_IRQ_IN3_INTR_MASK                  0x261e
#define AUD_ARC_IRQ_IN3_INTR_FIRQ_SEL              0x261f
#define GPIO_INTR_EDGE_POL                         0x2620
#define GPIO_INTR_GPIO_SEL0                        0x2621
#define GPIO_INTR_GPIO_SEL1                        0x2622
#define GPIO_INTR_FILTER_SEL0                      0x2623
#define GLOBAL_INTR_DISABLE                        0x2624

#define A9_IRQ_IN0_INTR_STAT                       0x2630
#define A9_IRQ_IN0_INTR_STAT_CLR                   0x2631
#define A9_IRQ_IN0_INTR_MASK                       0x2632
#define A9_IRQ_IN0_INTR_FIRQ_SEL                   0x2633
#define A9_IRQ_IN1_INTR_STAT                       0x2634
#define A9_IRQ_IN1_INTR_STAT_CLR                   0x2635
#define A9_IRQ_IN1_INTR_MASK                       0x2636
#define A9_IRQ_IN1_INTR_FIRQ_SEL                   0x2637
#define A9_IRQ_IN2_INTR_STAT                       0x2638
#define A9_IRQ_IN2_INTR_STAT_CLR                   0x2639
#define A9_IRQ_IN2_INTR_MASK                       0x263a
#define A9_IRQ_IN2_INTR_FIRQ_SEL                   0x263b
#define A9_IRQ_IN3_INTR_STAT                       0x263c
#define A9_IRQ_IN3_INTR_STAT_CLR                   0x263d
#define A9_IRQ_IN3_INTR_MASK                       0x263e
#define A9_IRQ_IN3_INTR_FIRQ_SEL                   0x263f

// -----------------------------------------------------------
#define WATCHDOG_TC                                0x2640
#define WATCHDOG_RESET_REG                             0x2641
#define WATCHDOG_ENABLE_BIT                        22						
// -----------------------------------------------------------
#define AHB_ARBITER_REG                            0x2642
#define AHB_ARBDEC_REG                             0x2643
// -----------------------------------------------------------
#define ISA_BIST_REG0                              0x2644
#define ISA_BIST_REG1                              0x2645
#define ISA_BIST_REG2                              0x2646
#define ISA_BIST_REG3                              0x2647
#define ISA_BIST_REG4                              0x2648
#define ISA_BIST_REG5                              0x2649
// -----------------------------------------------------------
#define ISA_TIMER_MUX                              0x2650
    #define TIMER_E_INPUT_BIT         8
    #define TIMER_D_INPUT_BIT         6
    #define TIMER_C_INPUT_BIT         4
    #define TIMER_B_INPUT_BIT         2
    #define TIMER_A_INPUT_BIT         0
    #define TIMER_E_INPUT_MASK       (3L << TIMER_E_INPUT_BIT)
    #define TIMER_D_INPUT_MASK       (3L << TIMER_D_INPUT_BIT)
    #define TIMER_C_INPUT_MASK       (3L << TIMER_C_INPUT_BIT)
    #define TIMER_B_INPUT_MASK       (3L << TIMER_B_INPUT_BIT)
    #define TIMER_A_INPUT_MASK       (3L << TIMER_A_INPUT_BIT)
    #define TIMER_UNIT_1us            0
    #define TIMER_UNIT_10us           1
    #define TIMER_UNIT_100us          2
    #define TIMER_UNIT_1ms            3
    #define TIMERE_UNIT_SYS           0
    #define TIMERE_UNIT_1us           1
    #define TIMERE_UNIT_10us          2
    #define TIMERE_UNIT_100us         3
#define ISA_TIMERA                                 0x2651
#define ISA_TIMERB                                 0x2652
#define ISA_TIMERC                                 0x2653
#define ISA_TIMERD                                 0x2654
#define ISA_TIMERE                                 0x2655
#define FBUF_ADDR                                  0x2656
    #define VIDEO_FRM_BUF_MSB_BIT      23 
    #define VIDEO_FRM_BUF_LSB_BIT       2 
#define SDRAM_CTL0                                 0x2657
#define SDRAM_CTL2                                 0x2658
#define AUD_ARC_CTL                                0x2659
#define SDRAM_CTL4                                 0x265a
#define SDRAM_CTL5                                 0x265b
#define SDRAM_CTL6                                 0x265c
#define SDRAM_CTL7                                 0x265d
#define SDRAM_CTL8                                 0x265e
#define AHB_MP4_MC_CTL                             0x265f
#define AUD_ARC_PCR                                0x2660
// ---------------------------------------------
#define ABUF_WR_CTL0                               0x2670
    #define ABUF_WR_INT_EN	    31
    #define ABUF_WR_INT_POS_MSB      30 
    #define ABUF_WR_INT_POS_LSB      16 
    #define ABUF_WR_BLK_SIZE_MSB     14 
    #define ABUF_WR_BLK_SIZE_LSB      0
#define ABUF_WR_CTL1                               0x2671
    #define ABUF_WR_INT_EN	    31
    #define ABUF_WR_INT_POS_MSB      30 
    #define ABUF_WR_INT_POS_LSB      16 
    #define ABUF_WR_BLK_SIZE_MSB     14 
    #define ABUF_WR_BLK_SIZE_LSB      0
#define ABUF_WR_CTL2                               0x2672
    #define ABUF_WR_CUR_FF_CNT_MSB   21
    #define ABUF_WR_CUR_FF_CNT_LSB   16
    #define ABUF_WR_CUR_BLK_MSB      14
    #define ABUF_WR_CUR_BLK_LSB       0   
#define ABUF_WR_CTL3                               0x2673
    #define ABUF_WR_AHB_RST_PLS       3
    #define ABUF_WR_FF_CLR_PLS        2
    #define ABUF_WR_PLY_RPT_LVL	     1
    #define ABUF_WR_FF_PAUSE_LVL      0
#define ABUF_RD_CTL0                               0x2674
#define ABUF_RD_CTL1                               0x2675
    #define ABUF_RD_INT_EN	    31
    #define ABUF_RD_INT_POS_MSB      30 
    #define ABUF_RD_INT_POS_LSB      16 
    #define ABUF_RD_BLK_SIZE_MSB     14 
    #define ABUF_RD_BLK_SIZE_LSB      0   
#define ABUF_RD_CTL2                               0x2676
    #define ABUF_RD_CUR_FF_CNT_MSB   21
    #define ABUF_RD_CUR_FF_CNT_LSB   16
    #define ABUF_RD_CUR_BLK_MSB      14
    #define ABUF_RD_CUR_BLK_LSB       0   
#define ABUF_RD_CTL3                               0x2677
    #define ABUF_RD_PLY_ONCE_PLS      4
    #define ABUF_RD_AHB_RST_PLS       3
    #define ABUF_RD_FF_CLR_PLS        2
    #define ABUF_RD_PLY_RPT_LVL	     1
    #define ABUF_RD_FF_PAUSE_LVL      0
#define ABUF_ARB_CTL0                              0x2678
#define ABUF_FIFO_CTL0                             0x2679
    #define AIUout_FIFO_THRESHOLD_MSB 11
    #define AIUout_FIFO_THRESHOLD_LSB 6 
    #define AIUin_FIFO_THRESHOLD_MSB  5
    #define AIUin_FIFO_THRESHOLD_LSB  0
// ---------------------------------------------
#define AHB_BRIDGE_CNTL_WR                         0x2680
#define AHB_BRIDGE_REMAP0                          0x2681
#define AHB_BRIDGE_REMAP1                          0x2682
#define AHB_BRIDGE_REMAP2                          0x2683
#define AHB_BRIDGE_REMAP3                          0x2684
#define AHB_BRIDGE_CNTL_REG1                       0x2685
// ---------------------------------------------
// -----------------------------------------------------------
#define A9_0_IRQ_IN0_INTR_STAT                     0x2690
#define A9_0_IRQ_IN0_INTR_STAT_CLR                 0x2691
#define A9_0_IRQ_IN0_INTR_MASK                     0x2692
#define A9_0_IRQ_IN0_INTR_FIRQ_SEL                 0x2693
#define A9_0_IRQ_IN1_INTR_STAT                     0x2694
#define A9_0_IRQ_IN1_INTR_STAT_CLR                 0x2695
#define A9_0_IRQ_IN1_INTR_MASK                     0x2696
#define A9_0_IRQ_IN1_INTR_FIRQ_SEL                 0x2697
#define A9_0_IRQ_IN2_INTR_STAT                     0x2698
#define A9_0_IRQ_IN2_INTR_STAT_CLR                 0x2699
#define A9_0_IRQ_IN2_INTR_MASK                     0x269a
#define A9_0_IRQ_IN2_INTR_FIRQ_SEL                 0x269b
#define A9_0_IRQ_IN3_INTR_STAT                     0x269c
#define A9_0_IRQ_IN3_INTR_STAT_CLR                 0x269d
#define A9_0_IRQ_IN3_INTR_MASK                     0x269e
#define A9_0_IRQ_IN3_INTR_FIRQ_SEL                 0x269f
// -----------------------------------------------------------
#define A9_1_IRQ_IN0_INTR_STAT                     0x26a0
#define A9_1_IRQ_IN0_INTR_STAT_CLR                 0x26a1
#define A9_1_IRQ_IN0_INTR_MASK                     0x26a2
#define A9_1_IRQ_IN0_INTR_FIRQ_SEL                 0x26a3
#define A9_1_IRQ_IN1_INTR_STAT                     0x26a4
#define A9_1_IRQ_IN1_INTR_STAT_CLR                 0x26a5
#define A9_1_IRQ_IN1_INTR_MASK                     0x26a6
#define A9_1_IRQ_IN1_INTR_FIRQ_SEL                 0x26a7
#define A9_1_IRQ_IN2_INTR_STAT                     0x26a8
#define A9_1_IRQ_IN2_INTR_STAT_CLR                 0x26a9
#define A9_1_IRQ_IN2_INTR_MASK                     0x26aa
#define A9_1_IRQ_IN2_INTR_FIRQ_SEL                 0x26ab
#define A9_1_IRQ_IN3_INTR_STAT                     0x26ac
#define A9_1_IRQ_IN3_INTR_STAT_CLR                 0x26ad
#define A9_1_IRQ_IN3_INTR_MASK                     0x26ae
#define A9_1_IRQ_IN3_INTR_FIRQ_SEL                 0x26af
//
// Closing file:  isa_reg.h
//
// -----------------------------------------------
// CBUS_BASE:  DDR_CBUS_BASE = 0x13
// -----------------------------------------------
// TEMP DEFINES
// -----------------------------------------------
// CBUS_BASE:  PERIPHS4_CBUS_BASE = 0x24
// -----------------------------------------------
// -----------------------------------------------
// CBUS_BASE:  PERIPHS5_CBUS_BASE = 0x25
// -----------------------------------------------
// For iq_om_width change for RealVideo
#define IQ_OM_WIDTH                                0x2510
//`define IQ_OM_WIDTH_12
#define DBG_ADDR_START                             0x2ff0
#define DBG_ADDR_END                               0x2fff
#define DBG_CTRL                                   0x2ff1
#define DBG_LED                                    0x2ff2
#define DBG_SWITCH                                 0x2ff3
#define DBG_VERSION                                0x2ff4
//========================================================================
//  Global Control Registers			    (12'h000 - 12'h0ff)
//
//========================================================================
// -----------------------------------------------
// CBUS_BASE:  RESET_CBUS_BASE = 0x11
// -----------------------------------------------
#define VERSION_CTRL                               0x1100
#define RESET0_REGISTER                            0x1101
//======================================
//  Reset Register Bits	
//
//======================================
    #define RESET_HIU           (1<<0)
    #define RESET_VLD           (1<<1)
    #define RESET_IQIDCT        (1<<2)
    #define RESET_MC            (1<<3)
	  #define RESET_DCU			      (1<<4)
    #define RESET_VIU           (1<<5)
    #define RESET_AIU           (1<<6)
    #define RESET_VCPU          (1<<7)
    #define RESET_CCPU          (1<<8)
    #define RESET_ASSIST        (1<<11)
    #define RESET_AIFIFO2       (1<<12)
    #define RESET_MDEC          (1<<13)
    #define RESET_VLD_PART      (1<<14)
#define RESET1_REGISTER                            0x1102
    #define RESET_DEMUXSTB      (1<<1)
    #define RESET_USB           (1<<2)
    #define RESET_DDR           (1<<3)
    #define RESET_BT656IN       (1<<5)
    #define RESET_DVIN          (1<<6)
    #define RESET_AHB_BRIDGE    (1<<7)
    #define RESET_PARSER        (1<<8)
    #define RESET_ARC1          (1<<9)
    #define RESET_DDRPLL        (1<<10)
    #define RESET_ARC2          (1<<11)
#define RESET2_REGISTER                            0x1103
    #define RESET_AUDIO_IN      (1<<1)
    #define RESET_DBLK          (1<<2)
    #define RESET_PIC_DC        (1<<3)
    #define RESET_PSCALE        (1<<4)
    #define RESET_PNAND         (1<<5)
    #define RESET_GE2D          (1<<6)
    #define RESET_ARC625        (1<<13)
#define RESET3_REGISTER                            0x1104
#define RESET4_REGISTER                            0x1105

//========================================================================
//  Host uP Interface				    (12'h100 - 12'h2ff)
//
//========================================================================
// -----------------------------------------------
// CBUS_BASE:  HIU_CBUS_BASE = 0x10
// -----------------------------------------------
#define SCR_HIU                                    0x100b
#define HPG_TIMER                                  0x100f
#define HARM_ASB_MB0                               0x1030
#define HARM_ASB_MB1                               0x1031
#define HARM_ASB_MB2                               0x1032
#define HARM_ASB_MB3                               0x1033
#define HASB_ARM_MB0                               0x1034
#define HASB_ARM_MB1                               0x1035
#define HASB_ARM_MB2                               0x1036
#define HASB_ARM_MB3                               0x1037
#define HHI_TIMER90K                               0x103b
#define HHI_AUD_DAC_CTRL                           0x1044
#define HHI_VIID_PLL_CNTL4                         0x1046
#define HHI_VIID_PLL_CNTL                          0x1047
#define HHI_VIID_PLL_CNTL2                         0x1048
#define HHI_VIID_PLL_CNTL3                         0x1049
#define HHI_VIID_CLK_DIV                           0x104a
#define HHI_VIID_CLK_CNTL                          0x104b
#define HHI_VIID_DIVIDER_CNTL                      0x104c
#define HHI_SYS_PLL_CNTL2                          0x104d
#define HHI_AUD_PLL_CNTL2                          0x104e
#define HHI_VID_PLL_CNTL2                          0x104f
// Gated clock enables.  There are 64 enables for the MPEG clocks and 32 enables for other clock domains
#define HHI_GCLK_MPEG0                             0x1050
#define HHI_GCLK_MPEG1                             0x1051
#define HHI_GCLK_MPEG2                             0x1052
#define HHI_GCLK_OTHER                             0x1054
// PLL Controls
#define HHI_SYS_PLL_CNTL3                          0x1056
#define HHI_AUD_PLL_CNTL3                          0x1057
#define HHI_VID_PLL_CNTL3                          0x1058
#define HHI_VID_CLK_DIV                            0x1059
#define HHI_SYS_PLL_CNTL                           0x105a
#define HHI_AUD_PLL_CNTL                           0x105b
#define HHI_VID_PLL_CNTL                           0x105c
#define HHI_MPEG_CLK_CNTL                          0x105d
#define HHI_AUD_CLK_CNTL                           0x105e
#define HHI_VID_CLK_CNTL                           0x105f
#define HHI_WIFI_CLK_CNTL                          0x1060
#define HHI_WIFI_PLL_CNTL                          0x1061
#define HHI_WIFI_PLL_CNTL2                         0x1062
#define HHI_WIFI_PLL_CNTL3                         0x1063
#define HHI_VID_DIVIDER_CNTL                       0x1066
#define HHI_A9_CLK_CNTL                            0x1067
#define HHI_DDR_PLL_CNTL                           0x1068
#define HHI_DDR_PLL_CNTL2                          0x1069
#define HHI_DDR_PLL_CNTL3                          0x106a
#define HHI_MALI_CLK_CNTL                          0x106c
#define HHI_DEMOD_PLL_CNTL                         0x106d
#define HHI_DEMOD_PLL_CNTL2                        0x106e
#define HHI_DEMOD_PLL_CNTL3                        0x106f
#define HHI_OTHER_PLL_CNTL                         0x1070
#define HHI_OTHER_PLL_CNTL2                        0x1071
#define HHI_OTHER_PLL_CNTL3                        0x1072
#define HHI_HDMI_CLK_CNTL                          0x1073
#define HHI_DEMOD_CLK_CNTL                         0x1074
#define HHI_SATA_CLK_CNTL                          0x1075
#define HHI_ETH_CLK_CNTL                           0x1076
#define HHI_A9_AUTO_CLK0                           0x1078
#define HHI_A9_AUTO_CLK1                           0x1079
#define HHI_ARC625_AUTO_CLK0                       0x107a
#define HHI_ARC625_AUTO_CLK1                       0x107b
#define HHI_HDMI_PLL_CNTL                          0x107c
#define HHI_HDMI_PLL_CNTL1                         0x107d
#define HHI_HDMI_PLL_CNTL2                         0x107e
#define HHI_HDMI_AFC_CNTL                          0x107f
#define HHI_AUD_PLL_MOD_CNTL0                      0x1080
#define HHI_AUD_PLL_MOD_LOW_TCNT                   0x1081
#define HHI_AUD_PLL_MOD_HIGH_TCNT                  0x1082
#define HHI_AUD_PLL_MOD_NOM_TCNT                   0x1083
#define HHI_VID_PLL_MOD_CNTL0                      0x1084
#define HHI_VID_PLL_MOD_LOW_TCNT                   0x1085
#define HHI_VID_PLL_MOD_HIGH_TCNT                  0x1086
#define HHI_VID_PLL_MOD_NOM_TCNT                   0x1087
#define HHI_JTAG_CONFIG                            0x108e
//-----------------------------------------------------------
// PARSER 
//-----------------------------------------------------------
// -----------------------------------------------
// CBUS_BASE:  PARSER_CBUS_BASE = 0x01
// -----------------------------------------------
// bit 31:8 -- es_pack_size
// bit 7:6 -- es_type     00-Video, 01-Audio, 10-Subtitle
// bit 5 -- es_write
// bit 4 -- es_passthrough
// bit 3 -- insert_before_es_write
// bit 2 -- discard_cmd
// bit 1 -- search_cmd
// bit 0 -- Parser Busy
#define PARSER_CONTROL                             0x0160
    #define ES_PACK_SIZE_MASK               0xffffff
    #define ES_PACK_SIZE_BIT                8
    #define ES_PACK_SIZE_WID                24
	#define ES_CTRL_WID						8
	#define ES_CTRL_BIT						0
    #define ES_TYPE_MASK                    (3 << 6)
    #define ES_TYPE_VIDEO                   (0 << 6)
    #define ES_TYPE_AUDIO                   (1 << 6)
    #define ES_TYPE_SUBTITLE                (2 << 6)
    #define ES_WRITE                        (1<<5)
    #define ES_PASSTHROUGH                  (1<<4)
    #define ES_INSERT_BEFORE_ES_WRITE       (1<<3)
    #define ES_DISCARD                      (1<<2)
    #define ES_SEARCH                       (1<<1)
    #define ES_PARSER_START                 (1<<0)
    #define ES_PARSER_BUSY                  (1<<0)
// Write
//   bit 31:0 begin address for parser fetch
// Read
//   32 bit current fetch address
#define PARSER_FETCH_ADDR                          0x0161
// Write
//   bit 31 circle buffer indicator
//   bit 30 check_buffer_stop_addr
//   bit 29:27 fetch endian 
//   bit 26:0 buffer size ( Bytes )
// Special command:
//   when bit 26:0 == 27'h0
//     then bit 29    -- stream_passthrough_enable
//          bit 28:27 -- stream_passthrough_type
// Read
//   6:5 cmd_rd_ptr 
//   4:3 cmd_wr_ptr 
//   2:0 cmd_number 
#define PARSER_FETCH_CMD                           0x0162
    #define FETCH_CIR_BUF               (1<<31)
    #define FETCH_CHK_BUF_STOP          (1<<30)
    #define FETCH_PASSTHROUGH           (1<<29)
    #define FETCH_ENDIAN                27
    #define FETCH_PASSTHROUGH_TYPE_MASK (0x3<<27)
    #define FETCH_ENDIAN_MASK           (0x7<<27)
    #define FETCH_BUF_SIZE_MASK         (0x7ffffff)
    #define FETCH_CMD_PTR_MASK          3
    #define FETCH_CMD_RD_PTR_BIT        5
    #define FETCH_CMD_WR_PTR_BIT        3
    #define FETCH_CMD_NUM_MASK          3
    #define FETCH_CMD_NUM_BIT           0
// 31:0 stop_fetch_addr
#define PARSER_FETCH_STOP_ADDR                     0x0163
// 31:0 stop_fetch_addr - current_write_addr  // read only
#define PARSER_FETCH_LEVEL                         0x0164
// bit 31 - fetch_dma_urgent
// bit 30 - stream_dma_urgent
// bit 29 - force_pfifo_ren
// bit 28 - pfifo_peak_enable
// bit 27 - enable_free_clk_parser_reg
// bit 26 -
// bit 25:24 - parser_src_sel (00 - fetch, 01 - aux1, 10 - aux2 11 - aux3)
// bit 23:16 - pfifo_empty_count
// bit 15:12 - max_es_write_cycle (x16x64bits) 
// 11:10 - start code width ( 00-8bits, 01-16bits, 10-24bits, 11-32bits )  
// 9:8 - pfifo data access width ( 00-8bits, 01-16bits, 10-24bits, 11-32bits )  
// 7:0 - empty room for fetch data ( max_fetch_cycle ) x64 bits
#define PARSER_CONFIG                              0x0165
    #define PS_CFG_FETCH_DMA_URGENT         (1<<31)
    #define PS_CFG_STREAM_DMA_URGENT        (1<<30)
    #define PS_CFG_FORCE_PFIFO_REN          (1<<29)
    #define PS_CFG_PFIFO_PEAK_EN            (1<<28)
    #define PS_CFG_SRC_SEL_BIT              24
    #define PS_CFG_SRC_SEL_MASK             (3<<PS_CFG_SRC_SEL_BIT)
    #define PS_CFG_SRC_SEL_FETCH            (0<<PS_CFG_SRC_SEL_BIT)
    #define PS_CFG_SRC_SEL_AUX1             (1<<PS_CFG_SRC_SEL_BIT) // from NDMA
    #define PS_CFG_SRC_SEL_AUX2             (2<<PS_CFG_SRC_SEL_BIT)
    #define PS_CFG_SRC_SEL_AUX3             (3<<PS_CFG_SRC_SEL_BIT)
    #define PS_CFG_PFIFO_EMPTY_CNT_BIT      16
    #define PS_CFG_PFIFO_EMPTY_CNT_MASK     0xff
    #define PS_CFG_MAX_ES_WR_CYCLE_BIT      12
    #define PS_CFG_MAX_ES_WR_CYCLE_MASK     0xf
    #define PS_CFG_STARTCODE_WID_MASK       (0x3<<10)
    #define PS_CFG_STARTCODE_WID_8          (0x0<<10)
    #define PS_CFG_STARTCODE_WID_16         (0x1<<10)
    #define PS_CFG_STARTCODE_WID_24         (0x2<<10)
    #define PS_CFG_STARTCODE_WID_32         (0x3<<10)
    #define PS_CFG_PFIFO_ACCESS_WID_MASK    (0x3<<8)
    #define PS_CFG_PFIFO_ACCESS_WID_8       (0x0<<8)
    #define PS_CFG_PFIFO_ACCESS_WID_16      (0x1<<8)
    #define PS_CFG_PFIFO_ACCESS_WID_24      (0x2<<8)
    #define PS_CFG_PFIFO_ACCESS_WID_32      (0x3<<8)
    #define PS_CFG_MAX_FETCH_CYCLE_BIT      0
    #define PS_CFG_MAX_FETCH_CYCLE_MASK     0xff
// bit 24:16 -- pfifo_level
// bit 9:0 -- point to byte address
#define PFIFO_WR_PTR                               0x0166
    #define PFIFO_WR_LEVEL_BIT   16
    #define PFIFO_BYTE_ADDR_BIT  0
    #define PFIFO_BYTE_ADDR_MASK 0x3ff
// bit 9:0 -- point to byte address
#define PFIFO_RD_PTR                               0x0167
// bit 31:0 -- 8/16/24/32 bits data acording to pfifo_data_width
#define PFIFO_DATA                                 0x0168
// bit 31:0 -- parser search pattern 
#define PARSER_SEARCH_PATTERN                      0x0169
// bit 31:0 -- parser search mask ( 0 - disable bit match test )
#define PARSER_SEARCH_MASK                         0x016a
// bit 31:16 -- parser_int_disable_count
// bit 15:8 -- Parser interrupt enable for host cpu 
// bit 7:0 -- Parser interrupt enable for Amrisc 
#define PARSER_INT_ENABLE                          0x016b
    #define PARSER_INT_DISABLE_CNT_MASK 0xffff
    #define PARSER_INT_DISABLE_CNT_BIT  16
    #define PARSER_INT_HOST_EN_MASK     0xff
    #define PARSER_INT_HOST_EN_BIT      8
    #define PARSER_INT_AMRISC_EN_MASK   0xff
    #define PARSER_INT_AMRISC_EN_BIT    0
	#define PARSER_INT_ALL				0xff
// Bit 7 -- fetch_cmd_finished
// Bit 6:5 -- reserved
// Bit 4 -- parse finished
// Bit 3 -- discard finished
// Bit 2 -- insert zero finished
// Bit 1 -- Action Finished Except Search Start Code
// Bit 0 -- Search match interrupt (StartCode found)
// Read 7:0 int status
// Write will clear (bit based) 
#define PARSER_INT_STATUS                          0x016c
    #define PARSER_INTSTAT_FETCH_CMD    (1<<7)
    #define PARSER_INTSTAT_PARSE        (1<<4)
    #define PARSER_INTSTAT_DISCARD      (1<<3)
    #define PARSER_INTSTAT_INSZERO      (1<<2)
    #define PARSER_INTSTAT_ACT_NOSSC    (1<<1)
    #define PARSER_INTSTAT_SC_FOUND     (1<<0)
// 15    - SCR_32_READ_OUT (Read Only)
// 14    - SCR_32_data_valid
// 13    - SCR_32_data
// 12    - SCR_count_en
// 11:0  - SCR90K_DIV
#define PARSER_SCR_CTL                             0x016d
    #define PARSER_SCR_32_RD            (1<<15)
    #define PARSER_SCR_32_DATA_VALID    (1<<14)
    #define PARSER_SCR_32_DATA          (1<<13)
    #define PARSER_SCR_CNT_EN           (1<<12)
    #define PARSER_SCR90K_DIV_WID       12
    #define PARSER_SCR90K_DIV_BIT       0
    #define PARSER_SCR90K_DIV_MASK      0x7ff
// bit 31:0 SCR value
#define PARSER_SCR                                 0x016e
// bit 31:24 -- insert_loop_number
// bit 23:21 -- 
// bit 20:16 -- insert_byte_number 
// bit 15:0 -- discard number
#define PARSER_PARAMETER                           0x016f
// bit 31:0 -- insert data // write only
// write to PARSER_CONTROL will reset the write position
// continous write to this address can write upto 16 bytes 
#define PARSER_INSERT_DATA                         0x0170
// Bit 31:24 -- Reserved Stream_ID
// Bit 23:16 -- Sub Stream_ID
// Bit 15:8  -- Audio Stream_ID
// Bit 7:0   -- Video Stream_ID
#define VAS_STREAM_ID                              0x0171
// Bit 31:0 -- VIDEO_DTS
#define VIDEO_DTS                                  0x0172
// Bit 31:0 -- VIDEO_PTS
#define VIDEO_PTS                                  0x0173
// Bit 31:0 -- VIDEO_PTS_DTS_WR_PTR
#define VIDEO_PTS_DTS_WR_PTR                       0x0174
// Bit 31:0 -- AUDIO_PTS
#define AUDIO_PTS                                  0x0175
// Bit 31:0 -- AUDIO_PTS_WR_PTR
#define AUDIO_PTS_WR_PTR                           0x0176
// bit 31:20 -- stream_es_count ( Read Only)
// bit 19 -- req_pending ( parser ddr_A_fifo ) (Read Only)
// bit 18 -- stream_es_passthrough_enable
// bit 17:16 -- stream_es_passthrough_type
// bit 15:12 -- reserved
// bit 11:9 -- SUB Ees_write Endian 
// bit 8 -- SUB using manual read point
// bit 7:5 -- AUDIO Ees_write Endian 
// bit 4 -- AUDIO using manual read point
// bit 3:1 -- VIDEO Ees_write Endian 
// bit 0 -- VIDEO using manual read point
#define PARSER_ES_CONTROL                          0x0177
    #define ES_COUNT_MASK                0xfff
    #define ES_COUNT_BIT                 20
    #define ES_REQ_PENDING               (1<<19)
    #define ES_PASSTHROUGH_EN            (1<<18)
    #define ES_PASSTHROUGH_TYPE_MASK     (3<<16)
    #define ES_PASSTHROUGH_TYPE_VIDEO    (0<<16)
    #define ES_PASSTHROUGH_TYPE_AUDIO    (1<<16)
    #define ES_PASSTHROUGH_TYPE_SUBTITLE (2<<16)
    #define ES_WR_ENDIAN_MASK            (0x7)
    #define ES_SUB_WR_ENDIAN_BIT         9
    #define ES_SUB_MAN_RD_PTR            (1<<8)
    #define ES_AUD_WR_ENDIAN_BIT         5
    #define ES_AUD_MAN_RD_PTR            (1<<4)
    #define ES_VID_WR_ENDIAN_BIT         1
    #define ES_VID_MAN_RD_PTR            (1<<0)
// Bit 31:0 PFIFO_MONITOR
#define PFIFO_MONITOR                              0x0178
// --------------------------------------------
// PARSER_VIDEO DDR Interface
// --------------------------------------------
// The PARSER_VIDEO start pointer into DDR memory is a 32-bit number
// The Start pointer will automatically be truncated to land on 
// an 8-byte boundary.  That is, bits [2:0] = 0;
#define PARSER_VIDEO_START_PTR                     0x0180
#define PARSER_VIDEO_END_PTR                       0x0181
// --------------------------------------------
// PARSER_VIDEO Buffer Level Manager
// --------------------------------------------
#define PARSER_VIDEO_WP                            0x0182
#define PARSER_VIDEO_RP                            0x0183
#define PARSER_VIDEO_HOLE                          0x0184
// --------------------------------------------
// PARSER_AUDIO DDR Interface
// --------------------------------------------
// The PARSER_AUDIO start pointer into DDR memory is a 32-bit number
// The Start pointer will automatically be truncated to land on 
// an 8-byte boundary.  That is, bits [2:0] = 0;
#define PARSER_AUDIO_START_PTR                     0x0185
#define PARSER_AUDIO_END_PTR                       0x0186
// --------------------------------------------
// PARSER_AUDIO Buffer Level Manager
// --------------------------------------------
#define PARSER_AUDIO_WP                            0x0187
#define PARSER_AUDIO_RP                            0x0188
#define PARSER_AUDIO_HOLE                          0x0189
// --------------------------------------------
// PARSER_SUB DDR Interface
// --------------------------------------------
// The PARSER_SUB start pointer into DDR memory is a 32-bit number
// The Start pointer will automatically be truncated to land on 
// an 8-byte boundary.  That is, bits [2:0] = 0;
#define PARSER_SUB_START_PTR                       0x018a
#define PARSER_SUB_END_PTR                         0x018b
// --------------------------------------------
// PARSER_SUB Buffer Level Manager
// --------------------------------------------
#define PARSER_SUB_WP                              0x018c
#define PARSER_SUB_RP                              0x018d
#define PARSER_SUB_HOLE                            0x018e
// Bit[31] dma_busy
// Bit[30] cur_fetch_or_es_write
// Bit[29:28] reserved
// Bit[27:24] fetch_status
// Bit[23:0] buffer_cycles_left
#define PARSER_FETCH_INFO                          0x018f
// Bit[31:28] ctl_status
// Bit[27:24] insert_byte_offset
// Bit[23:0] es_pack_left_cycle
#define PARSER_STATUS                              0x0190
// Bit [31:16] AUDIO_wrap_count
// Bit  [15:0] VIDEO_wrap_count
#define PARSER_AV_WRAP_COUNT                       0x0191
// bit[29:24] A_brst_num_parser
// bit[21:16] A_id_parser
// bit[11:0] wrrsp_count_parser
#define WRRSP_PARSER                               0x0192
// `define CSS_cmd             12'h200   // address of css command and indirect register
// `define CSS_cntl            12'h201   // css control register
// `define CSS_data            12'h202   // indirect register
// `define CSS_id1_data  	    12'h203   // ID data for the first and second bytes
// `define CSS_id2_data  	    12'h204   // ID data for the third and fourth bytes
//CPPM registers
// `define CPPM_IFIFO_CTRL		12'h210	  //CPPM input FIFO control
// `define CPPM_C2BC_KEY		12'h211	  //CPPM C2 Block Cipher Key register
// `define CPPM_C2BC_DIN		12'h212	  //CPPM C2 Block Cipher data input register
// `define CPPM_C2BC_DOUT		12'h213   //CPPM C2 Block Cipher data result register
// `define CPPM_CMD			12'h214   //CPPM command and control register
// `define CPPM_CTRL_STATUS	12'h215   //CPPM control status, mainly for debug 
// `define CPPM_IFIFO_DATA		12'h216   //CPPM input FIFO data pop port, just for debug 
// DDR registers
//`define USE_DDR2
//========================================================================
//  DVIN Registers				    (12'h2e0 - 12'h2ef)
//
//========================================================================
// -----------------------------------------------
// CBUS_BASE:  DVIN_CBUS_BASE = 0x12
// -----------------------------------------------
#define VDIN_SCALE_COEF_IDX                        0x1200
#define VDIN_SCALE_COEF                            0x1201
//bit 31,   mpeg_to_vdin_sel, 0: mpeg source to NR directly, 1: mpeg source pass through here
//bit 30,   mpeg_field info which can be written by software
//Bit 29,   force go_field, pulse signal
//Bit 28,   force go_line, pulse signal
//Bit 26:20, hold lines
//Bit 19,   delay go_field function enable
//Bit 18:12, delay go_field line number 
//Bit 11:10, component2 output switch, 00: select component0 in, 01: select component1 in, 10: select component2 in 
//Bit 9:8, component1 output switch, 00: select component0 in, 01: select component1 in, 10: select component2 in 
//Bit 7:6, component0 output switch, 00: select component0 in, 01: select component1 in, 10: select component2 in 
//Bit 4, enable VDIN common data input, otherwise there will be video data input
//Bit 3:0 vdin selection, 1: mpeg_in from dram, 2: component input, 3: tvdecoder input, 4: hdmi input, otherwise no input
#define VDIN_COM_CTRL0                             0x1202
//Bit 28:16 active_max_pix_cnt, readonly
//Bit 12:0  active_max_pix_cnt_shadow, readonly
#define VDIN_ACTIVE_MAX_PIX_CNT_STATUS             0x1203
//Bit 28:16 go_line_cnt, readonly
//Bit 12:0  active_line_cnt, readonly
#define VDIN_LCNT_STATUS                           0x1204
#define VDIN_COM_STATUS0                           0x1205
#define VDIN_COM_STATUS1                           0x1206
//Bit 28:16 go_line_cnt_shadow, readonly
//Bit 12:0  active_line_cnt_shadow, readonly
#define VDIN_LCNT_SHADOW_STATUS                    0x1207
#define VDIN_ASFIFO_CTRL0                          0x1208
#define VDIN_ASFIFO_CTRL1                          0x1209
//Bit 28:16 input width minus 1
//Bit 12:0  output width minus 1
#define VDIN_WIDTHM1I_WIDTHM1O                     0x120a
//Bit 6, prehsc_en
//Bit 5, hsc_en,
//Bit 4, hsc_nearest_en
//Bit 3, phase0_always_en
//Bit 2:0, hsc_bank_length
#define VDIN_SC_MISC_CTRL                          0x120b
//Bit 28:24, interge portion
//Bit 23:0, fraction portion
#define VDIN_HSC_PHASE_STEP                        0x120c
//Bit 30:29    hscale rpt_p0_num
//Bit 28:24    hscale ini_rcv_num
//Bit 23:0     hscale ini_phase
#define VDIN_HSC_INI_CTRL                          0x120d
//Bit 0    post conversion matrix enable
#define VDIN_MATRIX_CTRL                           0x1210
//Bit 28:16 coef00
//Bit 12:0  coef01
#define VDIN_MATRIX_COEF00_01                      0x1211
//Bit 28:16 coef02 
//Bit 12:0  coef10 
#define VDIN_MATRIX_COEF02_10                      0x1212
//Bit 28:16 coef11
//Bit 12:0  coef12
#define VDIN_MATRIX_COEF11_12                      0x1213
//Bit 28:16 coef20
//Bit 12:0  coef21
#define VDIN_MATRIX_COEF20_21                      0x1214
#define VDIN_MATRIX_COEF22                         0x1215
//Bit 26:16 offset0
//Bit 10:0  offset1
#define VDIN_MATRIX_OFFSET0_1                      0x1216
//Bit 10:0  offset2
#define VDIN_MATRIX_OFFSET2                        0x1217
//Bit 26:16 pre_offset0
//Bit 10:0  pre_offset1
#define VDIN_MATRIX_PRE_OFFSET0_1                  0x1218
//Bit 10:0  pre_offset2
#define VDIN_MATRIX_PRE_OFFSET2                    0x1219
//11:0 lfifo_buf_size
#define VDIN_LFIFO_CTRL                            0x121a
#define VDIN_COM_GCLK_CTRL                         0x121b
#define VDIN_WR_CTRL                               0x1220
//Bit 27:16 start
//Bit 11:0  end
#define VDIN_WR_H_START_END                        0x1221
//Bit 27:16 start
//Bit 11:0  end
#define VDIN_WR_V_START_END                        0x1222
//Bit 6:5   hist_dnlp_low   the real pixels in each bins got by VDIN_DNLP_HISTXX should multiple with 2^(dnlp_low+3)
//Bit 3:2   hist_din_sel    the source used for hist statistics. 2'b00: from MAT; 2'b01: from HSC; 2'b1X: from PREHSC
//Bit 1     hist_win_en     1'b0: hist used for full picture; 1'b1: hist used for pixels within hist window
//Bit 0     hist_spl_en     1'b0: disable hist readback; 1'b1: enable hist readback
#define VDIN_HIST_CTRL                             0x1230
//Bit 28:16 hist_hstart  horizontal start value to define hist window
//Bit 12:0  hist_hend    horizontal end value to define hist window
#define VDIN_HIST_H_START_END                      0x1231
//Bit 28:16 hist_vstart  vertical start value to define hist window
//Bit 12:0  hist_vend    vertical end value to define hist window
#define VDIN_HIST_V_START_END                      0x1232
//Bit 15:8  hist_max    maximum value 
//Bit 7:0   hist_min    minimum value 
//read only
#define VDIN_HIST_MAX_MIN                          0x1233
//Bit 31:0  hist_spl_rd
//counts for the total luma value 
//read only
#define VDIN_HIST_SPL_VAL                          0x1234
//Bit 21:0  hist_spl_pixel_count
//counts for the total calculated pixels
//read only
#define VDIN_HIST_SPL_PIX_CNT                      0x1235
//Bit 31:0  hist_chroma_sum
//counts for the total chroma value 
//read only
#define VDIN_HIST_CHROMA_SUM                       0x1236
//Bit 31:16 higher hist bin
//Bit 15:0  lower hist bin
//0-255 are splited to 64 bins evenly, and VDIN_DNLP_HISTXX
//are the statistic number of pixels that within each bin.
//VDIN_DNLP_HIST00[15:0]  counts for the first  bin
//VDIN_DNLP_HIST00[31:16] counts for the second bin
//VDIN_DNLP_HIST01[15:0]  counts for the third  bin
//VDIN_DNLP_HIST01[31:16] counts for the fourth bin
//etc...
//read only
#define VDIN_DNLP_HIST00                           0x1237
#define VDIN_DNLP_HIST01                           0x1238
#define VDIN_DNLP_HIST02                           0x1239
#define VDIN_DNLP_HIST03                           0x123a
#define VDIN_DNLP_HIST04                           0x123b
#define VDIN_DNLP_HIST05                           0x123c
#define VDIN_DNLP_HIST06                           0x123d
#define VDIN_DNLP_HIST07                           0x123e
#define VDIN_DNLP_HIST08                           0x123f
#define VDIN_DNLP_HIST09                           0x1240
#define VDIN_DNLP_HIST10                           0x1241
#define VDIN_DNLP_HIST11                           0x1242
#define VDIN_DNLP_HIST12                           0x1243
#define VDIN_DNLP_HIST13                           0x1244
#define VDIN_DNLP_HIST14                           0x1245
#define VDIN_DNLP_HIST15                           0x1246
#define VDIN_DNLP_HIST16                           0x1247
#define VDIN_DNLP_HIST17                           0x1248
#define VDIN_DNLP_HIST18                           0x1249
#define VDIN_DNLP_HIST19                           0x124a
#define VDIN_DNLP_HIST20                           0x124b
#define VDIN_DNLP_HIST21                           0x124c
#define VDIN_DNLP_HIST22                           0x124d
#define VDIN_DNLP_HIST23                           0x124e
#define VDIN_DNLP_HIST24                           0x124f
#define VDIN_DNLP_HIST25                           0x1250
#define VDIN_DNLP_HIST26                           0x1251
#define VDIN_DNLP_HIST27                           0x1252
#define VDIN_DNLP_HIST28                           0x1253
#define VDIN_DNLP_HIST29                           0x1254
#define VDIN_DNLP_HIST30                           0x1255
#define VDIN_DNLP_HIST31                           0x1256
// Bit 31:22 blkbar_black_level    threshold to judge a black point
// Bit 21    Reserved
// Bit 20:8  blkbar_hwidth         left and right region width
// Bit 7:5   blkbar_comp_sel       select yin or uin or vin to be the valid input
// Bit 4     blkbar_sw_statistic_en enable software statistic of each block black points number
// Bit 3     blkbar_det_en         
// Bit 2:1   blkbar_din_sel        
// bit blkbar_det_top_en
#define VDIN_BLKBAR_CTRL0                          0x1260
// Bit 31:29 Reserved
// Bit 28:16 blkbar_hstart.        Left region start
// Bit 15:13 Reserved
// Bit 12:0  blkbar_hend.          Right region end
#define VDIN_BLKBAR_H_START_END                    0x1261
// Bit 31:29 Reserved
// Bit 28:16 blkbar_vstart        
// Bit 15:13 Reserved
// Bit 12:0  blkbar_vend
#define VDIN_BLKBAR_V_START_END                    0x1262
// Bit 31:20 Reserved
// Bit 19:0  blkbar_cnt_threshold. threshold to judge whether a block is totally black  
#define VDIN_BLKBAR_CNT_THRESHOLD                  0x1263
// Bit 31:29 Reserved
// Bit 28:16 blkbar_row_th1.       //threshold of the top blackbar
// Bit 15:13 Reserved
// bit 12:0  blkbar_row_th2        //threshold of the bottom blackbar
#define VDIN_BLKBAR_ROW_TH1_TH2                    0x1264
//Readonly
// Bit 31:29 Reserved
// Bit 28:16 blkbar_ind_left_start. horizontal start of the left region in the current searching
// Bit 15:13 Reserved
// Bit 12:0  blkbar_ind_left_end.   horizontal end of the left region in the current searching
#define VDIN_BLKBAR_IND_LEFT_START_END             0x1265
//Readonly
// Bit 31:29 Reserved
// Bit 28:16 blkbar_ind_right_start.horizontal start of the right region in the current searching
// Bit 15:13 Reserved
// Bit 12:0  blkbar_ind_right_end.  horizontal end of the right region in the current searching
#define VDIN_BLKBAR_IND_RIGHT_START_END            0x1266
//Readonly
// Bit 31:20 Reserved
// Bit 19:0  blkbar_ind_left1_cnt.  Black pixel counter. left part of the left region
#define VDIN_BLKBAR_IND_LEFT1_CNT                  0x1267
//Readonly
// Bit 31:20 Reserved
// Bit 19:0  blkbar_ind_left2_cnt.  Black pixel counter. rigth part of the left region
#define VDIN_BLKBAR_IND_LEFT2_CNT                  0x1268
//Readonly
// Bit 31:20 Reserved
// Bit 19:0  blkbar_ind_right1_cnt. Black pixel counter. left part of the right region
#define VDIN_BLKBAR_IND_RIGHT1_CNT                 0x1269
//Readonly
// Bit 31:20 Reserved
// Bit 19:0  blkbar_ind_right2_cnt. Black pixel counter. right part of the right region
#define VDIN_BLKBAR_IND_RIGHT2_CNT                 0x126a
//Readonly
// Bit 31:30 Resersed
// Bit 29    blkbar_ind_black_det_done. LEFT/RIGHT Black detection done
// Bit 28:16 blkbar_top_pos.            Top black bar position
// Bit 15:13 Reserved.
// Bit 12:0  blkbar_bot_pos.            Bottom black bar position
#define VDIN_BLKBAR_STATUS0                        0x126b
//Readonly
// Bit 31:29 Reserved
// Bit 28:16 blkbar_left_pos.       Left black bar posiont
// Bit 15:13 Reserved
// Bit 12:0  blkbar_right_pos.      Right black bar position
#define VDIN_BLKBAR_STATUS1                        0x126c
// Bit 31:11 Reserved
// Bit 10: 9 RW, vs_hs_tim_ctrl
// Bit     8 RW, sample_clk_neg
// Bit     7 RW, mode_422
// Bit  6: 5 RW, de_mode
// Bit     4 RW, ext_field_sel
// Bit     3 RW, field_pol_inv
// Bit     2 RW, de_pol_inv
// Bit     1 RW, vs_pol_inv
// Bit     0 RW, hs_pol_inv
#define DVIN_FRONT_END_CTRL                        0x12e0
// Bit 31:28 Reserved
// Bit 27:16 RW, hs_lead_vs_odd_max
// Bit 15:12 Reserved
// Bit 11: 0 RW, hs_lead_vs_odd_min
#define DVIN_HS_LEAD_VS_ODD                        0x12e1
// Bit 31:28 Reserved
// Bit 27:16 RW, active_start_pix_fo
// Bit 15:12 Reserved
// Bit 11: 0 RW, active_start_pix_fe
#define DVIN_ACTIVE_START_PIX                      0x12e2
// Bit 31:28 Reserved
// Bit 27:16 RW, active_start_line_fo
// Bit 15:12 Reserved
// Bit 11: 0 RW, active_start_line_fe
#define DVIN_ACTIVE_START_LINE                     0x12e3
// Bit 31:28 Reserved
// Bit 27:16 RW, field_height_m1
// Bit 15:12 Reserved
// Bit 11: 0 RW, line_width_m1
#define DVIN_DISPLAY_SIZE                          0x12e4
// Bit 31:30 Reserved
// Bit    29 R,  multiple_fifo_fend
// Bit    28 R,  fifo_overflow
// Bit 27:16 R,  hs_lead_vs_cnt
// Bit 15: 5 Reserved
// Bit     4 RW, ddr_burst_size -- 0=default,32 per burst; 1=64 per burst
// Bit     3 W,  clear_err (a pulse)
// Bit     2 RW, urgent
// Bit     1 RW, fifo_reset
// Bit     0 RW, dvin_enable
#define DVIN_CTRL_STAT                             0x12e5
// Bit 31: 8 Reserved
// Bit  7: 0 RW, nxt_tbl_addr
#define DVIN_VCANV_TBL_ADDR                        0x12e6
// Bit 31:29 Reserved
// Bit 28:16 RW, nxt_y_start_addr
// Bit 15:12 Reserved
// Bit 11: 0 RW, nxt_x_start_addr
#define DVIN_VCANV_XY_START_ADDR                   0x12e7
//========================================================================
//  CPU Registers				    (8'h00 - 8'hff)
//
//========================================================================
// CPU1 registers are 8'h0x
// -----------------------------------------------
// CBUS_BASE:  CPU1_CBUS_BASE = 0x03
// -----------------------------------------------
#define MSP                                        0x0300
#define MPSR                                       0x0301
#define MINT_VEC_BASE                              0x0302
#define MCPU_INTR_GRP                              0x0303
#define MCPU_INTR_MSK                              0x0304
#define MCPU_INTR_REQ                              0x0305
#define MPC_P                                      0x0306
#define MPC_D                                      0x0307
#define MPC_E                                      0x0308
#define MPC_W                                      0x0309
#define MINDEX0_REG                                0x030a
#define MINDEX1_REG                                0x030b
#define MINDEX2_REG                                0x030c
#define MINDEX3_REG                                0x030d
#define MINDEX4_REG                                0x030e
#define MINDEX5_REG                                0x030f
#define MINDEX6_REG                                0x0310
#define MINDEX7_REG                                0x0311
#define MMIN_REG                                   0x0312
#define MMAX_REG                                   0x0313
#define MBREAK0_REG                                0x0314
#define MBREAK1_REG                                0x0315
#define MBREAK2_REG                                0x0316
#define MBREAK3_REG                                0x0317
#define MBREAK_TYPE                                0x0318
#define MBREAK_CTRL                                0x0319
#define MBREAK_STAUTS                              0x031a
#define MDB_ADDR_REG                               0x031b
#define MDB_DATA_REG                               0x031c
#define MDB_CTRL                                   0x031d
#define MSFTINT0                                   0x031e
#define MSFTINT1                                   0x031f
#define CSP                                        0x0320
#define CPSR                                       0x0321
#define CINT_VEC_BASE                              0x0322
#define CCPU_INTR_GRP                              0x0323
#define CCPU_INTR_MSK                              0x0324
#define CCPU_INTR_REQ                              0x0325
#define CPC_P                                      0x0326
#define CPC_D                                      0x0327
#define CPC_E                                      0x0328
#define CPC_W                                      0x0329
#define CINDEX0_REG                                0x032a
#define CINDEX1_REG                                0x032b
#define CINDEX2_REG                                0x032c
#define CINDEX3_REG                                0x032d
#define CINDEX4_REG                                0x032e
#define CINDEX5_REG                                0x032f
#define CINDEX6_REG                                0x0330
#define CINDEX7_REG                                0x0331
#define CMIN_REG                                   0x0332
#define CMAX_REG                                   0x0333
#define CBREAK0_REG                                0x0334
#define CBREAK1_REG                                0x0335
#define CBREAK2_REG                                0x0336
#define CBREAK3_REG                                0x0337
#define CBREAK_TYPE                                0x0338
#define CBREAK_CTRL                                0x0339
#define CBREAK_STAUTS                              0x033a
#define CDB_ADDR_REG                               0x033b
#define CDB_DATA_REG                               0x033c
#define CDB_CTRL                                   0x033d
#define CSFTINT0                                   0x033e
#define CSFTINT1                                   0x033f
#define IMEM_DMA_CTRL                              0x0340
#define IMEM_DMA_ADR                               0x0341
#define IMEM_DMA_COUNT                             0x0342
// bit[29:24] A_brst_num_imem
// bit[21:16] A_id_imem
// bit[11:0] wrrsp_count_imem (reserved)
#define WRRSP_IMEM                                 0x0343
#define LMEM_DMA_CTRL                              0x0350
#define LMEM_DMA_ADR                               0x0351
#define LMEM_DMA_COUNT                             0x0352
// bit[29:24] A_brst_num_lmem
// bit[21:16] A_id_lmem
// bit[11:0] wrrsp_count_lmem 
#define WRRSP_LMEM                                 0x0353
#define MAC_CTRL1                                  0x0360
#define ACC0REG1                                   0x0361
#define ACC1REG1                                   0x0362
#define MAC_CTRL2                                  0x0370
#define ACC0REG2                                   0x0371
#define ACC1REG2                                   0x0372
#define CPU_TRACE                                  0x0380
//=======================================================================
// XIF module
// `include "xregs.h"
    #define X_INT_ADR           0x400
    #define GPIO_ADR            0x401
    #define GPIO_ADR_H8         0x402 
    #define WFIFO_DEPTH         8          
    #define WFIFO_PointerWidth  3
    #define WFIFO_WORDSIZE      32
// MAC module
#define CLR_ACC_MAC                                0x0710
#define CLR_ACC_MAC2                               0x0711
#define ACC_0                                      0x0712
#define ACC_1                                      0x0713
#define ACC_2                                      0x0714
#define ACC_3                                      0x0715
//========================================================================
//  Audio Interface				    (12'h500 - 12'h5ff)
//
//========================================================================
//
// Reading file:  aregs.h
//
//========================================================================
//  Audio Interface                                 (8'h00 - 8'hff)
//  Modified : Xuyun Chen Jan 2001
//========================================================================
// Number of bytes expected per NON-PCM frame, including the header.
// 16 bits.  
// -----------------------------------------------
// CBUS_BASE:  AIU_CBUS_BASE = 0x15
// -----------------------------------------------
#define AIU_958_BPF                                0x1500
// Value of burst_info used in IEC958 preamble for a NON-PCM frame. See
// ATSC AC-3 spec Annex B. 16 bits.
#define AIU_958_BRST                               0x1501
// Value of length_code used in IEC958 preamble for an NON-PCM frame. See
// ATSC AC-3 spec Annex B. 16 bits.
#define AIU_958_LENGTH                             0x1502
// How many subframes to padd around the NON-PCM frame. This will 
// be set to 'd3072 if it is a AC-3 audio stream.
// 16 bits
#define AIU_958_PADDSIZE                           0x1503
// 16'd3072
// Misc. control settings for IEC958 interface
// Bit 15:14 pcm_sample_ctl, 00-pcm_no_sample, 01-pcm_sample_up, 10-pcm_sample_down, 11-pcm_sample_down_drop
// Bit 13: if true, force each audio data to left or right according to the bit attached with the audio data
//         This bit should be used with Register AIU_958_force_left(0x505) together
// Bit 12: if true, the U(user data) is from the stream otherwise it is filled by 
//                   zero while encoding iec958 frame
// Bit 11   : if true big endian(highword,lowword) otherwise little endian(lowword,highword)
//            for 32bit mode 
// Bit 10:8 : shift number for 32 bit mode
// Bit 7  : 32 bit mode turn on while This bit is true and Bit 1 is true 
// Bit 6:5 : Specifies output alignment for 16 bit pcm data.
//          00 : dout = {8'b0, din};
//          01 : dout = {4'b0, din, 4'b0};
//          10 : dout = {      din, 8'b0};
// Bit 4  : True if data should be sent out MSB first. LSB first is the
//          default in the spec.
// Bit 3  : True if msb should be extended (only used with 16 bit pcm data.)
// Bit 2  : True if msb of PCM data should be inverted.
// Bit 1  : True if PCM data is 16 bits wide. False if 24 bit or 32bit mode.
// Bit 0  : True if source data is non-PCM data. False if it is PCM data.
#define AIU_958_MISC                               0x1504
// 14'b0_0_0_000_0_0000001
// A write to this register specifies that the next pcm sample sent out
// of the iec958 interface should go into the _left_ channel.
#define AIU_958_FORCE_LEFT                         0x1505
//Read Only
//bit 6:0  how many data discarded in the last dma after one frame data finish transfering to AIU 
// should used together with register AIU_958_dcu_ff_ctrl
#define AIU_958_DISCARD_NUM                        0x1506
//bit 15:8  : A read from this register indicates the IEC958 FIFO count value 
//bit 7 :  ai_958_req_size if ture, set to 8 bits interface, used to handle odd frame continous read  
//bit 6 :  continue seeking and dont discard the rest data in one dma after frame end
//bit 5 :  if true, byte by byte seeking, otherwise word by word seeking
//bit 4 :  if true, the function for sync head seeking is enabled
//bit 3:2 :	IEC958 interrupt mode
// There are two conditions to generate interrupt. The First condition is that one frame data
// have been finished writing into FIFO. The second condition is at least some data of the current 
// frame have been read out(refer to Register AIU_958_ffrdout_thd)
//			00: interrupt is not generated
//			10:	interrupt is generated if the first condition is true 
//			01:	interrupt is generated if the second condition is true 
//			11:	interrupt is generated if both of the conditions are true 
//bit 1: fifo auto disable, High means after one frame data put into the FIFO, the FIFO
//					will automatically disabled
//bit 0: fifo enable
#define AIU_958_DCU_FF_CTRL                        0x1507
// 'b0_0_1_11_1_0
// channel status registers for Left channel
// chstat_l0[15:0] contains bits 15:0 of the channel status word. Note
// that bit zero of the channel status word is sent out first.
// chstat_l1[15:0] contains bits 31:16 of the channel status word.
#define AIU_958_CHSTAT_L0                          0x1508
#define AIU_958_CHSTAT_L1                          0x1509
// Control register for IEC958 interface
// Bit 9:8 what to do if there is a fifo underrun
//         00 => insert 24'h000000
//         01 => insert mute constant as defined below
//         10 => repeat last l/r samples
// Bit 7:5 mute constant
//         000 => 24'h000000
//         001 => 24'h800000
//         010 => 24'h080000
//         011 => 24'h008000
//         100 => 24'h000001
//         101 => 24'h000010
//         110 => 24'h000100
// Bit 4   mute left speaker
// Bit 3   mute right speaker
// Bit 2:1 swap channels
//         00 : L R => L R
//         01 : L R => L L
//         10 : L R => R R
//         11 : L R => R L
// Bit 0   Set this bit to hold iec958 interface after the current
//         subframe has been completely transmitted.
#define AIU_958_CTRL                               0x150a
// 10'b00_000_00_00_0
// A write operation to this register will cause one of the output samples
// to be repeated. This can be used to switch the left and the right
// channels.
#define AIU_958_RPT                                0x150b
// Channel swap and mute control register.
// Bit 15: Mute extra left channel
// Bit 14: Mute extra right channel
// Bit 13: Mute center
// Bit 12: Mute subwoofer
// Bit 11: Mute surround left
// Bit 10: Mute surround right
// Bit  9: Mute left
// Bit  8: Mute right
// Bit 7:6 Channel swap for xtra dac
// Bit 5:4 Channel swap for sub/center dac
// Bit 3:2 Channel swap for surround dac
// Bit 1:0 Channel swap for main l/r dac
// Channel swap possibilities:
// 00 : L R => L R
// 01 : L R => L L
// 10 : L R => R R
// 11 : L R => R L
#define AIU_I2S_MUTE_SWAP                          0x150c
// 16'b0
// Bit 0 : 0=> single two channel stream
//         1=> four two channel streams
#define AIU_I2S_SOURCE_DESC                        0x150d
// Median filter control register
// Bit 1:  0=> data is offset binary
//         1=> data is signed
// Bit 0:  enable median filter
#define AIU_I2S_MED_CTRL                           0x150e
// 2'b10
// Median filter threshold constant
// 16 bits
#define AIU_I2S_MED_THRESH                         0x150f
// 16'h8000
// Describes dac's connected to I2S interface
// Bit 7:  sign extend sample before downshift.
// Bit 6:4 payload downshift constant
// Bit 3:  mute constant
//         0 => 'h0000000
//         1 => 'h800000
// Bit 2:  send msb first
// Bit 1:0 Size of payload
//         Note that this parameter used to be called "size of dacs"
//         It is now called the payload size since a 24 bit payload can
//         actually be connected to any size of dac. The dac will simply
//         disregard the extra bits.
//         00 => 16 bit, alrclk = aoclk/32 
//         01 => 20 bit, alrclk = aoclk/40 
//         10 => 24 bit, alrclk = aoclk/48 
//		   11 => 24 bit, but alrclk = aoclk/64 
#define AIU_I2S_DAC_CFG                            0x1510
// 8'b0_000_1_1_10
// A write to this register will cause the interface to repeat the current
// sample. Can be used to regain synchronization.
// A read from this register indicates that the next sample to be sent
// out of the interface should go into the _left_ channel of the dac.
#define AIU_I2S_SYNC                               0x1511
// Misc regs
// Bit 4 if true, force each audio data to left or right according to the bit attached with the audio data
//         This bit should be used with Register AIU_i2s_sync(0x511) together
// Bit 3:  Same Audio source for IEC958 and I2s stream 0, both from i2s buffer 
// Bit 2:  Set this bit to put i2s interface in hold mode
// Bit 1:0 How to handle underruns
//         00 => send zeros
//         01 => send 'h800000
//         10 => repeat last samples
#define AIU_I2S_MISC                               0x1512
// 5'b0
// Bit 7:0 Audio output config.
//			2 bits for each dac, 7:6 for dac3, 5:4 for dac2,
//								 3:2 for dac1, 1:0 for dac0
//			For each 2bits: 00: connect channel0-1 to the dac
//							01: connect channel2-3 to the dac
//							10: connect channel4-5 to the dac
//							11: connect channel6-7 to the dac
#define AIU_I2S_OUT_CFG                            0x1513
// 8'b0_000000_0
#define AIU_I2S_FF_CTRL                            0x1514
// A write to this register resets the AIU
//Bit 3 reset slow domain iec958
//Bit 2 soft reset iec958 fast domain
//Bit 1 reset slow domain i2s
//Bit 0 soft reset i2s fast domain
#define AIU_RST_SOFT                               0x1515
// Clock generation control register
// Bit 15: enable_ddr_arb, set low to reset
// Bit 14:13 parser_A_addr_sel  00-A_addr_aififo2, 01-A_addr_iec958, 10-A_addr_aififo, 11-A_addr_i2s
// Bit 12: 958 divisor more, if true, divided by 2, 4, 6, 8
// Bit 11: amclk output divisor
//			0 => dont divide
//			1 => divide by 2		
// Bit 10: clock source selection
//        0 => aiclk from pin
//        1 => ai_pll_clk from pll
// Bit 9:8 alrclk skew
//         00 => alrclk transitions at the same time msb is sent
//         01 => alrclk transitions on the cycle before msb is sent
//         10 => alrclk transitions on the cycle after msb is sent
// Bit 7: invert alrclk
// Bit 6: invert aoclk
// Bit 5:4 958 divisor
//        00 => divide by 1
//        01 => divide by 2
//		  10 => divide by 3
//		  11 => divide by 4
// Bit 3:2 i2s divisor. NOTE: this value is ignored if AIU_clk_ctrl_more[3:0] != 0 
//         00 => divide by 1
//         01 => divide by 2
//         10 => divide by 4
//         11 => divide by 8
// Bit 1: enable 958 divider
// Bit 0: enable i2s divider
#define AIU_CLK_CTRL                               0x1516
// 13'b0_0_1_01_1_1_10_11_0_0
// Misc settings that determine the type of adc that is
// connected to the AIU. Reverb mode is deleted.
// Bit 12:  selects adc input
// Bit 11:10 adc size
//           00 => 16 bits
//           01 => 18 bits
//           10 => 20 bits
//           11 => 24 bits
// Bit 9:8   adc l/r swap mode
//           00 => stereo
//           01 => send the right adc input to both l and r speakers
//           01 => send the left adc input to both l and r speakers
//           11 => sum the left and right inputs and forward to
//                both speakers
// Bit 7:5 adata/lrclk skew mode
// Bit 4   1=>invert the adc's lrclk (This is the lrclk going _out_
//         of the chip.
// Bit 3   1=>Latch the data on the positive edge of the _internal_
//         aoclk.
// Bit 2   1=>adc data is in signed 2's complement mode
#define AIU_MIX_ADCCFG                             0x1517
// 12'b01_00_001_1_0_1_00
// Control register that can be changed dynamically. These control
// signals are synchronized internally.
// Bit 12:  if true, toggle each mixed audio data to left or right channel
// Bit 11:  abuf din left selection, if true, select bit 24 of the data from abuf
//		    otherwise select bit 25 of the data from abuf
// Bit 10:9  mix sync select, when music, mic and abuf are mixed togather, the main
//			 sync source can be selected
//     00: not sync source
//	   01: music data is the main sync source
//	   10: abuf input data is the main sync source
//	   11: music and abuf togather as the sync source
// Bit 8:  0=> data from abuf is offset binary
//         1=> data from abuf is signed
// Bit 7:6 the source for data from aiu to abuf 
//           00 => mic
//           01 => mic saled + abuf scaled 
//           10 => mic scaled + abuf scaled + music scaled
//			 11 => music
// Bit 5   channel from aiu to abuf is on
// Bit 4   channel from abuf to aiu is on
// Bit 3   mic is on
// Bit 2   music is on
// Bit 1   if true the mixed data are outputed to i2s dac channel,
//			otherwise the mixed data are outputed to IEC958 output 
// Bit 0   if true music source for mixing is from i2s buffer, 
//			otherwise music source is from iec958 buffer
#define AIU_MIX_CTRL                               0x1518
// 11'b01_1_01_0_0_0_1_1_1
// Bit 3:0 More control on i2s divisor. For backward compatiblity, this value is ignored if is 0,
//         if non-zero, it takes effect over AIU_clk_ctrl[3:2].
//         0=i2s divisor will use the old value in AIU_clk_ctrl[3:2] (divide by 1/2/4/8)
//         1=divide by 2;
//         2=divide by 3;
//         3=divide by 4;
//         ... and so on ...
//         15=divide by 16.
#define AIU_CLK_CTRL_MORE                          0x1519
// A read from this register pops 16 bits of data off the 958
// fifo. A write has no effect.
#define AIU_958_POP                                0x151a
//gain register for mixing
// for each gain, 
//			 00000: x 0
//			 00001: x 1
//			 00010: x 2
//           00011: x 3
//			 00100: x 4
//			 00101: x 5
//			 00110: x 6
//			......
//           01110: x14
//           01111: x15
//           10000: x 0
//           10001: x 1/16
//           10010: x 2/16
//           10011: x 3/16
//           10100: x 4/16
//			......
//           11110: x 14/16
//           11111: x 15/16
//Bit 14:10 mic gain
//Bit 9:5 	abuf gain
//Bit 4:0 music gain
#define AIU_MIX_GAIN                               0x151b
// 15'b00001_00001_00001
//sync head seeking is supported. The  maxinium length of sync head is
//48-bit-wide.(in byte by byte seeking mode, the maximium is 44-bit-wide).
//It is consisted of 3 words (synword1_synword2_syncword3).
//You can configure the sync head pattern by using sync mask(mask1_mask2_mask3).  
//For example. AC-3 sync head is a 16-bit word(0b77), so syncword1 is set as 0b77, 
//mask1 is 0000(not set), mask2 and mask3 is all masked.
#define AIU_958_SYNWORD1                           0x151c
//16'h0b77  //ac-3 sync head
#define AIU_958_SYNWORD2                           0x151d
//16'h0000  
#define AIU_958_SYNWORD3                           0x151e
//16'h0000
#define AIU_958_SYNWORD1_MASK                      0x151f
//16'h0000 //16-bit ac-3 sync_head
#define AIU_958_SYNWORD2_MASK                      0x1520
//16'hffff
#define AIU_958_SYNWORD3_MASK                      0x1521
//16'hffff
//fifo read-out threshold, one condition to generate interrupt is met after fifo readout counter
//reach this value in a frame, please refer to register AIU_958_dcu_ff_ctrl
#define AIU_958_FFRDOUT_THD                        0x1522
//'h0004
//For pause burst sequence adding, one pause burst sequence is consist of a serious
// pause burst.
//This register defines the length of each pause burst in a pause burst sequence. The size of the
//preamble(Pa, Pb, Pc, Pd) is not counted, but the size of stuff data is counted.
#define AIU_958_LENGTH_PER_PAUSE                   0x1523
//'h0000
//This reigster defines the number of pause burst in a pause burst sequence.
//Bit 15  if true, one pause burst sequence will be added 
//Bit 14:0 the number of pause burst in a pause burst sequence
#define AIU_958_PAUSE_NUM                          0x1524
//'h0000
//The first 16-bit in the payload of pause burst sequence (gap_length)
#define AIU_958_PAUSE_PAYLOAD                      0x1525
//'h0000
//For auto pause function, when enabled, pause burst sequence will be automatically added if the data in
// 958 fifo is less than auto_pause threshold and if fifo is disabled.
//Bit 15   if true, auto pause function enable
//Bit 14   pause pack option, just for debugging and adding one option
//Bit 7:0  auto_pause threshold
#define AIU_958_AUTO_PAUSE                         0x1526
//'h0000
//pause burst sequence payload length( = AIU_958_pause_num * AIU_958_length_per_pause)
#define AIU_958_PAUSE_PD_LENGTH                    0x1527
//'h0000
// channel status registers for right channel
// chstat_r0[15:0] contains bits 15:0 of the channel status word. Note
// that bit zero of the channel status word is sent out first.
// chstat_r1[15:0] contains bits 31:16 of the channel status word.
#define AIU_958_CHSTAT_R0                          0x1530
#define AIU_958_CHSTAT_R1                          0x1531
//Bit 1 	if true, turn on Digital output Valid control
//Bit 0		0: output 0, 1: output 1 to the valid bit in audio digital output when Bit 1 is true
#define AIU_958_VALID_CTRL                         0x1532
//-----------------------------------------------------------------------------
// Audio Amplifier controls
//-----------------------------------------------------------------------------
#define AIU_AUDIO_AMP_REG0                         0x153c
#define AIU_AUDIO_AMP_REG1                         0x153d
#define AIU_AUDIO_AMP_REG2                         0x153e
#define AIU_AUDIO_AMP_REG3                         0x153f
//-----------------------------------------------------------------------------
//add for AIFIFO2 channel
//-----------------------------------------------------------------------------
//Bit 3 	CRC pop aififo2 enable
//Bit 2		writing to this bit to 1 causes CRC module reset
//Bit 1		unused
//Bit 0		writing to this bit to 1 causes AIFIFO2 soft reset
#define AIU_AIFIFO2_CTRL                           0x1540
//'h0000
//AIFIFO2 status register
//Bit 4:0		//how many bits left in the first pop register
#define AIU_AIFIFO2_STATUS                         0x1541
//Same fucntion as the AIGBIT of AIFIFO in CDROM module
//write to this register how many bits wanna pop, 
//and reading this register gets the corresponding bits data
#define AIU_AIFIFO2_GBIT                           0x1542
//Same function as the AICLB of AIFIFO in CDROM module
//return the leading zeros by reading this registers
#define AIU_AIFIFO2_CLB                            0x1543
//CRC control register, read/write
//Bit 0		CRC caculation start
//Bit 1		CRC core soft reset
//Bit 2		CRC input register clear
//Bit 3		CRC pop data from FIFO enable
//Bit 13:8	CRC polynomial equation order, between 1 to 32
#define AIU_CRC_CTRL                               0x1544
//16'h1000
//CRC status register, read only
//Bit 7:4	CRC internal shift register bit select, just for debug purpose
//Bit 3		CRC internal shift register data valid, just for debug purpose
//Bit 2		CRC input register data valid
//Bit 1		CRC result, 1: CRC not correct, 0: CRC correct
//Bit 0		CRC state,  1: CRC busy, 0: CRC idle
#define AIU_CRC_STATUS                             0x1545
//CRC internal shift register, read only, for debug purpose
#define AIU_CRC_SHIFT_REG                          0x1546
//CRC data input register, read/write
#define AIU_CRC_IREG                               0x1547
//16'h0000
//CRC calculation register high-bit part [31:16], read/write
#define AIU_CRC_CAL_REG1                           0x1548
//CRC calculation register low-bit part [15:0], read/write
#define AIU_CRC_CAL_REG0                           0x1549
//32'h00000000
//CRC polynomial coefficient high-bit part [31:16], read/write
#define AIU_CRC_POLY_COEF1                         0x154a
//CRC polynomial coefficient low-bit part [15:0], read/write
#define AIU_CRC_POLY_COEF0                         0x154b
//32'h80050000			default CRC-16
//CRC frame size, high-bit part [19:16], read/write
#define AIU_CRC_BIT_SIZE1                          0x154c
//CRC frame size, low-bit part [15:0],	 read/write
#define AIU_CRC_BIT_SIZE0                          0x154d
//20'hfffff
//how many bits have been processed right now in the current frame, read only
//high-bit part [19:16]
#define AIU_CRC_BIT_CNT1                           0x154e
//low-bit part [15:0]
#define AIU_CRC_BIT_CNT0                           0x154f
// -------------------------------------
// AMCLK Measurement
// -------------------------------------
// Used to measure the amclk frequency
#define AIU_AMCLK_GATE_HI                          0x1550
#define AIU_AMCLK_GATE_LO                          0x1551
#define AIU_AMCLK_MSR                              0x1552
#define AIU_AUDAC_CTRL0                            0x1553
#define AIU_AUDAC_CTRL1                            0x1554
// -------------------------------------
// Super Simple Delta Sigma DAC
// -------------------------------------
// bit 15   1 = invert the clock to the analog filter
// bit 14   1 = digital mute
// bit 13   1 = enable analog mute (in the analog block)
// bit 12   1 = enable Right channel 3 in the analog block
// bit 11   1 = enable Left  channel 3 in the analog block
// bit 10   1 = enable Right channel 2 in the analog block
// bit  9   1 = enable Left  channel 2 in the analog block
// bit  8   1 = enable Right channel 1 in the analog block
// bit  7   1 = enable Left  channel 1 in the analog block
// bit  6   1 = enable Right channel 0 in the analog block
// bit  5   1 = enable Left  channel 0 in the analog block
// bit  4:  bit select for serial input data
// bit  3:  invert alrclk used by the delta-sigma DAC
// bit  2:  1 = use serial I2S data.  0 = use parallel audio data
// bits 1:0 Which data to send to the delta-sigma DAC
//              11 = use channel 3 data
//              10 = use channel 2 data
//              01 = use channel 1 data
//              00 = use channel 0 data
#define AIU_DELTA_SIGMA0                           0x1555
// Delta Sigma MUTE Value
#define AIU_DELTA_SIGMA1                           0x1556
// Additional Audio filter controls
#define AIU_DELTA_SIGMA2                           0x1557
//Bit 14, left channel Delta Sigma modulator soft reset
//Bit 13, right channel Delta Sigma modulator soft reset
//Bit 12, left channel Delta Sigma modulator internal state clear enable when it is unstable
//Bit 11, right channel Delta Sigma modulator internal state clear enable when it is unstable
//Bit 10, left channel Delta Sigma detect unstable state enable
//Bit  9, right channel Delta Sigma detect unstable state enable
//Bit  8, dither high pass filter enable in the Delta Sigma loop
//Bit 7:6, reserved
//Bit 5:0, Delta Sigma input data gain  0/32 ~ 63/32
//default: 16'h3
#define AIU_DELTA_SIGMA3                           0x1558
//15:8, Added Delta Sigma DC level, range:+-1/2, minimium: +-1/128 (assume max is -1 ~ +1)
//7:0, max same sequence number, used for unstable detection
//default: 16'h0
#define AIU_DELTA_SIGMA4                           0x1559
//Bit 15:8, square wave divide num
//Bit 7:0, square wave amplitude, -1/4 ~ 1/4, minimium: +-1/1024
//default: 16'h0
#define AIU_DELTA_SIGMA5                           0x155a
//Bit 11:8, loop dither amplitude2, 0/32 ~ 15/32
//Bit 7:4,  loop dither amplitude1, 0/32 ~ 15/32
//Bit 3:0,  loop dither amplitude0, 0/32 ~ 15/32
//default: 16'h0
#define AIU_DELTA_SIGMA6                           0x155b
//Bit 15:8, loop dithering threshold1   0, 1/512, 2/512 ... 1/2
//Bit 7:0,  loop dithering threshold0   0, 1/512, 2/512 ... 1/2
//default: 16'h0
#define AIU_DELTA_SIGMA7                           0x155c
//read only
//Bit 15:8  left channel Delta Sigma clear counter number, how many times Delta Sigma has been reseted
//          It will saturate to 255, if more than 255 time
//Bit 7:0   left channel max same sequence number
#define AIU_DELTA_SIGMA_LCNTS                      0x155d
//read only
//Bit 15:8  right channel Delta Sigma clear counter number, how many times Delta Sigma has been reseted
//          It will saturate to 255, if more than 255 time
//Bit 7:0   right channel max same sequence number
#define AIU_DELTA_SIGMA_RCNTS                      0x155e
// --------------------------------------------
// I2S DDR Interface
// --------------------------------------------
// The I2S start pointer into DDR memory is a 32-bit number
#define AIU_MEM_I2S_START_PTR                      0x1560
#define AIU_MEM_I2S_RD_PTR                         0x1561
#define AIU_MEM_I2S_END_PTR                        0x1562
// There are two masks that control how data is read:
// [31:16] IRQ block.
// [15:8] chan_mem_mask.  Each bit indicates which channels exist in memory
// [7:0]  chan_rd_mask.   Each bit indicates which channels are READ from memory
#define AIU_MEM_I2S_MASKS                          0x1563
// I2S FIFO Control
// bits [11:10] Select which hardware pointer to use to control the buffer
//              level:
//                  00 = parser 
//                  01 = audin_fifo0_wrpt 
//                  1x = audin_fifo1_wrpt 
// bit  [9]     Use level control: 1 = use buffer level control
// bit  [8]     Read Only.  This bit is 1 when there is data available for reading
// bit  [7]     Read only.  This bit will be high when we're fetching data from the DDR memory
//              To reset this module, set cntl_enable = 0, and then wait for busy = 0. 
//              After that you can pulse cntl_init to start over
// bit  [6]     cntl_mode_16bit:Set to 1 for 16 bit storage format in DDR
// bits [5:3]   endian:  see $lib/rtl/ddr_endian.v
// bit  [2]     cntl_empty_en   Set to 1 to enable reading data from the FIFO
// bit  [1]     cntl_fill_en    Set to 1 to enable reading data from DDR memory
// bit  [0]     cntl_init:      After setting the read pointers, sizes, channel masks
//                              and read masks, set this bit to 1 and then to 0
#define AIU_MEM_I2S_CONTROL                        0x1564
// --------------------------------------------
// IEC958 DDR Interface
// --------------------------------------------
// The IEC958 start pointer into DDR memory is a 32-bit number
#define AIU_MEM_IEC958_START_PTR                   0x1565
#define AIU_MEM_IEC958_RD_PTR                      0x1566
#define AIU_MEM_IEC958_END_PTR                     0x1567
// There are two masks that control how data is read:
// [15:8] chan_mem_mask.  Each bit indicates which channels exist in memory
// [7:0]  chan_rd_mask.   Each bit indicates which channels are READ from memory
#define AIU_MEM_IEC958_MASKS                       0x1568
// IEC958 FIFO Control
// bit  [31]    A_urgent
// bit  [30]    ch_always_8
// bit  [29:24] rdata_rd_base_begin ( used for select from different channel ) 
// bit  [23:14] reserved
// bit  [13]    cntl_sim_en
// bit  [12]    cntl_use_level
// bit  [11]    Read only.      This bit will be set to 1 when there is data in the FIFO to process
// bit  [10]    Read only.  This bit will be high when we're fetching data from the DDR memory
//              To reset this module, set cntl_enable = 0, and then wait for busy = 0. 
//              After that you can pulse cntl_init to start over
// bit  [9]     cntl_endian_jic Just in case endian.  last minute byte swap of the data out of
//                              the FIFO to the rest of the IEC958 logic
// bit  [8]     mode_raw:       Set this bit to 1 to tell the IEC958 FIFO to read
//                              and process data linearly for raw data.  
// bit  [7]     cntl_mode_16bit:Set to 1 for 16 bit storage format in DDR.  Only valid when mode_raw = 0
// bit  [6]     cntl_rd_ddr     Set this bit to read if you want AIU_MEM_IEC958_RD_PTR and
//                              AIU_MEM_IEC958_RD_PTR_HIGH to refer to the pointer into DDR memory.
//                              Otherwise, the curr_ptr registers refer to the byte address of the data
//                              at the output of the FIFO to the rest of the IEC958 logic
// bits [5:3]   endian:         see $lib/rtl/ddr_endian.v
// bit  [2]     cntl_empty_en   Set to 1 to enable reading the DDR memory FIFO and filling the pipeline to get-bit
//                              Set cntl_empty_en = cntl_fill_en = 0 when pulsing cntl_init
// bit  [1]     cntl_fill_en    Set to 1 to enable reading data from DDR memory
// bit  [0]     cntl_init:      After setting the read pointers, sizes, channel masks
//                              and read masks, set this bit to 1 and then to 0
#define AIU_MEM_IEC958_CONTROL                     0x1569
// --------------------------------------------
// AIFIFO2 DDR Interface
// --------------------------------------------
// The AIFIFO2 start pointer into DDR memory is a 32-bit number
// The Start pointer will automatically be truncated to land on 
// an 8-byte boundary.  That is, bits [2:0] = 0;
#define AIU_MEM_AIFIFO2_START_PTR                  0x156a
// The current pointer points so some location between the START and END 
// pointers.  The current pointer is a BYTE pointer.  That is, you can 
// point to any BYTE address within the START/END range
#define AIU_MEM_AIFIFO2_CURR_PTR                   0x156b
#define AIU_MEM_AIFIFO2_END_PTR                    0x156c
#define AIU_MEM_AIFIFO2_BYTES_AVAIL                0x156d
// AIFIFO2 FIFO Control
// bit  [15:11] unused
// bit  [10]    use_level       Set this bit to 1 to enable filling of the FIFO controlled by the buffer
//                              level control.  If this bit is 0, then use bit[1] to control the enabling of filling
// bit  [9]     Data Ready.     This bit is set when data can be popped
// bit  [8]     fill busy       This bit will be high when we're fetching data from the DDR memory
//                              To reset this module, set cntl_enable = 0, and then wait for busy = 0. 
//                              After that you can pulse cntl_init to start over
// bit  [7]     cntl_endian_jic Just in case endian.  last minute byte swap of the data out of
//                              the FIFO to getbit
// bit  [6]     unused  
// bits [5:3]   endian:         see $lib/rtl/ddr_endian.v
// bit  [2]     cntl_empty_en   Set to 1 to enable reading the DDR memory FIFO and filling the pipeline to get-bit
//                              Set cntl_empty_en = cntl_fill_en = 0 when pulsing cntl_init
// bit  [1]     cntl_fill_en    Set to 1 to enable reading data from DDR memory
// bit  [0]     cntl_init:      After setting the read pointers, sizes, channel masks
//                              and read masks, set this bit to 1 and then to 0
//                              NOTE:  You don't need to pulse cntl_init if only the start address is
//                              being changed
#define AIU_MEM_AIFIFO2_CONTROL                    0x156e
// --------------------------------------------
// AIFIFO2 Buffer Level Manager
// --------------------------------------------
#define AIU_MEM_AIFIFO2_MAN_WP                     0x156f
#define AIU_MEM_AIFIFO2_MAN_RP                     0x1570
#define AIU_MEM_AIFIFO2_LEVEL                      0x1571
//
// bit  [1]     manual mode     Set to 1 for manual write pointer mode
// bit  [0]     Init            Set high then low after everything has been initialized
#define AIU_MEM_AIFIFO2_BUF_CNTL                   0x1572
// --------------------------------------------
// I2S Buffer Level Manager
// --------------------------------------------
#define AIU_MEM_I2S_MAN_WP                         0x1573
#define AIU_MEM_I2S_MAN_RP                         0x1574
#define AIU_MEM_I2S_LEVEL                          0x1575
//
// bit  [1]     mode            0 = parser (or audin_fifo0 or audin_fifo1), 
//                              1 for manual write pointer 
// bit  [0]     Init            Set high then low after everything has been initialized
#define AIU_MEM_I2S_BUF_CNTL                       0x1576
#define AIU_MEM_I2S_BUF_WRAP_COUNT                 0x1577
// bit 29:24 A_brst_num
// bit 21:16 A_id
// bit 15:0 level_hold 
#define AIU_MEM_I2S_MEM_CTL                        0x1578
//-----------------------------------------------------------------------------
// Additional IEC958 registers (new feature)
//-----------------------------------------------------------------------------
// bit 29:24 A_brst_num
// bit 21:16 A_id
// bit 15:0 level_hold 
#define AIU_MEM_IEC958_MEM_CTL                     0x1579
#define AIU_MEM_IEC958_WRAP_COUNT                  0x157a
#define AIU_MEM_IEC958_IRQ_LEVEL                   0x157b
#define AIU_MEM_IEC958_MAN_WP                      0x157c
#define AIU_MEM_IEC958_MAN_RP                      0x157d
#define AIU_MEM_IEC958_LEVEL                       0x157e
#define AIU_MEM_IEC958_BUF_CNTL                    0x157f
//-----------------------------------------------------------------------------
// add for AIFIFO channel (old $cdrom/rtl/cdr_top/getbit)
//-----------------------------------------------------------------------------
// Bit 3 	CRC pop aififo enable
// Bit 2		writing to this bit to 1 causes CRC module reset
// Bit 1		enable aififo
// Bit 0		writing to this bit to 1 causes aififo soft reset
#define AIU_AIFIFO_CTRL                            0x1580
//'h0000
// AIFIFO status register
// Bit 13		//aififo request to dcu status
// Bit 12		//dcu select status
// Bit 11:5		//aififo word counter number 
// Bit 4:0		//how many bits left in the first pop register
#define AIU_AIFIFO_STATUS                          0x1581
// Same fucntion as the AIGBIT of AIFIFO in CDROM module
// write to this register how many bits wanna pop, 
// and reading this register gets the corresponding bits data
#define AIU_AIFIFO_GBIT                            0x1582
// Same function as the AICLB of AIFIFO in CDROM module
// return the leading zeros by reading this registers
#define AIU_AIFIFO_CLB                             0x1583
// --------------------------------------------
// AIFIFO DDR Interface
// --------------------------------------------
// The AIFIFO start pointer into DDR memory is a 32-bit number
// The Start pointer will automatically be truncated to land on 
// an 8-byte boundary.  That is, bits [2:0] = 0;
#define AIU_MEM_AIFIFO_START_PTR                   0x1584
// The current pointer points so some location between the START and END 
// pointers.  The current pointer is a BYTE pointer.  That is, you can 
// point to any BYTE address within the START/END range
#define AIU_MEM_AIFIFO_CURR_PTR                    0x1585
#define AIU_MEM_AIFIFO_END_PTR                     0x1586
#define AIU_MEM_AIFIFO_BYTES_AVAIL                 0x1587
// AIFIFO FIFO Control
// bit  [15:11] unused
// bit  [10]    use_level       Set this bit to 1 to enable filling of the FIFO controlled by the buffer
//                              level control.  If this bit is 0, then use bit[1] to control the enabling of filling
// bit  [9]     Data Ready.     This bit is set when data can be popped
// bit  [8]     fill busy       This bit will be high when we're fetching data from the DDR memory
//                              To reset this module, set cntl_enable = 0, and then wait for busy = 0. 
//                              After that you can pulse cntl_init to start over
// bit  [7]     cntl_endian_jic Just in case endian.  last minute byte swap of the data out of
//                              the FIFO to getbit
// bit  [6]     unused  
// bits [5:3]   endian:         see $lib/rtl/ddr_endian.v
// bit  [2]     cntl_empty_en   Set to 1 to enable reading the DDR memory FIFO and filling the pipeline to get-bit
//                              Set cntl_empty_en = cntl_fill_en = 0 when pulsing cntl_init
// bit  [1]     cntl_fill_en    Set to 1 to enable reading data from DDR memory
// bit  [0]     cntl_init:      After setting the read pointers, sizes, channel masks
//                              and read masks, set this bit to 1 and then to 0
//                              NOTE:  You don't need to pulse cntl_init if only the start address is
//                              being changed
#define AIU_MEM_AIFIFO_CONTROL                     0x1588
// --------------------------------------------
// AIFIFO Buffer Level Manager
// --------------------------------------------
#define AIU_MEM_AIFIFO_MAN_WP                      0x1589
#define AIU_MEM_AIFIFO_MAN_RP                      0x158a
#define AIU_MEM_AIFIFO_LEVEL                       0x158b
//
// bit  [1]     manual mode     Set to 1 for manual write pointer mode
// bit  [0]     Init            Set high then low after everything has been initialized
#define AIU_MEM_AIFIFO_BUF_CNTL                    0x158c

#define AIU_MEM_RD_PAGE					0x1a49
#define AIU_MEM_RD_PAGE_RP				0x1a4a

#define AIU_MEM_AIFIFO_BUF_WRAP_COUNT              0x158d
#define AIU_MEM_AIFIFO2_BUF_WRAP_COUNT             0x158e
// bit 29:24 A_brst_num
// bit 21:16 A_id
// bit 15:0 level_hold 
#define AIU_MEM_AIFIFO_MEM_CTL                     0x158f
// bit 31:16 -- drop_bytes
// bit 15:14 -- drop_status (Read-Only)
// bit 13:12 -- sync_match_position (Read-Only)
// bit 11:6 -- reserved
// bit 5:4 -- TIME_STAMP_NUMBER, 0-32bits, 1-64bits, 2-96bits, 3-128bits 
// bit 3 -- stamp_soft_reset
// bit 2 -- TIME_STAMP_length_enable
// bit 1 -- TIME_STAMP_sync64_enable
// bit 0 -- TIME_STAMP_enable
#define AIFIFO_TIME_STAMP_CNTL                     0x1590
// bit 31:0 -- TIME_STAMP_SYNC_CODE_0
#define AIFIFO_TIME_STAMP_SYNC_0                   0x1591
// bit 31:0 -- TIME_STAMP_SYNC_CODE_1 
#define AIFIFO_TIME_STAMP_SYNC_1                   0x1592
// bit 31:0 TIME_STAMP_0
#define AIFIFO_TIME_STAMP_0                        0x1593
// bit 31:0 TIME_STAMP_1
#define AIFIFO_TIME_STAMP_1                        0x1594
// bit 31:0 TIME_STAMP_2
#define AIFIFO_TIME_STAMP_2                        0x1595
// bit 31:0 TIME_STAMP_3
#define AIFIFO_TIME_STAMP_3                        0x1596
// bit 31:0 TIME_STAMP_LENGTH
#define AIFIFO_TIME_STAMP_LENGTH                   0x1597
// bit 31:16 -- drop_bytes
// bit 15:14 -- drop_status (Read-Only)
// bit 13:12 -- sync_match_position (Read-Only)
// bit 11:6 -- reserved
// bit 5:4 -- TIME_STAMP_NUMBER, 0-32bits, 1-64bits, 2-96bits, 3-128bits 
// bit 3 -- stamp_soft_reset
// bit 2 -- TIME_STAMP_length_enable
// bit 1 -- TIME_STAMP_sync64_enable
// bit 0 -- TIME_STAMP_enable
#define AIFIFO2_TIME_STAMP_CNTL                    0x1598
// bit 31:0 -- TIME_STAMP_SYNC_CODE_0
#define AIFIFO2_TIME_STAMP_SYNC_0                  0x1599
// bit 31:0 -- TIME_STAMP_SYNC_CODE_1 
#define AIFIFO2_TIME_STAMP_SYNC_1                  0x159a
// bit 31:0 TIME_STAMP_0
#define AIFIFO2_TIME_STAMP_0                       0x159b
// bit 31:0 TIME_STAMP_1
#define AIFIFO2_TIME_STAMP_1                       0x159c
// bit 31:0 TIME_STAMP_2
#define AIFIFO2_TIME_STAMP_2                       0x159d
// bit 31:0 TIME_STAMP_3
#define AIFIFO2_TIME_STAMP_3                       0x159e
// bit 31:0 TIME_STAMP_LENGTH
#define AIFIFO2_TIME_STAMP_LENGTH                  0x159f
// bit 31:16 -- drop_bytes
// bit 15:14 -- drop_status (Read-Only)
// bit 13:12 -- sync_match_position (Read-Only)
// bit 11:6 -- reserved
// bit 5:4 -- TIME_STAMP_NUMBER, 0-32bits, 1-64bits, 2-96bits, 3-128bits 
// bit 3 -- stamp_soft_reset
// bit 2 -- TIME_STAMP_length_enable
// bit 1 -- TIME_STAMP_sync64_enable
// bit 0 -- TIME_STAMP_enable
#define IEC958_TIME_STAMP_CNTL                     0x15a0
// bit 31:0 -- TIME_STAMP_SYNC_CODE_0
#define IEC958_TIME_STAMP_SYNC_0                   0x15a1
// bit 31:0 -- TIME_STAMP_SYNC_CODE_1 
#define IEC958_TIME_STAMP_SYNC_1                   0x15a2
// bit 31:0 TIME_STAMP_0
#define IEC958_TIME_STAMP_0                        0x15a3
// bit 31:0 TIME_STAMP_1
#define IEC958_TIME_STAMP_1                        0x15a4
// bit 31:0 TIME_STAMP_2
#define IEC958_TIME_STAMP_2                        0x15a5
// bit 31:0 TIME_STAMP_3
#define IEC958_TIME_STAMP_3                        0x15a6
// bit 31:0 TIME_STAMP_LENGTH
#define IEC958_TIME_STAMP_LENGTH                   0x15a7
// bit 29:24 A_brst_num
// bit 21:16 A_id
// bit 15:0 level_hold 
#define AIU_MEM_AIFIFO2_MEM_CTL                    0x15a8
//
// Closing file:  aregs.h
//
//========================================================================
//  CDROM Interface                                 (12'h600 - 12'h6ff)
//
//========================================================================
#define AIADR                                      0x1738
#define AICSR                                      0x1739
#define AIDAT                                      0x173a
#define AIGBIT                                     0x173b
#define AICLB                                      0x173c
//========================================================================
// SDIO interface
//========================================================================
#define HD0                                        0x1780
#define HD1                                        0x1781
#define SHD0                                       0x1782
#define SHD1                                       0x1783
#define SYND                                       0x1784
#define ECDCT                                      0x1785
#define ECDSTAT                                    0x1786
#define CTR0                                       0x1787
#define CTR1                                       0x1788
#define CTR2                                       0x1789
#define STAT0                                      0x178a
#define INT                                        0x178b
#define TCTR0                                      0x178c
#define TSTAT0                                     0x178d
#define TSTAT1                                     0x178e
//========================================================================
//	registers for video postprocessing (12'h800 - 12'h87f)
//========================================================================
//
// Reading file:  vpp_regs.h
//
// synopsys translate_off
// synopsys translate_on
// -----------------------------------------------
// CBUS_BASE:  VPP_CBUS_BASE = 0x1d
// -----------------------------------------------
//===========================================================================
// Video postprocesing Registers 
//===========================================================================
// dummy data used in the VPP preblend and scaler
// Bit 23:16    Y
// Bit 15:8     CB
// Bit 7:0      CR 
#define VPP_DUMMY_DATA                             0x1d00
    #define VPP_DUMMY_MASK              0xff
    #define VPP_DUMMY_Y_BIT             16
    #define VPP_DUMMY_Cb_BIT            8
    #define VPP_DUMMY_Cr_BIT            0
//input line length used in VPP
#define VPP_LINE_IN_LENGTH                         0x1d01
//input Picture height used in VPP
#define VPP_PIC_IN_HEIGHT                          0x1d02
//Because there are many coefficients used in the vertical filter and horizontal filters,
//indirect access the coefficients of vertical filter and horizontal filter is used.
//For vertical filter, there are 33x4 coefficients 
//For horizontal filter, there are 33x4 coefficients
//Bit 15	index increment, if bit9 == 1  then (0: index increase 1, 1: index increase 2) else (index increase 2)	
//Bit 14	1: read coef through cbus enable, just for debug purpose in case when we wanna check the coef in ram in correct or not
//Bit 9     if true, use 9bit resolution coef, other use 8bit resolution coef
//Bit 8	    type of index, 0: vertical coef
//						   1: horizontal coef
//Bit 6:0 	coef index
#define VPP_SCALE_COEF_IDX                         0x1d03
    #define VPP_COEF_IDXINC         (1 << 15)
    #define VPP_COEF_RD_CBUS        (1 << 14)
    #define VPP_COEF_9BIT           (1 << 9)
    #define VPP_COEF_TYPE           (1 << 8)
    #define VPP_COEF_VERT           (0 << 8)
    #define VPP_COEF_HORZ           (1 << 8)
    #define VPP_COEF_INDEX_MASK     0x7f
    #define VPP_COEF_INDEX_BIT      0
//coefficients for vertical filter and horizontal filter
#define VPP_SCALE_COEF                             0x1d04
//these following registers are the absolute line address pointer for output divided screen
//The output divided screen is shown in the following:
//
//  --------------------------   <------ line zero
//		. 
//		.
//		.		    region0        <---------- nonlinear region or nonscaling region	
//		.
//  ---------------------------  
//  ---------------------------  <------ region1_startp 
//		.
//		.           region1         <---------- nonlinear region
//		.
//		.
//  ---------------------------  
//  ---------------------------  <------ region2_startp
//		.
//		.           region2         <---------- linear region
//		.
//		.
//  ---------------------------  
//  ---------------------------  <------ region3_startp
//		.
//		.           region3         <---------- nonlinear region
//		.
//		.
//  ---------------------------  
//  ---------------------------  <------ region4_startp
//		.
//		.           region4         <---------- nonlinear region or nonoscaling region
//		.
//		.
//  ---------------------------  <------ region4_endp
//Bit 27:16 region1 startp
//Bit 11:0 region2 startp
#define VPP_VSC_REGION12_STARTP                    0x1d05
    #define VPP_REGION_MASK             0xfff
    #define VPP_REGION1_BIT             16
    #define VPP_REGION2_BIT             0
//Bit 27:16 region3 startp
//Bit 11:0 region4 startp
#define VPP_VSC_REGION34_STARTP                    0x1d06
    #define VPP_REGION3_BIT             16
    #define VPP_REGION4_BIT             0
#define VPP_VSC_REGION4_ENDP                       0x1d07
//vertical start phase step, (source/dest)*(2^24)
//Bit 27:24 integer part 
//Bit 23:0	fraction part
#define VPP_VSC_START_PHASE_STEP                   0x1d08
//vertical scaler region0 phase slope, Bit24 signed bit
#define VPP_VSC_REGION0_PHASE_SLOPE                0x1d09
//vertical scaler region1 phase slope, Bit24 signed bit
#define VPP_VSC_REGION1_PHASE_SLOPE                0x1d0a
//vertical scaler region3 phase slope, Bit24 signed bit
#define VPP_VSC_REGION3_PHASE_SLOPE                0x1d0b
//vertical scaler region4 phase slope, Bit24 signed bit
#define VPP_VSC_REGION4_PHASE_SLOPE                0x1d0c
//Bit 16     0: progressive output, 1: interlace output
//Bit 15     vertical scaler output line0 in advance or not for bottom field
//Bit 14:13  vertical scaler initial repeat line0 number for bottom field
//Bit 11:8   vertical scaler initial receiving  number for bottom field   
//Bit 7      vertical scaler output line0 in advance or not for top field
//Bit 6:5    vertical scaler initial repeat line0 number for top field
//Bit 3:0    vertical scaler initial receiving  number for top field   
#define VPP_VSC_PHASE_CTRL                         0x1d0d
    #define VPP_PHASECTL_TYPE           (1<<16)
    #define VPP_PHASECTL_TYPE_PROG      (0<<16)
    #define VPP_PHASECTL_TYPE_INTERLACE (1<<16)
    #define VPP_PHASECTL_VSL0B          (1<<15)
    #define VPP_PHASECTL_INIRPTNUM_MASK 0x3
    #define VPP_PHASECTL_INIRPTNUM_WID  2
    #define VPP_PHASECTL_INIRPTNUMB_BIT 13
    #define VPP_PHASECTL_INIRCVNUM_MASK 0xf
    #define VPP_PHASECTL_INIRCVNUM_WID  5
    #define VPP_PHASECTL_INIRCVNUMB_BIT 8
    #define VPP_PHASECTL_VSL0T          (1<<7)
    #define VPP_PHASECTL_INIRPTNUMT_BIT 5
    #define VPP_PHASECTL_INIRCVNUMT_BIT 0
//Bit 31:16  vertical scaler field initial phase for bottom field
//Bit 15:0  vertical scaler field initial phase for top field
#define VPP_VSC_INI_PHASE                          0x1d0e
    #define VPP_VSC_PHASE_MASK          0xffff
    #define VPP_VSC_PHASEB_BIT          16
    #define VPP_VSC_PHASET_BIT          0
//Bit 27:16 region1 startp
//Bit 11:0 region2 startp
#define VPP_HSC_REGION12_STARTP                    0x1d10
    #define VPP_HSC_RGN_MASK            0xfff
    #define VPP_HSC_RGN1_BIT            16
    #define VPP_HSC_RGN2_BIT            0
//Bit 27:16 region3 startp
//Bit 11:0 region4 startp
#define VPP_HSC_REGION34_STARTP                    0x1d11
    #define VPP_HSC_RGN3_BIT            16
    #define VPP_HSC_RGN4_BIT            0
#define VPP_HSC_REGION4_ENDP                       0x1d12
//horizontal start phase step, (source/dest)*(2^24)
//Bit 27:24 integer part 
//Bit 23:0	fraction part
#define VPP_HSC_START_PHASE_STEP                   0x1d13
//horizontal scaler region0 phase slope, Bit24 signed bit
#define VPP_HSC_REGION0_PHASE_SLOPE                0x1d14
//horizontal scaler region1 phase slope, Bit24 signed bit
#define VPP_HSC_REGION1_PHASE_SLOPE                0x1d15
//horizontal scaler region3 phase slope, Bit24 signed bit
#define VPP_HSC_REGION3_PHASE_SLOPE                0x1d16
//horizontal scaler region4 phase slope, Bit24 signed bit
#define VPP_HSC_REGION4_PHASE_SLOPE                0x1d17
//Bit 22:21   horizontal scaler initial repeat pixel0 number
//Bit 19:16   horizontal scaler initial receiving number   
//Bit 15:0    horizontal scaler top field initial phase
#define VPP_HSC_PHASE_CTRL                         0x1d18
    #define VPP_HSC_INIRPT_NUM_MASK     0x3
    #define VPP_HSC_INIRPT_NUM_BIT      21
    #define VPP_HSC_INIRCV_NUM_MASK     0xf
    #define VPP_HSC_INIRCV_NUM_BIT      16
    #define VPP_HSC_TOP_INI_PHASE_WID   16
    #define VPP_HSC_TOP_INI_PHASE_BIT   0
// Bit 20 prehsc_en
// Bit 19 prevsc_en
// Bit 18 vsc_en
// Bit 17 hsc_en
// Bit 16 scale_top_en
// Bit 15 video1 scale out enable
// Bit 12 if true, region0,region4 are nonlinear regions, otherwise they are not scaling regions, for horizontal scaler 
// Bit 10:8 horizontal scaler bank length
// Bit 5, vertical scaler phase field mode, if true, disable the opposite parity line output, more bandwith needed if output 1080i
// Bit 4 if true, region0,region4 are nonlinear regions, otherwise they are not scaling regions, for vertical scaler 
// Bit 2:0 vertical scaler bank length
#define VPP_SC_MISC                                0x1d19
    #define VPP_SC_PREHORZ_EN           (1 << 20)
    #define VPP_SC_PREVERT_EN           (1 << 19)
    #define VPP_SC_VERT_EN              (1 << 18)
    #define VPP_SC_HORZ_EN              (1 << 17)
    #define VPP_SC_TOP_EN               (1 << 16)
    #define VPP_SC_V1OUT_EN             (1 << 15)
    #define VPP_SC_RGN14_HNOLINEAR      (1 << 12)
    #define VPP_SC_BANK_LENGTH_WID      3
    #define VPP_SC_BANK_LENGTH_MASK     0x7
    #define VPP_SC_HBANK_LENGTH_BIT     8
    #define VPP_SC_RGN14_VNOLINEAR      (1 << 4)
    #define VPP_SC_VBANK_LENGTH_BIT     0
// preblend video1 horizontal start and end
//Bit 27:16 start
//Bit 11:0 end
#define VPP_PREBLEND_VD1_H_START_END               0x1d1a
// preblend video1 vertical start and end
//Bit 27:16 start
//Bit 11:0 end
#define VPP_PREBLEND_VD1_V_START_END               0x1d1b
// postblend video1 horizontal start and end
//Bit 27:16 start
//Bit 11:0 end
#define VPP_POSTBLEND_VD1_H_START_END              0x1d1c
// postblend video1 vertical start and end
//Bit 27:16 start
//Bit 11:0 end
#define VPP_POSTBLEND_VD1_V_START_END              0x1d1d
// preblend/postblend video2 horizontal start and end
//Bit 27:16 start
//Bit 11:0 end
#define VPP_BLEND_VD2_H_START_END                  0x1d1e
// preblend/postblend video2 vertical start and end
//Bit 27:16 start
//Bit 11:0 end
#define VPP_BLEND_VD2_V_START_END                  0x1d1f
    #define VPP_VD_SIZE_MASK            0xfff
    #define VPP_VD1_START_BIT           16
    #define VPP_VD1_END_BIT             0
// preblend horizontal size
#define VPP_PREBLEND_H_SIZE                        0x1d20
// postblend horizontal size
#define VPP_POSTBLEND_H_SIZE                       0x1d21
//VPP hold lines
//Bit 29:24
//Bit 21:16
//Bit 13:8     preblend hold lines
//Bit 5:0      postblend hold lines
#define VPP_HOLD_LINES                             0x1d22
//Bit 25   if true, change screen to one color value for preblender
//Bit 24   if true, change screen to one color value for postblender
// Bit 23:16 one color Y
// Bit 15:8 one color Cb
// Bit  7:0 one color  Cr
#define VPP_BLEND_ONECOLOR_CTRL                    0x1d23
    #define VPP_PREBLEND_1COLOR         (1 << 25)
    #define VPP_POSTBLEND_1COLOR        (1 << 24)
    #define VPP_1COLOR_MASK             0xff
    #define VPP_1COLOR_Y_BIT            16
    #define VPP_1COLOR_CB_BIT           8
    #define VPP_1COLOR_CR_BIT           0
//Read Only, VPP preblend current_x, current_y
//Bit 27:16 current_x
//Bit 11:0 current_y
#define VPP_PREBLEND_CURRENT_XY                    0x1d24
    #define VPP_CURXY_MASK              0xfff
    #define VPP_PREBLEND_CURX_BIT       16    
    #define VPP_PREBLEND_CURY_BIT       0 
//Read Only, VPP postblend current_x, current_y
//Bit 27:16 current_x
//Bit 11:0 current_y
#define VPP_POSTBLEND_CURRENT_XY                   0x1d25
// bit 28   color management enable
// Bit 26:18, vd2 alpha
// Bit 17, osd2 enable for preblend
// Bit 16, osd1 enable for preblend
// Bit 15, vd2 enable for preblend
// Bit 14, vd1 enable for preblend
// Bit 13, osd2 enable for postblend
// Bit 12, osd1 enable for postblend
// Bit 11, vd2 enable for postblend
// Bit 10, vd1 enable for postblend
// Bit 9,  if true, osd1 is alpha premultipiled 
// Bit 8,  if true, osd2 is alpha premultipiled 
// Bit 7,  postblend module enable
// Bit 6,  preblend module enable
// Bit 5,  if true, osd2 foreground compared with osd1 in preblend
// Bit 4,  if true, osd2 foreground compared with osd1 in postblend
// Bit 3,  
// Bit 2,  if true, disable resetting async fifo every vsync, otherwise every vsync
//			 the aync fifo will be reseted.
// Bit 1,	  
// Bit 0	if true, the output result of VPP is saturated
#define VPP_MISC                                   0x1d26
    #define VPP_VD2_ALPHA_WID           9
    #define VPP_VD2_ALPHA_MASK          0x1ff
    #define VPP_VD2_ALPHA_BIT           18
    #define VPP_OSD2_PREBLEND           (1 << 17)
    #define VPP_OSD1_PREBLEND           (1 << 16)
    #define VPP_VD2_PREBLEND            (1 << 15)
    #define VPP_VD1_PREBLEND            (1 << 14)
    #define VPP_OSD2_POSTBLEND          (1 << 13)
    #define VPP_OSD1_POSTBLEND          (1 << 12)
    #define VPP_VD2_POSTBLEND           (1 << 11)
    #define VPP_VD1_POSTBLEND           (1 << 10)
    #define VPP_OSD1_ALPHA              (1 << 9)
    #define VPP_OSD2_ALPHA              (1 << 8)
    #define VPP_POSTBLEND_EN            (1 << 7)
    #define VPP_PREBLEND_EN             (1 << 6)
    #define VPP_PRE_FG_SEL_MASK         (1 << 5)
    #define VPP_PRE_FG_OSD2             (1 << 5)
    #define VPP_PRE_FG_OSD1             (0 << 5)
    #define VPP_POST_FG_SEL_MASK        (1 << 4)
    #define VPP_POST_FG_OSD2            (1 << 4)
    #define VPP_POST_FG_OSD1            (0 << 4)
    #define VPP_FIFO_RESET_DE           (1 << 2)
    #define VPP_OUT_SATURATE            (1 << 0)
//Bit 31:20 ofifo line length minus 1
//Bit 19  if true invert input vs
//Bit 18  if true invert input hs
//Bit 17  force top/bottom field, enable
//Bit 16  force top/bottom field, 0: top, 1: bottom
//Bit 15  force one go_field, one pluse, write only
//Bit 14  force one go_line, one pluse, write only
//Bit 11:0 ofifo size (actually only bit 9:1 is valid), always even number
#define VPP_OFIFO_SIZE                             0x1d27
    #define VPP_OFIFO_LINELEN_MASK      0xfff
    #define VPP_OFIFO_LINELEN_BIT       20
    #define VPP_INV_VS                  (1 << 19)
    #define VPP_INV_HS                  (1 << 18)
    #define VPP_FORCE_FIELD_EN          (1 << 17)
    #define VPP_FORCE_FIELD_TYPE_MASK   (1 << 16)
    #define VPP_FORCE_FIELD_TOP         (0 << 16)
    #define VPP_FORCE_FIELD_BOTTOM      (1 << 16)
    #define VPP_FOURCE_GO_FIELD         (1 << 15)
    #define VPP_FOURCE_GO_LINE          (1 << 14)
    #define VPP_OFIFO_SIZE_WID          12
    #define VPP_OFIFO_SIZE_MASK         0xfff
    #define VPP_OFIFO_SIZE_BIT          0
//Read only
//Bit 26:17 current scale out fifo counter
//Bit 16:12 current afifo counter
//Bit 11:0 current ofifo counter
#define VPP_FIFO_STATUS                            0x1d28
    #define VPP_SOFIFO_CNT_MASK         0x3ff
    #define VPP_SOFIFO_CNT_BIT          17
    #define VPP_AFIFO_CNT_MASK          0x1ff
    #define VPP_AFIFO_CNT_BIT           12
    #define VPP_OFIFO_CNT_MASK          0xfff
    #define VPP_OFIFO_CNT_BIT           0
// Bit 5 SMOKE3 postblend enable only when postblend vd2 is not enable 
// Bit 4 SMOKE3 preblend enable only when preblend vd2 is not enable 
// Bit 3 SMOKE2 postblend enable only when postblend osd2 is not enable 
// Bit 2 SMOKE2 preblend enable only when preblend osd2 is not enable 
// Bit 1 SMOKE1 postblend enable only when postblend osd1 is not enable 
// Bit 0 SMOKE1 preblend enable only when preblend osd1 is not enable 
#define VPP_SMOKE_CTRL                             0x1d29
    #define VPP_POSTSMOKE3EN_POSTVD2DE  (1 << 5)
    #define VPP_PRESMOKE3EN_PREVD2DE    (1 << 4)
    #define VPP_POSTSMOKE2EN_POSTVD2DE  (1 << 3)
    #define VPP_PRESMOKE2EN_PREVD2DE    (1 << 2)
    #define VPP_POSTSMOKE1EN_POSTVD2DE  (1 << 1)
    #define VPP_PRESMOKE1EN_PREVD2DE    (1 << 0)
//smoke can be used only when that blending is disable and then be used as smoke function
//smoke1 for OSD1 chanel
//smoke2 for OSD2 chanel
//smoke3 for VD2 chanel
//31:24 Y
//23:16 Cb
//15:8 Cr
//7:0 Alpha
#define VPP_SMOKE1_VAL                             0x1d2a
#define VPP_SMOKE2_VAL                             0x1d2b
#define VPP_SMOKE3_VAL                             0x1d2c
    #define VPP_SMOKE_VAL_MASK          0xff
    #define VPP_SMOKE_Y_BIT             24
    #define VPP_SMOKE_CB_BIT            16
    #define VPP_SMOKE_CR_BIT            8
    #define VPP_SMOKE_ALPHA_BIT         0
//Bit 27:16 start
//Bit 11:0 end
#define VPP_SMOKE1_H_START_END                     0x1d2d
//Bit 27:16 start
//Bit 11:0 end
#define VPP_SMOKE1_V_START_END                     0x1d2e
//Bit 27:16 start
//Bit 11:0 end
#define VPP_SMOKE2_H_START_END                     0x1d2f
//Bit 27:16 start
//Bit 11:0 end
#define VPP_SMOKE2_V_START_END                     0x1d30
//Bit 27:16 start
//Bit 11:0 end
#define VPP_SMOKE3_H_START_END                     0x1d31
//Bit 27:16 start
//Bit 11:0 end
#define VPP_SMOKE3_V_START_END                     0x1d32
    #define VPP_SMOKE_SE_MASK           0xfff
    #define VPP_SMOKE_START_BIT         16
    #define VPP_SMOKE_END_BIT           0
//Bit 27:16 scale out fifo line length minus 1
//Bit 9:0 scale out fifo size (actually only bit 9:1 is valid), always even number
#define VPP_SCO_FIFO_CTRL                          0x1d33
    #define VPP_SCO_FIFO_LEN_MASK       0xfff
    #define VPP_SCO_FIFO_LEN_BIT        16
    #define VPP_SCO_FIFO_SIZE_MASK      0x3ff
    #define VPP_SCO_FIFO_SIZE_BIT       0
//Bit 3			minus black level enable for vadj2
//Bit 2			Video adjustment enable for vadj2
//Bit 1			minus black level enable for vadj1
//Bit 0			Video adjustment enable for vadj1
#define VPP_VADJ_CTRL                              0x1d40
    #define VPP_VADJ2_BLMINUS_EN        (1 << 3)
    #define VPP_VADJ2_EN                (1 << 2)
    #define VPP_VADJ1_BLMINUS_EN        (1 << 1)
    #define VPP_VADJ1_EN                (1 << 0)
//Bit 16:8  brightness, signed value
//Bit 7:0	contrast, unsigned value, contrast from  0 <= contrast <2
#define VPP_VADJ1_Y                                0x1d41
    #define VPP_VADJ_COEF_MASK          0xff
    #define VPP_VADJ_BR_BIT             8
    #define VPP_VADJ_CT_BIT             0
//cb' = cb*ma + cr*mb
//cr' = cb*mc + cr*md
//all are bit 9:0, signed value, -2 < ma/mb/mc/md < 2
#define VPP_VADJ1_MA_MB                            0x1d42
    #define VPP_VADJ_MA_BIT             16
    #define VPP_VADJ_MB_BIT             0
#define VPP_VADJ1_MC_MD                            0x1d43
    #define VPP_VADJ_MC_BIT             16
    #define VPP_VADJ_MD_BIT             0
//Bit 16:8  brightness, signed value
//Bit 7:0	contrast, unsigned value, contrast from  0 <= contrast <2
#define VPP_VADJ2_Y                                0x1d44
//cb' = cb*ma + cr*mb
//cr' = cb*mc + cr*md
//all are bit 9:0, signed value, -2 < ma/mb/mc/md < 2
#define VPP_VADJ2_MA_MB                            0x1d45
#define VPP_VADJ2_MC_MD                            0x1d46
//Bit 2 horizontal chroma sharp/blur selection, 0:sharp, 1: blur  
//Bit 1 horizontal luma sharp/blur selection, 0:sharp, 1: blur  
//Bit 0 horizontal sharpness enable
#define VPP_HSHARP_CTRL                            0x1d50
    #define VPP_CHROMA_HSHARP_SB_SEL    (1 << 2)
    #define VPP_CHROMA_HSHARP_SHARP     (0 << 2)
    #define VPP_CHROMA_HSHARP_BLUR      (1 << 2)
    #define VPP_LUMA_HSHARP_SB_SEL      (1 << 1)
    #define VPP_LUMA_HSHARP_SHARP       (0 << 1)
    #define VPP_LUMA_HSHARP_BLUR        (1 << 1)
    #define VPP_HSHARP_EN               (1 << 0)
//{1'b0,threhsold} < diff
//Bit 26:16  luma threshold0
//Bit 10:0   luma threshold1    
#define VPP_HSHARP_LUMA_THRESH01                   0x1d51
    #define VPP_HSHARP_THRESH_MASK      0x7ff
    #define VPP_HSHARP_THRESH0_BIT      16
    #define VPP_HSHARP_THRESH1_BIT      0
//
//Bit 26:16  luma threshold2
//Bit 10:0   luma threshold3    
#define VPP_HSHARP_LUMA_THRESH23                   0x1d52
    #define VPP_HSHARP_THRESH2_BIT      16
    #define VPP_HSHARP_THRESH3_BIT      0
//Bit 26:16  chroma threshold0
//Bit 10:0   chroma threshold1    
#define VPP_HSHARP_CHROMA_THRESH01                 0x1d53
//Bit 26:16  chroma threshold2
//Bit 10:0   chroma threshold3    
#define VPP_HSHARP_CHROMA_THRESH23                 0x1d54
//Bit 23:16 luma gain2
//Bit 15:8  luma gain1
//Bit 7:0   luma gain0
#define VPP_HSHARP_LUMA_GAIN                       0x1d55
//
//Bit 23:16 chroma gain2
//Bit 15:8  chroma gain1
//Bit 7:0   chroma gain0
#define VPP_HSHARP_CHROMA_GAIN                     0x1d56
    #define VPP_GAIN_MASK               0xff
    #define VPP_GAIN2_BIT               16
    #define VPP_GAIN1_BIT               8
    #define VPP_GAIN0_BIT               0
//Bit 9:8  matrix coef idx selection, 00: select post matrix, 01: select vd1 matrix, 10: select vd2 matrix
//Bit 5    vd1 conversion matrix enable
//Bit 4    vd2 conversion matrix enable
//Bit 2    output y/cb/cr saturation enable, only for post matrix (y saturate to 16-235, cb/cr saturate to 16-240)
//Bit 1    input y/cb/cr saturation enable, only for post matrix (y saturate to 16-235, cb/cr saturate to 16-240)
//Bit 0    post conversion matrix enable
#define VPP_MATRIX_CTRL                            0x1d5f
    #define VPP_MAT_SEL_MASK            (3 << 8)
    #define VPP_MAT_SEL_BIT             8
	#define VPP_MAT_VD0_MAT_EN          (1 << 5)
	#define VPP_MAT_VD1_MAT_EN          (1 << 4)
	#define VPP_MAT_OUTSAT_EN_BIT       (1 << 2)
	#define VPP_MAT_INSAT_EN_BIT        (1 << 1)
    #define VPP_MAT_EN                  (1 << 0)
//Bit 28:16 coef00
//Bit 12:0  coef01
#define VPP_MATRIX_COEF00_01                       0x1d60
    #define VPP_MAT_COEF_MASK           0xfff
    #define VPP_MAT_COEF00_BIT          16
    #define VPP_MAT_COEF01_BIT          0
//Bit 28:16 coef02 
//Bit 12:0  coef10 
#define VPP_MATRIX_COEF02_10                       0x1d61
    #define VPP_MAT_COEF02_BIT          16
    #define VPP_MAT_COEF10_BIT          0
//Bit 28:16 coef11
//Bit 12:0  coef12
#define VPP_MATRIX_COEF11_12                       0x1d62
    #define VPP_MAT_COEF11_BIT          16
    #define VPP_MAT_COEF12_BIT          0
//Bit 28:16 coef20
//Bit 12:0  coef21
#define VPP_MATRIX_COEF20_21                       0x1d63
    #define VPP_MAT_COEF20_BIT          16
    #define VPP_MAT_COEF21_BIT          0
#define VPP_MATRIX_COEF22                          0x1d64
//Bit 26:16 offset0
//Bit 10:0  offset1
#define VPP_MATRIX_OFFSET0_1                       0x1d65
    #define VPP_MAT_OFFSET_MASK         0x7ff
    #define VPP_MAT_OFFSET0_BIT         16
    #define VPP_MAT_OFFSET1_BIT         0
//Bit 10:0  offset2
#define VPP_MATRIX_OFFSET2                         0x1d66
//Bit 26:16 pre_offset0
//Bit 10:0  pre_offset1
#define VPP_MATRIX_PRE_OFFSET0_1                   0x1d67
//Bit 10:0  pre_offset2
#define VPP_MATRIX_PRE_OFFSET2                     0x1d68
// dummy data used in the VPP postblend
// Bit 23:16    Y
// Bit 15:8     CB
// Bit 7:0      CR 
#define VPP_DUMMY_DATA1                            0x1d69
//Bit 31 gainoff module enable
//Bit 26:16 gain0, 1.10 unsigned data
//Bit 10:0  gain1, 1.10 unsigned dat
#define VPP_GAINOFF_CTRL0                          0x1d6a
//Bit 26:16 gain2, 1.10 unsigned data
//Bit 10:0, offset0, signed data
#define VPP_GAINOFF_CTRL1                          0x1d6b
//Bit 26:16, offset1, signed data
//Bit 10:0, offset2, signed data
#define VPP_GAINOFF_CTRL2                          0x1d6c
//Bit 26:16, pre_offset0, signed data 
//Bit 10:0, pre_offset1, signed data 
#define VPP_GAINOFF_CTRL3                          0x1d6d
//Bit 10:0, pre_offset2, signed data 
#define VPP_GAINOFF_CTRL4                          0x1d6e
//only two registers used in the color management, which are defined in the chroma_reg.h
//`define VPP_CHROMA_ADDR_PORT    8'h70
//`define VPP_CHROMA_DATA_PORT    8'h71
//
// Reading file:  chroma_reg.h
//
//**********************************************************************************
//* Copyright (c) 2008, AMLOGIC Inc.
//* All rights reserved
//**********************************************************************************
//* File :  chroma_reg.v
//* Author : Terrence Wang
//* Date : Dec 2008
//* Description :  
//*
//********************************************************************************** 
//* Modification History:
//* Date    Modified By         Reason
//**********************************************************************************
// synopsys translate_off
// synopsys translate_on
#define VPP_CHROMA_ADDR_PORT                       0x1d70
#define VPP_CHROMA_DATA_PORT                       0x1d71
//`define CHROMA_ADDR_PORT        8'h67
//`define CHROMA_DATA_PORT        8'h68

//  CHROMA_GAIN_REG_XX(00-07)
//  hue gain, sat gain function control
//  Bit 31      reg_sat_en                  enable sat adjustment in current region
//  Bit 27      reg_sat_increase            sat adjustment increase or decrease
//                                          1'b1: increase  1'b0: decrease
//  Bit 26:25   reg_sat_central_en          sat adjustment with central biggest or one side biggest
//                                          2'b01 central biggest   2'b00 one side biggest
//  Bit 24      reg_sat_shape               when sat adjustment one side biggest, define left or right
//                                          1'b1: left side biggest 1'b0 right side biggest  
//  Bit 23:16   reg_sat_gain                define the sat gain when sat adjustment
//                                          0x00-0xff
//  Bit 15      reg_hue_en                  enable hue adjustment in current region
//  Bit 11      reg_hue_clockwise           hue adjustment clockwise or anti-clockwise
//                                          1'b1: clockwise 1'b0: anti-clockwise
//  Bit 10:9    reg_hue_central_en          when hue adjustment, parabola curve or non-symmetry curve
//                                          1'b1: parabola curve    1'b0: non-symmetry curve
//  Bit 8       reg_hue_shape               when non-symmetry curve, define which side change more
//                                          1'b1: right side change more    1'b0: left side change more
//  Bit 7:0     reg_hue_gain                define the hue gain when hue adjustment
//                                          0x00-0x80, note: should be no bigger than 0x80

    #define CHROMA_GAIN_REG00       0x00


//  HUE_HUE_RANGE_REG_XX(00-07)
//  hue range select
//  Bit 31:24   no use now
//  Bit 23:16   reg_hue_shift_range         define the angle of target region
//                                          0x00-0xff,(0x100 means 120 degree though it can not be set)
//                                          must be greater or equal than 8'd8
//  Bit 15      reg_symmetry_en             this is used for create one symmetry region
//                                          the symmetry region hue_shift_start = reg_hue_hue_shift_start + reg_hue_shift_range<<5
//                                          the symmetry region hue_shift_range = reg_hue_shift_range
//                                          in symmetry region, all the sat and hue setting will be same with original region, 
//                                          except reg_hue_shape, reg_sat_shape, reg_hue_clockwise will be reversed
//  Bit 14:0    reg_hue_hue_shift_start     define the start angle of target region
//                                          0x6000 means 360 degree
//                                          only region 0 and 1 can exceed 360 degrees.

    #define HUE_HUE_RANGE_REG00     0x01


//  HUE_RANGE_INV_REG_XX
//  Calculation should be follow
//  HUE_RANGE_INV_REG0X[15:0] = ((1<<20)/HUE_HUE_RANGE_REG0X[23:16]+1)>>1
//  HUE_RANGE_INV_REG_XX is to used to save divider

    #define HUE_RANGE_INV_REG00     0x02



//  for belowing each low, high, low_slope, high_slope group:
//            a_____________b
//            /             \               a = low  + 2^low_slope
//           /               \              b = high - 2^high_slope
//          /                 \             low_slope <= 7; high_slope <= 7
//         /                   \            b >= a
//  ______/_____________________\________
//       low                    high
//
//
//  HUE_LUM_RANGE_REG_XX(00-07)
//  luma range selection for hue adjustment
//  Bit 31:24   reg_sat_lum_low             define the low level of luma value for sat adjustment
//                                          0x00-0xff
//  Bit 23:20   reg_hue_lum_high_slope      define the slope area below high level of luma value for hue adjustment
//                                          0x00-0x07
//  Bit 19:16   reg_hue_lum_low_slope       define the slope area above low  level of luma value for hue adjustment
//                                          0x00-0x07
//  Bit 15:8    reg_hue_lum_high            define the high level of luma value for hue adjustment
//                                          0x00-0xff
//  Bit 7:0     reg_hue_lum_low             define the low  level of luma value for hue adjustment
//                                          0x00-0xff

    #define HUE_LUM_RANGE_REG00     0x03

//  HUE_SAT_RANGE_REG_XX(00-07)
//  sat range selection for hue adjustment
//  Bit 31:24   reg_sat_lum_high            define the high level of luma value for sat adjustment
//                                          0x00-0xff
//  Bit 23:20   reg_hue_sat_high_slope      define the slope area below high level of sat value for hue adjustment
//                                          0x00-0x07
//  Bit 19:16   reg_hue_sat_low_slope       define the slope area above low  level of sat value for hue adjustment
//                                          0x00-0x07
//  Bit 15:8    reg_hue_sat_high            define the high level of sat value for hue adjustment
//                                          0x00-0xff
//  Bit 7:0     reg_hue_sat_low             define the low  level of sat value for hue adjustment
//                                          0x00-0xff

    #define HUE_SAT_RANGE_REG00     0x04

//  SAT_SAT_RANGE_REG_XX(00-07)
//  sat range selection for hue adjustment
//  Bit 31:28   reg_sat_lum_high_slope      define the slope area below high level of luma value for sat adjustment
//                                          0x00-0x07
//  Bit 27:24   reg_sat_lum_low_slope       define the slope area above low  level of luma value for sat adjustment
//                                          0x00-0x07
//  Bit 23:20   reg_sat_sat_high_slope      define the slope area below high level of sat value for sat adjustment
//                                          0x00-0x07
//  Bit 19:16   reg_sat_sat_low_slope       define the slope area above low  level of sat value for sat adjustment
//                                          0x00-0x07
//  Bit 15:8    reg_sat_sat_high            define the high level of sat value for sat adjustment
//                                          0x00-0xff
//  Bit 7:0     reg_sat_sat_low             define the low  level of sat value for sat adjustment
//                                          0x00-0xff

    #define SAT_SAT_RANGE_REG00     0x05


    #define CHROMA_GAIN_REG01       0x06
    #define HUE_HUE_RANGE_REG01     0x07
    #define HUE_RANGE_INV_REG01     0x08
    #define HUE_LUM_RANGE_REG01     0x09
    #define HUE_SAT_RANGE_REG01     0x0a
    #define SAT_SAT_RANGE_REG01     0x0b

    #define CHROMA_GAIN_REG02       0x0c
    #define HUE_HUE_RANGE_REG02     0x0d
    #define HUE_RANGE_INV_REG02     0x0e
    #define HUE_LUM_RANGE_REG02     0x0f
    #define HUE_SAT_RANGE_REG02     0x10
    #define SAT_SAT_RANGE_REG02     0x11


    #define CHROMA_GAIN_REG03       0x12
    #define HUE_HUE_RANGE_REG03     0x13
    #define HUE_RANGE_INV_REG03     0x14
    #define HUE_LUM_RANGE_REG03     0x15
    #define HUE_SAT_RANGE_REG03     0x16
    #define SAT_SAT_RANGE_REG03     0x17

    #define CHROMA_GAIN_REG04       0x18
    #define HUE_HUE_RANGE_REG04     0x19
    #define HUE_RANGE_INV_REG04     0x1a
    #define HUE_LUM_RANGE_REG04     0x1b
    #define HUE_SAT_RANGE_REG04     0x1c
    #define SAT_SAT_RANGE_REG04     0x1d

    #define CHROMA_GAIN_REG05       0x1e
    #define HUE_HUE_RANGE_REG05     0x1f
    #define HUE_RANGE_INV_REG05     0x20
    #define HUE_LUM_RANGE_REG05     0x21
    #define HUE_SAT_RANGE_REG05     0x22
    #define SAT_SAT_RANGE_REG05     0x23

    #define CHROMA_GAIN_REG06       0x24
    #define HUE_HUE_RANGE_REG06     0x25
    #define HUE_RANGE_INV_REG06     0x26
    #define HUE_LUM_RANGE_REG06     0x27
    #define HUE_SAT_RANGE_REG06     0x28
    #define SAT_SAT_RANGE_REG06     0x29

    #define CHROMA_GAIN_REG07       0x2a
    #define HUE_HUE_RANGE_REG07     0x2b
    #define HUE_RANGE_INV_REG07     0x2c
    #define HUE_LUM_RANGE_REG07     0x2d
    #define HUE_SAT_RANGE_REG07     0x2e
    #define SAT_SAT_RANGE_REG07     0x2f

//  REG_CHROMA_CONTROL
//  Bit 31      reg_chroma_en               enable color manage function
//                                          1'b1: enable    1'b0: bypass
//  Bit 22      demo_adjust_on_left         1'b1: demo adjust on left, 1'b0: demo adjust on right
//  Bit 21      demo_highlight_adjusted     1'b1: hightlight the adjusted region, 1'b0: disable hightlight
//  Bit 20      demo_enable                 1'b1: demo mode enable, 1'b0, demo mode disable
//  Bit 19:8    demo_left_screen_width      left screen width in demo mode
//  Bit 6       sat_sel                     uv_max or u^2+v^2 selected as sat for reference
//                                          1'b1: uv_max(default)   1'b0: u^2+v^2
//  Bit 5       uv_adj_en                   final uv_adjust enable
//                                          1'b1: enable    1'b0: bypass
//  Bit 2       hue_en                      rgb to hue enable
//                                          1'b1: enable(default)   1'b0: bypass
//  Bit 1:0     csc_sel                     define input YUV with different color type
//                                          2'b00: 601(16-235)  2'b01: 709(16-235)
//                                          2'b10: 601(0-255)   2'b11: 709(0-255)
    #define REG_CHROMA_CONTROL      0x30   // default 32h'80000024


/* Constraints 
0)
  there are 16 regions totally. 8 regions are for hue adjustment, 8 regions are for sat adjustment.
  the hue range of the 16 regions can be set to overlap, but if overlap, the hue range(start and end) must be same.
  the 8 regions for hue adjustment should not overlap. if corresponding reg_hue_en_00 - 07 == 1
  the 8 regions for hue adjustment are defined by: (example are for region 0)
    a) hue:
        start: reg_hue_hue_shift_start_00[14:0]
        end:
        if reg_symmetry_en_00 == 0
        reg_hue_hue_shift_start_00[14:0] + (reg_hue_hue_shift_range_00[7:0]<<5)
        if reg_symmetry_en_00 == 1
        reg_hue_hue_shift_start_00[14:0] + (reg_hue_hue_shift_range_00[7:0]<<6)
    b) sat:
        start: reg_hue_sat_low_00 
        end:   reg_hue_sat_high_00  

  the 8 regions for sat adjustment should not overlap. if corresponding reg_sat_en_00 - 07 == 1
  the 8 regions for sat adjustment are defined by: (example are for region 0)
    a) hue: same as that for hue adjustment.
        start: reg_hue_hue_shift_start_00[14:0]
        end:
        if reg_symmetry_en_00 == 0
        reg_hue_hue_shift_start_00[14:0] + (reg_hue_hue_shift_range_00[7:0]<<5)
        if reg_symmetry_en_00 == 1
        reg_hue_hue_shift_start_00[14:0] + (reg_hue_hue_shift_range_00[7:0]<<6)
    b) sat:
        start: reg_sat_sat_low_00
        end:   reg_sat_sat_high_00  

1)
  reg_hue_hue_shift_range_00[7:0]:
  reg_hue_hue_shift_range_01[7:0]:
  reg_hue_hue_shift_range_02[7:0]:
  reg_hue_hue_shift_range_03[7:0]:
  reg_hue_hue_shift_range_04[7:0]:
  reg_hue_hue_shift_range_05[7:0]:
  reg_hue_hue_shift_range_06[7:0]:
  reg_hue_hue_shift_range_07[7:0]:
  must be greater or equal than 8'd8, so as reg_hue_range_inv_regxx can be represented by 0.0000_0000_xxxx_xxxx_xxxx_xxxx

2)
  all regions of 0-7 should meet below requirement. below is just an example for region 7.
  (reg_hue_lum_high_07 - reg_hue_lum_low_07) >= 
        (1<<reg_hue_lum_low_slope_07) + (1<<reg_hue_lum_high_slope_07)

  (reg_hue_sat_high_07 - reg_hue_sat_low_07) >=
        (1<<reg_hue_sat_low_slope_07) + (1<<reg_hue_sat_high_slope_07)

  (reg_sat_lum_high_07 - reg_sat_lum_low_07) >=
        (1<<reg_sat_lum_low_slope_07) + (1<<reg_sat_lum_high_slope_07)

  (reg_sat_sat_high_07 - reg_sat_sat_low_07) >=
        (1<<reg_sat_sat_low_slope_07) + (1<<reg_sat_sat_high_slope_07)

3)
  all of reg_hue_hue_shift_start_00[14:0] ~ 07[14:0] < 0x6000.
  only region 0 and 1 can exceed 360 degrees. ie:
    reg_hue_hue_shift_start_00 + (reg_hue_hue_shift_range_00<<5) can greater than 0x6000.
    reg_hue_hue_shift_start_01 + (reg_hue_hue_shift_range_01<<5) can greater than 0x6000.
  but below should be met:
    reg_hue_hue_shift_start_00 + (reg_hue_hue_shift_range_00<<5) < 0x8000. if reg_symmetry_en_00 == 0
    reg_hue_hue_shift_start_01 + (reg_hue_hue_shift_range_00<<5) < 0x8000. if reg_symmetry_en_00 == 0
    reg_hue_hue_shift_start_00 + (reg_hue_hue_shift_range_00<<6) < 0x8000. if reg_symmetry_en_00 == 1
    reg_hue_hue_shift_start_01 + (reg_hue_hue_shift_range_00<<6) < 0x8000. if reg_symmetry_en_00 == 1

  others could not exceed 360 degrees. ie:
    reg_hue_hue_shift_start_02(to 7) + (reg_hue_hue_shift_range_02 (to 7) <<5) < 0x6000. if reg_symmetry_en_02 (to 7) == 0.
    reg_hue_hue_shift_start_02(to 7) + (reg_hue_hue_shift_range_02 (to 7) <<6) < 0x6000. if reg_symmetry_en_02 (to 7) == 1.

4)
  reg_hue_gain_00[7:0] <= 0x80.
  reg_hue_gain_01[7:0] <= 0x80.
  reg_hue_gain_02[7:0] <= 0x80.
  reg_hue_gain_03[7:0] <= 0x80.
  reg_hue_gain_04[7:0] <= 0x80.
  reg_hue_gain_05[7:0] <= 0x80.
  reg_hue_gain_06[7:0] <= 0x80.
  reg_hue_gain_07[7:0] <= 0x80.

5)
  below registers can only have two setting: 00 and 01.
    reg_hue_central_en_00[1:0]  .. _07[1:0]
    reg_sat_central_en_00[1:0]  .. _07[1:0]

6)
  all reg_..._slope_00-07 should not be greater than 7, ie: maximum value is 7.
   for example: below is for region 0:
   reg_hue_lum_low_slope_00[3:0]  <= 7
   reg_hue_lum_high_slope_00[3:0] <= 7
   reg_hue_sat_low_slope_00[3:0]  <= 7
   reg_hue_sat_high_slope_00[3:0] <= 7
   reg_sat_lum_low_slope_00[3:0]  <= 7
   reg_sat_lum_high_slope_00[3:0] <= 7
   reg_sat_sat_low_slope_00[3:0]  <= 7
   reg_sat_sat_high_slope_00[3:0] <= 7
*/

// synopsys translate_off
// synopsys translate_on
//
// Closing file:  chroma_reg.h
//
//hsvsharp, blue, gainoff, mat_vd1,mat_vd2, mat_post, prebld, postbld,hsharp,sco_ff, vadj1, vadj2, ofifo, chroma, clk0(free_clk) vpp_reg
//each item 2bits, for each 2bits, if bit 2*i+1 == 1, free clk, else if bit 2*i == 1 no clk, else auto gated clock 
//bit1 is not used, because I can not turn off vpp_reg clk because I can not turn on again 
//because the register itself canot be set again without clk
//Bit 31:0
#define VPP_GCLK_CTRL0                             0x1d72
//Ccoring, blackext, dnlp
//Bit 5:0
#define VPP_GCLK_CTRL1                             0x1d73
//prehsc_clk, line_buf, prevsc, vsc, hsc_clk, clk0(free_clk)
//Bit 11:0
#define VPP_SC_GCLK_CTRL                           0x1d74
//Bit 31:24     blackext_start
//Bit 23:16     blackext_slope1
//Bit 15:8      blackext_midpt
//Bit 7:0       blackext_slope2
#define VPP_BLACKEXT_CTRL                          0x1d80
//Bit 31:24     bottom of region03 output value
//Bit 23:16     bottom of region02 output value
//Bit 15:8      bottom of region01 output value
//Bit 7:0       bottom of region00 output value
#define VPP_DNLP_CTRL_00                           0x1d81
//Bit 31:24     bottom of region07 output value
//Bit 23:16     bottom of region06 output value
//Bit 15:8      bottom of region05 output value
//Bit 7:0       bottom of region04 output value
#define VPP_DNLP_CTRL_01                           0x1d82
//Bit 31:24     bottom of region11 output value
//Bit 23:16     bottom of region10 output value
//Bit 15:8      bottom of region09 output value
//Bit 7:0       bottom of region08 output value
#define VPP_DNLP_CTRL_02                           0x1d83
//Bit 31:24     bottom of region15 output value
//Bit 23:16     bottom of region14 output value
//Bit 15:8      bottom of region13 output value
//Bit 7:0       bottom of region12 output value
#define VPP_DNLP_CTRL_03                           0x1d84
//Bit 31:24     bottom of region19 output value
//Bit 23:16     bottom of region18 output value
//Bit 15:8      bottom of region17 output value
//Bit 7:0       bottom of region16 output value
#define VPP_DNLP_CTRL_04                           0x1d85
//Bit 31:24     bottom of region23 output value
//Bit 23:16     bottom of region22 output value
//Bit 15:8      bottom of region21 output value
//Bit 7:0       bottom of region20 output value
#define VPP_DNLP_CTRL_05                           0x1d86
//Bit 31:24     bottom of region27 output value
//Bit 23:16     bottom of region26 output value
//Bit 15:8      bottom of region25 output value
//Bit 7:0       bottom of region24 output value
#define VPP_DNLP_CTRL_06                           0x1d87
//Bit 31:24     bottom of region31 output value
//Bit 23:16     bottom of region30 output value
//Bit 15:8      bottom of region29 output value
//Bit 7:0       bottom of region28 output value
#define VPP_DNLP_CTRL_07                           0x1d88
//Bit 31:24     bottom of region35 output value
//Bit 23:16     bottom of region34 output value
//Bit 15:8      bottom of region33 output value
//Bit 7:0       bottom of region32 output value
#define VPP_DNLP_CTRL_08                           0x1d89
//Bit 31:24     bottom of region39 output value
//Bit 23:16     bottom of region38 output value
//Bit 15:8      bottom of region37 output value
//Bit 7:0       bottom of region36 output value
#define VPP_DNLP_CTRL_09                           0x1d8a
//Bit 31:24     bottom of region43 output value
//Bit 23:16     bottom of region42 output value
//Bit 15:8      bottom of region41 output value
//Bit 7:0       bottom of region40 output value
#define VPP_DNLP_CTRL_10                           0x1d8b
//Bit 31:24     bottom of region47 output value
//Bit 23:16     bottom of region46 output value
//Bit 15:8      bottom of region45 output value
//Bit 7:0       bottom of region44 output value
#define VPP_DNLP_CTRL_11                           0x1d8c
//Bit 31:24     bottom of region51 output value
//Bit 23:16     bottom of region50 output value
//Bit 15:8      bottom of region49 output value
//Bit 7:0       bottom of region48 output value
#define VPP_DNLP_CTRL_12                           0x1d8d
//Bit 31:24     bottom of region55 output value
//Bit 23:16     bottom of region54 output value
//Bit 15:8      bottom of region53 output value
//Bit 7:0       bottom of region52 output value
#define VPP_DNLP_CTRL_13                           0x1d8e
//Bit 31:24     bottom of region59 output value
//Bit 23:16     bottom of region58 output value
//Bit 15:8      bottom of region57 output value
//Bit 7:0       bottom of region56 output value
#define VPP_DNLP_CTRL_14                           0x1d8f
//Bit 31:24     bottom of region63 output value
//Bit 23:16     bottom of region62 output value
//Bit 15:8      bottom of region61 output value
//Bit 7:0       bottom of region60 output value
#define VPP_DNLP_CTRL_15                           0x1d90
//Bit 28        vlti_step
//Bit 27        vlti_step2
//Bit 26:25     hlti_step
//Bit 24:20     peaking_gain_h1
//Bit 19:15     peaking_gain_h2
//Bit 14:10     peaking_gain_h3
//Bit 9:5       peaking_gain_h4
//Bit 4:0       peaking_gain_h5
#define VPP_PEAKING_HGAIN                          0x1d91
//Bit 31        hsvsharp_buf_en
//Bit 30        hsvsharp_buf_c5line_mode
//Bit 29:25     peaking_gain_v1
//Bit 24:20     peaking_gain_v2
//Bit 19:15     peaking_gain_v3
//Bit 14:10     peaking_gain_v4
//Bit 9:5       peaking_gain_v5
//Bit 4:0       peaking_gain_v6
#define VPP_PEAKING_VGAIN                          0x1d92
//Bit 31:26     hpeaking_slope1
//Bit 25:20     hpeaking_slope2
//Bit 19:12     hpeaking_slope_th1
//Bit 11:6      vpeaking_slope1
//Bit 5:0       vpeaking_slope2
#define VPP_PEAKING_NLP_1                          0x1d93
//Bit 31:24     hpeaking_slope_th2
//Bit 23:16     hpeaking_nlp_coring_th
//Bit 15:8      hpeaking_nlp_pgain
//Bit 7:0       hpeaking_nlp_ngain
#define VPP_PEAKING_NLP_2                          0x1d94
//Bit 31:24     vpeaking_slope_th1
//Bit 23:18     speaking_slope1
//Bit 17:12     speaking_slope2
//Bit 11:4      speaking_slope_th1
//Bit 3:0       peaking_coring_gain
#define VPP_PEAKING_NLP_3                          0x1d95
//Bit 31:24     vpeaking_slope_th2
//Bit 23:16     vpeaking_nlp_coring_th
//Bit 15:8      vpeaking_nlp_pgain
//Bit 7:0       vpeaking_nlp_ngain
#define VPP_PEAKING_NLP_4                          0x1d96
//Bit 31:24     speaking_slope_th2
//Bit 23:16     speaking_nlp_coring_th
//Bit 15:8      speaking_nlp_pgain
//Bit 7:0       speaking_nlp_ngain
#define VPP_PEAKING_NLP_5                          0x1d97
//Bit 31:24     peaking_coring_th_l
//Bit 23:16     peaking_coring_th_h
//Bit 15:12     vlimit_high_coef
//Bit 11:8      vlimit_low_coef
//Bit 7:4       hlimit_high_coef
//Bit 3:0       hlimit_low_coef
#define VPP_SHARP_LIMIT                            0x1d98
//Bit 31:24     vlti_neg_gain
//Bit 23:16     vlti_pos_gain
//Bit 15:8      vlti_threshold
//Bit 7:0       vlti_blend_factor
#define VPP_VLTI_CTRL                              0x1d99
//Bit 31:24     hlti_neg_gain
//Bit 23:16     hlti_pos_gain
//Bit 15:8      hlti_threshold
//Bit 7:0       hlti_blend_factor
#define VPP_HLTI_CTRL                              0x1d9a
//Bit 29:28     cti_vfilter_type
//Bit 27        cti_422to444_en
//Bit 26:24     cti_step2
//Bit 23:21     cti_step
//Bit 20:16     cti_blend_factor
//Bit 15        cti_median_mode
//Bit 14:8      cti_threshold
//Bit 7:0       cti_gain
#define VPP_CTI_CTRL                               0x1d9b
//Bit 29        blue_stretch_cb_inc
//Bit 28        blue_stretch_cr_inc
//Bit 27        the MSB of blue_stretch_error_crp_inv[11:0]
//Bit 26        the MSB of blue_stretch_error_crn_inv[11:0]
//Bit 25        the MSB of blue_stretch_error_cbp_inv[11:0]
//Bit 24        the MSB of blue_stretch_error_cbn_inv[11:0]
//Bit 23:16     blue_stretch_gain
//Bit 15:8      blue_stretch_gain_cb4cr
//Bit 7:0       blue_stretch_luma_high
#define VPP_BLUE_STRETCH_1                         0x1d9c
//Bit 31:27     blue_stretch_error_crp
//Bit 26:16     the 11 LSB of blue_stretch_error_crp_inv[11:0]
//Bit 15:11     blue_stretch_error_crn
//Bit 10:0      the 11 LSB of blue_stretch_error_crn_inv[11:0]
#define VPP_BLUE_STRETCH_2                         0x1d9d
//Bit 31:27     blue_stretch_error_cbp
//Bit 26:16     the 11 LSB of blue_stretch_error_cbp_inv[11:0]
//Bit 15:11     blue_stretch_error_cbn
//Bit 10:0      the 11 LSB of blue_stretch_error_cbn_inv[11:0]
#define VPP_BLUE_STRETCH_3                         0x1d9e
//Bit 15:8, Chroma coring threshold
//Bit 3:0, Chroma coring slope
#define VPP_CCORING_CTRL                           0x1da0
//Bit 20 demo chroma coring enable
//Bit 19 demo black enxtension enable
//Bit 18 demo dynamic nonlinear luma processing enable
//Bit 17 demo hsvsharp enable
//Bit 16 demo bluestretch enable
//Bit 15, if true, enhance video is on the left screen, otherwises it is on the right screen
//Bit 4 chroma coring enable
//Bit 3 black enxtension enable
//Bit 2 dynamic nonlinear luma processing enable
//Bit 1 hsvsharp enable
//Bit 0 bluestretch enable
#define VPP_VE_ENABLE_CTRL                         0x1da1
//Bit 11:0, demo left screen width
#define VPP_VE_DEMO_LEFT_SCREEN_WIDTH              0x1da2
// synopsys translate_off
// synopsys translate_on
//
// Closing file:  vpp_regs.h
//
//
//========================================================================
//	registers for ge2d (12'h8a0 - 12'h8ff)
//========================================================================
//
// Reading file:  ge2d_regs.h
//
// synopsys translate_off
// synopsys translate_on
//===========================================================================
// GE2D Registers    0x8a0 - 0x8ff
//===========================================================================
// -----------------------------------------------
// CBUS_BASE:  GE2D_CBUS_BASE = 0x18
// -----------------------------------------------
//Bit 31, destination bytemask only if destination bitmask is enable
//Bit 30, destination bitmask enable
//Bit 29, source2 key  enable
//Bit 28, source2 key  mode, 0: mask data when match, 1: mask data when unmatch
//Bit 27, source1 key  enable
//Bit 26, source1 key  mode, 0: mask data when match, 1: mask data when unmatch
//Bit 25:24, dst 8bit mode component selection, 
//            00: select Y(R), 01: Cb(G), 10: Cr(B), 11: Alpha
//Bit 23 dst clip mode, 0: write inside clip window, 1: write outside clip window
//Bit 21:17  reserved
//Bit 16:15, src2 8bit mode component selection, 
//            00: select Y(R), 01: Cb(G), 10: Cr(B), 11: Alpha
//Bit 14     src2 fill mode, 0: repeat data, 1: fill default color
//Bit 13:12  src2 picture struct, 00: frame, 10: even, 11: odd
//Bit 11     src1 x direction yc ration, 0: 1:1, 1: 2:1
//Bit 10     src1 y direction yc ration, 0: 1:1, 1: 2:1
//Bit 8:7    reserved
//Bit 6:5,   src1  8bit mode component selection, 
//            00: select Y(R), 01: Cb(G), 10: Cr(B), 11: Alpha
//Bit 4      src1 fill mode, 0: repeat data, 1: fill default color
//Bit 3      src1 lookup table enable
//Bit 2:1    src1 picture struct, 00: frame, 10: even, 11: odd
//Bit 0      src1 separate buffer enable
#define GE2D_GEN_CTRL0                             0x18a0
//Bit 31, soft rst
//Bit 30, dst write response counter reset  
//Bit 29, disable adding dst write response count to busy bit 
//bit 25:24, interrupt control, if bit[0] true, generate interrupt when one command done,
//                              if bit[1] true, generate interrupt when ge2d change from busy to not busy
//Bit 23:22 src2 burst size control
//Bit 21:16 src1 burst size control, 5:4, yfifo, 3:2, cbfifo, 1:0, crfifo
//          each 2bit, 00: 24 64bitword, 01: 32 64bitword, 10: 48 64bitwords, 11: 64 64bitwords  
//Bit 15:14, dst picture struct, 00: frame, 10:top, 11: bottom
//Bit 13:12, bit 13 if true, force read src1, bit 12 if true, force read src2
//Bit 10, src1 request urgent enable
//Bit 9,  src2 request urgent enable
//Bit 8,  dst request urgent enable
//Bit 7:0 src1 global alpha
#define GE2D_GEN_CTRL1                             0x18a1
//Bit31      alpha conversion mode in alu, 0: alpha_out = (alpha !=0) ? alpha +1 : 0; 
//                 otherwise, alpha_out = (alpha < 128) ? alpha: alpha + 1;
//Bit30      color conversion mode in alu, 0: color_out = (color != 0) ? color +1: 0;
//                 otherwise, color_out = (color < 128) ? color: color + 1;
//Bit29      reserved
//Bit28      dst_color_round_mode, 0: truncate, 1: + 0.5 rounding
//Bit27      src2_color_expand_mode, 0: add 0, 1: add MSBs 
//Bit26      src2_alpha_expand_mode, 0: add 0, 1: add MSBs 
//Bit25      src1_color_expand_mode, 0: add 0, 1: add MSBs 
//Bit24      src1_alpha_expand_mode, 0: add 0, 1: add MSBs 
//Bit 23     if true, dst little endian, otherwise big endian
//Bit 22:19 dst color_map
//        dst_format=0                 : output 8-bit;
//        dst_format=1, dst_color_map=1: output 16-bit YCbCr  655;
//        dst_format=1, dst_color_map=2: output 16-bit YCbCr  844;
//        dst_format=1, dst_color_map=3: output 16-bit YCbCrA 6442;
//        dst_format=1, dst_color_map=4: output 16-bit YCbCrA 4444;
//        dst_format=1, dst_color_map=5: output 16-bit YCbCr  565;
//        dst_format=1, dst_color_map=6: output 16-bit AYCbCr 4444;
//        dst_format=1, dst_color_map=7: output 16-bit AYCbCr 1555;
//        dst_format=1, dst_color_map=8: output 16-bit YCbCrA 4642;
//        dst_format=2, dst_color_map=0: output 24-bit YCbCr  888;
//        dst_format=2, dst_color_map=1: output 24-bit YCbCrA 5658;
//        dst_format=2, dst_color_map=2: output 24-bit AYCbCr 8565;
//        dst_format=2, dst_color_map=3: output 24-bit YCbCrA 6666;
//        dst_format=2, dst_color_map=4: output 24-bit AYCbCr 6666;
//        dst_format=2, dst_color_map=5: output 24-bit CrCbY  888;
//        dst_format=3, dst_color_map=0: output 32-bit YCbCrA 8888;
//        dst_format=3, dst_color_map=1: output 32-bit AYCbCr 8888;
//        dst_format=3, dst_color_map=2: output 32-bit ACrCbY 8888;
//        dst_format=3, dst_color_map=3: output 32-bit CrCbYA 8888.
//Bit 17:16 dst_format,  00: 8bit, 01:16bit, 10:24bit, 11: 32bit
//Bit 15    if true, src2 little endian, otherwise big endian
//Bit 14:11  src2 color_map
//        src2_format=0                 : output 8-bit;
//        src2_format=1, src2_color_map=1: output 16-bit YCbCr  655;
//        src2_format=1, src2_color_map=2: output 16-bit YCbCr  844;
//        src2_format=1, src2_color_map=3: output 16-bit YCbCrA 6442;
//        src2_format=1, src2_color_map=4: output 16-bit YCbCrA 4444;
//        src2_format=1, src2_color_map=5: output 16-bit YCbCr  565;
//        src2_format=1, src2_color_map=6: output 16-bit AYCbCr 4444;
//        src2_format=1, src2_color_map=7: output 16-bit AYCbCr 1555;
//        src2_format=1, src2_color_map=8: output 16-bit YCbCrA 4642;
//        src2_format=2, src2_color_map=0: output 24-bit YCbCr  888;
//        src2_format=2, src2_color_map=1: output 24-bit YCbCrA 5658;
//        src2_format=2, src2_color_map=2: output 24-bit AYCbCr 8565;
//        src2_format=2, src2_color_map=3: output 24-bit YCbCrA 6666;
//        src2_format=2, src2_color_map=4: output 24-bit AYCbCr 6666;
//        src2_format=2, src2_color_map=5: output 24-bit CrCbY  888;
//        src2_format=3, src2_color_map=0: output 32-bit YCbCrA 8888;
//        src2_format=3, src2_color_map=1: output 32-bit AYCbCr 8888;
//        src2_format=3, src2_color_map=2: output 32-bit ACrCbY 8888;
//        src2_format=3, src2_color_map=3: output 32-bit CrCbYA 8888.
//Bit 9:8 src2 format, 00: 8bit, 01:16bit, 10:24bit 11: 32bit
//Bit 7     if true, src1 little endian, otherwise big endian
//Bit 6:3   src1 color_map
//        src1_format=0                 : output 8-bit;
//        src1_format=1, src1_color_map=0: output 4:2:2  (Y0Cb0Y1Cr0);
//        src1_format=1, src1_color_map=1: output 16-bit YCbCr  655;
//        src1_format=1, src1_color_map=2: output 16-bit YCbCr  844;
//        src1_format=1, src1_color_map=3: output 16-bit YCbCrA 6442;
//        src1_format=1, src1_color_map=4: output 16-bit YCbCrA 4444;
//        src1_format=1, src1_color_map=5: output 16-bit YCbCr  565;
//        src1_format=1, src1_color_map=6: output 16-bit AYCbCr 4444;
//        src1_format=1, src1_color_map=7: output 16-bit AYCbCr 1555;
//        src1_format=1, src2_color_map=8: output 16-bit YCbCrA 4642;
//        src1_format=2, src1_color_map=0: output 24-bit YCbCr  888;
//        src1_format=2, src1_color_map=1: output 24-bit YCbCrA 5658;
//        src1_format=2, src1_color_map=2: output 24-bit AYCbCr 8565;
//        src1_format=2, src1_color_map=3: output 24-bit YCbCrA 6666;
//        src1_format=2, src1_color_map=4: output 24-bit AYCbCr 6666;
//        src1_format=2, src1_color_map=5: output 24-bit CrCbY  888;
//        src1_format=3, src1_color_map=0: output 32-bit YCbCrA 8888;
//        src1_format=3, src1_color_map=1: output 32-bit AYCbCr 8888;
//        src1_format=3, src1_color_map=2: output 32-bit ACrCbY 8888;
//        src1_format=3, src1_color_map=3: output 32-bit CrCbYA 8888.     
//Bit 1:0 src1 format, 00: 8bit, 01:16bit/4:2:2, 10:24bit 11: 32bit 
#define GE2D_GEN_CTRL2                             0x18a2
//Bit 9     if true, all src2 data use default color
//Bit 8     if true, all src1 data use default color
//Bit 7     if true, dst x/y swap 
//Bit 6     if true, dst x direction reversely read
//Bit 5     if true, dst y direction reversely read
//Bit 4     if true, src2 x direction reversely read
//Bit 3     if true, src2 y direction reversely read
//Bit 2     if true, src1 x direction reversely read
//Bit 1     if true, src1 y direction reversely read
//Bit 0     cmd write
#define GE2D_CMD_CTRL                              0x18a3
//Read only
//Bit 28:17 dst write response counter, for debug only
//Bit 16:7  ge2d_dp status, for debug only
//Bit 6     read src1 cmd ready
//Bit 5     read src2 cmd ready
//Bit 4     pre dpcmd ready
//Bit 3     ge2d dpcmd ready
//Bit 2     ge2d buffer command valid
//Bit 1     ge2d current command valid
//Bit 0     ge2d busy
#define GE2D_STATUS0                               0x18a4
//
//Read only
// Bit 29:16 ge2d_dst_status, for debug only
// Bit    15 ge2d_rd_src2 core.fifo_empty
// Bit    14 ge2d_rd_src2 core.fifo_overflow
// Bit 13:12 ge2d_rd_src2 core.req_st
// Bit    11 ge2d_rd_src2 cmd_if.cmd_err, true if cmd_format=1
// Bit    10 ge2d_rd_src2 cmd_if.cmd_st, 0=IDLE state, 1=BUSY state
// Bit     9 ge2d_rd_src1 luma_core(chroma_core).fifo_empty
// Bit     8 ge2d_rd_src1 luma_core(chroma_core).fifo_overflow
// Bit  7: 6 ge2d_rd_src1 chroma_core.req_st_cr
// Bit  5: 4 ge2d_rd_src1 chroma_core.req_st_cb
// Bit  3: 2 ge2d_rd_src1 luma_core.req_st_y
// Bit     1 ge2d_rd_src1 cmd_if.stat_read_window_err, 1=reading/clipping window setting exceed limit
// Bit     0 ge2d_rd_src1 cmd_if.cmd_st, 0=IDLE state, 1=BUSY state
#define GE2D_STATUS1                               0x18a5
//SRC1 default clolor
//{Y,Cb,Cr,A}/{R,G,B,A}
#define GE2D_SRC1_DEF_COLOR                        0x18a6
//Bit 31, SRC1 clip x start extra, if true, one more data is read for chroma
//Bit 28:16, SRC1 clip x start
//Bit 15, SRC1 clip x end extra, if true, one more data is read for chroma
//Bit 12:0, SRC1 clip x end
#define GE2D_SRC1_CLIPX_START_END                  0x18a7
//Bit 31, SRC1 clip y start extra, if true, one more data is read for chroma
//Bit 28:16, SRC1 clip y start
//Bit 15, SRC1 clip y end extra, if true, one more data is read for chroma
//Bit 12:0, SRC1 clip y end
#define GE2D_SRC1_CLIPY_START_END                  0x18a8
//Bit 31:24, SRC1 canvas address0
//Bit 23:16, SRC1 canvas address1
//Bit 15:8, SRC1 canvas address2
#define GE2D_SRC1_CANVAS                           0x18a9
//Bit 31, SRC1 x start extra bit1, if true, one more chroma data is read for x even start chroma data when y/c ratio = 2
//             or x even/odd start chroma extra data when y/c ratio = 1
//Bit 30, SRC1 x start extra bit0, if true, one more chroma data is read for x odd start chroma data when y/c ratio = 2
//Bit 29:16, SRC1 x start, signed data
//Bit 15, SRC1 x end extra bit1, if true, one more chroma data is read for x odd end chroma data when y/c ratio = 2
//             or x even/odd end chroma extra data when y/c ratio = 1
//Bit 14, SRC1 x end extra bit0, if true, one more chroma data is read for x even end chroma data when y/c ratio = 2
//Bit 13:0, SRC1 x end, signed data
#define GE2D_SRC1_X_START_END                      0x18aa
//Bit 31, SRC1 y start extra, if true, one more chroma data is read for y even start chroma data when y/c ratio = 2
//             or y even/odd start chroma extra data when y/c ratio = 1
//Bit 30, SRC1 y start extra, if true, one more chroma data is read for x odd start chroma data when y/c ratio = 2
//Bit 28:16, SRC1 y start
//Bit 15, SRC1 y end extra bit1, if true, one more chroma data is read for y odd end chroma data when y/c ratio = 2
//             or y even/odd end chroma extra data when y/c ratio = 1
//Bit 14, SRC1 y end extra bit0, if true, one more chroma data is read for y even end chroma data when y/c ratio = 2
//Bit 12:0, SRC1 y end
#define GE2D_SRC1_Y_START_END                      0x18ab
// Bit 31: 9 Reserved
// Bit     8 RW, 0 = Write LUT, 1 = Read LUT
// Bit  7: 0 RW, lut_addr
#define GE2D_SRC1_LUT_ADDR                         0x18ac
// Bit 31:24 RW, Y or R
// Bit 23:16 RW, Cb or G
// Bit 15: 8 RW, Cr or B
// Bit  7: 0 RW, Alpha
#define GE2D_SRC1_LUT_DAT                          0x18ad
//Bit 19, if true, horizontal formatter using repeat to get the pixel, otherwise using interpolation
//Bit 18, horizontal formatter en
//Bit 17, if true, vertical formatter using repeat to get the pixel, otherwise using interpolation
//Bit 16, vertical formatter en
//Bit 15:8 X direction chroma phase,  
//          [7:4] for x direction even start/end chroma phase when y/c ratio = 2
//                or start/end even/odd chroma phase  when y/c ratio = 1 
//          [3:0] for x direction odd start/end chroma phase only when y/c ration = 2
//Bit 7:0  Y direction chroma phase, 
//          [7:4] for y direction even start/end chroma phase when y/c ratio = 2
//          or start/end even/odd chroma phase  when y/c ratio = 1 
//          [3:0] for y direction odd start/end chroma phase only when y/c ration = 2 
#define GE2D_SRC1_FMT_CTRL                         0x18ae
//SRC2 default clolor
//{Y,Cb,Cr,A}/{R,G,B,A}
#define GE2D_SRC2_DEF_COLOR                        0x18af
//Bit 28:16, SRC2 clip x start
//Bit 12:0, SRC2 clip x end
#define GE2D_SRC2_CLIPX_START_END                  0x18b0
//Bit 28:16, SRC2 clip y start
//Bit 12:0, SRC2 clip y end
#define GE2D_SRC2_CLIPY_START_END                  0x18b1
//Bit 28:16, SRC2 x start
//Bit 12:0, SRC2 x end
#define GE2D_SRC2_X_START_END                      0x18b2
//Bit 28:16, SRC2 y start
//Bit 12:0, SRC2 y end
#define GE2D_SRC2_Y_START_END                      0x18b3
//Bit 28:16, DST clip x start
//Bit 12:0, DST clip x end
#define GE2D_DST_CLIPX_START_END                   0x18b4
//
//Bit 28:16, DST clip y start
//Bit 12:0, DST clip y end
#define GE2D_DST_CLIPY_START_END                   0x18b5
//Bit 28:16, DST x start
//Bit 12:0, DST x end
#define GE2D_DST_X_START_END                       0x18b6
//
//Bit 28:16, DST x start
//Bit 12:0, DST x end
#define GE2D_DST_Y_START_END                       0x18b7
//Bit 15:8 SRC2 canvas address
//Bit 7:0 DST canvas address
#define GE2D_SRC2_DST_CANVAS                       0x18b8
//vertical scaler phase step
//Bit 28:0,  5.24 format
#define GE2D_VSC_START_PHASE_STEP                  0x18b9
//phase slope 
//Bit 24:0, bit 24 signed bit
#define GE2D_VSC_PHASE_SLOPE                       0x18ba
//Bit 30:29, vertical repeat line0 number 
//Bit 23:0, vertical scaler initial phase
#define GE2D_VSC_INI_CTRL                          0x18bb
//horizontal scaler phase step
//Bit 28:0,  5.24 format
#define GE2D_HSC_START_PHASE_STEP                  0x18bc
//phase slope 
//Bit 24:0, bit 24 signed bit
#define GE2D_HSC_PHASE_SLOPE                       0x18bd
//Bit 30:29, horizontal repeat line0 number 
//Bit 23:0, horizontal scaler initial phase
#define GE2D_HSC_INI_CTRL                          0x18be
//Bit 31:24, advance number in this round, if horizontal scaler is working on dividing mode
//Bit 23:0, horizontal scaler advance phase in this round, if horizontal scaler is working on dividing mode 
#define GE2D_HSC_ADV_CTRL                          0x18bf
//Bit 30, vertical nearest mode enable, must set vt_bank_length = 4
//Bit 29, horizontal nearest mode enable, must set hz_bank_length = 4 
//Bit 28, horizontal scaler dividing mode enable
//Bit 27:15, horizontal dividing length, if bit 25 is enable
//Bit 14, pre horizontal scaler enable 
//Bit 13, pre vertical scale enable
//Bit 12, vertical scale enable
//Bit 11, horizontal scaler enable
//Bit 9, if true, treat horizontal repeat line number(GE2D_HSC_INI_CTRL bit 30:29) as repeating line, 
//        otherwise using treat horizontal repeat line number as minus line number. 
//Bit 8, if true, treat vertical repeat line number(GE2D_VSC_INI_CTRL bit 30:29) as repeating line, 
//        otherwise using treat vertical repeat line number as minus line number. 
//Bit 7, if true, always use phase0 in vertical scaler
//Bit 6:4, vertical scaler bank length
//Bit 3, if true, always use phase0 in horizontal scaler
//Bit 2:0, horizontal scaler bank length
#define GE2D_SC_MISC_CTRL                          0x18c0
//Read only
//vertical scaler next round integer pixel pointer, signed data
//Bit 13:0
#define GE2D_VSC_NRND_POINT                        0x18c1
//Read only
//vertical scaler next round phase
//bit 23:0
#define GE2D_VSC_NRND_PHASE                        0x18c2
//Read only
//horizontal scaler next round integer pixel pointer, signed data
//Bit 13:0
#define GE2D_HSC_NRND_POINT                        0x18c3
//Read only
//horizontal scaler next round phase
//bit 23:0
#define GE2D_HSC_NRND_PHASE                        0x18c4
//
//Bit 28:20, pre_offset0
//Bit 18:10, pre_offset1 
//Bit 8:0,   pre_offset2
#define GE2D_MATRIX_PRE_OFFSET                     0x18c5
//Bit 28:16 coef00
//Bit 12:0  coef01
#define GE2D_MATRIX_COEF00_01                      0x18c6
//Bit 28:16 coef02
//Bit 12:0  coef10
#define GE2D_MATRIX_COEF02_10                      0x18c7
//Bit 28:16 coef11
//Bit 12:0  coef12
#define GE2D_MATRIX_COEF11_12                      0x18c8
//Bit 28:16 coef20
//Bit 12:0  coef21
#define GE2D_MATRIX_COEF20_21                      0x18c9
//Bit 28:16 coef22
//Bit 7    input y/cb/cr saturation enable
//Bit 0    conversion matrix enable
#define GE2D_MATRIX_COEF22_CTRL                    0x18ca
//Bit 28:20, offset0
//Bit 18:10, offset1 
//Bit 8:0,   offset2
#define GE2D_MATRIX_OFFSET                         0x18cb
//Bit 26:25, SRC1 color multiplier alpha selection
//           if 00, Cs = Csr
//           if 01, Cs = Csr * Asr * Ag (if source is not premultiplied)
//           if 10, Cs = Csr * Ag (if source is premultipied)
//Bit 24    SRC2 color multiplier alpha selection 
//          if 0, no multiplier, Cd = Cdr,  otherwise, Cd = Cdr * Ad.   
//Bit 22:12 ALU color operation
//          bit10:8 Blending Mode Parameter
//            3'b000: ADD               Cs*Fs + Cd*Fd
//            3'b001: SUBTRACT          Cs*Fs - Cd*Fd
//            3'b010: REVERSE SUBTRACT  Cd*Fd - Cs*Fs
//            3'b011: MIN               min(Cs*Fs, Cd*Fd)
//            3'b100: MAX               max(Cs*Fs, Cd*Fd)
//            3'b101: LOGIC OP          Cs op Cd
//          bit7:4 Source Color Blending Factor CFs
//            4'b0000: ZERO                        0
//            4'b0001: ONE                         1
//            4'b0010: SRC_COLOR                   Cs(RGBs)
//            4'b0011: ONE_MINUS_SRC_COLOR         1 - Cs(RGBs)
//            4'b0100: DST_COLOR                   Cd(RGBd)
//            4'b0101: ONE_MINUS_DST_COLOR         1 - Cd(RGBd)
//            4'b0110: SRC_ALPHA                   As
//            4'b0111: ONE_MINUS_SRC_ALPHA         1 - As
//            4'b1000: DST_ALPHA                   Ad
//            4'b1001: ONE_MINUS_DST_ALPHA         1 - Ad
//            4'b1010: CONST_COLOR                 Cc(RGBc)
//            4'b1011: ONE_MINUS_CONST_COLOR       1 - Cc(RGBc)
//            4'b1100: CONST_ALPHA                 Ac
//            4'b1101: ONE_MINUS_CONST_ALPHA       1 - Ac
//            4'b1110: SRC_ALPHA_SATURATE          min(As,1-Ad)
//          bit3:0 dest Color Blending Factor CFd, when bit10:8 != LOGIC OP
//            4'b0000: ZERO                        0
//            4'b0001: ONE                         1
//            4'b0010: SRC_COLOR                   Cs(RGBs)
//            4'b0011: ONE_MINUS_SRC_COLOR         1 - Cs(RGBs)
//            4'b0100: DST_COLOR                   Cd(RGBd)
//            4'b0101: ONE_MINUS_DST_COLOR         1 - Cd(RGBd)
//            4'b0110: SRC_ALPHA                   As
//            4'b0111: ONE_MINUS_SRC_ALPHA         1 - As
//            4'b1000: DST_ALPHA                   Ad
//            4'b1001: ONE_MINUS_DST_ALPHA         1 - Ad
//            4'b1010: CONST_COLOR                 Cc(RGBc)
//            4'b1011: ONE_MINUS_CONST_COLOR       1 - Cc(RGBc)
//            4'b1100: CONST_ALPHA                 Ac
//            4'b1101: ONE_MINUS_CONST_ALPHA       1 - Ac
//            4'b1110: SRC_ALPHA_SATURATE          min(As,1-Ad)
//          bit3:0 logic operations, when bit10:8 == LOGIC OP
//            4'b0000: CLEAR                       0
//            4'b0001: COPY                        s
//            4'b0010: NOOP                        d
//            4'b0011: SET                         1
//            4'b0100: COPY_INVERT                 ~s
//            4'b0101: INVERT                      ~d
//            4'b0110: AND_REVERSE                 s & ~d
//            4'b0111: OR_REVERSE                  s | ~d
//            4'b1000: AND                         s & d
//            4'b1001: OR                          s | d
//            4'b1010: NAND                        ~(s & d)
//            4'b1011: NOR                         ~(s | d)
//            4'b1100: XOR                         s ^ d
//            4'b1101: EQUIV                       ~(s ^ d)
//            4'b1110: AND_INVERTED                ~s & d
//            4'b1111: OR_INVERTED                 ~s | d
//Bit 10:0  ALU alpha operation
//            bit10:8 Blending Equation Math Operation
//              3'b000: ADD               As*Fs + Ad*Fd
//              3'b001: SUBTRACT          As*Fs - Ad*Fd
//              3'b010: REVERSE SUBTRACT  Ad*Fd - As*Fs
//              3'b011: MIN               min(As*Fs, Ad*Fd)
//              3'b100: MAX               max(As*Fs, Ad*Fd)
//              3'b101: LOGIC OP          As op Ad
//            bit7:4 Source alpha Blending Factor AFs
//              4'b0000                       0
//              4'b0001                       1
//              4'b0010                       As
//              4'b0011                       1 - As
//              4'b0100                       Ad
//              4'b0101                       1 - Ad
//              4'b0110                       Ac
//              4'b0111                       1 - Ac
//               ....                         reserved
//            bit3:0 Destination alpha Blending Factor AFd, when bit10:8 != LOGIC OP
//              4'b0000                       0
//              4'b0001                       1
//              4'b0010                       As
//              4'b0011                       1 - As
//              4'b0100                       Ad
//              4'b0101                       1 - Ad
//              4'b0110                       Ac
//              4'b0111                       1 - Ac
//               ....                         reserved
//            bit3:0 logic operations, when bit10:8 == LOGIC OP
//              4'b0000: CLEAR                       0
//              4'b0001: COPY                        s
//              4'b0010: NOOP                        d
//              4'b0011: SET                         1
//              4'b0100: COPY_INVERT                 ~s
//              4'b0101: INVERT                      ~d
//              4'b0110: AND_REVERSE                 s & ~d
//              4'b0111: OR_REVERSE                  s | ~d
//              4'b1000: AND                         s & d
//              4'b1001: OR                          s | d
//              4'b1010: NAND                        ~(s & d)
//              4'b1011: NOR                         ~(s | d)
//              4'b1100: XOR                         s ^ d
//              4'b1101: EQUIV                       ~(s ^ d)
//              4'b1110: AND_INVERTED                ~s & d
//              4'b1111: OR_INVERTED                 ~s | d
#define GE2D_ALU_OP_CTRL                           0x18cc
//bit 31:0 (RGBA,YCBCRA)
#define GE2D_ALU_CONST_COLOR                       0x18cd
//SRC1 Key
//31:0 
#define GE2D_SRC1_KEY                              0x18ce
//SRC1 Key Mask
//31:0 
#define GE2D_SRC1_KEY_MASK                         0x18cf
//SRC2 Key
//31:0 
#define GE2D_SRC2_KEY                              0x18d0
//SRC2 Key Mask
//31:0 
#define GE2D_SRC2_KEY_MASK                         0x18d1
//Destination Bit Mask
//31:0 
#define GE2D_DST_BITMASK                           0x18d2
//Bit 31    DP onoff mode, 0: on_counter means how many pixels will output before ge2d turns off
//                         1: on_counter means how many clocks will ge2d turn on before ge2d turns off
//Bit 30:16     DP on counter
//Bit 15        0: vd_format doesnt have onoff mode, 1: vd format has onoff mode
//Bit 14:0      DP off counter
#define GE2D_DP_ONOFF_CTRL                         0x18d3
//Because there are many coefficients used in the vertical filter and horizontal filters,
//indirect access the coefficients of vertical filter and horizontal filter is used.
//For vertical filter, there are 33x4 coefficients 
//For horizontal filter, there are 33x4 coefficients
//Bit 15	index increment, if bit9 == 1  then (0: index increase 1, 1: index increase 2) else (index increase 2)	
//Bit 14	1: read coef through cbus enable, just for debug purpose in case when we wanna check the coef in ram in correct or not
//Bit 9     if true, use 9bit resolution coef, other use 8bit resolution coef
//Bit 8	    type of index, 0: vertical coef
//						   1: horizontal coef
//Bit 6:0 	coef index
#define GE2D_SCALE_COEF_IDX                        0x18d4
//coefficients for vertical filter and horizontal filter
#define GE2D_SCALE_COEF                            0x18d5
//Bit 24    src2 alpha fill mode: together with GE2D_GEN_CTRL0[4](fill_mode), define what alpha values are used
//                                for the area outside the clipping window. As below:
//                                fill_mode=0, alpha_fill_mode=0 : use inner alpha, (or default_alpha if src data have no alpha values);
//                                fill_mode=0, alpha_fill_mode=1 : use outside_alpha;
//                                fill_mode=1, alpha_fill_mode=0 : use default_alpha;
//                                fill_mode=1, alpha_fill_mode=1 : use outside_alpha.
//Bit 23:16 src2 outside alpha
//Bit 8     src1 alpha fill mode, refer to src2 alpha fill mode above. 
//Bit 7:0   src1 outside alpha
#define GE2D_SRC_OUTSIDE_ALPHA                     0x18d6
//Bit 31       antiflick enable
//Bit 24       1: alpha value for the first line use repeated alpha, 0: use bit 23:16 as the first line alpha 
//Bit 23:16     register value for the first line alpha when bit 24 is 1 
//Bit 8        1: alpha value for the last line use repeated alpha, 0: use bit 7:0 as the last line alpha 
//Bit 7:0      register value for the last line alpha when bit 8 is 1 
#define GE2D_ANTIFLICK_CTRL0                       0x18d8
//Bit 25,    rgb_sel, 1: antiflick RGBA, 0: antiflick YCbCrA 
//Bit 24,    cbcr_en, 1: also filter cbcr in case of antiflicking YCbCrA, 0: no filter on cbcr in case of antiflicking YCbCrA
//Bit 23:16, R mult coef for converting RGB to Y
//Bit 15:8,  G mult coef for converting RGB to Y
//Bit 7:0,   B mult coef for converting RGB to Y
//Y = (R * y_r + G * y_g + B * y_b) / 256
#define GE2D_ANTIFLICK_CTRL1                       0x18d9
//Bit 31:24, Y threhold1, when   0<Y<=th1, use filter0;
//Bit 23:16, color antiflick filter0 n3
//Bit 15:8,  color antiflick filter0 n2
//Bit 7:0,   color antiflick filter0 n1
//Y = (line_up * n1 + line_center * n2 + line_dn * n3) / 128
#define GE2D_ANTIFLICK_COLOR_FILT0                 0x18da
//Bit 31:24, Y threhold2, when th1<Y<=th2, use filter1;
//Bit 23:16, color antiflick filter1 n3
//Bit 15:8,  color antiflick filter1 n2
//Bit 7:0,   color antiflick filter1 n1
#define GE2D_ANTIFLICK_COLOR_FILT1                 0x18db
//Bit 31:24, Y threhold3, when th2<Y<=th3, use filter2; Y>th3, use filter3
//Bit 23:16, color antiflick filter2 n3
//Bit 15:8,  color antiflick filter2 n2
//Bit 7:0,   color antiflick filter2 n1
#define GE2D_ANTIFLICK_COLOR_FILT2                 0x18dc
//Bit 23:16, color antiflick filter3 n3
//Bit 15:8,  color antiflick filter3 n2
//Bit 7:0,   color antiflick filter3 n1
#define GE2D_ANTIFLICK_COLOR_FILT3                 0x18dd
//Bit 31:24, Alpha threhold1, when   0<Alpha<=th1, use filter0;
//Bit 23:16, Alpha antiflick filter0 n3
//Bit 15:8,  Alpha antiflick filter0 n2
//Bit 7:0,   Alpha antiflick filter0 n1
//Alpha = (line_up * n1 + line_center * n2 + line_dn * n3) / 128
#define GE2D_ANTIFLICK_ALPHA_FILT0                 0x18de
//Bit 31:24, Alpha threhold2, when th1<Alpha<=th2, use filter1;
//Bit 23:16, Alpha antiflick filter1 n3
//Bit 15:8,  Alpha antiflick filter1 n2
//Bit 7:0,   Alpha antiflick filter1 n1
#define GE2D_ANTIFLICK_ALPHA_FILT1                 0x18df
//Bit 31:24, Alpha threhold3, when th2<Alpha<=th3, use filter2; Alpha>th3, use filter3
//Bit 23:16, Alpha antiflick filter2 n3
//Bit 15:8,  Alpha antiflick filter2 n2
//Bit 7:0,   Alpha antiflick filter2 n1
#define GE2D_ANTIFLICK_ALPHA_FILT2                 0x18e0
//Bit 23:16, Alpha antiflick filter3 n3
//Bit 15:8,  Alpha antiflick filter3 n2
//Bit 7:0,   Alpha antiflick filter3 n1
#define GE2D_ANTIFLICK_ALPHA_FILT3                 0x18e1
//dout = clipto_0_255(((din + din_offset) * map_coef + ((1 << (map_sr - 1))) >> map_sr + dout_offset) 
//Bit 30:22 din_offset (signed data)
//Bit 21:14 map_coef (unsigned data)
//Bit 13:10 map_sr (unsigned data)
//Bit 9:1   dout_offset (signed data)
//Bit 0     enable
#define GE2D_SRC1_RANGE_MAP_Y_CTRL                 0x18e3
//dout = clipto_0_255(((din + din_offset) * map_coef + ((1 << (map_sr - 1))) >> map_sr + dout_offset) 
//Bit 30:22 din_offset (signed data)
//Bit 21:14 map_coef (unsigned data)
//Bit 13:10 map_sr (unsigned data)
//Bit 9:1   dout_offset (signed data)
//Bit 0     enable
#define GE2D_SRC1_RANGE_MAP_CB_CTRL                0x18e4
//dout = clipto_0_255(((din + din_offset) * map_coef + ((1 << (map_sr - 1))) >> map_sr + dout_offset) 
//Bit 30:22 din_offset (signed data)
//Bit 21:14 map_coef (unsigned data)
//Bit 13:10 map_sr (unsigned data)
//Bit 9:1   dout_offset (signed data)
//Bit 0     enable
#define GE2D_SRC1_RANGE_MAP_CR_CTRL                0x18e5
//Bit 21:16     src1 prearbitor burst number
//Bit 13:8      src2 prearbitor burst number
//Bit 5:0       dst prearbitor burst number
#define GE2D_ARB_BURST_NUM                         0x18e6
//each 6bit ID, high 4bit are thread ID, low 2bits are the token
//Bit 21:16 src1 ID
//Bit 13:8 src2 ID
//Bit 5:0  dst ID
#define GE2D_TID_TOKEN                             0x18e7
// synopsys translate_off
// synopsys translate_on
//
// Closing file:  ge2d_regs.h
//
//========================================================================
//  MDEC Registers				    (12'h900 - 12'h9ff)
//
//========================================================================
// -----------------------------------------------
// CBUS_BASE:  MDEC_CBUS_BASE = 0x09
// -----------------------------------------------
#define MC_CTRL_REG                                0x0900
#define MC_MB_INFO                                 0x0901
#define MC_PIC_INFO                                0x0902
#define MC_HALF_PEL_ONE                            0x0903
#define MC_HALF_PEL_TWO                            0x0904
#define POWER_CTL_MC                               0x0905
#define MC_CMD                                     0x0906
#define MC_CTRL0                                   0x0907
#define MC_PIC_W_H                                 0x0908
#define MC_STATUS0                                 0x0909
#define MC_STATUS1                                 0x090a
#define MC_CTRL1                                   0x090b
#define MC_MIX_RATIO0                              0x090c
#define MC_MIX_RATIO1                              0x090d
#define MC_DP_MB_XY                                0x090e
#define MC_OM_MB_XY                                0x090f
#define PSCALE_RST                                 0x0910
#define PSCALE_CTRL                                0x0911
#define PSCALE_PICI_W                              0x0912
#define PSCALE_PICI_H                              0x0913
#define PSCALE_PICO_W                              0x0914
#define PSCALE_PICO_H                              0x0915
#define PSCALE_PICO_START_X                        0x0916
#define PSCALE_PICO_START_Y                        0x0917
#define PSCALE_DUMMY                               0x0918
#define PSCALE_FILT0_COEF0                         0x0919
#define PSCALE_FILT0_COEF1                         0x091a
#define PSCALE_CMD_CTRL                            0x091b
#define PSCALE_CMD_BLK_X                           0x091c
#define PSCALE_CMD_BLK_Y                           0x091d
#define PSCALE_STATUS                              0x091e
#define PSCALE_BMEM_ADDR                           0x091f
#define PSCALE_BMEM_DAT                            0x0920
#define PSCALE_DRAM_BUF_CTRL                       0x0921
#define PSCALE_MCMD_CTRL                           0x0922
#define PSCALE_MCMD_XSIZE                          0x0923
#define PSCALE_MCMD_YSIZE                          0x0924
#define PSCALE_RBUF_START_BLKX                     0x0925
#define PSCALE_RBUF_START_BLKY                     0x0926
//`define PSCALE_RBUF_MB_WIDTH   8'h27
#define PSCALE_PICO_SHIFT_XY                       0x0928
#define PSCALE_CTRL1                               0x0929
//Bit 15, wmask enable
//Bit 14:13, filt0 srckey_less, 
//Bit 12:11, filt1 srckey_less, in the case of the interpolated data is equal distance to 
//key data and normal data, 00: select normal data, 01: select right data, 10: select key data
//Bit 10:9, srckey mode, 00: equal, 01: less than or equal, 10: great than or equal
//Bit 8, src key enable
//Bit 7:0, y src key
#define PSCALE_SRCKEY_CTRL0                        0x092a
//Bit 15:8, cb src key
//Bit 7:0, cr src key
#define PSCALE_SRCKEY_CTRL1                        0x092b
//Bit 22:16 canvas_rd_addr2
//Bit 14:8 canvas_rd_addr1
//Bit 6:0 canvas_rd_addr1
#define PSCALE_CANVAS_RD_ADDR                      0x092c
//Bit 22:16 canvas_wr_addr2
//Bit 14:8 canvas_wr_addr1
//Bit 6:0 canvas_wr_addr1
#define PSCALE_CANVAS_WR_ADDR                      0x092d
//bit 13:8 pscale thread ID and token 
//bit 7 disable write response count adding to busy bit 
//bit 5:0  pscale prearbitor burst num
#define PSCALE_CTRL2                               0x092e
#define MC_MPORT_CTRL                              0x0940
#define MC_MPORT_DAT                               0x0941
#define MC_WT_PRED_CTRL                            0x0942
#define MC_MBBOT_ST_EVEN_ADDR                      0x0944
#define MC_MBBOT_ST_ODD_ADDR                       0x0945
#define MC_DPDN_MB_XY                              0x0946
#define MC_OMDN_MB_XY                              0x0947
#define MC_HCMDBUF_H                               0x0948
#define MC_HCMDBUF_L                               0x0949
#define MC_HCMD_H                                  0x094a
#define MC_HCMD_L                                  0x094b
#define MC_IDCT_DAT                                0x094c
#define MC_CTRL_GCLK_CTRL                          0x094d
#define MC_OTHER_GCLK_CTRL                         0x094e
//Bit 29:24, mbbot thread ID and token 
//Bit 21:16, mc read/write thread ID and token 
//Bit 13:8,  mbbot pre-arbitor burst number 
//Bit 5:0,   mc pre-arbitor burst number 
#define MC_CTRL2                                   0x094f
// `define DBLK_QUANT            8'h76 // ONLY for $ucode/real/amrisc/rv.s, reg value from apollo
//`define ANC1_CANVAS_ADDR      8'h80
//`define ANC2_CANVAS_ADDR      8'h81
//`define REC_CANVAS_ADDR       8'h89
//`define MDEC_PIC_W          8'h8c
//`define MDEC_PIC_H          8'h8d
#define MDEC_PIC_DC_CTRL                           0x098e
#define MDEC_PIC_DC_STATUS                         0x098f
#define ANC0_CANVAS_ADDR                           0x0990
#define ANC1_CANVAS_ADDR                           0x0991
#define ANC2_CANVAS_ADDR                           0x0992
#define ANC3_CANVAS_ADDR                           0x0993
#define ANC4_CANVAS_ADDR                           0x0994
#define ANC5_CANVAS_ADDR                           0x0995
#define ANC6_CANVAS_ADDR                           0x0996
#define ANC7_CANVAS_ADDR                           0x0997
#define ANC8_CANVAS_ADDR                           0x0998
#define ANC9_CANVAS_ADDR                           0x0999
#define ANC10_CANVAS_ADDR                          0x099a
#define ANC11_CANVAS_ADDR                          0x099b
#define ANC12_CANVAS_ADDR                          0x099c
#define ANC13_CANVAS_ADDR                          0x099d
#define ANC14_CANVAS_ADDR                          0x099e
#define ANC15_CANVAS_ADDR                          0x099f
#define ANC16_CANVAS_ADDR                          0x09a0
#define ANC17_CANVAS_ADDR                          0x09a1
#define ANC18_CANVAS_ADDR                          0x09a2
#define ANC19_CANVAS_ADDR                          0x09a3
#define ANC20_CANVAS_ADDR                          0x09a4
#define ANC21_CANVAS_ADDR                          0x09a5
#define ANC22_CANVAS_ADDR                          0x09a6
#define ANC23_CANVAS_ADDR                          0x09a7
#define ANC24_CANVAS_ADDR                          0x09a8
#define ANC25_CANVAS_ADDR                          0x09a9
#define ANC26_CANVAS_ADDR                          0x09aa
#define ANC27_CANVAS_ADDR                          0x09ab
#define ANC28_CANVAS_ADDR                          0x09ac
#define ANC29_CANVAS_ADDR                          0x09ad
#define ANC30_CANVAS_ADDR                          0x09ae
#define ANC31_CANVAS_ADDR                          0x09af
#define DBKR_CANVAS_ADDR                           0x09b0
#define DBKW_CANVAS_ADDR                           0x09b1
#define REC_CANVAS_ADDR                            0x09b2
//28:24, read/write, current canvas idx, used in h264 only now
//23:0, read only, current canvas address, 23:16, Cr canvas addr, 15:8, Cb canvas addr, 7:0, Y  canvas addr
#define CURR_CANVAS_CTRL                           0x09b3
#define AV_SCRATCH_0                               0x09c0
#define AV_SCRATCH_1                               0x09c1
#define AV_SCRATCH_2                               0x09c2
#define AV_SCRATCH_3                               0x09c3
#define AV_SCRATCH_4                               0x09c4
#define AV_SCRATCH_5                               0x09c5
#define AV_SCRATCH_6                               0x09c6
#define AV_SCRATCH_7                               0x09c7
#define AV_SCRATCH_8                               0x09c8
#define AV_SCRATCH_9                               0x09c9
#define AV_SCRATCH_A                               0x09ca
#define AV_SCRATCH_B                               0x09cb
#define AV_SCRATCH_C                               0x09cc
#define AV_SCRATCH_D                               0x09cd
#define AV_SCRATCH_E                               0x09ce
#define AV_SCRATCH_F                               0x09cf
#define AV_SCRATCH_G                               0x09d0
#define AV_SCRATCH_H                               0x09d1
#define AV_SCRATCH_I                               0x09d2
#define AV_SCRATCH_J                               0x09d3
#define AV_SCRATCH_K                               0x09d4
#define AV_SCRATCH_L                               0x09d5
#define AV_SCRATCH_M                               0x09d6
#define AV_SCRATCH_N                               0x09d7
// bit[29:24] A_brst_num_co_mb
// bit[21:16] A_id_co_mb
// bit[11:0] wrrsp_count_co_mb
#define WRRSP_CO_MB                                0x09d8
// bit[29:24] A_brst_num_dcac
// bit[21:16] A_id_dcac
// bit[11:0] wrrsp_count_dcac
#define WRRSP_DCAC                                 0x09d9
//======================================
//  MC Control Register Bits
//
//======================================
// For bits, just copy the defines...don't translate to addresses
    #define MC_ENABLE	    0x0001
    //#define MC_RESET	    0x0002
    #define SKIP_MB		    0x0004

//======================================
//  MB Info Register Bits
//
//======================================
    #define INTRA_MB	    0x0001

    #define BWD_PRED	    0x0004
    #define FWD_PRED	    0x0008

    #define FLD_MOT		    0x0100
    #define FRM_16x8_MOT	0x0200
    #define DUAL_PRM_MOT	0x0300

    #define FRM_DCT		    0x0000	    // Bit 10
    #define FLD_DCT		    0x0400

//======================================
//  MB Info Register Bits
//
//======================================
    #define I_PIC		    0x0001
    #define P_PIC		    0x0002
    #define B_PIC		    0x0003
    
    #define FLD_PIC		    0x0000	    // Bit 8
    #define FRM_PIC		    0x0100	    
//========================================================================
// DBLK Register:  12'h950 - 12'h97f 
//========================================================================
#define DBLK_RST                                   0x0950
#define DBLK_CTRL                                  0x0951
#define DBLK_MB_WID_HEIGHT                         0x0952
#define DBLK_STATUS                                0x0953
#define DBLK_CMD_CTRL                              0x0954
#define DBLK_MB_XY                                 0x0955
#define DBLK_QP                                    0x0956
#define DBLK_Y_BHFILT                              0x0957
#define DBLK_Y_BHFILT_HIGH                         0x0958
#define DBLK_Y_BVFILT                              0x0959
#define DBLK_CB_BFILT                              0x095a
#define DBLK_CR_BFILT                              0x095b
#define DBLK_Y_HFILT                               0x095c
#define DBLK_Y_HFILT_HIGH                          0x095d
#define DBLK_Y_VFILT                               0x095e
#define DBLK_CB_FILT                               0x095f
#define DBLK_CR_FILT                               0x0960
#define DBLK_BETAX_QP_SEL                          0x0961
#define DBLK_CLIP_CTRL0                            0x0962
#define DBLK_CLIP_CTRL1                            0x0963
#define DBLK_CLIP_CTRL2                            0x0964
#define DBLK_CLIP_CTRL3                            0x0965
#define DBLK_CLIP_CTRL4                            0x0966
#define DBLK_CLIP_CTRL5                            0x0967
#define DBLK_CLIP_CTRL6                            0x0968
#define DBLK_CLIP_CTRL7                            0x0969
#define DBLK_CLIP_CTRL8                            0x096a
#define DBLK_STATUS1                               0x096b
#define DBLK_GCLK_FREE                             0x096c
#define DBLK_GCLK_OFF                              0x096d
// bit 15:0
#define DBLK_CBPY                                  0x0970
// bit 11:8 -- deblk_cbpy_bottom
// bit 7:4 -- deblk_cbpy_left
// bit 3:0 -- deblk_cbpy_top
#define DBLK_CBPY_ADJ                              0x0971
// bit 7:0 -- deblk_cbpc
#define DBLK_CBPC                                  0x0972
// bit 15 -- bottom_mb
// bit 14 -- left_mb
// bit 13 -- top_mb
// bit 12 -- reserved
// bit 11:8 -- deblk_cbpc_bottom
// bit 7:4 -- deblk_cbpc_left
// bit 3:0 -- deblk_cbpc_top
#define DBLK_CBPC_ADJ                              0x0973
// bit 15:8 -- deblk_hmvd   -- {left_1, left_0, below_1, below_0, block3-0} 
// bit 7:0 -- deblk_vmvd    -- {top_1, top_0, below_1, below_0, block3-0} 
#define DBLK_VHMVD                                 0x0974
// bit 13:12 -- right_vmvd
// bit 11 -- right_above_vmvd
// bit 10 -- left_below_hmvd
// bit 9 -- disable_dblk_luma  
// bit 8 -- disable_dblk_chroma
// bit 7 -- bBelowRefDiff
// bit 6 -- bLeftRefDiff
// bit 5 -- bAboveRefDiff
// bit 4 -- reserved
// bit 3 -- s_below
// bit 2 -- s_left
// bit 1 -- s_above
// bit 0 -- s 
#define DBLK_STRONG                                0x0975
// bit 14:10 -- PQUANT 
// bit 9:5 -- left_PQUANT 
// bit 4:0 -- top_PQUANT 
#define DBLK_RV8_QUANT                             0x0976
#define DBLK_CBUS_HCMD2                            0x0977
#define DBLK_CBUS_HCMD1                            0x0978
#define DBLK_CBUS_HCMD0                            0x0979
#define DBLK_VLD_HCMD2                             0x097a
#define DBLK_VLD_HCMD1                             0x097b
#define DBLK_VLD_HCMD0                             0x097c
#define DBLK_OST_YBASE                             0x097d
#define DBLK_OST_CBCRDIFF                          0x097e
//13:8 dblk thread ID and token 
//5:0  dblk prearbitor burst num
#define DBLK_CTRL1                                 0x097f
//DBLK last address 12'h97f
//========================================================================
//  Video Interface				    (12'ha00 - 12'hb7f)
//
//========================================================================
// NOTE:  The BASE above applies to all of the files below
//
// Reading file:  vregs.h
//
//===========================================================================
// Video Interface Registers    0xa00 - 0xaff
//===========================================================================
// -----------------------------------------------
// CBUS_BASE:  VIU_CBUS_BASE = 0x1a
// -----------------------------------------------
#define VIU_ADDR_START                             0x1a00
#define VIU_ADDR_END                               0x1aff
#define TRACE_REG                                  0x1a08
//------------------------------------------------------------------------------
// OSD1 registers
//------------------------------------------------------------------------------
// Bit    31 Reserved
// Bit    30 RW, enable_free_clk: 1=use free-running clock to drive logics;
//                                0=use gated clock for low power.
// Bit    29 R, test_rd_dsr
// Bit    28 R, osd_done
// Bit 27:24 R, osd_blk_mode
// Bit 23:22 R, osd_blk_ptr
// Bit    21 R, osd_enable
//
// Bit 20:12 RW, global_alpha
// Bit    11 RW, test_rd_en
// Bit 10: 9 Reserved for control signals
// Bit  8: 5 RW, ctrl_mtch_y
// Bit     4 RW, ctrl_422to444
// Bit  3: 0 RW, osd_blk_enable. Bit 0 to enable block 0: 1=enable, 0=disable;
//                               Bit 1 to enable block 1, and so on.
#define VIU_OSD1_CTRL_STAT                         0x1a10
// Bit 31: 4 Reserved
// Bit     3 RW, rgb2yuv_full_range
// Bit     2 RW, alpha_9b_mode
// Bit     1 RW, alpha_expand_mode
// Bit     0 RW, color_expand_mode
#define VIU_OSD1_CTRL_STAT2                        0x1a2d
// Bit 31: 9 Reserved
// Bit     8 RW, 0 = Write LUT, 1 = Read LUT
// Bit  7: 0 RW, lut_addr
#define VIU_OSD1_COLOR_ADDR                        0x1a11
// Bit 31:24 RW, Y or R
// Bit 23:16 RW, Cb or G
// Bit 15: 8 RW, Cr or B
// Bit  7: 0 RW, Alpha
#define VIU_OSD1_COLOR                             0x1a12
// Bit 31:24 RW, Y or R
// Bit 23:16 RW, Cb or G
// Bit 15: 8 RW, Cr or B
// Bit  7: 0 RW, Alpha
#define VIU_OSD1_TCOLOR_AG0                        0x1a17
#define VIU_OSD1_TCOLOR_AG1                        0x1a18
#define VIU_OSD1_TCOLOR_AG2                        0x1a19
#define VIU_OSD1_TCOLOR_AG3                        0x1a1a
// Bit 31:24 Reserved
// Bit 23:16 RW, tbl_addr
// Bit    15 RW, little_endian: 0=big endian, 1=little endian
// Bit    14 RW, rpt_y
// Bit 13:12 RW, interp_ctrl. 0x=No interpolation; 10=Interpolate with previous
//                            pixel; 11=Interpolate with the average value
//                            between previous and next pixel.
// Bit 11: 8 RW, osd_blk_mode
// Bit     7 RW, rgb_en
// Bit     6 RW, tc_alpha_en
// Bit  5: 2 RW, color_matrix
// Bit     1 RW, interlace_en
// Bit     0 RW, interlace_sel_odd
#define VIU_OSD1_BLK0_CFG_W0                       0x1a1b
#define VIU_OSD1_BLK1_CFG_W0                       0x1a1f
#define VIU_OSD1_BLK2_CFG_W0                       0x1a23
#define VIU_OSD1_BLK3_CFG_W0                       0x1a27
// Bit 31:29 Reserved
// Bit 28:16 RW, x_end
// Bit 15:13 Reserved
// Bit 12: 0 RW, x_start
#define VIU_OSD1_BLK0_CFG_W1                       0x1a1c
#define VIU_OSD1_BLK1_CFG_W1                       0x1a20
#define VIU_OSD1_BLK2_CFG_W1                       0x1a24
#define VIU_OSD1_BLK3_CFG_W1                       0x1a28
// Bit 31:29 Reserved
// Bit 28:16 RW, y_end
// Bit 15:13 Reserved
// Bit 12: 0 RW, y_start
#define VIU_OSD1_BLK0_CFG_W2                       0x1a1d
#define VIU_OSD1_BLK1_CFG_W2                       0x1a21
#define VIU_OSD1_BLK2_CFG_W2                       0x1a25
#define VIU_OSD1_BLK3_CFG_W2                       0x1a29
// Bit 31:28 Reserved
// Bit 27:16 RW, h_end
// Bit 15:12 Reserved
// Bit 11: 0 RW, h_start
#define VIU_OSD1_BLK0_CFG_W3                       0x1a1e
#define VIU_OSD1_BLK1_CFG_W3                       0x1a22
#define VIU_OSD1_BLK2_CFG_W3                       0x1a26
#define VIU_OSD1_BLK3_CFG_W3                       0x1a2a
// Bit 31:28 Reserved
// Bit 27:16 RW, v_end
// Bit 15:12 Reserved
// Bit 11: 0 RW, v_start
#define VIU_OSD1_BLK0_CFG_W4                       0x1a13
#define VIU_OSD1_BLK1_CFG_W4                       0x1a14
#define VIU_OSD1_BLK2_CFG_W4                       0x1a15
#define VIU_OSD1_BLK3_CFG_W4                       0x1a16
// Bit    31 Reserved
// Bit    30 RW, byte_swap: In addition to endian control, further define
//               whether to swap upper and lower byte within a 16-bit mem word.
//               0=No swap; 1=Swap data[15:0] to be {data[7:0], data[15:8]}
// Bit 29:21 R,  fifo_count
// Bit 20:19 R,  fifo_st. 0=IDLE, 1=FILL, 2=ABORT 
// Bit    18 R,  fifo_overflow
//
// Bit 17:12 RW, fifo_depth_val, max value=32: set actual fifo depth to fifo_depth_val*8.
// Bit 11:10 RW, burst_len_sel. 0=24(default), 1=32, 2=48, 3=64.
// Bit  9: 5 RW, hold_fifo_lines
// Bit     4 RW, clear_err: one pulse to clear fifo_overflow
// Bit     3 RW, fifo_sync_rst
// Bit  2: 1 RW, endian
// Bit     0 RW, urgent
#define VIU_OSD1_FIFO_CTRL_STAT                    0x1a2b
// Bit 31:24 R, Y or R
// Bit 23:16 R, Cb or G
// Bit 15: 8 R, Cr or B
// Bit  7: 0 R, Output Alpha[8:1]
#define VIU_OSD1_TEST_RDDATA                       0x1a2c
//------------------------------------------------------------------------------
// OSD2 registers
//------------------------------------------------------------------------------
// Bit    31 Reserved
// Bit    30 RW, enable_free_clk: 1=use free-running clock to drive logics;
//                                0=use gated clock for low power.
// Bit    29 R, test_rd_dsr
// Bit    28 R, osd_done
// Bit 27:24 R, osd_blk_mode
// Bit 23:22 R, osd_blk_ptr
// Bit    21 R, osd_enable
//
// Bit 20:12 RW, global_alpha
// Bit    11 RW, test_rd_en
// Bit    10 RW, hl2_en
// Bit     9 RW, hl1_en
// Bit  8: 5 RW, ctrl_mtch_y
// Bit     4 RW, ctrl_422to444
// Bit  3: 0 RW, osd_blk_enable. Bit 0 to enable block 0: 1=enable, 0=disable;
//                               Bit 1 to enable block 1, and so on.
#define VIU_OSD2_CTRL_STAT                         0x1a30
// Bit 31: 4 Reserved
// Bit     3 RW, rgb2yuv_full_range
// Bit     2 RW, alpha_9b_mode
// Bit     1 RW, alpha_expand_mode
// Bit     0 RW, color_expand_mode
#define VIU_OSD2_CTRL_STAT2                        0x1a4d
// Bit 31: 9 Reserved
// Bit     8 RW, 0 = Write LUT, 1 = Read LUT
// Bit  7: 0 RW, lut_addr
#define VIU_OSD2_COLOR_ADDR                        0x1a31
// Bit 31:24 RW, Y or R
// Bit 23:16 RW, Cb or G
// Bit 15: 8 RW, Cr or B
// Bit  7: 0 RW, Alpha
#define VIU_OSD2_COLOR                             0x1a32
// Bit 31:28 Reserved
// Bit 27:16 RW, hl[1-2]_h/v_start
// Bit 15:12 Reserved
// Bit 11: 0 RW, hl[1-2]_h/v_end
#define VIU_OSD2_HL1_H_START_END                   0x1a33
#define VIU_OSD2_HL1_V_START_END                   0x1a34
#define VIU_OSD2_HL2_H_START_END                   0x1a35
#define VIU_OSD2_HL2_V_START_END                   0x1a36
// Bit 31:24 RW, Y or R
// Bit 23:16 RW, Cb or G
// Bit 15: 8 RW, Cr or B
// Bit  7: 0 RW, Alpha
#define VIU_OSD2_TCOLOR_AG0                        0x1a37
#define VIU_OSD2_TCOLOR_AG1                        0x1a38
#define VIU_OSD2_TCOLOR_AG2                        0x1a39
#define VIU_OSD2_TCOLOR_AG3                        0x1a3a
// Bit 31:24 Reserved
// Bit 23:16 RW, tbl_addr
// Bit    15 RW, little_endian: 0=big endian, 1=little endian
// Bit    14 RW, rpt_y
// Bit 13:12 RW, interp_ctrl. 0x=No interpolation; 10=Interpolate with previous
//                            pixel; 11=Interpolate with the average value
//                            between previous and next pixel.
// Bit 11: 8 RW, osd_blk_mode
// Bit     7 RW, rgb_en
// Bit     6 RW, tc_alpha_en
// Bit  5: 2 RW, color_matrix
// Bit     1 RW, interlace_en
// Bit     0 RW, interlace_sel_odd
#define VIU_OSD2_BLK0_CFG_W0                       0x1a3b
#define VIU_OSD2_BLK1_CFG_W0                       0x1a3f
#define VIU_OSD2_BLK2_CFG_W0                       0x1a43
#define VIU_OSD2_BLK3_CFG_W0                       0x1a47
// Bit 31:29 Reserved
// Bit 28:16 RW, x_end
// Bit 15:13 Reserved
// Bit 12: 0 RW, x_start
#define VIU_OSD2_BLK0_CFG_W1                       0x1a3c
#define VIU_OSD2_BLK1_CFG_W1                       0x1a40
#define VIU_OSD2_BLK2_CFG_W1                       0x1a44
#define VIU_OSD2_BLK3_CFG_W1                       0x1a48
// Bit 31:29 Reserved
// Bit 28:16 RW, y_end
// Bit 15:13 Reserved
// Bit 12: 0 RW, y_start
#define VIU_OSD2_BLK0_CFG_W2                       0x1a3d
#define VIU_OSD2_BLK1_CFG_W2                       0x1a41
#define VIU_OSD2_BLK2_CFG_W2                       0x1a45
#define VIU_OSD2_BLK3_CFG_W2                       0x1a49
// Bit 31:28 Reserved
// Bit 27:16 RW, h_end
// Bit 15:12 Reserved
// Bit 11: 0 RW, h_start
#define VIU_OSD2_BLK0_CFG_W3                       0x1a3e
#define VIU_OSD2_BLK1_CFG_W3                       0x1a42
#define VIU_OSD2_BLK2_CFG_W3                       0x1a46
#define VIU_OSD2_BLK3_CFG_W3                       0x1a4a
// Bit 31:28 Reserved
// Bit 27:16 RW, v_end
// Bit 15:12 Reserved
// Bit 11: 0 RW, v_start
#define VIU_OSD2_BLK0_CFG_W4                       0x1a64
#define VIU_OSD2_BLK1_CFG_W4                       0x1a65
#define VIU_OSD2_BLK2_CFG_W4                       0x1a66
#define VIU_OSD2_BLK3_CFG_W4                       0x1a67
// Bit    31 Reserved
// Bit    30 RW, byte_swap: In addition to endian control, further define
//               whether to swap upper and lower byte within a 16-bit mem word.
//               0=No swap; 1=Swap data[15:0] to be {data[7:0], data[15:8]}
// Bit 29:21 R,  fifo_count
// Bit 20:19 R,  fifo_st. 0=IDLE, 1=FILL, 2=ABORT 
// Bit    18 R,  fifo_overflow
//
// Bit 17:12 RW, fifo_depth_val, max value=32: set actual fifo depth to fifo_depth_val*8.
// Bit 11:10 RW, burst_len_sel. 0=24(default), 1=32, 2=48, 3=64.
// Bit  9: 5 RW, hold_fifo_lines
// Bit     4 RW, clear_err: one pulse to clear fifo_overflow
// Bit     3 RW, fifo_sync_rst
// Bit  2: 1 RW, endian
// Bit     0 RW, urgent
#define VIU_OSD2_FIFO_CTRL_STAT                    0x1a4b
// Bit 31:24 R, Y or R
// Bit 23:16 R, Cb or G
// Bit 15: 8 R, Cr or B
// Bit  7: 0 R, Output Alpha[8:1]
#define VIU_OSD2_TEST_RDDATA                       0x1a4c
//------------------------------------------------------------------------------
// VD1 path
//------------------------------------------------------------------------------
#define VD1_IF0_GEN_REG                            0x1a50
    #define VDIF_URGENT_BIT              27
    #define VDIF_CHROMA_END_AT_LAST_LINE (1<<26)
    #define VDIF_LUMA_END_AT_LAST_LINE   (1<<25)
    #define VDIF_HOLD_LINES_BIT          19
    #define VDIF_HOLD_LINES_MASK         0x3f
    #define VDIF_LAST_LINE               (1<<18)
    #define VDIF_BUSY                    (1<<17)
    #define VDIF_DEMUX_MODE              (1<<16)
    #define VDIF_DEMUX_MODE_422          (0<<16)
    #define VDIF_DEMUX_MODE_RGB_444      (1<<16)
    #define VDIF_FORMAT_BIT              14
    #define VDIF_FORMAT_MASK             3
    #define VDIF_FORMAT_SPLIT            (0<<14)
    #define VDIF_FORMAT_422              (1<<14)
    #define VDIF_FORMAT_RGB888_YUV444    (2<<14)
    #define VDIF_BURSTSIZE_MASK          3
    #define VDIF_BURSTSIZE_CR_BIT        12
    #define VDIF_BURSTSIZE_CB_BIT        10
    #define VDIF_BURSTSIZE_Y_BIT         8
    #define VDIF_MANULE_START_FRAME      (1<<7)
    #define VDIF_CHRO_RPT_LAST           (1<<6)
    #define VDIF_CHROMA_HZ_AVG           (1<<3)
    #define VDIF_LUMA_HZ_AVG             (1<<2)
    #define VDIF_SEPARATE_EN             (1<<1)
    #define VDIF_ENABLE                  (1<<0)
#define VD1_IF0_CANVAS0                            0x1a51
#define VD1_IF0_CANVAS1                            0x1a52
    #define VDIF_CANVAS_ADDR_MASK        0x7f
    #define VDIF_CANVAS_ADDR2_BIT        16 
    #define VDIF_CANVAS_ADDR1_BIT        8
    #define VDIF_CANVAS_ADDR0_BIT        0
#define VD1_IF0_LUMA_X0                            0x1a53
#define VD1_IF0_LUMA_Y0                            0x1a54
#define VD1_IF0_CHROMA_X0                          0x1a55
#define VD1_IF0_CHROMA_Y0                          0x1a56
#define VD1_IF0_LUMA_X1                            0x1a57
#define VD1_IF0_LUMA_Y1                            0x1a58
#define VD1_IF0_CHROMA_X1                          0x1a59
#define VD1_IF0_CHROMA_Y1                          0x1a5a
    #define VDIF_PIC_XYMASK              0x7fff
    #define VDIF_PIC_END_BIT             16
    #define VDIF_PIC_START_BIT           0
#define VD1_IF0_RPT_LOOP                           0x1a5b
    #define VDIF_LOOP_MASK              0xff
    #define VDIF_CHROMA_LOOP1_BIT       24
    #define VDIF_LUMA_LOOP1_BIT         16
    #define VDIF_CHROMA_LOOP0_BIT       8
    #define VDIF_LUMA_LOOP0_BIT         0
#define VD1_IF0_LUMA0_RPT_PAT                      0x1a5c
#define VD1_IF0_CHROMA0_RPT_PAT                    0x1a5d
#define VD1_IF0_LUMA1_RPT_PAT                      0x1a5e
#define VD1_IF0_CHROMA1_RPT_PAT                    0x1a5f
#define VD1_IF0_LUMA_PSEL                          0x1a60
    #define VDIF_PSEL_MODE_BIT      26
    #define VDIF_PSEL_MODE_MASK     3
    #define VDIF_PSEL_MODE_PIC0     (0 << 26)
    #define VDIF_PSEL_MODE_PIC1     (1 << 26)
    #define VDIF_PSEL_MODE_PIC01    (2 << 26)
    #define VDIF_PSEL_LAST_LINE1    (1 << 25)
    #define VDIF_PSEL_LAST_LINE0    (1 << 24)
    #define VDIF_PSEL_PAT_BIT       8
    #define VDIF_PSEL_PAT_MASK      0xffff
    #define VDIF_PSEL_LP_MASK       0xf
    #define VDIF_PSEL_LP_START_BIT  4
    #define VDIF_PSEL_LP_END_BIT    0
#define VD1_IF0_CHROMA_PSEL                        0x1a61
#define VD1_IF0_DUMMY_PIXEL                        0x1a62
    #define VDIF_DUMMY_MASK         0xff
    #define VDIF_DUMMY_Y_BIT        24
    #define VDIF_DUMMY_R_BIT        24
    #define VDIF_DUMMY_CB_BIT       16
    #define VDIF_DUMMY_G_BIT        16
    #define VDIF_DUMMY_CR_BIT       8
    #define VDIF_DUMMY_B_BIT        8
#define VD1_IF0_LUMA_FIFO_SIZE                     0x1a63
#define VD1_IF0_RANGE_MAP_Y                        0x1a6a
#define VD1_IF0_RANGE_MAP_CB                       0x1a6b
#define VD1_IF0_RANGE_MAP_CR                       0x1a6c
//Bit 28    if true, horizontal formatter use repeating to generete pixel, otherwise use bilinear interpolation
//Bit 27:24 horizontal formatter initial phase
//Bit 23    horizontal formatter repeat pixel 0 enable
//Bit 22:21 horizontal Y/C ratio, 00: 1:1, 01: 2:1, 10: 4:1
//Bit 20    horizontal formatter enable
//Bit 19    if true, always use phase0 while vertical formater, meaning always
//          repeat data, no interpolation
//Bit 18    if true, disable vertical formatter chroma repeat last line
//Bit 17    veritcal formatter dont need repeat line on phase0, 1: enable, 0: disable
//Bit 16    veritcal formatter repeat line 0 enable
//Bit 15:12 vertical formatter skip line num at the beginning
//Bit 11:8  vertical formatter initial phase
//Bit 7:1   vertical formatter phase step (3.4)  
//Bit 0     vertical formatter enable
#define VIU_VD1_FMT_CTRL                           0x1a68
	#define HFORMATTER_REPEAT		 (1<<28)
	#define HFORMATTER_BILINEAR		 (0<<28)
	#define HFORMATTER_PHASE_MASK    0xf
	#define HFORMATTER_PHASE_BIT	 24
	#define HFORMATTER_RRT_PIXEL0	 (1<<23)
	#define HFORMATTER_YC_RATIO_1_1	 (0<<21)
	#define HFORMATTER_YC_RATIO_2_1	 (1<<21)
	#define HFORMATTER_YC_RATIO_4_1	 (2<<21)
	#define HFORMATTER_EN			 (1<<20)
	#define VFORMATTER_ALWAYS_RPT	 (1<<19)
	#define VFORMATTER_LUMA_RPTLINE0_DE 	(1<<18)
	#define VFORMATTER_CHROMA_RPTLINE0_DE	(1<<17)
	#define VFORMATTER_RPTLINE0_EN	 (1<<16)
	#define VFORMATTER_SKIPLINE_NUM_MASK	0xf
	#define VFORMATTER_SKIPLINE_NUM_BIT		12
    #define VFORMATTER_INIPHASE_MASK        0xf
    #define VFORMATTER_INIPHASE_BIT         8
	#define VFORMATTER_PHASE_MASK	(0x7f)
	#define VFORMATTER_PHASE_BIT	1
	#define VFORMATTER_EN			(1<<0)
//Bit 27:16  horizontal formatter width
//Bit 11:0   vertical formatter width
#define VIU_VD1_FMT_W                              0x1a69
	#define VD1_FMT_LUMA_WIDTH_MASK		0xfff
	#define VD1_FMT_LUMA_WIDTH_BIT		16
	#define VD1_FMT_CHROMA_WIDTH_MASK	0xfff
	#define VD1_FMT_CHROMA_WIDTH_BIT	0
//------------------------------------------------------------------------------
// VD2 path
//------------------------------------------------------------------------------
#define VD2_IF0_GEN_REG                            0x1a70
#define VD2_IF0_CANVAS0                            0x1a71
#define VD2_IF0_CANVAS1                            0x1a72
#define VD2_IF0_LUMA_X0                            0x1a73
#define VD2_IF0_LUMA_Y0                            0x1a74
#define VD2_IF0_CHROMA_X0                          0x1a75
#define VD2_IF0_CHROMA_Y0                          0x1a76
#define VD2_IF0_LUMA_X1                            0x1a77
#define VD2_IF0_LUMA_Y1                            0x1a78
#define VD2_IF0_CHROMA_X1                          0x1a79
#define VD2_IF0_CHROMA_Y1                          0x1a7a
#define VD2_IF0_RPT_LOOP                           0x1a7b
#define VD2_IF0_LUMA0_RPT_PAT                      0x1a7c
#define VD2_IF0_CHROMA0_RPT_PAT                    0x1a7d
#define VD2_IF0_LUMA1_RPT_PAT                      0x1a7e
#define VD2_IF0_CHROMA1_RPT_PAT                    0x1a7f
#define VD2_IF0_LUMA_PSEL                          0x1a80
#define VD2_IF0_CHROMA_PSEL                        0x1a81
#define VD2_IF0_DUMMY_PIXEL                        0x1a82
#define VD2_IF0_LUMA_FIFO_SIZE                     0x1a83
#define VD2_IF0_RANGE_MAP_Y                        0x1a8a
#define VD2_IF0_RANGE_MAP_CB                       0x1a8b
#define VD2_IF0_RANGE_MAP_CR                       0x1a8c
//Bit 28    if true, horizontal formatter use repeating to generete pixel, otherwise use bilinear interpolation
//Bit 27:24 horizontal formatter initial phase
//Bit 23    horizontal formatter repeat pixel 0 enable
//Bit 22:21 horizontal Y/C ratio, 00: 1:1, 01: 2:1, 10: 4:1
//Bit 20    horizontal formatter enable
//Bit 17    veritcal formatter dont need repeat line on phase0, 1: enable, 0: disable
//Bit 16    veritcal formatter repeat line 0 enable
//Bit 15:12 vertical formatter skip line num at the beginning
//Bit 11:8  vertical formatter initial phase
//Bit 7:1   vertical formatter phase step (3.4)  
//Bit 0     vertical formatter enable
#define VIU_VD2_FMT_CTRL                           0x1a88
//Bit 27:16  horizontal formatter width
//Bit 11:0   vertical formatter width
#define VIU_VD2_FMT_W                              0x1a89
//DEINTERLACE module start from 8'h90 end to 8'hff
#define DI_PRE_CTRL                                0x1a90
#define DI_POST_CTRL                               0x1a91
#define DI_POST_SIZE                               0x1a92
#define DI_PRE_SIZE                                0x1a93
#define DI_EI_CTRL0                                0x1a94
#define DI_EI_CTRL1                                0x1a95
#define DI_EI_CTRL2                                0x1a96
#define DI_NRMTN_CTRL0                             0x1a97
#define DI_NR_CTRL1                                0x1a98
#define DI_BLEND_CTRL                              0x1a99
#define DI_BLEND_REG0_X                            0x1a9a
#define DI_BLEND_REG0_Y                            0x1a9b
#define DI_BLEND_REG1_X                            0x1a9c
#define DI_BLEND_REG1_Y                            0x1a9d
#define DI_BLEND_REG2_X                            0x1a9e
#define DI_BLEND_REG2_Y                            0x1a9f
#define DI_BLEND_REG3_X                            0x1aa0
#define DI_BLEND_REG3_Y                            0x1aa1
// DEINTERLACE mode check.
#define DI_MC_REG0_X                               0x1aa2
#define DI_MC_REG0_Y                               0x1aa3
#define DI_MC_REG1_X                               0x1aa4
#define DI_MC_REG1_Y                               0x1aa5
#define DI_MC_REG2_X                               0x1aa6
#define DI_MC_REG2_Y                               0x1aa7
#define DI_MC_REG3_X                               0x1aa8
#define DI_MC_REG3_Y                               0x1aa9
#define DI_MC_REG4_X                               0x1aaa
#define DI_MC_REG4_Y                               0x1aab
#define DI_MC_32LVL0                               0x1aac
#define DI_MC_32LVL1                               0x1aad
#define DI_MC_22LVL0                               0x1aae
#define DI_MC_22LVL1                               0x1aaf
#define DI_MC_22LVL2                               0x1ab0
#define DI_MC_CTRL                                 0x1ab1
#define DI_INTR_CTRL                               0x1ab2
#define DI_INFO_ADDR                               0x1ab3
#define DI_INFO_DATA                               0x1ab4
#define DI_PRE_HOLD                                0x1ab5
#define DI_NRWR_X                                  0x1ac0
#define DI_NRWR_Y                                  0x1ac1
#define DI_NRWR_CTRL                               0x1ac2
#define DI_MTNWR_X                                 0x1ac3
#define DI_MTNWR_Y                                 0x1ac4
#define DI_MTNWR_CTRL                              0x1ac5
#define DI_DIWR_X                                  0x1ac6
#define DI_DIWR_Y                                  0x1ac7
#define DI_DIWR_CTRL                               0x1ac8
#define DI_MTNCRD_X                                0x1ac9
#define DI_MTNCRD_Y                                0x1aca
#define DI_MTNPRD_X                                0x1acb
#define DI_MTNPRD_Y                                0x1acc
#define DI_MTNRD_CTRL                              0x1acd
#define DI_INP_GEN_REG                             0x1ace
#define DI_INP_CANVAS0                             0x1acf
#define DI_INP_LUMA_X0                             0x1ad0
#define DI_INP_LUMA_Y0                             0x1ad1
#define DI_INP_CHROMA_X0                           0x1ad2
#define DI_INP_CHROMA_Y0                           0x1ad3
#define DI_INP_RPT_LOOP                            0x1ad4
#define DI_INP_LUMA0_RPT_PAT                       0x1ad5
#define DI_INP_CHROMA0_RPT_PAT                     0x1ad6
#define DI_INP_DUMMY_PIXEL                         0x1ad7
#define DI_INP_LUMA_FIFO_SIZE                      0x1ad8
#define DI_INP_RANGE_MAP_Y                         0x1aba
#define DI_INP_RANGE_MAP_CB                        0x1abb
#define DI_INP_RANGE_MAP_CR                        0x1abc
#define DI_INP_FMT_CTRL                            0x1ad9
#define DI_INP_FMT_W                               0x1ada
#define DI_MEM_GEN_REG                             0x1adb
#define DI_MEM_CANVAS0                             0x1adc
#define DI_MEM_LUMA_X0                             0x1add
#define DI_MEM_LUMA_Y0                             0x1ade
#define DI_MEM_CHROMA_X0                           0x1adf
#define DI_MEM_CHROMA_Y0                           0x1ae0
#define DI_MEM_RPT_LOOP                            0x1ae1
#define DI_MEM_LUMA0_RPT_PAT                       0x1ae2
#define DI_MEM_CHROMA0_RPT_PAT                     0x1ae3
#define DI_MEM_DUMMY_PIXEL                         0x1ae4
#define DI_MEM_LUMA_FIFO_SIZE                      0x1ae5
#define DI_MEM_RANGE_MAP_Y                         0x1abd
#define DI_MEM_RANGE_MAP_CB                        0x1abe
#define DI_MEM_RANGE_MAP_CR                        0x1abf
#define DI_MEM_FMT_CTRL                            0x1ae6
#define DI_MEM_FMT_W                               0x1ae7
#define DI_IF1_GEN_REG                             0x1ae8
#define DI_IF1_CANVAS0                             0x1ae9
#define DI_IF1_LUMA_X0                             0x1aea
#define DI_IF1_LUMA_Y0                             0x1aeb
#define DI_IF1_CHROMA_X0                           0x1aec
#define DI_IF1_CHROMA_Y0                           0x1aed
#define DI_IF1_RPT_LOOP                            0x1aee
#define DI_IF1_LUMA0_RPT_PAT                       0x1aef
#define DI_IF1_CHROMA0_RPT_PAT                     0x1af0
#define DI_IF1_DUMMY_PIXEL                         0x1af1
#define DI_IF1_LUMA_FIFO_SIZE                      0x1af2
#define DI_IF1_RANGE_MAP_Y                         0x1afc
#define DI_IF1_RANGE_MAP_CB                        0x1afd
#define DI_IF1_RANGE_MAP_CR                        0x1afe
#define DI_IF1_FMT_CTRL                            0x1af3
#define DI_IF1_FMT_W                               0x1af4
#define DI_CHAN2_GEN_REG                           0x1af5
#define DI_CHAN2_CANVAS                            0x1af6
#define DI_CHAN2_LUMA_X                            0x1af7
#define DI_CHAN2_LUMA_Y                            0x1af8
#define DI_CHAN2_RPT_LOOP                          0x1af9
#define DI_CHAN2_LUMA_RPT_PAT                      0x1afa
#define DI_CHAN2_DUMMY_PIXEL                       0x1afb
#define DI_CHAN2_RANGE_MAP_Y                       0x1ab9
//
// Closing file:  vregs.h
//
//
// Reading file:  venc_regs.h
//
//===========================================================================
// Video Interface Registers    0xa00 - 0xbff
//===========================================================================
// -----------------------------------------------
// CBUS_BASE:  VENC_CBUS_BASE = 0x1b
// -----------------------------------------------
// bit 15:8 -- vfifo2vd_vd_sel
// bit 0 -- vfifo2vd_en
#define VFIFO2VD_CTL                               0x1b58
// bit 12:0 -- vfifo2vd_pixel_start 
#define VFIFO2VD_PIXEL_START                       0x1b59
// bit 12:00 -- vfifo2vd_pixel_end   
#define VFIFO2VD_PIXEL_END                         0x1b5a
// bit 10:0 -- vfifo2vd_line_top_start 
#define VFIFO2VD_LINE_TOP_START                    0x1b5b
// bit 10:00 -- vfifo2vd_line_top_end   
#define VFIFO2VD_LINE_TOP_END                      0x1b5c
// bit 10:00 -- vfifo2vd_line_bot_start 
#define VFIFO2VD_LINE_BOT_START                    0x1b5d
// bit 10:00 -- vfifo2vd_line_bot_end   
#define VFIFO2VD_LINE_BOT_END                      0x1b5e
// Route the hsync and vsync signals round the chip. There are three
// sources and users of these signals: VIU, internal video encoder, and
// the pins on the chip. Some muxing is still being done in the VIU. It
// was not moved to the venc module so that the same exact VIU code could
// be used both in Twister and Twister2000.
// Bit 2: venc_sync_source (1=>pins, 0=>viu)
// Bit 1: viu_sync_source (1=>pins, 0=>venc)
// Bit 0: vpins_sync_source (1=>venc, 0=>viu)
#define VENC_SYNC_ROUTE                            0x1b60
#define VENC_VIDEO_EXSRC                           0x1b61
#define VENC_DVI_SETTING                           0x1b62
#define VENC_C656_CTRL                             0x1b63
#define VENC_UPSAMPLE_CTRL0                        0x1b64
#define VENC_UPSAMPLE_CTRL1                        0x1b65
#define VENC_UPSAMPLE_CTRL2                        0x1b66
// Invert control for tcon output
// bit[15:14] -- vsync, hsync, 
// bit[13:0] --  oev3, oev2, cpv2, cph3, cph2, cph1, oeh, vcom, stv2, stv1, cpv1, oev1, sth1, sth2
#define TCON_INVERT_CTL                            0x1b67
#define VENC_VIDEO_PROG_MODE                       0x1b68
//---- Venc pixel/line info
#define VENC_ENCI_LINE                             0x1b69
#define VENC_ENCI_PIXEL                            0x1b6a
#define VENC_ENCP_LINE                             0x1b6b
#define VENC_ENCP_PIXEL                            0x1b6c
//---- Status
#define VENC_STATA                                 0x1b6d
//---- Interrupt setting
#define VENC_INTCTRL                               0x1b6e
#define VENC_INTFLAG                               0x1b6f
//--------- Video test configuration
#define VENC_VIDEO_TST_EN                          0x1b70
#define VENC_VIDEO_TST_MDSEL                       0x1b71
#define VENC_VIDEO_TST_Y                           0x1b72
#define VENC_VIDEO_TST_CB                          0x1b73
#define VENC_VIDEO_TST_CR                          0x1b74
#define VENC_VIDEO_TST_CLRBAR_STRT                 0x1b75
#define VENC_VIDEO_TST_CLRBAR_WIDTH                0x1b76
#define VENC_VIDEO_TST_VDCNT_STSET                 0x1b77
//----- Video dac setting
#define VENC_VDAC_DACSEL0                          0x1b78
#define VENC_VDAC_DACSEL1                          0x1b79
#define VENC_VDAC_DACSEL2                          0x1b7a
#define VENC_VDAC_DACSEL3                          0x1b7b
#define VENC_VDAC_DACSEL4                          0x1b7c
#define VENC_VDAC_DACSEL5                          0x1b7d
#define VENC_VDAC_SETTING                          0x1b7e
#define VENC_VDAC_TST_VAL                          0x1b7f
#define VENC_VDAC_DAC0_GAINCTRL                    0x1bf0
#define VENC_VDAC_DAC0_OFFSET                      0x1bf1
#define VENC_VDAC_DAC1_GAINCTRL                    0x1bf2
#define VENC_VDAC_DAC1_OFFSET                      0x1bf3
#define VENC_VDAC_DAC2_GAINCTRL                    0x1bf4
#define VENC_VDAC_DAC2_OFFSET                      0x1bf5
#define VENC_VDAC_DAC3_GAINCTRL                    0x1bf6
#define VENC_VDAC_DAC3_OFFSET                      0x1bf7
//====== No prgressive venc
//
// Closing file:  venc_regs.h
//
//
// Reading file:  enc480p_regs.h
//
// synopsys translate_off
// synopsys translate_on
//===========================================================================
// Video Encoder 480p Registers    0xb80 - 0xbef
//===========================================================================
//-------- Video basic setting
#define ENCP_VIDEO_EN                              0x1b80
#define ENCP_VIDEO_SYNC_MODE                       0x1b81
#define ENCP_MACV_EN                               0x1b82
#define ENCP_VIDEO_Y_SCL                           0x1b83
#define ENCP_VIDEO_PB_SCL                          0x1b84
#define ENCP_VIDEO_PR_SCL                          0x1b85
#define ENCP_VIDEO_SYNC_SCL                        0x1b86
#define ENCP_VIDEO_MACV_SCL                        0x1b87
#define ENCP_VIDEO_Y_OFFST                         0x1b88
#define ENCP_VIDEO_PB_OFFST                        0x1b89
#define ENCP_VIDEO_PR_OFFST                        0x1b8a
#define ENCP_VIDEO_SYNC_OFFST                      0x1b8b
#define ENCP_VIDEO_MACV_OFFST                      0x1b8c
//----- Video mode
#define ENCP_VIDEO_MODE                            0x1b8d
#define ENCP_VIDEO_MODE_ADV                        0x1b8e
//--------------- Debug pins
#define ENCP_DBG_PX_RST                            0x1b90
#define ENCP_DBG_LN_RST                            0x1b91
#define ENCP_DBG_PX_INT                            0x1b92
#define ENCP_DBG_LN_INT                            0x1b93
//----------- Video Advanced setting
#define ENCP_VIDEO_YFP1_HTIME                      0x1b94
#define ENCP_VIDEO_YFP2_HTIME                      0x1b95
#define ENCP_VIDEO_YC_DLY                          0x1b96
#define ENCP_VIDEO_MAX_PXCNT                       0x1b97
#define ENCP_VIDEO_HSPULS_BEGIN                    0x1b98
#define ENCP_VIDEO_HSPULS_END                      0x1b99
#define ENCP_VIDEO_HSPULS_SWITCH                   0x1b9a
#define ENCP_VIDEO_VSPULS_BEGIN                    0x1b9b
#define ENCP_VIDEO_VSPULS_END                      0x1b9c
#define ENCP_VIDEO_VSPULS_BLINE                    0x1b9d
#define ENCP_VIDEO_VSPULS_ELINE                    0x1b9e
#define ENCP_VIDEO_EQPULS_BEGIN                    0x1b9f
#define ENCP_VIDEO_EQPULS_END                      0x1ba0
#define ENCP_VIDEO_EQPULS_BLINE                    0x1ba1
#define ENCP_VIDEO_EQPULS_ELINE                    0x1ba2
#define ENCP_VIDEO_HAVON_END                       0x1ba3
#define ENCP_VIDEO_HAVON_BEGIN                     0x1ba4
#define ENCP_VIDEO_VAVON_ELINE                     0x1baf
#define ENCP_VIDEO_VAVON_BLINE                     0x1ba6
#define ENCP_VIDEO_HSO_BEGIN                       0x1ba7
#define ENCP_VIDEO_HSO_END                         0x1ba8
#define ENCP_VIDEO_VSO_BEGIN                       0x1ba9
#define ENCP_VIDEO_VSO_END                         0x1baa
#define ENCP_VIDEO_VSO_BLINE                       0x1bab
#define ENCP_VIDEO_VSO_ELINE                       0x1bac
#define ENCP_VIDEO_SYNC_WAVE_CURVE                 0x1bad
#define ENCP_VIDEO_MAX_LNCNT                       0x1bae
#define ENCP_VIDEO_SY_VAL                          0x1bb0
#define ENCP_VIDEO_SY2_VAL                         0x1bb1
#define ENCP_VIDEO_BLANKY_VAL                      0x1bb2
#define ENCP_VIDEO_BLANKPB_VAL                     0x1bb3
#define ENCP_VIDEO_BLANKPR_VAL                     0x1bb4
#define ENCP_VIDEO_HOFFST                          0x1bb5
#define ENCP_VIDEO_VOFFST                          0x1bb6
#define ENCP_VIDEO_RGB_CTRL                        0x1bb7
#define ENCP_VIDEO_FILT_CTRL                       0x1bb8
#define ENCP_VIDEO_OFLD_VPEQ_OFST                  0x1bb9
#define ENCP_VIDEO_OFLD_VOAV_OFST                  0x1bba
#define ENCP_VIDEO_MATRIX_CB                       0x1bbb
#define ENCP_VIDEO_MATRIX_CR                       0x1bbc
#define ENCP_VIDEO_RGBIN_CTRL                      0x1bbd
//------------------Macrovision advanced setting
#define ENCP_MACV_BLANKY_VAL                       0x1bc0
#define ENCP_MACV_MAXY_VAL                         0x1bc1
#define ENCP_MACV_1ST_PSSYNC_STRT                  0x1bc2
#define ENCP_MACV_PSSYNC_STRT                      0x1bc3
#define ENCP_MACV_AGC_STRT                         0x1bc4
#define ENCP_MACV_AGC_END                          0x1bc5
#define ENCP_MACV_WAVE_END                         0x1bc6
#define ENCP_MACV_STRTLINE                         0x1bc7
#define ENCP_MACV_ENDLINE                          0x1bc8
#define ENCP_MACV_TS_CNT_MAX_L                     0x1bc9
#define ENCP_MACV_TS_CNT_MAX_H                     0x1bca
#define ENCP_MACV_TIME_DOWN                        0x1bcb
#define ENCP_MACV_TIME_LO                          0x1bcc
#define ENCP_MACV_TIME_UP                          0x1bcd
#define ENCP_MACV_TIME_RST                         0x1bce
//---------------- VBI control -------------------
#define ENCP_VBI_CTRL                              0x1bd0
#define ENCP_VBI_SETTING                           0x1bd1
#define ENCP_VBI_BEGIN                             0x1bd2
#define ENCP_VBI_WIDTH                             0x1bd3
#define ENCP_VBI_HVAL                              0x1bd4
#define ENCP_VBI_DATA0                             0x1bd5
#define ENCP_VBI_DATA1                             0x1bd6
//----------------C656 OUT Control------------- Grant
#define C656_HS_ST                                 0x1be0
#define C656_HS_ED                                 0x1be1
#define C656_VS_LNST_E                             0x1be2
#define C656_VS_LNST_O                             0x1be3
#define C656_VS_LNED_E                             0x1be4
#define C656_VS_LNED_O                             0x1be5
#define C656_FS_LNST                               0x1be6
#define C656_FS_LNED                               0x1be7
// synopsys translate_off
// synopsys translate_on
//
// Closing file:  enc480p_regs.h
//
//
// Reading file:  enci_regs.h
//
//===========================================================================
// Video Interface Registers    0xb00 - 0xb57
//===========================================================================
#define ENCI_VIDEO_MODE                            0x1b00
#define ENCI_VIDEO_MODE_ADV                        0x1b01
#define ENCI_VIDEO_FSC_ADJ                         0x1b02
#define ENCI_VIDEO_BRIGHT                          0x1b03
#define ENCI_VIDEO_CONT                            0x1b04
#define ENCI_VIDEO_SAT                             0x1b05
#define ENCI_VIDEO_HUE                             0x1b06
#define ENCI_VIDEO_SCH                             0x1b07
#define ENCI_SYNC_MODE                             0x1b08
#define ENCI_SYNC_CTRL                             0x1b09
#define ENCI_SYNC_HSO_BEGIN                        0x1b0a
#define ENCI_SYNC_HSO_END                          0x1b0b
#define ENCI_SYNC_VSO_EVN                          0x1b0c
#define ENCI_SYNC_VSO_ODD                          0x1b0d
#define ENCI_SYNC_VSO_EVNLN                        0x1b0e
#define ENCI_SYNC_VSO_ODDLN                        0x1b0f
#define ENCI_SYNC_HOFFST                           0x1b10
#define ENCI_SYNC_VOFFST                           0x1b11
#define ENCI_SYNC_ADJ                              0x1b12
#define ENCI_RGB_SETTING                           0x1b13
//`define	ENCI_CMPN_MATRIX_CB		8'h14
//`define	ENCI_CMPN_MATRIX_CR		8'h15
#define ENCI_DE_H_BEGIN                            0x1b16
#define ENCI_DE_H_END                              0x1b17
#define ENCI_DE_V_BEGIN_EVEN                       0x1b18
#define ENCI_DE_V_END_EVEN                         0x1b19
#define ENCI_DE_V_BEGIN_ODD                        0x1b1a
#define ENCI_DE_V_END_ODD                          0x1b1b
#define ENCI_VBI_SETTING                           0x1b20
#define ENCI_VBI_CCDT_EVN                          0x1b21
#define ENCI_VBI_CCDT_ODD                          0x1b22
#define ENCI_VBI_CC525_LN                          0x1b23
#define ENCI_VBI_CC625_LN                          0x1b24
#define ENCI_VBI_WSSDT                             0x1b25
#define ENCI_VBI_WSS_LN                            0x1b26
#define ENCI_VBI_CGMSDT_L                          0x1b27
#define ENCI_VBI_CGMSDT_H                          0x1b28
#define ENCI_VBI_CGMS_LN                           0x1b29
#define ENCI_VBI_TTX_HTIME                         0x1b2a
#define ENCI_VBI_TTX_LN                            0x1b2b
#define ENCI_VBI_TTXDT0                            0x1b2c
#define ENCI_VBI_TTXDT1                            0x1b2d
#define ENCI_VBI_TTXDT2                            0x1b2e
#define ENCI_VBI_TTXDT3                            0x1b2f
#define ENCI_MACV_N0                               0x1b30
#define ENCI_MACV_N1                               0x1b31
#define ENCI_MACV_N2                               0x1b32
#define ENCI_MACV_N3                               0x1b33
#define ENCI_MACV_N4                               0x1b34
#define ENCI_MACV_N5                               0x1b35
#define ENCI_MACV_N6                               0x1b36
#define ENCI_MACV_N7                               0x1b37
#define ENCI_MACV_N8                               0x1b38
#define ENCI_MACV_N9                               0x1b39
#define ENCI_MACV_N10                              0x1b3a
#define ENCI_MACV_N11                              0x1b3b
#define ENCI_MACV_N12                              0x1b3c
#define ENCI_MACV_N13                              0x1b3d
#define ENCI_MACV_N14                              0x1b3e
#define ENCI_MACV_N15                              0x1b3f
#define ENCI_MACV_N16                              0x1b40
#define ENCI_MACV_N17                              0x1b41
#define ENCI_MACV_N18                              0x1b42
#define ENCI_MACV_N19                              0x1b43
#define ENCI_MACV_N20                              0x1b44
#define ENCI_MACV_N21                              0x1b45
#define ENCI_MACV_N22                              0x1b46
//`define	ENCI_MACV_P_AGC			8'h47
#define ENCI_DBG_PX_RST                            0x1b48
#define ENCI_DBG_FLDLN_RST                         0x1b49
#define ENCI_DBG_PX_INT                            0x1b4a
#define ENCI_DBG_FLDLN_INT                         0x1b4b
#define ENCI_DBG_MAXPX                             0x1b4c
#define ENCI_DBG_MAXLN                             0x1b4d
#define ENCI_MACV_MAX_AMP                          0x1b50
#define ENCI_MACV_PULSE_LO                         0x1b51
#define ENCI_MACV_PULSE_HI                         0x1b52
#define ENCI_MACV_BKP_MAX                          0x1b53
#define ENCI_CFILT_CTRL                            0x1b54
#define ENCI_CFILT7                                0x1b55
#define ENCI_YC_DELAY                              0x1b56
#define ENCI_VIDEO_EN                              0x1b57
//
// Closing file:  enci_regs.h
//
//
// Reading file:  venc2_regs.h
//
//===========================================================================
// Venc Registers (Cont.)    0xc00 - 0xcff
//===========================================================================
// -----------------------------------------------
// CBUS_BASE:  VENC2_CBUS_BASE = 0x1c
// -----------------------------------------------
// Program video control signals from ENCI core to DVI/HDMI interface
#define ENCI_DVI_HSO_BEGIN                         0x1c00
#define ENCI_DVI_HSO_END                           0x1c01
#define ENCI_DVI_VSO_BLINE_EVN                     0x1c02
#define ENCI_DVI_VSO_BLINE_ODD                     0x1c03
#define ENCI_DVI_VSO_ELINE_EVN                     0x1c04
#define ENCI_DVI_VSO_ELINE_ODD                     0x1c05
#define ENCI_DVI_VSO_BEGIN_EVN                     0x1c06
#define ENCI_DVI_VSO_BEGIN_ODD                     0x1c07
#define ENCI_DVI_VSO_END_EVN                       0x1c08
#define ENCI_DVI_VSO_END_ODD                       0x1c09
// Define cmpt and cvbs cb/cr delay after ENCI chroma filters
// Bit 15:12 RW, enci_cb_cvbs_dly_sel. 0=no delay; 1~6=delay by 1~6 clk; 7~15 reserved.
// Bit 11: 8 RW, enci_cr_cvbs_dly_sel. 0=no delay; 1~6=delay by 1~6 clk; 7~15 reserved.
// Bit  7: 4 RW, enci_cb_cmpt_dly_sel. 0=no delay; 1~6=delay by 1~6 clk; 7~15 reserved.
// Bit  3: 0 RW, enci_cr_cmpt_dly_sel. 0=no delay; 1~6=delay by 1~6 clk; 7~15 reserved.
#define ENCI_CFILT_CTRL2                           0x1c0a
// Program video control signals from ENCP core to DVI/HDMI interface
#define ENCP_DVI_HSO_BEGIN                         0x1c40
#define ENCP_DVI_HSO_END                           0x1c41
#define ENCP_DVI_VSO_BLINE_EVN                     0x1c42
#define ENCP_DVI_VSO_BLINE_ODD                     0x1c43
#define ENCP_DVI_VSO_ELINE_EVN                     0x1c44
#define ENCP_DVI_VSO_ELINE_ODD                     0x1c45
#define ENCP_DVI_VSO_BEGIN_EVN                     0x1c46
#define ENCP_DVI_VSO_BEGIN_ODD                     0x1c47
#define ENCP_DVI_VSO_END_EVN                       0x1c48
#define ENCP_DVI_VSO_END_ODD                       0x1c49
#define ENCP_DE_H_BEGIN                            0x1c4a
#define ENCP_DE_H_END                              0x1c4b
#define ENCP_DE_V_BEGIN_EVEN                       0x1c4c
#define ENCP_DE_V_END_EVEN                         0x1c4d
#define ENCP_DE_V_BEGIN_ODD                        0x1c4e
#define ENCP_DE_V_END_ODD                          0x1c4f
// bit    3 cfg_encp_lcd_scaler_bypass. 1=Do not scale LCD input data;
//                                      0=Scale LCD input data to y [16*4,235*4], c [16*4,240*4].
// bit    2 cfg_encp_vadj_scaler_bypass. 1=Do not scale data to enc480p_vadj;
//                                       0=Scale enc480p_vadj input data to y [16*4,235*4], c [16*4,240*4].
// bit    1 cfg_vfifo2vd_out_scaler_bypass. 1=Do not scale vfifo2vd's output vdata;
//                                          0=Scale vfifo2vd's output vdata to y [16,235], c [16,240].
// bit    0 cfg_vfifo_din_full_range. 1=Data from viu fifo is full range [0,1023];
//                                    0=Data from viu fifo is y [16*4,235*4], c [16*4,240*4].

//===========================================================================
// ENCT registers
#define ENCT_VIDEO_EN                              0x1c60

//----- Video mode
#define ENCT_VIDEO_MODE                            0x1c67
#define ENCT_VIDEO_MODE_ADV                        0x1c68

//----------- Video Advanced setting
#define ENCT_VIDEO_MAX_PXCNT                       0x1c70
#define ENCT_VIDEO_HAVON_END                       0x1c71
#define ENCT_VIDEO_HAVON_BEGIN                     0x1c72
#define ENCT_VIDEO_VAVON_ELINE                     0x1c73
#define ENCT_VIDEO_VAVON_BLINE                     0x1c74
#define ENCT_VIDEO_HSO_BEGIN                       0x1c75
#define ENCT_VIDEO_HSO_END                         0x1c76
#define ENCT_VIDEO_VSO_BEGIN                       0x1c77
#define ENCT_VIDEO_VSO_END                         0x1c78
#define ENCT_VIDEO_VSO_BLINE                       0x1c79
#define ENCT_VIDEO_VSO_ELINE                       0x1c7a

#define ENCT_VIDEO_MAX_LNCNT                       0x1c7b


#define VENC_VFIFO2VD_CTL2                         0x1c80
// bit 15:1 Reserved.
// bit    0 cfg_int_dvi_sel_rgb. Applicable for using on-chip hdmi tx module only. This bit controls correct bit-mapping from
//          Venc to hdmi_tx depending on whether YCbCr or RGB mode.
//                               1=Map data bit from Venc to hdmi_tx for RGB mode;
//                               0=Default. Map data bit from Venc to hdmi_tx for YCbCr mode.
#define VENC_DVI_SETTING_MORE                      0x1c81
//Bit 0   filter_en
#define ENCT_VIDEO_FILT_CTRL                       0x1c82
#define VENC_VDAC_DAC0_FILT_CTRL0                  0x1c88
//dout = ((din + din_d2) * coef1 + (din_d1 * coef0) + 32) >> 6
//Bit 15:8, coef1,
//Bit 7:0, coef0, 
#define VENC_VDAC_DAC0_FILT_CTRL1                  0x1c89
//Bit 0   filter_en
#define VENC_VDAC_DAC1_FILT_CTRL0                  0x1c8a
//dout = ((din + din_d2) * coef1 + (din_d1 * coef0) + 32) >> 6
//Bit 15:8, coef1,
//Bit 7:0, coef0, 
#define VENC_VDAC_DAC1_FILT_CTRL1                  0x1c8b
//Bit 0   filter_en
#define VENC_VDAC_DAC2_FILT_CTRL0                  0x1c8c
//dout = ((din + din_d2) * coef1 + (din_d1 * coef0) + 32) >> 6
//Bit 15:8, coef1,
//Bit 7:0, coef0, 
#define VENC_VDAC_DAC2_FILT_CTRL1                  0x1c8d
//Bit 0   filter_en
#define VENC_VDAC_DAC3_FILT_CTRL0                  0x1c8e
//dout = ((din + din_d2) * coef1 + (din_d1 * coef0) + 32) >> 6
//Bit 15:8, coef1,
//Bit 7:0, coef0, 
#define VENC_VDAC_DAC3_FILT_CTRL1                  0x1c8f
//
// Closing file:  venc2_regs.h
//
//
// Reading file:  lcd_regs.h
//
// -----------------------------------------------
// CBUS_BASE:  LCD_CBUS_BASE = 0x14
// -----------------------------------------------
//========================================================================
//LCD DRV     12'h480~12'h4ef
//=======================================================================
#define L_GAMMA_CNTL_PORT                          0x1400
#define L_GAMMA_DATA_PORT                          0x1401
#define L_GAMMA_ADDR_PORT                          0x1402
#define L_GAMMA_VCOM_HSWITCH_ADDR                  0x1403
#define L_RGB_BASE_ADDR                            0x1405
#define L_RGB_COEFF_ADDR                           0x1406
#define L_POL_CNTL_ADDR                            0x1407
#define L_DITH_CNTL_ADDR                           0x1408
#define L_STH1_HS_ADDR                             0x1410
#define L_STH1_HE_ADDR                             0x1411
#define L_STH1_VS_ADDR                             0x1412
#define L_STH1_VE_ADDR                             0x1413
#define L_STH2_HS_ADDR                             0x1414
#define L_STH2_HE_ADDR                             0x1415
#define L_STH2_VS_ADDR                             0x1416
#define L_STH2_VE_ADDR                             0x1417
#define L_OEH_HS_ADDR                              0x1418
#define L_OEH_HE_ADDR                              0x1419
#define L_OEH_VS_ADDR                              0x141a
#define L_OEH_VE_ADDR                              0x141b
#define L_VCOM_HSWITCH_ADDR                        0x141c
#define L_VCOM_VS_ADDR                             0x141d
#define L_VCOM_VE_ADDR                             0x141e
#define L_CPV1_HS_ADDR                             0x141f
#define L_CPV1_HE_ADDR                             0x1420
#define L_CPV1_VS_ADDR                             0x1421
#define L_CPV1_VE_ADDR                             0x1422
#define L_CPV2_HS_ADDR                             0x1423
#define L_CPV2_HE_ADDR                             0x1424
#define L_CPV2_VS_ADDR                             0x1425
#define L_CPV2_VE_ADDR                             0x1426
#define L_STV1_HS_ADDR                             0x1427
#define L_STV1_HE_ADDR                             0x1428
#define L_STV1_VS_ADDR                             0x1429
#define L_STV1_VE_ADDR                             0x142a
#define L_STV2_HS_ADDR                             0x142b
#define L_STV2_HE_ADDR                             0x142c
#define L_STV2_VS_ADDR                             0x142d
#define L_STV2_VE_ADDR                             0x142e
#define L_OEV1_HS_ADDR                             0x142f
#define L_OEV1_HE_ADDR                             0x1430
#define L_OEV1_VS_ADDR                             0x1431
#define L_OEV1_VE_ADDR                             0x1432
#define L_OEV2_HS_ADDR                             0x1433
#define L_OEV2_HE_ADDR                             0x1434
#define L_OEV2_VS_ADDR                             0x1435
#define L_OEV2_VE_ADDR                             0x1436
#define L_OEV3_HS_ADDR                             0x1437
#define L_OEV3_HE_ADDR                             0x1438
#define L_OEV3_VS_ADDR                             0x1439
#define L_OEV3_VE_ADDR                             0x143a
#define L_LCD_PWR_ADDR                             0x143b
#define L_LCD_PWM0_LO_ADDR                         0x143c
#define L_LCD_PWM0_HI_ADDR                         0x143d
#define L_LCD_PWM1_LO_ADDR                         0x143e
#define L_LCD_PWM1_HI_ADDR                         0x143f
#define L_INV_CNT_ADDR                             0x1440
#define L_TCON_MISC_SEL_ADDR                       0x1441
#define L_DUAL_PORT_CNTL_ADDR                      0x1442
#define L_TCON_DOUBLE_CTL                          0x1449
#define L_TCON_PATTERN_HI                          0x144a
#define L_TCON_PATTERN_LO                          0x144b
#define L_DE_HS_ADDR                               0x1451
#define L_DE_HE_ADDR                               0x1452
#define L_DE_VS_ADDR                               0x1453
#define L_DE_VE_ADDR                               0x1454
#define L_HSYNC_HS_ADDR                            0x1455
#define L_HSYNC_HE_ADDR                            0x1456
#define L_HSYNC_VS_ADDR                            0x1457
#define L_HSYNC_VE_ADDR                            0x1458
#define L_VSYNC_HS_ADDR                            0x1459
#define L_VSYNC_HE_ADDR                            0x145a
#define L_VSYNC_VS_ADDR                            0x145b
#define L_VSYNC_VE_ADDR                            0x145c
// bit 8 -- vfifo_mcu_enable
// bit 7 -- halt_vs_de
// bit 6 -- R8G8B8_format
// bit 5 -- R6G6B6_format (round to 6 bits)
// bit 4 -- R5G6B5_format
// bit 3 -- dac_dith_sel
// bit 2 -- lcd_mcu_enable_de     -- ReadOnly
// bit 1 -- lcd_mcu_enable_vsync  -- ReadOnly
// bit 0 -- lcd_mcu_enable
#define L_LCD_MCU_CTL                              0x145d
//**************************************************************************
//*  NOTE::    When Programming the Gamma, please turn off the IRQ service *
//**************************************************************************
#define GAMMA_CNTL_PORT                            0x1480
   #define  GAMMA_VCOM_POL    7     //RW
   #define  GAMMA_RVS_OUT     6     //RW
   #define  ADR_RDY           5     //Read Only
   #define  WR_RDY            4     //Read Only
   #define  RD_RDY            3     //Read Only
   #define  GAMMA_TR          2     //RW
   #define  GAMMA_SET         1     //RW
   #define  GAMMA_EN          0     //RW
#define GAMMA_DATA_PORT                            0x1481
#define GAMMA_ADDR_PORT                            0x1482
   #define  H_RD              12
   #define  H_AUTO_INC        11
   #define  H_SEL_R           10
   #define  H_SEL_G           9
   #define  H_SEL_B           8
   #define  HADR_MSB          7            //7:0
   #define  HADR              0            //7:0
#define GAMMA_VCOM_HSWITCH_ADDR                    0x1483
#define RGB_BASE_ADDR                              0x1485
#define RGB_COEFF_ADDR                             0x1486
#define POL_CNTL_ADDR                              0x1487
   #define   DCLK_SEL             14    //FOR DCLK OUTPUT
   #define   TCON_VSYNC_SEL_DVI   11    //FOR RGB format DVI output
   #define   TCON_HSYNC_SEL_DVI   10    //FOR RGB format DVI output
   #define   TCON_DE_SEL_DVI      9     //FOR RGB format DVI output
   #define   CPH3_POL         8
   #define   CPH2_POL         7
   #define   CPH1_POL         6
   #define   TCON_DE_SEL      5
   #define   TCON_VS_SEL      4
   #define   TCON_HS_SEL      3
   #define   DE_POL           2
   #define   VS_POL           1
   #define   HS_POL           0
#define DITH_CNTL_ADDR                             0x1488
   #define  DITH10_EN         10
   #define  DITH8_EN          9
   #define  DITH_MD           8
   #define  DITH10_CNTL_MSB   7          //7:4
   #define  DITH10_CNTL       4          //7:4
   #define  DITH8_CNTL_MSB    3          //3:0
   #define  DITH8_CNTL        0          //3:0
#define STH1_HS_ADDR                               0x1490
#define STH1_HE_ADDR                               0x1491
#define STH1_VS_ADDR                               0x1492
#define STH1_VE_ADDR                               0x1493
#define STH2_HS_ADDR                               0x1494
#define STH2_HE_ADDR                               0x1495
#define STH2_VS_ADDR                               0x1496
#define STH2_VE_ADDR                               0x1497
#define OEH_HS_ADDR                                0x1498
#define OEH_HE_ADDR                                0x1499
#define OEH_VS_ADDR                                0x149a
#define OEH_VE_ADDR                                0x149b
#define VCOM_HSWITCH_ADDR                          0x149c
#define VCOM_VS_ADDR                               0x149d
#define VCOM_VE_ADDR                               0x149e
#define CPV1_HS_ADDR                               0x149f
#define CPV1_HE_ADDR                               0x14a0
#define CPV1_VS_ADDR                               0x14a1
#define CPV1_VE_ADDR                               0x14a2
#define CPV2_HS_ADDR                               0x14a3
#define CPV2_HE_ADDR                               0x14a4
#define CPV2_VS_ADDR                               0x14a5
#define CPV2_VE_ADDR                               0x14a6
#define STV1_HS_ADDR                               0x14a7
#define STV1_HE_ADDR                               0x14a8
#define STV1_VS_ADDR                               0x14a9
#define STV1_VE_ADDR                               0x14aa
#define STV2_HS_ADDR                               0x14ab
#define STV2_HE_ADDR                               0x14ac
#define STV2_VS_ADDR                               0x14ad
#define STV2_VE_ADDR                               0x14ae
#define OEV1_HS_ADDR                               0x14af
#define OEV1_HE_ADDR                               0x14b0
#define OEV1_VS_ADDR                               0x14b1
#define OEV1_VE_ADDR                               0x14b2
#define OEV2_HS_ADDR                               0x14b3
#define OEV2_HE_ADDR                               0x14b4
#define OEV2_VS_ADDR                               0x14b5
#define OEV2_VE_ADDR                               0x14b6
#define OEV3_HS_ADDR                               0x14b7
#define OEV3_HE_ADDR                               0x14b8
#define OEV3_VS_ADDR                               0x14b9
#define OEV3_VE_ADDR                               0x14ba
#define LCD_PWR_ADDR                               0x14bb
#define LCD_VDD                                    0x1405
#define LCD_VBL                                    0x1404
#define LCD_GPI_MSB                                0x1403
#define LCD_GPIO                                   0x1400
#define LCD_PWM0_LO_ADDR                           0x14bc
#define LCD_PWM0_HI_ADDR                           0x14bd
#define LCD_PWM1_LO_ADDR                           0x14be
#define LCD_PWM1_HI_ADDR                           0x14bf
#define INV_CNT_ADDR                               0x14c0
   #define     INV_EN          4
   #define     INV_CNT_MSB     3
   #define     INV_CNT         0
#define TCON_MISC_SEL_ADDR                         0x14c1
   #define     STH2_SEL        12
   #define     STH1_SEL        11
   #define     OEH_SEL         10
   #define     VCOM_SEL         9
   #define     DB_LINE_SW       8
   #define     CPV2_SEL         7
   #define     CPV1_SEL         6
   #define     STV2_SEL         5
   #define     STV1_SEL         4
   #define     OEV_UNITE        3
   #define     OEV3_SEL         2
   #define     OEV2_SEL         1
   #define     OEV1_SEL         0
#define DUAL_PORT_CNTL_ADDR                        0x14c2
   #define     OUTPUT_YUV       15
   #define     DUAL_IDF         12   // 14:12
   #define     DUAL_ISF         9    // 11:9
   #define     LCD_ANALOG_SEL_CPH3   8
   #define     LCD_ANALOG_3PHI_CLK_SEL   7
   #define     LCD_LVDS_SEL54   6
   #define     LCD_LVDS_SEL27   5
   #define     LCD_TTL_SEL      4
   #define     DUAL_LVDC_EN     3
   #define     PORT_SWP         2
   #define     RGB_SWP          1
   #define     BIT_SWP          0
#define LVDS_CLK_CNTL                              0x14c3
#define LVDS_PHY_CNTL0                             0x14c4
#define LVDS_PHY_CNTL1                             0x14c5
#define LVDS_PHY_CNTL2                             0x14c6
#define LVDS_PHY_CNTL3                             0x14c7
#define LVDS_SRG_TEST                              0x14c8
#define LVDS_BIST_MUX0                             0x14c9
#define LVDS_BIST_MUX1                             0x14ca
#define LVDS_BIST_FIXED0                           0x14cb
#define LVDS_BIST_FIXED1                           0x14cc
#define LVDS_BIST_CNTL0                            0x14cd
#define LVDS_CLKB_CLKA                             0x14ce
#define LVDS_GEN_CTNL                              0x14cf
#define LVDS_PACK_CNTL_ADDR                        0x14d0
   #define     LVDS_USE_TCON    7
   #define     LVDS_DUAL        6
   #define     PN_SWP           5
   #define     LSB_FIRST        4
   #define     LVDS_RESV        3
   #define     ODD_EVEN_SWP     2
   #define     LVDS_REPACK      0
#define DE_HS_ADDR                                 0x14d1
#define DE_HE_ADDR                                 0x14d2
#define DE_VS_ADDR                                 0x14d3
#define DE_VE_ADDR                                 0x14d4
#define HSYNC_HS_ADDR                              0x14d5
#define HSYNC_HE_ADDR                              0x14d6
#define HSYNC_VS_ADDR                              0x14d7
#define HSYNC_VE_ADDR                              0x14d8
#define VSYNC_HS_ADDR                              0x14d9
#define VSYNC_HE_ADDR                              0x14da
#define VSYNC_VS_ADDR                              0x14db
#define VSYNC_VE_ADDR                              0x14dc
// bit 8 -- vfifo_mcu_enable
// bit 7 -- halt_vs_de
// bit 6 -- R8G8B8_format
// bit 5 -- R6G6B6_format (round to 6 bits)
// bit 4 -- R5G6B5_format
// bit 3 -- dac_dith_sel
// bit 2 -- lcd_mcu_enable_de     -- ReadOnly
// bit 1 -- lcd_mcu_enable_vsync  -- ReadOnly
// bit 0 -- lcd_mcu_enable
#define LCD_MCU_CTL                                0x14dd
// ReadOnly 
//   R5G6B5 when R5G6B5_format
//   G8R8   when R8G8B8_format
//   G5R10  Other
#define LCD_MCU_DATA_0                             0x14de
// ReadOnly
//   G8B8   when R8G8B8_format
//   G5B10  Other
#define LCD_MCU_DATA_1                             0x14df
//===============================================================
//LCD DRIVER BASE   END
//===============================================================
//
// Closing file:  lcd_regs.h
//
//======================================================================
//   vpu  register.
//======================================================================
// -----------------------------------------------
// CBUS_BASE:  VPU_CBUS_BASE = 0x27
// -----------------------------------------------
#define VPU_OSD1_MMC_CTRL                          0x2701
#define VPU_OSD2_MMC_CTRL                          0x2702
#define VPU_VD1_MMC_CTRL                           0x2703
#define VPU_VD2_MMC_CTRL                           0x2704
#define VPU_DI_IF1_MMC_CTRL                        0x2705
#define VPU_DI_MEM_MMC_CTRL                        0x2706
#define VPU_DI_INP_MMC_CTRL                        0x2707
#define VPU_DI_MTNRD_MMC_CTRL                      0x2708
#define VPU_DI_CHAN2_MMC_CTRL                      0x2709
#define VPU_DI_MTNWR_MMC_CTRL                      0x270a
#define VPU_DI_NRWR_MMC_CTRL                       0x270b
#define VPU_DI_DIWR_MMC_CTRL                       0x270c
#define VPU_VDIN_MMC_CTRL                          0x270d
#define VPU_DVIN_MMC_CTRL                          0x270e
#define VPU_BT656_MMC_CTRL                         0x270f
#define VPU_VIU_VENC_MUX_CTRL                      0x271a
// [15:12] rd_rate. 0=A read every clk2; 1=A read every 2 clk2; ...; 15=A read every 16 clk2.
// [11: 8] wr_rate. 0=A write every clk1; 1=A write every 2 clk1; ...; 15=A write every 16 clk1.
// [ 7: 5] data_comp_map. Input data is CrYCb(BRG), map the output data to desired format:
//                          0=output CrYCb(BRG);
//                          1=output YCbCr(RGB);
//                          2=output YCrCb(RBG);
//                          3=output CbCrY(GBR);
//                          4=output CbYCr(GRB);
//                          5=output CrCbY(BGR);
//                          6,7=Rsrv.
// [    4] inv_dvi_clk. 1=Invert clock to external DVI, (clock invertion exists at internal HDMI).
// [    3] inv_vsync. 1=Invert Vsync polarity.
// [    2] inv_hsync. 1=Invert Hsync polarity.
// [ 1: 0] src_sel. 0=Disable output to HDMI; 1=Select VENC_I output to HDMI; 2=Select VENC_P output.

//========================================================================
//  VLD Registers				    (12'hC00 - 12'hCff)
//
//========================================================================
// -----------------------------------------------
// CBUS_BASE:  VLD_CBUS_BASE = 0x0c
// -----------------------------------------------
#define VLD_STATUS_CTRL                            0x0c00
//
// bit 10 -- use_old_shift_en
// bit 9 -- output_mv_not_pmv
// bit 8:5 -- force_zigzag
// bit 4 -- force_zigzag_en
// bit 3 -- disable_viff_anempty_int
// bit 2 -- disable_m2_ac_coeff_one_cycle
// bit 1 -- forced_reset  force reset pmv
// bit 0 -- mpeg_type  0:mpeg1 1: mpeg2
#define MPEG1_2_REG                                0x0c01
#define F_CODE_REG                                 0x0c02
#define PIC_HEAD_INFO                              0x0c03
#define SLICE_VER_POS_PIC_TYPE                     0x0c04
#define QP_VALUE_REG                               0x0c05
#define MBA_INC                                    0x0c06
#define MB_MOTION_MODE                             0x0c07
//`define PACKET_BYTE_COUNT   8'h08
// bit 15 -- force_search_startcode_en
// bit 14 -- int_cpu_when_error (before do anything)
// bit 13 -- vld_error_reset
// bit 12 -- return_on_slice_header
// bit 6 -- jpeg_ff00_en 
// bit 5:0 -- vld_power_ctl
#define POWER_CTL_VLD                              0x0c08
	#define FORCE_VIFF_RD		(1<<4)
#define MB_WIDTH                                   0x0c09
#define SLICE_QP                                   0x0c0a
// `define MB_X_MB_Y           8'h0b   /* current MBX and MBY                  */
#define PRE_START_CODE                             0x0c0b
#define SLICE_START_BYTE_01                        0x0c0c
#define SLICE_START_BYTE_23                        0x0c0d
#define RESYNC_MARKER_LENGTH                       0x0c0e
#define FST_FOR_MV_X                               0x0c10
#define FST_FOR_MV_Y                               0x0c11
#define SCD_FOR_MV_X                               0x0c12
#define SCD_FOR_MV_Y                               0x0c13
#define FST_BAK_MV_X                               0x0c14
#define FST_BAK_MV_Y                               0x0c15
#define SCD_BAK_MV_X                               0x0c16
#define SCD_BAK_MV_Y                               0x0c17
#define HALF_PEL_ONE                               0x0c18
#define HALF_PEL_TWO                               0x0c19
#define VIFF_BIT_CNT                               0x0c1a
#define BYTE_ALIGN_PEAK_HI                         0x0c1b
#define BYTE_ALIGN_PEAK_LO                         0x0c1c
#define NEXT_ALIGN_PEAK                            0x0c1d
// bit 6 : disable_dblk_hcmd
// bit 5 : disable_mc_hcmd
// bit 4 : first_mode3_set enable
// bit 3 : first_mode3
// bit 2:1 : vc1_profile  0-SP, 1-MP, 2-reserved, 3-AP
// bit 0   : vc1_enable
#define VC1_CONTROL_REG                            0x0c1e
#define PMV1_X                                     0x0c20
#define PMV1_Y                                     0x0c21
#define PMV2_X                                     0x0c22
#define PMV2_Y                                     0x0c23
#define PMV3_X                                     0x0c24
#define PMV3_Y                                     0x0c25
#define PMV4_X                                     0x0c26
#define PMV4_Y                                     0x0c27
// Can't use the same address for different defines
// Therefore, create a single define that covers both
// Only appears to be used in micro-code since the VLD hardware is 
// hard coded.
// `define M4_TABLE_SELECT     8'h28  // Does this exist in HW ? Added from register_mp2.h
// `define M4_TABLE_OUTPUT     8'h28  // Does this exist in HW ? Added from register_mp2.h
#define M4_TABLE_SELECT                            0x0c28
#define M4_CONTROL_REG                             0x0c29
#define BLOCK_NUM                                  0x0c2a
#define PATTERN_CODE                               0x0c2b
#define MB_INFO                                    0x0c2c
#define VLD_DC_PRED                                0x0c2d
#define VLD_ERROR_MASK                             0x0c2e
#define VLD_DC_PRED_C                              0x0c2f
#define LAST_SLICE_MV_ADDR                         0x0c30
#define LAST_MVX                                   0x0c31
#define LAST_MVY                                   0x0c32
#define VLD_C38                                    0x0c38
#define VLD_C39                                    0x0c39
#define VLD_STATUS                                 0x0c3a
#define VLD_SHIFT_STATUS                           0x0c3b
// `define VLD_SHIFT_INFO      8'h3b  // Does this exist in HW ? used in $ucode/mpeg4
#define VOFF_STATUS                                0x0c3c
#define VLD_C3D                                    0x0c3d
#define VLD_DBG_INDEX                              0x0c3e
// vld_buff_info -- (index == 0) 
// Bit[7:6]  mv_UR_ready_cnt;
// Bit[5]  vld_wr_idx
// Bit[4]  iq_rd_idx
// Bit[3]  vld_vi_block_rdy_1
// Bit[2]  vld_vi_block_rdy_2
// Bit[1]  voff_empty_1
// Bit[0]  voff_empty_2
// cabac_buff_info_0 -- (index == 1) 
// Bit[31] shift_data_ready
// Bit[30:29] Reserved
// Bit[28:24] cabac_buffer_ptr
// Bit[23:0] cabac_buffer
// cabac_buff_info_1 -- (index == 2) 
// Bit[31:29] Reserved
// Bit[28:20] Drange
// Bit[19:16] bin_count_4
// Bit[15:13] Reserved
// Bit[12:6] context_mem_do
// Bit[5:3] coeff_state
// Bit[2:0] mvd_state
// h264_mv_present -- (index == 3) 
// Bit[31:16] mv_present_l0
// Bit[15:0] mv_present_l1
// h264_mv_cal_info_0 -- (index == 4) 
// [31:28] mv_cal_state
// [27:24] direct_spatial_cnt
// Bit[23:21] Reserved
// Bit[20] mv_UR_ready_for_mv_cal
// Bit[19] co_mb_mem_ready_for_mv_cal
// Bit[18] mc_dblk_cmd_if_busy
// Bit[17] h264_co_mb_wr_busy
// Bit[16] H264_cbp_blk_ready
// Bit[15] mc_hcmd_rrdy
// Bit[14] mc_hcmd_srdy
// Bit[13] mc_cmd_if_ready
// Bit[12] mc_hcmd_mv_available
// Bit[11:8] mc_cmd_if_state
// Bit[7] dblk_hcmd_rrdy
// Bit[6] dblk_hcmd_srdy
// Bit[5] dblk_cmd_if_ready
// Bit[4] dblk_hcmd_mv_available
// Bit[3:0] dblk_cmd_if_state
// h264_mv_cal_info_1 -- (index == 5) 
//  Bit[31:29] Reserved
//  Bit[28:24] total_mvd_num_l0
//  Bit[23:21] Reserved
//  Bit[20:16] mv_cal_ptr_l0
//  Bit[15:13] Reserved
//  Bit[12:8] mc_hcmd_ptr_l0
//  Bit[7:5] Reserved
//  Bit[4:0] dblk_hcmd_ptr_l0
// h264_mv_cal_info_2 -- (index == 6) 
//  Bit[31:29] Reserved
//  Bit[28:24] total_mvd_num_l1
//  Bit[23:21] Reserved
//  Bit[20:16] mv_cal_ptr_l1
//  Bit[15:13] Reserved
//  Bit[12:8] mc_hcmd_ptr_l1
//  Bit[7:5] Reserved
//  Bit[4:0] dblk_hcmd_ptr_l1
// h264_co_mb_info -- (index == 7)
// Bit[31:26] Reserved
// Bit[25] mv_scale_cal_busy
// Bit[24:20] co_mv_count
// Bit[19:16] co_mv_process_state
// Bit[15] h264_co_mb_rd_busy
// Bit[15] h264_co_mb_rd_ready
// Bit[13:12] co_mv_transfer_block_cnt
// Bit[11:8] co_mv_transfer_ptr
// Bit[7] co_mv_POC_l1_busy
// Bit[6] h264_weight_scale_cal_en
// Bit[5] weight_cal_busy
// Bit[4] weight_cal_not_finished
// Bit[3:0] weight_process_state
#define VLD_DBG_DATA                               0x0c3f
// --------------------------------------------
// VIFIFO DDR Interface
// --------------------------------------------
// The VIFIFO start pointer into DDR memory is a 32-bit number
// The Start pointer will automatically be truncated to land on 
// an 8-byte boundary.  That is, bits [2:0] = 0;
#define VLD_MEM_VIFIFO_START_PTR                   0x0c40
// The current pointer points so some location between the START and END 
// pointers.  The current pointer is a BYTE pointer.  That is, you can 
// point to any BYTE address within the START/END range
#define VLD_MEM_VIFIFO_CURR_PTR                    0x0c41
#define VLD_MEM_VIFIFO_END_PTR                     0x0c42
#define VLD_MEM_VIFIFO_BYTES_AVAIL                 0x0c43
// VIFIFO FIFO Control
// bit  [31:24] viff_empty_int_enable_cpu[7:0] 
// bit  [23:16] viff_empty_int_enable_amrisc[7:0] 
//   -bit 23 Video BUFFER < 0x400 Bytes
//   -bit 22 Video BUFFER < 0x200 Bytes
//   -bit 21 Video BUFFER < 0x100 Bytes
//   -bit 20 Video BUFFER < 0x80 Bytes
//   -bit 19 Video BUFFER < 0x40 Bytes
//   -bit 18 Video BUFFER < 0x20 Bytes
//   -bit 17 vififo  < 16 double words
//   -bit 16 vififo  < 8 double words
// bit  [15:13] unused
// bit  [12]    A_urgent
// bit  [11]    transfer_length 0 - 32x64 Bits per request, 1 - 16x64 Bits per request
// bit  [10]    use_level       Set this bit to 1 to enable filling of the FIFO controlled by the buffer
//                              level control.  If this bit is 0, then use bit[1] to control the enabling of filling
// bit  [9]     Data Ready.     This bit is set when data can be popped
// bit  [8]     fill busy       This bit will be high when we're fetching data from the DDR memory
//                              To reset this module, set cntl_enable = 0, and then wait for busy = 0. 
//                              After that you can pulse cntl_init to start over
// bit  [7]     unused
// bit  [6]     unused
// bits [5:3]   endian:         see $lib/rtl/ddr_endian.v
// bit  [2]     cntl_empty_en   Set to 1 to enable reading the DDR memory FIFO
//                              Set cntl_empty_en = cntl_fill_en = 0 when pulsing cntl_init
// bit  [1]     cntl_fill_en    Set to 1 to enable reading data from DDR memory
// bit  [0]     cntl_init:      After setting the read pointers, sizes, channel masks
//                              and read masks, set this bit to 1 and then to 0
//                              NOTE:  You don't need to pulse cntl_init if only the start address is
//                              being changed
#define VLD_MEM_VIFIFO_CONTROL                     0x0c44
    #define MEM_LEVEL_CNT_BIT       18
    #define MEM_FIFO_CNT_BIT        16
	#define MEM_FILL_ON_LEVEL		(1<<10)
	#define MEM_CTRL_EMPTY_EN		(1<<2)
	#define MEM_CTRL_FILL_EN		(1<<1)
	#define MEM_CTRL_INIT        	(1<<0)
// --------------------------------------------
// VIFIFO Buffer Level Manager
// --------------------------------------------
#define VLD_MEM_VIFIFO_WP                          0x0c45
#define VLD_MEM_VIFIFO_RP                          0x0c46
#define VLD_MEM_VIFIFO_LEVEL                       0x0c47
//
// bit  [1]     manual mode     Set to 1 for manual write pointer mode
// bit  [0]     Init            Set high then low after everything has been initialized
#define VLD_MEM_VIFIFO_BUF_CNTL                    0x0c48
	#define MEM_BUFCTRL_MANUAL		(1<<1)
	#define MEM_BUFCTRL_INIT		(1<<0)

#define VLD_MEM_RD_PAGE				0x1a47
#define VLD_MEM_RD_PAGE_RP			0x1a48

// bit 31:16 -- drop_bytes
// bit 15:14 -- drop_status (Read-Only)
// bit 13:12 -- sync_match_position (Read-Only)
// bit 11:6 -- reserved
// bit 5:4 -- TIME_STAMP_NUMBER, 0-32bits, 1-64bits, 2-96bits, 3-128bits 
// bit 3 -- stamp_soft_reset
// bit 2 -- TIME_STAMP_length_enable
// bit 1 -- TIME_STAMP_sync64_enable
// bit 0 -- TIME_STAMP_enable
#define VLD_TIME_STAMP_CNTL                        0x0c49
// bit 31:0 -- TIME_STAMP_SYNC_CODE_0
#define VLD_TIME_STAMP_SYNC_0                      0x0c4a
// bit 31:0 -- TIME_STAMP_SYNC_CODE_1 
#define VLD_TIME_STAMP_SYNC_1                      0x0c4b
// bit 31:0 TIME_STAMP_0
#define VLD_TIME_STAMP_0                           0x0c4c
// bit 31:0 TIME_STAMP_1
#define VLD_TIME_STAMP_1                           0x0c4d
// bit 31:0 TIME_STAMP_2
#define VLD_TIME_STAMP_2                           0x0c4e
// bit 31:0 TIME_STAMP_3
#define VLD_TIME_STAMP_3                           0x0c4f
// bit 31:0 TIME_STAMP_LENGTH
#define VLD_TIME_STAMP_LENGTH                      0x0c50
// bit 15:0 vififo_rd_count
#define VLD_MEM_VIFIFO_WRAP_COUNT                  0x0c51
// bit 29:24 A_brst_num
// bit 21:16 A_id
// bit 15:0 level_hold 
#define VLD_MEM_VIFIFO_MEM_CTL                     0x0c52
//========================================================================
//  IQ/IDCT Registers				    (12'he00 - 12'heff)
//
//========================================================================
// -----------------------------------------------
// CBUS_BASE:  IQIDCT_CBUS_BASE = 0x0e
// -----------------------------------------------
#define VCOP_CTRL_REG                              0x0e00
#define QP_CTRL_REG                                0x0e01
#define INTRA_QUANT_MATRIX                         0x0e02
#define NON_I_QUANT_MATRIX                         0x0e03
#define DC_SCALER                                  0x0e04
#define DC_AC_CTRL                                 0x0e05
// `define RV_AI_CTRL          8'h05  // ONLY for $ucode/real/amrisc/rv.s reg value from apollo
#define DC_AC_SCALE_MUL                            0x0e06
#define DC_AC_SCALE_DIV                            0x0e07
// `define DC_AC_SCALE_RESULT  8'h06
// `define RESERVED_E07        8'h07
#define POWER_CTL_IQIDCT                           0x0e08
#define RV_AI_Y_X                                  0x0e09
#define RV_AI_U_X                                  0x0e0a
#define RV_AI_V_X                                  0x0e0b
// bit 15:0 will count up when rv_ai_mb finished when non zero
// and rv_ai_mb_finished_int will be generate when this is not zero
#define RV_AI_MB_COUNT                             0x0e0c
// For H264 I in PB picture Use -- dma type : h264_next_intra_dma
#define NEXT_INTRA_DMA_ADDRESS                     0x0e0d
// Bit 0 -- constrained_intra_pred_flag for H264
#define IQIDCT_CONTROL                             0x0e0e
// Bit[31:19] Reserved
// Bit[18] iq_waiting
// Bit[17] iq_om_wr_idx
// Bit[16] iq_om_rd_idx
// Bit[15] iq_om_busy
// Bit[14] iq_om_2_busy 
// Bit[13] idx_fifo_0
// Bit[12] idx_fifo_1
// Bit[11] idx_fifo_2
// Bit[10] idx_fifo_3
// Bit[9] idx_fifo_4
// Bit[8] idx_fifo_5
// Bit[7] idx_fifo_6
// Bit[6] idx_fifo_7
// Bit[5:3] idx_fifo_wp
// Bit[2:0] idx_fifo_rp
#define IQIDCT_DEBUG_INFO_0                        0x0e0f
// For RTL Simulation Only
#define DEBLK_CMD                                  0x0e10
// Bit[15+16] ds_mc_valid_2
// Bit[14+16] new_idct1_rd_idx_2
// Bit[13+16] new_idct1_wr_idx_2
// Bit[12+16] idct1_buff0_busy_2
// Bit[11+16] idct1_buff1_busy_2
// Bit[10+16] new_idct1_busy_2
// Bit[9+16] iq_om_8val_2
// Bit[8+16] idct1_pipe_busy_2
// Bit[7+16] wait_mb_left_finish_hold_2
// Bit[6+16] new_idct2_rd_idx_2
// Bit[5+16] new_idct2_wr_idx_2
// Bit[4+16] idct2_buff0_busy_2
// Bit[3+16] idct2_buff1_busy_2
// Bit[2+16] idct2_en_2
// Bit[1+16] new_idct2_busy_2
// Bit[0+16] new_idct1_ready_2
// Bit[15] ds_mc_valid_1
// Bit[14] new_idct1_rd_idx_1
// Bit[13] new_idct1_wr_idx_1
// Bit[12] idct1_buff0_busy_1
// Bit[11] idct1_buff1_busy_1
// Bit[10] new_idct1_busy_1
// Bit[9] iq_om_8val_1
// Bit[8] idct1_pipe_busy_1
// Bit[7] wait_mb_left_finish_hold_1
// Bit[6] new_idct2_rd_idx_1
// Bit[5] new_idct2_wr_idx_1
// Bit[4] idct2_buff0_busy_1
// Bit[3] idct2_buff1_busy_1
// Bit[2] idct2_en_1
// Bit[1] new_idct2_busy_1
// Bit[0] new_idct1_ready_1
#define IQIDCT_DEBUG_IDCT                          0x0e11
// bit 31 -- convas_enable
// bit 30:24 -- convas_x_count ( 8 pixels / 64 bits )
// bit 23:16 -- convas_y_count
// bit 15   -- dcac_dma_busy
// bit 14   -- dcac_dma_urgent
// bit 13:8 -- dcac_dma_count
// bit 7    -- dcac_dma_rw
// bit 6    -- dcac_skip_read_mode
// bit 5:0  -- dcac_dma_offset
#define DCAC_DMA_CTRL                              0x0e12
// when (convas_enable == 0 )
//   bit 31:0 dcac_dma_addr
// when (convas_enable == 1 )
//   bit 31:25 canvas_addr (7 bits)
//   bit 24:12 convas_y_start ( 13 btis )
//   bit 11:0  convas_x_start ( 12 btis )
#define DCAC_DMA_ADDRESS                           0x0e13
// bit 7:0 -- dcac_cpu_addr
#define DCAC_CPU_ADDRESS                           0x0e14
// bit 31:0 -- dcac_cpu_data
#define DCAC_CPU_DATA                              0x0e15
// bit 31:19 -- reserved
// bit 18:16 -- block_num_reg -- Read-Only 
// bit 15:0 -- dcac_mb_count
#define DCAC_MB_COUNT                              0x0e16
// bit 31:18 -- reserved
// For H264 :
//   bit 17:2 -- h264_quant 
//   bit 11:6 -- h264_quant_c 
//   bit  5:0 -- h264_quant_c 
// For VC1 :
//   bit    17 -- qindex_GT_8
//   bit    16 -- HalfQPStep
//   bit 15:12 -- eQuantMode 
//   bit 11:6  -- AltPQuant 
//   bit  5:0  -- PQuant 
//             
#define IQ_QUANT                                   0x0e17
// bit 31:24  -- bitplane_width 
// bit 23:16  -- bitplane_height 
// bit 15:14  -- bitplane_start_x 
// bit 13:12  -- bitplane_start_y 
// bit 11:4   -- reserved
// bit 3:1    -- bitplane_type
// bit 0      -- bitplane_busy
#define VC1_BITPLANE_CTL                           0x0e18
    #define RAM_TEST_CMD        0x002
    #define RAM_TEST_ADDR       0x003
    #define RAM_TEST_DATAH      0x004
    #define RAM_TEST_DATAL      0x005

    #define RAM_TEST_RD_CMD	    0x0000
    #define RAM_TEST_WR_CMD	    0x8000
    #define IDCT_TM2_PT0	    0x0001
    #define IDCT_TM2_PT1	    0x0002
    #define IDCT_TM1_PT0	    0x0004
    #define IDCT_TM1_PT1	    0x0008
    #define IQ_OMEM_PT0	        0x0010
    #define IQ_OMEM_PT1	        0x0020
    #define MC_IMEM_PT0	        0x0040
    #define ALL_RAM_PTS	        0x007f
//======================================
//  VCOP Control Register Bits
//
//======================================
    //#define IQIDCT_RESET	    0x0001	    // Bit 0
    #define QM_WEN		    0x0002	    // Bit 1
    #define IQIDCT_ENABLE	    0x0004	    // Bit 2
    #define INTRA_QM	    0x0008	    // Bit 3	0 = Use default; 1 = use loaded
    #define NINTRA_QM	    0x0010	    // Bit 4	0 = Use default; 1 = use loaded
//======================================
//  QP Control Register Bits
//
//======================================
    #define INTRA_MODE	    0x0080	    // Bit 7
// Duplicate Address:  When actually used
// please move to a different address
// `define FLD_DCT_TYPE	    16'h0100	    // Bit 8	0 = Frame DCT; 1 = field DCT
//========================================================================
//  DSP Co-Processor Registers			    ( 8'he00 - 12'hfff)
//
//========================================================================
// Duplicate Address:  When actually used
// please move to a different address
// `define AUDIO_COP_CTL1      12'hf00  // r & w; r-> 6'h00,bsmod[2:0],acmod[2:0],lfeon,nfchans[2:0]
#define AUDIO_COP_CTL2                             0x0f01
//  f02 -f0d are special regs , not in ac3_reg.h, but used by CPU for AC3 operations
#define OPERAND_M_CTL                              0x0f02
#define OPERAND1_ADDR                              0x0f03
#define OPERAND2_ADDR                              0x0f04
#define RESULT_M_CTL                               0x0f05
#define RESULT1_ADDR                               0x0f06
#define RESULT2_ADDR                               0x0f07
#define ADD_SHFT_CTL                               0x0f08
#define OPERAND_ONE_H                              0x0f09
#define OPERAND_ONE_L                              0x0f0a
#define OPERAND_TWO_H                              0x0f0b
#define OPERAND_TWO_L                              0x0f0c
#define RESULT_H                                   0x0f0d
#define RESULT_M                                   0x0f0e
// special reg 
#define RESULT_L                                   0x0f0f
// 
#define WMEM_R_PTR                                 0x0f10
#define WMEM_W_PTR                                 0x0f11
#define AUDIO_LAYER                                0x0f20
#define AC3_DECODING                               0x0f21
#define AC3_DYNAMIC                                0x0f22
#define AC3_MELODY                                 0x0f23
#define AC3_VOCAL                                  0x0f24
//======================================
//  CPU Assist module
//
//======================================
// -----------------------------------------------
// CBUS_BASE:  ASSIST_CBUS_BASE = 0x1f
// -----------------------------------------------
#define ASSIST_AMR1_INT0                           0x1f25
#define ASSIST_AMR1_INT1                           0x1f26
#define ASSIST_AMR1_INT2                           0x1f27
#define ASSIST_AMR1_INT3                           0x1f28
#define ASSIST_AMR1_INT4                           0x1f29
#define ASSIST_AMR1_INT5                           0x1f2a
#define ASSIST_AMR1_INT6                           0x1f2b
#define ASSIST_AMR1_INT7                           0x1f2c
#define ASSIST_AMR1_INT8                           0x1f2d
#define ASSIST_AMR1_INT9                           0x1f2e
#define ASSIST_AMR1_INTA                           0x1f2f
#define ASSIST_AMR1_INTB                           0x1f30
#define ASSIST_AMR1_INTC                           0x1f31
#define ASSIST_AMR1_INTD                           0x1f32
#define ASSIST_AMR1_INTE                           0x1f33
#define ASSIST_AMR1_INTF                           0x1f34
#define ASSIST_AMR2_INT0                           0x1f35
#define ASSIST_AMR2_INT1                           0x1f36
#define ASSIST_AMR2_INT2                           0x1f37
#define ASSIST_AMR2_INT3                           0x1f38
#define ASSIST_AMR2_INT4                           0x1f39
#define ASSIST_AMR2_INT5                           0x1f3a
#define ASSIST_AMR2_INT6                           0x1f3b
#define ASSIST_AMR2_INT7                           0x1f3c
#define ASSIST_AMR2_INT8                           0x1f3d
#define ASSIST_AMR2_INT9                           0x1f3e
#define ASSIST_AMR2_INTA                           0x1f3f
#define ASSIST_AMR2_INTB                           0x1f40
#define ASSIST_AMR2_INTC                           0x1f41
#define ASSIST_AMR2_INTD                           0x1f42
#define ASSIST_AMR2_INTE                           0x1f43
#define ASSIST_AMR2_INTF                           0x1f44
#define ASSIST_AMR_MBOX1_INT                       0x1f4d
#define ASSIST_AMR_MBOX2_INT                       0x1f4e
#define ASSIST_AMR_SCRATCH0                        0x1f4f
#define ASSIST_AMR_SCRATCH1                        0x1f50
#define ASSIST_AMR_SCRATCH2                        0x1f51
#define ASSIST_AMR_SCRATCH3                        0x1f52
#define ASSIST_HW_REV                              0x1f53
#define ASSIST_CBUS_ARB                            0x1f54
#define ASSIST_POR_CONFIG                          0x1f55
#define ASSIST_SPARE16_REG1                        0x1f56
#define ASSIST_SPARE16_REG2                        0x1f57
#define ASSIST_SPARE8_REG1                         0x1f58
#define ASSIST_SPARE8_REG2                         0x1f59
// Duplicate Address...when used please move to a new address
// `define TO_AMRISC_REG                 8'h59 // for amrisc
#define ASSIST_SPARE8_REG3                         0x1f5a
// Duplicate Address...when used please move to a new address
// `define FROM_AMRISC_REG               8'h5a // for amrisc
// Duplicate Address...when used please move to a new address
// `define MPEG2_DECODER_CONTROL         8'h5b // for amrisc
#define AC3_CTRL_REG1                              0x1f5b
#define AC3_CTRL_REG2                              0x1f5c
#define AC3_CTRL_REG3                              0x1f5d
#define AC3_CTRL_REG4                              0x1f5e
#define ASSIST_PMEM_SPLIT                          0x1f5f
#define TIMER0_LO                                  0x1f60
#define TIMER0_HI                                  0x1f61
#define TIMER1_LO                                  0x1f62
#define TIMER1_HI                                  0x1f63
#define DMA_INT                                    0x1f64
#define DMA_INT_MSK                                0x1f65
#define DMA_INT2                                   0x1f66
#define DMA_INT_MSK2                               0x1f67
#define ASSIST_MBOX0_IRQ_REG                       0x1f70
#define ASSIST_MBOX0_CLR_REG                       0x1f71
#define ASSIST_MBOX0_MASK                          0x1f72
#define ASSIST_MBOX0_FIQ_SEL                       0x1f73
#define ASSIST_MBOX1_IRQ_REG                       0x1f74
#define ASSIST_MBOX1_CLR_REG                       0x1f75
#define ASSIST_MBOX1_MASK                          0x1f76
#define ASSIST_MBOX1_FIQ_SEL                       0x1f77
#define ASSIST_MBOX2_IRQ_REG                       0x1f78
#define ASSIST_MBOX2_CLR_REG                       0x1f79
#define ASSIST_MBOX2_MASK                          0x1f7a
#define ASSIST_MBOX2_FIQ_SEL                       0x1f7b
// synopsys translate_off
// synopsys translate_on
//
// Closing file:  ./register_map.h
//

#endif
