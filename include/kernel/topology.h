#ifndef KERNEL_TOPOLOGY_H
#define KERNEL_TOPOLOGY_H

#include <stdbool.h>
#include <stdint.h>

struct cpu_topology_descriptor {
	uint64_t mpidr;
	unsigned int logical_id;
	unsigned int chip_id;
	unsigned int die_id;
	unsigned int cluster_id;
	unsigned int core_id;
	bool boot_cpu;
	bool present;
	bool online;
};

void topology_init(void);
const struct cpu_topology_descriptor *topology_boot_cpu(void);
const struct cpu_topology_descriptor *topology_cpu(unsigned int logical_id);
const struct cpu_topology_descriptor *topology_find_cpu_by_mpidr(uint64_t mpidr);
unsigned int topology_cpu_capacity(void);
unsigned int topology_present_cpu_count(void);
unsigned int topology_online_cpu_count(void);
void topology_mark_cpu_online(unsigned int logical_id, bool online);
void topology_register_cpu(unsigned int logical_id, uint64_t mpidr, bool boot_cpu);

#endif /* KERNEL_TOPOLOGY_H */