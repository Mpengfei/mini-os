#include <common/debug/debug.h>
#include <drivers/console/uart.h>

#include <stdarg.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#define FLAG_LEFT   (1U << 0)
#define FLAG_PLUS   (1U << 1)
#define FLAG_SPACE  (1U << 2)
#define FLAG_ALT    (1U << 3)
#define FLAG_ZERO   (1U << 4)
#define FLAG_UPPER  (1U << 5)

#define LENGTH_DEFAULT 0
#define LENGTH_HH      1
#define LENGTH_H       2
#define LENGTH_L       3
#define LENGTH_LL      4
#define LENGTH_Z       5
#define LENGTH_T       6
#define LENGTH_J       7

struct print_ctx {
	int count;
};

struct format_spec {
	unsigned int flags;
	int width;
	int precision;
	int length;
	char conv;
};

static void print_char(struct print_ctx *ctx, char ch)
{
	if (ch == '\n') {
		debug_putc('\r');
	}

	debug_putc((int)ch);
	ctx->count++;
}

static void print_repeat(struct print_ctx *ctx, char ch, int count)
{
	while (count-- > 0) {
		print_char(ctx, ch);
	}
}

static size_t str_length(const char *str)
{
	size_t len = 0U;

	while (str[len] != '\0') {
		len++;
	}

	return len;
}

static uint64_t get_unsigned_arg(va_list *args, int length)
{
	switch (length) {
	case LENGTH_HH:
		return (uint64_t)(unsigned char)va_arg(*args, unsigned int);
	case LENGTH_H:
		return (uint64_t)(unsigned short)va_arg(*args, unsigned int);
	case LENGTH_L:
		return (uint64_t)va_arg(*args, unsigned long);
	case LENGTH_LL:
		return (uint64_t)va_arg(*args, unsigned long long);
	case LENGTH_Z:
		return (uint64_t)va_arg(*args, size_t);
	case LENGTH_T:
		return (uint64_t)va_arg(*args, ptrdiff_t);
	case LENGTH_J:
		return (uint64_t)va_arg(*args, uintmax_t);
	default:
		return (uint64_t)va_arg(*args, unsigned int);
	}
}

static int64_t get_signed_arg(va_list *args, int length)
{
	switch (length) {
	case LENGTH_HH:
		return (int64_t)(signed char)va_arg(*args, int);
	case LENGTH_H:
		return (int64_t)(short)va_arg(*args, int);
	case LENGTH_L:
		return (int64_t)va_arg(*args, long);
	case LENGTH_LL:
		return (int64_t)va_arg(*args, long long);
	case LENGTH_Z:
		return (int64_t)(ptrdiff_t)va_arg(*args, size_t);
	case LENGTH_T:
		return (int64_t)va_arg(*args, ptrdiff_t);
	case LENGTH_J:
		return (int64_t)va_arg(*args, intmax_t);
	default:
		return (int64_t)va_arg(*args, int);
	}
}

static size_t u64_to_str(uint64_t value, unsigned int base, bool upper,
			 char *buf)
{
	static const char lower_digits[] = "0123456789abcdef";
	static const char upper_digits[] = "0123456789ABCDEF";
	const char *digits = upper ? upper_digits : lower_digits;
	size_t len = 0U;

	do {
		buf[len++] = digits[value % base];
		value /= base;
	} while (value != 0U);

	return len;
}

static void print_buffer(struct print_ctx *ctx, const char *buf, size_t len)
{
	while (len-- > 0U) {
		print_char(ctx, *buf++);
	}
}

