
/home/pengfei/felix-os/mini-os/build/Neoverse-N3/debug/mini-os.elf:     file format elf64-littleaarch64


Disassembly of section .text:

0000000088000000 <_start>:
    88000000:	580000c0 	ldr	x0, 88000018 <_start+0x18>
    88000004:	9100001f 	mov	sp, x0
    88000008:	940001e7 	bl	880007a4 <kernel_main>
    8800000c:	d503205f 	wfe
    88000010:	17ffffff 	b	8800000c <_start+0xc>
    88000014:	00000000 	udf	#0
    88000018:	88001a20 	.word	0x88001a20
    8800001c:	00000000 	.word	0x00000000

0000000088000020 <debug_console_init>:
#include <common/debug/debug.h>
#include <drivers/console/uart.h>

void debug_console_init(void)
{
    88000020:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    88000024:	910003fd 	mov	x29, sp
	uart_init();
    88000028:	940000c7 	bl	88000344 <uart_init>
}
    8800002c:	d503201f 	nop
    88000030:	a8c17bfd 	ldp	x29, x30, [sp], #16
    88000034:	d65f03c0 	ret

0000000088000038 <debug_putc>:

void debug_putc(int ch)
{
    88000038:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    8800003c:	910003fd 	mov	x29, sp
    88000040:	b9001fe0 	str	w0, [sp, #28]
	uart_putc(ch);
    88000044:	b9401fe0 	ldr	w0, [sp, #28]
    88000048:	94000110 	bl	88000488 <uart_putc>
}
    8800004c:	d503201f 	nop
    88000050:	a8c27bfd 	ldp	x29, x30, [sp], #32
    88000054:	d65f03c0 	ret

0000000088000058 <debug_puts>:

void debug_puts(const char *str)
{
    88000058:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    8800005c:	910003fd 	mov	x29, sp
    88000060:	f9000fe0 	str	x0, [sp, #24]
	uart_puts(str);
    88000064:	f9400fe0 	ldr	x0, [sp, #24]
    88000068:	94000123 	bl	880004f4 <uart_puts>
}
    8800006c:	d503201f 	nop
    88000070:	a8c27bfd 	ldp	x29, x30, [sp], #32
    88000074:	d65f03c0 	ret

0000000088000078 <debug_write>:

void debug_write(const char *buf, size_t len)
{
    88000078:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    8800007c:	910003fd 	mov	x29, sp
    88000080:	f9000fe0 	str	x0, [sp, #24]
    88000084:	f9000be1 	str	x1, [sp, #16]
	uart_write(buf, len);
    88000088:	f9400be1 	ldr	x1, [sp, #16]
    8800008c:	f9400fe0 	ldr	x0, [sp, #24]
    88000090:	94000133 	bl	8800055c <uart_write>
}
    88000094:	d503201f 	nop
    88000098:	a8c27bfd 	ldp	x29, x30, [sp], #32
    8800009c:	d65f03c0 	ret

00000000880000a0 <debug_getc>:

int debug_getc(void)
{
    880000a0:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    880000a4:	910003fd 	mov	x29, sp
	return uart_getc();
    880000a8:	94000158 	bl	88000608 <uart_getc>
}
    880000ac:	a8c17bfd 	ldp	x29, x30, [sp], #16
    880000b0:	d65f03c0 	ret

00000000880000b4 <debug_try_getc>:

int debug_try_getc(void)
{
    880000b4:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    880000b8:	910003fd 	mov	x29, sp
	return uart_try_getc();
    880000bc:	94000141 	bl	880005c0 <uart_try_getc>
}
    880000c0:	a8c17bfd 	ldp	x29, x30, [sp], #16
    880000c4:	d65f03c0 	ret

00000000880000c8 <debug_put_hex64>:

void debug_put_hex64(uint64_t value)
{
    880000c8:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    880000cc:	910003fd 	mov	x29, sp
    880000d0:	f9000fe0 	str	x0, [sp, #24]
	uart_put_hex64(value);
    880000d4:	f9400fe0 	ldr	x0, [sp, #24]
    880000d8:	9400015f 	bl	88000654 <uart_put_hex64>
}
    880000dc:	d503201f 	nop
    880000e0:	a8c27bfd 	ldp	x29, x30, [sp], #32
    880000e4:	d65f03c0 	ret

00000000880000e8 <debug_flush>:

void debug_flush(void)
{
    880000e8:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    880000ec:	910003fd 	mov	x29, sp
	uart_flush();
    880000f0:	94000171 	bl	880006b4 <uart_flush>
    880000f4:	d503201f 	nop
    880000f8:	a8c17bfd 	ldp	x29, x30, [sp], #16
    880000fc:	d65f03c0 	ret

0000000088000100 <mmio_write_32>:
	.clock_hz = PLAT_UART0_CLK_HZ,
	.baudrate = PLAT_UART0_BAUDRATE,
};

static inline void mmio_write_32(uintptr_t addr, uint32_t value)
{
    88000100:	d10043ff 	sub	sp, sp, #0x10
    88000104:	f90007e0 	str	x0, [sp, #8]
    88000108:	b90007e1 	str	w1, [sp, #4]
	*(volatile uint32_t *)addr = value;
    8800010c:	f94007e0 	ldr	x0, [sp, #8]
    88000110:	b94007e1 	ldr	w1, [sp, #4]
    88000114:	b9000001 	str	w1, [x0]
}
    88000118:	d503201f 	nop
    8800011c:	910043ff 	add	sp, sp, #0x10
    88000120:	d65f03c0 	ret

0000000088000124 <mmio_read_32>:

static inline uint32_t mmio_read_32(uintptr_t addr)
{
    88000124:	d10043ff 	sub	sp, sp, #0x10
    88000128:	f90007e0 	str	x0, [sp, #8]
	return *(volatile uint32_t *)addr;
    8800012c:	f94007e0 	ldr	x0, [sp, #8]
    88000130:	b9400000 	ldr	w0, [x0]
}
    88000134:	910043ff 	add	sp, sp, #0x10
    88000138:	d65f03c0 	ret

000000008800013c <dsb_sy>:

static inline void dsb_sy(void)
{
	__asm__ volatile ("dsb sy" : : : "memory");
    8800013c:	d5033f9f 	dsb	sy
}
    88000140:	d503201f 	nop
    88000144:	d65f03c0 	ret

0000000088000148 <isb>:

static inline void isb(void)
{
	__asm__ volatile ("isb" : : : "memory");
    88000148:	d5033fdf 	isb
}
    8800014c:	d503201f 	nop
    88000150:	d65f03c0 	ret

0000000088000154 <pl011_calc_baud>:

static void pl011_calc_baud(uint32_t uartclk_hz, uint32_t baud,
			    uint32_t *ibrd, uint32_t *fbrd)
{
    88000154:	d10103ff 	sub	sp, sp, #0x40
    88000158:	b9001fe0 	str	w0, [sp, #28]
    8800015c:	b9001be1 	str	w1, [sp, #24]
    88000160:	f9000be2 	str	x2, [sp, #16]
    88000164:	f90007e3 	str	x3, [sp, #8]
	uint64_t denom;
	uint64_t div;
	uint64_t rem;
	uint64_t frac64;

	if ((uartclk_hz == 0U) || (baud == 0U)) {
    88000168:	b9401fe0 	ldr	w0, [sp, #28]
    8800016c:	7100001f 	cmp	w0, #0x0
    88000170:	54000080 	b.eq	88000180 <pl011_calc_baud+0x2c>  // b.none
    88000174:	b9401be0 	ldr	w0, [sp, #24]
    88000178:	7100001f 	cmp	w0, #0x0
    8800017c:	540000e1 	b.ne	88000198 <pl011_calc_baud+0x44>  // b.any
		*ibrd = 1U;
    88000180:	f9400be0 	ldr	x0, [sp, #16]
    88000184:	52800021 	mov	w1, #0x1                   	// #1
    88000188:	b9000001 	str	w1, [x0]
		*fbrd = 0U;
    8800018c:	f94007e0 	ldr	x0, [sp, #8]
    88000190:	b900001f 	str	wzr, [x0]
		return;
    88000194:	14000029 	b	88000238 <pl011_calc_baud+0xe4>
	}

	denom = 16ULL * (uint64_t)baud;
    88000198:	b9401be0 	ldr	w0, [sp, #24]
    8800019c:	d37cec00 	lsl	x0, x0, #4
    880001a0:	f90017e0 	str	x0, [sp, #40]
	div = (uint64_t)uartclk_hz / denom;
    880001a4:	b9401fe1 	ldr	w1, [sp, #28]
    880001a8:	f94017e0 	ldr	x0, [sp, #40]
    880001ac:	9ac00820 	udiv	x0, x1, x0
    880001b0:	f9001fe0 	str	x0, [sp, #56]
	rem = (uint64_t)uartclk_hz % denom;
    880001b4:	b9401fe0 	ldr	w0, [sp, #28]
    880001b8:	f94017e1 	ldr	x1, [sp, #40]
    880001bc:	9ac10802 	udiv	x2, x0, x1
    880001c0:	f94017e1 	ldr	x1, [sp, #40]
    880001c4:	9b017c41 	mul	x1, x2, x1
    880001c8:	cb010000 	sub	x0, x0, x1
    880001cc:	f90013e0 	str	x0, [sp, #32]
	frac64 = (rem * 64ULL + denom / 2ULL) / denom;
    880001d0:	f94013e0 	ldr	x0, [sp, #32]
    880001d4:	d37ae401 	lsl	x1, x0, #6
    880001d8:	f94017e0 	ldr	x0, [sp, #40]
    880001dc:	d341fc00 	lsr	x0, x0, #1
    880001e0:	8b000021 	add	x1, x1, x0
    880001e4:	f94017e0 	ldr	x0, [sp, #40]
    880001e8:	9ac00820 	udiv	x0, x1, x0
    880001ec:	f9001be0 	str	x0, [sp, #48]

	if (div == 0U) {
    880001f0:	f9401fe0 	ldr	x0, [sp, #56]
    880001f4:	f100001f 	cmp	x0, #0x0
    880001f8:	54000061 	b.ne	88000204 <pl011_calc_baud+0xb0>  // b.any
		div = 1U;
    880001fc:	d2800020 	mov	x0, #0x1                   	// #1
    88000200:	f9001fe0 	str	x0, [sp, #56]
	}
	if (frac64 > 63U) {
    88000204:	f9401be0 	ldr	x0, [sp, #48]
    88000208:	f100fc1f 	cmp	x0, #0x3f
    8800020c:	54000069 	b.ls	88000218 <pl011_calc_baud+0xc4>  // b.plast
		frac64 = 63U;
    88000210:	d28007e0 	mov	x0, #0x3f                  	// #63
    88000214:	f9001be0 	str	x0, [sp, #48]
	}

	*ibrd = (uint32_t)div;
    88000218:	f9401fe0 	ldr	x0, [sp, #56]
    8800021c:	2a0003e1 	mov	w1, w0
    88000220:	f9400be0 	ldr	x0, [sp, #16]
    88000224:	b9000001 	str	w1, [x0]
	*fbrd = (uint32_t)frac64;
    88000228:	f9401be0 	ldr	x0, [sp, #48]
    8800022c:	2a0003e1 	mov	w1, w0
    88000230:	f94007e0 	ldr	x0, [sp, #8]
    88000234:	b9000001 	str	w1, [x0]
}
    88000238:	910103ff 	add	sp, sp, #0x40
    8800023c:	d65f03c0 	ret

0000000088000240 <uart_is_configured>:

bool uart_is_configured(void)
{
	return (plat_uart.base != 0UL) &&
    88000240:	90000000 	adrp	x0, 88000000 <_start>
    88000244:	91280000 	add	x0, x0, #0xa00
    88000248:	f9400000 	ldr	x0, [x0]
	       (plat_uart.clock_hz != 0U) &&
    8800024c:	f100001f 	cmp	x0, #0x0
    88000250:	540001a0 	b.eq	88000284 <uart_is_configured+0x44>  // b.none
    88000254:	90000000 	adrp	x0, 88000000 <_start>
    88000258:	91280000 	add	x0, x0, #0xa00
    8800025c:	b9400800 	ldr	w0, [x0, #8]
	return (plat_uart.base != 0UL) &&
    88000260:	7100001f 	cmp	w0, #0x0
    88000264:	54000100 	b.eq	88000284 <uart_is_configured+0x44>  // b.none
	       (plat_uart.baudrate != 0U);
    88000268:	90000000 	adrp	x0, 88000000 <_start>
    8800026c:	91280000 	add	x0, x0, #0xa00
    88000270:	b9400c00 	ldr	w0, [x0, #12]
	       (plat_uart.clock_hz != 0U) &&
    88000274:	7100001f 	cmp	w0, #0x0
    88000278:	54000060 	b.eq	88000284 <uart_is_configured+0x44>  // b.none
    8800027c:	52800020 	mov	w0, #0x1                   	// #1
    88000280:	14000002 	b	88000288 <uart_is_configured+0x48>
    88000284:	52800000 	mov	w0, #0x0                   	// #0
    88000288:	12000000 	and	w0, w0, #0x1
    8800028c:	12001c00 	and	w0, w0, #0xff
}
    88000290:	d65f03c0 	ret

0000000088000294 <uart_tx_ready>:

bool uart_tx_ready(void)
{
    88000294:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    88000298:	910003fd 	mov	x29, sp
	if (!uart_is_configured()) {
    8800029c:	97ffffe9 	bl	88000240 <uart_is_configured>
    880002a0:	12001c00 	and	w0, w0, #0xff
    880002a4:	52000000 	eor	w0, w0, #0x1
    880002a8:	12001c00 	and	w0, w0, #0xff
    880002ac:	12000000 	and	w0, w0, #0x1
    880002b0:	7100001f 	cmp	w0, #0x0
    880002b4:	54000060 	b.eq	880002c0 <uart_tx_ready+0x2c>  // b.none
		return false;
    880002b8:	52800000 	mov	w0, #0x0                   	// #0
    880002bc:	1400000a 	b	880002e4 <uart_tx_ready+0x50>
	}

	return (mmio_read_32(plat_uart.base + PL011_FR) & FR_TXFF) == 0U;
    880002c0:	90000000 	adrp	x0, 88000000 <_start>
    880002c4:	91280000 	add	x0, x0, #0xa00
    880002c8:	f9400000 	ldr	x0, [x0]
    880002cc:	91006000 	add	x0, x0, #0x18
    880002d0:	97ffff95 	bl	88000124 <mmio_read_32>
    880002d4:	121b0000 	and	w0, w0, #0x20
    880002d8:	7100001f 	cmp	w0, #0x0
    880002dc:	1a9f17e0 	cset	w0, eq	// eq = none
    880002e0:	12001c00 	and	w0, w0, #0xff
}
    880002e4:	a8c17bfd 	ldp	x29, x30, [sp], #16
    880002e8:	d65f03c0 	ret

00000000880002ec <uart_rx_ready>:

bool uart_rx_ready(void)
{
    880002ec:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    880002f0:	910003fd 	mov	x29, sp
	if (!uart_is_configured()) {
    880002f4:	97ffffd3 	bl	88000240 <uart_is_configured>
    880002f8:	12001c00 	and	w0, w0, #0xff
    880002fc:	52000000 	eor	w0, w0, #0x1
    88000300:	12001c00 	and	w0, w0, #0xff
    88000304:	12000000 	and	w0, w0, #0x1
    88000308:	7100001f 	cmp	w0, #0x0
    8800030c:	54000060 	b.eq	88000318 <uart_rx_ready+0x2c>  // b.none
		return false;
    88000310:	52800000 	mov	w0, #0x0                   	// #0
    88000314:	1400000a 	b	8800033c <uart_rx_ready+0x50>
	}

	return (mmio_read_32(plat_uart.base + PL011_FR) & FR_RXFE) == 0U;
    88000318:	90000000 	adrp	x0, 88000000 <_start>
    8800031c:	91280000 	add	x0, x0, #0xa00
    88000320:	f9400000 	ldr	x0, [x0]
    88000324:	91006000 	add	x0, x0, #0x18
    88000328:	97ffff7f 	bl	88000124 <mmio_read_32>
    8800032c:	121c0000 	and	w0, w0, #0x10
    88000330:	7100001f 	cmp	w0, #0x0
    88000334:	1a9f17e0 	cset	w0, eq	// eq = none
    88000338:	12001c00 	and	w0, w0, #0xff
}
    8800033c:	a8c17bfd 	ldp	x29, x30, [sp], #16
    88000340:	d65f03c0 	ret

0000000088000344 <uart_init>:

void uart_init(void)
{
    88000344:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    88000348:	910003fd 	mov	x29, sp
	uint32_t ibrd;
	uint32_t fbrd;

	if (!uart_is_configured()) {
    8800034c:	97ffffbd 	bl	88000240 <uart_is_configured>
    88000350:	12001c00 	and	w0, w0, #0xff
    88000354:	52000000 	eor	w0, w0, #0x1
    88000358:	12001c00 	and	w0, w0, #0xff
    8800035c:	12000000 	and	w0, w0, #0x1
    88000360:	7100001f 	cmp	w0, #0x0
    88000364:	540008c1 	b.ne	8800047c <uart_init+0x138>  // b.any
		return;
	}

	mmio_write_32(plat_uart.base + PL011_CR, 0U);
    88000368:	90000000 	adrp	x0, 88000000 <_start>
    8800036c:	91280000 	add	x0, x0, #0xa00
    88000370:	f9400000 	ldr	x0, [x0]
    88000374:	9100c000 	add	x0, x0, #0x30
    88000378:	52800001 	mov	w1, #0x0                   	// #0
    8800037c:	97ffff61 	bl	88000100 <mmio_write_32>
	dsb_sy();
    88000380:	97ffff6f 	bl	8800013c <dsb_sy>
	isb();
    88000384:	97ffff71 	bl	88000148 <isb>

	while ((mmio_read_32(plat_uart.base + PL011_FR) & FR_BUSY) != 0U) {
    88000388:	d503201f 	nop
    8800038c:	90000000 	adrp	x0, 88000000 <_start>
    88000390:	91280000 	add	x0, x0, #0xa00
    88000394:	f9400000 	ldr	x0, [x0]
    88000398:	91006000 	add	x0, x0, #0x18
    8800039c:	97ffff62 	bl	88000124 <mmio_read_32>
    880003a0:	121d0000 	and	w0, w0, #0x8
    880003a4:	7100001f 	cmp	w0, #0x0
    880003a8:	54ffff21 	b.ne	8800038c <uart_init+0x48>  // b.any
	}

	mmio_write_32(plat_uart.base + PL011_ICR, PL011_ICR_ALL);
    880003ac:	90000000 	adrp	x0, 88000000 <_start>
    880003b0:	91280000 	add	x0, x0, #0xa00
    880003b4:	f9400000 	ldr	x0, [x0]
    880003b8:	91011000 	add	x0, x0, #0x44
    880003bc:	5280ffe1 	mov	w1, #0x7ff                 	// #2047
    880003c0:	97ffff50 	bl	88000100 <mmio_write_32>
	mmio_write_32(plat_uart.base + PL011_IMSC, 0U);
    880003c4:	90000000 	adrp	x0, 88000000 <_start>
    880003c8:	91280000 	add	x0, x0, #0xa00
    880003cc:	f9400000 	ldr	x0, [x0]
    880003d0:	9100e000 	add	x0, x0, #0x38
    880003d4:	52800001 	mov	w1, #0x0                   	// #0
    880003d8:	97ffff4a 	bl	88000100 <mmio_write_32>

	pl011_calc_baud(plat_uart.clock_hz, plat_uart.baudrate, &ibrd, &fbrd);
    880003dc:	90000000 	adrp	x0, 88000000 <_start>
    880003e0:	91280000 	add	x0, x0, #0xa00
    880003e4:	b9400804 	ldr	w4, [x0, #8]
    880003e8:	90000000 	adrp	x0, 88000000 <_start>
    880003ec:	91280000 	add	x0, x0, #0xa00
    880003f0:	b9400c00 	ldr	w0, [x0, #12]
    880003f4:	910063e2 	add	x2, sp, #0x18
    880003f8:	910073e1 	add	x1, sp, #0x1c
    880003fc:	aa0203e3 	mov	x3, x2
    88000400:	aa0103e2 	mov	x2, x1
    88000404:	2a0003e1 	mov	w1, w0
    88000408:	2a0403e0 	mov	w0, w4
    8800040c:	97ffff52 	bl	88000154 <pl011_calc_baud>
	mmio_write_32(plat_uart.base + PL011_IBRD, ibrd);
    88000410:	90000000 	adrp	x0, 88000000 <_start>
    88000414:	91280000 	add	x0, x0, #0xa00
    88000418:	f9400000 	ldr	x0, [x0]
    8800041c:	91009000 	add	x0, x0, #0x24
    88000420:	b9401fe1 	ldr	w1, [sp, #28]
    88000424:	97ffff37 	bl	88000100 <mmio_write_32>
	mmio_write_32(plat_uart.base + PL011_FBRD, fbrd);
    88000428:	90000000 	adrp	x0, 88000000 <_start>
    8800042c:	91280000 	add	x0, x0, #0xa00
    88000430:	f9400000 	ldr	x0, [x0]
    88000434:	9100a000 	add	x0, x0, #0x28
    88000438:	b9401be1 	ldr	w1, [sp, #24]
    8800043c:	97ffff31 	bl	88000100 <mmio_write_32>
	mmio_write_32(plat_uart.base + PL011_LCRH, LCRH_WLEN_8 | LCRH_FEN);
    88000440:	90000000 	adrp	x0, 88000000 <_start>
    88000444:	91280000 	add	x0, x0, #0xa00
    88000448:	f9400000 	ldr	x0, [x0]
    8800044c:	9100b000 	add	x0, x0, #0x2c
    88000450:	52800e01 	mov	w1, #0x70                  	// #112
    88000454:	97ffff2b 	bl	88000100 <mmio_write_32>
	mmio_write_32(plat_uart.base + PL011_CR, CR_UARTEN | CR_TXE | CR_RXE);
    88000458:	90000000 	adrp	x0, 88000000 <_start>
    8800045c:	91280000 	add	x0, x0, #0xa00
    88000460:	f9400000 	ldr	x0, [x0]
    88000464:	9100c000 	add	x0, x0, #0x30
    88000468:	52806021 	mov	w1, #0x301                 	// #769
    8800046c:	97ffff25 	bl	88000100 <mmio_write_32>
	dsb_sy();
    88000470:	97ffff33 	bl	8800013c <dsb_sy>
	isb();
    88000474:	97ffff35 	bl	88000148 <isb>
    88000478:	14000002 	b	88000480 <uart_init+0x13c>
		return;
    8800047c:	d503201f 	nop
}
    88000480:	a8c27bfd 	ldp	x29, x30, [sp], #32
    88000484:	d65f03c0 	ret

0000000088000488 <uart_putc>:

void uart_putc(int ch)
{
    88000488:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    8800048c:	910003fd 	mov	x29, sp
    88000490:	b9001fe0 	str	w0, [sp, #28]
	if (!uart_is_configured()) {
    88000494:	97ffff6b 	bl	88000240 <uart_is_configured>
    88000498:	12001c00 	and	w0, w0, #0xff
    8800049c:	52000000 	eor	w0, w0, #0x1
    880004a0:	12001c00 	and	w0, w0, #0xff
    880004a4:	12000000 	and	w0, w0, #0x1
    880004a8:	7100001f 	cmp	w0, #0x0
    880004ac:	540001e1 	b.ne	880004e8 <uart_putc+0x60>  // b.any
		return;
	}

	while (!uart_tx_ready()) {
    880004b0:	d503201f 	nop
    880004b4:	97ffff78 	bl	88000294 <uart_tx_ready>
    880004b8:	12001c00 	and	w0, w0, #0xff
    880004bc:	52000000 	eor	w0, w0, #0x1
    880004c0:	12001c00 	and	w0, w0, #0xff
    880004c4:	12000000 	and	w0, w0, #0x1
    880004c8:	7100001f 	cmp	w0, #0x0
    880004cc:	54ffff41 	b.ne	880004b4 <uart_putc+0x2c>  // b.any
	}

	mmio_write_32(plat_uart.base + PL011_DR, (uint32_t)ch);
    880004d0:	90000000 	adrp	x0, 88000000 <_start>
    880004d4:	91280000 	add	x0, x0, #0xa00
    880004d8:	f9400000 	ldr	x0, [x0]
    880004dc:	b9401fe1 	ldr	w1, [sp, #28]
    880004e0:	97ffff08 	bl	88000100 <mmio_write_32>
    880004e4:	14000002 	b	880004ec <uart_putc+0x64>
		return;
    880004e8:	d503201f 	nop
}
    880004ec:	a8c27bfd 	ldp	x29, x30, [sp], #32
    880004f0:	d65f03c0 	ret

00000000880004f4 <uart_puts>:

void uart_puts(const char *str)
{
    880004f4:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    880004f8:	910003fd 	mov	x29, sp
    880004fc:	f9000fe0 	str	x0, [sp, #24]
	if (str == NULL) {
    88000500:	f9400fe0 	ldr	x0, [sp, #24]
    88000504:	f100001f 	cmp	x0, #0x0
    88000508:	54000240 	b.eq	88000550 <uart_puts+0x5c>  // b.none
		return;
	}

	while (*str != '\0') {
    8800050c:	1400000c 	b	8800053c <uart_puts+0x48>
		if (*str == '\n') {
    88000510:	f9400fe0 	ldr	x0, [sp, #24]
    88000514:	39400000 	ldrb	w0, [x0]
    88000518:	7100281f 	cmp	w0, #0xa
    8800051c:	54000061 	b.ne	88000528 <uart_puts+0x34>  // b.any
			uart_putc('\r');
    88000520:	528001a0 	mov	w0, #0xd                   	// #13
    88000524:	97ffffd9 	bl	88000488 <uart_putc>
		}

		uart_putc(*str++);
    88000528:	f9400fe0 	ldr	x0, [sp, #24]
    8800052c:	91000401 	add	x1, x0, #0x1
    88000530:	f9000fe1 	str	x1, [sp, #24]
    88000534:	39400000 	ldrb	w0, [x0]
    88000538:	97ffffd4 	bl	88000488 <uart_putc>
	while (*str != '\0') {
    8800053c:	f9400fe0 	ldr	x0, [sp, #24]
    88000540:	39400000 	ldrb	w0, [x0]
    88000544:	7100001f 	cmp	w0, #0x0
    88000548:	54fffe41 	b.ne	88000510 <uart_puts+0x1c>  // b.any
    8800054c:	14000002 	b	88000554 <uart_puts+0x60>
		return;
    88000550:	d503201f 	nop
	}
}
    88000554:	a8c27bfd 	ldp	x29, x30, [sp], #32
    88000558:	d65f03c0 	ret

000000008800055c <uart_write>:

void uart_write(const char *buf, size_t len)
{
    8800055c:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
    88000560:	910003fd 	mov	x29, sp
    88000564:	f9000fe0 	str	x0, [sp, #24]
    88000568:	f9000be1 	str	x1, [sp, #16]
	size_t i;

	if (buf == NULL) {
    8800056c:	f9400fe0 	ldr	x0, [sp, #24]
    88000570:	f100001f 	cmp	x0, #0x0
    88000574:	54000200 	b.eq	880005b4 <uart_write+0x58>  // b.none
		return;
	}

	for (i = 0; i < len; ++i) {
    88000578:	f90017ff 	str	xzr, [sp, #40]
    8800057c:	14000009 	b	880005a0 <uart_write+0x44>
		uart_putc((int)buf[i]);
    88000580:	f9400fe1 	ldr	x1, [sp, #24]
    88000584:	f94017e0 	ldr	x0, [sp, #40]
    88000588:	8b000020 	add	x0, x1, x0
    8800058c:	39400000 	ldrb	w0, [x0]
    88000590:	97ffffbe 	bl	88000488 <uart_putc>
	for (i = 0; i < len; ++i) {
    88000594:	f94017e0 	ldr	x0, [sp, #40]
    88000598:	91000400 	add	x0, x0, #0x1
    8800059c:	f90017e0 	str	x0, [sp, #40]
    880005a0:	f94017e1 	ldr	x1, [sp, #40]
    880005a4:	f9400be0 	ldr	x0, [sp, #16]
    880005a8:	eb00003f 	cmp	x1, x0
    880005ac:	54fffea3 	b.cc	88000580 <uart_write+0x24>  // b.lo, b.ul, b.last
    880005b0:	14000002 	b	880005b8 <uart_write+0x5c>
		return;
    880005b4:	d503201f 	nop
	}
}
    880005b8:	a8c37bfd 	ldp	x29, x30, [sp], #48
    880005bc:	d65f03c0 	ret

00000000880005c0 <uart_try_getc>:

int uart_try_getc(void)
{
    880005c0:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    880005c4:	910003fd 	mov	x29, sp
	if (!uart_rx_ready()) {
    880005c8:	97ffff49 	bl	880002ec <uart_rx_ready>
    880005cc:	12001c00 	and	w0, w0, #0xff
    880005d0:	52000000 	eor	w0, w0, #0x1
    880005d4:	12001c00 	and	w0, w0, #0xff
    880005d8:	12000000 	and	w0, w0, #0x1
    880005dc:	7100001f 	cmp	w0, #0x0
    880005e0:	54000060 	b.eq	880005ec <uart_try_getc+0x2c>  // b.none
		return -1;
    880005e4:	12800000 	mov	w0, #0xffffffff            	// #-1
    880005e8:	14000006 	b	88000600 <uart_try_getc+0x40>
	}

	return (int)(mmio_read_32(plat_uart.base + PL011_DR) & 0xFFU);
    880005ec:	90000000 	adrp	x0, 88000000 <_start>
    880005f0:	91280000 	add	x0, x0, #0xa00
    880005f4:	f9400000 	ldr	x0, [x0]
    880005f8:	97fffecb 	bl	88000124 <mmio_read_32>
    880005fc:	12001c00 	and	w0, w0, #0xff
}
    88000600:	a8c17bfd 	ldp	x29, x30, [sp], #16
    88000604:	d65f03c0 	ret

0000000088000608 <uart_getc>:

int uart_getc(void)
{
    88000608:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    8800060c:	910003fd 	mov	x29, sp
	int ch;

	if (!uart_is_configured()) {
    88000610:	97ffff0c 	bl	88000240 <uart_is_configured>
    88000614:	12001c00 	and	w0, w0, #0xff
    88000618:	52000000 	eor	w0, w0, #0x1
    8800061c:	12001c00 	and	w0, w0, #0xff
    88000620:	12000000 	and	w0, w0, #0x1
    88000624:	7100001f 	cmp	w0, #0x0
    88000628:	54000060 	b.eq	88000634 <uart_getc+0x2c>  // b.none
		return -1;
    8800062c:	12800000 	mov	w0, #0xffffffff            	// #-1
    88000630:	14000007 	b	8800064c <uart_getc+0x44>
	}

	do {
		ch = uart_try_getc();
    88000634:	97ffffe3 	bl	880005c0 <uart_try_getc>
    88000638:	b9001fe0 	str	w0, [sp, #28]
	} while (ch < 0);
    8800063c:	b9401fe0 	ldr	w0, [sp, #28]
    88000640:	7100001f 	cmp	w0, #0x0
    88000644:	54ffff8b 	b.lt	88000634 <uart_getc+0x2c>  // b.tstop

	return ch;
    88000648:	b9401fe0 	ldr	w0, [sp, #28]
}
    8800064c:	a8c27bfd 	ldp	x29, x30, [sp], #32
    88000650:	d65f03c0 	ret

0000000088000654 <uart_put_hex64>:

void uart_put_hex64(uint64_t value)
{
    88000654:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
    88000658:	910003fd 	mov	x29, sp
    8800065c:	f9000fe0 	str	x0, [sp, #24]
	static const char hex[] = "0123456789abcdef";
	int shift;

	for (shift = 60; shift >= 0; shift -= 4) {
    88000660:	52800780 	mov	w0, #0x3c                  	// #60
    88000664:	b9002fe0 	str	w0, [sp, #44]
    88000668:	1400000c 	b	88000698 <uart_put_hex64+0x44>
		uart_putc(hex[(value >> shift) & 0xFULL]);
    8800066c:	b9402fe0 	ldr	w0, [sp, #44]
    88000670:	f9400fe1 	ldr	x1, [sp, #24]
    88000674:	9ac02420 	lsr	x0, x1, x0
    88000678:	92400c00 	and	x0, x0, #0xf
    8800067c:	90000001 	adrp	x1, 88000000 <_start>
    88000680:	911fc021 	add	x1, x1, #0x7f0
    88000684:	38606820 	ldrb	w0, [x1, x0]
    88000688:	97ffff80 	bl	88000488 <uart_putc>
	for (shift = 60; shift >= 0; shift -= 4) {
    8800068c:	b9402fe0 	ldr	w0, [sp, #44]
    88000690:	51001000 	sub	w0, w0, #0x4
    88000694:	b9002fe0 	str	w0, [sp, #44]
    88000698:	b9402fe0 	ldr	w0, [sp, #44]
    8800069c:	7100001f 	cmp	w0, #0x0
    880006a0:	54fffe6a 	b.ge	8800066c <uart_put_hex64+0x18>  // b.tcont
	}
}
    880006a4:	d503201f 	nop
    880006a8:	d503201f 	nop
    880006ac:	a8c37bfd 	ldp	x29, x30, [sp], #48
    880006b0:	d65f03c0 	ret

00000000880006b4 <uart_flush>:

void uart_flush(void)
{
    880006b4:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    880006b8:	910003fd 	mov	x29, sp
	if (!uart_is_configured()) {
    880006bc:	97fffee1 	bl	88000240 <uart_is_configured>
    880006c0:	12001c00 	and	w0, w0, #0xff
    880006c4:	52000000 	eor	w0, w0, #0x1
    880006c8:	12001c00 	and	w0, w0, #0xff
    880006cc:	12000000 	and	w0, w0, #0x1
    880006d0:	7100001f 	cmp	w0, #0x0
    880006d4:	54000161 	b.ne	88000700 <uart_flush+0x4c>  // b.any
		return;
	}

	while ((mmio_read_32(plat_uart.base + PL011_FR) & FR_BUSY) != 0U) {
    880006d8:	d503201f 	nop
    880006dc:	90000000 	adrp	x0, 88000000 <_start>
    880006e0:	91280000 	add	x0, x0, #0xa00
    880006e4:	f9400000 	ldr	x0, [x0]
    880006e8:	91006000 	add	x0, x0, #0x18
    880006ec:	97fffe8e 	bl	88000124 <mmio_read_32>
    880006f0:	121d0000 	and	w0, w0, #0x8
    880006f4:	7100001f 	cmp	w0, #0x0
    880006f8:	54ffff21 	b.ne	880006dc <uart_flush+0x28>  // b.any
    880006fc:	14000002 	b	88000704 <uart_flush+0x50>
		return;
    88000700:	d503201f 	nop
	}
    88000704:	a8c17bfd 	ldp	x29, x30, [sp], #16
    88000708:	d65f03c0 	ret

000000008800070c <print_mini_os_banner>:
//     debug_puts("============================================================\n");
// 	debug_puts("2026-03-21 V0.1\n");
//     debug_puts("\n");
// }
static void print_mini_os_banner(void)
{
    8800070c:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    88000710:	910003fd 	mov	x29, sp
    debug_puts("\n");
    88000714:	90000000 	adrp	x0, 88000000 <_start>
    88000718:	91202000 	add	x0, x0, #0x808
    8800071c:	97fffe4f 	bl	88000058 <debug_puts>
    debug_puts("============================================================\n");
    88000720:	90000000 	adrp	x0, 88000000 <_start>
    88000724:	91204000 	add	x0, x0, #0x810
    88000728:	97fffe4c 	bl	88000058 <debug_puts>
    debug_puts("            __  __   ___   _   _   ___    ___    ____      \n");
    8800072c:	90000000 	adrp	x0, 88000000 <_start>
    88000730:	91214000 	add	x0, x0, #0x850
    88000734:	97fffe49 	bl	88000058 <debug_puts>
    debug_puts("           |  \\/  | |_ _| | \\ | | |_ _|  / _ \\  / ___|     \n");
    88000738:	90000000 	adrp	x0, 88000000 <_start>
    8800073c:	91224000 	add	x0, x0, #0x890
    88000740:	97fffe46 	bl	88000058 <debug_puts>
    debug_puts("           | |\\/| |  | |  |  \\| |  | |  | | | | \\___ \\     \n");
    88000744:	90000000 	adrp	x0, 88000000 <_start>
    88000748:	91234000 	add	x0, x0, #0x8d0
    8800074c:	97fffe43 	bl	88000058 <debug_puts>
    debug_puts("           | |  | |  | |  | |\\  |  | |  | |_| |  ___) |    \n");
    88000750:	90000000 	adrp	x0, 88000000 <_start>
    88000754:	91244000 	add	x0, x0, #0x910
    88000758:	97fffe40 	bl	88000058 <debug_puts>
    debug_puts("           |_|  |_| |___| |_| \\_| |___|  \\___/  |____/     \n");
    8800075c:	90000000 	adrp	x0, 88000000 <_start>
    88000760:	91254000 	add	x0, x0, #0x950
    88000764:	97fffe3d 	bl	88000058 <debug_puts>
    debug_puts("============================================================\n");
    88000768:	90000000 	adrp	x0, 88000000 <_start>
    8800076c:	91204000 	add	x0, x0, #0x810
    88000770:	97fffe3a 	bl	88000058 <debug_puts>
    debug_puts("                     Felix Mini-OS  V0.1                    \n");
    88000774:	90000000 	adrp	x0, 88000000 <_start>
    88000778:	91264000 	add	x0, x0, #0x990
    8800077c:	97fffe37 	bl	88000058 <debug_puts>
    debug_puts("============================================================\n");
    88000780:	90000000 	adrp	x0, 88000000 <_start>
    88000784:	91204000 	add	x0, x0, #0x810
    88000788:	97fffe34 	bl	88000058 <debug_puts>
    debug_puts("\n");
    8800078c:	90000000 	adrp	x0, 88000000 <_start>
    88000790:	91202000 	add	x0, x0, #0x808
    88000794:	97fffe31 	bl	88000058 <debug_puts>
}
    88000798:	d503201f 	nop
    8800079c:	a8c17bfd 	ldp	x29, x30, [sp], #16
    880007a0:	d65f03c0 	ret

00000000880007a4 <kernel_main>:

void kernel_main(void)
{
    880007a4:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    880007a8:	910003fd 	mov	x29, sp
	print_mini_os_banner();
    880007ac:	97ffffd8 	bl	8800070c <print_mini_os_banner>
	debug_console_init();
    880007b0:	97fffe1c 	bl	88000020 <debug_console_init>
	debug_puts("mini-os: kernel_main entered, load_addr=0x");
    880007b4:	90000000 	adrp	x0, 88000000 <_start>
    880007b8:	91274000 	add	x0, x0, #0x9d0
    880007bc:	97fffe27 	bl	88000058 <debug_puts>
	debug_put_hex64(boot_magic);
    880007c0:	90000000 	adrp	x0, 88000000 <_start>
    880007c4:	91284000 	add	x0, x0, #0xa10
    880007c8:	f9400000 	ldr	x0, [x0]
    880007cc:	97fffe3f 	bl	880000c8 <debug_put_hex64>
	debug_puts("\n");
    880007d0:	90000000 	adrp	x0, 88000000 <_start>
    880007d4:	91202000 	add	x0, x0, #0x808
    880007d8:	97fffe20 	bl	88000058 <debug_puts>
	debug_flush();
    880007dc:	97fffe43 	bl	880000e8 <debug_flush>

	for (;;) {
		__asm__ volatile ("wfe");
    880007e0:	d503205f 	wfe
    880007e4:	17ffffff 	b	880007e0 <kernel_main+0x3c>
