#include <common.h>
#include <command.h>
#include <linux/compiler.h>
#include <asm/arch/cpu.h>
#include <asm/arch/core.h>
#include <asm/arch/timer.h>
#define __asmeq(x, y)  ".ifnc " x "," y " ; .err ; .endif\n\t"

DECLARE_GLOBAL_DATA_PTR;

#define CPU_ON 1
#define CPU_OFF 0
#define STACK_SIZE        4096

typedef void (*test_pattern_t)(unsigned int *memstart, unsigned int count);

unsigned core_stack[NR_CPUS][STACK_SIZE/4] __attribute__ ((aligned (4)));
unsigned core_online[NR_CPUS];
unsigned long core_entry_fn[NR_CPUS];
unsigned long gd_addr;
unsigned int val;

void test_cache_pattern1(unsigned int *memstart, unsigned int count)
{
	unsigned long i;
	unsigned int *addr;
	unsigned long size;
	int ret;
	int process;
	int errcnt;

	printf("test cache pattern1 -- :   ");
	flush_dcache_all();

	addr = memstart;
	size = count/sizeof(unsigned);
	for (i=0; i<size; i++, addr++)
		*addr = (0xffffffff ^ ((unsigned)(unsigned long)addr));
	flush_dcache_all();

	addr = memstart;
	size = count/sizeof(unsigned);
	for (i=0; i<size; i++, addr++)
		val = *addr;

	addr=memstart;
	size = count/sizeof(unsigned);
	ret = 0;
	process = -1;
	for (i=0, errcnt=0; i<size && errcnt<10; i++, addr++) {
		if (*addr != (0xffffffff ^ ((unsigned)(unsigned long)addr))) {
			printf("\n  fail at: addr=0x%x,cache=0x%x,val=0x%x",
						(unsigned)(unsigned long)addr,
						*addr, (0xffffffff^((unsigned)(unsigned long)addr)));
			errcnt++;
			ret = 1;
		}
		else {
			if (!ret && (((i*100)/(size)) != process)) {
				process = ((i*100)/(size));
				printf("\b\b\b%2d%%", process);
			}
		}
	}
	if (ret == 0)
		printf("\b\b\b done!");

	if (ret == 0)
		printf("\ntest cache pattern1 result: success!\n");
	else
		printf("\ntest cache pattern1 result: fail!\n");
}

void test_cache_pattern2(unsigned int *memstart, unsigned int count)
{
	unsigned long i;
	unsigned int *addr;
	unsigned long size;
	int process;
	int ret;
	int errcnt;

	printf("test cache pattern2 -- :   ");
	flush_dcache_all();

	addr = memstart;
	size = count/sizeof(unsigned);
	for (i=0; i<size; i++, addr++)
		*addr = 0x55555555;
	flush_dcache_all();

	addr = memstart;
	size = count/sizeof(unsigned);
	for (i=0; i<size; i++, addr++)
		val = *addr;

	// compare nocache and memorys
	addr=memstart;
	size = count/sizeof(unsigned);
	ret = 0;
	process = -1;
	for (i=0, errcnt = 0; i<size && errcnt < 10; i++, addr++) {
		if (*addr != 0x55555555) {
			printf("\n  fail at: addr=0x%x,cache=0x%x,val=0x%x",
						(unsigned)(unsigned long)addr,
						*addr, 0x55555555);
			errcnt++;
			ret = 1;
		}
		else {
			if (!ret && (((i*100)/(size)) != process)) {
				process = ((i*100)/(size));
				printf("\b\b\b%2d%%", process);
			}
		}
	}

	if (ret == 0)
		printf("\b\b\b done!");

	if (ret == 0)
		printf("\ntest cache pattern2 result: success!\n");
	else
		printf("\ntest cache pattern2 result: fail!\n");
}

void test_cache_pattern3(unsigned int *memstart, unsigned int count)
{
	unsigned long i;
	unsigned int *addr;
	unsigned long size;
	int process;
	int ret;
	int errcnt;

	printf("test cache pattern3 -- :   ");
	flush_dcache_all();

	addr = memstart;
	size = count/sizeof(unsigned);
	for (i=0; i<size; i++, addr++)
		*addr = 0xaaaaaaaa;
	flush_dcache_all();

	addr = memstart;
	size = count/sizeof(unsigned);
	for (i=0; i<size; i++, addr++)
		val = *addr;

	// compare nocache and memorys
	addr=memstart;
	size = count/sizeof(unsigned);
	ret = 0;
	process = -1;
	for (i=0, errcnt=0; i<size && errcnt < 10; i++, addr++) {
		if (*addr != 0xaaaaaaaa) {
			printf("\n  fail at: addr=0x%x,cache=0x%x,val=0x%x",
						(unsigned)(unsigned long)addr,
						*addr, 0xaaaaaaaa);
			errcnt++;
			ret = 1;
		}
		else {
			if (!ret && (((i*100)/(size)) != process)) {
				process = ((i*100)/(size));
				printf("\b\b\b%2d%%", process);
			}
		}
	}

	if (ret == 0)
		printf("\b\b\b done!");

	if (ret == 0)
		printf("\ntest cache pattern3 result: success!\n");
	else
		printf("\ntest cache pattern3 result: fail!\n");
}

const test_pattern_t test_cache_pattern[] = {
	test_cache_pattern1,
	test_cache_pattern2,
	test_cache_pattern3,
};

