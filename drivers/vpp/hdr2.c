#include <asm/cpu_id.h>
#include <malloc.h>
#include "hdr2.h"
#include "aml_vpp_reg.h"

int cgain_lut0[65] = {
	0x400, 0x400, 0x400, 0x400, 0x400, 0x400, 0x400, 0x400, 0x400,
	0x400, 0x400, 0x400, 0x400, 0x400, 0x400, 0x400, 0x400, 0x400,
	0x4c0, 0x400, 0x400, 0x400, 0x400, 0x400, 0x400, 0x400, 0x400,
	0x400, 0x400, 0x400, 0x400, 0x400, 0x400, 0x400, 0x400, 0x40e,
	0x429, 0x444, 0x45f, 0x479, 0x492, 0x4ab, 0x4c3, 0x4db, 0x4f2,
	0x509, 0x520, 0x536, 0x54c, 0x561, 0x576, 0x58b, 0x59f, 0x5b3,
	0x5c0, 0x5d0, 0x5f2, 0x609, 0x620, 0x636, 0x64c, 0x661, 0x676,
	0x68b, 0x69f
};

int cgain_lut1[65] = {
	0x400, 0x400, 0x400, 0x400, 0x400, 0x400, 0x400, 0x400, 0x400,
	0x400, 0x400, 0x400, 0x400, 0x400, 0x400, 0x400, 0x400, 0x400,
	0x400, 0x400, 0x400, 0x400, 0x400, 0x400, 0x400, 0x400, 0x400,
	0x400, 0x400, 0x400, 0x400, 0x400, 0x400, 0x400, 0x400, 0x400,
	0x400, 0x400, 0x400, 0x400, 0x400, 0x400, 0x400, 0x400, 0x40e,
	0x419, 0x424, 0x43f, 0x449, 0x452, 0x46b, 0x473, 0x48b, 0x492,
	0x4a9, 0x4b0, 0x4c6, 0x4dc, 0x4e1, 0x4f6, 0x50b, 0x51f, 0x523,
	0x530, 0x540
};

int cgain_lut_bypass[65] = {
	0x400, 0x400, 0x400, 0x400, 0x400, 0x400, 0x400, 0x400, 0x400,
	0x400, 0x400, 0x400, 0x400, 0x400, 0x400, 0x400, 0x400, 0x400,
	0x400, 0x400, 0x400, 0x400, 0x400, 0x400, 0x400, 0x400, 0x400,
	0x400, 0x400, 0x400, 0x400, 0x400, 0x400, 0x400, 0x400, 0x400,
	0x400, 0x400, 0x400, 0x400, 0x400, 0x400, 0x400, 0x400, 0x400,
	0x400, 0x400, 0x400, 0x400, 0x400, 0x400, 0x400, 0x400, 0x400,
	0x400, 0x400, 0x400, 0x400, 0x400, 0x400, 0x400, 0x400, 0x400,
	0x400, 0x400
};

int cgain_lut2[65] = {
	0xc00, 0xc00, 0xc00, 0xc00, 0xc00, 0xc00, 0xc00, 0xc00, 0xc00,
	0xc00, 0xc00, 0xc0e, 0xc79, 0xcdb, 0xd36, 0xd8b, 0xdda, 0xe25,
	0xe6b, 0xead, 0xeec, 0xf28, 0xf61, 0xf98, 0xfcc, 0xfff, 0x102f,
	0x105d, 0x108a, 0x10b5, 0x10df, 0x1107, 0x112e, 0x1154, 0x1178, 0x119c,
	0x11bf, 0x11e0, 0x1201, 0x1221, 0x1240, 0x125e, 0x127c, 0x1299, 0x12b5,
	0x12d1, 0x12ec, 0x1306, 0x1320, 0x1339, 0x1352, 0x136b, 0x1383, 0x139a,
	0x13b1, 0x13c7, 0x13de, 0x13f3, 0x1409, 0x141e, 0x1432, 0x1447, 0x145b,
	0x146e, 0x1482
};

int eo_y_lut_hdr[143] = {
	132288, 136832, 165440, 181832, 193440, 202088, 210400, 216476, 221882,
	227920, 231986, 235648, 239639, 243964, 247193, 249698, 252377, 271330,
	285261, 297148, 306377, 314682, 321922, 329204, 334486, 340750, 346085,
	350369, 355325, 360734, 363991, 367697, 371896, 376636, 379400, 382389,
	385731, 389458, 393410, 395711, 398260, 401078, 404188, 407615, 410492,
	412562, 414834, 417322, 420045, 423021, 426127, 427900, 429831, 431934,
	434222, 436709, 439410, 442342, 443945, 445668, 447230, 448187, 449224,
	450344, 451555, 452864, 454277, 455803, 457449, 458988, 459945, 460977,
	462089, 463286, 464576, 465964, 467458, 469066, 470795, 472655, 474655,
	475971, 477126, 478368, 479702, 481136, 482676, 484330, 486107, 488015,
	490063, 491891, 493071, 494339, 495699, 497159, 498727, 500409, 502262,
	504308, 506503, 508381, 509646, 511003, 512460, 512934, 513098, 513279,
	513477, 513691, 513923, 514172, 514438, 514720, 515017, 515328, 515650,
	515981, 516320, 516662, 517006, 517349, 517689, 518022, 518347, 518662,
	518968, 519263, 519549, 519827, 520097, 520363, 520625, 520888, 521155,
	521431, 521727, 522054, 522431, 522871, 523371, 523881, 524287
};

int eo_y_lut_hlg[143] = {
	0, 169296, 202068, 221184, 234837, 246442, 253952, 262485, 267605,
	273408, 279210, 282794, 286720, 290986, 295253, 297728, 300373, 319488,
	333141, 344746, 352256, 360789, 365909, 371712, 377514, 381098, 385024,
	389290, 393557, 396032, 398677, 401493, 404480, 407637, 410282, 412032,
	413866, 415786, 417792, 419882, 422058, 424320, 426325, 427541, 428800,
	430101, 431445, 432832, 434261, 435733, 437248, 438805, 440405, 442048,
	443050, 443914, 444800, 445706, 446634, 447584, 448554, 449546, 450560,
	451594, 452650, 453728, 454826, 455946, 457088, 458250, 459093, 459696,
	460309, 460933, 461568, 462213, 462869, 463536, 464213, 464911, 465640,
	466401, 467197, 468028, 468896, 469803, 470750, 471740, 472774, 473854,
	474982, 475648, 476264, 476907, 477579, 478281, 479014, 479780, 480580,
	481416, 482289, 483201, 484154, 485150, 486190, 487276, 488411, 489597,
	490835, 491824, 492500, 493206, 493944, 494714, 495519, 496360, 497238,
	498156, 499114, 500115, 501161, 502254, 503396, 504588, 505834, 507135,
	508199, 508909, 509651, 510426, 511236, 512081, 512965, 513888, 514852,
	515859, 516911, 518010, 519158, 520358, 521611, 522920, 524287
};

int eo_y_lut_sdr[143] = {
	0, 163808, 199044, 219568, 234610, 247036, 255751, 264272, 270593,
	277939, 282430, 287163, 292441, 296593, 299792, 303278, 307054, 328697,
	344063, 354448, 364052, 372123, 379268, 384835, 391196, 395793, 399793,
	404214, 409063, 411973, 414834, 417919, 421229, 424767, 427260, 429261,
	431380, 433618, 435975, 438453, 441054, 443072, 444496, 445981, 447530,
	449142, 450817, 452556, 454360, 456229, 458163, 459457, 460489, 461555,
	462654, 463787, 464953, 466153, 467387, 468655, 469957, 471294, 472665,
	474071, 475324, 476062, 476817, 477590, 478381, 479190, 480016, 480861,
	481723, 482603, 483502, 484418, 485353, 486306, 487278, 488267, 489276,
	490302, 491348, 491966, 492507, 493057, 493618, 494187, 494766, 495354,
	495952, 496559, 497176, 497803, 498439, 499084, 499740, 500405, 501079,
	501764, 502458, 503161, 503875, 504598, 505332, 506075, 506828, 507590,
	508133, 508525, 508921, 509322, 509728, 510140, 510556, 510977, 511404,
	511835, 512272, 512713, 513160, 513611, 514068, 514530, 514997, 515469,
	515946, 516429, 516916, 517409, 517907, 518410, 518918, 519432, 519950,
	520474, 521003, 521537, 522077, 522622, 523172, 523727, 524287
};

