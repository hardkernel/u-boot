#include "config.h"
#include "registers.h"
#include "task_apis.h"

struct scpi_opp_entry {
	unsigned int freq_hz;
	unsigned int volt_mv;
};
#define DVFS(_freq, _volt) \
{ \
	.freq_hz = _freq, \
	.volt_mv = _volt, \
}
struct scpi_opp_entry cpu_dvfs_tbl[] = {
	DVFS(100000000, 1050),
	DVFS(250000000, 1050),
	DVFS(500000000, 1050),
	DVFS(1032000000, 1050),
	DVFS(1296000000, 1150),
	DVFS(1536000000, 1150),
};
static void *memcpy(void *dest, const void *src, unsigned int count)
{
	char *tmp = dest;
	const char *s = src;

	while (count--)
		*tmp++ = *s++;
	return dest;
}
static void *memset(void *s, int c, unsigned int count)
{
	char *xs = s;

	while (count--)
		*xs++ = c;
	return s;
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

void get_dvfs_info(unsigned int domain,
		unsigned char *info_out, unsigned int *size_out)
{
	unsigned int cnt = ARRAY_SIZE(cpu_dvfs_tbl);
	buf_opp.latency = 200;
	buf_opp.count = cnt;
	memset(&buf_opp.opp[0], 0, MAX_DVFS_OPPS * sizeof(struct scpi_opp_entry));
	memcpy(&buf_opp.opp[0], cpu_dvfs_tbl , cnt *sizeof(struct scpi_opp_entry));

	memcpy(info_out, &buf_opp, sizeof(struct scpi_opp));
	*size_out = sizeof(struct scpi_opp);
	return;
}
#define writel(v, addr) (*((unsigned *)addr) = v)
#define readl(addr) (*((unsigned *)addr))

void set_dvfs(unsigned int domain, unsigned int index)
{
#if 0
	if (cpu_dvfs_tbl[index].volt_mv == 1150) {
		unsigned int val;
		val = readl(0xda834400 + 0xc*4);
		val = val & (~(1<<29));
		writel(val , (0xda834400 + 0xc*4));

		val = readl(0xda834400 + 0xd*4);
		val = val & (~(1<<29));
		writel(val , (0xda834400 + 0xd*4));
	}
#endif
}
