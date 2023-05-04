/*
 * drivers/display/vout/cvbs_performance.h
 *
 * Copyright (C) 2015 Amlogic, Inc. All rights reserved.
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
*/
#include <amlogic/cvbs.h>
#include "cvbs_regs.h"
#include "cvbs.h"

#ifdef CONFIG_CVBS_PERFORMANCE_COMPATIBILITY_SUPPORT
static const struct reg_s tvregs_576cvbs_china_sarft_m8[] = {
	{MREG_END_MARKER,		0      }
};

static const struct reg_s tvregs_576cvbs_china_telecom_m8[] = {
	{ENCI_SYNC_ADJ,				0x8060	},
	{ENCI_VIDEO_SAT,            0xfe	},
	{VENC_VDAC_DAC0_FILT_CTRL1, 0xf850	},
	{MREG_END_MARKER,			0		}
};

static const struct reg_s tvregs_576cvbs_china_mobile_m8[] = {
	{ENCI_SYNC_ADJ,				0x8060	},
	{ENCI_VIDEO_SAT,            0xfe	},
	{VENC_VDAC_DAC0_FILT_CTRL1, 0xf850	},
	{MREG_END_MARKER,			0       }
};

static const struct reg_s *tvregs_576cvbs_performance_m8[] = {
	tvregs_576cvbs_china_sarft_m8,
	tvregs_576cvbs_china_telecom_m8,
	tvregs_576cvbs_china_mobile_m8
};

static const struct reg_s tvregs_576cvbs_china_sarft_m8m2[] = {
	{ENCI_YC_DELAY,			0x343  },
	{MREG_END_MARKER,		0      }
};

static const struct reg_s tvregs_576cvbs_china_telecom_m8m2[] = {
	{ENCI_YC_DELAY,				0x343   },
	{ENCI_SYNC_ADJ,				0x8080	},
	{ENCI_VIDEO_SAT,            0xfd	},
	{VENC_VDAC_DAC0_FILT_CTRL1, 0xf850	},
	{MREG_END_MARKER,			0		}
};

static const struct reg_s tvregs_576cvbs_china_mobile_m8m2[] = {
	{ENCI_YC_DELAY,				0x343   },
	{ENCI_SYNC_ADJ,				0x8080	},
	{ENCI_VIDEO_SAT,            0xfd	},
	{VENC_VDAC_DAC0_FILT_CTRL1, 0xf850	},
	{MREG_END_MARKER,			0       }
};

static const struct reg_s *tvregs_576cvbs_performance_m8m2[] = {
	tvregs_576cvbs_china_sarft_m8m2,
	tvregs_576cvbs_china_telecom_m8m2,
	tvregs_576cvbs_china_mobile_m8m2
};

static const struct reg_s tvregs_576cvbs_china_sarft_m8b[] = {
	{ENCI_YC_DELAY,			0x343  },
	{MREG_END_MARKER,		0      }
};

static const struct reg_s tvregs_576cvbs_china_telecom_m8b[] = {
	{ENCI_YC_DELAY,				0x343   },
	{ENCI_SYNC_ADJ,				0x8080	},
	{ENCI_VIDEO_SAT,            0xfd	},
	{VENC_VDAC_DAC0_FILT_CTRL1, 0xf850	},
	{MREG_END_MARKER,			0		}
};

static const struct reg_s tvregs_576cvbs_china_mobile_m8b[] = {
	{ENCI_YC_DELAY,				0x343   },
	{ENCI_SYNC_ADJ,				0x8080	},
	{ENCI_VIDEO_SAT,            0xfd	},
	{VENC_VDAC_DAC0_FILT_CTRL1, 0xf850	},
	{MREG_END_MARKER,			0       }
};

static const struct reg_s *tvregs_576cvbs_performance_m8b[] = {
	tvregs_576cvbs_china_sarft_m8b,
	tvregs_576cvbs_china_telecom_m8b,
	tvregs_576cvbs_china_mobile_m8b
};

static const struct reg_s tvregs_576cvbs_china_sarft_gxbb[] = {
	{VENC_VDAC_DAC0_GAINCTRL,	0x9  },
	{ENCI_YC_DELAY,				0x343},
	{ENCI_VIDEO_SAT,			0x9	 },
	{MREG_END_MARKER,			0    }
};

static const struct reg_s tvregs_576cvbs_china_telecom_gxbb[] = {
	{VENC_VDAC_DAC0_GAINCTRL,	0x9		},
	{ENCI_YC_DELAY,				0x343   },
	{ENCI_SYNC_ADJ,				0x8080	},
	{ENCI_VIDEO_SAT,			0xfd	},
	{VENC_VDAC_DAC0_FILT_CTRL1,	0xf850	},
	{MREG_END_MARKER,			0		}
};

