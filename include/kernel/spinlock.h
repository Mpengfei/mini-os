#ifndef KERNEL_SPINLOCK_H
#define KERNEL_SPINLOCK_H

#include "platform_def.h"

#include <stdint.h>

struct spinlock {
	volatile uint8_t choosing[PLAT_MAX_CPUS];
	volatile uint32_t tickets[PLAT_MAX_CPUS];
};

#define SPINLOCK_INIT { { 0U }, { 0U } }

void spinlock_init(struct spinlock *lock);
void spinlock_lock(struct spinlock *lock);
void spinlock_unlock(struct spinlock *lock);
int spinlock_try_lock(struct spinlock *lock);

#endif /* KERNEL_SPINLOCK_H */