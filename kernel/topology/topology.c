#include <stdbool.h>
#include <stddef.h>
#include <kernel/topology.h>
#include "platform_def.h"

#define MPIDR_AFF0_MASK 0xFFUL
#define MPIDR_AFF1_MASK 0xFF00UL
#define MPIDR_AFF2_MASK 0xFF0000UL
#define MPIDR_AFF3_MASK 0xFF000000UL
#define MPIDR_AFF1_SHIFT 8U
#define MPIDR_AFF2_SHIFT 16U
#define MPIDR_AFF3_SHIFT 24U

static struct cpu_topology_descriptor cpu_descs[PLAT_MAX_CPUS];
static unsigned int present_cpu_count;
static unsigned int online_cpu_count;

static inline uint64_t topology_read_mpidr(void)
{
	uint64_t mpidr;

	__asm__ volatile ("mrs %0, mpidr_el1" : "=r" (mpidr));
	return mpidr;
}

static void topology_fill_descriptor(struct cpu_topology_descriptor *cpu,
				     unsigned int logical_id,
				     uint64_t mpidr,
				     bool boot_cpu)
{
	cpu->logical_id = logical_id;
	cpu->mpidr = mpidr;
	cpu->chip_id = (unsigned int)((mpidr & MPIDR_AFF3_MASK) >> MPIDR_AFF3_SHIFT);
	cpu->die_id = (unsigned int)((mpidr & MPIDR_AFF2_MASK) >> MPIDR_AFF2_SHIFT);
	cpu->cluster_id = (unsigned int)((mpidr & MPIDR_AFF1_MASK) >> MPIDR_AFF1_SHIFT);
	cpu->core_id = (unsigned int)(mpidr & MPIDR_AFF0_MASK);
	cpu->boot_cpu = boot_cpu;
}

void topology_init(void)
{
	unsigned int i;
	uint64_t mpidr = topology_read_mpidr();

	for (i = 0U; i < PLAT_MAX_CPUS; ++i) {
		cpu_descs[i].logical_id = i;
		cpu_descs[i].present = false;
		cpu_descs[i].online = false;
		cpu_descs[i].boot_cpu = false;
		cpu_descs[i].mpidr = 0U;
		cpu_descs[i].chip_id = 0U;
		cpu_descs[i].die_id = 0U;
		cpu_descs[i].cluster_id = 0U;
		cpu_descs[i].core_id = 0U;
	}

	topology_fill_descriptor(&cpu_descs[0], 0U, mpidr, true);
	cpu_descs[0].present = true;
	cpu_descs[0].online = true;
	present_cpu_count = 1U;
	online_cpu_count = 1U;
}

const struct cpu_topology_descriptor *topology_boot_cpu(void)
{
	return &cpu_descs[0];
}

const struct cpu_topology_descriptor *topology_cpu(unsigned int logical_id)
{
	if (logical_id >= PLAT_MAX_CPUS) {
		return (const struct cpu_topology_descriptor *)0;
	}

	return &cpu_descs[logical_id];
}

const struct cpu_topology_descriptor *topology_find_cpu_by_mpidr(uint64_t mpidr)
{
	unsigned int i;

	for (i = 0U; i < PLAT_MAX_CPUS; ++i) {
		if (cpu_descs[i].present && (cpu_descs[i].mpidr == mpidr)) {
			return &cpu_descs[i];
		}
	}

	return (const struct cpu_topology_descriptor *)0;
}

unsigned int topology_cpu_capacity(void)
{
	return PLAT_MAX_CPUS;
}

unsigned int topology_present_cpu_count(void)
{
	return present_cpu_count;
}

unsigned int topology_online_cpu_count(void)
{
	return online_cpu_count;
}

void topology_mark_cpu_online(unsigned int logical_id, bool online)
{
	if (logical_id >= PLAT_MAX_CPUS) {
		return;
	}

	if (!cpu_descs[logical_id].present) {
		cpu_descs[logical_id].present = true;
		present_cpu_count++;
	}

	if (online && !cpu_descs[logical_id].online) {
		cpu_descs[logical_id].online = true;
		online_cpu_count++;
	} else if (!online && cpu_descs[logical_id].online) {
		cpu_descs[logical_id].online = false;
		if (online_cpu_count > 0U) {
			online_cpu_count--;
		}
	}
}

void topology_register_cpu(unsigned int logical_id, uint64_t mpidr, bool boot_cpu)
{
	if (logical_id >= PLAT_MAX_CPUS) {
		return;
	}

	if (!cpu_descs[logical_id].present) {
		present_cpu_count++;
	}

	topology_fill_descriptor(&cpu_descs[logical_id], logical_id, mpidr, boot_cpu);
	cpu_descs[logical_id].present = true;
	cpu_descs[logical_id].online = false;
}