static const struct reg_s tvregs_576cvbs_china_mobile_gxbb[] = {
	{VENC_VDAC_DAC0_GAINCTRL,	0x9		},
	{ENCI_YC_DELAY,				0x343   },
	{ENCI_SYNC_ADJ,				0x8080	},
	{ENCI_VIDEO_SAT,			0xfd	},
	{VENC_VDAC_DAC0_FILT_CTRL1,	0xf850	},
	{MREG_END_MARKER,			0		}
};

static const struct reg_s *tvregs_576cvbs_performance_gxbb[] = {
	tvregs_576cvbs_china_sarft_gxbb,
	tvregs_576cvbs_china_telecom_gxbb,
	tvregs_576cvbs_china_mobile_gxbb
};

static const struct reg_s tvregs_576cvbs_china_sarft_gxtvbb[] = {
	{ENCI_YC_DELAY,				0x333	},
	{ENCI_VIDEO_SAT,			0xfb 	},
	{VENC_VDAC_DAC0_FILT_CTRL1,	0xff42	},
	{ENCI_SYNC_ADJ,				0x8c00	},
	{MREG_END_MARKER,			0    }
};

static const struct reg_s tvregs_576cvbs_china_telecom_gxtvbb[] = {
	{ENCI_YC_DELAY, 			0x333	},
	{ENCI_VIDEO_SAT,			0xfb	},
	{VENC_VDAC_DAC0_FILT_CTRL1, 0xff42	},
	{ENCI_SYNC_ADJ, 			0x8c00	},
	{MREG_END_MARKER,			0		}
};

static const struct reg_s tvregs_576cvbs_china_mobile_gxtvbb[] = {
	{ENCI_YC_DELAY, 			0x333	},
	{ENCI_VIDEO_SAT,			0xfb	},
	{VENC_VDAC_DAC0_FILT_CTRL1, 0xff42	},
	{ENCI_SYNC_ADJ, 			0x8c00	},
	{MREG_END_MARKER,			0		}
};

static const struct reg_s *tvregs_576cvbs_performance_gxtvbb[] = {
	tvregs_576cvbs_china_sarft_gxtvbb,
	tvregs_576cvbs_china_telecom_gxtvbb,
	tvregs_576cvbs_china_mobile_gxtvbb
};

static const struct reg_s tvregs_576cvbs_china_sarft_905x[] = {
	{VENC_VDAC_DAC0_GAINCTRL,	0x9  },
	{ENCI_YC_DELAY,				0x343},
	{ENCI_VIDEO_SAT,			0x9	 },
	{MREG_END_MARKER,			0    }
};

static const struct reg_s tvregs_576cvbs_china_telecom_905x[] = {
	{VENC_VDAC_DAC0_GAINCTRL,	0x9		},
	{ENCI_YC_DELAY,				0x343   },
	{ENCI_SYNC_ADJ,				0x8080	},
	{ENCI_VIDEO_SAT,			0xfd	},
	{VENC_VDAC_DAC0_FILT_CTRL1,	0xf752	},
	{MREG_END_MARKER,			0		}
};

static const struct reg_s tvregs_576cvbs_china_mobile_905x[] = {
	{VENC_VDAC_DAC0_GAINCTRL,	0x9		},
	{ENCI_YC_DELAY,				0x343   },
	{ENCI_SYNC_ADJ,				0x8080	},
	{ENCI_VIDEO_SAT,			0xfd	},
	{VENC_VDAC_DAC0_FILT_CTRL1,	0xf752	},
	{MREG_END_MARKER,			0		}
};

static const struct reg_s *tvregs_576cvbs_performance_905x[] = {
	tvregs_576cvbs_china_sarft_905x,
	tvregs_576cvbs_china_telecom_905x,
	tvregs_576cvbs_china_mobile_905x
};

static const struct reg_s tvregs_576cvbs_china_sarft_905l[] = {
	{VENC_VDAC_DAC0_GAINCTRL,	0x9		},
	{ENCI_YC_DELAY,				0x343	},
	{ENCI_SYNC_ADJ,				0x0		},
	{ENCI_VIDEO_SAT,			0x9		},
	{VENC_VDAC_DAC0_FILT_CTRL1,	0xfc48	},
	{MREG_END_MARKER,			0    	}
};

static const struct reg_s tvregs_576cvbs_china_telecom_905l[] = {
	{VENC_VDAC_DAC0_GAINCTRL,	0x9		},
	{ENCI_YC_DELAY,				0x333   },
	{ENCI_SYNC_ADJ,				0x8080	},
	{ENCI_VIDEO_SAT,			0xfd	},
	{VENC_VDAC_DAC0_FILT_CTRL1,	0xf850	},
	{MREG_END_MARKER,			0		}
};