int eo_y_lut_bypass[143] = {
	0, 360448, 376832, 385024, 393216, 397312, 401408, 405504, 409600,
	411648, 413696, 415744, 417792, 419840, 421888, 423936, 425984, 434176,
	442368, 446464, 450560, 454656, 458752, 460800, 462848, 464896, 466944,
	468992, 471040, 473088, 475136, 476160, 477184, 478208, 479232, 480256,
	481280, 482304, 483328, 484352, 485376, 486400, 487424, 488448, 489472,
	490496, 491520, 492032, 492544, 493056, 493568, 494080, 494592, 495104,
	495616, 496128, 496640, 497152, 497664, 498176, 498688, 499200, 499712,
	500224, 500736, 501248, 501760, 502272, 502784, 503296, 503808, 504320,
	504832, 505344, 505856, 506368, 506880, 507392, 507904, 508160, 508416,
	508672, 508928, 509184, 509440, 509696, 509952, 510208, 510464, 510720,
	510976, 511232, 511488, 511744, 512000, 512256, 512512, 512768, 513024,
	513280, 513536, 513792, 514048, 514304, 514560, 514816, 515072, 515328,
	515584, 515840, 516096, 516352, 516608, 516864, 517120, 517376, 517632,
	517888, 518144, 518400, 518656, 518912, 519168, 519424, 519680, 519936,
	520192, 520448, 520704, 520960, 521216, 521472, 521728, 521984, 522240,
	522496, 522752, 523008, 523264, 523520, 523776, 524032, 524287
};

int oe_y_lut_hdr[149] = {0, 3, 5, 8, 12, 19, 28, 41, 60, 67, 74, 80, 85,
	96, 105, 113, 120, 134, 146, 157, 167, 184, 200, 214, 227, 250, 270,
	288, 304, 332, 357, 380, 400, 435, 465, 492, 517, 559, 595, 628, 656,
	706, 749, 787, 820, 850, 878, 903, 927, 949, 970, 989, 1008, 1042, 1073,
	1102, 1129, 1154, 1177, 1199, 1219, 1258, 1292, 1324, 1354, 1381, 1407,
	1431, 1453, 1495, 1533, 1568, 1600, 1630, 1657, 1683, 1708, 1753, 1794,
	1831, 1865, 1897, 1926, 1954, 1980, 2028, 2071, 2110, 2146, 2179, 2210,
	2239, 2267, 2317, 2361, 2402, 2440, 2474, 2506, 2536, 2564, 2616, 2662,
	2704, 2742, 2778, 2810, 2841, 2870, 2922, 2969, 3011, 3050, 3086, 3119,
	3150, 3179, 3231, 3278, 3321, 3360, 3396, 3429, 3459, 3488, 3540, 3587,
	3629, 3668, 3703, 3736, 3766, 3795, 3821, 3846, 3870, 3892, 3913, 3934,
	3953, 3971, 3989, 4006, 4022, 4038, 4053, 4068, 4082, 4095
};

int oe_y_lut_hlg[149] = {0, 0, 0, 0, 1, 1, 2, 3, 4, 5, 6, 6, 6, 7, 8, 9,
	9, 10, 12, 12, 13, 15, 16, 18, 19, 21, 24, 25, 27, 30, 33, 36, 39,
	43, 48, 51, 55, 61, 67, 73, 78, 87, 96, 103, 110, 117, 123, 129, 135,
	141, 146, 151, 156, 166, 175, 183, 192, 199, 207, 214, 221, 235, 247,
	259, 271, 282, 293, 303, 313, 332, 350, 367, 384, 399, 414, 429, 443,
	470, 495, 519, 543, 565, 586, 607, 627, 665, 701, 735, 768, 799, 829,
	858, 886, 940, 991, 1039, 1086, 1130, 1173, 1214, 1254, 1330, 1402,
	1470, 1536, 1598, 1659, 1717, 1773, 1881, 1982, 2079, 2165, 2243,
	2313, 2377, 2436, 2541, 2633, 2714, 2788, 2855, 2916, 2972, 3025,
	3119, 3203, 3279, 3347, 3409, 3467, 3520, 3570, 3616, 3660, 3701,
	3740, 3778, 3813, 3847, 3879, 3910, 3939, 3968, 3995, 4022, 4047,
	4072, 4095
};

int oe_y_lut_sdr[149] = {0, 1, 1, 2, 2, 3, 5, 7, 9, 10, 11, 12, 12, 13,
	15, 16, 16, 18, 20, 21, 22, 24, 26, 28, 30, 33, 35, 38, 40, 44, 47,
	50, 53, 59, 63, 67, 71, 78, 85, 90, 95, 105, 113, 121, 127, 134, 140,
	146, 151, 156, 161, 166, 170, 179, 187, 195, 202, 209, 215, 222, 228,
	239, 250, 260, 270, 279, 287, 296, 304, 319, 334, 347, 360, 372, 384,
	395, 406, 426, 445, 464, 481, 497, 513, 528, 542, 569, 595, 619, 642,
	664, 684, 704, 724, 760, 794, 826, 857, 886, 914, 940, 966, 1015, 1060,
	1103, 1144, 1183, 1220, 1255, 1290, 1355, 1415, 1473, 1527, 1579, 1628,
	1676, 1722, 1808, 1889, 1966, 2039, 2108, 2174, 2237, 2298, 2414, 2522,
	2624, 2721, 2814, 2902, 2987, 3068, 3147, 3222, 3296, 3367, 3436, 3503,
	3569, 3633, 3695, 3756, 3816, 3874, 3931, 3987, 4042, 4095
};

static int oe_y_lut_bypass[149] = {
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 5,
	5, 6, 6, 7, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 18, 20, 22, 24,
	26, 28, 30, 32, 36, 40, 44, 48, 52, 56, 60, 64, 72, 80, 88, 96,
	104, 112, 120, 128, 144, 160, 176, 192, 208, 224, 240, 256, 288,
	320, 352, 384, 416, 448, 480, 512, 576, 640, 704, 768, 832, 896,
	960, 1024, 1152, 1280, 1408, 1536, 1664, 1792, 1920, 2048, 2176,
	2304, 2432, 2560, 2688, 2816, 2944, 3072, 3200, 3328, 3456, 3584,
	3712, 3840, 3968, 4095
};

int oo_y_lut_hdr_hlg[149] = {
	4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095,
	4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095,
	4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095,
	3917, 3776, 3662, 3565, 3410, 3288, 3188, 3104, 2968, 2862, 2775,
	2702, 2639, 2584, 2535, 2491, 2452, 2416, 2383, 2352, 2297, 2249,
	2207, 2169, 2134, 2103, 2074, 2047, 2000, 1958, 1921, 1888, 1858,
	1831, 1806, 1782, 1741, 1705, 1672, 1644, 1617, 1594, 1572, 1552,
	1515, 1484, 1456, 1431, 1408, 1387, 1368, 1351, 1319, 1292, 1267,
	1245, 1226, 1208, 1191, 1176, 1148, 1124, 1103, 1084, 1067, 1051,
	1037, 1023, 1000, 979, 960, 944, 929, 915, 903, 891, 870, 852,
	836, 822, 808, 797, 786, 776, 757, 742, 728, 715, 704, 693, 684,
	675, 659, 646, 633, 622, 613, 604, 595, 588, 581, 574, 568, 562,
	557, 551, 546, 542, 537, 533, 529, 525, 522, 518, 515, 512
};

int oo_y_lut_hdr_sdr[149] = {
	255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
	255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
	255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
	255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
	255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
	255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
	255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
	255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
	255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
	255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
	255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
	255, 255, 255, 255, 255, 255
};

int oo_y_lut_bypass[149] = {
	255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
	255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
	255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
	255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
	255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
	255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
	255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
	255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
	255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
	255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
	255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
	255, 255, 255, 255, 255, 255
};

