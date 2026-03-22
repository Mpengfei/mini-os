#include <stdint.h>

#include <common/debug/debug.h>
#include <drivers/interrupt/gic.h>
#include <kernel/scheduler.h>
#include <kernel/shell.h>
#include <kernel/smp.h>
#include <kernel/test.h>
#include <kernel/topology.h>
#include "platform_def.h"

#define MINI_OS_NAME       "Mini-OS"
#define MINI_OS_VERSION    "V0.1"
#define MINI_OS_BUILD_YEAR 2026

volatile uint64_t boot_magic = PLAT_LOAD_ADDR;

static void print_mini_os_banner(void)
{
    debug_puts("\n");
    debug_puts("============================================================\n");
    debug_puts("            __  __   ___   _   _   ___    ___    ____      \n");
    debug_puts("           |  \\/  | |_ _| | \\ | | |_ _|  / _ \\  / ___|     \n");
    debug_puts("           | |\\/| |  | |  |  \\| |  | |  | | | | \\___ \\     \n");
    debug_puts("           | |  | |  | |  | |\\  |  | |  | |_| |  ___) |    \n");
    debug_puts("           |_|  |_| |___| |_| \\_| |___|  \\___/  |____/     \n");
    debug_puts("============================================================\n");
    debug_puts("                     2026  Mini-OS  V0.1                    \n");
    debug_puts("============================================================\n");
    debug_puts("\n");

    mini_os_printf("UART ready @ 0x%llx, boot magic: 0x%llx\n\n",
		       (unsigned long long)PLAT_UART0_BASE,
		       (unsigned long long)boot_magic);
}

static void initialize_phase0_modules(void)
{
    debug_console_init();
	topology_init();
	scheduler_init();
	scheduler_join_cpu(0U);
	smp_init();
	gic_init();
	test_framework_init();
}

void kernel_main(void)
{
    initialize_phase0_modules();
	print_mini_os_banner();
	shell_run();
}