static const struct reg_s tvregs_576cvbs_china_mobile_905l[] = {
	{VENC_VDAC_DAC0_GAINCTRL,	0x9		},
	{ENCI_YC_DELAY,				0x343   },
	{ENCI_SYNC_ADJ,				0x8080	},
	{ENCI_VIDEO_SAT,			0xfd	},
	{VENC_VDAC_DAC0_FILT_CTRL1,	0xf850	},
	{MREG_END_MARKER,			0		}
};

static const struct reg_s *tvregs_576cvbs_performance_905l[] = {
	tvregs_576cvbs_china_sarft_905l,
	tvregs_576cvbs_china_telecom_905l,
	tvregs_576cvbs_china_mobile_905l
};

static const struct reg_s tvregs_576cvbs_china_sarft_txl[] = {
	{ENCI_YC_DELAY,				0x333	},
	{ENCI_VIDEO_SAT,			0xf4	},
	{VENC_VDAC_DAC0_FILT_CTRL1,	0xfc48	},
	{ENCI_SYNC_ADJ,				0x8c00	},
	{MREG_END_MARKER,			0		}
};

static const struct reg_s tvregs_576cvbs_china_telecom_txl[] = {
	{ENCI_YC_DELAY,				0x333	},
	{ENCI_VIDEO_SAT,			0xf4	},
	{VENC_VDAC_DAC0_FILT_CTRL1,	0xfc48	},
	{ENCI_SYNC_ADJ,				0x8c00	},
	{MREG_END_MARKER,			0		}
};

static const struct reg_s tvregs_576cvbs_china_mobile_txl[] = {
	{ENCI_YC_DELAY,				0x333	},
	{ENCI_VIDEO_SAT,			0xf4	},
	{VENC_VDAC_DAC0_FILT_CTRL1,	0xfc48	},
	{ENCI_SYNC_ADJ,				0x8c00	},
	{MREG_END_MARKER,			0		}
};

static const struct reg_s *tvregs_576cvbs_performance_txl[] = {
	tvregs_576cvbs_china_sarft_txl,
	tvregs_576cvbs_china_telecom_txl,
	tvregs_576cvbs_china_mobile_txl
};

static const struct reg_s tvregs_576cvbs_china_sarft_g12a[] = {
	{VENC_VDAC_DAC0_GAINCTRL,	0x9		},
	{ENCI_YC_DELAY,				0x333	},
	{ENCI_SYNC_ADJ,				0x0		},
	{ENCI_VIDEO_SAT,			0x9		},
	{VENC_VDAC_DAC0_FILT_CTRL1,	0xfc48	},
	{MREG_END_MARKER,			0		}
};

static const struct reg_s tvregs_576cvbs_china_telecom_g12a[] = {
	{VENC_VDAC_DAC0_GAINCTRL,	0x9		},
	{ENCI_YC_DELAY,				0x333   },
	{ENCI_SYNC_ADJ,				0x8080	},
	{ENCI_VIDEO_SAT,			0xfd	},
	{VENC_VDAC_DAC0_FILT_CTRL1,	0xf850	},
	{MREG_END_MARKER,			0		}
};

static const struct reg_s tvregs_576cvbs_china_mobile_g12a[] = {
	{VENC_VDAC_DAC0_GAINCTRL,	0x9		},
	{ENCI_YC_DELAY,				0x333   },
	{ENCI_SYNC_ADJ,				0x8080	},
	{ENCI_VIDEO_SAT,			0xfd	},
	{VENC_VDAC_DAC0_FILT_CTRL1,	0xf850	},
	{MREG_END_MARKER,			0		}
};

static const struct reg_s tvregs_576cvbs_china_mobile_g12a_revB[] = {
	{VENC_VDAC_DAC0_GAINCTRL,	0x9		},
	{ENCI_YC_DELAY,				0x546   },
	{ENCI_SYNC_ADJ,				0x8080	},
	{ENCI_VIDEO_SAT,			0x9		},
	{VENC_VDAC_DAC0_FILT_CTRL1,	0xf850	},
	{MREG_END_MARKER,			0		}
};

static const struct reg_s *tvregs_576cvbs_performance_g12a[] = {
	tvregs_576cvbs_china_sarft_g12a,
	tvregs_576cvbs_china_telecom_g12a,
	tvregs_576cvbs_china_mobile_g12a,
	tvregs_576cvbs_china_mobile_g12a_revB
};

#endif

