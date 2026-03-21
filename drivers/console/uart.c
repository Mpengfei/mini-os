#include "platform_def.h"

#include <drivers/console/uart.h>


static struct uart_device plat_uart = {
	.base = PLAT_UART0_BASE,
	.clock_hz = PLAT_UART0_CLK_HZ,
	.baudrate = PLAT_UART0_BAUDRATE,
};

static inline void mmio_write_32(uintptr_t addr, uint32_t value)
{
	*(volatile uint32_t *)addr = value;
}

static inline uint32_t mmio_read_32(uintptr_t addr)
{
	return *(volatile uint32_t *)addr;
}

static inline void dsb_sy(void)
{
	__asm__ volatile ("dsb sy" : : : "memory");
}

static inline void isb(void)
{
	__asm__ volatile ("isb" : : : "memory");
}

static void pl011_calc_baud(uint32_t uartclk_hz, uint32_t baud,
			    uint32_t *ibrd, uint32_t *fbrd)
{
	uint64_t denom;
	uint64_t div;
	uint64_t rem;
	uint64_t frac64;

	if ((uartclk_hz == 0U) || (baud == 0U)) {
		*ibrd = 1U;
		*fbrd = 0U;
		return;
	}

	denom = 16ULL * (uint64_t)baud;
	div = (uint64_t)uartclk_hz / denom;
	rem = (uint64_t)uartclk_hz % denom;
	frac64 = (rem * 64ULL + denom / 2ULL) / denom;

	if (div == 0U) {
		div = 1U;
	}
	if (frac64 > 63U) {
		frac64 = 63U;
	}

	*ibrd = (uint32_t)div;
	*fbrd = (uint32_t)frac64;
}

bool uart_is_configured(void)
{
	return (plat_uart.base != 0UL) &&
	       (plat_uart.clock_hz != 0U) &&
	       (plat_uart.baudrate != 0U);
}

bool uart_tx_ready(void)
{
	if (!uart_is_configured()) {
		return false;
	}

	return (mmio_read_32(plat_uart.base + PL011_FR) & FR_TXFF) == 0U;
}

bool uart_rx_ready(void)
{
	if (!uart_is_configured()) {
		return false;
	}

	return (mmio_read_32(plat_uart.base + PL011_FR) & FR_RXFE) == 0U;
}

void uart_init(void)
{
	uint32_t ibrd;
	uint32_t fbrd;

	if (!uart_is_configured()) {
		return;
	}

	mmio_write_32(plat_uart.base + PL011_CR, 0U);
	dsb_sy();
	isb();

	while ((mmio_read_32(plat_uart.base + PL011_FR) & FR_BUSY) != 0U) {
	}

	mmio_write_32(plat_uart.base + PL011_ICR, PL011_ICR_ALL);
	mmio_write_32(plat_uart.base + PL011_IMSC, 0U);

	pl011_calc_baud(plat_uart.clock_hz, plat_uart.baudrate, &ibrd, &fbrd);
	mmio_write_32(plat_uart.base + PL011_IBRD, ibrd);
	mmio_write_32(plat_uart.base + PL011_FBRD, fbrd);
	mmio_write_32(plat_uart.base + PL011_LCRH, LCRH_WLEN_8 | LCRH_FEN);
	mmio_write_32(plat_uart.base + PL011_CR, CR_UARTEN | CR_TXE | CR_RXE);
	dsb_sy();
	isb();
}

void uart_putc(int ch)
{
	if (!uart_is_configured()) {
		return;
	}

	while (!uart_tx_ready()) {
	}

	mmio_write_32(plat_uart.base + PL011_DR, (uint32_t)ch);
}

void uart_puts(const char *str)
{
	if (str == NULL) {
		return;
	}

	while (*str != '\0') {
		if (*str == '\n') {
			uart_putc('\r');
		}

		uart_putc(*str++);
	}
}

void uart_write(const char *buf, size_t len)
{
	size_t i;

	if (buf == NULL) {
		return;
	}

	for (i = 0; i < len; ++i) {
		uart_putc((int)buf[i]);
	}
}

int uart_try_getc(void)
{
	if (!uart_rx_ready()) {
		return -1;
	}

	return (int)(mmio_read_32(plat_uart.base + PL011_DR) & 0xFFU);
}

int uart_getc(void)
{
	int ch;

	if (!uart_is_configured()) {
		return -1;
	}

	do {
		ch = uart_try_getc();
	} while (ch < 0);

	return ch;
}

void uart_put_hex64(uint64_t value)
{
	static const char hex[] = "0123456789abcdef";
	int shift;

	for (shift = 60; shift >= 0; shift -= 4) {
		uart_putc(hex[(value >> shift) & 0xFULL]);
	}
}

void uart_flush(void)
{
	if (!uart_is_configured()) {
		return;
	}

	while ((mmio_read_32(plat_uart.base + PL011_FR) & FR_BUSY) != 0U) {
	}
}