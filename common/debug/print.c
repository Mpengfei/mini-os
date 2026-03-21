#include <common/debug/debug.h>
#include <drivers/console/uart.h>

void debug_console_init(void)
{
	uart_init();
}

void debug_putc(int ch)
{
	uart_putc(ch);
}

void debug_puts(const char *str)
{
	uart_puts(str);
}

void debug_write(const char *buf, size_t len)
{
	uart_write(buf, len);
}

int debug_getc(void)
{
	return uart_getc();
}

int debug_try_getc(void)
{
	return uart_try_getc();
}

void debug_put_hex64(uint64_t value)
{
	uart_put_hex64(value);
}

void debug_flush(void)
{
	uart_flush();
}