int oo_y_lut_hlg_hdr[149] = {
	4, 8, 9, 11, 12, 14, 16, 19, 22, 23, 24, 24, 25, 26, 27, 28, 29,
	30, 31, 32, 33, 35, 36, 37, 38, 40, 42, 43, 44, 46, 48, 49, 51,
	53, 55, 57, 58, 61, 63, 65, 67, 70, 73, 75, 77, 79, 81, 82, 84,
	85, 86, 88, 89, 91, 93, 95, 96, 98, 99, 101, 102, 104, 107, 109,
	111, 112, 114, 116, 117, 120, 122, 125, 127, 129, 131, 133, 135,
	138, 141, 144, 146, 148, 151, 153, 155, 158, 162, 165, 168, 171,
	173, 176, 178, 182, 186, 190, 193, 196, 199, 202, 204, 209, 214,
	218, 222, 225, 229, 232, 235, 240, 245, 250, 255, 259, 263, 266,
	270, 276, 282, 288, 293, 297, 302, 306, 310, 317, 324, 330, 336,
	342, 347, 352, 356, 360, 365, 369, 372, 376, 380, 383, 386, 389,
	392, 395, 398, 401, 404, 407, 409
};

int oo_y_lut_sdr_hdr[149] = {
	38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38,
	38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38,
	38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38,
	38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38,
	38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38,
	38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38,
	38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38,
	38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38,
	38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38,
	38, 38, 38, 38, 38
};

int oo_y_lut_hlg_sdr[149] = {
	245, 269, 275, 282, 288, 295, 302, 309, 316, 318, 320, 322, 323,
	326, 327, 329, 331, 333, 335, 337, 338, 341, 343, 345, 346, 349,
	351, 353, 354, 357, 359, 361, 362, 365, 367, 369, 371, 373, 376,
	378, 379, 382, 384, 386, 388, 390, 391, 392, 393, 394, 395, 396,
	397, 399, 400, 401, 402, 403, 404, 405, 406, 408, 409, 410, 412,
	413, 414, 415, 416, 417, 419, 420, 421, 422, 423, 424, 425, 427,
	428, 430, 431, 432, 433, 434, 435, 437, 438, 440, 441, 442, 443,
	444, 445, 447, 448, 450, 451, 452, 453, 454, 455, 457, 459, 460,
	462, 463, 464, 465, 466, 468, 469, 471, 472, 473, 475, 476, 477,
	479, 480, 482, 483, 484, 486, 487, 488, 490, 491, 493, 494, 496,
	497, 498, 499, 500, 501, 502, 503, 503, 504, 505, 506, 506, 507,
	508, 508, 509, 509, 510, 510
};

int oo_y_lut_sdr_hlg[149] = {
	1060, 967, 946, 924, 903, 883, 863, 844, 825, 819, 814, 810, 806,
	800, 795, 791, 788, 782, 777, 773, 770, 764, 760, 756, 753,
	747, 743, 739, 736, 730, 726, 722, 719, 714, 710, 706, 703,
	698, 694, 690, 687, 682, 678, 674, 671, 669, 667, 664, 663,
	661, 659, 658, 656, 654, 651, 649, 648, 646, 644, 643, 641,
	639, 637, 635, 633, 631, 630, 628, 627, 625, 622, 620, 619,
	617, 616, 614, 613, 610, 608, 606, 605, 603, 602, 600, 599,
	597, 595, 593, 591, 590, 588, 587, 585, 583, 581, 579, 578,
	576, 575, 573, 572, 570, 568, 566, 565, 563, 562, 561, 559,
	557, 555, 554, 552, 550, 549, 548, 547, 545, 543, 541, 539,
	538, 537, 536, 534, 532, 530, 529, 527, 526, 525, 523, 522,
	521, 520, 519, 518, 518, 517, 516, 515, 515, 514, 513, 513,
	512, 512, 511, 511
};

int oo_y_lut_1[149] = {
	4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095,
	4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095,
	4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095,
	4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095,
	4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095,
	4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095,
	4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095,
	4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095,
	4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095,
	4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095,
	4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095,
	4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095,
	4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095,
	4095, 4095, 4095, 4095, 4095, 4095
};

static uint out_luma = 5;
static uint in_luma = 1;/*1 as 100luminance*/
static uint adp_scal_shift = 10;/*1 as 100luminance*/

int ncl_2020_709[9] = {
	2684, -489, -147, -201, 2266, -17, -29, -171, 2248};

int ncl_709_2020[9] = {1285, 674, 89, 142, 1883, 23, 34, 180, 1834};

int rgb2yuvpre[3]	= {0, 0, 0};
int rgb2yuvpos[3]	= {64, 512, 512};
int yuv2rgbpre[3]	= {-64, -512, -512};
int yuv2rgbpos[3]	= {0, 0, 0};

int yuv2rgbmat[15] = {
	1197, 0, 0, 1197, 1851, 0, 1197, 0, 1163, 1197, 2271, 0, 1197, 0, 2011};
int rgb2ycbcr[15] = {
	230, 594, 52, -125, -323, 448, 448, -412, -36, 0, 0, 0, 0, 0, 0};
int rgb2ycbcr_ncl2020[15] = {
	230, 594, 52, -125, -323, 448, 448, -412, -36, 0, 0, 0, 0, 0, 0};
int rgb2ycbcr_709[15] = {
	186, 627, 63, -103, -345, 448, 448, -407, -41, 0, 0, 0, 0, 0, 0};
int ycbcr2rgb_709[15]  = {
	1192, 0, 1836, 1192, -217, -546, 1192, 2166, 0, 0, 0, 0, 0, 0, 0};
int ycbcr2rgb_ncl2020[15] = {
	1197, 0, 1726, 1197, -193, -669, 1197, 2202, 0, 0, 0, 0, 0, 0, 0};

static int bypass_coeff[15] = {
	1024, 0, 0,
	0, 1024, 0,
	0, 0, 1024,
	0, 0, 0,
	0, 0, 0,
};

void set_hdr_matrix(
	enum hdr_module_sel module_sel,
	enum hdr_matrix_sel mtx_sel,
	struct hdr_proc_mtx_param_s *hdr_mtx_param)
{
	unsigned int MATRIXI_COEF00_01 = 0;
	unsigned int MATRIXI_COEF02_10 = 0;
	unsigned int MATRIXI_COEF11_12 = 0;
	unsigned int MATRIXI_COEF20_21 = 0;
	unsigned int MATRIXI_COEF22 = 0;
	/*unsigned int MATRIXI_COEF30_31 = 0;*/
	/*unsigned int MATRIXI_COEF32_40 = 0;*/
	/*unsigned int MATRIXI_COEF41_42 = 0;*/
	unsigned int MATRIXI_OFFSET0_1 = 0;
	unsigned int MATRIXI_OFFSET2 = 0;
	unsigned int MATRIXI_PRE_OFFSET0_1 = 0;
	unsigned int MATRIXI_PRE_OFFSET2 = 0;
	/*unsigned int MATRIXI_CLIP = 0;*/
	unsigned int MATRIXI_EN_CTRL = 0;

	unsigned int MATRIXO_COEF00_01 = 0;
	unsigned int MATRIXO_COEF02_10 = 0;
	unsigned int MATRIXO_COEF11_12 = 0;
	unsigned int MATRIXO_COEF20_21 = 0;
	unsigned int MATRIXO_COEF22 = 0;
	/*unsigned int MATRIXO_COEF30_31 = 0;*/
	/*unsigned int MATRIXO_COEF32_40 = 0;*/
	/*unsigned int MATRIXO_COEF41_42 = 0;*/
	unsigned int MATRIXO_OFFSET0_1 = 0;
	unsigned int MATRIXO_OFFSET2 = 0;
	unsigned int MATRIXO_PRE_OFFSET0_1 = 0;
	unsigned int MATRIXO_PRE_OFFSET2 = 0;
	/*unsigned int MATRIXO_CLIP = 0;*/
	unsigned int MATRIXO_EN_CTRL = 0;

