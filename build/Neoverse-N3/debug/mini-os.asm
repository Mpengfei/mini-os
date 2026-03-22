
/home/pengfei/felix-os/mini-os/build/Neoverse-N3/debug/mini-os.elf:     file format elf64-littleaarch64


Disassembly of section .text:

00000000c0000000 <_start>:
    c0000000:	580000c0 	ldr	x0, c0000018 <_start+0x18>
    c0000004:	9100001f 	mov	sp, x0
    c0000008:	94000978 	bl	c00025e8 <kernel_main>
    c000000c:	d503205f 	wfe
    c0000010:	17ffffff 	b	c000000c <_start+0xc>
    c0000014:	00000000 	udf	#0
    c0000018:	c002b5e0 	.word	0xc002b5e0
    c000001c:	00000000 	.word	0x00000000

00000000c0000020 <secondary_cpu_entrypoint>:
    c0000020:	58000101 	ldr	x1, c0000040 <secondary_cpu_entrypoint+0x20>
    c0000024:	58000122 	ldr	x2, c0000048 <secondary_cpu_entrypoint+0x28>
    c0000028:	9b020401 	madd	x1, x0, x2, x1
    c000002c:	8b020021 	add	x1, x1, x2
    c0000030:	9100003f 	mov	sp, x1
    c0000034:	940015b6 	bl	c000570c <smp_secondary_entry>
    c0000038:	d503205f 	wfe
    c000003c:	17ffffff 	b	c0000038 <secondary_cpu_entrypoint+0x18>
    c0000040:	c0007410 	.word	0xc0007410
    c0000044:	00000000 	.word	0x00000000
    c0000048:	00001000 	.word	0x00001000
    c000004c:	00000000 	.word	0x00000000

00000000c0000050 <debug_raw_putc>:
};

static struct spinlock debug_console_lock = SPINLOCK_INIT;

static void debug_raw_putc(int ch)
{
    c0000050:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c0000054:	910003fd 	mov	x29, sp
    c0000058:	b9001fe0 	str	w0, [sp, #28]
	uart_putc(ch);
    c000005c:	b9401fe0 	ldr	w0, [sp, #28]
    c0000060:	94000883 	bl	c000226c <uart_putc>
}
    c0000064:	d503201f 	nop
    c0000068:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c000006c:	d65f03c0 	ret

00000000c0000070 <print_char>:

static void print_char(struct print_ctx *ctx, char ch)
{
    c0000070:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c0000074:	910003fd 	mov	x29, sp
    c0000078:	f9000fe0 	str	x0, [sp, #24]
    c000007c:	39005fe1 	strb	w1, [sp, #23]
	if (ch == '\n') {
    c0000080:	39405fe0 	ldrb	w0, [sp, #23]
    c0000084:	7100281f 	cmp	w0, #0xa
    c0000088:	54000061 	b.ne	c0000094 <print_char+0x24>  // b.any
		debug_raw_putc('\r');
    c000008c:	528001a0 	mov	w0, #0xd                   	// #13
    c0000090:	97fffff0 	bl	c0000050 <debug_raw_putc>
	}

	debug_raw_putc((int)ch);
    c0000094:	39405fe0 	ldrb	w0, [sp, #23]
    c0000098:	97ffffee 	bl	c0000050 <debug_raw_putc>
	ctx->count++;
    c000009c:	f9400fe0 	ldr	x0, [sp, #24]
    c00000a0:	b9400000 	ldr	w0, [x0]
    c00000a4:	11000401 	add	w1, w0, #0x1
    c00000a8:	f9400fe0 	ldr	x0, [sp, #24]
    c00000ac:	b9000001 	str	w1, [x0]
}
    c00000b0:	d503201f 	nop
    c00000b4:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c00000b8:	d65f03c0 	ret

00000000c00000bc <print_repeat>:

static void print_repeat(struct print_ctx *ctx, char ch, int count)
{
    c00000bc:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c00000c0:	910003fd 	mov	x29, sp
    c00000c4:	f9000fe0 	str	x0, [sp, #24]
    c00000c8:	39005fe1 	strb	w1, [sp, #23]
    c00000cc:	b90013e2 	str	w2, [sp, #16]
	while (count-- > 0) {
    c00000d0:	14000004 	b	c00000e0 <print_repeat+0x24>
		print_char(ctx, ch);
    c00000d4:	39405fe1 	ldrb	w1, [sp, #23]
    c00000d8:	f9400fe0 	ldr	x0, [sp, #24]
    c00000dc:	97ffffe5 	bl	c0000070 <print_char>
	while (count-- > 0) {
    c00000e0:	b94013e0 	ldr	w0, [sp, #16]
    c00000e4:	51000401 	sub	w1, w0, #0x1
    c00000e8:	b90013e1 	str	w1, [sp, #16]
    c00000ec:	7100001f 	cmp	w0, #0x0
    c00000f0:	54ffff2c 	b.gt	c00000d4 <print_repeat+0x18>
	}
}
    c00000f4:	d503201f 	nop
    c00000f8:	d503201f 	nop
    c00000fc:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c0000100:	d65f03c0 	ret

00000000c0000104 <str_length>:

static size_t str_length(const char *str)
{
    c0000104:	d10083ff 	sub	sp, sp, #0x20
    c0000108:	f90007e0 	str	x0, [sp, #8]
	size_t len = 0U;
    c000010c:	f9000fff 	str	xzr, [sp, #24]

	while (str[len] != '\0') {
    c0000110:	14000004 	b	c0000120 <str_length+0x1c>
		len++;
    c0000114:	f9400fe0 	ldr	x0, [sp, #24]
    c0000118:	91000400 	add	x0, x0, #0x1
    c000011c:	f9000fe0 	str	x0, [sp, #24]
	while (str[len] != '\0') {
    c0000120:	f94007e1 	ldr	x1, [sp, #8]
    c0000124:	f9400fe0 	ldr	x0, [sp, #24]
    c0000128:	8b000020 	add	x0, x1, x0
    c000012c:	39400000 	ldrb	w0, [x0]
    c0000130:	7100001f 	cmp	w0, #0x0
    c0000134:	54ffff01 	b.ne	c0000114 <str_length+0x10>  // b.any
	}

	return len;
    c0000138:	f9400fe0 	ldr	x0, [sp, #24]
}
    c000013c:	910083ff 	add	sp, sp, #0x20
    c0000140:	d65f03c0 	ret

00000000c0000144 <get_unsigned_arg>:

static uint64_t get_unsigned_arg(va_list *args, int length)
{
    c0000144:	d10043ff 	sub	sp, sp, #0x10
    c0000148:	f90007e0 	str	x0, [sp, #8]
    c000014c:	b90007e1 	str	w1, [sp, #4]
	switch (length) {
    c0000150:	b94007e0 	ldr	w0, [sp, #4]
    c0000154:	71001c1f 	cmp	w0, #0x7
    c0000158:	54001aa0 	b.eq	c00004ac <get_unsigned_arg+0x368>  // b.none
    c000015c:	b94007e0 	ldr	w0, [sp, #4]
    c0000160:	71001c1f 	cmp	w0, #0x7
    c0000164:	54001dec 	b.gt	c0000520 <get_unsigned_arg+0x3dc>
    c0000168:	b94007e0 	ldr	w0, [sp, #4]
    c000016c:	7100181f 	cmp	w0, #0x6
    c0000170:	54001640 	b.eq	c0000438 <get_unsigned_arg+0x2f4>  // b.none
    c0000174:	b94007e0 	ldr	w0, [sp, #4]
    c0000178:	7100181f 	cmp	w0, #0x6
    c000017c:	54001d2c 	b.gt	c0000520 <get_unsigned_arg+0x3dc>
    c0000180:	b94007e0 	ldr	w0, [sp, #4]
    c0000184:	7100141f 	cmp	w0, #0x5
    c0000188:	540011e0 	b.eq	c00003c4 <get_unsigned_arg+0x280>  // b.none
    c000018c:	b94007e0 	ldr	w0, [sp, #4]
    c0000190:	7100141f 	cmp	w0, #0x5
    c0000194:	54001c6c 	b.gt	c0000520 <get_unsigned_arg+0x3dc>
    c0000198:	b94007e0 	ldr	w0, [sp, #4]
    c000019c:	7100101f 	cmp	w0, #0x4
    c00001a0:	54000d80 	b.eq	c0000350 <get_unsigned_arg+0x20c>  // b.none
    c00001a4:	b94007e0 	ldr	w0, [sp, #4]
    c00001a8:	7100101f 	cmp	w0, #0x4
    c00001ac:	54001bac 	b.gt	c0000520 <get_unsigned_arg+0x3dc>
    c00001b0:	b94007e0 	ldr	w0, [sp, #4]
    c00001b4:	71000c1f 	cmp	w0, #0x3
    c00001b8:	54000920 	b.eq	c00002dc <get_unsigned_arg+0x198>  // b.none
    c00001bc:	b94007e0 	ldr	w0, [sp, #4]
    c00001c0:	71000c1f 	cmp	w0, #0x3
    c00001c4:	54001aec 	b.gt	c0000520 <get_unsigned_arg+0x3dc>
    c00001c8:	b94007e0 	ldr	w0, [sp, #4]
    c00001cc:	7100041f 	cmp	w0, #0x1
    c00001d0:	540000a0 	b.eq	c00001e4 <get_unsigned_arg+0xa0>  // b.none
    c00001d4:	b94007e0 	ldr	w0, [sp, #4]
    c00001d8:	7100081f 	cmp	w0, #0x2
    c00001dc:	54000420 	b.eq	c0000260 <get_unsigned_arg+0x11c>  // b.none
    c00001e0:	140000d0 	b	c0000520 <get_unsigned_arg+0x3dc>
	case LENGTH_HH:
		return (uint64_t)(unsigned char)va_arg(*args, unsigned int);
    c00001e4:	f94007e0 	ldr	x0, [sp, #8]
    c00001e8:	b9401801 	ldr	w1, [x0, #24]
    c00001ec:	f94007e0 	ldr	x0, [sp, #8]
    c00001f0:	f9400000 	ldr	x0, [x0]
    c00001f4:	7100003f 	cmp	w1, #0x0
    c00001f8:	540000cb 	b.lt	c0000210 <get_unsigned_arg+0xcc>  // b.tstop
    c00001fc:	91002c01 	add	x1, x0, #0xb
    c0000200:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c0000204:	f94007e1 	ldr	x1, [sp, #8]
    c0000208:	f9000022 	str	x2, [x1]
    c000020c:	14000011 	b	c0000250 <get_unsigned_arg+0x10c>
    c0000210:	11002023 	add	w3, w1, #0x8
    c0000214:	f94007e2 	ldr	x2, [sp, #8]
    c0000218:	b9001843 	str	w3, [x2, #24]
    c000021c:	f94007e2 	ldr	x2, [sp, #8]
    c0000220:	b9401842 	ldr	w2, [x2, #24]
    c0000224:	7100005f 	cmp	w2, #0x0
    c0000228:	540000cd 	b.le	c0000240 <get_unsigned_arg+0xfc>
    c000022c:	91002c01 	add	x1, x0, #0xb
    c0000230:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c0000234:	f94007e1 	ldr	x1, [sp, #8]
    c0000238:	f9000022 	str	x2, [x1]
    c000023c:	14000005 	b	c0000250 <get_unsigned_arg+0x10c>
    c0000240:	f94007e0 	ldr	x0, [sp, #8]
    c0000244:	f9400402 	ldr	x2, [x0, #8]
    c0000248:	93407c20 	sxtw	x0, w1
    c000024c:	8b000040 	add	x0, x2, x0
    c0000250:	b9400000 	ldr	w0, [x0]
    c0000254:	12001c00 	and	w0, w0, #0xff
    c0000258:	92401c00 	and	x0, x0, #0xff
    c000025c:	140000ce 	b	c0000594 <get_unsigned_arg+0x450>
	case LENGTH_H:
		return (uint64_t)(unsigned short)va_arg(*args, unsigned int);
    c0000260:	f94007e0 	ldr	x0, [sp, #8]
    c0000264:	b9401801 	ldr	w1, [x0, #24]
    c0000268:	f94007e0 	ldr	x0, [sp, #8]
    c000026c:	f9400000 	ldr	x0, [x0]
    c0000270:	7100003f 	cmp	w1, #0x0
    c0000274:	540000cb 	b.lt	c000028c <get_unsigned_arg+0x148>  // b.tstop
    c0000278:	91002c01 	add	x1, x0, #0xb
    c000027c:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c0000280:	f94007e1 	ldr	x1, [sp, #8]
    c0000284:	f9000022 	str	x2, [x1]
    c0000288:	14000011 	b	c00002cc <get_unsigned_arg+0x188>
    c000028c:	11002023 	add	w3, w1, #0x8
    c0000290:	f94007e2 	ldr	x2, [sp, #8]
    c0000294:	b9001843 	str	w3, [x2, #24]
    c0000298:	f94007e2 	ldr	x2, [sp, #8]
    c000029c:	b9401842 	ldr	w2, [x2, #24]
    c00002a0:	7100005f 	cmp	w2, #0x0
    c00002a4:	540000cd 	b.le	c00002bc <get_unsigned_arg+0x178>
    c00002a8:	91002c01 	add	x1, x0, #0xb
    c00002ac:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c00002b0:	f94007e1 	ldr	x1, [sp, #8]
    c00002b4:	f9000022 	str	x2, [x1]
    c00002b8:	14000005 	b	c00002cc <get_unsigned_arg+0x188>
    c00002bc:	f94007e0 	ldr	x0, [sp, #8]
    c00002c0:	f9400402 	ldr	x2, [x0, #8]
    c00002c4:	93407c20 	sxtw	x0, w1
    c00002c8:	8b000040 	add	x0, x2, x0
    c00002cc:	b9400000 	ldr	w0, [x0]
    c00002d0:	12003c00 	and	w0, w0, #0xffff
    c00002d4:	92403c00 	and	x0, x0, #0xffff
    c00002d8:	140000af 	b	c0000594 <get_unsigned_arg+0x450>
	case LENGTH_L:
		return (uint64_t)va_arg(*args, unsigned long);
    c00002dc:	f94007e0 	ldr	x0, [sp, #8]
    c00002e0:	b9401801 	ldr	w1, [x0, #24]
    c00002e4:	f94007e0 	ldr	x0, [sp, #8]
    c00002e8:	f9400000 	ldr	x0, [x0]
    c00002ec:	7100003f 	cmp	w1, #0x0
    c00002f0:	540000cb 	b.lt	c0000308 <get_unsigned_arg+0x1c4>  // b.tstop
    c00002f4:	91003c01 	add	x1, x0, #0xf
    c00002f8:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c00002fc:	f94007e1 	ldr	x1, [sp, #8]
    c0000300:	f9000022 	str	x2, [x1]
    c0000304:	14000011 	b	c0000348 <get_unsigned_arg+0x204>
    c0000308:	11002023 	add	w3, w1, #0x8
    c000030c:	f94007e2 	ldr	x2, [sp, #8]
    c0000310:	b9001843 	str	w3, [x2, #24]
    c0000314:	f94007e2 	ldr	x2, [sp, #8]
    c0000318:	b9401842 	ldr	w2, [x2, #24]
    c000031c:	7100005f 	cmp	w2, #0x0
    c0000320:	540000cd 	b.le	c0000338 <get_unsigned_arg+0x1f4>
    c0000324:	91003c01 	add	x1, x0, #0xf
    c0000328:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c000032c:	f94007e1 	ldr	x1, [sp, #8]
    c0000330:	f9000022 	str	x2, [x1]
    c0000334:	14000005 	b	c0000348 <get_unsigned_arg+0x204>
    c0000338:	f94007e0 	ldr	x0, [sp, #8]
    c000033c:	f9400402 	ldr	x2, [x0, #8]
    c0000340:	93407c20 	sxtw	x0, w1
    c0000344:	8b000040 	add	x0, x2, x0
    c0000348:	f9400000 	ldr	x0, [x0]
    c000034c:	14000092 	b	c0000594 <get_unsigned_arg+0x450>
	case LENGTH_LL:
		return (uint64_t)va_arg(*args, unsigned long long);
    c0000350:	f94007e0 	ldr	x0, [sp, #8]
    c0000354:	b9401801 	ldr	w1, [x0, #24]
    c0000358:	f94007e0 	ldr	x0, [sp, #8]
    c000035c:	f9400000 	ldr	x0, [x0]
    c0000360:	7100003f 	cmp	w1, #0x0
    c0000364:	540000cb 	b.lt	c000037c <get_unsigned_arg+0x238>  // b.tstop
    c0000368:	91003c01 	add	x1, x0, #0xf
    c000036c:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c0000370:	f94007e1 	ldr	x1, [sp, #8]
    c0000374:	f9000022 	str	x2, [x1]
    c0000378:	14000011 	b	c00003bc <get_unsigned_arg+0x278>
    c000037c:	11002023 	add	w3, w1, #0x8
    c0000380:	f94007e2 	ldr	x2, [sp, #8]
    c0000384:	b9001843 	str	w3, [x2, #24]
    c0000388:	f94007e2 	ldr	x2, [sp, #8]
    c000038c:	b9401842 	ldr	w2, [x2, #24]
    c0000390:	7100005f 	cmp	w2, #0x0
    c0000394:	540000cd 	b.le	c00003ac <get_unsigned_arg+0x268>
    c0000398:	91003c01 	add	x1, x0, #0xf
    c000039c:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c00003a0:	f94007e1 	ldr	x1, [sp, #8]
    c00003a4:	f9000022 	str	x2, [x1]
    c00003a8:	14000005 	b	c00003bc <get_unsigned_arg+0x278>
    c00003ac:	f94007e0 	ldr	x0, [sp, #8]
    c00003b0:	f9400402 	ldr	x2, [x0, #8]
    c00003b4:	93407c20 	sxtw	x0, w1
    c00003b8:	8b000040 	add	x0, x2, x0
    c00003bc:	f9400000 	ldr	x0, [x0]
    c00003c0:	14000075 	b	c0000594 <get_unsigned_arg+0x450>
	case LENGTH_Z:
		return (uint64_t)va_arg(*args, size_t);
    c00003c4:	f94007e0 	ldr	x0, [sp, #8]
    c00003c8:	b9401801 	ldr	w1, [x0, #24]
    c00003cc:	f94007e0 	ldr	x0, [sp, #8]
    c00003d0:	f9400000 	ldr	x0, [x0]
    c00003d4:	7100003f 	cmp	w1, #0x0
    c00003d8:	540000cb 	b.lt	c00003f0 <get_unsigned_arg+0x2ac>  // b.tstop
    c00003dc:	91003c01 	add	x1, x0, #0xf
    c00003e0:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c00003e4:	f94007e1 	ldr	x1, [sp, #8]
    c00003e8:	f9000022 	str	x2, [x1]
    c00003ec:	14000011 	b	c0000430 <get_unsigned_arg+0x2ec>
    c00003f0:	11002023 	add	w3, w1, #0x8
    c00003f4:	f94007e2 	ldr	x2, [sp, #8]
    c00003f8:	b9001843 	str	w3, [x2, #24]
    c00003fc:	f94007e2 	ldr	x2, [sp, #8]
    c0000400:	b9401842 	ldr	w2, [x2, #24]
    c0000404:	7100005f 	cmp	w2, #0x0
    c0000408:	540000cd 	b.le	c0000420 <get_unsigned_arg+0x2dc>
    c000040c:	91003c01 	add	x1, x0, #0xf
    c0000410:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c0000414:	f94007e1 	ldr	x1, [sp, #8]
    c0000418:	f9000022 	str	x2, [x1]
    c000041c:	14000005 	b	c0000430 <get_unsigned_arg+0x2ec>
    c0000420:	f94007e0 	ldr	x0, [sp, #8]
    c0000424:	f9400402 	ldr	x2, [x0, #8]
    c0000428:	93407c20 	sxtw	x0, w1
    c000042c:	8b000040 	add	x0, x2, x0
    c0000430:	f9400000 	ldr	x0, [x0]
    c0000434:	14000058 	b	c0000594 <get_unsigned_arg+0x450>
	case LENGTH_T:
		return (uint64_t)va_arg(*args, ptrdiff_t);
    c0000438:	f94007e0 	ldr	x0, [sp, #8]
    c000043c:	b9401801 	ldr	w1, [x0, #24]
    c0000440:	f94007e0 	ldr	x0, [sp, #8]
    c0000444:	f9400000 	ldr	x0, [x0]
    c0000448:	7100003f 	cmp	w1, #0x0
    c000044c:	540000cb 	b.lt	c0000464 <get_unsigned_arg+0x320>  // b.tstop
    c0000450:	91003c01 	add	x1, x0, #0xf
    c0000454:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c0000458:	f94007e1 	ldr	x1, [sp, #8]
    c000045c:	f9000022 	str	x2, [x1]
    c0000460:	14000011 	b	c00004a4 <get_unsigned_arg+0x360>
    c0000464:	11002023 	add	w3, w1, #0x8
    c0000468:	f94007e2 	ldr	x2, [sp, #8]
    c000046c:	b9001843 	str	w3, [x2, #24]
    c0000470:	f94007e2 	ldr	x2, [sp, #8]
    c0000474:	b9401842 	ldr	w2, [x2, #24]
    c0000478:	7100005f 	cmp	w2, #0x0
    c000047c:	540000cd 	b.le	c0000494 <get_unsigned_arg+0x350>
    c0000480:	91003c01 	add	x1, x0, #0xf
    c0000484:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c0000488:	f94007e1 	ldr	x1, [sp, #8]
    c000048c:	f9000022 	str	x2, [x1]
    c0000490:	14000005 	b	c00004a4 <get_unsigned_arg+0x360>
    c0000494:	f94007e0 	ldr	x0, [sp, #8]
    c0000498:	f9400402 	ldr	x2, [x0, #8]
    c000049c:	93407c20 	sxtw	x0, w1
    c00004a0:	8b000040 	add	x0, x2, x0
    c00004a4:	f9400000 	ldr	x0, [x0]
    c00004a8:	1400003b 	b	c0000594 <get_unsigned_arg+0x450>
	case LENGTH_J:
		return (uint64_t)va_arg(*args, uintmax_t);
    c00004ac:	f94007e0 	ldr	x0, [sp, #8]
    c00004b0:	b9401801 	ldr	w1, [x0, #24]
    c00004b4:	f94007e0 	ldr	x0, [sp, #8]
    c00004b8:	f9400000 	ldr	x0, [x0]
    c00004bc:	7100003f 	cmp	w1, #0x0
    c00004c0:	540000cb 	b.lt	c00004d8 <get_unsigned_arg+0x394>  // b.tstop
    c00004c4:	91003c01 	add	x1, x0, #0xf
    c00004c8:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c00004cc:	f94007e1 	ldr	x1, [sp, #8]
    c00004d0:	f9000022 	str	x2, [x1]
    c00004d4:	14000011 	b	c0000518 <get_unsigned_arg+0x3d4>
    c00004d8:	11002023 	add	w3, w1, #0x8
    c00004dc:	f94007e2 	ldr	x2, [sp, #8]
    c00004e0:	b9001843 	str	w3, [x2, #24]
    c00004e4:	f94007e2 	ldr	x2, [sp, #8]
    c00004e8:	b9401842 	ldr	w2, [x2, #24]
    c00004ec:	7100005f 	cmp	w2, #0x0
    c00004f0:	540000cd 	b.le	c0000508 <get_unsigned_arg+0x3c4>
    c00004f4:	91003c01 	add	x1, x0, #0xf
    c00004f8:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c00004fc:	f94007e1 	ldr	x1, [sp, #8]
    c0000500:	f9000022 	str	x2, [x1]
    c0000504:	14000005 	b	c0000518 <get_unsigned_arg+0x3d4>
    c0000508:	f94007e0 	ldr	x0, [sp, #8]
    c000050c:	f9400402 	ldr	x2, [x0, #8]
    c0000510:	93407c20 	sxtw	x0, w1
    c0000514:	8b000040 	add	x0, x2, x0
    c0000518:	f9400000 	ldr	x0, [x0]
    c000051c:	1400001e 	b	c0000594 <get_unsigned_arg+0x450>
	default:
		return (uint64_t)va_arg(*args, unsigned int);
    c0000520:	f94007e0 	ldr	x0, [sp, #8]
    c0000524:	b9401801 	ldr	w1, [x0, #24]
    c0000528:	f94007e0 	ldr	x0, [sp, #8]
    c000052c:	f9400000 	ldr	x0, [x0]
    c0000530:	7100003f 	cmp	w1, #0x0
    c0000534:	540000cb 	b.lt	c000054c <get_unsigned_arg+0x408>  // b.tstop
    c0000538:	91002c01 	add	x1, x0, #0xb
    c000053c:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c0000540:	f94007e1 	ldr	x1, [sp, #8]
    c0000544:	f9000022 	str	x2, [x1]
    c0000548:	14000011 	b	c000058c <get_unsigned_arg+0x448>
    c000054c:	11002023 	add	w3, w1, #0x8
    c0000550:	f94007e2 	ldr	x2, [sp, #8]
    c0000554:	b9001843 	str	w3, [x2, #24]
    c0000558:	f94007e2 	ldr	x2, [sp, #8]
    c000055c:	b9401842 	ldr	w2, [x2, #24]
    c0000560:	7100005f 	cmp	w2, #0x0
    c0000564:	540000cd 	b.le	c000057c <get_unsigned_arg+0x438>
    c0000568:	91002c01 	add	x1, x0, #0xb
    c000056c:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c0000570:	f94007e1 	ldr	x1, [sp, #8]
    c0000574:	f9000022 	str	x2, [x1]
    c0000578:	14000005 	b	c000058c <get_unsigned_arg+0x448>
    c000057c:	f94007e0 	ldr	x0, [sp, #8]
    c0000580:	f9400402 	ldr	x2, [x0, #8]
    c0000584:	93407c20 	sxtw	x0, w1
    c0000588:	8b000040 	add	x0, x2, x0
    c000058c:	b9400000 	ldr	w0, [x0]
    c0000590:	2a0003e0 	mov	w0, w0
	}
}
    c0000594:	910043ff 	add	sp, sp, #0x10
    c0000598:	d65f03c0 	ret

00000000c000059c <get_signed_arg>:

static int64_t get_signed_arg(va_list *args, int length)
{
    c000059c:	d10043ff 	sub	sp, sp, #0x10
    c00005a0:	f90007e0 	str	x0, [sp, #8]
    c00005a4:	b90007e1 	str	w1, [sp, #4]
	switch (length) {
    c00005a8:	b94007e0 	ldr	w0, [sp, #4]
    c00005ac:	71001c1f 	cmp	w0, #0x7
    c00005b0:	54001aa0 	b.eq	c0000904 <get_signed_arg+0x368>  // b.none
    c00005b4:	b94007e0 	ldr	w0, [sp, #4]
    c00005b8:	71001c1f 	cmp	w0, #0x7
    c00005bc:	54001dec 	b.gt	c0000978 <get_signed_arg+0x3dc>
    c00005c0:	b94007e0 	ldr	w0, [sp, #4]
    c00005c4:	7100181f 	cmp	w0, #0x6
    c00005c8:	54001640 	b.eq	c0000890 <get_signed_arg+0x2f4>  // b.none
    c00005cc:	b94007e0 	ldr	w0, [sp, #4]
    c00005d0:	7100181f 	cmp	w0, #0x6
    c00005d4:	54001d2c 	b.gt	c0000978 <get_signed_arg+0x3dc>
    c00005d8:	b94007e0 	ldr	w0, [sp, #4]
    c00005dc:	7100141f 	cmp	w0, #0x5
    c00005e0:	540011e0 	b.eq	c000081c <get_signed_arg+0x280>  // b.none
    c00005e4:	b94007e0 	ldr	w0, [sp, #4]
    c00005e8:	7100141f 	cmp	w0, #0x5
    c00005ec:	54001c6c 	b.gt	c0000978 <get_signed_arg+0x3dc>
    c00005f0:	b94007e0 	ldr	w0, [sp, #4]
    c00005f4:	7100101f 	cmp	w0, #0x4
    c00005f8:	54000d80 	b.eq	c00007a8 <get_signed_arg+0x20c>  // b.none
    c00005fc:	b94007e0 	ldr	w0, [sp, #4]
    c0000600:	7100101f 	cmp	w0, #0x4
    c0000604:	54001bac 	b.gt	c0000978 <get_signed_arg+0x3dc>
    c0000608:	b94007e0 	ldr	w0, [sp, #4]
    c000060c:	71000c1f 	cmp	w0, #0x3
    c0000610:	54000920 	b.eq	c0000734 <get_signed_arg+0x198>  // b.none
    c0000614:	b94007e0 	ldr	w0, [sp, #4]
    c0000618:	71000c1f 	cmp	w0, #0x3
    c000061c:	54001aec 	b.gt	c0000978 <get_signed_arg+0x3dc>
    c0000620:	b94007e0 	ldr	w0, [sp, #4]
    c0000624:	7100041f 	cmp	w0, #0x1
    c0000628:	540000a0 	b.eq	c000063c <get_signed_arg+0xa0>  // b.none
    c000062c:	b94007e0 	ldr	w0, [sp, #4]
    c0000630:	7100081f 	cmp	w0, #0x2
    c0000634:	54000420 	b.eq	c00006b8 <get_signed_arg+0x11c>  // b.none
    c0000638:	140000d0 	b	c0000978 <get_signed_arg+0x3dc>
	case LENGTH_HH:
		return (int64_t)(signed char)va_arg(*args, int);
    c000063c:	f94007e0 	ldr	x0, [sp, #8]
    c0000640:	b9401801 	ldr	w1, [x0, #24]
    c0000644:	f94007e0 	ldr	x0, [sp, #8]
    c0000648:	f9400000 	ldr	x0, [x0]
    c000064c:	7100003f 	cmp	w1, #0x0
    c0000650:	540000cb 	b.lt	c0000668 <get_signed_arg+0xcc>  // b.tstop
    c0000654:	91002c01 	add	x1, x0, #0xb
    c0000658:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c000065c:	f94007e1 	ldr	x1, [sp, #8]
    c0000660:	f9000022 	str	x2, [x1]
    c0000664:	14000011 	b	c00006a8 <get_signed_arg+0x10c>
    c0000668:	11002023 	add	w3, w1, #0x8
    c000066c:	f94007e2 	ldr	x2, [sp, #8]
    c0000670:	b9001843 	str	w3, [x2, #24]
    c0000674:	f94007e2 	ldr	x2, [sp, #8]
    c0000678:	b9401842 	ldr	w2, [x2, #24]
    c000067c:	7100005f 	cmp	w2, #0x0
    c0000680:	540000cd 	b.le	c0000698 <get_signed_arg+0xfc>
    c0000684:	91002c01 	add	x1, x0, #0xb
    c0000688:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c000068c:	f94007e1 	ldr	x1, [sp, #8]
    c0000690:	f9000022 	str	x2, [x1]
    c0000694:	14000005 	b	c00006a8 <get_signed_arg+0x10c>
    c0000698:	f94007e0 	ldr	x0, [sp, #8]
    c000069c:	f9400402 	ldr	x2, [x0, #8]
    c00006a0:	93407c20 	sxtw	x0, w1
    c00006a4:	8b000040 	add	x0, x2, x0
    c00006a8:	b9400000 	ldr	w0, [x0]
    c00006ac:	13001c00 	sxtb	w0, w0
    c00006b0:	93401c00 	sxtb	x0, w0
    c00006b4:	140000ce 	b	c00009ec <get_signed_arg+0x450>
	case LENGTH_H:
		return (int64_t)(short)va_arg(*args, int);
    c00006b8:	f94007e0 	ldr	x0, [sp, #8]
    c00006bc:	b9401801 	ldr	w1, [x0, #24]
    c00006c0:	f94007e0 	ldr	x0, [sp, #8]
    c00006c4:	f9400000 	ldr	x0, [x0]
    c00006c8:	7100003f 	cmp	w1, #0x0
    c00006cc:	540000cb 	b.lt	c00006e4 <get_signed_arg+0x148>  // b.tstop
    c00006d0:	91002c01 	add	x1, x0, #0xb
    c00006d4:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c00006d8:	f94007e1 	ldr	x1, [sp, #8]
    c00006dc:	f9000022 	str	x2, [x1]
    c00006e0:	14000011 	b	c0000724 <get_signed_arg+0x188>
    c00006e4:	11002023 	add	w3, w1, #0x8
    c00006e8:	f94007e2 	ldr	x2, [sp, #8]
    c00006ec:	b9001843 	str	w3, [x2, #24]
    c00006f0:	f94007e2 	ldr	x2, [sp, #8]
    c00006f4:	b9401842 	ldr	w2, [x2, #24]
    c00006f8:	7100005f 	cmp	w2, #0x0
    c00006fc:	540000cd 	b.le	c0000714 <get_signed_arg+0x178>
    c0000700:	91002c01 	add	x1, x0, #0xb
    c0000704:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c0000708:	f94007e1 	ldr	x1, [sp, #8]
    c000070c:	f9000022 	str	x2, [x1]
    c0000710:	14000005 	b	c0000724 <get_signed_arg+0x188>
    c0000714:	f94007e0 	ldr	x0, [sp, #8]
    c0000718:	f9400402 	ldr	x2, [x0, #8]
    c000071c:	93407c20 	sxtw	x0, w1
    c0000720:	8b000040 	add	x0, x2, x0
    c0000724:	b9400000 	ldr	w0, [x0]
    c0000728:	13003c00 	sxth	w0, w0
    c000072c:	93403c00 	sxth	x0, w0
    c0000730:	140000af 	b	c00009ec <get_signed_arg+0x450>
	case LENGTH_L:
		return (int64_t)va_arg(*args, long);
    c0000734:	f94007e0 	ldr	x0, [sp, #8]
    c0000738:	b9401801 	ldr	w1, [x0, #24]
    c000073c:	f94007e0 	ldr	x0, [sp, #8]
    c0000740:	f9400000 	ldr	x0, [x0]
    c0000744:	7100003f 	cmp	w1, #0x0
    c0000748:	540000cb 	b.lt	c0000760 <get_signed_arg+0x1c4>  // b.tstop
    c000074c:	91003c01 	add	x1, x0, #0xf
    c0000750:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c0000754:	f94007e1 	ldr	x1, [sp, #8]
    c0000758:	f9000022 	str	x2, [x1]
    c000075c:	14000011 	b	c00007a0 <get_signed_arg+0x204>
    c0000760:	11002023 	add	w3, w1, #0x8
    c0000764:	f94007e2 	ldr	x2, [sp, #8]
    c0000768:	b9001843 	str	w3, [x2, #24]
    c000076c:	f94007e2 	ldr	x2, [sp, #8]
    c0000770:	b9401842 	ldr	w2, [x2, #24]
    c0000774:	7100005f 	cmp	w2, #0x0
    c0000778:	540000cd 	b.le	c0000790 <get_signed_arg+0x1f4>
    c000077c:	91003c01 	add	x1, x0, #0xf
    c0000780:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c0000784:	f94007e1 	ldr	x1, [sp, #8]
    c0000788:	f9000022 	str	x2, [x1]
    c000078c:	14000005 	b	c00007a0 <get_signed_arg+0x204>
    c0000790:	f94007e0 	ldr	x0, [sp, #8]
    c0000794:	f9400402 	ldr	x2, [x0, #8]
    c0000798:	93407c20 	sxtw	x0, w1
    c000079c:	8b000040 	add	x0, x2, x0
    c00007a0:	f9400000 	ldr	x0, [x0]
    c00007a4:	14000092 	b	c00009ec <get_signed_arg+0x450>
	case LENGTH_LL:
		return (int64_t)va_arg(*args, long long);
    c00007a8:	f94007e0 	ldr	x0, [sp, #8]
    c00007ac:	b9401801 	ldr	w1, [x0, #24]
    c00007b0:	f94007e0 	ldr	x0, [sp, #8]
    c00007b4:	f9400000 	ldr	x0, [x0]
    c00007b8:	7100003f 	cmp	w1, #0x0
    c00007bc:	540000cb 	b.lt	c00007d4 <get_signed_arg+0x238>  // b.tstop
    c00007c0:	91003c01 	add	x1, x0, #0xf
    c00007c4:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c00007c8:	f94007e1 	ldr	x1, [sp, #8]
    c00007cc:	f9000022 	str	x2, [x1]
    c00007d0:	14000011 	b	c0000814 <get_signed_arg+0x278>
    c00007d4:	11002023 	add	w3, w1, #0x8
    c00007d8:	f94007e2 	ldr	x2, [sp, #8]
    c00007dc:	b9001843 	str	w3, [x2, #24]
    c00007e0:	f94007e2 	ldr	x2, [sp, #8]
    c00007e4:	b9401842 	ldr	w2, [x2, #24]
    c00007e8:	7100005f 	cmp	w2, #0x0
    c00007ec:	540000cd 	b.le	c0000804 <get_signed_arg+0x268>
    c00007f0:	91003c01 	add	x1, x0, #0xf
    c00007f4:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c00007f8:	f94007e1 	ldr	x1, [sp, #8]
    c00007fc:	f9000022 	str	x2, [x1]
    c0000800:	14000005 	b	c0000814 <get_signed_arg+0x278>
    c0000804:	f94007e0 	ldr	x0, [sp, #8]
    c0000808:	f9400402 	ldr	x2, [x0, #8]
    c000080c:	93407c20 	sxtw	x0, w1
    c0000810:	8b000040 	add	x0, x2, x0
    c0000814:	f9400000 	ldr	x0, [x0]
    c0000818:	14000075 	b	c00009ec <get_signed_arg+0x450>
	case LENGTH_Z:
		return (int64_t)(ptrdiff_t)va_arg(*args, size_t);
    c000081c:	f94007e0 	ldr	x0, [sp, #8]
    c0000820:	b9401801 	ldr	w1, [x0, #24]
    c0000824:	f94007e0 	ldr	x0, [sp, #8]
    c0000828:	f9400000 	ldr	x0, [x0]
    c000082c:	7100003f 	cmp	w1, #0x0
    c0000830:	540000cb 	b.lt	c0000848 <get_signed_arg+0x2ac>  // b.tstop
    c0000834:	91003c01 	add	x1, x0, #0xf
    c0000838:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c000083c:	f94007e1 	ldr	x1, [sp, #8]
    c0000840:	f9000022 	str	x2, [x1]
    c0000844:	14000011 	b	c0000888 <get_signed_arg+0x2ec>
    c0000848:	11002023 	add	w3, w1, #0x8
    c000084c:	f94007e2 	ldr	x2, [sp, #8]
    c0000850:	b9001843 	str	w3, [x2, #24]
    c0000854:	f94007e2 	ldr	x2, [sp, #8]
    c0000858:	b9401842 	ldr	w2, [x2, #24]
    c000085c:	7100005f 	cmp	w2, #0x0
    c0000860:	540000cd 	b.le	c0000878 <get_signed_arg+0x2dc>
    c0000864:	91003c01 	add	x1, x0, #0xf
    c0000868:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c000086c:	f94007e1 	ldr	x1, [sp, #8]
    c0000870:	f9000022 	str	x2, [x1]
    c0000874:	14000005 	b	c0000888 <get_signed_arg+0x2ec>
    c0000878:	f94007e0 	ldr	x0, [sp, #8]
    c000087c:	f9400402 	ldr	x2, [x0, #8]
    c0000880:	93407c20 	sxtw	x0, w1
    c0000884:	8b000040 	add	x0, x2, x0
    c0000888:	f9400000 	ldr	x0, [x0]
    c000088c:	14000058 	b	c00009ec <get_signed_arg+0x450>
	case LENGTH_T:
		return (int64_t)va_arg(*args, ptrdiff_t);
    c0000890:	f94007e0 	ldr	x0, [sp, #8]
    c0000894:	b9401801 	ldr	w1, [x0, #24]
    c0000898:	f94007e0 	ldr	x0, [sp, #8]
    c000089c:	f9400000 	ldr	x0, [x0]
    c00008a0:	7100003f 	cmp	w1, #0x0
    c00008a4:	540000cb 	b.lt	c00008bc <get_signed_arg+0x320>  // b.tstop
    c00008a8:	91003c01 	add	x1, x0, #0xf
    c00008ac:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c00008b0:	f94007e1 	ldr	x1, [sp, #8]
    c00008b4:	f9000022 	str	x2, [x1]
    c00008b8:	14000011 	b	c00008fc <get_signed_arg+0x360>
    c00008bc:	11002023 	add	w3, w1, #0x8
    c00008c0:	f94007e2 	ldr	x2, [sp, #8]
    c00008c4:	b9001843 	str	w3, [x2, #24]
    c00008c8:	f94007e2 	ldr	x2, [sp, #8]
    c00008cc:	b9401842 	ldr	w2, [x2, #24]
    c00008d0:	7100005f 	cmp	w2, #0x0
    c00008d4:	540000cd 	b.le	c00008ec <get_signed_arg+0x350>
    c00008d8:	91003c01 	add	x1, x0, #0xf
    c00008dc:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c00008e0:	f94007e1 	ldr	x1, [sp, #8]
    c00008e4:	f9000022 	str	x2, [x1]
    c00008e8:	14000005 	b	c00008fc <get_signed_arg+0x360>
    c00008ec:	f94007e0 	ldr	x0, [sp, #8]
    c00008f0:	f9400402 	ldr	x2, [x0, #8]
    c00008f4:	93407c20 	sxtw	x0, w1
    c00008f8:	8b000040 	add	x0, x2, x0
    c00008fc:	f9400000 	ldr	x0, [x0]
    c0000900:	1400003b 	b	c00009ec <get_signed_arg+0x450>
	case LENGTH_J:
		return (int64_t)va_arg(*args, intmax_t);
    c0000904:	f94007e0 	ldr	x0, [sp, #8]
    c0000908:	b9401801 	ldr	w1, [x0, #24]
    c000090c:	f94007e0 	ldr	x0, [sp, #8]
    c0000910:	f9400000 	ldr	x0, [x0]
    c0000914:	7100003f 	cmp	w1, #0x0
    c0000918:	540000cb 	b.lt	c0000930 <get_signed_arg+0x394>  // b.tstop
    c000091c:	91003c01 	add	x1, x0, #0xf
    c0000920:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c0000924:	f94007e1 	ldr	x1, [sp, #8]
    c0000928:	f9000022 	str	x2, [x1]
    c000092c:	14000011 	b	c0000970 <get_signed_arg+0x3d4>
    c0000930:	11002023 	add	w3, w1, #0x8
    c0000934:	f94007e2 	ldr	x2, [sp, #8]
    c0000938:	b9001843 	str	w3, [x2, #24]
    c000093c:	f94007e2 	ldr	x2, [sp, #8]
    c0000940:	b9401842 	ldr	w2, [x2, #24]
    c0000944:	7100005f 	cmp	w2, #0x0
    c0000948:	540000cd 	b.le	c0000960 <get_signed_arg+0x3c4>
    c000094c:	91003c01 	add	x1, x0, #0xf
    c0000950:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c0000954:	f94007e1 	ldr	x1, [sp, #8]
    c0000958:	f9000022 	str	x2, [x1]
    c000095c:	14000005 	b	c0000970 <get_signed_arg+0x3d4>
    c0000960:	f94007e0 	ldr	x0, [sp, #8]
    c0000964:	f9400402 	ldr	x2, [x0, #8]
    c0000968:	93407c20 	sxtw	x0, w1
    c000096c:	8b000040 	add	x0, x2, x0
    c0000970:	f9400000 	ldr	x0, [x0]
    c0000974:	1400001e 	b	c00009ec <get_signed_arg+0x450>
	default:
		return (int64_t)va_arg(*args, int);
    c0000978:	f94007e0 	ldr	x0, [sp, #8]
    c000097c:	b9401801 	ldr	w1, [x0, #24]
    c0000980:	f94007e0 	ldr	x0, [sp, #8]
    c0000984:	f9400000 	ldr	x0, [x0]
    c0000988:	7100003f 	cmp	w1, #0x0
    c000098c:	540000cb 	b.lt	c00009a4 <get_signed_arg+0x408>  // b.tstop
    c0000990:	91002c01 	add	x1, x0, #0xb
    c0000994:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c0000998:	f94007e1 	ldr	x1, [sp, #8]
    c000099c:	f9000022 	str	x2, [x1]
    c00009a0:	14000011 	b	c00009e4 <get_signed_arg+0x448>
    c00009a4:	11002023 	add	w3, w1, #0x8
    c00009a8:	f94007e2 	ldr	x2, [sp, #8]
    c00009ac:	b9001843 	str	w3, [x2, #24]
    c00009b0:	f94007e2 	ldr	x2, [sp, #8]
    c00009b4:	b9401842 	ldr	w2, [x2, #24]
    c00009b8:	7100005f 	cmp	w2, #0x0
    c00009bc:	540000cd 	b.le	c00009d4 <get_signed_arg+0x438>
    c00009c0:	91002c01 	add	x1, x0, #0xb
    c00009c4:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c00009c8:	f94007e1 	ldr	x1, [sp, #8]
    c00009cc:	f9000022 	str	x2, [x1]
    c00009d0:	14000005 	b	c00009e4 <get_signed_arg+0x448>
    c00009d4:	f94007e0 	ldr	x0, [sp, #8]
    c00009d8:	f9400402 	ldr	x2, [x0, #8]
    c00009dc:	93407c20 	sxtw	x0, w1
    c00009e0:	8b000040 	add	x0, x2, x0
    c00009e4:	b9400000 	ldr	w0, [x0]
    c00009e8:	93407c00 	sxtw	x0, w0
	}
}
    c00009ec:	910043ff 	add	sp, sp, #0x10
    c00009f0:	d65f03c0 	ret

00000000c00009f4 <u64_to_str>:

static size_t u64_to_str(uint64_t value, unsigned int base, bool upper,
			 char *buf)
{
    c00009f4:	d100c3ff 	sub	sp, sp, #0x30
    c00009f8:	f9000fe0 	str	x0, [sp, #24]
    c00009fc:	b90017e1 	str	w1, [sp, #20]
    c0000a00:	39004fe2 	strb	w2, [sp, #19]
    c0000a04:	f90007e3 	str	x3, [sp, #8]
	static const char lower_digits[] = "0123456789abcdef";
	static const char upper_digits[] = "0123456789ABCDEF";
	const char *digits = upper ? upper_digits : lower_digits;
    c0000a08:	39404fe0 	ldrb	w0, [sp, #19]
    c0000a0c:	12000000 	and	w0, w0, #0x1
    c0000a10:	7100001f 	cmp	w0, #0x0
    c0000a14:	54000080 	b.eq	c0000a24 <u64_to_str+0x30>  // b.none
    c0000a18:	b0000020 	adrp	x0, c0005000 <smp_init+0x68>
    c0000a1c:	913aa000 	add	x0, x0, #0xea8
    c0000a20:	14000003 	b	c0000a2c <u64_to_str+0x38>
    c0000a24:	b0000020 	adrp	x0, c0005000 <smp_init+0x68>
    c0000a28:	913b0000 	add	x0, x0, #0xec0
    c0000a2c:	f90013e0 	str	x0, [sp, #32]
	size_t len = 0U;
    c0000a30:	f90017ff 	str	xzr, [sp, #40]

	do {
		buf[len++] = digits[value % base];
    c0000a34:	b94017e1 	ldr	w1, [sp, #20]
    c0000a38:	f9400fe0 	ldr	x0, [sp, #24]
    c0000a3c:	9ac10802 	udiv	x2, x0, x1
    c0000a40:	9b017c41 	mul	x1, x2, x1
    c0000a44:	cb010000 	sub	x0, x0, x1
    c0000a48:	f94013e1 	ldr	x1, [sp, #32]
    c0000a4c:	8b000021 	add	x1, x1, x0
    c0000a50:	f94017e0 	ldr	x0, [sp, #40]
    c0000a54:	91000402 	add	x2, x0, #0x1
    c0000a58:	f90017e2 	str	x2, [sp, #40]
    c0000a5c:	f94007e2 	ldr	x2, [sp, #8]
    c0000a60:	8b000040 	add	x0, x2, x0
    c0000a64:	39400021 	ldrb	w1, [x1]
    c0000a68:	39000001 	strb	w1, [x0]
		value /= base;
    c0000a6c:	b94017e0 	ldr	w0, [sp, #20]
    c0000a70:	f9400fe1 	ldr	x1, [sp, #24]
    c0000a74:	9ac00820 	udiv	x0, x1, x0
    c0000a78:	f9000fe0 	str	x0, [sp, #24]
	} while (value != 0U);
    c0000a7c:	f9400fe0 	ldr	x0, [sp, #24]
    c0000a80:	f100001f 	cmp	x0, #0x0
    c0000a84:	54fffd81 	b.ne	c0000a34 <u64_to_str+0x40>  // b.any

	return len;
    c0000a88:	f94017e0 	ldr	x0, [sp, #40]
}
    c0000a8c:	9100c3ff 	add	sp, sp, #0x30
    c0000a90:	d65f03c0 	ret

00000000c0000a94 <print_buffer>:

static void print_buffer(struct print_ctx *ctx, const char *buf, size_t len)
{
    c0000a94:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
    c0000a98:	910003fd 	mov	x29, sp
    c0000a9c:	f90017e0 	str	x0, [sp, #40]
    c0000aa0:	f90013e1 	str	x1, [sp, #32]
    c0000aa4:	f9000fe2 	str	x2, [sp, #24]
	while (len-- > 0U) {
    c0000aa8:	14000008 	b	c0000ac8 <print_buffer+0x34>
		print_char(ctx, *buf++);
    c0000aac:	f94013e0 	ldr	x0, [sp, #32]
    c0000ab0:	91000401 	add	x1, x0, #0x1
    c0000ab4:	f90013e1 	str	x1, [sp, #32]
    c0000ab8:	39400000 	ldrb	w0, [x0]
    c0000abc:	2a0003e1 	mov	w1, w0
    c0000ac0:	f94017e0 	ldr	x0, [sp, #40]
    c0000ac4:	97fffd6b 	bl	c0000070 <print_char>
	while (len-- > 0U) {
    c0000ac8:	f9400fe0 	ldr	x0, [sp, #24]
    c0000acc:	d1000401 	sub	x1, x0, #0x1
    c0000ad0:	f9000fe1 	str	x1, [sp, #24]
    c0000ad4:	f100001f 	cmp	x0, #0x0
    c0000ad8:	54fffea1 	b.ne	c0000aac <print_buffer+0x18>  // b.any
	}
}
    c0000adc:	d503201f 	nop
    c0000ae0:	d503201f 	nop
    c0000ae4:	a8c37bfd 	ldp	x29, x30, [sp], #48
    c0000ae8:	d65f03c0 	ret

00000000c0000aec <format_integer>:

static void format_integer(struct print_ctx *ctx, struct format_spec *spec,
			   uint64_t value, bool negative, unsigned int base)
{
    c0000aec:	a9b77bfd 	stp	x29, x30, [sp, #-144]!
    c0000af0:	910003fd 	mov	x29, sp
    c0000af4:	f90017e0 	str	x0, [sp, #40]
    c0000af8:	f90013e1 	str	x1, [sp, #32]
    c0000afc:	f9000fe2 	str	x2, [sp, #24]
    c0000b00:	39005fe3 	strb	w3, [sp, #23]
    c0000b04:	b90013e4 	str	w4, [sp, #16]
	char digits[32];
	char prefix[3];
	size_t digits_len;
	size_t prefix_len = 0U;
    c0000b08:	f90043ff 	str	xzr, [sp, #128]
	size_t zero_pad = 0U;
    c0000b0c:	f9003fff 	str	xzr, [sp, #120]
	size_t total_len;
	int pad_len;
	bool precision_specified = spec->precision >= 0;
    c0000b10:	f94013e0 	ldr	x0, [sp, #32]
    c0000b14:	b9400800 	ldr	w0, [x0, #8]
    c0000b18:	2a2003e0 	mvn	w0, w0
    c0000b1c:	531f7c00 	lsr	w0, w0, #31
    c0000b20:	3901dfe0 	strb	w0, [sp, #119]
	bool zero_value_suppressed = precision_specified &&
		(spec->precision == 0) && (value == 0U);
    c0000b24:	3941dfe0 	ldrb	w0, [sp, #119]
    c0000b28:	12000000 	and	w0, w0, #0x1
    c0000b2c:	7100001f 	cmp	w0, #0x0
    c0000b30:	54000140 	b.eq	c0000b58 <format_integer+0x6c>  // b.none
    c0000b34:	f94013e0 	ldr	x0, [sp, #32]
    c0000b38:	b9400800 	ldr	w0, [x0, #8]
	bool zero_value_suppressed = precision_specified &&
    c0000b3c:	7100001f 	cmp	w0, #0x0
    c0000b40:	540000c1 	b.ne	c0000b58 <format_integer+0x6c>  // b.any
		(spec->precision == 0) && (value == 0U);
    c0000b44:	f9400fe0 	ldr	x0, [sp, #24]
    c0000b48:	f100001f 	cmp	x0, #0x0
    c0000b4c:	54000061 	b.ne	c0000b58 <format_integer+0x6c>  // b.any
    c0000b50:	52800020 	mov	w0, #0x1                   	// #1
    c0000b54:	14000002 	b	c0000b5c <format_integer+0x70>
    c0000b58:	52800000 	mov	w0, #0x0                   	// #0
	bool zero_value_suppressed = precision_specified &&
    c0000b5c:	3901dbe0 	strb	w0, [sp, #118]
    c0000b60:	3941dbe0 	ldrb	w0, [sp, #118]
    c0000b64:	12000000 	and	w0, w0, #0x1
    c0000b68:	3901dbe0 	strb	w0, [sp, #118]

	if (negative) {
    c0000b6c:	39405fe0 	ldrb	w0, [sp, #23]
    c0000b70:	12000000 	and	w0, w0, #0x1
    c0000b74:	7100001f 	cmp	w0, #0x0
    c0000b78:	54000100 	b.eq	c0000b98 <format_integer+0xac>  // b.none
		prefix[prefix_len++] = '-';
    c0000b7c:	f94043e0 	ldr	x0, [sp, #128]
    c0000b80:	91000401 	add	x1, x0, #0x1
    c0000b84:	f90043e1 	str	x1, [sp, #128]
    c0000b88:	9100e3e1 	add	x1, sp, #0x38
    c0000b8c:	528005a2 	mov	w2, #0x2d                  	// #45
    c0000b90:	38206822 	strb	w2, [x1, x0]
    c0000b94:	14000018 	b	c0000bf4 <format_integer+0x108>
	} else if ((spec->flags & FLAG_PLUS) != 0U) {
    c0000b98:	f94013e0 	ldr	x0, [sp, #32]
    c0000b9c:	b9400000 	ldr	w0, [x0]
    c0000ba0:	121f0000 	and	w0, w0, #0x2
    c0000ba4:	7100001f 	cmp	w0, #0x0
    c0000ba8:	54000100 	b.eq	c0000bc8 <format_integer+0xdc>  // b.none
		prefix[prefix_len++] = '+';
    c0000bac:	f94043e0 	ldr	x0, [sp, #128]
    c0000bb0:	91000401 	add	x1, x0, #0x1
    c0000bb4:	f90043e1 	str	x1, [sp, #128]
    c0000bb8:	9100e3e1 	add	x1, sp, #0x38
    c0000bbc:	52800562 	mov	w2, #0x2b                  	// #43
    c0000bc0:	38206822 	strb	w2, [x1, x0]
    c0000bc4:	1400000c 	b	c0000bf4 <format_integer+0x108>
	} else if ((spec->flags & FLAG_SPACE) != 0U) {
    c0000bc8:	f94013e0 	ldr	x0, [sp, #32]
    c0000bcc:	b9400000 	ldr	w0, [x0]
    c0000bd0:	121e0000 	and	w0, w0, #0x4
    c0000bd4:	7100001f 	cmp	w0, #0x0
    c0000bd8:	540000e0 	b.eq	c0000bf4 <format_integer+0x108>  // b.none
		prefix[prefix_len++] = ' ';
    c0000bdc:	f94043e0 	ldr	x0, [sp, #128]
    c0000be0:	91000401 	add	x1, x0, #0x1
    c0000be4:	f90043e1 	str	x1, [sp, #128]
    c0000be8:	9100e3e1 	add	x1, sp, #0x38
    c0000bec:	52800402 	mov	w2, #0x20                  	// #32
    c0000bf0:	38206822 	strb	w2, [x1, x0]
	}

	if ((spec->flags & FLAG_ALT) != 0U) {
    c0000bf4:	f94013e0 	ldr	x0, [sp, #32]
    c0000bf8:	b9400000 	ldr	w0, [x0]
    c0000bfc:	121d0000 	and	w0, w0, #0x8
    c0000c00:	7100001f 	cmp	w0, #0x0
    c0000c04:	54000620 	b.eq	c0000cc8 <format_integer+0x1dc>  // b.none
		if ((base == 8U) && ((value != 0U) || !precision_specified || (spec->precision == 0))) {
    c0000c08:	b94013e0 	ldr	w0, [sp, #16]
    c0000c0c:	7100201f 	cmp	w0, #0x8
    c0000c10:	540002a1 	b.ne	c0000c64 <format_integer+0x178>  // b.any
    c0000c14:	f9400fe0 	ldr	x0, [sp, #24]
    c0000c18:	f100001f 	cmp	x0, #0x0
    c0000c1c:	54000161 	b.ne	c0000c48 <format_integer+0x15c>  // b.any
    c0000c20:	3941dfe0 	ldrb	w0, [sp, #119]
    c0000c24:	52000000 	eor	w0, w0, #0x1
    c0000c28:	12001c00 	and	w0, w0, #0xff
    c0000c2c:	12000000 	and	w0, w0, #0x1
    c0000c30:	7100001f 	cmp	w0, #0x0
    c0000c34:	540000a1 	b.ne	c0000c48 <format_integer+0x15c>  // b.any
    c0000c38:	f94013e0 	ldr	x0, [sp, #32]
    c0000c3c:	b9400800 	ldr	w0, [x0, #8]
    c0000c40:	7100001f 	cmp	w0, #0x0
    c0000c44:	54000101 	b.ne	c0000c64 <format_integer+0x178>  // b.any
			prefix[prefix_len++] = '0';
    c0000c48:	f94043e0 	ldr	x0, [sp, #128]
    c0000c4c:	91000401 	add	x1, x0, #0x1
    c0000c50:	f90043e1 	str	x1, [sp, #128]
    c0000c54:	9100e3e1 	add	x1, sp, #0x38
    c0000c58:	52800602 	mov	w2, #0x30                  	// #48
    c0000c5c:	38206822 	strb	w2, [x1, x0]
    c0000c60:	1400001a 	b	c0000cc8 <format_integer+0x1dc>
		} else if ((base == 16U) && (value != 0U)) {
    c0000c64:	b94013e0 	ldr	w0, [sp, #16]
    c0000c68:	7100401f 	cmp	w0, #0x10
    c0000c6c:	540002e1 	b.ne	c0000cc8 <format_integer+0x1dc>  // b.any
    c0000c70:	f9400fe0 	ldr	x0, [sp, #24]
    c0000c74:	f100001f 	cmp	x0, #0x0
    c0000c78:	54000280 	b.eq	c0000cc8 <format_integer+0x1dc>  // b.none
			prefix[prefix_len++] = '0';
    c0000c7c:	f94043e0 	ldr	x0, [sp, #128]
    c0000c80:	91000401 	add	x1, x0, #0x1
    c0000c84:	f90043e1 	str	x1, [sp, #128]
    c0000c88:	9100e3e1 	add	x1, sp, #0x38
    c0000c8c:	52800602 	mov	w2, #0x30                  	// #48
    c0000c90:	38206822 	strb	w2, [x1, x0]
			prefix[prefix_len++] = ((spec->flags & FLAG_UPPER) != 0U) ? 'X' : 'x';
    c0000c94:	f94013e0 	ldr	x0, [sp, #32]
    c0000c98:	b9400000 	ldr	w0, [x0]
    c0000c9c:	121b0000 	and	w0, w0, #0x20
    c0000ca0:	7100001f 	cmp	w0, #0x0
    c0000ca4:	54000060 	b.eq	c0000cb0 <format_integer+0x1c4>  // b.none
    c0000ca8:	52800b01 	mov	w1, #0x58                  	// #88
    c0000cac:	14000002 	b	c0000cb4 <format_integer+0x1c8>
    c0000cb0:	52800f01 	mov	w1, #0x78                  	// #120
    c0000cb4:	f94043e0 	ldr	x0, [sp, #128]
    c0000cb8:	91000402 	add	x2, x0, #0x1
    c0000cbc:	f90043e2 	str	x2, [sp, #128]
    c0000cc0:	9100e3e2 	add	x2, sp, #0x38
    c0000cc4:	38206841 	strb	w1, [x2, x0]
		}
	}

	if (zero_value_suppressed) {
    c0000cc8:	3941dbe0 	ldrb	w0, [sp, #118]
    c0000ccc:	12000000 	and	w0, w0, #0x1
    c0000cd0:	7100001f 	cmp	w0, #0x0
    c0000cd4:	54000060 	b.eq	c0000ce0 <format_integer+0x1f4>  // b.none
		digits_len = 0U;
    c0000cd8:	f90047ff 	str	xzr, [sp, #136]
    c0000cdc:	1400000e 	b	c0000d14 <format_integer+0x228>
	} else {
		digits_len = u64_to_str(value, base, (spec->flags & FLAG_UPPER) != 0U,
    c0000ce0:	f94013e0 	ldr	x0, [sp, #32]
    c0000ce4:	b9400000 	ldr	w0, [x0]
    c0000ce8:	121b0000 	and	w0, w0, #0x20
    c0000cec:	7100001f 	cmp	w0, #0x0
    c0000cf0:	1a9f07e0 	cset	w0, ne	// ne = any
    c0000cf4:	12001c01 	and	w1, w0, #0xff
    c0000cf8:	910103e0 	add	x0, sp, #0x40
    c0000cfc:	aa0003e3 	mov	x3, x0
    c0000d00:	2a0103e2 	mov	w2, w1
    c0000d04:	b94013e1 	ldr	w1, [sp, #16]
    c0000d08:	f9400fe0 	ldr	x0, [sp, #24]
    c0000d0c:	97ffff3a 	bl	c00009f4 <u64_to_str>
    c0000d10:	f90047e0 	str	x0, [sp, #136]
				      digits);
	}

	if (precision_specified && ((size_t)spec->precision > digits_len)) {
    c0000d14:	3941dfe0 	ldrb	w0, [sp, #119]
    c0000d18:	12000000 	and	w0, w0, #0x1
    c0000d1c:	7100001f 	cmp	w0, #0x0
    c0000d20:	540001c0 	b.eq	c0000d58 <format_integer+0x26c>  // b.none
    c0000d24:	f94013e0 	ldr	x0, [sp, #32]
    c0000d28:	b9400800 	ldr	w0, [x0, #8]
    c0000d2c:	93407c00 	sxtw	x0, w0
    c0000d30:	f94047e1 	ldr	x1, [sp, #136]
    c0000d34:	eb00003f 	cmp	x1, x0
    c0000d38:	54000102 	b.cs	c0000d58 <format_integer+0x26c>  // b.hs, b.nlast
		zero_pad = (size_t)spec->precision - digits_len;
    c0000d3c:	f94013e0 	ldr	x0, [sp, #32]
    c0000d40:	b9400800 	ldr	w0, [x0, #8]
    c0000d44:	93407c01 	sxtw	x1, w0
    c0000d48:	f94047e0 	ldr	x0, [sp, #136]
    c0000d4c:	cb000020 	sub	x0, x1, x0
    c0000d50:	f9003fe0 	str	x0, [sp, #120]
    c0000d54:	14000021 	b	c0000dd8 <format_integer+0x2ec>
	} else if (((spec->flags & FLAG_ZERO) != 0U) &&
    c0000d58:	f94013e0 	ldr	x0, [sp, #32]
    c0000d5c:	b9400000 	ldr	w0, [x0]
    c0000d60:	121c0000 	and	w0, w0, #0x10
    c0000d64:	7100001f 	cmp	w0, #0x0
    c0000d68:	54000380 	b.eq	c0000dd8 <format_integer+0x2ec>  // b.none
		   ((spec->flags & FLAG_LEFT) == 0U) &&
    c0000d6c:	f94013e0 	ldr	x0, [sp, #32]
    c0000d70:	b9400000 	ldr	w0, [x0]
    c0000d74:	12000000 	and	w0, w0, #0x1
	} else if (((spec->flags & FLAG_ZERO) != 0U) &&
    c0000d78:	7100001f 	cmp	w0, #0x0
    c0000d7c:	540002e1 	b.ne	c0000dd8 <format_integer+0x2ec>  // b.any
		   !precision_specified &&
    c0000d80:	3941dfe0 	ldrb	w0, [sp, #119]
    c0000d84:	52000000 	eor	w0, w0, #0x1
    c0000d88:	12001c00 	and	w0, w0, #0xff
		   ((spec->flags & FLAG_LEFT) == 0U) &&
    c0000d8c:	12000000 	and	w0, w0, #0x1
    c0000d90:	7100001f 	cmp	w0, #0x0
    c0000d94:	54000220 	b.eq	c0000dd8 <format_integer+0x2ec>  // b.none
		   (spec->width > (int)(prefix_len + digits_len))) {
    c0000d98:	f94013e0 	ldr	x0, [sp, #32]
    c0000d9c:	b9400400 	ldr	w0, [x0, #4]
    c0000da0:	f94043e1 	ldr	x1, [sp, #128]
    c0000da4:	2a0103e2 	mov	w2, w1
    c0000da8:	f94047e1 	ldr	x1, [sp, #136]
    c0000dac:	0b010041 	add	w1, w2, w1
		   !precision_specified &&
    c0000db0:	6b01001f 	cmp	w0, w1
    c0000db4:	5400012d 	b.le	c0000dd8 <format_integer+0x2ec>
		zero_pad = (size_t)spec->width - prefix_len - digits_len;
    c0000db8:	f94013e0 	ldr	x0, [sp, #32]
    c0000dbc:	b9400400 	ldr	w0, [x0, #4]
    c0000dc0:	93407c01 	sxtw	x1, w0
    c0000dc4:	f94043e0 	ldr	x0, [sp, #128]
    c0000dc8:	cb000021 	sub	x1, x1, x0
    c0000dcc:	f94047e0 	ldr	x0, [sp, #136]
    c0000dd0:	cb000020 	sub	x0, x1, x0
    c0000dd4:	f9003fe0 	str	x0, [sp, #120]
	}

	total_len = prefix_len + zero_pad + digits_len;
    c0000dd8:	f94043e1 	ldr	x1, [sp, #128]
    c0000ddc:	f9403fe0 	ldr	x0, [sp, #120]
    c0000de0:	8b000020 	add	x0, x1, x0
    c0000de4:	f94047e1 	ldr	x1, [sp, #136]
    c0000de8:	8b000020 	add	x0, x1, x0
    c0000dec:	f90037e0 	str	x0, [sp, #104]
	pad_len = (spec->width > (int)total_len) ? spec->width - (int)total_len : 0;
    c0000df0:	f94013e0 	ldr	x0, [sp, #32]
    c0000df4:	b9400400 	ldr	w0, [x0, #4]
    c0000df8:	f94037e1 	ldr	x1, [sp, #104]
    c0000dfc:	6b01001f 	cmp	w0, w1
    c0000e00:	540000cd 	b.le	c0000e18 <format_integer+0x32c>
    c0000e04:	f94013e0 	ldr	x0, [sp, #32]
    c0000e08:	b9400400 	ldr	w0, [x0, #4]
    c0000e0c:	f94037e1 	ldr	x1, [sp, #104]
    c0000e10:	4b010000 	sub	w0, w0, w1
    c0000e14:	14000002 	b	c0000e1c <format_integer+0x330>
    c0000e18:	52800000 	mov	w0, #0x0                   	// #0
    c0000e1c:	b90067e0 	str	w0, [sp, #100]

	if ((spec->flags & FLAG_LEFT) == 0U) {
    c0000e20:	f94013e0 	ldr	x0, [sp, #32]
    c0000e24:	b9400000 	ldr	w0, [x0]
    c0000e28:	12000000 	and	w0, w0, #0x1
    c0000e2c:	7100001f 	cmp	w0, #0x0
    c0000e30:	540000a1 	b.ne	c0000e44 <format_integer+0x358>  // b.any
		print_repeat(ctx, ' ', pad_len);
    c0000e34:	b94067e2 	ldr	w2, [sp, #100]
    c0000e38:	52800401 	mov	w1, #0x20                  	// #32
    c0000e3c:	f94017e0 	ldr	x0, [sp, #40]
    c0000e40:	97fffc9f 	bl	c00000bc <print_repeat>
	}

	print_buffer(ctx, prefix, prefix_len);
    c0000e44:	9100e3e0 	add	x0, sp, #0x38
    c0000e48:	f94043e2 	ldr	x2, [sp, #128]
    c0000e4c:	aa0003e1 	mov	x1, x0
    c0000e50:	f94017e0 	ldr	x0, [sp, #40]
    c0000e54:	97ffff10 	bl	c0000a94 <print_buffer>
	print_repeat(ctx, '0', (int)zero_pad);
    c0000e58:	f9403fe0 	ldr	x0, [sp, #120]
    c0000e5c:	2a0003e2 	mov	w2, w0
    c0000e60:	52800601 	mov	w1, #0x30                  	// #48
    c0000e64:	f94017e0 	ldr	x0, [sp, #40]
    c0000e68:	97fffc95 	bl	c00000bc <print_repeat>
	while (digits_len-- > 0U) {
    c0000e6c:	14000007 	b	c0000e88 <format_integer+0x39c>
		print_char(ctx, digits[digits_len]);
    c0000e70:	f94047e0 	ldr	x0, [sp, #136]
    c0000e74:	910103e1 	add	x1, sp, #0x40
    c0000e78:	38606820 	ldrb	w0, [x1, x0]
    c0000e7c:	2a0003e1 	mov	w1, w0
    c0000e80:	f94017e0 	ldr	x0, [sp, #40]
    c0000e84:	97fffc7b 	bl	c0000070 <print_char>
	while (digits_len-- > 0U) {
    c0000e88:	f94047e0 	ldr	x0, [sp, #136]
    c0000e8c:	d1000401 	sub	x1, x0, #0x1
    c0000e90:	f90047e1 	str	x1, [sp, #136]
    c0000e94:	f100001f 	cmp	x0, #0x0
    c0000e98:	54fffec1 	b.ne	c0000e70 <format_integer+0x384>  // b.any
	}

	if ((spec->flags & FLAG_LEFT) != 0U) {
    c0000e9c:	f94013e0 	ldr	x0, [sp, #32]
    c0000ea0:	b9400000 	ldr	w0, [x0]
    c0000ea4:	12000000 	and	w0, w0, #0x1
    c0000ea8:	7100001f 	cmp	w0, #0x0
    c0000eac:	540000a0 	b.eq	c0000ec0 <format_integer+0x3d4>  // b.none
		print_repeat(ctx, ' ', pad_len);
    c0000eb0:	b94067e2 	ldr	w2, [sp, #100]
    c0000eb4:	52800401 	mov	w1, #0x20                  	// #32
    c0000eb8:	f94017e0 	ldr	x0, [sp, #40]
    c0000ebc:	97fffc80 	bl	c00000bc <print_repeat>
	}
}
    c0000ec0:	d503201f 	nop
    c0000ec4:	a8c97bfd 	ldp	x29, x30, [sp], #144
    c0000ec8:	d65f03c0 	ret

00000000c0000ecc <format_string>:

static void format_string(struct print_ctx *ctx, struct format_spec *spec,
			  const char *str)
{
    c0000ecc:	a9bc7bfd 	stp	x29, x30, [sp, #-64]!
    c0000ed0:	910003fd 	mov	x29, sp
    c0000ed4:	f90017e0 	str	x0, [sp, #40]
    c0000ed8:	f90013e1 	str	x1, [sp, #32]
    c0000edc:	f9000fe2 	str	x2, [sp, #24]
	size_t len;
	int pad_len;

	if (str == NULL) {
    c0000ee0:	f9400fe0 	ldr	x0, [sp, #24]
    c0000ee4:	f100001f 	cmp	x0, #0x0
    c0000ee8:	54000081 	b.ne	c0000ef8 <format_string+0x2c>  // b.any
		str = "(null)";
    c0000eec:	b0000020 	adrp	x0, c0005000 <smp_init+0x68>
    c0000ef0:	913a8000 	add	x0, x0, #0xea0
    c0000ef4:	f9000fe0 	str	x0, [sp, #24]
	}

	len = str_length(str);
    c0000ef8:	f9400fe0 	ldr	x0, [sp, #24]
    c0000efc:	97fffc82 	bl	c0000104 <str_length>
    c0000f00:	f9001fe0 	str	x0, [sp, #56]
	if ((spec->precision >= 0) && ((size_t)spec->precision < len)) {
    c0000f04:	f94013e0 	ldr	x0, [sp, #32]
    c0000f08:	b9400800 	ldr	w0, [x0, #8]
    c0000f0c:	7100001f 	cmp	w0, #0x0
    c0000f10:	5400016b 	b.lt	c0000f3c <format_string+0x70>  // b.tstop
    c0000f14:	f94013e0 	ldr	x0, [sp, #32]
    c0000f18:	b9400800 	ldr	w0, [x0, #8]
    c0000f1c:	93407c00 	sxtw	x0, w0
    c0000f20:	f9401fe1 	ldr	x1, [sp, #56]
    c0000f24:	eb00003f 	cmp	x1, x0
    c0000f28:	540000a9 	b.ls	c0000f3c <format_string+0x70>  // b.plast
		len = (size_t)spec->precision;
    c0000f2c:	f94013e0 	ldr	x0, [sp, #32]
    c0000f30:	b9400800 	ldr	w0, [x0, #8]
    c0000f34:	93407c00 	sxtw	x0, w0
    c0000f38:	f9001fe0 	str	x0, [sp, #56]
	}

	pad_len = (spec->width > (int)len) ? spec->width - (int)len : 0;
    c0000f3c:	f94013e0 	ldr	x0, [sp, #32]
    c0000f40:	b9400400 	ldr	w0, [x0, #4]
    c0000f44:	f9401fe1 	ldr	x1, [sp, #56]
    c0000f48:	6b01001f 	cmp	w0, w1
    c0000f4c:	540000cd 	b.le	c0000f64 <format_string+0x98>
    c0000f50:	f94013e0 	ldr	x0, [sp, #32]
    c0000f54:	b9400400 	ldr	w0, [x0, #4]
    c0000f58:	f9401fe1 	ldr	x1, [sp, #56]
    c0000f5c:	4b010000 	sub	w0, w0, w1
    c0000f60:	14000002 	b	c0000f68 <format_string+0x9c>
    c0000f64:	52800000 	mov	w0, #0x0                   	// #0
    c0000f68:	b90037e0 	str	w0, [sp, #52]
	if ((spec->flags & FLAG_LEFT) == 0U) {
    c0000f6c:	f94013e0 	ldr	x0, [sp, #32]
    c0000f70:	b9400000 	ldr	w0, [x0]
    c0000f74:	12000000 	and	w0, w0, #0x1
    c0000f78:	7100001f 	cmp	w0, #0x0
    c0000f7c:	540000a1 	b.ne	c0000f90 <format_string+0xc4>  // b.any
		print_repeat(ctx, ' ', pad_len);
    c0000f80:	b94037e2 	ldr	w2, [sp, #52]
    c0000f84:	52800401 	mov	w1, #0x20                  	// #32
    c0000f88:	f94017e0 	ldr	x0, [sp, #40]
    c0000f8c:	97fffc4c 	bl	c00000bc <print_repeat>
	}
	print_buffer(ctx, str, len);
    c0000f90:	f9401fe2 	ldr	x2, [sp, #56]
    c0000f94:	f9400fe1 	ldr	x1, [sp, #24]
    c0000f98:	f94017e0 	ldr	x0, [sp, #40]
    c0000f9c:	97fffebe 	bl	c0000a94 <print_buffer>
	if ((spec->flags & FLAG_LEFT) != 0U) {
    c0000fa0:	f94013e0 	ldr	x0, [sp, #32]
    c0000fa4:	b9400000 	ldr	w0, [x0]
    c0000fa8:	12000000 	and	w0, w0, #0x1
    c0000fac:	7100001f 	cmp	w0, #0x0
    c0000fb0:	540000a0 	b.eq	c0000fc4 <format_string+0xf8>  // b.none
		print_repeat(ctx, ' ', pad_len);
    c0000fb4:	b94037e2 	ldr	w2, [sp, #52]
    c0000fb8:	52800401 	mov	w1, #0x20                  	// #32
    c0000fbc:	f94017e0 	ldr	x0, [sp, #40]
    c0000fc0:	97fffc3f 	bl	c00000bc <print_repeat>
	}
}
    c0000fc4:	d503201f 	nop
    c0000fc8:	a8c47bfd 	ldp	x29, x30, [sp], #64
    c0000fcc:	d65f03c0 	ret

00000000c0000fd0 <format_char>:

static void format_char(struct print_ctx *ctx, struct format_spec *spec, char ch)
{
    c0000fd0:	a9bc7bfd 	stp	x29, x30, [sp, #-64]!
    c0000fd4:	910003fd 	mov	x29, sp
    c0000fd8:	f90017e0 	str	x0, [sp, #40]
    c0000fdc:	f90013e1 	str	x1, [sp, #32]
    c0000fe0:	39007fe2 	strb	w2, [sp, #31]
	int pad_len = (spec->width > 1) ? spec->width - 1 : 0;
    c0000fe4:	f94013e0 	ldr	x0, [sp, #32]
    c0000fe8:	b9400400 	ldr	w0, [x0, #4]
    c0000fec:	52800021 	mov	w1, #0x1                   	// #1
    c0000ff0:	7100001f 	cmp	w0, #0x0
    c0000ff4:	1a81c000 	csel	w0, w0, w1, gt
    c0000ff8:	51000400 	sub	w0, w0, #0x1
    c0000ffc:	b9003fe0 	str	w0, [sp, #60]

	if ((spec->flags & FLAG_LEFT) == 0U) {
    c0001000:	f94013e0 	ldr	x0, [sp, #32]
    c0001004:	b9400000 	ldr	w0, [x0]
    c0001008:	12000000 	and	w0, w0, #0x1
    c000100c:	7100001f 	cmp	w0, #0x0
    c0001010:	540000a1 	b.ne	c0001024 <format_char+0x54>  // b.any
		print_repeat(ctx, ' ', pad_len);
    c0001014:	b9403fe2 	ldr	w2, [sp, #60]
    c0001018:	52800401 	mov	w1, #0x20                  	// #32
    c000101c:	f94017e0 	ldr	x0, [sp, #40]
    c0001020:	97fffc27 	bl	c00000bc <print_repeat>
	}
	print_char(ctx, ch);
    c0001024:	39407fe1 	ldrb	w1, [sp, #31]
    c0001028:	f94017e0 	ldr	x0, [sp, #40]
    c000102c:	97fffc11 	bl	c0000070 <print_char>
	if ((spec->flags & FLAG_LEFT) != 0U) {
    c0001030:	f94013e0 	ldr	x0, [sp, #32]
    c0001034:	b9400000 	ldr	w0, [x0]
    c0001038:	12000000 	and	w0, w0, #0x1
    c000103c:	7100001f 	cmp	w0, #0x0
    c0001040:	540000a0 	b.eq	c0001054 <format_char+0x84>  // b.none
		print_repeat(ctx, ' ', pad_len);
    c0001044:	b9403fe2 	ldr	w2, [sp, #60]
    c0001048:	52800401 	mov	w1, #0x20                  	// #32
    c000104c:	f94017e0 	ldr	x0, [sp, #40]
    c0001050:	97fffc1b 	bl	c00000bc <print_repeat>
	}
}
    c0001054:	d503201f 	nop
    c0001058:	a8c47bfd 	ldp	x29, x30, [sp], #64
    c000105c:	d65f03c0 	ret

00000000c0001060 <parse_number>:

static bool parse_number(const char **fmt, int *value)
{
    c0001060:	d10083ff 	sub	sp, sp, #0x20
    c0001064:	f90007e0 	str	x0, [sp, #8]
    c0001068:	f90003e1 	str	x1, [sp]
	bool found = false;
    c000106c:	39007fff 	strb	wzr, [sp, #31]
	int result = 0;
    c0001070:	b9001bff 	str	wzr, [sp, #24]

	while ((**fmt >= '0') && (**fmt <= '9')) {
    c0001074:	14000014 	b	c00010c4 <parse_number+0x64>
		found = true;
    c0001078:	52800020 	mov	w0, #0x1                   	// #1
    c000107c:	39007fe0 	strb	w0, [sp, #31]
		result = result * 10 + (**fmt - '0');
    c0001080:	b9401be1 	ldr	w1, [sp, #24]
    c0001084:	2a0103e0 	mov	w0, w1
    c0001088:	531e7400 	lsl	w0, w0, #2
    c000108c:	0b010000 	add	w0, w0, w1
    c0001090:	531f7800 	lsl	w0, w0, #1
    c0001094:	2a0003e1 	mov	w1, w0
    c0001098:	f94007e0 	ldr	x0, [sp, #8]
    c000109c:	f9400000 	ldr	x0, [x0]
    c00010a0:	39400000 	ldrb	w0, [x0]
    c00010a4:	5100c000 	sub	w0, w0, #0x30
    c00010a8:	0b000020 	add	w0, w1, w0
    c00010ac:	b9001be0 	str	w0, [sp, #24]
		(*fmt)++;
    c00010b0:	f94007e0 	ldr	x0, [sp, #8]
    c00010b4:	f9400000 	ldr	x0, [x0]
    c00010b8:	91000401 	add	x1, x0, #0x1
    c00010bc:	f94007e0 	ldr	x0, [sp, #8]
    c00010c0:	f9000001 	str	x1, [x0]
	while ((**fmt >= '0') && (**fmt <= '9')) {
    c00010c4:	f94007e0 	ldr	x0, [sp, #8]
    c00010c8:	f9400000 	ldr	x0, [x0]
    c00010cc:	39400000 	ldrb	w0, [x0]
    c00010d0:	7100bc1f 	cmp	w0, #0x2f
    c00010d4:	540000c9 	b.ls	c00010ec <parse_number+0x8c>  // b.plast
    c00010d8:	f94007e0 	ldr	x0, [sp, #8]
    c00010dc:	f9400000 	ldr	x0, [x0]
    c00010e0:	39400000 	ldrb	w0, [x0]
    c00010e4:	7100e41f 	cmp	w0, #0x39
    c00010e8:	54fffc89 	b.ls	c0001078 <parse_number+0x18>  // b.plast
	}

	*value = result;
    c00010ec:	f94003e0 	ldr	x0, [sp]
    c00010f0:	b9401be1 	ldr	w1, [sp, #24]
    c00010f4:	b9000001 	str	w1, [x0]
	return found;
    c00010f8:	39407fe0 	ldrb	w0, [sp, #31]
}
    c00010fc:	910083ff 	add	sp, sp, #0x20
    c0001100:	d65f03c0 	ret

00000000c0001104 <parse_format>:

static void parse_format(const char **fmt, struct format_spec *spec, va_list *args)
{
    c0001104:	a9bc7bfd 	stp	x29, x30, [sp, #-64]!
    c0001108:	910003fd 	mov	x29, sp
    c000110c:	f90017e0 	str	x0, [sp, #40]
    c0001110:	f90013e1 	str	x1, [sp, #32]
    c0001114:	f9000fe2 	str	x2, [sp, #24]
	const char *p = *fmt;
    c0001118:	f94017e0 	ldr	x0, [sp, #40]
    c000111c:	f9400000 	ldr	x0, [x0]
    c0001120:	f9001fe0 	str	x0, [sp, #56]
	int value;

	spec->flags = 0U;
    c0001124:	f94013e0 	ldr	x0, [sp, #32]
    c0001128:	b900001f 	str	wzr, [x0]
	spec->width = 0;
    c000112c:	f94013e0 	ldr	x0, [sp, #32]
    c0001130:	b900041f 	str	wzr, [x0, #4]
	spec->precision = -1;
    c0001134:	f94013e0 	ldr	x0, [sp, #32]
    c0001138:	12800001 	mov	w1, #0xffffffff            	// #-1
    c000113c:	b9000801 	str	w1, [x0, #8]
	spec->length = LENGTH_DEFAULT;
    c0001140:	f94013e0 	ldr	x0, [sp, #32]
    c0001144:	b9000c1f 	str	wzr, [x0, #12]
	spec->conv = '\0';
    c0001148:	f94013e0 	ldr	x0, [sp, #32]
    c000114c:	3900401f 	strb	wzr, [x0, #16]

	for (;;) {
		switch (*p) {
    c0001150:	f9401fe0 	ldr	x0, [sp, #56]
    c0001154:	39400000 	ldrb	w0, [x0]
    c0001158:	7100c01f 	cmp	w0, #0x30
    c000115c:	54000680 	b.eq	c000122c <parse_format+0x128>  // b.none
    c0001160:	7100c01f 	cmp	w0, #0x30
    c0001164:	5400076c 	b.gt	c0001250 <parse_format+0x14c>
    c0001168:	7100b41f 	cmp	w0, #0x2d
    c000116c:	54000180 	b.eq	c000119c <parse_format+0x98>  // b.none
    c0001170:	7100b41f 	cmp	w0, #0x2d
    c0001174:	540006ec 	b.gt	c0001250 <parse_format+0x14c>
    c0001178:	7100ac1f 	cmp	w0, #0x2b
    c000117c:	54000220 	b.eq	c00011c0 <parse_format+0xbc>  // b.none
    c0001180:	7100ac1f 	cmp	w0, #0x2b
    c0001184:	5400066c 	b.gt	c0001250 <parse_format+0x14c>
    c0001188:	7100801f 	cmp	w0, #0x20
    c000118c:	540002c0 	b.eq	c00011e4 <parse_format+0xe0>  // b.none
    c0001190:	71008c1f 	cmp	w0, #0x23
    c0001194:	540003a0 	b.eq	c0001208 <parse_format+0x104>  // b.none
		case '-': spec->flags |= FLAG_LEFT; p++; continue;
		case '+': spec->flags |= FLAG_PLUS; p++; continue;
		case ' ': spec->flags |= FLAG_SPACE; p++; continue;
		case '#': spec->flags |= FLAG_ALT; p++; continue;
		case '0': spec->flags |= FLAG_ZERO; p++; continue;
		default: break;
    c0001198:	1400002e 	b	c0001250 <parse_format+0x14c>
		case '-': spec->flags |= FLAG_LEFT; p++; continue;
    c000119c:	f94013e0 	ldr	x0, [sp, #32]
    c00011a0:	b9400000 	ldr	w0, [x0]
    c00011a4:	32000001 	orr	w1, w0, #0x1
    c00011a8:	f94013e0 	ldr	x0, [sp, #32]
    c00011ac:	b9000001 	str	w1, [x0]
    c00011b0:	f9401fe0 	ldr	x0, [sp, #56]
    c00011b4:	91000400 	add	x0, x0, #0x1
    c00011b8:	f9001fe0 	str	x0, [sp, #56]
    c00011bc:	1400002c 	b	c000126c <parse_format+0x168>
		case '+': spec->flags |= FLAG_PLUS; p++; continue;
    c00011c0:	f94013e0 	ldr	x0, [sp, #32]
    c00011c4:	b9400000 	ldr	w0, [x0]
    c00011c8:	321f0001 	orr	w1, w0, #0x2
    c00011cc:	f94013e0 	ldr	x0, [sp, #32]
    c00011d0:	b9000001 	str	w1, [x0]
    c00011d4:	f9401fe0 	ldr	x0, [sp, #56]
    c00011d8:	91000400 	add	x0, x0, #0x1
    c00011dc:	f9001fe0 	str	x0, [sp, #56]
    c00011e0:	14000023 	b	c000126c <parse_format+0x168>
		case ' ': spec->flags |= FLAG_SPACE; p++; continue;
    c00011e4:	f94013e0 	ldr	x0, [sp, #32]
    c00011e8:	b9400000 	ldr	w0, [x0]
    c00011ec:	321e0001 	orr	w1, w0, #0x4
    c00011f0:	f94013e0 	ldr	x0, [sp, #32]
    c00011f4:	b9000001 	str	w1, [x0]
    c00011f8:	f9401fe0 	ldr	x0, [sp, #56]
    c00011fc:	91000400 	add	x0, x0, #0x1
    c0001200:	f9001fe0 	str	x0, [sp, #56]
    c0001204:	1400001a 	b	c000126c <parse_format+0x168>
		case '#': spec->flags |= FLAG_ALT; p++; continue;
    c0001208:	f94013e0 	ldr	x0, [sp, #32]
    c000120c:	b9400000 	ldr	w0, [x0]
    c0001210:	321d0001 	orr	w1, w0, #0x8
    c0001214:	f94013e0 	ldr	x0, [sp, #32]
    c0001218:	b9000001 	str	w1, [x0]
    c000121c:	f9401fe0 	ldr	x0, [sp, #56]
    c0001220:	91000400 	add	x0, x0, #0x1
    c0001224:	f9001fe0 	str	x0, [sp, #56]
    c0001228:	14000011 	b	c000126c <parse_format+0x168>
		case '0': spec->flags |= FLAG_ZERO; p++; continue;
    c000122c:	f94013e0 	ldr	x0, [sp, #32]
    c0001230:	b9400000 	ldr	w0, [x0]
    c0001234:	321c0001 	orr	w1, w0, #0x10
    c0001238:	f94013e0 	ldr	x0, [sp, #32]
    c000123c:	b9000001 	str	w1, [x0]
    c0001240:	f9401fe0 	ldr	x0, [sp, #56]
    c0001244:	91000400 	add	x0, x0, #0x1
    c0001248:	f9001fe0 	str	x0, [sp, #56]
    c000124c:	14000008 	b	c000126c <parse_format+0x168>
		default: break;
    c0001250:	d503201f 	nop
		}
		break;
    c0001254:	d503201f 	nop
	}

	if (*p == '*') {
    c0001258:	f9401fe0 	ldr	x0, [sp, #56]
    c000125c:	39400000 	ldrb	w0, [x0]
    c0001260:	7100a81f 	cmp	w0, #0x2a
    c0001264:	54000661 	b.ne	c0001330 <parse_format+0x22c>  // b.any
    c0001268:	14000002 	b	c0001270 <parse_format+0x16c>
		switch (*p) {
    c000126c:	17ffffb9 	b	c0001150 <parse_format+0x4c>
		spec->width = va_arg(*args, int);
    c0001270:	f9400fe0 	ldr	x0, [sp, #24]
    c0001274:	b9401801 	ldr	w1, [x0, #24]
    c0001278:	f9400fe0 	ldr	x0, [sp, #24]
    c000127c:	f9400000 	ldr	x0, [x0]
    c0001280:	7100003f 	cmp	w1, #0x0
    c0001284:	540000cb 	b.lt	c000129c <parse_format+0x198>  // b.tstop
    c0001288:	91002c01 	add	x1, x0, #0xb
    c000128c:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c0001290:	f9400fe1 	ldr	x1, [sp, #24]
    c0001294:	f9000022 	str	x2, [x1]
    c0001298:	14000011 	b	c00012dc <parse_format+0x1d8>
    c000129c:	11002023 	add	w3, w1, #0x8
    c00012a0:	f9400fe2 	ldr	x2, [sp, #24]
    c00012a4:	b9001843 	str	w3, [x2, #24]
    c00012a8:	f9400fe2 	ldr	x2, [sp, #24]
    c00012ac:	b9401842 	ldr	w2, [x2, #24]
    c00012b0:	7100005f 	cmp	w2, #0x0
    c00012b4:	540000cd 	b.le	c00012cc <parse_format+0x1c8>
    c00012b8:	91002c01 	add	x1, x0, #0xb
    c00012bc:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c00012c0:	f9400fe1 	ldr	x1, [sp, #24]
    c00012c4:	f9000022 	str	x2, [x1]
    c00012c8:	14000005 	b	c00012dc <parse_format+0x1d8>
    c00012cc:	f9400fe0 	ldr	x0, [sp, #24]
    c00012d0:	f9400402 	ldr	x2, [x0, #8]
    c00012d4:	93407c20 	sxtw	x0, w1
    c00012d8:	8b000040 	add	x0, x2, x0
    c00012dc:	b9400001 	ldr	w1, [x0]
    c00012e0:	f94013e0 	ldr	x0, [sp, #32]
    c00012e4:	b9000401 	str	w1, [x0, #4]
		if (spec->width < 0) {
    c00012e8:	f94013e0 	ldr	x0, [sp, #32]
    c00012ec:	b9400400 	ldr	w0, [x0, #4]
    c00012f0:	7100001f 	cmp	w0, #0x0
    c00012f4:	5400016a 	b.ge	c0001320 <parse_format+0x21c>  // b.tcont
			spec->flags |= FLAG_LEFT;
    c00012f8:	f94013e0 	ldr	x0, [sp, #32]
    c00012fc:	b9400000 	ldr	w0, [x0]
    c0001300:	32000001 	orr	w1, w0, #0x1
    c0001304:	f94013e0 	ldr	x0, [sp, #32]
    c0001308:	b9000001 	str	w1, [x0]
			spec->width = -spec->width;
    c000130c:	f94013e0 	ldr	x0, [sp, #32]
    c0001310:	b9400400 	ldr	w0, [x0, #4]
    c0001314:	4b0003e1 	neg	w1, w0
    c0001318:	f94013e0 	ldr	x0, [sp, #32]
    c000131c:	b9000401 	str	w1, [x0, #4]
		}
		p++;
    c0001320:	f9401fe0 	ldr	x0, [sp, #56]
    c0001324:	91000400 	add	x0, x0, #0x1
    c0001328:	f9001fe0 	str	x0, [sp, #56]
    c000132c:	1400000b 	b	c0001358 <parse_format+0x254>
	} else if (parse_number(&p, &value)) {
    c0001330:	9100d3e1 	add	x1, sp, #0x34
    c0001334:	9100e3e0 	add	x0, sp, #0x38
    c0001338:	97ffff4a 	bl	c0001060 <parse_number>
    c000133c:	12001c00 	and	w0, w0, #0xff
    c0001340:	12000000 	and	w0, w0, #0x1
    c0001344:	7100001f 	cmp	w0, #0x0
    c0001348:	54000080 	b.eq	c0001358 <parse_format+0x254>  // b.none
		spec->width = value;
    c000134c:	b94037e1 	ldr	w1, [sp, #52]
    c0001350:	f94013e0 	ldr	x0, [sp, #32]
    c0001354:	b9000401 	str	w1, [x0, #4]
	}

	if (*p == '.') {
    c0001358:	f9401fe0 	ldr	x0, [sp, #56]
    c000135c:	39400000 	ldrb	w0, [x0]
    c0001360:	7100b81f 	cmp	w0, #0x2e
    c0001364:	540006e1 	b.ne	c0001440 <parse_format+0x33c>  // b.any
		p++;
    c0001368:	f9401fe0 	ldr	x0, [sp, #56]
    c000136c:	91000400 	add	x0, x0, #0x1
    c0001370:	f9001fe0 	str	x0, [sp, #56]
		if (*p == '*') {
    c0001374:	f9401fe0 	ldr	x0, [sp, #56]
    c0001378:	39400000 	ldrb	w0, [x0]
    c000137c:	7100a81f 	cmp	w0, #0x2a
    c0001380:	54000541 	b.ne	c0001428 <parse_format+0x324>  // b.any
			spec->precision = va_arg(*args, int);
    c0001384:	f9400fe0 	ldr	x0, [sp, #24]
    c0001388:	b9401801 	ldr	w1, [x0, #24]
    c000138c:	f9400fe0 	ldr	x0, [sp, #24]
    c0001390:	f9400000 	ldr	x0, [x0]
    c0001394:	7100003f 	cmp	w1, #0x0
    c0001398:	540000cb 	b.lt	c00013b0 <parse_format+0x2ac>  // b.tstop
    c000139c:	91002c01 	add	x1, x0, #0xb
    c00013a0:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c00013a4:	f9400fe1 	ldr	x1, [sp, #24]
    c00013a8:	f9000022 	str	x2, [x1]
    c00013ac:	14000011 	b	c00013f0 <parse_format+0x2ec>
    c00013b0:	11002023 	add	w3, w1, #0x8
    c00013b4:	f9400fe2 	ldr	x2, [sp, #24]
    c00013b8:	b9001843 	str	w3, [x2, #24]
    c00013bc:	f9400fe2 	ldr	x2, [sp, #24]
    c00013c0:	b9401842 	ldr	w2, [x2, #24]
    c00013c4:	7100005f 	cmp	w2, #0x0
    c00013c8:	540000cd 	b.le	c00013e0 <parse_format+0x2dc>
    c00013cc:	91002c01 	add	x1, x0, #0xb
    c00013d0:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c00013d4:	f9400fe1 	ldr	x1, [sp, #24]
    c00013d8:	f9000022 	str	x2, [x1]
    c00013dc:	14000005 	b	c00013f0 <parse_format+0x2ec>
    c00013e0:	f9400fe0 	ldr	x0, [sp, #24]
    c00013e4:	f9400402 	ldr	x2, [x0, #8]
    c00013e8:	93407c20 	sxtw	x0, w1
    c00013ec:	8b000040 	add	x0, x2, x0
    c00013f0:	b9400001 	ldr	w1, [x0]
    c00013f4:	f94013e0 	ldr	x0, [sp, #32]
    c00013f8:	b9000801 	str	w1, [x0, #8]
			if (spec->precision < 0) {
    c00013fc:	f94013e0 	ldr	x0, [sp, #32]
    c0001400:	b9400800 	ldr	w0, [x0, #8]
    c0001404:	7100001f 	cmp	w0, #0x0
    c0001408:	5400008a 	b.ge	c0001418 <parse_format+0x314>  // b.tcont
				spec->precision = -1;
    c000140c:	f94013e0 	ldr	x0, [sp, #32]
    c0001410:	12800001 	mov	w1, #0xffffffff            	// #-1
    c0001414:	b9000801 	str	w1, [x0, #8]
			}
			p++;
    c0001418:	f9401fe0 	ldr	x0, [sp, #56]
    c000141c:	91000400 	add	x0, x0, #0x1
    c0001420:	f9001fe0 	str	x0, [sp, #56]
    c0001424:	14000007 	b	c0001440 <parse_format+0x33c>
		} else {
			parse_number(&p, &value);
    c0001428:	9100d3e1 	add	x1, sp, #0x34
    c000142c:	9100e3e0 	add	x0, sp, #0x38
    c0001430:	97ffff0c 	bl	c0001060 <parse_number>
			spec->precision = value;
    c0001434:	b94037e1 	ldr	w1, [sp, #52]
    c0001438:	f94013e0 	ldr	x0, [sp, #32]
    c000143c:	b9000801 	str	w1, [x0, #8]
		}
	}

	if ((*p == 'h') && (*(p + 1) == 'h')) {
    c0001440:	f9401fe0 	ldr	x0, [sp, #56]
    c0001444:	39400000 	ldrb	w0, [x0]
    c0001448:	7101a01f 	cmp	w0, #0x68
    c000144c:	540001a1 	b.ne	c0001480 <parse_format+0x37c>  // b.any
    c0001450:	f9401fe0 	ldr	x0, [sp, #56]
    c0001454:	91000400 	add	x0, x0, #0x1
    c0001458:	39400000 	ldrb	w0, [x0]
    c000145c:	7101a01f 	cmp	w0, #0x68
    c0001460:	54000101 	b.ne	c0001480 <parse_format+0x37c>  // b.any
		spec->length = LENGTH_HH;
    c0001464:	f94013e0 	ldr	x0, [sp, #32]
    c0001468:	52800021 	mov	w1, #0x1                   	// #1
    c000146c:	b9000c01 	str	w1, [x0, #12]
		p += 2;
    c0001470:	f9401fe0 	ldr	x0, [sp, #56]
    c0001474:	91000800 	add	x0, x0, #0x2
    c0001478:	f9001fe0 	str	x0, [sp, #56]
    c000147c:	14000047 	b	c0001598 <parse_format+0x494>
	} else if (*p == 'h') {
    c0001480:	f9401fe0 	ldr	x0, [sp, #56]
    c0001484:	39400000 	ldrb	w0, [x0]
    c0001488:	7101a01f 	cmp	w0, #0x68
    c000148c:	54000101 	b.ne	c00014ac <parse_format+0x3a8>  // b.any
		spec->length = LENGTH_H;
    c0001490:	f94013e0 	ldr	x0, [sp, #32]
    c0001494:	52800041 	mov	w1, #0x2                   	// #2
    c0001498:	b9000c01 	str	w1, [x0, #12]
		p++;
    c000149c:	f9401fe0 	ldr	x0, [sp, #56]
    c00014a0:	91000400 	add	x0, x0, #0x1
    c00014a4:	f9001fe0 	str	x0, [sp, #56]
    c00014a8:	1400003c 	b	c0001598 <parse_format+0x494>
	} else if ((*p == 'l') && (*(p + 1) == 'l')) {
    c00014ac:	f9401fe0 	ldr	x0, [sp, #56]
    c00014b0:	39400000 	ldrb	w0, [x0]
    c00014b4:	7101b01f 	cmp	w0, #0x6c
    c00014b8:	540001a1 	b.ne	c00014ec <parse_format+0x3e8>  // b.any
    c00014bc:	f9401fe0 	ldr	x0, [sp, #56]
    c00014c0:	91000400 	add	x0, x0, #0x1
    c00014c4:	39400000 	ldrb	w0, [x0]
    c00014c8:	7101b01f 	cmp	w0, #0x6c
    c00014cc:	54000101 	b.ne	c00014ec <parse_format+0x3e8>  // b.any
		spec->length = LENGTH_LL;
    c00014d0:	f94013e0 	ldr	x0, [sp, #32]
    c00014d4:	52800081 	mov	w1, #0x4                   	// #4
    c00014d8:	b9000c01 	str	w1, [x0, #12]
		p += 2;
    c00014dc:	f9401fe0 	ldr	x0, [sp, #56]
    c00014e0:	91000800 	add	x0, x0, #0x2
    c00014e4:	f9001fe0 	str	x0, [sp, #56]
    c00014e8:	1400002c 	b	c0001598 <parse_format+0x494>
	} else if (*p == 'l') {
    c00014ec:	f9401fe0 	ldr	x0, [sp, #56]
    c00014f0:	39400000 	ldrb	w0, [x0]
    c00014f4:	7101b01f 	cmp	w0, #0x6c
    c00014f8:	54000101 	b.ne	c0001518 <parse_format+0x414>  // b.any
		spec->length = LENGTH_L;
    c00014fc:	f94013e0 	ldr	x0, [sp, #32]
    c0001500:	52800061 	mov	w1, #0x3                   	// #3
    c0001504:	b9000c01 	str	w1, [x0, #12]
		p++;
    c0001508:	f9401fe0 	ldr	x0, [sp, #56]
    c000150c:	91000400 	add	x0, x0, #0x1
    c0001510:	f9001fe0 	str	x0, [sp, #56]
    c0001514:	14000021 	b	c0001598 <parse_format+0x494>
	} else if (*p == 'z') {
    c0001518:	f9401fe0 	ldr	x0, [sp, #56]
    c000151c:	39400000 	ldrb	w0, [x0]
    c0001520:	7101e81f 	cmp	w0, #0x7a
    c0001524:	54000101 	b.ne	c0001544 <parse_format+0x440>  // b.any
		spec->length = LENGTH_Z;
    c0001528:	f94013e0 	ldr	x0, [sp, #32]
    c000152c:	528000a1 	mov	w1, #0x5                   	// #5
    c0001530:	b9000c01 	str	w1, [x0, #12]
		p++;
    c0001534:	f9401fe0 	ldr	x0, [sp, #56]
    c0001538:	91000400 	add	x0, x0, #0x1
    c000153c:	f9001fe0 	str	x0, [sp, #56]
    c0001540:	14000016 	b	c0001598 <parse_format+0x494>
	} else if (*p == 't') {
    c0001544:	f9401fe0 	ldr	x0, [sp, #56]
    c0001548:	39400000 	ldrb	w0, [x0]
    c000154c:	7101d01f 	cmp	w0, #0x74
    c0001550:	54000101 	b.ne	c0001570 <parse_format+0x46c>  // b.any
		spec->length = LENGTH_T;
    c0001554:	f94013e0 	ldr	x0, [sp, #32]
    c0001558:	528000c1 	mov	w1, #0x6                   	// #6
    c000155c:	b9000c01 	str	w1, [x0, #12]
		p++;
    c0001560:	f9401fe0 	ldr	x0, [sp, #56]
    c0001564:	91000400 	add	x0, x0, #0x1
    c0001568:	f9001fe0 	str	x0, [sp, #56]
    c000156c:	1400000b 	b	c0001598 <parse_format+0x494>
	} else if (*p == 'j') {
    c0001570:	f9401fe0 	ldr	x0, [sp, #56]
    c0001574:	39400000 	ldrb	w0, [x0]
    c0001578:	7101a81f 	cmp	w0, #0x6a
    c000157c:	540000e1 	b.ne	c0001598 <parse_format+0x494>  // b.any
		spec->length = LENGTH_J;
    c0001580:	f94013e0 	ldr	x0, [sp, #32]
    c0001584:	528000e1 	mov	w1, #0x7                   	// #7
    c0001588:	b9000c01 	str	w1, [x0, #12]
		p++;
    c000158c:	f9401fe0 	ldr	x0, [sp, #56]
    c0001590:	91000400 	add	x0, x0, #0x1
    c0001594:	f9001fe0 	str	x0, [sp, #56]
	}

	spec->conv = *p;
    c0001598:	f9401fe0 	ldr	x0, [sp, #56]
    c000159c:	39400001 	ldrb	w1, [x0]
    c00015a0:	f94013e0 	ldr	x0, [sp, #32]
    c00015a4:	39004001 	strb	w1, [x0, #16]
	if ((*p >= 'A') && (*p <= 'Z')) {
    c00015a8:	f9401fe0 	ldr	x0, [sp, #56]
    c00015ac:	39400000 	ldrb	w0, [x0]
    c00015b0:	7101001f 	cmp	w0, #0x40
    c00015b4:	54000149 	b.ls	c00015dc <parse_format+0x4d8>  // b.plast
    c00015b8:	f9401fe0 	ldr	x0, [sp, #56]
    c00015bc:	39400000 	ldrb	w0, [x0]
    c00015c0:	7101681f 	cmp	w0, #0x5a
    c00015c4:	540000c8 	b.hi	c00015dc <parse_format+0x4d8>  // b.pmore
		spec->flags |= FLAG_UPPER;
    c00015c8:	f94013e0 	ldr	x0, [sp, #32]
    c00015cc:	b9400000 	ldr	w0, [x0]
    c00015d0:	321b0001 	orr	w1, w0, #0x20
    c00015d4:	f94013e0 	ldr	x0, [sp, #32]
    c00015d8:	b9000001 	str	w1, [x0]
	}
	if (*p != '\0') {
    c00015dc:	f9401fe0 	ldr	x0, [sp, #56]
    c00015e0:	39400000 	ldrb	w0, [x0]
    c00015e4:	7100001f 	cmp	w0, #0x0
    c00015e8:	54000080 	b.eq	c00015f8 <parse_format+0x4f4>  // b.none
		p++;
    c00015ec:	f9401fe0 	ldr	x0, [sp, #56]
    c00015f0:	91000400 	add	x0, x0, #0x1
    c00015f4:	f9001fe0 	str	x0, [sp, #56]
	}
	*fmt = p;
    c00015f8:	f9401fe1 	ldr	x1, [sp, #56]
    c00015fc:	f94017e0 	ldr	x0, [sp, #40]
    c0001600:	f9000001 	str	x1, [x0]
}
    c0001604:	d503201f 	nop
    c0001608:	a8c47bfd 	ldp	x29, x30, [sp], #64
    c000160c:	d65f03c0 	ret

00000000c0001610 <debug_vprintf>:

int debug_vprintf(const char *fmt, va_list args)
{
    c0001610:	a9b87bfd 	stp	x29, x30, [sp, #-128]!
    c0001614:	910003fd 	mov	x29, sp
    c0001618:	f9000bf3 	str	x19, [sp, #16]
    c000161c:	f90017e0 	str	x0, [sp, #40]
    c0001620:	aa0103f3 	mov	x19, x1
	struct print_ctx ctx = { 0 };
    c0001624:	b9006bff 	str	wzr, [sp, #104]
	va_list ap;

	if (fmt == NULL) {
    c0001628:	f94017e0 	ldr	x0, [sp, #40]
    c000162c:	f100001f 	cmp	x0, #0x0
    c0001630:	54000061 	b.ne	c000163c <debug_vprintf+0x2c>  // b.any
		return 0;
    c0001634:	52800000 	mov	w0, #0x0                   	// #0
    c0001638:	14000175 	b	c0001c0c <debug_vprintf+0x5fc>
	}
	spinlock_lock(&debug_console_lock);
    c000163c:	d0000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c0001640:	910d0000 	add	x0, x0, #0x340
    c0001644:	9400056f 	bl	c0002c00 <spinlock_lock>
	va_copy(ap, args);
    c0001648:	f9400260 	ldr	x0, [x19]
    c000164c:	f90027e0 	str	x0, [sp, #72]
    c0001650:	f9400660 	ldr	x0, [x19, #8]
    c0001654:	f9002be0 	str	x0, [sp, #80]
    c0001658:	f9400a60 	ldr	x0, [x19, #16]
    c000165c:	f9002fe0 	str	x0, [sp, #88]
    c0001660:	f9400e60 	ldr	x0, [x19, #24]
    c0001664:	f90033e0 	str	x0, [sp, #96]
	while (*fmt != '\0') {
    c0001668:	14000161 	b	c0001bec <debug_vprintf+0x5dc>
		struct format_spec spec;
		uint64_t uvalue;
		int64_t svalue;

		if (*fmt != '%') {
    c000166c:	f94017e0 	ldr	x0, [sp, #40]
    c0001670:	39400000 	ldrb	w0, [x0]
    c0001674:	7100941f 	cmp	w0, #0x25
    c0001678:	54000100 	b.eq	c0001698 <debug_vprintf+0x88>  // b.none
			print_char(&ctx, *fmt++);
    c000167c:	f94017e0 	ldr	x0, [sp, #40]
    c0001680:	91000401 	add	x1, x0, #0x1
    c0001684:	f90017e1 	str	x1, [sp, #40]
    c0001688:	39400001 	ldrb	w1, [x0]
    c000168c:	9101a3e0 	add	x0, sp, #0x68
    c0001690:	97fffa78 	bl	c0000070 <print_char>
			continue;
    c0001694:	14000156 	b	c0001bec <debug_vprintf+0x5dc>
		}

		fmt++;
    c0001698:	f94017e0 	ldr	x0, [sp, #40]
    c000169c:	91000400 	add	x0, x0, #0x1
    c00016a0:	f90017e0 	str	x0, [sp, #40]
		if (*fmt == '%') {
    c00016a4:	f94017e0 	ldr	x0, [sp, #40]
    c00016a8:	39400000 	ldrb	w0, [x0]
    c00016ac:	7100941f 	cmp	w0, #0x25
    c00016b0:	54000101 	b.ne	c00016d0 <debug_vprintf+0xc0>  // b.any
			print_char(&ctx, *fmt++);
    c00016b4:	f94017e0 	ldr	x0, [sp, #40]
    c00016b8:	91000401 	add	x1, x0, #0x1
    c00016bc:	f90017e1 	str	x1, [sp, #40]
    c00016c0:	39400001 	ldrb	w1, [x0]
    c00016c4:	9101a3e0 	add	x0, sp, #0x68
    c00016c8:	97fffa6a 	bl	c0000070 <print_char>
			continue;
    c00016cc:	14000148 	b	c0001bec <debug_vprintf+0x5dc>
		}

		parse_format(&fmt, &spec, &ap);
    c00016d0:	910123e2 	add	x2, sp, #0x48
    c00016d4:	9100c3e1 	add	x1, sp, #0x30
    c00016d8:	9100a3e0 	add	x0, sp, #0x28
    c00016dc:	97fffe8a 	bl	c0001104 <parse_format>
		switch (spec.conv) {
    c00016e0:	394103e0 	ldrb	w0, [sp, #64]
    c00016e4:	7101e01f 	cmp	w0, #0x78
    c00016e8:	540009c0 	b.eq	c0001820 <debug_vprintf+0x210>  // b.none
    c00016ec:	7101e01f 	cmp	w0, #0x78
    c00016f0:	540026ac 	b.gt	c0001bc4 <debug_vprintf+0x5b4>
    c00016f4:	7101d41f 	cmp	w0, #0x75
    c00016f8:	540006c0 	b.eq	c00017d0 <debug_vprintf+0x1c0>  // b.none
    c00016fc:	7101d41f 	cmp	w0, #0x75
    c0001700:	5400262c 	b.gt	c0001bc4 <debug_vprintf+0x5b4>
    c0001704:	7101cc1f 	cmp	w0, #0x73
    c0001708:	54000d40 	b.eq	c00018b0 <debug_vprintf+0x2a0>  // b.none
    c000170c:	7101cc1f 	cmp	w0, #0x73
    c0001710:	540025ac 	b.gt	c0001bc4 <debug_vprintf+0x5b4>
    c0001714:	7101c01f 	cmp	w0, #0x70
    c0001718:	54000fe0 	b.eq	c0001914 <debug_vprintf+0x304>  // b.none
    c000171c:	7101c01f 	cmp	w0, #0x70
    c0001720:	5400252c 	b.gt	c0001bc4 <debug_vprintf+0x5b4>
    c0001724:	7101bc1f 	cmp	w0, #0x6f
    c0001728:	54000680 	b.eq	c00017f8 <debug_vprintf+0x1e8>  // b.none
    c000172c:	7101bc1f 	cmp	w0, #0x6f
    c0001730:	540024ac 	b.gt	c0001bc4 <debug_vprintf+0x5b4>
    c0001734:	7101b81f 	cmp	w0, #0x6e
    c0001738:	54001300 	b.eq	c0001998 <debug_vprintf+0x388>  // b.none
    c000173c:	7101b81f 	cmp	w0, #0x6e
    c0001740:	5400242c 	b.gt	c0001bc4 <debug_vprintf+0x5b4>
    c0001744:	7101a41f 	cmp	w0, #0x69
    c0001748:	54000180 	b.eq	c0001778 <debug_vprintf+0x168>  // b.none
    c000174c:	7101a41f 	cmp	w0, #0x69
    c0001750:	540023ac 	b.gt	c0001bc4 <debug_vprintf+0x5b4>
    c0001754:	7101901f 	cmp	w0, #0x64
    c0001758:	54000100 	b.eq	c0001778 <debug_vprintf+0x168>  // b.none
    c000175c:	7101901f 	cmp	w0, #0x64
    c0001760:	5400232c 	b.gt	c0001bc4 <debug_vprintf+0x5b4>
    c0001764:	7101601f 	cmp	w0, #0x58
    c0001768:	540005c0 	b.eq	c0001820 <debug_vprintf+0x210>  // b.none
    c000176c:	71018c1f 	cmp	w0, #0x63
    c0001770:	540006c0 	b.eq	c0001848 <debug_vprintf+0x238>  // b.none
    c0001774:	14000114 	b	c0001bc4 <debug_vprintf+0x5b4>
		case 'd':
		case 'i':
			svalue = get_signed_arg(&ap, spec.length);
    c0001778:	b9403fe1 	ldr	w1, [sp, #60]
    c000177c:	910123e0 	add	x0, sp, #0x48
    c0001780:	97fffb87 	bl	c000059c <get_signed_arg>
    c0001784:	f9003fe0 	str	x0, [sp, #120]
			uvalue = (svalue < 0) ? (uint64_t)(-(svalue + 1)) + 1U : (uint64_t)svalue;
    c0001788:	f9403fe0 	ldr	x0, [sp, #120]
    c000178c:	f100001f 	cmp	x0, #0x0
    c0001790:	5400008a 	b.ge	c00017a0 <debug_vprintf+0x190>  // b.tcont
    c0001794:	f9403fe0 	ldr	x0, [sp, #120]
    c0001798:	cb0003e0 	neg	x0, x0
    c000179c:	14000002 	b	c00017a4 <debug_vprintf+0x194>
    c00017a0:	f9403fe0 	ldr	x0, [sp, #120]
    c00017a4:	f9003be0 	str	x0, [sp, #112]
			format_integer(&ctx, &spec, uvalue, svalue < 0, 10U);
    c00017a8:	f9403fe0 	ldr	x0, [sp, #120]
    c00017ac:	d37ffc00 	lsr	x0, x0, #63
    c00017b0:	12001c02 	and	w2, w0, #0xff
    c00017b4:	9100c3e1 	add	x1, sp, #0x30
    c00017b8:	9101a3e0 	add	x0, sp, #0x68
    c00017bc:	52800144 	mov	w4, #0xa                   	// #10
    c00017c0:	2a0203e3 	mov	w3, w2
    c00017c4:	f9403be2 	ldr	x2, [sp, #112]
    c00017c8:	97fffcc9 	bl	c0000aec <format_integer>
			break;
    c00017cc:	14000108 	b	c0001bec <debug_vprintf+0x5dc>
		case 'u':
			format_integer(&ctx, &spec, get_unsigned_arg(&ap, spec.length), false, 10U);
    c00017d0:	b9403fe1 	ldr	w1, [sp, #60]
    c00017d4:	910123e0 	add	x0, sp, #0x48
    c00017d8:	97fffa5b 	bl	c0000144 <get_unsigned_arg>
    c00017dc:	aa0003e2 	mov	x2, x0
    c00017e0:	9100c3e1 	add	x1, sp, #0x30
    c00017e4:	9101a3e0 	add	x0, sp, #0x68
    c00017e8:	52800144 	mov	w4, #0xa                   	// #10
    c00017ec:	52800003 	mov	w3, #0x0                   	// #0
    c00017f0:	97fffcbf 	bl	c0000aec <format_integer>
			break;
    c00017f4:	140000fe 	b	c0001bec <debug_vprintf+0x5dc>
		case 'o':
			format_integer(&ctx, &spec, get_unsigned_arg(&ap, spec.length), false, 8U);
    c00017f8:	b9403fe1 	ldr	w1, [sp, #60]
    c00017fc:	910123e0 	add	x0, sp, #0x48
    c0001800:	97fffa51 	bl	c0000144 <get_unsigned_arg>
    c0001804:	aa0003e2 	mov	x2, x0
    c0001808:	9100c3e1 	add	x1, sp, #0x30
    c000180c:	9101a3e0 	add	x0, sp, #0x68
    c0001810:	52800104 	mov	w4, #0x8                   	// #8
    c0001814:	52800003 	mov	w3, #0x0                   	// #0
    c0001818:	97fffcb5 	bl	c0000aec <format_integer>
			break;
    c000181c:	140000f4 	b	c0001bec <debug_vprintf+0x5dc>
		case 'x':
		case 'X':
			format_integer(&ctx, &spec, get_unsigned_arg(&ap, spec.length), false, 16U);
    c0001820:	b9403fe1 	ldr	w1, [sp, #60]
    c0001824:	910123e0 	add	x0, sp, #0x48
    c0001828:	97fffa47 	bl	c0000144 <get_unsigned_arg>
    c000182c:	aa0003e2 	mov	x2, x0
    c0001830:	9100c3e1 	add	x1, sp, #0x30
    c0001834:	9101a3e0 	add	x0, sp, #0x68
    c0001838:	52800204 	mov	w4, #0x10                  	// #16
    c000183c:	52800003 	mov	w3, #0x0                   	// #0
    c0001840:	97fffcab 	bl	c0000aec <format_integer>
			break;
    c0001844:	140000ea 	b	c0001bec <debug_vprintf+0x5dc>
		case 'c':
			format_char(&ctx, &spec, (char)va_arg(ap, int));
    c0001848:	b94063e1 	ldr	w1, [sp, #96]
    c000184c:	f94027e0 	ldr	x0, [sp, #72]
    c0001850:	7100003f 	cmp	w1, #0x0
    c0001854:	540000ab 	b.lt	c0001868 <debug_vprintf+0x258>  // b.tstop
    c0001858:	91002c01 	add	x1, x0, #0xb
    c000185c:	927df021 	and	x1, x1, #0xfffffffffffffff8
    c0001860:	f90027e1 	str	x1, [sp, #72]
    c0001864:	1400000d 	b	c0001898 <debug_vprintf+0x288>
    c0001868:	11002022 	add	w2, w1, #0x8
    c000186c:	b90063e2 	str	w2, [sp, #96]
    c0001870:	b94063e2 	ldr	w2, [sp, #96]
    c0001874:	7100005f 	cmp	w2, #0x0
    c0001878:	540000ad 	b.le	c000188c <debug_vprintf+0x27c>
    c000187c:	91002c01 	add	x1, x0, #0xb
    c0001880:	927df021 	and	x1, x1, #0xfffffffffffffff8
    c0001884:	f90027e1 	str	x1, [sp, #72]
    c0001888:	14000004 	b	c0001898 <debug_vprintf+0x288>
    c000188c:	f9402be2 	ldr	x2, [sp, #80]
    c0001890:	93407c20 	sxtw	x0, w1
    c0001894:	8b000040 	add	x0, x2, x0
    c0001898:	b9400000 	ldr	w0, [x0]
    c000189c:	12001c02 	and	w2, w0, #0xff
    c00018a0:	9100c3e1 	add	x1, sp, #0x30
    c00018a4:	9101a3e0 	add	x0, sp, #0x68
    c00018a8:	97fffdca 	bl	c0000fd0 <format_char>
			break;
    c00018ac:	140000d0 	b	c0001bec <debug_vprintf+0x5dc>
		case 's':
			format_string(&ctx, &spec, va_arg(ap, const char *));
    c00018b0:	b94063e1 	ldr	w1, [sp, #96]
    c00018b4:	f94027e0 	ldr	x0, [sp, #72]
    c00018b8:	7100003f 	cmp	w1, #0x0
    c00018bc:	540000ab 	b.lt	c00018d0 <debug_vprintf+0x2c0>  // b.tstop
    c00018c0:	91003c01 	add	x1, x0, #0xf
    c00018c4:	927df021 	and	x1, x1, #0xfffffffffffffff8
    c00018c8:	f90027e1 	str	x1, [sp, #72]
    c00018cc:	1400000d 	b	c0001900 <debug_vprintf+0x2f0>
    c00018d0:	11002022 	add	w2, w1, #0x8
    c00018d4:	b90063e2 	str	w2, [sp, #96]
    c00018d8:	b94063e2 	ldr	w2, [sp, #96]
    c00018dc:	7100005f 	cmp	w2, #0x0
    c00018e0:	540000ad 	b.le	c00018f4 <debug_vprintf+0x2e4>
    c00018e4:	91003c01 	add	x1, x0, #0xf
    c00018e8:	927df021 	and	x1, x1, #0xfffffffffffffff8
    c00018ec:	f90027e1 	str	x1, [sp, #72]
    c00018f0:	14000004 	b	c0001900 <debug_vprintf+0x2f0>
    c00018f4:	f9402be2 	ldr	x2, [sp, #80]
    c00018f8:	93407c20 	sxtw	x0, w1
    c00018fc:	8b000040 	add	x0, x2, x0
    c0001900:	f9400002 	ldr	x2, [x0]
    c0001904:	9100c3e1 	add	x1, sp, #0x30
    c0001908:	9101a3e0 	add	x0, sp, #0x68
    c000190c:	97fffd70 	bl	c0000ecc <format_string>
			break;
    c0001910:	140000b7 	b	c0001bec <debug_vprintf+0x5dc>
		case 'p':
			spec.flags |= FLAG_ALT;
    c0001914:	b94033e0 	ldr	w0, [sp, #48]
    c0001918:	321d0000 	orr	w0, w0, #0x8
    c000191c:	b90033e0 	str	w0, [sp, #48]
			spec.length = LENGTH_LL;
    c0001920:	52800080 	mov	w0, #0x4                   	// #4
    c0001924:	b9003fe0 	str	w0, [sp, #60]
			format_integer(&ctx, &spec, (uintptr_t)va_arg(ap, void *), false, 16U);
    c0001928:	b94063e1 	ldr	w1, [sp, #96]
    c000192c:	f94027e0 	ldr	x0, [sp, #72]
    c0001930:	7100003f 	cmp	w1, #0x0
    c0001934:	540000ab 	b.lt	c0001948 <debug_vprintf+0x338>  // b.tstop
    c0001938:	91003c01 	add	x1, x0, #0xf
    c000193c:	927df021 	and	x1, x1, #0xfffffffffffffff8
    c0001940:	f90027e1 	str	x1, [sp, #72]
    c0001944:	1400000d 	b	c0001978 <debug_vprintf+0x368>
    c0001948:	11002022 	add	w2, w1, #0x8
    c000194c:	b90063e2 	str	w2, [sp, #96]
    c0001950:	b94063e2 	ldr	w2, [sp, #96]
    c0001954:	7100005f 	cmp	w2, #0x0
    c0001958:	540000ad 	b.le	c000196c <debug_vprintf+0x35c>
    c000195c:	91003c01 	add	x1, x0, #0xf
    c0001960:	927df021 	and	x1, x1, #0xfffffffffffffff8
    c0001964:	f90027e1 	str	x1, [sp, #72]
    c0001968:	14000004 	b	c0001978 <debug_vprintf+0x368>
    c000196c:	f9402be2 	ldr	x2, [sp, #80]
    c0001970:	93407c20 	sxtw	x0, w1
    c0001974:	8b000040 	add	x0, x2, x0
    c0001978:	f9400000 	ldr	x0, [x0]
    c000197c:	aa0003e2 	mov	x2, x0
    c0001980:	9100c3e1 	add	x1, sp, #0x30
    c0001984:	9101a3e0 	add	x0, sp, #0x68
    c0001988:	52800204 	mov	w4, #0x10                  	// #16
    c000198c:	52800003 	mov	w3, #0x0                   	// #0
    c0001990:	97fffc57 	bl	c0000aec <format_integer>
			break;
    c0001994:	14000096 	b	c0001bec <debug_vprintf+0x5dc>
		case 'n':
			switch (spec.length) {
    c0001998:	b9403fe0 	ldr	w0, [sp, #60]
    c000199c:	7100101f 	cmp	w0, #0x4
    c00019a0:	54000ae0 	b.eq	c0001afc <debug_vprintf+0x4ec>  // b.none
    c00019a4:	7100101f 	cmp	w0, #0x4
    c00019a8:	54000dcc 	b.gt	c0001b60 <debug_vprintf+0x550>
    c00019ac:	71000c1f 	cmp	w0, #0x3
    c00019b0:	54000740 	b.eq	c0001a98 <debug_vprintf+0x488>  // b.none
    c00019b4:	71000c1f 	cmp	w0, #0x3
    c00019b8:	54000d4c 	b.gt	c0001b60 <debug_vprintf+0x550>
    c00019bc:	7100041f 	cmp	w0, #0x1
    c00019c0:	54000080 	b.eq	c00019d0 <debug_vprintf+0x3c0>  // b.none
    c00019c4:	7100081f 	cmp	w0, #0x2
    c00019c8:	54000360 	b.eq	c0001a34 <debug_vprintf+0x424>  // b.none
    c00019cc:	14000065 	b	c0001b60 <debug_vprintf+0x550>
			case LENGTH_HH:
				*va_arg(ap, signed char *) = (signed char)ctx.count;
    c00019d0:	b9406be3 	ldr	w3, [sp, #104]
    c00019d4:	b94063e1 	ldr	w1, [sp, #96]
    c00019d8:	f94027e0 	ldr	x0, [sp, #72]
    c00019dc:	7100003f 	cmp	w1, #0x0
    c00019e0:	540000ab 	b.lt	c00019f4 <debug_vprintf+0x3e4>  // b.tstop
    c00019e4:	91003c01 	add	x1, x0, #0xf
    c00019e8:	927df021 	and	x1, x1, #0xfffffffffffffff8
    c00019ec:	f90027e1 	str	x1, [sp, #72]
    c00019f0:	1400000d 	b	c0001a24 <debug_vprintf+0x414>
    c00019f4:	11002022 	add	w2, w1, #0x8
    c00019f8:	b90063e2 	str	w2, [sp, #96]
    c00019fc:	b94063e2 	ldr	w2, [sp, #96]
    c0001a00:	7100005f 	cmp	w2, #0x0
    c0001a04:	540000ad 	b.le	c0001a18 <debug_vprintf+0x408>
    c0001a08:	91003c01 	add	x1, x0, #0xf
    c0001a0c:	927df021 	and	x1, x1, #0xfffffffffffffff8
    c0001a10:	f90027e1 	str	x1, [sp, #72]
    c0001a14:	14000004 	b	c0001a24 <debug_vprintf+0x414>
    c0001a18:	f9402be2 	ldr	x2, [sp, #80]
    c0001a1c:	93407c20 	sxtw	x0, w1
    c0001a20:	8b000040 	add	x0, x2, x0
    c0001a24:	f9400000 	ldr	x0, [x0]
    c0001a28:	13001c61 	sxtb	w1, w3
    c0001a2c:	39000001 	strb	w1, [x0]
				break;
    c0001a30:	14000064 	b	c0001bc0 <debug_vprintf+0x5b0>
			case LENGTH_H:
				*va_arg(ap, short *) = (short)ctx.count;
    c0001a34:	b9406be3 	ldr	w3, [sp, #104]
    c0001a38:	b94063e1 	ldr	w1, [sp, #96]
    c0001a3c:	f94027e0 	ldr	x0, [sp, #72]
    c0001a40:	7100003f 	cmp	w1, #0x0
    c0001a44:	540000ab 	b.lt	c0001a58 <debug_vprintf+0x448>  // b.tstop
    c0001a48:	91003c01 	add	x1, x0, #0xf
    c0001a4c:	927df021 	and	x1, x1, #0xfffffffffffffff8
    c0001a50:	f90027e1 	str	x1, [sp, #72]
    c0001a54:	1400000d 	b	c0001a88 <debug_vprintf+0x478>
    c0001a58:	11002022 	add	w2, w1, #0x8
    c0001a5c:	b90063e2 	str	w2, [sp, #96]
    c0001a60:	b94063e2 	ldr	w2, [sp, #96]
    c0001a64:	7100005f 	cmp	w2, #0x0
    c0001a68:	540000ad 	b.le	c0001a7c <debug_vprintf+0x46c>
    c0001a6c:	91003c01 	add	x1, x0, #0xf
    c0001a70:	927df021 	and	x1, x1, #0xfffffffffffffff8
    c0001a74:	f90027e1 	str	x1, [sp, #72]
    c0001a78:	14000004 	b	c0001a88 <debug_vprintf+0x478>
    c0001a7c:	f9402be2 	ldr	x2, [sp, #80]
    c0001a80:	93407c20 	sxtw	x0, w1
    c0001a84:	8b000040 	add	x0, x2, x0
    c0001a88:	f9400000 	ldr	x0, [x0]
    c0001a8c:	13003c61 	sxth	w1, w3
    c0001a90:	79000001 	strh	w1, [x0]
				break;
    c0001a94:	1400004b 	b	c0001bc0 <debug_vprintf+0x5b0>
			case LENGTH_L:
				*va_arg(ap, long *) = (long)ctx.count;
    c0001a98:	b9406be3 	ldr	w3, [sp, #104]
    c0001a9c:	b94063e1 	ldr	w1, [sp, #96]
    c0001aa0:	f94027e0 	ldr	x0, [sp, #72]
    c0001aa4:	7100003f 	cmp	w1, #0x0
    c0001aa8:	540000ab 	b.lt	c0001abc <debug_vprintf+0x4ac>  // b.tstop
    c0001aac:	91003c01 	add	x1, x0, #0xf
    c0001ab0:	927df021 	and	x1, x1, #0xfffffffffffffff8
    c0001ab4:	f90027e1 	str	x1, [sp, #72]
    c0001ab8:	1400000d 	b	c0001aec <debug_vprintf+0x4dc>
    c0001abc:	11002022 	add	w2, w1, #0x8
    c0001ac0:	b90063e2 	str	w2, [sp, #96]
    c0001ac4:	b94063e2 	ldr	w2, [sp, #96]
    c0001ac8:	7100005f 	cmp	w2, #0x0
    c0001acc:	540000ad 	b.le	c0001ae0 <debug_vprintf+0x4d0>
    c0001ad0:	91003c01 	add	x1, x0, #0xf
    c0001ad4:	927df021 	and	x1, x1, #0xfffffffffffffff8
    c0001ad8:	f90027e1 	str	x1, [sp, #72]
    c0001adc:	14000004 	b	c0001aec <debug_vprintf+0x4dc>
    c0001ae0:	f9402be2 	ldr	x2, [sp, #80]
    c0001ae4:	93407c20 	sxtw	x0, w1
    c0001ae8:	8b000040 	add	x0, x2, x0
    c0001aec:	f9400000 	ldr	x0, [x0]
    c0001af0:	93407c61 	sxtw	x1, w3
    c0001af4:	f9000001 	str	x1, [x0]
				break;
    c0001af8:	14000032 	b	c0001bc0 <debug_vprintf+0x5b0>
			case LENGTH_LL:
				*va_arg(ap, long long *) = (long long)ctx.count;
    c0001afc:	b9406be3 	ldr	w3, [sp, #104]
    c0001b00:	b94063e1 	ldr	w1, [sp, #96]
    c0001b04:	f94027e0 	ldr	x0, [sp, #72]
    c0001b08:	7100003f 	cmp	w1, #0x0
    c0001b0c:	540000ab 	b.lt	c0001b20 <debug_vprintf+0x510>  // b.tstop
    c0001b10:	91003c01 	add	x1, x0, #0xf
    c0001b14:	927df021 	and	x1, x1, #0xfffffffffffffff8
    c0001b18:	f90027e1 	str	x1, [sp, #72]
    c0001b1c:	1400000d 	b	c0001b50 <debug_vprintf+0x540>
    c0001b20:	11002022 	add	w2, w1, #0x8
    c0001b24:	b90063e2 	str	w2, [sp, #96]
    c0001b28:	b94063e2 	ldr	w2, [sp, #96]
    c0001b2c:	7100005f 	cmp	w2, #0x0
    c0001b30:	540000ad 	b.le	c0001b44 <debug_vprintf+0x534>
    c0001b34:	91003c01 	add	x1, x0, #0xf
    c0001b38:	927df021 	and	x1, x1, #0xfffffffffffffff8
    c0001b3c:	f90027e1 	str	x1, [sp, #72]
    c0001b40:	14000004 	b	c0001b50 <debug_vprintf+0x540>
    c0001b44:	f9402be2 	ldr	x2, [sp, #80]
    c0001b48:	93407c20 	sxtw	x0, w1
    c0001b4c:	8b000040 	add	x0, x2, x0
    c0001b50:	f9400000 	ldr	x0, [x0]
    c0001b54:	93407c61 	sxtw	x1, w3
    c0001b58:	f9000001 	str	x1, [x0]
				break;
    c0001b5c:	14000019 	b	c0001bc0 <debug_vprintf+0x5b0>
			default:
				*va_arg(ap, int *) = ctx.count;
    c0001b60:	b94063e1 	ldr	w1, [sp, #96]
    c0001b64:	f94027e0 	ldr	x0, [sp, #72]
    c0001b68:	7100003f 	cmp	w1, #0x0
    c0001b6c:	540000ab 	b.lt	c0001b80 <debug_vprintf+0x570>  // b.tstop
    c0001b70:	91003c01 	add	x1, x0, #0xf
    c0001b74:	927df021 	and	x1, x1, #0xfffffffffffffff8
    c0001b78:	f90027e1 	str	x1, [sp, #72]
    c0001b7c:	1400000d 	b	c0001bb0 <debug_vprintf+0x5a0>
    c0001b80:	11002022 	add	w2, w1, #0x8
    c0001b84:	b90063e2 	str	w2, [sp, #96]
    c0001b88:	b94063e2 	ldr	w2, [sp, #96]
    c0001b8c:	7100005f 	cmp	w2, #0x0
    c0001b90:	540000ad 	b.le	c0001ba4 <debug_vprintf+0x594>
    c0001b94:	91003c01 	add	x1, x0, #0xf
    c0001b98:	927df021 	and	x1, x1, #0xfffffffffffffff8
    c0001b9c:	f90027e1 	str	x1, [sp, #72]
    c0001ba0:	14000004 	b	c0001bb0 <debug_vprintf+0x5a0>
    c0001ba4:	f9402be2 	ldr	x2, [sp, #80]
    c0001ba8:	93407c20 	sxtw	x0, w1
    c0001bac:	8b000040 	add	x0, x2, x0
    c0001bb0:	f9400000 	ldr	x0, [x0]
    c0001bb4:	b9406be1 	ldr	w1, [sp, #104]
    c0001bb8:	b9000001 	str	w1, [x0]
				break;
    c0001bbc:	d503201f 	nop
			}
			break;
    c0001bc0:	1400000b 	b	c0001bec <debug_vprintf+0x5dc>
		default:
			print_char(&ctx, '%');
    c0001bc4:	9101a3e0 	add	x0, sp, #0x68
    c0001bc8:	528004a1 	mov	w1, #0x25                  	// #37
    c0001bcc:	97fff929 	bl	c0000070 <print_char>
			if (spec.conv != '\0') {
    c0001bd0:	394103e0 	ldrb	w0, [sp, #64]
    c0001bd4:	7100001f 	cmp	w0, #0x0
    c0001bd8:	54000080 	b.eq	c0001be8 <debug_vprintf+0x5d8>  // b.none
				print_char(&ctx, spec.conv);
    c0001bdc:	394103e1 	ldrb	w1, [sp, #64]
    c0001be0:	9101a3e0 	add	x0, sp, #0x68
    c0001be4:	97fff923 	bl	c0000070 <print_char>
			}
			break;
    c0001be8:	d503201f 	nop
	while (*fmt != '\0') {
    c0001bec:	f94017e0 	ldr	x0, [sp, #40]
    c0001bf0:	39400000 	ldrb	w0, [x0]
    c0001bf4:	7100001f 	cmp	w0, #0x0
    c0001bf8:	54ffd3a1 	b.ne	c000166c <debug_vprintf+0x5c>  // b.any
		}
	}
	va_end(ap);
	spinlock_unlock(&debug_console_lock);
    c0001bfc:	d0000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c0001c00:	910d0000 	add	x0, x0, #0x340
    c0001c04:	94000407 	bl	c0002c20 <spinlock_unlock>
	return ctx.count;
    c0001c08:	b9406be0 	ldr	w0, [sp, #104]
}
    c0001c0c:	f9400bf3 	ldr	x19, [sp, #16]
    c0001c10:	a8c87bfd 	ldp	x29, x30, [sp], #128
    c0001c14:	d65f03c0 	ret

00000000c0001c18 <debug_printf>:

int debug_printf(const char *fmt, ...)
{
    c0001c18:	a9b57bfd 	stp	x29, x30, [sp, #-176]!
    c0001c1c:	910003fd 	mov	x29, sp
    c0001c20:	f9001fe0 	str	x0, [sp, #56]
    c0001c24:	f9003fe1 	str	x1, [sp, #120]
    c0001c28:	f90043e2 	str	x2, [sp, #128]
    c0001c2c:	f90047e3 	str	x3, [sp, #136]
    c0001c30:	f9004be4 	str	x4, [sp, #144]
    c0001c34:	f9004fe5 	str	x5, [sp, #152]
    c0001c38:	f90053e6 	str	x6, [sp, #160]
    c0001c3c:	f90057e7 	str	x7, [sp, #168]
	int count;
	va_list args;

	va_start(args, fmt);
    c0001c40:	9102c3e0 	add	x0, sp, #0xb0
    c0001c44:	f90027e0 	str	x0, [sp, #72]
    c0001c48:	9102c3e0 	add	x0, sp, #0xb0
    c0001c4c:	f9002be0 	str	x0, [sp, #80]
    c0001c50:	9101c3e0 	add	x0, sp, #0x70
    c0001c54:	f9002fe0 	str	x0, [sp, #88]
    c0001c58:	128006e0 	mov	w0, #0xffffffc8            	// #-56
    c0001c5c:	b90063e0 	str	w0, [sp, #96]
    c0001c60:	b90067ff 	str	wzr, [sp, #100]
	count = debug_vprintf(fmt, args);
    c0001c64:	f94027e0 	ldr	x0, [sp, #72]
    c0001c68:	f9000be0 	str	x0, [sp, #16]
    c0001c6c:	f9402be0 	ldr	x0, [sp, #80]
    c0001c70:	f9000fe0 	str	x0, [sp, #24]
    c0001c74:	f9402fe0 	ldr	x0, [sp, #88]
    c0001c78:	f90013e0 	str	x0, [sp, #32]
    c0001c7c:	f94033e0 	ldr	x0, [sp, #96]
    c0001c80:	f90017e0 	str	x0, [sp, #40]
    c0001c84:	910043e0 	add	x0, sp, #0x10
    c0001c88:	aa0003e1 	mov	x1, x0
    c0001c8c:	f9401fe0 	ldr	x0, [sp, #56]
    c0001c90:	97fffe60 	bl	c0001610 <debug_vprintf>
    c0001c94:	b9006fe0 	str	w0, [sp, #108]
	va_end(args);

	return count;
    c0001c98:	b9406fe0 	ldr	w0, [sp, #108]
}
    c0001c9c:	a8cb7bfd 	ldp	x29, x30, [sp], #176
    c0001ca0:	d65f03c0 	ret

00000000c0001ca4 <mini_os_vprintf>:

int mini_os_vprintf(const char *fmt, va_list args)
{
    c0001ca4:	a9bb7bfd 	stp	x29, x30, [sp, #-80]!
    c0001ca8:	910003fd 	mov	x29, sp
    c0001cac:	f9000bf3 	str	x19, [sp, #16]
    c0001cb0:	f90027e0 	str	x0, [sp, #72]
    c0001cb4:	aa0103f3 	mov	x19, x1
	return debug_vprintf(fmt, args);
    c0001cb8:	f9400260 	ldr	x0, [x19]
    c0001cbc:	f90013e0 	str	x0, [sp, #32]
    c0001cc0:	f9400660 	ldr	x0, [x19, #8]
    c0001cc4:	f90017e0 	str	x0, [sp, #40]
    c0001cc8:	f9400a60 	ldr	x0, [x19, #16]
    c0001ccc:	f9001be0 	str	x0, [sp, #48]
    c0001cd0:	f9400e60 	ldr	x0, [x19, #24]
    c0001cd4:	f9001fe0 	str	x0, [sp, #56]
    c0001cd8:	910083e0 	add	x0, sp, #0x20
    c0001cdc:	aa0003e1 	mov	x1, x0
    c0001ce0:	f94027e0 	ldr	x0, [sp, #72]
    c0001ce4:	97fffe4b 	bl	c0001610 <debug_vprintf>
}
    c0001ce8:	f9400bf3 	ldr	x19, [sp, #16]
    c0001cec:	a8c57bfd 	ldp	x29, x30, [sp], #80
    c0001cf0:	d65f03c0 	ret

00000000c0001cf4 <mini_os_printf>:

int mini_os_printf(const char *fmt, ...)
{
    c0001cf4:	a9b57bfd 	stp	x29, x30, [sp, #-176]!
    c0001cf8:	910003fd 	mov	x29, sp
    c0001cfc:	f9001fe0 	str	x0, [sp, #56]
    c0001d00:	f9003fe1 	str	x1, [sp, #120]
    c0001d04:	f90043e2 	str	x2, [sp, #128]
    c0001d08:	f90047e3 	str	x3, [sp, #136]
    c0001d0c:	f9004be4 	str	x4, [sp, #144]
    c0001d10:	f9004fe5 	str	x5, [sp, #152]
    c0001d14:	f90053e6 	str	x6, [sp, #160]
    c0001d18:	f90057e7 	str	x7, [sp, #168]
	int count;
	va_list args;

	va_start(args, fmt);
    c0001d1c:	9102c3e0 	add	x0, sp, #0xb0
    c0001d20:	f90027e0 	str	x0, [sp, #72]
    c0001d24:	9102c3e0 	add	x0, sp, #0xb0
    c0001d28:	f9002be0 	str	x0, [sp, #80]
    c0001d2c:	9101c3e0 	add	x0, sp, #0x70
    c0001d30:	f9002fe0 	str	x0, [sp, #88]
    c0001d34:	128006e0 	mov	w0, #0xffffffc8            	// #-56
    c0001d38:	b90063e0 	str	w0, [sp, #96]
    c0001d3c:	b90067ff 	str	wzr, [sp, #100]
	count = mini_os_vprintf(fmt, args);
    c0001d40:	f94027e0 	ldr	x0, [sp, #72]
    c0001d44:	f9000be0 	str	x0, [sp, #16]
    c0001d48:	f9402be0 	ldr	x0, [sp, #80]
    c0001d4c:	f9000fe0 	str	x0, [sp, #24]
    c0001d50:	f9402fe0 	ldr	x0, [sp, #88]
    c0001d54:	f90013e0 	str	x0, [sp, #32]
    c0001d58:	f94033e0 	ldr	x0, [sp, #96]
    c0001d5c:	f90017e0 	str	x0, [sp, #40]
    c0001d60:	910043e0 	add	x0, sp, #0x10
    c0001d64:	aa0003e1 	mov	x1, x0
    c0001d68:	f9401fe0 	ldr	x0, [sp, #56]
    c0001d6c:	97ffffce 	bl	c0001ca4 <mini_os_vprintf>
    c0001d70:	b9006fe0 	str	w0, [sp, #108]
	va_end(args);

	return count;
    c0001d74:	b9406fe0 	ldr	w0, [sp, #108]
}
    c0001d78:	a8cb7bfd 	ldp	x29, x30, [sp], #176
    c0001d7c:	d65f03c0 	ret

00000000c0001d80 <debug_console_init>:

void debug_console_init(void)
{
    c0001d80:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    c0001d84:	910003fd 	mov	x29, sp
	spinlock_init(&debug_console_lock);
    c0001d88:	d0000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c0001d8c:	910d0000 	add	x0, x0, #0x340
    c0001d90:	94000311 	bl	c00029d4 <spinlock_init>
	uart_init();
    c0001d94:	940000e5 	bl	c0002128 <uart_init>
}
    c0001d98:	d503201f 	nop
    c0001d9c:	a8c17bfd 	ldp	x29, x30, [sp], #16
    c0001da0:	d65f03c0 	ret

00000000c0001da4 <debug_putc>:

void debug_putc(int ch)
{
    c0001da4:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c0001da8:	910003fd 	mov	x29, sp
    c0001dac:	b9001fe0 	str	w0, [sp, #28]
	spinlock_lock(&debug_console_lock);
    c0001db0:	d0000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c0001db4:	910d0000 	add	x0, x0, #0x340
    c0001db8:	94000392 	bl	c0002c00 <spinlock_lock>
	uart_putc(ch);
    c0001dbc:	b9401fe0 	ldr	w0, [sp, #28]
    c0001dc0:	9400012b 	bl	c000226c <uart_putc>
	spinlock_unlock(&debug_console_lock);
    c0001dc4:	d0000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c0001dc8:	910d0000 	add	x0, x0, #0x340
    c0001dcc:	94000395 	bl	c0002c20 <spinlock_unlock>
}
    c0001dd0:	d503201f 	nop
    c0001dd4:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c0001dd8:	d65f03c0 	ret

00000000c0001ddc <debug_puts>:

void debug_puts(const char *str)
{
    c0001ddc:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c0001de0:	910003fd 	mov	x29, sp
    c0001de4:	f9000fe0 	str	x0, [sp, #24]
	spinlock_lock(&debug_console_lock);
    c0001de8:	d0000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c0001dec:	910d0000 	add	x0, x0, #0x340
    c0001df0:	94000384 	bl	c0002c00 <spinlock_lock>
	uart_puts(str);
    c0001df4:	f9400fe0 	ldr	x0, [sp, #24]
    c0001df8:	94000138 	bl	c00022d8 <uart_puts>
	spinlock_unlock(&debug_console_lock);
    c0001dfc:	d0000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c0001e00:	910d0000 	add	x0, x0, #0x340
    c0001e04:	94000387 	bl	c0002c20 <spinlock_unlock>
}
    c0001e08:	d503201f 	nop
    c0001e0c:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c0001e10:	d65f03c0 	ret

00000000c0001e14 <debug_write>:

void debug_write(const char *buf, size_t len)
{
    c0001e14:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c0001e18:	910003fd 	mov	x29, sp
    c0001e1c:	f9000fe0 	str	x0, [sp, #24]
    c0001e20:	f9000be1 	str	x1, [sp, #16]
	spinlock_lock(&debug_console_lock);
    c0001e24:	d0000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c0001e28:	910d0000 	add	x0, x0, #0x340
    c0001e2c:	94000375 	bl	c0002c00 <spinlock_lock>
	uart_write(buf, len);
    c0001e30:	f9400be1 	ldr	x1, [sp, #16]
    c0001e34:	f9400fe0 	ldr	x0, [sp, #24]
    c0001e38:	94000142 	bl	c0002340 <uart_write>
	spinlock_unlock(&debug_console_lock);
    c0001e3c:	d0000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c0001e40:	910d0000 	add	x0, x0, #0x340
    c0001e44:	94000377 	bl	c0002c20 <spinlock_unlock>
}
    c0001e48:	d503201f 	nop
    c0001e4c:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c0001e50:	d65f03c0 	ret

00000000c0001e54 <debug_getc>:

int debug_getc(void)
{
    c0001e54:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    c0001e58:	910003fd 	mov	x29, sp
	return uart_getc();
    c0001e5c:	94000164 	bl	c00023ec <uart_getc>
}
    c0001e60:	a8c17bfd 	ldp	x29, x30, [sp], #16
    c0001e64:	d65f03c0 	ret

00000000c0001e68 <debug_try_getc>:

int debug_try_getc(void)
{
    c0001e68:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    c0001e6c:	910003fd 	mov	x29, sp
	return uart_try_getc();
    c0001e70:	9400014d 	bl	c00023a4 <uart_try_getc>
}
    c0001e74:	a8c17bfd 	ldp	x29, x30, [sp], #16
    c0001e78:	d65f03c0 	ret

00000000c0001e7c <debug_put_hex64>:

void debug_put_hex64(uint64_t value)
{
    c0001e7c:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c0001e80:	910003fd 	mov	x29, sp
    c0001e84:	f9000fe0 	str	x0, [sp, #24]
	spinlock_lock(&debug_console_lock);
    c0001e88:	d0000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c0001e8c:	910d0000 	add	x0, x0, #0x340
    c0001e90:	9400035c 	bl	c0002c00 <spinlock_lock>
	uart_put_hex64(value);
    c0001e94:	f9400fe0 	ldr	x0, [sp, #24]
    c0001e98:	94000168 	bl	c0002438 <uart_put_hex64>
	spinlock_unlock(&debug_console_lock);
    c0001e9c:	d0000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c0001ea0:	910d0000 	add	x0, x0, #0x340
    c0001ea4:	9400035f 	bl	c0002c20 <spinlock_unlock>
}
    c0001ea8:	d503201f 	nop
    c0001eac:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c0001eb0:	d65f03c0 	ret

00000000c0001eb4 <debug_flush>:

void debug_flush(void)
{
    c0001eb4:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    c0001eb8:	910003fd 	mov	x29, sp
	spinlock_lock(&debug_console_lock);
    c0001ebc:	d0000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c0001ec0:	910d0000 	add	x0, x0, #0x340
    c0001ec4:	9400034f 	bl	c0002c00 <spinlock_lock>
	uart_flush();
    c0001ec8:	94000174 	bl	c0002498 <uart_flush>
	spinlock_unlock(&debug_console_lock);
    c0001ecc:	d0000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c0001ed0:	910d0000 	add	x0, x0, #0x340
    c0001ed4:	94000353 	bl	c0002c20 <spinlock_unlock>
    c0001ed8:	d503201f 	nop
    c0001edc:	a8c17bfd 	ldp	x29, x30, [sp], #16
    c0001ee0:	d65f03c0 	ret

00000000c0001ee4 <mmio_write_32>:
	.clock_hz = PLAT_UART0_CLK_HZ,
	.baudrate = PLAT_UART0_BAUDRATE,
};

static inline void mmio_write_32(uintptr_t addr, uint32_t value)
{
    c0001ee4:	d10043ff 	sub	sp, sp, #0x10
    c0001ee8:	f90007e0 	str	x0, [sp, #8]
    c0001eec:	b90007e1 	str	w1, [sp, #4]
	*(volatile uint32_t *)addr = value;
    c0001ef0:	f94007e0 	ldr	x0, [sp, #8]
    c0001ef4:	b94007e1 	ldr	w1, [sp, #4]
    c0001ef8:	b9000001 	str	w1, [x0]
}
    c0001efc:	d503201f 	nop
    c0001f00:	910043ff 	add	sp, sp, #0x10
    c0001f04:	d65f03c0 	ret

00000000c0001f08 <mmio_read_32>:

static inline uint32_t mmio_read_32(uintptr_t addr)
{
    c0001f08:	d10043ff 	sub	sp, sp, #0x10
    c0001f0c:	f90007e0 	str	x0, [sp, #8]
	return *(volatile uint32_t *)addr;
    c0001f10:	f94007e0 	ldr	x0, [sp, #8]
    c0001f14:	b9400000 	ldr	w0, [x0]
}
    c0001f18:	910043ff 	add	sp, sp, #0x10
    c0001f1c:	d65f03c0 	ret

00000000c0001f20 <dsb_sy>:

static inline void dsb_sy(void)
{
	__asm__ volatile ("dsb sy" : : : "memory");
    c0001f20:	d5033f9f 	dsb	sy
}
    c0001f24:	d503201f 	nop
    c0001f28:	d65f03c0 	ret

00000000c0001f2c <isb>:

static inline void isb(void)
{
	__asm__ volatile ("isb" : : : "memory");
    c0001f2c:	d5033fdf 	isb
}
    c0001f30:	d503201f 	nop
    c0001f34:	d65f03c0 	ret

00000000c0001f38 <pl011_calc_baud>:

static void pl011_calc_baud(uint32_t uartclk_hz, uint32_t baud,
			    uint32_t *ibrd, uint32_t *fbrd)
{
    c0001f38:	d10103ff 	sub	sp, sp, #0x40
    c0001f3c:	b9001fe0 	str	w0, [sp, #28]
    c0001f40:	b9001be1 	str	w1, [sp, #24]
    c0001f44:	f9000be2 	str	x2, [sp, #16]
    c0001f48:	f90007e3 	str	x3, [sp, #8]
	uint64_t denom;
	uint64_t div;
	uint64_t rem;
	uint64_t frac64;

	if ((uartclk_hz == 0U) || (baud == 0U)) {
    c0001f4c:	b9401fe0 	ldr	w0, [sp, #28]
    c0001f50:	7100001f 	cmp	w0, #0x0
    c0001f54:	54000080 	b.eq	c0001f64 <pl011_calc_baud+0x2c>  // b.none
    c0001f58:	b9401be0 	ldr	w0, [sp, #24]
    c0001f5c:	7100001f 	cmp	w0, #0x0
    c0001f60:	540000e1 	b.ne	c0001f7c <pl011_calc_baud+0x44>  // b.any
		*ibrd = 1U;
    c0001f64:	f9400be0 	ldr	x0, [sp, #16]
    c0001f68:	52800021 	mov	w1, #0x1                   	// #1
    c0001f6c:	b9000001 	str	w1, [x0]
		*fbrd = 0U;
    c0001f70:	f94007e0 	ldr	x0, [sp, #8]
    c0001f74:	b900001f 	str	wzr, [x0]
		return;
    c0001f78:	14000029 	b	c000201c <pl011_calc_baud+0xe4>
	}

	denom = 16ULL * (uint64_t)baud;
    c0001f7c:	b9401be0 	ldr	w0, [sp, #24]
    c0001f80:	d37cec00 	lsl	x0, x0, #4
    c0001f84:	f90017e0 	str	x0, [sp, #40]
	div = (uint64_t)uartclk_hz / denom;
    c0001f88:	b9401fe1 	ldr	w1, [sp, #28]
    c0001f8c:	f94017e0 	ldr	x0, [sp, #40]
    c0001f90:	9ac00820 	udiv	x0, x1, x0
    c0001f94:	f9001fe0 	str	x0, [sp, #56]
	rem = (uint64_t)uartclk_hz % denom;
    c0001f98:	b9401fe0 	ldr	w0, [sp, #28]
    c0001f9c:	f94017e1 	ldr	x1, [sp, #40]
    c0001fa0:	9ac10802 	udiv	x2, x0, x1
    c0001fa4:	f94017e1 	ldr	x1, [sp, #40]
    c0001fa8:	9b017c41 	mul	x1, x2, x1
    c0001fac:	cb010000 	sub	x0, x0, x1
    c0001fb0:	f90013e0 	str	x0, [sp, #32]
	frac64 = (rem * 64ULL + denom / 2ULL) / denom;
    c0001fb4:	f94013e0 	ldr	x0, [sp, #32]
    c0001fb8:	d37ae401 	lsl	x1, x0, #6
    c0001fbc:	f94017e0 	ldr	x0, [sp, #40]
    c0001fc0:	d341fc00 	lsr	x0, x0, #1
    c0001fc4:	8b000021 	add	x1, x1, x0
    c0001fc8:	f94017e0 	ldr	x0, [sp, #40]
    c0001fcc:	9ac00820 	udiv	x0, x1, x0
    c0001fd0:	f9001be0 	str	x0, [sp, #48]

	if (div == 0U) {
    c0001fd4:	f9401fe0 	ldr	x0, [sp, #56]
    c0001fd8:	f100001f 	cmp	x0, #0x0
    c0001fdc:	54000061 	b.ne	c0001fe8 <pl011_calc_baud+0xb0>  // b.any
		div = 1U;
    c0001fe0:	d2800020 	mov	x0, #0x1                   	// #1
    c0001fe4:	f9001fe0 	str	x0, [sp, #56]
	}
	if (frac64 > 63U) {
    c0001fe8:	f9401be0 	ldr	x0, [sp, #48]
    c0001fec:	f100fc1f 	cmp	x0, #0x3f
    c0001ff0:	54000069 	b.ls	c0001ffc <pl011_calc_baud+0xc4>  // b.plast
		frac64 = 63U;
    c0001ff4:	d28007e0 	mov	x0, #0x3f                  	// #63
    c0001ff8:	f9001be0 	str	x0, [sp, #48]
	}

	*ibrd = (uint32_t)div;
    c0001ffc:	f9401fe0 	ldr	x0, [sp, #56]
    c0002000:	2a0003e1 	mov	w1, w0
    c0002004:	f9400be0 	ldr	x0, [sp, #16]
    c0002008:	b9000001 	str	w1, [x0]
	*fbrd = (uint32_t)frac64;
    c000200c:	f9401be0 	ldr	x0, [sp, #48]
    c0002010:	2a0003e1 	mov	w1, w0
    c0002014:	f94007e0 	ldr	x0, [sp, #8]
    c0002018:	b9000001 	str	w1, [x0]
}
    c000201c:	910103ff 	add	sp, sp, #0x40
    c0002020:	d65f03c0 	ret

00000000c0002024 <uart_is_configured>:

bool uart_is_configured(void)
{
	return (plat_uart.base != 0UL) &&
    c0002024:	b0000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c0002028:	910c8000 	add	x0, x0, #0x320
    c000202c:	f9400000 	ldr	x0, [x0]
	       (plat_uart.clock_hz != 0U) &&
    c0002030:	f100001f 	cmp	x0, #0x0
    c0002034:	540001a0 	b.eq	c0002068 <uart_is_configured+0x44>  // b.none
    c0002038:	b0000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c000203c:	910c8000 	add	x0, x0, #0x320
    c0002040:	b9400800 	ldr	w0, [x0, #8]
	return (plat_uart.base != 0UL) &&
    c0002044:	7100001f 	cmp	w0, #0x0
    c0002048:	54000100 	b.eq	c0002068 <uart_is_configured+0x44>  // b.none
	       (plat_uart.baudrate != 0U);
    c000204c:	b0000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c0002050:	910c8000 	add	x0, x0, #0x320
    c0002054:	b9400c00 	ldr	w0, [x0, #12]
	       (plat_uart.clock_hz != 0U) &&
    c0002058:	7100001f 	cmp	w0, #0x0
    c000205c:	54000060 	b.eq	c0002068 <uart_is_configured+0x44>  // b.none
    c0002060:	52800020 	mov	w0, #0x1                   	// #1
    c0002064:	14000002 	b	c000206c <uart_is_configured+0x48>
    c0002068:	52800000 	mov	w0, #0x0                   	// #0
    c000206c:	12000000 	and	w0, w0, #0x1
    c0002070:	12001c00 	and	w0, w0, #0xff
}
    c0002074:	d65f03c0 	ret

00000000c0002078 <uart_tx_ready>:

bool uart_tx_ready(void)
{
    c0002078:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    c000207c:	910003fd 	mov	x29, sp
	if (!uart_is_configured()) {
    c0002080:	97ffffe9 	bl	c0002024 <uart_is_configured>
    c0002084:	12001c00 	and	w0, w0, #0xff
    c0002088:	52000000 	eor	w0, w0, #0x1
    c000208c:	12001c00 	and	w0, w0, #0xff
    c0002090:	12000000 	and	w0, w0, #0x1
    c0002094:	7100001f 	cmp	w0, #0x0
    c0002098:	54000060 	b.eq	c00020a4 <uart_tx_ready+0x2c>  // b.none
		return false;
    c000209c:	52800000 	mov	w0, #0x0                   	// #0
    c00020a0:	1400000a 	b	c00020c8 <uart_tx_ready+0x50>
	}

	return (mmio_read_32(plat_uart.base + PL011_FR) & FR_TXFF) == 0U;
    c00020a4:	b0000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c00020a8:	910c8000 	add	x0, x0, #0x320
    c00020ac:	f9400000 	ldr	x0, [x0]
    c00020b0:	91006000 	add	x0, x0, #0x18
    c00020b4:	97ffff95 	bl	c0001f08 <mmio_read_32>
    c00020b8:	121b0000 	and	w0, w0, #0x20
    c00020bc:	7100001f 	cmp	w0, #0x0
    c00020c0:	1a9f17e0 	cset	w0, eq	// eq = none
    c00020c4:	12001c00 	and	w0, w0, #0xff
}
    c00020c8:	a8c17bfd 	ldp	x29, x30, [sp], #16
    c00020cc:	d65f03c0 	ret

00000000c00020d0 <uart_rx_ready>:

bool uart_rx_ready(void)
{
    c00020d0:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    c00020d4:	910003fd 	mov	x29, sp
	if (!uart_is_configured()) {
    c00020d8:	97ffffd3 	bl	c0002024 <uart_is_configured>
    c00020dc:	12001c00 	and	w0, w0, #0xff
    c00020e0:	52000000 	eor	w0, w0, #0x1
    c00020e4:	12001c00 	and	w0, w0, #0xff
    c00020e8:	12000000 	and	w0, w0, #0x1
    c00020ec:	7100001f 	cmp	w0, #0x0
    c00020f0:	54000060 	b.eq	c00020fc <uart_rx_ready+0x2c>  // b.none
		return false;
    c00020f4:	52800000 	mov	w0, #0x0                   	// #0
    c00020f8:	1400000a 	b	c0002120 <uart_rx_ready+0x50>
	}

	return (mmio_read_32(plat_uart.base + PL011_FR) & FR_RXFE) == 0U;
    c00020fc:	b0000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c0002100:	910c8000 	add	x0, x0, #0x320
    c0002104:	f9400000 	ldr	x0, [x0]
    c0002108:	91006000 	add	x0, x0, #0x18
    c000210c:	97ffff7f 	bl	c0001f08 <mmio_read_32>
    c0002110:	121c0000 	and	w0, w0, #0x10
    c0002114:	7100001f 	cmp	w0, #0x0
    c0002118:	1a9f17e0 	cset	w0, eq	// eq = none
    c000211c:	12001c00 	and	w0, w0, #0xff
}
    c0002120:	a8c17bfd 	ldp	x29, x30, [sp], #16
    c0002124:	d65f03c0 	ret

00000000c0002128 <uart_init>:

void uart_init(void)
{
    c0002128:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c000212c:	910003fd 	mov	x29, sp
	uint32_t ibrd;
	uint32_t fbrd;

	if (!uart_is_configured()) {
    c0002130:	97ffffbd 	bl	c0002024 <uart_is_configured>
    c0002134:	12001c00 	and	w0, w0, #0xff
    c0002138:	52000000 	eor	w0, w0, #0x1
    c000213c:	12001c00 	and	w0, w0, #0xff
    c0002140:	12000000 	and	w0, w0, #0x1
    c0002144:	7100001f 	cmp	w0, #0x0
    c0002148:	540008c1 	b.ne	c0002260 <uart_init+0x138>  // b.any
		return;
	}

	mmio_write_32(plat_uart.base + PL011_CR, 0U);
    c000214c:	b0000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c0002150:	910c8000 	add	x0, x0, #0x320
    c0002154:	f9400000 	ldr	x0, [x0]
    c0002158:	9100c000 	add	x0, x0, #0x30
    c000215c:	52800001 	mov	w1, #0x0                   	// #0
    c0002160:	97ffff61 	bl	c0001ee4 <mmio_write_32>
	dsb_sy();
    c0002164:	97ffff6f 	bl	c0001f20 <dsb_sy>
	isb();
    c0002168:	97ffff71 	bl	c0001f2c <isb>

	while ((mmio_read_32(plat_uart.base + PL011_FR) & FR_BUSY) != 0U) {
    c000216c:	d503201f 	nop
    c0002170:	b0000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c0002174:	910c8000 	add	x0, x0, #0x320
    c0002178:	f9400000 	ldr	x0, [x0]
    c000217c:	91006000 	add	x0, x0, #0x18
    c0002180:	97ffff62 	bl	c0001f08 <mmio_read_32>
    c0002184:	121d0000 	and	w0, w0, #0x8
    c0002188:	7100001f 	cmp	w0, #0x0
    c000218c:	54ffff21 	b.ne	c0002170 <uart_init+0x48>  // b.any
	}

	mmio_write_32(plat_uart.base + PL011_ICR, PL011_ICR_ALL);
    c0002190:	b0000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c0002194:	910c8000 	add	x0, x0, #0x320
    c0002198:	f9400000 	ldr	x0, [x0]
    c000219c:	91011000 	add	x0, x0, #0x44
    c00021a0:	5280ffe1 	mov	w1, #0x7ff                 	// #2047
    c00021a4:	97ffff50 	bl	c0001ee4 <mmio_write_32>
	mmio_write_32(plat_uart.base + PL011_IMSC, 0U);
    c00021a8:	b0000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c00021ac:	910c8000 	add	x0, x0, #0x320
    c00021b0:	f9400000 	ldr	x0, [x0]
    c00021b4:	9100e000 	add	x0, x0, #0x38
    c00021b8:	52800001 	mov	w1, #0x0                   	// #0
    c00021bc:	97ffff4a 	bl	c0001ee4 <mmio_write_32>

	pl011_calc_baud(plat_uart.clock_hz, plat_uart.baudrate, &ibrd, &fbrd);
    c00021c0:	b0000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c00021c4:	910c8000 	add	x0, x0, #0x320
    c00021c8:	b9400804 	ldr	w4, [x0, #8]
    c00021cc:	b0000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c00021d0:	910c8000 	add	x0, x0, #0x320
    c00021d4:	b9400c00 	ldr	w0, [x0, #12]
    c00021d8:	910063e2 	add	x2, sp, #0x18
    c00021dc:	910073e1 	add	x1, sp, #0x1c
    c00021e0:	aa0203e3 	mov	x3, x2
    c00021e4:	aa0103e2 	mov	x2, x1
    c00021e8:	2a0003e1 	mov	w1, w0
    c00021ec:	2a0403e0 	mov	w0, w4
    c00021f0:	97ffff52 	bl	c0001f38 <pl011_calc_baud>
	mmio_write_32(plat_uart.base + PL011_IBRD, ibrd);
    c00021f4:	b0000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c00021f8:	910c8000 	add	x0, x0, #0x320
    c00021fc:	f9400000 	ldr	x0, [x0]
    c0002200:	91009000 	add	x0, x0, #0x24
    c0002204:	b9401fe1 	ldr	w1, [sp, #28]
    c0002208:	97ffff37 	bl	c0001ee4 <mmio_write_32>
	mmio_write_32(plat_uart.base + PL011_FBRD, fbrd);
    c000220c:	b0000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c0002210:	910c8000 	add	x0, x0, #0x320
    c0002214:	f9400000 	ldr	x0, [x0]
    c0002218:	9100a000 	add	x0, x0, #0x28
    c000221c:	b9401be1 	ldr	w1, [sp, #24]
    c0002220:	97ffff31 	bl	c0001ee4 <mmio_write_32>
	mmio_write_32(plat_uart.base + PL011_LCRH, LCRH_WLEN_8 | LCRH_FEN);
    c0002224:	b0000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c0002228:	910c8000 	add	x0, x0, #0x320
    c000222c:	f9400000 	ldr	x0, [x0]
    c0002230:	9100b000 	add	x0, x0, #0x2c
    c0002234:	52800e01 	mov	w1, #0x70                  	// #112
    c0002238:	97ffff2b 	bl	c0001ee4 <mmio_write_32>
	mmio_write_32(plat_uart.base + PL011_CR, CR_UARTEN | CR_TXE | CR_RXE);
    c000223c:	b0000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c0002240:	910c8000 	add	x0, x0, #0x320
    c0002244:	f9400000 	ldr	x0, [x0]
    c0002248:	9100c000 	add	x0, x0, #0x30
    c000224c:	52806021 	mov	w1, #0x301                 	// #769
    c0002250:	97ffff25 	bl	c0001ee4 <mmio_write_32>
	dsb_sy();
    c0002254:	97ffff33 	bl	c0001f20 <dsb_sy>
	isb();
    c0002258:	97ffff35 	bl	c0001f2c <isb>
    c000225c:	14000002 	b	c0002264 <uart_init+0x13c>
		return;
    c0002260:	d503201f 	nop
}
    c0002264:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c0002268:	d65f03c0 	ret

00000000c000226c <uart_putc>:

void uart_putc(int ch)
{
    c000226c:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c0002270:	910003fd 	mov	x29, sp
    c0002274:	b9001fe0 	str	w0, [sp, #28]
	if (!uart_is_configured()) {
    c0002278:	97ffff6b 	bl	c0002024 <uart_is_configured>
    c000227c:	12001c00 	and	w0, w0, #0xff
    c0002280:	52000000 	eor	w0, w0, #0x1
    c0002284:	12001c00 	and	w0, w0, #0xff
    c0002288:	12000000 	and	w0, w0, #0x1
    c000228c:	7100001f 	cmp	w0, #0x0
    c0002290:	540001e1 	b.ne	c00022cc <uart_putc+0x60>  // b.any
		return;
	}

	while (!uart_tx_ready()) {
    c0002294:	d503201f 	nop
    c0002298:	97ffff78 	bl	c0002078 <uart_tx_ready>
    c000229c:	12001c00 	and	w0, w0, #0xff
    c00022a0:	52000000 	eor	w0, w0, #0x1
    c00022a4:	12001c00 	and	w0, w0, #0xff
    c00022a8:	12000000 	and	w0, w0, #0x1
    c00022ac:	7100001f 	cmp	w0, #0x0
    c00022b0:	54ffff41 	b.ne	c0002298 <uart_putc+0x2c>  // b.any
	}

	mmio_write_32(plat_uart.base + PL011_DR, (uint32_t)ch);
    c00022b4:	b0000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c00022b8:	910c8000 	add	x0, x0, #0x320
    c00022bc:	f9400000 	ldr	x0, [x0]
    c00022c0:	b9401fe1 	ldr	w1, [sp, #28]
    c00022c4:	97ffff08 	bl	c0001ee4 <mmio_write_32>
    c00022c8:	14000002 	b	c00022d0 <uart_putc+0x64>
		return;
    c00022cc:	d503201f 	nop
}
    c00022d0:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c00022d4:	d65f03c0 	ret

00000000c00022d8 <uart_puts>:

void uart_puts(const char *str)
{
    c00022d8:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c00022dc:	910003fd 	mov	x29, sp
    c00022e0:	f9000fe0 	str	x0, [sp, #24]
	if (str == NULL) {
    c00022e4:	f9400fe0 	ldr	x0, [sp, #24]
    c00022e8:	f100001f 	cmp	x0, #0x0
    c00022ec:	54000240 	b.eq	c0002334 <uart_puts+0x5c>  // b.none
		return;
	}

	while (*str != '\0') {
    c00022f0:	1400000c 	b	c0002320 <uart_puts+0x48>
		if (*str == '\n') {
    c00022f4:	f9400fe0 	ldr	x0, [sp, #24]
    c00022f8:	39400000 	ldrb	w0, [x0]
    c00022fc:	7100281f 	cmp	w0, #0xa
    c0002300:	54000061 	b.ne	c000230c <uart_puts+0x34>  // b.any
			uart_putc('\r');
    c0002304:	528001a0 	mov	w0, #0xd                   	// #13
    c0002308:	97ffffd9 	bl	c000226c <uart_putc>
		}

		uart_putc(*str++);
    c000230c:	f9400fe0 	ldr	x0, [sp, #24]
    c0002310:	91000401 	add	x1, x0, #0x1
    c0002314:	f9000fe1 	str	x1, [sp, #24]
    c0002318:	39400000 	ldrb	w0, [x0]
    c000231c:	97ffffd4 	bl	c000226c <uart_putc>
	while (*str != '\0') {
    c0002320:	f9400fe0 	ldr	x0, [sp, #24]
    c0002324:	39400000 	ldrb	w0, [x0]
    c0002328:	7100001f 	cmp	w0, #0x0
    c000232c:	54fffe41 	b.ne	c00022f4 <uart_puts+0x1c>  // b.any
    c0002330:	14000002 	b	c0002338 <uart_puts+0x60>
		return;
    c0002334:	d503201f 	nop
	}
}
    c0002338:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c000233c:	d65f03c0 	ret

00000000c0002340 <uart_write>:

void uart_write(const char *buf, size_t len)
{
    c0002340:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
    c0002344:	910003fd 	mov	x29, sp
    c0002348:	f9000fe0 	str	x0, [sp, #24]
    c000234c:	f9000be1 	str	x1, [sp, #16]
	size_t i;

	if (buf == NULL) {
    c0002350:	f9400fe0 	ldr	x0, [sp, #24]
    c0002354:	f100001f 	cmp	x0, #0x0
    c0002358:	54000200 	b.eq	c0002398 <uart_write+0x58>  // b.none
		return;
	}

	for (i = 0; i < len; ++i) {
    c000235c:	f90017ff 	str	xzr, [sp, #40]
    c0002360:	14000009 	b	c0002384 <uart_write+0x44>
		uart_putc((int)buf[i]);
    c0002364:	f9400fe1 	ldr	x1, [sp, #24]
    c0002368:	f94017e0 	ldr	x0, [sp, #40]
    c000236c:	8b000020 	add	x0, x1, x0
    c0002370:	39400000 	ldrb	w0, [x0]
    c0002374:	97ffffbe 	bl	c000226c <uart_putc>
	for (i = 0; i < len; ++i) {
    c0002378:	f94017e0 	ldr	x0, [sp, #40]
    c000237c:	91000400 	add	x0, x0, #0x1
    c0002380:	f90017e0 	str	x0, [sp, #40]
    c0002384:	f94017e1 	ldr	x1, [sp, #40]
    c0002388:	f9400be0 	ldr	x0, [sp, #16]
    c000238c:	eb00003f 	cmp	x1, x0
    c0002390:	54fffea3 	b.cc	c0002364 <uart_write+0x24>  // b.lo, b.ul, b.last
    c0002394:	14000002 	b	c000239c <uart_write+0x5c>
		return;
    c0002398:	d503201f 	nop
	}
}
    c000239c:	a8c37bfd 	ldp	x29, x30, [sp], #48
    c00023a0:	d65f03c0 	ret

00000000c00023a4 <uart_try_getc>:

int uart_try_getc(void)
{
    c00023a4:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    c00023a8:	910003fd 	mov	x29, sp
	if (!uart_rx_ready()) {
    c00023ac:	97ffff49 	bl	c00020d0 <uart_rx_ready>
    c00023b0:	12001c00 	and	w0, w0, #0xff
    c00023b4:	52000000 	eor	w0, w0, #0x1
    c00023b8:	12001c00 	and	w0, w0, #0xff
    c00023bc:	12000000 	and	w0, w0, #0x1
    c00023c0:	7100001f 	cmp	w0, #0x0
    c00023c4:	54000060 	b.eq	c00023d0 <uart_try_getc+0x2c>  // b.none
		return -1;
    c00023c8:	12800000 	mov	w0, #0xffffffff            	// #-1
    c00023cc:	14000006 	b	c00023e4 <uart_try_getc+0x40>
	}

	return (int)(mmio_read_32(plat_uart.base + PL011_DR) & 0xFFU);
    c00023d0:	b0000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c00023d4:	910c8000 	add	x0, x0, #0x320
    c00023d8:	f9400000 	ldr	x0, [x0]
    c00023dc:	97fffecb 	bl	c0001f08 <mmio_read_32>
    c00023e0:	12001c00 	and	w0, w0, #0xff
}
    c00023e4:	a8c17bfd 	ldp	x29, x30, [sp], #16
    c00023e8:	d65f03c0 	ret

00000000c00023ec <uart_getc>:

int uart_getc(void)
{
    c00023ec:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c00023f0:	910003fd 	mov	x29, sp
	int ch;

	if (!uart_is_configured()) {
    c00023f4:	97ffff0c 	bl	c0002024 <uart_is_configured>
    c00023f8:	12001c00 	and	w0, w0, #0xff
    c00023fc:	52000000 	eor	w0, w0, #0x1
    c0002400:	12001c00 	and	w0, w0, #0xff
    c0002404:	12000000 	and	w0, w0, #0x1
    c0002408:	7100001f 	cmp	w0, #0x0
    c000240c:	54000060 	b.eq	c0002418 <uart_getc+0x2c>  // b.none
		return -1;
    c0002410:	12800000 	mov	w0, #0xffffffff            	// #-1
    c0002414:	14000007 	b	c0002430 <uart_getc+0x44>
	}

	do {
		ch = uart_try_getc();
    c0002418:	97ffffe3 	bl	c00023a4 <uart_try_getc>
    c000241c:	b9001fe0 	str	w0, [sp, #28]
	} while (ch < 0);
    c0002420:	b9401fe0 	ldr	w0, [sp, #28]
    c0002424:	7100001f 	cmp	w0, #0x0
    c0002428:	54ffff8b 	b.lt	c0002418 <uart_getc+0x2c>  // b.tstop

	return ch;
    c000242c:	b9401fe0 	ldr	w0, [sp, #28]
}
    c0002430:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c0002434:	d65f03c0 	ret

00000000c0002438 <uart_put_hex64>:

void uart_put_hex64(uint64_t value)
{
    c0002438:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
    c000243c:	910003fd 	mov	x29, sp
    c0002440:	f9000fe0 	str	x0, [sp, #24]
	static const char hex[] = "0123456789abcdef";
	int shift;

	for (shift = 60; shift >= 0; shift -= 4) {
    c0002444:	52800780 	mov	w0, #0x3c                  	// #60
    c0002448:	b9002fe0 	str	w0, [sp, #44]
    c000244c:	1400000c 	b	c000247c <uart_put_hex64+0x44>
		uart_putc(hex[(value >> shift) & 0xFULL]);
    c0002450:	b9402fe0 	ldr	w0, [sp, #44]
    c0002454:	f9400fe1 	ldr	x1, [sp, #24]
    c0002458:	9ac02420 	lsr	x0, x1, x0
    c000245c:	92400c00 	and	x0, x0, #0xf
    c0002460:	f0000001 	adrp	x1, c0005000 <smp_init+0x68>
    c0002464:	913b6021 	add	x1, x1, #0xed8
    c0002468:	38606820 	ldrb	w0, [x1, x0]
    c000246c:	97ffff80 	bl	c000226c <uart_putc>
	for (shift = 60; shift >= 0; shift -= 4) {
    c0002470:	b9402fe0 	ldr	w0, [sp, #44]
    c0002474:	51001000 	sub	w0, w0, #0x4
    c0002478:	b9002fe0 	str	w0, [sp, #44]
    c000247c:	b9402fe0 	ldr	w0, [sp, #44]
    c0002480:	7100001f 	cmp	w0, #0x0
    c0002484:	54fffe6a 	b.ge	c0002450 <uart_put_hex64+0x18>  // b.tcont
	}
}
    c0002488:	d503201f 	nop
    c000248c:	d503201f 	nop
    c0002490:	a8c37bfd 	ldp	x29, x30, [sp], #48
    c0002494:	d65f03c0 	ret

00000000c0002498 <uart_flush>:

void uart_flush(void)
{
    c0002498:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    c000249c:	910003fd 	mov	x29, sp
	if (!uart_is_configured()) {
    c00024a0:	97fffee1 	bl	c0002024 <uart_is_configured>
    c00024a4:	12001c00 	and	w0, w0, #0xff
    c00024a8:	52000000 	eor	w0, w0, #0x1
    c00024ac:	12001c00 	and	w0, w0, #0xff
    c00024b0:	12000000 	and	w0, w0, #0x1
    c00024b4:	7100001f 	cmp	w0, #0x0
    c00024b8:	54000161 	b.ne	c00024e4 <uart_flush+0x4c>  // b.any
		return;
	}

	while ((mmio_read_32(plat_uart.base + PL011_FR) & FR_BUSY) != 0U) {
    c00024bc:	d503201f 	nop
    c00024c0:	b0000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c00024c4:	910c8000 	add	x0, x0, #0x320
    c00024c8:	f9400000 	ldr	x0, [x0]
    c00024cc:	91006000 	add	x0, x0, #0x18
    c00024d0:	97fffe8e 	bl	c0001f08 <mmio_read_32>
    c00024d4:	121d0000 	and	w0, w0, #0x8
    c00024d8:	7100001f 	cmp	w0, #0x0
    c00024dc:	54ffff21 	b.ne	c00024c0 <uart_flush+0x28>  // b.any
    c00024e0:	14000002 	b	c00024e8 <uart_flush+0x50>
		return;
    c00024e4:	d503201f 	nop
	}
    c00024e8:	a8c17bfd 	ldp	x29, x30, [sp], #16
    c00024ec:	d65f03c0 	ret

00000000c00024f0 <gic_init>:
#include <drivers/interrupt/gic.h>

void gic_init(void)
{
    c00024f0:	d503201f 	nop
    c00024f4:	d65f03c0 	ret

00000000c00024f8 <print_mini_os_banner>:
#define MINI_OS_BUILD_YEAR 2026

volatile uint64_t boot_magic = PLAT_LOAD_ADDR;

static void print_mini_os_banner(void)
{
    c00024f8:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    c00024fc:	910003fd 	mov	x29, sp
    debug_puts("\n");
    c0002500:	f0000000 	adrp	x0, c0005000 <smp_init+0x68>
    c0002504:	913bc000 	add	x0, x0, #0xef0
    c0002508:	97fffe35 	bl	c0001ddc <debug_puts>
    debug_puts("============================================================\n");
    c000250c:	f0000000 	adrp	x0, c0005000 <smp_init+0x68>
    c0002510:	913be000 	add	x0, x0, #0xef8
    c0002514:	97fffe32 	bl	c0001ddc <debug_puts>
    debug_puts("            __  __   ___   _   _   ___    ___    ____      \n");
    c0002518:	f0000000 	adrp	x0, c0005000 <smp_init+0x68>
    c000251c:	913ce000 	add	x0, x0, #0xf38
    c0002520:	97fffe2f 	bl	c0001ddc <debug_puts>
    debug_puts("           |  \\/  | |_ _| | \\ | | |_ _|  / _ \\  / ___|     \n");
    c0002524:	f0000000 	adrp	x0, c0005000 <smp_init+0x68>
    c0002528:	913de000 	add	x0, x0, #0xf78
    c000252c:	97fffe2c 	bl	c0001ddc <debug_puts>
    debug_puts("           | |\\/| |  | |  |  \\| |  | |  | | | | \\___ \\     \n");
    c0002530:	f0000000 	adrp	x0, c0005000 <smp_init+0x68>
    c0002534:	913ee000 	add	x0, x0, #0xfb8
    c0002538:	97fffe29 	bl	c0001ddc <debug_puts>
    debug_puts("           | |  | |  | |  | |\\  |  | |  | |_| |  ___) |    \n");
    c000253c:	f0000000 	adrp	x0, c0005000 <smp_init+0x68>
    c0002540:	913fe000 	add	x0, x0, #0xff8
    c0002544:	97fffe26 	bl	c0001ddc <debug_puts>
    debug_puts("           |_|  |_| |___| |_| \\_| |___|  \\___/  |____/     \n");
    c0002548:	90000020 	adrp	x0, c0006000 <hex.0+0x128>
    c000254c:	9100e000 	add	x0, x0, #0x38
    c0002550:	97fffe23 	bl	c0001ddc <debug_puts>
    debug_puts("============================================================\n");
    c0002554:	f0000000 	adrp	x0, c0005000 <smp_init+0x68>
    c0002558:	913be000 	add	x0, x0, #0xef8
    c000255c:	97fffe20 	bl	c0001ddc <debug_puts>
    debug_puts("                     2026  Mini-OS  V0.1                    \n");
    c0002560:	90000020 	adrp	x0, c0006000 <hex.0+0x128>
    c0002564:	9101e000 	add	x0, x0, #0x78
    c0002568:	97fffe1d 	bl	c0001ddc <debug_puts>
    debug_puts("============================================================\n");
    c000256c:	f0000000 	adrp	x0, c0005000 <smp_init+0x68>
    c0002570:	913be000 	add	x0, x0, #0xef8
    c0002574:	97fffe1a 	bl	c0001ddc <debug_puts>
    debug_puts("\n");
    c0002578:	f0000000 	adrp	x0, c0005000 <smp_init+0x68>
    c000257c:	913bc000 	add	x0, x0, #0xef0
    c0002580:	97fffe17 	bl	c0001ddc <debug_puts>

    mini_os_printf("UART ready @ 0x%llx, boot magic: 0x%llx\n\n",
    c0002584:	b0000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c0002588:	910cc000 	add	x0, x0, #0x330
    c000258c:	f9400000 	ldr	x0, [x0]
    c0002590:	aa0003e2 	mov	x2, x0
    c0002594:	d2a34801 	mov	x1, #0x1a400000            	// #440401920
    c0002598:	90000020 	adrp	x0, c0006000 <hex.0+0x128>
    c000259c:	9102e000 	add	x0, x0, #0xb8
    c00025a0:	97fffdd5 	bl	c0001cf4 <mini_os_printf>
		       (unsigned long long)PLAT_UART0_BASE,
		       (unsigned long long)boot_magic);
}
    c00025a4:	d503201f 	nop
    c00025a8:	a8c17bfd 	ldp	x29, x30, [sp], #16
    c00025ac:	d65f03c0 	ret

00000000c00025b0 <initialize_phase0_modules>:

static void initialize_phase0_modules(void)
{
    c00025b0:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    c00025b4:	910003fd 	mov	x29, sp
    early_mm_init();
    c00025b8:	9400023a 	bl	c0002ea0 <early_mm_init>
    debug_console_init();
    c00025bc:	97fffdf1 	bl	c0001d80 <debug_console_init>
	topology_init();
    c00025c0:	94000c9c 	bl	c0005830 <topology_init>
	scheduler_init();
    c00025c4:	9400033e 	bl	c00032bc <scheduler_init>
	scheduler_join_cpu(0U);
    c00025c8:	52800000 	mov	w0, #0x0                   	// #0
    c00025cc:	9400036d 	bl	c0003380 <scheduler_join_cpu>
	smp_init();
    c00025d0:	94000a72 	bl	c0004f98 <smp_init>
	gic_init();
    c00025d4:	97ffffc7 	bl	c00024f0 <gic_init>
	test_framework_init();
    c00025d8:	94000c6a 	bl	c0005780 <test_framework_init>
}
    c00025dc:	d503201f 	nop
    c00025e0:	a8c17bfd 	ldp	x29, x30, [sp], #16
    c00025e4:	d65f03c0 	ret

00000000c00025e8 <kernel_main>:

void kernel_main(void)
{
    c00025e8:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    c00025ec:	910003fd 	mov	x29, sp
    initialize_phase0_modules();
    c00025f0:	97fffff0 	bl	c00025b0 <initialize_phase0_modules>
	print_mini_os_banner();
    c00025f4:	97ffffc1 	bl	c00024f8 <print_mini_os_banner>
	shell_run();
    c00025f8:	94000905 	bl	c0004a0c <shell_run>
    c00025fc:	d503201f 	nop
    c0002600:	a8c17bfd 	ldp	x29, x30, [sp], #16
    c0002604:	d65f03c0 	ret

00000000c0002608 <bitmap_set_bit>:
#include <kernel/lib/bitmap.h>

#define BITS_PER_WORD (sizeof(unsigned long) * 8U)

void bitmap_set_bit(unsigned long *bitmap, size_t bit)
{
    c0002608:	d10043ff 	sub	sp, sp, #0x10
    c000260c:	f90007e0 	str	x0, [sp, #8]
    c0002610:	f90003e1 	str	x1, [sp]
	bitmap[bit / BITS_PER_WORD] |= (1UL << (bit % BITS_PER_WORD));
    c0002614:	f94003e0 	ldr	x0, [sp]
    c0002618:	d346fc00 	lsr	x0, x0, #6
    c000261c:	d37df001 	lsl	x1, x0, #3
    c0002620:	f94007e2 	ldr	x2, [sp, #8]
    c0002624:	8b010041 	add	x1, x2, x1
    c0002628:	f9400022 	ldr	x2, [x1]
    c000262c:	f94003e1 	ldr	x1, [sp]
    c0002630:	12001421 	and	w1, w1, #0x3f
    c0002634:	d2800023 	mov	x3, #0x1                   	// #1
    c0002638:	9ac12061 	lsl	x1, x3, x1
    c000263c:	d37df000 	lsl	x0, x0, #3
    c0002640:	f94007e3 	ldr	x3, [sp, #8]
    c0002644:	8b000060 	add	x0, x3, x0
    c0002648:	aa010041 	orr	x1, x2, x1
    c000264c:	f9000001 	str	x1, [x0]
}
    c0002650:	d503201f 	nop
    c0002654:	910043ff 	add	sp, sp, #0x10
    c0002658:	d65f03c0 	ret

00000000c000265c <bitmap_clear_bit>:

void bitmap_clear_bit(unsigned long *bitmap, size_t bit)
{
    c000265c:	d10043ff 	sub	sp, sp, #0x10
    c0002660:	f90007e0 	str	x0, [sp, #8]
    c0002664:	f90003e1 	str	x1, [sp]
	bitmap[bit / BITS_PER_WORD] &= ~(1UL << (bit % BITS_PER_WORD));
    c0002668:	f94003e0 	ldr	x0, [sp]
    c000266c:	d346fc00 	lsr	x0, x0, #6
    c0002670:	d37df001 	lsl	x1, x0, #3
    c0002674:	f94007e2 	ldr	x2, [sp, #8]
    c0002678:	8b010041 	add	x1, x2, x1
    c000267c:	f9400022 	ldr	x2, [x1]
    c0002680:	f94003e1 	ldr	x1, [sp]
    c0002684:	12001421 	and	w1, w1, #0x3f
    c0002688:	d2800023 	mov	x3, #0x1                   	// #1
    c000268c:	9ac12061 	lsl	x1, x3, x1
    c0002690:	aa2103e1 	mvn	x1, x1
    c0002694:	d37df000 	lsl	x0, x0, #3
    c0002698:	f94007e3 	ldr	x3, [sp, #8]
    c000269c:	8b000060 	add	x0, x3, x0
    c00026a0:	8a010041 	and	x1, x2, x1
    c00026a4:	f9000001 	str	x1, [x0]
}
    c00026a8:	d503201f 	nop
    c00026ac:	910043ff 	add	sp, sp, #0x10
    c00026b0:	d65f03c0 	ret

00000000c00026b4 <bitmap_test_bit>:

bool bitmap_test_bit(const unsigned long *bitmap, size_t bit)
{
    c00026b4:	d10043ff 	sub	sp, sp, #0x10
    c00026b8:	f90007e0 	str	x0, [sp, #8]
    c00026bc:	f90003e1 	str	x1, [sp]
	return (bitmap[bit / BITS_PER_WORD] & (1UL << (bit % BITS_PER_WORD))) != 0UL;
    c00026c0:	f94003e0 	ldr	x0, [sp]
    c00026c4:	d346fc00 	lsr	x0, x0, #6
    c00026c8:	d37df000 	lsl	x0, x0, #3
    c00026cc:	f94007e1 	ldr	x1, [sp, #8]
    c00026d0:	8b000020 	add	x0, x1, x0
    c00026d4:	f9400001 	ldr	x1, [x0]
    c00026d8:	f94003e0 	ldr	x0, [sp]
    c00026dc:	12001400 	and	w0, w0, #0x3f
    c00026e0:	9ac02420 	lsr	x0, x1, x0
    c00026e4:	92400000 	and	x0, x0, #0x1
    c00026e8:	f100001f 	cmp	x0, #0x0
    c00026ec:	1a9f07e0 	cset	w0, ne	// ne = any
    c00026f0:	12001c00 	and	w0, w0, #0xff
    c00026f4:	910043ff 	add	sp, sp, #0x10
    c00026f8:	d65f03c0 	ret

00000000c00026fc <ringbuffer_init>:
#include <kernel/lib/ringbuffer.h>

void ringbuffer_init(struct ringbuffer *rb, uint8_t *storage, size_t capacity)
{
    c00026fc:	d10083ff 	sub	sp, sp, #0x20
    c0002700:	f9000fe0 	str	x0, [sp, #24]
    c0002704:	f9000be1 	str	x1, [sp, #16]
    c0002708:	f90007e2 	str	x2, [sp, #8]
	rb->data = storage;
    c000270c:	f9400fe0 	ldr	x0, [sp, #24]
    c0002710:	f9400be1 	ldr	x1, [sp, #16]
    c0002714:	f9000001 	str	x1, [x0]
	rb->capacity = capacity;
    c0002718:	f9400fe0 	ldr	x0, [sp, #24]
    c000271c:	f94007e1 	ldr	x1, [sp, #8]
    c0002720:	f9000401 	str	x1, [x0, #8]
	rb->head = 0U;
    c0002724:	f9400fe0 	ldr	x0, [sp, #24]
    c0002728:	f900081f 	str	xzr, [x0, #16]
	rb->tail = 0U;
    c000272c:	f9400fe0 	ldr	x0, [sp, #24]
    c0002730:	f9000c1f 	str	xzr, [x0, #24]
	rb->count = 0U;
    c0002734:	f9400fe0 	ldr	x0, [sp, #24]
    c0002738:	f900101f 	str	xzr, [x0, #32]
}
    c000273c:	d503201f 	nop
    c0002740:	910083ff 	add	sp, sp, #0x20
    c0002744:	d65f03c0 	ret

00000000c0002748 <ringbuffer_is_empty>:

bool ringbuffer_is_empty(const struct ringbuffer *rb)
{
    c0002748:	d10043ff 	sub	sp, sp, #0x10
    c000274c:	f90007e0 	str	x0, [sp, #8]
	return rb->count == 0U;
    c0002750:	f94007e0 	ldr	x0, [sp, #8]
    c0002754:	f9401000 	ldr	x0, [x0, #32]
    c0002758:	f100001f 	cmp	x0, #0x0
    c000275c:	1a9f17e0 	cset	w0, eq	// eq = none
    c0002760:	12001c00 	and	w0, w0, #0xff
}
    c0002764:	910043ff 	add	sp, sp, #0x10
    c0002768:	d65f03c0 	ret

00000000c000276c <ringbuffer_is_full>:

bool ringbuffer_is_full(const struct ringbuffer *rb)
{
    c000276c:	d10043ff 	sub	sp, sp, #0x10
    c0002770:	f90007e0 	str	x0, [sp, #8]
	return rb->count == rb->capacity;
    c0002774:	f94007e0 	ldr	x0, [sp, #8]
    c0002778:	f9401001 	ldr	x1, [x0, #32]
    c000277c:	f94007e0 	ldr	x0, [sp, #8]
    c0002780:	f9400400 	ldr	x0, [x0, #8]
    c0002784:	eb00003f 	cmp	x1, x0
    c0002788:	1a9f17e0 	cset	w0, eq	// eq = none
    c000278c:	12001c00 	and	w0, w0, #0xff
}
    c0002790:	910043ff 	add	sp, sp, #0x10
    c0002794:	d65f03c0 	ret

00000000c0002798 <ringbuffer_push>:

bool ringbuffer_push(struct ringbuffer *rb, uint8_t value)
{
    c0002798:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c000279c:	910003fd 	mov	x29, sp
    c00027a0:	f9000fe0 	str	x0, [sp, #24]
    c00027a4:	39005fe1 	strb	w1, [sp, #23]
	if (ringbuffer_is_full(rb)) {
    c00027a8:	f9400fe0 	ldr	x0, [sp, #24]
    c00027ac:	97fffff0 	bl	c000276c <ringbuffer_is_full>
    c00027b0:	12001c00 	and	w0, w0, #0xff
    c00027b4:	12000000 	and	w0, w0, #0x1
    c00027b8:	7100001f 	cmp	w0, #0x0
    c00027bc:	54000060 	b.eq	c00027c8 <ringbuffer_push+0x30>  // b.none
		return false;
    c00027c0:	52800000 	mov	w0, #0x0                   	// #0
    c00027c4:	14000018 	b	c0002824 <ringbuffer_push+0x8c>
	}

	rb->data[rb->head] = value;
    c00027c8:	f9400fe0 	ldr	x0, [sp, #24]
    c00027cc:	f9400001 	ldr	x1, [x0]
    c00027d0:	f9400fe0 	ldr	x0, [sp, #24]
    c00027d4:	f9400800 	ldr	x0, [x0, #16]
    c00027d8:	8b000020 	add	x0, x1, x0
    c00027dc:	39405fe1 	ldrb	w1, [sp, #23]
    c00027e0:	39000001 	strb	w1, [x0]
	rb->head = (rb->head + 1U) % rb->capacity;
    c00027e4:	f9400fe0 	ldr	x0, [sp, #24]
    c00027e8:	f9400800 	ldr	x0, [x0, #16]
    c00027ec:	91000400 	add	x0, x0, #0x1
    c00027f0:	f9400fe1 	ldr	x1, [sp, #24]
    c00027f4:	f9400421 	ldr	x1, [x1, #8]
    c00027f8:	9ac10802 	udiv	x2, x0, x1
    c00027fc:	9b017c41 	mul	x1, x2, x1
    c0002800:	cb010001 	sub	x1, x0, x1
    c0002804:	f9400fe0 	ldr	x0, [sp, #24]
    c0002808:	f9000801 	str	x1, [x0, #16]
	rb->count++;
    c000280c:	f9400fe0 	ldr	x0, [sp, #24]
    c0002810:	f9401000 	ldr	x0, [x0, #32]
    c0002814:	91000401 	add	x1, x0, #0x1
    c0002818:	f9400fe0 	ldr	x0, [sp, #24]
    c000281c:	f9001001 	str	x1, [x0, #32]
	return true;
    c0002820:	52800020 	mov	w0, #0x1                   	// #1
}
    c0002824:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c0002828:	d65f03c0 	ret

00000000c000282c <ringbuffer_pop>:

bool ringbuffer_pop(struct ringbuffer *rb, uint8_t *value)
{
    c000282c:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c0002830:	910003fd 	mov	x29, sp
    c0002834:	f9000fe0 	str	x0, [sp, #24]
    c0002838:	f9000be1 	str	x1, [sp, #16]
	if (ringbuffer_is_empty(rb)) {
    c000283c:	f9400fe0 	ldr	x0, [sp, #24]
    c0002840:	97ffffc2 	bl	c0002748 <ringbuffer_is_empty>
    c0002844:	12001c00 	and	w0, w0, #0xff
    c0002848:	12000000 	and	w0, w0, #0x1
    c000284c:	7100001f 	cmp	w0, #0x0
    c0002850:	54000060 	b.eq	c000285c <ringbuffer_pop+0x30>  // b.none
		return false;
    c0002854:	52800000 	mov	w0, #0x0                   	// #0
    c0002858:	14000019 	b	c00028bc <ringbuffer_pop+0x90>
	}

	*value = rb->data[rb->tail];
    c000285c:	f9400fe0 	ldr	x0, [sp, #24]
    c0002860:	f9400001 	ldr	x1, [x0]
    c0002864:	f9400fe0 	ldr	x0, [sp, #24]
    c0002868:	f9400c00 	ldr	x0, [x0, #24]
    c000286c:	8b000020 	add	x0, x1, x0
    c0002870:	39400001 	ldrb	w1, [x0]
    c0002874:	f9400be0 	ldr	x0, [sp, #16]
    c0002878:	39000001 	strb	w1, [x0]
	rb->tail = (rb->tail + 1U) % rb->capacity;
    c000287c:	f9400fe0 	ldr	x0, [sp, #24]
    c0002880:	f9400c00 	ldr	x0, [x0, #24]
    c0002884:	91000400 	add	x0, x0, #0x1
    c0002888:	f9400fe1 	ldr	x1, [sp, #24]
    c000288c:	f9400421 	ldr	x1, [x1, #8]
    c0002890:	9ac10802 	udiv	x2, x0, x1
    c0002894:	9b017c41 	mul	x1, x2, x1
    c0002898:	cb010001 	sub	x1, x0, x1
    c000289c:	f9400fe0 	ldr	x0, [sp, #24]
    c00028a0:	f9000c01 	str	x1, [x0, #24]
	rb->count--;
    c00028a4:	f9400fe0 	ldr	x0, [sp, #24]
    c00028a8:	f9401000 	ldr	x0, [x0, #32]
    c00028ac:	d1000401 	sub	x1, x0, #0x1
    c00028b0:	f9400fe0 	ldr	x0, [sp, #24]
    c00028b4:	f9001001 	str	x1, [x0, #32]
	return true;
    c00028b8:	52800020 	mov	w0, #0x1                   	// #1
    c00028bc:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c00028c0:	d65f03c0 	ret

00000000c00028c4 <mini_os_strlen>:
#include <kernel/lib/string.h>

size_t mini_os_strlen(const char *str)
{
    c00028c4:	d10083ff 	sub	sp, sp, #0x20
    c00028c8:	f90007e0 	str	x0, [sp, #8]
	size_t len = 0U;
    c00028cc:	f9000fff 	str	xzr, [sp, #24]

	if (str == (const char *)0) {
    c00028d0:	f94007e0 	ldr	x0, [sp, #8]
    c00028d4:	f100001f 	cmp	x0, #0x0
    c00028d8:	540000c1 	b.ne	c00028f0 <mini_os_strlen+0x2c>  // b.any
		return 0U;
    c00028dc:	d2800000 	mov	x0, #0x0                   	// #0
    c00028e0:	1400000b 	b	c000290c <mini_os_strlen+0x48>
	}

	while (str[len] != '\0') {
		len++;
    c00028e4:	f9400fe0 	ldr	x0, [sp, #24]
    c00028e8:	91000400 	add	x0, x0, #0x1
    c00028ec:	f9000fe0 	str	x0, [sp, #24]
	while (str[len] != '\0') {
    c00028f0:	f94007e1 	ldr	x1, [sp, #8]
    c00028f4:	f9400fe0 	ldr	x0, [sp, #24]
    c00028f8:	8b000020 	add	x0, x1, x0
    c00028fc:	39400000 	ldrb	w0, [x0]
    c0002900:	7100001f 	cmp	w0, #0x0
    c0002904:	54ffff01 	b.ne	c00028e4 <mini_os_strlen+0x20>  // b.any
	}

	return len;
    c0002908:	f9400fe0 	ldr	x0, [sp, #24]
}
    c000290c:	910083ff 	add	sp, sp, #0x20
    c0002910:	d65f03c0 	ret

00000000c0002914 <mini_os_strcmp>:

int mini_os_strcmp(const char *lhs, const char *rhs)
{
    c0002914:	d10043ff 	sub	sp, sp, #0x10
    c0002918:	f90007e0 	str	x0, [sp, #8]
    c000291c:	f90003e1 	str	x1, [sp]
	while ((*lhs != '\0') && (*lhs == *rhs)) {
    c0002920:	14000007 	b	c000293c <mini_os_strcmp+0x28>
		lhs++;
    c0002924:	f94007e0 	ldr	x0, [sp, #8]
    c0002928:	91000400 	add	x0, x0, #0x1
    c000292c:	f90007e0 	str	x0, [sp, #8]
		rhs++;
    c0002930:	f94003e0 	ldr	x0, [sp]
    c0002934:	91000400 	add	x0, x0, #0x1
    c0002938:	f90003e0 	str	x0, [sp]
	while ((*lhs != '\0') && (*lhs == *rhs)) {
    c000293c:	f94007e0 	ldr	x0, [sp, #8]
    c0002940:	39400000 	ldrb	w0, [x0]
    c0002944:	7100001f 	cmp	w0, #0x0
    c0002948:	540000e0 	b.eq	c0002964 <mini_os_strcmp+0x50>  // b.none
    c000294c:	f94007e0 	ldr	x0, [sp, #8]
    c0002950:	39400001 	ldrb	w1, [x0]
    c0002954:	f94003e0 	ldr	x0, [sp]
    c0002958:	39400000 	ldrb	w0, [x0]
    c000295c:	6b00003f 	cmp	w1, w0
    c0002960:	54fffe20 	b.eq	c0002924 <mini_os_strcmp+0x10>  // b.none
	}

	return (int)(unsigned char)*lhs - (int)(unsigned char)*rhs;
    c0002964:	f94007e0 	ldr	x0, [sp, #8]
    c0002968:	39400000 	ldrb	w0, [x0]
    c000296c:	2a0003e1 	mov	w1, w0
    c0002970:	f94003e0 	ldr	x0, [sp]
    c0002974:	39400000 	ldrb	w0, [x0]
    c0002978:	4b000020 	sub	w0, w1, w0
    c000297c:	910043ff 	add	sp, sp, #0x10
    c0002980:	d65f03c0 	ret

00000000c0002984 <spinlock_read_mpidr>:
#include <kernel/spinlock.h>
#include <kernel/topology.h>

static inline uint64_t spinlock_read_mpidr(void)
{
    c0002984:	d10043ff 	sub	sp, sp, #0x10
	uint64_t mpidr;

	__asm__ volatile ("mrs %0, mpidr_el1" : "=r" (mpidr));
    c0002988:	d53800a0 	mrs	x0, mpidr_el1
    c000298c:	f90007e0 	str	x0, [sp, #8]
	return mpidr;
    c0002990:	f94007e0 	ldr	x0, [sp, #8]
}
    c0002994:	910043ff 	add	sp, sp, #0x10
    c0002998:	d65f03c0 	ret

00000000c000299c <spinlock_cpu_slot>:

static unsigned int spinlock_cpu_slot(void)
{
    c000299c:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c00029a0:	910003fd 	mov	x29, sp
	const struct cpu_topology_descriptor *cpu;

	cpu = topology_find_cpu_by_mpidr(spinlock_read_mpidr());
    c00029a4:	97fffff8 	bl	c0002984 <spinlock_read_mpidr>
    c00029a8:	94000c0f 	bl	c00059e4 <topology_find_cpu_by_mpidr>
    c00029ac:	f9000fe0 	str	x0, [sp, #24]
	if (cpu != (const struct cpu_topology_descriptor *)0) {
    c00029b0:	f9400fe0 	ldr	x0, [sp, #24]
    c00029b4:	f100001f 	cmp	x0, #0x0
    c00029b8:	54000080 	b.eq	c00029c8 <spinlock_cpu_slot+0x2c>  // b.none
		return cpu->logical_id;
    c00029bc:	f9400fe0 	ldr	x0, [sp, #24]
    c00029c0:	b9400800 	ldr	w0, [x0, #8]
    c00029c4:	14000002 	b	c00029cc <spinlock_cpu_slot+0x30>
	}

	return 0U;
    c00029c8:	52800000 	mov	w0, #0x0                   	// #0
}
    c00029cc:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c00029d0:	d65f03c0 	ret

00000000c00029d4 <spinlock_init>:

void spinlock_init(struct spinlock *lock)
{
    c00029d4:	d10083ff 	sub	sp, sp, #0x20
    c00029d8:	f90007e0 	str	x0, [sp, #8]
	unsigned int i;

	if (lock == (struct spinlock *)0) {
    c00029dc:	f94007e0 	ldr	x0, [sp, #8]
    c00029e0:	f100001f 	cmp	x0, #0x0
    c00029e4:	54000240 	b.eq	c0002a2c <spinlock_init+0x58>  // b.none
		return;
	}

	for (i = 0U; i < PLAT_MAX_CPUS; ++i) {
    c00029e8:	b9001fff 	str	wzr, [sp, #28]
    c00029ec:	1400000c 	b	c0002a1c <spinlock_init+0x48>
		lock->choosing[i] = 0U;
    c00029f0:	f94007e1 	ldr	x1, [sp, #8]
    c00029f4:	b9401fe0 	ldr	w0, [sp, #28]
    c00029f8:	3820683f 	strb	wzr, [x1, x0]
		lock->tickets[i] = 0U;
    c00029fc:	f94007e1 	ldr	x1, [sp, #8]
    c0002a00:	b9401fe0 	ldr	w0, [sp, #28]
    c0002a04:	d37ef400 	lsl	x0, x0, #2
    c0002a08:	8b000020 	add	x0, x1, x0
    c0002a0c:	b900081f 	str	wzr, [x0, #8]
	for (i = 0U; i < PLAT_MAX_CPUS; ++i) {
    c0002a10:	b9401fe0 	ldr	w0, [sp, #28]
    c0002a14:	11000400 	add	w0, w0, #0x1
    c0002a18:	b9001fe0 	str	w0, [sp, #28]
    c0002a1c:	b9401fe0 	ldr	w0, [sp, #28]
    c0002a20:	71001c1f 	cmp	w0, #0x7
    c0002a24:	54fffe69 	b.ls	c00029f0 <spinlock_init+0x1c>  // b.plast
    c0002a28:	14000002 	b	c0002a30 <spinlock_init+0x5c>
		return;
    c0002a2c:	d503201f 	nop
	}
}
    c0002a30:	910083ff 	add	sp, sp, #0x20
    c0002a34:	d65f03c0 	ret

00000000c0002a38 <spinlock_try_lock>:

int spinlock_try_lock(struct spinlock *lock)
{
    c0002a38:	a9bc7bfd 	stp	x29, x30, [sp, #-64]!
    c0002a3c:	910003fd 	mov	x29, sp
    c0002a40:	f9000fe0 	str	x0, [sp, #24]
	unsigned int slot;
	unsigned int i;
	uint32_t max_ticket = 0U;
    c0002a44:	b9003bff 	str	wzr, [sp, #56]
	uint32_t my_ticket;

	if (lock == (struct spinlock *)0) {
    c0002a48:	f9400fe0 	ldr	x0, [sp, #24]
    c0002a4c:	f100001f 	cmp	x0, #0x0
    c0002a50:	54000061 	b.ne	c0002a5c <spinlock_try_lock+0x24>  // b.any
		return 0;
    c0002a54:	52800000 	mov	w0, #0x0                   	// #0
    c0002a58:	14000068 	b	c0002bf8 <spinlock_try_lock+0x1c0>
	}

	slot = spinlock_cpu_slot();
    c0002a5c:	97ffffd0 	bl	c000299c <spinlock_cpu_slot>
    c0002a60:	b90033e0 	str	w0, [sp, #48]
	if (lock->tickets[slot] != 0U) {
    c0002a64:	f9400fe1 	ldr	x1, [sp, #24]
    c0002a68:	b94033e0 	ldr	w0, [sp, #48]
    c0002a6c:	d37ef400 	lsl	x0, x0, #2
    c0002a70:	8b000020 	add	x0, x1, x0
    c0002a74:	b9400800 	ldr	w0, [x0, #8]
    c0002a78:	7100001f 	cmp	w0, #0x0
    c0002a7c:	54000060 	b.eq	c0002a88 <spinlock_try_lock+0x50>  // b.none
		return 1;
    c0002a80:	52800020 	mov	w0, #0x1                   	// #1
    c0002a84:	1400005d 	b	c0002bf8 <spinlock_try_lock+0x1c0>
	}

	lock->choosing[slot] = 1U;
    c0002a88:	f9400fe1 	ldr	x1, [sp, #24]
    c0002a8c:	b94033e0 	ldr	w0, [sp, #48]
    c0002a90:	52800022 	mov	w2, #0x1                   	// #1
    c0002a94:	38206822 	strb	w2, [x1, x0]
	for (i = 0U; i < PLAT_MAX_CPUS; ++i) {
    c0002a98:	b9003fff 	str	wzr, [sp, #60]
    c0002a9c:	14000012 	b	c0002ae4 <spinlock_try_lock+0xac>
		if (lock->tickets[i] > max_ticket) {
    c0002aa0:	f9400fe1 	ldr	x1, [sp, #24]
    c0002aa4:	b9403fe0 	ldr	w0, [sp, #60]
    c0002aa8:	d37ef400 	lsl	x0, x0, #2
    c0002aac:	8b000020 	add	x0, x1, x0
    c0002ab0:	b9400800 	ldr	w0, [x0, #8]
    c0002ab4:	b9403be1 	ldr	w1, [sp, #56]
    c0002ab8:	6b00003f 	cmp	w1, w0
    c0002abc:	540000e2 	b.cs	c0002ad8 <spinlock_try_lock+0xa0>  // b.hs, b.nlast
			max_ticket = lock->tickets[i];
    c0002ac0:	f9400fe1 	ldr	x1, [sp, #24]
    c0002ac4:	b9403fe0 	ldr	w0, [sp, #60]
    c0002ac8:	d37ef400 	lsl	x0, x0, #2
    c0002acc:	8b000020 	add	x0, x1, x0
    c0002ad0:	b9400800 	ldr	w0, [x0, #8]
    c0002ad4:	b9003be0 	str	w0, [sp, #56]
	for (i = 0U; i < PLAT_MAX_CPUS; ++i) {
    c0002ad8:	b9403fe0 	ldr	w0, [sp, #60]
    c0002adc:	11000400 	add	w0, w0, #0x1
    c0002ae0:	b9003fe0 	str	w0, [sp, #60]
    c0002ae4:	b9403fe0 	ldr	w0, [sp, #60]
    c0002ae8:	71001c1f 	cmp	w0, #0x7
    c0002aec:	54fffda9 	b.ls	c0002aa0 <spinlock_try_lock+0x68>  // b.plast
		}
	}

	my_ticket = max_ticket + 1U;
    c0002af0:	b9403be0 	ldr	w0, [sp, #56]
    c0002af4:	11000400 	add	w0, w0, #0x1
    c0002af8:	b90037e0 	str	w0, [sp, #52]
	if (my_ticket == 0U) {
    c0002afc:	b94037e0 	ldr	w0, [sp, #52]
    c0002b00:	7100001f 	cmp	w0, #0x0
    c0002b04:	54000061 	b.ne	c0002b10 <spinlock_try_lock+0xd8>  // b.any
		my_ticket = 1U;
    c0002b08:	52800020 	mov	w0, #0x1                   	// #1
    c0002b0c:	b90037e0 	str	w0, [sp, #52]
	}

	lock->tickets[slot] = my_ticket;
    c0002b10:	f9400fe1 	ldr	x1, [sp, #24]
    c0002b14:	b94033e0 	ldr	w0, [sp, #48]
    c0002b18:	d37ef400 	lsl	x0, x0, #2
    c0002b1c:	8b000020 	add	x0, x1, x0
    c0002b20:	b94037e1 	ldr	w1, [sp, #52]
    c0002b24:	b9000801 	str	w1, [x0, #8]
	lock->choosing[slot] = 0U;
    c0002b28:	f9400fe1 	ldr	x1, [sp, #24]
    c0002b2c:	b94033e0 	ldr	w0, [sp, #48]
    c0002b30:	3820683f 	strb	wzr, [x1, x0]

	for (i = 0U; i < PLAT_MAX_CPUS; ++i) {
    c0002b34:	b9003fff 	str	wzr, [sp, #60]
    c0002b38:	1400002c 	b	c0002be8 <spinlock_try_lock+0x1b0>
		uint32_t other_ticket;

		if (i == slot) {
    c0002b3c:	b9403fe1 	ldr	w1, [sp, #60]
    c0002b40:	b94033e0 	ldr	w0, [sp, #48]
    c0002b44:	6b00003f 	cmp	w1, w0
    c0002b48:	540003c0 	b.eq	c0002bc0 <spinlock_try_lock+0x188>  // b.none
			continue;
		}

		while (lock->choosing[i] != 0U) {
    c0002b4c:	d503201f 	nop
    c0002b50:	f9400fe1 	ldr	x1, [sp, #24]
    c0002b54:	b9403fe0 	ldr	w0, [sp, #60]
    c0002b58:	38606820 	ldrb	w0, [x1, x0]
    c0002b5c:	12001c00 	and	w0, w0, #0xff
    c0002b60:	7100001f 	cmp	w0, #0x0
    c0002b64:	54ffff61 	b.ne	c0002b50 <spinlock_try_lock+0x118>  // b.any
		}

		for (;;) {
			other_ticket = lock->tickets[i];
    c0002b68:	f9400fe1 	ldr	x1, [sp, #24]
    c0002b6c:	b9403fe0 	ldr	w0, [sp, #60]
    c0002b70:	d37ef400 	lsl	x0, x0, #2
    c0002b74:	8b000020 	add	x0, x1, x0
    c0002b78:	b9400800 	ldr	w0, [x0, #8]
    c0002b7c:	b9002fe0 	str	w0, [sp, #44]
			if (other_ticket == 0U) {
    c0002b80:	b9402fe0 	ldr	w0, [sp, #44]
    c0002b84:	7100001f 	cmp	w0, #0x0
    c0002b88:	54000200 	b.eq	c0002bc8 <spinlock_try_lock+0x190>  // b.none
				break;
			}

			if (other_ticket > my_ticket) {
    c0002b8c:	b9402fe1 	ldr	w1, [sp, #44]
    c0002b90:	b94037e0 	ldr	w0, [sp, #52]
    c0002b94:	6b00003f 	cmp	w1, w0
    c0002b98:	540001c8 	b.hi	c0002bd0 <spinlock_try_lock+0x198>  // b.pmore
				break;
			}

			if ((other_ticket == my_ticket) && (i > slot)) {
    c0002b9c:	b9402fe1 	ldr	w1, [sp, #44]
    c0002ba0:	b94037e0 	ldr	w0, [sp, #52]
    c0002ba4:	6b00003f 	cmp	w1, w0
    c0002ba8:	54fffe01 	b.ne	c0002b68 <spinlock_try_lock+0x130>  // b.any
    c0002bac:	b9403fe1 	ldr	w1, [sp, #60]
    c0002bb0:	b94033e0 	ldr	w0, [sp, #48]
    c0002bb4:	6b00003f 	cmp	w1, w0
    c0002bb8:	54000108 	b.hi	c0002bd8 <spinlock_try_lock+0x1a0>  // b.pmore
			other_ticket = lock->tickets[i];
    c0002bbc:	17ffffeb 	b	c0002b68 <spinlock_try_lock+0x130>
			continue;
    c0002bc0:	d503201f 	nop
    c0002bc4:	14000006 	b	c0002bdc <spinlock_try_lock+0x1a4>
				break;
    c0002bc8:	d503201f 	nop
    c0002bcc:	14000004 	b	c0002bdc <spinlock_try_lock+0x1a4>
				break;
    c0002bd0:	d503201f 	nop
    c0002bd4:	14000002 	b	c0002bdc <spinlock_try_lock+0x1a4>
				break;
    c0002bd8:	d503201f 	nop
	for (i = 0U; i < PLAT_MAX_CPUS; ++i) {
    c0002bdc:	b9403fe0 	ldr	w0, [sp, #60]
    c0002be0:	11000400 	add	w0, w0, #0x1
    c0002be4:	b9003fe0 	str	w0, [sp, #60]
    c0002be8:	b9403fe0 	ldr	w0, [sp, #60]
    c0002bec:	71001c1f 	cmp	w0, #0x7
    c0002bf0:	54fffa69 	b.ls	c0002b3c <spinlock_try_lock+0x104>  // b.plast
			}
		}
	}

	return 1;
    c0002bf4:	52800020 	mov	w0, #0x1                   	// #1
}
    c0002bf8:	a8c47bfd 	ldp	x29, x30, [sp], #64
    c0002bfc:	d65f03c0 	ret

00000000c0002c00 <spinlock_lock>:

void spinlock_lock(struct spinlock *lock)
{
    c0002c00:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c0002c04:	910003fd 	mov	x29, sp
    c0002c08:	f9000fe0 	str	x0, [sp, #24]
	(void)spinlock_try_lock(lock);
    c0002c0c:	f9400fe0 	ldr	x0, [sp, #24]
    c0002c10:	97ffff8a 	bl	c0002a38 <spinlock_try_lock>
}
    c0002c14:	d503201f 	nop
    c0002c18:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c0002c1c:	d65f03c0 	ret

00000000c0002c20 <spinlock_unlock>:

void spinlock_unlock(struct spinlock *lock)
{
    c0002c20:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
    c0002c24:	910003fd 	mov	x29, sp
    c0002c28:	f9000fe0 	str	x0, [sp, #24]
	unsigned int slot;

	if (lock == (struct spinlock *)0) {
    c0002c2c:	f9400fe0 	ldr	x0, [sp, #24]
    c0002c30:	f100001f 	cmp	x0, #0x0
    c0002c34:	54000120 	b.eq	c0002c58 <spinlock_unlock+0x38>  // b.none
		return;
	}

	slot = spinlock_cpu_slot();
    c0002c38:	97ffff59 	bl	c000299c <spinlock_cpu_slot>
    c0002c3c:	b9002fe0 	str	w0, [sp, #44]
	lock->tickets[slot] = 0U;
    c0002c40:	f9400fe1 	ldr	x1, [sp, #24]
    c0002c44:	b9402fe0 	ldr	w0, [sp, #44]
    c0002c48:	d37ef400 	lsl	x0, x0, #2
    c0002c4c:	8b000020 	add	x0, x1, x0
    c0002c50:	b900081f 	str	wzr, [x0, #8]
    c0002c54:	14000002 	b	c0002c5c <spinlock_unlock+0x3c>
		return;
    c0002c58:	d503201f 	nop
    c0002c5c:	a8c37bfd 	ldp	x29, x30, [sp], #48
    c0002c60:	d65f03c0 	ret

00000000c0002c64 <align_up_uintptr>:
static const char *last_allocation_tag;
static uintptr_t last_allocation_base;
static size_t last_allocation_size;

static uintptr_t align_up_uintptr(uintptr_t value, size_t align)
{
    c0002c64:	d10083ff 	sub	sp, sp, #0x20
    c0002c68:	f90007e0 	str	x0, [sp, #8]
    c0002c6c:	f90003e1 	str	x1, [sp]
	uintptr_t mask;

	if (align <= 1U) {
    c0002c70:	f94003e0 	ldr	x0, [sp]
    c0002c74:	f100041f 	cmp	x0, #0x1
    c0002c78:	54000068 	b.hi	c0002c84 <align_up_uintptr+0x20>  // b.pmore
		return value;
    c0002c7c:	f94007e0 	ldr	x0, [sp, #8]
    c0002c80:	1400000a 	b	c0002ca8 <align_up_uintptr+0x44>
	}

	mask = (uintptr_t)align - 1U;
    c0002c84:	f94003e0 	ldr	x0, [sp]
    c0002c88:	d1000400 	sub	x0, x0, #0x1
    c0002c8c:	f9000fe0 	str	x0, [sp, #24]
	return (value + mask) & ~mask;
    c0002c90:	f94007e1 	ldr	x1, [sp, #8]
    c0002c94:	f9400fe0 	ldr	x0, [sp, #24]
    c0002c98:	8b000021 	add	x1, x1, x0
    c0002c9c:	f9400fe0 	ldr	x0, [sp, #24]
    c0002ca0:	aa2003e0 	mvn	x0, x0
    c0002ca4:	8a000020 	and	x0, x1, x0
}
    c0002ca8:	910083ff 	add	sp, sp, #0x20
    c0002cac:	d65f03c0 	ret

00000000c0002cb0 <zero_memory>:

static void zero_memory(unsigned char *memory, size_t size)
{
    c0002cb0:	d10083ff 	sub	sp, sp, #0x20
    c0002cb4:	f90007e0 	str	x0, [sp, #8]
    c0002cb8:	f90003e1 	str	x1, [sp]
	size_t i;

	for (i = 0U; i < size; ++i) {
    c0002cbc:	f9000fff 	str	xzr, [sp, #24]
    c0002cc0:	14000008 	b	c0002ce0 <zero_memory+0x30>
		memory[i] = 0U;
    c0002cc4:	f94007e1 	ldr	x1, [sp, #8]
    c0002cc8:	f9400fe0 	ldr	x0, [sp, #24]
    c0002ccc:	8b000020 	add	x0, x1, x0
    c0002cd0:	3900001f 	strb	wzr, [x0]
	for (i = 0U; i < size; ++i) {
    c0002cd4:	f9400fe0 	ldr	x0, [sp, #24]
    c0002cd8:	91000400 	add	x0, x0, #0x1
    c0002cdc:	f9000fe0 	str	x0, [sp, #24]
    c0002ce0:	f9400fe1 	ldr	x1, [sp, #24]
    c0002ce4:	f94003e0 	ldr	x0, [sp]
    c0002ce8:	eb00003f 	cmp	x1, x0
    c0002cec:	54fffec3 	b.cc	c0002cc4 <zero_memory+0x14>  // b.lo, b.ul, b.last
	}
}
    c0002cf0:	d503201f 	nop
    c0002cf4:	d503201f 	nop
    c0002cf8:	910083ff 	add	sp, sp, #0x20
    c0002cfc:	d65f03c0 	ret

00000000c0002d00 <early_mm_region_init>:

static void early_mm_region_init(struct early_mm_region *region,
				     const char *name,
				     uintptr_t start,
				     uintptr_t end)
{
    c0002d00:	d10083ff 	sub	sp, sp, #0x20
    c0002d04:	f9000fe0 	str	x0, [sp, #24]
    c0002d08:	f9000be1 	str	x1, [sp, #16]
    c0002d0c:	f90007e2 	str	x2, [sp, #8]
    c0002d10:	f90003e3 	str	x3, [sp]
	if (region == (struct early_mm_region *)0) {
    c0002d14:	f9400fe0 	ldr	x0, [sp, #24]
    c0002d18:	f100001f 	cmp	x0, #0x0
    c0002d1c:	54000240 	b.eq	c0002d64 <early_mm_region_init+0x64>  // b.none
		return;
	}

	region->name = name;
    c0002d20:	f9400fe0 	ldr	x0, [sp, #24]
    c0002d24:	f9400be1 	ldr	x1, [sp, #16]
    c0002d28:	f9000001 	str	x1, [x0]
	region->start = start;
    c0002d2c:	f9400fe0 	ldr	x0, [sp, #24]
    c0002d30:	f94007e1 	ldr	x1, [sp, #8]
    c0002d34:	f9000401 	str	x1, [x0, #8]
	region->current = start;
    c0002d38:	f9400fe0 	ldr	x0, [sp, #24]
    c0002d3c:	f94007e1 	ldr	x1, [sp, #8]
    c0002d40:	f9000801 	str	x1, [x0, #16]
	region->end = end;
    c0002d44:	f9400fe0 	ldr	x0, [sp, #24]
    c0002d48:	f94003e1 	ldr	x1, [sp]
    c0002d4c:	f9000c01 	str	x1, [x0, #24]
	region->allocation_count = 0U;
    c0002d50:	f9400fe0 	ldr	x0, [sp, #24]
    c0002d54:	f900101f 	str	xzr, [x0, #32]
	region->peak_used_bytes = 0U;
    c0002d58:	f9400fe0 	ldr	x0, [sp, #24]
    c0002d5c:	f900141f 	str	xzr, [x0, #40]
    c0002d60:	14000002 	b	c0002d68 <early_mm_region_init+0x68>
		return;
    c0002d64:	d503201f 	nop
}
    c0002d68:	910083ff 	add	sp, sp, #0x20
    c0002d6c:	d65f03c0 	ret

00000000c0002d70 <early_mm_region_alloc>:

static void *early_mm_region_alloc(struct early_mm_region *region,
				   size_t size,
				   size_t align,
				   const char *tag)
{
    c0002d70:	a9bb7bfd 	stp	x29, x30, [sp, #-80]!
    c0002d74:	910003fd 	mov	x29, sp
    c0002d78:	f90017e0 	str	x0, [sp, #40]
    c0002d7c:	f90013e1 	str	x1, [sp, #32]
    c0002d80:	f9000fe2 	str	x2, [sp, #24]
    c0002d84:	f9000be3 	str	x3, [sp, #16]
	uintptr_t current;
	uintptr_t next;
	size_t used_bytes;
	unsigned char *memory;

	if ((region == (struct early_mm_region *)0) || (size == 0U)) {
    c0002d88:	f94017e0 	ldr	x0, [sp, #40]
    c0002d8c:	f100001f 	cmp	x0, #0x0
    c0002d90:	54000080 	b.eq	c0002da0 <early_mm_region_alloc+0x30>  // b.none
    c0002d94:	f94013e0 	ldr	x0, [sp, #32]
    c0002d98:	f100001f 	cmp	x0, #0x0
    c0002d9c:	54000061 	b.ne	c0002da8 <early_mm_region_alloc+0x38>  // b.any
		return (void *)0;
    c0002da0:	d2800000 	mov	x0, #0x0                   	// #0
    c0002da4:	1400003d 	b	c0002e98 <early_mm_region_alloc+0x128>
	}

	current = align_up_uintptr(region->current, align);
    c0002da8:	f94017e0 	ldr	x0, [sp, #40]
    c0002dac:	f9400800 	ldr	x0, [x0, #16]
    c0002db0:	f9400fe1 	ldr	x1, [sp, #24]
    c0002db4:	97ffffac 	bl	c0002c64 <align_up_uintptr>
    c0002db8:	f90027e0 	str	x0, [sp, #72]
	next = current + (uintptr_t)size;
    c0002dbc:	f94027e1 	ldr	x1, [sp, #72]
    c0002dc0:	f94013e0 	ldr	x0, [sp, #32]
    c0002dc4:	8b000020 	add	x0, x1, x0
    c0002dc8:	f90023e0 	str	x0, [sp, #64]
	if ((next < current) || (next > region->end)) {
    c0002dcc:	f94023e1 	ldr	x1, [sp, #64]
    c0002dd0:	f94027e0 	ldr	x0, [sp, #72]
    c0002dd4:	eb00003f 	cmp	x1, x0
    c0002dd8:	540000c3 	b.cc	c0002df0 <early_mm_region_alloc+0x80>  // b.lo, b.ul, b.last
    c0002ddc:	f94017e0 	ldr	x0, [sp, #40]
    c0002de0:	f9400c00 	ldr	x0, [x0, #24]
    c0002de4:	f94023e1 	ldr	x1, [sp, #64]
    c0002de8:	eb00003f 	cmp	x1, x0
    c0002dec:	54000069 	b.ls	c0002df8 <early_mm_region_alloc+0x88>  // b.plast
		return (void *)0;
    c0002df0:	d2800000 	mov	x0, #0x0                   	// #0
    c0002df4:	14000029 	b	c0002e98 <early_mm_region_alloc+0x128>
	}

	memory = (unsigned char *)current;
    c0002df8:	f94027e0 	ldr	x0, [sp, #72]
    c0002dfc:	f9001fe0 	str	x0, [sp, #56]
	zero_memory(memory, size);
    c0002e00:	f94013e1 	ldr	x1, [sp, #32]
    c0002e04:	f9401fe0 	ldr	x0, [sp, #56]
    c0002e08:	97ffffaa 	bl	c0002cb0 <zero_memory>

	region->current = next;
    c0002e0c:	f94017e0 	ldr	x0, [sp, #40]
    c0002e10:	f94023e1 	ldr	x1, [sp, #64]
    c0002e14:	f9000801 	str	x1, [x0, #16]
	region->allocation_count++;
    c0002e18:	f94017e0 	ldr	x0, [sp, #40]
    c0002e1c:	f9401000 	ldr	x0, [x0, #32]
    c0002e20:	91000401 	add	x1, x0, #0x1
    c0002e24:	f94017e0 	ldr	x0, [sp, #40]
    c0002e28:	f9001001 	str	x1, [x0, #32]
	used_bytes = (size_t)(region->current - region->start);
    c0002e2c:	f94017e0 	ldr	x0, [sp, #40]
    c0002e30:	f9400801 	ldr	x1, [x0, #16]
    c0002e34:	f94017e0 	ldr	x0, [sp, #40]
    c0002e38:	f9400400 	ldr	x0, [x0, #8]
    c0002e3c:	cb000020 	sub	x0, x1, x0
    c0002e40:	f9001be0 	str	x0, [sp, #48]
	if (used_bytes > region->peak_used_bytes) {
    c0002e44:	f94017e0 	ldr	x0, [sp, #40]
    c0002e48:	f9401400 	ldr	x0, [x0, #40]
    c0002e4c:	f9401be1 	ldr	x1, [sp, #48]
    c0002e50:	eb00003f 	cmp	x1, x0
    c0002e54:	54000089 	b.ls	c0002e64 <early_mm_region_alloc+0xf4>  // b.plast
		region->peak_used_bytes = used_bytes;
    c0002e58:	f94017e0 	ldr	x0, [sp, #40]
    c0002e5c:	f9401be1 	ldr	x1, [sp, #48]
    c0002e60:	f9001401 	str	x1, [x0, #40]
	}

	last_allocation_tag = tag;
    c0002e64:	b0000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c0002e68:	910e6000 	add	x0, x0, #0x398
    c0002e6c:	f9400be1 	ldr	x1, [sp, #16]
    c0002e70:	f9000001 	str	x1, [x0]
	last_allocation_base = current;
    c0002e74:	b0000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c0002e78:	910e8000 	add	x0, x0, #0x3a0
    c0002e7c:	f94027e1 	ldr	x1, [sp, #72]
    c0002e80:	f9000001 	str	x1, [x0]
	last_allocation_size = size;
    c0002e84:	b0000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c0002e88:	910ea000 	add	x0, x0, #0x3a8
    c0002e8c:	f94013e1 	ldr	x1, [sp, #32]
    c0002e90:	f9000001 	str	x1, [x0]
	return memory;
    c0002e94:	f9401fe0 	ldr	x0, [sp, #56]
}
    c0002e98:	a8c57bfd 	ldp	x29, x30, [sp], #80
    c0002e9c:	d65f03c0 	ret

00000000c0002ea0 <early_mm_init>:

void early_mm_init(void)
{
    c0002ea0:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    c0002ea4:	910003fd 	mov	x29, sp
	early_mm_region_init(&boot_heap_region, "boot-heap",
    c0002ea8:	b0000140 	adrp	x0, c002b000 <__bss_end+0x3a20>
    c0002eac:	91180001 	add	x1, x0, #0x600
    c0002eb0:	b0000240 	adrp	x0, c004b000 <__heap_start+0x1fa00>
    c0002eb4:	91180000 	add	x0, x0, #0x600
    c0002eb8:	aa0003e3 	mov	x3, x0
    c0002ebc:	aa0103e2 	mov	x2, x1
    c0002ec0:	90000020 	adrp	x0, c0006000 <hex.0+0x128>
    c0002ec4:	9103a001 	add	x1, x0, #0xe8
    c0002ec8:	b0000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c0002ecc:	910da000 	add	x0, x0, #0x368
    c0002ed0:	97ffff8c 	bl	c0002d00 <early_mm_region_init>
			     (uintptr_t)__heap_start,
			     (uintptr_t)__heap_end);
	last_allocation_tag = (const char *)0;
    c0002ed4:	b0000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c0002ed8:	910e6000 	add	x0, x0, #0x398
    c0002edc:	f900001f 	str	xzr, [x0]
	last_allocation_base = 0U;
    c0002ee0:	b0000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c0002ee4:	910e8000 	add	x0, x0, #0x3a0
    c0002ee8:	f900001f 	str	xzr, [x0]
	last_allocation_size = 0U;
    c0002eec:	b0000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c0002ef0:	910ea000 	add	x0, x0, #0x3a8
    c0002ef4:	f900001f 	str	xzr, [x0]
}
    c0002ef8:	d503201f 	nop
    c0002efc:	a8c17bfd 	ldp	x29, x30, [sp], #16
    c0002f00:	d65f03c0 	ret

00000000c0002f04 <early_alloc>:

void *early_alloc(size_t size, size_t align)
{
    c0002f04:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c0002f08:	910003fd 	mov	x29, sp
    c0002f0c:	f9000fe0 	str	x0, [sp, #24]
    c0002f10:	f9000be1 	str	x1, [sp, #16]
	return early_mm_alloc(size, align, "legacy");
    c0002f14:	90000020 	adrp	x0, c0006000 <hex.0+0x128>
    c0002f18:	9103e002 	add	x2, x0, #0xf8
    c0002f1c:	f9400be1 	ldr	x1, [sp, #16]
    c0002f20:	f9400fe0 	ldr	x0, [sp, #24]
    c0002f24:	94000003 	bl	c0002f30 <early_mm_alloc>
}
    c0002f28:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c0002f2c:	d65f03c0 	ret

00000000c0002f30 <early_mm_alloc>:

void *early_mm_alloc(size_t size, size_t align, const char *tag)
{
    c0002f30:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
    c0002f34:	910003fd 	mov	x29, sp
    c0002f38:	f90017e0 	str	x0, [sp, #40]
    c0002f3c:	f90013e1 	str	x1, [sp, #32]
    c0002f40:	f9000fe2 	str	x2, [sp, #24]
	return early_mm_region_alloc(&boot_heap_region, size, align, tag);
    c0002f44:	f9400fe3 	ldr	x3, [sp, #24]
    c0002f48:	f94013e2 	ldr	x2, [sp, #32]
    c0002f4c:	f94017e1 	ldr	x1, [sp, #40]
    c0002f50:	b0000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c0002f54:	910da000 	add	x0, x0, #0x368
    c0002f58:	97ffff86 	bl	c0002d70 <early_mm_region_alloc>
}
    c0002f5c:	a8c37bfd 	ldp	x29, x30, [sp], #48
    c0002f60:	d65f03c0 	ret

00000000c0002f64 <early_mm_alloc_pages>:

void *early_mm_alloc_pages(size_t page_count, const char *tag)
{
    c0002f64:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c0002f68:	910003fd 	mov	x29, sp
    c0002f6c:	f9000fe0 	str	x0, [sp, #24]
    c0002f70:	f9000be1 	str	x1, [sp, #16]
	if (page_count == 0U) {
    c0002f74:	f9400fe0 	ldr	x0, [sp, #24]
    c0002f78:	f100001f 	cmp	x0, #0x0
    c0002f7c:	54000061 	b.ne	c0002f88 <early_mm_alloc_pages+0x24>  // b.any
		return (void *)0;
    c0002f80:	d2800000 	mov	x0, #0x0                   	// #0
    c0002f84:	14000006 	b	c0002f9c <early_mm_alloc_pages+0x38>
	}

	return early_mm_alloc(page_count * EARLY_MM_PAGE_SIZE,
    c0002f88:	f9400fe0 	ldr	x0, [sp, #24]
    c0002f8c:	d374cc00 	lsl	x0, x0, #12
    c0002f90:	f9400be2 	ldr	x2, [sp, #16]
    c0002f94:	d2820001 	mov	x1, #0x1000                	// #4096
    c0002f98:	97ffffe6 	bl	c0002f30 <early_mm_alloc>
			      EARLY_MM_PAGE_SIZE,
			      tag);
}
    c0002f9c:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c0002fa0:	d65f03c0 	ret

00000000c0002fa4 <early_mm_default_region>:

const struct early_mm_region *early_mm_default_region(void)
{
	return &boot_heap_region;
    c0002fa4:	b0000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c0002fa8:	910da000 	add	x0, x0, #0x368
}
    c0002fac:	d65f03c0 	ret

00000000c0002fb0 <early_mm_get_stats>:

void early_mm_get_stats(struct early_allocator_stats *stats)
{
    c0002fb0:	d10043ff 	sub	sp, sp, #0x10
    c0002fb4:	f90007e0 	str	x0, [sp, #8]
	if (stats == (struct early_allocator_stats *)0) {
    c0002fb8:	f94007e0 	ldr	x0, [sp, #8]
    c0002fbc:	f100001f 	cmp	x0, #0x0
    c0002fc0:	540007c0 	b.eq	c00030b8 <early_mm_get_stats+0x108>  // b.none
		return;
	}

	stats->name = boot_heap_region.name;
    c0002fc4:	b0000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c0002fc8:	910da000 	add	x0, x0, #0x368
    c0002fcc:	f9400001 	ldr	x1, [x0]
    c0002fd0:	f94007e0 	ldr	x0, [sp, #8]
    c0002fd4:	f9000001 	str	x1, [x0]
	stats->start = boot_heap_region.start;
    c0002fd8:	b0000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c0002fdc:	910da000 	add	x0, x0, #0x368
    c0002fe0:	f9400401 	ldr	x1, [x0, #8]
    c0002fe4:	f94007e0 	ldr	x0, [sp, #8]
    c0002fe8:	f9000401 	str	x1, [x0, #8]
	stats->current = boot_heap_region.current;
    c0002fec:	b0000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c0002ff0:	910da000 	add	x0, x0, #0x368
    c0002ff4:	f9400801 	ldr	x1, [x0, #16]
    c0002ff8:	f94007e0 	ldr	x0, [sp, #8]
    c0002ffc:	f9000801 	str	x1, [x0, #16]
	stats->end = boot_heap_region.end;
    c0003000:	90000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c0003004:	910da000 	add	x0, x0, #0x368
    c0003008:	f9400c01 	ldr	x1, [x0, #24]
    c000300c:	f94007e0 	ldr	x0, [sp, #8]
    c0003010:	f9000c01 	str	x1, [x0, #24]
	stats->total_bytes = (size_t)(boot_heap_region.end - boot_heap_region.start);
    c0003014:	90000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c0003018:	910da000 	add	x0, x0, #0x368
    c000301c:	f9400c01 	ldr	x1, [x0, #24]
    c0003020:	90000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c0003024:	910da000 	add	x0, x0, #0x368
    c0003028:	f9400400 	ldr	x0, [x0, #8]
    c000302c:	cb000021 	sub	x1, x1, x0
    c0003030:	f94007e0 	ldr	x0, [sp, #8]
    c0003034:	f9001001 	str	x1, [x0, #32]
	stats->used_bytes = (size_t)(boot_heap_region.current - boot_heap_region.start);
    c0003038:	90000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c000303c:	910da000 	add	x0, x0, #0x368
    c0003040:	f9400801 	ldr	x1, [x0, #16]
    c0003044:	90000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c0003048:	910da000 	add	x0, x0, #0x368
    c000304c:	f9400400 	ldr	x0, [x0, #8]
    c0003050:	cb000021 	sub	x1, x1, x0
    c0003054:	f94007e0 	ldr	x0, [sp, #8]
    c0003058:	f9001401 	str	x1, [x0, #40]
	stats->free_bytes = (size_t)(boot_heap_region.end - boot_heap_region.current);
    c000305c:	90000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c0003060:	910da000 	add	x0, x0, #0x368
    c0003064:	f9400c01 	ldr	x1, [x0, #24]
    c0003068:	90000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c000306c:	910da000 	add	x0, x0, #0x368
    c0003070:	f9400800 	ldr	x0, [x0, #16]
    c0003074:	cb000021 	sub	x1, x1, x0
    c0003078:	f94007e0 	ldr	x0, [sp, #8]
    c000307c:	f9001801 	str	x1, [x0, #48]
	stats->peak_used_bytes = boot_heap_region.peak_used_bytes;
    c0003080:	90000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c0003084:	910da000 	add	x0, x0, #0x368
    c0003088:	f9401401 	ldr	x1, [x0, #40]
    c000308c:	f94007e0 	ldr	x0, [sp, #8]
    c0003090:	f9001c01 	str	x1, [x0, #56]
	stats->allocation_count = boot_heap_region.allocation_count;
    c0003094:	90000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c0003098:	910da000 	add	x0, x0, #0x368
    c000309c:	f9401001 	ldr	x1, [x0, #32]
    c00030a0:	f94007e0 	ldr	x0, [sp, #8]
    c00030a4:	f9002001 	str	x1, [x0, #64]
	stats->page_size = EARLY_MM_PAGE_SIZE;
    c00030a8:	f94007e0 	ldr	x0, [sp, #8]
    c00030ac:	d2820001 	mov	x1, #0x1000                	// #4096
    c00030b0:	f9002401 	str	x1, [x0, #72]
    c00030b4:	14000002 	b	c00030bc <early_mm_get_stats+0x10c>
		return;
    c00030b8:	d503201f 	nop

	(void)last_allocation_tag;
	(void)last_allocation_base;
	(void)last_allocation_size;
    c00030bc:	910043ff 	add	sp, sp, #0x10
    c00030c0:	d65f03c0 	ret

00000000c00030c4 <scheduler_alloc_zeroed>:

static struct scheduler_percpu *scheduler_percpu_table[PLAT_MAX_CPUS];
static size_t scheduler_object_count;

static void *scheduler_alloc_zeroed(size_t size, size_t align)
{
    c00030c4:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
    c00030c8:	910003fd 	mov	x29, sp
    c00030cc:	f9000fe0 	str	x0, [sp, #24]
    c00030d0:	f9000be1 	str	x1, [sp, #16]
	void *ptr = early_mm_alloc(size, align, "scheduler-object");
    c00030d4:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c00030d8:	91040002 	add	x2, x0, #0x100
    c00030dc:	f9400be1 	ldr	x1, [sp, #16]
    c00030e0:	f9400fe0 	ldr	x0, [sp, #24]
    c00030e4:	97ffff93 	bl	c0002f30 <early_mm_alloc>
    c00030e8:	f90017e0 	str	x0, [sp, #40]

	if (ptr != (void *)0) {
    c00030ec:	f94017e0 	ldr	x0, [sp, #40]
    c00030f0:	f100001f 	cmp	x0, #0x0
    c00030f4:	54000100 	b.eq	c0003114 <scheduler_alloc_zeroed+0x50>  // b.none
		scheduler_object_count++;
    c00030f8:	90000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c00030fc:	91100000 	add	x0, x0, #0x400
    c0003100:	f9400000 	ldr	x0, [x0]
    c0003104:	91000401 	add	x1, x0, #0x1
    c0003108:	90000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c000310c:	91100000 	add	x0, x0, #0x400
    c0003110:	f9000001 	str	x1, [x0]
	}

	return ptr;
    c0003114:	f94017e0 	ldr	x0, [sp, #40]
}
    c0003118:	a8c37bfd 	ldp	x29, x30, [sp], #48
    c000311c:	d65f03c0 	ret

00000000c0003120 <scheduler_create_idle_task>:

static struct scheduler_task *scheduler_create_idle_task(unsigned int logical_id)
{
    c0003120:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
    c0003124:	910003fd 	mov	x29, sp
    c0003128:	b9001fe0 	str	w0, [sp, #28]
	struct scheduler_task *task;
	void *stack;

	task = (struct scheduler_task *)scheduler_alloc_zeroed(sizeof(*task), sizeof(uintptr_t));
    c000312c:	d2800101 	mov	x1, #0x8                   	// #8
    c0003130:	d2800400 	mov	x0, #0x20                  	// #32
    c0003134:	97ffffe4 	bl	c00030c4 <scheduler_alloc_zeroed>
    c0003138:	f90017e0 	str	x0, [sp, #40]
	if (task == (struct scheduler_task *)0) {
    c000313c:	f94017e0 	ldr	x0, [sp, #40]
    c0003140:	f100001f 	cmp	x0, #0x0
    c0003144:	54000061 	b.ne	c0003150 <scheduler_create_idle_task+0x30>  // b.any
		return (struct scheduler_task *)0;
    c0003148:	d2800000 	mov	x0, #0x0                   	// #0
    c000314c:	14000025 	b	c00031e0 <scheduler_create_idle_task+0xc0>
	}

	stack = early_mm_alloc_pages((SCHED_TASK_STACK_SIZE + EARLY_MM_PAGE_SIZE - 1U) / EARLY_MM_PAGE_SIZE,
    c0003150:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003154:	91046001 	add	x1, x0, #0x118
    c0003158:	d2800080 	mov	x0, #0x4                   	// #4
    c000315c:	97ffff82 	bl	c0002f64 <early_mm_alloc_pages>
    c0003160:	f90013e0 	str	x0, [sp, #32]
			    "scheduler-idle-stack");
	if (stack != (void *)0) {
    c0003164:	f94013e0 	ldr	x0, [sp, #32]
    c0003168:	f100001f 	cmp	x0, #0x0
    c000316c:	54000100 	b.eq	c000318c <scheduler_create_idle_task+0x6c>  // b.none
		scheduler_object_count++;
    c0003170:	90000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c0003174:	91100000 	add	x0, x0, #0x400
    c0003178:	f9400000 	ldr	x0, [x0]
    c000317c:	91000401 	add	x1, x0, #0x1
    c0003180:	90000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c0003184:	91100000 	add	x0, x0, #0x400
    c0003188:	f9000001 	str	x1, [x0]
	}
	if (stack == (void *)0) {
    c000318c:	f94013e0 	ldr	x0, [sp, #32]
    c0003190:	f100001f 	cmp	x0, #0x0
    c0003194:	54000061 	b.ne	c00031a0 <scheduler_create_idle_task+0x80>  // b.any
		return (struct scheduler_task *)0;
    c0003198:	d2800000 	mov	x0, #0x0                   	// #0
    c000319c:	14000011 	b	c00031e0 <scheduler_create_idle_task+0xc0>
	}

	task->task_id = logical_id;
    c00031a0:	f94017e0 	ldr	x0, [sp, #40]
    c00031a4:	b9401fe1 	ldr	w1, [sp, #28]
    c00031a8:	b9000001 	str	w1, [x0]
	task->cpu_hint = logical_id;
    c00031ac:	f94017e0 	ldr	x0, [sp, #40]
    c00031b0:	b9401fe1 	ldr	w1, [sp, #28]
    c00031b4:	b9000401 	str	w1, [x0, #4]
	task->stack_base = stack;
    c00031b8:	f94017e0 	ldr	x0, [sp, #40]
    c00031bc:	f94013e1 	ldr	x1, [sp, #32]
    c00031c0:	f9000401 	str	x1, [x0, #8]
	task->stack_size = SCHED_TASK_STACK_SIZE;
    c00031c4:	f94017e0 	ldr	x0, [sp, #40]
    c00031c8:	d2880001 	mov	x1, #0x4000                	// #16384
    c00031cc:	f9000801 	str	x1, [x0, #16]
	task->idle = true;
    c00031d0:	f94017e0 	ldr	x0, [sp, #40]
    c00031d4:	52800021 	mov	w1, #0x1                   	// #1
    c00031d8:	39006001 	strb	w1, [x0, #24]
	return task;
    c00031dc:	f94017e0 	ldr	x0, [sp, #40]
}
    c00031e0:	a8c37bfd 	ldp	x29, x30, [sp], #48
    c00031e4:	d65f03c0 	ret

00000000c00031e8 <scheduler_bootstrap_cpu>:

static struct scheduler_percpu *scheduler_bootstrap_cpu(unsigned int logical_id)
{
    c00031e8:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
    c00031ec:	910003fd 	mov	x29, sp
    c00031f0:	b9001fe0 	str	w0, [sp, #28]
	struct scheduler_percpu *cpu_ctx;
	struct scheduler_runqueue_node *idle_node;

	cpu_ctx = (struct scheduler_percpu *)scheduler_alloc_zeroed(sizeof(*cpu_ctx), sizeof(uintptr_t));
    c00031f4:	d2800101 	mov	x1, #0x8                   	// #8
    c00031f8:	d2800400 	mov	x0, #0x20                  	// #32
    c00031fc:	97ffffb2 	bl	c00030c4 <scheduler_alloc_zeroed>
    c0003200:	f90017e0 	str	x0, [sp, #40]
	if (cpu_ctx == (struct scheduler_percpu *)0) {
    c0003204:	f94017e0 	ldr	x0, [sp, #40]
    c0003208:	f100001f 	cmp	x0, #0x0
    c000320c:	54000061 	b.ne	c0003218 <scheduler_bootstrap_cpu+0x30>  // b.any
		return (struct scheduler_percpu *)0;
    c0003210:	d2800000 	mov	x0, #0x0                   	// #0
    c0003214:	14000028 	b	c00032b4 <scheduler_bootstrap_cpu+0xcc>
	}

	cpu_ctx->logical_id = logical_id;
    c0003218:	f94017e0 	ldr	x0, [sp, #40]
    c000321c:	b9401fe1 	ldr	w1, [sp, #28]
    c0003220:	b9000001 	str	w1, [x0]
	cpu_ctx->idle_task = scheduler_create_idle_task(logical_id);
    c0003224:	b9401fe0 	ldr	w0, [sp, #28]
    c0003228:	97ffffbe 	bl	c0003120 <scheduler_create_idle_task>
    c000322c:	aa0003e1 	mov	x1, x0
    c0003230:	f94017e0 	ldr	x0, [sp, #40]
    c0003234:	f9000401 	str	x1, [x0, #8]
	if (cpu_ctx->idle_task == (struct scheduler_task *)0) {
    c0003238:	f94017e0 	ldr	x0, [sp, #40]
    c000323c:	f9400400 	ldr	x0, [x0, #8]
    c0003240:	f100001f 	cmp	x0, #0x0
    c0003244:	54000061 	b.ne	c0003250 <scheduler_bootstrap_cpu+0x68>  // b.any
		return (struct scheduler_percpu *)0;
    c0003248:	d2800000 	mov	x0, #0x0                   	// #0
    c000324c:	1400001a 	b	c00032b4 <scheduler_bootstrap_cpu+0xcc>
	}

	idle_node = (struct scheduler_runqueue_node *)scheduler_alloc_zeroed(sizeof(*idle_node), sizeof(uintptr_t));
    c0003250:	d2800101 	mov	x1, #0x8                   	// #8
    c0003254:	d2800200 	mov	x0, #0x10                  	// #16
    c0003258:	97ffff9b 	bl	c00030c4 <scheduler_alloc_zeroed>
    c000325c:	f90013e0 	str	x0, [sp, #32]
	if (idle_node == (struct scheduler_runqueue_node *)0) {
    c0003260:	f94013e0 	ldr	x0, [sp, #32]
    c0003264:	f100001f 	cmp	x0, #0x0
    c0003268:	54000061 	b.ne	c0003274 <scheduler_bootstrap_cpu+0x8c>  // b.any
		return (struct scheduler_percpu *)0;
    c000326c:	d2800000 	mov	x0, #0x0                   	// #0
    c0003270:	14000011 	b	c00032b4 <scheduler_bootstrap_cpu+0xcc>
	}

	idle_node->task = cpu_ctx->idle_task;
    c0003274:	f94017e0 	ldr	x0, [sp, #40]
    c0003278:	f9400401 	ldr	x1, [x0, #8]
    c000327c:	f94013e0 	ldr	x0, [sp, #32]
    c0003280:	f9000001 	str	x1, [x0]
	cpu_ctx->ready_head = idle_node;
    c0003284:	f94017e0 	ldr	x0, [sp, #40]
    c0003288:	f94013e1 	ldr	x1, [sp, #32]
    c000328c:	f9000801 	str	x1, [x0, #16]
	cpu_ctx->ready_tail = idle_node;
    c0003290:	f94017e0 	ldr	x0, [sp, #40]
    c0003294:	f94013e1 	ldr	x1, [sp, #32]
    c0003298:	f9000c01 	str	x1, [x0, #24]
	scheduler_percpu_table[logical_id] = cpu_ctx;
    c000329c:	90000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c00032a0:	910f0000 	add	x0, x0, #0x3c0
    c00032a4:	b9401fe1 	ldr	w1, [sp, #28]
    c00032a8:	f94017e2 	ldr	x2, [sp, #40]
    c00032ac:	f8217802 	str	x2, [x0, x1, lsl #3]
	return cpu_ctx;
    c00032b0:	f94017e0 	ldr	x0, [sp, #40]
}
    c00032b4:	a8c37bfd 	ldp	x29, x30, [sp], #48
    c00032b8:	d65f03c0 	ret

00000000c00032bc <scheduler_init>:

void scheduler_init(void)
{
    c00032bc:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c00032c0:	910003fd 	mov	x29, sp
	unsigned int i;

	for (i = 0U; i < (unsigned int)(sizeof(runnable_cpus) / sizeof(runnable_cpus[0])); ++i) {
    c00032c4:	b9001fff 	str	wzr, [sp, #28]
    c00032c8:	14000008 	b	c00032e8 <scheduler_init+0x2c>
		runnable_cpus[i] = 0UL;
    c00032cc:	90000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c00032d0:	910ec000 	add	x0, x0, #0x3b0
    c00032d4:	b9401fe1 	ldr	w1, [sp, #28]
    c00032d8:	f821781f 	str	xzr, [x0, x1, lsl #3]
	for (i = 0U; i < (unsigned int)(sizeof(runnable_cpus) / sizeof(runnable_cpus[0])); ++i) {
    c00032dc:	b9401fe0 	ldr	w0, [sp, #28]
    c00032e0:	11000400 	add	w0, w0, #0x1
    c00032e4:	b9001fe0 	str	w0, [sp, #28]
    c00032e8:	b9401fe0 	ldr	w0, [sp, #28]
    c00032ec:	7100001f 	cmp	w0, #0x0
    c00032f0:	54fffee0 	b.eq	c00032cc <scheduler_init+0x10>  // b.none
	}

	for (i = 0U; i < PLAT_MAX_CPUS; ++i) {
    c00032f4:	b9001fff 	str	wzr, [sp, #28]
    c00032f8:	14000008 	b	c0003318 <scheduler_init+0x5c>
		scheduler_percpu_table[i] = (struct scheduler_percpu *)0;
    c00032fc:	90000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c0003300:	910f0000 	add	x0, x0, #0x3c0
    c0003304:	b9401fe1 	ldr	w1, [sp, #28]
    c0003308:	f821781f 	str	xzr, [x0, x1, lsl #3]
	for (i = 0U; i < PLAT_MAX_CPUS; ++i) {
    c000330c:	b9401fe0 	ldr	w0, [sp, #28]
    c0003310:	11000400 	add	w0, w0, #0x1
    c0003314:	b9001fe0 	str	w0, [sp, #28]
    c0003318:	b9401fe0 	ldr	w0, [sp, #28]
    c000331c:	71001c1f 	cmp	w0, #0x7
    c0003320:	54fffee9 	b.ls	c00032fc <scheduler_init+0x40>  // b.plast
	}

	runnable_cpu_count = 0U;
    c0003324:	90000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c0003328:	910ee000 	add	x0, x0, #0x3b8
    c000332c:	b900001f 	str	wzr, [x0]
	scheduler_object_count = 0U;
    c0003330:	90000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c0003334:	91100000 	add	x0, x0, #0x400
    c0003338:	f900001f 	str	xzr, [x0]

	for (i = 0U; i < PLAT_MAX_CPUS; ++i) {
    c000333c:	b9001fff 	str	wzr, [sp, #28]
    c0003340:	14000008 	b	c0003360 <scheduler_init+0xa4>
		if (scheduler_bootstrap_cpu(i) == (struct scheduler_percpu *)0) {
    c0003344:	b9401fe0 	ldr	w0, [sp, #28]
    c0003348:	97ffffa8 	bl	c00031e8 <scheduler_bootstrap_cpu>
    c000334c:	f100001f 	cmp	x0, #0x0
    c0003350:	54000100 	b.eq	c0003370 <scheduler_init+0xb4>  // b.none
	for (i = 0U; i < PLAT_MAX_CPUS; ++i) {
    c0003354:	b9401fe0 	ldr	w0, [sp, #28]
    c0003358:	11000400 	add	w0, w0, #0x1
    c000335c:	b9001fe0 	str	w0, [sp, #28]
    c0003360:	b9401fe0 	ldr	w0, [sp, #28]
    c0003364:	71001c1f 	cmp	w0, #0x7
    c0003368:	54fffee9 	b.ls	c0003344 <scheduler_init+0x88>  // b.plast
			break;
		}
	}
}
    c000336c:	14000002 	b	c0003374 <scheduler_init+0xb8>
			break;
    c0003370:	d503201f 	nop
}
    c0003374:	d503201f 	nop
    c0003378:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c000337c:	d65f03c0 	ret

00000000c0003380 <scheduler_join_cpu>:

void scheduler_join_cpu(unsigned int logical_id)
{
    c0003380:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c0003384:	910003fd 	mov	x29, sp
    c0003388:	b9001fe0 	str	w0, [sp, #28]
	if (logical_id >= PLAT_MAX_CPUS) {
    c000338c:	b9401fe0 	ldr	w0, [sp, #28]
    c0003390:	71001c1f 	cmp	w0, #0x7
    c0003394:	54000468 	b.hi	c0003420 <scheduler_join_cpu+0xa0>  // b.pmore
		return;
	}

	if ((scheduler_percpu_table[logical_id] == (struct scheduler_percpu *)0) &&
    c0003398:	90000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c000339c:	910f0000 	add	x0, x0, #0x3c0
    c00033a0:	b9401fe1 	ldr	w1, [sp, #28]
    c00033a4:	f8617800 	ldr	x0, [x0, x1, lsl #3]
    c00033a8:	f100001f 	cmp	x0, #0x0
    c00033ac:	540000a1 	b.ne	c00033c0 <scheduler_join_cpu+0x40>  // b.any
	    (scheduler_bootstrap_cpu(logical_id) == (struct scheduler_percpu *)0)) {
    c00033b0:	b9401fe0 	ldr	w0, [sp, #28]
    c00033b4:	97ffff8d 	bl	c00031e8 <scheduler_bootstrap_cpu>
	if ((scheduler_percpu_table[logical_id] == (struct scheduler_percpu *)0) &&
    c00033b8:	f100001f 	cmp	x0, #0x0
    c00033bc:	54000360 	b.eq	c0003428 <scheduler_join_cpu+0xa8>  // b.none
		return;
	}

	if (!bitmap_test_bit(runnable_cpus, logical_id)) {
    c00033c0:	b9401fe0 	ldr	w0, [sp, #28]
    c00033c4:	aa0003e1 	mov	x1, x0
    c00033c8:	90000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c00033cc:	910ec000 	add	x0, x0, #0x3b0
    c00033d0:	97fffcb9 	bl	c00026b4 <bitmap_test_bit>
    c00033d4:	12001c00 	and	w0, w0, #0xff
    c00033d8:	52000000 	eor	w0, w0, #0x1
    c00033dc:	12001c00 	and	w0, w0, #0xff
    c00033e0:	12000000 	and	w0, w0, #0x1
    c00033e4:	7100001f 	cmp	w0, #0x0
    c00033e8:	54000220 	b.eq	c000342c <scheduler_join_cpu+0xac>  // b.none
		bitmap_set_bit(runnable_cpus, logical_id);
    c00033ec:	b9401fe0 	ldr	w0, [sp, #28]
    c00033f0:	aa0003e1 	mov	x1, x0
    c00033f4:	90000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c00033f8:	910ec000 	add	x0, x0, #0x3b0
    c00033fc:	97fffc83 	bl	c0002608 <bitmap_set_bit>
		runnable_cpu_count++;
    c0003400:	90000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c0003404:	910ee000 	add	x0, x0, #0x3b8
    c0003408:	b9400000 	ldr	w0, [x0]
    c000340c:	11000401 	add	w1, w0, #0x1
    c0003410:	90000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c0003414:	910ee000 	add	x0, x0, #0x3b8
    c0003418:	b9000001 	str	w1, [x0]
    c000341c:	14000004 	b	c000342c <scheduler_join_cpu+0xac>
		return;
    c0003420:	d503201f 	nop
    c0003424:	14000002 	b	c000342c <scheduler_join_cpu+0xac>
		return;
    c0003428:	d503201f 	nop
	}
}
    c000342c:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c0003430:	d65f03c0 	ret

00000000c0003434 <scheduler_cpu_is_runnable>:

bool scheduler_cpu_is_runnable(unsigned int logical_id)
{
    c0003434:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c0003438:	910003fd 	mov	x29, sp
    c000343c:	b9001fe0 	str	w0, [sp, #28]
	return bitmap_test_bit(runnable_cpus, logical_id);
    c0003440:	b9401fe0 	ldr	w0, [sp, #28]
    c0003444:	aa0003e1 	mov	x1, x0
    c0003448:	90000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c000344c:	910ec000 	add	x0, x0, #0x3b0
    c0003450:	97fffc99 	bl	c00026b4 <bitmap_test_bit>
    c0003454:	12001c00 	and	w0, w0, #0xff
}
    c0003458:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c000345c:	d65f03c0 	ret

00000000c0003460 <scheduler_runnable_cpu_count>:

unsigned int scheduler_runnable_cpu_count(void)
{
	return runnable_cpu_count;
    c0003460:	90000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c0003464:	910ee000 	add	x0, x0, #0x3b8
    c0003468:	b9400000 	ldr	w0, [x0]
}
    c000346c:	d65f03c0 	ret

00000000c0003470 <scheduler_percpu_state>:

const struct scheduler_percpu *scheduler_percpu_state(unsigned int logical_id)
{
    c0003470:	d10043ff 	sub	sp, sp, #0x10
    c0003474:	b9000fe0 	str	w0, [sp, #12]
	if (logical_id >= PLAT_MAX_CPUS) {
    c0003478:	b9400fe0 	ldr	w0, [sp, #12]
    c000347c:	71001c1f 	cmp	w0, #0x7
    c0003480:	54000069 	b.ls	c000348c <scheduler_percpu_state+0x1c>  // b.plast
		return (const struct scheduler_percpu *)0;
    c0003484:	d2800000 	mov	x0, #0x0                   	// #0
    c0003488:	14000005 	b	c000349c <scheduler_percpu_state+0x2c>
	}

	return scheduler_percpu_table[logical_id];
    c000348c:	90000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c0003490:	910f0000 	add	x0, x0, #0x3c0
    c0003494:	b9400fe1 	ldr	w1, [sp, #12]
    c0003498:	f8617800 	ldr	x0, [x0, x1, lsl #3]
}
    c000349c:	910043ff 	add	sp, sp, #0x10
    c00034a0:	d65f03c0 	ret

00000000c00034a4 <scheduler_bootstrap_object_count>:

size_t scheduler_bootstrap_object_count(void)
{
	return scheduler_object_count;
    c00034a4:	90000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c00034a8:	91100000 	add	x0, x0, #0x400
    c00034ac:	f9400000 	ldr	x0, [x0]
    c00034b0:	d65f03c0 	ret

00000000c00034b4 <is_space>:
#define MINI_OS_BUILD_YEAR 2026

extern volatile uint64_t boot_magic;

static bool is_space(char ch)
{
    c00034b4:	d10043ff 	sub	sp, sp, #0x10
    c00034b8:	39003fe0 	strb	w0, [sp, #15]
	return (ch == ' ') || (ch == '\t') || (ch == '\r') || (ch == '\n');
    c00034bc:	39403fe0 	ldrb	w0, [sp, #15]
    c00034c0:	7100801f 	cmp	w0, #0x20
    c00034c4:	54000140 	b.eq	c00034ec <is_space+0x38>  // b.none
    c00034c8:	39403fe0 	ldrb	w0, [sp, #15]
    c00034cc:	7100241f 	cmp	w0, #0x9
    c00034d0:	540000e0 	b.eq	c00034ec <is_space+0x38>  // b.none
    c00034d4:	39403fe0 	ldrb	w0, [sp, #15]
    c00034d8:	7100341f 	cmp	w0, #0xd
    c00034dc:	54000080 	b.eq	c00034ec <is_space+0x38>  // b.none
    c00034e0:	39403fe0 	ldrb	w0, [sp, #15]
    c00034e4:	7100281f 	cmp	w0, #0xa
    c00034e8:	54000061 	b.ne	c00034f4 <is_space+0x40>  // b.any
    c00034ec:	52800020 	mov	w0, #0x1                   	// #1
    c00034f0:	14000002 	b	c00034f8 <is_space+0x44>
    c00034f4:	52800000 	mov	w0, #0x0                   	// #0
    c00034f8:	12000000 	and	w0, w0, #0x1
    c00034fc:	12001c00 	and	w0, w0, #0xff
}
    c0003500:	910043ff 	add	sp, sp, #0x10
    c0003504:	d65f03c0 	ret

00000000c0003508 <strings_equal>:

static bool strings_equal(const char *lhs, const char *rhs)
{
    c0003508:	d10043ff 	sub	sp, sp, #0x10
    c000350c:	f90007e0 	str	x0, [sp, #8]
    c0003510:	f90003e1 	str	x1, [sp]
	while ((*lhs != '\0') && (*rhs != '\0')) {
    c0003514:	1400000f 	b	c0003550 <strings_equal+0x48>
		if (*lhs != *rhs) {
    c0003518:	f94007e0 	ldr	x0, [sp, #8]
    c000351c:	39400001 	ldrb	w1, [x0]
    c0003520:	f94003e0 	ldr	x0, [sp]
    c0003524:	39400000 	ldrb	w0, [x0]
    c0003528:	6b00003f 	cmp	w1, w0
    c000352c:	54000060 	b.eq	c0003538 <strings_equal+0x30>  // b.none
			return false;
    c0003530:	52800000 	mov	w0, #0x0                   	// #0
    c0003534:	1400001c 	b	c00035a4 <strings_equal+0x9c>
		}
		lhs++;
    c0003538:	f94007e0 	ldr	x0, [sp, #8]
    c000353c:	91000400 	add	x0, x0, #0x1
    c0003540:	f90007e0 	str	x0, [sp, #8]
		rhs++;
    c0003544:	f94003e0 	ldr	x0, [sp]
    c0003548:	91000400 	add	x0, x0, #0x1
    c000354c:	f90003e0 	str	x0, [sp]
	while ((*lhs != '\0') && (*rhs != '\0')) {
    c0003550:	f94007e0 	ldr	x0, [sp, #8]
    c0003554:	39400000 	ldrb	w0, [x0]
    c0003558:	7100001f 	cmp	w0, #0x0
    c000355c:	540000a0 	b.eq	c0003570 <strings_equal+0x68>  // b.none
    c0003560:	f94003e0 	ldr	x0, [sp]
    c0003564:	39400000 	ldrb	w0, [x0]
    c0003568:	7100001f 	cmp	w0, #0x0
    c000356c:	54fffd61 	b.ne	c0003518 <strings_equal+0x10>  // b.any
	}

	return (*lhs == '\0') && (*rhs == '\0');
    c0003570:	f94007e0 	ldr	x0, [sp, #8]
    c0003574:	39400000 	ldrb	w0, [x0]
    c0003578:	7100001f 	cmp	w0, #0x0
    c000357c:	540000e1 	b.ne	c0003598 <strings_equal+0x90>  // b.any
    c0003580:	f94003e0 	ldr	x0, [sp]
    c0003584:	39400000 	ldrb	w0, [x0]
    c0003588:	7100001f 	cmp	w0, #0x0
    c000358c:	54000061 	b.ne	c0003598 <strings_equal+0x90>  // b.any
    c0003590:	52800020 	mov	w0, #0x1                   	// #1
    c0003594:	14000002 	b	c000359c <strings_equal+0x94>
    c0003598:	52800000 	mov	w0, #0x0                   	// #0
    c000359c:	12000000 	and	w0, w0, #0x1
    c00035a0:	12001c00 	and	w0, w0, #0xff
}
    c00035a4:	910043ff 	add	sp, sp, #0x10
    c00035a8:	d65f03c0 	ret

00000000c00035ac <shell_help_topic_name>:

static const char *shell_help_topic_name(const char *arg)
{
    c00035ac:	d10043ff 	sub	sp, sp, #0x10
    c00035b0:	f90007e0 	str	x0, [sp, #8]
	if ((arg == (const char *)0) || (*arg == '\0')) {
    c00035b4:	f94007e0 	ldr	x0, [sp, #8]
    c00035b8:	f100001f 	cmp	x0, #0x0
    c00035bc:	540000a0 	b.eq	c00035d0 <shell_help_topic_name+0x24>  // b.none
    c00035c0:	f94007e0 	ldr	x0, [sp, #8]
    c00035c4:	39400000 	ldrb	w0, [x0]
    c00035c8:	7100001f 	cmp	w0, #0x0
    c00035cc:	54000061 	b.ne	c00035d8 <shell_help_topic_name+0x2c>  // b.any
		return (const char *)0;
    c00035d0:	d2800000 	mov	x0, #0x0                   	// #0
    c00035d4:	1400000e 	b	c000360c <shell_help_topic_name+0x60>
	}

	if ((arg[0] == '-') && (arg[1] == '-')) {
    c00035d8:	f94007e0 	ldr	x0, [sp, #8]
    c00035dc:	39400000 	ldrb	w0, [x0]
    c00035e0:	7100b41f 	cmp	w0, #0x2d
    c00035e4:	54000121 	b.ne	c0003608 <shell_help_topic_name+0x5c>  // b.any
    c00035e8:	f94007e0 	ldr	x0, [sp, #8]
    c00035ec:	91000400 	add	x0, x0, #0x1
    c00035f0:	39400000 	ldrb	w0, [x0]
    c00035f4:	7100b41f 	cmp	w0, #0x2d
    c00035f8:	54000081 	b.ne	c0003608 <shell_help_topic_name+0x5c>  // b.any
		return arg + 2;
    c00035fc:	f94007e0 	ldr	x0, [sp, #8]
    c0003600:	91000800 	add	x0, x0, #0x2
    c0003604:	14000002 	b	c000360c <shell_help_topic_name+0x60>
	}

	return arg;
    c0003608:	f94007e0 	ldr	x0, [sp, #8]
}
    c000360c:	910043ff 	add	sp, sp, #0x10
    c0003610:	d65f03c0 	ret

00000000c0003614 <parse_u64>:

static bool parse_u64(const char *str, uint64_t *value)
{
    c0003614:	d100c3ff 	sub	sp, sp, #0x30
    c0003618:	f90007e0 	str	x0, [sp, #8]
    c000361c:	f90003e1 	str	x1, [sp]
	uint64_t result = 0U;
    c0003620:	f90017ff 	str	xzr, [sp, #40]
	unsigned int base = 10U;
    c0003624:	52800140 	mov	w0, #0xa                   	// #10
    c0003628:	b90027e0 	str	w0, [sp, #36]
	char ch;

	if ((str == (const char *)0) || (*str == '\0')) {
    c000362c:	f94007e0 	ldr	x0, [sp, #8]
    c0003630:	f100001f 	cmp	x0, #0x0
    c0003634:	540000a0 	b.eq	c0003648 <parse_u64+0x34>  // b.none
    c0003638:	f94007e0 	ldr	x0, [sp, #8]
    c000363c:	39400000 	ldrb	w0, [x0]
    c0003640:	7100001f 	cmp	w0, #0x0
    c0003644:	54000061 	b.ne	c0003650 <parse_u64+0x3c>  // b.any
		return false;
    c0003648:	52800000 	mov	w0, #0x0                   	// #0
    c000364c:	14000058 	b	c00037ac <parse_u64+0x198>
	}

	if ((str[0] == '0') && ((str[1] == 'x') || (str[1] == 'X'))) {
    c0003650:	f94007e0 	ldr	x0, [sp, #8]
    c0003654:	39400000 	ldrb	w0, [x0]
    c0003658:	7100c01f 	cmp	w0, #0x30
    c000365c:	54000201 	b.ne	c000369c <parse_u64+0x88>  // b.any
    c0003660:	f94007e0 	ldr	x0, [sp, #8]
    c0003664:	91000400 	add	x0, x0, #0x1
    c0003668:	39400000 	ldrb	w0, [x0]
    c000366c:	7101e01f 	cmp	w0, #0x78
    c0003670:	540000c0 	b.eq	c0003688 <parse_u64+0x74>  // b.none
    c0003674:	f94007e0 	ldr	x0, [sp, #8]
    c0003678:	91000400 	add	x0, x0, #0x1
    c000367c:	39400000 	ldrb	w0, [x0]
    c0003680:	7101601f 	cmp	w0, #0x58
    c0003684:	540000c1 	b.ne	c000369c <parse_u64+0x88>  // b.any
		base = 16U;
    c0003688:	52800200 	mov	w0, #0x10                  	// #16
    c000368c:	b90027e0 	str	w0, [sp, #36]
		str += 2;
    c0003690:	f94007e0 	ldr	x0, [sp, #8]
    c0003694:	91000800 	add	x0, x0, #0x2
    c0003698:	f90007e0 	str	x0, [sp, #8]
	}
	if (*str == '\0') {
    c000369c:	f94007e0 	ldr	x0, [sp, #8]
    c00036a0:	39400000 	ldrb	w0, [x0]
    c00036a4:	7100001f 	cmp	w0, #0x0
    c00036a8:	540006a1 	b.ne	c000377c <parse_u64+0x168>  // b.any
		return false;
    c00036ac:	52800000 	mov	w0, #0x0                   	// #0
    c00036b0:	1400003f 	b	c00037ac <parse_u64+0x198>
	}

	while ((ch = *str++) != '\0') {
		unsigned int digit;

		if ((ch >= '0') && (ch <= '9')) {
    c00036b4:	39407fe0 	ldrb	w0, [sp, #31]
    c00036b8:	7100bc1f 	cmp	w0, #0x2f
    c00036bc:	54000109 	b.ls	c00036dc <parse_u64+0xc8>  // b.plast
    c00036c0:	39407fe0 	ldrb	w0, [sp, #31]
    c00036c4:	7100e41f 	cmp	w0, #0x39
    c00036c8:	540000a8 	b.hi	c00036dc <parse_u64+0xc8>  // b.pmore
			digit = (unsigned int)(ch - '0');
    c00036cc:	39407fe0 	ldrb	w0, [sp, #31]
    c00036d0:	5100c000 	sub	w0, w0, #0x30
    c00036d4:	b90023e0 	str	w0, [sp, #32]
    c00036d8:	1400001d 	b	c000374c <parse_u64+0x138>
		} else if ((base == 16U) && (ch >= 'a') && (ch <= 'f')) {
    c00036dc:	b94027e0 	ldr	w0, [sp, #36]
    c00036e0:	7100401f 	cmp	w0, #0x10
    c00036e4:	54000161 	b.ne	c0003710 <parse_u64+0xfc>  // b.any
    c00036e8:	39407fe0 	ldrb	w0, [sp, #31]
    c00036ec:	7101801f 	cmp	w0, #0x60
    c00036f0:	54000109 	b.ls	c0003710 <parse_u64+0xfc>  // b.plast
    c00036f4:	39407fe0 	ldrb	w0, [sp, #31]
    c00036f8:	7101981f 	cmp	w0, #0x66
    c00036fc:	540000a8 	b.hi	c0003710 <parse_u64+0xfc>  // b.pmore
			digit = (unsigned int)(ch - 'a') + 10U;
    c0003700:	39407fe0 	ldrb	w0, [sp, #31]
    c0003704:	51015c00 	sub	w0, w0, #0x57
    c0003708:	b90023e0 	str	w0, [sp, #32]
    c000370c:	14000010 	b	c000374c <parse_u64+0x138>
		} else if ((base == 16U) && (ch >= 'A') && (ch <= 'F')) {
    c0003710:	b94027e0 	ldr	w0, [sp, #36]
    c0003714:	7100401f 	cmp	w0, #0x10
    c0003718:	54000161 	b.ne	c0003744 <parse_u64+0x130>  // b.any
    c000371c:	39407fe0 	ldrb	w0, [sp, #31]
    c0003720:	7101001f 	cmp	w0, #0x40
    c0003724:	54000109 	b.ls	c0003744 <parse_u64+0x130>  // b.plast
    c0003728:	39407fe0 	ldrb	w0, [sp, #31]
    c000372c:	7101181f 	cmp	w0, #0x46
    c0003730:	540000a8 	b.hi	c0003744 <parse_u64+0x130>  // b.pmore
			digit = (unsigned int)(ch - 'A') + 10U;
    c0003734:	39407fe0 	ldrb	w0, [sp, #31]
    c0003738:	5100dc00 	sub	w0, w0, #0x37
    c000373c:	b90023e0 	str	w0, [sp, #32]
    c0003740:	14000003 	b	c000374c <parse_u64+0x138>
		} else {
			return false;
    c0003744:	52800000 	mov	w0, #0x0                   	// #0
    c0003748:	14000019 	b	c00037ac <parse_u64+0x198>
		}
		if (digit >= base) {
    c000374c:	b94023e1 	ldr	w1, [sp, #32]
    c0003750:	b94027e0 	ldr	w0, [sp, #36]
    c0003754:	6b00003f 	cmp	w1, w0
    c0003758:	54000063 	b.cc	c0003764 <parse_u64+0x150>  // b.lo, b.ul, b.last
			return false;
    c000375c:	52800000 	mov	w0, #0x0                   	// #0
    c0003760:	14000013 	b	c00037ac <parse_u64+0x198>
		}
		result = result * base + digit;
    c0003764:	b94027e1 	ldr	w1, [sp, #36]
    c0003768:	f94017e0 	ldr	x0, [sp, #40]
    c000376c:	9b007c21 	mul	x1, x1, x0
    c0003770:	b94023e0 	ldr	w0, [sp, #32]
    c0003774:	8b000020 	add	x0, x1, x0
    c0003778:	f90017e0 	str	x0, [sp, #40]
	while ((ch = *str++) != '\0') {
    c000377c:	f94007e0 	ldr	x0, [sp, #8]
    c0003780:	91000401 	add	x1, x0, #0x1
    c0003784:	f90007e1 	str	x1, [sp, #8]
    c0003788:	39400000 	ldrb	w0, [x0]
    c000378c:	39007fe0 	strb	w0, [sp, #31]
    c0003790:	39407fe0 	ldrb	w0, [sp, #31]
    c0003794:	7100001f 	cmp	w0, #0x0
    c0003798:	54fff8e1 	b.ne	c00036b4 <parse_u64+0xa0>  // b.any
	}

	*value = result;
    c000379c:	f94003e0 	ldr	x0, [sp]
    c00037a0:	f94017e1 	ldr	x1, [sp, #40]
    c00037a4:	f9000001 	str	x1, [x0]
	return true;
    c00037a8:	52800020 	mov	w0, #0x1                   	// #1
}
    c00037ac:	9100c3ff 	add	sp, sp, #0x30
    c00037b0:	d65f03c0 	ret

00000000c00037b4 <shell_tokenize>:

static int shell_tokenize(char *line, char *argv[], int max_args)
{
    c00037b4:	a9bc7bfd 	stp	x29, x30, [sp, #-64]!
    c00037b8:	910003fd 	mov	x29, sp
    c00037bc:	f90017e0 	str	x0, [sp, #40]
    c00037c0:	f90013e1 	str	x1, [sp, #32]
    c00037c4:	b9001fe2 	str	w2, [sp, #28]
	int argc = 0;
    c00037c8:	b9003fff 	str	wzr, [sp, #60]

	while (*line != '\0') {
    c00037cc:	1400002e 	b	c0003884 <shell_tokenize+0xd0>
		while (is_space(*line)) {
			*line++ = '\0';
    c00037d0:	f94017e0 	ldr	x0, [sp, #40]
    c00037d4:	91000401 	add	x1, x0, #0x1
    c00037d8:	f90017e1 	str	x1, [sp, #40]
    c00037dc:	3900001f 	strb	wzr, [x0]
		while (is_space(*line)) {
    c00037e0:	f94017e0 	ldr	x0, [sp, #40]
    c00037e4:	39400000 	ldrb	w0, [x0]
    c00037e8:	97ffff33 	bl	c00034b4 <is_space>
    c00037ec:	12001c00 	and	w0, w0, #0xff
    c00037f0:	12000000 	and	w0, w0, #0x1
    c00037f4:	7100001f 	cmp	w0, #0x0
    c00037f8:	54fffec1 	b.ne	c00037d0 <shell_tokenize+0x1c>  // b.any
		}

		if (*line == '\0') {
    c00037fc:	f94017e0 	ldr	x0, [sp, #40]
    c0003800:	39400000 	ldrb	w0, [x0]
    c0003804:	7100001f 	cmp	w0, #0x0
    c0003808:	54000480 	b.eq	c0003898 <shell_tokenize+0xe4>  // b.none
			break;
		}

		if (argc >= max_args) {
    c000380c:	b9403fe1 	ldr	w1, [sp, #60]
    c0003810:	b9401fe0 	ldr	w0, [sp, #28]
    c0003814:	6b00003f 	cmp	w1, w0
    c0003818:	5400044a 	b.ge	c00038a0 <shell_tokenize+0xec>  // b.tcont
			break;
		}

		argv[argc++] = line;
    c000381c:	b9403fe0 	ldr	w0, [sp, #60]
    c0003820:	11000401 	add	w1, w0, #0x1
    c0003824:	b9003fe1 	str	w1, [sp, #60]
    c0003828:	93407c00 	sxtw	x0, w0
    c000382c:	d37df000 	lsl	x0, x0, #3
    c0003830:	f94013e1 	ldr	x1, [sp, #32]
    c0003834:	8b000020 	add	x0, x1, x0
    c0003838:	f94017e1 	ldr	x1, [sp, #40]
    c000383c:	f9000001 	str	x1, [x0]
		while ((*line != '\0') && !is_space(*line)) {
    c0003840:	14000004 	b	c0003850 <shell_tokenize+0x9c>
			line++;
    c0003844:	f94017e0 	ldr	x0, [sp, #40]
    c0003848:	91000400 	add	x0, x0, #0x1
    c000384c:	f90017e0 	str	x0, [sp, #40]
		while ((*line != '\0') && !is_space(*line)) {
    c0003850:	f94017e0 	ldr	x0, [sp, #40]
    c0003854:	39400000 	ldrb	w0, [x0]
    c0003858:	7100001f 	cmp	w0, #0x0
    c000385c:	54000140 	b.eq	c0003884 <shell_tokenize+0xd0>  // b.none
    c0003860:	f94017e0 	ldr	x0, [sp, #40]
    c0003864:	39400000 	ldrb	w0, [x0]
    c0003868:	97ffff13 	bl	c00034b4 <is_space>
    c000386c:	12001c00 	and	w0, w0, #0xff
    c0003870:	52000000 	eor	w0, w0, #0x1
    c0003874:	12001c00 	and	w0, w0, #0xff
    c0003878:	12000000 	and	w0, w0, #0x1
    c000387c:	7100001f 	cmp	w0, #0x0
    c0003880:	54fffe21 	b.ne	c0003844 <shell_tokenize+0x90>  // b.any
	while (*line != '\0') {
    c0003884:	f94017e0 	ldr	x0, [sp, #40]
    c0003888:	39400000 	ldrb	w0, [x0]
    c000388c:	7100001f 	cmp	w0, #0x0
    c0003890:	54fffa81 	b.ne	c00037e0 <shell_tokenize+0x2c>  // b.any
    c0003894:	14000004 	b	c00038a4 <shell_tokenize+0xf0>
			break;
    c0003898:	d503201f 	nop
    c000389c:	14000002 	b	c00038a4 <shell_tokenize+0xf0>
			break;
    c00038a0:	d503201f 	nop
		}
	}

	return argc;
    c00038a4:	b9403fe0 	ldr	w0, [sp, #60]
}
    c00038a8:	a8c47bfd 	ldp	x29, x30, [sp], #64
    c00038ac:	d65f03c0 	ret

00000000c00038b0 <shell_print_cpu_entry>:

static void shell_print_cpu_entry(unsigned int logical_id)
{
    c00038b0:	d10143ff 	sub	sp, sp, #0x50
    c00038b4:	a9027bfd 	stp	x29, x30, [sp, #32]
    c00038b8:	910083fd 	add	x29, sp, #0x20
    c00038bc:	b9003fe0 	str	w0, [sp, #60]
	const struct cpu_topology_descriptor *cpu = topology_cpu(logical_id);
    c00038c0:	b9403fe0 	ldr	w0, [sp, #60]
    c00038c4:	9400083a 	bl	c00059ac <topology_cpu>
    c00038c8:	f90027e0 	str	x0, [sp, #72]
	const struct smp_cpu_state *state = smp_cpu_state(logical_id);
    c00038cc:	b9403fe0 	ldr	w0, [sp, #60]
    c00038d0:	9400073b 	bl	c00055bc <smp_cpu_state>
    c00038d4:	f90023e0 	str	x0, [sp, #64]

	if ((cpu == (const struct cpu_topology_descriptor *)0) ||
    c00038d8:	f94027e0 	ldr	x0, [sp, #72]
    c00038dc:	f100001f 	cmp	x0, #0x0
    c00038e0:	54000940 	b.eq	c0003a08 <shell_print_cpu_entry+0x158>  // b.none
    c00038e4:	f94023e0 	ldr	x0, [sp, #64]
    c00038e8:	f100001f 	cmp	x0, #0x0
    c00038ec:	540008e0 	b.eq	c0003a08 <shell_print_cpu_entry+0x158>  // b.none
	    (state == (const struct smp_cpu_state *)0) ||
	    !cpu->present) {
    c00038f0:	f94027e0 	ldr	x0, [sp, #72]
    c00038f4:	39407400 	ldrb	w0, [x0, #29]
    c00038f8:	52000000 	eor	w0, w0, #0x1
    c00038fc:	12001c00 	and	w0, w0, #0xff
	    (state == (const struct smp_cpu_state *)0) ||
    c0003900:	12000000 	and	w0, w0, #0x1
    c0003904:	7100001f 	cmp	w0, #0x0
    c0003908:	54000801 	b.ne	c0003a08 <shell_print_cpu_entry+0x158>  // b.any
		return;
	}

	mini_os_printf("cpu%-2u mpidr=0x%llx chip=%u die=%u cluster=%u core=%u online=%s scheduled=%s pending=%s boot=%s\n",
		       cpu->logical_id,
    c000390c:	f94027e0 	ldr	x0, [sp, #72]
    c0003910:	b9400808 	ldr	w8, [x0, #8]
		       (unsigned long long)cpu->mpidr,
    c0003914:	f94027e0 	ldr	x0, [sp, #72]
    c0003918:	f9400009 	ldr	x9, [x0]
		       cpu->chip_id,
    c000391c:	f94027e0 	ldr	x0, [sp, #72]
    c0003920:	b9400c0a 	ldr	w10, [x0, #12]
		       cpu->die_id,
    c0003924:	f94027e0 	ldr	x0, [sp, #72]
    c0003928:	b9401004 	ldr	w4, [x0, #16]
		       cpu->cluster_id,
    c000392c:	f94027e0 	ldr	x0, [sp, #72]
    c0003930:	b9401405 	ldr	w5, [x0, #20]
		       cpu->core_id,
    c0003934:	f94027e0 	ldr	x0, [sp, #72]
    c0003938:	b9401806 	ldr	w6, [x0, #24]
		       state->online ? "yes" : "no",
    c000393c:	f94023e0 	ldr	x0, [sp, #64]
    c0003940:	39404000 	ldrb	w0, [x0, #16]
	mini_os_printf("cpu%-2u mpidr=0x%llx chip=%u die=%u cluster=%u core=%u online=%s scheduled=%s pending=%s boot=%s\n",
    c0003944:	12000000 	and	w0, w0, #0x1
    c0003948:	7100001f 	cmp	w0, #0x0
    c000394c:	54000080 	b.eq	c000395c <shell_print_cpu_entry+0xac>  // b.none
    c0003950:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003954:	9104c003 	add	x3, x0, #0x130
    c0003958:	14000003 	b	c0003964 <shell_print_cpu_entry+0xb4>
    c000395c:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003960:	9104e003 	add	x3, x0, #0x138
		       state->scheduled ? "yes" : "no",
    c0003964:	f94023e0 	ldr	x0, [sp, #64]
    c0003968:	39404400 	ldrb	w0, [x0, #17]
	mini_os_printf("cpu%-2u mpidr=0x%llx chip=%u die=%u cluster=%u core=%u online=%s scheduled=%s pending=%s boot=%s\n",
    c000396c:	12000000 	and	w0, w0, #0x1
    c0003970:	7100001f 	cmp	w0, #0x0
    c0003974:	54000080 	b.eq	c0003984 <shell_print_cpu_entry+0xd4>  // b.none
    c0003978:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c000397c:	9104c000 	add	x0, x0, #0x130
    c0003980:	14000003 	b	c000398c <shell_print_cpu_entry+0xdc>
    c0003984:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003988:	9104e000 	add	x0, x0, #0x138
		       state->pending ? "yes" : "no",
    c000398c:	f94023e1 	ldr	x1, [sp, #64]
    c0003990:	39404821 	ldrb	w1, [x1, #18]
	mini_os_printf("cpu%-2u mpidr=0x%llx chip=%u die=%u cluster=%u core=%u online=%s scheduled=%s pending=%s boot=%s\n",
    c0003994:	12000021 	and	w1, w1, #0x1
    c0003998:	7100003f 	cmp	w1, #0x0
    c000399c:	54000080 	b.eq	c00039ac <shell_print_cpu_entry+0xfc>  // b.none
    c00039a0:	f0000001 	adrp	x1, c0006000 <hex.0+0x128>
    c00039a4:	9104c021 	add	x1, x1, #0x130
    c00039a8:	14000003 	b	c00039b4 <shell_print_cpu_entry+0x104>
    c00039ac:	f0000001 	adrp	x1, c0006000 <hex.0+0x128>
    c00039b0:	9104e021 	add	x1, x1, #0x138
		       cpu->boot_cpu ? "yes" : "no");
    c00039b4:	f94027e2 	ldr	x2, [sp, #72]
    c00039b8:	39407042 	ldrb	w2, [x2, #28]
	mini_os_printf("cpu%-2u mpidr=0x%llx chip=%u die=%u cluster=%u core=%u online=%s scheduled=%s pending=%s boot=%s\n",
    c00039bc:	12000042 	and	w2, w2, #0x1
    c00039c0:	7100005f 	cmp	w2, #0x0
    c00039c4:	54000080 	b.eq	c00039d4 <shell_print_cpu_entry+0x124>  // b.none
    c00039c8:	f0000002 	adrp	x2, c0006000 <hex.0+0x128>
    c00039cc:	9104c042 	add	x2, x2, #0x130
    c00039d0:	14000003 	b	c00039dc <shell_print_cpu_entry+0x12c>
    c00039d4:	f0000002 	adrp	x2, c0006000 <hex.0+0x128>
    c00039d8:	9104e042 	add	x2, x2, #0x138
    c00039dc:	f9000be2 	str	x2, [sp, #16]
    c00039e0:	f90007e1 	str	x1, [sp, #8]
    c00039e4:	f90003e0 	str	x0, [sp]
    c00039e8:	aa0303e7 	mov	x7, x3
    c00039ec:	2a0a03e3 	mov	w3, w10
    c00039f0:	aa0903e2 	mov	x2, x9
    c00039f4:	2a0803e1 	mov	w1, w8
    c00039f8:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c00039fc:	91050000 	add	x0, x0, #0x140
    c0003a00:	97fff8bd 	bl	c0001cf4 <mini_os_printf>
    c0003a04:	14000002 	b	c0003a0c <shell_print_cpu_entry+0x15c>
		return;
    c0003a08:	d503201f 	nop
}
    c0003a0c:	a9427bfd 	ldp	x29, x30, [sp, #32]
    c0003a10:	910143ff 	add	sp, sp, #0x50
    c0003a14:	d65f03c0 	ret

00000000c0003a18 <shell_print_help_overview>:

static void shell_print_help_overview(void)
{
    c0003a18:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    c0003a1c:	910003fd 	mov	x29, sp
	mini_os_printf("Built-in commands:\n");
    c0003a20:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003a24:	9106a000 	add	x0, x0, #0x1a8
    c0003a28:	97fff8b3 	bl	c0001cf4 <mini_os_printf>
	mini_os_printf("  help [--topic]    Show command help or detailed help for one topic\n");
    c0003a2c:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003a30:	91070000 	add	x0, x0, #0x1c0
    c0003a34:	97fff8b0 	bl	c0001cf4 <mini_os_printf>
	mini_os_printf("  version           Show OS version information\n");
    c0003a38:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003a3c:	91082000 	add	x0, x0, #0x208
    c0003a40:	97fff8ad 	bl	c0001cf4 <mini_os_printf>
	mini_os_printf("  info              Show current platform/runtime info\n");
    c0003a44:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003a48:	91090000 	add	x0, x0, #0x240
    c0003a4c:	97fff8aa 	bl	c0001cf4 <mini_os_printf>
	mini_os_printf("  cpu [id]          Show CPU information\n");
    c0003a50:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003a54:	9109e000 	add	x0, x0, #0x278
    c0003a58:	97fff8a7 	bl	c0001cf4 <mini_os_printf>
	mini_os_printf("  cpus              List known CPUs\n");
    c0003a5c:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003a60:	910aa000 	add	x0, x0, #0x2a8
    c0003a64:	97fff8a4 	bl	c0001cf4 <mini_os_printf>
	mini_os_printf("  topo              Show topology summary\n");
    c0003a68:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003a6c:	910b4000 	add	x0, x0, #0x2d0
    c0003a70:	97fff8a1 	bl	c0001cf4 <mini_os_printf>
	mini_os_printf("  smp status        Show SMP status\n");
    c0003a74:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003a78:	910c0000 	add	x0, x0, #0x300
    c0003a7c:	97fff89e 	bl	c0001cf4 <mini_os_printf>
	mini_os_printf("  smp start <mpidr> Ask TF-A via SMC/PSCI to start a secondary CPU\n");
    c0003a80:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003a84:	910ca000 	add	x0, x0, #0x328
    c0003a88:	97fff89b 	bl	c0001cf4 <mini_os_printf>
	mini_os_printf("  echo ...          Print arguments back to the console\n");
    c0003a8c:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003a90:	910dc000 	add	x0, x0, #0x370
    c0003a94:	97fff898 	bl	c0001cf4 <mini_os_printf>
	mini_os_printf("  clear             Clear the terminal screen\n");
    c0003a98:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003a9c:	910ec000 	add	x0, x0, #0x3b0
    c0003aa0:	97fff895 	bl	c0001cf4 <mini_os_printf>
	mini_os_printf("  uname             Print the OS name\n");
    c0003aa4:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003aa8:	910f8000 	add	x0, x0, #0x3e0
    c0003aac:	97fff892 	bl	c0001cf4 <mini_os_printf>
	mini_os_printf("  halt              Stop the CPU in a low-power wait loop\n");
    c0003ab0:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003ab4:	91102000 	add	x0, x0, #0x408
    c0003ab8:	97fff88f 	bl	c0001cf4 <mini_os_printf>
	mini_os_printf("Examples: help --cpus, help --smp, help --topo\n");
    c0003abc:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003ac0:	91112000 	add	x0, x0, #0x448
    c0003ac4:	97fff88c 	bl	c0001cf4 <mini_os_printf>
}
    c0003ac8:	d503201f 	nop
    c0003acc:	a8c17bfd 	ldp	x29, x30, [sp], #16
    c0003ad0:	d65f03c0 	ret

00000000c0003ad4 <shell_print_help_topic>:

static void shell_print_help_topic(const char *topic)
{
    c0003ad4:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c0003ad8:	910003fd 	mov	x29, sp
    c0003adc:	f9000fe0 	str	x0, [sp, #24]
	if ((topic == (const char *)0) || strings_equal(topic, "help")) {
    c0003ae0:	f9400fe0 	ldr	x0, [sp, #24]
    c0003ae4:	f100001f 	cmp	x0, #0x0
    c0003ae8:	54000120 	b.eq	c0003b0c <shell_print_help_topic+0x38>  // b.none
    c0003aec:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003af0:	9111e001 	add	x1, x0, #0x478
    c0003af4:	f9400fe0 	ldr	x0, [sp, #24]
    c0003af8:	97fffe84 	bl	c0003508 <strings_equal>
    c0003afc:	12001c00 	and	w0, w0, #0xff
    c0003b00:	12000000 	and	w0, w0, #0x1
    c0003b04:	7100001f 	cmp	w0, #0x0
    c0003b08:	54000280 	b.eq	c0003b58 <shell_print_help_topic+0x84>  // b.none
		mini_os_printf("help [--topic]\n");
    c0003b0c:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003b10:	91120000 	add	x0, x0, #0x480
    c0003b14:	97fff878 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  Show the command list or detailed help for a single topic.\n");
    c0003b18:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003b1c:	91124000 	add	x0, x0, #0x490
    c0003b20:	97fff875 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("Examples:\n");
    c0003b24:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003b28:	91134000 	add	x0, x0, #0x4d0
    c0003b2c:	97fff872 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  help\n");
    c0003b30:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003b34:	91138000 	add	x0, x0, #0x4e0
    c0003b38:	97fff86f 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  help --cpus\n");
    c0003b3c:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003b40:	9113a000 	add	x0, x0, #0x4e8
    c0003b44:	97fff86c 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  help --smp\n");
    c0003b48:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003b4c:	9113e000 	add	x0, x0, #0x4f8
    c0003b50:	97fff869 	bl	c0001cf4 <mini_os_printf>
		return;
    c0003b54:	140000fb 	b	c0003f40 <shell_print_help_topic+0x46c>
	}

	if (strings_equal(topic, "cpu")) {
    c0003b58:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003b5c:	91142001 	add	x1, x0, #0x508
    c0003b60:	f9400fe0 	ldr	x0, [sp, #24]
    c0003b64:	97fffe69 	bl	c0003508 <strings_equal>
    c0003b68:	12001c00 	and	w0, w0, #0xff
    c0003b6c:	12000000 	and	w0, w0, #0x1
    c0003b70:	7100001f 	cmp	w0, #0x0
    c0003b74:	540002e0 	b.eq	c0003bd0 <shell_print_help_topic+0xfc>  // b.none
		mini_os_printf("cpu [id]\n");
    c0003b78:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003b7c:	91144000 	add	x0, x0, #0x510
    c0003b80:	97fff85d 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  Show one logical CPU entry from the topology/SMP tables.\n");
    c0003b84:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003b88:	91148000 	add	x0, x0, #0x520
    c0003b8c:	97fff85a 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  If no id is given, it prints the current boot CPU entry.\n");
    c0003b90:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003b94:	91158000 	add	x0, x0, #0x560
    c0003b98:	97fff857 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("Examples:\n");
    c0003b9c:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003ba0:	91134000 	add	x0, x0, #0x4d0
    c0003ba4:	97fff854 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  cpu\n");
    c0003ba8:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003bac:	91168000 	add	x0, x0, #0x5a0
    c0003bb0:	97fff851 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  cpu 0\n");
    c0003bb4:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003bb8:	9116a000 	add	x0, x0, #0x5a8
    c0003bbc:	97fff84e 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  cpu 1\n");
    c0003bc0:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003bc4:	9116e000 	add	x0, x0, #0x5b8
    c0003bc8:	97fff84b 	bl	c0001cf4 <mini_os_printf>
		return;
    c0003bcc:	140000dd 	b	c0003f40 <shell_print_help_topic+0x46c>
	}

	if (strings_equal(topic, "cpus")) {
    c0003bd0:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003bd4:	91172001 	add	x1, x0, #0x5c8
    c0003bd8:	f9400fe0 	ldr	x0, [sp, #24]
    c0003bdc:	97fffe4b 	bl	c0003508 <strings_equal>
    c0003be0:	12001c00 	and	w0, w0, #0xff
    c0003be4:	12000000 	and	w0, w0, #0x1
    c0003be8:	7100001f 	cmp	w0, #0x0
    c0003bec:	54000280 	b.eq	c0003c3c <shell_print_help_topic+0x168>  // b.none
		mini_os_printf("cpus\n");
    c0003bf0:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003bf4:	91174000 	add	x0, x0, #0x5d0
    c0003bf8:	97fff83f 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  List all CPUs that are currently registered in the topology table.\n");
    c0003bfc:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003c00:	91176000 	add	x0, x0, #0x5d8
    c0003c04:	97fff83c 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  The line shows mpidr/chip/die/cluster/core plus online, scheduled, pending and boot flags.\n");
    c0003c08:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003c0c:	91188000 	add	x0, x0, #0x620
    c0003c10:	97fff839 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("Examples:\n");
    c0003c14:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003c18:	91134000 	add	x0, x0, #0x4d0
    c0003c1c:	97fff836 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  cpus\n");
    c0003c20:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003c24:	911a0000 	add	x0, x0, #0x680
    c0003c28:	97fff833 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  help --cpu\n");
    c0003c2c:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003c30:	911a2000 	add	x0, x0, #0x688
    c0003c34:	97fff830 	bl	c0001cf4 <mini_os_printf>
		return;
    c0003c38:	140000c2 	b	c0003f40 <shell_print_help_topic+0x46c>
	}

	if (strings_equal(topic, "topo")) {
    c0003c3c:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003c40:	911a6001 	add	x1, x0, #0x698
    c0003c44:	f9400fe0 	ldr	x0, [sp, #24]
    c0003c48:	97fffe30 	bl	c0003508 <strings_equal>
    c0003c4c:	12001c00 	and	w0, w0, #0xff
    c0003c50:	12000000 	and	w0, w0, #0x1
    c0003c54:	7100001f 	cmp	w0, #0x0
    c0003c58:	54000220 	b.eq	c0003c9c <shell_print_help_topic+0x1c8>  // b.none
		mini_os_printf("topo\n");
    c0003c5c:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003c60:	911a8000 	add	x0, x0, #0x6a0
    c0003c64:	97fff824 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  Print a compact topology summary for the boot CPU and current CPU counts.\n");
    c0003c68:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003c6c:	911aa000 	add	x0, x0, #0x6a8
    c0003c70:	97fff821 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  Useful for checking the boot MPIDR and the decoded chip/die/cluster/core affinity.\n");
    c0003c74:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003c78:	911be000 	add	x0, x0, #0x6f8
    c0003c7c:	97fff81e 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("Examples:\n");
    c0003c80:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003c84:	91134000 	add	x0, x0, #0x4d0
    c0003c88:	97fff81b 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  topo\n");
    c0003c8c:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003c90:	911d4000 	add	x0, x0, #0x750
    c0003c94:	97fff818 	bl	c0001cf4 <mini_os_printf>
		return;
    c0003c98:	140000aa 	b	c0003f40 <shell_print_help_topic+0x46c>
	}

	if (strings_equal(topic, "smp")) {
    c0003c9c:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003ca0:	911d6001 	add	x1, x0, #0x758
    c0003ca4:	f9400fe0 	ldr	x0, [sp, #24]
    c0003ca8:	97fffe18 	bl	c0003508 <strings_equal>
    c0003cac:	12001c00 	and	w0, w0, #0xff
    c0003cb0:	12000000 	and	w0, w0, #0x1
    c0003cb4:	7100001f 	cmp	w0, #0x0
    c0003cb8:	540003a0 	b.eq	c0003d2c <shell_print_help_topic+0x258>  // b.none
		mini_os_printf("smp status\n");
    c0003cbc:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003cc0:	911d8000 	add	x0, x0, #0x760
    c0003cc4:	97fff80c 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  Show the same per-CPU runtime table as 'cpus'.\n");
    c0003cc8:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003ccc:	911dc000 	add	x0, x0, #0x770
    c0003cd0:	97fff809 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("smp start <mpidr>\n");
    c0003cd4:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003cd8:	911ea000 	add	x0, x0, #0x7a8
    c0003cdc:	97fff806 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  Ask TF-A/BL31 through SMC/PSCI CPU_ON to start the target CPU identified by MPIDR.\n");
    c0003ce0:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003ce4:	911f0000 	add	x0, x0, #0x7c0
    c0003ce8:	97fff803 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  The shell passes TF-A the target MPIDR and the mini-OS secondary entry address.\n");
    c0003cec:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003cf0:	91206000 	add	x0, x0, #0x818
    c0003cf4:	97fff800 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("Examples:\n");
    c0003cf8:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003cfc:	91134000 	add	x0, x0, #0x4d0
    c0003d00:	97fff7fd 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  smp status\n");
    c0003d04:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003d08:	9121c000 	add	x0, x0, #0x870
    c0003d0c:	97fff7fa 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  smp start 0x80000001\n");
    c0003d10:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003d14:	91220000 	add	x0, x0, #0x880
    c0003d18:	97fff7f7 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  smp start 2147483649\n");
    c0003d1c:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003d20:	91226000 	add	x0, x0, #0x898
    c0003d24:	97fff7f4 	bl	c0001cf4 <mini_os_printf>
		return;
    c0003d28:	14000086 	b	c0003f40 <shell_print_help_topic+0x46c>
	}

	if (strings_equal(topic, "info")) {
    c0003d2c:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003d30:	9122c001 	add	x1, x0, #0x8b0
    c0003d34:	f9400fe0 	ldr	x0, [sp, #24]
    c0003d38:	97fffdf4 	bl	c0003508 <strings_equal>
    c0003d3c:	12001c00 	and	w0, w0, #0xff
    c0003d40:	12000000 	and	w0, w0, #0x1
    c0003d44:	7100001f 	cmp	w0, #0x0
    c0003d48:	540001c0 	b.eq	c0003d80 <shell_print_help_topic+0x2ac>  // b.none
		mini_os_printf("info\n");
    c0003d4c:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003d50:	9122e000 	add	x0, x0, #0x8b8
    c0003d54:	97fff7e8 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  Show platform-level runtime information such as UART base, load address, boot magic and runnable CPU count.\n");
    c0003d58:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003d5c:	91230000 	add	x0, x0, #0x8c0
    c0003d60:	97fff7e5 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("Example:\n");
    c0003d64:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003d68:	9124c000 	add	x0, x0, #0x930
    c0003d6c:	97fff7e2 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  info\n");
    c0003d70:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003d74:	91250000 	add	x0, x0, #0x940
    c0003d78:	97fff7df 	bl	c0001cf4 <mini_os_printf>
		return;
    c0003d7c:	14000071 	b	c0003f40 <shell_print_help_topic+0x46c>
	}

	if (strings_equal(topic, "version")) {
    c0003d80:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003d84:	91252001 	add	x1, x0, #0x948
    c0003d88:	f9400fe0 	ldr	x0, [sp, #24]
    c0003d8c:	97fffddf 	bl	c0003508 <strings_equal>
    c0003d90:	12001c00 	and	w0, w0, #0xff
    c0003d94:	12000000 	and	w0, w0, #0x1
    c0003d98:	7100001f 	cmp	w0, #0x0
    c0003d9c:	540001c0 	b.eq	c0003dd4 <shell_print_help_topic+0x300>  // b.none
		mini_os_printf("version\n");
    c0003da0:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003da4:	91254000 	add	x0, x0, #0x950
    c0003da8:	97fff7d3 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  Show the Mini-OS name, version string and build year.\n");
    c0003dac:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003db0:	91258000 	add	x0, x0, #0x960
    c0003db4:	97fff7d0 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("Example:\n");
    c0003db8:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003dbc:	9124c000 	add	x0, x0, #0x930
    c0003dc0:	97fff7cd 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  version\n");
    c0003dc4:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003dc8:	91268000 	add	x0, x0, #0x9a0
    c0003dcc:	97fff7ca 	bl	c0001cf4 <mini_os_printf>
		return;
    c0003dd0:	1400005c 	b	c0003f40 <shell_print_help_topic+0x46c>
	}

	if (strings_equal(topic, "echo")) {
    c0003dd4:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003dd8:	9126c001 	add	x1, x0, #0x9b0
    c0003ddc:	f9400fe0 	ldr	x0, [sp, #24]
    c0003de0:	97fffdca 	bl	c0003508 <strings_equal>
    c0003de4:	12001c00 	and	w0, w0, #0xff
    c0003de8:	12000000 	and	w0, w0, #0x1
    c0003dec:	7100001f 	cmp	w0, #0x0
    c0003df0:	540001c0 	b.eq	c0003e28 <shell_print_help_topic+0x354>  // b.none
		mini_os_printf("echo <text...>\n");
    c0003df4:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003df8:	9126e000 	add	x0, x0, #0x9b8
    c0003dfc:	97fff7be 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  Print the provided arguments back to the serial console.\n");
    c0003e00:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003e04:	91272000 	add	x0, x0, #0x9c8
    c0003e08:	97fff7bb 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("Example:\n");
    c0003e0c:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003e10:	9124c000 	add	x0, x0, #0x930
    c0003e14:	97fff7b8 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  echo hello mini-os\n");
    c0003e18:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003e1c:	91282000 	add	x0, x0, #0xa08
    c0003e20:	97fff7b5 	bl	c0001cf4 <mini_os_printf>
		return;
    c0003e24:	14000047 	b	c0003f40 <shell_print_help_topic+0x46c>
	}

	if (strings_equal(topic, "clear")) {
    c0003e28:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003e2c:	91288001 	add	x1, x0, #0xa20
    c0003e30:	f9400fe0 	ldr	x0, [sp, #24]
    c0003e34:	97fffdb5 	bl	c0003508 <strings_equal>
    c0003e38:	12001c00 	and	w0, w0, #0xff
    c0003e3c:	12000000 	and	w0, w0, #0x1
    c0003e40:	7100001f 	cmp	w0, #0x0
    c0003e44:	540001c0 	b.eq	c0003e7c <shell_print_help_topic+0x3a8>  // b.none
		mini_os_printf("clear\n");
    c0003e48:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003e4c:	9128a000 	add	x0, x0, #0xa28
    c0003e50:	97fff7a9 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  Send ANSI escape sequences to clear the serial terminal and move the cursor to the top-left corner.\n");
    c0003e54:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003e58:	9128c000 	add	x0, x0, #0xa30
    c0003e5c:	97fff7a6 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("Example:\n");
    c0003e60:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003e64:	9124c000 	add	x0, x0, #0x930
    c0003e68:	97fff7a3 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  clear\n");
    c0003e6c:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003e70:	912a6000 	add	x0, x0, #0xa98
    c0003e74:	97fff7a0 	bl	c0001cf4 <mini_os_printf>
		return;
    c0003e78:	14000032 	b	c0003f40 <shell_print_help_topic+0x46c>
	}

	if (strings_equal(topic, "uname")) {
    c0003e7c:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003e80:	912aa001 	add	x1, x0, #0xaa8
    c0003e84:	f9400fe0 	ldr	x0, [sp, #24]
    c0003e88:	97fffda0 	bl	c0003508 <strings_equal>
    c0003e8c:	12001c00 	and	w0, w0, #0xff
    c0003e90:	12000000 	and	w0, w0, #0x1
    c0003e94:	7100001f 	cmp	w0, #0x0
    c0003e98:	540001c0 	b.eq	c0003ed0 <shell_print_help_topic+0x3fc>  // b.none
		mini_os_printf("uname\n");
    c0003e9c:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003ea0:	912ac000 	add	x0, x0, #0xab0
    c0003ea4:	97fff794 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  Print the OS name only.\n");
    c0003ea8:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003eac:	912ae000 	add	x0, x0, #0xab8
    c0003eb0:	97fff791 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("Example:\n");
    c0003eb4:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003eb8:	9124c000 	add	x0, x0, #0x930
    c0003ebc:	97fff78e 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  uname\n");
    c0003ec0:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003ec4:	912b6000 	add	x0, x0, #0xad8
    c0003ec8:	97fff78b 	bl	c0001cf4 <mini_os_printf>
		return;
    c0003ecc:	1400001d 	b	c0003f40 <shell_print_help_topic+0x46c>
	}

	if (strings_equal(topic, "halt")) {
    c0003ed0:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003ed4:	912ba001 	add	x1, x0, #0xae8
    c0003ed8:	f9400fe0 	ldr	x0, [sp, #24]
    c0003edc:	97fffd8b 	bl	c0003508 <strings_equal>
    c0003ee0:	12001c00 	and	w0, w0, #0xff
    c0003ee4:	12000000 	and	w0, w0, #0x1
    c0003ee8:	7100001f 	cmp	w0, #0x0
    c0003eec:	540001c0 	b.eq	c0003f24 <shell_print_help_topic+0x450>  // b.none
		mini_os_printf("halt\n");
    c0003ef0:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003ef4:	912bc000 	add	x0, x0, #0xaf0
    c0003ef8:	97fff77f 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  Stop the current CPU in a low-power wait loop.\n");
    c0003efc:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003f00:	912be000 	add	x0, x0, #0xaf8
    c0003f04:	97fff77c 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("Example:\n");
    c0003f08:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003f0c:	9124c000 	add	x0, x0, #0x930
    c0003f10:	97fff779 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  halt\n");
    c0003f14:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003f18:	912cc000 	add	x0, x0, #0xb30
    c0003f1c:	97fff776 	bl	c0001cf4 <mini_os_printf>
		return;
    c0003f20:	14000008 	b	c0003f40 <shell_print_help_topic+0x46c>
	}

	mini_os_printf("No detailed help for topic '%s'.\n", topic);
    c0003f24:	f9400fe1 	ldr	x1, [sp, #24]
    c0003f28:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003f2c:	912ce000 	add	x0, x0, #0xb38
    c0003f30:	97fff771 	bl	c0001cf4 <mini_os_printf>
	mini_os_printf("Try one of: cpu, cpus, topo, smp, info, version, echo, clear, uname, halt\n");
    c0003f34:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003f38:	912d8000 	add	x0, x0, #0xb60
    c0003f3c:	97fff76e 	bl	c0001cf4 <mini_os_printf>
}
    c0003f40:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c0003f44:	d65f03c0 	ret

00000000c0003f48 <shell_print_help>:

void shell_print_help(void)
{
    c0003f48:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    c0003f4c:	910003fd 	mov	x29, sp
	shell_print_help_overview();
    c0003f50:	97fffeb2 	bl	c0003a18 <shell_print_help_overview>
}
    c0003f54:	d503201f 	nop
    c0003f58:	a8c17bfd 	ldp	x29, x30, [sp], #16
    c0003f5c:	d65f03c0 	ret

00000000c0003f60 <shell_print_version>:

static void shell_print_version(void)
{
    c0003f60:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    c0003f64:	910003fd 	mov	x29, sp
	mini_os_printf("%s %s (%d)\n", MINI_OS_NAME, MINI_OS_VERSION,
    c0003f68:	5280fd43 	mov	w3, #0x7ea                 	// #2026
    c0003f6c:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003f70:	912ec002 	add	x2, x0, #0xbb0
    c0003f74:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003f78:	912ee001 	add	x1, x0, #0xbb8
    c0003f7c:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003f80:	912f0000 	add	x0, x0, #0xbc0
    c0003f84:	97fff75c 	bl	c0001cf4 <mini_os_printf>
		       MINI_OS_BUILD_YEAR);
}
    c0003f88:	d503201f 	nop
    c0003f8c:	a8c17bfd 	ldp	x29, x30, [sp], #16
    c0003f90:	d65f03c0 	ret

00000000c0003f94 <shell_print_info>:

static void shell_print_info(void)
{
    c0003f94:	a9ba7bfd 	stp	x29, x30, [sp, #-96]!
    c0003f98:	910003fd 	mov	x29, sp
	mini_os_printf("Platform      : %s\n", "Neoverse-N3");
    c0003f9c:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003fa0:	912f4001 	add	x1, x0, #0xbd0
    c0003fa4:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003fa8:	912f8000 	add	x0, x0, #0xbe0
    c0003fac:	97fff752 	bl	c0001cf4 <mini_os_printf>
	mini_os_printf("UART base     : 0x%llx\n",
    c0003fb0:	d2a34801 	mov	x1, #0x1a400000            	// #440401920
    c0003fb4:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003fb8:	912fe000 	add	x0, x0, #0xbf8
    c0003fbc:	97fff74e 	bl	c0001cf4 <mini_os_printf>
		       (unsigned long long)PLAT_UART0_BASE);
	mini_os_printf("Load address  : 0x%llx\n",
    c0003fc0:	d2b80001 	mov	x1, #0xc0000000            	// #3221225472
    c0003fc4:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003fc8:	91304000 	add	x0, x0, #0xc10
    c0003fcc:	97fff74a 	bl	c0001cf4 <mini_os_printf>
		       (unsigned long long)PLAT_LOAD_ADDR);
	mini_os_printf("Boot magic    : 0x%llx\n",
    c0003fd0:	90000020 	adrp	x0, c0007000 <hex.0+0x1128>
    c0003fd4:	910cc000 	add	x0, x0, #0x330
    c0003fd8:	f9400000 	ldr	x0, [x0]
    c0003fdc:	aa0003e1 	mov	x1, x0
    c0003fe0:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0003fe4:	9130a000 	add	x0, x0, #0xc28
    c0003fe8:	97fff743 	bl	c0001cf4 <mini_os_printf>
		       (unsigned long long)boot_magic);
	struct early_allocator_stats mm_stats;
	early_mm_get_stats(&mm_stats);
    c0003fec:	910043e0 	add	x0, sp, #0x10
    c0003ff0:	97fffbf0 	bl	c0002fb0 <early_mm_get_stats>
	mini_os_printf("Runnable CPUs : %u\n", scheduler_runnable_cpu_count());
    c0003ff4:	97fffd1b 	bl	c0003460 <scheduler_runnable_cpu_count>
    c0003ff8:	2a0003e1 	mov	w1, w0
    c0003ffc:	f0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0004000:	91310000 	add	x0, x0, #0xc40
    c0004004:	97fff73c 	bl	c0001cf4 <mini_os_printf>
	mini_os_printf("Early heap    : %s 0x%llx-0x%llx (%u/%u bytes used, peak=%u)\n",
    c0004008:	f9400be0 	ldr	x0, [sp, #16]
		       mm_stats.name,
		       (unsigned long long)mm_stats.start,
    c000400c:	f9400fe1 	ldr	x1, [sp, #24]
		       (unsigned long long)mm_stats.end,
    c0004010:	f94017e2 	ldr	x2, [sp, #40]
		       (unsigned int)mm_stats.used_bytes,
    c0004014:	f9401fe3 	ldr	x3, [sp, #56]
	mini_os_printf("Early heap    : %s 0x%llx-0x%llx (%u/%u bytes used, peak=%u)\n",
    c0004018:	2a0303e4 	mov	w4, w3
		       (unsigned int)mm_stats.total_bytes,
    c000401c:	f9401be3 	ldr	x3, [sp, #48]
	mini_os_printf("Early heap    : %s 0x%llx-0x%llx (%u/%u bytes used, peak=%u)\n",
    c0004020:	2a0303e5 	mov	w5, w3
		       (unsigned int)mm_stats.peak_used_bytes);
    c0004024:	f94027e3 	ldr	x3, [sp, #72]
	mini_os_printf("Early heap    : %s 0x%llx-0x%llx (%u/%u bytes used, peak=%u)\n",
    c0004028:	2a0303e6 	mov	w6, w3
    c000402c:	aa0203e3 	mov	x3, x2
    c0004030:	aa0103e2 	mov	x2, x1
    c0004034:	aa0003e1 	mov	x1, x0
    c0004038:	d0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c000403c:	91316000 	add	x0, x0, #0xc58
    c0004040:	97fff72d 	bl	c0001cf4 <mini_os_printf>
	mini_os_printf("Early allocs  : %u (page size=%u)\n",
		       (unsigned int)mm_stats.allocation_count,
    c0004044:	f9402be0 	ldr	x0, [sp, #80]
	mini_os_printf("Early allocs  : %u (page size=%u)\n",
    c0004048:	2a0003e1 	mov	w1, w0
		       (unsigned int)mm_stats.page_size);
    c000404c:	f9402fe0 	ldr	x0, [sp, #88]
	mini_os_printf("Early allocs  : %u (page size=%u)\n",
    c0004050:	2a0003e2 	mov	w2, w0
    c0004054:	d0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0004058:	91326000 	add	x0, x0, #0xc98
    c000405c:	97fff726 	bl	c0001cf4 <mini_os_printf>
	mini_os_printf("Sched objects : %u\n",
		       (unsigned int)scheduler_bootstrap_object_count());
    c0004060:	97fffd11 	bl	c00034a4 <scheduler_bootstrap_object_count>
	mini_os_printf("Sched objects : %u\n",
    c0004064:	2a0003e1 	mov	w1, w0
    c0004068:	d0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c000406c:	91330000 	add	x0, x0, #0xcc0
    c0004070:	97fff721 	bl	c0001cf4 <mini_os_printf>
}
    c0004074:	d503201f 	nop
    c0004078:	a8c67bfd 	ldp	x29, x30, [sp], #96
    c000407c:	d65f03c0 	ret

00000000c0004080 <shell_print_current_cpu>:

static void shell_print_current_cpu(void)
{
    c0004080:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    c0004084:	910003fd 	mov	x29, sp
	shell_print_cpu_entry(0U);
    c0004088:	52800000 	mov	w0, #0x0                   	// #0
    c000408c:	97fffe09 	bl	c00038b0 <shell_print_cpu_entry>
}
    c0004090:	d503201f 	nop
    c0004094:	a8c17bfd 	ldp	x29, x30, [sp], #16
    c0004098:	d65f03c0 	ret

00000000c000409c <shell_print_cpu_id>:

static void shell_print_cpu_id(const char *arg)
{
    c000409c:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
    c00040a0:	910003fd 	mov	x29, sp
    c00040a4:	f9000fe0 	str	x0, [sp, #24]
	uint64_t logical_id;
	const struct cpu_topology_descriptor *cpu;

	if (!parse_u64(arg, &logical_id)) {
    c00040a8:	910083e0 	add	x0, sp, #0x20
    c00040ac:	aa0003e1 	mov	x1, x0
    c00040b0:	f9400fe0 	ldr	x0, [sp, #24]
    c00040b4:	97fffd58 	bl	c0003614 <parse_u64>
    c00040b8:	12001c00 	and	w0, w0, #0xff
    c00040bc:	52000000 	eor	w0, w0, #0x1
    c00040c0:	12001c00 	and	w0, w0, #0xff
    c00040c4:	12000000 	and	w0, w0, #0x1
    c00040c8:	7100001f 	cmp	w0, #0x0
    c00040cc:	540000c0 	b.eq	c00040e4 <shell_print_cpu_id+0x48>  // b.none
		mini_os_printf("error: invalid cpu id '%s'\n", arg);
    c00040d0:	f9400fe1 	ldr	x1, [sp, #24]
    c00040d4:	d0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c00040d8:	91336000 	add	x0, x0, #0xcd8
    c00040dc:	97fff706 	bl	c0001cf4 <mini_os_printf>
		return;
    c00040e0:	14000016 	b	c0004138 <shell_print_cpu_id+0x9c>
	}

	cpu = topology_cpu((unsigned int)logical_id);
    c00040e4:	f94013e0 	ldr	x0, [sp, #32]
    c00040e8:	94000631 	bl	c00059ac <topology_cpu>
    c00040ec:	f90017e0 	str	x0, [sp, #40]
	if ((cpu == (const struct cpu_topology_descriptor *)0) || !cpu->present) {
    c00040f0:	f94017e0 	ldr	x0, [sp, #40]
    c00040f4:	f100001f 	cmp	x0, #0x0
    c00040f8:	54000100 	b.eq	c0004118 <shell_print_cpu_id+0x7c>  // b.none
    c00040fc:	f94017e0 	ldr	x0, [sp, #40]
    c0004100:	39407400 	ldrb	w0, [x0, #29]
    c0004104:	52000000 	eor	w0, w0, #0x1
    c0004108:	12001c00 	and	w0, w0, #0xff
    c000410c:	12000000 	and	w0, w0, #0x1
    c0004110:	7100001f 	cmp	w0, #0x0
    c0004114:	540000e0 	b.eq	c0004130 <shell_print_cpu_id+0x94>  // b.none
		mini_os_printf("cpu%u is not present\n", (unsigned int)logical_id);
    c0004118:	f94013e0 	ldr	x0, [sp, #32]
    c000411c:	2a0003e1 	mov	w1, w0
    c0004120:	d0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0004124:	9133e000 	add	x0, x0, #0xcf8
    c0004128:	97fff6f3 	bl	c0001cf4 <mini_os_printf>
		return;
    c000412c:	14000003 	b	c0004138 <shell_print_cpu_id+0x9c>
	}

	shell_print_cpu_entry((unsigned int)logical_id);
    c0004130:	f94013e0 	ldr	x0, [sp, #32]
    c0004134:	97fffddf 	bl	c00038b0 <shell_print_cpu_entry>
}
    c0004138:	a8c37bfd 	ldp	x29, x30, [sp], #48
    c000413c:	d65f03c0 	ret

00000000c0004140 <shell_print_cpus>:

static void shell_print_cpus(void)
{
    c0004140:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
    c0004144:	910003fd 	mov	x29, sp
    c0004148:	a90153f3 	stp	x19, x20, [sp, #16]
	unsigned int i;

	for (i = 0U; i < topology_cpu_capacity(); ++i) {
    c000414c:	b9002fff 	str	wzr, [sp, #44]
    c0004150:	14000011 	b	c0004194 <shell_print_cpus+0x54>
		const struct cpu_topology_descriptor *cpu = topology_cpu(i);
    c0004154:	b9402fe0 	ldr	w0, [sp, #44]
    c0004158:	94000615 	bl	c00059ac <topology_cpu>
    c000415c:	f90013e0 	str	x0, [sp, #32]

		if ((cpu != (const struct cpu_topology_descriptor *)0) && cpu->present) {
    c0004160:	f94013e0 	ldr	x0, [sp, #32]
    c0004164:	f100001f 	cmp	x0, #0x0
    c0004168:	54000100 	b.eq	c0004188 <shell_print_cpus+0x48>  // b.none
    c000416c:	f94013e0 	ldr	x0, [sp, #32]
    c0004170:	39407400 	ldrb	w0, [x0, #29]
    c0004174:	12000000 	and	w0, w0, #0x1
    c0004178:	7100001f 	cmp	w0, #0x0
    c000417c:	54000060 	b.eq	c0004188 <shell_print_cpus+0x48>  // b.none
			shell_print_cpu_entry(i);
    c0004180:	b9402fe0 	ldr	w0, [sp, #44]
    c0004184:	97fffdcb 	bl	c00038b0 <shell_print_cpu_entry>
	for (i = 0U; i < topology_cpu_capacity(); ++i) {
    c0004188:	b9402fe0 	ldr	w0, [sp, #44]
    c000418c:	11000400 	add	w0, w0, #0x1
    c0004190:	b9002fe0 	str	w0, [sp, #44]
    c0004194:	94000639 	bl	c0005a78 <topology_cpu_capacity>
    c0004198:	2a0003e1 	mov	w1, w0
    c000419c:	b9402fe0 	ldr	w0, [sp, #44]
    c00041a0:	6b01001f 	cmp	w0, w1
    c00041a4:	54fffd83 	b.cc	c0004154 <shell_print_cpus+0x14>  // b.lo, b.ul, b.last
		}
	}
	mini_os_printf("online=%u runnable=%u capacity=%u\n",
    c00041a8:	9400063a 	bl	c0005a90 <topology_online_cpu_count>
    c00041ac:	2a0003f3 	mov	w19, w0
    c00041b0:	97fffcac 	bl	c0003460 <scheduler_runnable_cpu_count>
    c00041b4:	2a0003f4 	mov	w20, w0
    c00041b8:	94000630 	bl	c0005a78 <topology_cpu_capacity>
    c00041bc:	2a0003e3 	mov	w3, w0
    c00041c0:	2a1403e2 	mov	w2, w20
    c00041c4:	2a1303e1 	mov	w1, w19
    c00041c8:	d0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c00041cc:	91344000 	add	x0, x0, #0xd10
    c00041d0:	97fff6c9 	bl	c0001cf4 <mini_os_printf>
		       topology_online_cpu_count(),
		       scheduler_runnable_cpu_count(),
		       topology_cpu_capacity());
}
    c00041d4:	d503201f 	nop
    c00041d8:	a94153f3 	ldp	x19, x20, [sp, #16]
    c00041dc:	a8c37bfd 	ldp	x29, x30, [sp], #48
    c00041e0:	d65f03c0 	ret

00000000c00041e4 <shell_print_topology_summary>:

static void shell_print_topology_summary(void)
{
    c00041e4:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c00041e8:	910003fd 	mov	x29, sp
	const struct cpu_topology_descriptor *boot_cpu = topology_boot_cpu();
    c00041ec:	940005ed 	bl	c00059a0 <topology_boot_cpu>
    c00041f0:	f9000fe0 	str	x0, [sp, #24]

	mini_os_printf("Topology summary:\n");
    c00041f4:	d0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c00041f8:	9134e000 	add	x0, x0, #0xd38
    c00041fc:	97fff6be 	bl	c0001cf4 <mini_os_printf>
	mini_os_printf("  present cpus : %u\n", topology_present_cpu_count());
    c0004200:	94000620 	bl	c0005a80 <topology_present_cpu_count>
    c0004204:	2a0003e1 	mov	w1, w0
    c0004208:	d0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c000420c:	91354000 	add	x0, x0, #0xd50
    c0004210:	97fff6b9 	bl	c0001cf4 <mini_os_printf>
	mini_os_printf("  online cpus  : %u\n", topology_online_cpu_count());
    c0004214:	9400061f 	bl	c0005a90 <topology_online_cpu_count>
    c0004218:	2a0003e1 	mov	w1, w0
    c000421c:	d0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0004220:	9135a000 	add	x0, x0, #0xd68
    c0004224:	97fff6b4 	bl	c0001cf4 <mini_os_printf>
	mini_os_printf("  boot cpu     : cpu%u\n", boot_cpu->logical_id);
    c0004228:	f9400fe0 	ldr	x0, [sp, #24]
    c000422c:	b9400800 	ldr	w0, [x0, #8]
    c0004230:	2a0003e1 	mov	w1, w0
    c0004234:	d0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0004238:	91360000 	add	x0, x0, #0xd80
    c000423c:	97fff6ae 	bl	c0001cf4 <mini_os_printf>
	mini_os_printf("  boot mpidr   : 0x%llx\n", (unsigned long long)boot_cpu->mpidr);
    c0004240:	f9400fe0 	ldr	x0, [sp, #24]
    c0004244:	f9400000 	ldr	x0, [x0]
    c0004248:	aa0003e1 	mov	x1, x0
    c000424c:	d0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0004250:	91366000 	add	x0, x0, #0xd98
    c0004254:	97fff6a8 	bl	c0001cf4 <mini_os_printf>
	mini_os_printf("  affinity     : chip=%u die=%u cluster=%u core=%u\n",
		       boot_cpu->chip_id,
    c0004258:	f9400fe0 	ldr	x0, [sp, #24]
    c000425c:	b9400c01 	ldr	w1, [x0, #12]
		       boot_cpu->die_id,
    c0004260:	f9400fe0 	ldr	x0, [sp, #24]
    c0004264:	b9401002 	ldr	w2, [x0, #16]
		       boot_cpu->cluster_id,
    c0004268:	f9400fe0 	ldr	x0, [sp, #24]
    c000426c:	b9401403 	ldr	w3, [x0, #20]
		       boot_cpu->core_id);
    c0004270:	f9400fe0 	ldr	x0, [sp, #24]
    c0004274:	b9401800 	ldr	w0, [x0, #24]
	mini_os_printf("  affinity     : chip=%u die=%u cluster=%u core=%u\n",
    c0004278:	2a0003e4 	mov	w4, w0
    c000427c:	d0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0004280:	9136e000 	add	x0, x0, #0xdb8
    c0004284:	97fff69c 	bl	c0001cf4 <mini_os_printf>
}
    c0004288:	d503201f 	nop
    c000428c:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c0004290:	d65f03c0 	ret

00000000c0004294 <shell_echo_args>:

static void shell_echo_args(int argc, char *argv[])
{
    c0004294:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
    c0004298:	910003fd 	mov	x29, sp
    c000429c:	b9001fe0 	str	w0, [sp, #28]
    c00042a0:	f9000be1 	str	x1, [sp, #16]
	int i;

	for (i = 1; i < argc; ++i) {
    c00042a4:	52800020 	mov	w0, #0x1                   	// #1
    c00042a8:	b9002fe0 	str	w0, [sp, #44]
    c00042ac:	14000015 	b	c0004300 <shell_echo_args+0x6c>
		mini_os_printf("%s", argv[i]);
    c00042b0:	b9802fe0 	ldrsw	x0, [sp, #44]
    c00042b4:	d37df000 	lsl	x0, x0, #3
    c00042b8:	f9400be1 	ldr	x1, [sp, #16]
    c00042bc:	8b000020 	add	x0, x1, x0
    c00042c0:	f9400000 	ldr	x0, [x0]
    c00042c4:	aa0003e1 	mov	x1, x0
    c00042c8:	d0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c00042cc:	9137c000 	add	x0, x0, #0xdf0
    c00042d0:	97fff689 	bl	c0001cf4 <mini_os_printf>
		if (i + 1 < argc) {
    c00042d4:	b9402fe0 	ldr	w0, [sp, #44]
    c00042d8:	11000400 	add	w0, w0, #0x1
    c00042dc:	b9401fe1 	ldr	w1, [sp, #28]
    c00042e0:	6b00003f 	cmp	w1, w0
    c00042e4:	5400008d 	b.le	c00042f4 <shell_echo_args+0x60>
			mini_os_printf(" ");
    c00042e8:	d0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c00042ec:	9137e000 	add	x0, x0, #0xdf8
    c00042f0:	97fff681 	bl	c0001cf4 <mini_os_printf>
	for (i = 1; i < argc; ++i) {
    c00042f4:	b9402fe0 	ldr	w0, [sp, #44]
    c00042f8:	11000400 	add	w0, w0, #0x1
    c00042fc:	b9002fe0 	str	w0, [sp, #44]
    c0004300:	b9402fe1 	ldr	w1, [sp, #44]
    c0004304:	b9401fe0 	ldr	w0, [sp, #28]
    c0004308:	6b00003f 	cmp	w1, w0
    c000430c:	54fffd2b 	b.lt	c00042b0 <shell_echo_args+0x1c>  // b.tstop
		}
	}
	mini_os_printf("\n");
    c0004310:	d0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0004314:	91380000 	add	x0, x0, #0xe00
    c0004318:	97fff677 	bl	c0001cf4 <mini_os_printf>
}
    c000431c:	d503201f 	nop
    c0004320:	a8c37bfd 	ldp	x29, x30, [sp], #48
    c0004324:	d65f03c0 	ret

00000000c0004328 <shell_clear_screen>:

static void shell_clear_screen(void)
{
    c0004328:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    c000432c:	910003fd 	mov	x29, sp
	mini_os_printf("\033[2J\033[H");
    c0004330:	d0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0004334:	91382000 	add	x0, x0, #0xe08
    c0004338:	97fff66f 	bl	c0001cf4 <mini_os_printf>
}
    c000433c:	d503201f 	nop
    c0004340:	a8c17bfd 	ldp	x29, x30, [sp], #16
    c0004344:	d65f03c0 	ret

00000000c0004348 <shell_halt>:

static void shell_halt(void)
{
    c0004348:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    c000434c:	910003fd 	mov	x29, sp
	mini_os_printf("Halting CPU. Use reset/restart in your emulator or board monitor.\n");
    c0004350:	d0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0004354:	91384000 	add	x0, x0, #0xe10
    c0004358:	97fff667 	bl	c0001cf4 <mini_os_printf>
	for (;;) {
		__asm__ volatile ("wfe");
    c000435c:	d503205f 	wfe
    c0004360:	17ffffff 	b	c000435c <shell_halt+0x14>

00000000c0004364 <shell_print_smp_already_online>:
}

static void shell_print_smp_already_online(uint64_t mpidr,
					   unsigned int logical_id,
					   const struct smp_cpu_state *state)
{
    c0004364:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
    c0004368:	910003fd 	mov	x29, sp
    c000436c:	f90017e0 	str	x0, [sp, #40]
    c0004370:	b90027e1 	str	w1, [sp, #36]
    c0004374:	f9000fe2 	str	x2, [sp, #24]
	if ((state != (const struct smp_cpu_state *)0) && state->boot_cpu) {
    c0004378:	f9400fe0 	ldr	x0, [sp, #24]
    c000437c:	f100001f 	cmp	x0, #0x0
    c0004380:	54000180 	b.eq	c00043b0 <shell_print_smp_already_online+0x4c>  // b.none
    c0004384:	f9400fe0 	ldr	x0, [sp, #24]
    c0004388:	39404c00 	ldrb	w0, [x0, #19]
    c000438c:	12000000 	and	w0, w0, #0x1
    c0004390:	7100001f 	cmp	w0, #0x0
    c0004394:	540000e0 	b.eq	c00043b0 <shell_print_smp_already_online+0x4c>  // b.none
		mini_os_printf("cpu%u (mpidr=0x%llx) is the boot CPU, already online by default\n",
    c0004398:	f94017e2 	ldr	x2, [sp, #40]
    c000439c:	b94027e1 	ldr	w1, [sp, #36]
    c00043a0:	d0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c00043a4:	91396000 	add	x0, x0, #0xe58
    c00043a8:	97fff653 	bl	c0001cf4 <mini_os_printf>
			       logical_id,
			       (unsigned long long)mpidr);
		return;
    c00043ac:	14000013 	b	c00043f8 <shell_print_smp_already_online+0x94>
	}

	if ((state != (const struct smp_cpu_state *)0) && state->online) {
    c00043b0:	f9400fe0 	ldr	x0, [sp, #24]
    c00043b4:	f100001f 	cmp	x0, #0x0
    c00043b8:	54000180 	b.eq	c00043e8 <shell_print_smp_already_online+0x84>  // b.none
    c00043bc:	f9400fe0 	ldr	x0, [sp, #24]
    c00043c0:	39404000 	ldrb	w0, [x0, #16]
    c00043c4:	12000000 	and	w0, w0, #0x1
    c00043c8:	7100001f 	cmp	w0, #0x0
    c00043cc:	540000e0 	b.eq	c00043e8 <shell_print_smp_already_online+0x84>  // b.none
		mini_os_printf("cpu%u (mpidr=0x%llx) is a secondary CPU that is already online and scheduled\n",
    c00043d0:	f94017e2 	ldr	x2, [sp, #40]
    c00043d4:	b94027e1 	ldr	w1, [sp, #36]
    c00043d8:	d0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c00043dc:	913a8000 	add	x0, x0, #0xea0
    c00043e0:	97fff645 	bl	c0001cf4 <mini_os_printf>
			       logical_id,
			       (unsigned long long)mpidr);
		return;
    c00043e4:	14000005 	b	c00043f8 <shell_print_smp_already_online+0x94>
	}

	mini_os_printf("TF-A returned already-on for mpidr=0x%llx, but mini-os did not observe this secondary CPU actually boot\n",
    c00043e8:	f94017e1 	ldr	x1, [sp, #40]
    c00043ec:	d0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c00043f0:	913bc000 	add	x0, x0, #0xef0
    c00043f4:	97fff640 	bl	c0001cf4 <mini_os_printf>
		       (unsigned long long)mpidr);
}
    c00043f8:	a8c37bfd 	ldp	x29, x30, [sp], #48
    c00043fc:	d65f03c0 	ret

00000000c0004400 <shell_handle_smp>:

static void shell_handle_smp(int argc, char *argv[])
{
    c0004400:	a9ba7bfd 	stp	x29, x30, [sp, #-96]!
    c0004404:	910003fd 	mov	x29, sp
    c0004408:	a90153f3 	stp	x19, x20, [sp, #16]
    c000440c:	a9025bf5 	stp	x21, x22, [sp, #32]
    c0004410:	b9003fe0 	str	w0, [sp, #60]
    c0004414:	f9001be1 	str	x1, [sp, #48]
	uint64_t mpidr;
	unsigned int logical_id = 0U;
    c0004418:	b90047ff 	str	wzr, [sp, #68]
	int32_t smc_ret = 0;
    c000441c:	b90043ff 	str	wzr, [sp, #64]
	int ret;
	const struct smp_cpu_state *state = (const struct smp_cpu_state *)0;
    c0004420:	f9002fff 	str	xzr, [sp, #88]

	if (argc < 2) {
    c0004424:	b9403fe0 	ldr	w0, [sp, #60]
    c0004428:	7100041f 	cmp	w0, #0x1
    c000442c:	540000ac 	b.gt	c0004440 <shell_handle_smp+0x40>
		mini_os_printf("usage: smp status | smp start <mpidr>\n");
    c0004430:	d0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0004434:	913d8000 	add	x0, x0, #0xf60
    c0004438:	97fff62f 	bl	c0001cf4 <mini_os_printf>
		return;
    c000443c:	140000bc 	b	c000472c <shell_handle_smp+0x32c>
	}

	if (strings_equal(argv[1], "status")) {
    c0004440:	f9401be0 	ldr	x0, [sp, #48]
    c0004444:	91002000 	add	x0, x0, #0x8
    c0004448:	f9400002 	ldr	x2, [x0]
    c000444c:	d0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0004450:	913e2001 	add	x1, x0, #0xf88
    c0004454:	aa0203e0 	mov	x0, x2
    c0004458:	97fffc2c 	bl	c0003508 <strings_equal>
    c000445c:	12001c00 	and	w0, w0, #0xff
    c0004460:	12000000 	and	w0, w0, #0x1
    c0004464:	7100001f 	cmp	w0, #0x0
    c0004468:	54000060 	b.eq	c0004474 <shell_handle_smp+0x74>  // b.none
		shell_print_cpus();
    c000446c:	97ffff35 	bl	c0004140 <shell_print_cpus>
		return;
    c0004470:	140000af 	b	c000472c <shell_handle_smp+0x32c>
	}

	if (strings_equal(argv[1], "start")) {
    c0004474:	f9401be0 	ldr	x0, [sp, #48]
    c0004478:	91002000 	add	x0, x0, #0x8
    c000447c:	f9400002 	ldr	x2, [x0]
    c0004480:	d0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0004484:	913e4001 	add	x1, x0, #0xf90
    c0004488:	aa0203e0 	mov	x0, x2
    c000448c:	97fffc1f 	bl	c0003508 <strings_equal>
    c0004490:	12001c00 	and	w0, w0, #0xff
    c0004494:	12000000 	and	w0, w0, #0x1
    c0004498:	7100001f 	cmp	w0, #0x0
    c000449c:	540013a0 	b.eq	c0004710 <shell_handle_smp+0x310>  // b.none
		if (argc < 3) {
    c00044a0:	b9403fe0 	ldr	w0, [sp, #60]
    c00044a4:	7100081f 	cmp	w0, #0x2
    c00044a8:	540000ac 	b.gt	c00044bc <shell_handle_smp+0xbc>
			mini_os_printf("usage: smp start <mpidr>\n");
    c00044ac:	d0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c00044b0:	913e6000 	add	x0, x0, #0xf98
    c00044b4:	97fff610 	bl	c0001cf4 <mini_os_printf>
			return;
    c00044b8:	1400009d 	b	c000472c <shell_handle_smp+0x32c>
		}
		if (!parse_u64(argv[2], &mpidr)) {
    c00044bc:	f9401be0 	ldr	x0, [sp, #48]
    c00044c0:	91004000 	add	x0, x0, #0x10
    c00044c4:	f9400000 	ldr	x0, [x0]
    c00044c8:	910123e1 	add	x1, sp, #0x48
    c00044cc:	97fffc52 	bl	c0003614 <parse_u64>
    c00044d0:	12001c00 	and	w0, w0, #0xff
    c00044d4:	52000000 	eor	w0, w0, #0x1
    c00044d8:	12001c00 	and	w0, w0, #0xff
    c00044dc:	12000000 	and	w0, w0, #0x1
    c00044e0:	7100001f 	cmp	w0, #0x0
    c00044e4:	54000120 	b.eq	c0004508 <shell_handle_smp+0x108>  // b.none
			mini_os_printf("error: invalid mpidr '%s'\n", argv[2]);
    c00044e8:	f9401be0 	ldr	x0, [sp, #48]
    c00044ec:	91004000 	add	x0, x0, #0x10
    c00044f0:	f9400000 	ldr	x0, [x0]
    c00044f4:	aa0003e1 	mov	x1, x0
    c00044f8:	d0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c00044fc:	913ee000 	add	x0, x0, #0xfb8
    c0004500:	97fff5fd 	bl	c0001cf4 <mini_os_printf>
			return;
    c0004504:	1400008a 	b	c000472c <shell_handle_smp+0x32c>
		}

		ret = smp_start_cpu(mpidr, &logical_id, &smc_ret);
    c0004508:	f94027e0 	ldr	x0, [sp, #72]
    c000450c:	910103e2 	add	x2, sp, #0x40
    c0004510:	910113e1 	add	x1, sp, #0x44
    c0004514:	940002ff 	bl	c0005110 <smp_start_cpu>
    c0004518:	b90057e0 	str	w0, [sp, #84]
		state = smp_cpu_state(logical_id);
    c000451c:	b94047e0 	ldr	w0, [sp, #68]
    c0004520:	94000427 	bl	c00055bc <smp_cpu_state>
    c0004524:	f9002fe0 	str	x0, [sp, #88]

		mini_os_printf("TF-A cpu_on(mpidr=0x%llx, entry=0x%llx, ctx=cpu%u) -> smc=%d (%s)\n",
    c0004528:	f94027f3 	ldr	x19, [sp, #72]
			       (unsigned long long)mpidr,
			       (unsigned long long)smp_secondary_entrypoint(),
    c000452c:	94000492 	bl	c0005774 <smp_secondary_entrypoint>
    c0004530:	aa0003f6 	mov	x22, x0
		mini_os_printf("TF-A cpu_on(mpidr=0x%llx, entry=0x%llx, ctx=cpu%u) -> smc=%d (%s)\n",
    c0004534:	b94047f4 	ldr	w20, [sp, #68]
    c0004538:	b94043f5 	ldr	w21, [sp, #64]
    c000453c:	b94057e0 	ldr	w0, [sp, #84]
    c0004540:	9400026c 	bl	c0004ef0 <smp_start_result_name>
    c0004544:	aa0003e5 	mov	x5, x0
    c0004548:	2a1503e4 	mov	w4, w21
    c000454c:	2a1403e3 	mov	w3, w20
    c0004550:	aa1603e2 	mov	x2, x22
    c0004554:	aa1303e1 	mov	x1, x19
    c0004558:	d0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c000455c:	913f6000 	add	x0, x0, #0xfd8
    c0004560:	97fff5e5 	bl	c0001cf4 <mini_os_printf>
			       logical_id,
			       smc_ret,
			       smp_start_result_name(ret));

		if (ret == SMP_START_OK) {
    c0004564:	b94057e0 	ldr	w0, [sp, #84]
    c0004568:	7100001f 	cmp	w0, #0x0
    c000456c:	54000661 	b.ne	c0004638 <shell_handle_smp+0x238>  // b.any
			mini_os_printf("cpu%u power-on confirmed: online=%s scheduled=%s pending=%s runnable=%u\n",
    c0004570:	b94047f6 	ldr	w22, [sp, #68]
    c0004574:	f9402fe0 	ldr	x0, [sp, #88]
    c0004578:	f100001f 	cmp	x0, #0x0
    c000457c:	54000120 	b.eq	c00045a0 <shell_handle_smp+0x1a0>  // b.none
				       logical_id,
				       ((state != (const struct smp_cpu_state *)0) && state->online) ? "yes" : "no",
    c0004580:	f9402fe0 	ldr	x0, [sp, #88]
    c0004584:	39404000 	ldrb	w0, [x0, #16]
    c0004588:	12000000 	and	w0, w0, #0x1
    c000458c:	7100001f 	cmp	w0, #0x0
    c0004590:	54000080 	b.eq	c00045a0 <shell_handle_smp+0x1a0>  // b.none
			mini_os_printf("cpu%u power-on confirmed: online=%s scheduled=%s pending=%s runnable=%u\n",
    c0004594:	d0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0004598:	9104c013 	add	x19, x0, #0x130
    c000459c:	14000003 	b	c00045a8 <shell_handle_smp+0x1a8>
    c00045a0:	d0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c00045a4:	9104e013 	add	x19, x0, #0x138
    c00045a8:	f9402fe0 	ldr	x0, [sp, #88]
    c00045ac:	f100001f 	cmp	x0, #0x0
    c00045b0:	54000120 	b.eq	c00045d4 <shell_handle_smp+0x1d4>  // b.none
				       ((state != (const struct smp_cpu_state *)0) && state->scheduled) ? "yes" : "no",
    c00045b4:	f9402fe0 	ldr	x0, [sp, #88]
    c00045b8:	39404400 	ldrb	w0, [x0, #17]
    c00045bc:	12000000 	and	w0, w0, #0x1
    c00045c0:	7100001f 	cmp	w0, #0x0
    c00045c4:	54000080 	b.eq	c00045d4 <shell_handle_smp+0x1d4>  // b.none
			mini_os_printf("cpu%u power-on confirmed: online=%s scheduled=%s pending=%s runnable=%u\n",
    c00045c8:	d0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c00045cc:	9104c014 	add	x20, x0, #0x130
    c00045d0:	14000003 	b	c00045dc <shell_handle_smp+0x1dc>
    c00045d4:	d0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c00045d8:	9104e014 	add	x20, x0, #0x138
    c00045dc:	f9402fe0 	ldr	x0, [sp, #88]
    c00045e0:	f100001f 	cmp	x0, #0x0
    c00045e4:	54000120 	b.eq	c0004608 <shell_handle_smp+0x208>  // b.none
				       ((state != (const struct smp_cpu_state *)0) && state->pending) ? "yes" : "no",
    c00045e8:	f9402fe0 	ldr	x0, [sp, #88]
    c00045ec:	39404800 	ldrb	w0, [x0, #18]
    c00045f0:	12000000 	and	w0, w0, #0x1
    c00045f4:	7100001f 	cmp	w0, #0x0
    c00045f8:	54000080 	b.eq	c0004608 <shell_handle_smp+0x208>  // b.none
			mini_os_printf("cpu%u power-on confirmed: online=%s scheduled=%s pending=%s runnable=%u\n",
    c00045fc:	d0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0004600:	9104c015 	add	x21, x0, #0x130
    c0004604:	14000003 	b	c0004610 <shell_handle_smp+0x210>
    c0004608:	d0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c000460c:	9104e015 	add	x21, x0, #0x138
    c0004610:	97fffb94 	bl	c0003460 <scheduler_runnable_cpu_count>
    c0004614:	2a0003e5 	mov	w5, w0
    c0004618:	aa1503e4 	mov	x4, x21
    c000461c:	aa1403e3 	mov	x3, x20
    c0004620:	aa1303e2 	mov	x2, x19
    c0004624:	2a1603e1 	mov	w1, w22
    c0004628:	f0000000 	adrp	x0, c0007000 <hex.0+0x1128>
    c000462c:	91008000 	add	x0, x0, #0x20
    c0004630:	97fff5b1 	bl	c0001cf4 <mini_os_printf>
		} else {
			mini_os_printf("cpu-on failed for mpidr=0x%llx with unexpected smc result %d\n",
				       (unsigned long long)mpidr,
				       smc_ret);
		}
		return;
    c0004634:	1400003e 	b	c000472c <shell_handle_smp+0x32c>
		} else if (ret == SMP_START_ALREADY_ONLINE) {
    c0004638:	b94057e0 	ldr	w0, [sp, #84]
    c000463c:	7100041f 	cmp	w0, #0x1
    c0004640:	540000c1 	b.ne	c0004658 <shell_handle_smp+0x258>  // b.any
			shell_print_smp_already_online(mpidr, logical_id, state);
    c0004644:	f94027e0 	ldr	x0, [sp, #72]
    c0004648:	b94047e1 	ldr	w1, [sp, #68]
    c000464c:	f9402fe2 	ldr	x2, [sp, #88]
    c0004650:	97ffff45 	bl	c0004364 <shell_print_smp_already_online>
		return;
    c0004654:	14000036 	b	c000472c <shell_handle_smp+0x32c>
		} else if (ret == SMP_START_INVALID_CPU) {
    c0004658:	b94057e0 	ldr	w0, [sp, #84]
    c000465c:	3100041f 	cmn	w0, #0x1
    c0004660:	54000121 	b.ne	c0004684 <shell_handle_smp+0x284>  // b.any
			mini_os_printf("TF-A reported invalid target or no logical slot left for mpidr=0x%llx (capacity=%u)\n",
    c0004664:	f94027f3 	ldr	x19, [sp, #72]
    c0004668:	94000504 	bl	c0005a78 <topology_cpu_capacity>
    c000466c:	2a0003e2 	mov	w2, w0
    c0004670:	aa1303e1 	mov	x1, x19
    c0004674:	f0000000 	adrp	x0, c0007000 <hex.0+0x1128>
    c0004678:	9101c000 	add	x0, x0, #0x70
    c000467c:	97fff59e 	bl	c0001cf4 <mini_os_printf>
		return;
    c0004680:	1400002b 	b	c000472c <shell_handle_smp+0x32c>
		} else if (ret == SMP_START_DENIED) {
    c0004684:	b94057e0 	ldr	w0, [sp, #84]
    c0004688:	31000c1f 	cmn	w0, #0x3
    c000468c:	540000e1 	b.ne	c00046a8 <shell_handle_smp+0x2a8>  // b.any
			mini_os_printf("TF-A denied cpu-on for mpidr=0x%llx\n",
    c0004690:	f94027e0 	ldr	x0, [sp, #72]
    c0004694:	aa0003e1 	mov	x1, x0
    c0004698:	f0000000 	adrp	x0, c0007000 <hex.0+0x1128>
    c000469c:	91032000 	add	x0, x0, #0xc8
    c00046a0:	97fff595 	bl	c0001cf4 <mini_os_printf>
		return;
    c00046a4:	14000022 	b	c000472c <shell_handle_smp+0x32c>
		} else if (ret == SMP_START_UNSUPPORTED) {
    c00046a8:	b94057e0 	ldr	w0, [sp, #84]
    c00046ac:	3100081f 	cmn	w0, #0x2
    c00046b0:	540000e1 	b.ne	c00046cc <shell_handle_smp+0x2cc>  // b.any
			mini_os_printf("TF-A/PSCI does not support cpu-on for mpidr=0x%llx\n",
    c00046b4:	f94027e0 	ldr	x0, [sp, #72]
    c00046b8:	aa0003e1 	mov	x1, x0
    c00046bc:	f0000000 	adrp	x0, c0007000 <hex.0+0x1128>
    c00046c0:	9103c000 	add	x0, x0, #0xf0
    c00046c4:	97fff58c 	bl	c0001cf4 <mini_os_printf>
		return;
    c00046c8:	14000019 	b	c000472c <shell_handle_smp+0x32c>
		} else if (ret == SMP_START_TIMEOUT) {
    c00046cc:	b94057e0 	ldr	w0, [sp, #84]
    c00046d0:	3100101f 	cmn	w0, #0x4
    c00046d4:	540000e1 	b.ne	c00046f0 <shell_handle_smp+0x2f0>  // b.any
			mini_os_printf("cpu%u did not report online before timeout; please inspect TF-A handoff or secondary entry path\n",
    c00046d8:	b94047e0 	ldr	w0, [sp, #68]
    c00046dc:	2a0003e1 	mov	w1, w0
    c00046e0:	f0000000 	adrp	x0, c0007000 <hex.0+0x1128>
    c00046e4:	9104a000 	add	x0, x0, #0x128
    c00046e8:	97fff583 	bl	c0001cf4 <mini_os_printf>
		return;
    c00046ec:	14000010 	b	c000472c <shell_handle_smp+0x32c>
			mini_os_printf("cpu-on failed for mpidr=0x%llx with unexpected smc result %d\n",
    c00046f0:	f94027e0 	ldr	x0, [sp, #72]
    c00046f4:	b94043e1 	ldr	w1, [sp, #64]
    c00046f8:	2a0103e2 	mov	w2, w1
    c00046fc:	aa0003e1 	mov	x1, x0
    c0004700:	f0000000 	adrp	x0, c0007000 <hex.0+0x1128>
    c0004704:	91064000 	add	x0, x0, #0x190
    c0004708:	97fff57b 	bl	c0001cf4 <mini_os_printf>
		return;
    c000470c:	14000008 	b	c000472c <shell_handle_smp+0x32c>
	}

	mini_os_printf("unknown smp subcommand: %s\n", argv[1]);
    c0004710:	f9401be0 	ldr	x0, [sp, #48]
    c0004714:	91002000 	add	x0, x0, #0x8
    c0004718:	f9400000 	ldr	x0, [x0]
    c000471c:	aa0003e1 	mov	x1, x0
    c0004720:	f0000000 	adrp	x0, c0007000 <hex.0+0x1128>
    c0004724:	91074000 	add	x0, x0, #0x1d0
    c0004728:	97fff573 	bl	c0001cf4 <mini_os_printf>
}
    c000472c:	a94153f3 	ldp	x19, x20, [sp, #16]
    c0004730:	a9425bf5 	ldp	x21, x22, [sp, #32]
    c0004734:	a8c67bfd 	ldp	x29, x30, [sp], #96
    c0004738:	d65f03c0 	ret

00000000c000473c <shell_execute>:

static void shell_execute(char *line)
{
    c000473c:	a9b97bfd 	stp	x29, x30, [sp, #-112]!
    c0004740:	910003fd 	mov	x29, sp
    c0004744:	f9000fe0 	str	x0, [sp, #24]
	char *argv[SHELL_MAX_ARGS];
	int argc;
	const char *topic;

	argc = shell_tokenize(line, argv, SHELL_MAX_ARGS);
    c0004748:	910083e0 	add	x0, sp, #0x20
    c000474c:	52800102 	mov	w2, #0x8                   	// #8
    c0004750:	aa0003e1 	mov	x1, x0
    c0004754:	f9400fe0 	ldr	x0, [sp, #24]
    c0004758:	97fffc17 	bl	c00037b4 <shell_tokenize>
    c000475c:	b9006fe0 	str	w0, [sp, #108]
	if (argc == 0) {
    c0004760:	b9406fe0 	ldr	w0, [sp, #108]
    c0004764:	7100001f 	cmp	w0, #0x0
    c0004768:	54001380 	b.eq	c00049d8 <shell_execute+0x29c>  // b.none
		return;
	}

	if (strings_equal(argv[0], "help")) {
    c000476c:	f94013e2 	ldr	x2, [sp, #32]
    c0004770:	d0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0004774:	9111e001 	add	x1, x0, #0x478
    c0004778:	aa0203e0 	mov	x0, x2
    c000477c:	97fffb63 	bl	c0003508 <strings_equal>
    c0004780:	12001c00 	and	w0, w0, #0xff
    c0004784:	12000000 	and	w0, w0, #0x1
    c0004788:	7100001f 	cmp	w0, #0x0
    c000478c:	54000180 	b.eq	c00047bc <shell_execute+0x80>  // b.none
		if (argc >= 2) {
    c0004790:	b9406fe0 	ldr	w0, [sp, #108]
    c0004794:	7100041f 	cmp	w0, #0x1
    c0004798:	540000ed 	b.le	c00047b4 <shell_execute+0x78>
			topic = shell_help_topic_name(argv[1]);
    c000479c:	f94017e0 	ldr	x0, [sp, #40]
    c00047a0:	97fffb83 	bl	c00035ac <shell_help_topic_name>
    c00047a4:	f90033e0 	str	x0, [sp, #96]
			shell_print_help_topic(topic);
    c00047a8:	f94033e0 	ldr	x0, [sp, #96]
    c00047ac:	97fffcca 	bl	c0003ad4 <shell_print_help_topic>
    c00047b0:	1400008b 	b	c00049dc <shell_execute+0x2a0>
		} else {
			shell_print_help();
    c00047b4:	97fffde5 	bl	c0003f48 <shell_print_help>
    c00047b8:	14000089 	b	c00049dc <shell_execute+0x2a0>
		}
	} else if (strings_equal(argv[0], "version")) {
    c00047bc:	f94013e2 	ldr	x2, [sp, #32]
    c00047c0:	d0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c00047c4:	91252001 	add	x1, x0, #0x948
    c00047c8:	aa0203e0 	mov	x0, x2
    c00047cc:	97fffb4f 	bl	c0003508 <strings_equal>
    c00047d0:	12001c00 	and	w0, w0, #0xff
    c00047d4:	12000000 	and	w0, w0, #0x1
    c00047d8:	7100001f 	cmp	w0, #0x0
    c00047dc:	54000060 	b.eq	c00047e8 <shell_execute+0xac>  // b.none
		shell_print_version();
    c00047e0:	97fffde0 	bl	c0003f60 <shell_print_version>
    c00047e4:	1400007e 	b	c00049dc <shell_execute+0x2a0>
	} else if (strings_equal(argv[0], "info")) {
    c00047e8:	f94013e2 	ldr	x2, [sp, #32]
    c00047ec:	d0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c00047f0:	9122c001 	add	x1, x0, #0x8b0
    c00047f4:	aa0203e0 	mov	x0, x2
    c00047f8:	97fffb44 	bl	c0003508 <strings_equal>
    c00047fc:	12001c00 	and	w0, w0, #0xff
    c0004800:	12000000 	and	w0, w0, #0x1
    c0004804:	7100001f 	cmp	w0, #0x0
    c0004808:	54000060 	b.eq	c0004814 <shell_execute+0xd8>  // b.none
		shell_print_info();
    c000480c:	97fffde2 	bl	c0003f94 <shell_print_info>
    c0004810:	14000073 	b	c00049dc <shell_execute+0x2a0>
	} else if (strings_equal(argv[0], "cpu")) {
    c0004814:	f94013e2 	ldr	x2, [sp, #32]
    c0004818:	d0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c000481c:	91142001 	add	x1, x0, #0x508
    c0004820:	aa0203e0 	mov	x0, x2
    c0004824:	97fffb39 	bl	c0003508 <strings_equal>
    c0004828:	12001c00 	and	w0, w0, #0xff
    c000482c:	12000000 	and	w0, w0, #0x1
    c0004830:	7100001f 	cmp	w0, #0x0
    c0004834:	54000120 	b.eq	c0004858 <shell_execute+0x11c>  // b.none
		if (argc >= 2) {
    c0004838:	b9406fe0 	ldr	w0, [sp, #108]
    c000483c:	7100041f 	cmp	w0, #0x1
    c0004840:	5400008d 	b.le	c0004850 <shell_execute+0x114>
			shell_print_cpu_id(argv[1]);
    c0004844:	f94017e0 	ldr	x0, [sp, #40]
    c0004848:	97fffe15 	bl	c000409c <shell_print_cpu_id>
    c000484c:	14000064 	b	c00049dc <shell_execute+0x2a0>
		} else {
			shell_print_current_cpu();
    c0004850:	97fffe0c 	bl	c0004080 <shell_print_current_cpu>
    c0004854:	14000062 	b	c00049dc <shell_execute+0x2a0>
		}
	} else if (strings_equal(argv[0], "cpus")) {
    c0004858:	f94013e2 	ldr	x2, [sp, #32]
    c000485c:	d0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0004860:	91172001 	add	x1, x0, #0x5c8
    c0004864:	aa0203e0 	mov	x0, x2
    c0004868:	97fffb28 	bl	c0003508 <strings_equal>
    c000486c:	12001c00 	and	w0, w0, #0xff
    c0004870:	12000000 	and	w0, w0, #0x1
    c0004874:	7100001f 	cmp	w0, #0x0
    c0004878:	54000060 	b.eq	c0004884 <shell_execute+0x148>  // b.none
		shell_print_cpus();
    c000487c:	97fffe31 	bl	c0004140 <shell_print_cpus>
    c0004880:	14000057 	b	c00049dc <shell_execute+0x2a0>
	} else if (strings_equal(argv[0], "topo")) {
    c0004884:	f94013e2 	ldr	x2, [sp, #32]
    c0004888:	d0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c000488c:	911a6001 	add	x1, x0, #0x698
    c0004890:	aa0203e0 	mov	x0, x2
    c0004894:	97fffb1d 	bl	c0003508 <strings_equal>
    c0004898:	12001c00 	and	w0, w0, #0xff
    c000489c:	12000000 	and	w0, w0, #0x1
    c00048a0:	7100001f 	cmp	w0, #0x0
    c00048a4:	54000060 	b.eq	c00048b0 <shell_execute+0x174>  // b.none
		shell_print_topology_summary();
    c00048a8:	97fffe4f 	bl	c00041e4 <shell_print_topology_summary>
    c00048ac:	1400004c 	b	c00049dc <shell_execute+0x2a0>
	} else if (strings_equal(argv[0], "smp")) {
    c00048b0:	f94013e2 	ldr	x2, [sp, #32]
    c00048b4:	d0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c00048b8:	911d6001 	add	x1, x0, #0x758
    c00048bc:	aa0203e0 	mov	x0, x2
    c00048c0:	97fffb12 	bl	c0003508 <strings_equal>
    c00048c4:	12001c00 	and	w0, w0, #0xff
    c00048c8:	12000000 	and	w0, w0, #0x1
    c00048cc:	7100001f 	cmp	w0, #0x0
    c00048d0:	540000c0 	b.eq	c00048e8 <shell_execute+0x1ac>  // b.none
		shell_handle_smp(argc, argv);
    c00048d4:	910083e0 	add	x0, sp, #0x20
    c00048d8:	aa0003e1 	mov	x1, x0
    c00048dc:	b9406fe0 	ldr	w0, [sp, #108]
    c00048e0:	97fffec8 	bl	c0004400 <shell_handle_smp>
    c00048e4:	1400003e 	b	c00049dc <shell_execute+0x2a0>
	} else if (strings_equal(argv[0], "echo")) {
    c00048e8:	f94013e2 	ldr	x2, [sp, #32]
    c00048ec:	d0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c00048f0:	9126c001 	add	x1, x0, #0x9b0
    c00048f4:	aa0203e0 	mov	x0, x2
    c00048f8:	97fffb04 	bl	c0003508 <strings_equal>
    c00048fc:	12001c00 	and	w0, w0, #0xff
    c0004900:	12000000 	and	w0, w0, #0x1
    c0004904:	7100001f 	cmp	w0, #0x0
    c0004908:	540000c0 	b.eq	c0004920 <shell_execute+0x1e4>  // b.none
		shell_echo_args(argc, argv);
    c000490c:	910083e0 	add	x0, sp, #0x20
    c0004910:	aa0003e1 	mov	x1, x0
    c0004914:	b9406fe0 	ldr	w0, [sp, #108]
    c0004918:	97fffe5f 	bl	c0004294 <shell_echo_args>
    c000491c:	14000030 	b	c00049dc <shell_execute+0x2a0>
	} else if (strings_equal(argv[0], "clear")) {
    c0004920:	f94013e2 	ldr	x2, [sp, #32]
    c0004924:	d0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0004928:	91288001 	add	x1, x0, #0xa20
    c000492c:	aa0203e0 	mov	x0, x2
    c0004930:	97fffaf6 	bl	c0003508 <strings_equal>
    c0004934:	12001c00 	and	w0, w0, #0xff
    c0004938:	12000000 	and	w0, w0, #0x1
    c000493c:	7100001f 	cmp	w0, #0x0
    c0004940:	54000060 	b.eq	c000494c <shell_execute+0x210>  // b.none
		shell_clear_screen();
    c0004944:	97fffe79 	bl	c0004328 <shell_clear_screen>
    c0004948:	14000025 	b	c00049dc <shell_execute+0x2a0>
	} else if (strings_equal(argv[0], "uname")) {
    c000494c:	f94013e2 	ldr	x2, [sp, #32]
    c0004950:	d0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0004954:	912aa001 	add	x1, x0, #0xaa8
    c0004958:	aa0203e0 	mov	x0, x2
    c000495c:	97fffaeb 	bl	c0003508 <strings_equal>
    c0004960:	12001c00 	and	w0, w0, #0xff
    c0004964:	12000000 	and	w0, w0, #0x1
    c0004968:	7100001f 	cmp	w0, #0x0
    c000496c:	540000e0 	b.eq	c0004988 <shell_execute+0x24c>  // b.none
		mini_os_printf("%s\n", MINI_OS_NAME);
    c0004970:	d0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0004974:	912ee001 	add	x1, x0, #0xbb8
    c0004978:	f0000000 	adrp	x0, c0007000 <hex.0+0x1128>
    c000497c:	9107c000 	add	x0, x0, #0x1f0
    c0004980:	97fff4dd 	bl	c0001cf4 <mini_os_printf>
    c0004984:	14000016 	b	c00049dc <shell_execute+0x2a0>
	} else if (strings_equal(argv[0], "halt")) {
    c0004988:	f94013e2 	ldr	x2, [sp, #32]
    c000498c:	d0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0004990:	912ba001 	add	x1, x0, #0xae8
    c0004994:	aa0203e0 	mov	x0, x2
    c0004998:	97fffadc 	bl	c0003508 <strings_equal>
    c000499c:	12001c00 	and	w0, w0, #0xff
    c00049a0:	12000000 	and	w0, w0, #0x1
    c00049a4:	7100001f 	cmp	w0, #0x0
    c00049a8:	54000060 	b.eq	c00049b4 <shell_execute+0x278>  // b.none
		shell_halt();
    c00049ac:	97fffe67 	bl	c0004348 <shell_halt>
    c00049b0:	1400000b 	b	c00049dc <shell_execute+0x2a0>
	} else {
		mini_os_printf("Unknown command: %s\n", argv[0]);
    c00049b4:	f94013e0 	ldr	x0, [sp, #32]
    c00049b8:	aa0003e1 	mov	x1, x0
    c00049bc:	f0000000 	adrp	x0, c0007000 <hex.0+0x1128>
    c00049c0:	9107e000 	add	x0, x0, #0x1f8
    c00049c4:	97fff4cc 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("Type 'help' to list supported commands.\n");
    c00049c8:	f0000000 	adrp	x0, c0007000 <hex.0+0x1128>
    c00049cc:	91084000 	add	x0, x0, #0x210
    c00049d0:	97fff4c9 	bl	c0001cf4 <mini_os_printf>
    c00049d4:	14000002 	b	c00049dc <shell_execute+0x2a0>
		return;
    c00049d8:	d503201f 	nop
	}
}
    c00049dc:	a8c77bfd 	ldp	x29, x30, [sp], #112
    c00049e0:	d65f03c0 	ret

00000000c00049e4 <shell_prompt>:

static void shell_prompt(void)
{
    c00049e4:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    c00049e8:	910003fd 	mov	x29, sp
	mini_os_printf("%s", SHELL_PROMPT);
    c00049ec:	f0000000 	adrp	x0, c0007000 <hex.0+0x1128>
    c00049f0:	91090001 	add	x1, x0, #0x240
    c00049f4:	d0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c00049f8:	9137c000 	add	x0, x0, #0xdf0
    c00049fc:	97fff4be 	bl	c0001cf4 <mini_os_printf>
}
    c0004a00:	d503201f 	nop
    c0004a04:	a8c17bfd 	ldp	x29, x30, [sp], #16
    c0004a08:	d65f03c0 	ret

00000000c0004a0c <shell_run>:

void shell_run(void)
{
    c0004a0c:	a9b67bfd 	stp	x29, x30, [sp, #-160]!
    c0004a10:	910003fd 	mov	x29, sp
	char line[SHELL_MAX_LINE];
	size_t len = 0U;
    c0004a14:	f9004fff 	str	xzr, [sp, #152]

	shell_prompt();
    c0004a18:	97fffff3 	bl	c00049e4 <shell_prompt>
	for (;;) {
		int ch = debug_getc();
    c0004a1c:	97fff50e 	bl	c0001e54 <debug_getc>
    c0004a20:	b90097e0 	str	w0, [sp, #148]

		if ((ch == '\r') || (ch == '\n')) {
    c0004a24:	b94097e0 	ldr	w0, [sp, #148]
    c0004a28:	7100341f 	cmp	w0, #0xd
    c0004a2c:	54000080 	b.eq	c0004a3c <shell_run+0x30>  // b.none
    c0004a30:	b94097e0 	ldr	w0, [sp, #148]
    c0004a34:	7100281f 	cmp	w0, #0xa
    c0004a38:	54000181 	b.ne	c0004a68 <shell_run+0x5c>  // b.any
			mini_os_printf("\n");
    c0004a3c:	d0000000 	adrp	x0, c0006000 <hex.0+0x128>
    c0004a40:	91380000 	add	x0, x0, #0xe00
    c0004a44:	97fff4ac 	bl	c0001cf4 <mini_os_printf>
			line[len] = '\0';
    c0004a48:	f9404fe0 	ldr	x0, [sp, #152]
    c0004a4c:	910043e1 	add	x1, sp, #0x10
    c0004a50:	3820683f 	strb	wzr, [x1, x0]
			shell_execute(line);
    c0004a54:	910043e0 	add	x0, sp, #0x10
    c0004a58:	97ffff39 	bl	c000473c <shell_execute>
			len = 0U;
    c0004a5c:	f9004fff 	str	xzr, [sp, #152]
			shell_prompt();
    c0004a60:	97ffffe1 	bl	c00049e4 <shell_prompt>
			continue;
    c0004a64:	14000034 	b	c0004b34 <shell_run+0x128>
		}

		if ((ch == '\b') || (ch == 127)) {
    c0004a68:	b94097e0 	ldr	w0, [sp, #148]
    c0004a6c:	7100201f 	cmp	w0, #0x8
    c0004a70:	54000080 	b.eq	c0004a80 <shell_run+0x74>  // b.none
    c0004a74:	b94097e0 	ldr	w0, [sp, #148]
    c0004a78:	7101fc1f 	cmp	w0, #0x7f
    c0004a7c:	54000161 	b.ne	c0004aa8 <shell_run+0x9c>  // b.any
			if (len > 0U) {
    c0004a80:	f9404fe0 	ldr	x0, [sp, #152]
    c0004a84:	f100001f 	cmp	x0, #0x0
    c0004a88:	540004c0 	b.eq	c0004b20 <shell_run+0x114>  // b.none
				len--;
    c0004a8c:	f9404fe0 	ldr	x0, [sp, #152]
    c0004a90:	d1000400 	sub	x0, x0, #0x1
    c0004a94:	f9004fe0 	str	x0, [sp, #152]
				mini_os_printf("\b \b");
    c0004a98:	f0000000 	adrp	x0, c0007000 <hex.0+0x1128>
    c0004a9c:	91094000 	add	x0, x0, #0x250
    c0004aa0:	97fff495 	bl	c0001cf4 <mini_os_printf>
			}
			continue;
    c0004aa4:	1400001f 	b	c0004b20 <shell_run+0x114>
		}

		if (ch == '\t') {
    c0004aa8:	b94097e0 	ldr	w0, [sp, #148]
    c0004aac:	7100241f 	cmp	w0, #0x9
    c0004ab0:	540003c0 	b.eq	c0004b28 <shell_run+0x11c>  // b.none
			continue;
		}

		if ((ch < 32) || (ch > 126)) {
    c0004ab4:	b94097e0 	ldr	w0, [sp, #148]
    c0004ab8:	71007c1f 	cmp	w0, #0x1f
    c0004abc:	540003ad 	b.le	c0004b30 <shell_run+0x124>
    c0004ac0:	b94097e0 	ldr	w0, [sp, #148]
    c0004ac4:	7101f81f 	cmp	w0, #0x7e
    c0004ac8:	5400034c 	b.gt	c0004b30 <shell_run+0x124>
			continue;
		}

		if (len + 1U >= SHELL_MAX_LINE) {
    c0004acc:	f9404fe0 	ldr	x0, [sp, #152]
    c0004ad0:	91000400 	add	x0, x0, #0x1
    c0004ad4:	f101fc1f 	cmp	x0, #0x7f
    c0004ad8:	54000109 	b.ls	c0004af8 <shell_run+0xec>  // b.plast
			mini_os_printf("\nerror: command too long (max %d chars)\n",
    c0004adc:	52800fe1 	mov	w1, #0x7f                  	// #127
    c0004ae0:	f0000000 	adrp	x0, c0007000 <hex.0+0x1128>
    c0004ae4:	91096000 	add	x0, x0, #0x258
    c0004ae8:	97fff483 	bl	c0001cf4 <mini_os_printf>
				       SHELL_MAX_LINE - 1);
			len = 0U;
    c0004aec:	f9004fff 	str	xzr, [sp, #152]
			shell_prompt();
    c0004af0:	97ffffbd 	bl	c00049e4 <shell_prompt>
			continue;
    c0004af4:	14000010 	b	c0004b34 <shell_run+0x128>
		}

		line[len++] = (char)ch;
    c0004af8:	f9404fe0 	ldr	x0, [sp, #152]
    c0004afc:	91000401 	add	x1, x0, #0x1
    c0004b00:	f9004fe1 	str	x1, [sp, #152]
    c0004b04:	b94097e1 	ldr	w1, [sp, #148]
    c0004b08:	12001c22 	and	w2, w1, #0xff
    c0004b0c:	910043e1 	add	x1, sp, #0x10
    c0004b10:	38206822 	strb	w2, [x1, x0]
		debug_putc(ch);
    c0004b14:	b94097e0 	ldr	w0, [sp, #148]
    c0004b18:	97fff4a3 	bl	c0001da4 <debug_putc>
    c0004b1c:	17ffffc0 	b	c0004a1c <shell_run+0x10>
			continue;
    c0004b20:	d503201f 	nop
    c0004b24:	17ffffbe 	b	c0004a1c <shell_run+0x10>
			continue;
    c0004b28:	d503201f 	nop
    c0004b2c:	17ffffbc 	b	c0004a1c <shell_run+0x10>
			continue;
    c0004b30:	d503201f 	nop
	for (;;) {
    c0004b34:	17ffffba 	b	c0004a1c <shell_run+0x10>

00000000c0004b38 <smp_read_cntfrq>:
unsigned char secondary_stacks[PLAT_MAX_CPUS][PLAT_STACK_SIZE] __attribute__((aligned(16)));

extern void secondary_cpu_entrypoint(void);

static inline uint64_t smp_read_cntfrq(void)
{
    c0004b38:	d10043ff 	sub	sp, sp, #0x10
	uint64_t value;

	__asm__ volatile ("mrs %0, cntfrq_el0" : "=r" (value));
    c0004b3c:	d53be000 	mrs	x0, cntfrq_el0
    c0004b40:	f90007e0 	str	x0, [sp, #8]
	return value;
    c0004b44:	f94007e0 	ldr	x0, [sp, #8]
}
    c0004b48:	910043ff 	add	sp, sp, #0x10
    c0004b4c:	d65f03c0 	ret

00000000c0004b50 <smp_read_cntpct>:

static inline uint64_t smp_read_cntpct(void)
{
    c0004b50:	d10043ff 	sub	sp, sp, #0x10
	uint64_t value;

	__asm__ volatile ("mrs %0, cntpct_el0" : "=r" (value));
    c0004b54:	d53be020 	mrs	x0, cntpct_el0
    c0004b58:	f90007e0 	str	x0, [sp, #8]
	return value;
    c0004b5c:	f94007e0 	ldr	x0, [sp, #8]
}
    c0004b60:	910043ff 	add	sp, sp, #0x10
    c0004b64:	d65f03c0 	ret

00000000c0004b68 <smp_relax>:

static inline void smp_relax(void)
{
	__asm__ volatile ("nop");
    c0004b68:	d503201f 	nop
}
    c0004b6c:	d503201f 	nop
    c0004b70:	d65f03c0 	ret

00000000c0004b74 <smp_smc_call>:

static int32_t smp_smc_call(uint64_t x0, uint64_t x1, uint64_t x2, uint64_t x3)
{
    c0004b74:	d10083ff 	sub	sp, sp, #0x20
    c0004b78:	f9000fe0 	str	x0, [sp, #24]
    c0004b7c:	f9000be1 	str	x1, [sp, #16]
    c0004b80:	f90007e2 	str	x2, [sp, #8]
    c0004b84:	f90003e3 	str	x3, [sp]
	register uint64_t r0 __asm__("x0") = x0;
    c0004b88:	f9400fe0 	ldr	x0, [sp, #24]
	register uint64_t r1 __asm__("x1") = x1;
    c0004b8c:	f9400be1 	ldr	x1, [sp, #16]
	register uint64_t r2 __asm__("x2") = x2;
    c0004b90:	f94007e2 	ldr	x2, [sp, #8]
	register uint64_t r3 __asm__("x3") = x3;
    c0004b94:	f94003e3 	ldr	x3, [sp]

	__asm__ volatile ("smc #0"
    c0004b98:	d4000003 	smc	#0x0
		: "r" (r1), "r" (r2), "r" (r3)
		: "x4", "x5", "x6", "x7", "x8", "x9", "x10", "x11", "x12",
		  "x13", "x14", "x15", "x16", "x17", "memory");

	return (int32_t)r0;
}
    c0004b9c:	910083ff 	add	sp, sp, #0x20
    c0004ba0:	d65f03c0 	ret

00000000c0004ba4 <smp_find_free_logical_slot>:

static int smp_find_free_logical_slot(void)
{
    c0004ba4:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c0004ba8:	910003fd 	mov	x29, sp
	unsigned int i;

	for (i = 0U; i < PLAT_MAX_CPUS; ++i) {
    c0004bac:	b9001fff 	str	wzr, [sp, #28]
    c0004bb0:	1400000e 	b	c0004be8 <smp_find_free_logical_slot+0x44>
		if (!topology_cpu(i)->present) {
    c0004bb4:	b9401fe0 	ldr	w0, [sp, #28]
    c0004bb8:	9400037d 	bl	c00059ac <topology_cpu>
    c0004bbc:	39407400 	ldrb	w0, [x0, #29]
    c0004bc0:	52000000 	eor	w0, w0, #0x1
    c0004bc4:	12001c00 	and	w0, w0, #0xff
    c0004bc8:	12000000 	and	w0, w0, #0x1
    c0004bcc:	7100001f 	cmp	w0, #0x0
    c0004bd0:	54000060 	b.eq	c0004bdc <smp_find_free_logical_slot+0x38>  // b.none
			return (int)i;
    c0004bd4:	b9401fe0 	ldr	w0, [sp, #28]
    c0004bd8:	14000008 	b	c0004bf8 <smp_find_free_logical_slot+0x54>
	for (i = 0U; i < PLAT_MAX_CPUS; ++i) {
    c0004bdc:	b9401fe0 	ldr	w0, [sp, #28]
    c0004be0:	11000400 	add	w0, w0, #0x1
    c0004be4:	b9001fe0 	str	w0, [sp, #28]
    c0004be8:	b9401fe0 	ldr	w0, [sp, #28]
    c0004bec:	71001c1f 	cmp	w0, #0x7
    c0004bf0:	54fffe29 	b.ls	c0004bb4 <smp_find_free_logical_slot+0x10>  // b.plast
		}
	}

	return -1;
    c0004bf4:	12800000 	mov	w0, #0xffffffff            	// #-1
}
    c0004bf8:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c0004bfc:	d65f03c0 	ret

00000000c0004c00 <smp_reset_cpu_state>:

static void smp_reset_cpu_state(unsigned int logical_id)
{
    c0004c00:	d10043ff 	sub	sp, sp, #0x10
    c0004c04:	b9000fe0 	str	w0, [sp, #12]
	if (logical_id >= PLAT_MAX_CPUS) {
    c0004c08:	b9400fe0 	ldr	w0, [sp, #12]
    c0004c0c:	71001c1f 	cmp	w0, #0x7
    c0004c10:	54000728 	b.hi	c0004cf4 <smp_reset_cpu_state+0xf4>  // b.pmore
		return;
	}

	cpu_states[logical_id].logical_id = logical_id;
    c0004c14:	f0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0004c18:	91104002 	add	x2, x0, #0x410
    c0004c1c:	b9400fe1 	ldr	w1, [sp, #12]
    c0004c20:	aa0103e0 	mov	x0, x1
    c0004c24:	d37ff800 	lsl	x0, x0, #1
    c0004c28:	8b010000 	add	x0, x0, x1
    c0004c2c:	d37df000 	lsl	x0, x0, #3
    c0004c30:	8b000040 	add	x0, x2, x0
    c0004c34:	b9400fe1 	ldr	w1, [sp, #12]
    c0004c38:	b9000001 	str	w1, [x0]
	cpu_states[logical_id].mpidr = 0U;
    c0004c3c:	f0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0004c40:	91104002 	add	x2, x0, #0x410
    c0004c44:	b9400fe1 	ldr	w1, [sp, #12]
    c0004c48:	aa0103e0 	mov	x0, x1
    c0004c4c:	d37ff800 	lsl	x0, x0, #1
    c0004c50:	8b010000 	add	x0, x0, x1
    c0004c54:	d37df000 	lsl	x0, x0, #3
    c0004c58:	8b000040 	add	x0, x2, x0
    c0004c5c:	f900041f 	str	xzr, [x0, #8]
	cpu_states[logical_id].online = false;
    c0004c60:	f0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0004c64:	91104002 	add	x2, x0, #0x410
    c0004c68:	b9400fe1 	ldr	w1, [sp, #12]
    c0004c6c:	aa0103e0 	mov	x0, x1
    c0004c70:	d37ff800 	lsl	x0, x0, #1
    c0004c74:	8b010000 	add	x0, x0, x1
    c0004c78:	d37df000 	lsl	x0, x0, #3
    c0004c7c:	8b000040 	add	x0, x2, x0
    c0004c80:	3900401f 	strb	wzr, [x0, #16]
	cpu_states[logical_id].scheduled = false;
    c0004c84:	f0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0004c88:	91104002 	add	x2, x0, #0x410
    c0004c8c:	b9400fe1 	ldr	w1, [sp, #12]
    c0004c90:	aa0103e0 	mov	x0, x1
    c0004c94:	d37ff800 	lsl	x0, x0, #1
    c0004c98:	8b010000 	add	x0, x0, x1
    c0004c9c:	d37df000 	lsl	x0, x0, #3
    c0004ca0:	8b000040 	add	x0, x2, x0
    c0004ca4:	3900441f 	strb	wzr, [x0, #17]
	cpu_states[logical_id].pending = false;
    c0004ca8:	f0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0004cac:	91104002 	add	x2, x0, #0x410
    c0004cb0:	b9400fe1 	ldr	w1, [sp, #12]
    c0004cb4:	aa0103e0 	mov	x0, x1
    c0004cb8:	d37ff800 	lsl	x0, x0, #1
    c0004cbc:	8b010000 	add	x0, x0, x1
    c0004cc0:	d37df000 	lsl	x0, x0, #3
    c0004cc4:	8b000040 	add	x0, x2, x0
    c0004cc8:	3900481f 	strb	wzr, [x0, #18]
	cpu_states[logical_id].boot_cpu = false;
    c0004ccc:	f0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0004cd0:	91104002 	add	x2, x0, #0x410
    c0004cd4:	b9400fe1 	ldr	w1, [sp, #12]
    c0004cd8:	aa0103e0 	mov	x0, x1
    c0004cdc:	d37ff800 	lsl	x0, x0, #1
    c0004ce0:	8b010000 	add	x0, x0, x1
    c0004ce4:	d37df000 	lsl	x0, x0, #3
    c0004ce8:	8b000040 	add	x0, x2, x0
    c0004cec:	39004c1f 	strb	wzr, [x0, #19]
    c0004cf0:	14000002 	b	c0004cf8 <smp_reset_cpu_state+0xf8>
		return;
    c0004cf4:	d503201f 	nop
}
    c0004cf8:	910043ff 	add	sp, sp, #0x10
    c0004cfc:	d65f03c0 	ret

00000000c0004d00 <smp_wait_for_online>:

static bool smp_wait_for_online(unsigned int logical_id, uint32_t timeout_us)
{
    c0004d00:	a9bc7bfd 	stp	x29, x30, [sp, #-64]!
    c0004d04:	910003fd 	mov	x29, sp
    c0004d08:	b9001fe0 	str	w0, [sp, #28]
    c0004d0c:	b9001be1 	str	w1, [sp, #24]
	uint64_t freq;
	uint64_t start;
	uint64_t ticks;

	if (logical_id >= PLAT_MAX_CPUS) {
    c0004d10:	b9401fe0 	ldr	w0, [sp, #28]
    c0004d14:	71001c1f 	cmp	w0, #0x7
    c0004d18:	54000069 	b.ls	c0004d24 <smp_wait_for_online+0x24>  // b.plast
		return false;
    c0004d1c:	52800000 	mov	w0, #0x0                   	// #0
    c0004d20:	14000054 	b	c0004e70 <smp_wait_for_online+0x170>
	}

	if (cpu_states[logical_id].online) {
    c0004d24:	f0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0004d28:	91104002 	add	x2, x0, #0x410
    c0004d2c:	b9401fe1 	ldr	w1, [sp, #28]
    c0004d30:	aa0103e0 	mov	x0, x1
    c0004d34:	d37ff800 	lsl	x0, x0, #1
    c0004d38:	8b010000 	add	x0, x0, x1
    c0004d3c:	d37df000 	lsl	x0, x0, #3
    c0004d40:	8b000040 	add	x0, x2, x0
    c0004d44:	39404000 	ldrb	w0, [x0, #16]
    c0004d48:	12000000 	and	w0, w0, #0x1
    c0004d4c:	7100001f 	cmp	w0, #0x0
    c0004d50:	54000060 	b.eq	c0004d5c <smp_wait_for_online+0x5c>  // b.none
		return true;
    c0004d54:	52800020 	mov	w0, #0x1                   	// #1
    c0004d58:	14000046 	b	c0004e70 <smp_wait_for_online+0x170>
	}

	freq = smp_read_cntfrq();
    c0004d5c:	97ffff77 	bl	c0004b38 <smp_read_cntfrq>
    c0004d60:	f9001be0 	str	x0, [sp, #48]
	if (freq == 0U) {
    c0004d64:	f9401be0 	ldr	x0, [sp, #48]
    c0004d68:	f100001f 	cmp	x0, #0x0
    c0004d6c:	54000161 	b.ne	c0004d98 <smp_wait_for_online+0x98>  // b.any
		return cpu_states[logical_id].online;
    c0004d70:	f0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0004d74:	91104002 	add	x2, x0, #0x410
    c0004d78:	b9401fe1 	ldr	w1, [sp, #28]
    c0004d7c:	aa0103e0 	mov	x0, x1
    c0004d80:	d37ff800 	lsl	x0, x0, #1
    c0004d84:	8b010000 	add	x0, x0, x1
    c0004d88:	d37df000 	lsl	x0, x0, #3
    c0004d8c:	8b000040 	add	x0, x2, x0
    c0004d90:	39404000 	ldrb	w0, [x0, #16]
    c0004d94:	14000037 	b	c0004e70 <smp_wait_for_online+0x170>
	}

	ticks = ((uint64_t)freq * timeout_us + 999999ULL) / 1000000ULL;
    c0004d98:	b9401be1 	ldr	w1, [sp, #24]
    c0004d9c:	f9401be0 	ldr	x0, [sp, #48]
    c0004da0:	9b007c21 	mul	x1, x1, x0
    c0004da4:	d28847e0 	mov	x0, #0x423f                	// #16959
    c0004da8:	f2a001e0 	movk	x0, #0xf, lsl #16
    c0004dac:	8b000021 	add	x1, x1, x0
    c0004db0:	d2869b60 	mov	x0, #0x34db                	// #13531
    c0004db4:	f2baf6c0 	movk	x0, #0xd7b6, lsl #16
    c0004db8:	f2dbd040 	movk	x0, #0xde82, lsl #32
    c0004dbc:	f2e86360 	movk	x0, #0x431b, lsl #48
    c0004dc0:	9bc07c20 	umulh	x0, x1, x0
    c0004dc4:	d352fc00 	lsr	x0, x0, #18
    c0004dc8:	f9001fe0 	str	x0, [sp, #56]
	if (ticks == 0U) {
    c0004dcc:	f9401fe0 	ldr	x0, [sp, #56]
    c0004dd0:	f100001f 	cmp	x0, #0x0
    c0004dd4:	54000061 	b.ne	c0004de0 <smp_wait_for_online+0xe0>  // b.any
		ticks = 1U;
    c0004dd8:	d2800020 	mov	x0, #0x1                   	// #1
    c0004ddc:	f9001fe0 	str	x0, [sp, #56]
	}

	start = smp_read_cntpct();
    c0004de0:	97ffff5c 	bl	c0004b50 <smp_read_cntpct>
    c0004de4:	f90017e0 	str	x0, [sp, #40]
	while (!cpu_states[logical_id].online) {
    c0004de8:	14000009 	b	c0004e0c <smp_wait_for_online+0x10c>
		if ((smp_read_cntpct() - start) >= ticks) {
    c0004dec:	97ffff59 	bl	c0004b50 <smp_read_cntpct>
    c0004df0:	aa0003e1 	mov	x1, x0
    c0004df4:	f94017e0 	ldr	x0, [sp, #40]
    c0004df8:	cb000020 	sub	x0, x1, x0
    c0004dfc:	f9401fe1 	ldr	x1, [sp, #56]
    c0004e00:	eb00003f 	cmp	x1, x0
    c0004e04:	54000229 	b.ls	c0004e48 <smp_wait_for_online+0x148>  // b.plast
			break;
		}
		smp_relax();
    c0004e08:	97ffff58 	bl	c0004b68 <smp_relax>
	while (!cpu_states[logical_id].online) {
    c0004e0c:	f0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0004e10:	91104002 	add	x2, x0, #0x410
    c0004e14:	b9401fe1 	ldr	w1, [sp, #28]
    c0004e18:	aa0103e0 	mov	x0, x1
    c0004e1c:	d37ff800 	lsl	x0, x0, #1
    c0004e20:	8b010000 	add	x0, x0, x1
    c0004e24:	d37df000 	lsl	x0, x0, #3
    c0004e28:	8b000040 	add	x0, x2, x0
    c0004e2c:	39404000 	ldrb	w0, [x0, #16]
    c0004e30:	52000000 	eor	w0, w0, #0x1
    c0004e34:	12001c00 	and	w0, w0, #0xff
    c0004e38:	12000000 	and	w0, w0, #0x1
    c0004e3c:	7100001f 	cmp	w0, #0x0
    c0004e40:	54fffd61 	b.ne	c0004dec <smp_wait_for_online+0xec>  // b.any
    c0004e44:	14000002 	b	c0004e4c <smp_wait_for_online+0x14c>
			break;
    c0004e48:	d503201f 	nop
	}

	return cpu_states[logical_id].online;
    c0004e4c:	f0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0004e50:	91104002 	add	x2, x0, #0x410
    c0004e54:	b9401fe1 	ldr	w1, [sp, #28]
    c0004e58:	aa0103e0 	mov	x0, x1
    c0004e5c:	d37ff800 	lsl	x0, x0, #1
    c0004e60:	8b010000 	add	x0, x0, x1
    c0004e64:	d37df000 	lsl	x0, x0, #3
    c0004e68:	8b000040 	add	x0, x2, x0
    c0004e6c:	39404000 	ldrb	w0, [x0, #16]
}
    c0004e70:	a8c47bfd 	ldp	x29, x30, [sp], #64
    c0004e74:	d65f03c0 	ret

00000000c0004e78 <smp_map_psci_result>:

static int smp_map_psci_result(int32_t ret)
{
    c0004e78:	d10043ff 	sub	sp, sp, #0x10
    c0004e7c:	b9000fe0 	str	w0, [sp, #12]
	if (ret == PSCI_RET_SUCCESS) {
    c0004e80:	b9400fe0 	ldr	w0, [sp, #12]
    c0004e84:	7100001f 	cmp	w0, #0x0
    c0004e88:	54000061 	b.ne	c0004e94 <smp_map_psci_result+0x1c>  // b.any
		return SMP_START_OK;
    c0004e8c:	52800000 	mov	w0, #0x0                   	// #0
    c0004e90:	14000016 	b	c0004ee8 <smp_map_psci_result+0x70>
	}
	if (ret == PSCI_RET_ALREADY_ON) {
    c0004e94:	b9400fe0 	ldr	w0, [sp, #12]
    c0004e98:	3100101f 	cmn	w0, #0x4
    c0004e9c:	54000061 	b.ne	c0004ea8 <smp_map_psci_result+0x30>  // b.any
		return SMP_START_ALREADY_ONLINE;
    c0004ea0:	52800020 	mov	w0, #0x1                   	// #1
    c0004ea4:	14000011 	b	c0004ee8 <smp_map_psci_result+0x70>
	}
	if (ret == PSCI_RET_INVALID_PARAMS) {
    c0004ea8:	b9400fe0 	ldr	w0, [sp, #12]
    c0004eac:	3100081f 	cmn	w0, #0x2
    c0004eb0:	54000061 	b.ne	c0004ebc <smp_map_psci_result+0x44>  // b.any
		return SMP_START_INVALID_CPU;
    c0004eb4:	12800000 	mov	w0, #0xffffffff            	// #-1
    c0004eb8:	1400000c 	b	c0004ee8 <smp_map_psci_result+0x70>
	}
	if (ret == PSCI_RET_DENIED) {
    c0004ebc:	b9400fe0 	ldr	w0, [sp, #12]
    c0004ec0:	31000c1f 	cmn	w0, #0x3
    c0004ec4:	54000061 	b.ne	c0004ed0 <smp_map_psci_result+0x58>  // b.any
		return SMP_START_DENIED;
    c0004ec8:	12800040 	mov	w0, #0xfffffffd            	// #-3
    c0004ecc:	14000007 	b	c0004ee8 <smp_map_psci_result+0x70>
	}
	if (ret == PSCI_RET_NOT_SUPPORTED) {
    c0004ed0:	b9400fe0 	ldr	w0, [sp, #12]
    c0004ed4:	3100041f 	cmn	w0, #0x1
    c0004ed8:	54000061 	b.ne	c0004ee4 <smp_map_psci_result+0x6c>  // b.any
		return SMP_START_UNSUPPORTED;
    c0004edc:	12800020 	mov	w0, #0xfffffffe            	// #-2
    c0004ee0:	14000002 	b	c0004ee8 <smp_map_psci_result+0x70>
	}

	return SMP_START_FAILED;
    c0004ee4:	12800080 	mov	w0, #0xfffffffb            	// #-5
}
    c0004ee8:	910043ff 	add	sp, sp, #0x10
    c0004eec:	d65f03c0 	ret

00000000c0004ef0 <smp_start_result_name>:

const char *smp_start_result_name(int result)
{
    c0004ef0:	d10043ff 	sub	sp, sp, #0x10
    c0004ef4:	b9000fe0 	str	w0, [sp, #12]
	if (result == SMP_START_OK) {
    c0004ef8:	b9400fe0 	ldr	w0, [sp, #12]
    c0004efc:	7100001f 	cmp	w0, #0x0
    c0004f00:	54000081 	b.ne	c0004f10 <smp_start_result_name+0x20>  // b.any
		return "ok";
    c0004f04:	f0000000 	adrp	x0, c0007000 <hex.0+0x1128>
    c0004f08:	910a2000 	add	x0, x0, #0x288
    c0004f0c:	14000021 	b	c0004f90 <smp_start_result_name+0xa0>
	}
	if (result == SMP_START_ALREADY_ONLINE) {
    c0004f10:	b9400fe0 	ldr	w0, [sp, #12]
    c0004f14:	7100041f 	cmp	w0, #0x1
    c0004f18:	54000081 	b.ne	c0004f28 <smp_start_result_name+0x38>  // b.any
		return "already-on";
    c0004f1c:	f0000000 	adrp	x0, c0007000 <hex.0+0x1128>
    c0004f20:	910a4000 	add	x0, x0, #0x290
    c0004f24:	1400001b 	b	c0004f90 <smp_start_result_name+0xa0>
	}
	if (result == SMP_START_INVALID_CPU) {
    c0004f28:	b9400fe0 	ldr	w0, [sp, #12]
    c0004f2c:	3100041f 	cmn	w0, #0x1
    c0004f30:	54000081 	b.ne	c0004f40 <smp_start_result_name+0x50>  // b.any
		return "invalid-params";
    c0004f34:	f0000000 	adrp	x0, c0007000 <hex.0+0x1128>
    c0004f38:	910a8000 	add	x0, x0, #0x2a0
    c0004f3c:	14000015 	b	c0004f90 <smp_start_result_name+0xa0>
	}
	if (result == SMP_START_UNSUPPORTED) {
    c0004f40:	b9400fe0 	ldr	w0, [sp, #12]
    c0004f44:	3100081f 	cmn	w0, #0x2
    c0004f48:	54000081 	b.ne	c0004f58 <smp_start_result_name+0x68>  // b.any
		return "not-supported";
    c0004f4c:	f0000000 	adrp	x0, c0007000 <hex.0+0x1128>
    c0004f50:	910ac000 	add	x0, x0, #0x2b0
    c0004f54:	1400000f 	b	c0004f90 <smp_start_result_name+0xa0>
	}
	if (result == SMP_START_DENIED) {
    c0004f58:	b9400fe0 	ldr	w0, [sp, #12]
    c0004f5c:	31000c1f 	cmn	w0, #0x3
    c0004f60:	54000081 	b.ne	c0004f70 <smp_start_result_name+0x80>  // b.any
		return "denied";
    c0004f64:	f0000000 	adrp	x0, c0007000 <hex.0+0x1128>
    c0004f68:	910b0000 	add	x0, x0, #0x2c0
    c0004f6c:	14000009 	b	c0004f90 <smp_start_result_name+0xa0>
	}
	if (result == SMP_START_TIMEOUT) {
    c0004f70:	b9400fe0 	ldr	w0, [sp, #12]
    c0004f74:	3100101f 	cmn	w0, #0x4
    c0004f78:	54000081 	b.ne	c0004f88 <smp_start_result_name+0x98>  // b.any
		return "timeout";
    c0004f7c:	f0000000 	adrp	x0, c0007000 <hex.0+0x1128>
    c0004f80:	910b2000 	add	x0, x0, #0x2c8
    c0004f84:	14000003 	b	c0004f90 <smp_start_result_name+0xa0>
	}

	return "failed";
    c0004f88:	f0000000 	adrp	x0, c0007000 <hex.0+0x1128>
    c0004f8c:	910b4000 	add	x0, x0, #0x2d0
}
    c0004f90:	910043ff 	add	sp, sp, #0x10
    c0004f94:	d65f03c0 	ret

00000000c0004f98 <smp_init>:

void smp_init(void)
{
    c0004f98:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c0004f9c:	910003fd 	mov	x29, sp
	unsigned int i;
	const struct cpu_topology_descriptor *boot_cpu = topology_boot_cpu();
    c0004fa0:	94000280 	bl	c00059a0 <topology_boot_cpu>
    c0004fa4:	f9000be0 	str	x0, [sp, #16]

	for (i = 0U; i < PLAT_MAX_CPUS; ++i) {
    c0004fa8:	b9001fff 	str	wzr, [sp, #28]
    c0004fac:	1400003b 	b	c0005098 <smp_init+0x100>
		cpu_states[i].logical_id = i;
    c0004fb0:	f0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0004fb4:	91104002 	add	x2, x0, #0x410
    c0004fb8:	b9401fe1 	ldr	w1, [sp, #28]
    c0004fbc:	aa0103e0 	mov	x0, x1
    c0004fc0:	d37ff800 	lsl	x0, x0, #1
    c0004fc4:	8b010000 	add	x0, x0, x1
    c0004fc8:	d37df000 	lsl	x0, x0, #3
    c0004fcc:	8b000040 	add	x0, x2, x0
    c0004fd0:	b9401fe1 	ldr	w1, [sp, #28]
    c0004fd4:	b9000001 	str	w1, [x0]
		cpu_states[i].mpidr = 0U;
    c0004fd8:	f0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0004fdc:	91104002 	add	x2, x0, #0x410
    c0004fe0:	b9401fe1 	ldr	w1, [sp, #28]
    c0004fe4:	aa0103e0 	mov	x0, x1
    c0004fe8:	d37ff800 	lsl	x0, x0, #1
    c0004fec:	8b010000 	add	x0, x0, x1
    c0004ff0:	d37df000 	lsl	x0, x0, #3
    c0004ff4:	8b000040 	add	x0, x2, x0
    c0004ff8:	f900041f 	str	xzr, [x0, #8]
		cpu_states[i].online = false;
    c0004ffc:	f0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0005000:	91104002 	add	x2, x0, #0x410
    c0005004:	b9401fe1 	ldr	w1, [sp, #28]
    c0005008:	aa0103e0 	mov	x0, x1
    c000500c:	d37ff800 	lsl	x0, x0, #1
    c0005010:	8b010000 	add	x0, x0, x1
    c0005014:	d37df000 	lsl	x0, x0, #3
    c0005018:	8b000040 	add	x0, x2, x0
    c000501c:	3900401f 	strb	wzr, [x0, #16]
		cpu_states[i].scheduled = false;
    c0005020:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0005024:	91104002 	add	x2, x0, #0x410
    c0005028:	b9401fe1 	ldr	w1, [sp, #28]
    c000502c:	aa0103e0 	mov	x0, x1
    c0005030:	d37ff800 	lsl	x0, x0, #1
    c0005034:	8b010000 	add	x0, x0, x1
    c0005038:	d37df000 	lsl	x0, x0, #3
    c000503c:	8b000040 	add	x0, x2, x0
    c0005040:	3900441f 	strb	wzr, [x0, #17]
		cpu_states[i].pending = false;
    c0005044:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0005048:	91104002 	add	x2, x0, #0x410
    c000504c:	b9401fe1 	ldr	w1, [sp, #28]
    c0005050:	aa0103e0 	mov	x0, x1
    c0005054:	d37ff800 	lsl	x0, x0, #1
    c0005058:	8b010000 	add	x0, x0, x1
    c000505c:	d37df000 	lsl	x0, x0, #3
    c0005060:	8b000040 	add	x0, x2, x0
    c0005064:	3900481f 	strb	wzr, [x0, #18]
		cpu_states[i].boot_cpu = false;
    c0005068:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c000506c:	91104002 	add	x2, x0, #0x410
    c0005070:	b9401fe1 	ldr	w1, [sp, #28]
    c0005074:	aa0103e0 	mov	x0, x1
    c0005078:	d37ff800 	lsl	x0, x0, #1
    c000507c:	8b010000 	add	x0, x0, x1
    c0005080:	d37df000 	lsl	x0, x0, #3
    c0005084:	8b000040 	add	x0, x2, x0
    c0005088:	39004c1f 	strb	wzr, [x0, #19]
	for (i = 0U; i < PLAT_MAX_CPUS; ++i) {
    c000508c:	b9401fe0 	ldr	w0, [sp, #28]
    c0005090:	11000400 	add	w0, w0, #0x1
    c0005094:	b9001fe0 	str	w0, [sp, #28]
    c0005098:	b9401fe0 	ldr	w0, [sp, #28]
    c000509c:	71001c1f 	cmp	w0, #0x7
    c00050a0:	54fff889 	b.ls	c0004fb0 <smp_init+0x18>  // b.plast
	}

	cpu_states[0].logical_id = 0U;
    c00050a4:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c00050a8:	91104000 	add	x0, x0, #0x410
    c00050ac:	b900001f 	str	wzr, [x0]
	cpu_states[0].mpidr = boot_cpu->mpidr;
    c00050b0:	f9400be0 	ldr	x0, [sp, #16]
    c00050b4:	f9400001 	ldr	x1, [x0]
    c00050b8:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c00050bc:	91104000 	add	x0, x0, #0x410
    c00050c0:	f9000401 	str	x1, [x0, #8]
	cpu_states[0].boot_cpu = true;
    c00050c4:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c00050c8:	91104000 	add	x0, x0, #0x410
    c00050cc:	52800021 	mov	w1, #0x1                   	// #1
    c00050d0:	39004c01 	strb	w1, [x0, #19]
	cpu_states[0].online = true;
    c00050d4:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c00050d8:	91104000 	add	x0, x0, #0x410
    c00050dc:	52800021 	mov	w1, #0x1                   	// #1
    c00050e0:	39004001 	strb	w1, [x0, #16]
	cpu_states[0].scheduled = true;
    c00050e4:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c00050e8:	91104000 	add	x0, x0, #0x410
    c00050ec:	52800021 	mov	w1, #0x1                   	// #1
    c00050f0:	39004401 	strb	w1, [x0, #17]
	online_cpu_count = 1U;
    c00050f4:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c00050f8:	91134000 	add	x0, x0, #0x4d0
    c00050fc:	52800021 	mov	w1, #0x1                   	// #1
    c0005100:	b9000001 	str	w1, [x0]
}
    c0005104:	d503201f 	nop
    c0005108:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c000510c:	d65f03c0 	ret

00000000c0005110 <smp_start_cpu>:

int smp_start_cpu(uint64_t mpidr, unsigned int *logical_id, int32_t *smc_ret)
{
    c0005110:	a9bb7bfd 	stp	x29, x30, [sp, #-80]!
    c0005114:	910003fd 	mov	x29, sp
    c0005118:	f90017e0 	str	x0, [sp, #40]
    c000511c:	f90013e1 	str	x1, [sp, #32]
    c0005120:	f9000fe2 	str	x2, [sp, #24]
	const struct cpu_topology_descriptor *cpu;
	int slot;
	int32_t ret;
	int result;
	bool new_cpu = false;
    c0005124:	39013fff 	strb	wzr, [sp, #79]

	if ((logical_id == (unsigned int *)0) || (smc_ret == (int32_t *)0)) {
    c0005128:	f94013e0 	ldr	x0, [sp, #32]
    c000512c:	f100001f 	cmp	x0, #0x0
    c0005130:	54000080 	b.eq	c0005140 <smp_start_cpu+0x30>  // b.none
    c0005134:	f9400fe0 	ldr	x0, [sp, #24]
    c0005138:	f100001f 	cmp	x0, #0x0
    c000513c:	54000061 	b.ne	c0005148 <smp_start_cpu+0x38>  // b.any
		return SMP_START_FAILED;
    c0005140:	12800080 	mov	w0, #0xfffffffb            	// #-5
    c0005144:	1400011c 	b	c00055b4 <smp_start_cpu+0x4a4>
	}

	*smc_ret = 0;
    c0005148:	f9400fe0 	ldr	x0, [sp, #24]
    c000514c:	b900001f 	str	wzr, [x0]
	cpu = topology_find_cpu_by_mpidr(mpidr);
    c0005150:	f94017e0 	ldr	x0, [sp, #40]
    c0005154:	94000224 	bl	c00059e4 <topology_find_cpu_by_mpidr>
    c0005158:	f90023e0 	str	x0, [sp, #64]
	if (cpu != (const struct cpu_topology_descriptor *)0) {
    c000515c:	f94023e0 	ldr	x0, [sp, #64]
    c0005160:	f100001f 	cmp	x0, #0x0
    c0005164:	54000300 	b.eq	c00051c4 <smp_start_cpu+0xb4>  // b.none
		*logical_id = cpu->logical_id;
    c0005168:	f94023e0 	ldr	x0, [sp, #64]
    c000516c:	b9400801 	ldr	w1, [x0, #8]
    c0005170:	f94013e0 	ldr	x0, [sp, #32]
    c0005174:	b9000001 	str	w1, [x0]
		if (cpu_states[cpu->logical_id].online) {
    c0005178:	f94023e0 	ldr	x0, [sp, #64]
    c000517c:	b9400801 	ldr	w1, [x0, #8]
    c0005180:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0005184:	91104002 	add	x2, x0, #0x410
    c0005188:	2a0103e1 	mov	w1, w1
    c000518c:	aa0103e0 	mov	x0, x1
    c0005190:	d37ff800 	lsl	x0, x0, #1
    c0005194:	8b010000 	add	x0, x0, x1
    c0005198:	d37df000 	lsl	x0, x0, #3
    c000519c:	8b000040 	add	x0, x2, x0
    c00051a0:	39404000 	ldrb	w0, [x0, #16]
    c00051a4:	12000000 	and	w0, w0, #0x1
    c00051a8:	7100001f 	cmp	w0, #0x0
    c00051ac:	54000760 	b.eq	c0005298 <smp_start_cpu+0x188>  // b.none
			*smc_ret = PSCI_RET_ALREADY_ON;
    c00051b0:	f9400fe0 	ldr	x0, [sp, #24]
    c00051b4:	12800061 	mov	w1, #0xfffffffc            	// #-4
    c00051b8:	b9000001 	str	w1, [x0]
			return SMP_START_ALREADY_ONLINE;
    c00051bc:	52800020 	mov	w0, #0x1                   	// #1
    c00051c0:	140000fd 	b	c00055b4 <smp_start_cpu+0x4a4>
		}
	} else {
		slot = smp_find_free_logical_slot();
    c00051c4:	97fffe78 	bl	c0004ba4 <smp_find_free_logical_slot>
    c00051c8:	b9003fe0 	str	w0, [sp, #60]
		if (slot < 0) {
    c00051cc:	b9403fe0 	ldr	w0, [sp, #60]
    c00051d0:	7100001f 	cmp	w0, #0x0
    c00051d4:	5400006a 	b.ge	c00051e0 <smp_start_cpu+0xd0>  // b.tcont
			return SMP_START_INVALID_CPU;
    c00051d8:	12800000 	mov	w0, #0xffffffff            	// #-1
    c00051dc:	140000f6 	b	c00055b4 <smp_start_cpu+0x4a4>
		}
		*logical_id = (unsigned int)slot;
    c00051e0:	b9403fe1 	ldr	w1, [sp, #60]
    c00051e4:	f94013e0 	ldr	x0, [sp, #32]
    c00051e8:	b9000001 	str	w1, [x0]
		new_cpu = true;
    c00051ec:	52800020 	mov	w0, #0x1                   	// #1
    c00051f0:	39013fe0 	strb	w0, [sp, #79]

		topology_register_cpu(*logical_id, mpidr, false);
    c00051f4:	f94013e0 	ldr	x0, [sp, #32]
    c00051f8:	b9400000 	ldr	w0, [x0]
    c00051fc:	52800002 	mov	w2, #0x0                   	// #0
    c0005200:	f94017e1 	ldr	x1, [sp, #40]
    c0005204:	94000289 	bl	c0005c28 <topology_register_cpu>
		cpu_states[*logical_id].logical_id = *logical_id;
    c0005208:	f94013e0 	ldr	x0, [sp, #32]
    c000520c:	b9400001 	ldr	w1, [x0]
    c0005210:	f94013e0 	ldr	x0, [sp, #32]
    c0005214:	b9400002 	ldr	w2, [x0]
    c0005218:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c000521c:	91104003 	add	x3, x0, #0x410
    c0005220:	2a0103e1 	mov	w1, w1
    c0005224:	aa0103e0 	mov	x0, x1
    c0005228:	d37ff800 	lsl	x0, x0, #1
    c000522c:	8b010000 	add	x0, x0, x1
    c0005230:	d37df000 	lsl	x0, x0, #3
    c0005234:	8b000060 	add	x0, x3, x0
    c0005238:	b9000002 	str	w2, [x0]
		cpu_states[*logical_id].mpidr = mpidr;
    c000523c:	f94013e0 	ldr	x0, [sp, #32]
    c0005240:	b9400001 	ldr	w1, [x0]
    c0005244:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0005248:	91104002 	add	x2, x0, #0x410
    c000524c:	2a0103e1 	mov	w1, w1
    c0005250:	aa0103e0 	mov	x0, x1
    c0005254:	d37ff800 	lsl	x0, x0, #1
    c0005258:	8b010000 	add	x0, x0, x1
    c000525c:	d37df000 	lsl	x0, x0, #3
    c0005260:	8b000040 	add	x0, x2, x0
    c0005264:	f94017e1 	ldr	x1, [sp, #40]
    c0005268:	f9000401 	str	x1, [x0, #8]
		cpu_states[*logical_id].boot_cpu = false;
    c000526c:	f94013e0 	ldr	x0, [sp, #32]
    c0005270:	b9400001 	ldr	w1, [x0]
    c0005274:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0005278:	91104002 	add	x2, x0, #0x410
    c000527c:	2a0103e1 	mov	w1, w1
    c0005280:	aa0103e0 	mov	x0, x1
    c0005284:	d37ff800 	lsl	x0, x0, #1
    c0005288:	8b010000 	add	x0, x0, x1
    c000528c:	d37df000 	lsl	x0, x0, #3
    c0005290:	8b000040 	add	x0, x2, x0
    c0005294:	39004c1f 	strb	wzr, [x0, #19]
	}

	cpu_states[*logical_id].pending = true;
    c0005298:	f94013e0 	ldr	x0, [sp, #32]
    c000529c:	b9400001 	ldr	w1, [x0]
    c00052a0:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c00052a4:	91104002 	add	x2, x0, #0x410
    c00052a8:	2a0103e1 	mov	w1, w1
    c00052ac:	aa0103e0 	mov	x0, x1
    c00052b0:	d37ff800 	lsl	x0, x0, #1
    c00052b4:	8b010000 	add	x0, x0, x1
    c00052b8:	d37df000 	lsl	x0, x0, #3
    c00052bc:	8b000040 	add	x0, x2, x0
    c00052c0:	52800021 	mov	w1, #0x1                   	// #1
    c00052c4:	39004801 	strb	w1, [x0, #18]
	cpu_states[*logical_id].online = false;
    c00052c8:	f94013e0 	ldr	x0, [sp, #32]
    c00052cc:	b9400001 	ldr	w1, [x0]
    c00052d0:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c00052d4:	91104002 	add	x2, x0, #0x410
    c00052d8:	2a0103e1 	mov	w1, w1
    c00052dc:	aa0103e0 	mov	x0, x1
    c00052e0:	d37ff800 	lsl	x0, x0, #1
    c00052e4:	8b010000 	add	x0, x0, x1
    c00052e8:	d37df000 	lsl	x0, x0, #3
    c00052ec:	8b000040 	add	x0, x2, x0
    c00052f0:	3900401f 	strb	wzr, [x0, #16]
	cpu_states[*logical_id].scheduled = false;
    c00052f4:	f94013e0 	ldr	x0, [sp, #32]
    c00052f8:	b9400001 	ldr	w1, [x0]
    c00052fc:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0005300:	91104002 	add	x2, x0, #0x410
    c0005304:	2a0103e1 	mov	w1, w1
    c0005308:	aa0103e0 	mov	x0, x1
    c000530c:	d37ff800 	lsl	x0, x0, #1
    c0005310:	8b010000 	add	x0, x0, x1
    c0005314:	d37df000 	lsl	x0, x0, #3
    c0005318:	8b000040 	add	x0, x2, x0
    c000531c:	3900441f 	strb	wzr, [x0, #17]

	ret = smp_smc_call(PSCI_CPU_ON_64, mpidr,
    c0005320:	f0ffffc0 	adrp	x0, c0000000 <_start>
    c0005324:	91008001 	add	x1, x0, #0x20
			   (uintptr_t)secondary_cpu_entrypoint,
			   *logical_id);
    c0005328:	f94013e0 	ldr	x0, [sp, #32]
    c000532c:	b9400000 	ldr	w0, [x0]
	ret = smp_smc_call(PSCI_CPU_ON_64, mpidr,
    c0005330:	2a0003e0 	mov	w0, w0
    c0005334:	aa0003e3 	mov	x3, x0
    c0005338:	aa0103e2 	mov	x2, x1
    c000533c:	f94017e1 	ldr	x1, [sp, #40]
    c0005340:	d2800060 	mov	x0, #0x3                   	// #3
    c0005344:	f2b88000 	movk	x0, #0xc400, lsl #16
    c0005348:	97fffe0b 	bl	c0004b74 <smp_smc_call>
    c000534c:	b9003be0 	str	w0, [sp, #56]
	*smc_ret = ret;
    c0005350:	f9400fe0 	ldr	x0, [sp, #24]
    c0005354:	b9403be1 	ldr	w1, [sp, #56]
    c0005358:	b9000001 	str	w1, [x0]
	result = smp_map_psci_result(ret);
    c000535c:	b9403be0 	ldr	w0, [sp, #56]
    c0005360:	97fffec6 	bl	c0004e78 <smp_map_psci_result>
    c0005364:	b90037e0 	str	w0, [sp, #52]

	if (result == SMP_START_OK) {
    c0005368:	b94037e0 	ldr	w0, [sp, #52]
    c000536c:	7100001f 	cmp	w0, #0x0
    c0005370:	540004a1 	b.ne	c0005404 <smp_start_cpu+0x2f4>  // b.any
		if (!smp_wait_for_online(*logical_id, SMP_CPU_ON_TIMEOUT_US)) {
    c0005374:	f94013e0 	ldr	x0, [sp, #32]
    c0005378:	b9400000 	ldr	w0, [x0]
    c000537c:	5290d401 	mov	w1, #0x86a0                	// #34464
    c0005380:	72a00021 	movk	w1, #0x1, lsl #16
    c0005384:	97fffe5f 	bl	c0004d00 <smp_wait_for_online>
    c0005388:	12001c00 	and	w0, w0, #0xff
    c000538c:	52000000 	eor	w0, w0, #0x1
    c0005390:	12001c00 	and	w0, w0, #0xff
    c0005394:	12000000 	and	w0, w0, #0x1
    c0005398:	7100001f 	cmp	w0, #0x0
    c000539c:	54000300 	b.eq	c00053fc <smp_start_cpu+0x2ec>  // b.none
			cpu_states[*logical_id].pending = false;
    c00053a0:	f94013e0 	ldr	x0, [sp, #32]
    c00053a4:	b9400001 	ldr	w1, [x0]
    c00053a8:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c00053ac:	91104002 	add	x2, x0, #0x410
    c00053b0:	2a0103e1 	mov	w1, w1
    c00053b4:	aa0103e0 	mov	x0, x1
    c00053b8:	d37ff800 	lsl	x0, x0, #1
    c00053bc:	8b010000 	add	x0, x0, x1
    c00053c0:	d37df000 	lsl	x0, x0, #3
    c00053c4:	8b000040 	add	x0, x2, x0
    c00053c8:	3900481f 	strb	wzr, [x0, #18]
			if (new_cpu) {
    c00053cc:	39413fe0 	ldrb	w0, [sp, #79]
    c00053d0:	12000000 	and	w0, w0, #0x1
    c00053d4:	7100001f 	cmp	w0, #0x0
    c00053d8:	540000e0 	b.eq	c00053f4 <smp_start_cpu+0x2e4>  // b.none
				topology_unregister_cpu(*logical_id);
    c00053dc:	f94013e0 	ldr	x0, [sp, #32]
    c00053e0:	b9400000 	ldr	w0, [x0]
    c00053e4:	94000245 	bl	c0005cf8 <topology_unregister_cpu>
				smp_reset_cpu_state(*logical_id);
    c00053e8:	f94013e0 	ldr	x0, [sp, #32]
    c00053ec:	b9400000 	ldr	w0, [x0]
    c00053f0:	97fffe04 	bl	c0004c00 <smp_reset_cpu_state>
			}
			return SMP_START_TIMEOUT;
    c00053f4:	12800060 	mov	w0, #0xfffffffc            	// #-4
    c00053f8:	1400006f 	b	c00055b4 <smp_start_cpu+0x4a4>
		}
		return SMP_START_OK;
    c00053fc:	52800000 	mov	w0, #0x0                   	// #0
    c0005400:	1400006d 	b	c00055b4 <smp_start_cpu+0x4a4>
	}

	if (result == SMP_START_ALREADY_ONLINE) {
    c0005404:	b94037e0 	ldr	w0, [sp, #52]
    c0005408:	7100041f 	cmp	w0, #0x1
    c000540c:	54000a81 	b.ne	c000555c <smp_start_cpu+0x44c>  // b.any
		cpu_states[*logical_id].pending = false;
    c0005410:	f94013e0 	ldr	x0, [sp, #32]
    c0005414:	b9400001 	ldr	w1, [x0]
    c0005418:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c000541c:	91104002 	add	x2, x0, #0x410
    c0005420:	2a0103e1 	mov	w1, w1
    c0005424:	aa0103e0 	mov	x0, x1
    c0005428:	d37ff800 	lsl	x0, x0, #1
    c000542c:	8b010000 	add	x0, x0, x1
    c0005430:	d37df000 	lsl	x0, x0, #3
    c0005434:	8b000040 	add	x0, x2, x0
    c0005438:	3900481f 	strb	wzr, [x0, #18]

		/*
		 * 不能单凭 TF-A 返回 already-on 就认定 secondary 已经真正进入 mini-os。
		 * 只有 boot cpu 才天然成立；对于新注册但没观察到 online 的核，必须回滚。
		 */
		if (cpu_states[*logical_id].boot_cpu) {
    c000543c:	f94013e0 	ldr	x0, [sp, #32]
    c0005440:	b9400001 	ldr	w1, [x0]
    c0005444:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0005448:	91104002 	add	x2, x0, #0x410
    c000544c:	2a0103e1 	mov	w1, w1
    c0005450:	aa0103e0 	mov	x0, x1
    c0005454:	d37ff800 	lsl	x0, x0, #1
    c0005458:	8b010000 	add	x0, x0, x1
    c000545c:	d37df000 	lsl	x0, x0, #3
    c0005460:	8b000040 	add	x0, x2, x0
    c0005464:	39404c00 	ldrb	w0, [x0, #19]
    c0005468:	12000000 	and	w0, w0, #0x1
    c000546c:	7100001f 	cmp	w0, #0x0
    c0005470:	540003e0 	b.eq	c00054ec <smp_start_cpu+0x3dc>  // b.none
			cpu_states[*logical_id].online = true;
    c0005474:	f94013e0 	ldr	x0, [sp, #32]
    c0005478:	b9400001 	ldr	w1, [x0]
    c000547c:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0005480:	91104002 	add	x2, x0, #0x410
    c0005484:	2a0103e1 	mov	w1, w1
    c0005488:	aa0103e0 	mov	x0, x1
    c000548c:	d37ff800 	lsl	x0, x0, #1
    c0005490:	8b010000 	add	x0, x0, x1
    c0005494:	d37df000 	lsl	x0, x0, #3
    c0005498:	8b000040 	add	x0, x2, x0
    c000549c:	52800021 	mov	w1, #0x1                   	// #1
    c00054a0:	39004001 	strb	w1, [x0, #16]
			cpu_states[*logical_id].scheduled = true;
    c00054a4:	f94013e0 	ldr	x0, [sp, #32]
    c00054a8:	b9400001 	ldr	w1, [x0]
    c00054ac:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c00054b0:	91104002 	add	x2, x0, #0x410
    c00054b4:	2a0103e1 	mov	w1, w1
    c00054b8:	aa0103e0 	mov	x0, x1
    c00054bc:	d37ff800 	lsl	x0, x0, #1
    c00054c0:	8b010000 	add	x0, x0, x1
    c00054c4:	d37df000 	lsl	x0, x0, #3
    c00054c8:	8b000040 	add	x0, x2, x0
    c00054cc:	52800021 	mov	w1, #0x1                   	// #1
    c00054d0:	39004401 	strb	w1, [x0, #17]
			topology_mark_cpu_online(*logical_id, true);
    c00054d4:	f94013e0 	ldr	x0, [sp, #32]
    c00054d8:	b9400000 	ldr	w0, [x0]
    c00054dc:	52800021 	mov	w1, #0x1                   	// #1
    c00054e0:	94000170 	bl	c0005aa0 <topology_mark_cpu_online>
			return SMP_START_ALREADY_ONLINE;
    c00054e4:	52800020 	mov	w0, #0x1                   	// #1
    c00054e8:	14000033 	b	c00055b4 <smp_start_cpu+0x4a4>
		}

		if (!cpu_states[*logical_id].online && new_cpu) {
    c00054ec:	f94013e0 	ldr	x0, [sp, #32]
    c00054f0:	b9400001 	ldr	w1, [x0]
    c00054f4:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c00054f8:	91104002 	add	x2, x0, #0x410
    c00054fc:	2a0103e1 	mov	w1, w1
    c0005500:	aa0103e0 	mov	x0, x1
    c0005504:	d37ff800 	lsl	x0, x0, #1
    c0005508:	8b010000 	add	x0, x0, x1
    c000550c:	d37df000 	lsl	x0, x0, #3
    c0005510:	8b000040 	add	x0, x2, x0
    c0005514:	39404000 	ldrb	w0, [x0, #16]
    c0005518:	52000000 	eor	w0, w0, #0x1
    c000551c:	12001c00 	and	w0, w0, #0xff
    c0005520:	12000000 	and	w0, w0, #0x1
    c0005524:	7100001f 	cmp	w0, #0x0
    c0005528:	54000160 	b.eq	c0005554 <smp_start_cpu+0x444>  // b.none
    c000552c:	39413fe0 	ldrb	w0, [sp, #79]
    c0005530:	12000000 	and	w0, w0, #0x1
    c0005534:	7100001f 	cmp	w0, #0x0
    c0005538:	540000e0 	b.eq	c0005554 <smp_start_cpu+0x444>  // b.none
			topology_unregister_cpu(*logical_id);
    c000553c:	f94013e0 	ldr	x0, [sp, #32]
    c0005540:	b9400000 	ldr	w0, [x0]
    c0005544:	940001ed 	bl	c0005cf8 <topology_unregister_cpu>
			smp_reset_cpu_state(*logical_id);
    c0005548:	f94013e0 	ldr	x0, [sp, #32]
    c000554c:	b9400000 	ldr	w0, [x0]
    c0005550:	97fffdac 	bl	c0004c00 <smp_reset_cpu_state>
		}

		return SMP_START_ALREADY_ONLINE;
    c0005554:	52800020 	mov	w0, #0x1                   	// #1
    c0005558:	14000017 	b	c00055b4 <smp_start_cpu+0x4a4>
	}

	cpu_states[*logical_id].pending = false;
    c000555c:	f94013e0 	ldr	x0, [sp, #32]
    c0005560:	b9400001 	ldr	w1, [x0]
    c0005564:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0005568:	91104002 	add	x2, x0, #0x410
    c000556c:	2a0103e1 	mov	w1, w1
    c0005570:	aa0103e0 	mov	x0, x1
    c0005574:	d37ff800 	lsl	x0, x0, #1
    c0005578:	8b010000 	add	x0, x0, x1
    c000557c:	d37df000 	lsl	x0, x0, #3
    c0005580:	8b000040 	add	x0, x2, x0
    c0005584:	3900481f 	strb	wzr, [x0, #18]

	if (new_cpu) {
    c0005588:	39413fe0 	ldrb	w0, [sp, #79]
    c000558c:	12000000 	and	w0, w0, #0x1
    c0005590:	7100001f 	cmp	w0, #0x0
    c0005594:	540000e0 	b.eq	c00055b0 <smp_start_cpu+0x4a0>  // b.none
		topology_unregister_cpu(*logical_id);
    c0005598:	f94013e0 	ldr	x0, [sp, #32]
    c000559c:	b9400000 	ldr	w0, [x0]
    c00055a0:	940001d6 	bl	c0005cf8 <topology_unregister_cpu>
		smp_reset_cpu_state(*logical_id);
    c00055a4:	f94013e0 	ldr	x0, [sp, #32]
    c00055a8:	b9400000 	ldr	w0, [x0]
    c00055ac:	97fffd95 	bl	c0004c00 <smp_reset_cpu_state>
	}

	return result;
    c00055b0:	b94037e0 	ldr	w0, [sp, #52]
}
    c00055b4:	a8c57bfd 	ldp	x29, x30, [sp], #80
    c00055b8:	d65f03c0 	ret

00000000c00055bc <smp_cpu_state>:

const struct smp_cpu_state *smp_cpu_state(unsigned int logical_id)
{
    c00055bc:	d10043ff 	sub	sp, sp, #0x10
    c00055c0:	b9000fe0 	str	w0, [sp, #12]
	if (logical_id >= PLAT_MAX_CPUS) {
    c00055c4:	b9400fe0 	ldr	w0, [sp, #12]
    c00055c8:	71001c1f 	cmp	w0, #0x7
    c00055cc:	54000069 	b.ls	c00055d8 <smp_cpu_state+0x1c>  // b.plast
		return (const struct smp_cpu_state *)0;
    c00055d0:	d2800000 	mov	x0, #0x0                   	// #0
    c00055d4:	14000009 	b	c00055f8 <smp_cpu_state+0x3c>
	}

	return &cpu_states[logical_id];
    c00055d8:	b9400fe1 	ldr	w1, [sp, #12]
    c00055dc:	aa0103e0 	mov	x0, x1
    c00055e0:	d37ff800 	lsl	x0, x0, #1
    c00055e4:	8b010000 	add	x0, x0, x1
    c00055e8:	d37df000 	lsl	x0, x0, #3
    c00055ec:	d0000101 	adrp	x1, c0027000 <secondary_stacks+0x1fbf0>
    c00055f0:	91104021 	add	x1, x1, #0x410
    c00055f4:	8b010000 	add	x0, x0, x1
}
    c00055f8:	910043ff 	add	sp, sp, #0x10
    c00055fc:	d65f03c0 	ret

00000000c0005600 <smp_online_cpu_count>:

unsigned int smp_online_cpu_count(void)
{
	return online_cpu_count;
    c0005600:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0005604:	91134000 	add	x0, x0, #0x4d0
    c0005608:	b9400000 	ldr	w0, [x0]
}
    c000560c:	d65f03c0 	ret

00000000c0005610 <smp_secondary_cpu_online>:

void smp_secondary_cpu_online(unsigned int logical_id)
{
    c0005610:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c0005614:	910003fd 	mov	x29, sp
    c0005618:	b9001fe0 	str	w0, [sp, #28]
	if ((logical_id >= PLAT_MAX_CPUS) || cpu_states[logical_id].online) {
    c000561c:	b9401fe0 	ldr	w0, [sp, #28]
    c0005620:	71001c1f 	cmp	w0, #0x7
    c0005624:	540006e8 	b.hi	c0005700 <smp_secondary_cpu_online+0xf0>  // b.pmore
    c0005628:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c000562c:	91104002 	add	x2, x0, #0x410
    c0005630:	b9401fe1 	ldr	w1, [sp, #28]
    c0005634:	aa0103e0 	mov	x0, x1
    c0005638:	d37ff800 	lsl	x0, x0, #1
    c000563c:	8b010000 	add	x0, x0, x1
    c0005640:	d37df000 	lsl	x0, x0, #3
    c0005644:	8b000040 	add	x0, x2, x0
    c0005648:	39404000 	ldrb	w0, [x0, #16]
    c000564c:	12000000 	and	w0, w0, #0x1
    c0005650:	7100001f 	cmp	w0, #0x0
    c0005654:	54000561 	b.ne	c0005700 <smp_secondary_cpu_online+0xf0>  // b.any
		return;
	}

	cpu_states[logical_id].pending = false;
    c0005658:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c000565c:	91104002 	add	x2, x0, #0x410
    c0005660:	b9401fe1 	ldr	w1, [sp, #28]
    c0005664:	aa0103e0 	mov	x0, x1
    c0005668:	d37ff800 	lsl	x0, x0, #1
    c000566c:	8b010000 	add	x0, x0, x1
    c0005670:	d37df000 	lsl	x0, x0, #3
    c0005674:	8b000040 	add	x0, x2, x0
    c0005678:	3900481f 	strb	wzr, [x0, #18]
	cpu_states[logical_id].online = true;
    c000567c:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0005680:	91104002 	add	x2, x0, #0x410
    c0005684:	b9401fe1 	ldr	w1, [sp, #28]
    c0005688:	aa0103e0 	mov	x0, x1
    c000568c:	d37ff800 	lsl	x0, x0, #1
    c0005690:	8b010000 	add	x0, x0, x1
    c0005694:	d37df000 	lsl	x0, x0, #3
    c0005698:	8b000040 	add	x0, x2, x0
    c000569c:	52800021 	mov	w1, #0x1                   	// #1
    c00056a0:	39004001 	strb	w1, [x0, #16]
	cpu_states[logical_id].scheduled = true;
    c00056a4:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c00056a8:	91104002 	add	x2, x0, #0x410
    c00056ac:	b9401fe1 	ldr	w1, [sp, #28]
    c00056b0:	aa0103e0 	mov	x0, x1
    c00056b4:	d37ff800 	lsl	x0, x0, #1
    c00056b8:	8b010000 	add	x0, x0, x1
    c00056bc:	d37df000 	lsl	x0, x0, #3
    c00056c0:	8b000040 	add	x0, x2, x0
    c00056c4:	52800021 	mov	w1, #0x1                   	// #1
    c00056c8:	39004401 	strb	w1, [x0, #17]
	online_cpu_count++;
    c00056cc:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c00056d0:	91134000 	add	x0, x0, #0x4d0
    c00056d4:	b9400000 	ldr	w0, [x0]
    c00056d8:	11000401 	add	w1, w0, #0x1
    c00056dc:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c00056e0:	91134000 	add	x0, x0, #0x4d0
    c00056e4:	b9000001 	str	w1, [x0]
	topology_mark_cpu_online(logical_id, true);
    c00056e8:	52800021 	mov	w1, #0x1                   	// #1
    c00056ec:	b9401fe0 	ldr	w0, [sp, #28]
    c00056f0:	940000ec 	bl	c0005aa0 <topology_mark_cpu_online>
	scheduler_join_cpu(logical_id);
    c00056f4:	b9401fe0 	ldr	w0, [sp, #28]
    c00056f8:	97fff722 	bl	c0003380 <scheduler_join_cpu>
    c00056fc:	14000002 	b	c0005704 <smp_secondary_cpu_online+0xf4>
		return;
    c0005700:	d503201f 	nop
}
    c0005704:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c0005708:	d65f03c0 	ret

00000000c000570c <smp_secondary_entry>:

void smp_secondary_entry(uint64_t logical_id)
{
    c000570c:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
    c0005710:	910003fd 	mov	x29, sp
    c0005714:	a90153f3 	stp	x19, x20, [sp, #16]
    c0005718:	f90017e0 	str	x0, [sp, #40]
	smp_secondary_cpu_online((unsigned int)logical_id);
    c000571c:	f94017e0 	ldr	x0, [sp, #40]
    c0005720:	97ffffbc 	bl	c0005610 <smp_secondary_cpu_online>
	mini_os_printf("secondary cpu%u online (mpidr=0x%llx), scheduler runnable=%u\n",
    c0005724:	f94017e0 	ldr	x0, [sp, #40]
    c0005728:	2a0003f4 	mov	w20, w0
		       (unsigned int)logical_id,
		       (unsigned long long)cpu_states[logical_id].mpidr,
    c000572c:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0005730:	91104002 	add	x2, x0, #0x410
    c0005734:	f94017e1 	ldr	x1, [sp, #40]
    c0005738:	aa0103e0 	mov	x0, x1
    c000573c:	d37ff800 	lsl	x0, x0, #1
    c0005740:	8b010000 	add	x0, x0, x1
    c0005744:	d37df000 	lsl	x0, x0, #3
    c0005748:	8b000040 	add	x0, x2, x0
    c000574c:	f9400413 	ldr	x19, [x0, #8]
	mini_os_printf("secondary cpu%u online (mpidr=0x%llx), scheduler runnable=%u\n",
    c0005750:	97fff744 	bl	c0003460 <scheduler_runnable_cpu_count>
    c0005754:	2a0003e3 	mov	w3, w0
    c0005758:	aa1303e2 	mov	x2, x19
    c000575c:	2a1403e1 	mov	w1, w20
    c0005760:	d0000000 	adrp	x0, c0007000 <hex.0+0x1128>
    c0005764:	910b6000 	add	x0, x0, #0x2d8
    c0005768:	97fff163 	bl	c0001cf4 <mini_os_printf>
		       scheduler_runnable_cpu_count());

	for (;;) {
		__asm__ volatile ("wfe");
    c000576c:	d503205f 	wfe
    c0005770:	17ffffff 	b	c000576c <smp_secondary_entry+0x60>

00000000c0005774 <smp_secondary_entrypoint>:
	}
}

uintptr_t smp_secondary_entrypoint(void)
{
	return (uintptr_t)secondary_cpu_entrypoint;
    c0005774:	f0ffffc0 	adrp	x0, c0000000 <_start>
    c0005778:	91008000 	add	x0, x0, #0x20
    c000577c:	d65f03c0 	ret

00000000c0005780 <test_framework_init>:
#include <kernel/test.h>

void test_framework_init(void)
{
    c0005780:	d503201f 	nop
    c0005784:	d65f03c0 	ret

00000000c0005788 <topology_read_mpidr>:
static struct cpu_topology_descriptor cpu_descs[PLAT_MAX_CPUS];
static unsigned int present_cpu_count;
static unsigned int online_cpu_count;

static inline uint64_t topology_read_mpidr(void)
{
    c0005788:	d10043ff 	sub	sp, sp, #0x10
	uint64_t mpidr;

	__asm__ volatile ("mrs %0, mpidr_el1" : "=r" (mpidr));
    c000578c:	d53800a0 	mrs	x0, mpidr_el1
    c0005790:	f90007e0 	str	x0, [sp, #8]
	return mpidr;
    c0005794:	f94007e0 	ldr	x0, [sp, #8]
}
    c0005798:	910043ff 	add	sp, sp, #0x10
    c000579c:	d65f03c0 	ret

00000000c00057a0 <topology_fill_descriptor>:

static void topology_fill_descriptor(struct cpu_topology_descriptor *cpu,
				     unsigned int logical_id,
				     uint64_t mpidr,
				     bool boot_cpu)
{
    c00057a0:	d10083ff 	sub	sp, sp, #0x20
    c00057a4:	f9000fe0 	str	x0, [sp, #24]
    c00057a8:	b90017e1 	str	w1, [sp, #20]
    c00057ac:	f90007e2 	str	x2, [sp, #8]
    c00057b0:	39004fe3 	strb	w3, [sp, #19]
	cpu->logical_id = logical_id;
    c00057b4:	f9400fe0 	ldr	x0, [sp, #24]
    c00057b8:	b94017e1 	ldr	w1, [sp, #20]
    c00057bc:	b9000801 	str	w1, [x0, #8]
	cpu->mpidr = mpidr;
    c00057c0:	f9400fe0 	ldr	x0, [sp, #24]
    c00057c4:	f94007e1 	ldr	x1, [sp, #8]
    c00057c8:	f9000001 	str	x1, [x0]
	cpu->chip_id = (unsigned int)((mpidr & MPIDR_AFF3_MASK) >> MPIDR_AFF3_SHIFT);
    c00057cc:	f94007e0 	ldr	x0, [sp, #8]
    c00057d0:	d358fc00 	lsr	x0, x0, #24
    c00057d4:	12001c01 	and	w1, w0, #0xff
    c00057d8:	f9400fe0 	ldr	x0, [sp, #24]
    c00057dc:	b9000c01 	str	w1, [x0, #12]
	cpu->die_id = (unsigned int)((mpidr & MPIDR_AFF2_MASK) >> MPIDR_AFF2_SHIFT);
    c00057e0:	f94007e0 	ldr	x0, [sp, #8]
    c00057e4:	d350fc00 	lsr	x0, x0, #16
    c00057e8:	12001c01 	and	w1, w0, #0xff
    c00057ec:	f9400fe0 	ldr	x0, [sp, #24]
    c00057f0:	b9001001 	str	w1, [x0, #16]
	cpu->cluster_id = (unsigned int)((mpidr & MPIDR_AFF1_MASK) >> MPIDR_AFF1_SHIFT);
    c00057f4:	f94007e0 	ldr	x0, [sp, #8]
    c00057f8:	d348fc00 	lsr	x0, x0, #8
    c00057fc:	12001c01 	and	w1, w0, #0xff
    c0005800:	f9400fe0 	ldr	x0, [sp, #24]
    c0005804:	b9001401 	str	w1, [x0, #20]
	cpu->core_id = (unsigned int)(mpidr & MPIDR_AFF0_MASK);
    c0005808:	f94007e0 	ldr	x0, [sp, #8]
    c000580c:	12001c01 	and	w1, w0, #0xff
    c0005810:	f9400fe0 	ldr	x0, [sp, #24]
    c0005814:	b9001801 	str	w1, [x0, #24]
	cpu->boot_cpu = boot_cpu;
    c0005818:	f9400fe0 	ldr	x0, [sp, #24]
    c000581c:	39404fe1 	ldrb	w1, [sp, #19]
    c0005820:	39007001 	strb	w1, [x0, #28]
}
    c0005824:	d503201f 	nop
    c0005828:	910083ff 	add	sp, sp, #0x20
    c000582c:	d65f03c0 	ret

00000000c0005830 <topology_init>:

void topology_init(void)
{
    c0005830:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c0005834:	910003fd 	mov	x29, sp
	unsigned int i;
	uint64_t mpidr = topology_read_mpidr();
    c0005838:	97ffffd4 	bl	c0005788 <topology_read_mpidr>
    c000583c:	f9000be0 	str	x0, [sp, #16]

	for (i = 0U; i < PLAT_MAX_CPUS; ++i) {
    c0005840:	b9001fff 	str	wzr, [sp, #28]
    c0005844:	1400003b 	b	c0005930 <topology_init+0x100>
		cpu_descs[i].logical_id = i;
    c0005848:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c000584c:	91136001 	add	x1, x0, #0x4d8
    c0005850:	b9401fe0 	ldr	w0, [sp, #28]
    c0005854:	d37be800 	lsl	x0, x0, #5
    c0005858:	8b000020 	add	x0, x1, x0
    c000585c:	b9401fe1 	ldr	w1, [sp, #28]
    c0005860:	b9000801 	str	w1, [x0, #8]
		cpu_descs[i].present = false;
    c0005864:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0005868:	91136001 	add	x1, x0, #0x4d8
    c000586c:	b9401fe0 	ldr	w0, [sp, #28]
    c0005870:	d37be800 	lsl	x0, x0, #5
    c0005874:	8b000020 	add	x0, x1, x0
    c0005878:	3900741f 	strb	wzr, [x0, #29]
		cpu_descs[i].online = false;
    c000587c:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0005880:	91136001 	add	x1, x0, #0x4d8
    c0005884:	b9401fe0 	ldr	w0, [sp, #28]
    c0005888:	d37be800 	lsl	x0, x0, #5
    c000588c:	8b000020 	add	x0, x1, x0
    c0005890:	3900781f 	strb	wzr, [x0, #30]
		cpu_descs[i].boot_cpu = false;
    c0005894:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0005898:	91136001 	add	x1, x0, #0x4d8
    c000589c:	b9401fe0 	ldr	w0, [sp, #28]
    c00058a0:	d37be800 	lsl	x0, x0, #5
    c00058a4:	8b000020 	add	x0, x1, x0
    c00058a8:	3900701f 	strb	wzr, [x0, #28]
		cpu_descs[i].mpidr = 0U;
    c00058ac:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c00058b0:	91136001 	add	x1, x0, #0x4d8
    c00058b4:	b9401fe0 	ldr	w0, [sp, #28]
    c00058b8:	d37be800 	lsl	x0, x0, #5
    c00058bc:	8b000020 	add	x0, x1, x0
    c00058c0:	f900001f 	str	xzr, [x0]
		cpu_descs[i].chip_id = 0U;
    c00058c4:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c00058c8:	91136001 	add	x1, x0, #0x4d8
    c00058cc:	b9401fe0 	ldr	w0, [sp, #28]
    c00058d0:	d37be800 	lsl	x0, x0, #5
    c00058d4:	8b000020 	add	x0, x1, x0
    c00058d8:	b9000c1f 	str	wzr, [x0, #12]
		cpu_descs[i].die_id = 0U;
    c00058dc:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c00058e0:	91136001 	add	x1, x0, #0x4d8
    c00058e4:	b9401fe0 	ldr	w0, [sp, #28]
    c00058e8:	d37be800 	lsl	x0, x0, #5
    c00058ec:	8b000020 	add	x0, x1, x0
    c00058f0:	b900101f 	str	wzr, [x0, #16]
		cpu_descs[i].cluster_id = 0U;
    c00058f4:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c00058f8:	91136001 	add	x1, x0, #0x4d8
    c00058fc:	b9401fe0 	ldr	w0, [sp, #28]
    c0005900:	d37be800 	lsl	x0, x0, #5
    c0005904:	8b000020 	add	x0, x1, x0
    c0005908:	b900141f 	str	wzr, [x0, #20]
		cpu_descs[i].core_id = 0U;
    c000590c:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0005910:	91136001 	add	x1, x0, #0x4d8
    c0005914:	b9401fe0 	ldr	w0, [sp, #28]
    c0005918:	d37be800 	lsl	x0, x0, #5
    c000591c:	8b000020 	add	x0, x1, x0
    c0005920:	b900181f 	str	wzr, [x0, #24]
	for (i = 0U; i < PLAT_MAX_CPUS; ++i) {
    c0005924:	b9401fe0 	ldr	w0, [sp, #28]
    c0005928:	11000400 	add	w0, w0, #0x1
    c000592c:	b9001fe0 	str	w0, [sp, #28]
    c0005930:	b9401fe0 	ldr	w0, [sp, #28]
    c0005934:	71001c1f 	cmp	w0, #0x7
    c0005938:	54fff889 	b.ls	c0005848 <topology_init+0x18>  // b.plast
	}

	topology_fill_descriptor(&cpu_descs[0], 0U, mpidr, true);
    c000593c:	52800023 	mov	w3, #0x1                   	// #1
    c0005940:	f9400be2 	ldr	x2, [sp, #16]
    c0005944:	52800001 	mov	w1, #0x0                   	// #0
    c0005948:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c000594c:	91136000 	add	x0, x0, #0x4d8
    c0005950:	97ffff94 	bl	c00057a0 <topology_fill_descriptor>
	cpu_descs[0].present = true;
    c0005954:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0005958:	91136000 	add	x0, x0, #0x4d8
    c000595c:	52800021 	mov	w1, #0x1                   	// #1
    c0005960:	39007401 	strb	w1, [x0, #29]
	cpu_descs[0].online = true;
    c0005964:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0005968:	91136000 	add	x0, x0, #0x4d8
    c000596c:	52800021 	mov	w1, #0x1                   	// #1
    c0005970:	39007801 	strb	w1, [x0, #30]
	present_cpu_count = 1U;
    c0005974:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0005978:	91176000 	add	x0, x0, #0x5d8
    c000597c:	52800021 	mov	w1, #0x1                   	// #1
    c0005980:	b9000001 	str	w1, [x0]
	online_cpu_count = 1U;
    c0005984:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0005988:	91177000 	add	x0, x0, #0x5dc
    c000598c:	52800021 	mov	w1, #0x1                   	// #1
    c0005990:	b9000001 	str	w1, [x0]
}
    c0005994:	d503201f 	nop
    c0005998:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c000599c:	d65f03c0 	ret

00000000c00059a0 <topology_boot_cpu>:

const struct cpu_topology_descriptor *topology_boot_cpu(void)
{
	return &cpu_descs[0];
    c00059a0:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c00059a4:	91136000 	add	x0, x0, #0x4d8
}
    c00059a8:	d65f03c0 	ret

00000000c00059ac <topology_cpu>:

const struct cpu_topology_descriptor *topology_cpu(unsigned int logical_id)
{
    c00059ac:	d10043ff 	sub	sp, sp, #0x10
    c00059b0:	b9000fe0 	str	w0, [sp, #12]
	if (logical_id >= PLAT_MAX_CPUS) {
    c00059b4:	b9400fe0 	ldr	w0, [sp, #12]
    c00059b8:	71001c1f 	cmp	w0, #0x7
    c00059bc:	54000069 	b.ls	c00059c8 <topology_cpu+0x1c>  // b.plast
		return (const struct cpu_topology_descriptor *)0;
    c00059c0:	d2800000 	mov	x0, #0x0                   	// #0
    c00059c4:	14000006 	b	c00059dc <topology_cpu+0x30>
	}

	return &cpu_descs[logical_id];
    c00059c8:	b9400fe0 	ldr	w0, [sp, #12]
    c00059cc:	d37be801 	lsl	x1, x0, #5
    c00059d0:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c00059d4:	91136000 	add	x0, x0, #0x4d8
    c00059d8:	8b000020 	add	x0, x1, x0
}
    c00059dc:	910043ff 	add	sp, sp, #0x10
    c00059e0:	d65f03c0 	ret

00000000c00059e4 <topology_find_cpu_by_mpidr>:

const struct cpu_topology_descriptor *topology_find_cpu_by_mpidr(uint64_t mpidr)
{
    c00059e4:	d10083ff 	sub	sp, sp, #0x20
    c00059e8:	f90007e0 	str	x0, [sp, #8]
	unsigned int i;

	for (i = 0U; i < PLAT_MAX_CPUS; ++i) {
    c00059ec:	b9001fff 	str	wzr, [sp, #28]
    c00059f0:	1400001c 	b	c0005a60 <topology_find_cpu_by_mpidr+0x7c>
		if (cpu_descs[i].present && (cpu_descs[i].mpidr == mpidr)) {
    c00059f4:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c00059f8:	91136001 	add	x1, x0, #0x4d8
    c00059fc:	b9401fe0 	ldr	w0, [sp, #28]
    c0005a00:	d37be800 	lsl	x0, x0, #5
    c0005a04:	8b000020 	add	x0, x1, x0
    c0005a08:	39407400 	ldrb	w0, [x0, #29]
    c0005a0c:	12000000 	and	w0, w0, #0x1
    c0005a10:	7100001f 	cmp	w0, #0x0
    c0005a14:	54000200 	b.eq	c0005a54 <topology_find_cpu_by_mpidr+0x70>  // b.none
    c0005a18:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0005a1c:	91136001 	add	x1, x0, #0x4d8
    c0005a20:	b9401fe0 	ldr	w0, [sp, #28]
    c0005a24:	d37be800 	lsl	x0, x0, #5
    c0005a28:	8b000020 	add	x0, x1, x0
    c0005a2c:	f9400000 	ldr	x0, [x0]
    c0005a30:	f94007e1 	ldr	x1, [sp, #8]
    c0005a34:	eb00003f 	cmp	x1, x0
    c0005a38:	540000e1 	b.ne	c0005a54 <topology_find_cpu_by_mpidr+0x70>  // b.any
			return &cpu_descs[i];
    c0005a3c:	b9401fe0 	ldr	w0, [sp, #28]
    c0005a40:	d37be801 	lsl	x1, x0, #5
    c0005a44:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0005a48:	91136000 	add	x0, x0, #0x4d8
    c0005a4c:	8b000020 	add	x0, x1, x0
    c0005a50:	14000008 	b	c0005a70 <topology_find_cpu_by_mpidr+0x8c>
	for (i = 0U; i < PLAT_MAX_CPUS; ++i) {
    c0005a54:	b9401fe0 	ldr	w0, [sp, #28]
    c0005a58:	11000400 	add	w0, w0, #0x1
    c0005a5c:	b9001fe0 	str	w0, [sp, #28]
    c0005a60:	b9401fe0 	ldr	w0, [sp, #28]
    c0005a64:	71001c1f 	cmp	w0, #0x7
    c0005a68:	54fffc69 	b.ls	c00059f4 <topology_find_cpu_by_mpidr+0x10>  // b.plast
		}
	}

	return (const struct cpu_topology_descriptor *)0;
    c0005a6c:	d2800000 	mov	x0, #0x0                   	// #0
}
    c0005a70:	910083ff 	add	sp, sp, #0x20
    c0005a74:	d65f03c0 	ret

00000000c0005a78 <topology_cpu_capacity>:

unsigned int topology_cpu_capacity(void)
{
	return PLAT_MAX_CPUS;
    c0005a78:	52800100 	mov	w0, #0x8                   	// #8
}
    c0005a7c:	d65f03c0 	ret

00000000c0005a80 <topology_present_cpu_count>:

unsigned int topology_present_cpu_count(void)
{
	return present_cpu_count;
    c0005a80:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0005a84:	91176000 	add	x0, x0, #0x5d8
    c0005a88:	b9400000 	ldr	w0, [x0]
}
    c0005a8c:	d65f03c0 	ret

00000000c0005a90 <topology_online_cpu_count>:

unsigned int topology_online_cpu_count(void)
{
	return online_cpu_count;
    c0005a90:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0005a94:	91177000 	add	x0, x0, #0x5dc
    c0005a98:	b9400000 	ldr	w0, [x0]
}
    c0005a9c:	d65f03c0 	ret

00000000c0005aa0 <topology_mark_cpu_online>:

void topology_mark_cpu_online(unsigned int logical_id, bool online)
{
    c0005aa0:	d10043ff 	sub	sp, sp, #0x10
    c0005aa4:	b9000fe0 	str	w0, [sp, #12]
    c0005aa8:	39002fe1 	strb	w1, [sp, #11]
	if (logical_id >= PLAT_MAX_CPUS) {
    c0005aac:	b9400fe0 	ldr	w0, [sp, #12]
    c0005ab0:	71001c1f 	cmp	w0, #0x7
    c0005ab4:	54000b48 	b.hi	c0005c1c <topology_mark_cpu_online+0x17c>  // b.pmore
		return;
	}

	if (!cpu_descs[logical_id].present) {
    c0005ab8:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0005abc:	91136001 	add	x1, x0, #0x4d8
    c0005ac0:	b9400fe0 	ldr	w0, [sp, #12]
    c0005ac4:	d37be800 	lsl	x0, x0, #5
    c0005ac8:	8b000020 	add	x0, x1, x0
    c0005acc:	39407400 	ldrb	w0, [x0, #29]
    c0005ad0:	52000000 	eor	w0, w0, #0x1
    c0005ad4:	12001c00 	and	w0, w0, #0xff
    c0005ad8:	12000000 	and	w0, w0, #0x1
    c0005adc:	7100001f 	cmp	w0, #0x0
    c0005ae0:	540001e0 	b.eq	c0005b1c <topology_mark_cpu_online+0x7c>  // b.none
		cpu_descs[logical_id].present = true;
    c0005ae4:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0005ae8:	91136001 	add	x1, x0, #0x4d8
    c0005aec:	b9400fe0 	ldr	w0, [sp, #12]
    c0005af0:	d37be800 	lsl	x0, x0, #5
    c0005af4:	8b000020 	add	x0, x1, x0
    c0005af8:	52800021 	mov	w1, #0x1                   	// #1
    c0005afc:	39007401 	strb	w1, [x0, #29]
		present_cpu_count++;
    c0005b00:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0005b04:	91176000 	add	x0, x0, #0x5d8
    c0005b08:	b9400000 	ldr	w0, [x0]
    c0005b0c:	11000401 	add	w1, w0, #0x1
    c0005b10:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0005b14:	91176000 	add	x0, x0, #0x5d8
    c0005b18:	b9000001 	str	w1, [x0]
	}

	if (online && !cpu_descs[logical_id].online) {
    c0005b1c:	39402fe0 	ldrb	w0, [sp, #11]
    c0005b20:	12000000 	and	w0, w0, #0x1
    c0005b24:	7100001f 	cmp	w0, #0x0
    c0005b28:	54000360 	b.eq	c0005b94 <topology_mark_cpu_online+0xf4>  // b.none
    c0005b2c:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0005b30:	91136001 	add	x1, x0, #0x4d8
    c0005b34:	b9400fe0 	ldr	w0, [sp, #12]
    c0005b38:	d37be800 	lsl	x0, x0, #5
    c0005b3c:	8b000020 	add	x0, x1, x0
    c0005b40:	39407800 	ldrb	w0, [x0, #30]
    c0005b44:	52000000 	eor	w0, w0, #0x1
    c0005b48:	12001c00 	and	w0, w0, #0xff
    c0005b4c:	12000000 	and	w0, w0, #0x1
    c0005b50:	7100001f 	cmp	w0, #0x0
    c0005b54:	54000200 	b.eq	c0005b94 <topology_mark_cpu_online+0xf4>  // b.none
		cpu_descs[logical_id].online = true;
    c0005b58:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0005b5c:	91136001 	add	x1, x0, #0x4d8
    c0005b60:	b9400fe0 	ldr	w0, [sp, #12]
    c0005b64:	d37be800 	lsl	x0, x0, #5
    c0005b68:	8b000020 	add	x0, x1, x0
    c0005b6c:	52800021 	mov	w1, #0x1                   	// #1
    c0005b70:	39007801 	strb	w1, [x0, #30]
		online_cpu_count++;
    c0005b74:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0005b78:	91177000 	add	x0, x0, #0x5dc
    c0005b7c:	b9400000 	ldr	w0, [x0]
    c0005b80:	11000401 	add	w1, w0, #0x1
    c0005b84:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0005b88:	91177000 	add	x0, x0, #0x5dc
    c0005b8c:	b9000001 	str	w1, [x0]
    c0005b90:	14000024 	b	c0005c20 <topology_mark_cpu_online+0x180>
	} else if (!online && cpu_descs[logical_id].online) {
    c0005b94:	39402fe0 	ldrb	w0, [sp, #11]
    c0005b98:	52000000 	eor	w0, w0, #0x1
    c0005b9c:	12001c00 	and	w0, w0, #0xff
    c0005ba0:	12000000 	and	w0, w0, #0x1
    c0005ba4:	7100001f 	cmp	w0, #0x0
    c0005ba8:	540003c0 	b.eq	c0005c20 <topology_mark_cpu_online+0x180>  // b.none
    c0005bac:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0005bb0:	91136001 	add	x1, x0, #0x4d8
    c0005bb4:	b9400fe0 	ldr	w0, [sp, #12]
    c0005bb8:	d37be800 	lsl	x0, x0, #5
    c0005bbc:	8b000020 	add	x0, x1, x0
    c0005bc0:	39407800 	ldrb	w0, [x0, #30]
    c0005bc4:	12000000 	and	w0, w0, #0x1
    c0005bc8:	7100001f 	cmp	w0, #0x0
    c0005bcc:	540002a0 	b.eq	c0005c20 <topology_mark_cpu_online+0x180>  // b.none
		cpu_descs[logical_id].online = false;
    c0005bd0:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0005bd4:	91136001 	add	x1, x0, #0x4d8
    c0005bd8:	b9400fe0 	ldr	w0, [sp, #12]
    c0005bdc:	d37be800 	lsl	x0, x0, #5
    c0005be0:	8b000020 	add	x0, x1, x0
    c0005be4:	3900781f 	strb	wzr, [x0, #30]
		if (online_cpu_count > 0U) {
    c0005be8:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0005bec:	91177000 	add	x0, x0, #0x5dc
    c0005bf0:	b9400000 	ldr	w0, [x0]
    c0005bf4:	7100001f 	cmp	w0, #0x0
    c0005bf8:	54000140 	b.eq	c0005c20 <topology_mark_cpu_online+0x180>  // b.none
			online_cpu_count--;
    c0005bfc:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0005c00:	91177000 	add	x0, x0, #0x5dc
    c0005c04:	b9400000 	ldr	w0, [x0]
    c0005c08:	51000401 	sub	w1, w0, #0x1
    c0005c0c:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0005c10:	91177000 	add	x0, x0, #0x5dc
    c0005c14:	b9000001 	str	w1, [x0]
    c0005c18:	14000002 	b	c0005c20 <topology_mark_cpu_online+0x180>
		return;
    c0005c1c:	d503201f 	nop
		}
	}
}
    c0005c20:	910043ff 	add	sp, sp, #0x10
    c0005c24:	d65f03c0 	ret

00000000c0005c28 <topology_register_cpu>:

void topology_register_cpu(unsigned int logical_id, uint64_t mpidr, bool boot_cpu)
{
    c0005c28:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c0005c2c:	910003fd 	mov	x29, sp
    c0005c30:	b9001fe0 	str	w0, [sp, #28]
    c0005c34:	f9000be1 	str	x1, [sp, #16]
    c0005c38:	39006fe2 	strb	w2, [sp, #27]
	if (logical_id >= PLAT_MAX_CPUS) {
    c0005c3c:	b9401fe0 	ldr	w0, [sp, #28]
    c0005c40:	71001c1f 	cmp	w0, #0x7
    c0005c44:	54000548 	b.hi	c0005cec <topology_register_cpu+0xc4>  // b.pmore
		return;
	}

	if (!cpu_descs[logical_id].present) {
    c0005c48:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0005c4c:	91136001 	add	x1, x0, #0x4d8
    c0005c50:	b9401fe0 	ldr	w0, [sp, #28]
    c0005c54:	d37be800 	lsl	x0, x0, #5
    c0005c58:	8b000020 	add	x0, x1, x0
    c0005c5c:	39407400 	ldrb	w0, [x0, #29]
    c0005c60:	52000000 	eor	w0, w0, #0x1
    c0005c64:	12001c00 	and	w0, w0, #0xff
    c0005c68:	12000000 	and	w0, w0, #0x1
    c0005c6c:	7100001f 	cmp	w0, #0x0
    c0005c70:	54000100 	b.eq	c0005c90 <topology_register_cpu+0x68>  // b.none
		present_cpu_count++;
    c0005c74:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0005c78:	91176000 	add	x0, x0, #0x5d8
    c0005c7c:	b9400000 	ldr	w0, [x0]
    c0005c80:	11000401 	add	w1, w0, #0x1
    c0005c84:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0005c88:	91176000 	add	x0, x0, #0x5d8
    c0005c8c:	b9000001 	str	w1, [x0]
	}

	topology_fill_descriptor(&cpu_descs[logical_id], logical_id, mpidr, boot_cpu);
    c0005c90:	b9401fe0 	ldr	w0, [sp, #28]
    c0005c94:	d37be801 	lsl	x1, x0, #5
    c0005c98:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0005c9c:	91136000 	add	x0, x0, #0x4d8
    c0005ca0:	8b000020 	add	x0, x1, x0
    c0005ca4:	39406fe3 	ldrb	w3, [sp, #27]
    c0005ca8:	f9400be2 	ldr	x2, [sp, #16]
    c0005cac:	b9401fe1 	ldr	w1, [sp, #28]
    c0005cb0:	97fffebc 	bl	c00057a0 <topology_fill_descriptor>
	cpu_descs[logical_id].present = true;
    c0005cb4:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0005cb8:	91136001 	add	x1, x0, #0x4d8
    c0005cbc:	b9401fe0 	ldr	w0, [sp, #28]
    c0005cc0:	d37be800 	lsl	x0, x0, #5
    c0005cc4:	8b000020 	add	x0, x1, x0
    c0005cc8:	52800021 	mov	w1, #0x1                   	// #1
    c0005ccc:	39007401 	strb	w1, [x0, #29]
	cpu_descs[logical_id].online = false;
    c0005cd0:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0005cd4:	91136001 	add	x1, x0, #0x4d8
    c0005cd8:	b9401fe0 	ldr	w0, [sp, #28]
    c0005cdc:	d37be800 	lsl	x0, x0, #5
    c0005ce0:	8b000020 	add	x0, x1, x0
    c0005ce4:	3900781f 	strb	wzr, [x0, #30]
    c0005ce8:	14000002 	b	c0005cf0 <topology_register_cpu+0xc8>
		return;
    c0005cec:	d503201f 	nop
}
    c0005cf0:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c0005cf4:	d65f03c0 	ret

00000000c0005cf8 <topology_unregister_cpu>:

void topology_unregister_cpu(unsigned int logical_id)
{
    c0005cf8:	d10043ff 	sub	sp, sp, #0x10
    c0005cfc:	b9000fe0 	str	w0, [sp, #12]
	if (logical_id >= PLAT_MAX_CPUS) {
    c0005d00:	b9400fe0 	ldr	w0, [sp, #12]
    c0005d04:	71001c1f 	cmp	w0, #0x7
    c0005d08:	54000c68 	b.hi	c0005e94 <topology_unregister_cpu+0x19c>  // b.pmore
		return;
	}

	if (cpu_descs[logical_id].online) {
    c0005d0c:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0005d10:	91136001 	add	x1, x0, #0x4d8
    c0005d14:	b9400fe0 	ldr	w0, [sp, #12]
    c0005d18:	d37be800 	lsl	x0, x0, #5
    c0005d1c:	8b000020 	add	x0, x1, x0
    c0005d20:	39407800 	ldrb	w0, [x0, #30]
    c0005d24:	12000000 	and	w0, w0, #0x1
    c0005d28:	7100001f 	cmp	w0, #0x0
    c0005d2c:	54000260 	b.eq	c0005d78 <topology_unregister_cpu+0x80>  // b.none
		cpu_descs[logical_id].online = false;
    c0005d30:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0005d34:	91136001 	add	x1, x0, #0x4d8
    c0005d38:	b9400fe0 	ldr	w0, [sp, #12]
    c0005d3c:	d37be800 	lsl	x0, x0, #5
    c0005d40:	8b000020 	add	x0, x1, x0
    c0005d44:	3900781f 	strb	wzr, [x0, #30]
		if (online_cpu_count > 0U) {
    c0005d48:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0005d4c:	91177000 	add	x0, x0, #0x5dc
    c0005d50:	b9400000 	ldr	w0, [x0]
    c0005d54:	7100001f 	cmp	w0, #0x0
    c0005d58:	54000100 	b.eq	c0005d78 <topology_unregister_cpu+0x80>  // b.none
			online_cpu_count--;
    c0005d5c:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0005d60:	91177000 	add	x0, x0, #0x5dc
    c0005d64:	b9400000 	ldr	w0, [x0]
    c0005d68:	51000401 	sub	w1, w0, #0x1
    c0005d6c:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0005d70:	91177000 	add	x0, x0, #0x5dc
    c0005d74:	b9000001 	str	w1, [x0]
		}
	}

	if (cpu_descs[logical_id].present) {
    c0005d78:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0005d7c:	91136001 	add	x1, x0, #0x4d8
    c0005d80:	b9400fe0 	ldr	w0, [sp, #12]
    c0005d84:	d37be800 	lsl	x0, x0, #5
    c0005d88:	8b000020 	add	x0, x1, x0
    c0005d8c:	39407400 	ldrb	w0, [x0, #29]
    c0005d90:	12000000 	and	w0, w0, #0x1
    c0005d94:	7100001f 	cmp	w0, #0x0
    c0005d98:	54000260 	b.eq	c0005de4 <topology_unregister_cpu+0xec>  // b.none
		cpu_descs[logical_id].present = false;
    c0005d9c:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0005da0:	91136001 	add	x1, x0, #0x4d8
    c0005da4:	b9400fe0 	ldr	w0, [sp, #12]
    c0005da8:	d37be800 	lsl	x0, x0, #5
    c0005dac:	8b000020 	add	x0, x1, x0
    c0005db0:	3900741f 	strb	wzr, [x0, #29]
		if (present_cpu_count > 0U) {
    c0005db4:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0005db8:	91176000 	add	x0, x0, #0x5d8
    c0005dbc:	b9400000 	ldr	w0, [x0]
    c0005dc0:	7100001f 	cmp	w0, #0x0
    c0005dc4:	54000100 	b.eq	c0005de4 <topology_unregister_cpu+0xec>  // b.none
			present_cpu_count--;
    c0005dc8:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0005dcc:	91176000 	add	x0, x0, #0x5d8
    c0005dd0:	b9400000 	ldr	w0, [x0]
    c0005dd4:	51000401 	sub	w1, w0, #0x1
    c0005dd8:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0005ddc:	91176000 	add	x0, x0, #0x5d8
    c0005de0:	b9000001 	str	w1, [x0]
		}
	}

	cpu_descs[logical_id].logical_id = logical_id;
    c0005de4:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0005de8:	91136001 	add	x1, x0, #0x4d8
    c0005dec:	b9400fe0 	ldr	w0, [sp, #12]
    c0005df0:	d37be800 	lsl	x0, x0, #5
    c0005df4:	8b000020 	add	x0, x1, x0
    c0005df8:	b9400fe1 	ldr	w1, [sp, #12]
    c0005dfc:	b9000801 	str	w1, [x0, #8]
	cpu_descs[logical_id].boot_cpu = false;
    c0005e00:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0005e04:	91136001 	add	x1, x0, #0x4d8
    c0005e08:	b9400fe0 	ldr	w0, [sp, #12]
    c0005e0c:	d37be800 	lsl	x0, x0, #5
    c0005e10:	8b000020 	add	x0, x1, x0
    c0005e14:	3900701f 	strb	wzr, [x0, #28]
	cpu_descs[logical_id].mpidr = 0U;
    c0005e18:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0005e1c:	91136001 	add	x1, x0, #0x4d8
    c0005e20:	b9400fe0 	ldr	w0, [sp, #12]
    c0005e24:	d37be800 	lsl	x0, x0, #5
    c0005e28:	8b000020 	add	x0, x1, x0
    c0005e2c:	f900001f 	str	xzr, [x0]
	cpu_descs[logical_id].chip_id = 0U;
    c0005e30:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0005e34:	91136001 	add	x1, x0, #0x4d8
    c0005e38:	b9400fe0 	ldr	w0, [sp, #12]
    c0005e3c:	d37be800 	lsl	x0, x0, #5
    c0005e40:	8b000020 	add	x0, x1, x0
    c0005e44:	b9000c1f 	str	wzr, [x0, #12]
	cpu_descs[logical_id].die_id = 0U;
    c0005e48:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0005e4c:	91136001 	add	x1, x0, #0x4d8
    c0005e50:	b9400fe0 	ldr	w0, [sp, #12]
    c0005e54:	d37be800 	lsl	x0, x0, #5
    c0005e58:	8b000020 	add	x0, x1, x0
    c0005e5c:	b900101f 	str	wzr, [x0, #16]
	cpu_descs[logical_id].cluster_id = 0U;
    c0005e60:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0005e64:	91136001 	add	x1, x0, #0x4d8
    c0005e68:	b9400fe0 	ldr	w0, [sp, #12]
    c0005e6c:	d37be800 	lsl	x0, x0, #5
    c0005e70:	8b000020 	add	x0, x1, x0
    c0005e74:	b900141f 	str	wzr, [x0, #20]
	cpu_descs[logical_id].core_id = 0U;
    c0005e78:	d0000100 	adrp	x0, c0027000 <secondary_stacks+0x1fbf0>
    c0005e7c:	91136001 	add	x1, x0, #0x4d8
    c0005e80:	b9400fe0 	ldr	w0, [sp, #12]
    c0005e84:	d37be800 	lsl	x0, x0, #5
    c0005e88:	8b000020 	add	x0, x1, x0
    c0005e8c:	b900181f 	str	wzr, [x0, #24]
    c0005e90:	14000002 	b	c0005e98 <topology_unregister_cpu+0x1a0>
		return;
    c0005e94:	d503201f 	nop
    c0005e98:	910043ff 	add	sp, sp, #0x10
    c0005e9c:	d65f03c0 	ret
