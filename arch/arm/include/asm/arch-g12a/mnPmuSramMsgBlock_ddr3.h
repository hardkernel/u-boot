
/** \file
 * \brief defines _PMU_SMB_DDR3U_1D data structure
 */

/**  \brief DDR3U_1D training firmware message block structure
 *
 *  Please refer to the Training Firmware App Note for futher information about
 *  the usage for Message Block.
 */
typedef struct _PMU_SMB_DDR3U_1D_t {
   uint8_t  Reserved00;       // Byte offset 0x00, CSR Addr 0x54000, Direction=In
                              // Reserved00[0:4] RFU, must be zero
                              //
                              // Reserved00[5] = Train vrefDAC0 During Read Deskew
                              //        0x1 =  Read Deskew will begin by enabling and roughly training the phy’s per-lane reference voltages.  Training the vrefDACs CSRs will increase the maximum 1D training time by around half a millisecond, but will improve 1D training accuracy on systems with significant voltage-offsets between lane read eyes.
                              //        0X0 =  Read Deskew will assume the messageblock’s phyVref setting will work for all lanes.
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
                              // MsgMisc[0] = MTESTEnable
                              //      0x1 = Pulse primary digital test output bump at the end of each major training stage. This enables observation of training stage completion by observing the digital test output.
                              //      0x0 = Do not pulse primary digital test output bump
                              //
                              // MsgMisc[1] = SimulationOnlyReset
                              //      0x1 = Verilog only simulation option to shorten duration of DRAM reset pulse length to 1ns.
                              //                Must never be set to 1 in silicon.
                              //      0x0 = Use reset pulse length specifed by JEDEC standard
                              //
                              // MsgMisc[2] = SimulationOnlyTraining
                              //      0x1 = Verilog only simulation option to shorten the duration of the training steps by performing fewer iterations.
                              //                Must never be set to 1 in silicon.
                              //      0x0 = Use standard training duration.
                              //
                              // MsgMisc[3] = RFU, must be zero (DDR4 UDIMM and RDIMM only, otherwise RFU, must be zero)
                              //
                              //
                              //
                              // MsgMisc[4] = Suppress streaming messages, including assertions, regardless of HdtCtrl setting.
                              //              Stage Completion messages, as well as training completion and error messages are
                              //              Still sent depending on HdtCtrl setting.
                              //
                              // MsgMisc[5] = PerByteMaxRdLat
                              //      0x1 = Each DBYTE will return dfi_rddata_valid at the lowest possible latency. This may result in unaligned data between bytes to be returned to the DFI.
                              //      0x0 = Every DBYTE will return  dfi_rddata_valid simultaneously. This will ensure that data bytes will return aligned accesses to the DFI.
                              //
                              // MsgMisc[6] = PartialRank (DDR3 UDIMM and DDR4 UDIMM only, otherwise RFU, must be zero)
                              //      0x1 = Support rank populated with a subset of byte, but where even-odd pair of rank support all the byte
                              //      0x0 = All rank populated with all the byte (tyical configuration)
                              //
                              // MsgMisc[7] RFU, must be zero
                              //
                              // Notes:
                              //
                              // - SimulationOnlyReset and SimulationOnlyTraining can be used to speed up simulation run times, and must never be used in real silicon. Some VIPs may have checks on DRAM reset parameters that may need to be disabled when using SimulationOnlyReset.
   uint16_t PmuRevision;      // Byte offset 0x02, CSR Addr 0x54001, Direction=Out
                              // PMU firmware revision ID
                              // After training is run, this address will contain the revision ID of the firmware.
                              // Please reference this revision ID when filing support cases with Synopsys.
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
   uint8_t  DramType;         // Byte offset 0x0d, CSR Addr 0x54006, Direction=In
                              // Module Type:
                              //   0x01 = DDR3 unbuffered
                              //   0x02 = Reserved
                              //   0x03 = Reserved
                              //   0x04 = Reserved
                              //   0x05 = Reserved
                              //
   uint8_t  DisabledDbyte;    // Byte offset 0x0e, CSR Addr 0x54007, Direction=In
                              // Bitmap to indicate which Dbyte are not connected (for DByte 0 to 7):
                              // Set DisabledDbyte[i] to 1 only to specify that DByte i not need to be trained (DByte 8 can be disabled via EnabledDQs setting)
   uint8_t  EnabledDQs;       // Byte offset 0x0f, CSR Addr 0x54007, Direction=In
                              // Total number of DQ bits enabled in PHY
   uint8_t  CsPresent;        // Byte offset 0x10, CSR Addr 0x54008, Direction=In
                              // Indicates presence of DRAM at each chip select for PHY. Each bit corresponds to a logical CS.
                              //
                              // If the bit is set to 1, the CS is connected to DRAM.
                              // If the bit is set to 0, the CS is not connected to DRAM.
                              //
                              //  CsPresent[0] = CS0 is populated with DRAM
                              //  CsPresent[1] = CS1 is populated with DRAM
                              //  CsPresent[2] = CS2 is populated with DRAM
                              //  CsPresent[3] = CS3 is populated with DRAM
                              //  CsPresent[7:4] = Reserved (must be programmed to 0)
                              //
                              //
   uint8_t  CsPresentD0;      // Byte offset 0x11, CSR Addr 0x54008, Direction=In
                              // The CS signals from field CsPresent that are routed to DIMM connector 0
   uint8_t  CsPresentD1;      // Byte offset 0x12, CSR Addr 0x54009, Direction=In
                              // The CS signals from field CsPresent that are routed to DIMM connector 1
   uint8_t  AddrMirror;       // Byte offset 0x13, CSR Addr 0x54009, Direction=In
                              // Corresponds to CS[3:0]
                              //      1 = Address Mirror.
                              //      0 = No Address Mirror.
   uint8_t  CsTestFail;       // Byte offset 0x14, CSR Addr 0x5400a, Direction=Out
                              // This field will be set if training fails on any rank.
                              //    0x0 = No failures
                              //    non-zero = one or more ranks failed training
   uint8_t  PhyCfg;           // Byte offset 0x15, CSR Addr 0x5400a, Direction=In
                              // Additional mode bits.
                              //
                              // Bit fields:
                              //  [0] SlowAccessMode  :
                              //       1 = 2T Address Timing.
                              //       0 = 1T Address Timing.
                              // [7-1] RFU, must be zero
   uint16_t SequenceCtrl;     // Byte offset 0x16, CSR Addr 0x5400b, Direction=In
                              // Controls the training steps to be run. Each bit corresponds to a training step.
                              //
                              // If the bit is set to 1, the training step will run.
                              // If the bit is set to 0, the training step will be skipped.
                              //
                              // Training step to bit mapping:
                              // SequenceCtrl[0] = Run DevInit - Device/phy initialization. Should always be set.
                              // SequenceCtrl[1] = Run WrLvl - Write leveling
                              // SequenceCtrl[2] = Run RxEn - Read gate training
                              // SequenceCtrl[3] = Run RdDQS1D - 1d read dqs training
                              // SequenceCtrl[4] = Run WrDQ1D - 1d write dq training
                              // SequenceCtrl[5] = RFU, must be zero
                              // SequenceCtrl[6] = RFU, must be zero
                              // SequenceCtrl[7] =  RFU, must be zero
                              // SequenceCtrl[8] = Run RdDeskew - Per lane read dq deskew training
                              // SequenceCtrl[9] = Run MxRdLat - Max read latency training
                              // SequenceCtrl[10] = RFU, must be zero
                              // SequenceCtrl[11] = RFU, must be zero
                              // SequenceCtrl[12] = RFU, must be zero
                              // SequenceCtrl[13] = RFU, must be zero
                              // SequenceCtrl[15-14] =  RFU, must be zero
   uint8_t  HdtCtrl;          // Byte offset 0x18, CSR Addr 0x5400c, Direction=In
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
   uint8_t  Reserved19;    // Byte offset 0x19, CSR Addr 0x5400c, Direction=N/A
















   uint8_t  Reserved1A;    // Byte offset 0x1a, CSR Addr 0x5400d, Direction=N/A



















   uint8_t  Reserved1B; // Byte offset 0x1b, CSR Addr 0x5400d, Direction=N/A



   uint8_t  Reserved1C;   // Byte offset 0x1c, CSR Addr 0x5400e, Direction=N/A

   uint8_t  Reserved1D; // Byte offset 0x1d, CSR Addr 0x5400e, Direction=N/A

   uint8_t  Reserved1E;       // Byte offset 0x1e, CSR Addr 0x5400f, Direction=In
                              // Input for constraining the range of vref(DQ) values training will collect data for, usually reducing training time. However, too large of a voltage range may cause longer 2D training times while too small of a voltage range may truncate passing regions. When in doubt, leave this field set to 0.
                              // Used by 2D training in: Rd2D, Wr2D
                              //
                              // Reserved1E[0-3]: Rd2D Voltage Range
                              //     0 = Training will search all phy vref(DQ) settings
                              //     1 = limit to +/-2 %VDDQ from phyVref
                              //     2 = limit to +/-4 %VDDQ from phyVref
                              //     …
                              //    15 = limit to +/-30% VDDQ from phyVref
                              //
                              // Reserved1E[4-7]: Wr2D Voltage Range
                              //     0 = Training will search all dram vref(DQ) settings
                              //     1 = limit to +/-2 %VDDQ from MR6
                              //     2 = limit to +/-4 %VDDQ from MR6
                              //     …
                              //    15 = limit to +/-30% VDDQ from MR6
   uint8_t  Reserved1F;       // Byte offset 0x1f, CSR Addr 0x5400f, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved20;       // Byte offset 0x20, CSR Addr 0x54010, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved21;       // Byte offset 0x21, CSR Addr 0x54010, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint16_t PhyConfigOverride; // Byte offset 0x22, CSR Addr 0x54011, Direction=In
                              // Override PhyConfig csr.
                              // 0x0: Use hardware csr value for PhyConfing (recommended)
                              // Other values: Use value for PhyConfig instead of Hardware value.
                              //
   uint8_t  DFIMRLMargin;     // Byte offset 0x24, CSR Addr 0x54012, Direction=In
                              // Margin added to smallest passing trained DFI Max Read Latency value, in units of DFI clocks. Recommended to be >= 1. See the Training App Note for more details on the training process and the use of this value.
   int8_t   CDD_RR_3_2;       // Byte offset 0x25, CSR Addr 0x54012, Direction=Out
                              // This is a signed integer value.
                              // Read to read critical delay difference from cs 3 to cs 2
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_RR_3_1;       // Byte offset 0x26, CSR Addr 0x54013, Direction=Out
                              // This is a signed integer value.
                              // Read to read critical delay difference from cs 3 to cs 1
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_RR_3_0;       // Byte offset 0x27, CSR Addr 0x54013, Direction=Out
                              // This is a signed integer value.
                              // Read to read critical delay difference from cs 3 to cs 0
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_RR_2_3;       // Byte offset 0x28, CSR Addr 0x54014, Direction=Out
                              // This is a signed integer value.
                              // Read to read critical delay difference from cs 2 to cs 3
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_RR_2_1;       // Byte offset 0x29, CSR Addr 0x54014, Direction=Out
                              // This is a signed integer value.
                              // Read to read critical delay difference from cs 2 to cs 1
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_RR_2_0;       // Byte offset 0x2a, CSR Addr 0x54015, Direction=Out
                              // This is a signed integer value.
                              // Read to read critical delay difference from cs 2 to cs 0
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_RR_1_3;       // Byte offset 0x2b, CSR Addr 0x54015, Direction=Out
                              // This is a signed integer value.
                              // Read to read critical delay difference from cs 1 to cs 3
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_RR_1_2;       // Byte offset 0x2c, CSR Addr 0x54016, Direction=Out
                              // This is a signed integer value.
                              // Read to read critical delay difference from cs 1 to cs 2
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_RR_1_0;       // Byte offset 0x2d, CSR Addr 0x54016, Direction=Out
                              // This is a signed integer value.
                              // Read to read critical delay difference from cs 1 to cs 0
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_RR_0_3;       // Byte offset 0x2e, CSR Addr 0x54017, Direction=Out
                              // This is a signed integer value.
                              // Read to read critical delay difference from cs 0 to cs 3
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_RR_0_2;       // Byte offset 0x2f, CSR Addr 0x54017, Direction=Out
                              // This is a signed integer value.
                              // Read to read critical delay difference from cs 0 to cs 2
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_RR_0_1;       // Byte offset 0x30, CSR Addr 0x54018, Direction=Out
                              // This is a signed integer value.
                              // Read to read critical delay difference from cs 0 to cs 1
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_WW_3_2;       // Byte offset 0x31, CSR Addr 0x54018, Direction=Out
                              // This is a signed integer value.
                              // Write to write critical delay difference from cs 3 to cs 2
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_WW_3_1;       // Byte offset 0x32, CSR Addr 0x54019, Direction=Out
                              // This is a signed integer value.
                              // Write to write critical delay difference from cs 3 to cs 1
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_WW_3_0;       // Byte offset 0x33, CSR Addr 0x54019, Direction=Out
                              // This is a signed integer value.
                              // Write to write critical delay difference from cs 3 to cs 0
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_WW_2_3;       // Byte offset 0x34, CSR Addr 0x5401a, Direction=Out
                              // This is a signed integer value.
                              // Write to write critical delay difference from cs 2 to cs 3
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_WW_2_1;       // Byte offset 0x35, CSR Addr 0x5401a, Direction=Out
                              // This is a signed integer value.
                              // Write to write critical delay difference from cs 2 to cs 1
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_WW_2_0;       // Byte offset 0x36, CSR Addr 0x5401b, Direction=Out
                              // This is a signed integer value.
                              // Write to write critical delay difference from cs 2 to cs 0
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_WW_1_3;       // Byte offset 0x37, CSR Addr 0x5401b, Direction=Out
                              // This is a signed integer value.
                              // Write to write critical delay difference from cs 1 to cs 3
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_WW_1_2;       // Byte offset 0x38, CSR Addr 0x5401c, Direction=Out
                              // This is a signed integer value.
                              // Write to write critical delay difference from cs 1 to cs 2
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_WW_1_0;       // Byte offset 0x39, CSR Addr 0x5401c, Direction=Out
                              // This is a signed integer value.
                              // Write to write critical delay difference from cs 1 to cs 0
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_WW_0_3;       // Byte offset 0x3a, CSR Addr 0x5401d, Direction=Out
                              // This is a signed integer value.
                              // Write to write critical delay difference from cs 0 to cs 3
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_WW_0_2;       // Byte offset 0x3b, CSR Addr 0x5401d, Direction=Out
                              // This is a signed integer value.
                              // Write to write critical delay difference from cs 0 to cs 2
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_WW_0_1;       // Byte offset 0x3c, CSR Addr 0x5401e, Direction=Out
                              // This is a signed integer value.
                              // Write to write critical delay difference from cs 0 to cs 1
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_RW_3_3;       // Byte offset 0x3d, CSR Addr 0x5401e, Direction=Out
                              // This is a signed integer value.
                              // Read to write critical delay difference from cs 3 to cs 3
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_RW_3_2;       // Byte offset 0x3e, CSR Addr 0x5401f, Direction=Out
                              // This is a signed integer value.
                              // Read to write critical delay difference from cs 3 to cs 2
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_RW_3_1;       // Byte offset 0x3f, CSR Addr 0x5401f, Direction=Out
                              // This is a signed integer value.
                              // Read to write critical delay difference from cs 3 to cs 1
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_RW_3_0;       // Byte offset 0x40, CSR Addr 0x54020, Direction=Out
                              // This is a signed integer value.
                              // Read to write critical delay difference from cs 3 to cs 0
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_RW_2_3;       // Byte offset 0x41, CSR Addr 0x54020, Direction=Out
                              // This is a signed integer value.
                              // Read to write critical delay difference from cs 2 to cs 3
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_RW_2_2;       // Byte offset 0x42, CSR Addr 0x54021, Direction=Out
                              // This is a signed integer value.
                              // Read to write critical delay difference from cs 2 to cs 2
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_RW_2_1;       // Byte offset 0x43, CSR Addr 0x54021, Direction=Out
                              // This is a signed integer value.
                              // Read to write critical delay difference from cs 2 to cs 1
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_RW_2_0;       // Byte offset 0x44, CSR Addr 0x54022, Direction=Out
                              // This is a signed integer value.
                              // Read to write critical delay difference from cs 2 to cs 0
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_RW_1_3;       // Byte offset 0x45, CSR Addr 0x54022, Direction=Out
                              // This is a signed integer value.
                              // Read to write critical delay difference from cs 1 to cs 3
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_RW_1_2;       // Byte offset 0x46, CSR Addr 0x54023, Direction=Out
                              // This is a signed integer value.
                              // Read to write critical delay difference from cs 1 to cs 2
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_RW_1_1;       // Byte offset 0x47, CSR Addr 0x54023, Direction=Out
                              // This is a signed integer value.
                              // Read to write critical delay difference from cs 1 to cs 1
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_RW_1_0;       // Byte offset 0x48, CSR Addr 0x54024, Direction=Out
                              // This is a signed integer value.
                              // Read to write critical delay difference from cs 1 to cs 0
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_RW_0_3;       // Byte offset 0x49, CSR Addr 0x54024, Direction=Out
                              // This is a signed integer value.
                              // Read to write critical delay difference from cs 0 to cs 3
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_RW_0_2;       // Byte offset 0x4a, CSR Addr 0x54025, Direction=Out
                              // This is a signed integer value.
                              // Read to write critical delay difference from cs 0 to cs 2
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_RW_0_1;       // Byte offset 0x4b, CSR Addr 0x54025, Direction=Out
                              // This is a signed integer value.
                              // Read to write critical delay difference from cs 0 to cs 1
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_RW_0_0;       // Byte offset 0x4c, CSR Addr 0x54026, Direction=Out
                              // This is a signed integer value.
                              // Read to write critical delay difference from cs 0 to cs 0
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_WR_3_3;       // Byte offset 0x4d, CSR Addr 0x54026, Direction=Out
                              // This is a signed integer value.
                              // Write to read critical delay difference from cs 3 to cs 3
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_WR_3_2;       // Byte offset 0x4e, CSR Addr 0x54027, Direction=Out
                              // This is a signed integer value.
                              // Write to read critical delay difference from cs 3 to cs 2
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_WR_3_1;       // Byte offset 0x4f, CSR Addr 0x54027, Direction=Out
                              // This is a signed integer value.
                              // Write to read critical delay difference from cs 3 to cs 1
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_WR_3_0;       // Byte offset 0x50, CSR Addr 0x54028, Direction=Out
                              // This is a signed integer value.
                              // Write to read critical delay difference from cs 3 to cs 0
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_WR_2_3;       // Byte offset 0x51, CSR Addr 0x54028, Direction=Out
                              // This is a signed integer value.
                              // Write to read critical delay difference from cs 2 to cs 3
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_WR_2_2;       // Byte offset 0x52, CSR Addr 0x54029, Direction=Out
                              // This is a signed integer value.
                              // Write to read critical delay difference from cs 2 to cs 2
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_WR_2_1;       // Byte offset 0x53, CSR Addr 0x54029, Direction=Out
                              // This is a signed integer value.
                              // Write to read critical delay difference from cs 2 to cs 1
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_WR_2_0;       // Byte offset 0x54, CSR Addr 0x5402a, Direction=Out
                              // This is a signed integer value.
                              // Write to read critical delay difference from cs 2 to cs 0
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_WR_1_3;       // Byte offset 0x55, CSR Addr 0x5402a, Direction=Out
                              // This is a signed integer value.
                              // Write to read critical delay difference from cs 1 to cs 3
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_WR_1_2;       // Byte offset 0x56, CSR Addr 0x5402b, Direction=Out
                              // This is a signed integer value.
                              // Write to read critical delay difference from cs 1 to cs 2
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_WR_1_1;       // Byte offset 0x57, CSR Addr 0x5402b, Direction=Out
                              // This is a signed integer value.
                              // Write to read critical delay difference from cs 1 to cs 1
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_WR_1_0;       // Byte offset 0x58, CSR Addr 0x5402c, Direction=Out
                              // This is a signed integer value.
                              // Write to read critical delay difference from cs 1 to cs 0
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_WR_0_3;       // Byte offset 0x59, CSR Addr 0x5402c, Direction=Out
                              // This is a signed integer value.
                              // Write to read critical delay difference from cs 0 to cs 3
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_WR_0_2;       // Byte offset 0x5a, CSR Addr 0x5402d, Direction=Out
                              // This is a signed integer value.
                              // Write to read critical delay difference from cs 0 to cs 2
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_WR_0_1;       // Byte offset 0x5b, CSR Addr 0x5402d, Direction=Out
                              // This is a signed integer value.
                              // Write to read critical delay difference from cs 0 to cs 1
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_WR_0_0;       // Byte offset 0x5c, CSR Addr 0x5402e, Direction=Out
                              // This is a signed integer value.
                              // Write to read critical delay difference from cs 0 to cs 0
                              // See PUB Databook section 8.2 for details on use of CDD values.
   uint8_t  Reserved5D;       // Byte offset 0x5d, CSR Addr 0x5402e, Direction=N/A
                              // This field is ignored if 0. If larger than 0, this value is used as is as the offset in fine-step applied at the end of DDR4 RxEnable training, instead of the default offset.
   uint16_t MR0;              // Byte offset 0x5e, CSR Addr 0x5402f, Direction=In
                              // Value of DDR mode register MR0 for all ranks for current pstate
   uint16_t MR1;              // Byte offset 0x60, CSR Addr 0x54030, Direction=In
                              // Value of DDR mode register MR1 for all ranks for current pstate
   uint16_t MR2;              // Byte offset 0x62, CSR Addr 0x54031, Direction=In
                              // Value of DDR mode register MR2 for all ranks for current pstate
   uint8_t  Reserved64;       // Byte offset 0x64, CSR Addr 0x54032, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved65;       // Byte offset 0x65, CSR Addr 0x54032, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
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
   uint8_t  Reserved6E;       // Byte offset 0x6e, CSR Addr 0x54037, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved6F;       // Byte offset 0x6f, CSR Addr 0x54037, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved70;       // Byte offset 0x70, CSR Addr 0x54038, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved71;       // Byte offset 0x71, CSR Addr 0x54038, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved72;       // Byte offset 0x72, CSR Addr 0x54039, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved73;       // Byte offset 0x73, CSR Addr 0x54039, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  AcsmOdtCtrl0;     // Byte offset 0x74, CSR Addr 0x5403a, Direction=In
                              // Odt pattern for accesses targeting rank 0. [3:0] is used for write ODT [7:4] is used for read ODT
   uint8_t  AcsmOdtCtrl1;     // Byte offset 0x75, CSR Addr 0x5403a, Direction=In
                              // Odt pattern for accesses targeting rank 1. [3:0] is used for write ODT [7:4] is used for read ODT
   uint8_t  AcsmOdtCtrl2;     // Byte offset 0x76, CSR Addr 0x5403b, Direction=In
                              // Odt pattern for accesses targeting rank 2. [3:0] is used for write ODT [7:4] is used for read ODT
   uint8_t  AcsmOdtCtrl3;     // Byte offset 0x77, CSR Addr 0x5403b, Direction=In
                              // Odt pattern for accesses targeting rank 3. [3:0] is used for write ODT [7:4] is used for read ODT
   uint8_t  AcsmOdtCtrl4;     // Byte offset 0x78, CSR Addr 0x5403c, Direction=In
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  AcsmOdtCtrl5;     // Byte offset 0x79, CSR Addr 0x5403c, Direction=In
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  AcsmOdtCtrl6;     // Byte offset 0x7a, CSR Addr 0x5403d, Direction=In
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  AcsmOdtCtrl7;     // Byte offset 0x7b, CSR Addr 0x5403d, Direction=In
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved7C;       // Byte offset 0x7c, CSR Addr 0x5403e, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved7D;       // Byte offset 0x7d, CSR Addr 0x5403e, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved7E;       // Byte offset 0x7e, CSR Addr 0x5403f, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved7F;       // Byte offset 0x7f, CSR Addr 0x5403f, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved80;       // Byte offset 0x80, CSR Addr 0x54040, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved81;       // Byte offset 0x81, CSR Addr 0x54040, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved82;       // Byte offset 0x82, CSR Addr 0x54041, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved83;       // Byte offset 0x83, CSR Addr 0x54041, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved84;           // Byte offset 0x84, CSR Addr 0x54042, Direction=N/A

   uint8_t  Reserved85;           // Byte offset 0x85, CSR Addr 0x54042, Direction=N/A

   uint8_t  Reserved86;           // Byte offset 0x86, CSR Addr 0x54043, Direction=N/A

   uint8_t  Reserved87;           // Byte offset 0x87, CSR Addr 0x54043, Direction=N/A

   uint8_t  Reserved88;           // Byte offset 0x88, CSR Addr 0x54044, Direction=N/A

   uint8_t  Reserved89;           // Byte offset 0x89, CSR Addr 0x54044, Direction=N/A

   uint8_t  Reserved8A;           // Byte offset 0x8a, CSR Addr 0x54045, Direction=N/A

   uint8_t  Reserved8B;           // Byte offset 0x8b, CSR Addr 0x54045, Direction=N/A

   uint8_t  Reserved8C;           // Byte offset 0x8c, CSR Addr 0x54046, Direction=N/A

   uint8_t  Reserved8D;           // Byte offset 0x8d, CSR Addr 0x54046, Direction=N/A

   uint8_t  Reserved8E;          // Byte offset 0x8e, CSR Addr 0x54047, Direction=N/A

   uint8_t  Reserved8F;          // Byte offset 0x8f, CSR Addr 0x54047, Direction=N/A

   uint8_t  Reserved90;          // Byte offset 0x90, CSR Addr 0x54048, Direction=N/A

   uint8_t  Reserved91;          // Byte offset 0x91, CSR Addr 0x54048, Direction=N/A

   uint8_t  Reserved92;          // Byte offset 0x92, CSR Addr 0x54049, Direction=N/A

   uint8_t  Reserved93;          // Byte offset 0x93, CSR Addr 0x54049, Direction=N/A

   uint8_t  Reserved94;           // Byte offset 0x94, CSR Addr 0x5404a, Direction=N/A

   uint8_t  Reserved95;           // Byte offset 0x95, CSR Addr 0x5404a, Direction=N/A

   uint8_t  Reserved96;           // Byte offset 0x96, CSR Addr 0x5404b, Direction=N/A

   uint8_t  Reserved97;           // Byte offset 0x97, CSR Addr 0x5404b, Direction=N/A

   uint8_t  Reserved98;           // Byte offset 0x98, CSR Addr 0x5404c, Direction=N/A

   uint8_t  Reserved99;           // Byte offset 0x99, CSR Addr 0x5404c, Direction=N/A

   uint8_t  Reserved9A;           // Byte offset 0x9a, CSR Addr 0x5404d, Direction=N/A

   uint8_t  Reserved9B;           // Byte offset 0x9b, CSR Addr 0x5404d, Direction=N/A

   uint8_t  Reserved9C;           // Byte offset 0x9c, CSR Addr 0x5404e, Direction=N/A

   uint8_t  Reserved9D;           // Byte offset 0x9d, CSR Addr 0x5404e, Direction=N/A

   uint8_t  Reserved9E;          // Byte offset 0x9e, CSR Addr 0x5404f, Direction=N/A

   uint8_t  Reserved9F;          // Byte offset 0x9f, CSR Addr 0x5404f, Direction=N/A

   uint8_t  ReservedA0;          // Byte offset 0xa0, CSR Addr 0x54050, Direction=N/A

   uint8_t  ReservedA1;          // Byte offset 0xa1, CSR Addr 0x54050, Direction=N/A

   uint8_t  ReservedA2;          // Byte offset 0xa2, CSR Addr 0x54051, Direction=N/A

   uint8_t  ReservedA3;          // Byte offset 0xa3, CSR Addr 0x54051, Direction=N/A

} __attribute__ ((packed)) PMU_SMB_DDR3U_1D_t;