	unsigned int CGAIN_OFFT = 0;
	unsigned int CGAIN_COEF0 = 0;
	unsigned int CGAIN_COEF1 = 0;
	unsigned int ADPS_CTRL = 0;
	unsigned int ADPS_ALPHA0 = 0;
	unsigned int ADPS_ALPHA1 = 0;
	unsigned int ADPS_BETA0 = 0;
	unsigned int ADPS_BETA1 = 0;
	unsigned int ADPS_BETA2 = 0;
	unsigned int ADPS_COEF0 = 0;
	unsigned int ADPS_COEF1 = 0;
	unsigned int GMUT_CTRL = 0;
	unsigned int GMUT_COEF0 = 0;
	unsigned int GMUT_COEF1 = 0;
	unsigned int GMUT_COEF2 = 0;
	unsigned int GMUT_COEF3 = 0;
	unsigned int GMUT_COEF4 = 0;

	unsigned int hdr_ctrl = 0;

	int adpscl_mode = 0;

	int c_gain_lim_coef[3];
	int gmut_coef[3][3];
	int gmut_shift;
	int adpscl_enable[3];
	int adpscl_alpha[3] = {0, 0, 0};
	int adpscl_shift[3];
	int adpscl_ys_coef[3] = {0, 0, 0};
	int adpscl_beta[3];
	int adpscl_beta_s[3];

	int i = 0;
	int mtx[15] = {
		1024, 0, 0,
		0, 1024, 0,
		0, 0, 1024,
		0, 0, 0,
		0, 0, 0,
	};

	if (module_sel & VD1_HDR) {
		MATRIXI_COEF00_01 = VD1_HDR2_MATRIXI_COEF00_01;
		MATRIXI_COEF00_01 = VD1_HDR2_MATRIXI_COEF00_01;
		MATRIXI_COEF02_10 = VD1_HDR2_MATRIXI_COEF02_10;
		MATRIXI_COEF11_12 = VD1_HDR2_MATRIXI_COEF11_12;
		MATRIXI_COEF20_21 = VD1_HDR2_MATRIXI_COEF20_21;
		MATRIXI_COEF22 = VD1_HDR2_MATRIXI_COEF22;
		/*MATRIXI_COEF30_31 = VD1_HDR2_MATRIXI_COEF30_31;*/
		/*MATRIXI_COEF32_40 = VD1_HDR2_MATRIXI_COEF32_40;*/
		/*MATRIXI_COEF41_42 = VD1_HDR2_MATRIXI_COEF41_42;*/
		MATRIXI_OFFSET0_1 = VD1_HDR2_MATRIXI_OFFSET0_1;
		MATRIXI_OFFSET2 = VD1_HDR2_MATRIXI_OFFSET2;
		MATRIXI_PRE_OFFSET0_1 = VD1_HDR2_MATRIXI_PRE_OFFSET0_1;
		MATRIXI_PRE_OFFSET2 = VD1_HDR2_MATRIXI_PRE_OFFSET2;
		/*MATRIXI_CLIP = VD1_HDR2_MATRIXI_CLIP;*/
		MATRIXI_EN_CTRL = VD1_HDR2_MATRIXI_EN_CTRL;

		MATRIXO_COEF00_01 = VD1_HDR2_MATRIXO_COEF00_01;
		MATRIXO_COEF00_01 = VD1_HDR2_MATRIXO_COEF00_01;
		MATRIXO_COEF02_10 = VD1_HDR2_MATRIXO_COEF02_10;
		MATRIXO_COEF11_12 = VD1_HDR2_MATRIXO_COEF11_12;
		MATRIXO_COEF20_21 = VD1_HDR2_MATRIXO_COEF20_21;
		MATRIXO_COEF22 = VD1_HDR2_MATRIXO_COEF22;
		/*MATRIXO_COEF30_31 = VD1_HDR2_MATRIXO_COEF30_31;*/
		/*MATRIXO_COEF32_40 = VD1_HDR2_MATRIXO_COEF32_40;*/
		/*MATRIXO_COEF41_42 = VD1_HDR2_MATRIXO_COEF41_42;*/
		MATRIXO_OFFSET0_1 = VD1_HDR2_MATRIXO_OFFSET0_1;
		MATRIXO_OFFSET2 = VD1_HDR2_MATRIXO_OFFSET2;
		MATRIXO_PRE_OFFSET0_1 = VD1_HDR2_MATRIXO_PRE_OFFSET0_1;
		MATRIXO_PRE_OFFSET2 = VD1_HDR2_MATRIXO_PRE_OFFSET2;
		/*MATRIXO_CLIP = VD1_HDR2_MATRIXO_CLIP;*/
		MATRIXO_EN_CTRL = VD1_HDR2_MATRIXO_EN_CTRL;

		CGAIN_OFFT = VD1_HDR2_CGAIN_OFFT;
		CGAIN_COEF0 = VD1_HDR2_CGAIN_COEF0;
		CGAIN_COEF1 = VD1_HDR2_CGAIN_COEF1;
		ADPS_CTRL = VD1_HDR2_ADPS_CTRL;
		ADPS_ALPHA0 = VD1_HDR2_ADPS_ALPHA0;
		ADPS_ALPHA1 = VD1_HDR2_ADPS_ALPHA1;
		ADPS_BETA0 = VD1_HDR2_ADPS_BETA0;
		ADPS_BETA1 = VD1_HDR2_ADPS_BETA1;
		ADPS_BETA2 = VD1_HDR2_ADPS_BETA2;
		ADPS_COEF0 = VD1_HDR2_ADPS_COEF0;
		ADPS_COEF1 = VD1_HDR2_ADPS_COEF1;
		GMUT_CTRL = VD1_HDR2_GMUT_CTRL;
		GMUT_COEF0 = VD1_HDR2_GMUT_COEF0;
		GMUT_COEF1 = VD1_HDR2_GMUT_COEF1;
		GMUT_COEF2 = VD1_HDR2_GMUT_COEF2;
		GMUT_COEF3 = VD1_HDR2_GMUT_COEF3;
		GMUT_COEF4 = VD1_HDR2_GMUT_COEF4;

		hdr_ctrl = VD1_HDR2_CTRL;
	} else if (module_sel & OSD1_HDR) {
		MATRIXI_COEF00_01 = OSD1_HDR2_MATRIXI_COEF00_01;
		MATRIXI_COEF00_01 = OSD1_HDR2_MATRIXI_COEF00_01;
		MATRIXI_COEF02_10 = OSD1_HDR2_MATRIXI_COEF02_10;
		MATRIXI_COEF11_12 = OSD1_HDR2_MATRIXI_COEF11_12;
		MATRIXI_COEF20_21 = OSD1_HDR2_MATRIXI_COEF20_21;
		MATRIXI_COEF22 = OSD1_HDR2_MATRIXI_COEF22;
		/*MATRIXI_COEF30_31 = OSD1_HDR2_MATRIXI_COEF30_31;*/
		/*MATRIXI_COEF32_40 = OSD1_HDR2_MATRIXI_COEF32_40;*/
		/*MATRIXI_COEF41_42 = OSD1_HDR2_MATRIXI_COEF41_42;*/
		MATRIXI_OFFSET0_1 = OSD1_HDR2_MATRIXI_OFFSET0_1;
		MATRIXI_OFFSET2 = OSD1_HDR2_MATRIXI_OFFSET2;
		MATRIXI_PRE_OFFSET0_1 = OSD1_HDR2_MATRIXI_PRE_OFFSET0_1;
		MATRIXI_PRE_OFFSET2 = OSD1_HDR2_MATRIXI_PRE_OFFSET2;
		/*MATRIXI_CLIP = OSD1_HDR2_MATRIXI_CLIP;*/
		MATRIXI_EN_CTRL = OSD1_HDR2_MATRIXI_EN_CTRL;

		MATRIXO_COEF00_01 = OSD1_HDR2_MATRIXO_COEF00_01;
		MATRIXO_COEF00_01 = OSD1_HDR2_MATRIXO_COEF00_01;
		MATRIXO_COEF02_10 = OSD1_HDR2_MATRIXO_COEF02_10;
		MATRIXO_COEF11_12 = OSD1_HDR2_MATRIXO_COEF11_12;
		MATRIXO_COEF20_21 = OSD1_HDR2_MATRIXO_COEF20_21;
		MATRIXO_COEF22 = OSD1_HDR2_MATRIXO_COEF22;
		/*MATRIXO_COEF30_31 = OSD1_HDR2_MATRIXO_COEF30_31;*/
		/*MATRIXO_COEF32_40 = OSD1_HDR2_MATRIXO_COEF32_40;*/
		/*MATRIXO_COEF41_42 = OSD1_HDR2_MATRIXO_COEF41_42;*/
		MATRIXO_OFFSET0_1 = OSD1_HDR2_MATRIXO_OFFSET0_1;
		MATRIXO_OFFSET2 = OSD1_HDR2_MATRIXO_OFFSET2;
		MATRIXO_PRE_OFFSET0_1 = OSD1_HDR2_MATRIXO_PRE_OFFSET0_1;
		MATRIXO_PRE_OFFSET2 = OSD1_HDR2_MATRIXO_PRE_OFFSET2;
		/*MATRIXO_CLIP = OSD1_HDR2_MATRIXO_CLIP;*/
		MATRIXO_EN_CTRL = OSD1_HDR2_MATRIXO_EN_CTRL;

		CGAIN_OFFT = OSD1_HDR2_CGAIN_OFFT;
		CGAIN_COEF0 = OSD1_HDR2_CGAIN_COEF0;
		CGAIN_COEF1 = OSD1_HDR2_CGAIN_COEF1;
		ADPS_CTRL = OSD1_HDR2_ADPS_CTRL;
		ADPS_ALPHA0 = OSD1_HDR2_ADPS_ALPHA0;
		ADPS_ALPHA1 = OSD1_HDR2_ADPS_ALPHA1;
		ADPS_BETA0 = OSD1_HDR2_ADPS_BETA0;
		ADPS_BETA1 = OSD1_HDR2_ADPS_BETA1;
		ADPS_BETA2 = OSD1_HDR2_ADPS_BETA2;
		ADPS_COEF0 = OSD1_HDR2_ADPS_COEF0;
		ADPS_COEF1 = OSD1_HDR2_ADPS_COEF1;
		GMUT_CTRL = OSD1_HDR2_GMUT_CTRL;
		GMUT_COEF0 = OSD1_HDR2_GMUT_COEF0;
		GMUT_COEF1 = OSD1_HDR2_GMUT_COEF1;
		GMUT_COEF2 = OSD1_HDR2_GMUT_COEF2;
		GMUT_COEF3 = OSD1_HDR2_GMUT_COEF3;
		GMUT_COEF4 = OSD1_HDR2_GMUT_COEF4;

		hdr_ctrl = OSD1_HDR2_CTRL;
	}

