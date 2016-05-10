/*
 * drivers/display/vout/cvbs_config.h
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

struct reg_s {
	unsigned int reg;
	unsigned int val;
};

#define MREG_END_MARKER 0xFFFF

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
	{VENC_VDAC_DAC0_GAINCTRL,	0x9  },
	{ENCI_YC_DELAY,				0x343},
	{ENCI_VIDEO_SAT,			0x9	 },
	{MREG_END_MARKER,			0    }
};

static const struct reg_s tvregs_576cvbs_china_telecom_905l[] = {
	{VENC_VDAC_DAC0_GAINCTRL,	0x9		},
	{ENCI_YC_DELAY,				0x343   },
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

#endif

static const struct reg_s tvregs_576cvbs_enc[] = {
	{ENCI_CFILT_CTRL,                 0x12,      },
	{ENCI_CFILT_CTRL2,                0x12,    	 },
	{VENC_DVI_SETTING,                0,         },
	{ENCI_VIDEO_MODE,                 0,         },
	{ENCI_VIDEO_MODE_ADV,             0,         },
	{ENCI_SYNC_HSO_BEGIN,             3,         },
	{ENCI_SYNC_HSO_END,               129,       },
	{ENCI_SYNC_VSO_EVNLN,             0x0003     },
	{ENCI_SYNC_VSO_ODDLN,             0x0104     },
	{ENCI_MACV_MAX_AMP,               0x8107     },
	{VENC_VIDEO_PROG_MODE,            0xff       },
	{ENCI_VIDEO_MODE,                 0x13       },
	{ENCI_VIDEO_MODE_ADV,             0x26,      },
	{ENCI_VIDEO_SCH,                  0x28,      },
	{ENCI_SYNC_MODE,                  0x07,      },
	{ENCI_YC_DELAY,                   0x333,     },
	{ENCI_VFIFO2VD_PIXEL_START,       0x0fb	     },
	{ENCI_VFIFO2VD_PIXEL_END,         0x069b     },
	{ENCI_VFIFO2VD_LINE_TOP_START,    0x0016     },
	{ENCI_VFIFO2VD_LINE_TOP_END,      0x0136     },
	{ENCI_VFIFO2VD_LINE_BOT_START,    0x0017     },
	{ENCI_VFIFO2VD_LINE_BOT_END,      0x0137     },
	{VENC_SYNC_ROUTE,                 0,         },
	{ENCI_DBG_PX_RST,                 0,         },
	{VENC_INTCTRL,                    0x2,       },
	{ENCI_VFIFO2VD_CTL,               0x4e01,    },
	{VENC_VDAC_SETTING,               0,         },
	{VENC_UPSAMPLE_CTRL0,             0x0061,    },
	{VENC_UPSAMPLE_CTRL1,             0x4061,    },
	{VENC_UPSAMPLE_CTRL2,             0x5061,    },
	{VENC_VDAC_DACSEL0,               0x0000,    },
	{VENC_VDAC_DACSEL1,               0x0000,    },
	{VENC_VDAC_DACSEL2,               0x0000,    },
	{VENC_VDAC_DACSEL3,               0x0000,    },
	{VENC_VDAC_DACSEL4,               0x0000,    },
	{VENC_VDAC_DACSEL5,               0x0000,    },
	{VPU_VIU_VENC_MUX_CTRL,           0x0005,    },
	{VENC_VDAC_FIFO_CTRL,             0x2000,    },
	{ENCI_DACSEL_0,                   0x0011     },
	{ENCI_DACSEL_1,                   0x11       },
	{ENCI_VIDEO_EN,                   1,         },
	{ENCI_VIDEO_SAT,                  0x7        },
	{VENC_VDAC_DAC0_FILT_CTRL0,       0x1        },
	{VENC_VDAC_DAC0_FILT_CTRL1,       0xfc48     },
	{ENCI_MACV_N0,                    0x0        },
	{MREG_END_MARKER,                 0          }
};

static const struct reg_s tvregs_480cvbs_enc[] = {
	{ENCI_CFILT_CTRL,                 0x12,      },
	{ENCI_CFILT_CTRL2,                0x12,      },
	{VENC_DVI_SETTING,                0,         },
	{ENCI_VIDEO_MODE,                 0,         },
	{ENCI_VIDEO_MODE_ADV,             0,         },
	{ENCI_SYNC_HSO_BEGIN,             5,         },
	{ENCI_SYNC_HSO_END,               129,       },
	{ENCI_SYNC_VSO_EVNLN,             0x0003     },
	{ENCI_SYNC_VSO_ODDLN,             0x0104     },
	{ENCI_MACV_MAX_AMP,               0x810b     },
	{VENC_VIDEO_PROG_MODE,            0xf0       },
	{ENCI_VIDEO_MODE,                 0x08       },
	{ENCI_VIDEO_MODE_ADV,             0x26,      },
	{ENCI_VIDEO_SCH,                  0x20,      },
	{ENCI_SYNC_MODE,                  0x07,      },
	{ENCI_YC_DELAY,                   0x333,     },
	{ENCI_VFIFO2VD_PIXEL_START,       0xe3,      },
	{ENCI_VFIFO2VD_PIXEL_END,         0x0683,    },
	{ENCI_VFIFO2VD_LINE_TOP_START,    0x12,      },
	{ENCI_VFIFO2VD_LINE_TOP_END,      0x102,     },
	{ENCI_VFIFO2VD_LINE_BOT_START,    0x13,      },
	{ENCI_VFIFO2VD_LINE_BOT_END,      0x103,     },
	{VENC_SYNC_ROUTE,                 0,         },
	{ENCI_DBG_PX_RST,                 0,         },
	{VENC_INTCTRL,                    0x2,       },
	{ENCI_VFIFO2VD_CTL,               0x4e01,    },
	{VENC_VDAC_SETTING,               0,         },
	{VENC_UPSAMPLE_CTRL0,             0x0061,    },
	{VENC_UPSAMPLE_CTRL1,             0x4061,    },
	{VENC_UPSAMPLE_CTRL2,             0x5061,    },
	{VENC_VDAC_DACSEL0,               0x0000,    },
	{VENC_VDAC_DACSEL1,               0x0000,    },
	{VENC_VDAC_DACSEL2,               0x0000,    },
	{VENC_VDAC_DACSEL3,               0x0000,    },
	{VENC_VDAC_DACSEL4,               0x0000,    },
	{VENC_VDAC_DACSEL5,               0x0000,    },
	{VPU_VIU_VENC_MUX_CTRL,           0x0005,    },
	{VENC_VDAC_FIFO_CTRL,             0x2000,    },
	{ENCI_DACSEL_0,                   0x0011     },
	{ENCI_DACSEL_1,                   0x11       },
	{ENCI_VIDEO_EN,                   1,         },
	{ENCI_VIDEO_SAT,                  0x12       },
	{VENC_VDAC_DAC0_FILT_CTRL0,       0x1        },
	{VENC_VDAC_DAC0_FILT_CTRL1,       0xfc48     },
	{ENCI_MACV_N0,                    0x0        },
	{ENCI_SYNC_ADJ,                   0x9c00     },
	{ENCI_VIDEO_CONT,                 0x3        },
	{MREG_END_MARKER,                 0          }
};

