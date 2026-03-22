#ifndef KERNEL_SCHEDULER_H
#define KERNEL_SCHEDULER_H

#include <stdbool.h>

void scheduler_init(void);
void scheduler_join_cpu(unsigned int logical_id);
bool scheduler_cpu_is_runnable(unsigned int logical_id);
unsigned int scheduler_runnable_cpu_count(void);

#endif /* KERNEL_SCHEDULER_H */