	if (hdr_mtx_param == NULL)
		return;
	vpp_reg_setb(hdr_ctrl, hdr_mtx_param->mtx_on, 13, 1);

	if (mtx_sel & HDR_IN_MTX) {
		for (i = 0; i < 15; i++)
			mtx[i] = hdr_mtx_param->mtx_in[i];
		vpp_reg_write(MATRIXI_EN_CTRL, hdr_mtx_param->mtx_on);
		/*yuv in*/
		vpp_reg_setb(hdr_ctrl, hdr_mtx_param->mtx_on, 4, 1);

		vpp_reg_setb(hdr_ctrl, hdr_mtx_param->mtx_only,
			16, 1);
		vpp_reg_setb(hdr_ctrl, 0, 17, 1);
		/*mtx in en*/
		vpp_reg_setb(hdr_ctrl, 1, 14, 1);

		vpp_reg_write(MATRIXI_COEF00_01,
			(mtx[0 * 3 + 0] << 16) | (mtx[0 * 3 + 1] & 0x1FFF));
		vpp_reg_write(MATRIXI_COEF02_10,
			(mtx[0 * 3 + 2] << 16) | (mtx[1 * 3 + 0] & 0x1FFF));
		vpp_reg_write(MATRIXI_COEF11_12,
			(mtx[1 * 3 + 1] << 16) | (mtx[1 * 3 + 2] & 0x1FFF));
		vpp_reg_write(MATRIXI_COEF20_21,
			(mtx[2 * 3 + 0] << 16) | (mtx[2 * 3 + 1] & 0x1FFF));
		vpp_reg_write(MATRIXI_COEF22,
			mtx[2 * 3 + 2]);
		vpp_reg_write(MATRIXI_OFFSET0_1,
			(yuv2rgbpos[0] << 16) | (yuv2rgbpos[1] & 0xFFF));
		vpp_reg_write(MATRIXI_OFFSET2,
			yuv2rgbpos[2]);
		vpp_reg_write(MATRIXI_PRE_OFFSET0_1,
			(yuv2rgbpre[0] << 16)|(yuv2rgbpre[1] & 0xFFF));
		vpp_reg_write(MATRIXI_PRE_OFFSET2,
			yuv2rgbpre[2]);

	} else if (mtx_sel & HDR_GAMUT_MTX) {
		for (i = 0; i < 9; i++)
			gmut_coef[i/3][i%3] =
				hdr_mtx_param->mtx_gamut[i];
		/*for g12a/g12b osd blend shift rtl bug*/
		if (((get_cpu_id().family_id == MESON_CPU_MAJOR_ID_G12A) ||
			(get_cpu_id().family_id == MESON_CPU_MAJOR_ID_G12B)) &&
			(hdr_mtx_param->p_sel & HDR_BYPASS) &&
			(module_sel & OSD1_HDR))
			gmut_shift = 10;
		else
			gmut_shift = 11;

		for (i = 0; i < 3; i++)
			c_gain_lim_coef[i] =
				hdr_mtx_param->mtx_cgain[i] << 2;
		/*0, nolinear input, 1, max linear, 2, adpscl mode*/
		adpscl_mode = 1;
		for (i = 0; i < 3; i++) {
			if (((get_cpu_id().family_id == MESON_CPU_MAJOR_ID_G12A) ||
				(get_cpu_id().family_id == MESON_CPU_MAJOR_ID_G12B)) &&
				(hdr_mtx_param->p_sel & HDR_BYPASS) &&
				(module_sel & OSD1_HDR))
				adpscl_enable[i] = 1;
			else
				adpscl_enable[i] = 0;
			if (hdr_mtx_param->p_sel & HDR_SDR)
				adpscl_alpha[i] =
					(1 << adp_scal_shift);
			else if (hdr_mtx_param->p_sel & SDR_HDR)
				adpscl_alpha[i] =
					(1 << adp_scal_shift);
			else if (hdr_mtx_param->p_sel & HDR_BYPASS)
				adpscl_alpha[i] = out_luma *
					(1 << adp_scal_shift) / in_luma;
			else if (hdr_mtx_param->p_sel & HLG_SDR) {
				adpscl_alpha[i] = out_luma *
					(1 << adp_scal_shift) / in_luma;
				adpscl_mode = 2;
			} else if (hdr_mtx_param->p_sel & HLG_HDR)
				adpscl_alpha[i] = 1 *
					(1 << adp_scal_shift) / in_luma;
			else if (hdr_mtx_param->p_sel & SDR_HLG)
				adpscl_alpha[i] = 10 * in_luma *
					(1 << adp_scal_shift) / out_luma;

			if (hdr_mtx_param->p_sel & HDR_SDR) {
				if (i == 0)
					adpscl_shift[i] = adp_scal_shift;
				else
					adpscl_shift[i] = adp_scal_shift - 2;
			} else
				adpscl_shift[i] = adp_scal_shift;

			adpscl_ys_coef[i] =
					1 << adp_scal_shift;
			adpscl_beta_s[i] = 0;
			adpscl_beta[i] = 0;
		}

		/*gamut mode: 1->gamut before ootf*/
					/*2->gamut after ootf*/
					/*other->disable gamut*/
		vpp_reg_setb(hdr_ctrl, 2, 6, 2);

	    vpp_reg_write(GMUT_CTRL, gmut_shift);
	    vpp_reg_write(GMUT_COEF0,
			(gmut_coef[0][1] & 0xffff) << 16 |
			(gmut_coef[0][0] & 0xffff));
	    vpp_reg_write(GMUT_COEF1,
			(gmut_coef[1][0] & 0xffff) << 16 |
			(gmut_coef[0][2] & 0xffff));
	    vpp_reg_write(GMUT_COEF2,
			(gmut_coef[1][2] & 0xffff) << 16 |
			(gmut_coef[1][1] & 0xffff));
	    vpp_reg_write(GMUT_COEF3,
			(gmut_coef[2][1] & 0xffff) << 16 |
			(gmut_coef[2][0] & 0xffff));
	    vpp_reg_write(GMUT_COEF4,
			gmut_coef[2][2] & 0xffff);

	    vpp_reg_write(CGAIN_COEF0,
			c_gain_lim_coef[1] << 16 |
			c_gain_lim_coef[0]);
	    vpp_reg_write(CGAIN_COEF1, c_gain_lim_coef[2] |
			0x400 << 16);

	    vpp_reg_write(ADPS_CTRL, adpscl_enable[2] << 6 |
							adpscl_enable[1] << 5 |
							adpscl_enable[0] << 4 |
							adpscl_mode);
		vpp_reg_write(ADPS_ALPHA0,
				adpscl_alpha[1]<<16 | adpscl_alpha[0]);
		vpp_reg_write(ADPS_ALPHA1, adpscl_shift[0] << 24 |
							adpscl_shift[1] << 20 |
							adpscl_shift[2] << 16 |
							adpscl_alpha[2]);
	    vpp_reg_write(ADPS_BETA0,
			adpscl_beta_s[0] << 20 | adpscl_beta[0]);
	    vpp_reg_write(ADPS_BETA1,
			adpscl_beta_s[1] << 20 | adpscl_beta[1]);
	    vpp_reg_write(ADPS_BETA2,
			adpscl_beta_s[2] << 20 | adpscl_beta[2]);
	    vpp_reg_write(ADPS_COEF0,
			adpscl_ys_coef[1] << 16 | adpscl_ys_coef[0]);
	    vpp_reg_write(ADPS_COEF1, adpscl_ys_coef[2]);

	} else if (mtx_sel & HDR_OUT_MTX) {
		for (i = 0; i < 15; i++)
			mtx[i] = hdr_mtx_param->mtx_out[i];
		vpp_reg_write(CGAIN_OFFT,
			(rgb2yuvpos[2] << 16) | rgb2yuvpos[1]);
		vpp_reg_write(MATRIXO_EN_CTRL, hdr_mtx_param->mtx_on);
		/*yuv in*/
		vpp_reg_setb(hdr_ctrl, hdr_mtx_param->mtx_on, 4, 1);

		vpp_reg_setb(hdr_ctrl, hdr_mtx_param->mtx_only,
			16, 1);
		vpp_reg_setb(hdr_ctrl, 0, 17, 1);
		/*mtx out en*/
		vpp_reg_setb(hdr_ctrl, 1, 15, 1);

		vpp_reg_write(MATRIXO_COEF00_01,
			(mtx[0 * 3 + 0] << 16) | (mtx[0 * 3 + 1] & 0x1FFF));
		vpp_reg_write(MATRIXO_COEF02_10,
			(mtx[0 * 3 + 2] << 16) | (mtx[1 * 3 + 0] & 0x1FFF));
		vpp_reg_write(MATRIXO_COEF11_12,
			(mtx[1 * 3 + 1] << 16) | (mtx[1 * 3 + 2] & 0x1FFF));
		vpp_reg_write(MATRIXO_COEF20_21,
			(mtx[2 * 3 + 0] << 16) | (mtx[2 * 3 + 1] & 0x1FFF));
		vpp_reg_write(MATRIXO_COEF22,
			mtx[2 * 3 + 2]);
		vpp_reg_write(MATRIXO_OFFSET0_1,
			(rgb2yuvpos[0] << 16) | (rgb2yuvpos[1]&0xFFF));
		vpp_reg_write(MATRIXO_OFFSET2,
			rgb2yuvpos[2]);
		vpp_reg_write(MATRIXO_PRE_OFFSET0_1,
			(rgb2yuvpre[0] << 16)|(rgb2yuvpre[1]&0xFFF));
		vpp_reg_write(MATRIXO_PRE_OFFSET2,
			rgb2yuvpre[2]);
	}

}

