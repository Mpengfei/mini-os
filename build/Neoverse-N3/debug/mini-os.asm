
/home/pengfei/felix-os/mini-os/build/Neoverse-N3/debug/mini-os.elf:     file format elf64-littleaarch64


Disassembly of section .text:

0000000088000000 <_start>:
    88000000:	580000c0 	ldr	x0, 88000018 <_start+0x18>
    88000004:	9100001f 	mov	sp, x0
    88000008:	94000925 	bl	8800249c <kernel_main>
    8800000c:	d503205f 	wfe
    88000010:	17ffffff 	b	8800000c <_start+0xc>
    88000014:	00000000 	udf	#0
    88000018:	88004140 	.word	0x88004140
    8800001c:	00000000 	.word	0x00000000

0000000088000020 <print_char>:
	int length;
	char conv;
};

static void print_char(struct print_ctx *ctx, char ch)
{
    88000020:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    88000024:	910003fd 	mov	x29, sp
    88000028:	f9000fe0 	str	x0, [sp, #24]
    8800002c:	39005fe1 	strb	w1, [sp, #23]
	if (ch == '\n') {
    88000030:	39405fe0 	ldrb	w0, [sp, #23]
    88000034:	7100281f 	cmp	w0, #0xa
    88000038:	54000061 	b.ne	88000044 <print_char+0x24>  // b.any
		debug_putc('\r');
    8800003c:	528001a0 	mov	w0, #0xd                   	// #13
    88000040:	9400073c 	bl	88001d30 <debug_putc>
	}

	debug_putc((int)ch);
    88000044:	39405fe0 	ldrb	w0, [sp, #23]
    88000048:	9400073a 	bl	88001d30 <debug_putc>
	ctx->count++;
    8800004c:	f9400fe0 	ldr	x0, [sp, #24]
    88000050:	b9400000 	ldr	w0, [x0]
    88000054:	11000401 	add	w1, w0, #0x1
    88000058:	f9400fe0 	ldr	x0, [sp, #24]
    8800005c:	b9000001 	str	w1, [x0]
}
    88000060:	d503201f 	nop
    88000064:	a8c27bfd 	ldp	x29, x30, [sp], #32
    88000068:	d65f03c0 	ret

000000008800006c <print_repeat>:

static void print_repeat(struct print_ctx *ctx, char ch, int count)
{
    8800006c:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    88000070:	910003fd 	mov	x29, sp
    88000074:	f9000fe0 	str	x0, [sp, #24]
    88000078:	39005fe1 	strb	w1, [sp, #23]
    8800007c:	b90013e2 	str	w2, [sp, #16]
	while (count-- > 0) {
    88000080:	14000004 	b	88000090 <print_repeat+0x24>
		print_char(ctx, ch);
    88000084:	39405fe1 	ldrb	w1, [sp, #23]
    88000088:	f9400fe0 	ldr	x0, [sp, #24]
    8800008c:	97ffffe5 	bl	88000020 <print_char>
	while (count-- > 0) {
    88000090:	b94013e0 	ldr	w0, [sp, #16]
    88000094:	51000401 	sub	w1, w0, #0x1
    88000098:	b90013e1 	str	w1, [sp, #16]
    8800009c:	7100001f 	cmp	w0, #0x0
    880000a0:	54ffff2c 	b.gt	88000084 <print_repeat+0x18>
	}
}
    880000a4:	d503201f 	nop
    880000a8:	d503201f 	nop
    880000ac:	a8c27bfd 	ldp	x29, x30, [sp], #32
    880000b0:	d65f03c0 	ret

00000000880000b4 <str_length>:

static size_t str_length(const char *str)
{
    880000b4:	d10083ff 	sub	sp, sp, #0x20
    880000b8:	f90007e0 	str	x0, [sp, #8]
	size_t len = 0U;
    880000bc:	f9000fff 	str	xzr, [sp, #24]

	while (str[len] != '\0') {
    880000c0:	14000004 	b	880000d0 <str_length+0x1c>
		len++;
    880000c4:	f9400fe0 	ldr	x0, [sp, #24]
    880000c8:	91000400 	add	x0, x0, #0x1
    880000cc:	f9000fe0 	str	x0, [sp, #24]
	while (str[len] != '\0') {
    880000d0:	f94007e1 	ldr	x1, [sp, #8]
    880000d4:	f9400fe0 	ldr	x0, [sp, #24]
    880000d8:	8b000020 	add	x0, x1, x0
    880000dc:	39400000 	ldrb	w0, [x0]
    880000e0:	7100001f 	cmp	w0, #0x0
    880000e4:	54ffff01 	b.ne	880000c4 <str_length+0x10>  // b.any
	}

	return len;
    880000e8:	f9400fe0 	ldr	x0, [sp, #24]
}
    880000ec:	910083ff 	add	sp, sp, #0x20
    880000f0:	d65f03c0 	ret

00000000880000f4 <get_unsigned_arg>:

static uint64_t get_unsigned_arg(va_list *args, int length)
{
    880000f4:	d10043ff 	sub	sp, sp, #0x10
    880000f8:	f90007e0 	str	x0, [sp, #8]
    880000fc:	b90007e1 	str	w1, [sp, #4]
	switch (length) {
    88000100:	b94007e0 	ldr	w0, [sp, #4]
    88000104:	71001c1f 	cmp	w0, #0x7
    88000108:	54001aa0 	b.eq	8800045c <get_unsigned_arg+0x368>  // b.none
    8800010c:	b94007e0 	ldr	w0, [sp, #4]
    88000110:	71001c1f 	cmp	w0, #0x7
    88000114:	54001dec 	b.gt	880004d0 <get_unsigned_arg+0x3dc>
    88000118:	b94007e0 	ldr	w0, [sp, #4]
    8800011c:	7100181f 	cmp	w0, #0x6
    88000120:	54001640 	b.eq	880003e8 <get_unsigned_arg+0x2f4>  // b.none
    88000124:	b94007e0 	ldr	w0, [sp, #4]
    88000128:	7100181f 	cmp	w0, #0x6
    8800012c:	54001d2c 	b.gt	880004d0 <get_unsigned_arg+0x3dc>
    88000130:	b94007e0 	ldr	w0, [sp, #4]
    88000134:	7100141f 	cmp	w0, #0x5
    88000138:	540011e0 	b.eq	88000374 <get_unsigned_arg+0x280>  // b.none
    8800013c:	b94007e0 	ldr	w0, [sp, #4]
    88000140:	7100141f 	cmp	w0, #0x5
    88000144:	54001c6c 	b.gt	880004d0 <get_unsigned_arg+0x3dc>
    88000148:	b94007e0 	ldr	w0, [sp, #4]
    8800014c:	7100101f 	cmp	w0, #0x4
    88000150:	54000d80 	b.eq	88000300 <get_unsigned_arg+0x20c>  // b.none
    88000154:	b94007e0 	ldr	w0, [sp, #4]
    88000158:	7100101f 	cmp	w0, #0x4
    8800015c:	54001bac 	b.gt	880004d0 <get_unsigned_arg+0x3dc>
    88000160:	b94007e0 	ldr	w0, [sp, #4]
    88000164:	71000c1f 	cmp	w0, #0x3
    88000168:	54000920 	b.eq	8800028c <get_unsigned_arg+0x198>  // b.none
    8800016c:	b94007e0 	ldr	w0, [sp, #4]
    88000170:	71000c1f 	cmp	w0, #0x3
    88000174:	54001aec 	b.gt	880004d0 <get_unsigned_arg+0x3dc>
    88000178:	b94007e0 	ldr	w0, [sp, #4]
    8800017c:	7100041f 	cmp	w0, #0x1
    88000180:	540000a0 	b.eq	88000194 <get_unsigned_arg+0xa0>  // b.none
    88000184:	b94007e0 	ldr	w0, [sp, #4]
    88000188:	7100081f 	cmp	w0, #0x2
    8800018c:	54000420 	b.eq	88000210 <get_unsigned_arg+0x11c>  // b.none
    88000190:	140000d0 	b	880004d0 <get_unsigned_arg+0x3dc>
	case LENGTH_HH:
		return (uint64_t)(unsigned char)va_arg(*args, unsigned int);
    88000194:	f94007e0 	ldr	x0, [sp, #8]
    88000198:	b9401801 	ldr	w1, [x0, #24]
    8800019c:	f94007e0 	ldr	x0, [sp, #8]
    880001a0:	f9400000 	ldr	x0, [x0]
    880001a4:	7100003f 	cmp	w1, #0x0
    880001a8:	540000cb 	b.lt	880001c0 <get_unsigned_arg+0xcc>  // b.tstop
    880001ac:	91002c01 	add	x1, x0, #0xb
    880001b0:	927df022 	and	x2, x1, #0xfffffffffffffff8
    880001b4:	f94007e1 	ldr	x1, [sp, #8]
    880001b8:	f9000022 	str	x2, [x1]
    880001bc:	14000011 	b	88000200 <get_unsigned_arg+0x10c>
    880001c0:	11002023 	add	w3, w1, #0x8
    880001c4:	f94007e2 	ldr	x2, [sp, #8]
    880001c8:	b9001843 	str	w3, [x2, #24]
    880001cc:	f94007e2 	ldr	x2, [sp, #8]
    880001d0:	b9401842 	ldr	w2, [x2, #24]
    880001d4:	7100005f 	cmp	w2, #0x0
    880001d8:	540000cd 	b.le	880001f0 <get_unsigned_arg+0xfc>
    880001dc:	91002c01 	add	x1, x0, #0xb
    880001e0:	927df022 	and	x2, x1, #0xfffffffffffffff8
    880001e4:	f94007e1 	ldr	x1, [sp, #8]
    880001e8:	f9000022 	str	x2, [x1]
    880001ec:	14000005 	b	88000200 <get_unsigned_arg+0x10c>
    880001f0:	f94007e0 	ldr	x0, [sp, #8]
    880001f4:	f9400402 	ldr	x2, [x0, #8]
    880001f8:	93407c20 	sxtw	x0, w1
    880001fc:	8b000040 	add	x0, x2, x0
    88000200:	b9400000 	ldr	w0, [x0]
    88000204:	12001c00 	and	w0, w0, #0xff
    88000208:	92401c00 	and	x0, x0, #0xff
    8800020c:	140000ce 	b	88000544 <get_unsigned_arg+0x450>
	case LENGTH_H:
		return (uint64_t)(unsigned short)va_arg(*args, unsigned int);
    88000210:	f94007e0 	ldr	x0, [sp, #8]
    88000214:	b9401801 	ldr	w1, [x0, #24]
    88000218:	f94007e0 	ldr	x0, [sp, #8]
    8800021c:	f9400000 	ldr	x0, [x0]
    88000220:	7100003f 	cmp	w1, #0x0
    88000224:	540000cb 	b.lt	8800023c <get_unsigned_arg+0x148>  // b.tstop
    88000228:	91002c01 	add	x1, x0, #0xb
    8800022c:	927df022 	and	x2, x1, #0xfffffffffffffff8
    88000230:	f94007e1 	ldr	x1, [sp, #8]
    88000234:	f9000022 	str	x2, [x1]
    88000238:	14000011 	b	8800027c <get_unsigned_arg+0x188>
    8800023c:	11002023 	add	w3, w1, #0x8
    88000240:	f94007e2 	ldr	x2, [sp, #8]
    88000244:	b9001843 	str	w3, [x2, #24]
    88000248:	f94007e2 	ldr	x2, [sp, #8]
    8800024c:	b9401842 	ldr	w2, [x2, #24]
    88000250:	7100005f 	cmp	w2, #0x0
    88000254:	540000cd 	b.le	8800026c <get_unsigned_arg+0x178>
    88000258:	91002c01 	add	x1, x0, #0xb
    8800025c:	927df022 	and	x2, x1, #0xfffffffffffffff8
    88000260:	f94007e1 	ldr	x1, [sp, #8]
    88000264:	f9000022 	str	x2, [x1]
    88000268:	14000005 	b	8800027c <get_unsigned_arg+0x188>
    8800026c:	f94007e0 	ldr	x0, [sp, #8]
    88000270:	f9400402 	ldr	x2, [x0, #8]
    88000274:	93407c20 	sxtw	x0, w1
    88000278:	8b000040 	add	x0, x2, x0
    8800027c:	b9400000 	ldr	w0, [x0]
    88000280:	12003c00 	and	w0, w0, #0xffff
    88000284:	92403c00 	and	x0, x0, #0xffff
    88000288:	140000af 	b	88000544 <get_unsigned_arg+0x450>
	case LENGTH_L:
		return (uint64_t)va_arg(*args, unsigned long);
    8800028c:	f94007e0 	ldr	x0, [sp, #8]
    88000290:	b9401801 	ldr	w1, [x0, #24]
    88000294:	f94007e0 	ldr	x0, [sp, #8]
    88000298:	f9400000 	ldr	x0, [x0]
    8800029c:	7100003f 	cmp	w1, #0x0
    880002a0:	540000cb 	b.lt	880002b8 <get_unsigned_arg+0x1c4>  // b.tstop
    880002a4:	91003c01 	add	x1, x0, #0xf
    880002a8:	927df022 	and	x2, x1, #0xfffffffffffffff8
    880002ac:	f94007e1 	ldr	x1, [sp, #8]
    880002b0:	f9000022 	str	x2, [x1]
    880002b4:	14000011 	b	880002f8 <get_unsigned_arg+0x204>
    880002b8:	11002023 	add	w3, w1, #0x8
    880002bc:	f94007e2 	ldr	x2, [sp, #8]
    880002c0:	b9001843 	str	w3, [x2, #24]
    880002c4:	f94007e2 	ldr	x2, [sp, #8]
    880002c8:	b9401842 	ldr	w2, [x2, #24]
    880002cc:	7100005f 	cmp	w2, #0x0
    880002d0:	540000cd 	b.le	880002e8 <get_unsigned_arg+0x1f4>
    880002d4:	91003c01 	add	x1, x0, #0xf
    880002d8:	927df022 	and	x2, x1, #0xfffffffffffffff8
    880002dc:	f94007e1 	ldr	x1, [sp, #8]
    880002e0:	f9000022 	str	x2, [x1]
    880002e4:	14000005 	b	880002f8 <get_unsigned_arg+0x204>
    880002e8:	f94007e0 	ldr	x0, [sp, #8]
    880002ec:	f9400402 	ldr	x2, [x0, #8]
    880002f0:	93407c20 	sxtw	x0, w1
    880002f4:	8b000040 	add	x0, x2, x0
    880002f8:	f9400000 	ldr	x0, [x0]
    880002fc:	14000092 	b	88000544 <get_unsigned_arg+0x450>
	case LENGTH_LL:
		return (uint64_t)va_arg(*args, unsigned long long);
    88000300:	f94007e0 	ldr	x0, [sp, #8]
    88000304:	b9401801 	ldr	w1, [x0, #24]
    88000308:	f94007e0 	ldr	x0, [sp, #8]
    8800030c:	f9400000 	ldr	x0, [x0]
    88000310:	7100003f 	cmp	w1, #0x0
    88000314:	540000cb 	b.lt	8800032c <get_unsigned_arg+0x238>  // b.tstop
    88000318:	91003c01 	add	x1, x0, #0xf
    8800031c:	927df022 	and	x2, x1, #0xfffffffffffffff8
    88000320:	f94007e1 	ldr	x1, [sp, #8]
    88000324:	f9000022 	str	x2, [x1]
    88000328:	14000011 	b	8800036c <get_unsigned_arg+0x278>
    8800032c:	11002023 	add	w3, w1, #0x8
    88000330:	f94007e2 	ldr	x2, [sp, #8]
    88000334:	b9001843 	str	w3, [x2, #24]
    88000338:	f94007e2 	ldr	x2, [sp, #8]
    8800033c:	b9401842 	ldr	w2, [x2, #24]
    88000340:	7100005f 	cmp	w2, #0x0
    88000344:	540000cd 	b.le	8800035c <get_unsigned_arg+0x268>
    88000348:	91003c01 	add	x1, x0, #0xf
    8800034c:	927df022 	and	x2, x1, #0xfffffffffffffff8
    88000350:	f94007e1 	ldr	x1, [sp, #8]
    88000354:	f9000022 	str	x2, [x1]
    88000358:	14000005 	b	8800036c <get_unsigned_arg+0x278>
    8800035c:	f94007e0 	ldr	x0, [sp, #8]
    88000360:	f9400402 	ldr	x2, [x0, #8]
    88000364:	93407c20 	sxtw	x0, w1
    88000368:	8b000040 	add	x0, x2, x0
    8800036c:	f9400000 	ldr	x0, [x0]
    88000370:	14000075 	b	88000544 <get_unsigned_arg+0x450>
	case LENGTH_Z:
		return (uint64_t)va_arg(*args, size_t);
    88000374:	f94007e0 	ldr	x0, [sp, #8]
    88000378:	b9401801 	ldr	w1, [x0, #24]
    8800037c:	f94007e0 	ldr	x0, [sp, #8]
    88000380:	f9400000 	ldr	x0, [x0]
    88000384:	7100003f 	cmp	w1, #0x0
    88000388:	540000cb 	b.lt	880003a0 <get_unsigned_arg+0x2ac>  // b.tstop
    8800038c:	91003c01 	add	x1, x0, #0xf
    88000390:	927df022 	and	x2, x1, #0xfffffffffffffff8
    88000394:	f94007e1 	ldr	x1, [sp, #8]
    88000398:	f9000022 	str	x2, [x1]
    8800039c:	14000011 	b	880003e0 <get_unsigned_arg+0x2ec>
    880003a0:	11002023 	add	w3, w1, #0x8
    880003a4:	f94007e2 	ldr	x2, [sp, #8]
    880003a8:	b9001843 	str	w3, [x2, #24]
    880003ac:	f94007e2 	ldr	x2, [sp, #8]
    880003b0:	b9401842 	ldr	w2, [x2, #24]
    880003b4:	7100005f 	cmp	w2, #0x0
    880003b8:	540000cd 	b.le	880003d0 <get_unsigned_arg+0x2dc>
    880003bc:	91003c01 	add	x1, x0, #0xf
    880003c0:	927df022 	and	x2, x1, #0xfffffffffffffff8
    880003c4:	f94007e1 	ldr	x1, [sp, #8]
    880003c8:	f9000022 	str	x2, [x1]
    880003cc:	14000005 	b	880003e0 <get_unsigned_arg+0x2ec>
    880003d0:	f94007e0 	ldr	x0, [sp, #8]
    880003d4:	f9400402 	ldr	x2, [x0, #8]
    880003d8:	93407c20 	sxtw	x0, w1
    880003dc:	8b000040 	add	x0, x2, x0
    880003e0:	f9400000 	ldr	x0, [x0]
    880003e4:	14000058 	b	88000544 <get_unsigned_arg+0x450>
	case LENGTH_T:
		return (uint64_t)va_arg(*args, ptrdiff_t);
    880003e8:	f94007e0 	ldr	x0, [sp, #8]
    880003ec:	b9401801 	ldr	w1, [x0, #24]
    880003f0:	f94007e0 	ldr	x0, [sp, #8]
    880003f4:	f9400000 	ldr	x0, [x0]
    880003f8:	7100003f 	cmp	w1, #0x0
    880003fc:	540000cb 	b.lt	88000414 <get_unsigned_arg+0x320>  // b.tstop
    88000400:	91003c01 	add	x1, x0, #0xf
    88000404:	927df022 	and	x2, x1, #0xfffffffffffffff8
    88000408:	f94007e1 	ldr	x1, [sp, #8]
    8800040c:	f9000022 	str	x2, [x1]
    88000410:	14000011 	b	88000454 <get_unsigned_arg+0x360>
    88000414:	11002023 	add	w3, w1, #0x8
    88000418:	f94007e2 	ldr	x2, [sp, #8]
    8800041c:	b9001843 	str	w3, [x2, #24]
    88000420:	f94007e2 	ldr	x2, [sp, #8]
    88000424:	b9401842 	ldr	w2, [x2, #24]
    88000428:	7100005f 	cmp	w2, #0x0
    8800042c:	540000cd 	b.le	88000444 <get_unsigned_arg+0x350>
    88000430:	91003c01 	add	x1, x0, #0xf
    88000434:	927df022 	and	x2, x1, #0xfffffffffffffff8
    88000438:	f94007e1 	ldr	x1, [sp, #8]
    8800043c:	f9000022 	str	x2, [x1]
    88000440:	14000005 	b	88000454 <get_unsigned_arg+0x360>
    88000444:	f94007e0 	ldr	x0, [sp, #8]
    88000448:	f9400402 	ldr	x2, [x0, #8]
    8800044c:	93407c20 	sxtw	x0, w1
    88000450:	8b000040 	add	x0, x2, x0
    88000454:	f9400000 	ldr	x0, [x0]
    88000458:	1400003b 	b	88000544 <get_unsigned_arg+0x450>
	case LENGTH_J:
		return (uint64_t)va_arg(*args, uintmax_t);
    8800045c:	f94007e0 	ldr	x0, [sp, #8]
    88000460:	b9401801 	ldr	w1, [x0, #24]
    88000464:	f94007e0 	ldr	x0, [sp, #8]
    88000468:	f9400000 	ldr	x0, [x0]
    8800046c:	7100003f 	cmp	w1, #0x0
    88000470:	540000cb 	b.lt	88000488 <get_unsigned_arg+0x394>  // b.tstop
    88000474:	91003c01 	add	x1, x0, #0xf
    88000478:	927df022 	and	x2, x1, #0xfffffffffffffff8
    8800047c:	f94007e1 	ldr	x1, [sp, #8]
    88000480:	f9000022 	str	x2, [x1]
    88000484:	14000011 	b	880004c8 <get_unsigned_arg+0x3d4>
    88000488:	11002023 	add	w3, w1, #0x8
    8800048c:	f94007e2 	ldr	x2, [sp, #8]
    88000490:	b9001843 	str	w3, [x2, #24]
    88000494:	f94007e2 	ldr	x2, [sp, #8]
    88000498:	b9401842 	ldr	w2, [x2, #24]
    8800049c:	7100005f 	cmp	w2, #0x0
    880004a0:	540000cd 	b.le	880004b8 <get_unsigned_arg+0x3c4>
    880004a4:	91003c01 	add	x1, x0, #0xf
    880004a8:	927df022 	and	x2, x1, #0xfffffffffffffff8
    880004ac:	f94007e1 	ldr	x1, [sp, #8]
    880004b0:	f9000022 	str	x2, [x1]
    880004b4:	14000005 	b	880004c8 <get_unsigned_arg+0x3d4>
    880004b8:	f94007e0 	ldr	x0, [sp, #8]
    880004bc:	f9400402 	ldr	x2, [x0, #8]
    880004c0:	93407c20 	sxtw	x0, w1
    880004c4:	8b000040 	add	x0, x2, x0
    880004c8:	f9400000 	ldr	x0, [x0]
    880004cc:	1400001e 	b	88000544 <get_unsigned_arg+0x450>
	default:
		return (uint64_t)va_arg(*args, unsigned int);
    880004d0:	f94007e0 	ldr	x0, [sp, #8]
    880004d4:	b9401801 	ldr	w1, [x0, #24]
    880004d8:	f94007e0 	ldr	x0, [sp, #8]
    880004dc:	f9400000 	ldr	x0, [x0]
    880004e0:	7100003f 	cmp	w1, #0x0
    880004e4:	540000cb 	b.lt	880004fc <get_unsigned_arg+0x408>  // b.tstop
    880004e8:	91002c01 	add	x1, x0, #0xb
    880004ec:	927df022 	and	x2, x1, #0xfffffffffffffff8
    880004f0:	f94007e1 	ldr	x1, [sp, #8]
    880004f4:	f9000022 	str	x2, [x1]
    880004f8:	14000011 	b	8800053c <get_unsigned_arg+0x448>
    880004fc:	11002023 	add	w3, w1, #0x8
    88000500:	f94007e2 	ldr	x2, [sp, #8]
    88000504:	b9001843 	str	w3, [x2, #24]
    88000508:	f94007e2 	ldr	x2, [sp, #8]
    8800050c:	b9401842 	ldr	w2, [x2, #24]
    88000510:	7100005f 	cmp	w2, #0x0
    88000514:	540000cd 	b.le	8800052c <get_unsigned_arg+0x438>
    88000518:	91002c01 	add	x1, x0, #0xb
    8800051c:	927df022 	and	x2, x1, #0xfffffffffffffff8
    88000520:	f94007e1 	ldr	x1, [sp, #8]
    88000524:	f9000022 	str	x2, [x1]
    88000528:	14000005 	b	8800053c <get_unsigned_arg+0x448>
    8800052c:	f94007e0 	ldr	x0, [sp, #8]
    88000530:	f9400402 	ldr	x2, [x0, #8]
    88000534:	93407c20 	sxtw	x0, w1
    88000538:	8b000040 	add	x0, x2, x0
    8800053c:	b9400000 	ldr	w0, [x0]
    88000540:	2a0003e0 	mov	w0, w0
	}
}
    88000544:	910043ff 	add	sp, sp, #0x10
    88000548:	d65f03c0 	ret

000000008800054c <get_signed_arg>:

static int64_t get_signed_arg(va_list *args, int length)
{
    8800054c:	d10043ff 	sub	sp, sp, #0x10
    88000550:	f90007e0 	str	x0, [sp, #8]
    88000554:	b90007e1 	str	w1, [sp, #4]
	switch (length) {
    88000558:	b94007e0 	ldr	w0, [sp, #4]
    8800055c:	71001c1f 	cmp	w0, #0x7
    88000560:	54001aa0 	b.eq	880008b4 <get_signed_arg+0x368>  // b.none
    88000564:	b94007e0 	ldr	w0, [sp, #4]
    88000568:	71001c1f 	cmp	w0, #0x7
    8800056c:	54001dec 	b.gt	88000928 <get_signed_arg+0x3dc>
    88000570:	b94007e0 	ldr	w0, [sp, #4]
    88000574:	7100181f 	cmp	w0, #0x6
    88000578:	54001640 	b.eq	88000840 <get_signed_arg+0x2f4>  // b.none
    8800057c:	b94007e0 	ldr	w0, [sp, #4]
    88000580:	7100181f 	cmp	w0, #0x6
    88000584:	54001d2c 	b.gt	88000928 <get_signed_arg+0x3dc>
    88000588:	b94007e0 	ldr	w0, [sp, #4]
    8800058c:	7100141f 	cmp	w0, #0x5
    88000590:	540011e0 	b.eq	880007cc <get_signed_arg+0x280>  // b.none
    88000594:	b94007e0 	ldr	w0, [sp, #4]
    88000598:	7100141f 	cmp	w0, #0x5
    8800059c:	54001c6c 	b.gt	88000928 <get_signed_arg+0x3dc>
    880005a0:	b94007e0 	ldr	w0, [sp, #4]
    880005a4:	7100101f 	cmp	w0, #0x4
    880005a8:	54000d80 	b.eq	88000758 <get_signed_arg+0x20c>  // b.none
    880005ac:	b94007e0 	ldr	w0, [sp, #4]
    880005b0:	7100101f 	cmp	w0, #0x4
    880005b4:	54001bac 	b.gt	88000928 <get_signed_arg+0x3dc>
    880005b8:	b94007e0 	ldr	w0, [sp, #4]
    880005bc:	71000c1f 	cmp	w0, #0x3
    880005c0:	54000920 	b.eq	880006e4 <get_signed_arg+0x198>  // b.none
    880005c4:	b94007e0 	ldr	w0, [sp, #4]
    880005c8:	71000c1f 	cmp	w0, #0x3
    880005cc:	54001aec 	b.gt	88000928 <get_signed_arg+0x3dc>
    880005d0:	b94007e0 	ldr	w0, [sp, #4]
    880005d4:	7100041f 	cmp	w0, #0x1
    880005d8:	540000a0 	b.eq	880005ec <get_signed_arg+0xa0>  // b.none
    880005dc:	b94007e0 	ldr	w0, [sp, #4]
    880005e0:	7100081f 	cmp	w0, #0x2
    880005e4:	54000420 	b.eq	88000668 <get_signed_arg+0x11c>  // b.none
    880005e8:	140000d0 	b	88000928 <get_signed_arg+0x3dc>
	case LENGTH_HH:
		return (int64_t)(signed char)va_arg(*args, int);
    880005ec:	f94007e0 	ldr	x0, [sp, #8]
    880005f0:	b9401801 	ldr	w1, [x0, #24]
    880005f4:	f94007e0 	ldr	x0, [sp, #8]
    880005f8:	f9400000 	ldr	x0, [x0]
    880005fc:	7100003f 	cmp	w1, #0x0
    88000600:	540000cb 	b.lt	88000618 <get_signed_arg+0xcc>  // b.tstop
    88000604:	91002c01 	add	x1, x0, #0xb
    88000608:	927df022 	and	x2, x1, #0xfffffffffffffff8
    8800060c:	f94007e1 	ldr	x1, [sp, #8]
    88000610:	f9000022 	str	x2, [x1]
    88000614:	14000011 	b	88000658 <get_signed_arg+0x10c>
    88000618:	11002023 	add	w3, w1, #0x8
    8800061c:	f94007e2 	ldr	x2, [sp, #8]
    88000620:	b9001843 	str	w3, [x2, #24]
    88000624:	f94007e2 	ldr	x2, [sp, #8]
    88000628:	b9401842 	ldr	w2, [x2, #24]
    8800062c:	7100005f 	cmp	w2, #0x0
    88000630:	540000cd 	b.le	88000648 <get_signed_arg+0xfc>
    88000634:	91002c01 	add	x1, x0, #0xb
    88000638:	927df022 	and	x2, x1, #0xfffffffffffffff8
    8800063c:	f94007e1 	ldr	x1, [sp, #8]
    88000640:	f9000022 	str	x2, [x1]
    88000644:	14000005 	b	88000658 <get_signed_arg+0x10c>
    88000648:	f94007e0 	ldr	x0, [sp, #8]
    8800064c:	f9400402 	ldr	x2, [x0, #8]
    88000650:	93407c20 	sxtw	x0, w1
    88000654:	8b000040 	add	x0, x2, x0
    88000658:	b9400000 	ldr	w0, [x0]
    8800065c:	13001c00 	sxtb	w0, w0
    88000660:	93401c00 	sxtb	x0, w0
    88000664:	140000ce 	b	8800099c <get_signed_arg+0x450>
	case LENGTH_H:
		return (int64_t)(short)va_arg(*args, int);
    88000668:	f94007e0 	ldr	x0, [sp, #8]
    8800066c:	b9401801 	ldr	w1, [x0, #24]
    88000670:	f94007e0 	ldr	x0, [sp, #8]
    88000674:	f9400000 	ldr	x0, [x0]
    88000678:	7100003f 	cmp	w1, #0x0
    8800067c:	540000cb 	b.lt	88000694 <get_signed_arg+0x148>  // b.tstop
    88000680:	91002c01 	add	x1, x0, #0xb
    88000684:	927df022 	and	x2, x1, #0xfffffffffffffff8
    88000688:	f94007e1 	ldr	x1, [sp, #8]
    8800068c:	f9000022 	str	x2, [x1]
    88000690:	14000011 	b	880006d4 <get_signed_arg+0x188>
    88000694:	11002023 	add	w3, w1, #0x8
    88000698:	f94007e2 	ldr	x2, [sp, #8]
    8800069c:	b9001843 	str	w3, [x2, #24]
    880006a0:	f94007e2 	ldr	x2, [sp, #8]
    880006a4:	b9401842 	ldr	w2, [x2, #24]
    880006a8:	7100005f 	cmp	w2, #0x0
    880006ac:	540000cd 	b.le	880006c4 <get_signed_arg+0x178>
    880006b0:	91002c01 	add	x1, x0, #0xb
    880006b4:	927df022 	and	x2, x1, #0xfffffffffffffff8
    880006b8:	f94007e1 	ldr	x1, [sp, #8]
    880006bc:	f9000022 	str	x2, [x1]
    880006c0:	14000005 	b	880006d4 <get_signed_arg+0x188>
    880006c4:	f94007e0 	ldr	x0, [sp, #8]
    880006c8:	f9400402 	ldr	x2, [x0, #8]
    880006cc:	93407c20 	sxtw	x0, w1
    880006d0:	8b000040 	add	x0, x2, x0
    880006d4:	b9400000 	ldr	w0, [x0]
    880006d8:	13003c00 	sxth	w0, w0
    880006dc:	93403c00 	sxth	x0, w0
    880006e0:	140000af 	b	8800099c <get_signed_arg+0x450>
	case LENGTH_L:
		return (int64_t)va_arg(*args, long);
    880006e4:	f94007e0 	ldr	x0, [sp, #8]
    880006e8:	b9401801 	ldr	w1, [x0, #24]
    880006ec:	f94007e0 	ldr	x0, [sp, #8]
    880006f0:	f9400000 	ldr	x0, [x0]
    880006f4:	7100003f 	cmp	w1, #0x0
    880006f8:	540000cb 	b.lt	88000710 <get_signed_arg+0x1c4>  // b.tstop
    880006fc:	91003c01 	add	x1, x0, #0xf
    88000700:	927df022 	and	x2, x1, #0xfffffffffffffff8
    88000704:	f94007e1 	ldr	x1, [sp, #8]
    88000708:	f9000022 	str	x2, [x1]
    8800070c:	14000011 	b	88000750 <get_signed_arg+0x204>
    88000710:	11002023 	add	w3, w1, #0x8
    88000714:	f94007e2 	ldr	x2, [sp, #8]
    88000718:	b9001843 	str	w3, [x2, #24]
    8800071c:	f94007e2 	ldr	x2, [sp, #8]
    88000720:	b9401842 	ldr	w2, [x2, #24]
    88000724:	7100005f 	cmp	w2, #0x0
    88000728:	540000cd 	b.le	88000740 <get_signed_arg+0x1f4>
    8800072c:	91003c01 	add	x1, x0, #0xf
    88000730:	927df022 	and	x2, x1, #0xfffffffffffffff8
    88000734:	f94007e1 	ldr	x1, [sp, #8]
    88000738:	f9000022 	str	x2, [x1]
    8800073c:	14000005 	b	88000750 <get_signed_arg+0x204>
    88000740:	f94007e0 	ldr	x0, [sp, #8]
    88000744:	f9400402 	ldr	x2, [x0, #8]
    88000748:	93407c20 	sxtw	x0, w1
    8800074c:	8b000040 	add	x0, x2, x0
    88000750:	f9400000 	ldr	x0, [x0]
    88000754:	14000092 	b	8800099c <get_signed_arg+0x450>
	case LENGTH_LL:
		return (int64_t)va_arg(*args, long long);
    88000758:	f94007e0 	ldr	x0, [sp, #8]
    8800075c:	b9401801 	ldr	w1, [x0, #24]
    88000760:	f94007e0 	ldr	x0, [sp, #8]
    88000764:	f9400000 	ldr	x0, [x0]
    88000768:	7100003f 	cmp	w1, #0x0
    8800076c:	540000cb 	b.lt	88000784 <get_signed_arg+0x238>  // b.tstop
    88000770:	91003c01 	add	x1, x0, #0xf
    88000774:	927df022 	and	x2, x1, #0xfffffffffffffff8
    88000778:	f94007e1 	ldr	x1, [sp, #8]
    8800077c:	f9000022 	str	x2, [x1]
    88000780:	14000011 	b	880007c4 <get_signed_arg+0x278>
    88000784:	11002023 	add	w3, w1, #0x8
    88000788:	f94007e2 	ldr	x2, [sp, #8]
    8800078c:	b9001843 	str	w3, [x2, #24]
    88000790:	f94007e2 	ldr	x2, [sp, #8]
    88000794:	b9401842 	ldr	w2, [x2, #24]
    88000798:	7100005f 	cmp	w2, #0x0
    8800079c:	540000cd 	b.le	880007b4 <get_signed_arg+0x268>
    880007a0:	91003c01 	add	x1, x0, #0xf
    880007a4:	927df022 	and	x2, x1, #0xfffffffffffffff8
    880007a8:	f94007e1 	ldr	x1, [sp, #8]
    880007ac:	f9000022 	str	x2, [x1]
    880007b0:	14000005 	b	880007c4 <get_signed_arg+0x278>
    880007b4:	f94007e0 	ldr	x0, [sp, #8]
    880007b8:	f9400402 	ldr	x2, [x0, #8]
    880007bc:	93407c20 	sxtw	x0, w1
    880007c0:	8b000040 	add	x0, x2, x0
    880007c4:	f9400000 	ldr	x0, [x0]
    880007c8:	14000075 	b	8800099c <get_signed_arg+0x450>
	case LENGTH_Z:
		return (int64_t)(ptrdiff_t)va_arg(*args, size_t);
    880007cc:	f94007e0 	ldr	x0, [sp, #8]
    880007d0:	b9401801 	ldr	w1, [x0, #24]
    880007d4:	f94007e0 	ldr	x0, [sp, #8]
    880007d8:	f9400000 	ldr	x0, [x0]
    880007dc:	7100003f 	cmp	w1, #0x0
    880007e0:	540000cb 	b.lt	880007f8 <get_signed_arg+0x2ac>  // b.tstop
    880007e4:	91003c01 	add	x1, x0, #0xf
    880007e8:	927df022 	and	x2, x1, #0xfffffffffffffff8
    880007ec:	f94007e1 	ldr	x1, [sp, #8]
    880007f0:	f9000022 	str	x2, [x1]
    880007f4:	14000011 	b	88000838 <get_signed_arg+0x2ec>
    880007f8:	11002023 	add	w3, w1, #0x8
    880007fc:	f94007e2 	ldr	x2, [sp, #8]
    88000800:	b9001843 	str	w3, [x2, #24]
    88000804:	f94007e2 	ldr	x2, [sp, #8]
    88000808:	b9401842 	ldr	w2, [x2, #24]
    8800080c:	7100005f 	cmp	w2, #0x0
    88000810:	540000cd 	b.le	88000828 <get_signed_arg+0x2dc>
    88000814:	91003c01 	add	x1, x0, #0xf
    88000818:	927df022 	and	x2, x1, #0xfffffffffffffff8
    8800081c:	f94007e1 	ldr	x1, [sp, #8]
    88000820:	f9000022 	str	x2, [x1]
    88000824:	14000005 	b	88000838 <get_signed_arg+0x2ec>
    88000828:	f94007e0 	ldr	x0, [sp, #8]
    8800082c:	f9400402 	ldr	x2, [x0, #8]
    88000830:	93407c20 	sxtw	x0, w1
    88000834:	8b000040 	add	x0, x2, x0
    88000838:	f9400000 	ldr	x0, [x0]
    8800083c:	14000058 	b	8800099c <get_signed_arg+0x450>
	case LENGTH_T:
		return (int64_t)va_arg(*args, ptrdiff_t);
    88000840:	f94007e0 	ldr	x0, [sp, #8]
    88000844:	b9401801 	ldr	w1, [x0, #24]
    88000848:	f94007e0 	ldr	x0, [sp, #8]
    8800084c:	f9400000 	ldr	x0, [x0]
    88000850:	7100003f 	cmp	w1, #0x0
    88000854:	540000cb 	b.lt	8800086c <get_signed_arg+0x320>  // b.tstop
    88000858:	91003c01 	add	x1, x0, #0xf
    8800085c:	927df022 	and	x2, x1, #0xfffffffffffffff8
    88000860:	f94007e1 	ldr	x1, [sp, #8]
    88000864:	f9000022 	str	x2, [x1]
    88000868:	14000011 	b	880008ac <get_signed_arg+0x360>
    8800086c:	11002023 	add	w3, w1, #0x8
    88000870:	f94007e2 	ldr	x2, [sp, #8]
    88000874:	b9001843 	str	w3, [x2, #24]
    88000878:	f94007e2 	ldr	x2, [sp, #8]
    8800087c:	b9401842 	ldr	w2, [x2, #24]
    88000880:	7100005f 	cmp	w2, #0x0
    88000884:	540000cd 	b.le	8800089c <get_signed_arg+0x350>
    88000888:	91003c01 	add	x1, x0, #0xf
    8800088c:	927df022 	and	x2, x1, #0xfffffffffffffff8
    88000890:	f94007e1 	ldr	x1, [sp, #8]
    88000894:	f9000022 	str	x2, [x1]
    88000898:	14000005 	b	880008ac <get_signed_arg+0x360>
    8800089c:	f94007e0 	ldr	x0, [sp, #8]
    880008a0:	f9400402 	ldr	x2, [x0, #8]
    880008a4:	93407c20 	sxtw	x0, w1
    880008a8:	8b000040 	add	x0, x2, x0
    880008ac:	f9400000 	ldr	x0, [x0]
    880008b0:	1400003b 	b	8800099c <get_signed_arg+0x450>
	case LENGTH_J:
		return (int64_t)va_arg(*args, intmax_t);
    880008b4:	f94007e0 	ldr	x0, [sp, #8]
    880008b8:	b9401801 	ldr	w1, [x0, #24]
    880008bc:	f94007e0 	ldr	x0, [sp, #8]
    880008c0:	f9400000 	ldr	x0, [x0]
    880008c4:	7100003f 	cmp	w1, #0x0
    880008c8:	540000cb 	b.lt	880008e0 <get_signed_arg+0x394>  // b.tstop
    880008cc:	91003c01 	add	x1, x0, #0xf
    880008d0:	927df022 	and	x2, x1, #0xfffffffffffffff8
    880008d4:	f94007e1 	ldr	x1, [sp, #8]
    880008d8:	f9000022 	str	x2, [x1]
    880008dc:	14000011 	b	88000920 <get_signed_arg+0x3d4>
    880008e0:	11002023 	add	w3, w1, #0x8
    880008e4:	f94007e2 	ldr	x2, [sp, #8]
    880008e8:	b9001843 	str	w3, [x2, #24]
    880008ec:	f94007e2 	ldr	x2, [sp, #8]
    880008f0:	b9401842 	ldr	w2, [x2, #24]
    880008f4:	7100005f 	cmp	w2, #0x0
    880008f8:	540000cd 	b.le	88000910 <get_signed_arg+0x3c4>
    880008fc:	91003c01 	add	x1, x0, #0xf
    88000900:	927df022 	and	x2, x1, #0xfffffffffffffff8
    88000904:	f94007e1 	ldr	x1, [sp, #8]
    88000908:	f9000022 	str	x2, [x1]
    8800090c:	14000005 	b	88000920 <get_signed_arg+0x3d4>
    88000910:	f94007e0 	ldr	x0, [sp, #8]
    88000914:	f9400402 	ldr	x2, [x0, #8]
    88000918:	93407c20 	sxtw	x0, w1
    8800091c:	8b000040 	add	x0, x2, x0
    88000920:	f9400000 	ldr	x0, [x0]
    88000924:	1400001e 	b	8800099c <get_signed_arg+0x450>
	default:
		return (int64_t)va_arg(*args, int);
    88000928:	f94007e0 	ldr	x0, [sp, #8]
    8800092c:	b9401801 	ldr	w1, [x0, #24]
    88000930:	f94007e0 	ldr	x0, [sp, #8]
    88000934:	f9400000 	ldr	x0, [x0]
    88000938:	7100003f 	cmp	w1, #0x0
    8800093c:	540000cb 	b.lt	88000954 <get_signed_arg+0x408>  // b.tstop
    88000940:	91002c01 	add	x1, x0, #0xb
    88000944:	927df022 	and	x2, x1, #0xfffffffffffffff8
    88000948:	f94007e1 	ldr	x1, [sp, #8]
    8800094c:	f9000022 	str	x2, [x1]
    88000950:	14000011 	b	88000994 <get_signed_arg+0x448>
    88000954:	11002023 	add	w3, w1, #0x8
    88000958:	f94007e2 	ldr	x2, [sp, #8]
    8800095c:	b9001843 	str	w3, [x2, #24]
    88000960:	f94007e2 	ldr	x2, [sp, #8]
    88000964:	b9401842 	ldr	w2, [x2, #24]
    88000968:	7100005f 	cmp	w2, #0x0
    8800096c:	540000cd 	b.le	88000984 <get_signed_arg+0x438>
    88000970:	91002c01 	add	x1, x0, #0xb
    88000974:	927df022 	and	x2, x1, #0xfffffffffffffff8
    88000978:	f94007e1 	ldr	x1, [sp, #8]
    8800097c:	f9000022 	str	x2, [x1]
    88000980:	14000005 	b	88000994 <get_signed_arg+0x448>
    88000984:	f94007e0 	ldr	x0, [sp, #8]
    88000988:	f9400402 	ldr	x2, [x0, #8]
    8800098c:	93407c20 	sxtw	x0, w1
    88000990:	8b000040 	add	x0, x2, x0
    88000994:	b9400000 	ldr	w0, [x0]
    88000998:	93407c00 	sxtw	x0, w0
	}
}
    8800099c:	910043ff 	add	sp, sp, #0x10
    880009a0:	d65f03c0 	ret

00000000880009a4 <u64_to_str>:

static size_t u64_to_str(uint64_t value, unsigned int base, bool upper,
			 char *buf)
{
    880009a4:	d100c3ff 	sub	sp, sp, #0x30
    880009a8:	f9000fe0 	str	x0, [sp, #24]
    880009ac:	b90017e1 	str	w1, [sp, #20]
    880009b0:	39004fe2 	strb	w2, [sp, #19]
    880009b4:	f90007e3 	str	x3, [sp, #8]
	static const char lower_digits[] = "0123456789abcdef";
	static const char upper_digits[] = "0123456789ABCDEF";
	const char *digits = upper ? upper_digits : lower_digits;
    880009b8:	39404fe0 	ldrb	w0, [sp, #19]
    880009bc:	12000000 	and	w0, w0, #0x1
    880009c0:	7100001f 	cmp	w0, #0x0
    880009c4:	54000080 	b.eq	880009d4 <u64_to_str+0x30>  // b.none
    880009c8:	d0000000 	adrp	x0, 88002000 <uart_rx_ready+0x1c>
    880009cc:	912ee000 	add	x0, x0, #0xbb8
    880009d0:	14000003 	b	880009dc <u64_to_str+0x38>
    880009d4:	d0000000 	adrp	x0, 88002000 <uart_rx_ready+0x1c>
    880009d8:	912f4000 	add	x0, x0, #0xbd0
    880009dc:	f90013e0 	str	x0, [sp, #32]
	size_t len = 0U;
    880009e0:	f90017ff 	str	xzr, [sp, #40]

	do {
		buf[len++] = digits[value % base];
    880009e4:	b94017e1 	ldr	w1, [sp, #20]
    880009e8:	f9400fe0 	ldr	x0, [sp, #24]
    880009ec:	9ac10802 	udiv	x2, x0, x1
    880009f0:	9b017c41 	mul	x1, x2, x1
    880009f4:	cb010000 	sub	x0, x0, x1
    880009f8:	f94013e1 	ldr	x1, [sp, #32]
    880009fc:	8b000021 	add	x1, x1, x0
    88000a00:	f94017e0 	ldr	x0, [sp, #40]
    88000a04:	91000402 	add	x2, x0, #0x1
    88000a08:	f90017e2 	str	x2, [sp, #40]
    88000a0c:	f94007e2 	ldr	x2, [sp, #8]
    88000a10:	8b000040 	add	x0, x2, x0
    88000a14:	39400021 	ldrb	w1, [x1]
    88000a18:	39000001 	strb	w1, [x0]
		value /= base;
    88000a1c:	b94017e0 	ldr	w0, [sp, #20]
    88000a20:	f9400fe1 	ldr	x1, [sp, #24]
    88000a24:	9ac00820 	udiv	x0, x1, x0
    88000a28:	f9000fe0 	str	x0, [sp, #24]
	} while (value != 0U);
    88000a2c:	f9400fe0 	ldr	x0, [sp, #24]
    88000a30:	f100001f 	cmp	x0, #0x0
    88000a34:	54fffd81 	b.ne	880009e4 <u64_to_str+0x40>  // b.any

	return len;
    88000a38:	f94017e0 	ldr	x0, [sp, #40]
}
    88000a3c:	9100c3ff 	add	sp, sp, #0x30
    88000a40:	d65f03c0 	ret

0000000088000a44 <print_buffer>:

static void print_buffer(struct print_ctx *ctx, const char *buf, size_t len)
{
    88000a44:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
    88000a48:	910003fd 	mov	x29, sp
    88000a4c:	f90017e0 	str	x0, [sp, #40]
    88000a50:	f90013e1 	str	x1, [sp, #32]
    88000a54:	f9000fe2 	str	x2, [sp, #24]
	while (len-- > 0U) {
    88000a58:	14000008 	b	88000a78 <print_buffer+0x34>
		print_char(ctx, *buf++);
    88000a5c:	f94013e0 	ldr	x0, [sp, #32]
    88000a60:	91000401 	add	x1, x0, #0x1
    88000a64:	f90013e1 	str	x1, [sp, #32]
    88000a68:	39400000 	ldrb	w0, [x0]
    88000a6c:	2a0003e1 	mov	w1, w0
    88000a70:	f94017e0 	ldr	x0, [sp, #40]
    88000a74:	97fffd6b 	bl	88000020 <print_char>
	while (len-- > 0U) {
    88000a78:	f9400fe0 	ldr	x0, [sp, #24]
    88000a7c:	d1000401 	sub	x1, x0, #0x1
    88000a80:	f9000fe1 	str	x1, [sp, #24]
    88000a84:	f100001f 	cmp	x0, #0x0
    88000a88:	54fffea1 	b.ne	88000a5c <print_buffer+0x18>  // b.any
	}
}
    88000a8c:	d503201f 	nop
    88000a90:	d503201f 	nop
    88000a94:	a8c37bfd 	ldp	x29, x30, [sp], #48
    88000a98:	d65f03c0 	ret

0000000088000a9c <format_integer>:

static void format_integer(struct print_ctx *ctx, struct format_spec *spec,
			   uint64_t value, bool negative, unsigned int base)
{
    88000a9c:	a9b77bfd 	stp	x29, x30, [sp, #-144]!
    88000aa0:	910003fd 	mov	x29, sp
    88000aa4:	f90017e0 	str	x0, [sp, #40]
    88000aa8:	f90013e1 	str	x1, [sp, #32]
    88000aac:	f9000fe2 	str	x2, [sp, #24]
    88000ab0:	39005fe3 	strb	w3, [sp, #23]
    88000ab4:	b90013e4 	str	w4, [sp, #16]
	char digits[32];
	char prefix[3];
	size_t digits_len;
	size_t prefix_len = 0U;
    88000ab8:	f90043ff 	str	xzr, [sp, #128]
	size_t zero_pad = 0U;
    88000abc:	f9003fff 	str	xzr, [sp, #120]
	size_t total_len;
	int pad_len;
	bool precision_specified = spec->precision >= 0;
    88000ac0:	f94013e0 	ldr	x0, [sp, #32]
    88000ac4:	b9400800 	ldr	w0, [x0, #8]
    88000ac8:	2a2003e0 	mvn	w0, w0
    88000acc:	531f7c00 	lsr	w0, w0, #31
    88000ad0:	3901dfe0 	strb	w0, [sp, #119]
	bool zero_value_suppressed = precision_specified &&
		(spec->precision == 0) && (value == 0U);
    88000ad4:	3941dfe0 	ldrb	w0, [sp, #119]
    88000ad8:	12000000 	and	w0, w0, #0x1
    88000adc:	7100001f 	cmp	w0, #0x0
    88000ae0:	54000140 	b.eq	88000b08 <format_integer+0x6c>  // b.none
    88000ae4:	f94013e0 	ldr	x0, [sp, #32]
    88000ae8:	b9400800 	ldr	w0, [x0, #8]
	bool zero_value_suppressed = precision_specified &&
    88000aec:	7100001f 	cmp	w0, #0x0
    88000af0:	540000c1 	b.ne	88000b08 <format_integer+0x6c>  // b.any
		(spec->precision == 0) && (value == 0U);
    88000af4:	f9400fe0 	ldr	x0, [sp, #24]
    88000af8:	f100001f 	cmp	x0, #0x0
    88000afc:	54000061 	b.ne	88000b08 <format_integer+0x6c>  // b.any
    88000b00:	52800020 	mov	w0, #0x1                   	// #1
    88000b04:	14000002 	b	88000b0c <format_integer+0x70>
    88000b08:	52800000 	mov	w0, #0x0                   	// #0
	bool zero_value_suppressed = precision_specified &&
    88000b0c:	3901dbe0 	strb	w0, [sp, #118]
    88000b10:	3941dbe0 	ldrb	w0, [sp, #118]
    88000b14:	12000000 	and	w0, w0, #0x1
    88000b18:	3901dbe0 	strb	w0, [sp, #118]

	if (negative) {
    88000b1c:	39405fe0 	ldrb	w0, [sp, #23]
    88000b20:	12000000 	and	w0, w0, #0x1
    88000b24:	7100001f 	cmp	w0, #0x0
    88000b28:	54000100 	b.eq	88000b48 <format_integer+0xac>  // b.none
		prefix[prefix_len++] = '-';
    88000b2c:	f94043e0 	ldr	x0, [sp, #128]
    88000b30:	91000401 	add	x1, x0, #0x1
    88000b34:	f90043e1 	str	x1, [sp, #128]
    88000b38:	9100e3e1 	add	x1, sp, #0x38
    88000b3c:	528005a2 	mov	w2, #0x2d                  	// #45
    88000b40:	38206822 	strb	w2, [x1, x0]
    88000b44:	14000018 	b	88000ba4 <format_integer+0x108>
	} else if ((spec->flags & FLAG_PLUS) != 0U) {
    88000b48:	f94013e0 	ldr	x0, [sp, #32]
    88000b4c:	b9400000 	ldr	w0, [x0]
    88000b50:	121f0000 	and	w0, w0, #0x2
    88000b54:	7100001f 	cmp	w0, #0x0
    88000b58:	54000100 	b.eq	88000b78 <format_integer+0xdc>  // b.none
		prefix[prefix_len++] = '+';
    88000b5c:	f94043e0 	ldr	x0, [sp, #128]
    88000b60:	91000401 	add	x1, x0, #0x1
    88000b64:	f90043e1 	str	x1, [sp, #128]
    88000b68:	9100e3e1 	add	x1, sp, #0x38
    88000b6c:	52800562 	mov	w2, #0x2b                  	// #43
    88000b70:	38206822 	strb	w2, [x1, x0]
    88000b74:	1400000c 	b	88000ba4 <format_integer+0x108>
	} else if ((spec->flags & FLAG_SPACE) != 0U) {
    88000b78:	f94013e0 	ldr	x0, [sp, #32]
    88000b7c:	b9400000 	ldr	w0, [x0]
    88000b80:	121e0000 	and	w0, w0, #0x4
    88000b84:	7100001f 	cmp	w0, #0x0
    88000b88:	540000e0 	b.eq	88000ba4 <format_integer+0x108>  // b.none
		prefix[prefix_len++] = ' ';
    88000b8c:	f94043e0 	ldr	x0, [sp, #128]
    88000b90:	91000401 	add	x1, x0, #0x1
    88000b94:	f90043e1 	str	x1, [sp, #128]
    88000b98:	9100e3e1 	add	x1, sp, #0x38
    88000b9c:	52800402 	mov	w2, #0x20                  	// #32
    88000ba0:	38206822 	strb	w2, [x1, x0]
	}

	if ((spec->flags & FLAG_ALT) != 0U) {
    88000ba4:	f94013e0 	ldr	x0, [sp, #32]
    88000ba8:	b9400000 	ldr	w0, [x0]
    88000bac:	121d0000 	and	w0, w0, #0x8
    88000bb0:	7100001f 	cmp	w0, #0x0
    88000bb4:	54000620 	b.eq	88000c78 <format_integer+0x1dc>  // b.none
		if ((base == 8U) && ((value != 0U) || !precision_specified || (spec->precision == 0))) {
    88000bb8:	b94013e0 	ldr	w0, [sp, #16]
    88000bbc:	7100201f 	cmp	w0, #0x8
    88000bc0:	540002a1 	b.ne	88000c14 <format_integer+0x178>  // b.any
    88000bc4:	f9400fe0 	ldr	x0, [sp, #24]
    88000bc8:	f100001f 	cmp	x0, #0x0
    88000bcc:	54000161 	b.ne	88000bf8 <format_integer+0x15c>  // b.any
    88000bd0:	3941dfe0 	ldrb	w0, [sp, #119]
    88000bd4:	52000000 	eor	w0, w0, #0x1
    88000bd8:	12001c00 	and	w0, w0, #0xff
    88000bdc:	12000000 	and	w0, w0, #0x1
    88000be0:	7100001f 	cmp	w0, #0x0
    88000be4:	540000a1 	b.ne	88000bf8 <format_integer+0x15c>  // b.any
    88000be8:	f94013e0 	ldr	x0, [sp, #32]
    88000bec:	b9400800 	ldr	w0, [x0, #8]
    88000bf0:	7100001f 	cmp	w0, #0x0
    88000bf4:	54000101 	b.ne	88000c14 <format_integer+0x178>  // b.any
			prefix[prefix_len++] = '0';
    88000bf8:	f94043e0 	ldr	x0, [sp, #128]
    88000bfc:	91000401 	add	x1, x0, #0x1
    88000c00:	f90043e1 	str	x1, [sp, #128]
    88000c04:	9100e3e1 	add	x1, sp, #0x38
    88000c08:	52800602 	mov	w2, #0x30                  	// #48
    88000c0c:	38206822 	strb	w2, [x1, x0]
    88000c10:	1400001a 	b	88000c78 <format_integer+0x1dc>
		} else if ((base == 16U) && (value != 0U)) {
    88000c14:	b94013e0 	ldr	w0, [sp, #16]
    88000c18:	7100401f 	cmp	w0, #0x10
    88000c1c:	540002e1 	b.ne	88000c78 <format_integer+0x1dc>  // b.any
    88000c20:	f9400fe0 	ldr	x0, [sp, #24]
    88000c24:	f100001f 	cmp	x0, #0x0
    88000c28:	54000280 	b.eq	88000c78 <format_integer+0x1dc>  // b.none
			prefix[prefix_len++] = '0';
    88000c2c:	f94043e0 	ldr	x0, [sp, #128]
    88000c30:	91000401 	add	x1, x0, #0x1
    88000c34:	f90043e1 	str	x1, [sp, #128]
    88000c38:	9100e3e1 	add	x1, sp, #0x38
    88000c3c:	52800602 	mov	w2, #0x30                  	// #48
    88000c40:	38206822 	strb	w2, [x1, x0]
			prefix[prefix_len++] = ((spec->flags & FLAG_UPPER) != 0U) ? 'X' : 'x';
    88000c44:	f94013e0 	ldr	x0, [sp, #32]
    88000c48:	b9400000 	ldr	w0, [x0]
    88000c4c:	121b0000 	and	w0, w0, #0x20
    88000c50:	7100001f 	cmp	w0, #0x0
    88000c54:	54000060 	b.eq	88000c60 <format_integer+0x1c4>  // b.none
    88000c58:	52800b01 	mov	w1, #0x58                  	// #88
    88000c5c:	14000002 	b	88000c64 <format_integer+0x1c8>
    88000c60:	52800f01 	mov	w1, #0x78                  	// #120
    88000c64:	f94043e0 	ldr	x0, [sp, #128]
    88000c68:	91000402 	add	x2, x0, #0x1
    88000c6c:	f90043e2 	str	x2, [sp, #128]
    88000c70:	9100e3e2 	add	x2, sp, #0x38
    88000c74:	38206841 	strb	w1, [x2, x0]
		}
	}

	if (zero_value_suppressed) {
    88000c78:	3941dbe0 	ldrb	w0, [sp, #118]
    88000c7c:	12000000 	and	w0, w0, #0x1
    88000c80:	7100001f 	cmp	w0, #0x0
    88000c84:	54000060 	b.eq	88000c90 <format_integer+0x1f4>  // b.none
		digits_len = 0U;
    88000c88:	f90047ff 	str	xzr, [sp, #136]
    88000c8c:	1400000e 	b	88000cc4 <format_integer+0x228>
	} else {
		digits_len = u64_to_str(value, base, (spec->flags & FLAG_UPPER) != 0U,
    88000c90:	f94013e0 	ldr	x0, [sp, #32]
    88000c94:	b9400000 	ldr	w0, [x0]
    88000c98:	121b0000 	and	w0, w0, #0x20
    88000c9c:	7100001f 	cmp	w0, #0x0
    88000ca0:	1a9f07e0 	cset	w0, ne	// ne = any
    88000ca4:	12001c01 	and	w1, w0, #0xff
    88000ca8:	910103e0 	add	x0, sp, #0x40
    88000cac:	aa0003e3 	mov	x3, x0
    88000cb0:	2a0103e2 	mov	w2, w1
    88000cb4:	b94013e1 	ldr	w1, [sp, #16]
    88000cb8:	f9400fe0 	ldr	x0, [sp, #24]
    88000cbc:	97ffff3a 	bl	880009a4 <u64_to_str>
    88000cc0:	f90047e0 	str	x0, [sp, #136]
				      digits);
	}

	if (precision_specified && ((size_t)spec->precision > digits_len)) {
    88000cc4:	3941dfe0 	ldrb	w0, [sp, #119]
    88000cc8:	12000000 	and	w0, w0, #0x1
    88000ccc:	7100001f 	cmp	w0, #0x0
    88000cd0:	540001c0 	b.eq	88000d08 <format_integer+0x26c>  // b.none
    88000cd4:	f94013e0 	ldr	x0, [sp, #32]
    88000cd8:	b9400800 	ldr	w0, [x0, #8]
    88000cdc:	93407c00 	sxtw	x0, w0
    88000ce0:	f94047e1 	ldr	x1, [sp, #136]
    88000ce4:	eb00003f 	cmp	x1, x0
    88000ce8:	54000102 	b.cs	88000d08 <format_integer+0x26c>  // b.hs, b.nlast
		zero_pad = (size_t)spec->precision - digits_len;
    88000cec:	f94013e0 	ldr	x0, [sp, #32]
    88000cf0:	b9400800 	ldr	w0, [x0, #8]
    88000cf4:	93407c01 	sxtw	x1, w0
    88000cf8:	f94047e0 	ldr	x0, [sp, #136]
    88000cfc:	cb000020 	sub	x0, x1, x0
    88000d00:	f9003fe0 	str	x0, [sp, #120]
    88000d04:	14000021 	b	88000d88 <format_integer+0x2ec>
	} else if (((spec->flags & FLAG_ZERO) != 0U) &&
    88000d08:	f94013e0 	ldr	x0, [sp, #32]
    88000d0c:	b9400000 	ldr	w0, [x0]
    88000d10:	121c0000 	and	w0, w0, #0x10
    88000d14:	7100001f 	cmp	w0, #0x0
    88000d18:	54000380 	b.eq	88000d88 <format_integer+0x2ec>  // b.none
		   ((spec->flags & FLAG_LEFT) == 0U) &&
    88000d1c:	f94013e0 	ldr	x0, [sp, #32]
    88000d20:	b9400000 	ldr	w0, [x0]
    88000d24:	12000000 	and	w0, w0, #0x1
	} else if (((spec->flags & FLAG_ZERO) != 0U) &&
    88000d28:	7100001f 	cmp	w0, #0x0
    88000d2c:	540002e1 	b.ne	88000d88 <format_integer+0x2ec>  // b.any
		   !precision_specified &&
    88000d30:	3941dfe0 	ldrb	w0, [sp, #119]
    88000d34:	52000000 	eor	w0, w0, #0x1
    88000d38:	12001c00 	and	w0, w0, #0xff
		   ((spec->flags & FLAG_LEFT) == 0U) &&
    88000d3c:	12000000 	and	w0, w0, #0x1
    88000d40:	7100001f 	cmp	w0, #0x0
    88000d44:	54000220 	b.eq	88000d88 <format_integer+0x2ec>  // b.none
		   (spec->width > (int)(prefix_len + digits_len))) {
    88000d48:	f94013e0 	ldr	x0, [sp, #32]
    88000d4c:	b9400400 	ldr	w0, [x0, #4]
    88000d50:	f94043e1 	ldr	x1, [sp, #128]
    88000d54:	2a0103e2 	mov	w2, w1
    88000d58:	f94047e1 	ldr	x1, [sp, #136]
    88000d5c:	0b010041 	add	w1, w2, w1
		   !precision_specified &&
    88000d60:	6b01001f 	cmp	w0, w1
    88000d64:	5400012d 	b.le	88000d88 <format_integer+0x2ec>
		zero_pad = (size_t)spec->width - prefix_len - digits_len;
    88000d68:	f94013e0 	ldr	x0, [sp, #32]
    88000d6c:	b9400400 	ldr	w0, [x0, #4]
    88000d70:	93407c01 	sxtw	x1, w0
    88000d74:	f94043e0 	ldr	x0, [sp, #128]
    88000d78:	cb000021 	sub	x1, x1, x0
    88000d7c:	f94047e0 	ldr	x0, [sp, #136]
    88000d80:	cb000020 	sub	x0, x1, x0
    88000d84:	f9003fe0 	str	x0, [sp, #120]
	}

	total_len = prefix_len + zero_pad + digits_len;
    88000d88:	f94043e1 	ldr	x1, [sp, #128]
    88000d8c:	f9403fe0 	ldr	x0, [sp, #120]
    88000d90:	8b000020 	add	x0, x1, x0
    88000d94:	f94047e1 	ldr	x1, [sp, #136]
    88000d98:	8b000020 	add	x0, x1, x0
    88000d9c:	f90037e0 	str	x0, [sp, #104]
	pad_len = (spec->width > (int)total_len) ? spec->width - (int)total_len : 0;
    88000da0:	f94013e0 	ldr	x0, [sp, #32]
    88000da4:	b9400400 	ldr	w0, [x0, #4]
    88000da8:	f94037e1 	ldr	x1, [sp, #104]
    88000dac:	6b01001f 	cmp	w0, w1
    88000db0:	540000cd 	b.le	88000dc8 <format_integer+0x32c>
    88000db4:	f94013e0 	ldr	x0, [sp, #32]
    88000db8:	b9400400 	ldr	w0, [x0, #4]
    88000dbc:	f94037e1 	ldr	x1, [sp, #104]
    88000dc0:	4b010000 	sub	w0, w0, w1
    88000dc4:	14000002 	b	88000dcc <format_integer+0x330>
    88000dc8:	52800000 	mov	w0, #0x0                   	// #0
    88000dcc:	b90067e0 	str	w0, [sp, #100]

	if ((spec->flags & FLAG_LEFT) == 0U) {
    88000dd0:	f94013e0 	ldr	x0, [sp, #32]
    88000dd4:	b9400000 	ldr	w0, [x0]
    88000dd8:	12000000 	and	w0, w0, #0x1
    88000ddc:	7100001f 	cmp	w0, #0x0
    88000de0:	540000a1 	b.ne	88000df4 <format_integer+0x358>  // b.any
		print_repeat(ctx, ' ', pad_len);
    88000de4:	b94067e2 	ldr	w2, [sp, #100]
    88000de8:	52800401 	mov	w1, #0x20                  	// #32
    88000dec:	f94017e0 	ldr	x0, [sp, #40]
    88000df0:	97fffc9f 	bl	8800006c <print_repeat>
	}

	print_buffer(ctx, prefix, prefix_len);
    88000df4:	9100e3e0 	add	x0, sp, #0x38
    88000df8:	f94043e2 	ldr	x2, [sp, #128]
    88000dfc:	aa0003e1 	mov	x1, x0
    88000e00:	f94017e0 	ldr	x0, [sp, #40]
    88000e04:	97ffff10 	bl	88000a44 <print_buffer>
	print_repeat(ctx, '0', (int)zero_pad);
    88000e08:	f9403fe0 	ldr	x0, [sp, #120]
    88000e0c:	2a0003e2 	mov	w2, w0
    88000e10:	52800601 	mov	w1, #0x30                  	// #48
    88000e14:	f94017e0 	ldr	x0, [sp, #40]
    88000e18:	97fffc95 	bl	8800006c <print_repeat>
	while (digits_len-- > 0U) {
    88000e1c:	14000007 	b	88000e38 <format_integer+0x39c>
		print_char(ctx, digits[digits_len]);
    88000e20:	f94047e0 	ldr	x0, [sp, #136]
    88000e24:	910103e1 	add	x1, sp, #0x40
    88000e28:	38606820 	ldrb	w0, [x1, x0]
    88000e2c:	2a0003e1 	mov	w1, w0
    88000e30:	f94017e0 	ldr	x0, [sp, #40]
    88000e34:	97fffc7b 	bl	88000020 <print_char>
	while (digits_len-- > 0U) {
    88000e38:	f94047e0 	ldr	x0, [sp, #136]
    88000e3c:	d1000401 	sub	x1, x0, #0x1
    88000e40:	f90047e1 	str	x1, [sp, #136]
    88000e44:	f100001f 	cmp	x0, #0x0
    88000e48:	54fffec1 	b.ne	88000e20 <format_integer+0x384>  // b.any
	}

	if ((spec->flags & FLAG_LEFT) != 0U) {
    88000e4c:	f94013e0 	ldr	x0, [sp, #32]
    88000e50:	b9400000 	ldr	w0, [x0]
    88000e54:	12000000 	and	w0, w0, #0x1
    88000e58:	7100001f 	cmp	w0, #0x0
    88000e5c:	540000a0 	b.eq	88000e70 <format_integer+0x3d4>  // b.none
		print_repeat(ctx, ' ', pad_len);
    88000e60:	b94067e2 	ldr	w2, [sp, #100]
    88000e64:	52800401 	mov	w1, #0x20                  	// #32
    88000e68:	f94017e0 	ldr	x0, [sp, #40]
    88000e6c:	97fffc80 	bl	8800006c <print_repeat>
	}
}
    88000e70:	d503201f 	nop
    88000e74:	a8c97bfd 	ldp	x29, x30, [sp], #144
    88000e78:	d65f03c0 	ret

0000000088000e7c <format_string>:

static void format_string(struct print_ctx *ctx, struct format_spec *spec,
			  const char *str)
{
    88000e7c:	a9bc7bfd 	stp	x29, x30, [sp, #-64]!
    88000e80:	910003fd 	mov	x29, sp
    88000e84:	f90017e0 	str	x0, [sp, #40]
    88000e88:	f90013e1 	str	x1, [sp, #32]
    88000e8c:	f9000fe2 	str	x2, [sp, #24]
	size_t len;
	int pad_len;

	if (str == NULL) {
    88000e90:	f9400fe0 	ldr	x0, [sp, #24]
    88000e94:	f100001f 	cmp	x0, #0x0
    88000e98:	54000081 	b.ne	88000ea8 <format_string+0x2c>  // b.any
		str = "(null)";
    88000e9c:	d0000000 	adrp	x0, 88002000 <uart_rx_ready+0x1c>
    88000ea0:	912ec000 	add	x0, x0, #0xbb0
    88000ea4:	f9000fe0 	str	x0, [sp, #24]
	}

	len = str_length(str);
    88000ea8:	f9400fe0 	ldr	x0, [sp, #24]
    88000eac:	97fffc82 	bl	880000b4 <str_length>
    88000eb0:	f9001fe0 	str	x0, [sp, #56]
	if ((spec->precision >= 0) && ((size_t)spec->precision < len)) {
    88000eb4:	f94013e0 	ldr	x0, [sp, #32]
    88000eb8:	b9400800 	ldr	w0, [x0, #8]
    88000ebc:	7100001f 	cmp	w0, #0x0
    88000ec0:	5400016b 	b.lt	88000eec <format_string+0x70>  // b.tstop
    88000ec4:	f94013e0 	ldr	x0, [sp, #32]
    88000ec8:	b9400800 	ldr	w0, [x0, #8]
    88000ecc:	93407c00 	sxtw	x0, w0
    88000ed0:	f9401fe1 	ldr	x1, [sp, #56]
    88000ed4:	eb00003f 	cmp	x1, x0
    88000ed8:	540000a9 	b.ls	88000eec <format_string+0x70>  // b.plast
		len = (size_t)spec->precision;
    88000edc:	f94013e0 	ldr	x0, [sp, #32]
    88000ee0:	b9400800 	ldr	w0, [x0, #8]
    88000ee4:	93407c00 	sxtw	x0, w0
    88000ee8:	f9001fe0 	str	x0, [sp, #56]
	}

	pad_len = (spec->width > (int)len) ? spec->width - (int)len : 0;
    88000eec:	f94013e0 	ldr	x0, [sp, #32]
    88000ef0:	b9400400 	ldr	w0, [x0, #4]
    88000ef4:	f9401fe1 	ldr	x1, [sp, #56]
    88000ef8:	6b01001f 	cmp	w0, w1
    88000efc:	540000cd 	b.le	88000f14 <format_string+0x98>
    88000f00:	f94013e0 	ldr	x0, [sp, #32]
    88000f04:	b9400400 	ldr	w0, [x0, #4]
    88000f08:	f9401fe1 	ldr	x1, [sp, #56]
    88000f0c:	4b010000 	sub	w0, w0, w1
    88000f10:	14000002 	b	88000f18 <format_string+0x9c>
    88000f14:	52800000 	mov	w0, #0x0                   	// #0
    88000f18:	b90037e0 	str	w0, [sp, #52]
	if ((spec->flags & FLAG_LEFT) == 0U) {
    88000f1c:	f94013e0 	ldr	x0, [sp, #32]
    88000f20:	b9400000 	ldr	w0, [x0]
    88000f24:	12000000 	and	w0, w0, #0x1
    88000f28:	7100001f 	cmp	w0, #0x0
    88000f2c:	540000a1 	b.ne	88000f40 <format_string+0xc4>  // b.any
		print_repeat(ctx, ' ', pad_len);
    88000f30:	b94037e2 	ldr	w2, [sp, #52]
    88000f34:	52800401 	mov	w1, #0x20                  	// #32
    88000f38:	f94017e0 	ldr	x0, [sp, #40]
    88000f3c:	97fffc4c 	bl	8800006c <print_repeat>
	}
	print_buffer(ctx, str, len);
    88000f40:	f9401fe2 	ldr	x2, [sp, #56]
    88000f44:	f9400fe1 	ldr	x1, [sp, #24]
    88000f48:	f94017e0 	ldr	x0, [sp, #40]
    88000f4c:	97fffebe 	bl	88000a44 <print_buffer>
	if ((spec->flags & FLAG_LEFT) != 0U) {
    88000f50:	f94013e0 	ldr	x0, [sp, #32]
    88000f54:	b9400000 	ldr	w0, [x0]
    88000f58:	12000000 	and	w0, w0, #0x1
    88000f5c:	7100001f 	cmp	w0, #0x0
    88000f60:	540000a0 	b.eq	88000f74 <format_string+0xf8>  // b.none
		print_repeat(ctx, ' ', pad_len);
    88000f64:	b94037e2 	ldr	w2, [sp, #52]
    88000f68:	52800401 	mov	w1, #0x20                  	// #32
    88000f6c:	f94017e0 	ldr	x0, [sp, #40]
    88000f70:	97fffc3f 	bl	8800006c <print_repeat>
	}
}
    88000f74:	d503201f 	nop
    88000f78:	a8c47bfd 	ldp	x29, x30, [sp], #64
    88000f7c:	d65f03c0 	ret

0000000088000f80 <format_char>:

static void format_char(struct print_ctx *ctx, struct format_spec *spec, char ch)
{
    88000f80:	a9bc7bfd 	stp	x29, x30, [sp, #-64]!
    88000f84:	910003fd 	mov	x29, sp
    88000f88:	f90017e0 	str	x0, [sp, #40]
    88000f8c:	f90013e1 	str	x1, [sp, #32]
    88000f90:	39007fe2 	strb	w2, [sp, #31]
	int pad_len = (spec->width > 1) ? spec->width - 1 : 0;
    88000f94:	f94013e0 	ldr	x0, [sp, #32]
    88000f98:	b9400400 	ldr	w0, [x0, #4]
    88000f9c:	52800021 	mov	w1, #0x1                   	// #1
    88000fa0:	7100001f 	cmp	w0, #0x0
    88000fa4:	1a81c000 	csel	w0, w0, w1, gt
    88000fa8:	51000400 	sub	w0, w0, #0x1
    88000fac:	b9003fe0 	str	w0, [sp, #60]

	if ((spec->flags & FLAG_LEFT) == 0U) {
    88000fb0:	f94013e0 	ldr	x0, [sp, #32]
    88000fb4:	b9400000 	ldr	w0, [x0]
    88000fb8:	12000000 	and	w0, w0, #0x1
    88000fbc:	7100001f 	cmp	w0, #0x0
    88000fc0:	540000a1 	b.ne	88000fd4 <format_char+0x54>  // b.any
		print_repeat(ctx, ' ', pad_len);
    88000fc4:	b9403fe2 	ldr	w2, [sp, #60]
    88000fc8:	52800401 	mov	w1, #0x20                  	// #32
    88000fcc:	f94017e0 	ldr	x0, [sp, #40]
    88000fd0:	97fffc27 	bl	8800006c <print_repeat>
	}
	print_char(ctx, ch);
    88000fd4:	39407fe1 	ldrb	w1, [sp, #31]
    88000fd8:	f94017e0 	ldr	x0, [sp, #40]
    88000fdc:	97fffc11 	bl	88000020 <print_char>
	if ((spec->flags & FLAG_LEFT) != 0U) {
    88000fe0:	f94013e0 	ldr	x0, [sp, #32]
    88000fe4:	b9400000 	ldr	w0, [x0]
    88000fe8:	12000000 	and	w0, w0, #0x1
    88000fec:	7100001f 	cmp	w0, #0x0
    88000ff0:	540000a0 	b.eq	88001004 <format_char+0x84>  // b.none
		print_repeat(ctx, ' ', pad_len);
    88000ff4:	b9403fe2 	ldr	w2, [sp, #60]
    88000ff8:	52800401 	mov	w1, #0x20                  	// #32
    88000ffc:	f94017e0 	ldr	x0, [sp, #40]
    88001000:	97fffc1b 	bl	8800006c <print_repeat>
	}
}
    88001004:	d503201f 	nop
    88001008:	a8c47bfd 	ldp	x29, x30, [sp], #64
    8800100c:	d65f03c0 	ret

0000000088001010 <parse_number>:

static bool parse_number(const char **fmt, int *value)
{
    88001010:	d10083ff 	sub	sp, sp, #0x20
    88001014:	f90007e0 	str	x0, [sp, #8]
    88001018:	f90003e1 	str	x1, [sp]
	bool found = false;
    8800101c:	39007fff 	strb	wzr, [sp, #31]
	int result = 0;
    88001020:	b9001bff 	str	wzr, [sp, #24]

	while ((**fmt >= '0') && (**fmt <= '9')) {
    88001024:	14000014 	b	88001074 <parse_number+0x64>
		found = true;
    88001028:	52800020 	mov	w0, #0x1                   	// #1
    8800102c:	39007fe0 	strb	w0, [sp, #31]
		result = result * 10 + (**fmt - '0');
    88001030:	b9401be1 	ldr	w1, [sp, #24]
    88001034:	2a0103e0 	mov	w0, w1
    88001038:	531e7400 	lsl	w0, w0, #2
    8800103c:	0b010000 	add	w0, w0, w1
    88001040:	531f7800 	lsl	w0, w0, #1
    88001044:	2a0003e1 	mov	w1, w0
    88001048:	f94007e0 	ldr	x0, [sp, #8]
    8800104c:	f9400000 	ldr	x0, [x0]
    88001050:	39400000 	ldrb	w0, [x0]
    88001054:	5100c000 	sub	w0, w0, #0x30
    88001058:	0b000020 	add	w0, w1, w0
    8800105c:	b9001be0 	str	w0, [sp, #24]
		(*fmt)++;
    88001060:	f94007e0 	ldr	x0, [sp, #8]
    88001064:	f9400000 	ldr	x0, [x0]
    88001068:	91000401 	add	x1, x0, #0x1
    8800106c:	f94007e0 	ldr	x0, [sp, #8]
    88001070:	f9000001 	str	x1, [x0]
	while ((**fmt >= '0') && (**fmt <= '9')) {
    88001074:	f94007e0 	ldr	x0, [sp, #8]
    88001078:	f9400000 	ldr	x0, [x0]
    8800107c:	39400000 	ldrb	w0, [x0]
    88001080:	7100bc1f 	cmp	w0, #0x2f
    88001084:	540000c9 	b.ls	8800109c <parse_number+0x8c>  // b.plast
    88001088:	f94007e0 	ldr	x0, [sp, #8]
    8800108c:	f9400000 	ldr	x0, [x0]
    88001090:	39400000 	ldrb	w0, [x0]
    88001094:	7100e41f 	cmp	w0, #0x39
    88001098:	54fffc89 	b.ls	88001028 <parse_number+0x18>  // b.plast
	}

	*value = result;
    8800109c:	f94003e0 	ldr	x0, [sp]
    880010a0:	b9401be1 	ldr	w1, [sp, #24]
    880010a4:	b9000001 	str	w1, [x0]
	return found;
    880010a8:	39407fe0 	ldrb	w0, [sp, #31]
}
    880010ac:	910083ff 	add	sp, sp, #0x20
    880010b0:	d65f03c0 	ret

00000000880010b4 <parse_format>:

static void parse_format(const char **fmt, struct format_spec *spec, va_list *args)
{
    880010b4:	a9bc7bfd 	stp	x29, x30, [sp, #-64]!
    880010b8:	910003fd 	mov	x29, sp
    880010bc:	f90017e0 	str	x0, [sp, #40]
    880010c0:	f90013e1 	str	x1, [sp, #32]
    880010c4:	f9000fe2 	str	x2, [sp, #24]
	const char *p = *fmt;
    880010c8:	f94017e0 	ldr	x0, [sp, #40]
    880010cc:	f9400000 	ldr	x0, [x0]
    880010d0:	f9001fe0 	str	x0, [sp, #56]
	int value;

	spec->flags = 0U;
    880010d4:	f94013e0 	ldr	x0, [sp, #32]
    880010d8:	b900001f 	str	wzr, [x0]
	spec->width = 0;
    880010dc:	f94013e0 	ldr	x0, [sp, #32]
    880010e0:	b900041f 	str	wzr, [x0, #4]
	spec->precision = -1;
    880010e4:	f94013e0 	ldr	x0, [sp, #32]
    880010e8:	12800001 	mov	w1, #0xffffffff            	// #-1
    880010ec:	b9000801 	str	w1, [x0, #8]
	spec->length = LENGTH_DEFAULT;
    880010f0:	f94013e0 	ldr	x0, [sp, #32]
    880010f4:	b9000c1f 	str	wzr, [x0, #12]
	spec->conv = '\0';
    880010f8:	f94013e0 	ldr	x0, [sp, #32]
    880010fc:	3900401f 	strb	wzr, [x0, #16]

	for (;;) {
		switch (*p) {
    88001100:	f9401fe0 	ldr	x0, [sp, #56]
    88001104:	39400000 	ldrb	w0, [x0]
    88001108:	7100c01f 	cmp	w0, #0x30
    8800110c:	54000680 	b.eq	880011dc <parse_format+0x128>  // b.none
    88001110:	7100c01f 	cmp	w0, #0x30
    88001114:	5400076c 	b.gt	88001200 <parse_format+0x14c>
    88001118:	7100b41f 	cmp	w0, #0x2d
    8800111c:	54000180 	b.eq	8800114c <parse_format+0x98>  // b.none
    88001120:	7100b41f 	cmp	w0, #0x2d
    88001124:	540006ec 	b.gt	88001200 <parse_format+0x14c>
    88001128:	7100ac1f 	cmp	w0, #0x2b
    8800112c:	54000220 	b.eq	88001170 <parse_format+0xbc>  // b.none
    88001130:	7100ac1f 	cmp	w0, #0x2b
    88001134:	5400066c 	b.gt	88001200 <parse_format+0x14c>
    88001138:	7100801f 	cmp	w0, #0x20
    8800113c:	540002c0 	b.eq	88001194 <parse_format+0xe0>  // b.none
    88001140:	71008c1f 	cmp	w0, #0x23
    88001144:	540003a0 	b.eq	880011b8 <parse_format+0x104>  // b.none
		case '-': spec->flags |= FLAG_LEFT; p++; continue;
		case '+': spec->flags |= FLAG_PLUS; p++; continue;
		case ' ': spec->flags |= FLAG_SPACE; p++; continue;
		case '#': spec->flags |= FLAG_ALT; p++; continue;
		case '0': spec->flags |= FLAG_ZERO; p++; continue;
		default: break;
    88001148:	1400002e 	b	88001200 <parse_format+0x14c>
		case '-': spec->flags |= FLAG_LEFT; p++; continue;
    8800114c:	f94013e0 	ldr	x0, [sp, #32]
    88001150:	b9400000 	ldr	w0, [x0]
    88001154:	32000001 	orr	w1, w0, #0x1
    88001158:	f94013e0 	ldr	x0, [sp, #32]
    8800115c:	b9000001 	str	w1, [x0]
    88001160:	f9401fe0 	ldr	x0, [sp, #56]
    88001164:	91000400 	add	x0, x0, #0x1
    88001168:	f9001fe0 	str	x0, [sp, #56]
    8800116c:	1400002c 	b	8800121c <parse_format+0x168>
		case '+': spec->flags |= FLAG_PLUS; p++; continue;
    88001170:	f94013e0 	ldr	x0, [sp, #32]
    88001174:	b9400000 	ldr	w0, [x0]
    88001178:	321f0001 	orr	w1, w0, #0x2
    8800117c:	f94013e0 	ldr	x0, [sp, #32]
    88001180:	b9000001 	str	w1, [x0]
    88001184:	f9401fe0 	ldr	x0, [sp, #56]
    88001188:	91000400 	add	x0, x0, #0x1
    8800118c:	f9001fe0 	str	x0, [sp, #56]
    88001190:	14000023 	b	8800121c <parse_format+0x168>
		case ' ': spec->flags |= FLAG_SPACE; p++; continue;
    88001194:	f94013e0 	ldr	x0, [sp, #32]
    88001198:	b9400000 	ldr	w0, [x0]
    8800119c:	321e0001 	orr	w1, w0, #0x4
    880011a0:	f94013e0 	ldr	x0, [sp, #32]
    880011a4:	b9000001 	str	w1, [x0]
    880011a8:	f9401fe0 	ldr	x0, [sp, #56]
    880011ac:	91000400 	add	x0, x0, #0x1
    880011b0:	f9001fe0 	str	x0, [sp, #56]
    880011b4:	1400001a 	b	8800121c <parse_format+0x168>
		case '#': spec->flags |= FLAG_ALT; p++; continue;
    880011b8:	f94013e0 	ldr	x0, [sp, #32]
    880011bc:	b9400000 	ldr	w0, [x0]
    880011c0:	321d0001 	orr	w1, w0, #0x8
    880011c4:	f94013e0 	ldr	x0, [sp, #32]
    880011c8:	b9000001 	str	w1, [x0]
    880011cc:	f9401fe0 	ldr	x0, [sp, #56]
    880011d0:	91000400 	add	x0, x0, #0x1
    880011d4:	f9001fe0 	str	x0, [sp, #56]
    880011d8:	14000011 	b	8800121c <parse_format+0x168>
		case '0': spec->flags |= FLAG_ZERO; p++; continue;
    880011dc:	f94013e0 	ldr	x0, [sp, #32]
    880011e0:	b9400000 	ldr	w0, [x0]
    880011e4:	321c0001 	orr	w1, w0, #0x10
    880011e8:	f94013e0 	ldr	x0, [sp, #32]
    880011ec:	b9000001 	str	w1, [x0]
    880011f0:	f9401fe0 	ldr	x0, [sp, #56]
    880011f4:	91000400 	add	x0, x0, #0x1
    880011f8:	f9001fe0 	str	x0, [sp, #56]
    880011fc:	14000008 	b	8800121c <parse_format+0x168>
		default: break;
    88001200:	d503201f 	nop
		}
		break;
    88001204:	d503201f 	nop
	}

	if (*p == '*') {
    88001208:	f9401fe0 	ldr	x0, [sp, #56]
    8800120c:	39400000 	ldrb	w0, [x0]
    88001210:	7100a81f 	cmp	w0, #0x2a
    88001214:	54000661 	b.ne	880012e0 <parse_format+0x22c>  // b.any
    88001218:	14000002 	b	88001220 <parse_format+0x16c>
		switch (*p) {
    8800121c:	17ffffb9 	b	88001100 <parse_format+0x4c>
		spec->width = va_arg(*args, int);
    88001220:	f9400fe0 	ldr	x0, [sp, #24]
    88001224:	b9401801 	ldr	w1, [x0, #24]
    88001228:	f9400fe0 	ldr	x0, [sp, #24]
    8800122c:	f9400000 	ldr	x0, [x0]
    88001230:	7100003f 	cmp	w1, #0x0
    88001234:	540000cb 	b.lt	8800124c <parse_format+0x198>  // b.tstop
    88001238:	91002c01 	add	x1, x0, #0xb
    8800123c:	927df022 	and	x2, x1, #0xfffffffffffffff8
    88001240:	f9400fe1 	ldr	x1, [sp, #24]
    88001244:	f9000022 	str	x2, [x1]
    88001248:	14000011 	b	8800128c <parse_format+0x1d8>
    8800124c:	11002023 	add	w3, w1, #0x8
    88001250:	f9400fe2 	ldr	x2, [sp, #24]
    88001254:	b9001843 	str	w3, [x2, #24]
    88001258:	f9400fe2 	ldr	x2, [sp, #24]
    8800125c:	b9401842 	ldr	w2, [x2, #24]
    88001260:	7100005f 	cmp	w2, #0x0
    88001264:	540000cd 	b.le	8800127c <parse_format+0x1c8>
    88001268:	91002c01 	add	x1, x0, #0xb
    8800126c:	927df022 	and	x2, x1, #0xfffffffffffffff8
    88001270:	f9400fe1 	ldr	x1, [sp, #24]
    88001274:	f9000022 	str	x2, [x1]
    88001278:	14000005 	b	8800128c <parse_format+0x1d8>
    8800127c:	f9400fe0 	ldr	x0, [sp, #24]
    88001280:	f9400402 	ldr	x2, [x0, #8]
    88001284:	93407c20 	sxtw	x0, w1
    88001288:	8b000040 	add	x0, x2, x0
    8800128c:	b9400001 	ldr	w1, [x0]
    88001290:	f94013e0 	ldr	x0, [sp, #32]
    88001294:	b9000401 	str	w1, [x0, #4]
		if (spec->width < 0) {
    88001298:	f94013e0 	ldr	x0, [sp, #32]
    8800129c:	b9400400 	ldr	w0, [x0, #4]
    880012a0:	7100001f 	cmp	w0, #0x0
    880012a4:	5400016a 	b.ge	880012d0 <parse_format+0x21c>  // b.tcont
			spec->flags |= FLAG_LEFT;
    880012a8:	f94013e0 	ldr	x0, [sp, #32]
    880012ac:	b9400000 	ldr	w0, [x0]
    880012b0:	32000001 	orr	w1, w0, #0x1
    880012b4:	f94013e0 	ldr	x0, [sp, #32]
    880012b8:	b9000001 	str	w1, [x0]
			spec->width = -spec->width;
    880012bc:	f94013e0 	ldr	x0, [sp, #32]
    880012c0:	b9400400 	ldr	w0, [x0, #4]
    880012c4:	4b0003e1 	neg	w1, w0
    880012c8:	f94013e0 	ldr	x0, [sp, #32]
    880012cc:	b9000401 	str	w1, [x0, #4]
		}
		p++;
    880012d0:	f9401fe0 	ldr	x0, [sp, #56]
    880012d4:	91000400 	add	x0, x0, #0x1
    880012d8:	f9001fe0 	str	x0, [sp, #56]
    880012dc:	1400000b 	b	88001308 <parse_format+0x254>
	} else if (parse_number(&p, &value)) {
    880012e0:	9100d3e1 	add	x1, sp, #0x34
    880012e4:	9100e3e0 	add	x0, sp, #0x38
    880012e8:	97ffff4a 	bl	88001010 <parse_number>
    880012ec:	12001c00 	and	w0, w0, #0xff
    880012f0:	12000000 	and	w0, w0, #0x1
    880012f4:	7100001f 	cmp	w0, #0x0
    880012f8:	54000080 	b.eq	88001308 <parse_format+0x254>  // b.none
		spec->width = value;
    880012fc:	b94037e1 	ldr	w1, [sp, #52]
    88001300:	f94013e0 	ldr	x0, [sp, #32]
    88001304:	b9000401 	str	w1, [x0, #4]
	}

	if (*p == '.') {
    88001308:	f9401fe0 	ldr	x0, [sp, #56]
    8800130c:	39400000 	ldrb	w0, [x0]
    88001310:	7100b81f 	cmp	w0, #0x2e
    88001314:	540006e1 	b.ne	880013f0 <parse_format+0x33c>  // b.any
		p++;
    88001318:	f9401fe0 	ldr	x0, [sp, #56]
    8800131c:	91000400 	add	x0, x0, #0x1
    88001320:	f9001fe0 	str	x0, [sp, #56]
		if (*p == '*') {
    88001324:	f9401fe0 	ldr	x0, [sp, #56]
    88001328:	39400000 	ldrb	w0, [x0]
    8800132c:	7100a81f 	cmp	w0, #0x2a
    88001330:	54000541 	b.ne	880013d8 <parse_format+0x324>  // b.any
			spec->precision = va_arg(*args, int);
    88001334:	f9400fe0 	ldr	x0, [sp, #24]
    88001338:	b9401801 	ldr	w1, [x0, #24]
    8800133c:	f9400fe0 	ldr	x0, [sp, #24]
    88001340:	f9400000 	ldr	x0, [x0]
    88001344:	7100003f 	cmp	w1, #0x0
    88001348:	540000cb 	b.lt	88001360 <parse_format+0x2ac>  // b.tstop
    8800134c:	91002c01 	add	x1, x0, #0xb
    88001350:	927df022 	and	x2, x1, #0xfffffffffffffff8
    88001354:	f9400fe1 	ldr	x1, [sp, #24]
    88001358:	f9000022 	str	x2, [x1]
    8800135c:	14000011 	b	880013a0 <parse_format+0x2ec>
    88001360:	11002023 	add	w3, w1, #0x8
    88001364:	f9400fe2 	ldr	x2, [sp, #24]
    88001368:	b9001843 	str	w3, [x2, #24]
    8800136c:	f9400fe2 	ldr	x2, [sp, #24]
    88001370:	b9401842 	ldr	w2, [x2, #24]
    88001374:	7100005f 	cmp	w2, #0x0
    88001378:	540000cd 	b.le	88001390 <parse_format+0x2dc>
    8800137c:	91002c01 	add	x1, x0, #0xb
    88001380:	927df022 	and	x2, x1, #0xfffffffffffffff8
    88001384:	f9400fe1 	ldr	x1, [sp, #24]
    88001388:	f9000022 	str	x2, [x1]
    8800138c:	14000005 	b	880013a0 <parse_format+0x2ec>
    88001390:	f9400fe0 	ldr	x0, [sp, #24]
    88001394:	f9400402 	ldr	x2, [x0, #8]
    88001398:	93407c20 	sxtw	x0, w1
    8800139c:	8b000040 	add	x0, x2, x0
    880013a0:	b9400001 	ldr	w1, [x0]
    880013a4:	f94013e0 	ldr	x0, [sp, #32]
    880013a8:	b9000801 	str	w1, [x0, #8]
			if (spec->precision < 0) {
    880013ac:	f94013e0 	ldr	x0, [sp, #32]
    880013b0:	b9400800 	ldr	w0, [x0, #8]
    880013b4:	7100001f 	cmp	w0, #0x0
    880013b8:	5400008a 	b.ge	880013c8 <parse_format+0x314>  // b.tcont
				spec->precision = -1;
    880013bc:	f94013e0 	ldr	x0, [sp, #32]
    880013c0:	12800001 	mov	w1, #0xffffffff            	// #-1
    880013c4:	b9000801 	str	w1, [x0, #8]
			}
			p++;
    880013c8:	f9401fe0 	ldr	x0, [sp, #56]
    880013cc:	91000400 	add	x0, x0, #0x1
    880013d0:	f9001fe0 	str	x0, [sp, #56]
    880013d4:	14000007 	b	880013f0 <parse_format+0x33c>
		} else {
			parse_number(&p, &value);
    880013d8:	9100d3e1 	add	x1, sp, #0x34
    880013dc:	9100e3e0 	add	x0, sp, #0x38
    880013e0:	97ffff0c 	bl	88001010 <parse_number>
			spec->precision = value;
    880013e4:	b94037e1 	ldr	w1, [sp, #52]
    880013e8:	f94013e0 	ldr	x0, [sp, #32]
    880013ec:	b9000801 	str	w1, [x0, #8]
		}
	}

	if ((*p == 'h') && (*(p + 1) == 'h')) {
    880013f0:	f9401fe0 	ldr	x0, [sp, #56]
    880013f4:	39400000 	ldrb	w0, [x0]
    880013f8:	7101a01f 	cmp	w0, #0x68
    880013fc:	540001a1 	b.ne	88001430 <parse_format+0x37c>  // b.any
    88001400:	f9401fe0 	ldr	x0, [sp, #56]
    88001404:	91000400 	add	x0, x0, #0x1
    88001408:	39400000 	ldrb	w0, [x0]
    8800140c:	7101a01f 	cmp	w0, #0x68
    88001410:	54000101 	b.ne	88001430 <parse_format+0x37c>  // b.any
		spec->length = LENGTH_HH;
    88001414:	f94013e0 	ldr	x0, [sp, #32]
    88001418:	52800021 	mov	w1, #0x1                   	// #1
    8800141c:	b9000c01 	str	w1, [x0, #12]
		p += 2;
    88001420:	f9401fe0 	ldr	x0, [sp, #56]
    88001424:	91000800 	add	x0, x0, #0x2
    88001428:	f9001fe0 	str	x0, [sp, #56]
    8800142c:	14000047 	b	88001548 <parse_format+0x494>
	} else if (*p == 'h') {
    88001430:	f9401fe0 	ldr	x0, [sp, #56]
    88001434:	39400000 	ldrb	w0, [x0]
    88001438:	7101a01f 	cmp	w0, #0x68
    8800143c:	54000101 	b.ne	8800145c <parse_format+0x3a8>  // b.any
		spec->length = LENGTH_H;
    88001440:	f94013e0 	ldr	x0, [sp, #32]
    88001444:	52800041 	mov	w1, #0x2                   	// #2
    88001448:	b9000c01 	str	w1, [x0, #12]
		p++;
    8800144c:	f9401fe0 	ldr	x0, [sp, #56]
    88001450:	91000400 	add	x0, x0, #0x1
    88001454:	f9001fe0 	str	x0, [sp, #56]
    88001458:	1400003c 	b	88001548 <parse_format+0x494>
	} else if ((*p == 'l') && (*(p + 1) == 'l')) {
    8800145c:	f9401fe0 	ldr	x0, [sp, #56]
    88001460:	39400000 	ldrb	w0, [x0]
    88001464:	7101b01f 	cmp	w0, #0x6c
    88001468:	540001a1 	b.ne	8800149c <parse_format+0x3e8>  // b.any
    8800146c:	f9401fe0 	ldr	x0, [sp, #56]
    88001470:	91000400 	add	x0, x0, #0x1
    88001474:	39400000 	ldrb	w0, [x0]
    88001478:	7101b01f 	cmp	w0, #0x6c
    8800147c:	54000101 	b.ne	8800149c <parse_format+0x3e8>  // b.any
		spec->length = LENGTH_LL;
    88001480:	f94013e0 	ldr	x0, [sp, #32]
    88001484:	52800081 	mov	w1, #0x4                   	// #4
    88001488:	b9000c01 	str	w1, [x0, #12]
		p += 2;
    8800148c:	f9401fe0 	ldr	x0, [sp, #56]
    88001490:	91000800 	add	x0, x0, #0x2
    88001494:	f9001fe0 	str	x0, [sp, #56]
    88001498:	1400002c 	b	88001548 <parse_format+0x494>
	} else if (*p == 'l') {
    8800149c:	f9401fe0 	ldr	x0, [sp, #56]
    880014a0:	39400000 	ldrb	w0, [x0]
    880014a4:	7101b01f 	cmp	w0, #0x6c
    880014a8:	54000101 	b.ne	880014c8 <parse_format+0x414>  // b.any
		spec->length = LENGTH_L;
    880014ac:	f94013e0 	ldr	x0, [sp, #32]
    880014b0:	52800061 	mov	w1, #0x3                   	// #3
    880014b4:	b9000c01 	str	w1, [x0, #12]
		p++;
    880014b8:	f9401fe0 	ldr	x0, [sp, #56]
    880014bc:	91000400 	add	x0, x0, #0x1
    880014c0:	f9001fe0 	str	x0, [sp, #56]
    880014c4:	14000021 	b	88001548 <parse_format+0x494>
	} else if (*p == 'z') {
    880014c8:	f9401fe0 	ldr	x0, [sp, #56]
    880014cc:	39400000 	ldrb	w0, [x0]
    880014d0:	7101e81f 	cmp	w0, #0x7a
    880014d4:	54000101 	b.ne	880014f4 <parse_format+0x440>  // b.any
		spec->length = LENGTH_Z;
    880014d8:	f94013e0 	ldr	x0, [sp, #32]
    880014dc:	528000a1 	mov	w1, #0x5                   	// #5
    880014e0:	b9000c01 	str	w1, [x0, #12]
		p++;
    880014e4:	f9401fe0 	ldr	x0, [sp, #56]
    880014e8:	91000400 	add	x0, x0, #0x1
    880014ec:	f9001fe0 	str	x0, [sp, #56]
    880014f0:	14000016 	b	88001548 <parse_format+0x494>
	} else if (*p == 't') {
    880014f4:	f9401fe0 	ldr	x0, [sp, #56]
    880014f8:	39400000 	ldrb	w0, [x0]
    880014fc:	7101d01f 	cmp	w0, #0x74
    88001500:	54000101 	b.ne	88001520 <parse_format+0x46c>  // b.any
		spec->length = LENGTH_T;
    88001504:	f94013e0 	ldr	x0, [sp, #32]
    88001508:	528000c1 	mov	w1, #0x6                   	// #6
    8800150c:	b9000c01 	str	w1, [x0, #12]
		p++;
    88001510:	f9401fe0 	ldr	x0, [sp, #56]
    88001514:	91000400 	add	x0, x0, #0x1
    88001518:	f9001fe0 	str	x0, [sp, #56]
    8800151c:	1400000b 	b	88001548 <parse_format+0x494>
	} else if (*p == 'j') {
    88001520:	f9401fe0 	ldr	x0, [sp, #56]
    88001524:	39400000 	ldrb	w0, [x0]
    88001528:	7101a81f 	cmp	w0, #0x6a
    8800152c:	540000e1 	b.ne	88001548 <parse_format+0x494>  // b.any
		spec->length = LENGTH_J;
    88001530:	f94013e0 	ldr	x0, [sp, #32]
    88001534:	528000e1 	mov	w1, #0x7                   	// #7
    88001538:	b9000c01 	str	w1, [x0, #12]
		p++;
    8800153c:	f9401fe0 	ldr	x0, [sp, #56]
    88001540:	91000400 	add	x0, x0, #0x1
    88001544:	f9001fe0 	str	x0, [sp, #56]
	}

	spec->conv = *p;
    88001548:	f9401fe0 	ldr	x0, [sp, #56]
    8800154c:	39400001 	ldrb	w1, [x0]
    88001550:	f94013e0 	ldr	x0, [sp, #32]
    88001554:	39004001 	strb	w1, [x0, #16]
	if ((*p >= 'A') && (*p <= 'Z')) {
    88001558:	f9401fe0 	ldr	x0, [sp, #56]
    8800155c:	39400000 	ldrb	w0, [x0]
    88001560:	7101001f 	cmp	w0, #0x40
    88001564:	54000149 	b.ls	8800158c <parse_format+0x4d8>  // b.plast
    88001568:	f9401fe0 	ldr	x0, [sp, #56]
    8800156c:	39400000 	ldrb	w0, [x0]
    88001570:	7101681f 	cmp	w0, #0x5a
    88001574:	540000c8 	b.hi	8800158c <parse_format+0x4d8>  // b.pmore
		spec->flags |= FLAG_UPPER;
    88001578:	f94013e0 	ldr	x0, [sp, #32]
    8800157c:	b9400000 	ldr	w0, [x0]
    88001580:	321b0001 	orr	w1, w0, #0x20
    88001584:	f94013e0 	ldr	x0, [sp, #32]
    88001588:	b9000001 	str	w1, [x0]
	}
	if (*p != '\0') {
    8800158c:	f9401fe0 	ldr	x0, [sp, #56]
    88001590:	39400000 	ldrb	w0, [x0]
    88001594:	7100001f 	cmp	w0, #0x0
    88001598:	54000080 	b.eq	880015a8 <parse_format+0x4f4>  // b.none
		p++;
    8800159c:	f9401fe0 	ldr	x0, [sp, #56]
    880015a0:	91000400 	add	x0, x0, #0x1
    880015a4:	f9001fe0 	str	x0, [sp, #56]
	}
	*fmt = p;
    880015a8:	f9401fe1 	ldr	x1, [sp, #56]
    880015ac:	f94017e0 	ldr	x0, [sp, #40]
    880015b0:	f9000001 	str	x1, [x0]
}
    880015b4:	d503201f 	nop
    880015b8:	a8c47bfd 	ldp	x29, x30, [sp], #64
    880015bc:	d65f03c0 	ret

00000000880015c0 <debug_vprintf>:

int debug_vprintf(const char *fmt, va_list args)
{
    880015c0:	a9b87bfd 	stp	x29, x30, [sp, #-128]!
    880015c4:	910003fd 	mov	x29, sp
    880015c8:	f9000bf3 	str	x19, [sp, #16]
    880015cc:	f90017e0 	str	x0, [sp, #40]
    880015d0:	aa0103f3 	mov	x19, x1
	struct print_ctx ctx = { 0 };
    880015d4:	b9006bff 	str	wzr, [sp, #104]
	va_list ap;

	if (fmt == NULL) {
    880015d8:	f94017e0 	ldr	x0, [sp, #40]
    880015dc:	f100001f 	cmp	x0, #0x0
    880015e0:	54000061 	b.ne	880015ec <debug_vprintf+0x2c>  // b.any
		return 0;
    880015e4:	52800000 	mov	w0, #0x0                   	// #0
    880015e8:	1400016f 	b	88001ba4 <debug_vprintf+0x5e4>
	}

	va_copy(ap, args);
    880015ec:	f9400260 	ldr	x0, [x19]
    880015f0:	f90027e0 	str	x0, [sp, #72]
    880015f4:	f9400660 	ldr	x0, [x19, #8]
    880015f8:	f9002be0 	str	x0, [sp, #80]
    880015fc:	f9400a60 	ldr	x0, [x19, #16]
    88001600:	f9002fe0 	str	x0, [sp, #88]
    88001604:	f9400e60 	ldr	x0, [x19, #24]
    88001608:	f90033e0 	str	x0, [sp, #96]
	while (*fmt != '\0') {
    8800160c:	14000161 	b	88001b90 <debug_vprintf+0x5d0>
		struct format_spec spec;
		uint64_t uvalue;
		int64_t svalue;

		if (*fmt != '%') {
    88001610:	f94017e0 	ldr	x0, [sp, #40]
    88001614:	39400000 	ldrb	w0, [x0]
    88001618:	7100941f 	cmp	w0, #0x25
    8800161c:	54000100 	b.eq	8800163c <debug_vprintf+0x7c>  // b.none
			print_char(&ctx, *fmt++);
    88001620:	f94017e0 	ldr	x0, [sp, #40]
    88001624:	91000401 	add	x1, x0, #0x1
    88001628:	f90017e1 	str	x1, [sp, #40]
    8800162c:	39400001 	ldrb	w1, [x0]
    88001630:	9101a3e0 	add	x0, sp, #0x68
    88001634:	97fffa7b 	bl	88000020 <print_char>
			continue;
    88001638:	14000156 	b	88001b90 <debug_vprintf+0x5d0>
		}

		fmt++;
    8800163c:	f94017e0 	ldr	x0, [sp, #40]
    88001640:	91000400 	add	x0, x0, #0x1
    88001644:	f90017e0 	str	x0, [sp, #40]
		if (*fmt == '%') {
    88001648:	f94017e0 	ldr	x0, [sp, #40]
    8800164c:	39400000 	ldrb	w0, [x0]
    88001650:	7100941f 	cmp	w0, #0x25
    88001654:	54000101 	b.ne	88001674 <debug_vprintf+0xb4>  // b.any
			print_char(&ctx, *fmt++);
    88001658:	f94017e0 	ldr	x0, [sp, #40]
    8800165c:	91000401 	add	x1, x0, #0x1
    88001660:	f90017e1 	str	x1, [sp, #40]
    88001664:	39400001 	ldrb	w1, [x0]
    88001668:	9101a3e0 	add	x0, sp, #0x68
    8800166c:	97fffa6d 	bl	88000020 <print_char>
			continue;
    88001670:	14000148 	b	88001b90 <debug_vprintf+0x5d0>
		}

		parse_format(&fmt, &spec, &ap);
    88001674:	910123e2 	add	x2, sp, #0x48
    88001678:	9100c3e1 	add	x1, sp, #0x30
    8800167c:	9100a3e0 	add	x0, sp, #0x28
    88001680:	97fffe8d 	bl	880010b4 <parse_format>
		switch (spec.conv) {
    88001684:	394103e0 	ldrb	w0, [sp, #64]
    88001688:	7101e01f 	cmp	w0, #0x78
    8800168c:	540009c0 	b.eq	880017c4 <debug_vprintf+0x204>  // b.none
    88001690:	7101e01f 	cmp	w0, #0x78
    88001694:	540026ac 	b.gt	88001b68 <debug_vprintf+0x5a8>
    88001698:	7101d41f 	cmp	w0, #0x75
    8800169c:	540006c0 	b.eq	88001774 <debug_vprintf+0x1b4>  // b.none
    880016a0:	7101d41f 	cmp	w0, #0x75
    880016a4:	5400262c 	b.gt	88001b68 <debug_vprintf+0x5a8>
    880016a8:	7101cc1f 	cmp	w0, #0x73
    880016ac:	54000d40 	b.eq	88001854 <debug_vprintf+0x294>  // b.none
    880016b0:	7101cc1f 	cmp	w0, #0x73
    880016b4:	540025ac 	b.gt	88001b68 <debug_vprintf+0x5a8>
    880016b8:	7101c01f 	cmp	w0, #0x70
    880016bc:	54000fe0 	b.eq	880018b8 <debug_vprintf+0x2f8>  // b.none
    880016c0:	7101c01f 	cmp	w0, #0x70
    880016c4:	5400252c 	b.gt	88001b68 <debug_vprintf+0x5a8>
    880016c8:	7101bc1f 	cmp	w0, #0x6f
    880016cc:	54000680 	b.eq	8800179c <debug_vprintf+0x1dc>  // b.none
    880016d0:	7101bc1f 	cmp	w0, #0x6f
    880016d4:	540024ac 	b.gt	88001b68 <debug_vprintf+0x5a8>
    880016d8:	7101b81f 	cmp	w0, #0x6e
    880016dc:	54001300 	b.eq	8800193c <debug_vprintf+0x37c>  // b.none
    880016e0:	7101b81f 	cmp	w0, #0x6e
    880016e4:	5400242c 	b.gt	88001b68 <debug_vprintf+0x5a8>
    880016e8:	7101a41f 	cmp	w0, #0x69
    880016ec:	54000180 	b.eq	8800171c <debug_vprintf+0x15c>  // b.none
    880016f0:	7101a41f 	cmp	w0, #0x69
    880016f4:	540023ac 	b.gt	88001b68 <debug_vprintf+0x5a8>
    880016f8:	7101901f 	cmp	w0, #0x64
    880016fc:	54000100 	b.eq	8800171c <debug_vprintf+0x15c>  // b.none
    88001700:	7101901f 	cmp	w0, #0x64
    88001704:	5400232c 	b.gt	88001b68 <debug_vprintf+0x5a8>
    88001708:	7101601f 	cmp	w0, #0x58
    8800170c:	540005c0 	b.eq	880017c4 <debug_vprintf+0x204>  // b.none
    88001710:	71018c1f 	cmp	w0, #0x63
    88001714:	540006c0 	b.eq	880017ec <debug_vprintf+0x22c>  // b.none
    88001718:	14000114 	b	88001b68 <debug_vprintf+0x5a8>
		case 'd':
		case 'i':
			svalue = get_signed_arg(&ap, spec.length);
    8800171c:	b9403fe1 	ldr	w1, [sp, #60]
    88001720:	910123e0 	add	x0, sp, #0x48
    88001724:	97fffb8a 	bl	8800054c <get_signed_arg>
    88001728:	f9003fe0 	str	x0, [sp, #120]
			uvalue = (svalue < 0) ? (uint64_t)(-(svalue + 1)) + 1U : (uint64_t)svalue;
    8800172c:	f9403fe0 	ldr	x0, [sp, #120]
    88001730:	f100001f 	cmp	x0, #0x0
    88001734:	5400008a 	b.ge	88001744 <debug_vprintf+0x184>  // b.tcont
    88001738:	f9403fe0 	ldr	x0, [sp, #120]
    8800173c:	cb0003e0 	neg	x0, x0
    88001740:	14000002 	b	88001748 <debug_vprintf+0x188>
    88001744:	f9403fe0 	ldr	x0, [sp, #120]
    88001748:	f9003be0 	str	x0, [sp, #112]
			format_integer(&ctx, &spec, uvalue, svalue < 0, 10U);
    8800174c:	f9403fe0 	ldr	x0, [sp, #120]
    88001750:	d37ffc00 	lsr	x0, x0, #63
    88001754:	12001c02 	and	w2, w0, #0xff
    88001758:	9100c3e1 	add	x1, sp, #0x30
    8800175c:	9101a3e0 	add	x0, sp, #0x68
    88001760:	52800144 	mov	w4, #0xa                   	// #10
    88001764:	2a0203e3 	mov	w3, w2
    88001768:	f9403be2 	ldr	x2, [sp, #112]
    8800176c:	97fffccc 	bl	88000a9c <format_integer>
			break;
    88001770:	14000108 	b	88001b90 <debug_vprintf+0x5d0>
		case 'u':
			format_integer(&ctx, &spec, get_unsigned_arg(&ap, spec.length), false, 10U);
    88001774:	b9403fe1 	ldr	w1, [sp, #60]
    88001778:	910123e0 	add	x0, sp, #0x48
    8800177c:	97fffa5e 	bl	880000f4 <get_unsigned_arg>
    88001780:	aa0003e2 	mov	x2, x0
    88001784:	9100c3e1 	add	x1, sp, #0x30
    88001788:	9101a3e0 	add	x0, sp, #0x68
    8800178c:	52800144 	mov	w4, #0xa                   	// #10
    88001790:	52800003 	mov	w3, #0x0                   	// #0
    88001794:	97fffcc2 	bl	88000a9c <format_integer>
			break;
    88001798:	140000fe 	b	88001b90 <debug_vprintf+0x5d0>
		case 'o':
			format_integer(&ctx, &spec, get_unsigned_arg(&ap, spec.length), false, 8U);
    8800179c:	b9403fe1 	ldr	w1, [sp, #60]
    880017a0:	910123e0 	add	x0, sp, #0x48
    880017a4:	97fffa54 	bl	880000f4 <get_unsigned_arg>
    880017a8:	aa0003e2 	mov	x2, x0
    880017ac:	9100c3e1 	add	x1, sp, #0x30
    880017b0:	9101a3e0 	add	x0, sp, #0x68
    880017b4:	52800104 	mov	w4, #0x8                   	// #8
    880017b8:	52800003 	mov	w3, #0x0                   	// #0
    880017bc:	97fffcb8 	bl	88000a9c <format_integer>
			break;
    880017c0:	140000f4 	b	88001b90 <debug_vprintf+0x5d0>
		case 'x':
		case 'X':
			format_integer(&ctx, &spec, get_unsigned_arg(&ap, spec.length), false, 16U);
    880017c4:	b9403fe1 	ldr	w1, [sp, #60]
    880017c8:	910123e0 	add	x0, sp, #0x48
    880017cc:	97fffa4a 	bl	880000f4 <get_unsigned_arg>
    880017d0:	aa0003e2 	mov	x2, x0
    880017d4:	9100c3e1 	add	x1, sp, #0x30
    880017d8:	9101a3e0 	add	x0, sp, #0x68
    880017dc:	52800204 	mov	w4, #0x10                  	// #16
    880017e0:	52800003 	mov	w3, #0x0                   	// #0
    880017e4:	97fffcae 	bl	88000a9c <format_integer>
			break;
    880017e8:	140000ea 	b	88001b90 <debug_vprintf+0x5d0>
		case 'c':
			format_char(&ctx, &spec, (char)va_arg(ap, int));
    880017ec:	b94063e1 	ldr	w1, [sp, #96]
    880017f0:	f94027e0 	ldr	x0, [sp, #72]
    880017f4:	7100003f 	cmp	w1, #0x0
    880017f8:	540000ab 	b.lt	8800180c <debug_vprintf+0x24c>  // b.tstop
    880017fc:	91002c01 	add	x1, x0, #0xb
    88001800:	927df021 	and	x1, x1, #0xfffffffffffffff8
    88001804:	f90027e1 	str	x1, [sp, #72]
    88001808:	1400000d 	b	8800183c <debug_vprintf+0x27c>
    8800180c:	11002022 	add	w2, w1, #0x8
    88001810:	b90063e2 	str	w2, [sp, #96]
    88001814:	b94063e2 	ldr	w2, [sp, #96]
    88001818:	7100005f 	cmp	w2, #0x0
    8800181c:	540000ad 	b.le	88001830 <debug_vprintf+0x270>
    88001820:	91002c01 	add	x1, x0, #0xb
    88001824:	927df021 	and	x1, x1, #0xfffffffffffffff8
    88001828:	f90027e1 	str	x1, [sp, #72]
    8800182c:	14000004 	b	8800183c <debug_vprintf+0x27c>
    88001830:	f9402be2 	ldr	x2, [sp, #80]
    88001834:	93407c20 	sxtw	x0, w1
    88001838:	8b000040 	add	x0, x2, x0
    8800183c:	b9400000 	ldr	w0, [x0]
    88001840:	12001c02 	and	w2, w0, #0xff
    88001844:	9100c3e1 	add	x1, sp, #0x30
    88001848:	9101a3e0 	add	x0, sp, #0x68
    8800184c:	97fffdcd 	bl	88000f80 <format_char>
			break;
    88001850:	140000d0 	b	88001b90 <debug_vprintf+0x5d0>
		case 's':
			format_string(&ctx, &spec, va_arg(ap, const char *));
    88001854:	b94063e1 	ldr	w1, [sp, #96]
    88001858:	f94027e0 	ldr	x0, [sp, #72]
    8800185c:	7100003f 	cmp	w1, #0x0
    88001860:	540000ab 	b.lt	88001874 <debug_vprintf+0x2b4>  // b.tstop
    88001864:	91003c01 	add	x1, x0, #0xf
    88001868:	927df021 	and	x1, x1, #0xfffffffffffffff8
    8800186c:	f90027e1 	str	x1, [sp, #72]
    88001870:	1400000d 	b	880018a4 <debug_vprintf+0x2e4>
    88001874:	11002022 	add	w2, w1, #0x8
    88001878:	b90063e2 	str	w2, [sp, #96]
    8800187c:	b94063e2 	ldr	w2, [sp, #96]
    88001880:	7100005f 	cmp	w2, #0x0
    88001884:	540000ad 	b.le	88001898 <debug_vprintf+0x2d8>
    88001888:	91003c01 	add	x1, x0, #0xf
    8800188c:	927df021 	and	x1, x1, #0xfffffffffffffff8
    88001890:	f90027e1 	str	x1, [sp, #72]
    88001894:	14000004 	b	880018a4 <debug_vprintf+0x2e4>
    88001898:	f9402be2 	ldr	x2, [sp, #80]
    8800189c:	93407c20 	sxtw	x0, w1
    880018a0:	8b000040 	add	x0, x2, x0
    880018a4:	f9400002 	ldr	x2, [x0]
    880018a8:	9100c3e1 	add	x1, sp, #0x30
    880018ac:	9101a3e0 	add	x0, sp, #0x68
    880018b0:	97fffd73 	bl	88000e7c <format_string>
			break;
    880018b4:	140000b7 	b	88001b90 <debug_vprintf+0x5d0>
		case 'p':
			spec.flags |= FLAG_ALT;
    880018b8:	b94033e0 	ldr	w0, [sp, #48]
    880018bc:	321d0000 	orr	w0, w0, #0x8
    880018c0:	b90033e0 	str	w0, [sp, #48]
			spec.length = LENGTH_LL;
    880018c4:	52800080 	mov	w0, #0x4                   	// #4
    880018c8:	b9003fe0 	str	w0, [sp, #60]
			format_integer(&ctx, &spec, (uintptr_t)va_arg(ap, void *), false, 16U);
    880018cc:	b94063e1 	ldr	w1, [sp, #96]
    880018d0:	f94027e0 	ldr	x0, [sp, #72]
    880018d4:	7100003f 	cmp	w1, #0x0
    880018d8:	540000ab 	b.lt	880018ec <debug_vprintf+0x32c>  // b.tstop
    880018dc:	91003c01 	add	x1, x0, #0xf
    880018e0:	927df021 	and	x1, x1, #0xfffffffffffffff8
    880018e4:	f90027e1 	str	x1, [sp, #72]
    880018e8:	1400000d 	b	8800191c <debug_vprintf+0x35c>
    880018ec:	11002022 	add	w2, w1, #0x8
    880018f0:	b90063e2 	str	w2, [sp, #96]
    880018f4:	b94063e2 	ldr	w2, [sp, #96]
    880018f8:	7100005f 	cmp	w2, #0x0
    880018fc:	540000ad 	b.le	88001910 <debug_vprintf+0x350>
    88001900:	91003c01 	add	x1, x0, #0xf
    88001904:	927df021 	and	x1, x1, #0xfffffffffffffff8
    88001908:	f90027e1 	str	x1, [sp, #72]
    8800190c:	14000004 	b	8800191c <debug_vprintf+0x35c>
    88001910:	f9402be2 	ldr	x2, [sp, #80]
    88001914:	93407c20 	sxtw	x0, w1
    88001918:	8b000040 	add	x0, x2, x0
    8800191c:	f9400000 	ldr	x0, [x0]
    88001920:	aa0003e2 	mov	x2, x0
    88001924:	9100c3e1 	add	x1, sp, #0x30
    88001928:	9101a3e0 	add	x0, sp, #0x68
    8800192c:	52800204 	mov	w4, #0x10                  	// #16
    88001930:	52800003 	mov	w3, #0x0                   	// #0
    88001934:	97fffc5a 	bl	88000a9c <format_integer>
			break;
    88001938:	14000096 	b	88001b90 <debug_vprintf+0x5d0>
		case 'n':
			switch (spec.length) {
    8800193c:	b9403fe0 	ldr	w0, [sp, #60]
    88001940:	7100101f 	cmp	w0, #0x4
    88001944:	54000ae0 	b.eq	88001aa0 <debug_vprintf+0x4e0>  // b.none
    88001948:	7100101f 	cmp	w0, #0x4
    8800194c:	54000dcc 	b.gt	88001b04 <debug_vprintf+0x544>
    88001950:	71000c1f 	cmp	w0, #0x3
    88001954:	54000740 	b.eq	88001a3c <debug_vprintf+0x47c>  // b.none
    88001958:	71000c1f 	cmp	w0, #0x3
    8800195c:	54000d4c 	b.gt	88001b04 <debug_vprintf+0x544>
    88001960:	7100041f 	cmp	w0, #0x1
    88001964:	54000080 	b.eq	88001974 <debug_vprintf+0x3b4>  // b.none
    88001968:	7100081f 	cmp	w0, #0x2
    8800196c:	54000360 	b.eq	880019d8 <debug_vprintf+0x418>  // b.none
    88001970:	14000065 	b	88001b04 <debug_vprintf+0x544>
			case LENGTH_HH:
				*va_arg(ap, signed char *) = (signed char)ctx.count;
    88001974:	b9406be3 	ldr	w3, [sp, #104]
    88001978:	b94063e1 	ldr	w1, [sp, #96]
    8800197c:	f94027e0 	ldr	x0, [sp, #72]
    88001980:	7100003f 	cmp	w1, #0x0
    88001984:	540000ab 	b.lt	88001998 <debug_vprintf+0x3d8>  // b.tstop
    88001988:	91003c01 	add	x1, x0, #0xf
    8800198c:	927df021 	and	x1, x1, #0xfffffffffffffff8
    88001990:	f90027e1 	str	x1, [sp, #72]
    88001994:	1400000d 	b	880019c8 <debug_vprintf+0x408>
    88001998:	11002022 	add	w2, w1, #0x8
    8800199c:	b90063e2 	str	w2, [sp, #96]
    880019a0:	b94063e2 	ldr	w2, [sp, #96]
    880019a4:	7100005f 	cmp	w2, #0x0
    880019a8:	540000ad 	b.le	880019bc <debug_vprintf+0x3fc>
    880019ac:	91003c01 	add	x1, x0, #0xf
    880019b0:	927df021 	and	x1, x1, #0xfffffffffffffff8
    880019b4:	f90027e1 	str	x1, [sp, #72]
    880019b8:	14000004 	b	880019c8 <debug_vprintf+0x408>
    880019bc:	f9402be2 	ldr	x2, [sp, #80]
    880019c0:	93407c20 	sxtw	x0, w1
    880019c4:	8b000040 	add	x0, x2, x0
    880019c8:	f9400000 	ldr	x0, [x0]
    880019cc:	13001c61 	sxtb	w1, w3
    880019d0:	39000001 	strb	w1, [x0]
				break;
    880019d4:	14000064 	b	88001b64 <debug_vprintf+0x5a4>
			case LENGTH_H:
				*va_arg(ap, short *) = (short)ctx.count;
    880019d8:	b9406be3 	ldr	w3, [sp, #104]
    880019dc:	b94063e1 	ldr	w1, [sp, #96]
    880019e0:	f94027e0 	ldr	x0, [sp, #72]
    880019e4:	7100003f 	cmp	w1, #0x0
    880019e8:	540000ab 	b.lt	880019fc <debug_vprintf+0x43c>  // b.tstop
    880019ec:	91003c01 	add	x1, x0, #0xf
    880019f0:	927df021 	and	x1, x1, #0xfffffffffffffff8
    880019f4:	f90027e1 	str	x1, [sp, #72]
    880019f8:	1400000d 	b	88001a2c <debug_vprintf+0x46c>
    880019fc:	11002022 	add	w2, w1, #0x8
    88001a00:	b90063e2 	str	w2, [sp, #96]
    88001a04:	b94063e2 	ldr	w2, [sp, #96]
    88001a08:	7100005f 	cmp	w2, #0x0
    88001a0c:	540000ad 	b.le	88001a20 <debug_vprintf+0x460>
    88001a10:	91003c01 	add	x1, x0, #0xf
    88001a14:	927df021 	and	x1, x1, #0xfffffffffffffff8
    88001a18:	f90027e1 	str	x1, [sp, #72]
    88001a1c:	14000004 	b	88001a2c <debug_vprintf+0x46c>
    88001a20:	f9402be2 	ldr	x2, [sp, #80]
    88001a24:	93407c20 	sxtw	x0, w1
    88001a28:	8b000040 	add	x0, x2, x0
    88001a2c:	f9400000 	ldr	x0, [x0]
    88001a30:	13003c61 	sxth	w1, w3
    88001a34:	79000001 	strh	w1, [x0]
				break;
    88001a38:	1400004b 	b	88001b64 <debug_vprintf+0x5a4>
			case LENGTH_L:
				*va_arg(ap, long *) = (long)ctx.count;
    88001a3c:	b9406be3 	ldr	w3, [sp, #104]
    88001a40:	b94063e1 	ldr	w1, [sp, #96]
    88001a44:	f94027e0 	ldr	x0, [sp, #72]
    88001a48:	7100003f 	cmp	w1, #0x0
    88001a4c:	540000ab 	b.lt	88001a60 <debug_vprintf+0x4a0>  // b.tstop
    88001a50:	91003c01 	add	x1, x0, #0xf
    88001a54:	927df021 	and	x1, x1, #0xfffffffffffffff8
    88001a58:	f90027e1 	str	x1, [sp, #72]
    88001a5c:	1400000d 	b	88001a90 <debug_vprintf+0x4d0>
    88001a60:	11002022 	add	w2, w1, #0x8
    88001a64:	b90063e2 	str	w2, [sp, #96]
    88001a68:	b94063e2 	ldr	w2, [sp, #96]
    88001a6c:	7100005f 	cmp	w2, #0x0
    88001a70:	540000ad 	b.le	88001a84 <debug_vprintf+0x4c4>
    88001a74:	91003c01 	add	x1, x0, #0xf
    88001a78:	927df021 	and	x1, x1, #0xfffffffffffffff8
    88001a7c:	f90027e1 	str	x1, [sp, #72]
    88001a80:	14000004 	b	88001a90 <debug_vprintf+0x4d0>
    88001a84:	f9402be2 	ldr	x2, [sp, #80]
    88001a88:	93407c20 	sxtw	x0, w1
    88001a8c:	8b000040 	add	x0, x2, x0
    88001a90:	f9400000 	ldr	x0, [x0]
    88001a94:	93407c61 	sxtw	x1, w3
    88001a98:	f9000001 	str	x1, [x0]
				break;
    88001a9c:	14000032 	b	88001b64 <debug_vprintf+0x5a4>
			case LENGTH_LL:
				*va_arg(ap, long long *) = (long long)ctx.count;
    88001aa0:	b9406be3 	ldr	w3, [sp, #104]
    88001aa4:	b94063e1 	ldr	w1, [sp, #96]
    88001aa8:	f94027e0 	ldr	x0, [sp, #72]
    88001aac:	7100003f 	cmp	w1, #0x0
    88001ab0:	540000ab 	b.lt	88001ac4 <debug_vprintf+0x504>  // b.tstop
    88001ab4:	91003c01 	add	x1, x0, #0xf
    88001ab8:	927df021 	and	x1, x1, #0xfffffffffffffff8
    88001abc:	f90027e1 	str	x1, [sp, #72]
    88001ac0:	1400000d 	b	88001af4 <debug_vprintf+0x534>
    88001ac4:	11002022 	add	w2, w1, #0x8
    88001ac8:	b90063e2 	str	w2, [sp, #96]
    88001acc:	b94063e2 	ldr	w2, [sp, #96]
    88001ad0:	7100005f 	cmp	w2, #0x0
    88001ad4:	540000ad 	b.le	88001ae8 <debug_vprintf+0x528>
    88001ad8:	91003c01 	add	x1, x0, #0xf
    88001adc:	927df021 	and	x1, x1, #0xfffffffffffffff8
    88001ae0:	f90027e1 	str	x1, [sp, #72]
    88001ae4:	14000004 	b	88001af4 <debug_vprintf+0x534>
    88001ae8:	f9402be2 	ldr	x2, [sp, #80]
    88001aec:	93407c20 	sxtw	x0, w1
    88001af0:	8b000040 	add	x0, x2, x0
    88001af4:	f9400000 	ldr	x0, [x0]
    88001af8:	93407c61 	sxtw	x1, w3
    88001afc:	f9000001 	str	x1, [x0]
				break;
    88001b00:	14000019 	b	88001b64 <debug_vprintf+0x5a4>
			default:
				*va_arg(ap, int *) = ctx.count;
    88001b04:	b94063e1 	ldr	w1, [sp, #96]
    88001b08:	f94027e0 	ldr	x0, [sp, #72]
    88001b0c:	7100003f 	cmp	w1, #0x0
    88001b10:	540000ab 	b.lt	88001b24 <debug_vprintf+0x564>  // b.tstop
    88001b14:	91003c01 	add	x1, x0, #0xf
    88001b18:	927df021 	and	x1, x1, #0xfffffffffffffff8
    88001b1c:	f90027e1 	str	x1, [sp, #72]
    88001b20:	1400000d 	b	88001b54 <debug_vprintf+0x594>
    88001b24:	11002022 	add	w2, w1, #0x8
    88001b28:	b90063e2 	str	w2, [sp, #96]
    88001b2c:	b94063e2 	ldr	w2, [sp, #96]
    88001b30:	7100005f 	cmp	w2, #0x0
    88001b34:	540000ad 	b.le	88001b48 <debug_vprintf+0x588>
    88001b38:	91003c01 	add	x1, x0, #0xf
    88001b3c:	927df021 	and	x1, x1, #0xfffffffffffffff8
    88001b40:	f90027e1 	str	x1, [sp, #72]
    88001b44:	14000004 	b	88001b54 <debug_vprintf+0x594>
    88001b48:	f9402be2 	ldr	x2, [sp, #80]
    88001b4c:	93407c20 	sxtw	x0, w1
    88001b50:	8b000040 	add	x0, x2, x0
    88001b54:	f9400000 	ldr	x0, [x0]
    88001b58:	b9406be1 	ldr	w1, [sp, #104]
    88001b5c:	b9000001 	str	w1, [x0]
				break;
    88001b60:	d503201f 	nop
			}
			break;
    88001b64:	1400000b 	b	88001b90 <debug_vprintf+0x5d0>
		default:
			print_char(&ctx, '%');
    88001b68:	9101a3e0 	add	x0, sp, #0x68
    88001b6c:	528004a1 	mov	w1, #0x25                  	// #37
    88001b70:	97fff92c 	bl	88000020 <print_char>
			if (spec.conv != '\0') {
    88001b74:	394103e0 	ldrb	w0, [sp, #64]
    88001b78:	7100001f 	cmp	w0, #0x0
    88001b7c:	54000080 	b.eq	88001b8c <debug_vprintf+0x5cc>  // b.none
				print_char(&ctx, spec.conv);
    88001b80:	394103e1 	ldrb	w1, [sp, #64]
    88001b84:	9101a3e0 	add	x0, sp, #0x68
    88001b88:	97fff926 	bl	88000020 <print_char>
			}
			break;
    88001b8c:	d503201f 	nop
	while (*fmt != '\0') {
    88001b90:	f94017e0 	ldr	x0, [sp, #40]
    88001b94:	39400000 	ldrb	w0, [x0]
    88001b98:	7100001f 	cmp	w0, #0x0
    88001b9c:	54ffd3a1 	b.ne	88001610 <debug_vprintf+0x50>  // b.any
		}
	}
	va_end(ap);
	return ctx.count;
    88001ba0:	b9406be0 	ldr	w0, [sp, #104]
}
    88001ba4:	f9400bf3 	ldr	x19, [sp, #16]
    88001ba8:	a8c87bfd 	ldp	x29, x30, [sp], #128
    88001bac:	d65f03c0 	ret

0000000088001bb0 <debug_printf>:

int debug_printf(const char *fmt, ...)
{
    88001bb0:	a9b57bfd 	stp	x29, x30, [sp, #-176]!
    88001bb4:	910003fd 	mov	x29, sp
    88001bb8:	f9001fe0 	str	x0, [sp, #56]
    88001bbc:	f9003fe1 	str	x1, [sp, #120]
    88001bc0:	f90043e2 	str	x2, [sp, #128]
    88001bc4:	f90047e3 	str	x3, [sp, #136]
    88001bc8:	f9004be4 	str	x4, [sp, #144]
    88001bcc:	f9004fe5 	str	x5, [sp, #152]
    88001bd0:	f90053e6 	str	x6, [sp, #160]
    88001bd4:	f90057e7 	str	x7, [sp, #168]
	int count;
	va_list args;

	va_start(args, fmt);
    88001bd8:	9102c3e0 	add	x0, sp, #0xb0
    88001bdc:	f90027e0 	str	x0, [sp, #72]
    88001be0:	9102c3e0 	add	x0, sp, #0xb0
    88001be4:	f9002be0 	str	x0, [sp, #80]
    88001be8:	9101c3e0 	add	x0, sp, #0x70
    88001bec:	f9002fe0 	str	x0, [sp, #88]
    88001bf0:	128006e0 	mov	w0, #0xffffffc8            	// #-56
    88001bf4:	b90063e0 	str	w0, [sp, #96]
    88001bf8:	b90067ff 	str	wzr, [sp, #100]
	count = debug_vprintf(fmt, args);
    88001bfc:	f94027e0 	ldr	x0, [sp, #72]
    88001c00:	f9000be0 	str	x0, [sp, #16]
    88001c04:	f9402be0 	ldr	x0, [sp, #80]
    88001c08:	f9000fe0 	str	x0, [sp, #24]
    88001c0c:	f9402fe0 	ldr	x0, [sp, #88]
    88001c10:	f90013e0 	str	x0, [sp, #32]
    88001c14:	f94033e0 	ldr	x0, [sp, #96]
    88001c18:	f90017e0 	str	x0, [sp, #40]
    88001c1c:	910043e0 	add	x0, sp, #0x10
    88001c20:	aa0003e1 	mov	x1, x0
    88001c24:	f9401fe0 	ldr	x0, [sp, #56]
    88001c28:	97fffe66 	bl	880015c0 <debug_vprintf>
    88001c2c:	b9006fe0 	str	w0, [sp, #108]
	va_end(args);

	return count;
    88001c30:	b9406fe0 	ldr	w0, [sp, #108]
}
    88001c34:	a8cb7bfd 	ldp	x29, x30, [sp], #176
    88001c38:	d65f03c0 	ret

0000000088001c3c <mini_os_vprintf>:

int mini_os_vprintf(const char *fmt, va_list args)
{
    88001c3c:	a9bb7bfd 	stp	x29, x30, [sp, #-80]!
    88001c40:	910003fd 	mov	x29, sp
    88001c44:	f9000bf3 	str	x19, [sp, #16]
    88001c48:	f90027e0 	str	x0, [sp, #72]
    88001c4c:	aa0103f3 	mov	x19, x1
	return debug_vprintf(fmt, args);
    88001c50:	f9400260 	ldr	x0, [x19]
    88001c54:	f90013e0 	str	x0, [sp, #32]
    88001c58:	f9400660 	ldr	x0, [x19, #8]
    88001c5c:	f90017e0 	str	x0, [sp, #40]
    88001c60:	f9400a60 	ldr	x0, [x19, #16]
    88001c64:	f9001be0 	str	x0, [sp, #48]
    88001c68:	f9400e60 	ldr	x0, [x19, #24]
    88001c6c:	f9001fe0 	str	x0, [sp, #56]
    88001c70:	910083e0 	add	x0, sp, #0x20
    88001c74:	aa0003e1 	mov	x1, x0
    88001c78:	f94027e0 	ldr	x0, [sp, #72]
    88001c7c:	97fffe51 	bl	880015c0 <debug_vprintf>
}
    88001c80:	f9400bf3 	ldr	x19, [sp, #16]
    88001c84:	a8c57bfd 	ldp	x29, x30, [sp], #80
    88001c88:	d65f03c0 	ret

0000000088001c8c <mini_os_printf>:

int mini_os_printf(const char *fmt, ...)
{
    88001c8c:	a9b57bfd 	stp	x29, x30, [sp, #-176]!
    88001c90:	910003fd 	mov	x29, sp
    88001c94:	f9001fe0 	str	x0, [sp, #56]
    88001c98:	f9003fe1 	str	x1, [sp, #120]
    88001c9c:	f90043e2 	str	x2, [sp, #128]
    88001ca0:	f90047e3 	str	x3, [sp, #136]
    88001ca4:	f9004be4 	str	x4, [sp, #144]
    88001ca8:	f9004fe5 	str	x5, [sp, #152]
    88001cac:	f90053e6 	str	x6, [sp, #160]
    88001cb0:	f90057e7 	str	x7, [sp, #168]
	int count;
	va_list args;

	va_start(args, fmt);
    88001cb4:	9102c3e0 	add	x0, sp, #0xb0
    88001cb8:	f90027e0 	str	x0, [sp, #72]
    88001cbc:	9102c3e0 	add	x0, sp, #0xb0
    88001cc0:	f9002be0 	str	x0, [sp, #80]
    88001cc4:	9101c3e0 	add	x0, sp, #0x70
    88001cc8:	f9002fe0 	str	x0, [sp, #88]
    88001ccc:	128006e0 	mov	w0, #0xffffffc8            	// #-56
    88001cd0:	b90063e0 	str	w0, [sp, #96]
    88001cd4:	b90067ff 	str	wzr, [sp, #100]
	count = mini_os_vprintf(fmt, args);
    88001cd8:	f94027e0 	ldr	x0, [sp, #72]
    88001cdc:	f9000be0 	str	x0, [sp, #16]
    88001ce0:	f9402be0 	ldr	x0, [sp, #80]
    88001ce4:	f9000fe0 	str	x0, [sp, #24]
    88001ce8:	f9402fe0 	ldr	x0, [sp, #88]
    88001cec:	f90013e0 	str	x0, [sp, #32]
    88001cf0:	f94033e0 	ldr	x0, [sp, #96]
    88001cf4:	f90017e0 	str	x0, [sp, #40]
    88001cf8:	910043e0 	add	x0, sp, #0x10
    88001cfc:	aa0003e1 	mov	x1, x0
    88001d00:	f9401fe0 	ldr	x0, [sp, #56]
    88001d04:	97ffffce 	bl	88001c3c <mini_os_vprintf>
    88001d08:	b9006fe0 	str	w0, [sp, #108]
	va_end(args);

	return count;
    88001d0c:	b9406fe0 	ldr	w0, [sp, #108]
}
    88001d10:	a8cb7bfd 	ldp	x29, x30, [sp], #176
    88001d14:	d65f03c0 	ret

0000000088001d18 <debug_console_init>:

void debug_console_init(void)
{
    88001d18:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    88001d1c:	910003fd 	mov	x29, sp
	uart_init();
    88001d20:	940000c7 	bl	8800203c <uart_init>
}
    88001d24:	d503201f 	nop
    88001d28:	a8c17bfd 	ldp	x29, x30, [sp], #16
    88001d2c:	d65f03c0 	ret

0000000088001d30 <debug_putc>:

void debug_putc(int ch)
{
    88001d30:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    88001d34:	910003fd 	mov	x29, sp
    88001d38:	b9001fe0 	str	w0, [sp, #28]
	uart_putc(ch);
    88001d3c:	b9401fe0 	ldr	w0, [sp, #28]
    88001d40:	94000110 	bl	88002180 <uart_putc>
}
    88001d44:	d503201f 	nop
    88001d48:	a8c27bfd 	ldp	x29, x30, [sp], #32
    88001d4c:	d65f03c0 	ret

0000000088001d50 <debug_puts>:

void debug_puts(const char *str)
{
    88001d50:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    88001d54:	910003fd 	mov	x29, sp
    88001d58:	f9000fe0 	str	x0, [sp, #24]
	uart_puts(str);
    88001d5c:	f9400fe0 	ldr	x0, [sp, #24]
    88001d60:	94000123 	bl	880021ec <uart_puts>
}
    88001d64:	d503201f 	nop
    88001d68:	a8c27bfd 	ldp	x29, x30, [sp], #32
    88001d6c:	d65f03c0 	ret

0000000088001d70 <debug_write>:

void debug_write(const char *buf, size_t len)
{
    88001d70:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    88001d74:	910003fd 	mov	x29, sp
    88001d78:	f9000fe0 	str	x0, [sp, #24]
    88001d7c:	f9000be1 	str	x1, [sp, #16]
	uart_write(buf, len);
    88001d80:	f9400be1 	ldr	x1, [sp, #16]
    88001d84:	f9400fe0 	ldr	x0, [sp, #24]
    88001d88:	94000133 	bl	88002254 <uart_write>
}
    88001d8c:	d503201f 	nop
    88001d90:	a8c27bfd 	ldp	x29, x30, [sp], #32
    88001d94:	d65f03c0 	ret

0000000088001d98 <debug_getc>:

int debug_getc(void)
{
    88001d98:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    88001d9c:	910003fd 	mov	x29, sp
	return uart_getc();
    88001da0:	94000158 	bl	88002300 <uart_getc>
}
    88001da4:	a8c17bfd 	ldp	x29, x30, [sp], #16
    88001da8:	d65f03c0 	ret

0000000088001dac <debug_try_getc>:

int debug_try_getc(void)
{
    88001dac:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    88001db0:	910003fd 	mov	x29, sp
	return uart_try_getc();
    88001db4:	94000141 	bl	880022b8 <uart_try_getc>
}
    88001db8:	a8c17bfd 	ldp	x29, x30, [sp], #16
    88001dbc:	d65f03c0 	ret

0000000088001dc0 <debug_put_hex64>:

void debug_put_hex64(uint64_t value)
{
    88001dc0:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    88001dc4:	910003fd 	mov	x29, sp
    88001dc8:	f9000fe0 	str	x0, [sp, #24]
	uart_put_hex64(value);
    88001dcc:	f9400fe0 	ldr	x0, [sp, #24]
    88001dd0:	9400015f 	bl	8800234c <uart_put_hex64>
}
    88001dd4:	d503201f 	nop
    88001dd8:	a8c27bfd 	ldp	x29, x30, [sp], #32
    88001ddc:	d65f03c0 	ret

0000000088001de0 <debug_flush>:

void debug_flush(void)
{
    88001de0:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    88001de4:	910003fd 	mov	x29, sp
	uart_flush();
    88001de8:	94000171 	bl	880023ac <uart_flush>
    88001dec:	d503201f 	nop
    88001df0:	a8c17bfd 	ldp	x29, x30, [sp], #16
    88001df4:	d65f03c0 	ret

0000000088001df8 <mmio_write_32>:
	.clock_hz = PLAT_UART0_CLK_HZ,
	.baudrate = PLAT_UART0_BAUDRATE,
};

static inline void mmio_write_32(uintptr_t addr, uint32_t value)
{
    88001df8:	d10043ff 	sub	sp, sp, #0x10
    88001dfc:	f90007e0 	str	x0, [sp, #8]
    88001e00:	b90007e1 	str	w1, [sp, #4]
	*(volatile uint32_t *)addr = value;
    88001e04:	f94007e0 	ldr	x0, [sp, #8]
    88001e08:	b94007e1 	ldr	w1, [sp, #4]
    88001e0c:	b9000001 	str	w1, [x0]
}
    88001e10:	d503201f 	nop
    88001e14:	910043ff 	add	sp, sp, #0x10
    88001e18:	d65f03c0 	ret

0000000088001e1c <mmio_read_32>:

static inline uint32_t mmio_read_32(uintptr_t addr)
{
    88001e1c:	d10043ff 	sub	sp, sp, #0x10
    88001e20:	f90007e0 	str	x0, [sp, #8]
	return *(volatile uint32_t *)addr;
    88001e24:	f94007e0 	ldr	x0, [sp, #8]
    88001e28:	b9400000 	ldr	w0, [x0]
}
    88001e2c:	910043ff 	add	sp, sp, #0x10
    88001e30:	d65f03c0 	ret

0000000088001e34 <dsb_sy>:

static inline void dsb_sy(void)
{
	__asm__ volatile ("dsb sy" : : : "memory");
    88001e34:	d5033f9f 	dsb	sy
}
    88001e38:	d503201f 	nop
    88001e3c:	d65f03c0 	ret

0000000088001e40 <isb>:

static inline void isb(void)
{
	__asm__ volatile ("isb" : : : "memory");
    88001e40:	d5033fdf 	isb
}
    88001e44:	d503201f 	nop
    88001e48:	d65f03c0 	ret

0000000088001e4c <pl011_calc_baud>:

static void pl011_calc_baud(uint32_t uartclk_hz, uint32_t baud,
			    uint32_t *ibrd, uint32_t *fbrd)
{
    88001e4c:	d10103ff 	sub	sp, sp, #0x40
    88001e50:	b9001fe0 	str	w0, [sp, #28]
    88001e54:	b9001be1 	str	w1, [sp, #24]
    88001e58:	f9000be2 	str	x2, [sp, #16]
    88001e5c:	f90007e3 	str	x3, [sp, #8]
	uint64_t denom;
	uint64_t div;
	uint64_t rem;
	uint64_t frac64;

	if ((uartclk_hz == 0U) || (baud == 0U)) {
    88001e60:	b9401fe0 	ldr	w0, [sp, #28]
    88001e64:	7100001f 	cmp	w0, #0x0
    88001e68:	54000080 	b.eq	88001e78 <pl011_calc_baud+0x2c>  // b.none
    88001e6c:	b9401be0 	ldr	w0, [sp, #24]
    88001e70:	7100001f 	cmp	w0, #0x0
    88001e74:	540000e1 	b.ne	88001e90 <pl011_calc_baud+0x44>  // b.any
		*ibrd = 1U;
    88001e78:	f9400be0 	ldr	x0, [sp, #16]
    88001e7c:	52800021 	mov	w1, #0x1                   	// #1
    88001e80:	b9000001 	str	w1, [x0]
		*fbrd = 0U;
    88001e84:	f94007e0 	ldr	x0, [sp, #8]
    88001e88:	b900001f 	str	wzr, [x0]
		return;
    88001e8c:	14000029 	b	88001f30 <pl011_calc_baud+0xe4>
	}

	denom = 16ULL * (uint64_t)baud;
    88001e90:	b9401be0 	ldr	w0, [sp, #24]
    88001e94:	d37cec00 	lsl	x0, x0, #4
    88001e98:	f90017e0 	str	x0, [sp, #40]
	div = (uint64_t)uartclk_hz / denom;
    88001e9c:	b9401fe1 	ldr	w1, [sp, #28]
    88001ea0:	f94017e0 	ldr	x0, [sp, #40]
    88001ea4:	9ac00820 	udiv	x0, x1, x0
    88001ea8:	f9001fe0 	str	x0, [sp, #56]
	rem = (uint64_t)uartclk_hz % denom;
    88001eac:	b9401fe0 	ldr	w0, [sp, #28]
    88001eb0:	f94017e1 	ldr	x1, [sp, #40]
    88001eb4:	9ac10802 	udiv	x2, x0, x1
    88001eb8:	f94017e1 	ldr	x1, [sp, #40]
    88001ebc:	9b017c41 	mul	x1, x2, x1
    88001ec0:	cb010000 	sub	x0, x0, x1
    88001ec4:	f90013e0 	str	x0, [sp, #32]
	frac64 = (rem * 64ULL + denom / 2ULL) / denom;
    88001ec8:	f94013e0 	ldr	x0, [sp, #32]
    88001ecc:	d37ae401 	lsl	x1, x0, #6
    88001ed0:	f94017e0 	ldr	x0, [sp, #40]
    88001ed4:	d341fc00 	lsr	x0, x0, #1
    88001ed8:	8b000021 	add	x1, x1, x0
    88001edc:	f94017e0 	ldr	x0, [sp, #40]
    88001ee0:	9ac00820 	udiv	x0, x1, x0
    88001ee4:	f9001be0 	str	x0, [sp, #48]

	if (div == 0U) {
    88001ee8:	f9401fe0 	ldr	x0, [sp, #56]
    88001eec:	f100001f 	cmp	x0, #0x0
    88001ef0:	54000061 	b.ne	88001efc <pl011_calc_baud+0xb0>  // b.any
		div = 1U;
    88001ef4:	d2800020 	mov	x0, #0x1                   	// #1
    88001ef8:	f9001fe0 	str	x0, [sp, #56]
	}
	if (frac64 > 63U) {
    88001efc:	f9401be0 	ldr	x0, [sp, #48]
    88001f00:	f100fc1f 	cmp	x0, #0x3f
    88001f04:	54000069 	b.ls	88001f10 <pl011_calc_baud+0xc4>  // b.plast
		frac64 = 63U;
    88001f08:	d28007e0 	mov	x0, #0x3f                  	// #63
    88001f0c:	f9001be0 	str	x0, [sp, #48]
	}

	*ibrd = (uint32_t)div;
    88001f10:	f9401fe0 	ldr	x0, [sp, #56]
    88001f14:	2a0003e1 	mov	w1, w0
    88001f18:	f9400be0 	ldr	x0, [sp, #16]
    88001f1c:	b9000001 	str	w1, [x0]
	*fbrd = (uint32_t)frac64;
    88001f20:	f9401be0 	ldr	x0, [sp, #48]
    88001f24:	2a0003e1 	mov	w1, w0
    88001f28:	f94007e0 	ldr	x0, [sp, #8]
    88001f2c:	b9000001 	str	w1, [x0]
}
    88001f30:	910103ff 	add	sp, sp, #0x40
    88001f34:	d65f03c0 	ret

0000000088001f38 <uart_is_configured>:

bool uart_is_configured(void)
{
	return (plat_uart.base != 0UL) &&
    88001f38:	d0000000 	adrp	x0, 88003000 <hex.0+0x418>
    88001f3c:	91048000 	add	x0, x0, #0x120
    88001f40:	f9400000 	ldr	x0, [x0]
	       (plat_uart.clock_hz != 0U) &&
    88001f44:	f100001f 	cmp	x0, #0x0
    88001f48:	540001a0 	b.eq	88001f7c <uart_is_configured+0x44>  // b.none
    88001f4c:	d0000000 	adrp	x0, 88003000 <hex.0+0x418>
    88001f50:	91048000 	add	x0, x0, #0x120
    88001f54:	b9400800 	ldr	w0, [x0, #8]
	return (plat_uart.base != 0UL) &&
    88001f58:	7100001f 	cmp	w0, #0x0
    88001f5c:	54000100 	b.eq	88001f7c <uart_is_configured+0x44>  // b.none
	       (plat_uart.baudrate != 0U);
    88001f60:	d0000000 	adrp	x0, 88003000 <hex.0+0x418>
    88001f64:	91048000 	add	x0, x0, #0x120
    88001f68:	b9400c00 	ldr	w0, [x0, #12]
	       (plat_uart.clock_hz != 0U) &&
    88001f6c:	7100001f 	cmp	w0, #0x0
    88001f70:	54000060 	b.eq	88001f7c <uart_is_configured+0x44>  // b.none
    88001f74:	52800020 	mov	w0, #0x1                   	// #1
    88001f78:	14000002 	b	88001f80 <uart_is_configured+0x48>
    88001f7c:	52800000 	mov	w0, #0x0                   	// #0
    88001f80:	12000000 	and	w0, w0, #0x1
    88001f84:	12001c00 	and	w0, w0, #0xff
}
    88001f88:	d65f03c0 	ret

0000000088001f8c <uart_tx_ready>:

bool uart_tx_ready(void)
{
    88001f8c:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    88001f90:	910003fd 	mov	x29, sp
	if (!uart_is_configured()) {
    88001f94:	97ffffe9 	bl	88001f38 <uart_is_configured>
    88001f98:	12001c00 	and	w0, w0, #0xff
    88001f9c:	52000000 	eor	w0, w0, #0x1
    88001fa0:	12001c00 	and	w0, w0, #0xff
    88001fa4:	12000000 	and	w0, w0, #0x1
    88001fa8:	7100001f 	cmp	w0, #0x0
    88001fac:	54000060 	b.eq	88001fb8 <uart_tx_ready+0x2c>  // b.none
		return false;
    88001fb0:	52800000 	mov	w0, #0x0                   	// #0
    88001fb4:	1400000a 	b	88001fdc <uart_tx_ready+0x50>
	}

	return (mmio_read_32(plat_uart.base + PL011_FR) & FR_TXFF) == 0U;
    88001fb8:	d0000000 	adrp	x0, 88003000 <hex.0+0x418>
    88001fbc:	91048000 	add	x0, x0, #0x120
    88001fc0:	f9400000 	ldr	x0, [x0]
    88001fc4:	91006000 	add	x0, x0, #0x18
    88001fc8:	97ffff95 	bl	88001e1c <mmio_read_32>
    88001fcc:	121b0000 	and	w0, w0, #0x20
    88001fd0:	7100001f 	cmp	w0, #0x0
    88001fd4:	1a9f17e0 	cset	w0, eq	// eq = none
    88001fd8:	12001c00 	and	w0, w0, #0xff
}
    88001fdc:	a8c17bfd 	ldp	x29, x30, [sp], #16
    88001fe0:	d65f03c0 	ret

0000000088001fe4 <uart_rx_ready>:

bool uart_rx_ready(void)
{
    88001fe4:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    88001fe8:	910003fd 	mov	x29, sp
	if (!uart_is_configured()) {
    88001fec:	97ffffd3 	bl	88001f38 <uart_is_configured>
    88001ff0:	12001c00 	and	w0, w0, #0xff
    88001ff4:	52000000 	eor	w0, w0, #0x1
    88001ff8:	12001c00 	and	w0, w0, #0xff
    88001ffc:	12000000 	and	w0, w0, #0x1
    88002000:	7100001f 	cmp	w0, #0x0
    88002004:	54000060 	b.eq	88002010 <uart_rx_ready+0x2c>  // b.none
		return false;
    88002008:	52800000 	mov	w0, #0x0                   	// #0
    8800200c:	1400000a 	b	88002034 <uart_rx_ready+0x50>
	}

	return (mmio_read_32(plat_uart.base + PL011_FR) & FR_RXFE) == 0U;
    88002010:	b0000000 	adrp	x0, 88003000 <hex.0+0x418>
    88002014:	91048000 	add	x0, x0, #0x120
    88002018:	f9400000 	ldr	x0, [x0]
    8800201c:	91006000 	add	x0, x0, #0x18
    88002020:	97ffff7f 	bl	88001e1c <mmio_read_32>
    88002024:	121c0000 	and	w0, w0, #0x10
    88002028:	7100001f 	cmp	w0, #0x0
    8800202c:	1a9f17e0 	cset	w0, eq	// eq = none
    88002030:	12001c00 	and	w0, w0, #0xff
}
    88002034:	a8c17bfd 	ldp	x29, x30, [sp], #16
    88002038:	d65f03c0 	ret

000000008800203c <uart_init>:

void uart_init(void)
{
    8800203c:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    88002040:	910003fd 	mov	x29, sp
	uint32_t ibrd;
	uint32_t fbrd;

	if (!uart_is_configured()) {
    88002044:	97ffffbd 	bl	88001f38 <uart_is_configured>
    88002048:	12001c00 	and	w0, w0, #0xff
    8800204c:	52000000 	eor	w0, w0, #0x1
    88002050:	12001c00 	and	w0, w0, #0xff
    88002054:	12000000 	and	w0, w0, #0x1
    88002058:	7100001f 	cmp	w0, #0x0
    8800205c:	540008c1 	b.ne	88002174 <uart_init+0x138>  // b.any
		return;
	}

	mmio_write_32(plat_uart.base + PL011_CR, 0U);
    88002060:	b0000000 	adrp	x0, 88003000 <hex.0+0x418>
    88002064:	91048000 	add	x0, x0, #0x120
    88002068:	f9400000 	ldr	x0, [x0]
    8800206c:	9100c000 	add	x0, x0, #0x30
    88002070:	52800001 	mov	w1, #0x0                   	// #0
    88002074:	97ffff61 	bl	88001df8 <mmio_write_32>
	dsb_sy();
    88002078:	97ffff6f 	bl	88001e34 <dsb_sy>
	isb();
    8800207c:	97ffff71 	bl	88001e40 <isb>

	while ((mmio_read_32(plat_uart.base + PL011_FR) & FR_BUSY) != 0U) {
    88002080:	d503201f 	nop
    88002084:	b0000000 	adrp	x0, 88003000 <hex.0+0x418>
    88002088:	91048000 	add	x0, x0, #0x120
    8800208c:	f9400000 	ldr	x0, [x0]
    88002090:	91006000 	add	x0, x0, #0x18
    88002094:	97ffff62 	bl	88001e1c <mmio_read_32>
    88002098:	121d0000 	and	w0, w0, #0x8
    8800209c:	7100001f 	cmp	w0, #0x0
    880020a0:	54ffff21 	b.ne	88002084 <uart_init+0x48>  // b.any
	}

	mmio_write_32(plat_uart.base + PL011_ICR, PL011_ICR_ALL);
    880020a4:	b0000000 	adrp	x0, 88003000 <hex.0+0x418>
    880020a8:	91048000 	add	x0, x0, #0x120
    880020ac:	f9400000 	ldr	x0, [x0]
    880020b0:	91011000 	add	x0, x0, #0x44
    880020b4:	5280ffe1 	mov	w1, #0x7ff                 	// #2047
    880020b8:	97ffff50 	bl	88001df8 <mmio_write_32>
	mmio_write_32(plat_uart.base + PL011_IMSC, 0U);
    880020bc:	b0000000 	adrp	x0, 88003000 <hex.0+0x418>
    880020c0:	91048000 	add	x0, x0, #0x120
    880020c4:	f9400000 	ldr	x0, [x0]
    880020c8:	9100e000 	add	x0, x0, #0x38
    880020cc:	52800001 	mov	w1, #0x0                   	// #0
    880020d0:	97ffff4a 	bl	88001df8 <mmio_write_32>

	pl011_calc_baud(plat_uart.clock_hz, plat_uart.baudrate, &ibrd, &fbrd);
    880020d4:	b0000000 	adrp	x0, 88003000 <hex.0+0x418>
    880020d8:	91048000 	add	x0, x0, #0x120
    880020dc:	b9400804 	ldr	w4, [x0, #8]
    880020e0:	b0000000 	adrp	x0, 88003000 <hex.0+0x418>
    880020e4:	91048000 	add	x0, x0, #0x120
    880020e8:	b9400c00 	ldr	w0, [x0, #12]
    880020ec:	910063e2 	add	x2, sp, #0x18
    880020f0:	910073e1 	add	x1, sp, #0x1c
    880020f4:	aa0203e3 	mov	x3, x2
    880020f8:	aa0103e2 	mov	x2, x1
    880020fc:	2a0003e1 	mov	w1, w0
    88002100:	2a0403e0 	mov	w0, w4
    88002104:	97ffff52 	bl	88001e4c <pl011_calc_baud>
	mmio_write_32(plat_uart.base + PL011_IBRD, ibrd);
    88002108:	b0000000 	adrp	x0, 88003000 <hex.0+0x418>
    8800210c:	91048000 	add	x0, x0, #0x120
    88002110:	f9400000 	ldr	x0, [x0]
    88002114:	91009000 	add	x0, x0, #0x24
    88002118:	b9401fe1 	ldr	w1, [sp, #28]
    8800211c:	97ffff37 	bl	88001df8 <mmio_write_32>
	mmio_write_32(plat_uart.base + PL011_FBRD, fbrd);
    88002120:	b0000000 	adrp	x0, 88003000 <hex.0+0x418>
    88002124:	91048000 	add	x0, x0, #0x120
    88002128:	f9400000 	ldr	x0, [x0]
    8800212c:	9100a000 	add	x0, x0, #0x28
    88002130:	b9401be1 	ldr	w1, [sp, #24]
    88002134:	97ffff31 	bl	88001df8 <mmio_write_32>
	mmio_write_32(plat_uart.base + PL011_LCRH, LCRH_WLEN_8 | LCRH_FEN);
    88002138:	b0000000 	adrp	x0, 88003000 <hex.0+0x418>
    8800213c:	91048000 	add	x0, x0, #0x120
    88002140:	f9400000 	ldr	x0, [x0]
    88002144:	9100b000 	add	x0, x0, #0x2c
    88002148:	52800e01 	mov	w1, #0x70                  	// #112
    8800214c:	97ffff2b 	bl	88001df8 <mmio_write_32>
	mmio_write_32(plat_uart.base + PL011_CR, CR_UARTEN | CR_TXE | CR_RXE);
    88002150:	b0000000 	adrp	x0, 88003000 <hex.0+0x418>
    88002154:	91048000 	add	x0, x0, #0x120
    88002158:	f9400000 	ldr	x0, [x0]
    8800215c:	9100c000 	add	x0, x0, #0x30
    88002160:	52806021 	mov	w1, #0x301                 	// #769
    88002164:	97ffff25 	bl	88001df8 <mmio_write_32>
	dsb_sy();
    88002168:	97ffff33 	bl	88001e34 <dsb_sy>
	isb();
    8800216c:	97ffff35 	bl	88001e40 <isb>
    88002170:	14000002 	b	88002178 <uart_init+0x13c>
		return;
    88002174:	d503201f 	nop
}
    88002178:	a8c27bfd 	ldp	x29, x30, [sp], #32
    8800217c:	d65f03c0 	ret

0000000088002180 <uart_putc>:

void uart_putc(int ch)
{
    88002180:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    88002184:	910003fd 	mov	x29, sp
    88002188:	b9001fe0 	str	w0, [sp, #28]
	if (!uart_is_configured()) {
    8800218c:	97ffff6b 	bl	88001f38 <uart_is_configured>
    88002190:	12001c00 	and	w0, w0, #0xff
    88002194:	52000000 	eor	w0, w0, #0x1
    88002198:	12001c00 	and	w0, w0, #0xff
    8800219c:	12000000 	and	w0, w0, #0x1
    880021a0:	7100001f 	cmp	w0, #0x0
    880021a4:	540001e1 	b.ne	880021e0 <uart_putc+0x60>  // b.any
		return;
	}

	while (!uart_tx_ready()) {
    880021a8:	d503201f 	nop
    880021ac:	97ffff78 	bl	88001f8c <uart_tx_ready>
    880021b0:	12001c00 	and	w0, w0, #0xff
    880021b4:	52000000 	eor	w0, w0, #0x1
    880021b8:	12001c00 	and	w0, w0, #0xff
    880021bc:	12000000 	and	w0, w0, #0x1
    880021c0:	7100001f 	cmp	w0, #0x0
    880021c4:	54ffff41 	b.ne	880021ac <uart_putc+0x2c>  // b.any
	}

	mmio_write_32(plat_uart.base + PL011_DR, (uint32_t)ch);
    880021c8:	b0000000 	adrp	x0, 88003000 <hex.0+0x418>
    880021cc:	91048000 	add	x0, x0, #0x120
    880021d0:	f9400000 	ldr	x0, [x0]
    880021d4:	b9401fe1 	ldr	w1, [sp, #28]
    880021d8:	97ffff08 	bl	88001df8 <mmio_write_32>
    880021dc:	14000002 	b	880021e4 <uart_putc+0x64>
		return;
    880021e0:	d503201f 	nop
}
    880021e4:	a8c27bfd 	ldp	x29, x30, [sp], #32
    880021e8:	d65f03c0 	ret

00000000880021ec <uart_puts>:

void uart_puts(const char *str)
{
    880021ec:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    880021f0:	910003fd 	mov	x29, sp
    880021f4:	f9000fe0 	str	x0, [sp, #24]
	if (str == NULL) {
    880021f8:	f9400fe0 	ldr	x0, [sp, #24]
    880021fc:	f100001f 	cmp	x0, #0x0
    88002200:	54000240 	b.eq	88002248 <uart_puts+0x5c>  // b.none
		return;
	}

	while (*str != '\0') {
    88002204:	1400000c 	b	88002234 <uart_puts+0x48>
		if (*str == '\n') {
    88002208:	f9400fe0 	ldr	x0, [sp, #24]
    8800220c:	39400000 	ldrb	w0, [x0]
    88002210:	7100281f 	cmp	w0, #0xa
    88002214:	54000061 	b.ne	88002220 <uart_puts+0x34>  // b.any
			uart_putc('\r');
    88002218:	528001a0 	mov	w0, #0xd                   	// #13
    8800221c:	97ffffd9 	bl	88002180 <uart_putc>
		}

		uart_putc(*str++);
    88002220:	f9400fe0 	ldr	x0, [sp, #24]
    88002224:	91000401 	add	x1, x0, #0x1
    88002228:	f9000fe1 	str	x1, [sp, #24]
    8800222c:	39400000 	ldrb	w0, [x0]
    88002230:	97ffffd4 	bl	88002180 <uart_putc>
	while (*str != '\0') {
    88002234:	f9400fe0 	ldr	x0, [sp, #24]
    88002238:	39400000 	ldrb	w0, [x0]
    8800223c:	7100001f 	cmp	w0, #0x0
    88002240:	54fffe41 	b.ne	88002208 <uart_puts+0x1c>  // b.any
    88002244:	14000002 	b	8800224c <uart_puts+0x60>
		return;
    88002248:	d503201f 	nop
	}
}
    8800224c:	a8c27bfd 	ldp	x29, x30, [sp], #32
    88002250:	d65f03c0 	ret

0000000088002254 <uart_write>:

void uart_write(const char *buf, size_t len)
{
    88002254:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
    88002258:	910003fd 	mov	x29, sp
    8800225c:	f9000fe0 	str	x0, [sp, #24]
    88002260:	f9000be1 	str	x1, [sp, #16]
	size_t i;

	if (buf == NULL) {
    88002264:	f9400fe0 	ldr	x0, [sp, #24]
    88002268:	f100001f 	cmp	x0, #0x0
    8800226c:	54000200 	b.eq	880022ac <uart_write+0x58>  // b.none
		return;
	}

	for (i = 0; i < len; ++i) {
    88002270:	f90017ff 	str	xzr, [sp, #40]
    88002274:	14000009 	b	88002298 <uart_write+0x44>
		uart_putc((int)buf[i]);
    88002278:	f9400fe1 	ldr	x1, [sp, #24]
    8800227c:	f94017e0 	ldr	x0, [sp, #40]
    88002280:	8b000020 	add	x0, x1, x0
    88002284:	39400000 	ldrb	w0, [x0]
    88002288:	97ffffbe 	bl	88002180 <uart_putc>
	for (i = 0; i < len; ++i) {
    8800228c:	f94017e0 	ldr	x0, [sp, #40]
    88002290:	91000400 	add	x0, x0, #0x1
    88002294:	f90017e0 	str	x0, [sp, #40]
    88002298:	f94017e1 	ldr	x1, [sp, #40]
    8800229c:	f9400be0 	ldr	x0, [sp, #16]
    880022a0:	eb00003f 	cmp	x1, x0
    880022a4:	54fffea3 	b.cc	88002278 <uart_write+0x24>  // b.lo, b.ul, b.last
    880022a8:	14000002 	b	880022b0 <uart_write+0x5c>
		return;
    880022ac:	d503201f 	nop
	}
}
    880022b0:	a8c37bfd 	ldp	x29, x30, [sp], #48
    880022b4:	d65f03c0 	ret

00000000880022b8 <uart_try_getc>:

int uart_try_getc(void)
{
    880022b8:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    880022bc:	910003fd 	mov	x29, sp
	if (!uart_rx_ready()) {
    880022c0:	97ffff49 	bl	88001fe4 <uart_rx_ready>
    880022c4:	12001c00 	and	w0, w0, #0xff
    880022c8:	52000000 	eor	w0, w0, #0x1
    880022cc:	12001c00 	and	w0, w0, #0xff
    880022d0:	12000000 	and	w0, w0, #0x1
    880022d4:	7100001f 	cmp	w0, #0x0
    880022d8:	54000060 	b.eq	880022e4 <uart_try_getc+0x2c>  // b.none
		return -1;
    880022dc:	12800000 	mov	w0, #0xffffffff            	// #-1
    880022e0:	14000006 	b	880022f8 <uart_try_getc+0x40>
	}

	return (int)(mmio_read_32(plat_uart.base + PL011_DR) & 0xFFU);
    880022e4:	b0000000 	adrp	x0, 88003000 <hex.0+0x418>
    880022e8:	91048000 	add	x0, x0, #0x120
    880022ec:	f9400000 	ldr	x0, [x0]
    880022f0:	97fffecb 	bl	88001e1c <mmio_read_32>
    880022f4:	12001c00 	and	w0, w0, #0xff
}
    880022f8:	a8c17bfd 	ldp	x29, x30, [sp], #16
    880022fc:	d65f03c0 	ret

0000000088002300 <uart_getc>:

int uart_getc(void)
{
    88002300:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    88002304:	910003fd 	mov	x29, sp
	int ch;

	if (!uart_is_configured()) {
    88002308:	97ffff0c 	bl	88001f38 <uart_is_configured>
    8800230c:	12001c00 	and	w0, w0, #0xff
    88002310:	52000000 	eor	w0, w0, #0x1
    88002314:	12001c00 	and	w0, w0, #0xff
    88002318:	12000000 	and	w0, w0, #0x1
    8800231c:	7100001f 	cmp	w0, #0x0
    88002320:	54000060 	b.eq	8800232c <uart_getc+0x2c>  // b.none
		return -1;
    88002324:	12800000 	mov	w0, #0xffffffff            	// #-1
    88002328:	14000007 	b	88002344 <uart_getc+0x44>
	}

	do {
		ch = uart_try_getc();
    8800232c:	97ffffe3 	bl	880022b8 <uart_try_getc>
    88002330:	b9001fe0 	str	w0, [sp, #28]
	} while (ch < 0);
    88002334:	b9401fe0 	ldr	w0, [sp, #28]
    88002338:	7100001f 	cmp	w0, #0x0
    8800233c:	54ffff8b 	b.lt	8800232c <uart_getc+0x2c>  // b.tstop

	return ch;
    88002340:	b9401fe0 	ldr	w0, [sp, #28]
}
    88002344:	a8c27bfd 	ldp	x29, x30, [sp], #32
    88002348:	d65f03c0 	ret

000000008800234c <uart_put_hex64>:

void uart_put_hex64(uint64_t value)
{
    8800234c:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
    88002350:	910003fd 	mov	x29, sp
    88002354:	f9000fe0 	str	x0, [sp, #24]
	static const char hex[] = "0123456789abcdef";
	int shift;

	for (shift = 60; shift >= 0; shift -= 4) {
    88002358:	52800780 	mov	w0, #0x3c                  	// #60
    8800235c:	b9002fe0 	str	w0, [sp, #44]
    88002360:	1400000c 	b	88002390 <uart_put_hex64+0x44>
		uart_putc(hex[(value >> shift) & 0xFULL]);
    88002364:	b9402fe0 	ldr	w0, [sp, #44]
    88002368:	f9400fe1 	ldr	x1, [sp, #24]
    8800236c:	9ac02420 	lsr	x0, x1, x0
    88002370:	92400c00 	and	x0, x0, #0xf
    88002374:	90000001 	adrp	x1, 88002000 <uart_rx_ready+0x1c>
    88002378:	912fa021 	add	x1, x1, #0xbe8
    8800237c:	38606820 	ldrb	w0, [x1, x0]
    88002380:	97ffff80 	bl	88002180 <uart_putc>
	for (shift = 60; shift >= 0; shift -= 4) {
    88002384:	b9402fe0 	ldr	w0, [sp, #44]
    88002388:	51001000 	sub	w0, w0, #0x4
    8800238c:	b9002fe0 	str	w0, [sp, #44]
    88002390:	b9402fe0 	ldr	w0, [sp, #44]
    88002394:	7100001f 	cmp	w0, #0x0
    88002398:	54fffe6a 	b.ge	88002364 <uart_put_hex64+0x18>  // b.tcont
	}
}
    8800239c:	d503201f 	nop
    880023a0:	d503201f 	nop
    880023a4:	a8c37bfd 	ldp	x29, x30, [sp], #48
    880023a8:	d65f03c0 	ret

00000000880023ac <uart_flush>:

void uart_flush(void)
{
    880023ac:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    880023b0:	910003fd 	mov	x29, sp
	if (!uart_is_configured()) {
    880023b4:	97fffee1 	bl	88001f38 <uart_is_configured>
    880023b8:	12001c00 	and	w0, w0, #0xff
    880023bc:	52000000 	eor	w0, w0, #0x1
    880023c0:	12001c00 	and	w0, w0, #0xff
    880023c4:	12000000 	and	w0, w0, #0x1
    880023c8:	7100001f 	cmp	w0, #0x0
    880023cc:	54000161 	b.ne	880023f8 <uart_flush+0x4c>  // b.any
		return;
	}

	while ((mmio_read_32(plat_uart.base + PL011_FR) & FR_BUSY) != 0U) {
    880023d0:	d503201f 	nop
    880023d4:	b0000000 	adrp	x0, 88003000 <hex.0+0x418>
    880023d8:	91048000 	add	x0, x0, #0x120
    880023dc:	f9400000 	ldr	x0, [x0]
    880023e0:	91006000 	add	x0, x0, #0x18
    880023e4:	97fffe8e 	bl	88001e1c <mmio_read_32>
    880023e8:	121d0000 	and	w0, w0, #0x8
    880023ec:	7100001f 	cmp	w0, #0x0
    880023f0:	54ffff21 	b.ne	880023d4 <uart_flush+0x28>  // b.any
    880023f4:	14000002 	b	880023fc <uart_flush+0x50>
		return;
    880023f8:	d503201f 	nop
	}
    880023fc:	a8c17bfd 	ldp	x29, x30, [sp], #16
    88002400:	d65f03c0 	ret

0000000088002404 <print_mini_os_banner>:
#include "platform_def.h"

volatile uint64_t boot_magic = PLAT_LOAD_ADDR;

static void print_mini_os_banner(void)
{
    88002404:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    88002408:	910003fd 	mov	x29, sp
    debug_puts("\n");
    8800240c:	90000000 	adrp	x0, 88002000 <uart_rx_ready+0x1c>
    88002410:	91300000 	add	x0, x0, #0xc00
    88002414:	97fffe4f 	bl	88001d50 <debug_puts>
    debug_puts("============================================================\n");
    88002418:	90000000 	adrp	x0, 88002000 <uart_rx_ready+0x1c>
    8800241c:	91302000 	add	x0, x0, #0xc08
    88002420:	97fffe4c 	bl	88001d50 <debug_puts>
    debug_puts("            __  __   ___   _   _   ___    ___    ____      \n");
    88002424:	90000000 	adrp	x0, 88002000 <uart_rx_ready+0x1c>
    88002428:	91312000 	add	x0, x0, #0xc48
    8800242c:	97fffe49 	bl	88001d50 <debug_puts>
    debug_puts("           |  \\/  | |_ _| | \\ | | |_ _|  / _ \\  / ___|     \n");
    88002430:	90000000 	adrp	x0, 88002000 <uart_rx_ready+0x1c>
    88002434:	91322000 	add	x0, x0, #0xc88
    88002438:	97fffe46 	bl	88001d50 <debug_puts>
    debug_puts("           | |\\/| |  | |  |  \\| |  | |  | | | | \\___ \\     \n");
    8800243c:	90000000 	adrp	x0, 88002000 <uart_rx_ready+0x1c>
    88002440:	91332000 	add	x0, x0, #0xcc8
    88002444:	97fffe43 	bl	88001d50 <debug_puts>
    debug_puts("           | |  | |  | |  | |\\  |  | |  | |_| |  ___) |    \n");
    88002448:	90000000 	adrp	x0, 88002000 <uart_rx_ready+0x1c>
    8800244c:	91342000 	add	x0, x0, #0xd08
    88002450:	97fffe40 	bl	88001d50 <debug_puts>
    debug_puts("           |_|  |_| |___| |_| \\_| |___|  \\___/  |____/     \n");
    88002454:	90000000 	adrp	x0, 88002000 <uart_rx_ready+0x1c>
    88002458:	91352000 	add	x0, x0, #0xd48
    8800245c:	97fffe3d 	bl	88001d50 <debug_puts>
    debug_puts("============================================================\n");
    88002460:	90000000 	adrp	x0, 88002000 <uart_rx_ready+0x1c>
    88002464:	91302000 	add	x0, x0, #0xc08
    88002468:	97fffe3a 	bl	88001d50 <debug_puts>
    debug_puts("                     2026  Mini-OS  V0.1                    \n");
    8800246c:	90000000 	adrp	x0, 88002000 <uart_rx_ready+0x1c>
    88002470:	91362000 	add	x0, x0, #0xd88
    88002474:	97fffe37 	bl	88001d50 <debug_puts>
    debug_puts("============================================================\n");
    88002478:	90000000 	adrp	x0, 88002000 <uart_rx_ready+0x1c>
    8800247c:	91302000 	add	x0, x0, #0xc08
    88002480:	97fffe34 	bl	88001d50 <debug_puts>
    debug_puts("\n");
    88002484:	90000000 	adrp	x0, 88002000 <uart_rx_ready+0x1c>
    88002488:	91300000 	add	x0, x0, #0xc00
    8800248c:	97fffe31 	bl	88001d50 <debug_puts>
}
    88002490:	d503201f 	nop
    88002494:	a8c17bfd 	ldp	x29, x30, [sp], #16
    88002498:	d65f03c0 	ret

000000008800249c <kernel_main>:

void kernel_main(void)
{
    8800249c:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    880024a0:	910003fd 	mov	x29, sp
	print_mini_os_banner();
    880024a4:	97ffffd8 	bl	88002404 <print_mini_os_banner>
    mini_os_printf("UART ready @ 0x%llx, boot magic: 0x%llx\n\n",
    880024a8:	b0000000 	adrp	x0, 88003000 <hex.0+0x418>
    880024ac:	9104c000 	add	x0, x0, #0x130
    880024b0:	f9400000 	ldr	x0, [x0]
    880024b4:	aa0003e2 	mov	x2, x0
    880024b8:	d2a38141 	mov	x1, #0x1c0a0000            	// #470417408
    880024bc:	90000000 	adrp	x0, 88002000 <uart_rx_ready+0x1c>
    880024c0:	91372000 	add	x0, x0, #0xdc8
    880024c4:	97fffdf2 	bl	88001c8c <mini_os_printf>
		       (unsigned long long)PLAT_UART0_BASE,
		       (unsigned long long)boot_magic);
	// shell_print_help();
	shell_run();
    880024c8:	9400016e 	bl	88002a80 <shell_run>
    880024cc:	d503201f 	nop
    880024d0:	a8c17bfd 	ldp	x29, x30, [sp], #16
    880024d4:	d65f03c0 	ret

00000000880024d8 <is_space>:
#define MINI_OS_BUILD_YEAR 2026

extern volatile uint64_t boot_magic;

static bool is_space(char ch)
{
    880024d8:	d10043ff 	sub	sp, sp, #0x10
    880024dc:	39003fe0 	strb	w0, [sp, #15]
	return (ch == ' ') || (ch == '\t') || (ch == '\r') || (ch == '\n');
    880024e0:	39403fe0 	ldrb	w0, [sp, #15]
    880024e4:	7100801f 	cmp	w0, #0x20
    880024e8:	54000140 	b.eq	88002510 <is_space+0x38>  // b.none
    880024ec:	39403fe0 	ldrb	w0, [sp, #15]
    880024f0:	7100241f 	cmp	w0, #0x9
    880024f4:	540000e0 	b.eq	88002510 <is_space+0x38>  // b.none
    880024f8:	39403fe0 	ldrb	w0, [sp, #15]
    880024fc:	7100341f 	cmp	w0, #0xd
    88002500:	54000080 	b.eq	88002510 <is_space+0x38>  // b.none
    88002504:	39403fe0 	ldrb	w0, [sp, #15]
    88002508:	7100281f 	cmp	w0, #0xa
    8800250c:	54000061 	b.ne	88002518 <is_space+0x40>  // b.any
    88002510:	52800020 	mov	w0, #0x1                   	// #1
    88002514:	14000002 	b	8800251c <is_space+0x44>
    88002518:	52800000 	mov	w0, #0x0                   	// #0
    8800251c:	12000000 	and	w0, w0, #0x1
    88002520:	12001c00 	and	w0, w0, #0xff
}
    88002524:	910043ff 	add	sp, sp, #0x10
    88002528:	d65f03c0 	ret

000000008800252c <strings_equal>:

static bool strings_equal(const char *lhs, const char *rhs)
{
    8800252c:	d10043ff 	sub	sp, sp, #0x10
    88002530:	f90007e0 	str	x0, [sp, #8]
    88002534:	f90003e1 	str	x1, [sp]
	while ((*lhs != '\0') && (*rhs != '\0')) {
    88002538:	1400000f 	b	88002574 <strings_equal+0x48>
		if (*lhs != *rhs) {
    8800253c:	f94007e0 	ldr	x0, [sp, #8]
    88002540:	39400001 	ldrb	w1, [x0]
    88002544:	f94003e0 	ldr	x0, [sp]
    88002548:	39400000 	ldrb	w0, [x0]
    8800254c:	6b00003f 	cmp	w1, w0
    88002550:	54000060 	b.eq	8800255c <strings_equal+0x30>  // b.none
			return false;
    88002554:	52800000 	mov	w0, #0x0                   	// #0
    88002558:	1400001c 	b	880025c8 <strings_equal+0x9c>
		}
		lhs++;
    8800255c:	f94007e0 	ldr	x0, [sp, #8]
    88002560:	91000400 	add	x0, x0, #0x1
    88002564:	f90007e0 	str	x0, [sp, #8]
		rhs++;
    88002568:	f94003e0 	ldr	x0, [sp]
    8800256c:	91000400 	add	x0, x0, #0x1
    88002570:	f90003e0 	str	x0, [sp]
	while ((*lhs != '\0') && (*rhs != '\0')) {
    88002574:	f94007e0 	ldr	x0, [sp, #8]
    88002578:	39400000 	ldrb	w0, [x0]
    8800257c:	7100001f 	cmp	w0, #0x0
    88002580:	540000a0 	b.eq	88002594 <strings_equal+0x68>  // b.none
    88002584:	f94003e0 	ldr	x0, [sp]
    88002588:	39400000 	ldrb	w0, [x0]
    8800258c:	7100001f 	cmp	w0, #0x0
    88002590:	54fffd61 	b.ne	8800253c <strings_equal+0x10>  // b.any
	}

	return (*lhs == '\0') && (*rhs == '\0');
    88002594:	f94007e0 	ldr	x0, [sp, #8]
    88002598:	39400000 	ldrb	w0, [x0]
    8800259c:	7100001f 	cmp	w0, #0x0
    880025a0:	540000e1 	b.ne	880025bc <strings_equal+0x90>  // b.any
    880025a4:	f94003e0 	ldr	x0, [sp]
    880025a8:	39400000 	ldrb	w0, [x0]
    880025ac:	7100001f 	cmp	w0, #0x0
    880025b0:	54000061 	b.ne	880025bc <strings_equal+0x90>  // b.any
    880025b4:	52800020 	mov	w0, #0x1                   	// #1
    880025b8:	14000002 	b	880025c0 <strings_equal+0x94>
    880025bc:	52800000 	mov	w0, #0x0                   	// #0
    880025c0:	12000000 	and	w0, w0, #0x1
    880025c4:	12001c00 	and	w0, w0, #0xff
}
    880025c8:	910043ff 	add	sp, sp, #0x10
    880025cc:	d65f03c0 	ret

00000000880025d0 <shell_tokenize>:

static int shell_tokenize(char *line, char *argv[], int max_args)
{
    880025d0:	a9bc7bfd 	stp	x29, x30, [sp, #-64]!
    880025d4:	910003fd 	mov	x29, sp
    880025d8:	f90017e0 	str	x0, [sp, #40]
    880025dc:	f90013e1 	str	x1, [sp, #32]
    880025e0:	b9001fe2 	str	w2, [sp, #28]
	int argc = 0;
    880025e4:	b9003fff 	str	wzr, [sp, #60]

	while (*line != '\0') {
    880025e8:	1400002e 	b	880026a0 <shell_tokenize+0xd0>
		while (is_space(*line)) {
			*line++ = '\0';
    880025ec:	f94017e0 	ldr	x0, [sp, #40]
    880025f0:	91000401 	add	x1, x0, #0x1
    880025f4:	f90017e1 	str	x1, [sp, #40]
    880025f8:	3900001f 	strb	wzr, [x0]
		while (is_space(*line)) {
    880025fc:	f94017e0 	ldr	x0, [sp, #40]
    88002600:	39400000 	ldrb	w0, [x0]
    88002604:	97ffffb5 	bl	880024d8 <is_space>
    88002608:	12001c00 	and	w0, w0, #0xff
    8800260c:	12000000 	and	w0, w0, #0x1
    88002610:	7100001f 	cmp	w0, #0x0
    88002614:	54fffec1 	b.ne	880025ec <shell_tokenize+0x1c>  // b.any
		}

		if (*line == '\0') {
    88002618:	f94017e0 	ldr	x0, [sp, #40]
    8800261c:	39400000 	ldrb	w0, [x0]
    88002620:	7100001f 	cmp	w0, #0x0
    88002624:	54000480 	b.eq	880026b4 <shell_tokenize+0xe4>  // b.none
			break;
		}

		if (argc >= max_args) {
    88002628:	b9403fe1 	ldr	w1, [sp, #60]
    8800262c:	b9401fe0 	ldr	w0, [sp, #28]
    88002630:	6b00003f 	cmp	w1, w0
    88002634:	5400044a 	b.ge	880026bc <shell_tokenize+0xec>  // b.tcont
			break;
		}

		argv[argc++] = line;
    88002638:	b9403fe0 	ldr	w0, [sp, #60]
    8800263c:	11000401 	add	w1, w0, #0x1
    88002640:	b9003fe1 	str	w1, [sp, #60]
    88002644:	93407c00 	sxtw	x0, w0
    88002648:	d37df000 	lsl	x0, x0, #3
    8800264c:	f94013e1 	ldr	x1, [sp, #32]
    88002650:	8b000020 	add	x0, x1, x0
    88002654:	f94017e1 	ldr	x1, [sp, #40]
    88002658:	f9000001 	str	x1, [x0]
		while ((*line != '\0') && !is_space(*line)) {
    8800265c:	14000004 	b	8800266c <shell_tokenize+0x9c>
			line++;
    88002660:	f94017e0 	ldr	x0, [sp, #40]
    88002664:	91000400 	add	x0, x0, #0x1
    88002668:	f90017e0 	str	x0, [sp, #40]
		while ((*line != '\0') && !is_space(*line)) {
    8800266c:	f94017e0 	ldr	x0, [sp, #40]
    88002670:	39400000 	ldrb	w0, [x0]
    88002674:	7100001f 	cmp	w0, #0x0
    88002678:	54000140 	b.eq	880026a0 <shell_tokenize+0xd0>  // b.none
    8800267c:	f94017e0 	ldr	x0, [sp, #40]
    88002680:	39400000 	ldrb	w0, [x0]
    88002684:	97ffff95 	bl	880024d8 <is_space>
    88002688:	12001c00 	and	w0, w0, #0xff
    8800268c:	52000000 	eor	w0, w0, #0x1
    88002690:	12001c00 	and	w0, w0, #0xff
    88002694:	12000000 	and	w0, w0, #0x1
    88002698:	7100001f 	cmp	w0, #0x0
    8800269c:	54fffe21 	b.ne	88002660 <shell_tokenize+0x90>  // b.any
	while (*line != '\0') {
    880026a0:	f94017e0 	ldr	x0, [sp, #40]
    880026a4:	39400000 	ldrb	w0, [x0]
    880026a8:	7100001f 	cmp	w0, #0x0
    880026ac:	54fffa81 	b.ne	880025fc <shell_tokenize+0x2c>  // b.any
    880026b0:	14000004 	b	880026c0 <shell_tokenize+0xf0>
			break;
    880026b4:	d503201f 	nop
    880026b8:	14000002 	b	880026c0 <shell_tokenize+0xf0>
			break;
    880026bc:	d503201f 	nop
		}
	}

	return argc;
    880026c0:	b9403fe0 	ldr	w0, [sp, #60]
}
    880026c4:	a8c47bfd 	ldp	x29, x30, [sp], #64
    880026c8:	d65f03c0 	ret

00000000880026cc <shell_print_help>:

void shell_print_help(void)
{
    880026cc:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    880026d0:	910003fd 	mov	x29, sp
	mini_os_printf("Built-in commands:\n");
    880026d4:	90000000 	adrp	x0, 88002000 <uart_rx_ready+0x1c>
    880026d8:	9137e000 	add	x0, x0, #0xdf8
    880026dc:	97fffd6c 	bl	88001c8c <mini_os_printf>
	mini_os_printf("  help      Show this help message\n");
    880026e0:	90000000 	adrp	x0, 88002000 <uart_rx_ready+0x1c>
    880026e4:	91384000 	add	x0, x0, #0xe10
    880026e8:	97fffd69 	bl	88001c8c <mini_os_printf>
	mini_os_printf("  version   Show OS version information\n");
    880026ec:	90000000 	adrp	x0, 88002000 <uart_rx_ready+0x1c>
    880026f0:	9138e000 	add	x0, x0, #0xe38
    880026f4:	97fffd66 	bl	88001c8c <mini_os_printf>
	mini_os_printf("  info      Show current platform/runtime info\n");
    880026f8:	90000000 	adrp	x0, 88002000 <uart_rx_ready+0x1c>
    880026fc:	9139a000 	add	x0, x0, #0xe68
    88002700:	97fffd63 	bl	88001c8c <mini_os_printf>
	mini_os_printf("  echo ...  Print arguments back to the console\n");
    88002704:	90000000 	adrp	x0, 88002000 <uart_rx_ready+0x1c>
    88002708:	913a6000 	add	x0, x0, #0xe98
    8800270c:	97fffd60 	bl	88001c8c <mini_os_printf>
	mini_os_printf("  clear     Clear the terminal screen\n");
    88002710:	90000000 	adrp	x0, 88002000 <uart_rx_ready+0x1c>
    88002714:	913b4000 	add	x0, x0, #0xed0
    88002718:	97fffd5d 	bl	88001c8c <mini_os_printf>
	mini_os_printf("  uname     Print the OS name\n");
    8800271c:	90000000 	adrp	x0, 88002000 <uart_rx_ready+0x1c>
    88002720:	913be000 	add	x0, x0, #0xef8
    88002724:	97fffd5a 	bl	88001c8c <mini_os_printf>
	mini_os_printf("  halt      Stop the CPU in a low-power wait loop\n");
    88002728:	90000000 	adrp	x0, 88002000 <uart_rx_ready+0x1c>
    8800272c:	913c6000 	add	x0, x0, #0xf18
    88002730:	97fffd57 	bl	88001c8c <mini_os_printf>
}
    88002734:	d503201f 	nop
    88002738:	a8c17bfd 	ldp	x29, x30, [sp], #16
    8800273c:	d65f03c0 	ret

0000000088002740 <shell_print_version>:

static void shell_print_version(void)
{
    88002740:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    88002744:	910003fd 	mov	x29, sp
	mini_os_printf("%s %s (%d)\n", MINI_OS_NAME, MINI_OS_VERSION,
    88002748:	5280fd43 	mov	w3, #0x7ea                 	// #2026
    8800274c:	90000000 	adrp	x0, 88002000 <uart_rx_ready+0x1c>
    88002750:	913d4002 	add	x2, x0, #0xf50
    88002754:	90000000 	adrp	x0, 88002000 <uart_rx_ready+0x1c>
    88002758:	913d6001 	add	x1, x0, #0xf58
    8800275c:	90000000 	adrp	x0, 88002000 <uart_rx_ready+0x1c>
    88002760:	913d8000 	add	x0, x0, #0xf60
    88002764:	97fffd4a 	bl	88001c8c <mini_os_printf>
		       MINI_OS_BUILD_YEAR);
}
    88002768:	d503201f 	nop
    8800276c:	a8c17bfd 	ldp	x29, x30, [sp], #16
    88002770:	d65f03c0 	ret

0000000088002774 <shell_print_info>:

static void shell_print_info(void)
{
    88002774:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    88002778:	910003fd 	mov	x29, sp
	mini_os_printf("Platform      : %s\n", "Neoverse-N3");
    8800277c:	90000000 	adrp	x0, 88002000 <uart_rx_ready+0x1c>
    88002780:	913dc001 	add	x1, x0, #0xf70
    88002784:	90000000 	adrp	x0, 88002000 <uart_rx_ready+0x1c>
    88002788:	913e0000 	add	x0, x0, #0xf80
    8800278c:	97fffd40 	bl	88001c8c <mini_os_printf>
	mini_os_printf("UART base     : 0x%llx\n",
    88002790:	d2a38141 	mov	x1, #0x1c0a0000            	// #470417408
    88002794:	90000000 	adrp	x0, 88002000 <uart_rx_ready+0x1c>
    88002798:	913e6000 	add	x0, x0, #0xf98
    8800279c:	97fffd3c 	bl	88001c8c <mini_os_printf>
		       (unsigned long long)PLAT_UART0_BASE);
	mini_os_printf("Load address  : 0x%llx\n",
    880027a0:	d2b10001 	mov	x1, #0x88000000            	// #2281701376
    880027a4:	90000000 	adrp	x0, 88002000 <uart_rx_ready+0x1c>
    880027a8:	913ec000 	add	x0, x0, #0xfb0
    880027ac:	97fffd38 	bl	88001c8c <mini_os_printf>
		       (unsigned long long)PLAT_LOAD_ADDR);
	mini_os_printf("Boot magic    : 0x%llx\n",
    880027b0:	b0000000 	adrp	x0, 88003000 <hex.0+0x418>
    880027b4:	9104c000 	add	x0, x0, #0x130
    880027b8:	f9400000 	ldr	x0, [x0]
    880027bc:	aa0003e1 	mov	x1, x0
    880027c0:	90000000 	adrp	x0, 88002000 <uart_rx_ready+0x1c>
    880027c4:	913f2000 	add	x0, x0, #0xfc8
    880027c8:	97fffd31 	bl	88001c8c <mini_os_printf>
		       (unsigned long long)boot_magic);
}
    880027cc:	d503201f 	nop
    880027d0:	a8c17bfd 	ldp	x29, x30, [sp], #16
    880027d4:	d65f03c0 	ret

00000000880027d8 <shell_echo_args>:

static void shell_echo_args(int argc, char *argv[])
{
    880027d8:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
    880027dc:	910003fd 	mov	x29, sp
    880027e0:	b9001fe0 	str	w0, [sp, #28]
    880027e4:	f9000be1 	str	x1, [sp, #16]
	int i;

	for (i = 1; i < argc; ++i) {
    880027e8:	52800020 	mov	w0, #0x1                   	// #1
    880027ec:	b9002fe0 	str	w0, [sp, #44]
    880027f0:	14000015 	b	88002844 <shell_echo_args+0x6c>
		mini_os_printf("%s", argv[i]);
    880027f4:	b9802fe0 	ldrsw	x0, [sp, #44]
    880027f8:	d37df000 	lsl	x0, x0, #3
    880027fc:	f9400be1 	ldr	x1, [sp, #16]
    88002800:	8b000020 	add	x0, x1, x0
    88002804:	f9400000 	ldr	x0, [x0]
    88002808:	aa0003e1 	mov	x1, x0
    8800280c:	90000000 	adrp	x0, 88002000 <uart_rx_ready+0x1c>
    88002810:	913f8000 	add	x0, x0, #0xfe0
    88002814:	97fffd1e 	bl	88001c8c <mini_os_printf>
		if (i + 1 < argc) {
    88002818:	b9402fe0 	ldr	w0, [sp, #44]
    8800281c:	11000400 	add	w0, w0, #0x1
    88002820:	b9401fe1 	ldr	w1, [sp, #28]
    88002824:	6b00003f 	cmp	w1, w0
    88002828:	5400008d 	b.le	88002838 <shell_echo_args+0x60>
			mini_os_printf(" ");
    8800282c:	90000000 	adrp	x0, 88002000 <uart_rx_ready+0x1c>
    88002830:	913fa000 	add	x0, x0, #0xfe8
    88002834:	97fffd16 	bl	88001c8c <mini_os_printf>
	for (i = 1; i < argc; ++i) {
    88002838:	b9402fe0 	ldr	w0, [sp, #44]
    8800283c:	11000400 	add	w0, w0, #0x1
    88002840:	b9002fe0 	str	w0, [sp, #44]
    88002844:	b9402fe1 	ldr	w1, [sp, #44]
    88002848:	b9401fe0 	ldr	w0, [sp, #28]
    8800284c:	6b00003f 	cmp	w1, w0
    88002850:	54fffd2b 	b.lt	880027f4 <shell_echo_args+0x1c>  // b.tstop
		}
	}
	mini_os_printf("\n");
    88002854:	90000000 	adrp	x0, 88002000 <uart_rx_ready+0x1c>
    88002858:	913fc000 	add	x0, x0, #0xff0
    8800285c:	97fffd0c 	bl	88001c8c <mini_os_printf>
}
    88002860:	d503201f 	nop
    88002864:	a8c37bfd 	ldp	x29, x30, [sp], #48
    88002868:	d65f03c0 	ret

000000008800286c <shell_clear_screen>:

static void shell_clear_screen(void)
{
    8800286c:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    88002870:	910003fd 	mov	x29, sp
	mini_os_printf("\033[2J\033[H");
    88002874:	90000000 	adrp	x0, 88002000 <uart_rx_ready+0x1c>
    88002878:	913fe000 	add	x0, x0, #0xff8
    8800287c:	97fffd04 	bl	88001c8c <mini_os_printf>
}
    88002880:	d503201f 	nop
    88002884:	a8c17bfd 	ldp	x29, x30, [sp], #16
    88002888:	d65f03c0 	ret

000000008800288c <shell_halt>:

static void shell_halt(void)
{
    8800288c:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    88002890:	910003fd 	mov	x29, sp
	mini_os_printf("Halting CPU. Use reset/restart in your emulator or board monitor.\n");
    88002894:	b0000000 	adrp	x0, 88003000 <hex.0+0x418>
    88002898:	91000000 	add	x0, x0, #0x0
    8800289c:	97fffcfc 	bl	88001c8c <mini_os_printf>
	for (;;) {
		__asm__ volatile ("wfe");
    880028a0:	d503205f 	wfe
    880028a4:	17ffffff 	b	880028a0 <shell_halt+0x14>

00000000880028a8 <shell_execute>:
	}
}

static void shell_execute(char *line)
{
    880028a8:	a9b97bfd 	stp	x29, x30, [sp, #-112]!
    880028ac:	910003fd 	mov	x29, sp
    880028b0:	f9000fe0 	str	x0, [sp, #24]
	char *argv[SHELL_MAX_ARGS];
	int argc;

	argc = shell_tokenize(line, argv, SHELL_MAX_ARGS);
    880028b4:	9100a3e0 	add	x0, sp, #0x28
    880028b8:	52800102 	mov	w2, #0x8                   	// #8
    880028bc:	aa0003e1 	mov	x1, x0
    880028c0:	f9400fe0 	ldr	x0, [sp, #24]
    880028c4:	97ffff43 	bl	880025d0 <shell_tokenize>
    880028c8:	b9006fe0 	str	w0, [sp, #108]
	if (argc == 0) {
    880028cc:	b9406fe0 	ldr	w0, [sp, #108]
    880028d0:	7100001f 	cmp	w0, #0x0
    880028d4:	54000bc0 	b.eq	88002a4c <shell_execute+0x1a4>  // b.none
		return;
	}

	if (strings_equal(argv[0], "help")) {
    880028d8:	f94017e2 	ldr	x2, [sp, #40]
    880028dc:	b0000000 	adrp	x0, 88003000 <hex.0+0x418>
    880028e0:	91012001 	add	x1, x0, #0x48
    880028e4:	aa0203e0 	mov	x0, x2
    880028e8:	97ffff11 	bl	8800252c <strings_equal>
    880028ec:	12001c00 	and	w0, w0, #0xff
    880028f0:	12000000 	and	w0, w0, #0x1
    880028f4:	7100001f 	cmp	w0, #0x0
    880028f8:	54000060 	b.eq	88002904 <shell_execute+0x5c>  // b.none
		shell_print_help();
    880028fc:	97ffff74 	bl	880026cc <shell_print_help>
    88002900:	14000054 	b	88002a50 <shell_execute+0x1a8>
	} else if (strings_equal(argv[0], "version")) {
    88002904:	f94017e2 	ldr	x2, [sp, #40]
    88002908:	b0000000 	adrp	x0, 88003000 <hex.0+0x418>
    8800290c:	91014001 	add	x1, x0, #0x50
    88002910:	aa0203e0 	mov	x0, x2
    88002914:	97ffff06 	bl	8800252c <strings_equal>
    88002918:	12001c00 	and	w0, w0, #0xff
    8800291c:	12000000 	and	w0, w0, #0x1
    88002920:	7100001f 	cmp	w0, #0x0
    88002924:	54000060 	b.eq	88002930 <shell_execute+0x88>  // b.none
		shell_print_version();
    88002928:	97ffff86 	bl	88002740 <shell_print_version>
    8800292c:	14000049 	b	88002a50 <shell_execute+0x1a8>
	} else if (strings_equal(argv[0], "info")) {
    88002930:	f94017e2 	ldr	x2, [sp, #40]
    88002934:	b0000000 	adrp	x0, 88003000 <hex.0+0x418>
    88002938:	91016001 	add	x1, x0, #0x58
    8800293c:	aa0203e0 	mov	x0, x2
    88002940:	97fffefb 	bl	8800252c <strings_equal>
    88002944:	12001c00 	and	w0, w0, #0xff
    88002948:	12000000 	and	w0, w0, #0x1
    8800294c:	7100001f 	cmp	w0, #0x0
    88002950:	54000060 	b.eq	8800295c <shell_execute+0xb4>  // b.none
		shell_print_info();
    88002954:	97ffff88 	bl	88002774 <shell_print_info>
    88002958:	1400003e 	b	88002a50 <shell_execute+0x1a8>
	} else if (strings_equal(argv[0], "echo")) {
    8800295c:	f94017e2 	ldr	x2, [sp, #40]
    88002960:	b0000000 	adrp	x0, 88003000 <hex.0+0x418>
    88002964:	91018001 	add	x1, x0, #0x60
    88002968:	aa0203e0 	mov	x0, x2
    8800296c:	97fffef0 	bl	8800252c <strings_equal>
    88002970:	12001c00 	and	w0, w0, #0xff
    88002974:	12000000 	and	w0, w0, #0x1
    88002978:	7100001f 	cmp	w0, #0x0
    8800297c:	540000c0 	b.eq	88002994 <shell_execute+0xec>  // b.none
		shell_echo_args(argc, argv);
    88002980:	9100a3e0 	add	x0, sp, #0x28
    88002984:	aa0003e1 	mov	x1, x0
    88002988:	b9406fe0 	ldr	w0, [sp, #108]
    8800298c:	97ffff93 	bl	880027d8 <shell_echo_args>
    88002990:	14000030 	b	88002a50 <shell_execute+0x1a8>
	} else if (strings_equal(argv[0], "clear")) {
    88002994:	f94017e2 	ldr	x2, [sp, #40]
    88002998:	b0000000 	adrp	x0, 88003000 <hex.0+0x418>
    8800299c:	9101a001 	add	x1, x0, #0x68
    880029a0:	aa0203e0 	mov	x0, x2
    880029a4:	97fffee2 	bl	8800252c <strings_equal>
    880029a8:	12001c00 	and	w0, w0, #0xff
    880029ac:	12000000 	and	w0, w0, #0x1
    880029b0:	7100001f 	cmp	w0, #0x0
    880029b4:	54000060 	b.eq	880029c0 <shell_execute+0x118>  // b.none
		shell_clear_screen();
    880029b8:	97ffffad 	bl	8800286c <shell_clear_screen>
    880029bc:	14000025 	b	88002a50 <shell_execute+0x1a8>
	} else if (strings_equal(argv[0], "uname")) {
    880029c0:	f94017e2 	ldr	x2, [sp, #40]
    880029c4:	b0000000 	adrp	x0, 88003000 <hex.0+0x418>
    880029c8:	9101c001 	add	x1, x0, #0x70
    880029cc:	aa0203e0 	mov	x0, x2
    880029d0:	97fffed7 	bl	8800252c <strings_equal>
    880029d4:	12001c00 	and	w0, w0, #0xff
    880029d8:	12000000 	and	w0, w0, #0x1
    880029dc:	7100001f 	cmp	w0, #0x0
    880029e0:	540000e0 	b.eq	880029fc <shell_execute+0x154>  // b.none
		mini_os_printf("%s\n", MINI_OS_NAME);
    880029e4:	90000000 	adrp	x0, 88002000 <uart_rx_ready+0x1c>
    880029e8:	913d6001 	add	x1, x0, #0xf58
    880029ec:	b0000000 	adrp	x0, 88003000 <hex.0+0x418>
    880029f0:	9101e000 	add	x0, x0, #0x78
    880029f4:	97fffca6 	bl	88001c8c <mini_os_printf>
    880029f8:	14000016 	b	88002a50 <shell_execute+0x1a8>
	} else if (strings_equal(argv[0], "halt")) {
    880029fc:	f94017e2 	ldr	x2, [sp, #40]
    88002a00:	b0000000 	adrp	x0, 88003000 <hex.0+0x418>
    88002a04:	91020001 	add	x1, x0, #0x80
    88002a08:	aa0203e0 	mov	x0, x2
    88002a0c:	97fffec8 	bl	8800252c <strings_equal>
    88002a10:	12001c00 	and	w0, w0, #0xff
    88002a14:	12000000 	and	w0, w0, #0x1
    88002a18:	7100001f 	cmp	w0, #0x0
    88002a1c:	54000060 	b.eq	88002a28 <shell_execute+0x180>  // b.none
		shell_halt();
    88002a20:	97ffff9b 	bl	8800288c <shell_halt>
    88002a24:	1400000b 	b	88002a50 <shell_execute+0x1a8>
	} else {
		mini_os_printf("Unknown command: %s\n", argv[0]);
    88002a28:	f94017e0 	ldr	x0, [sp, #40]
    88002a2c:	aa0003e1 	mov	x1, x0
    88002a30:	b0000000 	adrp	x0, 88003000 <hex.0+0x418>
    88002a34:	91022000 	add	x0, x0, #0x88
    88002a38:	97fffc95 	bl	88001c8c <mini_os_printf>
		mini_os_printf("Type 'help' to list supported commands.\n");
    88002a3c:	b0000000 	adrp	x0, 88003000 <hex.0+0x418>
    88002a40:	91028000 	add	x0, x0, #0xa0
    88002a44:	97fffc92 	bl	88001c8c <mini_os_printf>
    88002a48:	14000002 	b	88002a50 <shell_execute+0x1a8>
		return;
    88002a4c:	d503201f 	nop
	}
}
    88002a50:	a8c77bfd 	ldp	x29, x30, [sp], #112
    88002a54:	d65f03c0 	ret

0000000088002a58 <shell_prompt>:

static void shell_prompt(void)
{
    88002a58:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    88002a5c:	910003fd 	mov	x29, sp
	mini_os_printf("%s", SHELL_PROMPT);
    88002a60:	b0000000 	adrp	x0, 88003000 <hex.0+0x418>
    88002a64:	91034001 	add	x1, x0, #0xd0
    88002a68:	90000000 	adrp	x0, 88002000 <uart_rx_ready+0x1c>
    88002a6c:	913f8000 	add	x0, x0, #0xfe0
    88002a70:	97fffc87 	bl	88001c8c <mini_os_printf>
}
    88002a74:	d503201f 	nop
    88002a78:	a8c17bfd 	ldp	x29, x30, [sp], #16
    88002a7c:	d65f03c0 	ret

0000000088002a80 <shell_run>:

void shell_run(void)
{
    88002a80:	a9b67bfd 	stp	x29, x30, [sp, #-160]!
    88002a84:	910003fd 	mov	x29, sp
	char line[SHELL_MAX_LINE];
	size_t len = 0U;
    88002a88:	f9004fff 	str	xzr, [sp, #152]

	shell_prompt();
    88002a8c:	97fffff3 	bl	88002a58 <shell_prompt>
	for (;;) {
		int ch = debug_getc();
    88002a90:	97fffcc2 	bl	88001d98 <debug_getc>
    88002a94:	b90097e0 	str	w0, [sp, #148]

		if ((ch == '\r') || (ch == '\n')) {
    88002a98:	b94097e0 	ldr	w0, [sp, #148]
    88002a9c:	7100341f 	cmp	w0, #0xd
    88002aa0:	54000080 	b.eq	88002ab0 <shell_run+0x30>  // b.none
    88002aa4:	b94097e0 	ldr	w0, [sp, #148]
    88002aa8:	7100281f 	cmp	w0, #0xa
    88002aac:	54000181 	b.ne	88002adc <shell_run+0x5c>  // b.any
			mini_os_printf("\n");
    88002ab0:	90000000 	adrp	x0, 88002000 <uart_rx_ready+0x1c>
    88002ab4:	913fc000 	add	x0, x0, #0xff0
    88002ab8:	97fffc75 	bl	88001c8c <mini_os_printf>
			line[len] = '\0';
    88002abc:	f9404fe0 	ldr	x0, [sp, #152]
    88002ac0:	910043e1 	add	x1, sp, #0x10
    88002ac4:	3820683f 	strb	wzr, [x1, x0]
			shell_execute(line);
    88002ac8:	910043e0 	add	x0, sp, #0x10
    88002acc:	97ffff77 	bl	880028a8 <shell_execute>
			len = 0U;
    88002ad0:	f9004fff 	str	xzr, [sp, #152]
			shell_prompt();
    88002ad4:	97ffffe1 	bl	88002a58 <shell_prompt>
			continue;
    88002ad8:	14000034 	b	88002ba8 <shell_run+0x128>
		}

		if ((ch == '\b') || (ch == 127)) {
    88002adc:	b94097e0 	ldr	w0, [sp, #148]
    88002ae0:	7100201f 	cmp	w0, #0x8
    88002ae4:	54000080 	b.eq	88002af4 <shell_run+0x74>  // b.none
    88002ae8:	b94097e0 	ldr	w0, [sp, #148]
    88002aec:	7101fc1f 	cmp	w0, #0x7f
    88002af0:	54000161 	b.ne	88002b1c <shell_run+0x9c>  // b.any
			if (len > 0U) {
    88002af4:	f9404fe0 	ldr	x0, [sp, #152]
    88002af8:	f100001f 	cmp	x0, #0x0
    88002afc:	540004c0 	b.eq	88002b94 <shell_run+0x114>  // b.none
				len--;
    88002b00:	f9404fe0 	ldr	x0, [sp, #152]
    88002b04:	d1000400 	sub	x0, x0, #0x1
    88002b08:	f9004fe0 	str	x0, [sp, #152]
				mini_os_printf("\b \b");
    88002b0c:	b0000000 	adrp	x0, 88003000 <hex.0+0x418>
    88002b10:	91038000 	add	x0, x0, #0xe0
    88002b14:	97fffc5e 	bl	88001c8c <mini_os_printf>
			}
			continue;
    88002b18:	1400001f 	b	88002b94 <shell_run+0x114>
		}

		if (ch == '\t') {
    88002b1c:	b94097e0 	ldr	w0, [sp, #148]
    88002b20:	7100241f 	cmp	w0, #0x9
    88002b24:	540003c0 	b.eq	88002b9c <shell_run+0x11c>  // b.none
			continue;
		}

		if ((ch < 32) || (ch > 126)) {
    88002b28:	b94097e0 	ldr	w0, [sp, #148]
    88002b2c:	71007c1f 	cmp	w0, #0x1f
    88002b30:	540003ad 	b.le	88002ba4 <shell_run+0x124>
    88002b34:	b94097e0 	ldr	w0, [sp, #148]
    88002b38:	7101f81f 	cmp	w0, #0x7e
    88002b3c:	5400034c 	b.gt	88002ba4 <shell_run+0x124>
			continue;
		}

		if (len + 1U >= SHELL_MAX_LINE) {
    88002b40:	f9404fe0 	ldr	x0, [sp, #152]
    88002b44:	91000400 	add	x0, x0, #0x1
    88002b48:	f101fc1f 	cmp	x0, #0x7f
    88002b4c:	54000109 	b.ls	88002b6c <shell_run+0xec>  // b.plast
			mini_os_printf("\nerror: command too long (max %d chars)\n",
    88002b50:	52800fe1 	mov	w1, #0x7f                  	// #127
    88002b54:	b0000000 	adrp	x0, 88003000 <hex.0+0x418>
    88002b58:	9103a000 	add	x0, x0, #0xe8
    88002b5c:	97fffc4c 	bl	88001c8c <mini_os_printf>
				       SHELL_MAX_LINE - 1);
			len = 0U;
    88002b60:	f9004fff 	str	xzr, [sp, #152]
			shell_prompt();
    88002b64:	97ffffbd 	bl	88002a58 <shell_prompt>
			continue;
    88002b68:	14000010 	b	88002ba8 <shell_run+0x128>
		}

		line[len++] = (char)ch;
    88002b6c:	f9404fe0 	ldr	x0, [sp, #152]
    88002b70:	91000401 	add	x1, x0, #0x1
    88002b74:	f9004fe1 	str	x1, [sp, #152]
    88002b78:	b94097e1 	ldr	w1, [sp, #148]
    88002b7c:	12001c22 	and	w2, w1, #0xff
    88002b80:	910043e1 	add	x1, sp, #0x10
    88002b84:	38206822 	strb	w2, [x1, x0]
		debug_putc(ch);
    88002b88:	b94097e0 	ldr	w0, [sp, #148]
    88002b8c:	97fffc69 	bl	88001d30 <debug_putc>
    88002b90:	17ffffc0 	b	88002a90 <shell_run+0x10>
			continue;
    88002b94:	d503201f 	nop
    88002b98:	17ffffbe 	b	88002a90 <shell_run+0x10>
			continue;
    88002b9c:	d503201f 	nop
    88002ba0:	17ffffbc 	b	88002a90 <shell_run+0x10>
			continue;
    88002ba4:	d503201f 	nop
	for (;;) {
    88002ba8:	17ffffba 	b	88002a90 <shell_run+0x10>
