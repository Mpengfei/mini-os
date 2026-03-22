#include <kernel/lib/bitmap.h>
#include <kernel/scheduler.h>
#include <platform_def.h>

static unsigned long runnable_cpus[((PLAT_MAX_CPUS + (sizeof(unsigned long) * 8U) - 1U) /
	(sizeof(unsigned long) * 8U))];
static unsigned int runnable_cpu_count;

void scheduler_init(void)
{
	unsigned int i;

	for (i = 0U; i < (unsigned int)(sizeof(runnable_cpus) / sizeof(runnable_cpus[0])); ++i) {
		runnable_cpus[i] = 0UL;
	}
	runnable_cpu_count = 0U;
}

void scheduler_join_cpu(unsigned int logical_id)
{
	if (!bitmap_test_bit(runnable_cpus, logical_id)) {
		bitmap_set_bit(runnable_cpus, logical_id);
		runnable_cpu_count++;
	}
}

bool scheduler_cpu_is_runnable(unsigned int logical_id)
{
	return bitmap_test_bit(runnable_cpus, logical_id);
}

unsigned int scheduler_runnable_cpu_count(void)
{
	return runnable_cpu_count;
}