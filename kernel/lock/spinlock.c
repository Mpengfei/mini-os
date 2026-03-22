#include <kernel/spinlock.h>
#include <kernel/topology.h>

static inline uint64_t spinlock_read_mpidr(void)
{
	uint64_t mpidr;

	__asm__ volatile ("mrs %0, mpidr_el1" : "=r" (mpidr));
	return mpidr;
}

static unsigned int spinlock_cpu_slot(void)
{
	const struct cpu_topology_descriptor *cpu;

	cpu = topology_find_cpu_by_mpidr(spinlock_read_mpidr());
	if (cpu != (const struct cpu_topology_descriptor *)0) {
		return cpu->logical_id;
	}

	return 0U;
}

void spinlock_init(struct spinlock *lock)
{
	unsigned int i;

	if (lock == (struct spinlock *)0) {
		return;
	}

	for (i = 0U; i < PLAT_MAX_CPUS; ++i) {
		lock->choosing[i] = 0U;
		lock->tickets[i] = 0U;
	}
}

int spinlock_try_lock(struct spinlock *lock)
{
	unsigned int slot;
	unsigned int i;
	uint32_t max_ticket = 0U;
	uint32_t my_ticket;

	if (lock == (struct spinlock *)0) {
		return 0;
	}

	slot = spinlock_cpu_slot();
	if (lock->tickets[slot] != 0U) {
		return 1;
	}

	lock->choosing[slot] = 1U;
	for (i = 0U; i < PLAT_MAX_CPUS; ++i) {
		if (lock->tickets[i] > max_ticket) {
			max_ticket = lock->tickets[i];
		}
	}

	my_ticket = max_ticket + 1U;
	if (my_ticket == 0U) {
		my_ticket = 1U;
	}

	lock->tickets[slot] = my_ticket;
	lock->choosing[slot] = 0U;

	for (i = 0U; i < PLAT_MAX_CPUS; ++i) {
		uint32_t other_ticket;

		if (i == slot) {
			continue;
		}

		while (lock->choosing[i] != 0U) {
		}

		for (;;) {
			other_ticket = lock->tickets[i];
			if (other_ticket == 0U) {
				break;
			}

			if (other_ticket > my_ticket) {
				break;
			}

			if ((other_ticket == my_ticket) && (i > slot)) {
				break;
			}
		}
	}

	return 1;
}

void spinlock_lock(struct spinlock *lock)
{
	(void)spinlock_try_lock(lock);
}

void spinlock_unlock(struct spinlock *lock)
{
	unsigned int slot;

	if (lock == (struct spinlock *)0) {
		return;
	}

	slot = spinlock_cpu_slot();
	lock->tickets[slot] = 0U;
}