static void format_integer(struct print_ctx *ctx, struct format_spec *spec,
			   uint64_t value, bool negative, unsigned int base)
{
	char digits[32];
	char prefix[3];
	size_t digits_len;
	size_t prefix_len = 0U;
	size_t zero_pad = 0U;
	size_t total_len;
	int pad_len;
	bool precision_specified = spec->precision >= 0;
	bool zero_value_suppressed = precision_specified &&
		(spec->precision == 0) && (value == 0U);

	if (negative) {
		prefix[prefix_len++] = '-';
	} else if ((spec->flags & FLAG_PLUS) != 0U) {
		prefix[prefix_len++] = '+';
	} else if ((spec->flags & FLAG_SPACE) != 0U) {
		prefix[prefix_len++] = ' ';
	}

	if ((spec->flags & FLAG_ALT) != 0U) {
		if ((base == 8U) && ((value != 0U) || !precision_specified || (spec->precision == 0))) {
			prefix[prefix_len++] = '0';
		} else if ((base == 16U) && (value != 0U)) {
			prefix[prefix_len++] = '0';
			prefix[prefix_len++] = ((spec->flags & FLAG_UPPER) != 0U) ? 'X' : 'x';
		}
	}

	if (zero_value_suppressed) {
		digits_len = 0U;
	} else {
		digits_len = u64_to_str(value, base, (spec->flags & FLAG_UPPER) != 0U,
				      digits);
	}

	if (precision_specified && ((size_t)spec->precision > digits_len)) {
		zero_pad = (size_t)spec->precision - digits_len;
	} else if (((spec->flags & FLAG_ZERO) != 0U) &&
		   ((spec->flags & FLAG_LEFT) == 0U) &&
		   !precision_specified &&
		   (spec->width > (int)(prefix_len + digits_len))) {
		zero_pad = (size_t)spec->width - prefix_len - digits_len;
	}

	total_len = prefix_len + zero_pad + digits_len;
	pad_len = (spec->width > (int)total_len) ? spec->width - (int)total_len : 0;

	if ((spec->flags & FLAG_LEFT) == 0U) {
		print_repeat(ctx, ' ', pad_len);
	}

	print_buffer(ctx, prefix, prefix_len);
	print_repeat(ctx, '0', (int)zero_pad);
	while (digits_len-- > 0U) {
		print_char(ctx, digits[digits_len]);
	}

	if ((spec->flags & FLAG_LEFT) != 0U) {
		print_repeat(ctx, ' ', pad_len);
	}
}

static void format_string(struct print_ctx *ctx, struct format_spec *spec,
			  const char *str)
{
	size_t len;
	int pad_len;

	if (str == NULL) {
		str = "(null)";
	}

	len = str_length(str);
	if ((spec->precision >= 0) && ((size_t)spec->precision < len)) {
		len = (size_t)spec->precision;
	}

	pad_len = (spec->width > (int)len) ? spec->width - (int)len : 0;
	if ((spec->flags & FLAG_LEFT) == 0U) {
		print_repeat(ctx, ' ', pad_len);
	}
	print_buffer(ctx, str, len);
	if ((spec->flags & FLAG_LEFT) != 0U) {
		print_repeat(ctx, ' ', pad_len);
	}
}

static void format_char(struct print_ctx *ctx, struct format_spec *spec, char ch)
{
	int pad_len = (spec->width > 1) ? spec->width - 1 : 0;

	if ((spec->flags & FLAG_LEFT) == 0U) {
		print_repeat(ctx, ' ', pad_len);
	}
	print_char(ctx, ch);
	if ((spec->flags & FLAG_LEFT) != 0U) {
		print_repeat(ctx, ' ', pad_len);
	}
}

static bool parse_number(const char **fmt, int *value)
{
	bool found = false;
	int result = 0;

	while ((**fmt >= '0') && (**fmt <= '9')) {
		found = true;
		result = result * 10 + (**fmt - '0');
		(*fmt)++;
	}

	*value = result;
	return found;
}

