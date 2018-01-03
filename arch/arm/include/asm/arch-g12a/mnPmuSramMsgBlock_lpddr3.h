
/** \file
 * \brief defines _PMU_SMB_LPDDR3_1D data structure
 */

/**  \brief LPDDR3_1D training firmware message block structure
 *
 *  Please refer to the Training Firmware App Note for futher information about
 *  the usage for Message Block.
 */
typedef struct _PMU_SMB_LPDDR3_1D_t {
   uint8_t  Reserved00;       // Byte offset 0x00, CSR Addr 0x54000, Direction=In
                              // Reserved00[0:5] RFU, must be zero
                              //
                              // Reserved00[6] = Enable High Effort WrDQ1D
                              //      0x1 = WrDQ1D will conditionally retry training at several extra RxClkDly Timings. This will increase the maximum 1D training time by up to 4 extra iterations of WrDQ1D. This is only required in systems that suffer from very large, asymmetric eye-collapse when receiving PRBS patterns.
                              //      0x0 = WrDQ1D assume rxClkDly values found by SI Friendly  RdDqs1D will work for receiving PRBS patterns
                              //
                              // Reserved00[7] = Optimize for the special hard macros in TSMC28.
                              //      0x1 = set if the phy being trained was manufactured in any TSMC28 process node.
                              //      0x0 = otherwise, when not training a TSMC28 phy, leave this field as 0.
   uint8_t  MsgMisc;          // Byte offset 0x01, CSR Addr 0x54000, Direction=In
                              // Contains various global options for training.
                              //
                              // Bit fields:
                              //
                              // MsgMisc[0] MTESTEnable
                              //      0x1 = Pulse primary digital test output bump at the end of each major training stage. This enables observation of training stage completion by observing the digital test output.
                              //      0x0 = Do not pulse primary digital test output bump
                              //
                              // MsgMisc[1] SimulationOnlyReset
                              //      0x1 = Verilog only simulation option to shorten duration of DRAM reset pulse length to 1ns.
                              //                Must never be set to 1 in silicon.
                              //      0x0 = Use reset pulse length specifed by JEDEC standard
                              //
                              // MsgMisc[2] SimulationOnlyTraining
                              //      0x1 = Verilog only simulation option to shorten the duration of the training steps by performing fewer iterations.
                              //                Must never be set to 1 in silicon.
                              //      0x0 = Use standard training duration.
                              //
                              // MsgMisc[3] RFU, must be zero
                              //
                              // MsgMisc[4] Suppress streaming messages, including assertions, regardless of HdtCtrl setting.
                              //            Stage Completion messages, as well as training completion and error messages are
                              //            Still sent depending on HdtCtrl setting.
                              //
                              // MsgMisc[5] PerByteMaxRdLat
                              //      0x1 = Each DBYTE will return dfi_rddata_valid at the lowest possible latency. This may result in unaligned data between bytes to be returned to the DFI.
                              //      0x0 = Every DBYTE will return  dfi_rddata_valid simultaneously. This will ensure that data bytes will return aligned accesses to the DFI.
                              //
                              // MsgMisc[7-6] RFU, must be zero
                              //
                              // Notes:
                              //
                              // - SimulationOnlyReset and SimulationOnlyTraining can be used to speed up simulation run times, and must never be used in real silicon. Some VIPs may have checks on DRAM reset parameters that may need to be disabled when using SimulationOnlyReset.
   uint16_t PmuRevision;      // Byte offset 0x02, CSR Addr 0x54001, Direction=Out
                              // PMU firmware revision ID
                              // After training is run, this address will contain the revision ID of the firmware
   uint8_t  Pstate;           // Byte offset 0x04, CSR Addr 0x54002, Direction=In
                              // Must be set to the target Pstate to be trained
                              //    0x0 = Pstate 0
                              //    0x1 = Pstate 1
                              //    0x2 = Pstate 2
                              //    0x3 = Pstate 3
                              //    All other encodings are reserved
   uint8_t  PllBypassEn;      // Byte offset 0x05, CSR Addr 0x54002, Direction=In
                              // Set according to whether target Pstate uses PHY PLL bypass
                              //    0x0 = PHY PLL is enabled for target Pstate
                              //    0x1 = PHY PLL is bypassed for target Pstate
   uint16_t DRAMFreq;         // Byte offset 0x06, CSR Addr 0x54003, Direction=In
                              // DDR data rate for the target Pstate in units of MT/s.
                              // For example enter 0x0640 for DDR1600.
   uint8_t  DfiFreqRatio;     // Byte offset 0x08, CSR Addr 0x54004, Direction=In
                              // Frequency ratio betwen DfiCtlClk and SDRAM memclk.
                              //    0x1 = 1:1
                              //    0x2 = 1:2
                              //    0x4 = 1:4
   uint8_t  BPZNResVal ;      // Byte offset 0x09, CSR Addr 0x54004, Direction=In
                              // Must be programmed to match the precision resistor connected to Phy BP_ZN
                              //    0x00 = Do not program. Use current CSR value.
                              //    0xf0 = 240 Ohm (recommended value)
                              //    0x78 = 120 Ohm
                              //    0x28 = 40 Ohm
                              //    All other values are reserved.
                              //
   uint8_t  PhyOdtImpedance;  // Byte offset 0x0a, CSR Addr 0x54005, Direction=In
                              // Must be programmed to the termination impedance in ohms used by PHY during reads.
                              //
                              // 0x0 = Firmware skips programming (must be manually programmed by user prior to training start)
                              //
                              // See PHY databook for legal termination impedance values.
                              //
                              // For digital simulation, any legal value can be used. For silicon, the users must determine the correct value through SI simulation or other methods.
   uint8_t  PhyDrvImpedance;  // Byte offset 0x0b, CSR Addr 0x54005, Direction=In
                              // Must be programmed to the driver impedance in ohms used by PHY during writes for all DBYTE drivers (DQ/DM/DBI/DQS).
                              //
                              // 0x0 = Firmware skips programming (must be manually programmed by user prior to training start)
                              //
                              // See PHY databook for legal R_on driver impedance values.
                              //
                              // For digital simulation, any value can be used that is not Hi-Z. For silicon, the users must determine the correct value through SI simulation or other methods.
   uint8_t  PhyVref;          // Byte offset 0x0c, CSR Addr 0x54006, Direction=In
                              // Must be programmed with the Vref level to be used by the PHY during reads
                              //
                              // The units of this field are a percentage of VDDQ according to the following equation:
                              //
                              // Receiver Vref = VDDQ*PhyVref[6:0]/128
                              //
                              // For example to set Vref at 0.75*VDDQ, set this field to 0x60.
                              //
                              // For digital simulation, any legal value can be used. For silicon, the users must calculate the analytical Vref by using the impedances, terminations, and series resistance present in the system.
   uint8_t  Reserved0D;       // Byte offset 0x0d, CSR Addr 0x54006, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved0E;       // Byte offset 0x0e, CSR Addr 0x54007, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  CsTestFail;       // Byte offset 0x0f, CSR Addr 0x54007, Direction=Out
                              // This field will be set if training fails on any rank.
                              //    0x0 = No failures
                              //    non-zero = one or more ranks failed training
   uint16_t SequenceCtrl;     // Byte offset 0x10, CSR Addr 0x54008, Direction=In
                              // Controls the training steps to be run. Each bit corresponds to a training step.
                              //
                              // If the bit is set to 1, the training step will run.
                              // If the bit is set to 0, the training step will be skipped.
                              //
                              // Training step to bit mapping:
                              //    SequenceCtrl[0] = Run DevInit - Device/phy initialization. Should always be set.
                              //    SequenceCtrl[1] = Run WrLvl - Write leveling
                              //    SequenceCtrl[2] = Run RxEn - Read gate training
                              //    SequenceCtrl[3] = Run RdDQS1D - 1d read dqs training
                              //    SequenceCtrl[4] = RunWrDQ1D - 1d write dq training
                              //    SequenceCtrl[5] = RFU, must be zero
                              //    SequenceCtrl[6] = RFU, must be zero
                              //    SequenceCtrl[7] = RFU, must be zero
                              //    SequenceCtrl[8] = Run RdDeskew - Per lane read dq deskew training
                              //    SequenceCtrl[9] = Run MxRdLat - Max read latency training
                              //    SequenceCtrl[10] = RFU, must be zero
                              //    SequenceCtrl[11] = RFU, must be zero
                              //    SequenceCtrl[12] = Run LPCA - CA Training
                              //    SequenceCtrl[13] = RFU, must be zero
                              //    SequenceCtrl[14] = RFU, must be zero
                              //    SequenceCtrl[15] = RFU, must be zero
                              //
   uint8_t  HdtCtrl;          // Byte offset 0x12, CSR Addr 0x54009, Direction=In
                              // To control the total number of debug messages, a verbosity subfield (HdtCtrl, Hardware Debug Trace Control) exists in the message block. Every message has a verbosity level associated with it, and as the HdtCtrl value is increased, less important s messages stop being sent through the mailboxes. The meanings of several major HdtCtrl thresholds are explained below:
                              //
                              //    0x05 = Detailed debug messages (e.g. Eye delays)
                              //    0x0A = Coarse debug messages (e.g. rank information)
                              //    0xC8 = Stage completion
                              //    0xC9 = Assertion messages
                              //    0xFF = Firmware completion messages only
                              //
                              // See Training App Note for more detailed information on what messages are included for each threshold.
                              //
   uint8_t  Reserved13;       // Byte offset 0x13, CSR Addr 0x54009, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  DFIMRLMargin;     // Byte offset 0x14, CSR Addr 0x5400a, Direction=In
                              // Margin added to smallest passing trained DFI Max Read Latency value, in units of DFI clocks. Recommended to be >= 1. See the Training App Note for more details on the training process and the use of this value.
                              //
                              // This margin must include the maximum positive drift expected in tDQSCK over the target temperature and voltage range of the users system.
   uint8_t  Reserved15;       // Byte offset 0x15, CSR Addr 0x5400a, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  UseBroadcastMR;   // Byte offset 0x16, CSR Addr 0x5400b, Direction=In
                              // Training firmware can optionally set per rank mode register values for DRAM partial array self-refresh features if desired.
                              //
                              //    0x0 = Use MR<0:17>_A0 for rank 0 channel A
                              //              Use MR<0:17>_B0 for rank 0 channel B
                              //              Use MR<0:17>_A1 for rank 1 channel A
                              //              Use MR<0:17>_B1 for rank 1 channel B
                              //
                              //    0x1 = Use MR<0:17>_A0 setting for all channels/ranks
                              //
                              // This should be set to 1 for all systems.
                              //
                              // Note: If setting this to 0, only mode register settings related to DRAM partial array self-refresh may be different between the ranks and channels. All other mode register settings must be the same for all ranks and channels.
   uint8_t  Reserved17;       // Byte offset 0x17, CSR Addr 0x5400b, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  LogToPhyByteMap0; // Byte offset 0x18, CSR Addr 0x5400c, Direction=In
                              // Physical Byte associated with Channel A logical Byte 0, depending on LogToPhyByteMap0[7] value:
                              //   LogToPhyByteMap0[7]==0: Logical Byte 0 map on Physical Byte 0
                              //   LogToPhyByteMap0[7]==1: Logical Byte 0 map on Physical Byte LogToPhyByteMap0[6:0]
   uint8_t  LogToPhyByteMap1; // Byte offset 0x19, CSR Addr 0x5400c, Direction=In
                              // Physical Byte associated with Channel A logical Byte 1, depending on LogToPhyByteMap1[7] value:
                              //   LogToPhyByteMap1[7]==0: Logical Byte 1 map on Physical Byte 1
                              //   LogToPhyByteMap1[7]==1: Logical Byte 1 map on Physical Byte LogToPhyByteMap1[6:0]
   uint8_t  LogToPhyByteMap2; // Byte offset 0x1a, CSR Addr 0x5400d, Direction=In
                              // Physical Byte associated with Channel A logical Byte 2, depending on LogToPhyByteMap2[7] value:
                              //   LogToPhyByteMap2[7]==0: Logical Byte 2 map on Physical Byte 2
                              //   LogToPhyByteMap2[7]==1: Logical Byte 2 map on Physical Byte LogToPhyByteMap2[6:0]
   uint8_t  LogToPhyByteMap3; // Byte offset 0x1b, CSR Addr 0x5400d, Direction=In
                              // Physical Byte associated with Channel A logical Byte 3, depending on LogToPhyByteMap3[7] value:
                              //   LogToPhyByteMap3[7]==0: Logical Byte 3 map on Physical Byte 3
                              //   LogToPhyByteMap3[7]==1: Logical Byte 3 map on Physical Byte LogToPhyByteMap3[6:0]
   uint8_t  LogToPhyByteMap4; // Byte offset 0x1c, CSR Addr 0x5400e, Direction=In
                              // Physical Byte associated with Channel B logical Byte 0, depending on LogToPhyByteMap4[7] value:
                              //   LogToPhyByteMap4[7]==0: Logical Byte 0 map on Physical Byte 4
                              //   LogToPhyByteMap4[7]==1: Logical Byte 0 map on Physical Byte LogToPhyByteMap4[6:0]
   uint8_t  LogToPhyByteMap5; // Byte offset 0x1d, CSR Addr 0x5400e, Direction=In
                              // Physical Byte associated with Channel B logical Byte 1, depending on LogToPhyByteMap5[7] value:
                              //   LogToPhyByteMap5[7]==0: Logical Byte 1 map on Physical Byte 5
                              //   LogToPhyByteMap5[7]==1: Logical Byte 1 map on Physical Byte LogToPhyByteMap5[6:0]
   uint8_t  LogToPhyByteMap6; // Byte offset 0x1e, CSR Addr 0x5400f, Direction=In
                              // Physical Byte associated with Channel B logical Byte 2, depending on LogToPhyByteMap6[7] value:
                              //   LogToPhyByteMap6[7]==0: Logical Byte 2 map on Physical Byte 6
                              //   LogToPhyByteMap6[7]==1: Logical Byte 2 map on Physical Byte LogToPhyByteMap6[6:0]
   uint8_t  LogToPhyByteMap7; // Byte offset 0x1f, CSR Addr 0x5400f, Direction=In
                              // Physical Byte associated with Channel B logical Byte 3, depending on LogToPhyByteMap7[7] value:
                              //   LogToPhyByteMap7[7]==0: Logical Byte 3 map on Physical Byte 7
                              //   LogToPhyByteMap7[7]==1: Logical Byte 3 map on Physical Byte LogToPhyByteMap7[6:0]
   uint8_t  LogToPhyByteMap8; // Byte offset 0x20, CSR Addr 0x54010, Direction=In
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  LogToPhyByteMap9; // Byte offset 0x21, CSR Addr 0x54010, Direction=In
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  EnabledDQsChA;    // Byte offset 0x22, CSR Addr 0x54011, Direction=In
                              // Total number of DQ bits enabled in PHY Channel A
   uint8_t  CsPresentChA;     // Byte offset 0x23, CSR Addr 0x54011, Direction=In
                              // Indicates presence of DRAM at each chip select for PHY channel A.
                              //
                              //  0x1 = CS0 is populated with DRAM
                              //  0x3 = CS0 and CS1 are populated with DRAM
                              //
                              // All other encodings are illegal
                              //
   int8_t   CDD_ChA_RR_1_0;   // Byte offset 0x24, CSR Addr 0x54012, Direction=Out
                              // This is a signed integer value.
                              // Read to read critical delay difference from cs 1 to cs 0 on Channel A
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_ChA_RR_0_1;   // Byte offset 0x25, CSR Addr 0x54012, Direction=Out
                              // This is a signed integer value.
                              // Read to read critical delay difference from cs 0 to cs 1 on Channel A
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_ChA_RW_1_1;   // Byte offset 0x26, CSR Addr 0x54013, Direction=Out
                              // This is a signed integer value.
                              // Read to write critical delay difference from cs 1 to cs 1 on Channel A
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_ChA_RW_1_0;   // Byte offset 0x27, CSR Addr 0x54013, Direction=Out
                              // This is a signed integer value.
                              // Read to write critical delay difference from cs 1 to cs 0 on Channel A
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_ChA_RW_0_1;   // Byte offset 0x28, CSR Addr 0x54014, Direction=Out
                              // This is a signed integer value.
                              // Read to write critical delay difference from cs 0 to cs 1 on Channel A
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_ChA_RW_0_0;   // Byte offset 0x29, CSR Addr 0x54014, Direction=Out
                              // This is a signed integer value.
                              // Read to write critical delay difference from cs0 to cs 0 on Channel A
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_ChA_WR_1_1;   // Byte offset 0x2a, CSR Addr 0x54015, Direction=Out
                              // This is a signed integer value.
                              // Write  to read critical delay difference from cs 1 to cs 1 on Channel A
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_ChA_WR_1_0;   // Byte offset 0x2b, CSR Addr 0x54015, Direction=Out
                              // This is a signed integer value.
                              // Write  to read critical delay difference from cs 1 to cs 0 on Channel A
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_ChA_WR_0_1;   // Byte offset 0x2c, CSR Addr 0x54016, Direction=Out
                              // This is a signed integer value.
                              // Write  to read critical delay difference from cs 0 to cs 1 on Channel A
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_ChA_WR_0_0;   // Byte offset 0x2d, CSR Addr 0x54016, Direction=Out
                              // This is a signed integer value.
                              // Write  to read critical delay difference from cs 0 to cs 0 on Channel A
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_ChA_WW_1_0;   // Byte offset 0x2e, CSR Addr 0x54017, Direction=Out
                              // This is a signed integer value.
                              // Write  to write critical delay difference from cs 1 to cs 0 on Channel A
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_ChA_WW_0_1;   // Byte offset 0x2f, CSR Addr 0x54017, Direction=Out
                              // This is a signed integer value.
                              // Write  to write critical delay difference from cs 0 to cs 1 on Channel A
                              // See PUB Databook section 8.2 for details on use of CDD values.
   uint8_t  Reserved30;       // Byte offset 0x30, CSR Addr 0x54018, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  MR1_A0;           // Byte offset 0x31, CSR Addr 0x54018, Direction=In
                              // Value to be programmed in DRAM Mode Register 1 {Channel A, Rank 0}
   uint8_t  MR2_A0;           // Byte offset 0x32, CSR Addr 0x54019, Direction=In
                              // Value to be programmed in DRAM Mode Register 2 {Channel A, Rank 0}
   uint8_t  MR3_A0;           // Byte offset 0x33, CSR Addr 0x54019, Direction=In
                              // Value to be programmed in DRAM Mode Register 3 {Channel A, Rank 0}
   uint8_t  Reserved34;       // Byte offset 0x34, CSR Addr 0x5401a, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  MR11_A0;          // Byte offset 0x35, CSR Addr 0x5401a, Direction=In
                              // Value to be programmed in DRAM Mode Register 11 {Channel A, Rank 0}
   uint8_t  MR16_A0;          // Byte offset 0x36, CSR Addr 0x5401b, Direction=In
                              // Value to be programmed in DRAM Mode Register 16 {Channel A, Rank 0}
   uint8_t  MR17_A0;          // Byte offset 0x37, CSR Addr 0x5401b, Direction=In
                              // Value to be programmed in DRAM Mode Register 17 {Channel A, Rank 0}
   uint8_t  Reserved38;       // Byte offset 0x38, CSR Addr 0x5401c, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  MR1_A1;           // Byte offset 0x39, CSR Addr 0x5401c, Direction=In
                              // Must be programmed the same as MR1_A0
   uint8_t  MR2_A1;           // Byte offset 0x3a, CSR Addr 0x5401d, Direction=In
                              // Must be programmed the same as MR2_A0
   uint8_t  MR3_A1;           // Byte offset 0x3b, CSR Addr 0x5401d, Direction=In
                              // Must be programmed the same as MR3_A0
   uint8_t  Reserved3C;       // Byte offset 0x3c, CSR Addr 0x5401e, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  MR11_A1;          // Byte offset 0x3d, CSR Addr 0x5401e, Direction=In
                              // Must be programmed the same as MR11_A0
   uint8_t  MR16_A1;          // Byte offset 0x3e, CSR Addr 0x5401f, Direction=In
                              // Value to be programmed in DRAM Mode Register 16 {Channel A, Rank 1}
   uint8_t  MR17_A1;          // Byte offset 0x3f, CSR Addr 0x5401f, Direction=In
                              // Value to be programmed in DRAM Mode Register 17 {Channel A, Rank 1}
   uint8_t  Reserved40;       // Byte offset 0x40, CSR Addr 0x54020, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved41;       // Byte offset 0x41, CSR Addr 0x54020, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved42;       // Byte offset 0x42, CSR Addr 0x54021, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved43;       // Byte offset 0x43, CSR Addr 0x54021, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved44;       // Byte offset 0x44, CSR Addr 0x54022, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved45;       // Byte offset 0x45, CSR Addr 0x54022, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved46;       // Byte offset 0x46, CSR Addr 0x54023, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved47;       // Byte offset 0x47, CSR Addr 0x54023, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  EnabledDQsChB;    // Byte offset 0x48, CSR Addr 0x54024, Direction=In
                              // Total number of DQ bits enabled in PHY Channel B
   uint8_t  CsPresentChB;     // Byte offset 0x49, CSR Addr 0x54024, Direction=In
                              // Indicates presence of DRAM at each chip select for PHY channel B.
                              //
                              //    0x0 = No chip selects are populated with DRAM
                              //    0x1 = CS0 is populated with DRAM
                              //    0x3 = CS0 and CS1 are populated with DRAM
                              //
                              // All other encodings are illegal
                              //
   int8_t   CDD_ChB_RR_1_0;   // Byte offset 0x4a, CSR Addr 0x54025, Direction=Out
                              // This is a signed integer value.
                              // Read to read critical delay difference from cs 1 to cs 0 on Channel B
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_ChB_RR_0_1;   // Byte offset 0x4b, CSR Addr 0x54025, Direction=Out
                              // This is a signed integer value.
                              // Read to read critical delay difference from cs 0 to cs 1 on Channel B
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_ChB_RW_1_1;   // Byte offset 0x4c, CSR Addr 0x54026, Direction=Out
                              // This is a signed integer value.
                              // Read to write critical delay difference from cs 1 to cs 1 on Channel B
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_ChB_RW_1_0;   // Byte offset 0x4d, CSR Addr 0x54026, Direction=Out
                              // This is a signed integer value.
                              // Read to write critical delay difference from cs 1 to cs 0 on Channel B
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_ChB_RW_0_1;   // Byte offset 0x4e, CSR Addr 0x54027, Direction=Out
                              // This is a signed integer value.
                              // Read to write critical delay difference from cs 0 to cs 1 on Channel B
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_ChB_RW_0_0;   // Byte offset 0x4f, CSR Addr 0x54027, Direction=Out
                              // This is a signed integer value.
                              // Read to write critical delay difference from cs01 to cs 0 on Channel B
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_ChB_WR_1_1;   // Byte offset 0x50, CSR Addr 0x54028, Direction=Out
                              // This is a signed integer value.
                              // Write  to read critical delay difference from cs 1 to cs 1 on Channel B
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_ChB_WR_1_0;   // Byte offset 0x51, CSR Addr 0x54028, Direction=Out
                              // This is a signed integer value.
                              // Write  to read critical delay difference from cs 1 to cs 0 on Channel B
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_ChB_WR_0_1;   // Byte offset 0x52, CSR Addr 0x54029, Direction=Out
                              // This is a signed integer value.
                              // Write  to read critical delay difference from cs 0 to cs 1 on Channel B
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_ChB_WR_0_0;   // Byte offset 0x53, CSR Addr 0x54029, Direction=Out
                              // This is a signed integer value.
                              // Write  to read critical delay difference from cs 0 to cs 0 on Channel B
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_ChB_WW_1_0;   // Byte offset 0x54, CSR Addr 0x5402a, Direction=Out
                              // This is a signed integer value.
                              // Write  to write critical delay difference from cs 1 to cs 0 on Channel B
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_ChB_WW_0_1;   // Byte offset 0x55, CSR Addr 0x5402a, Direction=Out
                              // This is a signed integer value.
                              // Write  to write critical delay difference from cs 0 to cs 1 on Channel B
                              // See PUB Databook section 8.2 for details on use of CDD values.
   uint8_t  Reserved56;       // Byte offset 0x56, CSR Addr 0x5402b, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  MR1_B0;           // Byte offset 0x57, CSR Addr 0x5402b, Direction=In
                              // Must be programmed the same as MR1_A0
   uint8_t  MR2_B0;           // Byte offset 0x58, CSR Addr 0x5402c, Direction=In
                              // Must be programmed the same as MR2_A0
   uint8_t  MR3_B0;           // Byte offset 0x59, CSR Addr 0x5402c, Direction=In
                              // Must be programmed the same as MR3_A0
   uint8_t  Reserved5A;       // Byte offset 0x5a, CSR Addr 0x5402d, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  MR11_B0;          // Byte offset 0x5b, CSR Addr 0x5402d, Direction=In
                              // Must be programmed the same as MR11_A0
   uint8_t  MR16_B0;          // Byte offset 0x5c, CSR Addr 0x5402e, Direction=In
                              // Value to be programmed in DRAM Mode Register 16 {Channel B, Rank 0}
   uint8_t  MR17_B0;          // Byte offset 0x5d, CSR Addr 0x5402e, Direction=In
                              // Value to be programmed in DRAM Mode Register 17 {Channel B, Rank 0}
   uint8_t  Reserved5E;       // Byte offset 0x5e, CSR Addr 0x5402f, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  MR1_B1;           // Byte offset 0x5f, CSR Addr 0x5402f, Direction=In
                              // Must be programmed the same as MR1_A0
   uint8_t  MR2_B1;           // Byte offset 0x60, CSR Addr 0x54030, Direction=In
                              // Must be programmed the same as MR2_A0
   uint8_t  MR3_B1;           // Byte offset 0x61, CSR Addr 0x54030, Direction=In
                              // Must be programmed the same as MR3_A0
   uint8_t  Reserved62;       // Byte offset 0x62, CSR Addr 0x54031, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  MR11_B1;          // Byte offset 0x63, CSR Addr 0x54031, Direction=In
                              // Must be programmed the same as MR11_A0
   uint8_t  MR16_B1;          // Byte offset 0x64, CSR Addr 0x54032, Direction=In
                              // Value to be programmed in DRAM Mode Register 16 {Channel B, Rank 1}
   uint8_t  MR17_B1;          // Byte offset 0x65, CSR Addr 0x54032, Direction=In
                              // Value to be programmed in DRAM Mode Register 17 {Channel B, Rank 1}
   uint8_t  Reserved66;       // Byte offset 0x66, CSR Addr 0x54033, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved67;       // Byte offset 0x67, CSR Addr 0x54033, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved68;       // Byte offset 0x68, CSR Addr 0x54034, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved69;       // Byte offset 0x69, CSR Addr 0x54034, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved6A;       // Byte offset 0x6a, CSR Addr 0x54035, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved6B;       // Byte offset 0x6b, CSR Addr 0x54035, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved6C;       // Byte offset 0x6c, CSR Addr 0x54036, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved6D;       // Byte offset 0x6d, CSR Addr 0x54036, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint16_t PhyConfigOverride; // Byte offset 0x6e, CSR Addr 0x54037, Direction=In
                              // Override PhyConfig csr.
                              // 0x0: Use hardware csr value for PhyConfing (recommended)
                              // Other values: Use value for PhyConfig instead of Hardware value.
                              //
   uint8_t  Reserved70;       // Byte offset 0x70, CSR Addr 0x54038, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
} __attribute__ ((packed)) PMU_SMB_LPDDR3_1D_t;
