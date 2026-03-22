#ifndef KERNEL_SCHEDULER_H
#define KERNEL_SCHEDULER_H

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

struct scheduler_task {
	unsigned int task_id;
	unsigned int cpu_hint;
	void *stack_base;
	size_t stack_size;
	bool idle;
};

struct scheduler_runqueue_node {
	struct scheduler_task *task;
	struct scheduler_runqueue_node *next;
};

struct scheduler_percpu {
	unsigned int logical_id;
	struct scheduler_task *idle_task;
	struct scheduler_runqueue_node *ready_head;
	struct scheduler_runqueue_node *ready_tail;
};

void scheduler_init(void);
void scheduler_join_cpu(unsigned int logical_id);
bool scheduler_cpu_is_runnable(unsigned int logical_id);
unsigned int scheduler_runnable_cpu_count(void);
const struct scheduler_percpu *scheduler_percpu_state(unsigned int logical_id);
size_t scheduler_bootstrap_object_count(void);

#endif /* KERNEL_SCHEDULER_H */