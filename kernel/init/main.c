#include <stdint.h>

#include <common/debug/debug.h>
#include "platform_def.h"

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
}

void kernel_main(void)
{
	print_mini_os_banner();

	for (;;) {
		__asm__ volatile ("wfe");
	}
}