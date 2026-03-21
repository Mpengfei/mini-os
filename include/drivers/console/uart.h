#ifndef UART_H
#define UART_H

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include "platform_def.h"

#define PL011_DR		0x00U
#define PL011_FR		0x18U
#define PL011_IBRD		0x24U
#define PL011_FBRD		0x28U
#define PL011_LCRH		0x2CU
#define PL011_CR		0x30U
#define PL011_IMSC		0x38U
#define PL011_ICR		0x44U

#define FR_RXFE			(1U << 4)
#define FR_TXFF			(1U << 5)
#define FR_BUSY			(1U << 3)

#define LCRH_FEN		(1U << 4)
#define LCRH_WLEN_8		(3U << 5)

#define CR_UARTEN		(1U << 0)
#define CR_TXE			(1U << 8)
#define CR_RXE			(1U << 9)

#define PL011_ICR_ALL		0x7FFU

struct uart_device {
	uintptr_t base;
	uint32_t clock_hz;
	uint32_t baudrate;
};

void uart_init(void);
bool uart_is_configured(void);
bool uart_tx_ready(void);
bool uart_rx_ready(void);
void uart_putc(int ch);
void uart_puts(const char *str);
void uart_write(const char *buf, size_t len);
int uart_getc(void);
int uart_try_getc(void);
void uart_put_hex64(uint64_t value);
void uart_flush(void);

#endif /* UART_H */