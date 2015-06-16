#ifndef __SCP_DVFS_H__
#define __SCP_DVFS_H__

struct scpi_opp_entry {
	unsigned int freq_hz;
	unsigned int volt_mv;
};
#define DVFS(_freq, _volt) \
{ \
	.freq_hz = _freq, \
	.volt_mv = _volt, \
}

#define SCPI_SUCCESS 0
#define MAX_DVFS_OPPS		16
#define DVFS_LATENCY(hdr)	((hdr) << 16)
#define DVFS_OPP_COUNT(hdr)	((hdr) << 8)
struct scpi_opp {
	unsigned int latency; /* in usecs */
	int count;
	struct scpi_opp_entry opp[MAX_DVFS_OPPS];
} buf_opp;

#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
#endif

