#include <kernel/early_mm.h>
#include <kernel/lib/bitmap.h>
#include <kernel/scheduler.h>
#include <platform_def.h>

#define SCHED_TASK_STACK_SIZE PLAT_STACK_SIZE

static unsigned long runnable_cpus[((PLAT_MAX_CPUS + (sizeof(unsigned long) * 8U) - 1U) /
	(sizeof(unsigned long) * 8U))];
static unsigned int runnable_cpu_count;

static struct scheduler_percpu *scheduler_percpu_table[PLAT_MAX_CPUS];
static size_t scheduler_object_count;

static void *scheduler_alloc_zeroed(size_t size, size_t align)
{
	void *ptr = early_mm_alloc(size, align, "scheduler-object");

	if (ptr != (void *)0) {
		scheduler_object_count++;
	}

	return ptr;
}

static struct scheduler_task *scheduler_create_idle_task(unsigned int logical_id)
{
	struct scheduler_task *task;
	void *stack;

	task = (struct scheduler_task *)scheduler_alloc_zeroed(sizeof(*task), sizeof(uintptr_t));
	if (task == (struct scheduler_task *)0) {
		return (struct scheduler_task *)0;
	}

	stack = early_mm_alloc_pages((SCHED_TASK_STACK_SIZE + EARLY_MM_PAGE_SIZE - 1U) / EARLY_MM_PAGE_SIZE,
			    "scheduler-idle-stack");
	if (stack != (void *)0) {
		scheduler_object_count++;
	}
	if (stack == (void *)0) {
		return (struct scheduler_task *)0;
	}

	task->task_id = logical_id;
	task->cpu_hint = logical_id;
	task->stack_base = stack;
	task->stack_size = SCHED_TASK_STACK_SIZE;
	task->idle = true;
	return task;
}

static struct scheduler_percpu *scheduler_bootstrap_cpu(unsigned int logical_id)
{
	struct scheduler_percpu *cpu_ctx;
	struct scheduler_runqueue_node *idle_node;

	cpu_ctx = (struct scheduler_percpu *)scheduler_alloc_zeroed(sizeof(*cpu_ctx), sizeof(uintptr_t));
	if (cpu_ctx == (struct scheduler_percpu *)0) {
		return (struct scheduler_percpu *)0;
	}

	cpu_ctx->logical_id = logical_id;
	cpu_ctx->idle_task = scheduler_create_idle_task(logical_id);
	if (cpu_ctx->idle_task == (struct scheduler_task *)0) {
		return (struct scheduler_percpu *)0;
	}

	idle_node = (struct scheduler_runqueue_node *)scheduler_alloc_zeroed(sizeof(*idle_node), sizeof(uintptr_t));
	if (idle_node == (struct scheduler_runqueue_node *)0) {
		return (struct scheduler_percpu *)0;
	}

	idle_node->task = cpu_ctx->idle_task;
	cpu_ctx->ready_head = idle_node;
	cpu_ctx->ready_tail = idle_node;
	scheduler_percpu_table[logical_id] = cpu_ctx;
	return cpu_ctx;
}

void scheduler_init(void)
{
	unsigned int i;

	for (i = 0U; i < (unsigned int)(sizeof(runnable_cpus) / sizeof(runnable_cpus[0])); ++i) {
		runnable_cpus[i] = 0UL;
	}

	for (i = 0U; i < PLAT_MAX_CPUS; ++i) {
		scheduler_percpu_table[i] = (struct scheduler_percpu *)0;
	}

	runnable_cpu_count = 0U;
	scheduler_object_count = 0U;

	for (i = 0U; i < PLAT_MAX_CPUS; ++i) {
		if (scheduler_bootstrap_cpu(i) == (struct scheduler_percpu *)0) {
			break;
		}
	}
}

void scheduler_join_cpu(unsigned int logical_id)
{
	if (logical_id >= PLAT_MAX_CPUS) {
		return;
	}

	if ((scheduler_percpu_table[logical_id] == (struct scheduler_percpu *)0) &&
	    (scheduler_bootstrap_cpu(logical_id) == (struct scheduler_percpu *)0)) {
		return;
	}

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

const struct scheduler_percpu *scheduler_percpu_state(unsigned int logical_id)
{
	if (logical_id >= PLAT_MAX_CPUS) {
		return (const struct scheduler_percpu *)0;
	}

	return scheduler_percpu_table[logical_id];
}

size_t scheduler_bootstrap_object_count(void)
{
	return scheduler_object_count;
}