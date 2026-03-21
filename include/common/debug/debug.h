#ifndef DEBUG_H
#define DEBUG_H

#include <stddef.h>
#include <stdint.h>

void debug_console_init(void);
void debug_putc(int ch);
void debug_puts(const char *str);
void debug_write(const char *buf, size_t len);
int  debug_getc(void);
int  debug_try_getc(void);
void debug_put_hex64(uint64_t value);
void debug_flush(void);

#endif /* DEBUG_H */