static void parse_format(const char **fmt, struct format_spec *spec, va_list *args)
{
	const char *p = *fmt;
	int value;

	spec->flags = 0U;
	spec->width = 0;
	spec->precision = -1;
	spec->length = LENGTH_DEFAULT;
	spec->conv = '\0';

	for (;;) {
		switch (*p) {
		case '-': spec->flags |= FLAG_LEFT; p++; continue;
		case '+': spec->flags |= FLAG_PLUS; p++; continue;
		case ' ': spec->flags |= FLAG_SPACE; p++; continue;
		case '#': spec->flags |= FLAG_ALT; p++; continue;
		case '0': spec->flags |= FLAG_ZERO; p++; continue;
		default: break;
		}
		break;
	}

	if (*p == '*') {
		spec->width = va_arg(*args, int);
		if (spec->width < 0) {
			spec->flags |= FLAG_LEFT;
			spec->width = -spec->width;
		}
		p++;
	} else if (parse_number(&p, &value)) {
		spec->width = value;
	}

	if (*p == '.') {
		p++;
		if (*p == '*') {
			spec->precision = va_arg(*args, int);
			if (spec->precision < 0) {
				spec->precision = -1;
			}
			p++;
		} else {
			parse_number(&p, &value);
			spec->precision = value;
		}
	}

	if ((*p == 'h') && (*(p + 1) == 'h')) {
		spec->length = LENGTH_HH;
		p += 2;
	} else if (*p == 'h') {
		spec->length = LENGTH_H;
		p++;
	} else if ((*p == 'l') && (*(p + 1) == 'l')) {
		spec->length = LENGTH_LL;
		p += 2;
	} else if (*p == 'l') {
		spec->length = LENGTH_L;
		p++;
	} else if (*p == 'z') {
		spec->length = LENGTH_Z;
		p++;
	} else if (*p == 't') {
		spec->length = LENGTH_T;
		p++;
	} else if (*p == 'j') {
		spec->length = LENGTH_J;
		p++;
	}

	spec->conv = *p;
	if ((*p >= 'A') && (*p <= 'Z')) {
		spec->flags |= FLAG_UPPER;
	}
	if (*p != '\0') {
		p++;
	}
	*fmt = p;
}

int debug_vprintf(const char *fmt, va_list args)
{
	struct print_ctx ctx = { 0 };
	va_list ap;

	if (fmt == NULL) {
		return 0;
	}

	va_copy(ap, args);
	while (*fmt != '\0') {
		struct format_spec spec;
		uint64_t uvalue;
		int64_t svalue;

		if (*fmt != '%') {
			print_char(&ctx, *fmt++);
			continue;
		}

		fmt++;
		if (*fmt == '%') {
			print_char(&ctx, *fmt++);
			continue;
		}

		parse_format(&fmt, &spec, &ap);
		switch (spec.conv) {
		case 'd':
		case 'i':
			svalue = get_signed_arg(&ap, spec.length);
			uvalue = (svalue < 0) ? (uint64_t)(-(svalue + 1)) + 1U : (uint64_t)svalue;
			format_integer(&ctx, &spec, uvalue, svalue < 0, 10U);
			break;
		case 'u':
			format_integer(&ctx, &spec, get_unsigned_arg(&ap, spec.length), false, 10U);
			break;
		case 'o':
			format_integer(&ctx, &spec, get_unsigned_arg(&ap, spec.length), false, 8U);
			break;
		case 'x':
		case 'X':
			format_integer(&ctx, &spec, get_unsigned_arg(&ap, spec.length), false, 16U);
			break;
		case 'c':
			format_char(&ctx, &spec, (char)va_arg(ap, int));
			break;
		case 's':
			format_string(&ctx, &spec, va_arg(ap, const char *));
			break;
		case 'p':
			spec.flags |= FLAG_ALT;
			spec.length = LENGTH_LL;
			format_integer(&ctx, &spec, (uintptr_t)va_arg(ap, void *), false, 16U);
			break;
		case 'n':
			switch (spec.length) {
			case LENGTH_HH:
				*va_arg(ap, signed char *) = (signed char)ctx.count;
				break;
			case LENGTH_H:
				*va_arg(ap, short *) = (short)ctx.count;
				break;
			case LENGTH_L:
				*va_arg(ap, long *) = (long)ctx.count;
				break;
			case LENGTH_LL:
				*va_arg(ap, long long *) = (long long)ctx.count;
				break;
			default:
				*va_arg(ap, int *) = ctx.count;
				break;
			}
			break;
		default:
			print_char(&ctx, '%');
			if (spec.conv != '\0') {
				print_char(&ctx, spec.conv);
			}
			break;
		}
	}
	va_end(ap);
	return ctx.count;
}

int debug_printf(const char *fmt, ...)
{
	int count;
	va_list args;

	va_start(args, fmt);
	count = debug_vprintf(fmt, args);
	va_end(args);

	return count;
}

int mini_os_vprintf(const char *fmt, va_list args)
{
	return debug_vprintf(fmt, args);
}

int mini_os_printf(const char *fmt, ...)
{
	int count;
	va_list args;

	va_start(args, fmt);
	count = mini_os_vprintf(fmt, args);
	va_end(args);

	return count;
}

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