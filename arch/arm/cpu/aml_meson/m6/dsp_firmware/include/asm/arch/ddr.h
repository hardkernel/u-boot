#include "pctl.h"
#include "dmc.h"
#include "register.h"


//#define DDR3_533Mhz
////#define DDR2_400Mhz
//#ifdef DDR2_400Mhz
//#define init_pctl init_pctl_ddr2
//#else
//#define init_pctl init_pctl_ddr3
//#endif
#define NOP_CMD  0
#define PREA_CMD  1
#define REF_CMD  2
#define MRS_CMD  3
#define ZQ_SHORT_CMD 4
#define ZQ_LONG_CMD  5
#define SFT_RESET_CMD 6


typedef struct DDR_timing {
  unsigned short cl; // cas latency
  unsigned short t_faw;
  unsigned short t_mrd;
  unsigned short t_1us_pck;
  unsigned short t_100ns_pck;
  unsigned short t_init_us;
  unsigned short t_ras;
  unsigned short t_rc;
  unsigned short t_rcd;
  unsigned short t_refi_100ns;
  unsigned short t_rfc;
  unsigned short t_rp;
  unsigned short t_rrd;
  unsigned short t_rtp;
  unsigned short t_wr;
  unsigned short t_wtr;
  unsigned short t_xp;
  unsigned short t_xsrd;       // init to 0 so that if only one of them is defined, this is chosen
  unsigned short t_xsnr;
  unsigned short t_exsr;
  unsigned short t_al;     // Additive Latency
  unsigned short t_clr;    // cas_latency for DDR2 (nclk cycles)
  unsigned short t_dqs;    // distance between data phases to different ranks
  unsigned short t_cwl;     // cas write latency.
  unsigned short t_mod;     // MRS command  
  unsigned short t_zqcl;    // ZQ calibration long period in clock cycles.
  unsigned short t_cksrx;   // CKE maintained high before issuing self refresh command. 
  unsigned short t_cksre;   // Time after Self Refresh Entry that CKE is heold high before going low. 
  unsigned short t_cke;     // CKE minimum pulse width in memory clock cycles. 
  unsigned ddr_pll_cntl;
  unsigned ddr_clk;
  unsigned ddr_ctrl;
  int (* init_pctl)(void);
} DDR_Timing;
//#if 1
//static DDR_Timing timing_reg;
//#else
//#endif

#define ddr_pll_cntl    0
#define mmc_ddr_ctrl    1
#define t_1us_pck       2
#define t_100ns_pck     3
#define t_init_us       4
#define iocr            5
#define t_rsth          6
#define t_srtl          7
#define powstat         8
#define powctl          9
#define odtcfg          10
#define zqcr            11
#define t_refi          12
#define t_mrd           13
#define t_rfc           14
#define t_rp            15
#define t_al            16
#define t_cwl           17
#define t_cl            18
#define t_ras           19
#define t_rc            20
#define t_rcd           21
#define t_rrd           22
#define t_rtp           23
#define t_wr            24
#define t_wtr           25
#define t_exsr          26
#define t_xp            27
#define t_dqs           28
#define t_mod           29
#define t_zqcl          30
#define t_cksrx         31
#define t_cksre         32
#define t_cke           33
#define mcfg            34
#define phycr           35
#define rdgr0           36
#define rslr0           37
#define t_zqcsi         38
#define mmc_phy_ctrl    39
#define ddr_pll_cntl2   40
#define ddr_pll_cntl3   41
#define dllcr9          42
#define dllcr0          43
#define dllcr1          44
#define dllcr2          45
#define dllcr3          46
#define dqscr           47
#define dqsntr          48
#define tr0             49
#define tr1             50
#define tr2             51
#define tr3             52

#define DDR_SETTING_COUNT 53

#define v_ddr_pll_cntl    ddr_settings[ddr_pll_cntl]
#define v_mmc_ddr_ctrl    ddr_settings[mmc_ddr_ctrl]
#define v_t_1us_pck       ddr_settings[t_1us_pck]
#define v_t_100ns_pck     ddr_settings[t_100ns_pck]
#define v_t_init_us       ddr_settings[t_init_us]
#define v_iocr            ddr_settings[iocr]
#define v_t_rsth          ddr_settings[t_rsth]
#define v_t_srtl          ddr_settings[t_srtl]
#define v_powstat         ddr_settings[powstat]
#define v_powctl          ddr_settings[powctl]
#define v_odtcfg          ddr_settings[odtcfg]
#define v_zqcr            ddr_settings[zqcr]
#define v_t_refi          ddr_settings[t_refi]
#define v_t_mrd           ddr_settings[t_mrd]
#define v_t_rfc           ddr_settings[t_rfc]
#define v_t_rp            ddr_settings[t_rp]
#define v_t_al            ddr_settings[t_al]
#define v_t_cwl           ddr_settings[t_cwl]
#define v_t_cl            ddr_settings[t_cl]
#define v_t_ras           ddr_settings[t_ras]
#define v_t_rc            ddr_settings[t_rc]
#define v_t_rcd           ddr_settings[t_rcd]
#define v_t_rrd           ddr_settings[t_rrd]
#define v_t_rtp           ddr_settings[t_rtp]
#define v_t_wr            ddr_settings[t_wr]
#define v_t_wtr           ddr_settings[t_wtr]
#define v_t_exsr          ddr_settings[t_exsr]
#define v_t_xp            ddr_settings[t_xp]
#define v_t_dqs           ddr_settings[t_dqs]
#define v_t_mod           ddr_settings[t_mod]
#define v_t_zqcl          ddr_settings[t_zqcl]
#define v_t_cksrx         ddr_settings[t_cksrx]
#define v_t_cksre         ddr_settings[t_cksre]
#define v_t_cke           ddr_settings[t_cke]
#define v_mcfg            ddr_settings[mcfg]
#define v_phycr           ddr_settings[phycr]
#define v_rdgr0           ddr_settings[rdgr0]
#define v_rslr0           ddr_settings[rslr0]
#define v_t_zqcsi         ddr_settings[t_zqcsi]
#define	v_mmc_phy_ctrl    ddr_settings[mmc_phy_ctrl]
#define v_ddr_pll_cntl2   ddr_settings[ddr_pll_cntl2]
#define v_ddr_pll_cntl3   ddr_settings[ddr_pll_cntl3]
#define v_dllcr9          ddr_settings[dllcr9]
#define v_dllcr0          ddr_settings[dllcr0]
#define v_dllcr1          ddr_settings[dllcr1]
#define v_dllcr2          ddr_settings[dllcr2]
#define v_dllcr3          ddr_settings[dllcr3]
#define v_dqscr           ddr_settings[dqscr] 
#define v_dqsntr          ddr_settings[dqsntr]
#define v_tr0             ddr_settings[tr0]
#define v_tr1             ddr_settings[tr1]
#define v_tr2             ddr_settings[tr2]
#define v_tr3             ddr_settings[tr3]

extern unsigned ddr_settings[];
extern int init_pctl_ddr2(void);
extern int  init_pctl_ddr3(void);
extern int  ddr_phy_data_training(void);
extern void init_dmc(void);

extern void load_nop(void);
extern void load_prea(void);
extern void load_mrs(int mrs_num, int mrs_value);
extern void load_ref(void);
extern void load_zqcl(int zqcl_value);
extern void set_ddr_clock_333(void);
extern void set_ddr_clock_533(void);

