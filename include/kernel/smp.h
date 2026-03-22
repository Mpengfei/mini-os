#ifndef KERNEL_SMP_H
#define KERNEL_SMP_H

#include <stdbool.h>
#include <stdint.h>

struct smp_cpu_state {
	unsigned int logical_id;
	uint64_t mpidr;
	bool online;
	bool scheduled;
	bool pending;
	bool boot_cpu;
};

enum smp_start_result {
	SMP_START_OK = 0,
	SMP_START_ALREADY_ONLINE = 1,
	SMP_START_INVALID_CPU = -1,
	SMP_START_UNSUPPORTED = -2,
	SMP_START_DENIED = -3,
};

void smp_init(void);
int smp_start_cpu(uint64_t mpidr, unsigned int *logical_id);
const struct smp_cpu_state *smp_cpu_state(unsigned int logical_id);
unsigned int smp_online_cpu_count(void);
void smp_secondary_cpu_online(unsigned int logical_id);
void smp_secondary_entry(uint64_t logical_id);
uintptr_t smp_secondary_entrypoint(void);

#endif /* KERNEL_SMP_H */