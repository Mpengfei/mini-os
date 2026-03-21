#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#include <common/debug/debug.h>
#include <kernel/shell.h>
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

void shell_print_help(void)
{
	mini_os_printf("Built-in commands:\n");
	mini_os_printf("  help      Show this help message\n");
	mini_os_printf("  version   Show OS version information\n");
	mini_os_printf("  info      Show current platform/runtime info\n");
	mini_os_printf("  echo ...  Print arguments back to the console\n");
	mini_os_printf("  clear     Clear the terminal screen\n");
	mini_os_printf("  uname     Print the OS name\n");
	mini_os_printf("  halt      Stop the CPU in a low-power wait loop\n");
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

static void shell_execute(char *line)
{
	char *argv[SHELL_MAX_ARGS];
	int argc;

	argc = shell_tokenize(line, argv, SHELL_MAX_ARGS);
	if (argc == 0) {
		return;
	}

	if (strings_equal(argv[0], "help")) {
		shell_print_help();
	} else if (strings_equal(argv[0], "version")) {
		shell_print_version();
	} else if (strings_equal(argv[0], "info")) {
		shell_print_info();
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