void test_cache(int cpuidx)
{
	/*DRAM_END-128M --- RAM_END*/
	unsigned int *memstart;
	unsigned int count;
	int i;
	bd_t *bd = gd->bd;

	memstart = (unsigned int *)(bd->bi_dram[0].start + bd->bi_dram[0].size);
	count = CONFIG_SYS_MEM_TOP_HIDE;

	printf("\n===========cpu%d test start: offset: 0x%x, count: %x\n",
				cpuidx, (unsigned)(unsigned long)memstart, count);
	for (i=0; i<sizeof(test_cache_pattern)/sizeof(test_pattern_t); i++) {
			test_cache_pattern[i](memstart, count);
	}

	memset(memstart, 0, count);
	flush_dcache_all();
}

unsigned get_gd_addr(void)
{
	return gd_addr;
}

unsigned get_stack_base(unsigned cpuidx)
{
	return (unsigned)(unsigned long)&(core_stack[cpuidx]);
}

unsigned long get_core_entry_fn(unsigned cpuidx)
{
	return core_entry_fn[cpuidx];
}

void invoke_psci_fn(unsigned fn, unsigned targetcpu, unsigned entry_point, unsigned arg)
{
	asm volatile(
		__asmeq("%0", "x0")
		__asmeq("%1", "x1")
		__asmeq("%2", "x2")
		__asmeq("%3", "x3")
		"smc #0\n"
		::"r"(fn), "r"(targetcpu), "r"(entry_point), "r"(arg));
}

void power_off_secondary_cpu(int cpuidx)
{
	core_online[cpuidx] = CPU_OFF;
	__asm__ volatile("sev");
	invoke_psci_fn(0x84000002, 0x0010000, 0, 0);
}

void secondary_cpu_test_cache_entry(int cpuidx)
{
	test_cache(cpuidx);
	power_off_secondary_cpu(cpuidx);
}

void secondary_cpu_test_smp_entry(int cpuidx)
{
	printf("CPU%d power on!\n", cpuidx);
	power_off_secondary_cpu(cpuidx);
}

extern void _start(void);
static int do_testcache(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	int i;
	int test_cpus = 0;
	int cpuid;
	char *cpuarg = argv[1];
	int mpidr, cpuidx;

	if (argc > 2) {
		printf("usage: testsmpcache cpu-[0~7|a]\n");
		return 0;
	}
	if (strlen(argv[1]) != 5)	{
		printf("usage: testsmpcache cpu-[0~7|a]\n");
		return 0;
	}

	cpuarg += 4;
	switch (*cpuarg) {
		case '0' ... '7':
			cpuid = *cpuarg - '0';
			if (cpuid >= get_core_max()) {
				printf("usage: testsmpcache cpu-[0~7|a]\n");
				return 0;
			}
			test_cpus |= (1 << cpuid);
			break;
		case 'a':
			for (i = 0; i < get_core_max(); i++)
				test_cpus |= (1 << i);
			break;
		default:
			printf("usage: testsmpcache cpu-[0~7|a]\n");
			return 0;
	}

	gd_addr = (unsigned long)gd;
	flush_dcache_all();

	if ((test_cpus & 0x1) == 0x1)
			test_cache(0);
	for (i = 1; i < get_core_max(); i++) {
		if ((test_cpus & (1<<i)) != 0) {
			mpidr = get_core_mpidr(i);
			if (mpidr < 0) {
				printf("cpu %d mpidr 0x%x error!\n", i, (unsigned int)mpidr);
				return 0;
			}
			cpuidx = get_core_idx((unsigned int)mpidr);
			if (cpuidx < 0) {
				printf("cpu %d idx error!\n", i);
				return 0;
			}

			core_online[cpuidx] = CPU_ON;
			core_entry_fn[cpuidx] = (unsigned long)secondary_cpu_test_cache_entry;
			__asm__ volatile("dsb sy");
			invoke_psci_fn(0xC4000003, mpidr, (unsigned)(unsigned long)_start, 0);
			while (core_online[cpuidx] == CPU_ON) {
				__asm__ volatile("wfe");
				__asm__ volatile("" : : : "memory");
			}
			_udelay(100);
		}
	}

	return 0;
}

static int do_testsmp(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	int i;
	int mpidr, cpuidx;

	gd_addr = (unsigned long)gd;
	flush_dcache_all();

	for (i = 1; i < get_core_max(); i++) {
		mpidr = get_core_mpidr(i);
		cpuidx = get_core_idx((unsigned int)mpidr);
		core_online[cpuidx] = CPU_ON;
		core_entry_fn[cpuidx] = (unsigned long)secondary_cpu_test_smp_entry;
		__asm__ volatile("dsb sy");
		invoke_psci_fn(0xC4000003, mpidr, (unsigned)(unsigned long)_start, 0);
		while (core_online[cpuidx] == CPU_ON) {
			__asm__ volatile("wfe");
			__asm__ volatile("" : : : "memory");
		}
		_udelay(100);
	}
	return 0;
}

U_BOOT_CMD(
	testsmp,   1,   1,     do_testsmp,
	"test each CPU power on/off",
	""
	""
);


U_BOOT_CMD(
	testcache,   2,   1,     do_testcache,
	"cache test",
	"testcache cpu-[0-7|a]\n"
);
