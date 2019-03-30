
/** \file
 * \brief defines _PMU_SMB_LPDDR4_1D data structure
 */

/**  \brief LPDDR4_1D training firmware message block structure
 *
 *  Please refer to the Training Firmware App Note for futher information about
 *  the usage for Message Block.
 */
typedef struct _PMU_SMB_LPDDR4_1D_t {
   uint8_t  Reserved00;       // Byte offset 0x00, CSR Addr 0x54000, Direction=In
                              // Reserved00[0:4] RFU, must be zero
                              //
                              // Reserved00[5] = Quick Rd2D during 1D Training
                              //        0x1 =  Read Deskew will begin by enabling and quickly training the phy’s per-lane reference voltages.  Training the vrefDACs CSRs will increase the maximum 1D training time by around half a millisecond, but will improve 1D training accuracy on systems with significant voltage-offsets between lane read eyes.
                              //        0X0 =  Read Deskew will assume the messageblock’s phyVref setting is optimal for all lanes.
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
                              // MsgMisc[3] Disable Boot Clock
                              //      0x1 = Disable boot frequency clock when initializing DRAM. (not recommended)
                              //      0x0 = Use Boot Frequency Clock
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
                              // For example to set Vref at 0.25*VDDQ, set this field to 0x20.
                              //
                              // For digital simulation, any legal value can be used. For silicon, the users must calculate the analytical Vref by using the impedances, terminations, and series resistance present in the system.
   uint8_t  Lp4Misc;          // Byte offset 0x0d, CSR Addr 0x54006, Direction=In
                              // Lp4 specific options for training.
                              //
                              // Bit fields:
                              //
                              // Lp4Misc[0] Enable dfi_reset_n
                              //
                              // 0x0 = (Recommended) PHY internal registers control memreset during training, and also after training.
                              //  dfi_reset_n cannot control the PHY BP_MEMRESET_L pin.
                              //
                              // 0x1 = Enables dfi_reset_n to control memreset after training.
                              //  PHY Internal registers control memreset during training only.
                              //  To ensure that no glitches occur on BP_MEMRESET at the end of training,
                              //  The MC must drive dfi_reset_n=1'b1 _prior to starting training_
                              //
                              // Lp4Misc[7-1] RFU, must be zero
   uint8_t  Reserved0E;       // Byte offset 0x0e, CSR Addr 0x54007, Direction=In
                              // Bit Field for enabling optional 2D training features that impact both Rx2D and Tx2D.
                              //
                              // Reserved0E[0:3]: bitTimeControl
                              //     Input for increasing the number of data-comparisons 2D runs per (delay,voltage) point. Every time this input increases by 1, the number of 2D data comparisons is doubled. The 2D run time will increase proportionally to the number of bit times requested per point.
                              //     0 = 288 bits per point (legacy behavior)
                              //     1 = 576 bits per point
                              //     2 = 1.125 kilobits per point
                              //     …
                              //     15 = 9 megabits per point
                              //
                              // Reserved0E[4]: Exhaustive2D
                              //     0 = 2D’s optimization assumes the optimal trained point is near the 1D trained point (legacy behavior)
                              //     1 = 2D’s optimization searches the entire passing region at the cost of run time. Recommended for optimal results any time the optimal trained point is expected to be near the edges of the eyes instead of near the 1D trained point.
                              //
                              // Reserved0E[5:7]: RFU, must be 0
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
                              //    SequenceCtrl[4] = Run WrDQ1D - 1d write dq training
                              //    SequenceCtrl[5] = RFU, must be zero
                              //    SequenceCtrl[6] = RFU, must be zero
                              //    SequenceCtrl[7] = RFU, must be zero
                              //    SequenceCtrl[8] = Run RdDeskew - Per lane read dq deskew training
                              //    SequenceCtrl[9] = Run MxRdLat - Max read latency training
                              //    SequenceCtrl[11-10] = RFU, must be zero
                              //    SequenceCtrl[12]      = Run LPCA - CA Training
                              //    SequenceCtrl[15-13] = RFU, must be zero
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
   uint8_t  Reserved14;       // Byte offset 0x14, CSR Addr 0x5400a, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved15;       // Byte offset 0x15, CSR Addr 0x5400a, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  DFIMRLMargin;     // Byte offset 0x16, CSR Addr 0x5400b, Direction=In
                              // Margin added to smallest passing trained DFI Max Read Latency value, in units of DFI clocks. Recommended to be >= 1. See the Training App Note for more details on the training process and the use of this value.
                              //
                              // This margin must include the maximum positive drift expected in tDQSCK over the target temperature and voltage range of the users system.
   uint8_t  Reserved17;       // Byte offset 0x17, CSR Addr 0x5400b, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  UseBroadcastMR;   // Byte offset 0x18, CSR Addr 0x5400c, Direction=In
                              // Training firmware can optionally set per rank mode register values for DRAM partial array self-refresh features if desired.
                              //
                              //    0x0 = Use MR<0:17>_A0 for rank 0 channel A
                              //              Use MR<0:17>_B0 for rank 0 channel B
                              //              Use MR<0:17>_A1 for rank 1 channel A
                              //              Use MR<0:17>_B1 for rank 1 channel B
                              //
                              //    0x1 = Use MR<0:17>_A0 setting for all channels/ranks
                              //
                              // It is recommended in most LPDDR4 system configurations to set this to 1.
                              //
                              // Note: When set to 0, only mode registers associated with Vref CA, Vref DQ, and DRAM partial array self-refresh may differ between ranks and channels.
                              //
   uint8_t  Lp4Quickboot;     // Byte offset 0x19, CSR Addr 0x5400c, Direction=In
                              // Enable Quickboot.
   uint8_t  Reserved1A;       // Byte offset 0x1a, CSR Addr 0x5400d, Direction=In
                              // Input for constraining the range of vref(DQ) values training will collect data for, usually reducing training time. However, too large of a voltage range may cause longer 2D training times while too small of a voltage range may truncate passing regions. When in doubt, leave this field set to 0.
                              // Used by 2D stages: Rd2D, Wr2D
                              //
                              // Reserved1A[0-3]: Rd2D Voltage Range
                              //     0 = Training will search all phy vref(DQ) settings
                              //     1 = limit to +/-2 %VDDQ from phyVref
                              //     2 = limit to +/-4 %VDDQ from phyVref
                              //     …
                              //    15 = limit to +/-30% VDDQ from phyVref
                              //
                              // Reserved1A[4-7]: Wr2D Voltage Range
                              //     0 = Training will search all dram vref(DQ) settings
                              //     1 = limit to +/-2 %VDDQ from MR14
                              //     2 = limit to +/-4 %VDDQ from MR14
                              //     …
                              //    15 = limit to +/-30% VDDQ from MR14
   uint8_t  CATrainOpt;       // Byte offset 0x1b, CSR Addr 0x5400d, Direction=In
                              // CA training option bit field
                              // [0] CA VREF Training
                              //        1 = Enable CA VREF Training
                              //        0 = Disable CA VREF Training
                              // [1-7] RFU must be zero
   uint8_t  X8Mode;           // Byte offset 0x1c, CSR Addr 0x5400e, Direction=In
                              // X8 mode configuration:
                              // 0x0 = x16 configuration for all devices
                              // 0xF =  x8 configuration for all devices
                              // All other values are RFU
   uint8_t  Reserved1D;    // Byte offset 0x1d, CSR Addr 0x5400e, Direction=N/A
















   uint8_t  Reserved1E;    // Byte offset 0x1e, CSR Addr 0x5400f, Direction=N/A
















   uint8_t  Reserved1F; // Byte offset 0x1f, CSR Addr 0x5400f, Direction=N/A



   uint8_t  Reserved20;   // Byte offset 0x20, CSR Addr 0x54010, Direction=N/A

   uint8_t  Reserved21; // Byte offset 0x21, CSR Addr 0x54010, Direction=N/A

   uint16_t PhyConfigOverride; // Byte offset 0x22, CSR Addr 0x54011, Direction=In
                              // Override PhyConfig csr.
                              // 0x0: Use hardware csr value for PhyConfing (recommended)
                              // Other values: Use value for PhyConfig instead of Hardware value.
                              //
   uint8_t  EnabledDQsChA;    // Byte offset 0x24, CSR Addr 0x54012, Direction=In
                              // Total number of DQ bits enabled in PHY Channel A
   uint8_t  CsPresentChA;     // Byte offset 0x25, CSR Addr 0x54012, Direction=In
                              // Indicates presence of DRAM at each chip select for PHY channel A.
                              //
                              //  0x1 = CS0 is populated with DRAM
                              //  0x3 = CS0 and CS1 are populated with DRAM
                              //
                              // All other encodings are illegal
                              //
   int8_t   CDD_ChA_RR_1_0;   // Byte offset 0x26, CSR Addr 0x54013, Direction=Out
                              // This is a signed integer value.
                              // Read to read critical delay difference from cs 1 to cs 0 on Channel A
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_ChA_RR_0_1;   // Byte offset 0x27, CSR Addr 0x54013, Direction=Out
                              // This is a signed integer value.
                              // Read to read critical delay difference from cs 0 to cs 1 on Channel A
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_ChA_RW_1_1;   // Byte offset 0x28, CSR Addr 0x54014, Direction=Out
                              // This is a signed integer value.
                              // Read to write critical delay difference from cs 1 to cs 1 on Channel A
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_ChA_RW_1_0;   // Byte offset 0x29, CSR Addr 0x54014, Direction=Out
                              // This is a signed integer value.
                              // Read to write critical delay difference from cs 1 to cs 0 on Channel A
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_ChA_RW_0_1;   // Byte offset 0x2a, CSR Addr 0x54015, Direction=Out
                              // This is a signed integer value.
                              // Read to write critical delay difference from cs 0 to cs 1 on Channel A
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_ChA_RW_0_0;   // Byte offset 0x2b, CSR Addr 0x54015, Direction=Out
                              // This is a signed integer value.
                              // Read to write critical delay difference from cs0 to cs 0 on Channel A
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_ChA_WR_1_1;   // Byte offset 0x2c, CSR Addr 0x54016, Direction=Out
                              // This is a signed integer value.
                              // Write  to read critical delay difference from cs 1 to cs 1 on Channel A
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_ChA_WR_1_0;   // Byte offset 0x2d, CSR Addr 0x54016, Direction=Out
                              // This is a signed integer value.
                              // Write  to read critical delay difference from cs 1 to cs 0 on Channel A
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_ChA_WR_0_1;   // Byte offset 0x2e, CSR Addr 0x54017, Direction=Out
                              // This is a signed integer value.
                              // Write  to read critical delay difference from cs 0 to cs 1 on Channel A
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_ChA_WR_0_0;   // Byte offset 0x2f, CSR Addr 0x54017, Direction=Out
                              // This is a signed integer value.
                              // Write  to read critical delay difference from cs 0 to cs 0 on Channel A
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_ChA_WW_1_0;   // Byte offset 0x30, CSR Addr 0x54018, Direction=Out
                              // This is a signed integer value.
                              // Write  to write critical delay difference from cs 1 to cs 0 on Channel A
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_ChA_WW_0_1;   // Byte offset 0x31, CSR Addr 0x54018, Direction=Out
                              // This is a signed integer value.
                              // Write  to write critical delay difference from cs 0 to cs 1 on Channel A
                              // See PUB Databook section 8.2 for details on use of CDD values.
   uint8_t  MR1_A0;           // Byte offset 0x32, CSR Addr 0x54019, Direction=In
                              // Value to be programmed in DRAM Mode Register 1 {Channel A, Rank 0}
   uint8_t  MR2_A0;           // Byte offset 0x33, CSR Addr 0x54019, Direction=In
                              // Value to be programmed in DRAM Mode Register 2 {Channel A, Rank 0}
   uint8_t  MR3_A0;           // Byte offset 0x34, CSR Addr 0x5401a, Direction=In
                              // Value to be programmed in DRAM Mode Register 3 {Channel A, Rank 0}
   uint8_t  MR4_A0;           // Byte offset 0x35, CSR Addr 0x5401a, Direction=In
                              // Value to be programmed in DRAM Mode Register 4 {Channel A, Rank 0}
   uint8_t  MR11_A0;          // Byte offset 0x36, CSR Addr 0x5401b, Direction=In
                              // Value to be programmed in DRAM Mode Register 11 {Channel A, Rank 0}
   uint8_t  MR12_A0;          // Byte offset 0x37, CSR Addr 0x5401b, Direction=In
                              // Value to be programmed in DRAM Mode Register 12 {Channel A, Rank 0}
   uint8_t  MR13_A0;          // Byte offset 0x38, CSR Addr 0x5401c, Direction=In
                              // Value to be programmed in DRAM Mode Register 13 {Channel A, Rank 0}
   uint8_t  MR14_A0;          // Byte offset 0x39, CSR Addr 0x5401c, Direction=In
                              // Value to be programmed in DRAM Mode Register 14 {Channel A, Rank 0}
   uint8_t  MR16_A0;          // Byte offset 0x3a, CSR Addr 0x5401d, Direction=In
                              // Value to be programmed in DRAM Mode Register 16 {Channel A, Rank 0}
   uint8_t  MR17_A0;          // Byte offset 0x3b, CSR Addr 0x5401d, Direction=In
                              // Value to be programmed in DRAM Mode Register 17 {Channel A, Rank 0}
   uint8_t  MR22_A0;          // Byte offset 0x3c, CSR Addr 0x5401e, Direction=In
                              // Value to be programmed in DRAM Mode Register 22 {Channel A, Rank 0}
   uint8_t  MR24_A0;          // Byte offset 0x3d, CSR Addr 0x5401e, Direction=In
                              // Value to be programmed in DRAM Mode Register 24 {Channel A, Rank 0}
   uint8_t  MR1_A1;           // Byte offset 0x3e, CSR Addr 0x5401f, Direction=In
                              // Value to be programmed in DRAM Mode Register 1 {Channel A, Rank 1}
   uint8_t  MR2_A1;           // Byte offset 0x3f, CSR Addr 0x5401f, Direction=In
                              // Value to be programmed in DRAM Mode Register 2 {Channel A, Rank 1}
   uint8_t  MR3_A1;           // Byte offset 0x40, CSR Addr 0x54020, Direction=In
                              // Value to be programmed in DRAM Mode Register 3 {Channel A, Rank 1}
   uint8_t  MR4_A1;           // Byte offset 0x41, CSR Addr 0x54020, Direction=In
                              // Value to be programmed in DRAM Mode Register 4 {Channel A, Rank 1}
   uint8_t  MR11_A1;          // Byte offset 0x42, CSR Addr 0x54021, Direction=In
                              // Value to be programmed in DRAM Mode Register 11 {Channel A, Rank 1}
   uint8_t  MR12_A1;          // Byte offset 0x43, CSR Addr 0x54021, Direction=In
                              // Value to be programmed in DRAM Mode Register 12 {Channel A, Rank 1}
   uint8_t  MR13_A1;          // Byte offset 0x44, CSR Addr 0x54022, Direction=In
                              // Value to be programmed in DRAM Mode Register 13 {Channel A, Rank 1}
   uint8_t  MR14_A1;          // Byte offset 0x45, CSR Addr 0x54022, Direction=In
                              // Value to be programmed in DRAM Mode Register 14 {Channel A, Rank 1}
   uint8_t  MR16_A1;          // Byte offset 0x46, CSR Addr 0x54023, Direction=In
                              // Value to be programmed in DRAM Mode Register 16 {Channel A, Rank 1}
   uint8_t  MR17_A1;          // Byte offset 0x47, CSR Addr 0x54023, Direction=In
                              // Value to be programmed in DRAM Mode Register 17 {Channel A, Rank 1}
   uint8_t  MR22_A1;          // Byte offset 0x48, CSR Addr 0x54024, Direction=In
                              // Value to be programmed in DRAM Mode Register 22 {Channel A, Rank 1}
   uint8_t  MR24_A1;          // Byte offset 0x49, CSR Addr 0x54024, Direction=In
                              // Value to be programmed in DRAM Mode Register 24 {Channel A, Rank 1}
   uint8_t  CATerminatingRankChA; // Byte offset 0x4a, CSR Addr 0x54025, Direction=In
                              // Terminating Rank for CA bus on Channel A
                              //    0x0 = Rank 0 is terminating rank
                              //    0x1 = Rank 1 is terminating rank
   uint8_t  Reserved4B; // Byte offset 0x4b, CSR Addr 0x54025, Direction=N/A

   uint8_t  Reserved4C; // Byte offset 0x4c, CSR Addr 0x54026, Direction=N/A

   uint8_t  Reserved4D; // Byte offset 0x4d, CSR Addr 0x54026, Direction=N/A

   uint8_t  Reserved4E; // Byte offset 0x4e, CSR Addr 0x54027, Direction=N/A

   uint8_t  Reserved4F; // Byte offset 0x4f, CSR Addr 0x54027, Direction=N/A

   uint8_t  Reserved50; // Byte offset 0x50, CSR Addr 0x54028, Direction=N/A

   uint8_t  Reserved51; // Byte offset 0x51, CSR Addr 0x54028, Direction=N/A

   uint8_t  Reserved52; // Byte offset 0x52, CSR Addr 0x54029, Direction=N/A

   uint8_t  Reserved53; // Byte offset 0x53, CSR Addr 0x54029, Direction=N/A

   uint8_t  Reserved54; // Byte offset 0x54, CSR Addr 0x5402a, Direction=N/A

   uint8_t  Reserved55; // Byte offset 0x55, CSR Addr 0x5402a, Direction=N/A

   uint8_t  Reserved56; // Byte offset 0x56, CSR Addr 0x5402b, Direction=N/A

   uint8_t  EnabledDQsChB;    // Byte offset 0x57, CSR Addr 0x5402b, Direction=In
                              // Total number of DQ bits enabled in PHY Channel B
   uint8_t  CsPresentChB;     // Byte offset 0x58, CSR Addr 0x5402c, Direction=In
                              // Indicates presence of DRAM at each chip select for PHY channel B.
                              //
                              //    0x0 = No chip selects are populated with DRAM
                              //    0x1 = CS0 is populated with DRAM
                              //    0x3 = CS0 and CS1 are populated with DRAM
                              //
                              // All other encodings are illegal
                              //
   int8_t   CDD_ChB_RR_1_0;   // Byte offset 0x59, CSR Addr 0x5402c, Direction=Out
                              // This is a signed integer value.
                              // Read to read critical delay difference from cs 1 to cs 0 on Channel B
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_ChB_RR_0_1;   // Byte offset 0x5a, CSR Addr 0x5402d, Direction=Out
                              // This is a signed integer value.
                              // Read to read critical delay difference from cs 0 to cs 1 on Channel B
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_ChB_RW_1_1;   // Byte offset 0x5b, CSR Addr 0x5402d, Direction=Out
                              // This is a signed integer value.
                              // Read to write critical delay difference from cs 1 to cs 1 on Channel B
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_ChB_RW_1_0;   // Byte offset 0x5c, CSR Addr 0x5402e, Direction=Out
                              // This is a signed integer value.
                              // Read to write critical delay difference from cs 1 to cs 0 on Channel B
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_ChB_RW_0_1;   // Byte offset 0x5d, CSR Addr 0x5402e, Direction=Out
                              // This is a signed integer value.
                              // Read to write critical delay difference from cs 0 to cs 1 on Channel B
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_ChB_RW_0_0;   // Byte offset 0x5e, CSR Addr 0x5402f, Direction=Out
                              // This is a signed integer value.
                              // Read to write critical delay difference from cs01 to cs 0 on Channel B
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_ChB_WR_1_1;   // Byte offset 0x5f, CSR Addr 0x5402f, Direction=Out
                              // This is a signed integer value.
                              // Write  to read critical delay difference from cs 1 to cs 1 on Channel B
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_ChB_WR_1_0;   // Byte offset 0x60, CSR Addr 0x54030, Direction=Out
                              // This is a signed integer value.
                              // Write  to read critical delay difference from cs 1 to cs 0 on Channel B
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_ChB_WR_0_1;   // Byte offset 0x61, CSR Addr 0x54030, Direction=Out
                              // This is a signed integer value.
                              // Write  to read critical delay difference from cs 0 to cs 1 on Channel B
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_ChB_WR_0_0;   // Byte offset 0x62, CSR Addr 0x54031, Direction=Out
                              // This is a signed integer value.
                              // Write  to read critical delay difference from cs 0 to cs 0 on Channel B
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_ChB_WW_1_0;   // Byte offset 0x63, CSR Addr 0x54031, Direction=Out
                              // This is a signed integer value.
                              // Write  to write critical delay difference from cs 1 to cs 0 on Channel B
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_ChB_WW_0_1;   // Byte offset 0x64, CSR Addr 0x54032, Direction=Out
                              // This is a signed integer value.
                              // Write  to write critical delay difference from cs 0 to cs 1 on Channel B
                              // See PUB Databook section 8.2 for details on use of CDD values.
   uint8_t  MR1_B0;           // Byte offset 0x65, CSR Addr 0x54032, Direction=In
                              // Value to be programmed in DRAM Mode Register 1 {Channel B, Rank 0}
   uint8_t  MR2_B0;           // Byte offset 0x66, CSR Addr 0x54033, Direction=In
                              // Value to be programmed in DRAM Mode Register 2 {Channel B, Rank 0}
   uint8_t  MR3_B0;           // Byte offset 0x67, CSR Addr 0x54033, Direction=In
                              // Value to be programmed in DRAM Mode Register 3 {Channel B, Rank 0}
   uint8_t  MR4_B0;           // Byte offset 0x68, CSR Addr 0x54034, Direction=In
                              // Value to be programmed in DRAM Mode Register 4 {Channel B, Rank 0}
   uint8_t  MR11_B0;          // Byte offset 0x69, CSR Addr 0x54034, Direction=In
                              // Value to be programmed in DRAM Mode Register 11 {Channel B, Rank 0}
   uint8_t  MR12_B0;          // Byte offset 0x6a, CSR Addr 0x54035, Direction=In
                              // Value to be programmed in DRAM Mode Register 12 {Channel B, Rank 0}
   uint8_t  MR13_B0;          // Byte offset 0x6b, CSR Addr 0x54035, Direction=In
                              // Value to be programmed in DRAM Mode Register 13 {Channel B, Rank 0}
   uint8_t  MR14_B0;          // Byte offset 0x6c, CSR Addr 0x54036, Direction=In
                              // Value to be programmed in DRAM Mode Register 14 {Channel B, Rank 0}
   uint8_t  MR16_B0;          // Byte offset 0x6d, CSR Addr 0x54036, Direction=In
                              // Value to be programmed in DRAM Mode Register 16 {Channel B, Rank 0}
   uint8_t  MR17_B0;          // Byte offset 0x6e, CSR Addr 0x54037, Direction=In
                              // Value to be programmed in DRAM Mode Register 17 {Channel B, Rank 0}
   uint8_t  MR22_B0;          // Byte offset 0x6f, CSR Addr 0x54037, Direction=In
                              // Value to be programmed in DRAM Mode Register 22 {Channel B, Rank 0}
   uint8_t  MR24_B0;          // Byte offset 0x70, CSR Addr 0x54038, Direction=In
                              // Value to be programmed in DRAM Mode Register 24 {Channel B, Rank 0}
   uint8_t  MR1_B1;           // Byte offset 0x71, CSR Addr 0x54038, Direction=In
                              // Value to be programmed in DRAM Mode Register 1 {Channel B, Rank 1}
   uint8_t  MR2_B1;           // Byte offset 0x72, CSR Addr 0x54039, Direction=In
                              // Value to be programmed in DRAM Mode Register 2 {Channel B, Rank 1}
   uint8_t  MR3_B1;           // Byte offset 0x73, CSR Addr 0x54039, Direction=In
                              // Value to be programmed in DRAM Mode Register 3 {Channel B, Rank 1}
   uint8_t  MR4_B1;           // Byte offset 0x74, CSR Addr 0x5403a, Direction=In
                              // Value to be programmed in DRAM Mode Register 4 {Channel B, Rank 1}
   uint8_t  MR11_B1;          // Byte offset 0x75, CSR Addr 0x5403a, Direction=In
                              // Value to be programmed in DRAM Mode Register 11 {Channel B, Rank 1}
   uint8_t  MR12_B1;          // Byte offset 0x76, CSR Addr 0x5403b, Direction=In
                              // Value to be programmed in DRAM Mode Register 12 {Channel B, Rank 1}
   uint8_t  MR13_B1;          // Byte offset 0x77, CSR Addr 0x5403b, Direction=In
                              // Value to be programmed in DRAM Mode Register 13 {Channel B, Rank 1}
   uint8_t  MR14_B1;          // Byte offset 0x78, CSR Addr 0x5403c, Direction=In
                              // Value to be programmed in DRAM Mode Register 14 {Channel B, Rank 1}
   uint8_t  MR16_B1;          // Byte offset 0x79, CSR Addr 0x5403c, Direction=In
                              // Value to be programmed in DRAM Mode Register 16 {Channel B, Rank 1}
   uint8_t  MR17_B1;          // Byte offset 0x7a, CSR Addr 0x5403d, Direction=In
                              // Value to be programmed in DRAM Mode Register 17 {Channel B, Rank 1}
   uint8_t  MR22_B1;          // Byte offset 0x7b, CSR Addr 0x5403d, Direction=In
                              // Value to be programmed in DRAM Mode Register 22 {Channel B, Rank 1}
   uint8_t  MR24_B1;          // Byte offset 0x7c, CSR Addr 0x5403e, Direction=In
                              // Value to be programmed in DRAM Mode Register 24 {Channel B, Rank 1}
   uint8_t  CATerminatingRankChB; // Byte offset 0x7d, CSR Addr 0x5403e, Direction=In
                              // Terminating Rank for CA bus on Channel B
                              //    0x0 = Rank 0 is terminating rank
                              //    0x1 = Rank 1 is terminating rank
   uint8_t  Reserved7E; // Byte offset 0x7e, CSR Addr 0x5403f, Direction=N/A

   uint8_t  Reserved7F; // Byte offset 0x7f, CSR Addr 0x5403f, Direction=N/A

   uint8_t  Reserved80; // Byte offset 0x80, CSR Addr 0x54040, Direction=N/A

   uint8_t  Reserved81; // Byte offset 0x81, CSR Addr 0x54040, Direction=N/A

   uint8_t  Reserved82; // Byte offset 0x82, CSR Addr 0x54041, Direction=N/A

   uint8_t  Reserved83; // Byte offset 0x83, CSR Addr 0x54041, Direction=N/A

   uint8_t  Reserved84; // Byte offset 0x84, CSR Addr 0x54042, Direction=N/A

   uint8_t  Reserved85; // Byte offset 0x85, CSR Addr 0x54042, Direction=N/A

   uint8_t  Reserved86; // Byte offset 0x86, CSR Addr 0x54043, Direction=N/A

   uint8_t  Reserved87; // Byte offset 0x87, CSR Addr 0x54043, Direction=N/A

   uint8_t  Reserved88; // Byte offset 0x88, CSR Addr 0x54044, Direction=N/A

   uint8_t  Reserved89; // Byte offset 0x89, CSR Addr 0x54044, Direction=N/A

} __attribute__ ((packed)) PMU_SMB_LPDDR4_1D_t;
