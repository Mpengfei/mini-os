#include <common/debug/debug.h>
#include <kernel/scheduler.h>
#include <kernel/smp.h>
#include <kernel/topology.h>
#include "platform_def.h"

#define PSCI_VERSION            0x84000000U
#define PSCI_CPU_ON_64          0xC4000003U
#define PSCI_RET_SUCCESS        0
#define PSCI_RET_ALREADY_ON    -4
#define PSCI_RET_INVALID_PARAMS -2
#define PSCI_RET_DENIED        -3

static struct smp_cpu_state cpu_states[PLAT_MAX_CPUS];
static unsigned int online_cpu_count;
unsigned char secondary_stacks[PLAT_MAX_CPUS][PLAT_STACK_SIZE] __attribute__((aligned(16)));

extern void secondary_cpu_entrypoint(void);

static int32_t smp_smc_call(uint64_t x0, uint64_t x1, uint64_t x2, uint64_t x3)
{
	register uint64_t r0 __asm__("x0") = x0;
	register uint64_t r1 __asm__("x1") = x1;
	register uint64_t r2 __asm__("x2") = x2;
	register uint64_t r3 __asm__("x3") = x3;

	__asm__ volatile ("smc #0"
		: "+r" (r0)
		: "r" (r1), "r" (r2), "r" (r3)
		: "x4", "x5", "x6", "x7", "x8", "x9", "x10", "x11", "x12",
		  "x13", "x14", "x15", "x16", "x17", "memory");

	return (int32_t)r0;
}

static int smp_find_free_logical_slot(void)
{
	unsigned int i;

	for (i = 0U; i < PLAT_MAX_CPUS; ++i) {
		if (!topology_cpu(i)->present) {
			return (int)i;
		}
	}

	return -1;
}

void smp_init(void)
{
	unsigned int i;
	const struct cpu_topology_descriptor *boot_cpu = topology_boot_cpu();

	(void)smp_smc_call(PSCI_VERSION, 0U, 0U, 0U);

	for (i = 0U; i < PLAT_MAX_CPUS; ++i) {
		cpu_states[i].logical_id = i;
		cpu_states[i].mpidr = 0U;
		cpu_states[i].online = false;
		cpu_states[i].scheduled = false;
		cpu_states[i].pending = false;
		cpu_states[i].boot_cpu = false;
	}

	cpu_states[0].logical_id = 0U;
	cpu_states[0].mpidr = boot_cpu->mpidr;
	cpu_states[0].boot_cpu = true;
	cpu_states[0].online = true;
	cpu_states[0].scheduled = true;
	online_cpu_count = 1U;
}

int smp_start_cpu(uint64_t mpidr, unsigned int *logical_id)
{
	const struct cpu_topology_descriptor *cpu;
	int slot;
	int32_t ret;

	cpu = topology_find_cpu_by_mpidr(mpidr);
	if (cpu != (const struct cpu_topology_descriptor *)0) {
		*logical_id = cpu->logical_id;
		if (cpu_states[cpu->logical_id].online) {
			return SMP_START_ALREADY_ONLINE;
		}
	} else {
		slot = smp_find_free_logical_slot();
		if (slot < 0) {
			return SMP_START_INVALID_CPU;
		}
		*logical_id = (unsigned int)slot;
		topology_register_cpu(*logical_id, mpidr, false);
		cpu_states[*logical_id].logical_id = *logical_id;
		cpu_states[*logical_id].mpidr = mpidr;
	}

	cpu_states[*logical_id].pending = true;
	ret = smp_smc_call(PSCI_CPU_ON_64, mpidr,
			   (uintptr_t)secondary_cpu_entrypoint,
			   *logical_id);
	if (ret == PSCI_RET_SUCCESS) {
		return SMP_START_OK;
	}
	if (ret == PSCI_RET_ALREADY_ON) {
		cpu_states[*logical_id].pending = false;
		cpu_states[*logical_id].online = true;
		cpu_states[*logical_id].scheduled = true;
		return SMP_START_ALREADY_ONLINE;
	}
	if ((ret == PSCI_RET_INVALID_PARAMS) || (ret == PSCI_RET_DENIED)) {
		cpu_states[*logical_id].pending = false;
		return SMP_START_DENIED;
	}

	cpu_states[*logical_id].pending = false;
	return SMP_START_UNSUPPORTED;
}

const struct smp_cpu_state *smp_cpu_state(unsigned int logical_id)
{
	if (logical_id >= PLAT_MAX_CPUS) {
		return (const struct smp_cpu_state *)0;
	}

	return &cpu_states[logical_id];
}

unsigned int smp_online_cpu_count(void)
{
	return online_cpu_count;
}

void smp_secondary_cpu_online(unsigned int logical_id)
{
	if ((logical_id >= PLAT_MAX_CPUS) || cpu_states[logical_id].online) {
		return;
	}

	cpu_states[logical_id].pending = false;
	cpu_states[logical_id].online = true;
	cpu_states[logical_id].scheduled = true;
	online_cpu_count++;
	topology_mark_cpu_online(logical_id, true);
	scheduler_join_cpu(logical_id);
}

void smp_secondary_entry(uint64_t logical_id)
{
	smp_secondary_cpu_online((unsigned int)logical_id);
	mini_os_printf("secondary cpu%u online (mpidr=0x%llx), scheduler runnable=%u\n",
		       (unsigned int)logical_id,
		       (unsigned long long)cpu_states[logical_id].mpidr,
		       scheduler_runnable_cpu_count());

	for (;;) {
		__asm__ volatile ("wfe");
	}
}

uintptr_t smp_secondary_entrypoint(void)
{
	return (uintptr_t)secondary_cpu_entrypoint;
}