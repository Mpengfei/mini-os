
/home/pengfei/felix-os/mini-os/build/Neoverse-N3/debug/mini-os.elf:     file format elf64-littleaarch64


Disassembly of section .text:

00000000c0000000 <_start>:
    c0000000:	580000c0 	ldr	x0, c0000018 <_start+0x18>
    c0000004:	9100001f 	mov	sp, x0
    c0000008:	94000978 	bl	c00025e8 <kernel_main>
    c000000c:	d503205f 	wfe
    c0000010:	17ffffff 	b	c000000c <_start+0xc>
    c0000014:	00000000 	udf	#0
    c0000018:	c002ce60 	.word	0xc002ce60
    c000001c:	00000000 	.word	0x00000000

00000000c0000020 <secondary_cpu_entrypoint>:
    c0000020:	58000101 	ldr	x1, c0000040 <secondary_cpu_entrypoint+0x20>
    c0000024:	58000122 	ldr	x2, c0000048 <secondary_cpu_entrypoint+0x28>
    c0000028:	9b020401 	madd	x1, x0, x2, x1
    c000002c:	8b020021 	add	x1, x1, x2
    c0000030:	9100003f 	mov	sp, x1
    c0000034:	94001846 	bl	c000614c <smp_secondary_entry>
    c0000038:	d503205f 	wfe
    c000003c:	17ffffff 	b	c0000038 <secondary_cpu_entrypoint+0x18>
    c0000040:	c00082d0 	.word	0xc00082d0
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
    c0000a18:	d0000020 	adrp	x0, c0006000 <smp_cpu_state+0x4>
    c0000a1c:	9125e000 	add	x0, x0, #0x978
    c0000a20:	14000003 	b	c0000a2c <u64_to_str+0x38>
    c0000a24:	d0000020 	adrp	x0, c0006000 <smp_cpu_state+0x4>
    c0000a28:	91264000 	add	x0, x0, #0x990
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
    c0000eec:	d0000020 	adrp	x0, c0006000 <smp_cpu_state+0x4>
    c0000ef0:	9125c000 	add	x0, x0, #0x970
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
    c000163c:	f0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c0001640:	91080000 	add	x0, x0, #0x200
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
    c0001bfc:	f0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c0001c00:	91080000 	add	x0, x0, #0x200
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
    c0001d88:	f0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c0001d8c:	91080000 	add	x0, x0, #0x200
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
    c0001db0:	f0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c0001db4:	91080000 	add	x0, x0, #0x200
    c0001db8:	94000392 	bl	c0002c00 <spinlock_lock>
	uart_putc(ch);
    c0001dbc:	b9401fe0 	ldr	w0, [sp, #28]
    c0001dc0:	9400012b 	bl	c000226c <uart_putc>
	spinlock_unlock(&debug_console_lock);
    c0001dc4:	f0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c0001dc8:	91080000 	add	x0, x0, #0x200
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
    c0001de8:	f0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c0001dec:	91080000 	add	x0, x0, #0x200
    c0001df0:	94000384 	bl	c0002c00 <spinlock_lock>
	uart_puts(str);
    c0001df4:	f9400fe0 	ldr	x0, [sp, #24]
    c0001df8:	94000138 	bl	c00022d8 <uart_puts>
	spinlock_unlock(&debug_console_lock);
    c0001dfc:	f0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c0001e00:	91080000 	add	x0, x0, #0x200
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
    c0001e24:	f0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c0001e28:	91080000 	add	x0, x0, #0x200
    c0001e2c:	94000375 	bl	c0002c00 <spinlock_lock>
	uart_write(buf, len);
    c0001e30:	f9400be1 	ldr	x1, [sp, #16]
    c0001e34:	f9400fe0 	ldr	x0, [sp, #24]
    c0001e38:	94000142 	bl	c0002340 <uart_write>
	spinlock_unlock(&debug_console_lock);
    c0001e3c:	f0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c0001e40:	91080000 	add	x0, x0, #0x200
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
    c0001e88:	f0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c0001e8c:	91080000 	add	x0, x0, #0x200
    c0001e90:	9400035c 	bl	c0002c00 <spinlock_lock>
	uart_put_hex64(value);
    c0001e94:	f9400fe0 	ldr	x0, [sp, #24]
    c0001e98:	94000168 	bl	c0002438 <uart_put_hex64>
	spinlock_unlock(&debug_console_lock);
    c0001e9c:	f0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c0001ea0:	91080000 	add	x0, x0, #0x200
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
    c0001ebc:	f0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c0001ec0:	91080000 	add	x0, x0, #0x200
    c0001ec4:	9400034f 	bl	c0002c00 <spinlock_lock>
	uart_flush();
    c0001ec8:	94000174 	bl	c0002498 <uart_flush>
	spinlock_unlock(&debug_console_lock);
    c0001ecc:	f0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c0001ed0:	91080000 	add	x0, x0, #0x200
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
    c0002024:	d0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c0002028:	91078000 	add	x0, x0, #0x1e0
    c000202c:	f9400000 	ldr	x0, [x0]
	       (plat_uart.clock_hz != 0U) &&
    c0002030:	f100001f 	cmp	x0, #0x0
    c0002034:	540001a0 	b.eq	c0002068 <uart_is_configured+0x44>  // b.none
    c0002038:	d0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c000203c:	91078000 	add	x0, x0, #0x1e0
    c0002040:	b9400800 	ldr	w0, [x0, #8]
	return (plat_uart.base != 0UL) &&
    c0002044:	7100001f 	cmp	w0, #0x0
    c0002048:	54000100 	b.eq	c0002068 <uart_is_configured+0x44>  // b.none
	       (plat_uart.baudrate != 0U);
    c000204c:	d0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c0002050:	91078000 	add	x0, x0, #0x1e0
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
    c00020a4:	d0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c00020a8:	91078000 	add	x0, x0, #0x1e0
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
    c00020fc:	d0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c0002100:	91078000 	add	x0, x0, #0x1e0
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
    c000214c:	d0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c0002150:	91078000 	add	x0, x0, #0x1e0
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
    c0002170:	d0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c0002174:	91078000 	add	x0, x0, #0x1e0
    c0002178:	f9400000 	ldr	x0, [x0]
    c000217c:	91006000 	add	x0, x0, #0x18
    c0002180:	97ffff62 	bl	c0001f08 <mmio_read_32>
    c0002184:	121d0000 	and	w0, w0, #0x8
    c0002188:	7100001f 	cmp	w0, #0x0
    c000218c:	54ffff21 	b.ne	c0002170 <uart_init+0x48>  // b.any
	}

	mmio_write_32(plat_uart.base + PL011_ICR, PL011_ICR_ALL);
    c0002190:	d0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c0002194:	91078000 	add	x0, x0, #0x1e0
    c0002198:	f9400000 	ldr	x0, [x0]
    c000219c:	91011000 	add	x0, x0, #0x44
    c00021a0:	5280ffe1 	mov	w1, #0x7ff                 	// #2047
    c00021a4:	97ffff50 	bl	c0001ee4 <mmio_write_32>
	mmio_write_32(plat_uart.base + PL011_IMSC, 0U);
    c00021a8:	d0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c00021ac:	91078000 	add	x0, x0, #0x1e0
    c00021b0:	f9400000 	ldr	x0, [x0]
    c00021b4:	9100e000 	add	x0, x0, #0x38
    c00021b8:	52800001 	mov	w1, #0x0                   	// #0
    c00021bc:	97ffff4a 	bl	c0001ee4 <mmio_write_32>

	pl011_calc_baud(plat_uart.clock_hz, plat_uart.baudrate, &ibrd, &fbrd);
    c00021c0:	d0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c00021c4:	91078000 	add	x0, x0, #0x1e0
    c00021c8:	b9400804 	ldr	w4, [x0, #8]
    c00021cc:	d0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c00021d0:	91078000 	add	x0, x0, #0x1e0
    c00021d4:	b9400c00 	ldr	w0, [x0, #12]
    c00021d8:	910063e2 	add	x2, sp, #0x18
    c00021dc:	910073e1 	add	x1, sp, #0x1c
    c00021e0:	aa0203e3 	mov	x3, x2
    c00021e4:	aa0103e2 	mov	x2, x1
    c00021e8:	2a0003e1 	mov	w1, w0
    c00021ec:	2a0403e0 	mov	w0, w4
    c00021f0:	97ffff52 	bl	c0001f38 <pl011_calc_baud>
	mmio_write_32(plat_uart.base + PL011_IBRD, ibrd);
    c00021f4:	d0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c00021f8:	91078000 	add	x0, x0, #0x1e0
    c00021fc:	f9400000 	ldr	x0, [x0]
    c0002200:	91009000 	add	x0, x0, #0x24
    c0002204:	b9401fe1 	ldr	w1, [sp, #28]
    c0002208:	97ffff37 	bl	c0001ee4 <mmio_write_32>
	mmio_write_32(plat_uart.base + PL011_FBRD, fbrd);
    c000220c:	d0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c0002210:	91078000 	add	x0, x0, #0x1e0
    c0002214:	f9400000 	ldr	x0, [x0]
    c0002218:	9100a000 	add	x0, x0, #0x28
    c000221c:	b9401be1 	ldr	w1, [sp, #24]
    c0002220:	97ffff31 	bl	c0001ee4 <mmio_write_32>
	mmio_write_32(plat_uart.base + PL011_LCRH, LCRH_WLEN_8 | LCRH_FEN);
    c0002224:	d0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c0002228:	91078000 	add	x0, x0, #0x1e0
    c000222c:	f9400000 	ldr	x0, [x0]
    c0002230:	9100b000 	add	x0, x0, #0x2c
    c0002234:	52800e01 	mov	w1, #0x70                  	// #112
    c0002238:	97ffff2b 	bl	c0001ee4 <mmio_write_32>
	mmio_write_32(plat_uart.base + PL011_CR, CR_UARTEN | CR_TXE | CR_RXE);
    c000223c:	d0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c0002240:	91078000 	add	x0, x0, #0x1e0
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
    c00022b4:	d0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c00022b8:	91078000 	add	x0, x0, #0x1e0
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
    c00023d0:	d0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c00023d4:	91078000 	add	x0, x0, #0x1e0
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
    c0002460:	90000021 	adrp	x1, c0006000 <smp_cpu_state+0x4>
    c0002464:	9126a021 	add	x1, x1, #0x9a8
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
    c00024c0:	d0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c00024c4:	91078000 	add	x0, x0, #0x1e0
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
    c0002500:	90000020 	adrp	x0, c0006000 <smp_cpu_state+0x4>
    c0002504:	91270000 	add	x0, x0, #0x9c0
    c0002508:	97fffe35 	bl	c0001ddc <debug_puts>
    debug_puts("============================================================\n");
    c000250c:	90000020 	adrp	x0, c0006000 <smp_cpu_state+0x4>
    c0002510:	91272000 	add	x0, x0, #0x9c8
    c0002514:	97fffe32 	bl	c0001ddc <debug_puts>
    debug_puts("            __  __   ___   _   _   ___    ___    ____      \n");
    c0002518:	90000020 	adrp	x0, c0006000 <smp_cpu_state+0x4>
    c000251c:	91282000 	add	x0, x0, #0xa08
    c0002520:	97fffe2f 	bl	c0001ddc <debug_puts>
    debug_puts("           |  \\/  | |_ _| | \\ | | |_ _|  / _ \\  / ___|     \n");
    c0002524:	90000020 	adrp	x0, c0006000 <smp_cpu_state+0x4>
    c0002528:	91292000 	add	x0, x0, #0xa48
    c000252c:	97fffe2c 	bl	c0001ddc <debug_puts>
    debug_puts("           | |\\/| |  | |  |  \\| |  | |  | | | | \\___ \\     \n");
    c0002530:	90000020 	adrp	x0, c0006000 <smp_cpu_state+0x4>
    c0002534:	912a2000 	add	x0, x0, #0xa88
    c0002538:	97fffe29 	bl	c0001ddc <debug_puts>
    debug_puts("           | |  | |  | |  | |\\  |  | |  | |_| |  ___) |    \n");
    c000253c:	90000020 	adrp	x0, c0006000 <smp_cpu_state+0x4>
    c0002540:	912b2000 	add	x0, x0, #0xac8
    c0002544:	97fffe26 	bl	c0001ddc <debug_puts>
    debug_puts("           |_|  |_| |___| |_| \\_| |___|  \\___/  |____/     \n");
    c0002548:	90000020 	adrp	x0, c0006000 <smp_cpu_state+0x4>
    c000254c:	912c2000 	add	x0, x0, #0xb08
    c0002550:	97fffe23 	bl	c0001ddc <debug_puts>
    debug_puts("============================================================\n");
    c0002554:	90000020 	adrp	x0, c0006000 <smp_cpu_state+0x4>
    c0002558:	91272000 	add	x0, x0, #0x9c8
    c000255c:	97fffe20 	bl	c0001ddc <debug_puts>
    debug_puts("                     2026  Mini-OS  V0.1                    \n");
    c0002560:	90000020 	adrp	x0, c0006000 <smp_cpu_state+0x4>
    c0002564:	912d2000 	add	x0, x0, #0xb48
    c0002568:	97fffe1d 	bl	c0001ddc <debug_puts>
    debug_puts("============================================================\n");
    c000256c:	90000020 	adrp	x0, c0006000 <smp_cpu_state+0x4>
    c0002570:	91272000 	add	x0, x0, #0x9c8
    c0002574:	97fffe1a 	bl	c0001ddc <debug_puts>
    debug_puts("\n");
    c0002578:	90000020 	adrp	x0, c0006000 <smp_cpu_state+0x4>
    c000257c:	91270000 	add	x0, x0, #0x9c0
    c0002580:	97fffe17 	bl	c0001ddc <debug_puts>

    mini_os_printf("UART ready @ 0x%llx, boot magic: 0x%llx\n\n",
    c0002584:	d0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c0002588:	9107c000 	add	x0, x0, #0x1f0
    c000258c:	f9400000 	ldr	x0, [x0]
    c0002590:	aa0003e2 	mov	x2, x0
    c0002594:	d2a34801 	mov	x1, #0x1a400000            	// #440401920
    c0002598:	90000020 	adrp	x0, c0006000 <smp_cpu_state+0x4>
    c000259c:	912e2000 	add	x0, x0, #0xb88
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
    c00025c0:	94000f4d 	bl	c00062f4 <topology_init>
	scheduler_init();
    c00025c4:	9400033e 	bl	c00032bc <scheduler_init>
	scheduler_join_cpu(0U);
    c00025c8:	52800000 	mov	w0, #0x0                   	// #0
    c00025cc:	9400036d 	bl	c0003380 <scheduler_join_cpu>
	smp_init();
    c00025d0:	94000c6f 	bl	c000578c <smp_init>
	gic_init();
    c00025d4:	97ffffc7 	bl	c00024f0 <gic_init>
	test_framework_init();
    c00025d8:	94000f1b 	bl	c0006244 <test_framework_init>
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
    c00025f8:	94000a25 	bl	c0004e8c <shell_run>
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
    c00029a8:	94000ec0 	bl	c00064a8 <topology_find_cpu_by_mpidr>
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
    c0002e64:	d0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c0002e68:	91096000 	add	x0, x0, #0x258
    c0002e6c:	f9400be1 	ldr	x1, [sp, #16]
    c0002e70:	f9000001 	str	x1, [x0]
	last_allocation_base = current;
    c0002e74:	d0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c0002e78:	91098000 	add	x0, x0, #0x260
    c0002e7c:	f94027e1 	ldr	x1, [sp, #72]
    c0002e80:	f9000001 	str	x1, [x0]
	last_allocation_size = size;
    c0002e84:	d0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c0002e88:	9109a000 	add	x0, x0, #0x268
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
    c0002ea8:	d0000140 	adrp	x0, c002c000 <__bss_end+0x31a0>
    c0002eac:	913a0001 	add	x1, x0, #0xe80
    c0002eb0:	d0000240 	adrp	x0, c004c000 <__heap_start+0x1f180>
    c0002eb4:	913a0000 	add	x0, x0, #0xe80
    c0002eb8:	aa0003e3 	mov	x3, x0
    c0002ebc:	aa0103e2 	mov	x2, x1
    c0002ec0:	90000020 	adrp	x0, c0006000 <smp_cpu_state+0x4>
    c0002ec4:	912ee001 	add	x1, x0, #0xbb8
    c0002ec8:	d0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c0002ecc:	9108a000 	add	x0, x0, #0x228
    c0002ed0:	97ffff8c 	bl	c0002d00 <early_mm_region_init>
			     (uintptr_t)__heap_start,
			     (uintptr_t)__heap_end);
	last_allocation_tag = (const char *)0;
    c0002ed4:	d0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c0002ed8:	91096000 	add	x0, x0, #0x258
    c0002edc:	f900001f 	str	xzr, [x0]
	last_allocation_base = 0U;
    c0002ee0:	d0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c0002ee4:	91098000 	add	x0, x0, #0x260
    c0002ee8:	f900001f 	str	xzr, [x0]
	last_allocation_size = 0U;
    c0002eec:	d0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c0002ef0:	9109a000 	add	x0, x0, #0x268
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
    c0002f14:	90000020 	adrp	x0, c0006000 <smp_cpu_state+0x4>
    c0002f18:	912f2002 	add	x2, x0, #0xbc8
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
    c0002f50:	d0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c0002f54:	9108a000 	add	x0, x0, #0x228
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
    c0002fa4:	d0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c0002fa8:	9108a000 	add	x0, x0, #0x228
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
    c0002fc4:	d0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c0002fc8:	9108a000 	add	x0, x0, #0x228
    c0002fcc:	f9400001 	ldr	x1, [x0]
    c0002fd0:	f94007e0 	ldr	x0, [sp, #8]
    c0002fd4:	f9000001 	str	x1, [x0]
	stats->start = boot_heap_region.start;
    c0002fd8:	d0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c0002fdc:	9108a000 	add	x0, x0, #0x228
    c0002fe0:	f9400401 	ldr	x1, [x0, #8]
    c0002fe4:	f94007e0 	ldr	x0, [sp, #8]
    c0002fe8:	f9000401 	str	x1, [x0, #8]
	stats->current = boot_heap_region.current;
    c0002fec:	d0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c0002ff0:	9108a000 	add	x0, x0, #0x228
    c0002ff4:	f9400801 	ldr	x1, [x0, #16]
    c0002ff8:	f94007e0 	ldr	x0, [sp, #8]
    c0002ffc:	f9000801 	str	x1, [x0, #16]
	stats->end = boot_heap_region.end;
    c0003000:	b0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c0003004:	9108a000 	add	x0, x0, #0x228
    c0003008:	f9400c01 	ldr	x1, [x0, #24]
    c000300c:	f94007e0 	ldr	x0, [sp, #8]
    c0003010:	f9000c01 	str	x1, [x0, #24]
	stats->total_bytes = (size_t)(boot_heap_region.end - boot_heap_region.start);
    c0003014:	b0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c0003018:	9108a000 	add	x0, x0, #0x228
    c000301c:	f9400c01 	ldr	x1, [x0, #24]
    c0003020:	b0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c0003024:	9108a000 	add	x0, x0, #0x228
    c0003028:	f9400400 	ldr	x0, [x0, #8]
    c000302c:	cb000021 	sub	x1, x1, x0
    c0003030:	f94007e0 	ldr	x0, [sp, #8]
    c0003034:	f9001001 	str	x1, [x0, #32]
	stats->used_bytes = (size_t)(boot_heap_region.current - boot_heap_region.start);
    c0003038:	b0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c000303c:	9108a000 	add	x0, x0, #0x228
    c0003040:	f9400801 	ldr	x1, [x0, #16]
    c0003044:	b0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c0003048:	9108a000 	add	x0, x0, #0x228
    c000304c:	f9400400 	ldr	x0, [x0, #8]
    c0003050:	cb000021 	sub	x1, x1, x0
    c0003054:	f94007e0 	ldr	x0, [sp, #8]
    c0003058:	f9001401 	str	x1, [x0, #40]
	stats->free_bytes = (size_t)(boot_heap_region.end - boot_heap_region.current);
    c000305c:	b0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c0003060:	9108a000 	add	x0, x0, #0x228
    c0003064:	f9400c01 	ldr	x1, [x0, #24]
    c0003068:	b0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c000306c:	9108a000 	add	x0, x0, #0x228
    c0003070:	f9400800 	ldr	x0, [x0, #16]
    c0003074:	cb000021 	sub	x1, x1, x0
    c0003078:	f94007e0 	ldr	x0, [sp, #8]
    c000307c:	f9001801 	str	x1, [x0, #48]
	stats->peak_used_bytes = boot_heap_region.peak_used_bytes;
    c0003080:	b0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c0003084:	9108a000 	add	x0, x0, #0x228
    c0003088:	f9401401 	ldr	x1, [x0, #40]
    c000308c:	f94007e0 	ldr	x0, [sp, #8]
    c0003090:	f9001c01 	str	x1, [x0, #56]
	stats->allocation_count = boot_heap_region.allocation_count;
    c0003094:	b0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c0003098:	9108a000 	add	x0, x0, #0x228
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
    c00030d4:	f0000000 	adrp	x0, c0006000 <smp_cpu_state+0x4>
    c00030d8:	912f4002 	add	x2, x0, #0xbd0
    c00030dc:	f9400be1 	ldr	x1, [sp, #16]
    c00030e0:	f9400fe0 	ldr	x0, [sp, #24]
    c00030e4:	97ffff93 	bl	c0002f30 <early_mm_alloc>
    c00030e8:	f90017e0 	str	x0, [sp, #40]

	if (ptr != (void *)0) {
    c00030ec:	f94017e0 	ldr	x0, [sp, #40]
    c00030f0:	f100001f 	cmp	x0, #0x0
    c00030f4:	54000100 	b.eq	c0003114 <scheduler_alloc_zeroed+0x50>  // b.none
		scheduler_object_count++;
    c00030f8:	b0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c00030fc:	910b0000 	add	x0, x0, #0x2c0
    c0003100:	f9400000 	ldr	x0, [x0]
    c0003104:	91000401 	add	x1, x0, #0x1
    c0003108:	b0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c000310c:	910b0000 	add	x0, x0, #0x2c0
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
    c0003150:	f0000000 	adrp	x0, c0006000 <smp_cpu_state+0x4>
    c0003154:	912fa001 	add	x1, x0, #0xbe8
    c0003158:	d2800080 	mov	x0, #0x4                   	// #4
    c000315c:	97ffff82 	bl	c0002f64 <early_mm_alloc_pages>
    c0003160:	f90013e0 	str	x0, [sp, #32]
			    "scheduler-idle-stack");
	if (stack != (void *)0) {
    c0003164:	f94013e0 	ldr	x0, [sp, #32]
    c0003168:	f100001f 	cmp	x0, #0x0
    c000316c:	54000100 	b.eq	c000318c <scheduler_create_idle_task+0x6c>  // b.none
		scheduler_object_count++;
    c0003170:	b0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c0003174:	910b0000 	add	x0, x0, #0x2c0
    c0003178:	f9400000 	ldr	x0, [x0]
    c000317c:	91000401 	add	x1, x0, #0x1
    c0003180:	b0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c0003184:	910b0000 	add	x0, x0, #0x2c0
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
    c000329c:	b0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c00032a0:	910a0000 	add	x0, x0, #0x280
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
    c00032cc:	b0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c00032d0:	9109c000 	add	x0, x0, #0x270
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
    c00032fc:	b0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c0003300:	910a0000 	add	x0, x0, #0x280
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
    c0003324:	b0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c0003328:	9109e000 	add	x0, x0, #0x278
    c000332c:	b900001f 	str	wzr, [x0]
	scheduler_object_count = 0U;
    c0003330:	b0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c0003334:	910b0000 	add	x0, x0, #0x2c0
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
    c0003398:	b0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c000339c:	910a0000 	add	x0, x0, #0x280
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
    c00033c8:	b0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c00033cc:	9109c000 	add	x0, x0, #0x270
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
    c00033f4:	b0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c00033f8:	9109c000 	add	x0, x0, #0x270
    c00033fc:	97fffc83 	bl	c0002608 <bitmap_set_bit>
		runnable_cpu_count++;
    c0003400:	b0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c0003404:	9109e000 	add	x0, x0, #0x278
    c0003408:	b9400000 	ldr	w0, [x0]
    c000340c:	11000401 	add	w1, w0, #0x1
    c0003410:	b0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c0003414:	9109e000 	add	x0, x0, #0x278
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
    c0003448:	b0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c000344c:	9109c000 	add	x0, x0, #0x270
    c0003450:	97fffc99 	bl	c00026b4 <bitmap_test_bit>
    c0003454:	12001c00 	and	w0, w0, #0xff
}
    c0003458:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c000345c:	d65f03c0 	ret

00000000c0003460 <scheduler_runnable_cpu_count>:

unsigned int scheduler_runnable_cpu_count(void)
{
	return runnable_cpu_count;
    c0003460:	b0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c0003464:	9109e000 	add	x0, x0, #0x278
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
    c000348c:	b0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c0003490:	910a0000 	add	x0, x0, #0x280
    c0003494:	b9400fe1 	ldr	w1, [sp, #12]
    c0003498:	f8617800 	ldr	x0, [x0, x1, lsl #3]
}
    c000349c:	910043ff 	add	sp, sp, #0x10
    c00034a0:	d65f03c0 	ret

00000000c00034a4 <scheduler_bootstrap_object_count>:

size_t scheduler_bootstrap_object_count(void)
{
	return scheduler_object_count;
    c00034a4:	b0000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c00034a8:	910b0000 	add	x0, x0, #0x2c0
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
    c00038c4:	94000aeb 	bl	c0006470 <topology_cpu>
    c00038c8:	f90027e0 	str	x0, [sp, #72]
	const struct smp_cpu_state *state = smp_cpu_state(logical_id);
    c00038cc:	b9403fe0 	ldr	w0, [sp, #60]
    c00038d0:	940009cb 	bl	c0005ffc <smp_cpu_state>
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
    c0003950:	f0000000 	adrp	x0, c0006000 <smp_cpu_state+0x4>
    c0003954:	91300003 	add	x3, x0, #0xc00
    c0003958:	14000003 	b	c0003964 <shell_print_cpu_entry+0xb4>
    c000395c:	f0000000 	adrp	x0, c0006000 <smp_cpu_state+0x4>
    c0003960:	91302003 	add	x3, x0, #0xc08
		       state->scheduled ? "yes" : "no",
    c0003964:	f94023e0 	ldr	x0, [sp, #64]
    c0003968:	39404400 	ldrb	w0, [x0, #17]
	mini_os_printf("cpu%-2u mpidr=0x%llx chip=%u die=%u cluster=%u core=%u online=%s scheduled=%s pending=%s boot=%s\n",
    c000396c:	12000000 	and	w0, w0, #0x1
    c0003970:	7100001f 	cmp	w0, #0x0
    c0003974:	54000080 	b.eq	c0003984 <shell_print_cpu_entry+0xd4>  // b.none
    c0003978:	f0000000 	adrp	x0, c0006000 <smp_cpu_state+0x4>
    c000397c:	91300000 	add	x0, x0, #0xc00
    c0003980:	14000003 	b	c000398c <shell_print_cpu_entry+0xdc>
    c0003984:	f0000000 	adrp	x0, c0006000 <smp_cpu_state+0x4>
    c0003988:	91302000 	add	x0, x0, #0xc08
		       state->pending ? "yes" : "no",
    c000398c:	f94023e1 	ldr	x1, [sp, #64]
    c0003990:	39404821 	ldrb	w1, [x1, #18]
	mini_os_printf("cpu%-2u mpidr=0x%llx chip=%u die=%u cluster=%u core=%u online=%s scheduled=%s pending=%s boot=%s\n",
    c0003994:	12000021 	and	w1, w1, #0x1
    c0003998:	7100003f 	cmp	w1, #0x0
    c000399c:	54000080 	b.eq	c00039ac <shell_print_cpu_entry+0xfc>  // b.none
    c00039a0:	f0000001 	adrp	x1, c0006000 <smp_cpu_state+0x4>
    c00039a4:	91300021 	add	x1, x1, #0xc00
    c00039a8:	14000003 	b	c00039b4 <shell_print_cpu_entry+0x104>
    c00039ac:	f0000001 	adrp	x1, c0006000 <smp_cpu_state+0x4>
    c00039b0:	91302021 	add	x1, x1, #0xc08
		       cpu->boot_cpu ? "yes" : "no");
    c00039b4:	f94027e2 	ldr	x2, [sp, #72]
    c00039b8:	39407042 	ldrb	w2, [x2, #28]
	mini_os_printf("cpu%-2u mpidr=0x%llx chip=%u die=%u cluster=%u core=%u online=%s scheduled=%s pending=%s boot=%s\n",
    c00039bc:	12000042 	and	w2, w2, #0x1
    c00039c0:	7100005f 	cmp	w2, #0x0
    c00039c4:	54000080 	b.eq	c00039d4 <shell_print_cpu_entry+0x124>  // b.none
    c00039c8:	f0000002 	adrp	x2, c0006000 <smp_cpu_state+0x4>
    c00039cc:	91300042 	add	x2, x2, #0xc00
    c00039d0:	14000003 	b	c00039dc <shell_print_cpu_entry+0x12c>
    c00039d4:	f0000002 	adrp	x2, c0006000 <smp_cpu_state+0x4>
    c00039d8:	91302042 	add	x2, x2, #0xc08
    c00039dc:	f9000be2 	str	x2, [sp, #16]
    c00039e0:	f90007e1 	str	x1, [sp, #8]
    c00039e4:	f90003e0 	str	x0, [sp]
    c00039e8:	aa0303e7 	mov	x7, x3
    c00039ec:	2a0a03e3 	mov	w3, w10
    c00039f0:	aa0903e2 	mov	x2, x9
    c00039f4:	2a0803e1 	mov	w1, w8
    c00039f8:	f0000000 	adrp	x0, c0006000 <smp_cpu_state+0x4>
    c00039fc:	91304000 	add	x0, x0, #0xc10
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
    c0003a20:	f0000000 	adrp	x0, c0006000 <smp_cpu_state+0x4>
    c0003a24:	9131e000 	add	x0, x0, #0xc78
    c0003a28:	97fff8b3 	bl	c0001cf4 <mini_os_printf>
	mini_os_printf("  help [--topic]    Show command help or detailed help for one topic\n");
    c0003a2c:	f0000000 	adrp	x0, c0006000 <smp_cpu_state+0x4>
    c0003a30:	91324000 	add	x0, x0, #0xc90
    c0003a34:	97fff8b0 	bl	c0001cf4 <mini_os_printf>
	mini_os_printf("  version           Show OS version information\n");
    c0003a38:	f0000000 	adrp	x0, c0006000 <smp_cpu_state+0x4>
    c0003a3c:	91336000 	add	x0, x0, #0xcd8
    c0003a40:	97fff8ad 	bl	c0001cf4 <mini_os_printf>
	mini_os_printf("  info              Show current platform/runtime info\n");
    c0003a44:	f0000000 	adrp	x0, c0006000 <smp_cpu_state+0x4>
    c0003a48:	91344000 	add	x0, x0, #0xd10
    c0003a4c:	97fff8aa 	bl	c0001cf4 <mini_os_printf>
	mini_os_printf("  cpu [id]          Show CPU information\n");
    c0003a50:	f0000000 	adrp	x0, c0006000 <smp_cpu_state+0x4>
    c0003a54:	91352000 	add	x0, x0, #0xd48
    c0003a58:	97fff8a7 	bl	c0001cf4 <mini_os_printf>
	mini_os_printf("  cpus              List known CPUs\n");
    c0003a5c:	f0000000 	adrp	x0, c0006000 <smp_cpu_state+0x4>
    c0003a60:	9135e000 	add	x0, x0, #0xd78
    c0003a64:	97fff8a4 	bl	c0001cf4 <mini_os_printf>
	mini_os_printf("  topo              Show topology summary\n");
    c0003a68:	f0000000 	adrp	x0, c0006000 <smp_cpu_state+0x4>
    c0003a6c:	91368000 	add	x0, x0, #0xda0
    c0003a70:	97fff8a1 	bl	c0001cf4 <mini_os_printf>
	mini_os_printf("  smp status        Show SMP status\n");
    c0003a74:	f0000000 	adrp	x0, c0006000 <smp_cpu_state+0x4>
    c0003a78:	91374000 	add	x0, x0, #0xdd0
    c0003a7c:	97fff89e 	bl	c0001cf4 <mini_os_printf>
	mini_os_printf("  smp start <mpidr> Ask TF-A via SMC/PSCI to start a secondary CPU\n");
    c0003a80:	f0000000 	adrp	x0, c0006000 <smp_cpu_state+0x4>
    c0003a84:	9137e000 	add	x0, x0, #0xdf8
    c0003a88:	97fff89b 	bl	c0001cf4 <mini_os_printf>
	mini_os_printf("  smp task add <cpu> <task> [arg] Queue a task to a secondary CPU\n");
    c0003a8c:	f0000000 	adrp	x0, c0006000 <smp_cpu_state+0x4>
    c0003a90:	91390000 	add	x0, x0, #0xe40
    c0003a94:	97fff898 	bl	c0001cf4 <mini_os_printf>
	mini_os_printf("  smp task list [cpu] Show pending task counts\n");
    c0003a98:	f0000000 	adrp	x0, c0006000 <smp_cpu_state+0x4>
    c0003a9c:	913a2000 	add	x0, x0, #0xe88
    c0003aa0:	97fff895 	bl	c0001cf4 <mini_os_printf>
	mini_os_printf("  echo ...          Print arguments back to the console\n");
    c0003aa4:	f0000000 	adrp	x0, c0006000 <smp_cpu_state+0x4>
    c0003aa8:	913ae000 	add	x0, x0, #0xeb8
    c0003aac:	97fff892 	bl	c0001cf4 <mini_os_printf>
	mini_os_printf("  clear             Clear the terminal screen\n");
    c0003ab0:	f0000000 	adrp	x0, c0006000 <smp_cpu_state+0x4>
    c0003ab4:	913be000 	add	x0, x0, #0xef8
    c0003ab8:	97fff88f 	bl	c0001cf4 <mini_os_printf>
	mini_os_printf("  uname             Print the OS name\n");
    c0003abc:	f0000000 	adrp	x0, c0006000 <smp_cpu_state+0x4>
    c0003ac0:	913ca000 	add	x0, x0, #0xf28
    c0003ac4:	97fff88c 	bl	c0001cf4 <mini_os_printf>
	mini_os_printf("  halt              Stop the CPU in a low-power wait loop\n");
    c0003ac8:	f0000000 	adrp	x0, c0006000 <smp_cpu_state+0x4>
    c0003acc:	913d4000 	add	x0, x0, #0xf50
    c0003ad0:	97fff889 	bl	c0001cf4 <mini_os_printf>
	mini_os_printf("Examples: help --cpus, help --smp, help --topo\n");
    c0003ad4:	f0000000 	adrp	x0, c0006000 <smp_cpu_state+0x4>
    c0003ad8:	913e4000 	add	x0, x0, #0xf90
    c0003adc:	97fff886 	bl	c0001cf4 <mini_os_printf>
}
    c0003ae0:	d503201f 	nop
    c0003ae4:	a8c17bfd 	ldp	x29, x30, [sp], #16
    c0003ae8:	d65f03c0 	ret

00000000c0003aec <shell_print_help_topic>:

static void shell_print_help_topic(const char *topic)
{
    c0003aec:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c0003af0:	910003fd 	mov	x29, sp
    c0003af4:	f9000fe0 	str	x0, [sp, #24]
	if ((topic == (const char *)0) || strings_equal(topic, "help")) {
    c0003af8:	f9400fe0 	ldr	x0, [sp, #24]
    c0003afc:	f100001f 	cmp	x0, #0x0
    c0003b00:	54000120 	b.eq	c0003b24 <shell_print_help_topic+0x38>  // b.none
    c0003b04:	f0000000 	adrp	x0, c0006000 <smp_cpu_state+0x4>
    c0003b08:	913f0001 	add	x1, x0, #0xfc0
    c0003b0c:	f9400fe0 	ldr	x0, [sp, #24]
    c0003b10:	97fffe7e 	bl	c0003508 <strings_equal>
    c0003b14:	12001c00 	and	w0, w0, #0xff
    c0003b18:	12000000 	and	w0, w0, #0x1
    c0003b1c:	7100001f 	cmp	w0, #0x0
    c0003b20:	54000280 	b.eq	c0003b70 <shell_print_help_topic+0x84>  // b.none
		mini_os_printf("help [--topic]\n");
    c0003b24:	f0000000 	adrp	x0, c0006000 <smp_cpu_state+0x4>
    c0003b28:	913f2000 	add	x0, x0, #0xfc8
    c0003b2c:	97fff872 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  Show the command list or detailed help for a single topic.\n");
    c0003b30:	f0000000 	adrp	x0, c0006000 <smp_cpu_state+0x4>
    c0003b34:	913f6000 	add	x0, x0, #0xfd8
    c0003b38:	97fff86f 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("Examples:\n");
    c0003b3c:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003b40:	91006000 	add	x0, x0, #0x18
    c0003b44:	97fff86c 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  help\n");
    c0003b48:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003b4c:	9100a000 	add	x0, x0, #0x28
    c0003b50:	97fff869 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  help --cpus\n");
    c0003b54:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003b58:	9100c000 	add	x0, x0, #0x30
    c0003b5c:	97fff866 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  help --smp\n");
    c0003b60:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003b64:	91010000 	add	x0, x0, #0x40
    c0003b68:	97fff863 	bl	c0001cf4 <mini_os_printf>
		return;
    c0003b6c:	14000110 	b	c0003fac <shell_print_help_topic+0x4c0>
	}

	if (strings_equal(topic, "cpu")) {
    c0003b70:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003b74:	91014001 	add	x1, x0, #0x50
    c0003b78:	f9400fe0 	ldr	x0, [sp, #24]
    c0003b7c:	97fffe63 	bl	c0003508 <strings_equal>
    c0003b80:	12001c00 	and	w0, w0, #0xff
    c0003b84:	12000000 	and	w0, w0, #0x1
    c0003b88:	7100001f 	cmp	w0, #0x0
    c0003b8c:	540002e0 	b.eq	c0003be8 <shell_print_help_topic+0xfc>  // b.none
		mini_os_printf("cpu [id]\n");
    c0003b90:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003b94:	91016000 	add	x0, x0, #0x58
    c0003b98:	97fff857 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  Show one logical CPU entry from the topology/SMP tables.\n");
    c0003b9c:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003ba0:	9101a000 	add	x0, x0, #0x68
    c0003ba4:	97fff854 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  If no id is given, it prints the current boot CPU entry.\n");
    c0003ba8:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003bac:	9102a000 	add	x0, x0, #0xa8
    c0003bb0:	97fff851 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("Examples:\n");
    c0003bb4:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003bb8:	91006000 	add	x0, x0, #0x18
    c0003bbc:	97fff84e 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  cpu\n");
    c0003bc0:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003bc4:	9103a000 	add	x0, x0, #0xe8
    c0003bc8:	97fff84b 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  cpu 0\n");
    c0003bcc:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003bd0:	9103c000 	add	x0, x0, #0xf0
    c0003bd4:	97fff848 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  cpu 1\n");
    c0003bd8:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003bdc:	91040000 	add	x0, x0, #0x100
    c0003be0:	97fff845 	bl	c0001cf4 <mini_os_printf>
		return;
    c0003be4:	140000f2 	b	c0003fac <shell_print_help_topic+0x4c0>
	}

	if (strings_equal(topic, "cpus")) {
    c0003be8:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003bec:	91044001 	add	x1, x0, #0x110
    c0003bf0:	f9400fe0 	ldr	x0, [sp, #24]
    c0003bf4:	97fffe45 	bl	c0003508 <strings_equal>
    c0003bf8:	12001c00 	and	w0, w0, #0xff
    c0003bfc:	12000000 	and	w0, w0, #0x1
    c0003c00:	7100001f 	cmp	w0, #0x0
    c0003c04:	54000280 	b.eq	c0003c54 <shell_print_help_topic+0x168>  // b.none
		mini_os_printf("cpus\n");
    c0003c08:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003c0c:	91046000 	add	x0, x0, #0x118
    c0003c10:	97fff839 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  List all CPUs that are currently registered in the topology table.\n");
    c0003c14:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003c18:	91048000 	add	x0, x0, #0x120
    c0003c1c:	97fff836 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  The line shows mpidr/chip/die/cluster/core plus online, scheduled, pending and boot flags.\n");
    c0003c20:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003c24:	9105a000 	add	x0, x0, #0x168
    c0003c28:	97fff833 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("Examples:\n");
    c0003c2c:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003c30:	91006000 	add	x0, x0, #0x18
    c0003c34:	97fff830 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  cpus\n");
    c0003c38:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003c3c:	91072000 	add	x0, x0, #0x1c8
    c0003c40:	97fff82d 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  help --cpu\n");
    c0003c44:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003c48:	91074000 	add	x0, x0, #0x1d0
    c0003c4c:	97fff82a 	bl	c0001cf4 <mini_os_printf>
		return;
    c0003c50:	140000d7 	b	c0003fac <shell_print_help_topic+0x4c0>
	}

	if (strings_equal(topic, "topo")) {
    c0003c54:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003c58:	91078001 	add	x1, x0, #0x1e0
    c0003c5c:	f9400fe0 	ldr	x0, [sp, #24]
    c0003c60:	97fffe2a 	bl	c0003508 <strings_equal>
    c0003c64:	12001c00 	and	w0, w0, #0xff
    c0003c68:	12000000 	and	w0, w0, #0x1
    c0003c6c:	7100001f 	cmp	w0, #0x0
    c0003c70:	54000220 	b.eq	c0003cb4 <shell_print_help_topic+0x1c8>  // b.none
		mini_os_printf("topo\n");
    c0003c74:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003c78:	9107a000 	add	x0, x0, #0x1e8
    c0003c7c:	97fff81e 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  Print a compact topology summary for the boot CPU and current CPU counts.\n");
    c0003c80:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003c84:	9107c000 	add	x0, x0, #0x1f0
    c0003c88:	97fff81b 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  Useful for checking the boot MPIDR and the decoded chip/die/cluster/core affinity.\n");
    c0003c8c:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003c90:	91090000 	add	x0, x0, #0x240
    c0003c94:	97fff818 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("Examples:\n");
    c0003c98:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003c9c:	91006000 	add	x0, x0, #0x18
    c0003ca0:	97fff815 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  topo\n");
    c0003ca4:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003ca8:	910a6000 	add	x0, x0, #0x298
    c0003cac:	97fff812 	bl	c0001cf4 <mini_os_printf>
		return;
    c0003cb0:	140000bf 	b	c0003fac <shell_print_help_topic+0x4c0>
	}

	if (strings_equal(topic, "smp")) {
    c0003cb4:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003cb8:	910a8001 	add	x1, x0, #0x2a0
    c0003cbc:	f9400fe0 	ldr	x0, [sp, #24]
    c0003cc0:	97fffe12 	bl	c0003508 <strings_equal>
    c0003cc4:	12001c00 	and	w0, w0, #0xff
    c0003cc8:	12000000 	and	w0, w0, #0x1
    c0003ccc:	7100001f 	cmp	w0, #0x0
    c0003cd0:	54000640 	b.eq	c0003d98 <shell_print_help_topic+0x2ac>  // b.none
		mini_os_printf("smp status\n");
    c0003cd4:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003cd8:	910aa000 	add	x0, x0, #0x2a8
    c0003cdc:	97fff806 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  Show the same per-CPU runtime table as 'cpus'.\n");
    c0003ce0:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003ce4:	910ae000 	add	x0, x0, #0x2b8
    c0003ce8:	97fff803 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("smp start <mpidr>\n");
    c0003cec:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003cf0:	910bc000 	add	x0, x0, #0x2f0
    c0003cf4:	97fff800 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  Ask TF-A/BL31 through SMC/PSCI CPU_ON to start the target CPU identified by MPIDR.\n");
    c0003cf8:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003cfc:	910c2000 	add	x0, x0, #0x308
    c0003d00:	97fff7fd 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  The shell passes TF-A the target MPIDR and the mini-OS secondary entry address.\n");
    c0003d04:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003d08:	910d8000 	add	x0, x0, #0x360
    c0003d0c:	97fff7fa 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("smp task add <cpu-id> <task-id> [arg]\n");
    c0003d10:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003d14:	910ee000 	add	x0, x0, #0x3b8
    c0003d18:	97fff7f7 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  Dynamically append a task to the target secondary CPU queue.\n");
    c0003d1c:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003d20:	910f8000 	add	x0, x0, #0x3e0
    c0003d24:	97fff7f4 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  The secondary CPU polls its queue periodically and executes queued tasks.\n");
    c0003d28:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003d2c:	91108000 	add	x0, x0, #0x420
    c0003d30:	97fff7f1 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("smp task list [cpu-id]\n");
    c0003d34:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003d38:	9111c000 	add	x0, x0, #0x470
    c0003d3c:	97fff7ee 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  Show pending queued task count for all CPUs or one CPU.\n");
    c0003d40:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003d44:	91122000 	add	x0, x0, #0x488
    c0003d48:	97fff7eb 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("Examples:\n");
    c0003d4c:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003d50:	91006000 	add	x0, x0, #0x18
    c0003d54:	97fff7e8 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  smp status\n");
    c0003d58:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003d5c:	91132000 	add	x0, x0, #0x4c8
    c0003d60:	97fff7e5 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  smp start 0x80000001\n");
    c0003d64:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003d68:	91136000 	add	x0, x0, #0x4d8
    c0003d6c:	97fff7e2 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  smp start 2147483649\n");
    c0003d70:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003d74:	9113c000 	add	x0, x0, #0x4f0
    c0003d78:	97fff7df 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  smp task add 1 100 42\n");
    c0003d7c:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003d80:	91142000 	add	x0, x0, #0x508
    c0003d84:	97fff7dc 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  smp task list\n");
    c0003d88:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003d8c:	9114a000 	add	x0, x0, #0x528
    c0003d90:	97fff7d9 	bl	c0001cf4 <mini_os_printf>
		return;
    c0003d94:	14000086 	b	c0003fac <shell_print_help_topic+0x4c0>
	}

	if (strings_equal(topic, "info")) {
    c0003d98:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003d9c:	91150001 	add	x1, x0, #0x540
    c0003da0:	f9400fe0 	ldr	x0, [sp, #24]
    c0003da4:	97fffdd9 	bl	c0003508 <strings_equal>
    c0003da8:	12001c00 	and	w0, w0, #0xff
    c0003dac:	12000000 	and	w0, w0, #0x1
    c0003db0:	7100001f 	cmp	w0, #0x0
    c0003db4:	540001c0 	b.eq	c0003dec <shell_print_help_topic+0x300>  // b.none
		mini_os_printf("info\n");
    c0003db8:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003dbc:	91152000 	add	x0, x0, #0x548
    c0003dc0:	97fff7cd 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  Show platform-level runtime information such as UART base, load address, boot magic and runnable CPU count.\n");
    c0003dc4:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003dc8:	91154000 	add	x0, x0, #0x550
    c0003dcc:	97fff7ca 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("Example:\n");
    c0003dd0:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003dd4:	91170000 	add	x0, x0, #0x5c0
    c0003dd8:	97fff7c7 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  info\n");
    c0003ddc:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003de0:	91174000 	add	x0, x0, #0x5d0
    c0003de4:	97fff7c4 	bl	c0001cf4 <mini_os_printf>
		return;
    c0003de8:	14000071 	b	c0003fac <shell_print_help_topic+0x4c0>
	}

	if (strings_equal(topic, "version")) {
    c0003dec:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003df0:	91176001 	add	x1, x0, #0x5d8
    c0003df4:	f9400fe0 	ldr	x0, [sp, #24]
    c0003df8:	97fffdc4 	bl	c0003508 <strings_equal>
    c0003dfc:	12001c00 	and	w0, w0, #0xff
    c0003e00:	12000000 	and	w0, w0, #0x1
    c0003e04:	7100001f 	cmp	w0, #0x0
    c0003e08:	540001c0 	b.eq	c0003e40 <shell_print_help_topic+0x354>  // b.none
		mini_os_printf("version\n");
    c0003e0c:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003e10:	91178000 	add	x0, x0, #0x5e0
    c0003e14:	97fff7b8 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  Show the Mini-OS name, version string and build year.\n");
    c0003e18:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003e1c:	9117c000 	add	x0, x0, #0x5f0
    c0003e20:	97fff7b5 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("Example:\n");
    c0003e24:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003e28:	91170000 	add	x0, x0, #0x5c0
    c0003e2c:	97fff7b2 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  version\n");
    c0003e30:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003e34:	9118c000 	add	x0, x0, #0x630
    c0003e38:	97fff7af 	bl	c0001cf4 <mini_os_printf>
		return;
    c0003e3c:	1400005c 	b	c0003fac <shell_print_help_topic+0x4c0>
	}

	if (strings_equal(topic, "echo")) {
    c0003e40:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003e44:	91190001 	add	x1, x0, #0x640
    c0003e48:	f9400fe0 	ldr	x0, [sp, #24]
    c0003e4c:	97fffdaf 	bl	c0003508 <strings_equal>
    c0003e50:	12001c00 	and	w0, w0, #0xff
    c0003e54:	12000000 	and	w0, w0, #0x1
    c0003e58:	7100001f 	cmp	w0, #0x0
    c0003e5c:	540001c0 	b.eq	c0003e94 <shell_print_help_topic+0x3a8>  // b.none
		mini_os_printf("echo <text...>\n");
    c0003e60:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003e64:	91192000 	add	x0, x0, #0x648
    c0003e68:	97fff7a3 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  Print the provided arguments back to the serial console.\n");
    c0003e6c:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003e70:	91196000 	add	x0, x0, #0x658
    c0003e74:	97fff7a0 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("Example:\n");
    c0003e78:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003e7c:	91170000 	add	x0, x0, #0x5c0
    c0003e80:	97fff79d 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  echo hello mini-os\n");
    c0003e84:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003e88:	911a6000 	add	x0, x0, #0x698
    c0003e8c:	97fff79a 	bl	c0001cf4 <mini_os_printf>
		return;
    c0003e90:	14000047 	b	c0003fac <shell_print_help_topic+0x4c0>
	}

	if (strings_equal(topic, "clear")) {
    c0003e94:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003e98:	911ac001 	add	x1, x0, #0x6b0
    c0003e9c:	f9400fe0 	ldr	x0, [sp, #24]
    c0003ea0:	97fffd9a 	bl	c0003508 <strings_equal>
    c0003ea4:	12001c00 	and	w0, w0, #0xff
    c0003ea8:	12000000 	and	w0, w0, #0x1
    c0003eac:	7100001f 	cmp	w0, #0x0
    c0003eb0:	540001c0 	b.eq	c0003ee8 <shell_print_help_topic+0x3fc>  // b.none
		mini_os_printf("clear\n");
    c0003eb4:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003eb8:	911ae000 	add	x0, x0, #0x6b8
    c0003ebc:	97fff78e 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  Send ANSI escape sequences to clear the serial terminal and move the cursor to the top-left corner.\n");
    c0003ec0:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003ec4:	911b0000 	add	x0, x0, #0x6c0
    c0003ec8:	97fff78b 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("Example:\n");
    c0003ecc:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003ed0:	91170000 	add	x0, x0, #0x5c0
    c0003ed4:	97fff788 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  clear\n");
    c0003ed8:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003edc:	911ca000 	add	x0, x0, #0x728
    c0003ee0:	97fff785 	bl	c0001cf4 <mini_os_printf>
		return;
    c0003ee4:	14000032 	b	c0003fac <shell_print_help_topic+0x4c0>
	}

	if (strings_equal(topic, "uname")) {
    c0003ee8:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003eec:	911ce001 	add	x1, x0, #0x738
    c0003ef0:	f9400fe0 	ldr	x0, [sp, #24]
    c0003ef4:	97fffd85 	bl	c0003508 <strings_equal>
    c0003ef8:	12001c00 	and	w0, w0, #0xff
    c0003efc:	12000000 	and	w0, w0, #0x1
    c0003f00:	7100001f 	cmp	w0, #0x0
    c0003f04:	540001c0 	b.eq	c0003f3c <shell_print_help_topic+0x450>  // b.none
		mini_os_printf("uname\n");
    c0003f08:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003f0c:	911d0000 	add	x0, x0, #0x740
    c0003f10:	97fff779 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  Print the OS name only.\n");
    c0003f14:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003f18:	911d2000 	add	x0, x0, #0x748
    c0003f1c:	97fff776 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("Example:\n");
    c0003f20:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003f24:	91170000 	add	x0, x0, #0x5c0
    c0003f28:	97fff773 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  uname\n");
    c0003f2c:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003f30:	911da000 	add	x0, x0, #0x768
    c0003f34:	97fff770 	bl	c0001cf4 <mini_os_printf>
		return;
    c0003f38:	1400001d 	b	c0003fac <shell_print_help_topic+0x4c0>
	}

	if (strings_equal(topic, "halt")) {
    c0003f3c:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003f40:	911de001 	add	x1, x0, #0x778
    c0003f44:	f9400fe0 	ldr	x0, [sp, #24]
    c0003f48:	97fffd70 	bl	c0003508 <strings_equal>
    c0003f4c:	12001c00 	and	w0, w0, #0xff
    c0003f50:	12000000 	and	w0, w0, #0x1
    c0003f54:	7100001f 	cmp	w0, #0x0
    c0003f58:	540001c0 	b.eq	c0003f90 <shell_print_help_topic+0x4a4>  // b.none
		mini_os_printf("halt\n");
    c0003f5c:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003f60:	911e0000 	add	x0, x0, #0x780
    c0003f64:	97fff764 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  Stop the current CPU in a low-power wait loop.\n");
    c0003f68:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003f6c:	911e2000 	add	x0, x0, #0x788
    c0003f70:	97fff761 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("Example:\n");
    c0003f74:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003f78:	91170000 	add	x0, x0, #0x5c0
    c0003f7c:	97fff75e 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  halt\n");
    c0003f80:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003f84:	911f0000 	add	x0, x0, #0x7c0
    c0003f88:	97fff75b 	bl	c0001cf4 <mini_os_printf>
		return;
    c0003f8c:	14000008 	b	c0003fac <shell_print_help_topic+0x4c0>
	}

	mini_os_printf("No detailed help for topic '%s'.\n", topic);
    c0003f90:	f9400fe1 	ldr	x1, [sp, #24]
    c0003f94:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003f98:	911f2000 	add	x0, x0, #0x7c8
    c0003f9c:	97fff756 	bl	c0001cf4 <mini_os_printf>
	mini_os_printf("Try one of: cpu, cpus, topo, smp, info, version, echo, clear, uname, halt\n");
    c0003fa0:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003fa4:	911fc000 	add	x0, x0, #0x7f0
    c0003fa8:	97fff753 	bl	c0001cf4 <mini_os_printf>
}
    c0003fac:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c0003fb0:	d65f03c0 	ret

00000000c0003fb4 <shell_print_help>:

void shell_print_help(void)
{
    c0003fb4:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    c0003fb8:	910003fd 	mov	x29, sp
	shell_print_help_overview();
    c0003fbc:	97fffe97 	bl	c0003a18 <shell_print_help_overview>
}
    c0003fc0:	d503201f 	nop
    c0003fc4:	a8c17bfd 	ldp	x29, x30, [sp], #16
    c0003fc8:	d65f03c0 	ret

00000000c0003fcc <shell_print_version>:

static void shell_print_version(void)
{
    c0003fcc:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    c0003fd0:	910003fd 	mov	x29, sp
	mini_os_printf("%s %s (%d)\n", MINI_OS_NAME, MINI_OS_VERSION,
    c0003fd4:	5280fd43 	mov	w3, #0x7ea                 	// #2026
    c0003fd8:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003fdc:	91210002 	add	x2, x0, #0x840
    c0003fe0:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003fe4:	91212001 	add	x1, x0, #0x848
    c0003fe8:	90000020 	adrp	x0, c0007000 <hex.0+0x658>
    c0003fec:	91214000 	add	x0, x0, #0x850
    c0003ff0:	97fff741 	bl	c0001cf4 <mini_os_printf>
		       MINI_OS_BUILD_YEAR);
}
    c0003ff4:	d503201f 	nop
    c0003ff8:	a8c17bfd 	ldp	x29, x30, [sp], #16
    c0003ffc:	d65f03c0 	ret

00000000c0004000 <shell_print_info>:

static void shell_print_info(void)
{
    c0004000:	a9ba7bfd 	stp	x29, x30, [sp, #-96]!
    c0004004:	910003fd 	mov	x29, sp
	mini_os_printf("Platform      : %s\n", "Neoverse-N3");
    c0004008:	f0000000 	adrp	x0, c0007000 <hex.0+0x658>
    c000400c:	91218001 	add	x1, x0, #0x860
    c0004010:	f0000000 	adrp	x0, c0007000 <hex.0+0x658>
    c0004014:	9121c000 	add	x0, x0, #0x870
    c0004018:	97fff737 	bl	c0001cf4 <mini_os_printf>
	mini_os_printf("UART base     : 0x%llx\n",
    c000401c:	d2a34801 	mov	x1, #0x1a400000            	// #440401920
    c0004020:	f0000000 	adrp	x0, c0007000 <hex.0+0x658>
    c0004024:	91222000 	add	x0, x0, #0x888
    c0004028:	97fff733 	bl	c0001cf4 <mini_os_printf>
		       (unsigned long long)PLAT_UART0_BASE);
	mini_os_printf("Load address  : 0x%llx\n",
    c000402c:	d2b80001 	mov	x1, #0xc0000000            	// #3221225472
    c0004030:	f0000000 	adrp	x0, c0007000 <hex.0+0x658>
    c0004034:	91228000 	add	x0, x0, #0x8a0
    c0004038:	97fff72f 	bl	c0001cf4 <mini_os_printf>
		       (unsigned long long)PLAT_LOAD_ADDR);
	mini_os_printf("Boot magic    : 0x%llx\n",
    c000403c:	90000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c0004040:	9107c000 	add	x0, x0, #0x1f0
    c0004044:	f9400000 	ldr	x0, [x0]
    c0004048:	aa0003e1 	mov	x1, x0
    c000404c:	f0000000 	adrp	x0, c0007000 <hex.0+0x658>
    c0004050:	9122e000 	add	x0, x0, #0x8b8
    c0004054:	97fff728 	bl	c0001cf4 <mini_os_printf>
		       (unsigned long long)boot_magic);
	struct early_allocator_stats mm_stats;
	early_mm_get_stats(&mm_stats);
    c0004058:	910043e0 	add	x0, sp, #0x10
    c000405c:	97fffbd5 	bl	c0002fb0 <early_mm_get_stats>
	mini_os_printf("Runnable CPUs : %u\n", scheduler_runnable_cpu_count());
    c0004060:	97fffd00 	bl	c0003460 <scheduler_runnable_cpu_count>
    c0004064:	2a0003e1 	mov	w1, w0
    c0004068:	f0000000 	adrp	x0, c0007000 <hex.0+0x658>
    c000406c:	91234000 	add	x0, x0, #0x8d0
    c0004070:	97fff721 	bl	c0001cf4 <mini_os_printf>
	mini_os_printf("Early heap    : %s 0x%llx-0x%llx (%u/%u bytes used, peak=%u)\n",
    c0004074:	f9400be0 	ldr	x0, [sp, #16]
		       mm_stats.name,
		       (unsigned long long)mm_stats.start,
    c0004078:	f9400fe1 	ldr	x1, [sp, #24]
		       (unsigned long long)mm_stats.end,
    c000407c:	f94017e2 	ldr	x2, [sp, #40]
		       (unsigned int)mm_stats.used_bytes,
    c0004080:	f9401fe3 	ldr	x3, [sp, #56]
	mini_os_printf("Early heap    : %s 0x%llx-0x%llx (%u/%u bytes used, peak=%u)\n",
    c0004084:	2a0303e4 	mov	w4, w3
		       (unsigned int)mm_stats.total_bytes,
    c0004088:	f9401be3 	ldr	x3, [sp, #48]
	mini_os_printf("Early heap    : %s 0x%llx-0x%llx (%u/%u bytes used, peak=%u)\n",
    c000408c:	2a0303e5 	mov	w5, w3
		       (unsigned int)mm_stats.peak_used_bytes);
    c0004090:	f94027e3 	ldr	x3, [sp, #72]
	mini_os_printf("Early heap    : %s 0x%llx-0x%llx (%u/%u bytes used, peak=%u)\n",
    c0004094:	2a0303e6 	mov	w6, w3
    c0004098:	aa0203e3 	mov	x3, x2
    c000409c:	aa0103e2 	mov	x2, x1
    c00040a0:	aa0003e1 	mov	x1, x0
    c00040a4:	f0000000 	adrp	x0, c0007000 <hex.0+0x658>
    c00040a8:	9123a000 	add	x0, x0, #0x8e8
    c00040ac:	97fff712 	bl	c0001cf4 <mini_os_printf>
	mini_os_printf("Early allocs  : %u (page size=%u)\n",
		       (unsigned int)mm_stats.allocation_count,
    c00040b0:	f9402be0 	ldr	x0, [sp, #80]
	mini_os_printf("Early allocs  : %u (page size=%u)\n",
    c00040b4:	2a0003e1 	mov	w1, w0
		       (unsigned int)mm_stats.page_size);
    c00040b8:	f9402fe0 	ldr	x0, [sp, #88]
	mini_os_printf("Early allocs  : %u (page size=%u)\n",
    c00040bc:	2a0003e2 	mov	w2, w0
    c00040c0:	f0000000 	adrp	x0, c0007000 <hex.0+0x658>
    c00040c4:	9124a000 	add	x0, x0, #0x928
    c00040c8:	97fff70b 	bl	c0001cf4 <mini_os_printf>
	mini_os_printf("Sched objects : %u\n",
		       (unsigned int)scheduler_bootstrap_object_count());
    c00040cc:	97fffcf6 	bl	c00034a4 <scheduler_bootstrap_object_count>
	mini_os_printf("Sched objects : %u\n",
    c00040d0:	2a0003e1 	mov	w1, w0
    c00040d4:	f0000000 	adrp	x0, c0007000 <hex.0+0x658>
    c00040d8:	91254000 	add	x0, x0, #0x950
    c00040dc:	97fff706 	bl	c0001cf4 <mini_os_printf>
}
    c00040e0:	d503201f 	nop
    c00040e4:	a8c67bfd 	ldp	x29, x30, [sp], #96
    c00040e8:	d65f03c0 	ret

00000000c00040ec <shell_print_current_cpu>:

static void shell_print_current_cpu(void)
{
    c00040ec:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    c00040f0:	910003fd 	mov	x29, sp
	shell_print_cpu_entry(0U);
    c00040f4:	52800000 	mov	w0, #0x0                   	// #0
    c00040f8:	97fffdee 	bl	c00038b0 <shell_print_cpu_entry>
}
    c00040fc:	d503201f 	nop
    c0004100:	a8c17bfd 	ldp	x29, x30, [sp], #16
    c0004104:	d65f03c0 	ret

00000000c0004108 <shell_print_cpu_id>:

static void shell_print_cpu_id(const char *arg)
{
    c0004108:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
    c000410c:	910003fd 	mov	x29, sp
    c0004110:	f9000fe0 	str	x0, [sp, #24]
	uint64_t logical_id;
	const struct cpu_topology_descriptor *cpu;

	if (!parse_u64(arg, &logical_id)) {
    c0004114:	910083e0 	add	x0, sp, #0x20
    c0004118:	aa0003e1 	mov	x1, x0
    c000411c:	f9400fe0 	ldr	x0, [sp, #24]
    c0004120:	97fffd3d 	bl	c0003614 <parse_u64>
    c0004124:	12001c00 	and	w0, w0, #0xff
    c0004128:	52000000 	eor	w0, w0, #0x1
    c000412c:	12001c00 	and	w0, w0, #0xff
    c0004130:	12000000 	and	w0, w0, #0x1
    c0004134:	7100001f 	cmp	w0, #0x0
    c0004138:	540000c0 	b.eq	c0004150 <shell_print_cpu_id+0x48>  // b.none
		mini_os_printf("error: invalid cpu id '%s'\n", arg);
    c000413c:	f9400fe1 	ldr	x1, [sp, #24]
    c0004140:	f0000000 	adrp	x0, c0007000 <hex.0+0x658>
    c0004144:	9125a000 	add	x0, x0, #0x968
    c0004148:	97fff6eb 	bl	c0001cf4 <mini_os_printf>
		return;
    c000414c:	14000016 	b	c00041a4 <shell_print_cpu_id+0x9c>
	}

	cpu = topology_cpu((unsigned int)logical_id);
    c0004150:	f94013e0 	ldr	x0, [sp, #32]
    c0004154:	940008c7 	bl	c0006470 <topology_cpu>
    c0004158:	f90017e0 	str	x0, [sp, #40]
	if ((cpu == (const struct cpu_topology_descriptor *)0) || !cpu->present) {
    c000415c:	f94017e0 	ldr	x0, [sp, #40]
    c0004160:	f100001f 	cmp	x0, #0x0
    c0004164:	54000100 	b.eq	c0004184 <shell_print_cpu_id+0x7c>  // b.none
    c0004168:	f94017e0 	ldr	x0, [sp, #40]
    c000416c:	39407400 	ldrb	w0, [x0, #29]
    c0004170:	52000000 	eor	w0, w0, #0x1
    c0004174:	12001c00 	and	w0, w0, #0xff
    c0004178:	12000000 	and	w0, w0, #0x1
    c000417c:	7100001f 	cmp	w0, #0x0
    c0004180:	540000e0 	b.eq	c000419c <shell_print_cpu_id+0x94>  // b.none
		mini_os_printf("cpu%u is not present\n", (unsigned int)logical_id);
    c0004184:	f94013e0 	ldr	x0, [sp, #32]
    c0004188:	2a0003e1 	mov	w1, w0
    c000418c:	f0000000 	adrp	x0, c0007000 <hex.0+0x658>
    c0004190:	91262000 	add	x0, x0, #0x988
    c0004194:	97fff6d8 	bl	c0001cf4 <mini_os_printf>
		return;
    c0004198:	14000003 	b	c00041a4 <shell_print_cpu_id+0x9c>
	}

	shell_print_cpu_entry((unsigned int)logical_id);
    c000419c:	f94013e0 	ldr	x0, [sp, #32]
    c00041a0:	97fffdc4 	bl	c00038b0 <shell_print_cpu_entry>
}
    c00041a4:	a8c37bfd 	ldp	x29, x30, [sp], #48
    c00041a8:	d65f03c0 	ret

00000000c00041ac <shell_print_cpus>:

static void shell_print_cpus(void)
{
    c00041ac:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
    c00041b0:	910003fd 	mov	x29, sp
    c00041b4:	a90153f3 	stp	x19, x20, [sp, #16]
	unsigned int i;

	for (i = 0U; i < topology_cpu_capacity(); ++i) {
    c00041b8:	b9002fff 	str	wzr, [sp, #44]
    c00041bc:	14000011 	b	c0004200 <shell_print_cpus+0x54>
		const struct cpu_topology_descriptor *cpu = topology_cpu(i);
    c00041c0:	b9402fe0 	ldr	w0, [sp, #44]
    c00041c4:	940008ab 	bl	c0006470 <topology_cpu>
    c00041c8:	f90013e0 	str	x0, [sp, #32]

		if ((cpu != (const struct cpu_topology_descriptor *)0) && cpu->present) {
    c00041cc:	f94013e0 	ldr	x0, [sp, #32]
    c00041d0:	f100001f 	cmp	x0, #0x0
    c00041d4:	54000100 	b.eq	c00041f4 <shell_print_cpus+0x48>  // b.none
    c00041d8:	f94013e0 	ldr	x0, [sp, #32]
    c00041dc:	39407400 	ldrb	w0, [x0, #29]
    c00041e0:	12000000 	and	w0, w0, #0x1
    c00041e4:	7100001f 	cmp	w0, #0x0
    c00041e8:	54000060 	b.eq	c00041f4 <shell_print_cpus+0x48>  // b.none
			shell_print_cpu_entry(i);
    c00041ec:	b9402fe0 	ldr	w0, [sp, #44]
    c00041f0:	97fffdb0 	bl	c00038b0 <shell_print_cpu_entry>
	for (i = 0U; i < topology_cpu_capacity(); ++i) {
    c00041f4:	b9402fe0 	ldr	w0, [sp, #44]
    c00041f8:	11000400 	add	w0, w0, #0x1
    c00041fc:	b9002fe0 	str	w0, [sp, #44]
    c0004200:	940008cf 	bl	c000653c <topology_cpu_capacity>
    c0004204:	2a0003e1 	mov	w1, w0
    c0004208:	b9402fe0 	ldr	w0, [sp, #44]
    c000420c:	6b01001f 	cmp	w0, w1
    c0004210:	54fffd83 	b.cc	c00041c0 <shell_print_cpus+0x14>  // b.lo, b.ul, b.last
		}
	}
	mini_os_printf("online=%u runnable=%u capacity=%u\n",
    c0004214:	940008d0 	bl	c0006554 <topology_online_cpu_count>
    c0004218:	2a0003f3 	mov	w19, w0
    c000421c:	97fffc91 	bl	c0003460 <scheduler_runnable_cpu_count>
    c0004220:	2a0003f4 	mov	w20, w0
    c0004224:	940008c6 	bl	c000653c <topology_cpu_capacity>
    c0004228:	2a0003e3 	mov	w3, w0
    c000422c:	2a1403e2 	mov	w2, w20
    c0004230:	2a1303e1 	mov	w1, w19
    c0004234:	f0000000 	adrp	x0, c0007000 <hex.0+0x658>
    c0004238:	91268000 	add	x0, x0, #0x9a0
    c000423c:	97fff6ae 	bl	c0001cf4 <mini_os_printf>
		       topology_online_cpu_count(),
		       scheduler_runnable_cpu_count(),
		       topology_cpu_capacity());
}
    c0004240:	d503201f 	nop
    c0004244:	a94153f3 	ldp	x19, x20, [sp, #16]
    c0004248:	a8c37bfd 	ldp	x29, x30, [sp], #48
    c000424c:	d65f03c0 	ret

00000000c0004250 <shell_print_topology_summary>:

static void shell_print_topology_summary(void)
{
    c0004250:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c0004254:	910003fd 	mov	x29, sp
	const struct cpu_topology_descriptor *boot_cpu = topology_boot_cpu();
    c0004258:	94000883 	bl	c0006464 <topology_boot_cpu>
    c000425c:	f9000fe0 	str	x0, [sp, #24]

	mini_os_printf("Topology summary:\n");
    c0004260:	f0000000 	adrp	x0, c0007000 <hex.0+0x658>
    c0004264:	91272000 	add	x0, x0, #0x9c8
    c0004268:	97fff6a3 	bl	c0001cf4 <mini_os_printf>
	mini_os_printf("  present cpus : %u\n", topology_present_cpu_count());
    c000426c:	940008b6 	bl	c0006544 <topology_present_cpu_count>
    c0004270:	2a0003e1 	mov	w1, w0
    c0004274:	f0000000 	adrp	x0, c0007000 <hex.0+0x658>
    c0004278:	91278000 	add	x0, x0, #0x9e0
    c000427c:	97fff69e 	bl	c0001cf4 <mini_os_printf>
	mini_os_printf("  online cpus  : %u\n", topology_online_cpu_count());
    c0004280:	940008b5 	bl	c0006554 <topology_online_cpu_count>
    c0004284:	2a0003e1 	mov	w1, w0
    c0004288:	f0000000 	adrp	x0, c0007000 <hex.0+0x658>
    c000428c:	9127e000 	add	x0, x0, #0x9f8
    c0004290:	97fff699 	bl	c0001cf4 <mini_os_printf>
	mini_os_printf("  boot cpu     : cpu%u\n", boot_cpu->logical_id);
    c0004294:	f9400fe0 	ldr	x0, [sp, #24]
    c0004298:	b9400800 	ldr	w0, [x0, #8]
    c000429c:	2a0003e1 	mov	w1, w0
    c00042a0:	f0000000 	adrp	x0, c0007000 <hex.0+0x658>
    c00042a4:	91284000 	add	x0, x0, #0xa10
    c00042a8:	97fff693 	bl	c0001cf4 <mini_os_printf>
	mini_os_printf("  boot mpidr   : 0x%llx\n", (unsigned long long)boot_cpu->mpidr);
    c00042ac:	f9400fe0 	ldr	x0, [sp, #24]
    c00042b0:	f9400000 	ldr	x0, [x0]
    c00042b4:	aa0003e1 	mov	x1, x0
    c00042b8:	f0000000 	adrp	x0, c0007000 <hex.0+0x658>
    c00042bc:	9128a000 	add	x0, x0, #0xa28
    c00042c0:	97fff68d 	bl	c0001cf4 <mini_os_printf>
	mini_os_printf("  affinity     : chip=%u die=%u cluster=%u core=%u\n",
		       boot_cpu->chip_id,
    c00042c4:	f9400fe0 	ldr	x0, [sp, #24]
    c00042c8:	b9400c01 	ldr	w1, [x0, #12]
		       boot_cpu->die_id,
    c00042cc:	f9400fe0 	ldr	x0, [sp, #24]
    c00042d0:	b9401002 	ldr	w2, [x0, #16]
		       boot_cpu->cluster_id,
    c00042d4:	f9400fe0 	ldr	x0, [sp, #24]
    c00042d8:	b9401403 	ldr	w3, [x0, #20]
		       boot_cpu->core_id);
    c00042dc:	f9400fe0 	ldr	x0, [sp, #24]
    c00042e0:	b9401800 	ldr	w0, [x0, #24]
	mini_os_printf("  affinity     : chip=%u die=%u cluster=%u core=%u\n",
    c00042e4:	2a0003e4 	mov	w4, w0
    c00042e8:	f0000000 	adrp	x0, c0007000 <hex.0+0x658>
    c00042ec:	91292000 	add	x0, x0, #0xa48
    c00042f0:	97fff681 	bl	c0001cf4 <mini_os_printf>
}
    c00042f4:	d503201f 	nop
    c00042f8:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c00042fc:	d65f03c0 	ret

00000000c0004300 <shell_echo_args>:

static void shell_echo_args(int argc, char *argv[])
{
    c0004300:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
    c0004304:	910003fd 	mov	x29, sp
    c0004308:	b9001fe0 	str	w0, [sp, #28]
    c000430c:	f9000be1 	str	x1, [sp, #16]
	int i;

	for (i = 1; i < argc; ++i) {
    c0004310:	52800020 	mov	w0, #0x1                   	// #1
    c0004314:	b9002fe0 	str	w0, [sp, #44]
    c0004318:	14000015 	b	c000436c <shell_echo_args+0x6c>
		mini_os_printf("%s", argv[i]);
    c000431c:	b9802fe0 	ldrsw	x0, [sp, #44]
    c0004320:	d37df000 	lsl	x0, x0, #3
    c0004324:	f9400be1 	ldr	x1, [sp, #16]
    c0004328:	8b000020 	add	x0, x1, x0
    c000432c:	f9400000 	ldr	x0, [x0]
    c0004330:	aa0003e1 	mov	x1, x0
    c0004334:	f0000000 	adrp	x0, c0007000 <hex.0+0x658>
    c0004338:	912a0000 	add	x0, x0, #0xa80
    c000433c:	97fff66e 	bl	c0001cf4 <mini_os_printf>
		if (i + 1 < argc) {
    c0004340:	b9402fe0 	ldr	w0, [sp, #44]
    c0004344:	11000400 	add	w0, w0, #0x1
    c0004348:	b9401fe1 	ldr	w1, [sp, #28]
    c000434c:	6b00003f 	cmp	w1, w0
    c0004350:	5400008d 	b.le	c0004360 <shell_echo_args+0x60>
			mini_os_printf(" ");
    c0004354:	f0000000 	adrp	x0, c0007000 <hex.0+0x658>
    c0004358:	912a2000 	add	x0, x0, #0xa88
    c000435c:	97fff666 	bl	c0001cf4 <mini_os_printf>
	for (i = 1; i < argc; ++i) {
    c0004360:	b9402fe0 	ldr	w0, [sp, #44]
    c0004364:	11000400 	add	w0, w0, #0x1
    c0004368:	b9002fe0 	str	w0, [sp, #44]
    c000436c:	b9402fe1 	ldr	w1, [sp, #44]
    c0004370:	b9401fe0 	ldr	w0, [sp, #28]
    c0004374:	6b00003f 	cmp	w1, w0
    c0004378:	54fffd2b 	b.lt	c000431c <shell_echo_args+0x1c>  // b.tstop
		}
	}
	mini_os_printf("\n");
    c000437c:	f0000000 	adrp	x0, c0007000 <hex.0+0x658>
    c0004380:	912a4000 	add	x0, x0, #0xa90
    c0004384:	97fff65c 	bl	c0001cf4 <mini_os_printf>
}
    c0004388:	d503201f 	nop
    c000438c:	a8c37bfd 	ldp	x29, x30, [sp], #48
    c0004390:	d65f03c0 	ret

00000000c0004394 <shell_clear_screen>:

static void shell_clear_screen(void)
{
    c0004394:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    c0004398:	910003fd 	mov	x29, sp
	mini_os_printf("\033[2J\033[H");
    c000439c:	f0000000 	adrp	x0, c0007000 <hex.0+0x658>
    c00043a0:	912a6000 	add	x0, x0, #0xa98
    c00043a4:	97fff654 	bl	c0001cf4 <mini_os_printf>
}
    c00043a8:	d503201f 	nop
    c00043ac:	a8c17bfd 	ldp	x29, x30, [sp], #16
    c00043b0:	d65f03c0 	ret

00000000c00043b4 <shell_halt>:

static void shell_halt(void)
{
    c00043b4:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    c00043b8:	910003fd 	mov	x29, sp
	mini_os_printf("Halting CPU. Use reset/restart in your emulator or board monitor.\n");
    c00043bc:	f0000000 	adrp	x0, c0007000 <hex.0+0x658>
    c00043c0:	912a8000 	add	x0, x0, #0xaa0
    c00043c4:	97fff64c 	bl	c0001cf4 <mini_os_printf>
	for (;;) {
		__asm__ volatile ("wfe");
    c00043c8:	d503205f 	wfe
    c00043cc:	17ffffff 	b	c00043c8 <shell_halt+0x14>

00000000c00043d0 <shell_print_smp_already_online>:
}

static void shell_print_smp_already_online(uint64_t mpidr,
					   unsigned int logical_id,
					   const struct smp_cpu_state *state)
{
    c00043d0:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
    c00043d4:	910003fd 	mov	x29, sp
    c00043d8:	f90017e0 	str	x0, [sp, #40]
    c00043dc:	b90027e1 	str	w1, [sp, #36]
    c00043e0:	f9000fe2 	str	x2, [sp, #24]
	if ((state != (const struct smp_cpu_state *)0) && state->boot_cpu) {
    c00043e4:	f9400fe0 	ldr	x0, [sp, #24]
    c00043e8:	f100001f 	cmp	x0, #0x0
    c00043ec:	54000180 	b.eq	c000441c <shell_print_smp_already_online+0x4c>  // b.none
    c00043f0:	f9400fe0 	ldr	x0, [sp, #24]
    c00043f4:	39404c00 	ldrb	w0, [x0, #19]
    c00043f8:	12000000 	and	w0, w0, #0x1
    c00043fc:	7100001f 	cmp	w0, #0x0
    c0004400:	540000e0 	b.eq	c000441c <shell_print_smp_already_online+0x4c>  // b.none
		mini_os_printf("cpu%u (mpidr=0x%llx) is the boot CPU, already online by default\n",
    c0004404:	f94017e2 	ldr	x2, [sp, #40]
    c0004408:	b94027e1 	ldr	w1, [sp, #36]
    c000440c:	f0000000 	adrp	x0, c0007000 <hex.0+0x658>
    c0004410:	912ba000 	add	x0, x0, #0xae8
    c0004414:	97fff638 	bl	c0001cf4 <mini_os_printf>
			       logical_id,
			       (unsigned long long)mpidr);
		return;
    c0004418:	14000013 	b	c0004464 <shell_print_smp_already_online+0x94>
	}

	if ((state != (const struct smp_cpu_state *)0) && state->online) {
    c000441c:	f9400fe0 	ldr	x0, [sp, #24]
    c0004420:	f100001f 	cmp	x0, #0x0
    c0004424:	54000180 	b.eq	c0004454 <shell_print_smp_already_online+0x84>  // b.none
    c0004428:	f9400fe0 	ldr	x0, [sp, #24]
    c000442c:	39404000 	ldrb	w0, [x0, #16]
    c0004430:	12000000 	and	w0, w0, #0x1
    c0004434:	7100001f 	cmp	w0, #0x0
    c0004438:	540000e0 	b.eq	c0004454 <shell_print_smp_already_online+0x84>  // b.none
		mini_os_printf("cpu%u (mpidr=0x%llx) is a secondary CPU that is already online and scheduled\n",
    c000443c:	f94017e2 	ldr	x2, [sp, #40]
    c0004440:	b94027e1 	ldr	w1, [sp, #36]
    c0004444:	f0000000 	adrp	x0, c0007000 <hex.0+0x658>
    c0004448:	912cc000 	add	x0, x0, #0xb30
    c000444c:	97fff62a 	bl	c0001cf4 <mini_os_printf>
			       logical_id,
			       (unsigned long long)mpidr);
		return;
    c0004450:	14000005 	b	c0004464 <shell_print_smp_already_online+0x94>
	}

	mini_os_printf("TF-A returned already-on for mpidr=0x%llx, but mini-os did not observe this secondary CPU actually boot\n",
    c0004454:	f94017e1 	ldr	x1, [sp, #40]
    c0004458:	f0000000 	adrp	x0, c0007000 <hex.0+0x658>
    c000445c:	912e0000 	add	x0, x0, #0xb80
    c0004460:	97fff625 	bl	c0001cf4 <mini_os_printf>
		       (unsigned long long)mpidr);
}
    c0004464:	a8c37bfd 	ldp	x29, x30, [sp], #48
    c0004468:	d65f03c0 	ret

00000000c000446c <shell_handle_smp>:

static void shell_handle_smp(int argc, char *argv[])
{
    c000446c:	a9b77bfd 	stp	x29, x30, [sp, #-144]!
    c0004470:	910003fd 	mov	x29, sp
    c0004474:	a90153f3 	stp	x19, x20, [sp, #16]
    c0004478:	a9025bf5 	stp	x21, x22, [sp, #32]
    c000447c:	b9003fe0 	str	w0, [sp, #60]
    c0004480:	f9001be1 	str	x1, [sp, #48]
	uint64_t cpu_id = 0U;
    c0004484:	f90033ff 	str	xzr, [sp, #96]
	uint64_t task_id = 0U;
    c0004488:	f9002fff 	str	xzr, [sp, #88]
	uint64_t task_arg = 0U;
    c000448c:	f9002bff 	str	xzr, [sp, #80]
	uint64_t mpidr;
	unsigned int logical_id = 0U;
    c0004490:	b90047ff 	str	wzr, [sp, #68]
	int32_t smc_ret = 0;
    c0004494:	b90043ff 	str	wzr, [sp, #64]
	int ret;
	unsigned int i;
	const struct smp_cpu_state *state = (const struct smp_cpu_state *)0;
    c0004498:	f90043ff 	str	xzr, [sp, #128]

	if (argc < 2) {
    c000449c:	b9403fe0 	ldr	w0, [sp, #60]
    c00044a0:	7100041f 	cmp	w0, #0x1
    c00044a4:	540000ac 	b.gt	c00044b8 <shell_handle_smp+0x4c>
		mini_os_printf("usage: smp status | smp start <mpidr>\n");
    c00044a8:	f0000000 	adrp	x0, c0007000 <hex.0+0x658>
    c00044ac:	912fc000 	add	x0, x0, #0xbf0
    c00044b0:	97fff611 	bl	c0001cf4 <mini_os_printf>
		return;
    c00044b4:	140001be 	b	c0004bac <shell_handle_smp+0x740>
	}

	if (strings_equal(argv[1], "status")) {
    c00044b8:	f9401be0 	ldr	x0, [sp, #48]
    c00044bc:	91002000 	add	x0, x0, #0x8
    c00044c0:	f9400002 	ldr	x2, [x0]
    c00044c4:	f0000000 	adrp	x0, c0007000 <hex.0+0x658>
    c00044c8:	91306001 	add	x1, x0, #0xc18
    c00044cc:	aa0203e0 	mov	x0, x2
    c00044d0:	97fffc0e 	bl	c0003508 <strings_equal>
    c00044d4:	12001c00 	and	w0, w0, #0xff
    c00044d8:	12000000 	and	w0, w0, #0x1
    c00044dc:	7100001f 	cmp	w0, #0x0
    c00044e0:	54000060 	b.eq	c00044ec <shell_handle_smp+0x80>  // b.none
		shell_print_cpus();
    c00044e4:	97ffff32 	bl	c00041ac <shell_print_cpus>
		return;
    c00044e8:	140001b1 	b	c0004bac <shell_handle_smp+0x740>
	}

	if (strings_equal(argv[1], "start")) {
    c00044ec:	f9401be0 	ldr	x0, [sp, #48]
    c00044f0:	91002000 	add	x0, x0, #0x8
    c00044f4:	f9400002 	ldr	x2, [x0]
    c00044f8:	f0000000 	adrp	x0, c0007000 <hex.0+0x658>
    c00044fc:	91308001 	add	x1, x0, #0xc20
    c0004500:	aa0203e0 	mov	x0, x2
    c0004504:	97fffc01 	bl	c0003508 <strings_equal>
    c0004508:	12001c00 	and	w0, w0, #0xff
    c000450c:	12000000 	and	w0, w0, #0x1
    c0004510:	7100001f 	cmp	w0, #0x0
    c0004514:	540013a0 	b.eq	c0004788 <shell_handle_smp+0x31c>  // b.none
		if (argc < 3) {
    c0004518:	b9403fe0 	ldr	w0, [sp, #60]
    c000451c:	7100081f 	cmp	w0, #0x2
    c0004520:	540000ac 	b.gt	c0004534 <shell_handle_smp+0xc8>
			mini_os_printf("usage: smp start <mpidr>\n");
    c0004524:	f0000000 	adrp	x0, c0007000 <hex.0+0x658>
    c0004528:	9130a000 	add	x0, x0, #0xc28
    c000452c:	97fff5f2 	bl	c0001cf4 <mini_os_printf>
			return;
    c0004530:	1400019f 	b	c0004bac <shell_handle_smp+0x740>
		}
		if (!parse_u64(argv[2], &mpidr)) {
    c0004534:	f9401be0 	ldr	x0, [sp, #48]
    c0004538:	91004000 	add	x0, x0, #0x10
    c000453c:	f9400000 	ldr	x0, [x0]
    c0004540:	910123e1 	add	x1, sp, #0x48
    c0004544:	97fffc34 	bl	c0003614 <parse_u64>
    c0004548:	12001c00 	and	w0, w0, #0xff
    c000454c:	52000000 	eor	w0, w0, #0x1
    c0004550:	12001c00 	and	w0, w0, #0xff
    c0004554:	12000000 	and	w0, w0, #0x1
    c0004558:	7100001f 	cmp	w0, #0x0
    c000455c:	54000120 	b.eq	c0004580 <shell_handle_smp+0x114>  // b.none
			mini_os_printf("error: invalid mpidr '%s'\n", argv[2]);
    c0004560:	f9401be0 	ldr	x0, [sp, #48]
    c0004564:	91004000 	add	x0, x0, #0x10
    c0004568:	f9400000 	ldr	x0, [x0]
    c000456c:	aa0003e1 	mov	x1, x0
    c0004570:	f0000000 	adrp	x0, c0007000 <hex.0+0x658>
    c0004574:	91312000 	add	x0, x0, #0xc48
    c0004578:	97fff5df 	bl	c0001cf4 <mini_os_printf>
			return;
    c000457c:	1400018c 	b	c0004bac <shell_handle_smp+0x740>
		}

		ret = smp_start_cpu(mpidr, &logical_id, &smc_ret);
    c0004580:	f94027e0 	ldr	x0, [sp, #72]
    c0004584:	910103e2 	add	x2, sp, #0x40
    c0004588:	910113e1 	add	x1, sp, #0x44
    c000458c:	94000571 	bl	c0005b50 <smp_start_cpu>
    c0004590:	b9006fe0 	str	w0, [sp, #108]
		state = smp_cpu_state(logical_id);
    c0004594:	b94047e0 	ldr	w0, [sp, #68]
    c0004598:	94000699 	bl	c0005ffc <smp_cpu_state>
    c000459c:	f90043e0 	str	x0, [sp, #128]

		mini_os_printf("TF-A cpu_on(mpidr=0x%llx, entry=0x%llx, ctx=cpu%u) -> smc=%d (%s)\n",
    c00045a0:	f94027f3 	ldr	x19, [sp, #72]
			       (unsigned long long)mpidr,
			       (unsigned long long)smp_secondary_entrypoint(),
    c00045a4:	94000725 	bl	c0006238 <smp_secondary_entrypoint>
    c00045a8:	aa0003f6 	mov	x22, x0
		mini_os_printf("TF-A cpu_on(mpidr=0x%llx, entry=0x%llx, ctx=cpu%u) -> smc=%d (%s)\n",
    c00045ac:	b94047f4 	ldr	w20, [sp, #68]
    c00045b0:	b94043f5 	ldr	w21, [sp, #64]
    c00045b4:	b9406fe0 	ldr	w0, [sp, #108]
    c00045b8:	9400044b 	bl	c00056e4 <smp_start_result_name>
    c00045bc:	aa0003e5 	mov	x5, x0
    c00045c0:	2a1503e4 	mov	w4, w21
    c00045c4:	2a1403e3 	mov	w3, w20
    c00045c8:	aa1603e2 	mov	x2, x22
    c00045cc:	aa1303e1 	mov	x1, x19
    c00045d0:	f0000000 	adrp	x0, c0007000 <hex.0+0x658>
    c00045d4:	9131a000 	add	x0, x0, #0xc68
    c00045d8:	97fff5c7 	bl	c0001cf4 <mini_os_printf>
			       logical_id,
			       smc_ret,
			       smp_start_result_name(ret));

		if (ret == SMP_START_OK) {
    c00045dc:	b9406fe0 	ldr	w0, [sp, #108]
    c00045e0:	7100001f 	cmp	w0, #0x0
    c00045e4:	54000661 	b.ne	c00046b0 <shell_handle_smp+0x244>  // b.any
			mini_os_printf("cpu%u power-on confirmed: online=%s scheduled=%s pending=%s runnable=%u\n",
    c00045e8:	b94047f6 	ldr	w22, [sp, #68]
    c00045ec:	f94043e0 	ldr	x0, [sp, #128]
    c00045f0:	f100001f 	cmp	x0, #0x0
    c00045f4:	54000120 	b.eq	c0004618 <shell_handle_smp+0x1ac>  // b.none
				       logical_id,
				       ((state != (const struct smp_cpu_state *)0) && state->online) ? "yes" : "no",
    c00045f8:	f94043e0 	ldr	x0, [sp, #128]
    c00045fc:	39404000 	ldrb	w0, [x0, #16]
    c0004600:	12000000 	and	w0, w0, #0x1
    c0004604:	7100001f 	cmp	w0, #0x0
    c0004608:	54000080 	b.eq	c0004618 <shell_handle_smp+0x1ac>  // b.none
			mini_os_printf("cpu%u power-on confirmed: online=%s scheduled=%s pending=%s runnable=%u\n",
    c000460c:	d0000000 	adrp	x0, c0006000 <smp_cpu_state+0x4>
    c0004610:	91300013 	add	x19, x0, #0xc00
    c0004614:	14000003 	b	c0004620 <shell_handle_smp+0x1b4>
    c0004618:	d0000000 	adrp	x0, c0006000 <smp_cpu_state+0x4>
    c000461c:	91302013 	add	x19, x0, #0xc08
    c0004620:	f94043e0 	ldr	x0, [sp, #128]
    c0004624:	f100001f 	cmp	x0, #0x0
    c0004628:	54000120 	b.eq	c000464c <shell_handle_smp+0x1e0>  // b.none
				       ((state != (const struct smp_cpu_state *)0) && state->scheduled) ? "yes" : "no",
    c000462c:	f94043e0 	ldr	x0, [sp, #128]
    c0004630:	39404400 	ldrb	w0, [x0, #17]
    c0004634:	12000000 	and	w0, w0, #0x1
    c0004638:	7100001f 	cmp	w0, #0x0
    c000463c:	54000080 	b.eq	c000464c <shell_handle_smp+0x1e0>  // b.none
			mini_os_printf("cpu%u power-on confirmed: online=%s scheduled=%s pending=%s runnable=%u\n",
    c0004640:	d0000000 	adrp	x0, c0006000 <smp_cpu_state+0x4>
    c0004644:	91300014 	add	x20, x0, #0xc00
    c0004648:	14000003 	b	c0004654 <shell_handle_smp+0x1e8>
    c000464c:	d0000000 	adrp	x0, c0006000 <smp_cpu_state+0x4>
    c0004650:	91302014 	add	x20, x0, #0xc08
    c0004654:	f94043e0 	ldr	x0, [sp, #128]
    c0004658:	f100001f 	cmp	x0, #0x0
    c000465c:	54000120 	b.eq	c0004680 <shell_handle_smp+0x214>  // b.none
				       ((state != (const struct smp_cpu_state *)0) && state->pending) ? "yes" : "no",
    c0004660:	f94043e0 	ldr	x0, [sp, #128]
    c0004664:	39404800 	ldrb	w0, [x0, #18]
    c0004668:	12000000 	and	w0, w0, #0x1
    c000466c:	7100001f 	cmp	w0, #0x0
    c0004670:	54000080 	b.eq	c0004680 <shell_handle_smp+0x214>  // b.none
			mini_os_printf("cpu%u power-on confirmed: online=%s scheduled=%s pending=%s runnable=%u\n",
    c0004674:	d0000000 	adrp	x0, c0006000 <smp_cpu_state+0x4>
    c0004678:	91300015 	add	x21, x0, #0xc00
    c000467c:	14000003 	b	c0004688 <shell_handle_smp+0x21c>
    c0004680:	d0000000 	adrp	x0, c0006000 <smp_cpu_state+0x4>
    c0004684:	91302015 	add	x21, x0, #0xc08
    c0004688:	97fffb76 	bl	c0003460 <scheduler_runnable_cpu_count>
    c000468c:	2a0003e5 	mov	w5, w0
    c0004690:	aa1503e4 	mov	x4, x21
    c0004694:	aa1403e3 	mov	x3, x20
    c0004698:	aa1303e2 	mov	x2, x19
    c000469c:	2a1603e1 	mov	w1, w22
    c00046a0:	f0000000 	adrp	x0, c0007000 <hex.0+0x658>
    c00046a4:	9132c000 	add	x0, x0, #0xcb0
    c00046a8:	97fff593 	bl	c0001cf4 <mini_os_printf>
		} else {
			mini_os_printf("cpu-on failed for mpidr=0x%llx with unexpected smc result %d\n",
				       (unsigned long long)mpidr,
				       smc_ret);
		}
		return;
    c00046ac:	14000140 	b	c0004bac <shell_handle_smp+0x740>
		} else if (ret == SMP_START_ALREADY_ONLINE) {
    c00046b0:	b9406fe0 	ldr	w0, [sp, #108]
    c00046b4:	7100041f 	cmp	w0, #0x1
    c00046b8:	540000c1 	b.ne	c00046d0 <shell_handle_smp+0x264>  // b.any
			shell_print_smp_already_online(mpidr, logical_id, state);
    c00046bc:	f94027e0 	ldr	x0, [sp, #72]
    c00046c0:	b94047e1 	ldr	w1, [sp, #68]
    c00046c4:	f94043e2 	ldr	x2, [sp, #128]
    c00046c8:	97ffff42 	bl	c00043d0 <shell_print_smp_already_online>
		return;
    c00046cc:	14000138 	b	c0004bac <shell_handle_smp+0x740>
		} else if (ret == SMP_START_INVALID_CPU) {
    c00046d0:	b9406fe0 	ldr	w0, [sp, #108]
    c00046d4:	3100041f 	cmn	w0, #0x1
    c00046d8:	54000121 	b.ne	c00046fc <shell_handle_smp+0x290>  // b.any
			mini_os_printf("TF-A reported invalid target or no logical slot left for mpidr=0x%llx (capacity=%u)\n",
    c00046dc:	f94027f3 	ldr	x19, [sp, #72]
    c00046e0:	94000797 	bl	c000653c <topology_cpu_capacity>
    c00046e4:	2a0003e2 	mov	w2, w0
    c00046e8:	aa1303e1 	mov	x1, x19
    c00046ec:	f0000000 	adrp	x0, c0007000 <hex.0+0x658>
    c00046f0:	91340000 	add	x0, x0, #0xd00
    c00046f4:	97fff580 	bl	c0001cf4 <mini_os_printf>
		return;
    c00046f8:	1400012d 	b	c0004bac <shell_handle_smp+0x740>
		} else if (ret == SMP_START_DENIED) {
    c00046fc:	b9406fe0 	ldr	w0, [sp, #108]
    c0004700:	31000c1f 	cmn	w0, #0x3
    c0004704:	540000e1 	b.ne	c0004720 <shell_handle_smp+0x2b4>  // b.any
			mini_os_printf("TF-A denied cpu-on for mpidr=0x%llx\n",
    c0004708:	f94027e0 	ldr	x0, [sp, #72]
    c000470c:	aa0003e1 	mov	x1, x0
    c0004710:	f0000000 	adrp	x0, c0007000 <hex.0+0x658>
    c0004714:	91356000 	add	x0, x0, #0xd58
    c0004718:	97fff577 	bl	c0001cf4 <mini_os_printf>
		return;
    c000471c:	14000124 	b	c0004bac <shell_handle_smp+0x740>
		} else if (ret == SMP_START_UNSUPPORTED) {
    c0004720:	b9406fe0 	ldr	w0, [sp, #108]
    c0004724:	3100081f 	cmn	w0, #0x2
    c0004728:	540000e1 	b.ne	c0004744 <shell_handle_smp+0x2d8>  // b.any
			mini_os_printf("TF-A/PSCI does not support cpu-on for mpidr=0x%llx\n",
    c000472c:	f94027e0 	ldr	x0, [sp, #72]
    c0004730:	aa0003e1 	mov	x1, x0
    c0004734:	f0000000 	adrp	x0, c0007000 <hex.0+0x658>
    c0004738:	91360000 	add	x0, x0, #0xd80
    c000473c:	97fff56e 	bl	c0001cf4 <mini_os_printf>
		return;
    c0004740:	1400011b 	b	c0004bac <shell_handle_smp+0x740>
		} else if (ret == SMP_START_TIMEOUT) {
    c0004744:	b9406fe0 	ldr	w0, [sp, #108]
    c0004748:	3100101f 	cmn	w0, #0x4
    c000474c:	540000e1 	b.ne	c0004768 <shell_handle_smp+0x2fc>  // b.any
			mini_os_printf("cpu%u did not report online before timeout; please inspect TF-A handoff or secondary entry path\n",
    c0004750:	b94047e0 	ldr	w0, [sp, #68]
    c0004754:	2a0003e1 	mov	w1, w0
    c0004758:	f0000000 	adrp	x0, c0007000 <hex.0+0x658>
    c000475c:	9136e000 	add	x0, x0, #0xdb8
    c0004760:	97fff565 	bl	c0001cf4 <mini_os_printf>
		return;
    c0004764:	14000112 	b	c0004bac <shell_handle_smp+0x740>
			mini_os_printf("cpu-on failed for mpidr=0x%llx with unexpected smc result %d\n",
    c0004768:	f94027e0 	ldr	x0, [sp, #72]
    c000476c:	b94043e1 	ldr	w1, [sp, #64]
    c0004770:	2a0103e2 	mov	w2, w1
    c0004774:	aa0003e1 	mov	x1, x0
    c0004778:	f0000000 	adrp	x0, c0007000 <hex.0+0x658>
    c000477c:	91388000 	add	x0, x0, #0xe20
    c0004780:	97fff55d 	bl	c0001cf4 <mini_os_printf>
		return;
    c0004784:	1400010a 	b	c0004bac <shell_handle_smp+0x740>
	}

	if (strings_equal(argv[1], "task")) {
    c0004788:	f9401be0 	ldr	x0, [sp, #48]
    c000478c:	91002000 	add	x0, x0, #0x8
    c0004790:	f9400002 	ldr	x2, [x0]
    c0004794:	f0000000 	adrp	x0, c0007000 <hex.0+0x658>
    c0004798:	91398001 	add	x1, x0, #0xe60
    c000479c:	aa0203e0 	mov	x0, x2
    c00047a0:	97fffb5a 	bl	c0003508 <strings_equal>
    c00047a4:	12001c00 	and	w0, w0, #0xff
    c00047a8:	12000000 	and	w0, w0, #0x1
    c00047ac:	7100001f 	cmp	w0, #0x0
    c00047b0:	54001f00 	b.eq	c0004b90 <shell_handle_smp+0x724>  // b.none
		if (argc < 3) {
    c00047b4:	b9403fe0 	ldr	w0, [sp, #60]
    c00047b8:	7100081f 	cmp	w0, #0x2
    c00047bc:	540000ac 	b.gt	c00047d0 <shell_handle_smp+0x364>
			mini_os_printf("usage: smp task add <cpu> <task> [arg] | smp task list [cpu]\n");
    c00047c0:	f0000000 	adrp	x0, c0007000 <hex.0+0x658>
    c00047c4:	9139a000 	add	x0, x0, #0xe68
    c00047c8:	97fff54b 	bl	c0001cf4 <mini_os_printf>
			return;
    c00047cc:	140000f8 	b	c0004bac <shell_handle_smp+0x740>
		}

		if (strings_equal(argv[2], "add")) {
    c00047d0:	f9401be0 	ldr	x0, [sp, #48]
    c00047d4:	91004000 	add	x0, x0, #0x10
    c00047d8:	f9400002 	ldr	x2, [x0]
    c00047dc:	f0000000 	adrp	x0, c0007000 <hex.0+0x658>
    c00047e0:	913aa001 	add	x1, x0, #0xea8
    c00047e4:	aa0203e0 	mov	x0, x2
    c00047e8:	97fffb48 	bl	c0003508 <strings_equal>
    c00047ec:	12001c00 	and	w0, w0, #0xff
    c00047f0:	12000000 	and	w0, w0, #0x1
    c00047f4:	7100001f 	cmp	w0, #0x0
    c00047f8:	54000d80 	b.eq	c00049a8 <shell_handle_smp+0x53c>  // b.none
			if (argc < 5) {
    c00047fc:	b9403fe0 	ldr	w0, [sp, #60]
    c0004800:	7100101f 	cmp	w0, #0x4
    c0004804:	540000ac 	b.gt	c0004818 <shell_handle_smp+0x3ac>
				mini_os_printf("usage: smp task add <cpu> <task> [arg]\n");
    c0004808:	f0000000 	adrp	x0, c0007000 <hex.0+0x658>
    c000480c:	913ac000 	add	x0, x0, #0xeb0
    c0004810:	97fff539 	bl	c0001cf4 <mini_os_printf>
				return;
    c0004814:	140000e6 	b	c0004bac <shell_handle_smp+0x740>
			}

			if (!parse_u64(argv[3], &cpu_id)) {
    c0004818:	f9401be0 	ldr	x0, [sp, #48]
    c000481c:	91006000 	add	x0, x0, #0x18
    c0004820:	f9400000 	ldr	x0, [x0]
    c0004824:	910183e1 	add	x1, sp, #0x60
    c0004828:	97fffb7b 	bl	c0003614 <parse_u64>
    c000482c:	12001c00 	and	w0, w0, #0xff
    c0004830:	52000000 	eor	w0, w0, #0x1
    c0004834:	12001c00 	and	w0, w0, #0xff
    c0004838:	12000000 	and	w0, w0, #0x1
    c000483c:	7100001f 	cmp	w0, #0x0
    c0004840:	54000120 	b.eq	c0004864 <shell_handle_smp+0x3f8>  // b.none
				mini_os_printf("error: invalid cpu id '%s'\n", argv[3]);
    c0004844:	f9401be0 	ldr	x0, [sp, #48]
    c0004848:	91006000 	add	x0, x0, #0x18
    c000484c:	f9400000 	ldr	x0, [x0]
    c0004850:	aa0003e1 	mov	x1, x0
    c0004854:	f0000000 	adrp	x0, c0007000 <hex.0+0x658>
    c0004858:	9125a000 	add	x0, x0, #0x968
    c000485c:	97fff526 	bl	c0001cf4 <mini_os_printf>
				return;
    c0004860:	140000d3 	b	c0004bac <shell_handle_smp+0x740>
			}

			if (!parse_u64(argv[4], &task_id)) {
    c0004864:	f9401be0 	ldr	x0, [sp, #48]
    c0004868:	91008000 	add	x0, x0, #0x20
    c000486c:	f9400000 	ldr	x0, [x0]
    c0004870:	910163e1 	add	x1, sp, #0x58
    c0004874:	97fffb68 	bl	c0003614 <parse_u64>
    c0004878:	12001c00 	and	w0, w0, #0xff
    c000487c:	52000000 	eor	w0, w0, #0x1
    c0004880:	12001c00 	and	w0, w0, #0xff
    c0004884:	12000000 	and	w0, w0, #0x1
    c0004888:	7100001f 	cmp	w0, #0x0
    c000488c:	54000120 	b.eq	c00048b0 <shell_handle_smp+0x444>  // b.none
				mini_os_printf("error: invalid task id '%s'\n", argv[4]);
    c0004890:	f9401be0 	ldr	x0, [sp, #48]
    c0004894:	91008000 	add	x0, x0, #0x20
    c0004898:	f9400000 	ldr	x0, [x0]
    c000489c:	aa0003e1 	mov	x1, x0
    c00048a0:	f0000000 	adrp	x0, c0007000 <hex.0+0x658>
    c00048a4:	913b6000 	add	x0, x0, #0xed8
    c00048a8:	97fff513 	bl	c0001cf4 <mini_os_printf>
				return;
    c00048ac:	140000c0 	b	c0004bac <shell_handle_smp+0x740>
			}

			if ((argc >= 6) && !parse_u64(argv[5], &task_arg)) {
    c00048b0:	b9403fe0 	ldr	w0, [sp, #60]
    c00048b4:	7100141f 	cmp	w0, #0x5
    c00048b8:	5400028d 	b.le	c0004908 <shell_handle_smp+0x49c>
    c00048bc:	f9401be0 	ldr	x0, [sp, #48]
    c00048c0:	9100a000 	add	x0, x0, #0x28
    c00048c4:	f9400000 	ldr	x0, [x0]
    c00048c8:	910143e1 	add	x1, sp, #0x50
    c00048cc:	97fffb52 	bl	c0003614 <parse_u64>
    c00048d0:	12001c00 	and	w0, w0, #0xff
    c00048d4:	52000000 	eor	w0, w0, #0x1
    c00048d8:	12001c00 	and	w0, w0, #0xff
    c00048dc:	12000000 	and	w0, w0, #0x1
    c00048e0:	7100001f 	cmp	w0, #0x0
    c00048e4:	54000120 	b.eq	c0004908 <shell_handle_smp+0x49c>  // b.none
				mini_os_printf("error: invalid task arg '%s'\n", argv[5]);
    c00048e8:	f9401be0 	ldr	x0, [sp, #48]
    c00048ec:	9100a000 	add	x0, x0, #0x28
    c00048f0:	f9400000 	ldr	x0, [x0]
    c00048f4:	aa0003e1 	mov	x1, x0
    c00048f8:	f0000000 	adrp	x0, c0007000 <hex.0+0x658>
    c00048fc:	913be000 	add	x0, x0, #0xef8
    c0004900:	97fff4fd 	bl	c0001cf4 <mini_os_printf>
				return;
    c0004904:	140000aa 	b	c0004bac <shell_handle_smp+0x740>
			}

			ret = smp_enqueue_task((unsigned int)cpu_id, task_id, task_arg);
    c0004908:	f94033e0 	ldr	x0, [sp, #96]
    c000490c:	2a0003e3 	mov	w3, w0
    c0004910:	f9402fe0 	ldr	x0, [sp, #88]
    c0004914:	f9402be1 	ldr	x1, [sp, #80]
    c0004918:	aa0103e2 	mov	x2, x1
    c000491c:	aa0003e1 	mov	x1, x0
    c0004920:	2a0303e0 	mov	w0, w3
    c0004924:	94000418 	bl	c0005984 <smp_enqueue_task>
    c0004928:	b9006fe0 	str	w0, [sp, #108]
			if (ret == SMP_TASK_ENQUEUE_OK) {
    c000492c:	b9406fe0 	ldr	w0, [sp, #108]
    c0004930:	7100001f 	cmp	w0, #0x0
    c0004934:	540001e1 	b.ne	c0004970 <shell_handle_smp+0x504>  // b.any
				mini_os_printf("task queued: cpu=%u task=%llu arg=%llu pending=%u\n",
    c0004938:	f94033e0 	ldr	x0, [sp, #96]
    c000493c:	2a0003f5 	mov	w21, w0
    c0004940:	f9402ff3 	ldr	x19, [sp, #88]
    c0004944:	f9402bf4 	ldr	x20, [sp, #80]
    c0004948:	f94033e0 	ldr	x0, [sp, #96]
    c000494c:	94000463 	bl	c0005ad8 <smp_pending_task_count>
    c0004950:	2a0003e4 	mov	w4, w0
    c0004954:	aa1403e3 	mov	x3, x20
    c0004958:	aa1303e2 	mov	x2, x19
    c000495c:	2a1503e1 	mov	w1, w21
    c0004960:	f0000000 	adrp	x0, c0007000 <hex.0+0x658>
    c0004964:	913c6000 	add	x0, x0, #0xf18
    c0004968:	97fff4e3 	bl	c0001cf4 <mini_os_printf>
					       (unsigned int)cpu_id,
					       (unsigned long long)task_id,
					       (unsigned long long)task_arg,
					       smp_task_enqueue_result_name(ret));
			}
			return;
    c000496c:	14000090 	b	c0004bac <shell_handle_smp+0x740>
				mini_os_printf("task queue failed: cpu=%u task=%llu arg=%llu (%s)\n",
    c0004970:	f94033e0 	ldr	x0, [sp, #96]
    c0004974:	2a0003f5 	mov	w21, w0
    c0004978:	f9402ff3 	ldr	x19, [sp, #88]
    c000497c:	f9402bf4 	ldr	x20, [sp, #80]
    c0004980:	b9406fe0 	ldr	w0, [sp, #108]
    c0004984:	940003e2 	bl	c000590c <smp_task_enqueue_result_name>
    c0004988:	aa0003e4 	mov	x4, x0
    c000498c:	aa1403e3 	mov	x3, x20
    c0004990:	aa1303e2 	mov	x2, x19
    c0004994:	2a1503e1 	mov	w1, w21
    c0004998:	f0000000 	adrp	x0, c0007000 <hex.0+0x658>
    c000499c:	913d4000 	add	x0, x0, #0xf50
    c00049a0:	97fff4d5 	bl	c0001cf4 <mini_os_printf>
			return;
    c00049a4:	14000082 	b	c0004bac <shell_handle_smp+0x740>
		}

		if (strings_equal(argv[2], "list")) {
    c00049a8:	f9401be0 	ldr	x0, [sp, #48]
    c00049ac:	91004000 	add	x0, x0, #0x10
    c00049b0:	f9400002 	ldr	x2, [x0]
    c00049b4:	f0000000 	adrp	x0, c0007000 <hex.0+0x658>
    c00049b8:	913e2001 	add	x1, x0, #0xf88
    c00049bc:	aa0203e0 	mov	x0, x2
    c00049c0:	97fffad2 	bl	c0003508 <strings_equal>
    c00049c4:	12001c00 	and	w0, w0, #0xff
    c00049c8:	12000000 	and	w0, w0, #0x1
    c00049cc:	7100001f 	cmp	w0, #0x0
    c00049d0:	54000ca0 	b.eq	c0004b64 <shell_handle_smp+0x6f8>  // b.none
			if (argc >= 4) {
    c00049d4:	b9403fe0 	ldr	w0, [sp, #60]
    c00049d8:	71000c1f 	cmp	w0, #0x3
    c00049dc:	540005ed 	b.le	c0004a98 <shell_handle_smp+0x62c>
				if (!parse_u64(argv[3], &cpu_id)) {
    c00049e0:	f9401be0 	ldr	x0, [sp, #48]
    c00049e4:	91006000 	add	x0, x0, #0x18
    c00049e8:	f9400000 	ldr	x0, [x0]
    c00049ec:	910183e1 	add	x1, sp, #0x60
    c00049f0:	97fffb09 	bl	c0003614 <parse_u64>
    c00049f4:	12001c00 	and	w0, w0, #0xff
    c00049f8:	52000000 	eor	w0, w0, #0x1
    c00049fc:	12001c00 	and	w0, w0, #0xff
    c0004a00:	12000000 	and	w0, w0, #0x1
    c0004a04:	7100001f 	cmp	w0, #0x0
    c0004a08:	54000120 	b.eq	c0004a2c <shell_handle_smp+0x5c0>  // b.none
					mini_os_printf("error: invalid cpu id '%s'\n", argv[3]);
    c0004a0c:	f9401be0 	ldr	x0, [sp, #48]
    c0004a10:	91006000 	add	x0, x0, #0x18
    c0004a14:	f9400000 	ldr	x0, [x0]
    c0004a18:	aa0003e1 	mov	x1, x0
    c0004a1c:	f0000000 	adrp	x0, c0007000 <hex.0+0x658>
    c0004a20:	9125a000 	add	x0, x0, #0x968
    c0004a24:	97fff4b4 	bl	c0001cf4 <mini_os_printf>
					return;
    c0004a28:	14000061 	b	c0004bac <shell_handle_smp+0x740>
				}

				mini_os_printf("cpu%u pending tasks=%u online=%s\n",
    c0004a2c:	f94033e0 	ldr	x0, [sp, #96]
    c0004a30:	2a0003f4 	mov	w20, w0
    c0004a34:	f94033e0 	ldr	x0, [sp, #96]
    c0004a38:	94000428 	bl	c0005ad8 <smp_pending_task_count>
    c0004a3c:	2a0003f3 	mov	w19, w0
					       (unsigned int)cpu_id,
					       smp_pending_task_count((unsigned int)cpu_id),
					       ((smp_cpu_state((unsigned int)cpu_id) != (const struct smp_cpu_state *)0) &&
    c0004a40:	f94033e0 	ldr	x0, [sp, #96]
    c0004a44:	9400056e 	bl	c0005ffc <smp_cpu_state>
				mini_os_printf("cpu%u pending tasks=%u online=%s\n",
    c0004a48:	f100001f 	cmp	x0, #0x0
    c0004a4c:	54000140 	b.eq	c0004a74 <shell_handle_smp+0x608>  // b.none
						(smp_cpu_state((unsigned int)cpu_id)->online)) ? "yes" : "no");
    c0004a50:	f94033e0 	ldr	x0, [sp, #96]
    c0004a54:	9400056a 	bl	c0005ffc <smp_cpu_state>
    c0004a58:	39404000 	ldrb	w0, [x0, #16]
					       ((smp_cpu_state((unsigned int)cpu_id) != (const struct smp_cpu_state *)0) &&
    c0004a5c:	12000000 	and	w0, w0, #0x1
    c0004a60:	7100001f 	cmp	w0, #0x0
    c0004a64:	54000080 	b.eq	c0004a74 <shell_handle_smp+0x608>  // b.none
				mini_os_printf("cpu%u pending tasks=%u online=%s\n",
    c0004a68:	d0000000 	adrp	x0, c0006000 <smp_cpu_state+0x4>
    c0004a6c:	91300000 	add	x0, x0, #0xc00
    c0004a70:	14000003 	b	c0004a7c <shell_handle_smp+0x610>
    c0004a74:	d0000000 	adrp	x0, c0006000 <smp_cpu_state+0x4>
    c0004a78:	91302000 	add	x0, x0, #0xc08
    c0004a7c:	aa0003e3 	mov	x3, x0
    c0004a80:	2a1303e2 	mov	w2, w19
    c0004a84:	2a1403e1 	mov	w1, w20
    c0004a88:	f0000000 	adrp	x0, c0007000 <hex.0+0x658>
    c0004a8c:	913e4000 	add	x0, x0, #0xf90
    c0004a90:	97fff499 	bl	c0001cf4 <mini_os_printf>
				return;
    c0004a94:	14000046 	b	c0004bac <shell_handle_smp+0x740>
			}

			for (i = 0U; i < topology_cpu_capacity(); ++i) {
    c0004a98:	b9008fff 	str	wzr, [sp, #140]
    c0004a9c:	1400002c 	b	c0004b4c <shell_handle_smp+0x6e0>
				const struct cpu_topology_descriptor *cpu = topology_cpu(i);
    c0004aa0:	b9408fe0 	ldr	w0, [sp, #140]
    c0004aa4:	94000673 	bl	c0006470 <topology_cpu>
    c0004aa8:	f9003fe0 	str	x0, [sp, #120]
				const struct smp_cpu_state *cpu_state = smp_cpu_state(i);
    c0004aac:	b9408fe0 	ldr	w0, [sp, #140]
    c0004ab0:	94000553 	bl	c0005ffc <smp_cpu_state>
    c0004ab4:	f9003be0 	str	x0, [sp, #112]

				if ((cpu == (const struct cpu_topology_descriptor *)0) || !cpu->present ||
    c0004ab8:	f9403fe0 	ldr	x0, [sp, #120]
    c0004abc:	f100001f 	cmp	x0, #0x0
    c0004ac0:	540003e0 	b.eq	c0004b3c <shell_handle_smp+0x6d0>  // b.none
    c0004ac4:	f9403fe0 	ldr	x0, [sp, #120]
    c0004ac8:	39407400 	ldrb	w0, [x0, #29]
    c0004acc:	52000000 	eor	w0, w0, #0x1
    c0004ad0:	12001c00 	and	w0, w0, #0xff
    c0004ad4:	12000000 	and	w0, w0, #0x1
    c0004ad8:	7100001f 	cmp	w0, #0x0
    c0004adc:	54000301 	b.ne	c0004b3c <shell_handle_smp+0x6d0>  // b.any
    c0004ae0:	f9403be0 	ldr	x0, [sp, #112]
    c0004ae4:	f100001f 	cmp	x0, #0x0
    c0004ae8:	540002a0 	b.eq	c0004b3c <shell_handle_smp+0x6d0>  // b.none
				    (cpu_state == (const struct smp_cpu_state *)0)) {
					continue;
				}

				mini_os_printf("cpu%u pending=%u online=%s\n",
    c0004aec:	b9408fe0 	ldr	w0, [sp, #140]
    c0004af0:	940003fa 	bl	c0005ad8 <smp_pending_task_count>
    c0004af4:	2a0003e1 	mov	w1, w0
					       i,
					       smp_pending_task_count(i),
					       cpu_state->online ? "yes" : "no");
    c0004af8:	f9403be0 	ldr	x0, [sp, #112]
    c0004afc:	39404000 	ldrb	w0, [x0, #16]
				mini_os_printf("cpu%u pending=%u online=%s\n",
    c0004b00:	12000000 	and	w0, w0, #0x1
    c0004b04:	7100001f 	cmp	w0, #0x0
    c0004b08:	54000080 	b.eq	c0004b18 <shell_handle_smp+0x6ac>  // b.none
    c0004b0c:	d0000000 	adrp	x0, c0006000 <smp_cpu_state+0x4>
    c0004b10:	91300000 	add	x0, x0, #0xc00
    c0004b14:	14000003 	b	c0004b20 <shell_handle_smp+0x6b4>
    c0004b18:	d0000000 	adrp	x0, c0006000 <smp_cpu_state+0x4>
    c0004b1c:	91302000 	add	x0, x0, #0xc08
    c0004b20:	aa0003e3 	mov	x3, x0
    c0004b24:	2a0103e2 	mov	w2, w1
    c0004b28:	b9408fe1 	ldr	w1, [sp, #140]
    c0004b2c:	f0000000 	adrp	x0, c0007000 <hex.0+0x658>
    c0004b30:	913ee000 	add	x0, x0, #0xfb8
    c0004b34:	97fff470 	bl	c0001cf4 <mini_os_printf>
    c0004b38:	14000002 	b	c0004b40 <shell_handle_smp+0x6d4>
					continue;
    c0004b3c:	d503201f 	nop
			for (i = 0U; i < topology_cpu_capacity(); ++i) {
    c0004b40:	b9408fe0 	ldr	w0, [sp, #140]
    c0004b44:	11000400 	add	w0, w0, #0x1
    c0004b48:	b9008fe0 	str	w0, [sp, #140]
    c0004b4c:	9400067c 	bl	c000653c <topology_cpu_capacity>
    c0004b50:	2a0003e1 	mov	w1, w0
    c0004b54:	b9408fe0 	ldr	w0, [sp, #140]
    c0004b58:	6b01001f 	cmp	w0, w1
    c0004b5c:	54fffa23 	b.cc	c0004aa0 <shell_handle_smp+0x634>  // b.lo, b.ul, b.last
			}
			return;
    c0004b60:	14000013 	b	c0004bac <shell_handle_smp+0x740>
		}

		mini_os_printf("unknown smp task subcommand: %s\n", argv[2]);
    c0004b64:	f9401be0 	ldr	x0, [sp, #48]
    c0004b68:	91004000 	add	x0, x0, #0x10
    c0004b6c:	f9400000 	ldr	x0, [x0]
    c0004b70:	aa0003e1 	mov	x1, x0
    c0004b74:	f0000000 	adrp	x0, c0007000 <hex.0+0x658>
    c0004b78:	913f6000 	add	x0, x0, #0xfd8
    c0004b7c:	97fff45e 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("usage: smp task add <cpu> <task> [arg] | smp task list [cpu]\n");
    c0004b80:	f0000000 	adrp	x0, c0007000 <hex.0+0x658>
    c0004b84:	9139a000 	add	x0, x0, #0xe68
    c0004b88:	97fff45b 	bl	c0001cf4 <mini_os_printf>
		return;
    c0004b8c:	14000008 	b	c0004bac <shell_handle_smp+0x740>
	}

	mini_os_printf("unknown smp subcommand: %s\n", argv[1]);
    c0004b90:	f9401be0 	ldr	x0, [sp, #48]
    c0004b94:	91002000 	add	x0, x0, #0x8
    c0004b98:	f9400000 	ldr	x0, [x0]
    c0004b9c:	aa0003e1 	mov	x1, x0
    c0004ba0:	90000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c0004ba4:	91000000 	add	x0, x0, #0x0
    c0004ba8:	97fff453 	bl	c0001cf4 <mini_os_printf>
}
    c0004bac:	a94153f3 	ldp	x19, x20, [sp, #16]
    c0004bb0:	a9425bf5 	ldp	x21, x22, [sp, #32]
    c0004bb4:	a8c97bfd 	ldp	x29, x30, [sp], #144
    c0004bb8:	d65f03c0 	ret

00000000c0004bbc <shell_execute>:

static void shell_execute(char *line)
{
    c0004bbc:	a9b97bfd 	stp	x29, x30, [sp, #-112]!
    c0004bc0:	910003fd 	mov	x29, sp
    c0004bc4:	f9000fe0 	str	x0, [sp, #24]
	char *argv[SHELL_MAX_ARGS];
	int argc;
	const char *topic;

	argc = shell_tokenize(line, argv, SHELL_MAX_ARGS);
    c0004bc8:	910083e0 	add	x0, sp, #0x20
    c0004bcc:	52800102 	mov	w2, #0x8                   	// #8
    c0004bd0:	aa0003e1 	mov	x1, x0
    c0004bd4:	f9400fe0 	ldr	x0, [sp, #24]
    c0004bd8:	97fffaf7 	bl	c00037b4 <shell_tokenize>
    c0004bdc:	b9006fe0 	str	w0, [sp, #108]
	if (argc == 0) {
    c0004be0:	b9406fe0 	ldr	w0, [sp, #108]
    c0004be4:	7100001f 	cmp	w0, #0x0
    c0004be8:	54001380 	b.eq	c0004e58 <shell_execute+0x29c>  // b.none
		return;
	}

	if (strings_equal(argv[0], "help")) {
    c0004bec:	f94013e2 	ldr	x2, [sp, #32]
    c0004bf0:	d0000000 	adrp	x0, c0006000 <smp_cpu_state+0x4>
    c0004bf4:	913f0001 	add	x1, x0, #0xfc0
    c0004bf8:	aa0203e0 	mov	x0, x2
    c0004bfc:	97fffa43 	bl	c0003508 <strings_equal>
    c0004c00:	12001c00 	and	w0, w0, #0xff
    c0004c04:	12000000 	and	w0, w0, #0x1
    c0004c08:	7100001f 	cmp	w0, #0x0
    c0004c0c:	54000180 	b.eq	c0004c3c <shell_execute+0x80>  // b.none
		if (argc >= 2) {
    c0004c10:	b9406fe0 	ldr	w0, [sp, #108]
    c0004c14:	7100041f 	cmp	w0, #0x1
    c0004c18:	540000ed 	b.le	c0004c34 <shell_execute+0x78>
			topic = shell_help_topic_name(argv[1]);
    c0004c1c:	f94017e0 	ldr	x0, [sp, #40]
    c0004c20:	97fffa63 	bl	c00035ac <shell_help_topic_name>
    c0004c24:	f90033e0 	str	x0, [sp, #96]
			shell_print_help_topic(topic);
    c0004c28:	f94033e0 	ldr	x0, [sp, #96]
    c0004c2c:	97fffbb0 	bl	c0003aec <shell_print_help_topic>
    c0004c30:	1400008b 	b	c0004e5c <shell_execute+0x2a0>
		} else {
			shell_print_help();
    c0004c34:	97fffce0 	bl	c0003fb4 <shell_print_help>
    c0004c38:	14000089 	b	c0004e5c <shell_execute+0x2a0>
		}
	} else if (strings_equal(argv[0], "version")) {
    c0004c3c:	f94013e2 	ldr	x2, [sp, #32]
    c0004c40:	f0000000 	adrp	x0, c0007000 <hex.0+0x658>
    c0004c44:	91176001 	add	x1, x0, #0x5d8
    c0004c48:	aa0203e0 	mov	x0, x2
    c0004c4c:	97fffa2f 	bl	c0003508 <strings_equal>
    c0004c50:	12001c00 	and	w0, w0, #0xff
    c0004c54:	12000000 	and	w0, w0, #0x1
    c0004c58:	7100001f 	cmp	w0, #0x0
    c0004c5c:	54000060 	b.eq	c0004c68 <shell_execute+0xac>  // b.none
		shell_print_version();
    c0004c60:	97fffcdb 	bl	c0003fcc <shell_print_version>
    c0004c64:	1400007e 	b	c0004e5c <shell_execute+0x2a0>
	} else if (strings_equal(argv[0], "info")) {
    c0004c68:	f94013e2 	ldr	x2, [sp, #32]
    c0004c6c:	f0000000 	adrp	x0, c0007000 <hex.0+0x658>
    c0004c70:	91150001 	add	x1, x0, #0x540
    c0004c74:	aa0203e0 	mov	x0, x2
    c0004c78:	97fffa24 	bl	c0003508 <strings_equal>
    c0004c7c:	12001c00 	and	w0, w0, #0xff
    c0004c80:	12000000 	and	w0, w0, #0x1
    c0004c84:	7100001f 	cmp	w0, #0x0
    c0004c88:	54000060 	b.eq	c0004c94 <shell_execute+0xd8>  // b.none
		shell_print_info();
    c0004c8c:	97fffcdd 	bl	c0004000 <shell_print_info>
    c0004c90:	14000073 	b	c0004e5c <shell_execute+0x2a0>
	} else if (strings_equal(argv[0], "cpu")) {
    c0004c94:	f94013e2 	ldr	x2, [sp, #32]
    c0004c98:	f0000000 	adrp	x0, c0007000 <hex.0+0x658>
    c0004c9c:	91014001 	add	x1, x0, #0x50
    c0004ca0:	aa0203e0 	mov	x0, x2
    c0004ca4:	97fffa19 	bl	c0003508 <strings_equal>
    c0004ca8:	12001c00 	and	w0, w0, #0xff
    c0004cac:	12000000 	and	w0, w0, #0x1
    c0004cb0:	7100001f 	cmp	w0, #0x0
    c0004cb4:	54000120 	b.eq	c0004cd8 <shell_execute+0x11c>  // b.none
		if (argc >= 2) {
    c0004cb8:	b9406fe0 	ldr	w0, [sp, #108]
    c0004cbc:	7100041f 	cmp	w0, #0x1
    c0004cc0:	5400008d 	b.le	c0004cd0 <shell_execute+0x114>
			shell_print_cpu_id(argv[1]);
    c0004cc4:	f94017e0 	ldr	x0, [sp, #40]
    c0004cc8:	97fffd10 	bl	c0004108 <shell_print_cpu_id>
    c0004ccc:	14000064 	b	c0004e5c <shell_execute+0x2a0>
		} else {
			shell_print_current_cpu();
    c0004cd0:	97fffd07 	bl	c00040ec <shell_print_current_cpu>
    c0004cd4:	14000062 	b	c0004e5c <shell_execute+0x2a0>
		}
	} else if (strings_equal(argv[0], "cpus")) {
    c0004cd8:	f94013e2 	ldr	x2, [sp, #32]
    c0004cdc:	f0000000 	adrp	x0, c0007000 <hex.0+0x658>
    c0004ce0:	91044001 	add	x1, x0, #0x110
    c0004ce4:	aa0203e0 	mov	x0, x2
    c0004ce8:	97fffa08 	bl	c0003508 <strings_equal>
    c0004cec:	12001c00 	and	w0, w0, #0xff
    c0004cf0:	12000000 	and	w0, w0, #0x1
    c0004cf4:	7100001f 	cmp	w0, #0x0
    c0004cf8:	54000060 	b.eq	c0004d04 <shell_execute+0x148>  // b.none
		shell_print_cpus();
    c0004cfc:	97fffd2c 	bl	c00041ac <shell_print_cpus>
    c0004d00:	14000057 	b	c0004e5c <shell_execute+0x2a0>
	} else if (strings_equal(argv[0], "topo")) {
    c0004d04:	f94013e2 	ldr	x2, [sp, #32]
    c0004d08:	f0000000 	adrp	x0, c0007000 <hex.0+0x658>
    c0004d0c:	91078001 	add	x1, x0, #0x1e0
    c0004d10:	aa0203e0 	mov	x0, x2
    c0004d14:	97fff9fd 	bl	c0003508 <strings_equal>
    c0004d18:	12001c00 	and	w0, w0, #0xff
    c0004d1c:	12000000 	and	w0, w0, #0x1
    c0004d20:	7100001f 	cmp	w0, #0x0
    c0004d24:	54000060 	b.eq	c0004d30 <shell_execute+0x174>  // b.none
		shell_print_topology_summary();
    c0004d28:	97fffd4a 	bl	c0004250 <shell_print_topology_summary>
    c0004d2c:	1400004c 	b	c0004e5c <shell_execute+0x2a0>
	} else if (strings_equal(argv[0], "smp")) {
    c0004d30:	f94013e2 	ldr	x2, [sp, #32]
    c0004d34:	f0000000 	adrp	x0, c0007000 <hex.0+0x658>
    c0004d38:	910a8001 	add	x1, x0, #0x2a0
    c0004d3c:	aa0203e0 	mov	x0, x2
    c0004d40:	97fff9f2 	bl	c0003508 <strings_equal>
    c0004d44:	12001c00 	and	w0, w0, #0xff
    c0004d48:	12000000 	and	w0, w0, #0x1
    c0004d4c:	7100001f 	cmp	w0, #0x0
    c0004d50:	540000c0 	b.eq	c0004d68 <shell_execute+0x1ac>  // b.none
		shell_handle_smp(argc, argv);
    c0004d54:	910083e0 	add	x0, sp, #0x20
    c0004d58:	aa0003e1 	mov	x1, x0
    c0004d5c:	b9406fe0 	ldr	w0, [sp, #108]
    c0004d60:	97fffdc3 	bl	c000446c <shell_handle_smp>
    c0004d64:	1400003e 	b	c0004e5c <shell_execute+0x2a0>
	} else if (strings_equal(argv[0], "echo")) {
    c0004d68:	f94013e2 	ldr	x2, [sp, #32]
    c0004d6c:	f0000000 	adrp	x0, c0007000 <hex.0+0x658>
    c0004d70:	91190001 	add	x1, x0, #0x640
    c0004d74:	aa0203e0 	mov	x0, x2
    c0004d78:	97fff9e4 	bl	c0003508 <strings_equal>
    c0004d7c:	12001c00 	and	w0, w0, #0xff
    c0004d80:	12000000 	and	w0, w0, #0x1
    c0004d84:	7100001f 	cmp	w0, #0x0
    c0004d88:	540000c0 	b.eq	c0004da0 <shell_execute+0x1e4>  // b.none
		shell_echo_args(argc, argv);
    c0004d8c:	910083e0 	add	x0, sp, #0x20
    c0004d90:	aa0003e1 	mov	x1, x0
    c0004d94:	b9406fe0 	ldr	w0, [sp, #108]
    c0004d98:	97fffd5a 	bl	c0004300 <shell_echo_args>
    c0004d9c:	14000030 	b	c0004e5c <shell_execute+0x2a0>
	} else if (strings_equal(argv[0], "clear")) {
    c0004da0:	f94013e2 	ldr	x2, [sp, #32]
    c0004da4:	f0000000 	adrp	x0, c0007000 <hex.0+0x658>
    c0004da8:	911ac001 	add	x1, x0, #0x6b0
    c0004dac:	aa0203e0 	mov	x0, x2
    c0004db0:	97fff9d6 	bl	c0003508 <strings_equal>
    c0004db4:	12001c00 	and	w0, w0, #0xff
    c0004db8:	12000000 	and	w0, w0, #0x1
    c0004dbc:	7100001f 	cmp	w0, #0x0
    c0004dc0:	54000060 	b.eq	c0004dcc <shell_execute+0x210>  // b.none
		shell_clear_screen();
    c0004dc4:	97fffd74 	bl	c0004394 <shell_clear_screen>
    c0004dc8:	14000025 	b	c0004e5c <shell_execute+0x2a0>
	} else if (strings_equal(argv[0], "uname")) {
    c0004dcc:	f94013e2 	ldr	x2, [sp, #32]
    c0004dd0:	f0000000 	adrp	x0, c0007000 <hex.0+0x658>
    c0004dd4:	911ce001 	add	x1, x0, #0x738
    c0004dd8:	aa0203e0 	mov	x0, x2
    c0004ddc:	97fff9cb 	bl	c0003508 <strings_equal>
    c0004de0:	12001c00 	and	w0, w0, #0xff
    c0004de4:	12000000 	and	w0, w0, #0x1
    c0004de8:	7100001f 	cmp	w0, #0x0
    c0004dec:	540000e0 	b.eq	c0004e08 <shell_execute+0x24c>  // b.none
		mini_os_printf("%s\n", MINI_OS_NAME);
    c0004df0:	f0000000 	adrp	x0, c0007000 <hex.0+0x658>
    c0004df4:	91212001 	add	x1, x0, #0x848
    c0004df8:	90000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c0004dfc:	91008000 	add	x0, x0, #0x20
    c0004e00:	97fff3bd 	bl	c0001cf4 <mini_os_printf>
    c0004e04:	14000016 	b	c0004e5c <shell_execute+0x2a0>
	} else if (strings_equal(argv[0], "halt")) {
    c0004e08:	f94013e2 	ldr	x2, [sp, #32]
    c0004e0c:	f0000000 	adrp	x0, c0007000 <hex.0+0x658>
    c0004e10:	911de001 	add	x1, x0, #0x778
    c0004e14:	aa0203e0 	mov	x0, x2
    c0004e18:	97fff9bc 	bl	c0003508 <strings_equal>
    c0004e1c:	12001c00 	and	w0, w0, #0xff
    c0004e20:	12000000 	and	w0, w0, #0x1
    c0004e24:	7100001f 	cmp	w0, #0x0
    c0004e28:	54000060 	b.eq	c0004e34 <shell_execute+0x278>  // b.none
		shell_halt();
    c0004e2c:	97fffd62 	bl	c00043b4 <shell_halt>
    c0004e30:	1400000b 	b	c0004e5c <shell_execute+0x2a0>
	} else {
		mini_os_printf("Unknown command: %s\n", argv[0]);
    c0004e34:	f94013e0 	ldr	x0, [sp, #32]
    c0004e38:	aa0003e1 	mov	x1, x0
    c0004e3c:	90000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c0004e40:	9100a000 	add	x0, x0, #0x28
    c0004e44:	97fff3ac 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("Type 'help' to list supported commands.\n");
    c0004e48:	90000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c0004e4c:	91010000 	add	x0, x0, #0x40
    c0004e50:	97fff3a9 	bl	c0001cf4 <mini_os_printf>
    c0004e54:	14000002 	b	c0004e5c <shell_execute+0x2a0>
		return;
    c0004e58:	d503201f 	nop
	}
}
    c0004e5c:	a8c77bfd 	ldp	x29, x30, [sp], #112
    c0004e60:	d65f03c0 	ret

00000000c0004e64 <shell_prompt>:

static void shell_prompt(void)
{
    c0004e64:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    c0004e68:	910003fd 	mov	x29, sp
	mini_os_printf("%s", SHELL_PROMPT);
    c0004e6c:	90000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c0004e70:	9101c001 	add	x1, x0, #0x70
    c0004e74:	f0000000 	adrp	x0, c0007000 <hex.0+0x658>
    c0004e78:	912a0000 	add	x0, x0, #0xa80
    c0004e7c:	97fff39e 	bl	c0001cf4 <mini_os_printf>
}
    c0004e80:	d503201f 	nop
    c0004e84:	a8c17bfd 	ldp	x29, x30, [sp], #16
    c0004e88:	d65f03c0 	ret

00000000c0004e8c <shell_run>:

void shell_run(void)
{
    c0004e8c:	a9b67bfd 	stp	x29, x30, [sp, #-160]!
    c0004e90:	910003fd 	mov	x29, sp
	char line[SHELL_MAX_LINE];
	size_t len = 0U;
    c0004e94:	f9004fff 	str	xzr, [sp, #152]

	shell_prompt();
    c0004e98:	97fffff3 	bl	c0004e64 <shell_prompt>
	for (;;) {
		int ch = debug_getc();
    c0004e9c:	97fff3ee 	bl	c0001e54 <debug_getc>
    c0004ea0:	b90097e0 	str	w0, [sp, #148]

		if ((ch == '\r') || (ch == '\n')) {
    c0004ea4:	b94097e0 	ldr	w0, [sp, #148]
    c0004ea8:	7100341f 	cmp	w0, #0xd
    c0004eac:	54000080 	b.eq	c0004ebc <shell_run+0x30>  // b.none
    c0004eb0:	b94097e0 	ldr	w0, [sp, #148]
    c0004eb4:	7100281f 	cmp	w0, #0xa
    c0004eb8:	54000181 	b.ne	c0004ee8 <shell_run+0x5c>  // b.any
			mini_os_printf("\n");
    c0004ebc:	f0000000 	adrp	x0, c0007000 <hex.0+0x658>
    c0004ec0:	912a4000 	add	x0, x0, #0xa90
    c0004ec4:	97fff38c 	bl	c0001cf4 <mini_os_printf>
			line[len] = '\0';
    c0004ec8:	f9404fe0 	ldr	x0, [sp, #152]
    c0004ecc:	910043e1 	add	x1, sp, #0x10
    c0004ed0:	3820683f 	strb	wzr, [x1, x0]
			shell_execute(line);
    c0004ed4:	910043e0 	add	x0, sp, #0x10
    c0004ed8:	97ffff39 	bl	c0004bbc <shell_execute>
			len = 0U;
    c0004edc:	f9004fff 	str	xzr, [sp, #152]
			shell_prompt();
    c0004ee0:	97ffffe1 	bl	c0004e64 <shell_prompt>
			continue;
    c0004ee4:	14000034 	b	c0004fb4 <shell_run+0x128>
		}

		if ((ch == '\b') || (ch == 127)) {
    c0004ee8:	b94097e0 	ldr	w0, [sp, #148]
    c0004eec:	7100201f 	cmp	w0, #0x8
    c0004ef0:	54000080 	b.eq	c0004f00 <shell_run+0x74>  // b.none
    c0004ef4:	b94097e0 	ldr	w0, [sp, #148]
    c0004ef8:	7101fc1f 	cmp	w0, #0x7f
    c0004efc:	54000161 	b.ne	c0004f28 <shell_run+0x9c>  // b.any
			if (len > 0U) {
    c0004f00:	f9404fe0 	ldr	x0, [sp, #152]
    c0004f04:	f100001f 	cmp	x0, #0x0
    c0004f08:	540004c0 	b.eq	c0004fa0 <shell_run+0x114>  // b.none
				len--;
    c0004f0c:	f9404fe0 	ldr	x0, [sp, #152]
    c0004f10:	d1000400 	sub	x0, x0, #0x1
    c0004f14:	f9004fe0 	str	x0, [sp, #152]
				mini_os_printf("\b \b");
    c0004f18:	90000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c0004f1c:	91020000 	add	x0, x0, #0x80
    c0004f20:	97fff375 	bl	c0001cf4 <mini_os_printf>
			}
			continue;
    c0004f24:	1400001f 	b	c0004fa0 <shell_run+0x114>
		}

		if (ch == '\t') {
    c0004f28:	b94097e0 	ldr	w0, [sp, #148]
    c0004f2c:	7100241f 	cmp	w0, #0x9
    c0004f30:	540003c0 	b.eq	c0004fa8 <shell_run+0x11c>  // b.none
			continue;
		}

		if ((ch < 32) || (ch > 126)) {
    c0004f34:	b94097e0 	ldr	w0, [sp, #148]
    c0004f38:	71007c1f 	cmp	w0, #0x1f
    c0004f3c:	540003ad 	b.le	c0004fb0 <shell_run+0x124>
    c0004f40:	b94097e0 	ldr	w0, [sp, #148]
    c0004f44:	7101f81f 	cmp	w0, #0x7e
    c0004f48:	5400034c 	b.gt	c0004fb0 <shell_run+0x124>
			continue;
		}

		if (len + 1U >= SHELL_MAX_LINE) {
    c0004f4c:	f9404fe0 	ldr	x0, [sp, #152]
    c0004f50:	91000400 	add	x0, x0, #0x1
    c0004f54:	f101fc1f 	cmp	x0, #0x7f
    c0004f58:	54000109 	b.ls	c0004f78 <shell_run+0xec>  // b.plast
			mini_os_printf("\nerror: command too long (max %d chars)\n",
    c0004f5c:	52800fe1 	mov	w1, #0x7f                  	// #127
    c0004f60:	90000020 	adrp	x0, c0008000 <hex.0+0x1658>
    c0004f64:	91022000 	add	x0, x0, #0x88
    c0004f68:	97fff363 	bl	c0001cf4 <mini_os_printf>
				       SHELL_MAX_LINE - 1);
			len = 0U;
    c0004f6c:	f9004fff 	str	xzr, [sp, #152]
			shell_prompt();
    c0004f70:	97ffffbd 	bl	c0004e64 <shell_prompt>
			continue;
    c0004f74:	14000010 	b	c0004fb4 <shell_run+0x128>
		}

		line[len++] = (char)ch;
    c0004f78:	f9404fe0 	ldr	x0, [sp, #152]
    c0004f7c:	91000401 	add	x1, x0, #0x1
    c0004f80:	f9004fe1 	str	x1, [sp, #152]
    c0004f84:	b94097e1 	ldr	w1, [sp, #148]
    c0004f88:	12001c22 	and	w2, w1, #0xff
    c0004f8c:	910043e1 	add	x1, sp, #0x10
    c0004f90:	38206822 	strb	w2, [x1, x0]
		debug_putc(ch);
    c0004f94:	b94097e0 	ldr	w0, [sp, #148]
    c0004f98:	97fff383 	bl	c0001da4 <debug_putc>
    c0004f9c:	17ffffc0 	b	c0004e9c <shell_run+0x10>
			continue;
    c0004fa0:	d503201f 	nop
    c0004fa4:	17ffffbe 	b	c0004e9c <shell_run+0x10>
			continue;
    c0004fa8:	d503201f 	nop
    c0004fac:	17ffffbc 	b	c0004e9c <shell_run+0x10>
			continue;
    c0004fb0:	d503201f 	nop
	for (;;) {
    c0004fb4:	17ffffba 	b	c0004e9c <shell_run+0x10>

00000000c0004fb8 <smp_read_cntfrq>:
unsigned char secondary_stacks[PLAT_MAX_CPUS][PLAT_STACK_SIZE] __attribute__((aligned(16)));

extern void secondary_cpu_entrypoint(void);

static inline uint64_t smp_read_cntfrq(void)
{
    c0004fb8:	d10043ff 	sub	sp, sp, #0x10
	uint64_t value;

	__asm__ volatile ("mrs %0, cntfrq_el0" : "=r" (value));
    c0004fbc:	d53be000 	mrs	x0, cntfrq_el0
    c0004fc0:	f90007e0 	str	x0, [sp, #8]
	return value;
    c0004fc4:	f94007e0 	ldr	x0, [sp, #8]
}
    c0004fc8:	910043ff 	add	sp, sp, #0x10
    c0004fcc:	d65f03c0 	ret

00000000c0004fd0 <smp_read_cntpct>:

static inline uint64_t smp_read_cntpct(void)
{
    c0004fd0:	d10043ff 	sub	sp, sp, #0x10
	uint64_t value;

	__asm__ volatile ("mrs %0, cntpct_el0" : "=r" (value));
    c0004fd4:	d53be020 	mrs	x0, cntpct_el0
    c0004fd8:	f90007e0 	str	x0, [sp, #8]
	return value;
    c0004fdc:	f94007e0 	ldr	x0, [sp, #8]
}
    c0004fe0:	910043ff 	add	sp, sp, #0x10
    c0004fe4:	d65f03c0 	ret

00000000c0004fe8 <smp_relax>:

static inline void smp_relax(void)
{
	__asm__ volatile ("nop");
    c0004fe8:	d503201f 	nop
}
    c0004fec:	d503201f 	nop
    c0004ff0:	d65f03c0 	ret

00000000c0004ff4 <smp_event_broadcast>:

static inline void smp_event_broadcast(void)
{
	__asm__ volatile ("dsb ishst\n\t"
    c0004ff4:	d5033a9f 	dsb	ishst
    c0004ff8:	d503209f 	sev
			  "sev\n\t"
			  :
			  :
			  : "memory");
}
    c0004ffc:	d503201f 	nop
    c0005000:	d65f03c0 	ret

00000000c0005004 <smp_ticks_from_ms>:

static uint64_t smp_ticks_from_ms(uint32_t ms)
{
    c0005004:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
    c0005008:	910003fd 	mov	x29, sp
    c000500c:	b9001fe0 	str	w0, [sp, #28]
	uint64_t freq = smp_read_cntfrq();
    c0005010:	97ffffea 	bl	c0004fb8 <smp_read_cntfrq>
    c0005014:	f90017e0 	str	x0, [sp, #40]
	uint64_t ticks;

	if (freq == 0U) {
    c0005018:	f94017e0 	ldr	x0, [sp, #40]
    c000501c:	f100001f 	cmp	x0, #0x0
    c0005020:	54000061 	b.ne	c000502c <smp_ticks_from_ms+0x28>  // b.any
		return 1U;
    c0005024:	d2800020 	mov	x0, #0x1                   	// #1
    c0005028:	14000013 	b	c0005074 <smp_ticks_from_ms+0x70>
	}

	ticks = ((uint64_t)freq * (uint64_t)ms + 999ULL) / 1000ULL;
    c000502c:	b9401fe1 	ldr	w1, [sp, #28]
    c0005030:	f94017e0 	ldr	x0, [sp, #40]
    c0005034:	9b007c20 	mul	x0, x1, x0
    c0005038:	910f9c00 	add	x0, x0, #0x3e7
    c000503c:	d343fc01 	lsr	x1, x0, #3
    c0005040:	d29ef9e0 	mov	x0, #0xf7cf                	// #63439
    c0005044:	f2bc6a60 	movk	x0, #0xe353, lsl #16
    c0005048:	f2d374a0 	movk	x0, #0x9ba5, lsl #32
    c000504c:	f2e41880 	movk	x0, #0x20c4, lsl #48
    c0005050:	9bc07c20 	umulh	x0, x1, x0
    c0005054:	d344fc00 	lsr	x0, x0, #4
    c0005058:	f90013e0 	str	x0, [sp, #32]
	if (ticks == 0U) {
    c000505c:	f94013e0 	ldr	x0, [sp, #32]
    c0005060:	f100001f 	cmp	x0, #0x0
    c0005064:	54000061 	b.ne	c0005070 <smp_ticks_from_ms+0x6c>  // b.any
		return 1U;
    c0005068:	d2800020 	mov	x0, #0x1                   	// #1
    c000506c:	14000002 	b	c0005074 <smp_ticks_from_ms+0x70>
	}

	return ticks;
    c0005070:	f94013e0 	ldr	x0, [sp, #32]
}
    c0005074:	a8c37bfd 	ldp	x29, x30, [sp], #48
    c0005078:	d65f03c0 	ret

00000000c000507c <smp_task_queue_init>:

static void smp_task_queue_init(unsigned int logical_id)
{
    c000507c:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c0005080:	910003fd 	mov	x29, sp
    c0005084:	b9001fe0 	str	w0, [sp, #28]
	if (logical_id >= PLAT_MAX_CPUS) {
    c0005088:	b9401fe0 	ldr	w0, [sp, #28]
    c000508c:	71001c1f 	cmp	w0, #0x7
    c0005090:	540005c8 	b.hi	c0005148 <smp_task_queue_init+0xcc>  // b.pmore
		return;
	}

	spinlock_init(&cpu_task_queues[logical_id].lock);
    c0005094:	b9401fe1 	ldr	w1, [sp, #28]
    c0005098:	aa0103e0 	mov	x0, x1
    c000509c:	d37ef400 	lsl	x0, x0, #2
    c00050a0:	8b010000 	add	x0, x0, x1
    c00050a4:	d37df000 	lsl	x0, x0, #3
    c00050a8:	cb010000 	sub	x0, x0, x1
    c00050ac:	d37df000 	lsl	x0, x0, #3
    c00050b0:	f0000101 	adrp	x1, c0028000 <secondary_stacks+0x1fd30>
    c00050b4:	910e4021 	add	x1, x1, #0x390
    c00050b8:	8b010000 	add	x0, x0, x1
    c00050bc:	97fff646 	bl	c00029d4 <spinlock_init>
	cpu_task_queues[logical_id].head = 0U;
    c00050c0:	f0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c00050c4:	910e4002 	add	x2, x0, #0x390
    c00050c8:	b9401fe1 	ldr	w1, [sp, #28]
    c00050cc:	aa0103e0 	mov	x0, x1
    c00050d0:	d37ef400 	lsl	x0, x0, #2
    c00050d4:	8b010000 	add	x0, x0, x1
    c00050d8:	d37df000 	lsl	x0, x0, #3
    c00050dc:	cb010000 	sub	x0, x0, x1
    c00050e0:	d37df000 	lsl	x0, x0, #3
    c00050e4:	8b000040 	add	x0, x2, x0
    c00050e8:	b901281f 	str	wzr, [x0, #296]
	cpu_task_queues[logical_id].tail = 0U;
    c00050ec:	f0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c00050f0:	910e4002 	add	x2, x0, #0x390
    c00050f4:	b9401fe1 	ldr	w1, [sp, #28]
    c00050f8:	aa0103e0 	mov	x0, x1
    c00050fc:	d37ef400 	lsl	x0, x0, #2
    c0005100:	8b010000 	add	x0, x0, x1
    c0005104:	d37df000 	lsl	x0, x0, #3
    c0005108:	cb010000 	sub	x0, x0, x1
    c000510c:	d37df000 	lsl	x0, x0, #3
    c0005110:	8b000040 	add	x0, x2, x0
    c0005114:	b9012c1f 	str	wzr, [x0, #300]
	cpu_task_queues[logical_id].count = 0U;
    c0005118:	f0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c000511c:	910e4002 	add	x2, x0, #0x390
    c0005120:	b9401fe1 	ldr	w1, [sp, #28]
    c0005124:	aa0103e0 	mov	x0, x1
    c0005128:	d37ef400 	lsl	x0, x0, #2
    c000512c:	8b010000 	add	x0, x0, x1
    c0005130:	d37df000 	lsl	x0, x0, #3
    c0005134:	cb010000 	sub	x0, x0, x1
    c0005138:	d37df000 	lsl	x0, x0, #3
    c000513c:	8b000040 	add	x0, x2, x0
    c0005140:	b901301f 	str	wzr, [x0, #304]
    c0005144:	14000002 	b	c000514c <smp_task_queue_init+0xd0>
		return;
    c0005148:	d503201f 	nop
}
    c000514c:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c0005150:	d65f03c0 	ret

00000000c0005154 <smp_task_dequeue>:

static bool smp_task_dequeue(unsigned int logical_id, struct smp_task_entry *entry)
{
    c0005154:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
    c0005158:	910003fd 	mov	x29, sp
    c000515c:	b9001fe0 	str	w0, [sp, #28]
    c0005160:	f9000be1 	str	x1, [sp, #16]
	bool has_task = false;
    c0005164:	3900bfff 	strb	wzr, [sp, #47]
	struct smp_task_queue *queue;

	if ((logical_id >= PLAT_MAX_CPUS) || (entry == (struct smp_task_entry *)0)) {
    c0005168:	b9401fe0 	ldr	w0, [sp, #28]
    c000516c:	71001c1f 	cmp	w0, #0x7
    c0005170:	54000088 	b.hi	c0005180 <smp_task_dequeue+0x2c>  // b.pmore
    c0005174:	f9400be0 	ldr	x0, [sp, #16]
    c0005178:	f100001f 	cmp	x0, #0x0
    c000517c:	54000061 	b.ne	c0005188 <smp_task_dequeue+0x34>  // b.any
		return false;
    c0005180:	52800000 	mov	w0, #0x0                   	// #0
    c0005184:	1400002f 	b	c0005240 <smp_task_dequeue+0xec>
	}

	queue = &cpu_task_queues[logical_id];
    c0005188:	b9401fe1 	ldr	w1, [sp, #28]
    c000518c:	aa0103e0 	mov	x0, x1
    c0005190:	d37ef400 	lsl	x0, x0, #2
    c0005194:	8b010000 	add	x0, x0, x1
    c0005198:	d37df000 	lsl	x0, x0, #3
    c000519c:	cb010000 	sub	x0, x0, x1
    c00051a0:	d37df000 	lsl	x0, x0, #3
    c00051a4:	f0000101 	adrp	x1, c0028000 <secondary_stacks+0x1fd30>
    c00051a8:	910e4021 	add	x1, x1, #0x390
    c00051ac:	8b010000 	add	x0, x0, x1
    c00051b0:	f90013e0 	str	x0, [sp, #32]
	spinlock_lock(&queue->lock);
    c00051b4:	f94013e0 	ldr	x0, [sp, #32]
    c00051b8:	97fff692 	bl	c0002c00 <spinlock_lock>
	if (queue->count > 0U) {
    c00051bc:	f94013e0 	ldr	x0, [sp, #32]
    c00051c0:	b9413000 	ldr	w0, [x0, #304]
    c00051c4:	7100001f 	cmp	w0, #0x0
    c00051c8:	54000360 	b.eq	c0005234 <smp_task_dequeue+0xe0>  // b.none
		*entry = queue->entries[queue->head];
    c00051cc:	f94013e0 	ldr	x0, [sp, #32]
    c00051d0:	b9412801 	ldr	w1, [x0, #296]
    c00051d4:	f9400be0 	ldr	x0, [sp, #16]
    c00051d8:	f94013e2 	ldr	x2, [sp, #32]
    c00051dc:	2a0103e1 	mov	w1, w1
    c00051e0:	91000821 	add	x1, x1, #0x2
    c00051e4:	d37cec21 	lsl	x1, x1, #4
    c00051e8:	8b010041 	add	x1, x2, x1
    c00051ec:	91002021 	add	x1, x1, #0x8
    c00051f0:	f9400022 	ldr	x2, [x1]
    c00051f4:	f9000002 	str	x2, [x0]
    c00051f8:	f9400421 	ldr	x1, [x1, #8]
    c00051fc:	f9000401 	str	x1, [x0, #8]
		queue->head = (queue->head + 1U) % SMP_TASK_QUEUE_DEPTH;
    c0005200:	f94013e0 	ldr	x0, [sp, #32]
    c0005204:	b9412800 	ldr	w0, [x0, #296]
    c0005208:	11000400 	add	w0, w0, #0x1
    c000520c:	12000c01 	and	w1, w0, #0xf
    c0005210:	f94013e0 	ldr	x0, [sp, #32]
    c0005214:	b9012801 	str	w1, [x0, #296]
		queue->count--;
    c0005218:	f94013e0 	ldr	x0, [sp, #32]
    c000521c:	b9413000 	ldr	w0, [x0, #304]
    c0005220:	51000401 	sub	w1, w0, #0x1
    c0005224:	f94013e0 	ldr	x0, [sp, #32]
    c0005228:	b9013001 	str	w1, [x0, #304]
		has_task = true;
    c000522c:	52800020 	mov	w0, #0x1                   	// #1
    c0005230:	3900bfe0 	strb	w0, [sp, #47]
	}
	spinlock_unlock(&queue->lock);
    c0005234:	f94013e0 	ldr	x0, [sp, #32]
    c0005238:	97fff67a 	bl	c0002c20 <spinlock_unlock>

	return has_task;
    c000523c:	3940bfe0 	ldrb	w0, [sp, #47]
}
    c0005240:	a8c37bfd 	ldp	x29, x30, [sp], #48
    c0005244:	d65f03c0 	ret

00000000c0005248 <smp_task_has_pending>:

static bool smp_task_has_pending(unsigned int logical_id)
{
    c0005248:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
    c000524c:	910003fd 	mov	x29, sp
    c0005250:	b9001fe0 	str	w0, [sp, #28]
	bool has_pending;
	struct smp_task_queue *queue;

	if (logical_id >= PLAT_MAX_CPUS) {
    c0005254:	b9401fe0 	ldr	w0, [sp, #28]
    c0005258:	71001c1f 	cmp	w0, #0x7
    c000525c:	54000069 	b.ls	c0005268 <smp_task_has_pending+0x20>  // b.plast
		return false;
    c0005260:	52800000 	mov	w0, #0x0                   	// #0
    c0005264:	14000016 	b	c00052bc <smp_task_has_pending+0x74>
	}

	queue = &cpu_task_queues[logical_id];
    c0005268:	b9401fe1 	ldr	w1, [sp, #28]
    c000526c:	aa0103e0 	mov	x0, x1
    c0005270:	d37ef400 	lsl	x0, x0, #2
    c0005274:	8b010000 	add	x0, x0, x1
    c0005278:	d37df000 	lsl	x0, x0, #3
    c000527c:	cb010000 	sub	x0, x0, x1
    c0005280:	d37df000 	lsl	x0, x0, #3
    c0005284:	f0000101 	adrp	x1, c0028000 <secondary_stacks+0x1fd30>
    c0005288:	910e4021 	add	x1, x1, #0x390
    c000528c:	8b010000 	add	x0, x0, x1
    c0005290:	f90017e0 	str	x0, [sp, #40]
	spinlock_lock(&queue->lock);
    c0005294:	f94017e0 	ldr	x0, [sp, #40]
    c0005298:	97fff65a 	bl	c0002c00 <spinlock_lock>
	has_pending = queue->count > 0U;
    c000529c:	f94017e0 	ldr	x0, [sp, #40]
    c00052a0:	b9413000 	ldr	w0, [x0, #304]
    c00052a4:	7100001f 	cmp	w0, #0x0
    c00052a8:	1a9f07e0 	cset	w0, ne	// ne = any
    c00052ac:	39009fe0 	strb	w0, [sp, #39]
	spinlock_unlock(&queue->lock);
    c00052b0:	f94017e0 	ldr	x0, [sp, #40]
    c00052b4:	97fff65b 	bl	c0002c20 <spinlock_unlock>

	return has_pending;
    c00052b8:	39409fe0 	ldrb	w0, [sp, #39]
}
    c00052bc:	a8c37bfd 	ldp	x29, x30, [sp], #48
    c00052c0:	d65f03c0 	ret

00000000c00052c4 <smp_execute_task>:

static void smp_execute_task(unsigned int logical_id, const struct smp_task_entry *entry)
{
    c00052c4:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c00052c8:	910003fd 	mov	x29, sp
    c00052cc:	b9001fe0 	str	w0, [sp, #28]
    c00052d0:	f9000be1 	str	x1, [sp, #16]
	if (entry == (const struct smp_task_entry *)0) {
    c00052d4:	f9400be0 	ldr	x0, [sp, #16]
    c00052d8:	f100001f 	cmp	x0, #0x0
    c00052dc:	54000180 	b.eq	c000530c <smp_execute_task+0x48>  // b.none
		return;
	}

	mini_os_printf("cpu%u task execute: id=%llu arg=%llu\n",
		       logical_id,
		       (unsigned long long)entry->task_id,
    c00052e0:	f9400be0 	ldr	x0, [sp, #16]
    c00052e4:	f9400001 	ldr	x1, [x0]
		       (unsigned long long)entry->arg);
    c00052e8:	f9400be0 	ldr	x0, [sp, #16]
    c00052ec:	f9400400 	ldr	x0, [x0, #8]
	mini_os_printf("cpu%u task execute: id=%llu arg=%llu\n",
    c00052f0:	aa0003e3 	mov	x3, x0
    c00052f4:	aa0103e2 	mov	x2, x1
    c00052f8:	b9401fe1 	ldr	w1, [sp, #28]
    c00052fc:	f0000000 	adrp	x0, c0008000 <hex.0+0x1658>
    c0005300:	9102e000 	add	x0, x0, #0xb8
    c0005304:	97fff27c 	bl	c0001cf4 <mini_os_printf>
    c0005308:	14000002 	b	c0005310 <smp_execute_task+0x4c>
		return;
    c000530c:	d503201f 	nop
}
    c0005310:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c0005314:	d65f03c0 	ret

00000000c0005318 <smp_run_pending_tasks>:

static void smp_run_pending_tasks(unsigned int logical_id)
{
    c0005318:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
    c000531c:	910003fd 	mov	x29, sp
    c0005320:	b9001fe0 	str	w0, [sp, #28]
	struct smp_task_entry entry;

	while (smp_task_dequeue(logical_id, &entry)) {
    c0005324:	14000005 	b	c0005338 <smp_run_pending_tasks+0x20>
		smp_execute_task(logical_id, &entry);
    c0005328:	910083e0 	add	x0, sp, #0x20
    c000532c:	aa0003e1 	mov	x1, x0
    c0005330:	b9401fe0 	ldr	w0, [sp, #28]
    c0005334:	97ffffe4 	bl	c00052c4 <smp_execute_task>
	while (smp_task_dequeue(logical_id, &entry)) {
    c0005338:	910083e0 	add	x0, sp, #0x20
    c000533c:	aa0003e1 	mov	x1, x0
    c0005340:	b9401fe0 	ldr	w0, [sp, #28]
    c0005344:	97ffff84 	bl	c0005154 <smp_task_dequeue>
    c0005348:	12001c00 	and	w0, w0, #0xff
    c000534c:	12000000 	and	w0, w0, #0x1
    c0005350:	7100001f 	cmp	w0, #0x0
    c0005354:	54fffea1 	b.ne	c0005328 <smp_run_pending_tasks+0x10>  // b.any
	}
}
    c0005358:	d503201f 	nop
    c000535c:	d503201f 	nop
    c0005360:	a8c37bfd 	ldp	x29, x30, [sp], #48
    c0005364:	d65f03c0 	ret

00000000c0005368 <smp_smc_call>:

static int32_t smp_smc_call(uint64_t x0, uint64_t x1, uint64_t x2, uint64_t x3)
{
    c0005368:	d10083ff 	sub	sp, sp, #0x20
    c000536c:	f9000fe0 	str	x0, [sp, #24]
    c0005370:	f9000be1 	str	x1, [sp, #16]
    c0005374:	f90007e2 	str	x2, [sp, #8]
    c0005378:	f90003e3 	str	x3, [sp]
	register uint64_t r0 __asm__("x0") = x0;
    c000537c:	f9400fe0 	ldr	x0, [sp, #24]
	register uint64_t r1 __asm__("x1") = x1;
    c0005380:	f9400be1 	ldr	x1, [sp, #16]
	register uint64_t r2 __asm__("x2") = x2;
    c0005384:	f94007e2 	ldr	x2, [sp, #8]
	register uint64_t r3 __asm__("x3") = x3;
    c0005388:	f94003e3 	ldr	x3, [sp]

	__asm__ volatile ("smc #0"
    c000538c:	d4000003 	smc	#0x0
		: "r" (r1), "r" (r2), "r" (r3)
		: "x4", "x5", "x6", "x7", "x8", "x9", "x10", "x11", "x12",
		  "x13", "x14", "x15", "x16", "x17", "memory");

	return (int32_t)r0;
}
    c0005390:	910083ff 	add	sp, sp, #0x20
    c0005394:	d65f03c0 	ret

00000000c0005398 <smp_find_free_logical_slot>:

static int smp_find_free_logical_slot(void)
{
    c0005398:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c000539c:	910003fd 	mov	x29, sp
	unsigned int i;

	for (i = 0U; i < PLAT_MAX_CPUS; ++i) {
    c00053a0:	b9001fff 	str	wzr, [sp, #28]
    c00053a4:	1400000e 	b	c00053dc <smp_find_free_logical_slot+0x44>
		if (!topology_cpu(i)->present) {
    c00053a8:	b9401fe0 	ldr	w0, [sp, #28]
    c00053ac:	94000431 	bl	c0006470 <topology_cpu>
    c00053b0:	39407400 	ldrb	w0, [x0, #29]
    c00053b4:	52000000 	eor	w0, w0, #0x1
    c00053b8:	12001c00 	and	w0, w0, #0xff
    c00053bc:	12000000 	and	w0, w0, #0x1
    c00053c0:	7100001f 	cmp	w0, #0x0
    c00053c4:	54000060 	b.eq	c00053d0 <smp_find_free_logical_slot+0x38>  // b.none
			return (int)i;
    c00053c8:	b9401fe0 	ldr	w0, [sp, #28]
    c00053cc:	14000008 	b	c00053ec <smp_find_free_logical_slot+0x54>
	for (i = 0U; i < PLAT_MAX_CPUS; ++i) {
    c00053d0:	b9401fe0 	ldr	w0, [sp, #28]
    c00053d4:	11000400 	add	w0, w0, #0x1
    c00053d8:	b9001fe0 	str	w0, [sp, #28]
    c00053dc:	b9401fe0 	ldr	w0, [sp, #28]
    c00053e0:	71001c1f 	cmp	w0, #0x7
    c00053e4:	54fffe29 	b.ls	c00053a8 <smp_find_free_logical_slot+0x10>  // b.plast
		}
	}

	return -1;
    c00053e8:	12800000 	mov	w0, #0xffffffff            	// #-1
}
    c00053ec:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c00053f0:	d65f03c0 	ret

00000000c00053f4 <smp_reset_cpu_state>:

static void smp_reset_cpu_state(unsigned int logical_id)
{
    c00053f4:	d10043ff 	sub	sp, sp, #0x10
    c00053f8:	b9000fe0 	str	w0, [sp, #12]
	if (logical_id >= PLAT_MAX_CPUS) {
    c00053fc:	b9400fe0 	ldr	w0, [sp, #12]
    c0005400:	71001c1f 	cmp	w0, #0x7
    c0005404:	54000728 	b.hi	c00054e8 <smp_reset_cpu_state+0xf4>  // b.pmore
		return;
	}

	cpu_states[logical_id].logical_id = logical_id;
    c0005408:	f0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c000540c:	910b4002 	add	x2, x0, #0x2d0
    c0005410:	b9400fe1 	ldr	w1, [sp, #12]
    c0005414:	aa0103e0 	mov	x0, x1
    c0005418:	d37ff800 	lsl	x0, x0, #1
    c000541c:	8b010000 	add	x0, x0, x1
    c0005420:	d37df000 	lsl	x0, x0, #3
    c0005424:	8b000040 	add	x0, x2, x0
    c0005428:	b9400fe1 	ldr	w1, [sp, #12]
    c000542c:	b9000001 	str	w1, [x0]
	cpu_states[logical_id].mpidr = 0U;
    c0005430:	f0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c0005434:	910b4002 	add	x2, x0, #0x2d0
    c0005438:	b9400fe1 	ldr	w1, [sp, #12]
    c000543c:	aa0103e0 	mov	x0, x1
    c0005440:	d37ff800 	lsl	x0, x0, #1
    c0005444:	8b010000 	add	x0, x0, x1
    c0005448:	d37df000 	lsl	x0, x0, #3
    c000544c:	8b000040 	add	x0, x2, x0
    c0005450:	f900041f 	str	xzr, [x0, #8]
	cpu_states[logical_id].online = false;
    c0005454:	f0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c0005458:	910b4002 	add	x2, x0, #0x2d0
    c000545c:	b9400fe1 	ldr	w1, [sp, #12]
    c0005460:	aa0103e0 	mov	x0, x1
    c0005464:	d37ff800 	lsl	x0, x0, #1
    c0005468:	8b010000 	add	x0, x0, x1
    c000546c:	d37df000 	lsl	x0, x0, #3
    c0005470:	8b000040 	add	x0, x2, x0
    c0005474:	3900401f 	strb	wzr, [x0, #16]
	cpu_states[logical_id].scheduled = false;
    c0005478:	f0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c000547c:	910b4002 	add	x2, x0, #0x2d0
    c0005480:	b9400fe1 	ldr	w1, [sp, #12]
    c0005484:	aa0103e0 	mov	x0, x1
    c0005488:	d37ff800 	lsl	x0, x0, #1
    c000548c:	8b010000 	add	x0, x0, x1
    c0005490:	d37df000 	lsl	x0, x0, #3
    c0005494:	8b000040 	add	x0, x2, x0
    c0005498:	3900441f 	strb	wzr, [x0, #17]
	cpu_states[logical_id].pending = false;
    c000549c:	f0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c00054a0:	910b4002 	add	x2, x0, #0x2d0
    c00054a4:	b9400fe1 	ldr	w1, [sp, #12]
    c00054a8:	aa0103e0 	mov	x0, x1
    c00054ac:	d37ff800 	lsl	x0, x0, #1
    c00054b0:	8b010000 	add	x0, x0, x1
    c00054b4:	d37df000 	lsl	x0, x0, #3
    c00054b8:	8b000040 	add	x0, x2, x0
    c00054bc:	3900481f 	strb	wzr, [x0, #18]
	cpu_states[logical_id].boot_cpu = false;
    c00054c0:	f0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c00054c4:	910b4002 	add	x2, x0, #0x2d0
    c00054c8:	b9400fe1 	ldr	w1, [sp, #12]
    c00054cc:	aa0103e0 	mov	x0, x1
    c00054d0:	d37ff800 	lsl	x0, x0, #1
    c00054d4:	8b010000 	add	x0, x0, x1
    c00054d8:	d37df000 	lsl	x0, x0, #3
    c00054dc:	8b000040 	add	x0, x2, x0
    c00054e0:	39004c1f 	strb	wzr, [x0, #19]
    c00054e4:	14000002 	b	c00054ec <smp_reset_cpu_state+0xf8>
		return;
    c00054e8:	d503201f 	nop
}
    c00054ec:	910043ff 	add	sp, sp, #0x10
    c00054f0:	d65f03c0 	ret

00000000c00054f4 <smp_wait_for_online>:

static bool smp_wait_for_online(unsigned int logical_id, uint32_t timeout_us)
{
    c00054f4:	a9bc7bfd 	stp	x29, x30, [sp, #-64]!
    c00054f8:	910003fd 	mov	x29, sp
    c00054fc:	b9001fe0 	str	w0, [sp, #28]
    c0005500:	b9001be1 	str	w1, [sp, #24]
	uint64_t freq;
	uint64_t start;
	uint64_t ticks;

	if (logical_id >= PLAT_MAX_CPUS) {
    c0005504:	b9401fe0 	ldr	w0, [sp, #28]
    c0005508:	71001c1f 	cmp	w0, #0x7
    c000550c:	54000069 	b.ls	c0005518 <smp_wait_for_online+0x24>  // b.plast
		return false;
    c0005510:	52800000 	mov	w0, #0x0                   	// #0
    c0005514:	14000054 	b	c0005664 <smp_wait_for_online+0x170>
	}

	if (cpu_states[logical_id].online) {
    c0005518:	f0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c000551c:	910b4002 	add	x2, x0, #0x2d0
    c0005520:	b9401fe1 	ldr	w1, [sp, #28]
    c0005524:	aa0103e0 	mov	x0, x1
    c0005528:	d37ff800 	lsl	x0, x0, #1
    c000552c:	8b010000 	add	x0, x0, x1
    c0005530:	d37df000 	lsl	x0, x0, #3
    c0005534:	8b000040 	add	x0, x2, x0
    c0005538:	39404000 	ldrb	w0, [x0, #16]
    c000553c:	12000000 	and	w0, w0, #0x1
    c0005540:	7100001f 	cmp	w0, #0x0
    c0005544:	54000060 	b.eq	c0005550 <smp_wait_for_online+0x5c>  // b.none
		return true;
    c0005548:	52800020 	mov	w0, #0x1                   	// #1
    c000554c:	14000046 	b	c0005664 <smp_wait_for_online+0x170>
	}

	freq = smp_read_cntfrq();
    c0005550:	97fffe9a 	bl	c0004fb8 <smp_read_cntfrq>
    c0005554:	f9001be0 	str	x0, [sp, #48]
	if (freq == 0U) {
    c0005558:	f9401be0 	ldr	x0, [sp, #48]
    c000555c:	f100001f 	cmp	x0, #0x0
    c0005560:	54000161 	b.ne	c000558c <smp_wait_for_online+0x98>  // b.any
		return cpu_states[logical_id].online;
    c0005564:	f0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c0005568:	910b4002 	add	x2, x0, #0x2d0
    c000556c:	b9401fe1 	ldr	w1, [sp, #28]
    c0005570:	aa0103e0 	mov	x0, x1
    c0005574:	d37ff800 	lsl	x0, x0, #1
    c0005578:	8b010000 	add	x0, x0, x1
    c000557c:	d37df000 	lsl	x0, x0, #3
    c0005580:	8b000040 	add	x0, x2, x0
    c0005584:	39404000 	ldrb	w0, [x0, #16]
    c0005588:	14000037 	b	c0005664 <smp_wait_for_online+0x170>
	}

	ticks = ((uint64_t)freq * timeout_us + 999999ULL) / 1000000ULL;
    c000558c:	b9401be1 	ldr	w1, [sp, #24]
    c0005590:	f9401be0 	ldr	x0, [sp, #48]
    c0005594:	9b007c21 	mul	x1, x1, x0
    c0005598:	d28847e0 	mov	x0, #0x423f                	// #16959
    c000559c:	f2a001e0 	movk	x0, #0xf, lsl #16
    c00055a0:	8b000021 	add	x1, x1, x0
    c00055a4:	d2869b60 	mov	x0, #0x34db                	// #13531
    c00055a8:	f2baf6c0 	movk	x0, #0xd7b6, lsl #16
    c00055ac:	f2dbd040 	movk	x0, #0xde82, lsl #32
    c00055b0:	f2e86360 	movk	x0, #0x431b, lsl #48
    c00055b4:	9bc07c20 	umulh	x0, x1, x0
    c00055b8:	d352fc00 	lsr	x0, x0, #18
    c00055bc:	f9001fe0 	str	x0, [sp, #56]
	if (ticks == 0U) {
    c00055c0:	f9401fe0 	ldr	x0, [sp, #56]
    c00055c4:	f100001f 	cmp	x0, #0x0
    c00055c8:	54000061 	b.ne	c00055d4 <smp_wait_for_online+0xe0>  // b.any
		ticks = 1U;
    c00055cc:	d2800020 	mov	x0, #0x1                   	// #1
    c00055d0:	f9001fe0 	str	x0, [sp, #56]
	}

	start = smp_read_cntpct();
    c00055d4:	97fffe7f 	bl	c0004fd0 <smp_read_cntpct>
    c00055d8:	f90017e0 	str	x0, [sp, #40]
	while (!cpu_states[logical_id].online) {
    c00055dc:	14000009 	b	c0005600 <smp_wait_for_online+0x10c>
		if ((smp_read_cntpct() - start) >= ticks) {
    c00055e0:	97fffe7c 	bl	c0004fd0 <smp_read_cntpct>
    c00055e4:	aa0003e1 	mov	x1, x0
    c00055e8:	f94017e0 	ldr	x0, [sp, #40]
    c00055ec:	cb000020 	sub	x0, x1, x0
    c00055f0:	f9401fe1 	ldr	x1, [sp, #56]
    c00055f4:	eb00003f 	cmp	x1, x0
    c00055f8:	54000229 	b.ls	c000563c <smp_wait_for_online+0x148>  // b.plast
			break;
		}
		smp_relax();
    c00055fc:	97fffe7b 	bl	c0004fe8 <smp_relax>
	while (!cpu_states[logical_id].online) {
    c0005600:	f0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c0005604:	910b4002 	add	x2, x0, #0x2d0
    c0005608:	b9401fe1 	ldr	w1, [sp, #28]
    c000560c:	aa0103e0 	mov	x0, x1
    c0005610:	d37ff800 	lsl	x0, x0, #1
    c0005614:	8b010000 	add	x0, x0, x1
    c0005618:	d37df000 	lsl	x0, x0, #3
    c000561c:	8b000040 	add	x0, x2, x0
    c0005620:	39404000 	ldrb	w0, [x0, #16]
    c0005624:	52000000 	eor	w0, w0, #0x1
    c0005628:	12001c00 	and	w0, w0, #0xff
    c000562c:	12000000 	and	w0, w0, #0x1
    c0005630:	7100001f 	cmp	w0, #0x0
    c0005634:	54fffd61 	b.ne	c00055e0 <smp_wait_for_online+0xec>  // b.any
    c0005638:	14000002 	b	c0005640 <smp_wait_for_online+0x14c>
			break;
    c000563c:	d503201f 	nop
	}

	return cpu_states[logical_id].online;
    c0005640:	f0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c0005644:	910b4002 	add	x2, x0, #0x2d0
    c0005648:	b9401fe1 	ldr	w1, [sp, #28]
    c000564c:	aa0103e0 	mov	x0, x1
    c0005650:	d37ff800 	lsl	x0, x0, #1
    c0005654:	8b010000 	add	x0, x0, x1
    c0005658:	d37df000 	lsl	x0, x0, #3
    c000565c:	8b000040 	add	x0, x2, x0
    c0005660:	39404000 	ldrb	w0, [x0, #16]
}
    c0005664:	a8c47bfd 	ldp	x29, x30, [sp], #64
    c0005668:	d65f03c0 	ret

00000000c000566c <smp_map_psci_result>:

static int smp_map_psci_result(int32_t ret)
{
    c000566c:	d10043ff 	sub	sp, sp, #0x10
    c0005670:	b9000fe0 	str	w0, [sp, #12]
	if (ret == PSCI_RET_SUCCESS) {
    c0005674:	b9400fe0 	ldr	w0, [sp, #12]
    c0005678:	7100001f 	cmp	w0, #0x0
    c000567c:	54000061 	b.ne	c0005688 <smp_map_psci_result+0x1c>  // b.any
		return SMP_START_OK;
    c0005680:	52800000 	mov	w0, #0x0                   	// #0
    c0005684:	14000016 	b	c00056dc <smp_map_psci_result+0x70>
	}
	if (ret == PSCI_RET_ALREADY_ON) {
    c0005688:	b9400fe0 	ldr	w0, [sp, #12]
    c000568c:	3100101f 	cmn	w0, #0x4
    c0005690:	54000061 	b.ne	c000569c <smp_map_psci_result+0x30>  // b.any
		return SMP_START_ALREADY_ONLINE;
    c0005694:	52800020 	mov	w0, #0x1                   	// #1
    c0005698:	14000011 	b	c00056dc <smp_map_psci_result+0x70>
	}
	if (ret == PSCI_RET_INVALID_PARAMS) {
    c000569c:	b9400fe0 	ldr	w0, [sp, #12]
    c00056a0:	3100081f 	cmn	w0, #0x2
    c00056a4:	54000061 	b.ne	c00056b0 <smp_map_psci_result+0x44>  // b.any
		return SMP_START_INVALID_CPU;
    c00056a8:	12800000 	mov	w0, #0xffffffff            	// #-1
    c00056ac:	1400000c 	b	c00056dc <smp_map_psci_result+0x70>
	}
	if (ret == PSCI_RET_DENIED) {
    c00056b0:	b9400fe0 	ldr	w0, [sp, #12]
    c00056b4:	31000c1f 	cmn	w0, #0x3
    c00056b8:	54000061 	b.ne	c00056c4 <smp_map_psci_result+0x58>  // b.any
		return SMP_START_DENIED;
    c00056bc:	12800040 	mov	w0, #0xfffffffd            	// #-3
    c00056c0:	14000007 	b	c00056dc <smp_map_psci_result+0x70>
	}
	if (ret == PSCI_RET_NOT_SUPPORTED) {
    c00056c4:	b9400fe0 	ldr	w0, [sp, #12]
    c00056c8:	3100041f 	cmn	w0, #0x1
    c00056cc:	54000061 	b.ne	c00056d8 <smp_map_psci_result+0x6c>  // b.any
		return SMP_START_UNSUPPORTED;
    c00056d0:	12800020 	mov	w0, #0xfffffffe            	// #-2
    c00056d4:	14000002 	b	c00056dc <smp_map_psci_result+0x70>
	}

	return SMP_START_FAILED;
    c00056d8:	12800080 	mov	w0, #0xfffffffb            	// #-5
}
    c00056dc:	910043ff 	add	sp, sp, #0x10
    c00056e0:	d65f03c0 	ret

00000000c00056e4 <smp_start_result_name>:

const char *smp_start_result_name(int result)
{
    c00056e4:	d10043ff 	sub	sp, sp, #0x10
    c00056e8:	b9000fe0 	str	w0, [sp, #12]
	if (result == SMP_START_OK) {
    c00056ec:	b9400fe0 	ldr	w0, [sp, #12]
    c00056f0:	7100001f 	cmp	w0, #0x0
    c00056f4:	54000081 	b.ne	c0005704 <smp_start_result_name+0x20>  // b.any
		return "ok";
    c00056f8:	f0000000 	adrp	x0, c0008000 <hex.0+0x1658>
    c00056fc:	91038000 	add	x0, x0, #0xe0
    c0005700:	14000021 	b	c0005784 <smp_start_result_name+0xa0>
	}
	if (result == SMP_START_ALREADY_ONLINE) {
    c0005704:	b9400fe0 	ldr	w0, [sp, #12]
    c0005708:	7100041f 	cmp	w0, #0x1
    c000570c:	54000081 	b.ne	c000571c <smp_start_result_name+0x38>  // b.any
		return "already-on";
    c0005710:	f0000000 	adrp	x0, c0008000 <hex.0+0x1658>
    c0005714:	9103a000 	add	x0, x0, #0xe8
    c0005718:	1400001b 	b	c0005784 <smp_start_result_name+0xa0>
	}
	if (result == SMP_START_INVALID_CPU) {
    c000571c:	b9400fe0 	ldr	w0, [sp, #12]
    c0005720:	3100041f 	cmn	w0, #0x1
    c0005724:	54000081 	b.ne	c0005734 <smp_start_result_name+0x50>  // b.any
		return "invalid-params";
    c0005728:	f0000000 	adrp	x0, c0008000 <hex.0+0x1658>
    c000572c:	9103e000 	add	x0, x0, #0xf8
    c0005730:	14000015 	b	c0005784 <smp_start_result_name+0xa0>
	}
	if (result == SMP_START_UNSUPPORTED) {
    c0005734:	b9400fe0 	ldr	w0, [sp, #12]
    c0005738:	3100081f 	cmn	w0, #0x2
    c000573c:	54000081 	b.ne	c000574c <smp_start_result_name+0x68>  // b.any
		return "not-supported";
    c0005740:	f0000000 	adrp	x0, c0008000 <hex.0+0x1658>
    c0005744:	91042000 	add	x0, x0, #0x108
    c0005748:	1400000f 	b	c0005784 <smp_start_result_name+0xa0>
	}
	if (result == SMP_START_DENIED) {
    c000574c:	b9400fe0 	ldr	w0, [sp, #12]
    c0005750:	31000c1f 	cmn	w0, #0x3
    c0005754:	54000081 	b.ne	c0005764 <smp_start_result_name+0x80>  // b.any
		return "denied";
    c0005758:	f0000000 	adrp	x0, c0008000 <hex.0+0x1658>
    c000575c:	91046000 	add	x0, x0, #0x118
    c0005760:	14000009 	b	c0005784 <smp_start_result_name+0xa0>
	}
	if (result == SMP_START_TIMEOUT) {
    c0005764:	b9400fe0 	ldr	w0, [sp, #12]
    c0005768:	3100101f 	cmn	w0, #0x4
    c000576c:	54000081 	b.ne	c000577c <smp_start_result_name+0x98>  // b.any
		return "timeout";
    c0005770:	f0000000 	adrp	x0, c0008000 <hex.0+0x1658>
    c0005774:	91048000 	add	x0, x0, #0x120
    c0005778:	14000003 	b	c0005784 <smp_start_result_name+0xa0>
	}

	return "failed";
    c000577c:	f0000000 	adrp	x0, c0008000 <hex.0+0x1658>
    c0005780:	9104a000 	add	x0, x0, #0x128
}
    c0005784:	910043ff 	add	sp, sp, #0x10
    c0005788:	d65f03c0 	ret

00000000c000578c <smp_init>:

void smp_init(void)
{
    c000578c:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c0005790:	910003fd 	mov	x29, sp
	unsigned int i;
	const struct cpu_topology_descriptor *boot_cpu = topology_boot_cpu();
    c0005794:	94000334 	bl	c0006464 <topology_boot_cpu>
    c0005798:	f9000be0 	str	x0, [sp, #16]

	for (i = 0U; i < PLAT_MAX_CPUS; ++i) {
    c000579c:	b9001fff 	str	wzr, [sp, #28]
    c00057a0:	1400003d 	b	c0005894 <smp_init+0x108>
		cpu_states[i].logical_id = i;
    c00057a4:	f0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c00057a8:	910b4002 	add	x2, x0, #0x2d0
    c00057ac:	b9401fe1 	ldr	w1, [sp, #28]
    c00057b0:	aa0103e0 	mov	x0, x1
    c00057b4:	d37ff800 	lsl	x0, x0, #1
    c00057b8:	8b010000 	add	x0, x0, x1
    c00057bc:	d37df000 	lsl	x0, x0, #3
    c00057c0:	8b000040 	add	x0, x2, x0
    c00057c4:	b9401fe1 	ldr	w1, [sp, #28]
    c00057c8:	b9000001 	str	w1, [x0]
		cpu_states[i].mpidr = 0U;
    c00057cc:	f0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c00057d0:	910b4002 	add	x2, x0, #0x2d0
    c00057d4:	b9401fe1 	ldr	w1, [sp, #28]
    c00057d8:	aa0103e0 	mov	x0, x1
    c00057dc:	d37ff800 	lsl	x0, x0, #1
    c00057e0:	8b010000 	add	x0, x0, x1
    c00057e4:	d37df000 	lsl	x0, x0, #3
    c00057e8:	8b000040 	add	x0, x2, x0
    c00057ec:	f900041f 	str	xzr, [x0, #8]
		cpu_states[i].online = false;
    c00057f0:	f0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c00057f4:	910b4002 	add	x2, x0, #0x2d0
    c00057f8:	b9401fe1 	ldr	w1, [sp, #28]
    c00057fc:	aa0103e0 	mov	x0, x1
    c0005800:	d37ff800 	lsl	x0, x0, #1
    c0005804:	8b010000 	add	x0, x0, x1
    c0005808:	d37df000 	lsl	x0, x0, #3
    c000580c:	8b000040 	add	x0, x2, x0
    c0005810:	3900401f 	strb	wzr, [x0, #16]
		cpu_states[i].scheduled = false;
    c0005814:	f0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c0005818:	910b4002 	add	x2, x0, #0x2d0
    c000581c:	b9401fe1 	ldr	w1, [sp, #28]
    c0005820:	aa0103e0 	mov	x0, x1
    c0005824:	d37ff800 	lsl	x0, x0, #1
    c0005828:	8b010000 	add	x0, x0, x1
    c000582c:	d37df000 	lsl	x0, x0, #3
    c0005830:	8b000040 	add	x0, x2, x0
    c0005834:	3900441f 	strb	wzr, [x0, #17]
		cpu_states[i].pending = false;
    c0005838:	f0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c000583c:	910b4002 	add	x2, x0, #0x2d0
    c0005840:	b9401fe1 	ldr	w1, [sp, #28]
    c0005844:	aa0103e0 	mov	x0, x1
    c0005848:	d37ff800 	lsl	x0, x0, #1
    c000584c:	8b010000 	add	x0, x0, x1
    c0005850:	d37df000 	lsl	x0, x0, #3
    c0005854:	8b000040 	add	x0, x2, x0
    c0005858:	3900481f 	strb	wzr, [x0, #18]
		cpu_states[i].boot_cpu = false;
    c000585c:	f0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c0005860:	910b4002 	add	x2, x0, #0x2d0
    c0005864:	b9401fe1 	ldr	w1, [sp, #28]
    c0005868:	aa0103e0 	mov	x0, x1
    c000586c:	d37ff800 	lsl	x0, x0, #1
    c0005870:	8b010000 	add	x0, x0, x1
    c0005874:	d37df000 	lsl	x0, x0, #3
    c0005878:	8b000040 	add	x0, x2, x0
    c000587c:	39004c1f 	strb	wzr, [x0, #19]
		smp_task_queue_init(i);
    c0005880:	b9401fe0 	ldr	w0, [sp, #28]
    c0005884:	97fffdfe 	bl	c000507c <smp_task_queue_init>
	for (i = 0U; i < PLAT_MAX_CPUS; ++i) {
    c0005888:	b9401fe0 	ldr	w0, [sp, #28]
    c000588c:	11000400 	add	w0, w0, #0x1
    c0005890:	b9001fe0 	str	w0, [sp, #28]
    c0005894:	b9401fe0 	ldr	w0, [sp, #28]
    c0005898:	71001c1f 	cmp	w0, #0x7
    c000589c:	54fff849 	b.ls	c00057a4 <smp_init+0x18>  // b.plast
	}

	cpu_states[0].logical_id = 0U;
    c00058a0:	f0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c00058a4:	910b4000 	add	x0, x0, #0x2d0
    c00058a8:	b900001f 	str	wzr, [x0]
	cpu_states[0].mpidr = boot_cpu->mpidr;
    c00058ac:	f9400be0 	ldr	x0, [sp, #16]
    c00058b0:	f9400001 	ldr	x1, [x0]
    c00058b4:	f0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c00058b8:	910b4000 	add	x0, x0, #0x2d0
    c00058bc:	f9000401 	str	x1, [x0, #8]
	cpu_states[0].boot_cpu = true;
    c00058c0:	f0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c00058c4:	910b4000 	add	x0, x0, #0x2d0
    c00058c8:	52800021 	mov	w1, #0x1                   	// #1
    c00058cc:	39004c01 	strb	w1, [x0, #19]
	cpu_states[0].online = true;
    c00058d0:	f0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c00058d4:	910b4000 	add	x0, x0, #0x2d0
    c00058d8:	52800021 	mov	w1, #0x1                   	// #1
    c00058dc:	39004001 	strb	w1, [x0, #16]
	cpu_states[0].scheduled = true;
    c00058e0:	f0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c00058e4:	910b4000 	add	x0, x0, #0x2d0
    c00058e8:	52800021 	mov	w1, #0x1                   	// #1
    c00058ec:	39004401 	strb	w1, [x0, #17]
	online_cpu_count = 1U;
    c00058f0:	f0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c00058f4:	91354000 	add	x0, x0, #0xd50
    c00058f8:	52800021 	mov	w1, #0x1                   	// #1
    c00058fc:	b9000001 	str	w1, [x0]
}
    c0005900:	d503201f 	nop
    c0005904:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c0005908:	d65f03c0 	ret

00000000c000590c <smp_task_enqueue_result_name>:

const char *smp_task_enqueue_result_name(int result)
{
    c000590c:	d10043ff 	sub	sp, sp, #0x10
    c0005910:	b9000fe0 	str	w0, [sp, #12]
	if (result == SMP_TASK_ENQUEUE_OK) {
    c0005914:	b9400fe0 	ldr	w0, [sp, #12]
    c0005918:	7100001f 	cmp	w0, #0x0
    c000591c:	54000081 	b.ne	c000592c <smp_task_enqueue_result_name+0x20>  // b.any
		return "ok";
    c0005920:	f0000000 	adrp	x0, c0008000 <hex.0+0x1658>
    c0005924:	91038000 	add	x0, x0, #0xe0
    c0005928:	14000015 	b	c000597c <smp_task_enqueue_result_name+0x70>
	}
	if (result == SMP_TASK_ENQUEUE_INVALID_CPU) {
    c000592c:	b9400fe0 	ldr	w0, [sp, #12]
    c0005930:	3100041f 	cmn	w0, #0x1
    c0005934:	54000081 	b.ne	c0005944 <smp_task_enqueue_result_name+0x38>  // b.any
		return "invalid-cpu";
    c0005938:	f0000000 	adrp	x0, c0008000 <hex.0+0x1658>
    c000593c:	9104c000 	add	x0, x0, #0x130
    c0005940:	1400000f 	b	c000597c <smp_task_enqueue_result_name+0x70>
	}
	if (result == SMP_TASK_ENQUEUE_OFFLINE) {
    c0005944:	b9400fe0 	ldr	w0, [sp, #12]
    c0005948:	3100081f 	cmn	w0, #0x2
    c000594c:	54000081 	b.ne	c000595c <smp_task_enqueue_result_name+0x50>  // b.any
		return "cpu-offline";
    c0005950:	f0000000 	adrp	x0, c0008000 <hex.0+0x1658>
    c0005954:	91050000 	add	x0, x0, #0x140
    c0005958:	14000009 	b	c000597c <smp_task_enqueue_result_name+0x70>
	}
	if (result == SMP_TASK_ENQUEUE_FULL) {
    c000595c:	b9400fe0 	ldr	w0, [sp, #12]
    c0005960:	31000c1f 	cmn	w0, #0x3
    c0005964:	54000081 	b.ne	c0005974 <smp_task_enqueue_result_name+0x68>  // b.any
		return "queue-full";
    c0005968:	f0000000 	adrp	x0, c0008000 <hex.0+0x1658>
    c000596c:	91054000 	add	x0, x0, #0x150
    c0005970:	14000003 	b	c000597c <smp_task_enqueue_result_name+0x70>
	}

	return "failed";
    c0005974:	f0000000 	adrp	x0, c0008000 <hex.0+0x1658>
    c0005978:	9104a000 	add	x0, x0, #0x128
}
    c000597c:	910043ff 	add	sp, sp, #0x10
    c0005980:	d65f03c0 	ret

00000000c0005984 <smp_enqueue_task>:

int smp_enqueue_task(unsigned int logical_id, uint64_t task_id, uint64_t arg)
{
    c0005984:	a9bc7bfd 	stp	x29, x30, [sp, #-64]!
    c0005988:	910003fd 	mov	x29, sp
    c000598c:	b9002fe0 	str	w0, [sp, #44]
    c0005990:	f90013e1 	str	x1, [sp, #32]
    c0005994:	f9000fe2 	str	x2, [sp, #24]
	struct smp_task_queue *queue;
	int result = SMP_TASK_ENQUEUE_OK;
    c0005998:	b9003fff 	str	wzr, [sp, #60]

	if (logical_id >= PLAT_MAX_CPUS) {
    c000599c:	b9402fe0 	ldr	w0, [sp, #44]
    c00059a0:	71001c1f 	cmp	w0, #0x7
    c00059a4:	54000069 	b.ls	c00059b0 <smp_enqueue_task+0x2c>  // b.plast
		return SMP_TASK_ENQUEUE_INVALID_CPU;
    c00059a8:	12800000 	mov	w0, #0xffffffff            	// #-1
    c00059ac:	14000049 	b	c0005ad0 <smp_enqueue_task+0x14c>
	}

	if (!cpu_states[logical_id].online) {
    c00059b0:	f0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c00059b4:	910b4002 	add	x2, x0, #0x2d0
    c00059b8:	b9402fe1 	ldr	w1, [sp, #44]
    c00059bc:	aa0103e0 	mov	x0, x1
    c00059c0:	d37ff800 	lsl	x0, x0, #1
    c00059c4:	8b010000 	add	x0, x0, x1
    c00059c8:	d37df000 	lsl	x0, x0, #3
    c00059cc:	8b000040 	add	x0, x2, x0
    c00059d0:	39404000 	ldrb	w0, [x0, #16]
    c00059d4:	52000000 	eor	w0, w0, #0x1
    c00059d8:	12001c00 	and	w0, w0, #0xff
    c00059dc:	12000000 	and	w0, w0, #0x1
    c00059e0:	7100001f 	cmp	w0, #0x0
    c00059e4:	54000060 	b.eq	c00059f0 <smp_enqueue_task+0x6c>  // b.none
		return SMP_TASK_ENQUEUE_OFFLINE;
    c00059e8:	12800020 	mov	w0, #0xfffffffe            	// #-2
    c00059ec:	14000039 	b	c0005ad0 <smp_enqueue_task+0x14c>
	}

	queue = &cpu_task_queues[logical_id];
    c00059f0:	b9402fe1 	ldr	w1, [sp, #44]
    c00059f4:	aa0103e0 	mov	x0, x1
    c00059f8:	d37ef400 	lsl	x0, x0, #2
    c00059fc:	8b010000 	add	x0, x0, x1
    c0005a00:	d37df000 	lsl	x0, x0, #3
    c0005a04:	cb010000 	sub	x0, x0, x1
    c0005a08:	d37df000 	lsl	x0, x0, #3
    c0005a0c:	f0000101 	adrp	x1, c0028000 <secondary_stacks+0x1fd30>
    c0005a10:	910e4021 	add	x1, x1, #0x390
    c0005a14:	8b010000 	add	x0, x0, x1
    c0005a18:	f9001be0 	str	x0, [sp, #48]
	spinlock_lock(&queue->lock);
    c0005a1c:	f9401be0 	ldr	x0, [sp, #48]
    c0005a20:	97fff478 	bl	c0002c00 <spinlock_lock>
	if (queue->count >= SMP_TASK_QUEUE_DEPTH) {
    c0005a24:	f9401be0 	ldr	x0, [sp, #48]
    c0005a28:	b9413000 	ldr	w0, [x0, #304]
    c0005a2c:	71003c1f 	cmp	w0, #0xf
    c0005a30:	54000089 	b.ls	c0005a40 <smp_enqueue_task+0xbc>  // b.plast
		result = SMP_TASK_ENQUEUE_FULL;
    c0005a34:	12800040 	mov	w0, #0xfffffffd            	// #-3
    c0005a38:	b9003fe0 	str	w0, [sp, #60]
    c0005a3c:	1400001e 	b	c0005ab4 <smp_enqueue_task+0x130>
	} else {
		queue->entries[queue->tail].task_id = task_id;
    c0005a40:	f9401be0 	ldr	x0, [sp, #48]
    c0005a44:	b9412c00 	ldr	w0, [x0, #300]
    c0005a48:	f9401be1 	ldr	x1, [sp, #48]
    c0005a4c:	2a0003e0 	mov	w0, w0
    c0005a50:	91000800 	add	x0, x0, #0x2
    c0005a54:	d37cec00 	lsl	x0, x0, #4
    c0005a58:	8b000020 	add	x0, x1, x0
    c0005a5c:	f94013e1 	ldr	x1, [sp, #32]
    c0005a60:	f9000401 	str	x1, [x0, #8]
		queue->entries[queue->tail].arg = arg;
    c0005a64:	f9401be0 	ldr	x0, [sp, #48]
    c0005a68:	b9412c00 	ldr	w0, [x0, #300]
    c0005a6c:	f9401be1 	ldr	x1, [sp, #48]
    c0005a70:	2a0003e0 	mov	w0, w0
    c0005a74:	91000800 	add	x0, x0, #0x2
    c0005a78:	d37cec00 	lsl	x0, x0, #4
    c0005a7c:	8b000020 	add	x0, x1, x0
    c0005a80:	f9400fe1 	ldr	x1, [sp, #24]
    c0005a84:	f9000801 	str	x1, [x0, #16]
		queue->tail = (queue->tail + 1U) % SMP_TASK_QUEUE_DEPTH;
    c0005a88:	f9401be0 	ldr	x0, [sp, #48]
    c0005a8c:	b9412c00 	ldr	w0, [x0, #300]
    c0005a90:	11000400 	add	w0, w0, #0x1
    c0005a94:	12000c01 	and	w1, w0, #0xf
    c0005a98:	f9401be0 	ldr	x0, [sp, #48]
    c0005a9c:	b9012c01 	str	w1, [x0, #300]
		queue->count++;
    c0005aa0:	f9401be0 	ldr	x0, [sp, #48]
    c0005aa4:	b9413000 	ldr	w0, [x0, #304]
    c0005aa8:	11000401 	add	w1, w0, #0x1
    c0005aac:	f9401be0 	ldr	x0, [sp, #48]
    c0005ab0:	b9013001 	str	w1, [x0, #304]
	}
	spinlock_unlock(&queue->lock);
    c0005ab4:	f9401be0 	ldr	x0, [sp, #48]
    c0005ab8:	97fff45a 	bl	c0002c20 <spinlock_unlock>

	if (result == SMP_TASK_ENQUEUE_OK) {
    c0005abc:	b9403fe0 	ldr	w0, [sp, #60]
    c0005ac0:	7100001f 	cmp	w0, #0x0
    c0005ac4:	54000041 	b.ne	c0005acc <smp_enqueue_task+0x148>  // b.any
		smp_event_broadcast();
    c0005ac8:	97fffd4b 	bl	c0004ff4 <smp_event_broadcast>
	}

	return result;
    c0005acc:	b9403fe0 	ldr	w0, [sp, #60]
}
    c0005ad0:	a8c47bfd 	ldp	x29, x30, [sp], #64
    c0005ad4:	d65f03c0 	ret

00000000c0005ad8 <smp_pending_task_count>:

unsigned int smp_pending_task_count(unsigned int logical_id)
{
    c0005ad8:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
    c0005adc:	910003fd 	mov	x29, sp
    c0005ae0:	b9001fe0 	str	w0, [sp, #28]
	struct smp_task_queue *queue;
	unsigned int count = 0U;
    c0005ae4:	b9002fff 	str	wzr, [sp, #44]

	if (logical_id >= PLAT_MAX_CPUS) {
    c0005ae8:	b9401fe0 	ldr	w0, [sp, #28]
    c0005aec:	71001c1f 	cmp	w0, #0x7
    c0005af0:	54000069 	b.ls	c0005afc <smp_pending_task_count+0x24>  // b.plast
		return 0U;
    c0005af4:	52800000 	mov	w0, #0x0                   	// #0
    c0005af8:	14000014 	b	c0005b48 <smp_pending_task_count+0x70>
	}

	queue = &cpu_task_queues[logical_id];
    c0005afc:	b9401fe1 	ldr	w1, [sp, #28]
    c0005b00:	aa0103e0 	mov	x0, x1
    c0005b04:	d37ef400 	lsl	x0, x0, #2
    c0005b08:	8b010000 	add	x0, x0, x1
    c0005b0c:	d37df000 	lsl	x0, x0, #3
    c0005b10:	cb010000 	sub	x0, x0, x1
    c0005b14:	d37df000 	lsl	x0, x0, #3
    c0005b18:	f0000101 	adrp	x1, c0028000 <secondary_stacks+0x1fd30>
    c0005b1c:	910e4021 	add	x1, x1, #0x390
    c0005b20:	8b010000 	add	x0, x0, x1
    c0005b24:	f90013e0 	str	x0, [sp, #32]
	spinlock_lock(&queue->lock);
    c0005b28:	f94013e0 	ldr	x0, [sp, #32]
    c0005b2c:	97fff435 	bl	c0002c00 <spinlock_lock>
	count = queue->count;
    c0005b30:	f94013e0 	ldr	x0, [sp, #32]
    c0005b34:	b9413000 	ldr	w0, [x0, #304]
    c0005b38:	b9002fe0 	str	w0, [sp, #44]
	spinlock_unlock(&queue->lock);
    c0005b3c:	f94013e0 	ldr	x0, [sp, #32]
    c0005b40:	97fff438 	bl	c0002c20 <spinlock_unlock>

	return count;
    c0005b44:	b9402fe0 	ldr	w0, [sp, #44]
}
    c0005b48:	a8c37bfd 	ldp	x29, x30, [sp], #48
    c0005b4c:	d65f03c0 	ret

00000000c0005b50 <smp_start_cpu>:

int smp_start_cpu(uint64_t mpidr, unsigned int *logical_id, int32_t *smc_ret)
{
    c0005b50:	a9bb7bfd 	stp	x29, x30, [sp, #-80]!
    c0005b54:	910003fd 	mov	x29, sp
    c0005b58:	f90017e0 	str	x0, [sp, #40]
    c0005b5c:	f90013e1 	str	x1, [sp, #32]
    c0005b60:	f9000fe2 	str	x2, [sp, #24]
	const struct cpu_topology_descriptor *cpu;
	int slot;
	int32_t ret;
	int result;
	bool new_cpu = false;
    c0005b64:	39013fff 	strb	wzr, [sp, #79]

	if ((logical_id == (unsigned int *)0) || (smc_ret == (int32_t *)0)) {
    c0005b68:	f94013e0 	ldr	x0, [sp, #32]
    c0005b6c:	f100001f 	cmp	x0, #0x0
    c0005b70:	54000080 	b.eq	c0005b80 <smp_start_cpu+0x30>  // b.none
    c0005b74:	f9400fe0 	ldr	x0, [sp, #24]
    c0005b78:	f100001f 	cmp	x0, #0x0
    c0005b7c:	54000061 	b.ne	c0005b88 <smp_start_cpu+0x38>  // b.any
		return SMP_START_FAILED;
    c0005b80:	12800080 	mov	w0, #0xfffffffb            	// #-5
    c0005b84:	1400011c 	b	c0005ff4 <smp_start_cpu+0x4a4>
	}

	*smc_ret = 0;
    c0005b88:	f9400fe0 	ldr	x0, [sp, #24]
    c0005b8c:	b900001f 	str	wzr, [x0]
	cpu = topology_find_cpu_by_mpidr(mpidr);
    c0005b90:	f94017e0 	ldr	x0, [sp, #40]
    c0005b94:	94000245 	bl	c00064a8 <topology_find_cpu_by_mpidr>
    c0005b98:	f90023e0 	str	x0, [sp, #64]
	if (cpu != (const struct cpu_topology_descriptor *)0) {
    c0005b9c:	f94023e0 	ldr	x0, [sp, #64]
    c0005ba0:	f100001f 	cmp	x0, #0x0
    c0005ba4:	54000300 	b.eq	c0005c04 <smp_start_cpu+0xb4>  // b.none
		*logical_id = cpu->logical_id;
    c0005ba8:	f94023e0 	ldr	x0, [sp, #64]
    c0005bac:	b9400801 	ldr	w1, [x0, #8]
    c0005bb0:	f94013e0 	ldr	x0, [sp, #32]
    c0005bb4:	b9000001 	str	w1, [x0]
		if (cpu_states[cpu->logical_id].online) {
    c0005bb8:	f94023e0 	ldr	x0, [sp, #64]
    c0005bbc:	b9400801 	ldr	w1, [x0, #8]
    c0005bc0:	f0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c0005bc4:	910b4002 	add	x2, x0, #0x2d0
    c0005bc8:	2a0103e1 	mov	w1, w1
    c0005bcc:	aa0103e0 	mov	x0, x1
    c0005bd0:	d37ff800 	lsl	x0, x0, #1
    c0005bd4:	8b010000 	add	x0, x0, x1
    c0005bd8:	d37df000 	lsl	x0, x0, #3
    c0005bdc:	8b000040 	add	x0, x2, x0
    c0005be0:	39404000 	ldrb	w0, [x0, #16]
    c0005be4:	12000000 	and	w0, w0, #0x1
    c0005be8:	7100001f 	cmp	w0, #0x0
    c0005bec:	54000760 	b.eq	c0005cd8 <smp_start_cpu+0x188>  // b.none
			*smc_ret = PSCI_RET_ALREADY_ON;
    c0005bf0:	f9400fe0 	ldr	x0, [sp, #24]
    c0005bf4:	12800061 	mov	w1, #0xfffffffc            	// #-4
    c0005bf8:	b9000001 	str	w1, [x0]
			return SMP_START_ALREADY_ONLINE;
    c0005bfc:	52800020 	mov	w0, #0x1                   	// #1
    c0005c00:	140000fd 	b	c0005ff4 <smp_start_cpu+0x4a4>
		}
	} else {
		slot = smp_find_free_logical_slot();
    c0005c04:	97fffde5 	bl	c0005398 <smp_find_free_logical_slot>
    c0005c08:	b9003fe0 	str	w0, [sp, #60]
		if (slot < 0) {
    c0005c0c:	b9403fe0 	ldr	w0, [sp, #60]
    c0005c10:	7100001f 	cmp	w0, #0x0
    c0005c14:	5400006a 	b.ge	c0005c20 <smp_start_cpu+0xd0>  // b.tcont
			return SMP_START_INVALID_CPU;
    c0005c18:	12800000 	mov	w0, #0xffffffff            	// #-1
    c0005c1c:	140000f6 	b	c0005ff4 <smp_start_cpu+0x4a4>
		}
		*logical_id = (unsigned int)slot;
    c0005c20:	b9403fe1 	ldr	w1, [sp, #60]
    c0005c24:	f94013e0 	ldr	x0, [sp, #32]
    c0005c28:	b9000001 	str	w1, [x0]
		new_cpu = true;
    c0005c2c:	52800020 	mov	w0, #0x1                   	// #1
    c0005c30:	39013fe0 	strb	w0, [sp, #79]

		topology_register_cpu(*logical_id, mpidr, false);
    c0005c34:	f94013e0 	ldr	x0, [sp, #32]
    c0005c38:	b9400000 	ldr	w0, [x0]
    c0005c3c:	52800002 	mov	w2, #0x0                   	// #0
    c0005c40:	f94017e1 	ldr	x1, [sp, #40]
    c0005c44:	940002aa 	bl	c00066ec <topology_register_cpu>
		cpu_states[*logical_id].logical_id = *logical_id;
    c0005c48:	f94013e0 	ldr	x0, [sp, #32]
    c0005c4c:	b9400001 	ldr	w1, [x0]
    c0005c50:	f94013e0 	ldr	x0, [sp, #32]
    c0005c54:	b9400002 	ldr	w2, [x0]
    c0005c58:	f0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c0005c5c:	910b4003 	add	x3, x0, #0x2d0
    c0005c60:	2a0103e1 	mov	w1, w1
    c0005c64:	aa0103e0 	mov	x0, x1
    c0005c68:	d37ff800 	lsl	x0, x0, #1
    c0005c6c:	8b010000 	add	x0, x0, x1
    c0005c70:	d37df000 	lsl	x0, x0, #3
    c0005c74:	8b000060 	add	x0, x3, x0
    c0005c78:	b9000002 	str	w2, [x0]
		cpu_states[*logical_id].mpidr = mpidr;
    c0005c7c:	f94013e0 	ldr	x0, [sp, #32]
    c0005c80:	b9400001 	ldr	w1, [x0]
    c0005c84:	f0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c0005c88:	910b4002 	add	x2, x0, #0x2d0
    c0005c8c:	2a0103e1 	mov	w1, w1
    c0005c90:	aa0103e0 	mov	x0, x1
    c0005c94:	d37ff800 	lsl	x0, x0, #1
    c0005c98:	8b010000 	add	x0, x0, x1
    c0005c9c:	d37df000 	lsl	x0, x0, #3
    c0005ca0:	8b000040 	add	x0, x2, x0
    c0005ca4:	f94017e1 	ldr	x1, [sp, #40]
    c0005ca8:	f9000401 	str	x1, [x0, #8]
		cpu_states[*logical_id].boot_cpu = false;
    c0005cac:	f94013e0 	ldr	x0, [sp, #32]
    c0005cb0:	b9400001 	ldr	w1, [x0]
    c0005cb4:	f0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c0005cb8:	910b4002 	add	x2, x0, #0x2d0
    c0005cbc:	2a0103e1 	mov	w1, w1
    c0005cc0:	aa0103e0 	mov	x0, x1
    c0005cc4:	d37ff800 	lsl	x0, x0, #1
    c0005cc8:	8b010000 	add	x0, x0, x1
    c0005ccc:	d37df000 	lsl	x0, x0, #3
    c0005cd0:	8b000040 	add	x0, x2, x0
    c0005cd4:	39004c1f 	strb	wzr, [x0, #19]
	}

	cpu_states[*logical_id].pending = true;
    c0005cd8:	f94013e0 	ldr	x0, [sp, #32]
    c0005cdc:	b9400001 	ldr	w1, [x0]
    c0005ce0:	f0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c0005ce4:	910b4002 	add	x2, x0, #0x2d0
    c0005ce8:	2a0103e1 	mov	w1, w1
    c0005cec:	aa0103e0 	mov	x0, x1
    c0005cf0:	d37ff800 	lsl	x0, x0, #1
    c0005cf4:	8b010000 	add	x0, x0, x1
    c0005cf8:	d37df000 	lsl	x0, x0, #3
    c0005cfc:	8b000040 	add	x0, x2, x0
    c0005d00:	52800021 	mov	w1, #0x1                   	// #1
    c0005d04:	39004801 	strb	w1, [x0, #18]
	cpu_states[*logical_id].online = false;
    c0005d08:	f94013e0 	ldr	x0, [sp, #32]
    c0005d0c:	b9400001 	ldr	w1, [x0]
    c0005d10:	f0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c0005d14:	910b4002 	add	x2, x0, #0x2d0
    c0005d18:	2a0103e1 	mov	w1, w1
    c0005d1c:	aa0103e0 	mov	x0, x1
    c0005d20:	d37ff800 	lsl	x0, x0, #1
    c0005d24:	8b010000 	add	x0, x0, x1
    c0005d28:	d37df000 	lsl	x0, x0, #3
    c0005d2c:	8b000040 	add	x0, x2, x0
    c0005d30:	3900401f 	strb	wzr, [x0, #16]
	cpu_states[*logical_id].scheduled = false;
    c0005d34:	f94013e0 	ldr	x0, [sp, #32]
    c0005d38:	b9400001 	ldr	w1, [x0]
    c0005d3c:	f0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c0005d40:	910b4002 	add	x2, x0, #0x2d0
    c0005d44:	2a0103e1 	mov	w1, w1
    c0005d48:	aa0103e0 	mov	x0, x1
    c0005d4c:	d37ff800 	lsl	x0, x0, #1
    c0005d50:	8b010000 	add	x0, x0, x1
    c0005d54:	d37df000 	lsl	x0, x0, #3
    c0005d58:	8b000040 	add	x0, x2, x0
    c0005d5c:	3900441f 	strb	wzr, [x0, #17]

	ret = smp_smc_call(PSCI_CPU_ON_64, mpidr,
    c0005d60:	f0ffffc0 	adrp	x0, c0000000 <_start>
    c0005d64:	91008001 	add	x1, x0, #0x20
			   (uintptr_t)secondary_cpu_entrypoint,
			   *logical_id);
    c0005d68:	f94013e0 	ldr	x0, [sp, #32]
    c0005d6c:	b9400000 	ldr	w0, [x0]
	ret = smp_smc_call(PSCI_CPU_ON_64, mpidr,
    c0005d70:	2a0003e0 	mov	w0, w0
    c0005d74:	aa0003e3 	mov	x3, x0
    c0005d78:	aa0103e2 	mov	x2, x1
    c0005d7c:	f94017e1 	ldr	x1, [sp, #40]
    c0005d80:	d2800060 	mov	x0, #0x3                   	// #3
    c0005d84:	f2b88000 	movk	x0, #0xc400, lsl #16
    c0005d88:	97fffd78 	bl	c0005368 <smp_smc_call>
    c0005d8c:	b9003be0 	str	w0, [sp, #56]
	*smc_ret = ret;
    c0005d90:	f9400fe0 	ldr	x0, [sp, #24]
    c0005d94:	b9403be1 	ldr	w1, [sp, #56]
    c0005d98:	b9000001 	str	w1, [x0]
	result = smp_map_psci_result(ret);
    c0005d9c:	b9403be0 	ldr	w0, [sp, #56]
    c0005da0:	97fffe33 	bl	c000566c <smp_map_psci_result>
    c0005da4:	b90037e0 	str	w0, [sp, #52]

	if (result == SMP_START_OK) {
    c0005da8:	b94037e0 	ldr	w0, [sp, #52]
    c0005dac:	7100001f 	cmp	w0, #0x0
    c0005db0:	540004a1 	b.ne	c0005e44 <smp_start_cpu+0x2f4>  // b.any
		if (!smp_wait_for_online(*logical_id, SMP_CPU_ON_TIMEOUT_US)) {
    c0005db4:	f94013e0 	ldr	x0, [sp, #32]
    c0005db8:	b9400000 	ldr	w0, [x0]
    c0005dbc:	5290d401 	mov	w1, #0x86a0                	// #34464
    c0005dc0:	72a00021 	movk	w1, #0x1, lsl #16
    c0005dc4:	97fffdcc 	bl	c00054f4 <smp_wait_for_online>
    c0005dc8:	12001c00 	and	w0, w0, #0xff
    c0005dcc:	52000000 	eor	w0, w0, #0x1
    c0005dd0:	12001c00 	and	w0, w0, #0xff
    c0005dd4:	12000000 	and	w0, w0, #0x1
    c0005dd8:	7100001f 	cmp	w0, #0x0
    c0005ddc:	54000300 	b.eq	c0005e3c <smp_start_cpu+0x2ec>  // b.none
			cpu_states[*logical_id].pending = false;
    c0005de0:	f94013e0 	ldr	x0, [sp, #32]
    c0005de4:	b9400001 	ldr	w1, [x0]
    c0005de8:	f0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c0005dec:	910b4002 	add	x2, x0, #0x2d0
    c0005df0:	2a0103e1 	mov	w1, w1
    c0005df4:	aa0103e0 	mov	x0, x1
    c0005df8:	d37ff800 	lsl	x0, x0, #1
    c0005dfc:	8b010000 	add	x0, x0, x1
    c0005e00:	d37df000 	lsl	x0, x0, #3
    c0005e04:	8b000040 	add	x0, x2, x0
    c0005e08:	3900481f 	strb	wzr, [x0, #18]
			if (new_cpu) {
    c0005e0c:	39413fe0 	ldrb	w0, [sp, #79]
    c0005e10:	12000000 	and	w0, w0, #0x1
    c0005e14:	7100001f 	cmp	w0, #0x0
    c0005e18:	540000e0 	b.eq	c0005e34 <smp_start_cpu+0x2e4>  // b.none
				topology_unregister_cpu(*logical_id);
    c0005e1c:	f94013e0 	ldr	x0, [sp, #32]
    c0005e20:	b9400000 	ldr	w0, [x0]
    c0005e24:	94000266 	bl	c00067bc <topology_unregister_cpu>
				smp_reset_cpu_state(*logical_id);
    c0005e28:	f94013e0 	ldr	x0, [sp, #32]
    c0005e2c:	b9400000 	ldr	w0, [x0]
    c0005e30:	97fffd71 	bl	c00053f4 <smp_reset_cpu_state>
			}
			return SMP_START_TIMEOUT;
    c0005e34:	12800060 	mov	w0, #0xfffffffc            	// #-4
    c0005e38:	1400006f 	b	c0005ff4 <smp_start_cpu+0x4a4>
		}
		return SMP_START_OK;
    c0005e3c:	52800000 	mov	w0, #0x0                   	// #0
    c0005e40:	1400006d 	b	c0005ff4 <smp_start_cpu+0x4a4>
	}

	if (result == SMP_START_ALREADY_ONLINE) {
    c0005e44:	b94037e0 	ldr	w0, [sp, #52]
    c0005e48:	7100041f 	cmp	w0, #0x1
    c0005e4c:	54000a81 	b.ne	c0005f9c <smp_start_cpu+0x44c>  // b.any
		cpu_states[*logical_id].pending = false;
    c0005e50:	f94013e0 	ldr	x0, [sp, #32]
    c0005e54:	b9400001 	ldr	w1, [x0]
    c0005e58:	f0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c0005e5c:	910b4002 	add	x2, x0, #0x2d0
    c0005e60:	2a0103e1 	mov	w1, w1
    c0005e64:	aa0103e0 	mov	x0, x1
    c0005e68:	d37ff800 	lsl	x0, x0, #1
    c0005e6c:	8b010000 	add	x0, x0, x1
    c0005e70:	d37df000 	lsl	x0, x0, #3
    c0005e74:	8b000040 	add	x0, x2, x0
    c0005e78:	3900481f 	strb	wzr, [x0, #18]

		/*
		 * 不能单凭 TF-A 返回 already-on 就认定 secondary 已经真正进入 mini-os。
		 * 只有 boot cpu 才天然成立；对于新注册但没观察到 online 的核，必须回滚。
		 */
		if (cpu_states[*logical_id].boot_cpu) {
    c0005e7c:	f94013e0 	ldr	x0, [sp, #32]
    c0005e80:	b9400001 	ldr	w1, [x0]
    c0005e84:	f0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c0005e88:	910b4002 	add	x2, x0, #0x2d0
    c0005e8c:	2a0103e1 	mov	w1, w1
    c0005e90:	aa0103e0 	mov	x0, x1
    c0005e94:	d37ff800 	lsl	x0, x0, #1
    c0005e98:	8b010000 	add	x0, x0, x1
    c0005e9c:	d37df000 	lsl	x0, x0, #3
    c0005ea0:	8b000040 	add	x0, x2, x0
    c0005ea4:	39404c00 	ldrb	w0, [x0, #19]
    c0005ea8:	12000000 	and	w0, w0, #0x1
    c0005eac:	7100001f 	cmp	w0, #0x0
    c0005eb0:	540003e0 	b.eq	c0005f2c <smp_start_cpu+0x3dc>  // b.none
			cpu_states[*logical_id].online = true;
    c0005eb4:	f94013e0 	ldr	x0, [sp, #32]
    c0005eb8:	b9400001 	ldr	w1, [x0]
    c0005ebc:	f0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c0005ec0:	910b4002 	add	x2, x0, #0x2d0
    c0005ec4:	2a0103e1 	mov	w1, w1
    c0005ec8:	aa0103e0 	mov	x0, x1
    c0005ecc:	d37ff800 	lsl	x0, x0, #1
    c0005ed0:	8b010000 	add	x0, x0, x1
    c0005ed4:	d37df000 	lsl	x0, x0, #3
    c0005ed8:	8b000040 	add	x0, x2, x0
    c0005edc:	52800021 	mov	w1, #0x1                   	// #1
    c0005ee0:	39004001 	strb	w1, [x0, #16]
			cpu_states[*logical_id].scheduled = true;
    c0005ee4:	f94013e0 	ldr	x0, [sp, #32]
    c0005ee8:	b9400001 	ldr	w1, [x0]
    c0005eec:	f0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c0005ef0:	910b4002 	add	x2, x0, #0x2d0
    c0005ef4:	2a0103e1 	mov	w1, w1
    c0005ef8:	aa0103e0 	mov	x0, x1
    c0005efc:	d37ff800 	lsl	x0, x0, #1
    c0005f00:	8b010000 	add	x0, x0, x1
    c0005f04:	d37df000 	lsl	x0, x0, #3
    c0005f08:	8b000040 	add	x0, x2, x0
    c0005f0c:	52800021 	mov	w1, #0x1                   	// #1
    c0005f10:	39004401 	strb	w1, [x0, #17]
			topology_mark_cpu_online(*logical_id, true);
    c0005f14:	f94013e0 	ldr	x0, [sp, #32]
    c0005f18:	b9400000 	ldr	w0, [x0]
    c0005f1c:	52800021 	mov	w1, #0x1                   	// #1
    c0005f20:	94000191 	bl	c0006564 <topology_mark_cpu_online>
			return SMP_START_ALREADY_ONLINE;
    c0005f24:	52800020 	mov	w0, #0x1                   	// #1
    c0005f28:	14000033 	b	c0005ff4 <smp_start_cpu+0x4a4>
		}

		if (!cpu_states[*logical_id].online && new_cpu) {
    c0005f2c:	f94013e0 	ldr	x0, [sp, #32]
    c0005f30:	b9400001 	ldr	w1, [x0]
    c0005f34:	f0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c0005f38:	910b4002 	add	x2, x0, #0x2d0
    c0005f3c:	2a0103e1 	mov	w1, w1
    c0005f40:	aa0103e0 	mov	x0, x1
    c0005f44:	d37ff800 	lsl	x0, x0, #1
    c0005f48:	8b010000 	add	x0, x0, x1
    c0005f4c:	d37df000 	lsl	x0, x0, #3
    c0005f50:	8b000040 	add	x0, x2, x0
    c0005f54:	39404000 	ldrb	w0, [x0, #16]
    c0005f58:	52000000 	eor	w0, w0, #0x1
    c0005f5c:	12001c00 	and	w0, w0, #0xff
    c0005f60:	12000000 	and	w0, w0, #0x1
    c0005f64:	7100001f 	cmp	w0, #0x0
    c0005f68:	54000160 	b.eq	c0005f94 <smp_start_cpu+0x444>  // b.none
    c0005f6c:	39413fe0 	ldrb	w0, [sp, #79]
    c0005f70:	12000000 	and	w0, w0, #0x1
    c0005f74:	7100001f 	cmp	w0, #0x0
    c0005f78:	540000e0 	b.eq	c0005f94 <smp_start_cpu+0x444>  // b.none
			topology_unregister_cpu(*logical_id);
    c0005f7c:	f94013e0 	ldr	x0, [sp, #32]
    c0005f80:	b9400000 	ldr	w0, [x0]
    c0005f84:	9400020e 	bl	c00067bc <topology_unregister_cpu>
			smp_reset_cpu_state(*logical_id);
    c0005f88:	f94013e0 	ldr	x0, [sp, #32]
    c0005f8c:	b9400000 	ldr	w0, [x0]
    c0005f90:	97fffd19 	bl	c00053f4 <smp_reset_cpu_state>
		}

		return SMP_START_ALREADY_ONLINE;
    c0005f94:	52800020 	mov	w0, #0x1                   	// #1
    c0005f98:	14000017 	b	c0005ff4 <smp_start_cpu+0x4a4>
	}

	cpu_states[*logical_id].pending = false;
    c0005f9c:	f94013e0 	ldr	x0, [sp, #32]
    c0005fa0:	b9400001 	ldr	w1, [x0]
    c0005fa4:	f0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c0005fa8:	910b4002 	add	x2, x0, #0x2d0
    c0005fac:	2a0103e1 	mov	w1, w1
    c0005fb0:	aa0103e0 	mov	x0, x1
    c0005fb4:	d37ff800 	lsl	x0, x0, #1
    c0005fb8:	8b010000 	add	x0, x0, x1
    c0005fbc:	d37df000 	lsl	x0, x0, #3
    c0005fc0:	8b000040 	add	x0, x2, x0
    c0005fc4:	3900481f 	strb	wzr, [x0, #18]

	if (new_cpu) {
    c0005fc8:	39413fe0 	ldrb	w0, [sp, #79]
    c0005fcc:	12000000 	and	w0, w0, #0x1
    c0005fd0:	7100001f 	cmp	w0, #0x0
    c0005fd4:	540000e0 	b.eq	c0005ff0 <smp_start_cpu+0x4a0>  // b.none
		topology_unregister_cpu(*logical_id);
    c0005fd8:	f94013e0 	ldr	x0, [sp, #32]
    c0005fdc:	b9400000 	ldr	w0, [x0]
    c0005fe0:	940001f7 	bl	c00067bc <topology_unregister_cpu>
		smp_reset_cpu_state(*logical_id);
    c0005fe4:	f94013e0 	ldr	x0, [sp, #32]
    c0005fe8:	b9400000 	ldr	w0, [x0]
    c0005fec:	97fffd02 	bl	c00053f4 <smp_reset_cpu_state>
	}

	return result;
    c0005ff0:	b94037e0 	ldr	w0, [sp, #52]
}
    c0005ff4:	a8c57bfd 	ldp	x29, x30, [sp], #80
    c0005ff8:	d65f03c0 	ret

00000000c0005ffc <smp_cpu_state>:

const struct smp_cpu_state *smp_cpu_state(unsigned int logical_id)
{
    c0005ffc:	d10043ff 	sub	sp, sp, #0x10
    c0006000:	b9000fe0 	str	w0, [sp, #12]
	if (logical_id >= PLAT_MAX_CPUS) {
    c0006004:	b9400fe0 	ldr	w0, [sp, #12]
    c0006008:	71001c1f 	cmp	w0, #0x7
    c000600c:	54000069 	b.ls	c0006018 <smp_cpu_state+0x1c>  // b.plast
		return (const struct smp_cpu_state *)0;
    c0006010:	d2800000 	mov	x0, #0x0                   	// #0
    c0006014:	14000009 	b	c0006038 <smp_cpu_state+0x3c>
	}

	return &cpu_states[logical_id];
    c0006018:	b9400fe1 	ldr	w1, [sp, #12]
    c000601c:	aa0103e0 	mov	x0, x1
    c0006020:	d37ff800 	lsl	x0, x0, #1
    c0006024:	8b010000 	add	x0, x0, x1
    c0006028:	d37df000 	lsl	x0, x0, #3
    c000602c:	d0000101 	adrp	x1, c0028000 <secondary_stacks+0x1fd30>
    c0006030:	910b4021 	add	x1, x1, #0x2d0
    c0006034:	8b010000 	add	x0, x0, x1
}
    c0006038:	910043ff 	add	sp, sp, #0x10
    c000603c:	d65f03c0 	ret

00000000c0006040 <smp_online_cpu_count>:

unsigned int smp_online_cpu_count(void)
{
	return online_cpu_count;
    c0006040:	d0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c0006044:	91354000 	add	x0, x0, #0xd50
    c0006048:	b9400000 	ldr	w0, [x0]
}
    c000604c:	d65f03c0 	ret

00000000c0006050 <smp_secondary_cpu_online>:

void smp_secondary_cpu_online(unsigned int logical_id)
{
    c0006050:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c0006054:	910003fd 	mov	x29, sp
    c0006058:	b9001fe0 	str	w0, [sp, #28]
	if ((logical_id >= PLAT_MAX_CPUS) || cpu_states[logical_id].online) {
    c000605c:	b9401fe0 	ldr	w0, [sp, #28]
    c0006060:	71001c1f 	cmp	w0, #0x7
    c0006064:	540006e8 	b.hi	c0006140 <smp_secondary_cpu_online+0xf0>  // b.pmore
    c0006068:	d0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c000606c:	910b4002 	add	x2, x0, #0x2d0
    c0006070:	b9401fe1 	ldr	w1, [sp, #28]
    c0006074:	aa0103e0 	mov	x0, x1
    c0006078:	d37ff800 	lsl	x0, x0, #1
    c000607c:	8b010000 	add	x0, x0, x1
    c0006080:	d37df000 	lsl	x0, x0, #3
    c0006084:	8b000040 	add	x0, x2, x0
    c0006088:	39404000 	ldrb	w0, [x0, #16]
    c000608c:	12000000 	and	w0, w0, #0x1
    c0006090:	7100001f 	cmp	w0, #0x0
    c0006094:	54000561 	b.ne	c0006140 <smp_secondary_cpu_online+0xf0>  // b.any
		return;
	}

	cpu_states[logical_id].pending = false;
    c0006098:	d0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c000609c:	910b4002 	add	x2, x0, #0x2d0
    c00060a0:	b9401fe1 	ldr	w1, [sp, #28]
    c00060a4:	aa0103e0 	mov	x0, x1
    c00060a8:	d37ff800 	lsl	x0, x0, #1
    c00060ac:	8b010000 	add	x0, x0, x1
    c00060b0:	d37df000 	lsl	x0, x0, #3
    c00060b4:	8b000040 	add	x0, x2, x0
    c00060b8:	3900481f 	strb	wzr, [x0, #18]
	cpu_states[logical_id].online = true;
    c00060bc:	d0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c00060c0:	910b4002 	add	x2, x0, #0x2d0
    c00060c4:	b9401fe1 	ldr	w1, [sp, #28]
    c00060c8:	aa0103e0 	mov	x0, x1
    c00060cc:	d37ff800 	lsl	x0, x0, #1
    c00060d0:	8b010000 	add	x0, x0, x1
    c00060d4:	d37df000 	lsl	x0, x0, #3
    c00060d8:	8b000040 	add	x0, x2, x0
    c00060dc:	52800021 	mov	w1, #0x1                   	// #1
    c00060e0:	39004001 	strb	w1, [x0, #16]
	cpu_states[logical_id].scheduled = true;
    c00060e4:	d0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c00060e8:	910b4002 	add	x2, x0, #0x2d0
    c00060ec:	b9401fe1 	ldr	w1, [sp, #28]
    c00060f0:	aa0103e0 	mov	x0, x1
    c00060f4:	d37ff800 	lsl	x0, x0, #1
    c00060f8:	8b010000 	add	x0, x0, x1
    c00060fc:	d37df000 	lsl	x0, x0, #3
    c0006100:	8b000040 	add	x0, x2, x0
    c0006104:	52800021 	mov	w1, #0x1                   	// #1
    c0006108:	39004401 	strb	w1, [x0, #17]
	online_cpu_count++;
    c000610c:	d0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c0006110:	91354000 	add	x0, x0, #0xd50
    c0006114:	b9400000 	ldr	w0, [x0]
    c0006118:	11000401 	add	w1, w0, #0x1
    c000611c:	d0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c0006120:	91354000 	add	x0, x0, #0xd50
    c0006124:	b9000001 	str	w1, [x0]
	topology_mark_cpu_online(logical_id, true);
    c0006128:	52800021 	mov	w1, #0x1                   	// #1
    c000612c:	b9401fe0 	ldr	w0, [sp, #28]
    c0006130:	9400010d 	bl	c0006564 <topology_mark_cpu_online>
	scheduler_join_cpu(logical_id);
    c0006134:	b9401fe0 	ldr	w0, [sp, #28]
    c0006138:	97fff492 	bl	c0003380 <scheduler_join_cpu>
    c000613c:	14000002 	b	c0006144 <smp_secondary_cpu_online+0xf4>
		return;
    c0006140:	d503201f 	nop
}
    c0006144:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c0006148:	d65f03c0 	ret

00000000c000614c <smp_secondary_entry>:

void smp_secondary_entry(uint64_t logical_id)
{
    c000614c:	a9bb7bfd 	stp	x29, x30, [sp, #-80]!
    c0006150:	910003fd 	mov	x29, sp
    c0006154:	a90153f3 	stp	x19, x20, [sp, #16]
    c0006158:	f90017e0 	str	x0, [sp, #40]
	uint64_t poll_ticks = smp_ticks_from_ms(SMP_TASK_POLL_MS);
    c000615c:	52800140 	mov	w0, #0xa                   	// #10
    c0006160:	97fffba9 	bl	c0005004 <smp_ticks_from_ms>
    c0006164:	f90023e0 	str	x0, [sp, #64]
	uint64_t next_poll = smp_read_cntpct() + poll_ticks;
    c0006168:	97fffb9a 	bl	c0004fd0 <smp_read_cntpct>
    c000616c:	aa0003e1 	mov	x1, x0
    c0006170:	f94023e0 	ldr	x0, [sp, #64]
    c0006174:	8b010000 	add	x0, x0, x1
    c0006178:	f90027e0 	str	x0, [sp, #72]
	smp_secondary_cpu_online((unsigned int)logical_id);
    c000617c:	f94017e0 	ldr	x0, [sp, #40]
    c0006180:	97ffffb4 	bl	c0006050 <smp_secondary_cpu_online>
	mini_os_printf("secondary cpu%u online (mpidr=0x%llx), scheduler runnable=%u\n",
    c0006184:	f94017e0 	ldr	x0, [sp, #40]
    c0006188:	2a0003f4 	mov	w20, w0
		       (unsigned int)logical_id,
		       (unsigned long long)cpu_states[logical_id].mpidr,
    c000618c:	d0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c0006190:	910b4002 	add	x2, x0, #0x2d0
    c0006194:	f94017e1 	ldr	x1, [sp, #40]
    c0006198:	aa0103e0 	mov	x0, x1
    c000619c:	d37ff800 	lsl	x0, x0, #1
    c00061a0:	8b010000 	add	x0, x0, x1
    c00061a4:	d37df000 	lsl	x0, x0, #3
    c00061a8:	8b000040 	add	x0, x2, x0
    c00061ac:	f9400413 	ldr	x19, [x0, #8]
	mini_os_printf("secondary cpu%u online (mpidr=0x%llx), scheduler runnable=%u\n",
    c00061b0:	97fff4ac 	bl	c0003460 <scheduler_runnable_cpu_count>
    c00061b4:	2a0003e3 	mov	w3, w0
    c00061b8:	aa1303e2 	mov	x2, x19
    c00061bc:	2a1403e1 	mov	w1, w20
    c00061c0:	d0000000 	adrp	x0, c0008000 <hex.0+0x1658>
    c00061c4:	91058000 	add	x0, x0, #0x160
    c00061c8:	97ffeecb 	bl	c0001cf4 <mini_os_printf>
		       scheduler_runnable_cpu_count());
	mini_os_printf("secondary cpu%u timer scheduler started (poll=%ums)\n",
    c00061cc:	f94017e0 	ldr	x0, [sp, #40]
    c00061d0:	52800142 	mov	w2, #0xa                   	// #10
    c00061d4:	2a0003e1 	mov	w1, w0
    c00061d8:	d0000000 	adrp	x0, c0008000 <hex.0+0x1658>
    c00061dc:	91068000 	add	x0, x0, #0x1a0
    c00061e0:	97ffeec5 	bl	c0001cf4 <mini_os_printf>
		       (unsigned int)logical_id,
		       (unsigned int)SMP_TASK_POLL_MS);


	for (;;) {
		uint64_t now = smp_read_cntpct();
    c00061e4:	97fffb7b 	bl	c0004fd0 <smp_read_cntpct>
    c00061e8:	f9001fe0 	str	x0, [sp, #56]

		if (smp_task_has_pending((unsigned int)logical_id) ||
    c00061ec:	f94017e0 	ldr	x0, [sp, #40]
    c00061f0:	97fffc16 	bl	c0005248 <smp_task_has_pending>
    c00061f4:	12001c00 	and	w0, w0, #0xff
    c00061f8:	12000000 	and	w0, w0, #0x1
    c00061fc:	7100001f 	cmp	w0, #0x0
    c0006200:	540000c1 	b.ne	c0006218 <smp_secondary_entry+0xcc>  // b.any
		    ((int64_t)(now - next_poll) >= 0)) {
    c0006204:	f9401fe1 	ldr	x1, [sp, #56]
    c0006208:	f94027e0 	ldr	x0, [sp, #72]
    c000620c:	cb000020 	sub	x0, x1, x0
		if (smp_task_has_pending((unsigned int)logical_id) ||
    c0006210:	f100001f 	cmp	x0, #0x0
    c0006214:	540000eb 	b.lt	c0006230 <smp_secondary_entry+0xe4>  // b.tstop
			smp_run_pending_tasks((unsigned int)logical_id);
    c0006218:	f94017e0 	ldr	x0, [sp, #40]
    c000621c:	97fffc3f 	bl	c0005318 <smp_run_pending_tasks>
			next_poll = now + poll_ticks;
    c0006220:	f9401fe1 	ldr	x1, [sp, #56]
    c0006224:	f94023e0 	ldr	x0, [sp, #64]
    c0006228:	8b000020 	add	x0, x1, x0
    c000622c:	f90027e0 	str	x0, [sp, #72]
		}
		__asm__ volatile ("wfe");
    c0006230:	d503205f 	wfe
	for (;;) {
    c0006234:	17ffffec 	b	c00061e4 <smp_secondary_entry+0x98>

00000000c0006238 <smp_secondary_entrypoint>:
	}
}

uintptr_t smp_secondary_entrypoint(void)
{
	return (uintptr_t)secondary_cpu_entrypoint;
    c0006238:	d0ffffc0 	adrp	x0, c0000000 <_start>
    c000623c:	91008000 	add	x0, x0, #0x20
    c0006240:	d65f03c0 	ret

00000000c0006244 <test_framework_init>:
#include <kernel/test.h>

void test_framework_init(void)
{
    c0006244:	d503201f 	nop
    c0006248:	d65f03c0 	ret

00000000c000624c <topology_read_mpidr>:
static struct cpu_topology_descriptor cpu_descs[PLAT_MAX_CPUS];
static unsigned int present_cpu_count;
static unsigned int online_cpu_count;

static inline uint64_t topology_read_mpidr(void)
{
    c000624c:	d10043ff 	sub	sp, sp, #0x10
	uint64_t mpidr;

	__asm__ volatile ("mrs %0, mpidr_el1" : "=r" (mpidr));
    c0006250:	d53800a0 	mrs	x0, mpidr_el1
    c0006254:	f90007e0 	str	x0, [sp, #8]
	return mpidr;
    c0006258:	f94007e0 	ldr	x0, [sp, #8]
}
    c000625c:	910043ff 	add	sp, sp, #0x10
    c0006260:	d65f03c0 	ret

00000000c0006264 <topology_fill_descriptor>:

static void topology_fill_descriptor(struct cpu_topology_descriptor *cpu,
				     unsigned int logical_id,
				     uint64_t mpidr,
				     bool boot_cpu)
{
    c0006264:	d10083ff 	sub	sp, sp, #0x20
    c0006268:	f9000fe0 	str	x0, [sp, #24]
    c000626c:	b90017e1 	str	w1, [sp, #20]
    c0006270:	f90007e2 	str	x2, [sp, #8]
    c0006274:	39004fe3 	strb	w3, [sp, #19]
	cpu->logical_id = logical_id;
    c0006278:	f9400fe0 	ldr	x0, [sp, #24]
    c000627c:	b94017e1 	ldr	w1, [sp, #20]
    c0006280:	b9000801 	str	w1, [x0, #8]
	cpu->mpidr = mpidr;
    c0006284:	f9400fe0 	ldr	x0, [sp, #24]
    c0006288:	f94007e1 	ldr	x1, [sp, #8]
    c000628c:	f9000001 	str	x1, [x0]
	cpu->chip_id = (unsigned int)((mpidr & MPIDR_AFF3_MASK) >> MPIDR_AFF3_SHIFT);
    c0006290:	f94007e0 	ldr	x0, [sp, #8]
    c0006294:	d358fc00 	lsr	x0, x0, #24
    c0006298:	12001c01 	and	w1, w0, #0xff
    c000629c:	f9400fe0 	ldr	x0, [sp, #24]
    c00062a0:	b9000c01 	str	w1, [x0, #12]
	cpu->die_id = (unsigned int)((mpidr & MPIDR_AFF2_MASK) >> MPIDR_AFF2_SHIFT);
    c00062a4:	f94007e0 	ldr	x0, [sp, #8]
    c00062a8:	d350fc00 	lsr	x0, x0, #16
    c00062ac:	12001c01 	and	w1, w0, #0xff
    c00062b0:	f9400fe0 	ldr	x0, [sp, #24]
    c00062b4:	b9001001 	str	w1, [x0, #16]
	cpu->cluster_id = (unsigned int)((mpidr & MPIDR_AFF1_MASK) >> MPIDR_AFF1_SHIFT);
    c00062b8:	f94007e0 	ldr	x0, [sp, #8]
    c00062bc:	d348fc00 	lsr	x0, x0, #8
    c00062c0:	12001c01 	and	w1, w0, #0xff
    c00062c4:	f9400fe0 	ldr	x0, [sp, #24]
    c00062c8:	b9001401 	str	w1, [x0, #20]
	cpu->core_id = (unsigned int)(mpidr & MPIDR_AFF0_MASK);
    c00062cc:	f94007e0 	ldr	x0, [sp, #8]
    c00062d0:	12001c01 	and	w1, w0, #0xff
    c00062d4:	f9400fe0 	ldr	x0, [sp, #24]
    c00062d8:	b9001801 	str	w1, [x0, #24]
	cpu->boot_cpu = boot_cpu;
    c00062dc:	f9400fe0 	ldr	x0, [sp, #24]
    c00062e0:	39404fe1 	ldrb	w1, [sp, #19]
    c00062e4:	39007001 	strb	w1, [x0, #28]
}
    c00062e8:	d503201f 	nop
    c00062ec:	910083ff 	add	sp, sp, #0x20
    c00062f0:	d65f03c0 	ret

00000000c00062f4 <topology_init>:

void topology_init(void)
{
    c00062f4:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c00062f8:	910003fd 	mov	x29, sp
	unsigned int i;
	uint64_t mpidr = topology_read_mpidr();
    c00062fc:	97ffffd4 	bl	c000624c <topology_read_mpidr>
    c0006300:	f9000be0 	str	x0, [sp, #16]

	for (i = 0U; i < PLAT_MAX_CPUS; ++i) {
    c0006304:	b9001fff 	str	wzr, [sp, #28]
    c0006308:	1400003b 	b	c00063f4 <topology_init+0x100>
		cpu_descs[i].logical_id = i;
    c000630c:	d0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c0006310:	91356001 	add	x1, x0, #0xd58
    c0006314:	b9401fe0 	ldr	w0, [sp, #28]
    c0006318:	d37be800 	lsl	x0, x0, #5
    c000631c:	8b000020 	add	x0, x1, x0
    c0006320:	b9401fe1 	ldr	w1, [sp, #28]
    c0006324:	b9000801 	str	w1, [x0, #8]
		cpu_descs[i].present = false;
    c0006328:	d0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c000632c:	91356001 	add	x1, x0, #0xd58
    c0006330:	b9401fe0 	ldr	w0, [sp, #28]
    c0006334:	d37be800 	lsl	x0, x0, #5
    c0006338:	8b000020 	add	x0, x1, x0
    c000633c:	3900741f 	strb	wzr, [x0, #29]
		cpu_descs[i].online = false;
    c0006340:	d0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c0006344:	91356001 	add	x1, x0, #0xd58
    c0006348:	b9401fe0 	ldr	w0, [sp, #28]
    c000634c:	d37be800 	lsl	x0, x0, #5
    c0006350:	8b000020 	add	x0, x1, x0
    c0006354:	3900781f 	strb	wzr, [x0, #30]
		cpu_descs[i].boot_cpu = false;
    c0006358:	d0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c000635c:	91356001 	add	x1, x0, #0xd58
    c0006360:	b9401fe0 	ldr	w0, [sp, #28]
    c0006364:	d37be800 	lsl	x0, x0, #5
    c0006368:	8b000020 	add	x0, x1, x0
    c000636c:	3900701f 	strb	wzr, [x0, #28]
		cpu_descs[i].mpidr = 0U;
    c0006370:	d0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c0006374:	91356001 	add	x1, x0, #0xd58
    c0006378:	b9401fe0 	ldr	w0, [sp, #28]
    c000637c:	d37be800 	lsl	x0, x0, #5
    c0006380:	8b000020 	add	x0, x1, x0
    c0006384:	f900001f 	str	xzr, [x0]
		cpu_descs[i].chip_id = 0U;
    c0006388:	d0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c000638c:	91356001 	add	x1, x0, #0xd58
    c0006390:	b9401fe0 	ldr	w0, [sp, #28]
    c0006394:	d37be800 	lsl	x0, x0, #5
    c0006398:	8b000020 	add	x0, x1, x0
    c000639c:	b9000c1f 	str	wzr, [x0, #12]
		cpu_descs[i].die_id = 0U;
    c00063a0:	d0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c00063a4:	91356001 	add	x1, x0, #0xd58
    c00063a8:	b9401fe0 	ldr	w0, [sp, #28]
    c00063ac:	d37be800 	lsl	x0, x0, #5
    c00063b0:	8b000020 	add	x0, x1, x0
    c00063b4:	b900101f 	str	wzr, [x0, #16]
		cpu_descs[i].cluster_id = 0U;
    c00063b8:	d0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c00063bc:	91356001 	add	x1, x0, #0xd58
    c00063c0:	b9401fe0 	ldr	w0, [sp, #28]
    c00063c4:	d37be800 	lsl	x0, x0, #5
    c00063c8:	8b000020 	add	x0, x1, x0
    c00063cc:	b900141f 	str	wzr, [x0, #20]
		cpu_descs[i].core_id = 0U;
    c00063d0:	d0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c00063d4:	91356001 	add	x1, x0, #0xd58
    c00063d8:	b9401fe0 	ldr	w0, [sp, #28]
    c00063dc:	d37be800 	lsl	x0, x0, #5
    c00063e0:	8b000020 	add	x0, x1, x0
    c00063e4:	b900181f 	str	wzr, [x0, #24]
	for (i = 0U; i < PLAT_MAX_CPUS; ++i) {
    c00063e8:	b9401fe0 	ldr	w0, [sp, #28]
    c00063ec:	11000400 	add	w0, w0, #0x1
    c00063f0:	b9001fe0 	str	w0, [sp, #28]
    c00063f4:	b9401fe0 	ldr	w0, [sp, #28]
    c00063f8:	71001c1f 	cmp	w0, #0x7
    c00063fc:	54fff889 	b.ls	c000630c <topology_init+0x18>  // b.plast
	}

	topology_fill_descriptor(&cpu_descs[0], 0U, mpidr, true);
    c0006400:	52800023 	mov	w3, #0x1                   	// #1
    c0006404:	f9400be2 	ldr	x2, [sp, #16]
    c0006408:	52800001 	mov	w1, #0x0                   	// #0
    c000640c:	d0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c0006410:	91356000 	add	x0, x0, #0xd58
    c0006414:	97ffff94 	bl	c0006264 <topology_fill_descriptor>
	cpu_descs[0].present = true;
    c0006418:	d0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c000641c:	91356000 	add	x0, x0, #0xd58
    c0006420:	52800021 	mov	w1, #0x1                   	// #1
    c0006424:	39007401 	strb	w1, [x0, #29]
	cpu_descs[0].online = true;
    c0006428:	d0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c000642c:	91356000 	add	x0, x0, #0xd58
    c0006430:	52800021 	mov	w1, #0x1                   	// #1
    c0006434:	39007801 	strb	w1, [x0, #30]
	present_cpu_count = 1U;
    c0006438:	d0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c000643c:	91396000 	add	x0, x0, #0xe58
    c0006440:	52800021 	mov	w1, #0x1                   	// #1
    c0006444:	b9000001 	str	w1, [x0]
	online_cpu_count = 1U;
    c0006448:	d0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c000644c:	91397000 	add	x0, x0, #0xe5c
    c0006450:	52800021 	mov	w1, #0x1                   	// #1
    c0006454:	b9000001 	str	w1, [x0]
}
    c0006458:	d503201f 	nop
    c000645c:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c0006460:	d65f03c0 	ret

00000000c0006464 <topology_boot_cpu>:

const struct cpu_topology_descriptor *topology_boot_cpu(void)
{
	return &cpu_descs[0];
    c0006464:	d0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c0006468:	91356000 	add	x0, x0, #0xd58
}
    c000646c:	d65f03c0 	ret

00000000c0006470 <topology_cpu>:

const struct cpu_topology_descriptor *topology_cpu(unsigned int logical_id)
{
    c0006470:	d10043ff 	sub	sp, sp, #0x10
    c0006474:	b9000fe0 	str	w0, [sp, #12]
	if (logical_id >= PLAT_MAX_CPUS) {
    c0006478:	b9400fe0 	ldr	w0, [sp, #12]
    c000647c:	71001c1f 	cmp	w0, #0x7
    c0006480:	54000069 	b.ls	c000648c <topology_cpu+0x1c>  // b.plast
		return (const struct cpu_topology_descriptor *)0;
    c0006484:	d2800000 	mov	x0, #0x0                   	// #0
    c0006488:	14000006 	b	c00064a0 <topology_cpu+0x30>
	}

	return &cpu_descs[logical_id];
    c000648c:	b9400fe0 	ldr	w0, [sp, #12]
    c0006490:	d37be801 	lsl	x1, x0, #5
    c0006494:	d0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c0006498:	91356000 	add	x0, x0, #0xd58
    c000649c:	8b000020 	add	x0, x1, x0
}
    c00064a0:	910043ff 	add	sp, sp, #0x10
    c00064a4:	d65f03c0 	ret

00000000c00064a8 <topology_find_cpu_by_mpidr>:

const struct cpu_topology_descriptor *topology_find_cpu_by_mpidr(uint64_t mpidr)
{
    c00064a8:	d10083ff 	sub	sp, sp, #0x20
    c00064ac:	f90007e0 	str	x0, [sp, #8]
	unsigned int i;

	for (i = 0U; i < PLAT_MAX_CPUS; ++i) {
    c00064b0:	b9001fff 	str	wzr, [sp, #28]
    c00064b4:	1400001c 	b	c0006524 <topology_find_cpu_by_mpidr+0x7c>
		if (cpu_descs[i].present && (cpu_descs[i].mpidr == mpidr)) {
    c00064b8:	d0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c00064bc:	91356001 	add	x1, x0, #0xd58
    c00064c0:	b9401fe0 	ldr	w0, [sp, #28]
    c00064c4:	d37be800 	lsl	x0, x0, #5
    c00064c8:	8b000020 	add	x0, x1, x0
    c00064cc:	39407400 	ldrb	w0, [x0, #29]
    c00064d0:	12000000 	and	w0, w0, #0x1
    c00064d4:	7100001f 	cmp	w0, #0x0
    c00064d8:	54000200 	b.eq	c0006518 <topology_find_cpu_by_mpidr+0x70>  // b.none
    c00064dc:	d0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c00064e0:	91356001 	add	x1, x0, #0xd58
    c00064e4:	b9401fe0 	ldr	w0, [sp, #28]
    c00064e8:	d37be800 	lsl	x0, x0, #5
    c00064ec:	8b000020 	add	x0, x1, x0
    c00064f0:	f9400000 	ldr	x0, [x0]
    c00064f4:	f94007e1 	ldr	x1, [sp, #8]
    c00064f8:	eb00003f 	cmp	x1, x0
    c00064fc:	540000e1 	b.ne	c0006518 <topology_find_cpu_by_mpidr+0x70>  // b.any
			return &cpu_descs[i];
    c0006500:	b9401fe0 	ldr	w0, [sp, #28]
    c0006504:	d37be801 	lsl	x1, x0, #5
    c0006508:	d0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c000650c:	91356000 	add	x0, x0, #0xd58
    c0006510:	8b000020 	add	x0, x1, x0
    c0006514:	14000008 	b	c0006534 <topology_find_cpu_by_mpidr+0x8c>
	for (i = 0U; i < PLAT_MAX_CPUS; ++i) {
    c0006518:	b9401fe0 	ldr	w0, [sp, #28]
    c000651c:	11000400 	add	w0, w0, #0x1
    c0006520:	b9001fe0 	str	w0, [sp, #28]
    c0006524:	b9401fe0 	ldr	w0, [sp, #28]
    c0006528:	71001c1f 	cmp	w0, #0x7
    c000652c:	54fffc69 	b.ls	c00064b8 <topology_find_cpu_by_mpidr+0x10>  // b.plast
		}
	}

	return (const struct cpu_topology_descriptor *)0;
    c0006530:	d2800000 	mov	x0, #0x0                   	// #0
}
    c0006534:	910083ff 	add	sp, sp, #0x20
    c0006538:	d65f03c0 	ret

00000000c000653c <topology_cpu_capacity>:

unsigned int topology_cpu_capacity(void)
{
	return PLAT_MAX_CPUS;
    c000653c:	52800100 	mov	w0, #0x8                   	// #8
}
    c0006540:	d65f03c0 	ret

00000000c0006544 <topology_present_cpu_count>:

unsigned int topology_present_cpu_count(void)
{
	return present_cpu_count;
    c0006544:	d0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c0006548:	91396000 	add	x0, x0, #0xe58
    c000654c:	b9400000 	ldr	w0, [x0]
}
    c0006550:	d65f03c0 	ret

00000000c0006554 <topology_online_cpu_count>:

unsigned int topology_online_cpu_count(void)
{
	return online_cpu_count;
    c0006554:	d0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c0006558:	91397000 	add	x0, x0, #0xe5c
    c000655c:	b9400000 	ldr	w0, [x0]
}
    c0006560:	d65f03c0 	ret

00000000c0006564 <topology_mark_cpu_online>:

void topology_mark_cpu_online(unsigned int logical_id, bool online)
{
    c0006564:	d10043ff 	sub	sp, sp, #0x10
    c0006568:	b9000fe0 	str	w0, [sp, #12]
    c000656c:	39002fe1 	strb	w1, [sp, #11]
	if (logical_id >= PLAT_MAX_CPUS) {
    c0006570:	b9400fe0 	ldr	w0, [sp, #12]
    c0006574:	71001c1f 	cmp	w0, #0x7
    c0006578:	54000b48 	b.hi	c00066e0 <topology_mark_cpu_online+0x17c>  // b.pmore
		return;
	}

	if (!cpu_descs[logical_id].present) {
    c000657c:	d0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c0006580:	91356001 	add	x1, x0, #0xd58
    c0006584:	b9400fe0 	ldr	w0, [sp, #12]
    c0006588:	d37be800 	lsl	x0, x0, #5
    c000658c:	8b000020 	add	x0, x1, x0
    c0006590:	39407400 	ldrb	w0, [x0, #29]
    c0006594:	52000000 	eor	w0, w0, #0x1
    c0006598:	12001c00 	and	w0, w0, #0xff
    c000659c:	12000000 	and	w0, w0, #0x1
    c00065a0:	7100001f 	cmp	w0, #0x0
    c00065a4:	540001e0 	b.eq	c00065e0 <topology_mark_cpu_online+0x7c>  // b.none
		cpu_descs[logical_id].present = true;
    c00065a8:	d0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c00065ac:	91356001 	add	x1, x0, #0xd58
    c00065b0:	b9400fe0 	ldr	w0, [sp, #12]
    c00065b4:	d37be800 	lsl	x0, x0, #5
    c00065b8:	8b000020 	add	x0, x1, x0
    c00065bc:	52800021 	mov	w1, #0x1                   	// #1
    c00065c0:	39007401 	strb	w1, [x0, #29]
		present_cpu_count++;
    c00065c4:	d0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c00065c8:	91396000 	add	x0, x0, #0xe58
    c00065cc:	b9400000 	ldr	w0, [x0]
    c00065d0:	11000401 	add	w1, w0, #0x1
    c00065d4:	d0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c00065d8:	91396000 	add	x0, x0, #0xe58
    c00065dc:	b9000001 	str	w1, [x0]
	}

	if (online && !cpu_descs[logical_id].online) {
    c00065e0:	39402fe0 	ldrb	w0, [sp, #11]
    c00065e4:	12000000 	and	w0, w0, #0x1
    c00065e8:	7100001f 	cmp	w0, #0x0
    c00065ec:	54000360 	b.eq	c0006658 <topology_mark_cpu_online+0xf4>  // b.none
    c00065f0:	d0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c00065f4:	91356001 	add	x1, x0, #0xd58
    c00065f8:	b9400fe0 	ldr	w0, [sp, #12]
    c00065fc:	d37be800 	lsl	x0, x0, #5
    c0006600:	8b000020 	add	x0, x1, x0
    c0006604:	39407800 	ldrb	w0, [x0, #30]
    c0006608:	52000000 	eor	w0, w0, #0x1
    c000660c:	12001c00 	and	w0, w0, #0xff
    c0006610:	12000000 	and	w0, w0, #0x1
    c0006614:	7100001f 	cmp	w0, #0x0
    c0006618:	54000200 	b.eq	c0006658 <topology_mark_cpu_online+0xf4>  // b.none
		cpu_descs[logical_id].online = true;
    c000661c:	d0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c0006620:	91356001 	add	x1, x0, #0xd58
    c0006624:	b9400fe0 	ldr	w0, [sp, #12]
    c0006628:	d37be800 	lsl	x0, x0, #5
    c000662c:	8b000020 	add	x0, x1, x0
    c0006630:	52800021 	mov	w1, #0x1                   	// #1
    c0006634:	39007801 	strb	w1, [x0, #30]
		online_cpu_count++;
    c0006638:	d0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c000663c:	91397000 	add	x0, x0, #0xe5c
    c0006640:	b9400000 	ldr	w0, [x0]
    c0006644:	11000401 	add	w1, w0, #0x1
    c0006648:	d0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c000664c:	91397000 	add	x0, x0, #0xe5c
    c0006650:	b9000001 	str	w1, [x0]
    c0006654:	14000024 	b	c00066e4 <topology_mark_cpu_online+0x180>
	} else if (!online && cpu_descs[logical_id].online) {
    c0006658:	39402fe0 	ldrb	w0, [sp, #11]
    c000665c:	52000000 	eor	w0, w0, #0x1
    c0006660:	12001c00 	and	w0, w0, #0xff
    c0006664:	12000000 	and	w0, w0, #0x1
    c0006668:	7100001f 	cmp	w0, #0x0
    c000666c:	540003c0 	b.eq	c00066e4 <topology_mark_cpu_online+0x180>  // b.none
    c0006670:	d0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c0006674:	91356001 	add	x1, x0, #0xd58
    c0006678:	b9400fe0 	ldr	w0, [sp, #12]
    c000667c:	d37be800 	lsl	x0, x0, #5
    c0006680:	8b000020 	add	x0, x1, x0
    c0006684:	39407800 	ldrb	w0, [x0, #30]
    c0006688:	12000000 	and	w0, w0, #0x1
    c000668c:	7100001f 	cmp	w0, #0x0
    c0006690:	540002a0 	b.eq	c00066e4 <topology_mark_cpu_online+0x180>  // b.none
		cpu_descs[logical_id].online = false;
    c0006694:	d0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c0006698:	91356001 	add	x1, x0, #0xd58
    c000669c:	b9400fe0 	ldr	w0, [sp, #12]
    c00066a0:	d37be800 	lsl	x0, x0, #5
    c00066a4:	8b000020 	add	x0, x1, x0
    c00066a8:	3900781f 	strb	wzr, [x0, #30]
		if (online_cpu_count > 0U) {
    c00066ac:	d0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c00066b0:	91397000 	add	x0, x0, #0xe5c
    c00066b4:	b9400000 	ldr	w0, [x0]
    c00066b8:	7100001f 	cmp	w0, #0x0
    c00066bc:	54000140 	b.eq	c00066e4 <topology_mark_cpu_online+0x180>  // b.none
			online_cpu_count--;
    c00066c0:	d0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c00066c4:	91397000 	add	x0, x0, #0xe5c
    c00066c8:	b9400000 	ldr	w0, [x0]
    c00066cc:	51000401 	sub	w1, w0, #0x1
    c00066d0:	d0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c00066d4:	91397000 	add	x0, x0, #0xe5c
    c00066d8:	b9000001 	str	w1, [x0]
    c00066dc:	14000002 	b	c00066e4 <topology_mark_cpu_online+0x180>
		return;
    c00066e0:	d503201f 	nop
		}
	}
}
    c00066e4:	910043ff 	add	sp, sp, #0x10
    c00066e8:	d65f03c0 	ret

00000000c00066ec <topology_register_cpu>:

void topology_register_cpu(unsigned int logical_id, uint64_t mpidr, bool boot_cpu)
{
    c00066ec:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c00066f0:	910003fd 	mov	x29, sp
    c00066f4:	b9001fe0 	str	w0, [sp, #28]
    c00066f8:	f9000be1 	str	x1, [sp, #16]
    c00066fc:	39006fe2 	strb	w2, [sp, #27]
	if (logical_id >= PLAT_MAX_CPUS) {
    c0006700:	b9401fe0 	ldr	w0, [sp, #28]
    c0006704:	71001c1f 	cmp	w0, #0x7
    c0006708:	54000548 	b.hi	c00067b0 <topology_register_cpu+0xc4>  // b.pmore
		return;
	}

	if (!cpu_descs[logical_id].present) {
    c000670c:	d0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c0006710:	91356001 	add	x1, x0, #0xd58
    c0006714:	b9401fe0 	ldr	w0, [sp, #28]
    c0006718:	d37be800 	lsl	x0, x0, #5
    c000671c:	8b000020 	add	x0, x1, x0
    c0006720:	39407400 	ldrb	w0, [x0, #29]
    c0006724:	52000000 	eor	w0, w0, #0x1
    c0006728:	12001c00 	and	w0, w0, #0xff
    c000672c:	12000000 	and	w0, w0, #0x1
    c0006730:	7100001f 	cmp	w0, #0x0
    c0006734:	54000100 	b.eq	c0006754 <topology_register_cpu+0x68>  // b.none
		present_cpu_count++;
    c0006738:	d0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c000673c:	91396000 	add	x0, x0, #0xe58
    c0006740:	b9400000 	ldr	w0, [x0]
    c0006744:	11000401 	add	w1, w0, #0x1
    c0006748:	d0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c000674c:	91396000 	add	x0, x0, #0xe58
    c0006750:	b9000001 	str	w1, [x0]
	}

	topology_fill_descriptor(&cpu_descs[logical_id], logical_id, mpidr, boot_cpu);
    c0006754:	b9401fe0 	ldr	w0, [sp, #28]
    c0006758:	d37be801 	lsl	x1, x0, #5
    c000675c:	d0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c0006760:	91356000 	add	x0, x0, #0xd58
    c0006764:	8b000020 	add	x0, x1, x0
    c0006768:	39406fe3 	ldrb	w3, [sp, #27]
    c000676c:	f9400be2 	ldr	x2, [sp, #16]
    c0006770:	b9401fe1 	ldr	w1, [sp, #28]
    c0006774:	97fffebc 	bl	c0006264 <topology_fill_descriptor>
	cpu_descs[logical_id].present = true;
    c0006778:	d0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c000677c:	91356001 	add	x1, x0, #0xd58
    c0006780:	b9401fe0 	ldr	w0, [sp, #28]
    c0006784:	d37be800 	lsl	x0, x0, #5
    c0006788:	8b000020 	add	x0, x1, x0
    c000678c:	52800021 	mov	w1, #0x1                   	// #1
    c0006790:	39007401 	strb	w1, [x0, #29]
	cpu_descs[logical_id].online = false;
    c0006794:	d0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c0006798:	91356001 	add	x1, x0, #0xd58
    c000679c:	b9401fe0 	ldr	w0, [sp, #28]
    c00067a0:	d37be800 	lsl	x0, x0, #5
    c00067a4:	8b000020 	add	x0, x1, x0
    c00067a8:	3900781f 	strb	wzr, [x0, #30]
    c00067ac:	14000002 	b	c00067b4 <topology_register_cpu+0xc8>
		return;
    c00067b0:	d503201f 	nop
}
    c00067b4:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c00067b8:	d65f03c0 	ret

00000000c00067bc <topology_unregister_cpu>:

void topology_unregister_cpu(unsigned int logical_id)
{
    c00067bc:	d10043ff 	sub	sp, sp, #0x10
    c00067c0:	b9000fe0 	str	w0, [sp, #12]
	if (logical_id >= PLAT_MAX_CPUS) {
    c00067c4:	b9400fe0 	ldr	w0, [sp, #12]
    c00067c8:	71001c1f 	cmp	w0, #0x7
    c00067cc:	54000c68 	b.hi	c0006958 <topology_unregister_cpu+0x19c>  // b.pmore
		return;
	}

	if (cpu_descs[logical_id].online) {
    c00067d0:	d0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c00067d4:	91356001 	add	x1, x0, #0xd58
    c00067d8:	b9400fe0 	ldr	w0, [sp, #12]
    c00067dc:	d37be800 	lsl	x0, x0, #5
    c00067e0:	8b000020 	add	x0, x1, x0
    c00067e4:	39407800 	ldrb	w0, [x0, #30]
    c00067e8:	12000000 	and	w0, w0, #0x1
    c00067ec:	7100001f 	cmp	w0, #0x0
    c00067f0:	54000260 	b.eq	c000683c <topology_unregister_cpu+0x80>  // b.none
		cpu_descs[logical_id].online = false;
    c00067f4:	d0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c00067f8:	91356001 	add	x1, x0, #0xd58
    c00067fc:	b9400fe0 	ldr	w0, [sp, #12]
    c0006800:	d37be800 	lsl	x0, x0, #5
    c0006804:	8b000020 	add	x0, x1, x0
    c0006808:	3900781f 	strb	wzr, [x0, #30]
		if (online_cpu_count > 0U) {
    c000680c:	d0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c0006810:	91397000 	add	x0, x0, #0xe5c
    c0006814:	b9400000 	ldr	w0, [x0]
    c0006818:	7100001f 	cmp	w0, #0x0
    c000681c:	54000100 	b.eq	c000683c <topology_unregister_cpu+0x80>  // b.none
			online_cpu_count--;
    c0006820:	d0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c0006824:	91397000 	add	x0, x0, #0xe5c
    c0006828:	b9400000 	ldr	w0, [x0]
    c000682c:	51000401 	sub	w1, w0, #0x1
    c0006830:	d0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c0006834:	91397000 	add	x0, x0, #0xe5c
    c0006838:	b9000001 	str	w1, [x0]
		}
	}

	if (cpu_descs[logical_id].present) {
    c000683c:	d0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c0006840:	91356001 	add	x1, x0, #0xd58
    c0006844:	b9400fe0 	ldr	w0, [sp, #12]
    c0006848:	d37be800 	lsl	x0, x0, #5
    c000684c:	8b000020 	add	x0, x1, x0
    c0006850:	39407400 	ldrb	w0, [x0, #29]
    c0006854:	12000000 	and	w0, w0, #0x1
    c0006858:	7100001f 	cmp	w0, #0x0
    c000685c:	54000260 	b.eq	c00068a8 <topology_unregister_cpu+0xec>  // b.none
		cpu_descs[logical_id].present = false;
    c0006860:	d0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c0006864:	91356001 	add	x1, x0, #0xd58
    c0006868:	b9400fe0 	ldr	w0, [sp, #12]
    c000686c:	d37be800 	lsl	x0, x0, #5
    c0006870:	8b000020 	add	x0, x1, x0
    c0006874:	3900741f 	strb	wzr, [x0, #29]
		if (present_cpu_count > 0U) {
    c0006878:	d0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c000687c:	91396000 	add	x0, x0, #0xe58
    c0006880:	b9400000 	ldr	w0, [x0]
    c0006884:	7100001f 	cmp	w0, #0x0
    c0006888:	54000100 	b.eq	c00068a8 <topology_unregister_cpu+0xec>  // b.none
			present_cpu_count--;
    c000688c:	d0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c0006890:	91396000 	add	x0, x0, #0xe58
    c0006894:	b9400000 	ldr	w0, [x0]
    c0006898:	51000401 	sub	w1, w0, #0x1
    c000689c:	d0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c00068a0:	91396000 	add	x0, x0, #0xe58
    c00068a4:	b9000001 	str	w1, [x0]
		}
	}

	cpu_descs[logical_id].logical_id = logical_id;
    c00068a8:	d0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c00068ac:	91356001 	add	x1, x0, #0xd58
    c00068b0:	b9400fe0 	ldr	w0, [sp, #12]
    c00068b4:	d37be800 	lsl	x0, x0, #5
    c00068b8:	8b000020 	add	x0, x1, x0
    c00068bc:	b9400fe1 	ldr	w1, [sp, #12]
    c00068c0:	b9000801 	str	w1, [x0, #8]
	cpu_descs[logical_id].boot_cpu = false;
    c00068c4:	d0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c00068c8:	91356001 	add	x1, x0, #0xd58
    c00068cc:	b9400fe0 	ldr	w0, [sp, #12]
    c00068d0:	d37be800 	lsl	x0, x0, #5
    c00068d4:	8b000020 	add	x0, x1, x0
    c00068d8:	3900701f 	strb	wzr, [x0, #28]
	cpu_descs[logical_id].mpidr = 0U;
    c00068dc:	d0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c00068e0:	91356001 	add	x1, x0, #0xd58
    c00068e4:	b9400fe0 	ldr	w0, [sp, #12]
    c00068e8:	d37be800 	lsl	x0, x0, #5
    c00068ec:	8b000020 	add	x0, x1, x0
    c00068f0:	f900001f 	str	xzr, [x0]
	cpu_descs[logical_id].chip_id = 0U;
    c00068f4:	d0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c00068f8:	91356001 	add	x1, x0, #0xd58
    c00068fc:	b9400fe0 	ldr	w0, [sp, #12]
    c0006900:	d37be800 	lsl	x0, x0, #5
    c0006904:	8b000020 	add	x0, x1, x0
    c0006908:	b9000c1f 	str	wzr, [x0, #12]
	cpu_descs[logical_id].die_id = 0U;
    c000690c:	d0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c0006910:	91356001 	add	x1, x0, #0xd58
    c0006914:	b9400fe0 	ldr	w0, [sp, #12]
    c0006918:	d37be800 	lsl	x0, x0, #5
    c000691c:	8b000020 	add	x0, x1, x0
    c0006920:	b900101f 	str	wzr, [x0, #16]
	cpu_descs[logical_id].cluster_id = 0U;
    c0006924:	d0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c0006928:	91356001 	add	x1, x0, #0xd58
    c000692c:	b9400fe0 	ldr	w0, [sp, #12]
    c0006930:	d37be800 	lsl	x0, x0, #5
    c0006934:	8b000020 	add	x0, x1, x0
    c0006938:	b900141f 	str	wzr, [x0, #20]
	cpu_descs[logical_id].core_id = 0U;
    c000693c:	d0000100 	adrp	x0, c0028000 <secondary_stacks+0x1fd30>
    c0006940:	91356001 	add	x1, x0, #0xd58
    c0006944:	b9400fe0 	ldr	w0, [sp, #12]
    c0006948:	d37be800 	lsl	x0, x0, #5
    c000694c:	8b000020 	add	x0, x1, x0
    c0006950:	b900181f 	str	wzr, [x0, #24]
    c0006954:	14000002 	b	c000695c <topology_unregister_cpu+0x1a0>
		return;
    c0006958:	d503201f 	nop
    c000695c:	910043ff 	add	sp, sp, #0x10
    c0006960:	d65f03c0 	ret
