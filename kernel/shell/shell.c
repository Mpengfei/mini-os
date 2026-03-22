#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#include <common/debug/debug.h>
#include <kernel/scheduler.h>
#include <kernel/shell.h>
#include <kernel/smp.h>
#include <kernel/topology.h>
#include "platform_def.h"

#define SHELL_PROMPT       "mini-os> "
#define SHELL_MAX_LINE     128
#define SHELL_MAX_ARGS     8
#define MINI_OS_NAME       "Mini-OS"
#define MINI_OS_VERSION    "V0.1"
#define MINI_OS_BUILD_YEAR 2026

extern volatile uint64_t boot_magic;

static bool is_space(char ch)
{
	return (ch == ' ') || (ch == '\t') || (ch == '\r') || (ch == '\n');
}

static bool strings_equal(const char *lhs, const char *rhs)
{
	while ((*lhs != '\0') && (*rhs != '\0')) {
		if (*lhs != *rhs) {
			return false;
		}
		lhs++;
		rhs++;
	}

	return (*lhs == '\0') && (*rhs == '\0');
}

static const char *shell_help_topic_name(const char *arg)
{
	if ((arg == (const char *)0) || (*arg == '\0')) {
		return (const char *)0;
	}

	if ((arg[0] == '-') && (arg[1] == '-')) {
		return arg + 2;
	}

	return arg;
}

static bool parse_u64(const char *str, uint64_t *value)
{
	uint64_t result = 0U;
	unsigned int base = 10U;
	char ch;

	if ((str == (const char *)0) || (*str == '\0')) {
		return false;
	}

	if ((str[0] == '0') && ((str[1] == 'x') || (str[1] == 'X'))) {
		base = 16U;
		str += 2;
	}
	if (*str == '\0') {
		return false;
	}

	while ((ch = *str++) != '\0') {
		unsigned int digit;

		if ((ch >= '0') && (ch <= '9')) {
			digit = (unsigned int)(ch - '0');
		} else if ((base == 16U) && (ch >= 'a') && (ch <= 'f')) {
			digit = (unsigned int)(ch - 'a') + 10U;
		} else if ((base == 16U) && (ch >= 'A') && (ch <= 'F')) {
			digit = (unsigned int)(ch - 'A') + 10U;
		} else {
			return false;
		}
		if (digit >= base) {
			return false;
		}
		result = result * base + digit;
	}

	*value = result;
	return true;
}

static int shell_tokenize(char *line, char *argv[], int max_args)
{
	int argc = 0;

	while (*line != '\0') {
		while (is_space(*line)) {
			*line++ = '\0';
		}

		if (*line == '\0') {
			break;
		}

		if (argc >= max_args) {
			break;
		}

		argv[argc++] = line;
		while ((*line != '\0') && !is_space(*line)) {
			line++;
		}
	}

	return argc;
}

static void shell_print_cpu_entry(unsigned int logical_id)
{
	const struct cpu_topology_descriptor *cpu = topology_cpu(logical_id);
	const struct smp_cpu_state *state = smp_cpu_state(logical_id);

	if ((cpu == (const struct cpu_topology_descriptor *)0) ||
	    (state == (const struct smp_cpu_state *)0) ||
	    !cpu->present) {
		return;
	}

	mini_os_printf("cpu%-2u mpidr=0x%llx chip=%u die=%u cluster=%u core=%u online=%s scheduled=%s pending=%s boot=%s\n",
		       cpu->logical_id,
		       (unsigned long long)cpu->mpidr,
		       cpu->chip_id,
		       cpu->die_id,
		       cpu->cluster_id,
		       cpu->core_id,
		       state->online ? "yes" : "no",
		       state->scheduled ? "yes" : "no",
		       state->pending ? "yes" : "no",
		       cpu->boot_cpu ? "yes" : "no");
}

static void shell_print_help_overview(void)
{
	mini_os_printf("Built-in commands:\n");
	mini_os_printf("  help [--topic]    Show command help or detailed help for one topic\n");
	mini_os_printf("  version           Show OS version information\n");
	mini_os_printf("  info              Show current platform/runtime info\n");
	mini_os_printf("  cpu [id]          Show CPU information\n");
	mini_os_printf("  cpus              List known CPUs\n");
	mini_os_printf("  topo              Show topology summary\n");
	mini_os_printf("  smp status        Show SMP status\n");
	mini_os_printf("  smp start <mpidr> Ask TF-A via SMC/PSCI to start a secondary CPU\n");
	mini_os_printf("  echo ...          Print arguments back to the console\n");
	mini_os_printf("  clear             Clear the terminal screen\n");
	mini_os_printf("  uname             Print the OS name\n");
	mini_os_printf("  halt              Stop the CPU in a low-power wait loop\n");
	mini_os_printf("Examples: help --cpus, help --smp, help --topo\n");
}