void set_eotf_lut(
	enum hdr_module_sel module_sel,
	struct hdr_proc_lut_param_s *hdr_lut_param)
{
	unsigned int lut[HDR2_EOTF_LUT_SIZE];
	unsigned int eotf_lut_addr_port = 0;
	unsigned int eotf_lut_data_port = 0;
	unsigned int hdr_ctrl = 0;
	unsigned int i = 0;

	if (module_sel & VD1_HDR) {
		eotf_lut_addr_port = VD1_EOTF_LUT_ADDR_PORT;
		eotf_lut_data_port = VD1_EOTF_LUT_DATA_PORT;
		hdr_ctrl = VD1_HDR2_CTRL;
	} else if (module_sel & OSD1_HDR) {
		eotf_lut_addr_port = OSD1_EOTF_LUT_ADDR_PORT;
		eotf_lut_data_port = OSD1_EOTF_LUT_DATA_PORT;
		hdr_ctrl = OSD1_HDR2_CTRL;
	}

	for (i = 0; i < HDR2_EOTF_LUT_SIZE; i++)
		lut[i] = hdr_lut_param->eotf_lut[i];

	vpp_reg_setb(hdr_ctrl, hdr_lut_param->lut_on, 3, 1);

	if (!hdr_lut_param->lut_on)
		return;

	vpp_reg_write(eotf_lut_addr_port, 0x0);
	for (i = 0; i < HDR2_EOTF_LUT_SIZE; i++)
		vpp_reg_write(eotf_lut_data_port, lut[i]);
}

void set_ootf_lut(
	enum hdr_module_sel module_sel,
	struct hdr_proc_lut_param_s *hdr_lut_param)
{
	unsigned int lut[HDR2_OOTF_LUT_SIZE];
	unsigned int ootf_lut_addr_port = 0;
	unsigned int ootf_lut_data_port = 0;
	unsigned int hdr_ctrl = 0;
	unsigned int i = 0;

	if (module_sel & VD1_HDR) {
		ootf_lut_addr_port = VD1_OGAIN_LUT_ADDR_PORT;
		ootf_lut_data_port = VD1_OGAIN_LUT_DATA_PORT;
		hdr_ctrl = VD1_HDR2_CTRL;
	} else if (module_sel & OSD1_HDR) {
		ootf_lut_addr_port = OSD1_OGAIN_LUT_ADDR_PORT;
		ootf_lut_data_port = OSD1_OGAIN_LUT_DATA_PORT;
		hdr_ctrl = OSD1_HDR2_CTRL;
	}

	for (i = 0; i < HDR2_OOTF_LUT_SIZE; i++)
		lut[i] = hdr_lut_param->ogain_lut[i];

	vpp_reg_setb(hdr_ctrl, hdr_lut_param->lut_on, 1, 1);

	if (!hdr_lut_param->lut_on)
		return;

	vpp_reg_write(ootf_lut_addr_port, 0x0);
	for (i = 0; i < HDR2_OOTF_LUT_SIZE / 2; i++)
		vpp_reg_write(ootf_lut_data_port,
			(lut[i * 2 + 1] << 16) +
			lut[i * 2]);
	vpp_reg_write(ootf_lut_data_port, lut[148]);
}

void set_oetf_lut(
	enum hdr_module_sel module_sel,
	struct hdr_proc_lut_param_s *hdr_lut_param)
{
	unsigned int lut[HDR2_OETF_LUT_SIZE];
	unsigned int oetf_lut_addr_port = 0;
	unsigned int oetf_lut_data_port = 0;
	unsigned int hdr_ctrl = 0;
	unsigned int i = 0;

	if (module_sel & VD1_HDR) {
		oetf_lut_addr_port = VD1_OETF_LUT_ADDR_PORT;
		oetf_lut_data_port = VD1_OETF_LUT_DATA_PORT;
		hdr_ctrl = VD1_HDR2_CTRL;
	} else if (module_sel & OSD1_HDR) {
		oetf_lut_addr_port = OSD1_OETF_LUT_ADDR_PORT;
		oetf_lut_data_port = OSD1_OETF_LUT_DATA_PORT;
		hdr_ctrl = OSD1_HDR2_CTRL;
	}

	for (i = 0; i < HDR2_OETF_LUT_SIZE; i++)
		lut[i] = hdr_lut_param->oetf_lut[i];

	vpp_reg_setb(hdr_ctrl, hdr_lut_param->lut_on, 2, 1);

	if (!hdr_lut_param->lut_on)
		return;

