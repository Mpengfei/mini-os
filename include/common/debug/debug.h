#ifndef DEBUG_H
#define DEBUG_H

#include <stdarg.h>
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
int  debug_vprintf(const char *fmt, va_list args);
int  debug_printf(const char *fmt, ...);
int  mini_os_vprintf(const char *fmt, va_list args);
int  mini_os_printf(const char *fmt, ...);

#endif /* DEBUG_H */