static void shell_print_help_topic(const char *topic)
{
	if ((topic == (const char *)0) || strings_equal(topic, "help")) {
		mini_os_printf("help [--topic]\n");
		mini_os_printf("  Show the command list or detailed help for a single topic.\n");
		mini_os_printf("Examples:\n");
		mini_os_printf("  help\n");
		mini_os_printf("  help --cpus\n");
		mini_os_printf("  help --smp\n");
		return;
	}

	if (strings_equal(topic, "cpu")) {
		mini_os_printf("cpu [id]\n");
		mini_os_printf("  Show one logical CPU entry from the topology/SMP tables.\n");
		mini_os_printf("  If no id is given, it prints the current boot CPU entry.\n");
		mini_os_printf("Examples:\n");
		mini_os_printf("  cpu\n");
		mini_os_printf("  cpu 0\n");
		mini_os_printf("  cpu 1\n");
		return;
	}

	if (strings_equal(topic, "cpus")) {
		mini_os_printf("cpus\n");
		mini_os_printf("  List all CPUs that are currently registered in the topology table.\n");
		mini_os_printf("  The line shows mpidr/chip/die/cluster/core plus online, scheduled, pending and boot flags.\n");
		mini_os_printf("Examples:\n");
		mini_os_printf("  cpus\n");
		mini_os_printf("  help --cpu\n");
		return;
	}

	if (strings_equal(topic, "topo")) {
		mini_os_printf("topo\n");
		mini_os_printf("  Print a compact topology summary for the boot CPU and current CPU counts.\n");
		mini_os_printf("  Useful for checking the boot MPIDR and the decoded chip/die/cluster/core affinity.\n");
		mini_os_printf("Examples:\n");
		mini_os_printf("  topo\n");
		return;
	}

	if (strings_equal(topic, "smp")) {
		mini_os_printf("smp status\n");
		mini_os_printf("  Show the same per-CPU runtime table as 'cpus'.\n");
		mini_os_printf("smp start <mpidr>\n");
		mini_os_printf("  Ask TF-A/BL31 through SMC/PSCI CPU_ON to start the target CPU identified by MPIDR.\n");
		mini_os_printf("  The shell passes TF-A the target MPIDR and the mini-OS secondary entry address.\n");
		mini_os_printf("Examples:\n");
		mini_os_printf("  smp status\n");
		mini_os_printf("  smp start 0x80000001\n");
		mini_os_printf("  smp start 2147483649\n");
		return;
	}

	if (strings_equal(topic, "info")) {
		mini_os_printf("info\n");
		mini_os_printf("  Show platform-level runtime information such as UART base, load address, boot magic and runnable CPU count.\n");
		mini_os_printf("Example:\n");
		mini_os_printf("  info\n");
		return;
	}

	if (strings_equal(topic, "version")) {
		mini_os_printf("version\n");
		mini_os_printf("  Show the Mini-OS name, version string and build year.\n");
		mini_os_printf("Example:\n");
		mini_os_printf("  version\n");
		return;
	}

	if (strings_equal(topic, "echo")) {
		mini_os_printf("echo <text...>\n");
		mini_os_printf("  Print the provided arguments back to the serial console.\n");
		mini_os_printf("Example:\n");
		mini_os_printf("  echo hello mini-os\n");
		return;
	}

	if (strings_equal(topic, "clear")) {
		mini_os_printf("clear\n");
		mini_os_printf("  Send ANSI escape sequences to clear the serial terminal and move the cursor to the top-left corner.\n");
		mini_os_printf("Example:\n");
		mini_os_printf("  clear\n");
		return;
	}

	if (strings_equal(topic, "uname")) {
		mini_os_printf("uname\n");
		mini_os_printf("  Print the OS name only.\n");
		mini_os_printf("Example:\n");
		mini_os_printf("  uname\n");
		return;
	}

	if (strings_equal(topic, "halt")) {
		mini_os_printf("halt\n");
		mini_os_printf("  Stop the current CPU in a low-power wait loop.\n");
		mini_os_printf("Example:\n");
		mini_os_printf("  halt\n");
		return;
	}

	mini_os_printf("No detailed help for topic '%s'.\n", topic);
	mini_os_printf("Try one of: cpu, cpus, topo, smp, info, version, echo, clear, uname, halt\n");
}

void shell_print_help(void)
{
	shell_print_help_overview();
}

static void shell_print_version(void)
{
	mini_os_printf("%s %s (%d)\n", MINI_OS_NAME, MINI_OS_VERSION,
		       MINI_OS_BUILD_YEAR);
}