	vpp_reg_write(oetf_lut_addr_port, 0x0);
	for (i = 0; i < HDR2_OETF_LUT_SIZE / 2; i++) {
		if (hdr_lut_param->bitdepth == 10)
			vpp_reg_write(oetf_lut_data_port,
				((lut[i * 2 + 1] >> 2) << 16) +
				(lut[i * 2] >> 2));
		else
			vpp_reg_write(oetf_lut_data_port,
				(lut[i * 2 + 1] << 16) +
				lut[i * 2]);
		}
		vpp_reg_write(oetf_lut_data_port, lut[148]);
}

void set_c_gain(
	enum hdr_module_sel module_sel,
	struct hdr_proc_lut_param_s *hdr_lut_param)
{
	unsigned int lut[HDR2_CGAIN_LUT_SIZE];
	unsigned int cgain_lut_addr_port = 0;
	unsigned int cgain_lut_data_port = 0;
	unsigned int hdr_ctrl = 0;
	unsigned int i = 0;

	if (module_sel & VD1_HDR) {
		cgain_lut_addr_port = VD1_CGAIN_LUT_ADDR_PORT;
		cgain_lut_data_port = VD1_CGAIN_LUT_DATA_PORT;
		hdr_ctrl = VD1_HDR2_CTRL;
	} else if (module_sel & OSD1_HDR) {
		cgain_lut_addr_port = OSD1_CGAIN_LUT_ADDR_PORT;
		cgain_lut_data_port = OSD1_CGAIN_LUT_DATA_PORT;
		hdr_ctrl = OSD1_HDR2_CTRL;
	}

	for (i = 0; i < HDR2_CGAIN_LUT_SIZE; i++)
		lut[i] = hdr_lut_param->cgain_lut[i];

	/*cgain mode: 0->y domin*/
	/*cgain mode: 1->rgb domin, use r/g/b max*/
	vpp_reg_setb(hdr_ctrl, hdr_lut_param->cgain_en, 12, 1);
	vpp_reg_setb(hdr_ctrl, hdr_lut_param->cgain_en, 0, 1);

	if (!hdr_lut_param->cgain_en)
		return;

	vpp_reg_write(cgain_lut_addr_port, 0x0);
	for (i = 0; i < HDR2_CGAIN_LUT_SIZE / 2; i++)
		vpp_reg_write(cgain_lut_data_port,
			(lut[i * 2 + 1] << 16) + lut[i * 2]);
	vpp_reg_write(cgain_lut_data_port, lut[64]);
}

struct hdr_proc_lut_param_s hdr_lut_param;

void hdr_func(enum hdr_module_sel module_sel,
	enum hdr_process_sel hdr_process_select)
{
	int bit_depth;
	unsigned int i = 0;
	struct hdr_proc_mtx_param_s hdr_mtx_param;

	memset(&hdr_mtx_param, 0, sizeof(struct hdr_proc_mtx_param_s));
	memset(&hdr_lut_param, 0, sizeof(struct hdr_proc_lut_param_s));

	if (module_sel & (VD1_HDR | VD2_HDR | OSD1_HDR))
		bit_depth = 12;
	else if (module_sel & (VDIN0_HDR | VDIN1_HDR | DI_HDR))
		bit_depth = 10;
	else
		return;

	/*lut parameters*/
	if (hdr_process_select & HDR_BYPASS) {
		/*for g12a/g12b osd blend shift rtl bug*/
		if (((get_cpu_id().family_id == MESON_CPU_MAJOR_ID_G12A) ||
			(get_cpu_id().family_id == MESON_CPU_MAJOR_ID_G12B)) &&
			(module_sel & OSD1_HDR)) {
			for (i = 0; i < HDR2_OETF_LUT_SIZE; i++) {
				hdr_lut_param.oetf_lut[i]  = oe_y_lut_bypass[i];
				hdr_lut_param.ogain_lut[i] = oo_y_lut_bypass[i];
				if (i < HDR2_EOTF_LUT_SIZE)
					hdr_lut_param.eotf_lut[i] =
						eo_y_lut_bypass[i];
				if (i < HDR2_CGAIN_LUT_SIZE)
					hdr_lut_param.cgain_lut[i] =
						cgain_lut_bypass[i] - 1;
			}
			hdr_lut_param.lut_on = LUT_ON;
			hdr_lut_param.bitdepth = bit_depth;
			hdr_lut_param.cgain_en = LUT_ON;
		} else {
			for (i = 0; i < HDR2_OETF_LUT_SIZE; i++) {
				hdr_lut_param.oetf_lut[i]  = oe_y_lut_sdr[i];
				hdr_lut_param.ogain_lut[i] =
					oo_y_lut_hdr_sdr[i];
				if (i < HDR2_EOTF_LUT_SIZE)
					hdr_lut_param.eotf_lut[i] =
						eo_y_lut_hdr[i];
				if (i < HDR2_CGAIN_LUT_SIZE)
					hdr_lut_param.cgain_lut[i] =
						cgain_lut1[i] - 1;
			}
			hdr_lut_param.lut_on = LUT_OFF;
			hdr_lut_param.bitdepth = bit_depth;
			hdr_lut_param.cgain_en = LUT_OFF;
		}
	} else if (hdr_process_select & HDR_SDR) {
		for (i = 0; i < HDR2_OETF_LUT_SIZE; i++) {
			hdr_lut_param.oetf_lut[i]  = oe_y_lut_sdr[i];
			hdr_lut_param.ogain_lut[i] = oo_y_lut_hdr_sdr[i];
			if (i < HDR2_EOTF_LUT_SIZE)
				hdr_lut_param.eotf_lut[i] = eo_y_lut_hdr[i];
			if (i < HDR2_CGAIN_LUT_SIZE)
				hdr_lut_param.cgain_lut[i] = cgain_lut1[i] - 1;
		}
		hdr_lut_param.lut_on = LUT_ON;
		hdr_lut_param.bitdepth = bit_depth;
		hdr_lut_param.cgain_en = LUT_ON;
	} else if (hdr_process_select & SDR_HDR) {
		for (i = 0; i < HDR2_OETF_LUT_SIZE; i++) {
			hdr_lut_param.oetf_lut[i]  = oe_y_lut_hdr[i];
			hdr_lut_param.ogain_lut[i] = oo_y_lut_sdr_hdr[i];
			if (i < HDR2_EOTF_LUT_SIZE)
				hdr_lut_param.eotf_lut[i] = eo_y_lut_sdr[i];
			if (i < HDR2_CGAIN_LUT_SIZE)
				hdr_lut_param.cgain_lut[i] =
					cgain_lut_bypass[i] - 1;
		}
		hdr_lut_param.lut_on = LUT_ON;
		hdr_lut_param.bitdepth = bit_depth;
		/*for g12a/g12b osd blend shift rtl bug*/
		if (((get_cpu_id().family_id == MESON_CPU_MAJOR_ID_G12A) ||
			(get_cpu_id().family_id == MESON_CPU_MAJOR_ID_G12B)) &&
			(module_sel & OSD1_HDR))
			hdr_lut_param.cgain_en = LUT_ON;
		else
			hdr_lut_param.cgain_en = LUT_OFF;
	} else if (hdr_process_select & HLG_BYPASS) {
		for (i = 0; i < HDR2_OETF_LUT_SIZE; i++) {
			hdr_lut_param.oetf_lut[i]  = oe_y_lut_sdr[i];
			hdr_lut_param.ogain_lut[i] = oo_y_lut_hdr_sdr[i];
			if (i < HDR2_EOTF_LUT_SIZE)
				hdr_lut_param.eotf_lut[i] = eo_y_lut_hlg[i];
			if (i < HDR2_CGAIN_LUT_SIZE)
				hdr_lut_param.cgain_lut[i] = cgain_lut1[i] - 1;
		}
		hdr_lut_param.lut_on = LUT_OFF;
		hdr_lut_param.bitdepth = bit_depth;
		hdr_lut_param.cgain_en = LUT_OFF;
	} else if (hdr_process_select & HLG_SDR) {
		for (i = 0; i < HDR2_OETF_LUT_SIZE; i++) {
			hdr_lut_param.oetf_lut[i]  = oe_y_lut_sdr[i];
			hdr_lut_param.ogain_lut[i] = oo_y_lut_hlg_sdr[i];
			if (i < HDR2_EOTF_LUT_SIZE)
				hdr_lut_param.eotf_lut[i] = eo_y_lut_hlg[i];
			if (i < HDR2_CGAIN_LUT_SIZE)
				hdr_lut_param.cgain_lut[i] = cgain_lut1[i] - 1;
		}
		hdr_lut_param.lut_on = LUT_ON;
		hdr_lut_param.bitdepth = bit_depth;
		hdr_lut_param.cgain_en = LUT_ON;
	} else if (hdr_process_select & HLG_HDR) {
		for (i = 0; i < HDR2_OETF_LUT_SIZE; i++) {
			hdr_lut_param.oetf_lut[i]  = oe_y_lut_hdr[i];
			hdr_lut_param.ogain_lut[i] = oo_y_lut_hlg_hdr[i];
			if (i < HDR2_EOTF_LUT_SIZE)
				hdr_lut_param.eotf_lut[i] = eo_y_lut_hlg[i];
			if (i < HDR2_CGAIN_LUT_SIZE)
				hdr_lut_param.cgain_lut[i] = cgain_lut1[i] - 1;
		}
		hdr_lut_param.lut_on = LUT_ON;
		hdr_lut_param.bitdepth = bit_depth;
		hdr_lut_param.cgain_en = LUT_ON;
	} else if (hdr_process_select & SDR_HLG) {
		for (i = 0; i < HDR2_OETF_LUT_SIZE; i++) {
			hdr_lut_param.oetf_lut[i]  = oe_y_lut_hlg[i];
			hdr_lut_param.ogain_lut[i] = oo_y_lut_sdr_hlg[i];
			if (i < HDR2_EOTF_LUT_SIZE)
				hdr_lut_param.eotf_lut[i] = eo_y_lut_sdr[i];
			if (i < HDR2_CGAIN_LUT_SIZE)
				hdr_lut_param.cgain_lut[i] =
					cgain_lut_bypass[i] - 1;
		}
		hdr_lut_param.lut_on = LUT_ON;
		hdr_lut_param.bitdepth = bit_depth;
		/*for g12a/g12b osd blend shift rtl bug*/
		if (((get_cpu_id().family_id == MESON_CPU_MAJOR_ID_G12A) ||
			(get_cpu_id().family_id == MESON_CPU_MAJOR_ID_G12B)) &&
			(module_sel & OSD1_HDR))
			hdr_lut_param.cgain_en = LUT_ON;
		else
			hdr_lut_param.cgain_en = LUT_OFF;
	} else
		return;

