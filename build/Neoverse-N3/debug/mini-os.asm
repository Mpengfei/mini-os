
/home/pengfei/felix-os/mini-os/build/Neoverse-N3/debug/mini-os.elf:     file format elf64-littleaarch64


Disassembly of section .text:

00000000c0000000 <_start>:
    c0000000:	580000c0 	ldr	x0, c0000018 <_start+0x18>
    c0000004:	9100001f 	mov	sp, x0
    c0000008:	94000977 	bl	c00025e4 <kernel_main>
    c000000c:	d503205f 	wfe
    c0000010:	17ffffff 	b	c000000c <_start+0xc>
    c0000014:	00000000 	udf	#0
    c0000018:	c000fcc0 	.word	0xc000fcc0
    c000001c:	00000000 	.word	0x00000000

00000000c0000020 <secondary_cpu_entrypoint>:
    c0000020:	58000101 	ldr	x1, c0000040 <secondary_cpu_entrypoint+0x20>
    c0000024:	58000122 	ldr	x2, c0000048 <secondary_cpu_entrypoint+0x28>
    c0000028:	9b020401 	madd	x1, x0, x2, x1
    c000002c:	8b020021 	add	x1, x1, x2
    c0000030:	9100003f 	mov	sp, x1
    c0000034:	940013c3 	bl	c0004f40 <smp_secondary_entry>
    c0000038:	d503205f 	wfe
    c000003c:	17ffffff 	b	c0000038 <secondary_cpu_entrypoint+0x18>
    c0000040:	c0006af0 	.word	0xc0006af0
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
    c0000a18:	b0000020 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c0000a1c:	911ba000 	add	x0, x0, #0x6e8
    c0000a20:	14000003 	b	c0000a2c <u64_to_str+0x38>
    c0000a24:	b0000020 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c0000a28:	911c0000 	add	x0, x0, #0x700
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
    c0000eec:	b0000020 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c0000ef0:	911b8000 	add	x0, x0, #0x6e0
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
    c000163c:	b0000020 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0001640:	912ac000 	add	x0, x0, #0xab0
    c0001644:	9400056e 	bl	c0002bfc <spinlock_lock>
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
    c0001bfc:	b0000020 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0001c00:	912ac000 	add	x0, x0, #0xab0
    c0001c04:	94000406 	bl	c0002c1c <spinlock_unlock>
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
    c0001d88:	b0000020 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0001d8c:	912ac000 	add	x0, x0, #0xab0
    c0001d90:	94000310 	bl	c00029d0 <spinlock_init>
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
    c0001db0:	b0000020 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0001db4:	912ac000 	add	x0, x0, #0xab0
    c0001db8:	94000391 	bl	c0002bfc <spinlock_lock>
	uart_putc(ch);
    c0001dbc:	b9401fe0 	ldr	w0, [sp, #28]
    c0001dc0:	9400012b 	bl	c000226c <uart_putc>
	spinlock_unlock(&debug_console_lock);
    c0001dc4:	b0000020 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0001dc8:	912ac000 	add	x0, x0, #0xab0
    c0001dcc:	94000394 	bl	c0002c1c <spinlock_unlock>
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
    c0001de8:	b0000020 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0001dec:	912ac000 	add	x0, x0, #0xab0
    c0001df0:	94000383 	bl	c0002bfc <spinlock_lock>
	uart_puts(str);
    c0001df4:	f9400fe0 	ldr	x0, [sp, #24]
    c0001df8:	94000138 	bl	c00022d8 <uart_puts>
	spinlock_unlock(&debug_console_lock);
    c0001dfc:	b0000020 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0001e00:	912ac000 	add	x0, x0, #0xab0
    c0001e04:	94000386 	bl	c0002c1c <spinlock_unlock>
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
    c0001e24:	b0000020 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0001e28:	912ac000 	add	x0, x0, #0xab0
    c0001e2c:	94000374 	bl	c0002bfc <spinlock_lock>
	uart_write(buf, len);
    c0001e30:	f9400be1 	ldr	x1, [sp, #16]
    c0001e34:	f9400fe0 	ldr	x0, [sp, #24]
    c0001e38:	94000142 	bl	c0002340 <uart_write>
	spinlock_unlock(&debug_console_lock);
    c0001e3c:	b0000020 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0001e40:	912ac000 	add	x0, x0, #0xab0
    c0001e44:	94000376 	bl	c0002c1c <spinlock_unlock>
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
    c0001e88:	b0000020 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0001e8c:	912ac000 	add	x0, x0, #0xab0
    c0001e90:	9400035b 	bl	c0002bfc <spinlock_lock>
	uart_put_hex64(value);
    c0001e94:	f9400fe0 	ldr	x0, [sp, #24]
    c0001e98:	94000168 	bl	c0002438 <uart_put_hex64>
	spinlock_unlock(&debug_console_lock);
    c0001e9c:	b0000020 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0001ea0:	912ac000 	add	x0, x0, #0xab0
    c0001ea4:	9400035e 	bl	c0002c1c <spinlock_unlock>
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
    c0001ebc:	b0000020 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0001ec0:	912ac000 	add	x0, x0, #0xab0
    c0001ec4:	9400034e 	bl	c0002bfc <spinlock_lock>
	uart_flush();
    c0001ec8:	94000174 	bl	c0002498 <uart_flush>
	spinlock_unlock(&debug_console_lock);
    c0001ecc:	b0000020 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0001ed0:	912ac000 	add	x0, x0, #0xab0
    c0001ed4:	94000352 	bl	c0002c1c <spinlock_unlock>
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
    c0002024:	90000020 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0002028:	912a4000 	add	x0, x0, #0xa90
    c000202c:	f9400000 	ldr	x0, [x0]
	       (plat_uart.clock_hz != 0U) &&
    c0002030:	f100001f 	cmp	x0, #0x0
    c0002034:	540001a0 	b.eq	c0002068 <uart_is_configured+0x44>  // b.none
    c0002038:	90000020 	adrp	x0, c0006000 <hex.0+0x8e8>
    c000203c:	912a4000 	add	x0, x0, #0xa90
    c0002040:	b9400800 	ldr	w0, [x0, #8]
	return (plat_uart.base != 0UL) &&
    c0002044:	7100001f 	cmp	w0, #0x0
    c0002048:	54000100 	b.eq	c0002068 <uart_is_configured+0x44>  // b.none
	       (plat_uart.baudrate != 0U);
    c000204c:	90000020 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0002050:	912a4000 	add	x0, x0, #0xa90
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
    c00020a4:	90000020 	adrp	x0, c0006000 <hex.0+0x8e8>
    c00020a8:	912a4000 	add	x0, x0, #0xa90
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
    c00020fc:	90000020 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0002100:	912a4000 	add	x0, x0, #0xa90
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
    c000214c:	90000020 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0002150:	912a4000 	add	x0, x0, #0xa90
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
    c0002170:	90000020 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0002174:	912a4000 	add	x0, x0, #0xa90
    c0002178:	f9400000 	ldr	x0, [x0]
    c000217c:	91006000 	add	x0, x0, #0x18
    c0002180:	97ffff62 	bl	c0001f08 <mmio_read_32>
    c0002184:	121d0000 	and	w0, w0, #0x8
    c0002188:	7100001f 	cmp	w0, #0x0
    c000218c:	54ffff21 	b.ne	c0002170 <uart_init+0x48>  // b.any
	}

	mmio_write_32(plat_uart.base + PL011_ICR, PL011_ICR_ALL);
    c0002190:	90000020 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0002194:	912a4000 	add	x0, x0, #0xa90
    c0002198:	f9400000 	ldr	x0, [x0]
    c000219c:	91011000 	add	x0, x0, #0x44
    c00021a0:	5280ffe1 	mov	w1, #0x7ff                 	// #2047
    c00021a4:	97ffff50 	bl	c0001ee4 <mmio_write_32>
	mmio_write_32(plat_uart.base + PL011_IMSC, 0U);
    c00021a8:	90000020 	adrp	x0, c0006000 <hex.0+0x8e8>
    c00021ac:	912a4000 	add	x0, x0, #0xa90
    c00021b0:	f9400000 	ldr	x0, [x0]
    c00021b4:	9100e000 	add	x0, x0, #0x38
    c00021b8:	52800001 	mov	w1, #0x0                   	// #0
    c00021bc:	97ffff4a 	bl	c0001ee4 <mmio_write_32>

	pl011_calc_baud(plat_uart.clock_hz, plat_uart.baudrate, &ibrd, &fbrd);
    c00021c0:	90000020 	adrp	x0, c0006000 <hex.0+0x8e8>
    c00021c4:	912a4000 	add	x0, x0, #0xa90
    c00021c8:	b9400804 	ldr	w4, [x0, #8]
    c00021cc:	90000020 	adrp	x0, c0006000 <hex.0+0x8e8>
    c00021d0:	912a4000 	add	x0, x0, #0xa90
    c00021d4:	b9400c00 	ldr	w0, [x0, #12]
    c00021d8:	910063e2 	add	x2, sp, #0x18
    c00021dc:	910073e1 	add	x1, sp, #0x1c
    c00021e0:	aa0203e3 	mov	x3, x2
    c00021e4:	aa0103e2 	mov	x2, x1
    c00021e8:	2a0003e1 	mov	w1, w0
    c00021ec:	2a0403e0 	mov	w0, w4
    c00021f0:	97ffff52 	bl	c0001f38 <pl011_calc_baud>
	mmio_write_32(plat_uart.base + PL011_IBRD, ibrd);
    c00021f4:	90000020 	adrp	x0, c0006000 <hex.0+0x8e8>
    c00021f8:	912a4000 	add	x0, x0, #0xa90
    c00021fc:	f9400000 	ldr	x0, [x0]
    c0002200:	91009000 	add	x0, x0, #0x24
    c0002204:	b9401fe1 	ldr	w1, [sp, #28]
    c0002208:	97ffff37 	bl	c0001ee4 <mmio_write_32>
	mmio_write_32(plat_uart.base + PL011_FBRD, fbrd);
    c000220c:	90000020 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0002210:	912a4000 	add	x0, x0, #0xa90
    c0002214:	f9400000 	ldr	x0, [x0]
    c0002218:	9100a000 	add	x0, x0, #0x28
    c000221c:	b9401be1 	ldr	w1, [sp, #24]
    c0002220:	97ffff31 	bl	c0001ee4 <mmio_write_32>
	mmio_write_32(plat_uart.base + PL011_LCRH, LCRH_WLEN_8 | LCRH_FEN);
    c0002224:	90000020 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0002228:	912a4000 	add	x0, x0, #0xa90
    c000222c:	f9400000 	ldr	x0, [x0]
    c0002230:	9100b000 	add	x0, x0, #0x2c
    c0002234:	52800e01 	mov	w1, #0x70                  	// #112
    c0002238:	97ffff2b 	bl	c0001ee4 <mmio_write_32>
	mmio_write_32(plat_uart.base + PL011_CR, CR_UARTEN | CR_TXE | CR_RXE);
    c000223c:	90000020 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0002240:	912a4000 	add	x0, x0, #0xa90
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
    c00022b4:	90000020 	adrp	x0, c0006000 <hex.0+0x8e8>
    c00022b8:	912a4000 	add	x0, x0, #0xa90
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
    c00023d0:	90000020 	adrp	x0, c0006000 <hex.0+0x8e8>
    c00023d4:	912a4000 	add	x0, x0, #0xa90
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
    c0002460:	f0000001 	adrp	x1, c0005000 <topology_fill_descriptor+0x2c>
    c0002464:	911c6021 	add	x1, x1, #0x718
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
    c00024c0:	90000020 	adrp	x0, c0006000 <hex.0+0x8e8>
    c00024c4:	912a4000 	add	x0, x0, #0xa90
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
    c0002500:	f0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c0002504:	911cc000 	add	x0, x0, #0x730
    c0002508:	97fffe35 	bl	c0001ddc <debug_puts>
    debug_puts("============================================================\n");
    c000250c:	f0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c0002510:	911ce000 	add	x0, x0, #0x738
    c0002514:	97fffe32 	bl	c0001ddc <debug_puts>
    debug_puts("            __  __   ___   _   _   ___    ___    ____      \n");
    c0002518:	f0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c000251c:	911de000 	add	x0, x0, #0x778
    c0002520:	97fffe2f 	bl	c0001ddc <debug_puts>
    debug_puts("           |  \\/  | |_ _| | \\ | | |_ _|  / _ \\  / ___|     \n");
    c0002524:	f0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c0002528:	911ee000 	add	x0, x0, #0x7b8
    c000252c:	97fffe2c 	bl	c0001ddc <debug_puts>
    debug_puts("           | |\\/| |  | |  |  \\| |  | |  | | | | \\___ \\     \n");
    c0002530:	f0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c0002534:	911fe000 	add	x0, x0, #0x7f8
    c0002538:	97fffe29 	bl	c0001ddc <debug_puts>
    debug_puts("           | |  | |  | |  | |\\  |  | |  | |_| |  ___) |    \n");
    c000253c:	f0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c0002540:	9120e000 	add	x0, x0, #0x838
    c0002544:	97fffe26 	bl	c0001ddc <debug_puts>
    debug_puts("           |_|  |_| |___| |_| \\_| |___|  \\___/  |____/     \n");
    c0002548:	f0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c000254c:	9121e000 	add	x0, x0, #0x878
    c0002550:	97fffe23 	bl	c0001ddc <debug_puts>
    debug_puts("============================================================\n");
    c0002554:	f0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c0002558:	911ce000 	add	x0, x0, #0x738
    c000255c:	97fffe20 	bl	c0001ddc <debug_puts>
    debug_puts("                     2026  Mini-OS  V0.1                    \n");
    c0002560:	f0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c0002564:	9122e000 	add	x0, x0, #0x8b8
    c0002568:	97fffe1d 	bl	c0001ddc <debug_puts>
    debug_puts("============================================================\n");
    c000256c:	f0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c0002570:	911ce000 	add	x0, x0, #0x738
    c0002574:	97fffe1a 	bl	c0001ddc <debug_puts>
    debug_puts("\n");
    c0002578:	f0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c000257c:	911cc000 	add	x0, x0, #0x730
    c0002580:	97fffe17 	bl	c0001ddc <debug_puts>

    mini_os_printf("UART ready @ 0x%llx, boot magic: 0x%llx\n\n",
    c0002584:	90000020 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0002588:	912a8000 	add	x0, x0, #0xaa0
    c000258c:	f9400000 	ldr	x0, [x0]
    c0002590:	aa0003e2 	mov	x2, x0
    c0002594:	d2a34801 	mov	x1, #0x1a400000            	// #440401920
    c0002598:	f0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c000259c:	9123e000 	add	x0, x0, #0x8f8
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
    debug_console_init();
    c00025b8:	97fffdf2 	bl	c0001d80 <debug_console_init>
	topology_init();
    c00025bc:	94000aaa 	bl	c0005064 <topology_init>
	scheduler_init();
    c00025c0:	940001a8 	bl	c0002c60 <scheduler_init>
	scheduler_join_cpu(0U);
    c00025c4:	52800000 	mov	w0, #0x0                   	// #0
    c00025c8:	940001b9 	bl	c0002cac <scheduler_join_cpu>
	smp_init();
    c00025cc:	94000880 	bl	c00047cc <smp_init>
	gic_init();
    c00025d0:	97ffffc8 	bl	c00024f0 <gic_init>
	test_framework_init();
    c00025d4:	94000a78 	bl	c0004fb4 <test_framework_init>
}
    c00025d8:	d503201f 	nop
    c00025dc:	a8c17bfd 	ldp	x29, x30, [sp], #16
    c00025e0:	d65f03c0 	ret

00000000c00025e4 <kernel_main>:

void kernel_main(void)
{
    c00025e4:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    c00025e8:	910003fd 	mov	x29, sp
    initialize_phase0_modules();
    c00025ec:	97fffff1 	bl	c00025b0 <initialize_phase0_modules>
	print_mini_os_banner();
    c00025f0:	97ffffc2 	bl	c00024f8 <print_mini_os_banner>
	shell_run();
    c00025f4:	94000713 	bl	c0004240 <shell_run>
    c00025f8:	d503201f 	nop
    c00025fc:	a8c17bfd 	ldp	x29, x30, [sp], #16
    c0002600:	d65f03c0 	ret

00000000c0002604 <bitmap_set_bit>:
#include <kernel/lib/bitmap.h>

#define BITS_PER_WORD (sizeof(unsigned long) * 8U)

void bitmap_set_bit(unsigned long *bitmap, size_t bit)
{
    c0002604:	d10043ff 	sub	sp, sp, #0x10
    c0002608:	f90007e0 	str	x0, [sp, #8]
    c000260c:	f90003e1 	str	x1, [sp]
	bitmap[bit / BITS_PER_WORD] |= (1UL << (bit % BITS_PER_WORD));
    c0002610:	f94003e0 	ldr	x0, [sp]
    c0002614:	d346fc00 	lsr	x0, x0, #6
    c0002618:	d37df001 	lsl	x1, x0, #3
    c000261c:	f94007e2 	ldr	x2, [sp, #8]
    c0002620:	8b010041 	add	x1, x2, x1
    c0002624:	f9400022 	ldr	x2, [x1]
    c0002628:	f94003e1 	ldr	x1, [sp]
    c000262c:	12001421 	and	w1, w1, #0x3f
    c0002630:	d2800023 	mov	x3, #0x1                   	// #1
    c0002634:	9ac12061 	lsl	x1, x3, x1
    c0002638:	d37df000 	lsl	x0, x0, #3
    c000263c:	f94007e3 	ldr	x3, [sp, #8]
    c0002640:	8b000060 	add	x0, x3, x0
    c0002644:	aa010041 	orr	x1, x2, x1
    c0002648:	f9000001 	str	x1, [x0]
}
    c000264c:	d503201f 	nop
    c0002650:	910043ff 	add	sp, sp, #0x10
    c0002654:	d65f03c0 	ret

00000000c0002658 <bitmap_clear_bit>:

void bitmap_clear_bit(unsigned long *bitmap, size_t bit)
{
    c0002658:	d10043ff 	sub	sp, sp, #0x10
    c000265c:	f90007e0 	str	x0, [sp, #8]
    c0002660:	f90003e1 	str	x1, [sp]
	bitmap[bit / BITS_PER_WORD] &= ~(1UL << (bit % BITS_PER_WORD));
    c0002664:	f94003e0 	ldr	x0, [sp]
    c0002668:	d346fc00 	lsr	x0, x0, #6
    c000266c:	d37df001 	lsl	x1, x0, #3
    c0002670:	f94007e2 	ldr	x2, [sp, #8]
    c0002674:	8b010041 	add	x1, x2, x1
    c0002678:	f9400022 	ldr	x2, [x1]
    c000267c:	f94003e1 	ldr	x1, [sp]
    c0002680:	12001421 	and	w1, w1, #0x3f
    c0002684:	d2800023 	mov	x3, #0x1                   	// #1
    c0002688:	9ac12061 	lsl	x1, x3, x1
    c000268c:	aa2103e1 	mvn	x1, x1
    c0002690:	d37df000 	lsl	x0, x0, #3
    c0002694:	f94007e3 	ldr	x3, [sp, #8]
    c0002698:	8b000060 	add	x0, x3, x0
    c000269c:	8a010041 	and	x1, x2, x1
    c00026a0:	f9000001 	str	x1, [x0]
}
    c00026a4:	d503201f 	nop
    c00026a8:	910043ff 	add	sp, sp, #0x10
    c00026ac:	d65f03c0 	ret

00000000c00026b0 <bitmap_test_bit>:

bool bitmap_test_bit(const unsigned long *bitmap, size_t bit)
{
    c00026b0:	d10043ff 	sub	sp, sp, #0x10
    c00026b4:	f90007e0 	str	x0, [sp, #8]
    c00026b8:	f90003e1 	str	x1, [sp]
	return (bitmap[bit / BITS_PER_WORD] & (1UL << (bit % BITS_PER_WORD))) != 0UL;
    c00026bc:	f94003e0 	ldr	x0, [sp]
    c00026c0:	d346fc00 	lsr	x0, x0, #6
    c00026c4:	d37df000 	lsl	x0, x0, #3
    c00026c8:	f94007e1 	ldr	x1, [sp, #8]
    c00026cc:	8b000020 	add	x0, x1, x0
    c00026d0:	f9400001 	ldr	x1, [x0]
    c00026d4:	f94003e0 	ldr	x0, [sp]
    c00026d8:	12001400 	and	w0, w0, #0x3f
    c00026dc:	9ac02420 	lsr	x0, x1, x0
    c00026e0:	92400000 	and	x0, x0, #0x1
    c00026e4:	f100001f 	cmp	x0, #0x0
    c00026e8:	1a9f07e0 	cset	w0, ne	// ne = any
    c00026ec:	12001c00 	and	w0, w0, #0xff
    c00026f0:	910043ff 	add	sp, sp, #0x10
    c00026f4:	d65f03c0 	ret

00000000c00026f8 <ringbuffer_init>:
#include <kernel/lib/ringbuffer.h>

void ringbuffer_init(struct ringbuffer *rb, uint8_t *storage, size_t capacity)
{
    c00026f8:	d10083ff 	sub	sp, sp, #0x20
    c00026fc:	f9000fe0 	str	x0, [sp, #24]
    c0002700:	f9000be1 	str	x1, [sp, #16]
    c0002704:	f90007e2 	str	x2, [sp, #8]
	rb->data = storage;
    c0002708:	f9400fe0 	ldr	x0, [sp, #24]
    c000270c:	f9400be1 	ldr	x1, [sp, #16]
    c0002710:	f9000001 	str	x1, [x0]
	rb->capacity = capacity;
    c0002714:	f9400fe0 	ldr	x0, [sp, #24]
    c0002718:	f94007e1 	ldr	x1, [sp, #8]
    c000271c:	f9000401 	str	x1, [x0, #8]
	rb->head = 0U;
    c0002720:	f9400fe0 	ldr	x0, [sp, #24]
    c0002724:	f900081f 	str	xzr, [x0, #16]
	rb->tail = 0U;
    c0002728:	f9400fe0 	ldr	x0, [sp, #24]
    c000272c:	f9000c1f 	str	xzr, [x0, #24]
	rb->count = 0U;
    c0002730:	f9400fe0 	ldr	x0, [sp, #24]
    c0002734:	f900101f 	str	xzr, [x0, #32]
}
    c0002738:	d503201f 	nop
    c000273c:	910083ff 	add	sp, sp, #0x20
    c0002740:	d65f03c0 	ret

00000000c0002744 <ringbuffer_is_empty>:

bool ringbuffer_is_empty(const struct ringbuffer *rb)
{
    c0002744:	d10043ff 	sub	sp, sp, #0x10
    c0002748:	f90007e0 	str	x0, [sp, #8]
	return rb->count == 0U;
    c000274c:	f94007e0 	ldr	x0, [sp, #8]
    c0002750:	f9401000 	ldr	x0, [x0, #32]
    c0002754:	f100001f 	cmp	x0, #0x0
    c0002758:	1a9f17e0 	cset	w0, eq	// eq = none
    c000275c:	12001c00 	and	w0, w0, #0xff
}
    c0002760:	910043ff 	add	sp, sp, #0x10
    c0002764:	d65f03c0 	ret

00000000c0002768 <ringbuffer_is_full>:

bool ringbuffer_is_full(const struct ringbuffer *rb)
{
    c0002768:	d10043ff 	sub	sp, sp, #0x10
    c000276c:	f90007e0 	str	x0, [sp, #8]
	return rb->count == rb->capacity;
    c0002770:	f94007e0 	ldr	x0, [sp, #8]
    c0002774:	f9401001 	ldr	x1, [x0, #32]
    c0002778:	f94007e0 	ldr	x0, [sp, #8]
    c000277c:	f9400400 	ldr	x0, [x0, #8]
    c0002780:	eb00003f 	cmp	x1, x0
    c0002784:	1a9f17e0 	cset	w0, eq	// eq = none
    c0002788:	12001c00 	and	w0, w0, #0xff
}
    c000278c:	910043ff 	add	sp, sp, #0x10
    c0002790:	d65f03c0 	ret

00000000c0002794 <ringbuffer_push>:

bool ringbuffer_push(struct ringbuffer *rb, uint8_t value)
{
    c0002794:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c0002798:	910003fd 	mov	x29, sp
    c000279c:	f9000fe0 	str	x0, [sp, #24]
    c00027a0:	39005fe1 	strb	w1, [sp, #23]
	if (ringbuffer_is_full(rb)) {
    c00027a4:	f9400fe0 	ldr	x0, [sp, #24]
    c00027a8:	97fffff0 	bl	c0002768 <ringbuffer_is_full>
    c00027ac:	12001c00 	and	w0, w0, #0xff
    c00027b0:	12000000 	and	w0, w0, #0x1
    c00027b4:	7100001f 	cmp	w0, #0x0
    c00027b8:	54000060 	b.eq	c00027c4 <ringbuffer_push+0x30>  // b.none
		return false;
    c00027bc:	52800000 	mov	w0, #0x0                   	// #0
    c00027c0:	14000018 	b	c0002820 <ringbuffer_push+0x8c>
	}

	rb->data[rb->head] = value;
    c00027c4:	f9400fe0 	ldr	x0, [sp, #24]
    c00027c8:	f9400001 	ldr	x1, [x0]
    c00027cc:	f9400fe0 	ldr	x0, [sp, #24]
    c00027d0:	f9400800 	ldr	x0, [x0, #16]
    c00027d4:	8b000020 	add	x0, x1, x0
    c00027d8:	39405fe1 	ldrb	w1, [sp, #23]
    c00027dc:	39000001 	strb	w1, [x0]
	rb->head = (rb->head + 1U) % rb->capacity;
    c00027e0:	f9400fe0 	ldr	x0, [sp, #24]
    c00027e4:	f9400800 	ldr	x0, [x0, #16]
    c00027e8:	91000400 	add	x0, x0, #0x1
    c00027ec:	f9400fe1 	ldr	x1, [sp, #24]
    c00027f0:	f9400421 	ldr	x1, [x1, #8]
    c00027f4:	9ac10802 	udiv	x2, x0, x1
    c00027f8:	9b017c41 	mul	x1, x2, x1
    c00027fc:	cb010001 	sub	x1, x0, x1
    c0002800:	f9400fe0 	ldr	x0, [sp, #24]
    c0002804:	f9000801 	str	x1, [x0, #16]
	rb->count++;
    c0002808:	f9400fe0 	ldr	x0, [sp, #24]
    c000280c:	f9401000 	ldr	x0, [x0, #32]
    c0002810:	91000401 	add	x1, x0, #0x1
    c0002814:	f9400fe0 	ldr	x0, [sp, #24]
    c0002818:	f9001001 	str	x1, [x0, #32]
	return true;
    c000281c:	52800020 	mov	w0, #0x1                   	// #1
}
    c0002820:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c0002824:	d65f03c0 	ret

00000000c0002828 <ringbuffer_pop>:

bool ringbuffer_pop(struct ringbuffer *rb, uint8_t *value)
{
    c0002828:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c000282c:	910003fd 	mov	x29, sp
    c0002830:	f9000fe0 	str	x0, [sp, #24]
    c0002834:	f9000be1 	str	x1, [sp, #16]
	if (ringbuffer_is_empty(rb)) {
    c0002838:	f9400fe0 	ldr	x0, [sp, #24]
    c000283c:	97ffffc2 	bl	c0002744 <ringbuffer_is_empty>
    c0002840:	12001c00 	and	w0, w0, #0xff
    c0002844:	12000000 	and	w0, w0, #0x1
    c0002848:	7100001f 	cmp	w0, #0x0
    c000284c:	54000060 	b.eq	c0002858 <ringbuffer_pop+0x30>  // b.none
		return false;
    c0002850:	52800000 	mov	w0, #0x0                   	// #0
    c0002854:	14000019 	b	c00028b8 <ringbuffer_pop+0x90>
	}

	*value = rb->data[rb->tail];
    c0002858:	f9400fe0 	ldr	x0, [sp, #24]
    c000285c:	f9400001 	ldr	x1, [x0]
    c0002860:	f9400fe0 	ldr	x0, [sp, #24]
    c0002864:	f9400c00 	ldr	x0, [x0, #24]
    c0002868:	8b000020 	add	x0, x1, x0
    c000286c:	39400001 	ldrb	w1, [x0]
    c0002870:	f9400be0 	ldr	x0, [sp, #16]
    c0002874:	39000001 	strb	w1, [x0]
	rb->tail = (rb->tail + 1U) % rb->capacity;
    c0002878:	f9400fe0 	ldr	x0, [sp, #24]
    c000287c:	f9400c00 	ldr	x0, [x0, #24]
    c0002880:	91000400 	add	x0, x0, #0x1
    c0002884:	f9400fe1 	ldr	x1, [sp, #24]
    c0002888:	f9400421 	ldr	x1, [x1, #8]
    c000288c:	9ac10802 	udiv	x2, x0, x1
    c0002890:	9b017c41 	mul	x1, x2, x1
    c0002894:	cb010001 	sub	x1, x0, x1
    c0002898:	f9400fe0 	ldr	x0, [sp, #24]
    c000289c:	f9000c01 	str	x1, [x0, #24]
	rb->count--;
    c00028a0:	f9400fe0 	ldr	x0, [sp, #24]
    c00028a4:	f9401000 	ldr	x0, [x0, #32]
    c00028a8:	d1000401 	sub	x1, x0, #0x1
    c00028ac:	f9400fe0 	ldr	x0, [sp, #24]
    c00028b0:	f9001001 	str	x1, [x0, #32]
	return true;
    c00028b4:	52800020 	mov	w0, #0x1                   	// #1
    c00028b8:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c00028bc:	d65f03c0 	ret

00000000c00028c0 <mini_os_strlen>:
#include <kernel/lib/string.h>

size_t mini_os_strlen(const char *str)
{
    c00028c0:	d10083ff 	sub	sp, sp, #0x20
    c00028c4:	f90007e0 	str	x0, [sp, #8]
	size_t len = 0U;
    c00028c8:	f9000fff 	str	xzr, [sp, #24]

	if (str == (const char *)0) {
    c00028cc:	f94007e0 	ldr	x0, [sp, #8]
    c00028d0:	f100001f 	cmp	x0, #0x0
    c00028d4:	540000c1 	b.ne	c00028ec <mini_os_strlen+0x2c>  // b.any
		return 0U;
    c00028d8:	d2800000 	mov	x0, #0x0                   	// #0
    c00028dc:	1400000b 	b	c0002908 <mini_os_strlen+0x48>
	}

	while (str[len] != '\0') {
		len++;
    c00028e0:	f9400fe0 	ldr	x0, [sp, #24]
    c00028e4:	91000400 	add	x0, x0, #0x1
    c00028e8:	f9000fe0 	str	x0, [sp, #24]
	while (str[len] != '\0') {
    c00028ec:	f94007e1 	ldr	x1, [sp, #8]
    c00028f0:	f9400fe0 	ldr	x0, [sp, #24]
    c00028f4:	8b000020 	add	x0, x1, x0
    c00028f8:	39400000 	ldrb	w0, [x0]
    c00028fc:	7100001f 	cmp	w0, #0x0
    c0002900:	54ffff01 	b.ne	c00028e0 <mini_os_strlen+0x20>  // b.any
	}

	return len;
    c0002904:	f9400fe0 	ldr	x0, [sp, #24]
}
    c0002908:	910083ff 	add	sp, sp, #0x20
    c000290c:	d65f03c0 	ret

00000000c0002910 <mini_os_strcmp>:

int mini_os_strcmp(const char *lhs, const char *rhs)
{
    c0002910:	d10043ff 	sub	sp, sp, #0x10
    c0002914:	f90007e0 	str	x0, [sp, #8]
    c0002918:	f90003e1 	str	x1, [sp]
	while ((*lhs != '\0') && (*lhs == *rhs)) {
    c000291c:	14000007 	b	c0002938 <mini_os_strcmp+0x28>
		lhs++;
    c0002920:	f94007e0 	ldr	x0, [sp, #8]
    c0002924:	91000400 	add	x0, x0, #0x1
    c0002928:	f90007e0 	str	x0, [sp, #8]
		rhs++;
    c000292c:	f94003e0 	ldr	x0, [sp]
    c0002930:	91000400 	add	x0, x0, #0x1
    c0002934:	f90003e0 	str	x0, [sp]
	while ((*lhs != '\0') && (*lhs == *rhs)) {
    c0002938:	f94007e0 	ldr	x0, [sp, #8]
    c000293c:	39400000 	ldrb	w0, [x0]
    c0002940:	7100001f 	cmp	w0, #0x0
    c0002944:	540000e0 	b.eq	c0002960 <mini_os_strcmp+0x50>  // b.none
    c0002948:	f94007e0 	ldr	x0, [sp, #8]
    c000294c:	39400001 	ldrb	w1, [x0]
    c0002950:	f94003e0 	ldr	x0, [sp]
    c0002954:	39400000 	ldrb	w0, [x0]
    c0002958:	6b00003f 	cmp	w1, w0
    c000295c:	54fffe20 	b.eq	c0002920 <mini_os_strcmp+0x10>  // b.none
	}

	return (int)(unsigned char)*lhs - (int)(unsigned char)*rhs;
    c0002960:	f94007e0 	ldr	x0, [sp, #8]
    c0002964:	39400000 	ldrb	w0, [x0]
    c0002968:	2a0003e1 	mov	w1, w0
    c000296c:	f94003e0 	ldr	x0, [sp]
    c0002970:	39400000 	ldrb	w0, [x0]
    c0002974:	4b000020 	sub	w0, w1, w0
    c0002978:	910043ff 	add	sp, sp, #0x10
    c000297c:	d65f03c0 	ret

00000000c0002980 <spinlock_read_mpidr>:
#include <kernel/spinlock.h>
#include <kernel/topology.h>

static inline uint64_t spinlock_read_mpidr(void)
{
    c0002980:	d10043ff 	sub	sp, sp, #0x10
	uint64_t mpidr;

	__asm__ volatile ("mrs %0, mpidr_el1" : "=r" (mpidr));
    c0002984:	d53800a0 	mrs	x0, mpidr_el1
    c0002988:	f90007e0 	str	x0, [sp, #8]
	return mpidr;
    c000298c:	f94007e0 	ldr	x0, [sp, #8]
}
    c0002990:	910043ff 	add	sp, sp, #0x10
    c0002994:	d65f03c0 	ret

00000000c0002998 <spinlock_cpu_slot>:

static unsigned int spinlock_cpu_slot(void)
{
    c0002998:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c000299c:	910003fd 	mov	x29, sp
	const struct cpu_topology_descriptor *cpu;

	cpu = topology_find_cpu_by_mpidr(spinlock_read_mpidr());
    c00029a0:	97fffff8 	bl	c0002980 <spinlock_read_mpidr>
    c00029a4:	94000a1d 	bl	c0005218 <topology_find_cpu_by_mpidr>
    c00029a8:	f9000fe0 	str	x0, [sp, #24]
	if (cpu != (const struct cpu_topology_descriptor *)0) {
    c00029ac:	f9400fe0 	ldr	x0, [sp, #24]
    c00029b0:	f100001f 	cmp	x0, #0x0
    c00029b4:	54000080 	b.eq	c00029c4 <spinlock_cpu_slot+0x2c>  // b.none
		return cpu->logical_id;
    c00029b8:	f9400fe0 	ldr	x0, [sp, #24]
    c00029bc:	b9400800 	ldr	w0, [x0, #8]
    c00029c0:	14000002 	b	c00029c8 <spinlock_cpu_slot+0x30>
	}

	return 0U;
    c00029c4:	52800000 	mov	w0, #0x0                   	// #0
}
    c00029c8:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c00029cc:	d65f03c0 	ret

00000000c00029d0 <spinlock_init>:

void spinlock_init(struct spinlock *lock)
{
    c00029d0:	d10083ff 	sub	sp, sp, #0x20
    c00029d4:	f90007e0 	str	x0, [sp, #8]
	unsigned int i;

	if (lock == (struct spinlock *)0) {
    c00029d8:	f94007e0 	ldr	x0, [sp, #8]
    c00029dc:	f100001f 	cmp	x0, #0x0
    c00029e0:	54000240 	b.eq	c0002a28 <spinlock_init+0x58>  // b.none
		return;
	}

	for (i = 0U; i < PLAT_MAX_CPUS; ++i) {
    c00029e4:	b9001fff 	str	wzr, [sp, #28]
    c00029e8:	1400000c 	b	c0002a18 <spinlock_init+0x48>
		lock->choosing[i] = 0U;
    c00029ec:	f94007e1 	ldr	x1, [sp, #8]
    c00029f0:	b9401fe0 	ldr	w0, [sp, #28]
    c00029f4:	3820683f 	strb	wzr, [x1, x0]
		lock->tickets[i] = 0U;
    c00029f8:	f94007e1 	ldr	x1, [sp, #8]
    c00029fc:	b9401fe0 	ldr	w0, [sp, #28]
    c0002a00:	d37ef400 	lsl	x0, x0, #2
    c0002a04:	8b000020 	add	x0, x1, x0
    c0002a08:	b900081f 	str	wzr, [x0, #8]
	for (i = 0U; i < PLAT_MAX_CPUS; ++i) {
    c0002a0c:	b9401fe0 	ldr	w0, [sp, #28]
    c0002a10:	11000400 	add	w0, w0, #0x1
    c0002a14:	b9001fe0 	str	w0, [sp, #28]
    c0002a18:	b9401fe0 	ldr	w0, [sp, #28]
    c0002a1c:	71001c1f 	cmp	w0, #0x7
    c0002a20:	54fffe69 	b.ls	c00029ec <spinlock_init+0x1c>  // b.plast
    c0002a24:	14000002 	b	c0002a2c <spinlock_init+0x5c>
		return;
    c0002a28:	d503201f 	nop
	}
}
    c0002a2c:	910083ff 	add	sp, sp, #0x20
    c0002a30:	d65f03c0 	ret

00000000c0002a34 <spinlock_try_lock>:

int spinlock_try_lock(struct spinlock *lock)
{
    c0002a34:	a9bc7bfd 	stp	x29, x30, [sp, #-64]!
    c0002a38:	910003fd 	mov	x29, sp
    c0002a3c:	f9000fe0 	str	x0, [sp, #24]
	unsigned int slot;
	unsigned int i;
	uint32_t max_ticket = 0U;
    c0002a40:	b9003bff 	str	wzr, [sp, #56]
	uint32_t my_ticket;

	if (lock == (struct spinlock *)0) {
    c0002a44:	f9400fe0 	ldr	x0, [sp, #24]
    c0002a48:	f100001f 	cmp	x0, #0x0
    c0002a4c:	54000061 	b.ne	c0002a58 <spinlock_try_lock+0x24>  // b.any
		return 0;
    c0002a50:	52800000 	mov	w0, #0x0                   	// #0
    c0002a54:	14000068 	b	c0002bf4 <spinlock_try_lock+0x1c0>
	}

	slot = spinlock_cpu_slot();
    c0002a58:	97ffffd0 	bl	c0002998 <spinlock_cpu_slot>
    c0002a5c:	b90033e0 	str	w0, [sp, #48]
	if (lock->tickets[slot] != 0U) {
    c0002a60:	f9400fe1 	ldr	x1, [sp, #24]
    c0002a64:	b94033e0 	ldr	w0, [sp, #48]
    c0002a68:	d37ef400 	lsl	x0, x0, #2
    c0002a6c:	8b000020 	add	x0, x1, x0
    c0002a70:	b9400800 	ldr	w0, [x0, #8]
    c0002a74:	7100001f 	cmp	w0, #0x0
    c0002a78:	54000060 	b.eq	c0002a84 <spinlock_try_lock+0x50>  // b.none
		return 1;
    c0002a7c:	52800020 	mov	w0, #0x1                   	// #1
    c0002a80:	1400005d 	b	c0002bf4 <spinlock_try_lock+0x1c0>
	}

	lock->choosing[slot] = 1U;
    c0002a84:	f9400fe1 	ldr	x1, [sp, #24]
    c0002a88:	b94033e0 	ldr	w0, [sp, #48]
    c0002a8c:	52800022 	mov	w2, #0x1                   	// #1
    c0002a90:	38206822 	strb	w2, [x1, x0]
	for (i = 0U; i < PLAT_MAX_CPUS; ++i) {
    c0002a94:	b9003fff 	str	wzr, [sp, #60]
    c0002a98:	14000012 	b	c0002ae0 <spinlock_try_lock+0xac>
		if (lock->tickets[i] > max_ticket) {
    c0002a9c:	f9400fe1 	ldr	x1, [sp, #24]
    c0002aa0:	b9403fe0 	ldr	w0, [sp, #60]
    c0002aa4:	d37ef400 	lsl	x0, x0, #2
    c0002aa8:	8b000020 	add	x0, x1, x0
    c0002aac:	b9400800 	ldr	w0, [x0, #8]
    c0002ab0:	b9403be1 	ldr	w1, [sp, #56]
    c0002ab4:	6b00003f 	cmp	w1, w0
    c0002ab8:	540000e2 	b.cs	c0002ad4 <spinlock_try_lock+0xa0>  // b.hs, b.nlast
			max_ticket = lock->tickets[i];
    c0002abc:	f9400fe1 	ldr	x1, [sp, #24]
    c0002ac0:	b9403fe0 	ldr	w0, [sp, #60]
    c0002ac4:	d37ef400 	lsl	x0, x0, #2
    c0002ac8:	8b000020 	add	x0, x1, x0
    c0002acc:	b9400800 	ldr	w0, [x0, #8]
    c0002ad0:	b9003be0 	str	w0, [sp, #56]
	for (i = 0U; i < PLAT_MAX_CPUS; ++i) {
    c0002ad4:	b9403fe0 	ldr	w0, [sp, #60]
    c0002ad8:	11000400 	add	w0, w0, #0x1
    c0002adc:	b9003fe0 	str	w0, [sp, #60]
    c0002ae0:	b9403fe0 	ldr	w0, [sp, #60]
    c0002ae4:	71001c1f 	cmp	w0, #0x7
    c0002ae8:	54fffda9 	b.ls	c0002a9c <spinlock_try_lock+0x68>  // b.plast
		}
	}

	my_ticket = max_ticket + 1U;
    c0002aec:	b9403be0 	ldr	w0, [sp, #56]
    c0002af0:	11000400 	add	w0, w0, #0x1
    c0002af4:	b90037e0 	str	w0, [sp, #52]
	if (my_ticket == 0U) {
    c0002af8:	b94037e0 	ldr	w0, [sp, #52]
    c0002afc:	7100001f 	cmp	w0, #0x0
    c0002b00:	54000061 	b.ne	c0002b0c <spinlock_try_lock+0xd8>  // b.any
		my_ticket = 1U;
    c0002b04:	52800020 	mov	w0, #0x1                   	// #1
    c0002b08:	b90037e0 	str	w0, [sp, #52]
	}

	lock->tickets[slot] = my_ticket;
    c0002b0c:	f9400fe1 	ldr	x1, [sp, #24]
    c0002b10:	b94033e0 	ldr	w0, [sp, #48]
    c0002b14:	d37ef400 	lsl	x0, x0, #2
    c0002b18:	8b000020 	add	x0, x1, x0
    c0002b1c:	b94037e1 	ldr	w1, [sp, #52]
    c0002b20:	b9000801 	str	w1, [x0, #8]
	lock->choosing[slot] = 0U;
    c0002b24:	f9400fe1 	ldr	x1, [sp, #24]
    c0002b28:	b94033e0 	ldr	w0, [sp, #48]
    c0002b2c:	3820683f 	strb	wzr, [x1, x0]

	for (i = 0U; i < PLAT_MAX_CPUS; ++i) {
    c0002b30:	b9003fff 	str	wzr, [sp, #60]
    c0002b34:	1400002c 	b	c0002be4 <spinlock_try_lock+0x1b0>
		uint32_t other_ticket;

		if (i == slot) {
    c0002b38:	b9403fe1 	ldr	w1, [sp, #60]
    c0002b3c:	b94033e0 	ldr	w0, [sp, #48]
    c0002b40:	6b00003f 	cmp	w1, w0
    c0002b44:	540003c0 	b.eq	c0002bbc <spinlock_try_lock+0x188>  // b.none
			continue;
		}

		while (lock->choosing[i] != 0U) {
    c0002b48:	d503201f 	nop
    c0002b4c:	f9400fe1 	ldr	x1, [sp, #24]
    c0002b50:	b9403fe0 	ldr	w0, [sp, #60]
    c0002b54:	38606820 	ldrb	w0, [x1, x0]
    c0002b58:	12001c00 	and	w0, w0, #0xff
    c0002b5c:	7100001f 	cmp	w0, #0x0
    c0002b60:	54ffff61 	b.ne	c0002b4c <spinlock_try_lock+0x118>  // b.any
		}

		for (;;) {
			other_ticket = lock->tickets[i];
    c0002b64:	f9400fe1 	ldr	x1, [sp, #24]
    c0002b68:	b9403fe0 	ldr	w0, [sp, #60]
    c0002b6c:	d37ef400 	lsl	x0, x0, #2
    c0002b70:	8b000020 	add	x0, x1, x0
    c0002b74:	b9400800 	ldr	w0, [x0, #8]
    c0002b78:	b9002fe0 	str	w0, [sp, #44]
			if (other_ticket == 0U) {
    c0002b7c:	b9402fe0 	ldr	w0, [sp, #44]
    c0002b80:	7100001f 	cmp	w0, #0x0
    c0002b84:	54000200 	b.eq	c0002bc4 <spinlock_try_lock+0x190>  // b.none
				break;
			}

			if (other_ticket > my_ticket) {
    c0002b88:	b9402fe1 	ldr	w1, [sp, #44]
    c0002b8c:	b94037e0 	ldr	w0, [sp, #52]
    c0002b90:	6b00003f 	cmp	w1, w0
    c0002b94:	540001c8 	b.hi	c0002bcc <spinlock_try_lock+0x198>  // b.pmore
				break;
			}

			if ((other_ticket == my_ticket) && (i > slot)) {
    c0002b98:	b9402fe1 	ldr	w1, [sp, #44]
    c0002b9c:	b94037e0 	ldr	w0, [sp, #52]
    c0002ba0:	6b00003f 	cmp	w1, w0
    c0002ba4:	54fffe01 	b.ne	c0002b64 <spinlock_try_lock+0x130>  // b.any
    c0002ba8:	b9403fe1 	ldr	w1, [sp, #60]
    c0002bac:	b94033e0 	ldr	w0, [sp, #48]
    c0002bb0:	6b00003f 	cmp	w1, w0
    c0002bb4:	54000108 	b.hi	c0002bd4 <spinlock_try_lock+0x1a0>  // b.pmore
			other_ticket = lock->tickets[i];
    c0002bb8:	17ffffeb 	b	c0002b64 <spinlock_try_lock+0x130>
			continue;
    c0002bbc:	d503201f 	nop
    c0002bc0:	14000006 	b	c0002bd8 <spinlock_try_lock+0x1a4>
				break;
    c0002bc4:	d503201f 	nop
    c0002bc8:	14000004 	b	c0002bd8 <spinlock_try_lock+0x1a4>
				break;
    c0002bcc:	d503201f 	nop
    c0002bd0:	14000002 	b	c0002bd8 <spinlock_try_lock+0x1a4>
				break;
    c0002bd4:	d503201f 	nop
	for (i = 0U; i < PLAT_MAX_CPUS; ++i) {
    c0002bd8:	b9403fe0 	ldr	w0, [sp, #60]
    c0002bdc:	11000400 	add	w0, w0, #0x1
    c0002be0:	b9003fe0 	str	w0, [sp, #60]
    c0002be4:	b9403fe0 	ldr	w0, [sp, #60]
    c0002be8:	71001c1f 	cmp	w0, #0x7
    c0002bec:	54fffa69 	b.ls	c0002b38 <spinlock_try_lock+0x104>  // b.plast
			}
		}
	}

	return 1;
    c0002bf0:	52800020 	mov	w0, #0x1                   	// #1
}
    c0002bf4:	a8c47bfd 	ldp	x29, x30, [sp], #64
    c0002bf8:	d65f03c0 	ret

00000000c0002bfc <spinlock_lock>:

void spinlock_lock(struct spinlock *lock)
{
    c0002bfc:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c0002c00:	910003fd 	mov	x29, sp
    c0002c04:	f9000fe0 	str	x0, [sp, #24]
	(void)spinlock_try_lock(lock);
    c0002c08:	f9400fe0 	ldr	x0, [sp, #24]
    c0002c0c:	97ffff8a 	bl	c0002a34 <spinlock_try_lock>
}
    c0002c10:	d503201f 	nop
    c0002c14:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c0002c18:	d65f03c0 	ret

00000000c0002c1c <spinlock_unlock>:

void spinlock_unlock(struct spinlock *lock)
{
    c0002c1c:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
    c0002c20:	910003fd 	mov	x29, sp
    c0002c24:	f9000fe0 	str	x0, [sp, #24]
	unsigned int slot;

	if (lock == (struct spinlock *)0) {
    c0002c28:	f9400fe0 	ldr	x0, [sp, #24]
    c0002c2c:	f100001f 	cmp	x0, #0x0
    c0002c30:	54000120 	b.eq	c0002c54 <spinlock_unlock+0x38>  // b.none
		return;
	}

	slot = spinlock_cpu_slot();
    c0002c34:	97ffff59 	bl	c0002998 <spinlock_cpu_slot>
    c0002c38:	b9002fe0 	str	w0, [sp, #44]
	lock->tickets[slot] = 0U;
    c0002c3c:	f9400fe1 	ldr	x1, [sp, #24]
    c0002c40:	b9402fe0 	ldr	w0, [sp, #44]
    c0002c44:	d37ef400 	lsl	x0, x0, #2
    c0002c48:	8b000020 	add	x0, x1, x0
    c0002c4c:	b900081f 	str	wzr, [x0, #8]
    c0002c50:	14000002 	b	c0002c58 <spinlock_unlock+0x3c>
		return;
    c0002c54:	d503201f 	nop
    c0002c58:	a8c37bfd 	ldp	x29, x30, [sp], #48
    c0002c5c:	d65f03c0 	ret

00000000c0002c60 <scheduler_init>:
static unsigned long runnable_cpus[((PLAT_MAX_CPUS + (sizeof(unsigned long) * 8U) - 1U) /
	(sizeof(unsigned long) * 8U))];
static unsigned int runnable_cpu_count;

void scheduler_init(void)
{
    c0002c60:	d10043ff 	sub	sp, sp, #0x10
	unsigned int i;

	for (i = 0U; i < (unsigned int)(sizeof(runnable_cpus) / sizeof(runnable_cpus[0])); ++i) {
    c0002c64:	b9000fff 	str	wzr, [sp, #12]
    c0002c68:	14000008 	b	c0002c88 <scheduler_init+0x28>
		runnable_cpus[i] = 0UL;
    c0002c6c:	90000020 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0002c70:	912b6000 	add	x0, x0, #0xad8
    c0002c74:	b9400fe1 	ldr	w1, [sp, #12]
    c0002c78:	f821781f 	str	xzr, [x0, x1, lsl #3]
	for (i = 0U; i < (unsigned int)(sizeof(runnable_cpus) / sizeof(runnable_cpus[0])); ++i) {
    c0002c7c:	b9400fe0 	ldr	w0, [sp, #12]
    c0002c80:	11000400 	add	w0, w0, #0x1
    c0002c84:	b9000fe0 	str	w0, [sp, #12]
    c0002c88:	b9400fe0 	ldr	w0, [sp, #12]
    c0002c8c:	7100001f 	cmp	w0, #0x0
    c0002c90:	54fffee0 	b.eq	c0002c6c <scheduler_init+0xc>  // b.none
	}
	runnable_cpu_count = 0U;
    c0002c94:	90000020 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0002c98:	912b8000 	add	x0, x0, #0xae0
    c0002c9c:	b900001f 	str	wzr, [x0]
}
    c0002ca0:	d503201f 	nop
    c0002ca4:	910043ff 	add	sp, sp, #0x10
    c0002ca8:	d65f03c0 	ret

00000000c0002cac <scheduler_join_cpu>:

void scheduler_join_cpu(unsigned int logical_id)
{
    c0002cac:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c0002cb0:	910003fd 	mov	x29, sp
    c0002cb4:	b9001fe0 	str	w0, [sp, #28]
	if (!bitmap_test_bit(runnable_cpus, logical_id)) {
    c0002cb8:	b9401fe0 	ldr	w0, [sp, #28]
    c0002cbc:	aa0003e1 	mov	x1, x0
    c0002cc0:	90000020 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0002cc4:	912b6000 	add	x0, x0, #0xad8
    c0002cc8:	97fffe7a 	bl	c00026b0 <bitmap_test_bit>
    c0002ccc:	12001c00 	and	w0, w0, #0xff
    c0002cd0:	52000000 	eor	w0, w0, #0x1
    c0002cd4:	12001c00 	and	w0, w0, #0xff
    c0002cd8:	12000000 	and	w0, w0, #0x1
    c0002cdc:	7100001f 	cmp	w0, #0x0
    c0002ce0:	540001a0 	b.eq	c0002d14 <scheduler_join_cpu+0x68>  // b.none
		bitmap_set_bit(runnable_cpus, logical_id);
    c0002ce4:	b9401fe0 	ldr	w0, [sp, #28]
    c0002ce8:	aa0003e1 	mov	x1, x0
    c0002cec:	90000020 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0002cf0:	912b6000 	add	x0, x0, #0xad8
    c0002cf4:	97fffe44 	bl	c0002604 <bitmap_set_bit>
		runnable_cpu_count++;
    c0002cf8:	90000020 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0002cfc:	912b8000 	add	x0, x0, #0xae0
    c0002d00:	b9400000 	ldr	w0, [x0]
    c0002d04:	11000401 	add	w1, w0, #0x1
    c0002d08:	90000020 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0002d0c:	912b8000 	add	x0, x0, #0xae0
    c0002d10:	b9000001 	str	w1, [x0]
	}
}
    c0002d14:	d503201f 	nop
    c0002d18:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c0002d1c:	d65f03c0 	ret

00000000c0002d20 <scheduler_cpu_is_runnable>:

bool scheduler_cpu_is_runnable(unsigned int logical_id)
{
    c0002d20:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c0002d24:	910003fd 	mov	x29, sp
    c0002d28:	b9001fe0 	str	w0, [sp, #28]
	return bitmap_test_bit(runnable_cpus, logical_id);
    c0002d2c:	b9401fe0 	ldr	w0, [sp, #28]
    c0002d30:	aa0003e1 	mov	x1, x0
    c0002d34:	90000020 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0002d38:	912b6000 	add	x0, x0, #0xad8
    c0002d3c:	97fffe5d 	bl	c00026b0 <bitmap_test_bit>
    c0002d40:	12001c00 	and	w0, w0, #0xff
}
    c0002d44:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c0002d48:	d65f03c0 	ret

00000000c0002d4c <scheduler_runnable_cpu_count>:

unsigned int scheduler_runnable_cpu_count(void)
{
	return runnable_cpu_count;
    c0002d4c:	90000020 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0002d50:	912b8000 	add	x0, x0, #0xae0
    c0002d54:	b9400000 	ldr	w0, [x0]
    c0002d58:	d65f03c0 	ret

00000000c0002d5c <is_space>:
#define MINI_OS_BUILD_YEAR 2026

extern volatile uint64_t boot_magic;

static bool is_space(char ch)
{
    c0002d5c:	d10043ff 	sub	sp, sp, #0x10
    c0002d60:	39003fe0 	strb	w0, [sp, #15]
	return (ch == ' ') || (ch == '\t') || (ch == '\r') || (ch == '\n');
    c0002d64:	39403fe0 	ldrb	w0, [sp, #15]
    c0002d68:	7100801f 	cmp	w0, #0x20
    c0002d6c:	54000140 	b.eq	c0002d94 <is_space+0x38>  // b.none
    c0002d70:	39403fe0 	ldrb	w0, [sp, #15]
    c0002d74:	7100241f 	cmp	w0, #0x9
    c0002d78:	540000e0 	b.eq	c0002d94 <is_space+0x38>  // b.none
    c0002d7c:	39403fe0 	ldrb	w0, [sp, #15]
    c0002d80:	7100341f 	cmp	w0, #0xd
    c0002d84:	54000080 	b.eq	c0002d94 <is_space+0x38>  // b.none
    c0002d88:	39403fe0 	ldrb	w0, [sp, #15]
    c0002d8c:	7100281f 	cmp	w0, #0xa
    c0002d90:	54000061 	b.ne	c0002d9c <is_space+0x40>  // b.any
    c0002d94:	52800020 	mov	w0, #0x1                   	// #1
    c0002d98:	14000002 	b	c0002da0 <is_space+0x44>
    c0002d9c:	52800000 	mov	w0, #0x0                   	// #0
    c0002da0:	12000000 	and	w0, w0, #0x1
    c0002da4:	12001c00 	and	w0, w0, #0xff
}
    c0002da8:	910043ff 	add	sp, sp, #0x10
    c0002dac:	d65f03c0 	ret

00000000c0002db0 <strings_equal>:

static bool strings_equal(const char *lhs, const char *rhs)
{
    c0002db0:	d10043ff 	sub	sp, sp, #0x10
    c0002db4:	f90007e0 	str	x0, [sp, #8]
    c0002db8:	f90003e1 	str	x1, [sp]
	while ((*lhs != '\0') && (*rhs != '\0')) {
    c0002dbc:	1400000f 	b	c0002df8 <strings_equal+0x48>
		if (*lhs != *rhs) {
    c0002dc0:	f94007e0 	ldr	x0, [sp, #8]
    c0002dc4:	39400001 	ldrb	w1, [x0]
    c0002dc8:	f94003e0 	ldr	x0, [sp]
    c0002dcc:	39400000 	ldrb	w0, [x0]
    c0002dd0:	6b00003f 	cmp	w1, w0
    c0002dd4:	54000060 	b.eq	c0002de0 <strings_equal+0x30>  // b.none
			return false;
    c0002dd8:	52800000 	mov	w0, #0x0                   	// #0
    c0002ddc:	1400001c 	b	c0002e4c <strings_equal+0x9c>
		}
		lhs++;
    c0002de0:	f94007e0 	ldr	x0, [sp, #8]
    c0002de4:	91000400 	add	x0, x0, #0x1
    c0002de8:	f90007e0 	str	x0, [sp, #8]
		rhs++;
    c0002dec:	f94003e0 	ldr	x0, [sp]
    c0002df0:	91000400 	add	x0, x0, #0x1
    c0002df4:	f90003e0 	str	x0, [sp]
	while ((*lhs != '\0') && (*rhs != '\0')) {
    c0002df8:	f94007e0 	ldr	x0, [sp, #8]
    c0002dfc:	39400000 	ldrb	w0, [x0]
    c0002e00:	7100001f 	cmp	w0, #0x0
    c0002e04:	540000a0 	b.eq	c0002e18 <strings_equal+0x68>  // b.none
    c0002e08:	f94003e0 	ldr	x0, [sp]
    c0002e0c:	39400000 	ldrb	w0, [x0]
    c0002e10:	7100001f 	cmp	w0, #0x0
    c0002e14:	54fffd61 	b.ne	c0002dc0 <strings_equal+0x10>  // b.any
	}

	return (*lhs == '\0') && (*rhs == '\0');
    c0002e18:	f94007e0 	ldr	x0, [sp, #8]
    c0002e1c:	39400000 	ldrb	w0, [x0]
    c0002e20:	7100001f 	cmp	w0, #0x0
    c0002e24:	540000e1 	b.ne	c0002e40 <strings_equal+0x90>  // b.any
    c0002e28:	f94003e0 	ldr	x0, [sp]
    c0002e2c:	39400000 	ldrb	w0, [x0]
    c0002e30:	7100001f 	cmp	w0, #0x0
    c0002e34:	54000061 	b.ne	c0002e40 <strings_equal+0x90>  // b.any
    c0002e38:	52800020 	mov	w0, #0x1                   	// #1
    c0002e3c:	14000002 	b	c0002e44 <strings_equal+0x94>
    c0002e40:	52800000 	mov	w0, #0x0                   	// #0
    c0002e44:	12000000 	and	w0, w0, #0x1
    c0002e48:	12001c00 	and	w0, w0, #0xff
}
    c0002e4c:	910043ff 	add	sp, sp, #0x10
    c0002e50:	d65f03c0 	ret

00000000c0002e54 <shell_help_topic_name>:

static const char *shell_help_topic_name(const char *arg)
{
    c0002e54:	d10043ff 	sub	sp, sp, #0x10
    c0002e58:	f90007e0 	str	x0, [sp, #8]
	if ((arg == (const char *)0) || (*arg == '\0')) {
    c0002e5c:	f94007e0 	ldr	x0, [sp, #8]
    c0002e60:	f100001f 	cmp	x0, #0x0
    c0002e64:	540000a0 	b.eq	c0002e78 <shell_help_topic_name+0x24>  // b.none
    c0002e68:	f94007e0 	ldr	x0, [sp, #8]
    c0002e6c:	39400000 	ldrb	w0, [x0]
    c0002e70:	7100001f 	cmp	w0, #0x0
    c0002e74:	54000061 	b.ne	c0002e80 <shell_help_topic_name+0x2c>  // b.any
		return (const char *)0;
    c0002e78:	d2800000 	mov	x0, #0x0                   	// #0
    c0002e7c:	1400000e 	b	c0002eb4 <shell_help_topic_name+0x60>
	}

	if ((arg[0] == '-') && (arg[1] == '-')) {
    c0002e80:	f94007e0 	ldr	x0, [sp, #8]
    c0002e84:	39400000 	ldrb	w0, [x0]
    c0002e88:	7100b41f 	cmp	w0, #0x2d
    c0002e8c:	54000121 	b.ne	c0002eb0 <shell_help_topic_name+0x5c>  // b.any
    c0002e90:	f94007e0 	ldr	x0, [sp, #8]
    c0002e94:	91000400 	add	x0, x0, #0x1
    c0002e98:	39400000 	ldrb	w0, [x0]
    c0002e9c:	7100b41f 	cmp	w0, #0x2d
    c0002ea0:	54000081 	b.ne	c0002eb0 <shell_help_topic_name+0x5c>  // b.any
		return arg + 2;
    c0002ea4:	f94007e0 	ldr	x0, [sp, #8]
    c0002ea8:	91000800 	add	x0, x0, #0x2
    c0002eac:	14000002 	b	c0002eb4 <shell_help_topic_name+0x60>
	}

	return arg;
    c0002eb0:	f94007e0 	ldr	x0, [sp, #8]
}
    c0002eb4:	910043ff 	add	sp, sp, #0x10
    c0002eb8:	d65f03c0 	ret

00000000c0002ebc <parse_u64>:

static bool parse_u64(const char *str, uint64_t *value)
{
    c0002ebc:	d100c3ff 	sub	sp, sp, #0x30
    c0002ec0:	f90007e0 	str	x0, [sp, #8]
    c0002ec4:	f90003e1 	str	x1, [sp]
	uint64_t result = 0U;
    c0002ec8:	f90017ff 	str	xzr, [sp, #40]
	unsigned int base = 10U;
    c0002ecc:	52800140 	mov	w0, #0xa                   	// #10
    c0002ed0:	b90027e0 	str	w0, [sp, #36]
	char ch;

	if ((str == (const char *)0) || (*str == '\0')) {
    c0002ed4:	f94007e0 	ldr	x0, [sp, #8]
    c0002ed8:	f100001f 	cmp	x0, #0x0
    c0002edc:	540000a0 	b.eq	c0002ef0 <parse_u64+0x34>  // b.none
    c0002ee0:	f94007e0 	ldr	x0, [sp, #8]
    c0002ee4:	39400000 	ldrb	w0, [x0]
    c0002ee8:	7100001f 	cmp	w0, #0x0
    c0002eec:	54000061 	b.ne	c0002ef8 <parse_u64+0x3c>  // b.any
		return false;
    c0002ef0:	52800000 	mov	w0, #0x0                   	// #0
    c0002ef4:	14000058 	b	c0003054 <parse_u64+0x198>
	}

	if ((str[0] == '0') && ((str[1] == 'x') || (str[1] == 'X'))) {
    c0002ef8:	f94007e0 	ldr	x0, [sp, #8]
    c0002efc:	39400000 	ldrb	w0, [x0]
    c0002f00:	7100c01f 	cmp	w0, #0x30
    c0002f04:	54000201 	b.ne	c0002f44 <parse_u64+0x88>  // b.any
    c0002f08:	f94007e0 	ldr	x0, [sp, #8]
    c0002f0c:	91000400 	add	x0, x0, #0x1
    c0002f10:	39400000 	ldrb	w0, [x0]
    c0002f14:	7101e01f 	cmp	w0, #0x78
    c0002f18:	540000c0 	b.eq	c0002f30 <parse_u64+0x74>  // b.none
    c0002f1c:	f94007e0 	ldr	x0, [sp, #8]
    c0002f20:	91000400 	add	x0, x0, #0x1
    c0002f24:	39400000 	ldrb	w0, [x0]
    c0002f28:	7101601f 	cmp	w0, #0x58
    c0002f2c:	540000c1 	b.ne	c0002f44 <parse_u64+0x88>  // b.any
		base = 16U;
    c0002f30:	52800200 	mov	w0, #0x10                  	// #16
    c0002f34:	b90027e0 	str	w0, [sp, #36]
		str += 2;
    c0002f38:	f94007e0 	ldr	x0, [sp, #8]
    c0002f3c:	91000800 	add	x0, x0, #0x2
    c0002f40:	f90007e0 	str	x0, [sp, #8]
	}
	if (*str == '\0') {
    c0002f44:	f94007e0 	ldr	x0, [sp, #8]
    c0002f48:	39400000 	ldrb	w0, [x0]
    c0002f4c:	7100001f 	cmp	w0, #0x0
    c0002f50:	540006a1 	b.ne	c0003024 <parse_u64+0x168>  // b.any
		return false;
    c0002f54:	52800000 	mov	w0, #0x0                   	// #0
    c0002f58:	1400003f 	b	c0003054 <parse_u64+0x198>
	}

	while ((ch = *str++) != '\0') {
		unsigned int digit;

		if ((ch >= '0') && (ch <= '9')) {
    c0002f5c:	39407fe0 	ldrb	w0, [sp, #31]
    c0002f60:	7100bc1f 	cmp	w0, #0x2f
    c0002f64:	54000109 	b.ls	c0002f84 <parse_u64+0xc8>  // b.plast
    c0002f68:	39407fe0 	ldrb	w0, [sp, #31]
    c0002f6c:	7100e41f 	cmp	w0, #0x39
    c0002f70:	540000a8 	b.hi	c0002f84 <parse_u64+0xc8>  // b.pmore
			digit = (unsigned int)(ch - '0');
    c0002f74:	39407fe0 	ldrb	w0, [sp, #31]
    c0002f78:	5100c000 	sub	w0, w0, #0x30
    c0002f7c:	b90023e0 	str	w0, [sp, #32]
    c0002f80:	1400001d 	b	c0002ff4 <parse_u64+0x138>
		} else if ((base == 16U) && (ch >= 'a') && (ch <= 'f')) {
    c0002f84:	b94027e0 	ldr	w0, [sp, #36]
    c0002f88:	7100401f 	cmp	w0, #0x10
    c0002f8c:	54000161 	b.ne	c0002fb8 <parse_u64+0xfc>  // b.any
    c0002f90:	39407fe0 	ldrb	w0, [sp, #31]
    c0002f94:	7101801f 	cmp	w0, #0x60
    c0002f98:	54000109 	b.ls	c0002fb8 <parse_u64+0xfc>  // b.plast
    c0002f9c:	39407fe0 	ldrb	w0, [sp, #31]
    c0002fa0:	7101981f 	cmp	w0, #0x66
    c0002fa4:	540000a8 	b.hi	c0002fb8 <parse_u64+0xfc>  // b.pmore
			digit = (unsigned int)(ch - 'a') + 10U;
    c0002fa8:	39407fe0 	ldrb	w0, [sp, #31]
    c0002fac:	51015c00 	sub	w0, w0, #0x57
    c0002fb0:	b90023e0 	str	w0, [sp, #32]
    c0002fb4:	14000010 	b	c0002ff4 <parse_u64+0x138>
		} else if ((base == 16U) && (ch >= 'A') && (ch <= 'F')) {
    c0002fb8:	b94027e0 	ldr	w0, [sp, #36]
    c0002fbc:	7100401f 	cmp	w0, #0x10
    c0002fc0:	54000161 	b.ne	c0002fec <parse_u64+0x130>  // b.any
    c0002fc4:	39407fe0 	ldrb	w0, [sp, #31]
    c0002fc8:	7101001f 	cmp	w0, #0x40
    c0002fcc:	54000109 	b.ls	c0002fec <parse_u64+0x130>  // b.plast
    c0002fd0:	39407fe0 	ldrb	w0, [sp, #31]
    c0002fd4:	7101181f 	cmp	w0, #0x46
    c0002fd8:	540000a8 	b.hi	c0002fec <parse_u64+0x130>  // b.pmore
			digit = (unsigned int)(ch - 'A') + 10U;
    c0002fdc:	39407fe0 	ldrb	w0, [sp, #31]
    c0002fe0:	5100dc00 	sub	w0, w0, #0x37
    c0002fe4:	b90023e0 	str	w0, [sp, #32]
    c0002fe8:	14000003 	b	c0002ff4 <parse_u64+0x138>
		} else {
			return false;
    c0002fec:	52800000 	mov	w0, #0x0                   	// #0
    c0002ff0:	14000019 	b	c0003054 <parse_u64+0x198>
		}
		if (digit >= base) {
    c0002ff4:	b94023e1 	ldr	w1, [sp, #32]
    c0002ff8:	b94027e0 	ldr	w0, [sp, #36]
    c0002ffc:	6b00003f 	cmp	w1, w0
    c0003000:	54000063 	b.cc	c000300c <parse_u64+0x150>  // b.lo, b.ul, b.last
			return false;
    c0003004:	52800000 	mov	w0, #0x0                   	// #0
    c0003008:	14000013 	b	c0003054 <parse_u64+0x198>
		}
		result = result * base + digit;
    c000300c:	b94027e1 	ldr	w1, [sp, #36]
    c0003010:	f94017e0 	ldr	x0, [sp, #40]
    c0003014:	9b007c21 	mul	x1, x1, x0
    c0003018:	b94023e0 	ldr	w0, [sp, #32]
    c000301c:	8b000020 	add	x0, x1, x0
    c0003020:	f90017e0 	str	x0, [sp, #40]
	while ((ch = *str++) != '\0') {
    c0003024:	f94007e0 	ldr	x0, [sp, #8]
    c0003028:	91000401 	add	x1, x0, #0x1
    c000302c:	f90007e1 	str	x1, [sp, #8]
    c0003030:	39400000 	ldrb	w0, [x0]
    c0003034:	39007fe0 	strb	w0, [sp, #31]
    c0003038:	39407fe0 	ldrb	w0, [sp, #31]
    c000303c:	7100001f 	cmp	w0, #0x0
    c0003040:	54fff8e1 	b.ne	c0002f5c <parse_u64+0xa0>  // b.any
	}

	*value = result;
    c0003044:	f94003e0 	ldr	x0, [sp]
    c0003048:	f94017e1 	ldr	x1, [sp, #40]
    c000304c:	f9000001 	str	x1, [x0]
	return true;
    c0003050:	52800020 	mov	w0, #0x1                   	// #1
}
    c0003054:	9100c3ff 	add	sp, sp, #0x30
    c0003058:	d65f03c0 	ret

00000000c000305c <shell_tokenize>:

static int shell_tokenize(char *line, char *argv[], int max_args)
{
    c000305c:	a9bc7bfd 	stp	x29, x30, [sp, #-64]!
    c0003060:	910003fd 	mov	x29, sp
    c0003064:	f90017e0 	str	x0, [sp, #40]
    c0003068:	f90013e1 	str	x1, [sp, #32]
    c000306c:	b9001fe2 	str	w2, [sp, #28]
	int argc = 0;
    c0003070:	b9003fff 	str	wzr, [sp, #60]

	while (*line != '\0') {
    c0003074:	1400002e 	b	c000312c <shell_tokenize+0xd0>
		while (is_space(*line)) {
			*line++ = '\0';
    c0003078:	f94017e0 	ldr	x0, [sp, #40]
    c000307c:	91000401 	add	x1, x0, #0x1
    c0003080:	f90017e1 	str	x1, [sp, #40]
    c0003084:	3900001f 	strb	wzr, [x0]
		while (is_space(*line)) {
    c0003088:	f94017e0 	ldr	x0, [sp, #40]
    c000308c:	39400000 	ldrb	w0, [x0]
    c0003090:	97ffff33 	bl	c0002d5c <is_space>
    c0003094:	12001c00 	and	w0, w0, #0xff
    c0003098:	12000000 	and	w0, w0, #0x1
    c000309c:	7100001f 	cmp	w0, #0x0
    c00030a0:	54fffec1 	b.ne	c0003078 <shell_tokenize+0x1c>  // b.any
		}

		if (*line == '\0') {
    c00030a4:	f94017e0 	ldr	x0, [sp, #40]
    c00030a8:	39400000 	ldrb	w0, [x0]
    c00030ac:	7100001f 	cmp	w0, #0x0
    c00030b0:	54000480 	b.eq	c0003140 <shell_tokenize+0xe4>  // b.none
			break;
		}

		if (argc >= max_args) {
    c00030b4:	b9403fe1 	ldr	w1, [sp, #60]
    c00030b8:	b9401fe0 	ldr	w0, [sp, #28]
    c00030bc:	6b00003f 	cmp	w1, w0
    c00030c0:	5400044a 	b.ge	c0003148 <shell_tokenize+0xec>  // b.tcont
			break;
		}

		argv[argc++] = line;
    c00030c4:	b9403fe0 	ldr	w0, [sp, #60]
    c00030c8:	11000401 	add	w1, w0, #0x1
    c00030cc:	b9003fe1 	str	w1, [sp, #60]
    c00030d0:	93407c00 	sxtw	x0, w0
    c00030d4:	d37df000 	lsl	x0, x0, #3
    c00030d8:	f94013e1 	ldr	x1, [sp, #32]
    c00030dc:	8b000020 	add	x0, x1, x0
    c00030e0:	f94017e1 	ldr	x1, [sp, #40]
    c00030e4:	f9000001 	str	x1, [x0]
		while ((*line != '\0') && !is_space(*line)) {
    c00030e8:	14000004 	b	c00030f8 <shell_tokenize+0x9c>
			line++;
    c00030ec:	f94017e0 	ldr	x0, [sp, #40]
    c00030f0:	91000400 	add	x0, x0, #0x1
    c00030f4:	f90017e0 	str	x0, [sp, #40]
		while ((*line != '\0') && !is_space(*line)) {
    c00030f8:	f94017e0 	ldr	x0, [sp, #40]
    c00030fc:	39400000 	ldrb	w0, [x0]
    c0003100:	7100001f 	cmp	w0, #0x0
    c0003104:	54000140 	b.eq	c000312c <shell_tokenize+0xd0>  // b.none
    c0003108:	f94017e0 	ldr	x0, [sp, #40]
    c000310c:	39400000 	ldrb	w0, [x0]
    c0003110:	97ffff13 	bl	c0002d5c <is_space>
    c0003114:	12001c00 	and	w0, w0, #0xff
    c0003118:	52000000 	eor	w0, w0, #0x1
    c000311c:	12001c00 	and	w0, w0, #0xff
    c0003120:	12000000 	and	w0, w0, #0x1
    c0003124:	7100001f 	cmp	w0, #0x0
    c0003128:	54fffe21 	b.ne	c00030ec <shell_tokenize+0x90>  // b.any
	while (*line != '\0') {
    c000312c:	f94017e0 	ldr	x0, [sp, #40]
    c0003130:	39400000 	ldrb	w0, [x0]
    c0003134:	7100001f 	cmp	w0, #0x0
    c0003138:	54fffa81 	b.ne	c0003088 <shell_tokenize+0x2c>  // b.any
    c000313c:	14000004 	b	c000314c <shell_tokenize+0xf0>
			break;
    c0003140:	d503201f 	nop
    c0003144:	14000002 	b	c000314c <shell_tokenize+0xf0>
			break;
    c0003148:	d503201f 	nop
		}
	}

	return argc;
    c000314c:	b9403fe0 	ldr	w0, [sp, #60]
}
    c0003150:	a8c47bfd 	ldp	x29, x30, [sp], #64
    c0003154:	d65f03c0 	ret

00000000c0003158 <shell_print_cpu_entry>:

static void shell_print_cpu_entry(unsigned int logical_id)
{
    c0003158:	d10143ff 	sub	sp, sp, #0x50
    c000315c:	a9027bfd 	stp	x29, x30, [sp, #32]
    c0003160:	910083fd 	add	x29, sp, #0x20
    c0003164:	b9003fe0 	str	w0, [sp, #60]
	const struct cpu_topology_descriptor *cpu = topology_cpu(logical_id);
    c0003168:	b9403fe0 	ldr	w0, [sp, #60]
    c000316c:	9400081d 	bl	c00051e0 <topology_cpu>
    c0003170:	f90027e0 	str	x0, [sp, #72]
	const struct smp_cpu_state *state = smp_cpu_state(logical_id);
    c0003174:	b9403fe0 	ldr	w0, [sp, #60]
    c0003178:	9400071e 	bl	c0004df0 <smp_cpu_state>
    c000317c:	f90023e0 	str	x0, [sp, #64]

	if ((cpu == (const struct cpu_topology_descriptor *)0) ||
    c0003180:	f94027e0 	ldr	x0, [sp, #72]
    c0003184:	f100001f 	cmp	x0, #0x0
    c0003188:	54000940 	b.eq	c00032b0 <shell_print_cpu_entry+0x158>  // b.none
    c000318c:	f94023e0 	ldr	x0, [sp, #64]
    c0003190:	f100001f 	cmp	x0, #0x0
    c0003194:	540008e0 	b.eq	c00032b0 <shell_print_cpu_entry+0x158>  // b.none
	    (state == (const struct smp_cpu_state *)0) ||
	    !cpu->present) {
    c0003198:	f94027e0 	ldr	x0, [sp, #72]
    c000319c:	39407400 	ldrb	w0, [x0, #29]
    c00031a0:	52000000 	eor	w0, w0, #0x1
    c00031a4:	12001c00 	and	w0, w0, #0xff
	    (state == (const struct smp_cpu_state *)0) ||
    c00031a8:	12000000 	and	w0, w0, #0x1
    c00031ac:	7100001f 	cmp	w0, #0x0
    c00031b0:	54000801 	b.ne	c00032b0 <shell_print_cpu_entry+0x158>  // b.any
		return;
	}

	mini_os_printf("cpu%-2u mpidr=0x%llx chip=%u die=%u cluster=%u core=%u online=%s scheduled=%s pending=%s boot=%s\n",
		       cpu->logical_id,
    c00031b4:	f94027e0 	ldr	x0, [sp, #72]
    c00031b8:	b9400808 	ldr	w8, [x0, #8]
		       (unsigned long long)cpu->mpidr,
    c00031bc:	f94027e0 	ldr	x0, [sp, #72]
    c00031c0:	f9400009 	ldr	x9, [x0]
		       cpu->chip_id,
    c00031c4:	f94027e0 	ldr	x0, [sp, #72]
    c00031c8:	b9400c0a 	ldr	w10, [x0, #12]
		       cpu->die_id,
    c00031cc:	f94027e0 	ldr	x0, [sp, #72]
    c00031d0:	b9401004 	ldr	w4, [x0, #16]
		       cpu->cluster_id,
    c00031d4:	f94027e0 	ldr	x0, [sp, #72]
    c00031d8:	b9401405 	ldr	w5, [x0, #20]
		       cpu->core_id,
    c00031dc:	f94027e0 	ldr	x0, [sp, #72]
    c00031e0:	b9401806 	ldr	w6, [x0, #24]
		       state->online ? "yes" : "no",
    c00031e4:	f94023e0 	ldr	x0, [sp, #64]
    c00031e8:	39404000 	ldrb	w0, [x0, #16]
	mini_os_printf("cpu%-2u mpidr=0x%llx chip=%u die=%u cluster=%u core=%u online=%s scheduled=%s pending=%s boot=%s\n",
    c00031ec:	12000000 	and	w0, w0, #0x1
    c00031f0:	7100001f 	cmp	w0, #0x0
    c00031f4:	54000080 	b.eq	c0003204 <shell_print_cpu_entry+0xac>  // b.none
    c00031f8:	d0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c00031fc:	9124a003 	add	x3, x0, #0x928
    c0003200:	14000003 	b	c000320c <shell_print_cpu_entry+0xb4>
    c0003204:	d0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c0003208:	9124c003 	add	x3, x0, #0x930
		       state->scheduled ? "yes" : "no",
    c000320c:	f94023e0 	ldr	x0, [sp, #64]
    c0003210:	39404400 	ldrb	w0, [x0, #17]
	mini_os_printf("cpu%-2u mpidr=0x%llx chip=%u die=%u cluster=%u core=%u online=%s scheduled=%s pending=%s boot=%s\n",
    c0003214:	12000000 	and	w0, w0, #0x1
    c0003218:	7100001f 	cmp	w0, #0x0
    c000321c:	54000080 	b.eq	c000322c <shell_print_cpu_entry+0xd4>  // b.none
    c0003220:	d0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c0003224:	9124a000 	add	x0, x0, #0x928
    c0003228:	14000003 	b	c0003234 <shell_print_cpu_entry+0xdc>
    c000322c:	d0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c0003230:	9124c000 	add	x0, x0, #0x930
		       state->pending ? "yes" : "no",
    c0003234:	f94023e1 	ldr	x1, [sp, #64]
    c0003238:	39404821 	ldrb	w1, [x1, #18]
	mini_os_printf("cpu%-2u mpidr=0x%llx chip=%u die=%u cluster=%u core=%u online=%s scheduled=%s pending=%s boot=%s\n",
    c000323c:	12000021 	and	w1, w1, #0x1
    c0003240:	7100003f 	cmp	w1, #0x0
    c0003244:	54000080 	b.eq	c0003254 <shell_print_cpu_entry+0xfc>  // b.none
    c0003248:	d0000001 	adrp	x1, c0005000 <topology_fill_descriptor+0x2c>
    c000324c:	9124a021 	add	x1, x1, #0x928
    c0003250:	14000003 	b	c000325c <shell_print_cpu_entry+0x104>
    c0003254:	d0000001 	adrp	x1, c0005000 <topology_fill_descriptor+0x2c>
    c0003258:	9124c021 	add	x1, x1, #0x930
		       cpu->boot_cpu ? "yes" : "no");
    c000325c:	f94027e2 	ldr	x2, [sp, #72]
    c0003260:	39407042 	ldrb	w2, [x2, #28]
	mini_os_printf("cpu%-2u mpidr=0x%llx chip=%u die=%u cluster=%u core=%u online=%s scheduled=%s pending=%s boot=%s\n",
    c0003264:	12000042 	and	w2, w2, #0x1
    c0003268:	7100005f 	cmp	w2, #0x0
    c000326c:	54000080 	b.eq	c000327c <shell_print_cpu_entry+0x124>  // b.none
    c0003270:	d0000002 	adrp	x2, c0005000 <topology_fill_descriptor+0x2c>
    c0003274:	9124a042 	add	x2, x2, #0x928
    c0003278:	14000003 	b	c0003284 <shell_print_cpu_entry+0x12c>
    c000327c:	d0000002 	adrp	x2, c0005000 <topology_fill_descriptor+0x2c>
    c0003280:	9124c042 	add	x2, x2, #0x930
    c0003284:	f9000be2 	str	x2, [sp, #16]
    c0003288:	f90007e1 	str	x1, [sp, #8]
    c000328c:	f90003e0 	str	x0, [sp]
    c0003290:	aa0303e7 	mov	x7, x3
    c0003294:	2a0a03e3 	mov	w3, w10
    c0003298:	aa0903e2 	mov	x2, x9
    c000329c:	2a0803e1 	mov	w1, w8
    c00032a0:	d0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c00032a4:	9124e000 	add	x0, x0, #0x938
    c00032a8:	97fffa93 	bl	c0001cf4 <mini_os_printf>
    c00032ac:	14000002 	b	c00032b4 <shell_print_cpu_entry+0x15c>
		return;
    c00032b0:	d503201f 	nop
}
    c00032b4:	a9427bfd 	ldp	x29, x30, [sp, #32]
    c00032b8:	910143ff 	add	sp, sp, #0x50
    c00032bc:	d65f03c0 	ret

00000000c00032c0 <shell_print_help_overview>:

static void shell_print_help_overview(void)
{
    c00032c0:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    c00032c4:	910003fd 	mov	x29, sp
	mini_os_printf("Built-in commands:\n");
    c00032c8:	d0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c00032cc:	91268000 	add	x0, x0, #0x9a0
    c00032d0:	97fffa89 	bl	c0001cf4 <mini_os_printf>
	mini_os_printf("  help [--topic]    Show command help or detailed help for one topic\n");
    c00032d4:	d0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c00032d8:	9126e000 	add	x0, x0, #0x9b8
    c00032dc:	97fffa86 	bl	c0001cf4 <mini_os_printf>
	mini_os_printf("  version           Show OS version information\n");
    c00032e0:	d0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c00032e4:	91280000 	add	x0, x0, #0xa00
    c00032e8:	97fffa83 	bl	c0001cf4 <mini_os_printf>
	mini_os_printf("  info              Show current platform/runtime info\n");
    c00032ec:	d0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c00032f0:	9128e000 	add	x0, x0, #0xa38
    c00032f4:	97fffa80 	bl	c0001cf4 <mini_os_printf>
	mini_os_printf("  cpu [id]          Show CPU information\n");
    c00032f8:	d0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c00032fc:	9129c000 	add	x0, x0, #0xa70
    c0003300:	97fffa7d 	bl	c0001cf4 <mini_os_printf>
	mini_os_printf("  cpus              List known CPUs\n");
    c0003304:	d0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c0003308:	912a8000 	add	x0, x0, #0xaa0
    c000330c:	97fffa7a 	bl	c0001cf4 <mini_os_printf>
	mini_os_printf("  topo              Show topology summary\n");
    c0003310:	d0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c0003314:	912b2000 	add	x0, x0, #0xac8
    c0003318:	97fffa77 	bl	c0001cf4 <mini_os_printf>
	mini_os_printf("  smp status        Show SMP status\n");
    c000331c:	d0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c0003320:	912be000 	add	x0, x0, #0xaf8
    c0003324:	97fffa74 	bl	c0001cf4 <mini_os_printf>
	mini_os_printf("  smp start <mpidr> Ask TF-A via SMC/PSCI to start a secondary CPU\n");
    c0003328:	d0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c000332c:	912c8000 	add	x0, x0, #0xb20
    c0003330:	97fffa71 	bl	c0001cf4 <mini_os_printf>
	mini_os_printf("  echo ...          Print arguments back to the console\n");
    c0003334:	d0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c0003338:	912da000 	add	x0, x0, #0xb68
    c000333c:	97fffa6e 	bl	c0001cf4 <mini_os_printf>
	mini_os_printf("  clear             Clear the terminal screen\n");
    c0003340:	d0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c0003344:	912ea000 	add	x0, x0, #0xba8
    c0003348:	97fffa6b 	bl	c0001cf4 <mini_os_printf>
	mini_os_printf("  uname             Print the OS name\n");
    c000334c:	d0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c0003350:	912f6000 	add	x0, x0, #0xbd8
    c0003354:	97fffa68 	bl	c0001cf4 <mini_os_printf>
	mini_os_printf("  halt              Stop the CPU in a low-power wait loop\n");
    c0003358:	d0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c000335c:	91300000 	add	x0, x0, #0xc00
    c0003360:	97fffa65 	bl	c0001cf4 <mini_os_printf>
	mini_os_printf("Examples: help --cpus, help --smp, help --topo\n");
    c0003364:	d0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c0003368:	91310000 	add	x0, x0, #0xc40
    c000336c:	97fffa62 	bl	c0001cf4 <mini_os_printf>
}
    c0003370:	d503201f 	nop
    c0003374:	a8c17bfd 	ldp	x29, x30, [sp], #16
    c0003378:	d65f03c0 	ret

00000000c000337c <shell_print_help_topic>:

static void shell_print_help_topic(const char *topic)
{
    c000337c:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c0003380:	910003fd 	mov	x29, sp
    c0003384:	f9000fe0 	str	x0, [sp, #24]
	if ((topic == (const char *)0) || strings_equal(topic, "help")) {
    c0003388:	f9400fe0 	ldr	x0, [sp, #24]
    c000338c:	f100001f 	cmp	x0, #0x0
    c0003390:	54000120 	b.eq	c00033b4 <shell_print_help_topic+0x38>  // b.none
    c0003394:	d0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c0003398:	9131c001 	add	x1, x0, #0xc70
    c000339c:	f9400fe0 	ldr	x0, [sp, #24]
    c00033a0:	97fffe84 	bl	c0002db0 <strings_equal>
    c00033a4:	12001c00 	and	w0, w0, #0xff
    c00033a8:	12000000 	and	w0, w0, #0x1
    c00033ac:	7100001f 	cmp	w0, #0x0
    c00033b0:	54000280 	b.eq	c0003400 <shell_print_help_topic+0x84>  // b.none
		mini_os_printf("help [--topic]\n");
    c00033b4:	d0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c00033b8:	9131e000 	add	x0, x0, #0xc78
    c00033bc:	97fffa4e 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  Show the command list or detailed help for a single topic.\n");
    c00033c0:	d0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c00033c4:	91322000 	add	x0, x0, #0xc88
    c00033c8:	97fffa4b 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("Examples:\n");
    c00033cc:	d0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c00033d0:	91332000 	add	x0, x0, #0xcc8
    c00033d4:	97fffa48 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  help\n");
    c00033d8:	d0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c00033dc:	91336000 	add	x0, x0, #0xcd8
    c00033e0:	97fffa45 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  help --cpus\n");
    c00033e4:	d0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c00033e8:	91338000 	add	x0, x0, #0xce0
    c00033ec:	97fffa42 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  help --smp\n");
    c00033f0:	d0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c00033f4:	9133c000 	add	x0, x0, #0xcf0
    c00033f8:	97fffa3f 	bl	c0001cf4 <mini_os_printf>
		return;
    c00033fc:	140000fb 	b	c00037e8 <shell_print_help_topic+0x46c>
	}

	if (strings_equal(topic, "cpu")) {
    c0003400:	d0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c0003404:	91340001 	add	x1, x0, #0xd00
    c0003408:	f9400fe0 	ldr	x0, [sp, #24]
    c000340c:	97fffe69 	bl	c0002db0 <strings_equal>
    c0003410:	12001c00 	and	w0, w0, #0xff
    c0003414:	12000000 	and	w0, w0, #0x1
    c0003418:	7100001f 	cmp	w0, #0x0
    c000341c:	540002e0 	b.eq	c0003478 <shell_print_help_topic+0xfc>  // b.none
		mini_os_printf("cpu [id]\n");
    c0003420:	d0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c0003424:	91342000 	add	x0, x0, #0xd08
    c0003428:	97fffa33 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  Show one logical CPU entry from the topology/SMP tables.\n");
    c000342c:	d0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c0003430:	91346000 	add	x0, x0, #0xd18
    c0003434:	97fffa30 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  If no id is given, it prints the current boot CPU entry.\n");
    c0003438:	d0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c000343c:	91356000 	add	x0, x0, #0xd58
    c0003440:	97fffa2d 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("Examples:\n");
    c0003444:	d0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c0003448:	91332000 	add	x0, x0, #0xcc8
    c000344c:	97fffa2a 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  cpu\n");
    c0003450:	d0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c0003454:	91366000 	add	x0, x0, #0xd98
    c0003458:	97fffa27 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  cpu 0\n");
    c000345c:	d0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c0003460:	91368000 	add	x0, x0, #0xda0
    c0003464:	97fffa24 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  cpu 1\n");
    c0003468:	d0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c000346c:	9136c000 	add	x0, x0, #0xdb0
    c0003470:	97fffa21 	bl	c0001cf4 <mini_os_printf>
		return;
    c0003474:	140000dd 	b	c00037e8 <shell_print_help_topic+0x46c>
	}

	if (strings_equal(topic, "cpus")) {
    c0003478:	d0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c000347c:	91370001 	add	x1, x0, #0xdc0
    c0003480:	f9400fe0 	ldr	x0, [sp, #24]
    c0003484:	97fffe4b 	bl	c0002db0 <strings_equal>
    c0003488:	12001c00 	and	w0, w0, #0xff
    c000348c:	12000000 	and	w0, w0, #0x1
    c0003490:	7100001f 	cmp	w0, #0x0
    c0003494:	54000280 	b.eq	c00034e4 <shell_print_help_topic+0x168>  // b.none
		mini_os_printf("cpus\n");
    c0003498:	d0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c000349c:	91372000 	add	x0, x0, #0xdc8
    c00034a0:	97fffa15 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  List all CPUs that are currently registered in the topology table.\n");
    c00034a4:	d0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c00034a8:	91374000 	add	x0, x0, #0xdd0
    c00034ac:	97fffa12 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  The line shows mpidr/chip/die/cluster/core plus online, scheduled, pending and boot flags.\n");
    c00034b0:	d0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c00034b4:	91386000 	add	x0, x0, #0xe18
    c00034b8:	97fffa0f 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("Examples:\n");
    c00034bc:	d0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c00034c0:	91332000 	add	x0, x0, #0xcc8
    c00034c4:	97fffa0c 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  cpus\n");
    c00034c8:	d0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c00034cc:	9139e000 	add	x0, x0, #0xe78
    c00034d0:	97fffa09 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  help --cpu\n");
    c00034d4:	d0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c00034d8:	913a0000 	add	x0, x0, #0xe80
    c00034dc:	97fffa06 	bl	c0001cf4 <mini_os_printf>
		return;
    c00034e0:	140000c2 	b	c00037e8 <shell_print_help_topic+0x46c>
	}

	if (strings_equal(topic, "topo")) {
    c00034e4:	d0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c00034e8:	913a4001 	add	x1, x0, #0xe90
    c00034ec:	f9400fe0 	ldr	x0, [sp, #24]
    c00034f0:	97fffe30 	bl	c0002db0 <strings_equal>
    c00034f4:	12001c00 	and	w0, w0, #0xff
    c00034f8:	12000000 	and	w0, w0, #0x1
    c00034fc:	7100001f 	cmp	w0, #0x0
    c0003500:	54000220 	b.eq	c0003544 <shell_print_help_topic+0x1c8>  // b.none
		mini_os_printf("topo\n");
    c0003504:	d0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c0003508:	913a6000 	add	x0, x0, #0xe98
    c000350c:	97fff9fa 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  Print a compact topology summary for the boot CPU and current CPU counts.\n");
    c0003510:	d0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c0003514:	913a8000 	add	x0, x0, #0xea0
    c0003518:	97fff9f7 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  Useful for checking the boot MPIDR and the decoded chip/die/cluster/core affinity.\n");
    c000351c:	d0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c0003520:	913bc000 	add	x0, x0, #0xef0
    c0003524:	97fff9f4 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("Examples:\n");
    c0003528:	d0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c000352c:	91332000 	add	x0, x0, #0xcc8
    c0003530:	97fff9f1 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  topo\n");
    c0003534:	d0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c0003538:	913d2000 	add	x0, x0, #0xf48
    c000353c:	97fff9ee 	bl	c0001cf4 <mini_os_printf>
		return;
    c0003540:	140000aa 	b	c00037e8 <shell_print_help_topic+0x46c>
	}

	if (strings_equal(topic, "smp")) {
    c0003544:	d0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c0003548:	913d4001 	add	x1, x0, #0xf50
    c000354c:	f9400fe0 	ldr	x0, [sp, #24]
    c0003550:	97fffe18 	bl	c0002db0 <strings_equal>
    c0003554:	12001c00 	and	w0, w0, #0xff
    c0003558:	12000000 	and	w0, w0, #0x1
    c000355c:	7100001f 	cmp	w0, #0x0
    c0003560:	540003a0 	b.eq	c00035d4 <shell_print_help_topic+0x258>  // b.none
		mini_os_printf("smp status\n");
    c0003564:	d0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c0003568:	913d6000 	add	x0, x0, #0xf58
    c000356c:	97fff9e2 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  Show the same per-CPU runtime table as 'cpus'.\n");
    c0003570:	d0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c0003574:	913da000 	add	x0, x0, #0xf68
    c0003578:	97fff9df 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("smp start <mpidr>\n");
    c000357c:	d0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c0003580:	913e8000 	add	x0, x0, #0xfa0
    c0003584:	97fff9dc 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  Ask TF-A/BL31 through SMC/PSCI CPU_ON to start the target CPU identified by MPIDR.\n");
    c0003588:	d0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c000358c:	913ee000 	add	x0, x0, #0xfb8
    c0003590:	97fff9d9 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  The shell passes TF-A the target MPIDR and the mini-OS secondary entry address.\n");
    c0003594:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0003598:	91004000 	add	x0, x0, #0x10
    c000359c:	97fff9d6 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("Examples:\n");
    c00035a0:	d0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c00035a4:	91332000 	add	x0, x0, #0xcc8
    c00035a8:	97fff9d3 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  smp status\n");
    c00035ac:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c00035b0:	9101a000 	add	x0, x0, #0x68
    c00035b4:	97fff9d0 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  smp start 0x80000001\n");
    c00035b8:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c00035bc:	9101e000 	add	x0, x0, #0x78
    c00035c0:	97fff9cd 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  smp start 2147483649\n");
    c00035c4:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c00035c8:	91024000 	add	x0, x0, #0x90
    c00035cc:	97fff9ca 	bl	c0001cf4 <mini_os_printf>
		return;
    c00035d0:	14000086 	b	c00037e8 <shell_print_help_topic+0x46c>
	}

	if (strings_equal(topic, "info")) {
    c00035d4:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c00035d8:	9102a001 	add	x1, x0, #0xa8
    c00035dc:	f9400fe0 	ldr	x0, [sp, #24]
    c00035e0:	97fffdf4 	bl	c0002db0 <strings_equal>
    c00035e4:	12001c00 	and	w0, w0, #0xff
    c00035e8:	12000000 	and	w0, w0, #0x1
    c00035ec:	7100001f 	cmp	w0, #0x0
    c00035f0:	540001c0 	b.eq	c0003628 <shell_print_help_topic+0x2ac>  // b.none
		mini_os_printf("info\n");
    c00035f4:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c00035f8:	9102c000 	add	x0, x0, #0xb0
    c00035fc:	97fff9be 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  Show platform-level runtime information such as UART base, load address, boot magic and runnable CPU count.\n");
    c0003600:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0003604:	9102e000 	add	x0, x0, #0xb8
    c0003608:	97fff9bb 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("Example:\n");
    c000360c:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0003610:	9104a000 	add	x0, x0, #0x128
    c0003614:	97fff9b8 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  info\n");
    c0003618:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c000361c:	9104e000 	add	x0, x0, #0x138
    c0003620:	97fff9b5 	bl	c0001cf4 <mini_os_printf>
		return;
    c0003624:	14000071 	b	c00037e8 <shell_print_help_topic+0x46c>
	}

	if (strings_equal(topic, "version")) {
    c0003628:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c000362c:	91050001 	add	x1, x0, #0x140
    c0003630:	f9400fe0 	ldr	x0, [sp, #24]
    c0003634:	97fffddf 	bl	c0002db0 <strings_equal>
    c0003638:	12001c00 	and	w0, w0, #0xff
    c000363c:	12000000 	and	w0, w0, #0x1
    c0003640:	7100001f 	cmp	w0, #0x0
    c0003644:	540001c0 	b.eq	c000367c <shell_print_help_topic+0x300>  // b.none
		mini_os_printf("version\n");
    c0003648:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c000364c:	91052000 	add	x0, x0, #0x148
    c0003650:	97fff9a9 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  Show the Mini-OS name, version string and build year.\n");
    c0003654:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0003658:	91056000 	add	x0, x0, #0x158
    c000365c:	97fff9a6 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("Example:\n");
    c0003660:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0003664:	9104a000 	add	x0, x0, #0x128
    c0003668:	97fff9a3 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  version\n");
    c000366c:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0003670:	91066000 	add	x0, x0, #0x198
    c0003674:	97fff9a0 	bl	c0001cf4 <mini_os_printf>
		return;
    c0003678:	1400005c 	b	c00037e8 <shell_print_help_topic+0x46c>
	}

	if (strings_equal(topic, "echo")) {
    c000367c:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0003680:	9106a001 	add	x1, x0, #0x1a8
    c0003684:	f9400fe0 	ldr	x0, [sp, #24]
    c0003688:	97fffdca 	bl	c0002db0 <strings_equal>
    c000368c:	12001c00 	and	w0, w0, #0xff
    c0003690:	12000000 	and	w0, w0, #0x1
    c0003694:	7100001f 	cmp	w0, #0x0
    c0003698:	540001c0 	b.eq	c00036d0 <shell_print_help_topic+0x354>  // b.none
		mini_os_printf("echo <text...>\n");
    c000369c:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c00036a0:	9106c000 	add	x0, x0, #0x1b0
    c00036a4:	97fff994 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  Print the provided arguments back to the serial console.\n");
    c00036a8:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c00036ac:	91070000 	add	x0, x0, #0x1c0
    c00036b0:	97fff991 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("Example:\n");
    c00036b4:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c00036b8:	9104a000 	add	x0, x0, #0x128
    c00036bc:	97fff98e 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  echo hello mini-os\n");
    c00036c0:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c00036c4:	91080000 	add	x0, x0, #0x200
    c00036c8:	97fff98b 	bl	c0001cf4 <mini_os_printf>
		return;
    c00036cc:	14000047 	b	c00037e8 <shell_print_help_topic+0x46c>
	}

	if (strings_equal(topic, "clear")) {
    c00036d0:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c00036d4:	91086001 	add	x1, x0, #0x218
    c00036d8:	f9400fe0 	ldr	x0, [sp, #24]
    c00036dc:	97fffdb5 	bl	c0002db0 <strings_equal>
    c00036e0:	12001c00 	and	w0, w0, #0xff
    c00036e4:	12000000 	and	w0, w0, #0x1
    c00036e8:	7100001f 	cmp	w0, #0x0
    c00036ec:	540001c0 	b.eq	c0003724 <shell_print_help_topic+0x3a8>  // b.none
		mini_os_printf("clear\n");
    c00036f0:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c00036f4:	91088000 	add	x0, x0, #0x220
    c00036f8:	97fff97f 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  Send ANSI escape sequences to clear the serial terminal and move the cursor to the top-left corner.\n");
    c00036fc:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0003700:	9108a000 	add	x0, x0, #0x228
    c0003704:	97fff97c 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("Example:\n");
    c0003708:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c000370c:	9104a000 	add	x0, x0, #0x128
    c0003710:	97fff979 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  clear\n");
    c0003714:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0003718:	910a4000 	add	x0, x0, #0x290
    c000371c:	97fff976 	bl	c0001cf4 <mini_os_printf>
		return;
    c0003720:	14000032 	b	c00037e8 <shell_print_help_topic+0x46c>
	}

	if (strings_equal(topic, "uname")) {
    c0003724:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0003728:	910a8001 	add	x1, x0, #0x2a0
    c000372c:	f9400fe0 	ldr	x0, [sp, #24]
    c0003730:	97fffda0 	bl	c0002db0 <strings_equal>
    c0003734:	12001c00 	and	w0, w0, #0xff
    c0003738:	12000000 	and	w0, w0, #0x1
    c000373c:	7100001f 	cmp	w0, #0x0
    c0003740:	540001c0 	b.eq	c0003778 <shell_print_help_topic+0x3fc>  // b.none
		mini_os_printf("uname\n");
    c0003744:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0003748:	910aa000 	add	x0, x0, #0x2a8
    c000374c:	97fff96a 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  Print the OS name only.\n");
    c0003750:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0003754:	910ac000 	add	x0, x0, #0x2b0
    c0003758:	97fff967 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("Example:\n");
    c000375c:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0003760:	9104a000 	add	x0, x0, #0x128
    c0003764:	97fff964 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  uname\n");
    c0003768:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c000376c:	910b4000 	add	x0, x0, #0x2d0
    c0003770:	97fff961 	bl	c0001cf4 <mini_os_printf>
		return;
    c0003774:	1400001d 	b	c00037e8 <shell_print_help_topic+0x46c>
	}

	if (strings_equal(topic, "halt")) {
    c0003778:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c000377c:	910b8001 	add	x1, x0, #0x2e0
    c0003780:	f9400fe0 	ldr	x0, [sp, #24]
    c0003784:	97fffd8b 	bl	c0002db0 <strings_equal>
    c0003788:	12001c00 	and	w0, w0, #0xff
    c000378c:	12000000 	and	w0, w0, #0x1
    c0003790:	7100001f 	cmp	w0, #0x0
    c0003794:	540001c0 	b.eq	c00037cc <shell_print_help_topic+0x450>  // b.none
		mini_os_printf("halt\n");
    c0003798:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c000379c:	910ba000 	add	x0, x0, #0x2e8
    c00037a0:	97fff955 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  Stop the current CPU in a low-power wait loop.\n");
    c00037a4:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c00037a8:	910bc000 	add	x0, x0, #0x2f0
    c00037ac:	97fff952 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("Example:\n");
    c00037b0:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c00037b4:	9104a000 	add	x0, x0, #0x128
    c00037b8:	97fff94f 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("  halt\n");
    c00037bc:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c00037c0:	910ca000 	add	x0, x0, #0x328
    c00037c4:	97fff94c 	bl	c0001cf4 <mini_os_printf>
		return;
    c00037c8:	14000008 	b	c00037e8 <shell_print_help_topic+0x46c>
	}

	mini_os_printf("No detailed help for topic '%s'.\n", topic);
    c00037cc:	f9400fe1 	ldr	x1, [sp, #24]
    c00037d0:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c00037d4:	910cc000 	add	x0, x0, #0x330
    c00037d8:	97fff947 	bl	c0001cf4 <mini_os_printf>
	mini_os_printf("Try one of: cpu, cpus, topo, smp, info, version, echo, clear, uname, halt\n");
    c00037dc:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c00037e0:	910d6000 	add	x0, x0, #0x358
    c00037e4:	97fff944 	bl	c0001cf4 <mini_os_printf>
}
    c00037e8:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c00037ec:	d65f03c0 	ret

00000000c00037f0 <shell_print_help>:

void shell_print_help(void)
{
    c00037f0:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    c00037f4:	910003fd 	mov	x29, sp
	shell_print_help_overview();
    c00037f8:	97fffeb2 	bl	c00032c0 <shell_print_help_overview>
}
    c00037fc:	d503201f 	nop
    c0003800:	a8c17bfd 	ldp	x29, x30, [sp], #16
    c0003804:	d65f03c0 	ret

00000000c0003808 <shell_print_version>:

static void shell_print_version(void)
{
    c0003808:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    c000380c:	910003fd 	mov	x29, sp
	mini_os_printf("%s %s (%d)\n", MINI_OS_NAME, MINI_OS_VERSION,
    c0003810:	5280fd43 	mov	w3, #0x7ea                 	// #2026
    c0003814:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0003818:	910ea002 	add	x2, x0, #0x3a8
    c000381c:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0003820:	910ec001 	add	x1, x0, #0x3b0
    c0003824:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0003828:	910ee000 	add	x0, x0, #0x3b8
    c000382c:	97fff932 	bl	c0001cf4 <mini_os_printf>
		       MINI_OS_BUILD_YEAR);
}
    c0003830:	d503201f 	nop
    c0003834:	a8c17bfd 	ldp	x29, x30, [sp], #16
    c0003838:	d65f03c0 	ret

00000000c000383c <shell_print_info>:

static void shell_print_info(void)
{
    c000383c:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    c0003840:	910003fd 	mov	x29, sp
	mini_os_printf("Platform      : %s\n", "Neoverse-N3");
    c0003844:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0003848:	910f2001 	add	x1, x0, #0x3c8
    c000384c:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0003850:	910f6000 	add	x0, x0, #0x3d8
    c0003854:	97fff928 	bl	c0001cf4 <mini_os_printf>
	mini_os_printf("UART base     : 0x%llx\n",
    c0003858:	d2a34801 	mov	x1, #0x1a400000            	// #440401920
    c000385c:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0003860:	910fc000 	add	x0, x0, #0x3f0
    c0003864:	97fff924 	bl	c0001cf4 <mini_os_printf>
		       (unsigned long long)PLAT_UART0_BASE);
	mini_os_printf("Load address  : 0x%llx\n",
    c0003868:	d2b80001 	mov	x1, #0xc0000000            	// #3221225472
    c000386c:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0003870:	91102000 	add	x0, x0, #0x408
    c0003874:	97fff920 	bl	c0001cf4 <mini_os_printf>
		       (unsigned long long)PLAT_LOAD_ADDR);
	mini_os_printf("Boot magic    : 0x%llx\n",
    c0003878:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c000387c:	912a8000 	add	x0, x0, #0xaa0
    c0003880:	f9400000 	ldr	x0, [x0]
    c0003884:	aa0003e1 	mov	x1, x0
    c0003888:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c000388c:	91108000 	add	x0, x0, #0x420
    c0003890:	97fff919 	bl	c0001cf4 <mini_os_printf>
		       (unsigned long long)boot_magic);
	mini_os_printf("Runnable CPUs : %u\n", scheduler_runnable_cpu_count());
    c0003894:	97fffd2e 	bl	c0002d4c <scheduler_runnable_cpu_count>
    c0003898:	2a0003e1 	mov	w1, w0
    c000389c:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c00038a0:	9110e000 	add	x0, x0, #0x438
    c00038a4:	97fff914 	bl	c0001cf4 <mini_os_printf>
}
    c00038a8:	d503201f 	nop
    c00038ac:	a8c17bfd 	ldp	x29, x30, [sp], #16
    c00038b0:	d65f03c0 	ret

00000000c00038b4 <shell_print_current_cpu>:

static void shell_print_current_cpu(void)
{
    c00038b4:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    c00038b8:	910003fd 	mov	x29, sp
	shell_print_cpu_entry(0U);
    c00038bc:	52800000 	mov	w0, #0x0                   	// #0
    c00038c0:	97fffe26 	bl	c0003158 <shell_print_cpu_entry>
}
    c00038c4:	d503201f 	nop
    c00038c8:	a8c17bfd 	ldp	x29, x30, [sp], #16
    c00038cc:	d65f03c0 	ret

00000000c00038d0 <shell_print_cpu_id>:

static void shell_print_cpu_id(const char *arg)
{
    c00038d0:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
    c00038d4:	910003fd 	mov	x29, sp
    c00038d8:	f9000fe0 	str	x0, [sp, #24]
	uint64_t logical_id;
	const struct cpu_topology_descriptor *cpu;

	if (!parse_u64(arg, &logical_id)) {
    c00038dc:	910083e0 	add	x0, sp, #0x20
    c00038e0:	aa0003e1 	mov	x1, x0
    c00038e4:	f9400fe0 	ldr	x0, [sp, #24]
    c00038e8:	97fffd75 	bl	c0002ebc <parse_u64>
    c00038ec:	12001c00 	and	w0, w0, #0xff
    c00038f0:	52000000 	eor	w0, w0, #0x1
    c00038f4:	12001c00 	and	w0, w0, #0xff
    c00038f8:	12000000 	and	w0, w0, #0x1
    c00038fc:	7100001f 	cmp	w0, #0x0
    c0003900:	540000c0 	b.eq	c0003918 <shell_print_cpu_id+0x48>  // b.none
		mini_os_printf("error: invalid cpu id '%s'\n", arg);
    c0003904:	f9400fe1 	ldr	x1, [sp, #24]
    c0003908:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c000390c:	91114000 	add	x0, x0, #0x450
    c0003910:	97fff8f9 	bl	c0001cf4 <mini_os_printf>
		return;
    c0003914:	14000016 	b	c000396c <shell_print_cpu_id+0x9c>
	}

	cpu = topology_cpu((unsigned int)logical_id);
    c0003918:	f94013e0 	ldr	x0, [sp, #32]
    c000391c:	94000631 	bl	c00051e0 <topology_cpu>
    c0003920:	f90017e0 	str	x0, [sp, #40]
	if ((cpu == (const struct cpu_topology_descriptor *)0) || !cpu->present) {
    c0003924:	f94017e0 	ldr	x0, [sp, #40]
    c0003928:	f100001f 	cmp	x0, #0x0
    c000392c:	54000100 	b.eq	c000394c <shell_print_cpu_id+0x7c>  // b.none
    c0003930:	f94017e0 	ldr	x0, [sp, #40]
    c0003934:	39407400 	ldrb	w0, [x0, #29]
    c0003938:	52000000 	eor	w0, w0, #0x1
    c000393c:	12001c00 	and	w0, w0, #0xff
    c0003940:	12000000 	and	w0, w0, #0x1
    c0003944:	7100001f 	cmp	w0, #0x0
    c0003948:	540000e0 	b.eq	c0003964 <shell_print_cpu_id+0x94>  // b.none
		mini_os_printf("cpu%u is not present\n", (unsigned int)logical_id);
    c000394c:	f94013e0 	ldr	x0, [sp, #32]
    c0003950:	2a0003e1 	mov	w1, w0
    c0003954:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0003958:	9111c000 	add	x0, x0, #0x470
    c000395c:	97fff8e6 	bl	c0001cf4 <mini_os_printf>
		return;
    c0003960:	14000003 	b	c000396c <shell_print_cpu_id+0x9c>
	}

	shell_print_cpu_entry((unsigned int)logical_id);
    c0003964:	f94013e0 	ldr	x0, [sp, #32]
    c0003968:	97fffdfc 	bl	c0003158 <shell_print_cpu_entry>
}
    c000396c:	a8c37bfd 	ldp	x29, x30, [sp], #48
    c0003970:	d65f03c0 	ret

00000000c0003974 <shell_print_cpus>:

static void shell_print_cpus(void)
{
    c0003974:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
    c0003978:	910003fd 	mov	x29, sp
    c000397c:	a90153f3 	stp	x19, x20, [sp, #16]
	unsigned int i;

	for (i = 0U; i < topology_cpu_capacity(); ++i) {
    c0003980:	b9002fff 	str	wzr, [sp, #44]
    c0003984:	14000011 	b	c00039c8 <shell_print_cpus+0x54>
		const struct cpu_topology_descriptor *cpu = topology_cpu(i);
    c0003988:	b9402fe0 	ldr	w0, [sp, #44]
    c000398c:	94000615 	bl	c00051e0 <topology_cpu>
    c0003990:	f90013e0 	str	x0, [sp, #32]

		if ((cpu != (const struct cpu_topology_descriptor *)0) && cpu->present) {
    c0003994:	f94013e0 	ldr	x0, [sp, #32]
    c0003998:	f100001f 	cmp	x0, #0x0
    c000399c:	54000100 	b.eq	c00039bc <shell_print_cpus+0x48>  // b.none
    c00039a0:	f94013e0 	ldr	x0, [sp, #32]
    c00039a4:	39407400 	ldrb	w0, [x0, #29]
    c00039a8:	12000000 	and	w0, w0, #0x1
    c00039ac:	7100001f 	cmp	w0, #0x0
    c00039b0:	54000060 	b.eq	c00039bc <shell_print_cpus+0x48>  // b.none
			shell_print_cpu_entry(i);
    c00039b4:	b9402fe0 	ldr	w0, [sp, #44]
    c00039b8:	97fffde8 	bl	c0003158 <shell_print_cpu_entry>
	for (i = 0U; i < topology_cpu_capacity(); ++i) {
    c00039bc:	b9402fe0 	ldr	w0, [sp, #44]
    c00039c0:	11000400 	add	w0, w0, #0x1
    c00039c4:	b9002fe0 	str	w0, [sp, #44]
    c00039c8:	94000639 	bl	c00052ac <topology_cpu_capacity>
    c00039cc:	2a0003e1 	mov	w1, w0
    c00039d0:	b9402fe0 	ldr	w0, [sp, #44]
    c00039d4:	6b01001f 	cmp	w0, w1
    c00039d8:	54fffd83 	b.cc	c0003988 <shell_print_cpus+0x14>  // b.lo, b.ul, b.last
		}
	}
	mini_os_printf("online=%u runnable=%u capacity=%u\n",
    c00039dc:	9400063a 	bl	c00052c4 <topology_online_cpu_count>
    c00039e0:	2a0003f3 	mov	w19, w0
    c00039e4:	97fffcda 	bl	c0002d4c <scheduler_runnable_cpu_count>
    c00039e8:	2a0003f4 	mov	w20, w0
    c00039ec:	94000630 	bl	c00052ac <topology_cpu_capacity>
    c00039f0:	2a0003e3 	mov	w3, w0
    c00039f4:	2a1403e2 	mov	w2, w20
    c00039f8:	2a1303e1 	mov	w1, w19
    c00039fc:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0003a00:	91122000 	add	x0, x0, #0x488
    c0003a04:	97fff8bc 	bl	c0001cf4 <mini_os_printf>
		       topology_online_cpu_count(),
		       scheduler_runnable_cpu_count(),
		       topology_cpu_capacity());
}
    c0003a08:	d503201f 	nop
    c0003a0c:	a94153f3 	ldp	x19, x20, [sp, #16]
    c0003a10:	a8c37bfd 	ldp	x29, x30, [sp], #48
    c0003a14:	d65f03c0 	ret

00000000c0003a18 <shell_print_topology_summary>:

static void shell_print_topology_summary(void)
{
    c0003a18:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c0003a1c:	910003fd 	mov	x29, sp
	const struct cpu_topology_descriptor *boot_cpu = topology_boot_cpu();
    c0003a20:	940005ed 	bl	c00051d4 <topology_boot_cpu>
    c0003a24:	f9000fe0 	str	x0, [sp, #24]

	mini_os_printf("Topology summary:\n");
    c0003a28:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0003a2c:	9112c000 	add	x0, x0, #0x4b0
    c0003a30:	97fff8b1 	bl	c0001cf4 <mini_os_printf>
	mini_os_printf("  present cpus : %u\n", topology_present_cpu_count());
    c0003a34:	94000620 	bl	c00052b4 <topology_present_cpu_count>
    c0003a38:	2a0003e1 	mov	w1, w0
    c0003a3c:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0003a40:	91132000 	add	x0, x0, #0x4c8
    c0003a44:	97fff8ac 	bl	c0001cf4 <mini_os_printf>
	mini_os_printf("  online cpus  : %u\n", topology_online_cpu_count());
    c0003a48:	9400061f 	bl	c00052c4 <topology_online_cpu_count>
    c0003a4c:	2a0003e1 	mov	w1, w0
    c0003a50:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0003a54:	91138000 	add	x0, x0, #0x4e0
    c0003a58:	97fff8a7 	bl	c0001cf4 <mini_os_printf>
	mini_os_printf("  boot cpu     : cpu%u\n", boot_cpu->logical_id);
    c0003a5c:	f9400fe0 	ldr	x0, [sp, #24]
    c0003a60:	b9400800 	ldr	w0, [x0, #8]
    c0003a64:	2a0003e1 	mov	w1, w0
    c0003a68:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0003a6c:	9113e000 	add	x0, x0, #0x4f8
    c0003a70:	97fff8a1 	bl	c0001cf4 <mini_os_printf>
	mini_os_printf("  boot mpidr   : 0x%llx\n", (unsigned long long)boot_cpu->mpidr);
    c0003a74:	f9400fe0 	ldr	x0, [sp, #24]
    c0003a78:	f9400000 	ldr	x0, [x0]
    c0003a7c:	aa0003e1 	mov	x1, x0
    c0003a80:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0003a84:	91144000 	add	x0, x0, #0x510
    c0003a88:	97fff89b 	bl	c0001cf4 <mini_os_printf>
	mini_os_printf("  affinity     : chip=%u die=%u cluster=%u core=%u\n",
		       boot_cpu->chip_id,
    c0003a8c:	f9400fe0 	ldr	x0, [sp, #24]
    c0003a90:	b9400c01 	ldr	w1, [x0, #12]
		       boot_cpu->die_id,
    c0003a94:	f9400fe0 	ldr	x0, [sp, #24]
    c0003a98:	b9401002 	ldr	w2, [x0, #16]
		       boot_cpu->cluster_id,
    c0003a9c:	f9400fe0 	ldr	x0, [sp, #24]
    c0003aa0:	b9401403 	ldr	w3, [x0, #20]
		       boot_cpu->core_id);
    c0003aa4:	f9400fe0 	ldr	x0, [sp, #24]
    c0003aa8:	b9401800 	ldr	w0, [x0, #24]
	mini_os_printf("  affinity     : chip=%u die=%u cluster=%u core=%u\n",
    c0003aac:	2a0003e4 	mov	w4, w0
    c0003ab0:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0003ab4:	9114c000 	add	x0, x0, #0x530
    c0003ab8:	97fff88f 	bl	c0001cf4 <mini_os_printf>
}
    c0003abc:	d503201f 	nop
    c0003ac0:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c0003ac4:	d65f03c0 	ret

00000000c0003ac8 <shell_echo_args>:

static void shell_echo_args(int argc, char *argv[])
{
    c0003ac8:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
    c0003acc:	910003fd 	mov	x29, sp
    c0003ad0:	b9001fe0 	str	w0, [sp, #28]
    c0003ad4:	f9000be1 	str	x1, [sp, #16]
	int i;

	for (i = 1; i < argc; ++i) {
    c0003ad8:	52800020 	mov	w0, #0x1                   	// #1
    c0003adc:	b9002fe0 	str	w0, [sp, #44]
    c0003ae0:	14000015 	b	c0003b34 <shell_echo_args+0x6c>
		mini_os_printf("%s", argv[i]);
    c0003ae4:	b9802fe0 	ldrsw	x0, [sp, #44]
    c0003ae8:	d37df000 	lsl	x0, x0, #3
    c0003aec:	f9400be1 	ldr	x1, [sp, #16]
    c0003af0:	8b000020 	add	x0, x1, x0
    c0003af4:	f9400000 	ldr	x0, [x0]
    c0003af8:	aa0003e1 	mov	x1, x0
    c0003afc:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0003b00:	9115a000 	add	x0, x0, #0x568
    c0003b04:	97fff87c 	bl	c0001cf4 <mini_os_printf>
		if (i + 1 < argc) {
    c0003b08:	b9402fe0 	ldr	w0, [sp, #44]
    c0003b0c:	11000400 	add	w0, w0, #0x1
    c0003b10:	b9401fe1 	ldr	w1, [sp, #28]
    c0003b14:	6b00003f 	cmp	w1, w0
    c0003b18:	5400008d 	b.le	c0003b28 <shell_echo_args+0x60>
			mini_os_printf(" ");
    c0003b1c:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0003b20:	9115c000 	add	x0, x0, #0x570
    c0003b24:	97fff874 	bl	c0001cf4 <mini_os_printf>
	for (i = 1; i < argc; ++i) {
    c0003b28:	b9402fe0 	ldr	w0, [sp, #44]
    c0003b2c:	11000400 	add	w0, w0, #0x1
    c0003b30:	b9002fe0 	str	w0, [sp, #44]
    c0003b34:	b9402fe1 	ldr	w1, [sp, #44]
    c0003b38:	b9401fe0 	ldr	w0, [sp, #28]
    c0003b3c:	6b00003f 	cmp	w1, w0
    c0003b40:	54fffd2b 	b.lt	c0003ae4 <shell_echo_args+0x1c>  // b.tstop
		}
	}
	mini_os_printf("\n");
    c0003b44:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0003b48:	9115e000 	add	x0, x0, #0x578
    c0003b4c:	97fff86a 	bl	c0001cf4 <mini_os_printf>
}
    c0003b50:	d503201f 	nop
    c0003b54:	a8c37bfd 	ldp	x29, x30, [sp], #48
    c0003b58:	d65f03c0 	ret

00000000c0003b5c <shell_clear_screen>:

static void shell_clear_screen(void)
{
    c0003b5c:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    c0003b60:	910003fd 	mov	x29, sp
	mini_os_printf("\033[2J\033[H");
    c0003b64:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0003b68:	91160000 	add	x0, x0, #0x580
    c0003b6c:	97fff862 	bl	c0001cf4 <mini_os_printf>
}
    c0003b70:	d503201f 	nop
    c0003b74:	a8c17bfd 	ldp	x29, x30, [sp], #16
    c0003b78:	d65f03c0 	ret

00000000c0003b7c <shell_halt>:

static void shell_halt(void)
{
    c0003b7c:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    c0003b80:	910003fd 	mov	x29, sp
	mini_os_printf("Halting CPU. Use reset/restart in your emulator or board monitor.\n");
    c0003b84:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0003b88:	91162000 	add	x0, x0, #0x588
    c0003b8c:	97fff85a 	bl	c0001cf4 <mini_os_printf>
	for (;;) {
		__asm__ volatile ("wfe");
    c0003b90:	d503205f 	wfe
    c0003b94:	17ffffff 	b	c0003b90 <shell_halt+0x14>

00000000c0003b98 <shell_print_smp_already_online>:
}

static void shell_print_smp_already_online(uint64_t mpidr,
					   unsigned int logical_id,
					   const struct smp_cpu_state *state)
{
    c0003b98:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
    c0003b9c:	910003fd 	mov	x29, sp
    c0003ba0:	f90017e0 	str	x0, [sp, #40]
    c0003ba4:	b90027e1 	str	w1, [sp, #36]
    c0003ba8:	f9000fe2 	str	x2, [sp, #24]
	if ((state != (const struct smp_cpu_state *)0) && state->boot_cpu) {
    c0003bac:	f9400fe0 	ldr	x0, [sp, #24]
    c0003bb0:	f100001f 	cmp	x0, #0x0
    c0003bb4:	54000180 	b.eq	c0003be4 <shell_print_smp_already_online+0x4c>  // b.none
    c0003bb8:	f9400fe0 	ldr	x0, [sp, #24]
    c0003bbc:	39404c00 	ldrb	w0, [x0, #19]
    c0003bc0:	12000000 	and	w0, w0, #0x1
    c0003bc4:	7100001f 	cmp	w0, #0x0
    c0003bc8:	540000e0 	b.eq	c0003be4 <shell_print_smp_already_online+0x4c>  // b.none
		mini_os_printf("cpu%u (mpidr=0x%llx) is the boot CPU, already online by default\n",
    c0003bcc:	f94017e2 	ldr	x2, [sp, #40]
    c0003bd0:	b94027e1 	ldr	w1, [sp, #36]
    c0003bd4:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0003bd8:	91174000 	add	x0, x0, #0x5d0
    c0003bdc:	97fff846 	bl	c0001cf4 <mini_os_printf>
			       logical_id,
			       (unsigned long long)mpidr);
		return;
    c0003be0:	14000013 	b	c0003c2c <shell_print_smp_already_online+0x94>
	}

	if ((state != (const struct smp_cpu_state *)0) && state->online) {
    c0003be4:	f9400fe0 	ldr	x0, [sp, #24]
    c0003be8:	f100001f 	cmp	x0, #0x0
    c0003bec:	54000180 	b.eq	c0003c1c <shell_print_smp_already_online+0x84>  // b.none
    c0003bf0:	f9400fe0 	ldr	x0, [sp, #24]
    c0003bf4:	39404000 	ldrb	w0, [x0, #16]
    c0003bf8:	12000000 	and	w0, w0, #0x1
    c0003bfc:	7100001f 	cmp	w0, #0x0
    c0003c00:	540000e0 	b.eq	c0003c1c <shell_print_smp_already_online+0x84>  // b.none
		mini_os_printf("cpu%u (mpidr=0x%llx) is a secondary CPU that is already online and scheduled\n",
    c0003c04:	f94017e2 	ldr	x2, [sp, #40]
    c0003c08:	b94027e1 	ldr	w1, [sp, #36]
    c0003c0c:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0003c10:	91186000 	add	x0, x0, #0x618
    c0003c14:	97fff838 	bl	c0001cf4 <mini_os_printf>
			       logical_id,
			       (unsigned long long)mpidr);
		return;
    c0003c18:	14000005 	b	c0003c2c <shell_print_smp_already_online+0x94>
	}

	mini_os_printf("TF-A returned already-on for mpidr=0x%llx, but mini-os did not observe this secondary CPU actually boot\n",
    c0003c1c:	f94017e1 	ldr	x1, [sp, #40]
    c0003c20:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0003c24:	9119a000 	add	x0, x0, #0x668
    c0003c28:	97fff833 	bl	c0001cf4 <mini_os_printf>
		       (unsigned long long)mpidr);
}
    c0003c2c:	a8c37bfd 	ldp	x29, x30, [sp], #48
    c0003c30:	d65f03c0 	ret

00000000c0003c34 <shell_handle_smp>:

static void shell_handle_smp(int argc, char *argv[])
{
    c0003c34:	a9ba7bfd 	stp	x29, x30, [sp, #-96]!
    c0003c38:	910003fd 	mov	x29, sp
    c0003c3c:	a90153f3 	stp	x19, x20, [sp, #16]
    c0003c40:	a9025bf5 	stp	x21, x22, [sp, #32]
    c0003c44:	b9003fe0 	str	w0, [sp, #60]
    c0003c48:	f9001be1 	str	x1, [sp, #48]
	uint64_t mpidr;
	unsigned int logical_id = 0U;
    c0003c4c:	b90047ff 	str	wzr, [sp, #68]
	int32_t smc_ret = 0;
    c0003c50:	b90043ff 	str	wzr, [sp, #64]
	int ret;
	const struct smp_cpu_state *state = (const struct smp_cpu_state *)0;
    c0003c54:	f9002fff 	str	xzr, [sp, #88]

	if (argc < 2) {
    c0003c58:	b9403fe0 	ldr	w0, [sp, #60]
    c0003c5c:	7100041f 	cmp	w0, #0x1
    c0003c60:	540000ac 	b.gt	c0003c74 <shell_handle_smp+0x40>
		mini_os_printf("usage: smp status | smp start <mpidr>\n");
    c0003c64:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0003c68:	911b6000 	add	x0, x0, #0x6d8
    c0003c6c:	97fff822 	bl	c0001cf4 <mini_os_printf>
		return;
    c0003c70:	140000bc 	b	c0003f60 <shell_handle_smp+0x32c>
	}

	if (strings_equal(argv[1], "status")) {
    c0003c74:	f9401be0 	ldr	x0, [sp, #48]
    c0003c78:	91002000 	add	x0, x0, #0x8
    c0003c7c:	f9400002 	ldr	x2, [x0]
    c0003c80:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0003c84:	911c0001 	add	x1, x0, #0x700
    c0003c88:	aa0203e0 	mov	x0, x2
    c0003c8c:	97fffc49 	bl	c0002db0 <strings_equal>
    c0003c90:	12001c00 	and	w0, w0, #0xff
    c0003c94:	12000000 	and	w0, w0, #0x1
    c0003c98:	7100001f 	cmp	w0, #0x0
    c0003c9c:	54000060 	b.eq	c0003ca8 <shell_handle_smp+0x74>  // b.none
		shell_print_cpus();
    c0003ca0:	97ffff35 	bl	c0003974 <shell_print_cpus>
		return;
    c0003ca4:	140000af 	b	c0003f60 <shell_handle_smp+0x32c>
	}

	if (strings_equal(argv[1], "start")) {
    c0003ca8:	f9401be0 	ldr	x0, [sp, #48]
    c0003cac:	91002000 	add	x0, x0, #0x8
    c0003cb0:	f9400002 	ldr	x2, [x0]
    c0003cb4:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0003cb8:	911c2001 	add	x1, x0, #0x708
    c0003cbc:	aa0203e0 	mov	x0, x2
    c0003cc0:	97fffc3c 	bl	c0002db0 <strings_equal>
    c0003cc4:	12001c00 	and	w0, w0, #0xff
    c0003cc8:	12000000 	and	w0, w0, #0x1
    c0003ccc:	7100001f 	cmp	w0, #0x0
    c0003cd0:	540013a0 	b.eq	c0003f44 <shell_handle_smp+0x310>  // b.none
		if (argc < 3) {
    c0003cd4:	b9403fe0 	ldr	w0, [sp, #60]
    c0003cd8:	7100081f 	cmp	w0, #0x2
    c0003cdc:	540000ac 	b.gt	c0003cf0 <shell_handle_smp+0xbc>
			mini_os_printf("usage: smp start <mpidr>\n");
    c0003ce0:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0003ce4:	911c4000 	add	x0, x0, #0x710
    c0003ce8:	97fff803 	bl	c0001cf4 <mini_os_printf>
			return;
    c0003cec:	1400009d 	b	c0003f60 <shell_handle_smp+0x32c>
		}
		if (!parse_u64(argv[2], &mpidr)) {
    c0003cf0:	f9401be0 	ldr	x0, [sp, #48]
    c0003cf4:	91004000 	add	x0, x0, #0x10
    c0003cf8:	f9400000 	ldr	x0, [x0]
    c0003cfc:	910123e1 	add	x1, sp, #0x48
    c0003d00:	97fffc6f 	bl	c0002ebc <parse_u64>
    c0003d04:	12001c00 	and	w0, w0, #0xff
    c0003d08:	52000000 	eor	w0, w0, #0x1
    c0003d0c:	12001c00 	and	w0, w0, #0xff
    c0003d10:	12000000 	and	w0, w0, #0x1
    c0003d14:	7100001f 	cmp	w0, #0x0
    c0003d18:	54000120 	b.eq	c0003d3c <shell_handle_smp+0x108>  // b.none
			mini_os_printf("error: invalid mpidr '%s'\n", argv[2]);
    c0003d1c:	f9401be0 	ldr	x0, [sp, #48]
    c0003d20:	91004000 	add	x0, x0, #0x10
    c0003d24:	f9400000 	ldr	x0, [x0]
    c0003d28:	aa0003e1 	mov	x1, x0
    c0003d2c:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0003d30:	911cc000 	add	x0, x0, #0x730
    c0003d34:	97fff7f0 	bl	c0001cf4 <mini_os_printf>
			return;
    c0003d38:	1400008a 	b	c0003f60 <shell_handle_smp+0x32c>
		}

		ret = smp_start_cpu(mpidr, &logical_id, &smc_ret);
    c0003d3c:	f94027e0 	ldr	x0, [sp, #72]
    c0003d40:	910103e2 	add	x2, sp, #0x40
    c0003d44:	910113e1 	add	x1, sp, #0x44
    c0003d48:	940002ff 	bl	c0004944 <smp_start_cpu>
    c0003d4c:	b90057e0 	str	w0, [sp, #84]
		state = smp_cpu_state(logical_id);
    c0003d50:	b94047e0 	ldr	w0, [sp, #68]
    c0003d54:	94000427 	bl	c0004df0 <smp_cpu_state>
    c0003d58:	f9002fe0 	str	x0, [sp, #88]

		mini_os_printf("TF-A cpu_on(mpidr=0x%llx, entry=0x%llx, ctx=cpu%u) -> smc=%d (%s)\n",
    c0003d5c:	f94027f3 	ldr	x19, [sp, #72]
			       (unsigned long long)mpidr,
			       (unsigned long long)smp_secondary_entrypoint(),
    c0003d60:	94000492 	bl	c0004fa8 <smp_secondary_entrypoint>
    c0003d64:	aa0003f6 	mov	x22, x0
		mini_os_printf("TF-A cpu_on(mpidr=0x%llx, entry=0x%llx, ctx=cpu%u) -> smc=%d (%s)\n",
    c0003d68:	b94047f4 	ldr	w20, [sp, #68]
    c0003d6c:	b94043f5 	ldr	w21, [sp, #64]
    c0003d70:	b94057e0 	ldr	w0, [sp, #84]
    c0003d74:	9400026c 	bl	c0004724 <smp_start_result_name>
    c0003d78:	aa0003e5 	mov	x5, x0
    c0003d7c:	2a1503e4 	mov	w4, w21
    c0003d80:	2a1403e3 	mov	w3, w20
    c0003d84:	aa1603e2 	mov	x2, x22
    c0003d88:	aa1303e1 	mov	x1, x19
    c0003d8c:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0003d90:	911d4000 	add	x0, x0, #0x750
    c0003d94:	97fff7d8 	bl	c0001cf4 <mini_os_printf>
			       logical_id,
			       smc_ret,
			       smp_start_result_name(ret));

		if (ret == SMP_START_OK) {
    c0003d98:	b94057e0 	ldr	w0, [sp, #84]
    c0003d9c:	7100001f 	cmp	w0, #0x0
    c0003da0:	54000661 	b.ne	c0003e6c <shell_handle_smp+0x238>  // b.any
			mini_os_printf("cpu%u power-on confirmed: online=%s scheduled=%s pending=%s runnable=%u\n",
    c0003da4:	b94047f6 	ldr	w22, [sp, #68]
    c0003da8:	f9402fe0 	ldr	x0, [sp, #88]
    c0003dac:	f100001f 	cmp	x0, #0x0
    c0003db0:	54000120 	b.eq	c0003dd4 <shell_handle_smp+0x1a0>  // b.none
				       logical_id,
				       ((state != (const struct smp_cpu_state *)0) && state->online) ? "yes" : "no",
    c0003db4:	f9402fe0 	ldr	x0, [sp, #88]
    c0003db8:	39404000 	ldrb	w0, [x0, #16]
    c0003dbc:	12000000 	and	w0, w0, #0x1
    c0003dc0:	7100001f 	cmp	w0, #0x0
    c0003dc4:	54000080 	b.eq	c0003dd4 <shell_handle_smp+0x1a0>  // b.none
			mini_os_printf("cpu%u power-on confirmed: online=%s scheduled=%s pending=%s runnable=%u\n",
    c0003dc8:	d0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c0003dcc:	9124a013 	add	x19, x0, #0x928
    c0003dd0:	14000003 	b	c0003ddc <shell_handle_smp+0x1a8>
    c0003dd4:	d0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c0003dd8:	9124c013 	add	x19, x0, #0x930
    c0003ddc:	f9402fe0 	ldr	x0, [sp, #88]
    c0003de0:	f100001f 	cmp	x0, #0x0
    c0003de4:	54000120 	b.eq	c0003e08 <shell_handle_smp+0x1d4>  // b.none
				       ((state != (const struct smp_cpu_state *)0) && state->scheduled) ? "yes" : "no",
    c0003de8:	f9402fe0 	ldr	x0, [sp, #88]
    c0003dec:	39404400 	ldrb	w0, [x0, #17]
    c0003df0:	12000000 	and	w0, w0, #0x1
    c0003df4:	7100001f 	cmp	w0, #0x0
    c0003df8:	54000080 	b.eq	c0003e08 <shell_handle_smp+0x1d4>  // b.none
			mini_os_printf("cpu%u power-on confirmed: online=%s scheduled=%s pending=%s runnable=%u\n",
    c0003dfc:	d0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c0003e00:	9124a014 	add	x20, x0, #0x928
    c0003e04:	14000003 	b	c0003e10 <shell_handle_smp+0x1dc>
    c0003e08:	d0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c0003e0c:	9124c014 	add	x20, x0, #0x930
    c0003e10:	f9402fe0 	ldr	x0, [sp, #88]
    c0003e14:	f100001f 	cmp	x0, #0x0
    c0003e18:	54000120 	b.eq	c0003e3c <shell_handle_smp+0x208>  // b.none
				       ((state != (const struct smp_cpu_state *)0) && state->pending) ? "yes" : "no",
    c0003e1c:	f9402fe0 	ldr	x0, [sp, #88]
    c0003e20:	39404800 	ldrb	w0, [x0, #18]
    c0003e24:	12000000 	and	w0, w0, #0x1
    c0003e28:	7100001f 	cmp	w0, #0x0
    c0003e2c:	54000080 	b.eq	c0003e3c <shell_handle_smp+0x208>  // b.none
			mini_os_printf("cpu%u power-on confirmed: online=%s scheduled=%s pending=%s runnable=%u\n",
    c0003e30:	d0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c0003e34:	9124a015 	add	x21, x0, #0x928
    c0003e38:	14000003 	b	c0003e44 <shell_handle_smp+0x210>
    c0003e3c:	d0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c0003e40:	9124c015 	add	x21, x0, #0x930
    c0003e44:	97fffbc2 	bl	c0002d4c <scheduler_runnable_cpu_count>
    c0003e48:	2a0003e5 	mov	w5, w0
    c0003e4c:	aa1503e4 	mov	x4, x21
    c0003e50:	aa1403e3 	mov	x3, x20
    c0003e54:	aa1303e2 	mov	x2, x19
    c0003e58:	2a1603e1 	mov	w1, w22
    c0003e5c:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0003e60:	911e6000 	add	x0, x0, #0x798
    c0003e64:	97fff7a4 	bl	c0001cf4 <mini_os_printf>
		} else {
			mini_os_printf("cpu-on failed for mpidr=0x%llx with unexpected smc result %d\n",
				       (unsigned long long)mpidr,
				       smc_ret);
		}
		return;
    c0003e68:	1400003e 	b	c0003f60 <shell_handle_smp+0x32c>
		} else if (ret == SMP_START_ALREADY_ONLINE) {
    c0003e6c:	b94057e0 	ldr	w0, [sp, #84]
    c0003e70:	7100041f 	cmp	w0, #0x1
    c0003e74:	540000c1 	b.ne	c0003e8c <shell_handle_smp+0x258>  // b.any
			shell_print_smp_already_online(mpidr, logical_id, state);
    c0003e78:	f94027e0 	ldr	x0, [sp, #72]
    c0003e7c:	b94047e1 	ldr	w1, [sp, #68]
    c0003e80:	f9402fe2 	ldr	x2, [sp, #88]
    c0003e84:	97ffff45 	bl	c0003b98 <shell_print_smp_already_online>
		return;
    c0003e88:	14000036 	b	c0003f60 <shell_handle_smp+0x32c>
		} else if (ret == SMP_START_INVALID_CPU) {
    c0003e8c:	b94057e0 	ldr	w0, [sp, #84]
    c0003e90:	3100041f 	cmn	w0, #0x1
    c0003e94:	54000121 	b.ne	c0003eb8 <shell_handle_smp+0x284>  // b.any
			mini_os_printf("TF-A reported invalid target or no logical slot left for mpidr=0x%llx (capacity=%u)\n",
    c0003e98:	f94027f3 	ldr	x19, [sp, #72]
    c0003e9c:	94000504 	bl	c00052ac <topology_cpu_capacity>
    c0003ea0:	2a0003e2 	mov	w2, w0
    c0003ea4:	aa1303e1 	mov	x1, x19
    c0003ea8:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0003eac:	911fa000 	add	x0, x0, #0x7e8
    c0003eb0:	97fff791 	bl	c0001cf4 <mini_os_printf>
		return;
    c0003eb4:	1400002b 	b	c0003f60 <shell_handle_smp+0x32c>
		} else if (ret == SMP_START_DENIED) {
    c0003eb8:	b94057e0 	ldr	w0, [sp, #84]
    c0003ebc:	31000c1f 	cmn	w0, #0x3
    c0003ec0:	540000e1 	b.ne	c0003edc <shell_handle_smp+0x2a8>  // b.any
			mini_os_printf("TF-A denied cpu-on for mpidr=0x%llx\n",
    c0003ec4:	f94027e0 	ldr	x0, [sp, #72]
    c0003ec8:	aa0003e1 	mov	x1, x0
    c0003ecc:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0003ed0:	91210000 	add	x0, x0, #0x840
    c0003ed4:	97fff788 	bl	c0001cf4 <mini_os_printf>
		return;
    c0003ed8:	14000022 	b	c0003f60 <shell_handle_smp+0x32c>
		} else if (ret == SMP_START_UNSUPPORTED) {
    c0003edc:	b94057e0 	ldr	w0, [sp, #84]
    c0003ee0:	3100081f 	cmn	w0, #0x2
    c0003ee4:	540000e1 	b.ne	c0003f00 <shell_handle_smp+0x2cc>  // b.any
			mini_os_printf("TF-A/PSCI does not support cpu-on for mpidr=0x%llx\n",
    c0003ee8:	f94027e0 	ldr	x0, [sp, #72]
    c0003eec:	aa0003e1 	mov	x1, x0
    c0003ef0:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0003ef4:	9121a000 	add	x0, x0, #0x868
    c0003ef8:	97fff77f 	bl	c0001cf4 <mini_os_printf>
		return;
    c0003efc:	14000019 	b	c0003f60 <shell_handle_smp+0x32c>
		} else if (ret == SMP_START_TIMEOUT) {
    c0003f00:	b94057e0 	ldr	w0, [sp, #84]
    c0003f04:	3100101f 	cmn	w0, #0x4
    c0003f08:	540000e1 	b.ne	c0003f24 <shell_handle_smp+0x2f0>  // b.any
			mini_os_printf("cpu%u did not report online before timeout; please inspect TF-A handoff or secondary entry path\n",
    c0003f0c:	b94047e0 	ldr	w0, [sp, #68]
    c0003f10:	2a0003e1 	mov	w1, w0
    c0003f14:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0003f18:	91228000 	add	x0, x0, #0x8a0
    c0003f1c:	97fff776 	bl	c0001cf4 <mini_os_printf>
		return;
    c0003f20:	14000010 	b	c0003f60 <shell_handle_smp+0x32c>
			mini_os_printf("cpu-on failed for mpidr=0x%llx with unexpected smc result %d\n",
    c0003f24:	f94027e0 	ldr	x0, [sp, #72]
    c0003f28:	b94043e1 	ldr	w1, [sp, #64]
    c0003f2c:	2a0103e2 	mov	w2, w1
    c0003f30:	aa0003e1 	mov	x1, x0
    c0003f34:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0003f38:	91242000 	add	x0, x0, #0x908
    c0003f3c:	97fff76e 	bl	c0001cf4 <mini_os_printf>
		return;
    c0003f40:	14000008 	b	c0003f60 <shell_handle_smp+0x32c>
	}

	mini_os_printf("unknown smp subcommand: %s\n", argv[1]);
    c0003f44:	f9401be0 	ldr	x0, [sp, #48]
    c0003f48:	91002000 	add	x0, x0, #0x8
    c0003f4c:	f9400000 	ldr	x0, [x0]
    c0003f50:	aa0003e1 	mov	x1, x0
    c0003f54:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0003f58:	91252000 	add	x0, x0, #0x948
    c0003f5c:	97fff766 	bl	c0001cf4 <mini_os_printf>
}
    c0003f60:	a94153f3 	ldp	x19, x20, [sp, #16]
    c0003f64:	a9425bf5 	ldp	x21, x22, [sp, #32]
    c0003f68:	a8c67bfd 	ldp	x29, x30, [sp], #96
    c0003f6c:	d65f03c0 	ret

00000000c0003f70 <shell_execute>:

static void shell_execute(char *line)
{
    c0003f70:	a9b97bfd 	stp	x29, x30, [sp, #-112]!
    c0003f74:	910003fd 	mov	x29, sp
    c0003f78:	f9000fe0 	str	x0, [sp, #24]
	char *argv[SHELL_MAX_ARGS];
	int argc;
	const char *topic;

	argc = shell_tokenize(line, argv, SHELL_MAX_ARGS);
    c0003f7c:	910083e0 	add	x0, sp, #0x20
    c0003f80:	52800102 	mov	w2, #0x8                   	// #8
    c0003f84:	aa0003e1 	mov	x1, x0
    c0003f88:	f9400fe0 	ldr	x0, [sp, #24]
    c0003f8c:	97fffc34 	bl	c000305c <shell_tokenize>
    c0003f90:	b9006fe0 	str	w0, [sp, #108]
	if (argc == 0) {
    c0003f94:	b9406fe0 	ldr	w0, [sp, #108]
    c0003f98:	7100001f 	cmp	w0, #0x0
    c0003f9c:	54001380 	b.eq	c000420c <shell_execute+0x29c>  // b.none
		return;
	}

	if (strings_equal(argv[0], "help")) {
    c0003fa0:	f94013e2 	ldr	x2, [sp, #32]
    c0003fa4:	d0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c0003fa8:	9131c001 	add	x1, x0, #0xc70
    c0003fac:	aa0203e0 	mov	x0, x2
    c0003fb0:	97fffb80 	bl	c0002db0 <strings_equal>
    c0003fb4:	12001c00 	and	w0, w0, #0xff
    c0003fb8:	12000000 	and	w0, w0, #0x1
    c0003fbc:	7100001f 	cmp	w0, #0x0
    c0003fc0:	54000180 	b.eq	c0003ff0 <shell_execute+0x80>  // b.none
		if (argc >= 2) {
    c0003fc4:	b9406fe0 	ldr	w0, [sp, #108]
    c0003fc8:	7100041f 	cmp	w0, #0x1
    c0003fcc:	540000ed 	b.le	c0003fe8 <shell_execute+0x78>
			topic = shell_help_topic_name(argv[1]);
    c0003fd0:	f94017e0 	ldr	x0, [sp, #40]
    c0003fd4:	97fffba0 	bl	c0002e54 <shell_help_topic_name>
    c0003fd8:	f90033e0 	str	x0, [sp, #96]
			shell_print_help_topic(topic);
    c0003fdc:	f94033e0 	ldr	x0, [sp, #96]
    c0003fe0:	97fffce7 	bl	c000337c <shell_print_help_topic>
    c0003fe4:	1400008b 	b	c0004210 <shell_execute+0x2a0>
		} else {
			shell_print_help();
    c0003fe8:	97fffe02 	bl	c00037f0 <shell_print_help>
    c0003fec:	14000089 	b	c0004210 <shell_execute+0x2a0>
		}
	} else if (strings_equal(argv[0], "version")) {
    c0003ff0:	f94013e2 	ldr	x2, [sp, #32]
    c0003ff4:	f0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0003ff8:	91050001 	add	x1, x0, #0x140
    c0003ffc:	aa0203e0 	mov	x0, x2
    c0004000:	97fffb6c 	bl	c0002db0 <strings_equal>
    c0004004:	12001c00 	and	w0, w0, #0xff
    c0004008:	12000000 	and	w0, w0, #0x1
    c000400c:	7100001f 	cmp	w0, #0x0
    c0004010:	54000060 	b.eq	c000401c <shell_execute+0xac>  // b.none
		shell_print_version();
    c0004014:	97fffdfd 	bl	c0003808 <shell_print_version>
    c0004018:	1400007e 	b	c0004210 <shell_execute+0x2a0>
	} else if (strings_equal(argv[0], "info")) {
    c000401c:	f94013e2 	ldr	x2, [sp, #32]
    c0004020:	d0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0004024:	9102a001 	add	x1, x0, #0xa8
    c0004028:	aa0203e0 	mov	x0, x2
    c000402c:	97fffb61 	bl	c0002db0 <strings_equal>
    c0004030:	12001c00 	and	w0, w0, #0xff
    c0004034:	12000000 	and	w0, w0, #0x1
    c0004038:	7100001f 	cmp	w0, #0x0
    c000403c:	54000060 	b.eq	c0004048 <shell_execute+0xd8>  // b.none
		shell_print_info();
    c0004040:	97fffdff 	bl	c000383c <shell_print_info>
    c0004044:	14000073 	b	c0004210 <shell_execute+0x2a0>
	} else if (strings_equal(argv[0], "cpu")) {
    c0004048:	f94013e2 	ldr	x2, [sp, #32]
    c000404c:	b0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c0004050:	91340001 	add	x1, x0, #0xd00
    c0004054:	aa0203e0 	mov	x0, x2
    c0004058:	97fffb56 	bl	c0002db0 <strings_equal>
    c000405c:	12001c00 	and	w0, w0, #0xff
    c0004060:	12000000 	and	w0, w0, #0x1
    c0004064:	7100001f 	cmp	w0, #0x0
    c0004068:	54000120 	b.eq	c000408c <shell_execute+0x11c>  // b.none
		if (argc >= 2) {
    c000406c:	b9406fe0 	ldr	w0, [sp, #108]
    c0004070:	7100041f 	cmp	w0, #0x1
    c0004074:	5400008d 	b.le	c0004084 <shell_execute+0x114>
			shell_print_cpu_id(argv[1]);
    c0004078:	f94017e0 	ldr	x0, [sp, #40]
    c000407c:	97fffe15 	bl	c00038d0 <shell_print_cpu_id>
    c0004080:	14000064 	b	c0004210 <shell_execute+0x2a0>
		} else {
			shell_print_current_cpu();
    c0004084:	97fffe0c 	bl	c00038b4 <shell_print_current_cpu>
    c0004088:	14000062 	b	c0004210 <shell_execute+0x2a0>
		}
	} else if (strings_equal(argv[0], "cpus")) {
    c000408c:	f94013e2 	ldr	x2, [sp, #32]
    c0004090:	b0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c0004094:	91370001 	add	x1, x0, #0xdc0
    c0004098:	aa0203e0 	mov	x0, x2
    c000409c:	97fffb45 	bl	c0002db0 <strings_equal>
    c00040a0:	12001c00 	and	w0, w0, #0xff
    c00040a4:	12000000 	and	w0, w0, #0x1
    c00040a8:	7100001f 	cmp	w0, #0x0
    c00040ac:	54000060 	b.eq	c00040b8 <shell_execute+0x148>  // b.none
		shell_print_cpus();
    c00040b0:	97fffe31 	bl	c0003974 <shell_print_cpus>
    c00040b4:	14000057 	b	c0004210 <shell_execute+0x2a0>
	} else if (strings_equal(argv[0], "topo")) {
    c00040b8:	f94013e2 	ldr	x2, [sp, #32]
    c00040bc:	b0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c00040c0:	913a4001 	add	x1, x0, #0xe90
    c00040c4:	aa0203e0 	mov	x0, x2
    c00040c8:	97fffb3a 	bl	c0002db0 <strings_equal>
    c00040cc:	12001c00 	and	w0, w0, #0xff
    c00040d0:	12000000 	and	w0, w0, #0x1
    c00040d4:	7100001f 	cmp	w0, #0x0
    c00040d8:	54000060 	b.eq	c00040e4 <shell_execute+0x174>  // b.none
		shell_print_topology_summary();
    c00040dc:	97fffe4f 	bl	c0003a18 <shell_print_topology_summary>
    c00040e0:	1400004c 	b	c0004210 <shell_execute+0x2a0>
	} else if (strings_equal(argv[0], "smp")) {
    c00040e4:	f94013e2 	ldr	x2, [sp, #32]
    c00040e8:	b0000000 	adrp	x0, c0005000 <topology_fill_descriptor+0x2c>
    c00040ec:	913d4001 	add	x1, x0, #0xf50
    c00040f0:	aa0203e0 	mov	x0, x2
    c00040f4:	97fffb2f 	bl	c0002db0 <strings_equal>
    c00040f8:	12001c00 	and	w0, w0, #0xff
    c00040fc:	12000000 	and	w0, w0, #0x1
    c0004100:	7100001f 	cmp	w0, #0x0
    c0004104:	540000c0 	b.eq	c000411c <shell_execute+0x1ac>  // b.none
		shell_handle_smp(argc, argv);
    c0004108:	910083e0 	add	x0, sp, #0x20
    c000410c:	aa0003e1 	mov	x1, x0
    c0004110:	b9406fe0 	ldr	w0, [sp, #108]
    c0004114:	97fffec8 	bl	c0003c34 <shell_handle_smp>
    c0004118:	1400003e 	b	c0004210 <shell_execute+0x2a0>
	} else if (strings_equal(argv[0], "echo")) {
    c000411c:	f94013e2 	ldr	x2, [sp, #32]
    c0004120:	d0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0004124:	9106a001 	add	x1, x0, #0x1a8
    c0004128:	aa0203e0 	mov	x0, x2
    c000412c:	97fffb21 	bl	c0002db0 <strings_equal>
    c0004130:	12001c00 	and	w0, w0, #0xff
    c0004134:	12000000 	and	w0, w0, #0x1
    c0004138:	7100001f 	cmp	w0, #0x0
    c000413c:	540000c0 	b.eq	c0004154 <shell_execute+0x1e4>  // b.none
		shell_echo_args(argc, argv);
    c0004140:	910083e0 	add	x0, sp, #0x20
    c0004144:	aa0003e1 	mov	x1, x0
    c0004148:	b9406fe0 	ldr	w0, [sp, #108]
    c000414c:	97fffe5f 	bl	c0003ac8 <shell_echo_args>
    c0004150:	14000030 	b	c0004210 <shell_execute+0x2a0>
	} else if (strings_equal(argv[0], "clear")) {
    c0004154:	f94013e2 	ldr	x2, [sp, #32]
    c0004158:	d0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c000415c:	91086001 	add	x1, x0, #0x218
    c0004160:	aa0203e0 	mov	x0, x2
    c0004164:	97fffb13 	bl	c0002db0 <strings_equal>
    c0004168:	12001c00 	and	w0, w0, #0xff
    c000416c:	12000000 	and	w0, w0, #0x1
    c0004170:	7100001f 	cmp	w0, #0x0
    c0004174:	54000060 	b.eq	c0004180 <shell_execute+0x210>  // b.none
		shell_clear_screen();
    c0004178:	97fffe79 	bl	c0003b5c <shell_clear_screen>
    c000417c:	14000025 	b	c0004210 <shell_execute+0x2a0>
	} else if (strings_equal(argv[0], "uname")) {
    c0004180:	f94013e2 	ldr	x2, [sp, #32]
    c0004184:	d0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0004188:	910a8001 	add	x1, x0, #0x2a0
    c000418c:	aa0203e0 	mov	x0, x2
    c0004190:	97fffb08 	bl	c0002db0 <strings_equal>
    c0004194:	12001c00 	and	w0, w0, #0xff
    c0004198:	12000000 	and	w0, w0, #0x1
    c000419c:	7100001f 	cmp	w0, #0x0
    c00041a0:	540000e0 	b.eq	c00041bc <shell_execute+0x24c>  // b.none
		mini_os_printf("%s\n", MINI_OS_NAME);
    c00041a4:	d0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c00041a8:	910ec001 	add	x1, x0, #0x3b0
    c00041ac:	d0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c00041b0:	9125a000 	add	x0, x0, #0x968
    c00041b4:	97fff6d0 	bl	c0001cf4 <mini_os_printf>
    c00041b8:	14000016 	b	c0004210 <shell_execute+0x2a0>
	} else if (strings_equal(argv[0], "halt")) {
    c00041bc:	f94013e2 	ldr	x2, [sp, #32]
    c00041c0:	d0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c00041c4:	910b8001 	add	x1, x0, #0x2e0
    c00041c8:	aa0203e0 	mov	x0, x2
    c00041cc:	97fffaf9 	bl	c0002db0 <strings_equal>
    c00041d0:	12001c00 	and	w0, w0, #0xff
    c00041d4:	12000000 	and	w0, w0, #0x1
    c00041d8:	7100001f 	cmp	w0, #0x0
    c00041dc:	54000060 	b.eq	c00041e8 <shell_execute+0x278>  // b.none
		shell_halt();
    c00041e0:	97fffe67 	bl	c0003b7c <shell_halt>
    c00041e4:	1400000b 	b	c0004210 <shell_execute+0x2a0>
	} else {
		mini_os_printf("Unknown command: %s\n", argv[0]);
    c00041e8:	f94013e0 	ldr	x0, [sp, #32]
    c00041ec:	aa0003e1 	mov	x1, x0
    c00041f0:	d0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c00041f4:	9125c000 	add	x0, x0, #0x970
    c00041f8:	97fff6bf 	bl	c0001cf4 <mini_os_printf>
		mini_os_printf("Type 'help' to list supported commands.\n");
    c00041fc:	d0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0004200:	91262000 	add	x0, x0, #0x988
    c0004204:	97fff6bc 	bl	c0001cf4 <mini_os_printf>
    c0004208:	14000002 	b	c0004210 <shell_execute+0x2a0>
		return;
    c000420c:	d503201f 	nop
	}
}
    c0004210:	a8c77bfd 	ldp	x29, x30, [sp], #112
    c0004214:	d65f03c0 	ret

00000000c0004218 <shell_prompt>:

static void shell_prompt(void)
{
    c0004218:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    c000421c:	910003fd 	mov	x29, sp
	mini_os_printf("%s", SHELL_PROMPT);
    c0004220:	d0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0004224:	9126e001 	add	x1, x0, #0x9b8
    c0004228:	d0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c000422c:	9115a000 	add	x0, x0, #0x568
    c0004230:	97fff6b1 	bl	c0001cf4 <mini_os_printf>
}
    c0004234:	d503201f 	nop
    c0004238:	a8c17bfd 	ldp	x29, x30, [sp], #16
    c000423c:	d65f03c0 	ret

00000000c0004240 <shell_run>:

void shell_run(void)
{
    c0004240:	a9b67bfd 	stp	x29, x30, [sp, #-160]!
    c0004244:	910003fd 	mov	x29, sp
	char line[SHELL_MAX_LINE];
	size_t len = 0U;
    c0004248:	f9004fff 	str	xzr, [sp, #152]

	shell_prompt();
    c000424c:	97fffff3 	bl	c0004218 <shell_prompt>
	for (;;) {
		int ch = debug_getc();
    c0004250:	97fff701 	bl	c0001e54 <debug_getc>
    c0004254:	b90097e0 	str	w0, [sp, #148]

		if ((ch == '\r') || (ch == '\n')) {
    c0004258:	b94097e0 	ldr	w0, [sp, #148]
    c000425c:	7100341f 	cmp	w0, #0xd
    c0004260:	54000080 	b.eq	c0004270 <shell_run+0x30>  // b.none
    c0004264:	b94097e0 	ldr	w0, [sp, #148]
    c0004268:	7100281f 	cmp	w0, #0xa
    c000426c:	54000181 	b.ne	c000429c <shell_run+0x5c>  // b.any
			mini_os_printf("\n");
    c0004270:	d0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0004274:	9115e000 	add	x0, x0, #0x578
    c0004278:	97fff69f 	bl	c0001cf4 <mini_os_printf>
			line[len] = '\0';
    c000427c:	f9404fe0 	ldr	x0, [sp, #152]
    c0004280:	910043e1 	add	x1, sp, #0x10
    c0004284:	3820683f 	strb	wzr, [x1, x0]
			shell_execute(line);
    c0004288:	910043e0 	add	x0, sp, #0x10
    c000428c:	97ffff39 	bl	c0003f70 <shell_execute>
			len = 0U;
    c0004290:	f9004fff 	str	xzr, [sp, #152]
			shell_prompt();
    c0004294:	97ffffe1 	bl	c0004218 <shell_prompt>
			continue;
    c0004298:	14000034 	b	c0004368 <shell_run+0x128>
		}

		if ((ch == '\b') || (ch == 127)) {
    c000429c:	b94097e0 	ldr	w0, [sp, #148]
    c00042a0:	7100201f 	cmp	w0, #0x8
    c00042a4:	54000080 	b.eq	c00042b4 <shell_run+0x74>  // b.none
    c00042a8:	b94097e0 	ldr	w0, [sp, #148]
    c00042ac:	7101fc1f 	cmp	w0, #0x7f
    c00042b0:	54000161 	b.ne	c00042dc <shell_run+0x9c>  // b.any
			if (len > 0U) {
    c00042b4:	f9404fe0 	ldr	x0, [sp, #152]
    c00042b8:	f100001f 	cmp	x0, #0x0
    c00042bc:	540004c0 	b.eq	c0004354 <shell_run+0x114>  // b.none
				len--;
    c00042c0:	f9404fe0 	ldr	x0, [sp, #152]
    c00042c4:	d1000400 	sub	x0, x0, #0x1
    c00042c8:	f9004fe0 	str	x0, [sp, #152]
				mini_os_printf("\b \b");
    c00042cc:	d0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c00042d0:	91272000 	add	x0, x0, #0x9c8
    c00042d4:	97fff688 	bl	c0001cf4 <mini_os_printf>
			}
			continue;
    c00042d8:	1400001f 	b	c0004354 <shell_run+0x114>
		}

		if (ch == '\t') {
    c00042dc:	b94097e0 	ldr	w0, [sp, #148]
    c00042e0:	7100241f 	cmp	w0, #0x9
    c00042e4:	540003c0 	b.eq	c000435c <shell_run+0x11c>  // b.none
			continue;
		}

		if ((ch < 32) || (ch > 126)) {
    c00042e8:	b94097e0 	ldr	w0, [sp, #148]
    c00042ec:	71007c1f 	cmp	w0, #0x1f
    c00042f0:	540003ad 	b.le	c0004364 <shell_run+0x124>
    c00042f4:	b94097e0 	ldr	w0, [sp, #148]
    c00042f8:	7101f81f 	cmp	w0, #0x7e
    c00042fc:	5400034c 	b.gt	c0004364 <shell_run+0x124>
			continue;
		}

		if (len + 1U >= SHELL_MAX_LINE) {
    c0004300:	f9404fe0 	ldr	x0, [sp, #152]
    c0004304:	91000400 	add	x0, x0, #0x1
    c0004308:	f101fc1f 	cmp	x0, #0x7f
    c000430c:	54000109 	b.ls	c000432c <shell_run+0xec>  // b.plast
			mini_os_printf("\nerror: command too long (max %d chars)\n",
    c0004310:	52800fe1 	mov	w1, #0x7f                  	// #127
    c0004314:	d0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0004318:	91274000 	add	x0, x0, #0x9d0
    c000431c:	97fff676 	bl	c0001cf4 <mini_os_printf>
				       SHELL_MAX_LINE - 1);
			len = 0U;
    c0004320:	f9004fff 	str	xzr, [sp, #152]
			shell_prompt();
    c0004324:	97ffffbd 	bl	c0004218 <shell_prompt>
			continue;
    c0004328:	14000010 	b	c0004368 <shell_run+0x128>
		}

		line[len++] = (char)ch;
    c000432c:	f9404fe0 	ldr	x0, [sp, #152]
    c0004330:	91000401 	add	x1, x0, #0x1
    c0004334:	f9004fe1 	str	x1, [sp, #152]
    c0004338:	b94097e1 	ldr	w1, [sp, #148]
    c000433c:	12001c22 	and	w2, w1, #0xff
    c0004340:	910043e1 	add	x1, sp, #0x10
    c0004344:	38206822 	strb	w2, [x1, x0]
		debug_putc(ch);
    c0004348:	b94097e0 	ldr	w0, [sp, #148]
    c000434c:	97fff696 	bl	c0001da4 <debug_putc>
    c0004350:	17ffffc0 	b	c0004250 <shell_run+0x10>
			continue;
    c0004354:	d503201f 	nop
    c0004358:	17ffffbe 	b	c0004250 <shell_run+0x10>
			continue;
    c000435c:	d503201f 	nop
    c0004360:	17ffffbc 	b	c0004250 <shell_run+0x10>
			continue;
    c0004364:	d503201f 	nop
	for (;;) {
    c0004368:	17ffffba 	b	c0004250 <shell_run+0x10>

00000000c000436c <smp_read_cntfrq>:
unsigned char secondary_stacks[PLAT_MAX_CPUS][PLAT_STACK_SIZE] __attribute__((aligned(16)));

extern void secondary_cpu_entrypoint(void);

static inline uint64_t smp_read_cntfrq(void)
{
    c000436c:	d10043ff 	sub	sp, sp, #0x10
	uint64_t value;

	__asm__ volatile ("mrs %0, cntfrq_el0" : "=r" (value));
    c0004370:	d53be000 	mrs	x0, cntfrq_el0
    c0004374:	f90007e0 	str	x0, [sp, #8]
	return value;
    c0004378:	f94007e0 	ldr	x0, [sp, #8]
}
    c000437c:	910043ff 	add	sp, sp, #0x10
    c0004380:	d65f03c0 	ret

00000000c0004384 <smp_read_cntpct>:

static inline uint64_t smp_read_cntpct(void)
{
    c0004384:	d10043ff 	sub	sp, sp, #0x10
	uint64_t value;

	__asm__ volatile ("mrs %0, cntpct_el0" : "=r" (value));
    c0004388:	d53be020 	mrs	x0, cntpct_el0
    c000438c:	f90007e0 	str	x0, [sp, #8]
	return value;
    c0004390:	f94007e0 	ldr	x0, [sp, #8]
}
    c0004394:	910043ff 	add	sp, sp, #0x10
    c0004398:	d65f03c0 	ret

00000000c000439c <smp_relax>:

static inline void smp_relax(void)
{
	__asm__ volatile ("nop");
    c000439c:	d503201f 	nop
}
    c00043a0:	d503201f 	nop
    c00043a4:	d65f03c0 	ret

00000000c00043a8 <smp_smc_call>:

static int32_t smp_smc_call(uint64_t x0, uint64_t x1, uint64_t x2, uint64_t x3)
{
    c00043a8:	d10083ff 	sub	sp, sp, #0x20
    c00043ac:	f9000fe0 	str	x0, [sp, #24]
    c00043b0:	f9000be1 	str	x1, [sp, #16]
    c00043b4:	f90007e2 	str	x2, [sp, #8]
    c00043b8:	f90003e3 	str	x3, [sp]
	register uint64_t r0 __asm__("x0") = x0;
    c00043bc:	f9400fe0 	ldr	x0, [sp, #24]
	register uint64_t r1 __asm__("x1") = x1;
    c00043c0:	f9400be1 	ldr	x1, [sp, #16]
	register uint64_t r2 __asm__("x2") = x2;
    c00043c4:	f94007e2 	ldr	x2, [sp, #8]
	register uint64_t r3 __asm__("x3") = x3;
    c00043c8:	f94003e3 	ldr	x3, [sp]

	__asm__ volatile ("smc #0"
    c00043cc:	d4000003 	smc	#0x0
		: "r" (r1), "r" (r2), "r" (r3)
		: "x4", "x5", "x6", "x7", "x8", "x9", "x10", "x11", "x12",
		  "x13", "x14", "x15", "x16", "x17", "memory");

	return (int32_t)r0;
}
    c00043d0:	910083ff 	add	sp, sp, #0x20
    c00043d4:	d65f03c0 	ret

00000000c00043d8 <smp_find_free_logical_slot>:

static int smp_find_free_logical_slot(void)
{
    c00043d8:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c00043dc:	910003fd 	mov	x29, sp
	unsigned int i;

	for (i = 0U; i < PLAT_MAX_CPUS; ++i) {
    c00043e0:	b9001fff 	str	wzr, [sp, #28]
    c00043e4:	1400000e 	b	c000441c <smp_find_free_logical_slot+0x44>
		if (!topology_cpu(i)->present) {
    c00043e8:	b9401fe0 	ldr	w0, [sp, #28]
    c00043ec:	9400037d 	bl	c00051e0 <topology_cpu>
    c00043f0:	39407400 	ldrb	w0, [x0, #29]
    c00043f4:	52000000 	eor	w0, w0, #0x1
    c00043f8:	12001c00 	and	w0, w0, #0xff
    c00043fc:	12000000 	and	w0, w0, #0x1
    c0004400:	7100001f 	cmp	w0, #0x0
    c0004404:	54000060 	b.eq	c0004410 <smp_find_free_logical_slot+0x38>  // b.none
			return (int)i;
    c0004408:	b9401fe0 	ldr	w0, [sp, #28]
    c000440c:	14000008 	b	c000442c <smp_find_free_logical_slot+0x54>
	for (i = 0U; i < PLAT_MAX_CPUS; ++i) {
    c0004410:	b9401fe0 	ldr	w0, [sp, #28]
    c0004414:	11000400 	add	w0, w0, #0x1
    c0004418:	b9001fe0 	str	w0, [sp, #28]
    c000441c:	b9401fe0 	ldr	w0, [sp, #28]
    c0004420:	71001c1f 	cmp	w0, #0x7
    c0004424:	54fffe29 	b.ls	c00043e8 <smp_find_free_logical_slot+0x10>  // b.plast
		}
	}

	return -1;
    c0004428:	12800000 	mov	w0, #0xffffffff            	// #-1
}
    c000442c:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c0004430:	d65f03c0 	ret

00000000c0004434 <smp_reset_cpu_state>:

static void smp_reset_cpu_state(unsigned int logical_id)
{
    c0004434:	d10043ff 	sub	sp, sp, #0x10
    c0004438:	b9000fe0 	str	w0, [sp, #12]
	if (logical_id >= PLAT_MAX_CPUS) {
    c000443c:	b9400fe0 	ldr	w0, [sp, #12]
    c0004440:	71001c1f 	cmp	w0, #0x7
    c0004444:	54000728 	b.hi	c0004528 <smp_reset_cpu_state+0xf4>  // b.pmore
		return;
	}

	cpu_states[logical_id].logical_id = logical_id;
    c0004448:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c000444c:	912bc002 	add	x2, x0, #0xaf0
    c0004450:	b9400fe1 	ldr	w1, [sp, #12]
    c0004454:	aa0103e0 	mov	x0, x1
    c0004458:	d37ff800 	lsl	x0, x0, #1
    c000445c:	8b010000 	add	x0, x0, x1
    c0004460:	d37df000 	lsl	x0, x0, #3
    c0004464:	8b000040 	add	x0, x2, x0
    c0004468:	b9400fe1 	ldr	w1, [sp, #12]
    c000446c:	b9000001 	str	w1, [x0]
	cpu_states[logical_id].mpidr = 0U;
    c0004470:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c0004474:	912bc002 	add	x2, x0, #0xaf0
    c0004478:	b9400fe1 	ldr	w1, [sp, #12]
    c000447c:	aa0103e0 	mov	x0, x1
    c0004480:	d37ff800 	lsl	x0, x0, #1
    c0004484:	8b010000 	add	x0, x0, x1
    c0004488:	d37df000 	lsl	x0, x0, #3
    c000448c:	8b000040 	add	x0, x2, x0
    c0004490:	f900041f 	str	xzr, [x0, #8]
	cpu_states[logical_id].online = false;
    c0004494:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c0004498:	912bc002 	add	x2, x0, #0xaf0
    c000449c:	b9400fe1 	ldr	w1, [sp, #12]
    c00044a0:	aa0103e0 	mov	x0, x1
    c00044a4:	d37ff800 	lsl	x0, x0, #1
    c00044a8:	8b010000 	add	x0, x0, x1
    c00044ac:	d37df000 	lsl	x0, x0, #3
    c00044b0:	8b000040 	add	x0, x2, x0
    c00044b4:	3900401f 	strb	wzr, [x0, #16]
	cpu_states[logical_id].scheduled = false;
    c00044b8:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c00044bc:	912bc002 	add	x2, x0, #0xaf0
    c00044c0:	b9400fe1 	ldr	w1, [sp, #12]
    c00044c4:	aa0103e0 	mov	x0, x1
    c00044c8:	d37ff800 	lsl	x0, x0, #1
    c00044cc:	8b010000 	add	x0, x0, x1
    c00044d0:	d37df000 	lsl	x0, x0, #3
    c00044d4:	8b000040 	add	x0, x2, x0
    c00044d8:	3900441f 	strb	wzr, [x0, #17]
	cpu_states[logical_id].pending = false;
    c00044dc:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c00044e0:	912bc002 	add	x2, x0, #0xaf0
    c00044e4:	b9400fe1 	ldr	w1, [sp, #12]
    c00044e8:	aa0103e0 	mov	x0, x1
    c00044ec:	d37ff800 	lsl	x0, x0, #1
    c00044f0:	8b010000 	add	x0, x0, x1
    c00044f4:	d37df000 	lsl	x0, x0, #3
    c00044f8:	8b000040 	add	x0, x2, x0
    c00044fc:	3900481f 	strb	wzr, [x0, #18]
	cpu_states[logical_id].boot_cpu = false;
    c0004500:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c0004504:	912bc002 	add	x2, x0, #0xaf0
    c0004508:	b9400fe1 	ldr	w1, [sp, #12]
    c000450c:	aa0103e0 	mov	x0, x1
    c0004510:	d37ff800 	lsl	x0, x0, #1
    c0004514:	8b010000 	add	x0, x0, x1
    c0004518:	d37df000 	lsl	x0, x0, #3
    c000451c:	8b000040 	add	x0, x2, x0
    c0004520:	39004c1f 	strb	wzr, [x0, #19]
    c0004524:	14000002 	b	c000452c <smp_reset_cpu_state+0xf8>
		return;
    c0004528:	d503201f 	nop
}
    c000452c:	910043ff 	add	sp, sp, #0x10
    c0004530:	d65f03c0 	ret

00000000c0004534 <smp_wait_for_online>:

static bool smp_wait_for_online(unsigned int logical_id, uint32_t timeout_us)
{
    c0004534:	a9bc7bfd 	stp	x29, x30, [sp, #-64]!
    c0004538:	910003fd 	mov	x29, sp
    c000453c:	b9001fe0 	str	w0, [sp, #28]
    c0004540:	b9001be1 	str	w1, [sp, #24]
	uint64_t freq;
	uint64_t start;
	uint64_t ticks;

	if (logical_id >= PLAT_MAX_CPUS) {
    c0004544:	b9401fe0 	ldr	w0, [sp, #28]
    c0004548:	71001c1f 	cmp	w0, #0x7
    c000454c:	54000069 	b.ls	c0004558 <smp_wait_for_online+0x24>  // b.plast
		return false;
    c0004550:	52800000 	mov	w0, #0x0                   	// #0
    c0004554:	14000054 	b	c00046a4 <smp_wait_for_online+0x170>
	}

	if (cpu_states[logical_id].online) {
    c0004558:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c000455c:	912bc002 	add	x2, x0, #0xaf0
    c0004560:	b9401fe1 	ldr	w1, [sp, #28]
    c0004564:	aa0103e0 	mov	x0, x1
    c0004568:	d37ff800 	lsl	x0, x0, #1
    c000456c:	8b010000 	add	x0, x0, x1
    c0004570:	d37df000 	lsl	x0, x0, #3
    c0004574:	8b000040 	add	x0, x2, x0
    c0004578:	39404000 	ldrb	w0, [x0, #16]
    c000457c:	12000000 	and	w0, w0, #0x1
    c0004580:	7100001f 	cmp	w0, #0x0
    c0004584:	54000060 	b.eq	c0004590 <smp_wait_for_online+0x5c>  // b.none
		return true;
    c0004588:	52800020 	mov	w0, #0x1                   	// #1
    c000458c:	14000046 	b	c00046a4 <smp_wait_for_online+0x170>
	}

	freq = smp_read_cntfrq();
    c0004590:	97ffff77 	bl	c000436c <smp_read_cntfrq>
    c0004594:	f9001be0 	str	x0, [sp, #48]
	if (freq == 0U) {
    c0004598:	f9401be0 	ldr	x0, [sp, #48]
    c000459c:	f100001f 	cmp	x0, #0x0
    c00045a0:	54000161 	b.ne	c00045cc <smp_wait_for_online+0x98>  // b.any
		return cpu_states[logical_id].online;
    c00045a4:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c00045a8:	912bc002 	add	x2, x0, #0xaf0
    c00045ac:	b9401fe1 	ldr	w1, [sp, #28]
    c00045b0:	aa0103e0 	mov	x0, x1
    c00045b4:	d37ff800 	lsl	x0, x0, #1
    c00045b8:	8b010000 	add	x0, x0, x1
    c00045bc:	d37df000 	lsl	x0, x0, #3
    c00045c0:	8b000040 	add	x0, x2, x0
    c00045c4:	39404000 	ldrb	w0, [x0, #16]
    c00045c8:	14000037 	b	c00046a4 <smp_wait_for_online+0x170>
	}

	ticks = ((uint64_t)freq * timeout_us + 999999ULL) / 1000000ULL;
    c00045cc:	b9401be1 	ldr	w1, [sp, #24]
    c00045d0:	f9401be0 	ldr	x0, [sp, #48]
    c00045d4:	9b007c21 	mul	x1, x1, x0
    c00045d8:	d28847e0 	mov	x0, #0x423f                	// #16959
    c00045dc:	f2a001e0 	movk	x0, #0xf, lsl #16
    c00045e0:	8b000021 	add	x1, x1, x0
    c00045e4:	d2869b60 	mov	x0, #0x34db                	// #13531
    c00045e8:	f2baf6c0 	movk	x0, #0xd7b6, lsl #16
    c00045ec:	f2dbd040 	movk	x0, #0xde82, lsl #32
    c00045f0:	f2e86360 	movk	x0, #0x431b, lsl #48
    c00045f4:	9bc07c20 	umulh	x0, x1, x0
    c00045f8:	d352fc00 	lsr	x0, x0, #18
    c00045fc:	f9001fe0 	str	x0, [sp, #56]
	if (ticks == 0U) {
    c0004600:	f9401fe0 	ldr	x0, [sp, #56]
    c0004604:	f100001f 	cmp	x0, #0x0
    c0004608:	54000061 	b.ne	c0004614 <smp_wait_for_online+0xe0>  // b.any
		ticks = 1U;
    c000460c:	d2800020 	mov	x0, #0x1                   	// #1
    c0004610:	f9001fe0 	str	x0, [sp, #56]
	}

	start = smp_read_cntpct();
    c0004614:	97ffff5c 	bl	c0004384 <smp_read_cntpct>
    c0004618:	f90017e0 	str	x0, [sp, #40]
	while (!cpu_states[logical_id].online) {
    c000461c:	14000009 	b	c0004640 <smp_wait_for_online+0x10c>
		if ((smp_read_cntpct() - start) >= ticks) {
    c0004620:	97ffff59 	bl	c0004384 <smp_read_cntpct>
    c0004624:	aa0003e1 	mov	x1, x0
    c0004628:	f94017e0 	ldr	x0, [sp, #40]
    c000462c:	cb000020 	sub	x0, x1, x0
    c0004630:	f9401fe1 	ldr	x1, [sp, #56]
    c0004634:	eb00003f 	cmp	x1, x0
    c0004638:	54000229 	b.ls	c000467c <smp_wait_for_online+0x148>  // b.plast
			break;
		}
		smp_relax();
    c000463c:	97ffff58 	bl	c000439c <smp_relax>
	while (!cpu_states[logical_id].online) {
    c0004640:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c0004644:	912bc002 	add	x2, x0, #0xaf0
    c0004648:	b9401fe1 	ldr	w1, [sp, #28]
    c000464c:	aa0103e0 	mov	x0, x1
    c0004650:	d37ff800 	lsl	x0, x0, #1
    c0004654:	8b010000 	add	x0, x0, x1
    c0004658:	d37df000 	lsl	x0, x0, #3
    c000465c:	8b000040 	add	x0, x2, x0
    c0004660:	39404000 	ldrb	w0, [x0, #16]
    c0004664:	52000000 	eor	w0, w0, #0x1
    c0004668:	12001c00 	and	w0, w0, #0xff
    c000466c:	12000000 	and	w0, w0, #0x1
    c0004670:	7100001f 	cmp	w0, #0x0
    c0004674:	54fffd61 	b.ne	c0004620 <smp_wait_for_online+0xec>  // b.any
    c0004678:	14000002 	b	c0004680 <smp_wait_for_online+0x14c>
			break;
    c000467c:	d503201f 	nop
	}

	return cpu_states[logical_id].online;
    c0004680:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c0004684:	912bc002 	add	x2, x0, #0xaf0
    c0004688:	b9401fe1 	ldr	w1, [sp, #28]
    c000468c:	aa0103e0 	mov	x0, x1
    c0004690:	d37ff800 	lsl	x0, x0, #1
    c0004694:	8b010000 	add	x0, x0, x1
    c0004698:	d37df000 	lsl	x0, x0, #3
    c000469c:	8b000040 	add	x0, x2, x0
    c00046a0:	39404000 	ldrb	w0, [x0, #16]
}
    c00046a4:	a8c47bfd 	ldp	x29, x30, [sp], #64
    c00046a8:	d65f03c0 	ret

00000000c00046ac <smp_map_psci_result>:

static int smp_map_psci_result(int32_t ret)
{
    c00046ac:	d10043ff 	sub	sp, sp, #0x10
    c00046b0:	b9000fe0 	str	w0, [sp, #12]
	if (ret == PSCI_RET_SUCCESS) {
    c00046b4:	b9400fe0 	ldr	w0, [sp, #12]
    c00046b8:	7100001f 	cmp	w0, #0x0
    c00046bc:	54000061 	b.ne	c00046c8 <smp_map_psci_result+0x1c>  // b.any
		return SMP_START_OK;
    c00046c0:	52800000 	mov	w0, #0x0                   	// #0
    c00046c4:	14000016 	b	c000471c <smp_map_psci_result+0x70>
	}
	if (ret == PSCI_RET_ALREADY_ON) {
    c00046c8:	b9400fe0 	ldr	w0, [sp, #12]
    c00046cc:	3100101f 	cmn	w0, #0x4
    c00046d0:	54000061 	b.ne	c00046dc <smp_map_psci_result+0x30>  // b.any
		return SMP_START_ALREADY_ONLINE;
    c00046d4:	52800020 	mov	w0, #0x1                   	// #1
    c00046d8:	14000011 	b	c000471c <smp_map_psci_result+0x70>
	}
	if (ret == PSCI_RET_INVALID_PARAMS) {
    c00046dc:	b9400fe0 	ldr	w0, [sp, #12]
    c00046e0:	3100081f 	cmn	w0, #0x2
    c00046e4:	54000061 	b.ne	c00046f0 <smp_map_psci_result+0x44>  // b.any
		return SMP_START_INVALID_CPU;
    c00046e8:	12800000 	mov	w0, #0xffffffff            	// #-1
    c00046ec:	1400000c 	b	c000471c <smp_map_psci_result+0x70>
	}
	if (ret == PSCI_RET_DENIED) {
    c00046f0:	b9400fe0 	ldr	w0, [sp, #12]
    c00046f4:	31000c1f 	cmn	w0, #0x3
    c00046f8:	54000061 	b.ne	c0004704 <smp_map_psci_result+0x58>  // b.any
		return SMP_START_DENIED;
    c00046fc:	12800040 	mov	w0, #0xfffffffd            	// #-3
    c0004700:	14000007 	b	c000471c <smp_map_psci_result+0x70>
	}
	if (ret == PSCI_RET_NOT_SUPPORTED) {
    c0004704:	b9400fe0 	ldr	w0, [sp, #12]
    c0004708:	3100041f 	cmn	w0, #0x1
    c000470c:	54000061 	b.ne	c0004718 <smp_map_psci_result+0x6c>  // b.any
		return SMP_START_UNSUPPORTED;
    c0004710:	12800020 	mov	w0, #0xfffffffe            	// #-2
    c0004714:	14000002 	b	c000471c <smp_map_psci_result+0x70>
	}

	return SMP_START_FAILED;
    c0004718:	12800080 	mov	w0, #0xfffffffb            	// #-5
}
    c000471c:	910043ff 	add	sp, sp, #0x10
    c0004720:	d65f03c0 	ret

00000000c0004724 <smp_start_result_name>:

const char *smp_start_result_name(int result)
{
    c0004724:	d10043ff 	sub	sp, sp, #0x10
    c0004728:	b9000fe0 	str	w0, [sp, #12]
	if (result == SMP_START_OK) {
    c000472c:	b9400fe0 	ldr	w0, [sp, #12]
    c0004730:	7100001f 	cmp	w0, #0x0
    c0004734:	54000081 	b.ne	c0004744 <smp_start_result_name+0x20>  // b.any
		return "ok";
    c0004738:	d0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c000473c:	91280000 	add	x0, x0, #0xa00
    c0004740:	14000021 	b	c00047c4 <smp_start_result_name+0xa0>
	}
	if (result == SMP_START_ALREADY_ONLINE) {
    c0004744:	b9400fe0 	ldr	w0, [sp, #12]
    c0004748:	7100041f 	cmp	w0, #0x1
    c000474c:	54000081 	b.ne	c000475c <smp_start_result_name+0x38>  // b.any
		return "already-on";
    c0004750:	d0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0004754:	91282000 	add	x0, x0, #0xa08
    c0004758:	1400001b 	b	c00047c4 <smp_start_result_name+0xa0>
	}
	if (result == SMP_START_INVALID_CPU) {
    c000475c:	b9400fe0 	ldr	w0, [sp, #12]
    c0004760:	3100041f 	cmn	w0, #0x1
    c0004764:	54000081 	b.ne	c0004774 <smp_start_result_name+0x50>  // b.any
		return "invalid-params";
    c0004768:	d0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c000476c:	91286000 	add	x0, x0, #0xa18
    c0004770:	14000015 	b	c00047c4 <smp_start_result_name+0xa0>
	}
	if (result == SMP_START_UNSUPPORTED) {
    c0004774:	b9400fe0 	ldr	w0, [sp, #12]
    c0004778:	3100081f 	cmn	w0, #0x2
    c000477c:	54000081 	b.ne	c000478c <smp_start_result_name+0x68>  // b.any
		return "not-supported";
    c0004780:	d0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0004784:	9128a000 	add	x0, x0, #0xa28
    c0004788:	1400000f 	b	c00047c4 <smp_start_result_name+0xa0>
	}
	if (result == SMP_START_DENIED) {
    c000478c:	b9400fe0 	ldr	w0, [sp, #12]
    c0004790:	31000c1f 	cmn	w0, #0x3
    c0004794:	54000081 	b.ne	c00047a4 <smp_start_result_name+0x80>  // b.any
		return "denied";
    c0004798:	d0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c000479c:	9128e000 	add	x0, x0, #0xa38
    c00047a0:	14000009 	b	c00047c4 <smp_start_result_name+0xa0>
	}
	if (result == SMP_START_TIMEOUT) {
    c00047a4:	b9400fe0 	ldr	w0, [sp, #12]
    c00047a8:	3100101f 	cmn	w0, #0x4
    c00047ac:	54000081 	b.ne	c00047bc <smp_start_result_name+0x98>  // b.any
		return "timeout";
    c00047b0:	d0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c00047b4:	91290000 	add	x0, x0, #0xa40
    c00047b8:	14000003 	b	c00047c4 <smp_start_result_name+0xa0>
	}

	return "failed";
    c00047bc:	d0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c00047c0:	91292000 	add	x0, x0, #0xa48
}
    c00047c4:	910043ff 	add	sp, sp, #0x10
    c00047c8:	d65f03c0 	ret

00000000c00047cc <smp_init>:

void smp_init(void)
{
    c00047cc:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c00047d0:	910003fd 	mov	x29, sp
	unsigned int i;
	const struct cpu_topology_descriptor *boot_cpu = topology_boot_cpu();
    c00047d4:	94000280 	bl	c00051d4 <topology_boot_cpu>
    c00047d8:	f9000be0 	str	x0, [sp, #16]

	for (i = 0U; i < PLAT_MAX_CPUS; ++i) {
    c00047dc:	b9001fff 	str	wzr, [sp, #28]
    c00047e0:	1400003b 	b	c00048cc <smp_init+0x100>
		cpu_states[i].logical_id = i;
    c00047e4:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c00047e8:	912bc002 	add	x2, x0, #0xaf0
    c00047ec:	b9401fe1 	ldr	w1, [sp, #28]
    c00047f0:	aa0103e0 	mov	x0, x1
    c00047f4:	d37ff800 	lsl	x0, x0, #1
    c00047f8:	8b010000 	add	x0, x0, x1
    c00047fc:	d37df000 	lsl	x0, x0, #3
    c0004800:	8b000040 	add	x0, x2, x0
    c0004804:	b9401fe1 	ldr	w1, [sp, #28]
    c0004808:	b9000001 	str	w1, [x0]
		cpu_states[i].mpidr = 0U;
    c000480c:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c0004810:	912bc002 	add	x2, x0, #0xaf0
    c0004814:	b9401fe1 	ldr	w1, [sp, #28]
    c0004818:	aa0103e0 	mov	x0, x1
    c000481c:	d37ff800 	lsl	x0, x0, #1
    c0004820:	8b010000 	add	x0, x0, x1
    c0004824:	d37df000 	lsl	x0, x0, #3
    c0004828:	8b000040 	add	x0, x2, x0
    c000482c:	f900041f 	str	xzr, [x0, #8]
		cpu_states[i].online = false;
    c0004830:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c0004834:	912bc002 	add	x2, x0, #0xaf0
    c0004838:	b9401fe1 	ldr	w1, [sp, #28]
    c000483c:	aa0103e0 	mov	x0, x1
    c0004840:	d37ff800 	lsl	x0, x0, #1
    c0004844:	8b010000 	add	x0, x0, x1
    c0004848:	d37df000 	lsl	x0, x0, #3
    c000484c:	8b000040 	add	x0, x2, x0
    c0004850:	3900401f 	strb	wzr, [x0, #16]
		cpu_states[i].scheduled = false;
    c0004854:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c0004858:	912bc002 	add	x2, x0, #0xaf0
    c000485c:	b9401fe1 	ldr	w1, [sp, #28]
    c0004860:	aa0103e0 	mov	x0, x1
    c0004864:	d37ff800 	lsl	x0, x0, #1
    c0004868:	8b010000 	add	x0, x0, x1
    c000486c:	d37df000 	lsl	x0, x0, #3
    c0004870:	8b000040 	add	x0, x2, x0
    c0004874:	3900441f 	strb	wzr, [x0, #17]
		cpu_states[i].pending = false;
    c0004878:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c000487c:	912bc002 	add	x2, x0, #0xaf0
    c0004880:	b9401fe1 	ldr	w1, [sp, #28]
    c0004884:	aa0103e0 	mov	x0, x1
    c0004888:	d37ff800 	lsl	x0, x0, #1
    c000488c:	8b010000 	add	x0, x0, x1
    c0004890:	d37df000 	lsl	x0, x0, #3
    c0004894:	8b000040 	add	x0, x2, x0
    c0004898:	3900481f 	strb	wzr, [x0, #18]
		cpu_states[i].boot_cpu = false;
    c000489c:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c00048a0:	912bc002 	add	x2, x0, #0xaf0
    c00048a4:	b9401fe1 	ldr	w1, [sp, #28]
    c00048a8:	aa0103e0 	mov	x0, x1
    c00048ac:	d37ff800 	lsl	x0, x0, #1
    c00048b0:	8b010000 	add	x0, x0, x1
    c00048b4:	d37df000 	lsl	x0, x0, #3
    c00048b8:	8b000040 	add	x0, x2, x0
    c00048bc:	39004c1f 	strb	wzr, [x0, #19]
	for (i = 0U; i < PLAT_MAX_CPUS; ++i) {
    c00048c0:	b9401fe0 	ldr	w0, [sp, #28]
    c00048c4:	11000400 	add	w0, w0, #0x1
    c00048c8:	b9001fe0 	str	w0, [sp, #28]
    c00048cc:	b9401fe0 	ldr	w0, [sp, #28]
    c00048d0:	71001c1f 	cmp	w0, #0x7
    c00048d4:	54fff889 	b.ls	c00047e4 <smp_init+0x18>  // b.plast
	}

	cpu_states[0].logical_id = 0U;
    c00048d8:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c00048dc:	912bc000 	add	x0, x0, #0xaf0
    c00048e0:	b900001f 	str	wzr, [x0]
	cpu_states[0].mpidr = boot_cpu->mpidr;
    c00048e4:	f9400be0 	ldr	x0, [sp, #16]
    c00048e8:	f9400001 	ldr	x1, [x0]
    c00048ec:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c00048f0:	912bc000 	add	x0, x0, #0xaf0
    c00048f4:	f9000401 	str	x1, [x0, #8]
	cpu_states[0].boot_cpu = true;
    c00048f8:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c00048fc:	912bc000 	add	x0, x0, #0xaf0
    c0004900:	52800021 	mov	w1, #0x1                   	// #1
    c0004904:	39004c01 	strb	w1, [x0, #19]
	cpu_states[0].online = true;
    c0004908:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c000490c:	912bc000 	add	x0, x0, #0xaf0
    c0004910:	52800021 	mov	w1, #0x1                   	// #1
    c0004914:	39004001 	strb	w1, [x0, #16]
	cpu_states[0].scheduled = true;
    c0004918:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c000491c:	912bc000 	add	x0, x0, #0xaf0
    c0004920:	52800021 	mov	w1, #0x1                   	// #1
    c0004924:	39004401 	strb	w1, [x0, #17]
	online_cpu_count = 1U;
    c0004928:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c000492c:	912ec000 	add	x0, x0, #0xbb0
    c0004930:	52800021 	mov	w1, #0x1                   	// #1
    c0004934:	b9000001 	str	w1, [x0]
}
    c0004938:	d503201f 	nop
    c000493c:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c0004940:	d65f03c0 	ret

00000000c0004944 <smp_start_cpu>:

int smp_start_cpu(uint64_t mpidr, unsigned int *logical_id, int32_t *smc_ret)
{
    c0004944:	a9bb7bfd 	stp	x29, x30, [sp, #-80]!
    c0004948:	910003fd 	mov	x29, sp
    c000494c:	f90017e0 	str	x0, [sp, #40]
    c0004950:	f90013e1 	str	x1, [sp, #32]
    c0004954:	f9000fe2 	str	x2, [sp, #24]
	const struct cpu_topology_descriptor *cpu;
	int slot;
	int32_t ret;
	int result;
	bool new_cpu = false;
    c0004958:	39013fff 	strb	wzr, [sp, #79]

	if ((logical_id == (unsigned int *)0) || (smc_ret == (int32_t *)0)) {
    c000495c:	f94013e0 	ldr	x0, [sp, #32]
    c0004960:	f100001f 	cmp	x0, #0x0
    c0004964:	54000080 	b.eq	c0004974 <smp_start_cpu+0x30>  // b.none
    c0004968:	f9400fe0 	ldr	x0, [sp, #24]
    c000496c:	f100001f 	cmp	x0, #0x0
    c0004970:	54000061 	b.ne	c000497c <smp_start_cpu+0x38>  // b.any
		return SMP_START_FAILED;
    c0004974:	12800080 	mov	w0, #0xfffffffb            	// #-5
    c0004978:	1400011c 	b	c0004de8 <smp_start_cpu+0x4a4>
	}

	*smc_ret = 0;
    c000497c:	f9400fe0 	ldr	x0, [sp, #24]
    c0004980:	b900001f 	str	wzr, [x0]
	cpu = topology_find_cpu_by_mpidr(mpidr);
    c0004984:	f94017e0 	ldr	x0, [sp, #40]
    c0004988:	94000224 	bl	c0005218 <topology_find_cpu_by_mpidr>
    c000498c:	f90023e0 	str	x0, [sp, #64]
	if (cpu != (const struct cpu_topology_descriptor *)0) {
    c0004990:	f94023e0 	ldr	x0, [sp, #64]
    c0004994:	f100001f 	cmp	x0, #0x0
    c0004998:	54000300 	b.eq	c00049f8 <smp_start_cpu+0xb4>  // b.none
		*logical_id = cpu->logical_id;
    c000499c:	f94023e0 	ldr	x0, [sp, #64]
    c00049a0:	b9400801 	ldr	w1, [x0, #8]
    c00049a4:	f94013e0 	ldr	x0, [sp, #32]
    c00049a8:	b9000001 	str	w1, [x0]
		if (cpu_states[cpu->logical_id].online) {
    c00049ac:	f94023e0 	ldr	x0, [sp, #64]
    c00049b0:	b9400801 	ldr	w1, [x0, #8]
    c00049b4:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c00049b8:	912bc002 	add	x2, x0, #0xaf0
    c00049bc:	2a0103e1 	mov	w1, w1
    c00049c0:	aa0103e0 	mov	x0, x1
    c00049c4:	d37ff800 	lsl	x0, x0, #1
    c00049c8:	8b010000 	add	x0, x0, x1
    c00049cc:	d37df000 	lsl	x0, x0, #3
    c00049d0:	8b000040 	add	x0, x2, x0
    c00049d4:	39404000 	ldrb	w0, [x0, #16]
    c00049d8:	12000000 	and	w0, w0, #0x1
    c00049dc:	7100001f 	cmp	w0, #0x0
    c00049e0:	54000760 	b.eq	c0004acc <smp_start_cpu+0x188>  // b.none
			*smc_ret = PSCI_RET_ALREADY_ON;
    c00049e4:	f9400fe0 	ldr	x0, [sp, #24]
    c00049e8:	12800061 	mov	w1, #0xfffffffc            	// #-4
    c00049ec:	b9000001 	str	w1, [x0]
			return SMP_START_ALREADY_ONLINE;
    c00049f0:	52800020 	mov	w0, #0x1                   	// #1
    c00049f4:	140000fd 	b	c0004de8 <smp_start_cpu+0x4a4>
		}
	} else {
		slot = smp_find_free_logical_slot();
    c00049f8:	97fffe78 	bl	c00043d8 <smp_find_free_logical_slot>
    c00049fc:	b9003fe0 	str	w0, [sp, #60]
		if (slot < 0) {
    c0004a00:	b9403fe0 	ldr	w0, [sp, #60]
    c0004a04:	7100001f 	cmp	w0, #0x0
    c0004a08:	5400006a 	b.ge	c0004a14 <smp_start_cpu+0xd0>  // b.tcont
			return SMP_START_INVALID_CPU;
    c0004a0c:	12800000 	mov	w0, #0xffffffff            	// #-1
    c0004a10:	140000f6 	b	c0004de8 <smp_start_cpu+0x4a4>
		}
		*logical_id = (unsigned int)slot;
    c0004a14:	b9403fe1 	ldr	w1, [sp, #60]
    c0004a18:	f94013e0 	ldr	x0, [sp, #32]
    c0004a1c:	b9000001 	str	w1, [x0]
		new_cpu = true;
    c0004a20:	52800020 	mov	w0, #0x1                   	// #1
    c0004a24:	39013fe0 	strb	w0, [sp, #79]

		topology_register_cpu(*logical_id, mpidr, false);
    c0004a28:	f94013e0 	ldr	x0, [sp, #32]
    c0004a2c:	b9400000 	ldr	w0, [x0]
    c0004a30:	52800002 	mov	w2, #0x0                   	// #0
    c0004a34:	f94017e1 	ldr	x1, [sp, #40]
    c0004a38:	94000289 	bl	c000545c <topology_register_cpu>
		cpu_states[*logical_id].logical_id = *logical_id;
    c0004a3c:	f94013e0 	ldr	x0, [sp, #32]
    c0004a40:	b9400001 	ldr	w1, [x0]
    c0004a44:	f94013e0 	ldr	x0, [sp, #32]
    c0004a48:	b9400002 	ldr	w2, [x0]
    c0004a4c:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c0004a50:	912bc003 	add	x3, x0, #0xaf0
    c0004a54:	2a0103e1 	mov	w1, w1
    c0004a58:	aa0103e0 	mov	x0, x1
    c0004a5c:	d37ff800 	lsl	x0, x0, #1
    c0004a60:	8b010000 	add	x0, x0, x1
    c0004a64:	d37df000 	lsl	x0, x0, #3
    c0004a68:	8b000060 	add	x0, x3, x0
    c0004a6c:	b9000002 	str	w2, [x0]
		cpu_states[*logical_id].mpidr = mpidr;
    c0004a70:	f94013e0 	ldr	x0, [sp, #32]
    c0004a74:	b9400001 	ldr	w1, [x0]
    c0004a78:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c0004a7c:	912bc002 	add	x2, x0, #0xaf0
    c0004a80:	2a0103e1 	mov	w1, w1
    c0004a84:	aa0103e0 	mov	x0, x1
    c0004a88:	d37ff800 	lsl	x0, x0, #1
    c0004a8c:	8b010000 	add	x0, x0, x1
    c0004a90:	d37df000 	lsl	x0, x0, #3
    c0004a94:	8b000040 	add	x0, x2, x0
    c0004a98:	f94017e1 	ldr	x1, [sp, #40]
    c0004a9c:	f9000401 	str	x1, [x0, #8]
		cpu_states[*logical_id].boot_cpu = false;
    c0004aa0:	f94013e0 	ldr	x0, [sp, #32]
    c0004aa4:	b9400001 	ldr	w1, [x0]
    c0004aa8:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c0004aac:	912bc002 	add	x2, x0, #0xaf0
    c0004ab0:	2a0103e1 	mov	w1, w1
    c0004ab4:	aa0103e0 	mov	x0, x1
    c0004ab8:	d37ff800 	lsl	x0, x0, #1
    c0004abc:	8b010000 	add	x0, x0, x1
    c0004ac0:	d37df000 	lsl	x0, x0, #3
    c0004ac4:	8b000040 	add	x0, x2, x0
    c0004ac8:	39004c1f 	strb	wzr, [x0, #19]
	}

	cpu_states[*logical_id].pending = true;
    c0004acc:	f94013e0 	ldr	x0, [sp, #32]
    c0004ad0:	b9400001 	ldr	w1, [x0]
    c0004ad4:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c0004ad8:	912bc002 	add	x2, x0, #0xaf0
    c0004adc:	2a0103e1 	mov	w1, w1
    c0004ae0:	aa0103e0 	mov	x0, x1
    c0004ae4:	d37ff800 	lsl	x0, x0, #1
    c0004ae8:	8b010000 	add	x0, x0, x1
    c0004aec:	d37df000 	lsl	x0, x0, #3
    c0004af0:	8b000040 	add	x0, x2, x0
    c0004af4:	52800021 	mov	w1, #0x1                   	// #1
    c0004af8:	39004801 	strb	w1, [x0, #18]
	cpu_states[*logical_id].online = false;
    c0004afc:	f94013e0 	ldr	x0, [sp, #32]
    c0004b00:	b9400001 	ldr	w1, [x0]
    c0004b04:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c0004b08:	912bc002 	add	x2, x0, #0xaf0
    c0004b0c:	2a0103e1 	mov	w1, w1
    c0004b10:	aa0103e0 	mov	x0, x1
    c0004b14:	d37ff800 	lsl	x0, x0, #1
    c0004b18:	8b010000 	add	x0, x0, x1
    c0004b1c:	d37df000 	lsl	x0, x0, #3
    c0004b20:	8b000040 	add	x0, x2, x0
    c0004b24:	3900401f 	strb	wzr, [x0, #16]
	cpu_states[*logical_id].scheduled = false;
    c0004b28:	f94013e0 	ldr	x0, [sp, #32]
    c0004b2c:	b9400001 	ldr	w1, [x0]
    c0004b30:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c0004b34:	912bc002 	add	x2, x0, #0xaf0
    c0004b38:	2a0103e1 	mov	w1, w1
    c0004b3c:	aa0103e0 	mov	x0, x1
    c0004b40:	d37ff800 	lsl	x0, x0, #1
    c0004b44:	8b010000 	add	x0, x0, x1
    c0004b48:	d37df000 	lsl	x0, x0, #3
    c0004b4c:	8b000040 	add	x0, x2, x0
    c0004b50:	3900441f 	strb	wzr, [x0, #17]

	ret = smp_smc_call(PSCI_CPU_ON_64, mpidr,
    c0004b54:	90ffffe0 	adrp	x0, c0000000 <_start>
    c0004b58:	91008001 	add	x1, x0, #0x20
			   (uintptr_t)secondary_cpu_entrypoint,
			   *logical_id);
    c0004b5c:	f94013e0 	ldr	x0, [sp, #32]
    c0004b60:	b9400000 	ldr	w0, [x0]
	ret = smp_smc_call(PSCI_CPU_ON_64, mpidr,
    c0004b64:	2a0003e0 	mov	w0, w0
    c0004b68:	aa0003e3 	mov	x3, x0
    c0004b6c:	aa0103e2 	mov	x2, x1
    c0004b70:	f94017e1 	ldr	x1, [sp, #40]
    c0004b74:	d2800060 	mov	x0, #0x3                   	// #3
    c0004b78:	f2b88000 	movk	x0, #0xc400, lsl #16
    c0004b7c:	97fffe0b 	bl	c00043a8 <smp_smc_call>
    c0004b80:	b9003be0 	str	w0, [sp, #56]
	*smc_ret = ret;
    c0004b84:	f9400fe0 	ldr	x0, [sp, #24]
    c0004b88:	b9403be1 	ldr	w1, [sp, #56]
    c0004b8c:	b9000001 	str	w1, [x0]
	result = smp_map_psci_result(ret);
    c0004b90:	b9403be0 	ldr	w0, [sp, #56]
    c0004b94:	97fffec6 	bl	c00046ac <smp_map_psci_result>
    c0004b98:	b90037e0 	str	w0, [sp, #52]

	if (result == SMP_START_OK) {
    c0004b9c:	b94037e0 	ldr	w0, [sp, #52]
    c0004ba0:	7100001f 	cmp	w0, #0x0
    c0004ba4:	540004a1 	b.ne	c0004c38 <smp_start_cpu+0x2f4>  // b.any
		if (!smp_wait_for_online(*logical_id, SMP_CPU_ON_TIMEOUT_US)) {
    c0004ba8:	f94013e0 	ldr	x0, [sp, #32]
    c0004bac:	b9400000 	ldr	w0, [x0]
    c0004bb0:	5290d401 	mov	w1, #0x86a0                	// #34464
    c0004bb4:	72a00021 	movk	w1, #0x1, lsl #16
    c0004bb8:	97fffe5f 	bl	c0004534 <smp_wait_for_online>
    c0004bbc:	12001c00 	and	w0, w0, #0xff
    c0004bc0:	52000000 	eor	w0, w0, #0x1
    c0004bc4:	12001c00 	and	w0, w0, #0xff
    c0004bc8:	12000000 	and	w0, w0, #0x1
    c0004bcc:	7100001f 	cmp	w0, #0x0
    c0004bd0:	54000300 	b.eq	c0004c30 <smp_start_cpu+0x2ec>  // b.none
			cpu_states[*logical_id].pending = false;
    c0004bd4:	f94013e0 	ldr	x0, [sp, #32]
    c0004bd8:	b9400001 	ldr	w1, [x0]
    c0004bdc:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c0004be0:	912bc002 	add	x2, x0, #0xaf0
    c0004be4:	2a0103e1 	mov	w1, w1
    c0004be8:	aa0103e0 	mov	x0, x1
    c0004bec:	d37ff800 	lsl	x0, x0, #1
    c0004bf0:	8b010000 	add	x0, x0, x1
    c0004bf4:	d37df000 	lsl	x0, x0, #3
    c0004bf8:	8b000040 	add	x0, x2, x0
    c0004bfc:	3900481f 	strb	wzr, [x0, #18]
			if (new_cpu) {
    c0004c00:	39413fe0 	ldrb	w0, [sp, #79]
    c0004c04:	12000000 	and	w0, w0, #0x1
    c0004c08:	7100001f 	cmp	w0, #0x0
    c0004c0c:	540000e0 	b.eq	c0004c28 <smp_start_cpu+0x2e4>  // b.none
				topology_unregister_cpu(*logical_id);
    c0004c10:	f94013e0 	ldr	x0, [sp, #32]
    c0004c14:	b9400000 	ldr	w0, [x0]
    c0004c18:	94000245 	bl	c000552c <topology_unregister_cpu>
				smp_reset_cpu_state(*logical_id);
    c0004c1c:	f94013e0 	ldr	x0, [sp, #32]
    c0004c20:	b9400000 	ldr	w0, [x0]
    c0004c24:	97fffe04 	bl	c0004434 <smp_reset_cpu_state>
			}
			return SMP_START_TIMEOUT;
    c0004c28:	12800060 	mov	w0, #0xfffffffc            	// #-4
    c0004c2c:	1400006f 	b	c0004de8 <smp_start_cpu+0x4a4>
		}
		return SMP_START_OK;
    c0004c30:	52800000 	mov	w0, #0x0                   	// #0
    c0004c34:	1400006d 	b	c0004de8 <smp_start_cpu+0x4a4>
	}

	if (result == SMP_START_ALREADY_ONLINE) {
    c0004c38:	b94037e0 	ldr	w0, [sp, #52]
    c0004c3c:	7100041f 	cmp	w0, #0x1
    c0004c40:	54000a81 	b.ne	c0004d90 <smp_start_cpu+0x44c>  // b.any
		cpu_states[*logical_id].pending = false;
    c0004c44:	f94013e0 	ldr	x0, [sp, #32]
    c0004c48:	b9400001 	ldr	w1, [x0]
    c0004c4c:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c0004c50:	912bc002 	add	x2, x0, #0xaf0
    c0004c54:	2a0103e1 	mov	w1, w1
    c0004c58:	aa0103e0 	mov	x0, x1
    c0004c5c:	d37ff800 	lsl	x0, x0, #1
    c0004c60:	8b010000 	add	x0, x0, x1
    c0004c64:	d37df000 	lsl	x0, x0, #3
    c0004c68:	8b000040 	add	x0, x2, x0
    c0004c6c:	3900481f 	strb	wzr, [x0, #18]

		/*
		 * 不能单凭 TF-A 返回 already-on 就认定 secondary 已经真正进入 mini-os。
		 * 只有 boot cpu 才天然成立；对于新注册但没观察到 online 的核，必须回滚。
		 */
		if (cpu_states[*logical_id].boot_cpu) {
    c0004c70:	f94013e0 	ldr	x0, [sp, #32]
    c0004c74:	b9400001 	ldr	w1, [x0]
    c0004c78:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c0004c7c:	912bc002 	add	x2, x0, #0xaf0
    c0004c80:	2a0103e1 	mov	w1, w1
    c0004c84:	aa0103e0 	mov	x0, x1
    c0004c88:	d37ff800 	lsl	x0, x0, #1
    c0004c8c:	8b010000 	add	x0, x0, x1
    c0004c90:	d37df000 	lsl	x0, x0, #3
    c0004c94:	8b000040 	add	x0, x2, x0
    c0004c98:	39404c00 	ldrb	w0, [x0, #19]
    c0004c9c:	12000000 	and	w0, w0, #0x1
    c0004ca0:	7100001f 	cmp	w0, #0x0
    c0004ca4:	540003e0 	b.eq	c0004d20 <smp_start_cpu+0x3dc>  // b.none
			cpu_states[*logical_id].online = true;
    c0004ca8:	f94013e0 	ldr	x0, [sp, #32]
    c0004cac:	b9400001 	ldr	w1, [x0]
    c0004cb0:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c0004cb4:	912bc002 	add	x2, x0, #0xaf0
    c0004cb8:	2a0103e1 	mov	w1, w1
    c0004cbc:	aa0103e0 	mov	x0, x1
    c0004cc0:	d37ff800 	lsl	x0, x0, #1
    c0004cc4:	8b010000 	add	x0, x0, x1
    c0004cc8:	d37df000 	lsl	x0, x0, #3
    c0004ccc:	8b000040 	add	x0, x2, x0
    c0004cd0:	52800021 	mov	w1, #0x1                   	// #1
    c0004cd4:	39004001 	strb	w1, [x0, #16]
			cpu_states[*logical_id].scheduled = true;
    c0004cd8:	f94013e0 	ldr	x0, [sp, #32]
    c0004cdc:	b9400001 	ldr	w1, [x0]
    c0004ce0:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c0004ce4:	912bc002 	add	x2, x0, #0xaf0
    c0004ce8:	2a0103e1 	mov	w1, w1
    c0004cec:	aa0103e0 	mov	x0, x1
    c0004cf0:	d37ff800 	lsl	x0, x0, #1
    c0004cf4:	8b010000 	add	x0, x0, x1
    c0004cf8:	d37df000 	lsl	x0, x0, #3
    c0004cfc:	8b000040 	add	x0, x2, x0
    c0004d00:	52800021 	mov	w1, #0x1                   	// #1
    c0004d04:	39004401 	strb	w1, [x0, #17]
			topology_mark_cpu_online(*logical_id, true);
    c0004d08:	f94013e0 	ldr	x0, [sp, #32]
    c0004d0c:	b9400000 	ldr	w0, [x0]
    c0004d10:	52800021 	mov	w1, #0x1                   	// #1
    c0004d14:	94000170 	bl	c00052d4 <topology_mark_cpu_online>
			return SMP_START_ALREADY_ONLINE;
    c0004d18:	52800020 	mov	w0, #0x1                   	// #1
    c0004d1c:	14000033 	b	c0004de8 <smp_start_cpu+0x4a4>
		}

		if (!cpu_states[*logical_id].online && new_cpu) {
    c0004d20:	f94013e0 	ldr	x0, [sp, #32]
    c0004d24:	b9400001 	ldr	w1, [x0]
    c0004d28:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c0004d2c:	912bc002 	add	x2, x0, #0xaf0
    c0004d30:	2a0103e1 	mov	w1, w1
    c0004d34:	aa0103e0 	mov	x0, x1
    c0004d38:	d37ff800 	lsl	x0, x0, #1
    c0004d3c:	8b010000 	add	x0, x0, x1
    c0004d40:	d37df000 	lsl	x0, x0, #3
    c0004d44:	8b000040 	add	x0, x2, x0
    c0004d48:	39404000 	ldrb	w0, [x0, #16]
    c0004d4c:	52000000 	eor	w0, w0, #0x1
    c0004d50:	12001c00 	and	w0, w0, #0xff
    c0004d54:	12000000 	and	w0, w0, #0x1
    c0004d58:	7100001f 	cmp	w0, #0x0
    c0004d5c:	54000160 	b.eq	c0004d88 <smp_start_cpu+0x444>  // b.none
    c0004d60:	39413fe0 	ldrb	w0, [sp, #79]
    c0004d64:	12000000 	and	w0, w0, #0x1
    c0004d68:	7100001f 	cmp	w0, #0x0
    c0004d6c:	540000e0 	b.eq	c0004d88 <smp_start_cpu+0x444>  // b.none
			topology_unregister_cpu(*logical_id);
    c0004d70:	f94013e0 	ldr	x0, [sp, #32]
    c0004d74:	b9400000 	ldr	w0, [x0]
    c0004d78:	940001ed 	bl	c000552c <topology_unregister_cpu>
			smp_reset_cpu_state(*logical_id);
    c0004d7c:	f94013e0 	ldr	x0, [sp, #32]
    c0004d80:	b9400000 	ldr	w0, [x0]
    c0004d84:	97fffdac 	bl	c0004434 <smp_reset_cpu_state>
		}

		return SMP_START_ALREADY_ONLINE;
    c0004d88:	52800020 	mov	w0, #0x1                   	// #1
    c0004d8c:	14000017 	b	c0004de8 <smp_start_cpu+0x4a4>
	}

	cpu_states[*logical_id].pending = false;
    c0004d90:	f94013e0 	ldr	x0, [sp, #32]
    c0004d94:	b9400001 	ldr	w1, [x0]
    c0004d98:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c0004d9c:	912bc002 	add	x2, x0, #0xaf0
    c0004da0:	2a0103e1 	mov	w1, w1
    c0004da4:	aa0103e0 	mov	x0, x1
    c0004da8:	d37ff800 	lsl	x0, x0, #1
    c0004dac:	8b010000 	add	x0, x0, x1
    c0004db0:	d37df000 	lsl	x0, x0, #3
    c0004db4:	8b000040 	add	x0, x2, x0
    c0004db8:	3900481f 	strb	wzr, [x0, #18]

	if (new_cpu) {
    c0004dbc:	39413fe0 	ldrb	w0, [sp, #79]
    c0004dc0:	12000000 	and	w0, w0, #0x1
    c0004dc4:	7100001f 	cmp	w0, #0x0
    c0004dc8:	540000e0 	b.eq	c0004de4 <smp_start_cpu+0x4a0>  // b.none
		topology_unregister_cpu(*logical_id);
    c0004dcc:	f94013e0 	ldr	x0, [sp, #32]
    c0004dd0:	b9400000 	ldr	w0, [x0]
    c0004dd4:	940001d6 	bl	c000552c <topology_unregister_cpu>
		smp_reset_cpu_state(*logical_id);
    c0004dd8:	f94013e0 	ldr	x0, [sp, #32]
    c0004ddc:	b9400000 	ldr	w0, [x0]
    c0004de0:	97fffd95 	bl	c0004434 <smp_reset_cpu_state>
	}

	return result;
    c0004de4:	b94037e0 	ldr	w0, [sp, #52]
}
    c0004de8:	a8c57bfd 	ldp	x29, x30, [sp], #80
    c0004dec:	d65f03c0 	ret

00000000c0004df0 <smp_cpu_state>:

const struct smp_cpu_state *smp_cpu_state(unsigned int logical_id)
{
    c0004df0:	d10043ff 	sub	sp, sp, #0x10
    c0004df4:	b9000fe0 	str	w0, [sp, #12]
	if (logical_id >= PLAT_MAX_CPUS) {
    c0004df8:	b9400fe0 	ldr	w0, [sp, #12]
    c0004dfc:	71001c1f 	cmp	w0, #0x7
    c0004e00:	54000069 	b.ls	c0004e0c <smp_cpu_state+0x1c>  // b.plast
		return (const struct smp_cpu_state *)0;
    c0004e04:	d2800000 	mov	x0, #0x0                   	// #0
    c0004e08:	14000009 	b	c0004e2c <smp_cpu_state+0x3c>
	}

	return &cpu_states[logical_id];
    c0004e0c:	b9400fe1 	ldr	w1, [sp, #12]
    c0004e10:	aa0103e0 	mov	x0, x1
    c0004e14:	d37ff800 	lsl	x0, x0, #1
    c0004e18:	8b010000 	add	x0, x0, x1
    c0004e1c:	d37df000 	lsl	x0, x0, #3
    c0004e20:	d0000041 	adrp	x1, c000e000 <secondary_stacks+0x7510>
    c0004e24:	912bc021 	add	x1, x1, #0xaf0
    c0004e28:	8b010000 	add	x0, x0, x1
}
    c0004e2c:	910043ff 	add	sp, sp, #0x10
    c0004e30:	d65f03c0 	ret

00000000c0004e34 <smp_online_cpu_count>:

unsigned int smp_online_cpu_count(void)
{
	return online_cpu_count;
    c0004e34:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c0004e38:	912ec000 	add	x0, x0, #0xbb0
    c0004e3c:	b9400000 	ldr	w0, [x0]
}
    c0004e40:	d65f03c0 	ret

00000000c0004e44 <smp_secondary_cpu_online>:

void smp_secondary_cpu_online(unsigned int logical_id)
{
    c0004e44:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c0004e48:	910003fd 	mov	x29, sp
    c0004e4c:	b9001fe0 	str	w0, [sp, #28]
	if ((logical_id >= PLAT_MAX_CPUS) || cpu_states[logical_id].online) {
    c0004e50:	b9401fe0 	ldr	w0, [sp, #28]
    c0004e54:	71001c1f 	cmp	w0, #0x7
    c0004e58:	540006e8 	b.hi	c0004f34 <smp_secondary_cpu_online+0xf0>  // b.pmore
    c0004e5c:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c0004e60:	912bc002 	add	x2, x0, #0xaf0
    c0004e64:	b9401fe1 	ldr	w1, [sp, #28]
    c0004e68:	aa0103e0 	mov	x0, x1
    c0004e6c:	d37ff800 	lsl	x0, x0, #1
    c0004e70:	8b010000 	add	x0, x0, x1
    c0004e74:	d37df000 	lsl	x0, x0, #3
    c0004e78:	8b000040 	add	x0, x2, x0
    c0004e7c:	39404000 	ldrb	w0, [x0, #16]
    c0004e80:	12000000 	and	w0, w0, #0x1
    c0004e84:	7100001f 	cmp	w0, #0x0
    c0004e88:	54000561 	b.ne	c0004f34 <smp_secondary_cpu_online+0xf0>  // b.any
		return;
	}

	cpu_states[logical_id].pending = false;
    c0004e8c:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c0004e90:	912bc002 	add	x2, x0, #0xaf0
    c0004e94:	b9401fe1 	ldr	w1, [sp, #28]
    c0004e98:	aa0103e0 	mov	x0, x1
    c0004e9c:	d37ff800 	lsl	x0, x0, #1
    c0004ea0:	8b010000 	add	x0, x0, x1
    c0004ea4:	d37df000 	lsl	x0, x0, #3
    c0004ea8:	8b000040 	add	x0, x2, x0
    c0004eac:	3900481f 	strb	wzr, [x0, #18]
	cpu_states[logical_id].online = true;
    c0004eb0:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c0004eb4:	912bc002 	add	x2, x0, #0xaf0
    c0004eb8:	b9401fe1 	ldr	w1, [sp, #28]
    c0004ebc:	aa0103e0 	mov	x0, x1
    c0004ec0:	d37ff800 	lsl	x0, x0, #1
    c0004ec4:	8b010000 	add	x0, x0, x1
    c0004ec8:	d37df000 	lsl	x0, x0, #3
    c0004ecc:	8b000040 	add	x0, x2, x0
    c0004ed0:	52800021 	mov	w1, #0x1                   	// #1
    c0004ed4:	39004001 	strb	w1, [x0, #16]
	cpu_states[logical_id].scheduled = true;
    c0004ed8:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c0004edc:	912bc002 	add	x2, x0, #0xaf0
    c0004ee0:	b9401fe1 	ldr	w1, [sp, #28]
    c0004ee4:	aa0103e0 	mov	x0, x1
    c0004ee8:	d37ff800 	lsl	x0, x0, #1
    c0004eec:	8b010000 	add	x0, x0, x1
    c0004ef0:	d37df000 	lsl	x0, x0, #3
    c0004ef4:	8b000040 	add	x0, x2, x0
    c0004ef8:	52800021 	mov	w1, #0x1                   	// #1
    c0004efc:	39004401 	strb	w1, [x0, #17]
	online_cpu_count++;
    c0004f00:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c0004f04:	912ec000 	add	x0, x0, #0xbb0
    c0004f08:	b9400000 	ldr	w0, [x0]
    c0004f0c:	11000401 	add	w1, w0, #0x1
    c0004f10:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c0004f14:	912ec000 	add	x0, x0, #0xbb0
    c0004f18:	b9000001 	str	w1, [x0]
	topology_mark_cpu_online(logical_id, true);
    c0004f1c:	52800021 	mov	w1, #0x1                   	// #1
    c0004f20:	b9401fe0 	ldr	w0, [sp, #28]
    c0004f24:	940000ec 	bl	c00052d4 <topology_mark_cpu_online>
	scheduler_join_cpu(logical_id);
    c0004f28:	b9401fe0 	ldr	w0, [sp, #28]
    c0004f2c:	97fff760 	bl	c0002cac <scheduler_join_cpu>
    c0004f30:	14000002 	b	c0004f38 <smp_secondary_cpu_online+0xf4>
		return;
    c0004f34:	d503201f 	nop
}
    c0004f38:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c0004f3c:	d65f03c0 	ret

00000000c0004f40 <smp_secondary_entry>:

void smp_secondary_entry(uint64_t logical_id)
{
    c0004f40:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
    c0004f44:	910003fd 	mov	x29, sp
    c0004f48:	a90153f3 	stp	x19, x20, [sp, #16]
    c0004f4c:	f90017e0 	str	x0, [sp, #40]
	smp_secondary_cpu_online((unsigned int)logical_id);
    c0004f50:	f94017e0 	ldr	x0, [sp, #40]
    c0004f54:	97ffffbc 	bl	c0004e44 <smp_secondary_cpu_online>
	mini_os_printf("secondary cpu%u online (mpidr=0x%llx), scheduler runnable=%u\n",
    c0004f58:	f94017e0 	ldr	x0, [sp, #40]
    c0004f5c:	2a0003f4 	mov	w20, w0
		       (unsigned int)logical_id,
		       (unsigned long long)cpu_states[logical_id].mpidr,
    c0004f60:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c0004f64:	912bc002 	add	x2, x0, #0xaf0
    c0004f68:	f94017e1 	ldr	x1, [sp, #40]
    c0004f6c:	aa0103e0 	mov	x0, x1
    c0004f70:	d37ff800 	lsl	x0, x0, #1
    c0004f74:	8b010000 	add	x0, x0, x1
    c0004f78:	d37df000 	lsl	x0, x0, #3
    c0004f7c:	8b000040 	add	x0, x2, x0
    c0004f80:	f9400413 	ldr	x19, [x0, #8]
	mini_os_printf("secondary cpu%u online (mpidr=0x%llx), scheduler runnable=%u\n",
    c0004f84:	97fff772 	bl	c0002d4c <scheduler_runnable_cpu_count>
    c0004f88:	2a0003e3 	mov	w3, w0
    c0004f8c:	aa1303e2 	mov	x2, x19
    c0004f90:	2a1403e1 	mov	w1, w20
    c0004f94:	d0000000 	adrp	x0, c0006000 <hex.0+0x8e8>
    c0004f98:	91294000 	add	x0, x0, #0xa50
    c0004f9c:	97fff356 	bl	c0001cf4 <mini_os_printf>
		       scheduler_runnable_cpu_count());

	for (;;) {
		__asm__ volatile ("wfe");
    c0004fa0:	d503205f 	wfe
    c0004fa4:	17ffffff 	b	c0004fa0 <smp_secondary_entry+0x60>

00000000c0004fa8 <smp_secondary_entrypoint>:
	}
}

uintptr_t smp_secondary_entrypoint(void)
{
	return (uintptr_t)secondary_cpu_entrypoint;
    c0004fa8:	90ffffe0 	adrp	x0, c0000000 <_start>
    c0004fac:	91008000 	add	x0, x0, #0x20
    c0004fb0:	d65f03c0 	ret

00000000c0004fb4 <test_framework_init>:
#include <kernel/test.h>

void test_framework_init(void)
{
    c0004fb4:	d503201f 	nop
    c0004fb8:	d65f03c0 	ret

00000000c0004fbc <topology_read_mpidr>:
static struct cpu_topology_descriptor cpu_descs[PLAT_MAX_CPUS];
static unsigned int present_cpu_count;
static unsigned int online_cpu_count;

static inline uint64_t topology_read_mpidr(void)
{
    c0004fbc:	d10043ff 	sub	sp, sp, #0x10
	uint64_t mpidr;

	__asm__ volatile ("mrs %0, mpidr_el1" : "=r" (mpidr));
    c0004fc0:	d53800a0 	mrs	x0, mpidr_el1
    c0004fc4:	f90007e0 	str	x0, [sp, #8]
	return mpidr;
    c0004fc8:	f94007e0 	ldr	x0, [sp, #8]
}
    c0004fcc:	910043ff 	add	sp, sp, #0x10
    c0004fd0:	d65f03c0 	ret

00000000c0004fd4 <topology_fill_descriptor>:

static void topology_fill_descriptor(struct cpu_topology_descriptor *cpu,
				     unsigned int logical_id,
				     uint64_t mpidr,
				     bool boot_cpu)
{
    c0004fd4:	d10083ff 	sub	sp, sp, #0x20
    c0004fd8:	f9000fe0 	str	x0, [sp, #24]
    c0004fdc:	b90017e1 	str	w1, [sp, #20]
    c0004fe0:	f90007e2 	str	x2, [sp, #8]
    c0004fe4:	39004fe3 	strb	w3, [sp, #19]
	cpu->logical_id = logical_id;
    c0004fe8:	f9400fe0 	ldr	x0, [sp, #24]
    c0004fec:	b94017e1 	ldr	w1, [sp, #20]
    c0004ff0:	b9000801 	str	w1, [x0, #8]
	cpu->mpidr = mpidr;
    c0004ff4:	f9400fe0 	ldr	x0, [sp, #24]
    c0004ff8:	f94007e1 	ldr	x1, [sp, #8]
    c0004ffc:	f9000001 	str	x1, [x0]
	cpu->chip_id = (unsigned int)((mpidr & MPIDR_AFF3_MASK) >> MPIDR_AFF3_SHIFT);
    c0005000:	f94007e0 	ldr	x0, [sp, #8]
    c0005004:	d358fc00 	lsr	x0, x0, #24
    c0005008:	12001c01 	and	w1, w0, #0xff
    c000500c:	f9400fe0 	ldr	x0, [sp, #24]
    c0005010:	b9000c01 	str	w1, [x0, #12]
	cpu->die_id = (unsigned int)((mpidr & MPIDR_AFF2_MASK) >> MPIDR_AFF2_SHIFT);
    c0005014:	f94007e0 	ldr	x0, [sp, #8]
    c0005018:	d350fc00 	lsr	x0, x0, #16
    c000501c:	12001c01 	and	w1, w0, #0xff
    c0005020:	f9400fe0 	ldr	x0, [sp, #24]
    c0005024:	b9001001 	str	w1, [x0, #16]
	cpu->cluster_id = (unsigned int)((mpidr & MPIDR_AFF1_MASK) >> MPIDR_AFF1_SHIFT);
    c0005028:	f94007e0 	ldr	x0, [sp, #8]
    c000502c:	d348fc00 	lsr	x0, x0, #8
    c0005030:	12001c01 	and	w1, w0, #0xff
    c0005034:	f9400fe0 	ldr	x0, [sp, #24]
    c0005038:	b9001401 	str	w1, [x0, #20]
	cpu->core_id = (unsigned int)(mpidr & MPIDR_AFF0_MASK);
    c000503c:	f94007e0 	ldr	x0, [sp, #8]
    c0005040:	12001c01 	and	w1, w0, #0xff
    c0005044:	f9400fe0 	ldr	x0, [sp, #24]
    c0005048:	b9001801 	str	w1, [x0, #24]
	cpu->boot_cpu = boot_cpu;
    c000504c:	f9400fe0 	ldr	x0, [sp, #24]
    c0005050:	39404fe1 	ldrb	w1, [sp, #19]
    c0005054:	39007001 	strb	w1, [x0, #28]
}
    c0005058:	d503201f 	nop
    c000505c:	910083ff 	add	sp, sp, #0x20
    c0005060:	d65f03c0 	ret

00000000c0005064 <topology_init>:

void topology_init(void)
{
    c0005064:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c0005068:	910003fd 	mov	x29, sp
	unsigned int i;
	uint64_t mpidr = topology_read_mpidr();
    c000506c:	97ffffd4 	bl	c0004fbc <topology_read_mpidr>
    c0005070:	f9000be0 	str	x0, [sp, #16]

	for (i = 0U; i < PLAT_MAX_CPUS; ++i) {
    c0005074:	b9001fff 	str	wzr, [sp, #28]
    c0005078:	1400003b 	b	c0005164 <topology_init+0x100>
		cpu_descs[i].logical_id = i;
    c000507c:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c0005080:	912ee001 	add	x1, x0, #0xbb8
    c0005084:	b9401fe0 	ldr	w0, [sp, #28]
    c0005088:	d37be800 	lsl	x0, x0, #5
    c000508c:	8b000020 	add	x0, x1, x0
    c0005090:	b9401fe1 	ldr	w1, [sp, #28]
    c0005094:	b9000801 	str	w1, [x0, #8]
		cpu_descs[i].present = false;
    c0005098:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c000509c:	912ee001 	add	x1, x0, #0xbb8
    c00050a0:	b9401fe0 	ldr	w0, [sp, #28]
    c00050a4:	d37be800 	lsl	x0, x0, #5
    c00050a8:	8b000020 	add	x0, x1, x0
    c00050ac:	3900741f 	strb	wzr, [x0, #29]
		cpu_descs[i].online = false;
    c00050b0:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c00050b4:	912ee001 	add	x1, x0, #0xbb8
    c00050b8:	b9401fe0 	ldr	w0, [sp, #28]
    c00050bc:	d37be800 	lsl	x0, x0, #5
    c00050c0:	8b000020 	add	x0, x1, x0
    c00050c4:	3900781f 	strb	wzr, [x0, #30]
		cpu_descs[i].boot_cpu = false;
    c00050c8:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c00050cc:	912ee001 	add	x1, x0, #0xbb8
    c00050d0:	b9401fe0 	ldr	w0, [sp, #28]
    c00050d4:	d37be800 	lsl	x0, x0, #5
    c00050d8:	8b000020 	add	x0, x1, x0
    c00050dc:	3900701f 	strb	wzr, [x0, #28]
		cpu_descs[i].mpidr = 0U;
    c00050e0:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c00050e4:	912ee001 	add	x1, x0, #0xbb8
    c00050e8:	b9401fe0 	ldr	w0, [sp, #28]
    c00050ec:	d37be800 	lsl	x0, x0, #5
    c00050f0:	8b000020 	add	x0, x1, x0
    c00050f4:	f900001f 	str	xzr, [x0]
		cpu_descs[i].chip_id = 0U;
    c00050f8:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c00050fc:	912ee001 	add	x1, x0, #0xbb8
    c0005100:	b9401fe0 	ldr	w0, [sp, #28]
    c0005104:	d37be800 	lsl	x0, x0, #5
    c0005108:	8b000020 	add	x0, x1, x0
    c000510c:	b9000c1f 	str	wzr, [x0, #12]
		cpu_descs[i].die_id = 0U;
    c0005110:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c0005114:	912ee001 	add	x1, x0, #0xbb8
    c0005118:	b9401fe0 	ldr	w0, [sp, #28]
    c000511c:	d37be800 	lsl	x0, x0, #5
    c0005120:	8b000020 	add	x0, x1, x0
    c0005124:	b900101f 	str	wzr, [x0, #16]
		cpu_descs[i].cluster_id = 0U;
    c0005128:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c000512c:	912ee001 	add	x1, x0, #0xbb8
    c0005130:	b9401fe0 	ldr	w0, [sp, #28]
    c0005134:	d37be800 	lsl	x0, x0, #5
    c0005138:	8b000020 	add	x0, x1, x0
    c000513c:	b900141f 	str	wzr, [x0, #20]
		cpu_descs[i].core_id = 0U;
    c0005140:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c0005144:	912ee001 	add	x1, x0, #0xbb8
    c0005148:	b9401fe0 	ldr	w0, [sp, #28]
    c000514c:	d37be800 	lsl	x0, x0, #5
    c0005150:	8b000020 	add	x0, x1, x0
    c0005154:	b900181f 	str	wzr, [x0, #24]
	for (i = 0U; i < PLAT_MAX_CPUS; ++i) {
    c0005158:	b9401fe0 	ldr	w0, [sp, #28]
    c000515c:	11000400 	add	w0, w0, #0x1
    c0005160:	b9001fe0 	str	w0, [sp, #28]
    c0005164:	b9401fe0 	ldr	w0, [sp, #28]
    c0005168:	71001c1f 	cmp	w0, #0x7
    c000516c:	54fff889 	b.ls	c000507c <topology_init+0x18>  // b.plast
	}

	topology_fill_descriptor(&cpu_descs[0], 0U, mpidr, true);
    c0005170:	52800023 	mov	w3, #0x1                   	// #1
    c0005174:	f9400be2 	ldr	x2, [sp, #16]
    c0005178:	52800001 	mov	w1, #0x0                   	// #0
    c000517c:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c0005180:	912ee000 	add	x0, x0, #0xbb8
    c0005184:	97ffff94 	bl	c0004fd4 <topology_fill_descriptor>
	cpu_descs[0].present = true;
    c0005188:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c000518c:	912ee000 	add	x0, x0, #0xbb8
    c0005190:	52800021 	mov	w1, #0x1                   	// #1
    c0005194:	39007401 	strb	w1, [x0, #29]
	cpu_descs[0].online = true;
    c0005198:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c000519c:	912ee000 	add	x0, x0, #0xbb8
    c00051a0:	52800021 	mov	w1, #0x1                   	// #1
    c00051a4:	39007801 	strb	w1, [x0, #30]
	present_cpu_count = 1U;
    c00051a8:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c00051ac:	9132e000 	add	x0, x0, #0xcb8
    c00051b0:	52800021 	mov	w1, #0x1                   	// #1
    c00051b4:	b9000001 	str	w1, [x0]
	online_cpu_count = 1U;
    c00051b8:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c00051bc:	9132f000 	add	x0, x0, #0xcbc
    c00051c0:	52800021 	mov	w1, #0x1                   	// #1
    c00051c4:	b9000001 	str	w1, [x0]
}
    c00051c8:	d503201f 	nop
    c00051cc:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c00051d0:	d65f03c0 	ret

00000000c00051d4 <topology_boot_cpu>:

const struct cpu_topology_descriptor *topology_boot_cpu(void)
{
	return &cpu_descs[0];
    c00051d4:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c00051d8:	912ee000 	add	x0, x0, #0xbb8
}
    c00051dc:	d65f03c0 	ret

00000000c00051e0 <topology_cpu>:

const struct cpu_topology_descriptor *topology_cpu(unsigned int logical_id)
{
    c00051e0:	d10043ff 	sub	sp, sp, #0x10
    c00051e4:	b9000fe0 	str	w0, [sp, #12]
	if (logical_id >= PLAT_MAX_CPUS) {
    c00051e8:	b9400fe0 	ldr	w0, [sp, #12]
    c00051ec:	71001c1f 	cmp	w0, #0x7
    c00051f0:	54000069 	b.ls	c00051fc <topology_cpu+0x1c>  // b.plast
		return (const struct cpu_topology_descriptor *)0;
    c00051f4:	d2800000 	mov	x0, #0x0                   	// #0
    c00051f8:	14000006 	b	c0005210 <topology_cpu+0x30>
	}

	return &cpu_descs[logical_id];
    c00051fc:	b9400fe0 	ldr	w0, [sp, #12]
    c0005200:	d37be801 	lsl	x1, x0, #5
    c0005204:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c0005208:	912ee000 	add	x0, x0, #0xbb8
    c000520c:	8b000020 	add	x0, x1, x0
}
    c0005210:	910043ff 	add	sp, sp, #0x10
    c0005214:	d65f03c0 	ret

00000000c0005218 <topology_find_cpu_by_mpidr>:

const struct cpu_topology_descriptor *topology_find_cpu_by_mpidr(uint64_t mpidr)
{
    c0005218:	d10083ff 	sub	sp, sp, #0x20
    c000521c:	f90007e0 	str	x0, [sp, #8]
	unsigned int i;

	for (i = 0U; i < PLAT_MAX_CPUS; ++i) {
    c0005220:	b9001fff 	str	wzr, [sp, #28]
    c0005224:	1400001c 	b	c0005294 <topology_find_cpu_by_mpidr+0x7c>
		if (cpu_descs[i].present && (cpu_descs[i].mpidr == mpidr)) {
    c0005228:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c000522c:	912ee001 	add	x1, x0, #0xbb8
    c0005230:	b9401fe0 	ldr	w0, [sp, #28]
    c0005234:	d37be800 	lsl	x0, x0, #5
    c0005238:	8b000020 	add	x0, x1, x0
    c000523c:	39407400 	ldrb	w0, [x0, #29]
    c0005240:	12000000 	and	w0, w0, #0x1
    c0005244:	7100001f 	cmp	w0, #0x0
    c0005248:	54000200 	b.eq	c0005288 <topology_find_cpu_by_mpidr+0x70>  // b.none
    c000524c:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c0005250:	912ee001 	add	x1, x0, #0xbb8
    c0005254:	b9401fe0 	ldr	w0, [sp, #28]
    c0005258:	d37be800 	lsl	x0, x0, #5
    c000525c:	8b000020 	add	x0, x1, x0
    c0005260:	f9400000 	ldr	x0, [x0]
    c0005264:	f94007e1 	ldr	x1, [sp, #8]
    c0005268:	eb00003f 	cmp	x1, x0
    c000526c:	540000e1 	b.ne	c0005288 <topology_find_cpu_by_mpidr+0x70>  // b.any
			return &cpu_descs[i];
    c0005270:	b9401fe0 	ldr	w0, [sp, #28]
    c0005274:	d37be801 	lsl	x1, x0, #5
    c0005278:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c000527c:	912ee000 	add	x0, x0, #0xbb8
    c0005280:	8b000020 	add	x0, x1, x0
    c0005284:	14000008 	b	c00052a4 <topology_find_cpu_by_mpidr+0x8c>
	for (i = 0U; i < PLAT_MAX_CPUS; ++i) {
    c0005288:	b9401fe0 	ldr	w0, [sp, #28]
    c000528c:	11000400 	add	w0, w0, #0x1
    c0005290:	b9001fe0 	str	w0, [sp, #28]
    c0005294:	b9401fe0 	ldr	w0, [sp, #28]
    c0005298:	71001c1f 	cmp	w0, #0x7
    c000529c:	54fffc69 	b.ls	c0005228 <topology_find_cpu_by_mpidr+0x10>  // b.plast
		}
	}

	return (const struct cpu_topology_descriptor *)0;
    c00052a0:	d2800000 	mov	x0, #0x0                   	// #0
}
    c00052a4:	910083ff 	add	sp, sp, #0x20
    c00052a8:	d65f03c0 	ret

00000000c00052ac <topology_cpu_capacity>:

unsigned int topology_cpu_capacity(void)
{
	return PLAT_MAX_CPUS;
    c00052ac:	52800100 	mov	w0, #0x8                   	// #8
}
    c00052b0:	d65f03c0 	ret

00000000c00052b4 <topology_present_cpu_count>:

unsigned int topology_present_cpu_count(void)
{
	return present_cpu_count;
    c00052b4:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c00052b8:	9132e000 	add	x0, x0, #0xcb8
    c00052bc:	b9400000 	ldr	w0, [x0]
}
    c00052c0:	d65f03c0 	ret

00000000c00052c4 <topology_online_cpu_count>:

unsigned int topology_online_cpu_count(void)
{
	return online_cpu_count;
    c00052c4:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c00052c8:	9132f000 	add	x0, x0, #0xcbc
    c00052cc:	b9400000 	ldr	w0, [x0]
}
    c00052d0:	d65f03c0 	ret

00000000c00052d4 <topology_mark_cpu_online>:

void topology_mark_cpu_online(unsigned int logical_id, bool online)
{
    c00052d4:	d10043ff 	sub	sp, sp, #0x10
    c00052d8:	b9000fe0 	str	w0, [sp, #12]
    c00052dc:	39002fe1 	strb	w1, [sp, #11]
	if (logical_id >= PLAT_MAX_CPUS) {
    c00052e0:	b9400fe0 	ldr	w0, [sp, #12]
    c00052e4:	71001c1f 	cmp	w0, #0x7
    c00052e8:	54000b48 	b.hi	c0005450 <topology_mark_cpu_online+0x17c>  // b.pmore
		return;
	}

	if (!cpu_descs[logical_id].present) {
    c00052ec:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c00052f0:	912ee001 	add	x1, x0, #0xbb8
    c00052f4:	b9400fe0 	ldr	w0, [sp, #12]
    c00052f8:	d37be800 	lsl	x0, x0, #5
    c00052fc:	8b000020 	add	x0, x1, x0
    c0005300:	39407400 	ldrb	w0, [x0, #29]
    c0005304:	52000000 	eor	w0, w0, #0x1
    c0005308:	12001c00 	and	w0, w0, #0xff
    c000530c:	12000000 	and	w0, w0, #0x1
    c0005310:	7100001f 	cmp	w0, #0x0
    c0005314:	540001e0 	b.eq	c0005350 <topology_mark_cpu_online+0x7c>  // b.none
		cpu_descs[logical_id].present = true;
    c0005318:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c000531c:	912ee001 	add	x1, x0, #0xbb8
    c0005320:	b9400fe0 	ldr	w0, [sp, #12]
    c0005324:	d37be800 	lsl	x0, x0, #5
    c0005328:	8b000020 	add	x0, x1, x0
    c000532c:	52800021 	mov	w1, #0x1                   	// #1
    c0005330:	39007401 	strb	w1, [x0, #29]
		present_cpu_count++;
    c0005334:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c0005338:	9132e000 	add	x0, x0, #0xcb8
    c000533c:	b9400000 	ldr	w0, [x0]
    c0005340:	11000401 	add	w1, w0, #0x1
    c0005344:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c0005348:	9132e000 	add	x0, x0, #0xcb8
    c000534c:	b9000001 	str	w1, [x0]
	}

	if (online && !cpu_descs[logical_id].online) {
    c0005350:	39402fe0 	ldrb	w0, [sp, #11]
    c0005354:	12000000 	and	w0, w0, #0x1
    c0005358:	7100001f 	cmp	w0, #0x0
    c000535c:	54000360 	b.eq	c00053c8 <topology_mark_cpu_online+0xf4>  // b.none
    c0005360:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c0005364:	912ee001 	add	x1, x0, #0xbb8
    c0005368:	b9400fe0 	ldr	w0, [sp, #12]
    c000536c:	d37be800 	lsl	x0, x0, #5
    c0005370:	8b000020 	add	x0, x1, x0
    c0005374:	39407800 	ldrb	w0, [x0, #30]
    c0005378:	52000000 	eor	w0, w0, #0x1
    c000537c:	12001c00 	and	w0, w0, #0xff
    c0005380:	12000000 	and	w0, w0, #0x1
    c0005384:	7100001f 	cmp	w0, #0x0
    c0005388:	54000200 	b.eq	c00053c8 <topology_mark_cpu_online+0xf4>  // b.none
		cpu_descs[logical_id].online = true;
    c000538c:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c0005390:	912ee001 	add	x1, x0, #0xbb8
    c0005394:	b9400fe0 	ldr	w0, [sp, #12]
    c0005398:	d37be800 	lsl	x0, x0, #5
    c000539c:	8b000020 	add	x0, x1, x0
    c00053a0:	52800021 	mov	w1, #0x1                   	// #1
    c00053a4:	39007801 	strb	w1, [x0, #30]
		online_cpu_count++;
    c00053a8:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c00053ac:	9132f000 	add	x0, x0, #0xcbc
    c00053b0:	b9400000 	ldr	w0, [x0]
    c00053b4:	11000401 	add	w1, w0, #0x1
    c00053b8:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c00053bc:	9132f000 	add	x0, x0, #0xcbc
    c00053c0:	b9000001 	str	w1, [x0]
    c00053c4:	14000024 	b	c0005454 <topology_mark_cpu_online+0x180>
	} else if (!online && cpu_descs[logical_id].online) {
    c00053c8:	39402fe0 	ldrb	w0, [sp, #11]
    c00053cc:	52000000 	eor	w0, w0, #0x1
    c00053d0:	12001c00 	and	w0, w0, #0xff
    c00053d4:	12000000 	and	w0, w0, #0x1
    c00053d8:	7100001f 	cmp	w0, #0x0
    c00053dc:	540003c0 	b.eq	c0005454 <topology_mark_cpu_online+0x180>  // b.none
    c00053e0:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c00053e4:	912ee001 	add	x1, x0, #0xbb8
    c00053e8:	b9400fe0 	ldr	w0, [sp, #12]
    c00053ec:	d37be800 	lsl	x0, x0, #5
    c00053f0:	8b000020 	add	x0, x1, x0
    c00053f4:	39407800 	ldrb	w0, [x0, #30]
    c00053f8:	12000000 	and	w0, w0, #0x1
    c00053fc:	7100001f 	cmp	w0, #0x0
    c0005400:	540002a0 	b.eq	c0005454 <topology_mark_cpu_online+0x180>  // b.none
		cpu_descs[logical_id].online = false;
    c0005404:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c0005408:	912ee001 	add	x1, x0, #0xbb8
    c000540c:	b9400fe0 	ldr	w0, [sp, #12]
    c0005410:	d37be800 	lsl	x0, x0, #5
    c0005414:	8b000020 	add	x0, x1, x0
    c0005418:	3900781f 	strb	wzr, [x0, #30]
		if (online_cpu_count > 0U) {
    c000541c:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c0005420:	9132f000 	add	x0, x0, #0xcbc
    c0005424:	b9400000 	ldr	w0, [x0]
    c0005428:	7100001f 	cmp	w0, #0x0
    c000542c:	54000140 	b.eq	c0005454 <topology_mark_cpu_online+0x180>  // b.none
			online_cpu_count--;
    c0005430:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c0005434:	9132f000 	add	x0, x0, #0xcbc
    c0005438:	b9400000 	ldr	w0, [x0]
    c000543c:	51000401 	sub	w1, w0, #0x1
    c0005440:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c0005444:	9132f000 	add	x0, x0, #0xcbc
    c0005448:	b9000001 	str	w1, [x0]
    c000544c:	14000002 	b	c0005454 <topology_mark_cpu_online+0x180>
		return;
    c0005450:	d503201f 	nop
		}
	}
}
    c0005454:	910043ff 	add	sp, sp, #0x10
    c0005458:	d65f03c0 	ret

00000000c000545c <topology_register_cpu>:

void topology_register_cpu(unsigned int logical_id, uint64_t mpidr, bool boot_cpu)
{
    c000545c:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c0005460:	910003fd 	mov	x29, sp
    c0005464:	b9001fe0 	str	w0, [sp, #28]
    c0005468:	f9000be1 	str	x1, [sp, #16]
    c000546c:	39006fe2 	strb	w2, [sp, #27]
	if (logical_id >= PLAT_MAX_CPUS) {
    c0005470:	b9401fe0 	ldr	w0, [sp, #28]
    c0005474:	71001c1f 	cmp	w0, #0x7
    c0005478:	54000548 	b.hi	c0005520 <topology_register_cpu+0xc4>  // b.pmore
		return;
	}

	if (!cpu_descs[logical_id].present) {
    c000547c:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c0005480:	912ee001 	add	x1, x0, #0xbb8
    c0005484:	b9401fe0 	ldr	w0, [sp, #28]
    c0005488:	d37be800 	lsl	x0, x0, #5
    c000548c:	8b000020 	add	x0, x1, x0
    c0005490:	39407400 	ldrb	w0, [x0, #29]
    c0005494:	52000000 	eor	w0, w0, #0x1
    c0005498:	12001c00 	and	w0, w0, #0xff
    c000549c:	12000000 	and	w0, w0, #0x1
    c00054a0:	7100001f 	cmp	w0, #0x0
    c00054a4:	54000100 	b.eq	c00054c4 <topology_register_cpu+0x68>  // b.none
		present_cpu_count++;
    c00054a8:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c00054ac:	9132e000 	add	x0, x0, #0xcb8
    c00054b0:	b9400000 	ldr	w0, [x0]
    c00054b4:	11000401 	add	w1, w0, #0x1
    c00054b8:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c00054bc:	9132e000 	add	x0, x0, #0xcb8
    c00054c0:	b9000001 	str	w1, [x0]
	}

	topology_fill_descriptor(&cpu_descs[logical_id], logical_id, mpidr, boot_cpu);
    c00054c4:	b9401fe0 	ldr	w0, [sp, #28]
    c00054c8:	d37be801 	lsl	x1, x0, #5
    c00054cc:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c00054d0:	912ee000 	add	x0, x0, #0xbb8
    c00054d4:	8b000020 	add	x0, x1, x0
    c00054d8:	39406fe3 	ldrb	w3, [sp, #27]
    c00054dc:	f9400be2 	ldr	x2, [sp, #16]
    c00054e0:	b9401fe1 	ldr	w1, [sp, #28]
    c00054e4:	97fffebc 	bl	c0004fd4 <topology_fill_descriptor>
	cpu_descs[logical_id].present = true;
    c00054e8:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c00054ec:	912ee001 	add	x1, x0, #0xbb8
    c00054f0:	b9401fe0 	ldr	w0, [sp, #28]
    c00054f4:	d37be800 	lsl	x0, x0, #5
    c00054f8:	8b000020 	add	x0, x1, x0
    c00054fc:	52800021 	mov	w1, #0x1                   	// #1
    c0005500:	39007401 	strb	w1, [x0, #29]
	cpu_descs[logical_id].online = false;
    c0005504:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c0005508:	912ee001 	add	x1, x0, #0xbb8
    c000550c:	b9401fe0 	ldr	w0, [sp, #28]
    c0005510:	d37be800 	lsl	x0, x0, #5
    c0005514:	8b000020 	add	x0, x1, x0
    c0005518:	3900781f 	strb	wzr, [x0, #30]
    c000551c:	14000002 	b	c0005524 <topology_register_cpu+0xc8>
		return;
    c0005520:	d503201f 	nop
}
    c0005524:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c0005528:	d65f03c0 	ret

00000000c000552c <topology_unregister_cpu>:

void topology_unregister_cpu(unsigned int logical_id)
{
    c000552c:	d10043ff 	sub	sp, sp, #0x10
    c0005530:	b9000fe0 	str	w0, [sp, #12]
	if (logical_id >= PLAT_MAX_CPUS) {
    c0005534:	b9400fe0 	ldr	w0, [sp, #12]
    c0005538:	71001c1f 	cmp	w0, #0x7
    c000553c:	54000c68 	b.hi	c00056c8 <topology_unregister_cpu+0x19c>  // b.pmore
		return;
	}

	if (cpu_descs[logical_id].online) {
    c0005540:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c0005544:	912ee001 	add	x1, x0, #0xbb8
    c0005548:	b9400fe0 	ldr	w0, [sp, #12]
    c000554c:	d37be800 	lsl	x0, x0, #5
    c0005550:	8b000020 	add	x0, x1, x0
    c0005554:	39407800 	ldrb	w0, [x0, #30]
    c0005558:	12000000 	and	w0, w0, #0x1
    c000555c:	7100001f 	cmp	w0, #0x0
    c0005560:	54000260 	b.eq	c00055ac <topology_unregister_cpu+0x80>  // b.none
		cpu_descs[logical_id].online = false;
    c0005564:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c0005568:	912ee001 	add	x1, x0, #0xbb8
    c000556c:	b9400fe0 	ldr	w0, [sp, #12]
    c0005570:	d37be800 	lsl	x0, x0, #5
    c0005574:	8b000020 	add	x0, x1, x0
    c0005578:	3900781f 	strb	wzr, [x0, #30]
		if (online_cpu_count > 0U) {
    c000557c:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c0005580:	9132f000 	add	x0, x0, #0xcbc
    c0005584:	b9400000 	ldr	w0, [x0]
    c0005588:	7100001f 	cmp	w0, #0x0
    c000558c:	54000100 	b.eq	c00055ac <topology_unregister_cpu+0x80>  // b.none
			online_cpu_count--;
    c0005590:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c0005594:	9132f000 	add	x0, x0, #0xcbc
    c0005598:	b9400000 	ldr	w0, [x0]
    c000559c:	51000401 	sub	w1, w0, #0x1
    c00055a0:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c00055a4:	9132f000 	add	x0, x0, #0xcbc
    c00055a8:	b9000001 	str	w1, [x0]
		}
	}

	if (cpu_descs[logical_id].present) {
    c00055ac:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c00055b0:	912ee001 	add	x1, x0, #0xbb8
    c00055b4:	b9400fe0 	ldr	w0, [sp, #12]
    c00055b8:	d37be800 	lsl	x0, x0, #5
    c00055bc:	8b000020 	add	x0, x1, x0
    c00055c0:	39407400 	ldrb	w0, [x0, #29]
    c00055c4:	12000000 	and	w0, w0, #0x1
    c00055c8:	7100001f 	cmp	w0, #0x0
    c00055cc:	54000260 	b.eq	c0005618 <topology_unregister_cpu+0xec>  // b.none
		cpu_descs[logical_id].present = false;
    c00055d0:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c00055d4:	912ee001 	add	x1, x0, #0xbb8
    c00055d8:	b9400fe0 	ldr	w0, [sp, #12]
    c00055dc:	d37be800 	lsl	x0, x0, #5
    c00055e0:	8b000020 	add	x0, x1, x0
    c00055e4:	3900741f 	strb	wzr, [x0, #29]
		if (present_cpu_count > 0U) {
    c00055e8:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c00055ec:	9132e000 	add	x0, x0, #0xcb8
    c00055f0:	b9400000 	ldr	w0, [x0]
    c00055f4:	7100001f 	cmp	w0, #0x0
    c00055f8:	54000100 	b.eq	c0005618 <topology_unregister_cpu+0xec>  // b.none
			present_cpu_count--;
    c00055fc:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c0005600:	9132e000 	add	x0, x0, #0xcb8
    c0005604:	b9400000 	ldr	w0, [x0]
    c0005608:	51000401 	sub	w1, w0, #0x1
    c000560c:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c0005610:	9132e000 	add	x0, x0, #0xcb8
    c0005614:	b9000001 	str	w1, [x0]
		}
	}

	cpu_descs[logical_id].logical_id = logical_id;
    c0005618:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c000561c:	912ee001 	add	x1, x0, #0xbb8
    c0005620:	b9400fe0 	ldr	w0, [sp, #12]
    c0005624:	d37be800 	lsl	x0, x0, #5
    c0005628:	8b000020 	add	x0, x1, x0
    c000562c:	b9400fe1 	ldr	w1, [sp, #12]
    c0005630:	b9000801 	str	w1, [x0, #8]
	cpu_descs[logical_id].boot_cpu = false;
    c0005634:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c0005638:	912ee001 	add	x1, x0, #0xbb8
    c000563c:	b9400fe0 	ldr	w0, [sp, #12]
    c0005640:	d37be800 	lsl	x0, x0, #5
    c0005644:	8b000020 	add	x0, x1, x0
    c0005648:	3900701f 	strb	wzr, [x0, #28]
	cpu_descs[logical_id].mpidr = 0U;
    c000564c:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c0005650:	912ee001 	add	x1, x0, #0xbb8
    c0005654:	b9400fe0 	ldr	w0, [sp, #12]
    c0005658:	d37be800 	lsl	x0, x0, #5
    c000565c:	8b000020 	add	x0, x1, x0
    c0005660:	f900001f 	str	xzr, [x0]
	cpu_descs[logical_id].chip_id = 0U;
    c0005664:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c0005668:	912ee001 	add	x1, x0, #0xbb8
    c000566c:	b9400fe0 	ldr	w0, [sp, #12]
    c0005670:	d37be800 	lsl	x0, x0, #5
    c0005674:	8b000020 	add	x0, x1, x0
    c0005678:	b9000c1f 	str	wzr, [x0, #12]
	cpu_descs[logical_id].die_id = 0U;
    c000567c:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c0005680:	912ee001 	add	x1, x0, #0xbb8
    c0005684:	b9400fe0 	ldr	w0, [sp, #12]
    c0005688:	d37be800 	lsl	x0, x0, #5
    c000568c:	8b000020 	add	x0, x1, x0
    c0005690:	b900101f 	str	wzr, [x0, #16]
	cpu_descs[logical_id].cluster_id = 0U;
    c0005694:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c0005698:	912ee001 	add	x1, x0, #0xbb8
    c000569c:	b9400fe0 	ldr	w0, [sp, #12]
    c00056a0:	d37be800 	lsl	x0, x0, #5
    c00056a4:	8b000020 	add	x0, x1, x0
    c00056a8:	b900141f 	str	wzr, [x0, #20]
	cpu_descs[logical_id].core_id = 0U;
    c00056ac:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x7510>
    c00056b0:	912ee001 	add	x1, x0, #0xbb8
    c00056b4:	b9400fe0 	ldr	w0, [sp, #12]
    c00056b8:	d37be800 	lsl	x0, x0, #5
    c00056bc:	8b000020 	add	x0, x1, x0
    c00056c0:	b900181f 	str	wzr, [x0, #24]
    c00056c4:	14000002 	b	c00056cc <topology_unregister_cpu+0x1a0>
		return;
    c00056c8:	d503201f 	nop
    c00056cc:	910043ff 	add	sp, sp, #0x10
    c00056d0:	d65f03c0 	ret