static void shell_print_info(void)
{
	mini_os_printf("Platform      : %s\n", "Neoverse-N3");
	mini_os_printf("UART base     : 0x%llx\n",
		       (unsigned long long)PLAT_UART0_BASE);
	mini_os_printf("Load address  : 0x%llx\n",
		       (unsigned long long)PLAT_LOAD_ADDR);
	mini_os_printf("Boot magic    : 0x%llx\n",
		       (unsigned long long)boot_magic);
	mini_os_printf("Runnable CPUs : %u\n", scheduler_runnable_cpu_count());
}

static void shell_print_current_cpu(void)
{
	shell_print_cpu_entry(0U);
}

static void shell_print_cpu_id(const char *arg)
{
	uint64_t logical_id;
	const struct cpu_topology_descriptor *cpu;

	if (!parse_u64(arg, &logical_id)) {
		mini_os_printf("error: invalid cpu id '%s'\n", arg);
		return;
	}

	cpu = topology_cpu((unsigned int)logical_id);
	if ((cpu == (const struct cpu_topology_descriptor *)0) || !cpu->present) {
		mini_os_printf("cpu%u is not present\n", (unsigned int)logical_id);
		return;
	}

	shell_print_cpu_entry((unsigned int)logical_id);
}

static void shell_print_cpus(void)
{
	unsigned int i;

	for (i = 0U; i < topology_cpu_capacity(); ++i) {
		const struct cpu_topology_descriptor *cpu = topology_cpu(i);

		if ((cpu != (const struct cpu_topology_descriptor *)0) && cpu->present) {
			shell_print_cpu_entry(i);
		}
	}
	mini_os_printf("online=%u runnable=%u capacity=%u\n",
		       topology_online_cpu_count(),
		       scheduler_runnable_cpu_count(),
		       topology_cpu_capacity());
}

static void shell_print_topology_summary(void)
{
	const struct cpu_topology_descriptor *boot_cpu = topology_boot_cpu();

	mini_os_printf("Topology summary:\n");
	mini_os_printf("  present cpus : %u\n", topology_present_cpu_count());
	mini_os_printf("  online cpus  : %u\n", topology_online_cpu_count());
	mini_os_printf("  boot cpu     : cpu%u\n", boot_cpu->logical_id);
	mini_os_printf("  boot mpidr   : 0x%llx\n", (unsigned long long)boot_cpu->mpidr);
	mini_os_printf("  affinity     : chip=%u die=%u cluster=%u core=%u\n",
		       boot_cpu->chip_id,
		       boot_cpu->die_id,
		       boot_cpu->cluster_id,
		       boot_cpu->core_id);
}

static void shell_echo_args(int argc, char *argv[])
{
	int i;

	for (i = 1; i < argc; ++i) {
		mini_os_printf("%s", argv[i]);
		if (i + 1 < argc) {
			mini_os_printf(" ");
		}
	}
	mini_os_printf("\n");
}

static void shell_clear_screen(void)
{
	mini_os_printf("\033[2J\033[H");
}

static void shell_halt(void)
{
	mini_os_printf("Halting CPU. Use reset/restart in your emulator or board monitor.\n");
	for (;;) {
		__asm__ volatile ("wfe");
	}
}

static void shell_print_smp_already_online(uint64_t mpidr,
					   unsigned int logical_id,
					   const struct smp_cpu_state *state)
{
	if ((state != (const struct smp_cpu_state *)0) && state->boot_cpu) {
		mini_os_printf("cpu%u (mpidr=0x%llx) is the boot CPU, already online by default\n",
			       logical_id,
			       (unsigned long long)mpidr);
		return;
	}

	if ((state != (const struct smp_cpu_state *)0) && state->online) {
		mini_os_printf("cpu%u (mpidr=0x%llx) is a secondary CPU that is already online and scheduled\n",
			       logical_id,
			       (unsigned long long)mpidr);
		return;
	}

	mini_os_printf("TF-A returned already-on for mpidr=0x%llx, but mini-os did not observe this secondary CPU actually boot\n",
		       (unsigned long long)mpidr);
}