	/*mtx parameters*/
	if (hdr_process_select & (HDR_BYPASS | HLG_BYPASS)) {
		hdr_mtx_param.mtx_only = HDR_ONLY;
		/*for g12a/g12b osd blend shift rtl bug*/
		if (((get_cpu_id().family_id == MESON_CPU_MAJOR_ID_G12A) ||
			(get_cpu_id().family_id == MESON_CPU_MAJOR_ID_G12B)) &&
			(hdr_process_select & HDR_BYPASS) &&
			(module_sel & OSD1_HDR)) {
			for (i = 0; i < 15; i++) {
				hdr_mtx_param.mtx_in[i] = ycbcr2rgb_709[i];
				hdr_mtx_param.mtx_cgain[i] = bypass_coeff[i];
				hdr_mtx_param.mtx_ogain[i] = bypass_coeff[i];
				hdr_mtx_param.mtx_out[i] = rgb2ycbcr_709[i];
				if (i < 9)
					hdr_mtx_param.mtx_gamut[i] =
						bypass_coeff[i];
			}
			hdr_mtx_param.mtx_on = MTX_ON;
			hdr_mtx_param.p_sel = HDR_BYPASS;
		} else {
			for (i = 0; i < 15; i++) {
				hdr_mtx_param.mtx_in[i] = bypass_coeff[i];
				hdr_mtx_param.mtx_cgain[i] = bypass_coeff[i];
				hdr_mtx_param.mtx_ogain[i] = bypass_coeff[i];
				hdr_mtx_param.mtx_out[i] = bypass_coeff[i];
				if (i < 9)
					hdr_mtx_param.mtx_gamut[i] =
						bypass_coeff[i];
			}
			hdr_mtx_param.mtx_on = MTX_OFF;
			hdr_mtx_param.p_sel = HDR_BYPASS;
		}
	} else if (hdr_process_select & (HDR_SDR | HLG_SDR)) {
		hdr_mtx_param.mtx_only = HDR_ONLY;
		for (i = 0; i < 15; i++) {
			hdr_mtx_param.mtx_in[i] = ycbcr2rgb_ncl2020[i];
			hdr_mtx_param.mtx_cgain[i] = rgb2ycbcr_709[i];
			hdr_mtx_param.mtx_ogain[i] = rgb2ycbcr_ncl2020[i];
			hdr_mtx_param.mtx_out[i] = rgb2ycbcr_709[i];
			if (i < 9)
				hdr_mtx_param.mtx_gamut[i] = ncl_2020_709[i];
		}
		hdr_mtx_param.mtx_on = MTX_ON;

		if (hdr_process_select & HDR_SDR)
			hdr_mtx_param.p_sel = HDR_SDR;
		else if (hdr_process_select & HLG_SDR)
			hdr_mtx_param.p_sel = HLG_SDR;

	} else if (hdr_process_select & SDR_HDR) {
		hdr_mtx_param.mtx_only = HDR_ONLY;
		for (i = 0; i < 15; i++) {
			hdr_mtx_param.mtx_in[i] = ycbcr2rgb_709[i];
			hdr_mtx_param.mtx_cgain[i] = rgb2ycbcr_ncl2020[i];
			hdr_mtx_param.mtx_ogain[i] = rgb2ycbcr_709[i];
			hdr_mtx_param.mtx_out[i] = rgb2ycbcr_ncl2020[i];
			if (i < 9)
				hdr_mtx_param.mtx_gamut[i] = ncl_709_2020[i];
		}
		hdr_mtx_param.mtx_on = MTX_ON;
		hdr_mtx_param.p_sel = SDR_HDR;
	} else if (hdr_process_select & HLG_HDR) {
		hdr_mtx_param.mtx_only = HDR_ONLY;
		for (i = 0; i < 15; i++) {
			hdr_mtx_param.mtx_in[i] = ycbcr2rgb_ncl2020[i];
			hdr_mtx_param.mtx_cgain[i] = bypass_coeff[i];
			hdr_mtx_param.mtx_ogain[i] = bypass_coeff[i];
			hdr_mtx_param.mtx_out[i] = rgb2ycbcr_ncl2020[i];
			if (i < 9)
				hdr_mtx_param.mtx_gamut[i] = bypass_coeff[i];
		}
		hdr_mtx_param.mtx_on = MTX_ON;
		hdr_mtx_param.p_sel = HLG_HDR;
	}  else if (hdr_process_select & SDR_HLG) {
		hdr_mtx_param.mtx_only = HDR_ONLY;
		for (i = 0; i < 15; i++) {
			hdr_mtx_param.mtx_in[i] = ycbcr2rgb_709[i];
			hdr_mtx_param.mtx_cgain[i] = rgb2ycbcr_ncl2020[i];
			hdr_mtx_param.mtx_ogain[i] = rgb2ycbcr_709[i];
			hdr_mtx_param.mtx_out[i] = rgb2ycbcr_ncl2020[i];
			if (i < 9)
				hdr_mtx_param.mtx_gamut[i] = ncl_709_2020[i];
		}
		hdr_mtx_param.mtx_on = MTX_ON;
		hdr_mtx_param.p_sel = SDR_HLG;
	}

	set_hdr_matrix(module_sel, HDR_IN_MTX, &hdr_mtx_param);

	set_eotf_lut(module_sel, &hdr_lut_param);

	set_hdr_matrix(module_sel, HDR_GAMUT_MTX, &hdr_mtx_param);

	set_ootf_lut(module_sel, &hdr_lut_param);

	set_oetf_lut(module_sel, &hdr_lut_param);

	set_hdr_matrix(module_sel, HDR_OUT_MTX, &hdr_mtx_param);

	set_c_gain(module_sel, &hdr_lut_param);
}