static void shell_handle_smp(int argc, char *argv[])
{
	uint64_t mpidr;
	unsigned int logical_id = 0U;
	int32_t smc_ret = 0;
	int ret;
	const struct smp_cpu_state *state = (const struct smp_cpu_state *)0;

	if (argc < 2) {
		mini_os_printf("usage: smp status | smp start <mpidr>\n");
		return;
	}

	if (strings_equal(argv[1], "status")) {
		shell_print_cpus();
		return;
	}

	if (strings_equal(argv[1], "start")) {
		if (argc < 3) {
			mini_os_printf("usage: smp start <mpidr>\n");
			return;
		}
		if (!parse_u64(argv[2], &mpidr)) {
			mini_os_printf("error: invalid mpidr '%s'\n", argv[2]);
			return;
		}

		ret = smp_start_cpu(mpidr, &logical_id, &smc_ret);
		state = smp_cpu_state(logical_id);

		mini_os_printf("TF-A cpu_on(mpidr=0x%llx, entry=0x%llx, ctx=cpu%u) -> smc=%d (%s)\n",
			       (unsigned long long)mpidr,
			       (unsigned long long)smp_secondary_entrypoint(),
			       logical_id,
			       smc_ret,
			       smp_start_result_name(ret));

		if (ret == SMP_START_OK) {
			mini_os_printf("cpu%u power-on confirmed: online=%s scheduled=%s pending=%s runnable=%u\n",
				       logical_id,
				       ((state != (const struct smp_cpu_state *)0) && state->online) ? "yes" : "no",
				       ((state != (const struct smp_cpu_state *)0) && state->scheduled) ? "yes" : "no",
				       ((state != (const struct smp_cpu_state *)0) && state->pending) ? "yes" : "no",
				       scheduler_runnable_cpu_count());
		} else if (ret == SMP_START_ALREADY_ONLINE) {
			shell_print_smp_already_online(mpidr, logical_id, state);
		} else if (ret == SMP_START_INVALID_CPU) {
			mini_os_printf("TF-A reported invalid target or no logical slot left for mpidr=0x%llx (capacity=%u)\n",
				       (unsigned long long)mpidr,
				       topology_cpu_capacity());
		} else if (ret == SMP_START_DENIED) {
			mini_os_printf("TF-A denied cpu-on for mpidr=0x%llx\n",
				       (unsigned long long)mpidr);
		} else if (ret == SMP_START_UNSUPPORTED) {
			mini_os_printf("TF-A/PSCI does not support cpu-on for mpidr=0x%llx\n",
				       (unsigned long long)mpidr);
		} else if (ret == SMP_START_TIMEOUT) {
			mini_os_printf("cpu%u did not report online before timeout; please inspect TF-A handoff or secondary entry path\n",
				       logical_id);
		} else {
			mini_os_printf("cpu-on failed for mpidr=0x%llx with unexpected smc result %d\n",
				       (unsigned long long)mpidr,
				       smc_ret);
		}
		return;
	}

	mini_os_printf("unknown smp subcommand: %s\n", argv[1]);
}

static void shell_execute(char *line)
{
	char *argv[SHELL_MAX_ARGS];
	int argc;
	const char *topic;

	argc = shell_tokenize(line, argv, SHELL_MAX_ARGS);
	if (argc == 0) {
		return;
	}

	if (strings_equal(argv[0], "help")) {
		if (argc >= 2) {
			topic = shell_help_topic_name(argv[1]);
			shell_print_help_topic(topic);
		} else {
			shell_print_help();
		}
	} else if (strings_equal(argv[0], "version")) {
		shell_print_version();
	} else if (strings_equal(argv[0], "info")) {
		shell_print_info();
	} else if (strings_equal(argv[0], "cpu")) {
		if (argc >= 2) {
			shell_print_cpu_id(argv[1]);
		} else {
			shell_print_current_cpu();
		}
	} else if (strings_equal(argv[0], "cpus")) {
		shell_print_cpus();
	} else if (strings_equal(argv[0], "topo")) {
		shell_print_topology_summary();
	} else if (strings_equal(argv[0], "smp")) {
		shell_handle_smp(argc, argv);
	} else if (strings_equal(argv[0], "echo")) {
		shell_echo_args(argc, argv);
	} else if (strings_equal(argv[0], "clear")) {
		shell_clear_screen();
	} else if (strings_equal(argv[0], "uname")) {
		mini_os_printf("%s\n", MINI_OS_NAME);
	} else if (strings_equal(argv[0], "halt")) {
		shell_halt();
	} else {
		mini_os_printf("Unknown command: %s\n", argv[0]);
		mini_os_printf("Type 'help' to list supported commands.\n");
	}
}

static void shell_prompt(void)
{
	mini_os_printf("%s", SHELL_PROMPT);
}

void shell_run(void)
{
	char line[SHELL_MAX_LINE];
	size_t len = 0U;

	shell_prompt();
	for (;;) {
		int ch = debug_getc();

		if ((ch == '\r') || (ch == '\n')) {
			mini_os_printf("\n");
			line[len] = '\0';
			shell_execute(line);
			len = 0U;
			shell_prompt();
			continue;
		}

		if ((ch == '\b') || (ch == 127)) {
			if (len > 0U) {
				len--;
				mini_os_printf("\b \b");
			}
			continue;
		}

		if (ch == '\t') {
			continue;
		}

		if ((ch < 32) || (ch > 126)) {
			continue;
		}

		if (len + 1U >= SHELL_MAX_LINE) {
			mini_os_printf("\nerror: command too long (max %d chars)\n",
				       SHELL_MAX_LINE - 1);
			len = 0U;
			shell_prompt();
			continue;
		}

		line[len++] = (char)ch;
		debug_putc(ch);
	}
}