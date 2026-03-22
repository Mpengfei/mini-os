
/home/pengfei/felix-os/mini-os/build/Neoverse-N3/debug/mini-os.elf:     file format elf64-littleaarch64


Disassembly of section .text:

00000000c0000000 <_start>:
    c0000000:	580000c0 	ldr	x0, c0000018 <_start+0x18>
    c0000004:	9100001f 	mov	sp, x0
    c0000008:	94000947 	bl	c0002524 <kernel_main>
    c000000c:	d503205f 	wfe
    c0000010:	17ffffff 	b	c000000c <_start+0xc>
    c0000014:	00000000 	udf	#0
    c0000018:	c000f8f0 	.word	0xc000f8f0
    c000001c:	00000000 	.word	0x00000000

00000000c0000020 <secondary_cpu_entrypoint>:
    c0000020:	58000101 	ldr	x1, c0000040 <secondary_cpu_entrypoint+0x20>
    c0000024:	58000122 	ldr	x2, c0000048 <secondary_cpu_entrypoint+0x28>
    c0000028:	9b020401 	madd	x1, x0, x2, x1
    c000002c:	8b020021 	add	x1, x1, x2
    c0000030:	9100003f 	mov	sp, x1
    c0000034:	940012db 	bl	c0004ba0 <smp_secondary_entry>
    c0000038:	d503205f 	wfe
    c000003c:	17ffffff 	b	c0000038 <secondary_cpu_entrypoint+0x18>
    c0000040:	c0006720 	.word	0xc0006720
    c0000044:	00000000 	.word	0x00000000
    c0000048:	00001000 	.word	0x00001000
    c000004c:	00000000 	.word	0x00000000

00000000c0000050 <print_char>:
	int length;
	char conv;
};

static void print_char(struct print_ctx *ctx, char ch)
{
    c0000050:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c0000054:	910003fd 	mov	x29, sp
    c0000058:	f9000fe0 	str	x0, [sp, #24]
    c000005c:	39005fe1 	strb	w1, [sp, #23]
	if (ch == '\n') {
    c0000060:	39405fe0 	ldrb	w0, [sp, #23]
    c0000064:	7100281f 	cmp	w0, #0xa
    c0000068:	54000061 	b.ne	c0000074 <print_char+0x24>  // b.any
		debug_putc('\r');
    c000006c:	528001a0 	mov	w0, #0xd                   	// #13
    c0000070:	9400073c 	bl	c0001d60 <debug_putc>
	}

	debug_putc((int)ch);
    c0000074:	39405fe0 	ldrb	w0, [sp, #23]
    c0000078:	9400073a 	bl	c0001d60 <debug_putc>
	ctx->count++;
    c000007c:	f9400fe0 	ldr	x0, [sp, #24]
    c0000080:	b9400000 	ldr	w0, [x0]
    c0000084:	11000401 	add	w1, w0, #0x1
    c0000088:	f9400fe0 	ldr	x0, [sp, #24]
    c000008c:	b9000001 	str	w1, [x0]
}
    c0000090:	d503201f 	nop
    c0000094:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c0000098:	d65f03c0 	ret

00000000c000009c <print_repeat>:

static void print_repeat(struct print_ctx *ctx, char ch, int count)
{
    c000009c:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c00000a0:	910003fd 	mov	x29, sp
    c00000a4:	f9000fe0 	str	x0, [sp, #24]
    c00000a8:	39005fe1 	strb	w1, [sp, #23]
    c00000ac:	b90013e2 	str	w2, [sp, #16]
	while (count-- > 0) {
    c00000b0:	14000004 	b	c00000c0 <print_repeat+0x24>
		print_char(ctx, ch);
    c00000b4:	39405fe1 	ldrb	w1, [sp, #23]
    c00000b8:	f9400fe0 	ldr	x0, [sp, #24]
    c00000bc:	97ffffe5 	bl	c0000050 <print_char>
	while (count-- > 0) {
    c00000c0:	b94013e0 	ldr	w0, [sp, #16]
    c00000c4:	51000401 	sub	w1, w0, #0x1
    c00000c8:	b90013e1 	str	w1, [sp, #16]
    c00000cc:	7100001f 	cmp	w0, #0x0
    c00000d0:	54ffff2c 	b.gt	c00000b4 <print_repeat+0x18>
	}
}
    c00000d4:	d503201f 	nop
    c00000d8:	d503201f 	nop
    c00000dc:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c00000e0:	d65f03c0 	ret

00000000c00000e4 <str_length>:

static size_t str_length(const char *str)
{
    c00000e4:	d10083ff 	sub	sp, sp, #0x20
    c00000e8:	f90007e0 	str	x0, [sp, #8]
	size_t len = 0U;
    c00000ec:	f9000fff 	str	xzr, [sp, #24]

	while (str[len] != '\0') {
    c00000f0:	14000004 	b	c0000100 <str_length+0x1c>
		len++;
    c00000f4:	f9400fe0 	ldr	x0, [sp, #24]
    c00000f8:	91000400 	add	x0, x0, #0x1
    c00000fc:	f9000fe0 	str	x0, [sp, #24]
	while (str[len] != '\0') {
    c0000100:	f94007e1 	ldr	x1, [sp, #8]
    c0000104:	f9400fe0 	ldr	x0, [sp, #24]
    c0000108:	8b000020 	add	x0, x1, x0
    c000010c:	39400000 	ldrb	w0, [x0]
    c0000110:	7100001f 	cmp	w0, #0x0
    c0000114:	54ffff01 	b.ne	c00000f4 <str_length+0x10>  // b.any
	}

	return len;
    c0000118:	f9400fe0 	ldr	x0, [sp, #24]
}
    c000011c:	910083ff 	add	sp, sp, #0x20
    c0000120:	d65f03c0 	ret

00000000c0000124 <get_unsigned_arg>:

static uint64_t get_unsigned_arg(va_list *args, int length)
{
    c0000124:	d10043ff 	sub	sp, sp, #0x10
    c0000128:	f90007e0 	str	x0, [sp, #8]
    c000012c:	b90007e1 	str	w1, [sp, #4]
	switch (length) {
    c0000130:	b94007e0 	ldr	w0, [sp, #4]
    c0000134:	71001c1f 	cmp	w0, #0x7
    c0000138:	54001aa0 	b.eq	c000048c <get_unsigned_arg+0x368>  // b.none
    c000013c:	b94007e0 	ldr	w0, [sp, #4]
    c0000140:	71001c1f 	cmp	w0, #0x7
    c0000144:	54001dec 	b.gt	c0000500 <get_unsigned_arg+0x3dc>
    c0000148:	b94007e0 	ldr	w0, [sp, #4]
    c000014c:	7100181f 	cmp	w0, #0x6
    c0000150:	54001640 	b.eq	c0000418 <get_unsigned_arg+0x2f4>  // b.none
    c0000154:	b94007e0 	ldr	w0, [sp, #4]
    c0000158:	7100181f 	cmp	w0, #0x6
    c000015c:	54001d2c 	b.gt	c0000500 <get_unsigned_arg+0x3dc>
    c0000160:	b94007e0 	ldr	w0, [sp, #4]
    c0000164:	7100141f 	cmp	w0, #0x5
    c0000168:	540011e0 	b.eq	c00003a4 <get_unsigned_arg+0x280>  // b.none
    c000016c:	b94007e0 	ldr	w0, [sp, #4]
    c0000170:	7100141f 	cmp	w0, #0x5
    c0000174:	54001c6c 	b.gt	c0000500 <get_unsigned_arg+0x3dc>
    c0000178:	b94007e0 	ldr	w0, [sp, #4]
    c000017c:	7100101f 	cmp	w0, #0x4
    c0000180:	54000d80 	b.eq	c0000330 <get_unsigned_arg+0x20c>  // b.none
    c0000184:	b94007e0 	ldr	w0, [sp, #4]
    c0000188:	7100101f 	cmp	w0, #0x4
    c000018c:	54001bac 	b.gt	c0000500 <get_unsigned_arg+0x3dc>
    c0000190:	b94007e0 	ldr	w0, [sp, #4]
    c0000194:	71000c1f 	cmp	w0, #0x3
    c0000198:	54000920 	b.eq	c00002bc <get_unsigned_arg+0x198>  // b.none
    c000019c:	b94007e0 	ldr	w0, [sp, #4]
    c00001a0:	71000c1f 	cmp	w0, #0x3
    c00001a4:	54001aec 	b.gt	c0000500 <get_unsigned_arg+0x3dc>
    c00001a8:	b94007e0 	ldr	w0, [sp, #4]
    c00001ac:	7100041f 	cmp	w0, #0x1
    c00001b0:	540000a0 	b.eq	c00001c4 <get_unsigned_arg+0xa0>  // b.none
    c00001b4:	b94007e0 	ldr	w0, [sp, #4]
    c00001b8:	7100081f 	cmp	w0, #0x2
    c00001bc:	54000420 	b.eq	c0000240 <get_unsigned_arg+0x11c>  // b.none
    c00001c0:	140000d0 	b	c0000500 <get_unsigned_arg+0x3dc>
	case LENGTH_HH:
		return (uint64_t)(unsigned char)va_arg(*args, unsigned int);
    c00001c4:	f94007e0 	ldr	x0, [sp, #8]
    c00001c8:	b9401801 	ldr	w1, [x0, #24]
    c00001cc:	f94007e0 	ldr	x0, [sp, #8]
    c00001d0:	f9400000 	ldr	x0, [x0]
    c00001d4:	7100003f 	cmp	w1, #0x0
    c00001d8:	540000cb 	b.lt	c00001f0 <get_unsigned_arg+0xcc>  // b.tstop
    c00001dc:	91002c01 	add	x1, x0, #0xb
    c00001e0:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c00001e4:	f94007e1 	ldr	x1, [sp, #8]
    c00001e8:	f9000022 	str	x2, [x1]
    c00001ec:	14000011 	b	c0000230 <get_unsigned_arg+0x10c>
    c00001f0:	11002023 	add	w3, w1, #0x8
    c00001f4:	f94007e2 	ldr	x2, [sp, #8]
    c00001f8:	b9001843 	str	w3, [x2, #24]
    c00001fc:	f94007e2 	ldr	x2, [sp, #8]
    c0000200:	b9401842 	ldr	w2, [x2, #24]
    c0000204:	7100005f 	cmp	w2, #0x0
    c0000208:	540000cd 	b.le	c0000220 <get_unsigned_arg+0xfc>
    c000020c:	91002c01 	add	x1, x0, #0xb
    c0000210:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c0000214:	f94007e1 	ldr	x1, [sp, #8]
    c0000218:	f9000022 	str	x2, [x1]
    c000021c:	14000005 	b	c0000230 <get_unsigned_arg+0x10c>
    c0000220:	f94007e0 	ldr	x0, [sp, #8]
    c0000224:	f9400402 	ldr	x2, [x0, #8]
    c0000228:	93407c20 	sxtw	x0, w1
    c000022c:	8b000040 	add	x0, x2, x0
    c0000230:	b9400000 	ldr	w0, [x0]
    c0000234:	12001c00 	and	w0, w0, #0xff
    c0000238:	92401c00 	and	x0, x0, #0xff
    c000023c:	140000ce 	b	c0000574 <get_unsigned_arg+0x450>
	case LENGTH_H:
		return (uint64_t)(unsigned short)va_arg(*args, unsigned int);
    c0000240:	f94007e0 	ldr	x0, [sp, #8]
    c0000244:	b9401801 	ldr	w1, [x0, #24]
    c0000248:	f94007e0 	ldr	x0, [sp, #8]
    c000024c:	f9400000 	ldr	x0, [x0]
    c0000250:	7100003f 	cmp	w1, #0x0
    c0000254:	540000cb 	b.lt	c000026c <get_unsigned_arg+0x148>  // b.tstop
    c0000258:	91002c01 	add	x1, x0, #0xb
    c000025c:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c0000260:	f94007e1 	ldr	x1, [sp, #8]
    c0000264:	f9000022 	str	x2, [x1]
    c0000268:	14000011 	b	c00002ac <get_unsigned_arg+0x188>
    c000026c:	11002023 	add	w3, w1, #0x8
    c0000270:	f94007e2 	ldr	x2, [sp, #8]
    c0000274:	b9001843 	str	w3, [x2, #24]
    c0000278:	f94007e2 	ldr	x2, [sp, #8]
    c000027c:	b9401842 	ldr	w2, [x2, #24]
    c0000280:	7100005f 	cmp	w2, #0x0
    c0000284:	540000cd 	b.le	c000029c <get_unsigned_arg+0x178>
    c0000288:	91002c01 	add	x1, x0, #0xb
    c000028c:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c0000290:	f94007e1 	ldr	x1, [sp, #8]
    c0000294:	f9000022 	str	x2, [x1]
    c0000298:	14000005 	b	c00002ac <get_unsigned_arg+0x188>
    c000029c:	f94007e0 	ldr	x0, [sp, #8]
    c00002a0:	f9400402 	ldr	x2, [x0, #8]
    c00002a4:	93407c20 	sxtw	x0, w1
    c00002a8:	8b000040 	add	x0, x2, x0
    c00002ac:	b9400000 	ldr	w0, [x0]
    c00002b0:	12003c00 	and	w0, w0, #0xffff
    c00002b4:	92403c00 	and	x0, x0, #0xffff
    c00002b8:	140000af 	b	c0000574 <get_unsigned_arg+0x450>
	case LENGTH_L:
		return (uint64_t)va_arg(*args, unsigned long);
    c00002bc:	f94007e0 	ldr	x0, [sp, #8]
    c00002c0:	b9401801 	ldr	w1, [x0, #24]
    c00002c4:	f94007e0 	ldr	x0, [sp, #8]
    c00002c8:	f9400000 	ldr	x0, [x0]
    c00002cc:	7100003f 	cmp	w1, #0x0
    c00002d0:	540000cb 	b.lt	c00002e8 <get_unsigned_arg+0x1c4>  // b.tstop
    c00002d4:	91003c01 	add	x1, x0, #0xf
    c00002d8:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c00002dc:	f94007e1 	ldr	x1, [sp, #8]
    c00002e0:	f9000022 	str	x2, [x1]
    c00002e4:	14000011 	b	c0000328 <get_unsigned_arg+0x204>
    c00002e8:	11002023 	add	w3, w1, #0x8
    c00002ec:	f94007e2 	ldr	x2, [sp, #8]
    c00002f0:	b9001843 	str	w3, [x2, #24]
    c00002f4:	f94007e2 	ldr	x2, [sp, #8]
    c00002f8:	b9401842 	ldr	w2, [x2, #24]
    c00002fc:	7100005f 	cmp	w2, #0x0
    c0000300:	540000cd 	b.le	c0000318 <get_unsigned_arg+0x1f4>
    c0000304:	91003c01 	add	x1, x0, #0xf
    c0000308:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c000030c:	f94007e1 	ldr	x1, [sp, #8]
    c0000310:	f9000022 	str	x2, [x1]
    c0000314:	14000005 	b	c0000328 <get_unsigned_arg+0x204>
    c0000318:	f94007e0 	ldr	x0, [sp, #8]
    c000031c:	f9400402 	ldr	x2, [x0, #8]
    c0000320:	93407c20 	sxtw	x0, w1
    c0000324:	8b000040 	add	x0, x2, x0
    c0000328:	f9400000 	ldr	x0, [x0]
    c000032c:	14000092 	b	c0000574 <get_unsigned_arg+0x450>
	case LENGTH_LL:
		return (uint64_t)va_arg(*args, unsigned long long);
    c0000330:	f94007e0 	ldr	x0, [sp, #8]
    c0000334:	b9401801 	ldr	w1, [x0, #24]
    c0000338:	f94007e0 	ldr	x0, [sp, #8]
    c000033c:	f9400000 	ldr	x0, [x0]
    c0000340:	7100003f 	cmp	w1, #0x0
    c0000344:	540000cb 	b.lt	c000035c <get_unsigned_arg+0x238>  // b.tstop
    c0000348:	91003c01 	add	x1, x0, #0xf
    c000034c:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c0000350:	f94007e1 	ldr	x1, [sp, #8]
    c0000354:	f9000022 	str	x2, [x1]
    c0000358:	14000011 	b	c000039c <get_unsigned_arg+0x278>
    c000035c:	11002023 	add	w3, w1, #0x8
    c0000360:	f94007e2 	ldr	x2, [sp, #8]
    c0000364:	b9001843 	str	w3, [x2, #24]
    c0000368:	f94007e2 	ldr	x2, [sp, #8]
    c000036c:	b9401842 	ldr	w2, [x2, #24]
    c0000370:	7100005f 	cmp	w2, #0x0
    c0000374:	540000cd 	b.le	c000038c <get_unsigned_arg+0x268>
    c0000378:	91003c01 	add	x1, x0, #0xf
    c000037c:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c0000380:	f94007e1 	ldr	x1, [sp, #8]
    c0000384:	f9000022 	str	x2, [x1]
    c0000388:	14000005 	b	c000039c <get_unsigned_arg+0x278>
    c000038c:	f94007e0 	ldr	x0, [sp, #8]
    c0000390:	f9400402 	ldr	x2, [x0, #8]
    c0000394:	93407c20 	sxtw	x0, w1
    c0000398:	8b000040 	add	x0, x2, x0
    c000039c:	f9400000 	ldr	x0, [x0]
    c00003a0:	14000075 	b	c0000574 <get_unsigned_arg+0x450>
	case LENGTH_Z:
		return (uint64_t)va_arg(*args, size_t);
    c00003a4:	f94007e0 	ldr	x0, [sp, #8]
    c00003a8:	b9401801 	ldr	w1, [x0, #24]
    c00003ac:	f94007e0 	ldr	x0, [sp, #8]
    c00003b0:	f9400000 	ldr	x0, [x0]
    c00003b4:	7100003f 	cmp	w1, #0x0
    c00003b8:	540000cb 	b.lt	c00003d0 <get_unsigned_arg+0x2ac>  // b.tstop
    c00003bc:	91003c01 	add	x1, x0, #0xf
    c00003c0:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c00003c4:	f94007e1 	ldr	x1, [sp, #8]
    c00003c8:	f9000022 	str	x2, [x1]
    c00003cc:	14000011 	b	c0000410 <get_unsigned_arg+0x2ec>
    c00003d0:	11002023 	add	w3, w1, #0x8
    c00003d4:	f94007e2 	ldr	x2, [sp, #8]
    c00003d8:	b9001843 	str	w3, [x2, #24]
    c00003dc:	f94007e2 	ldr	x2, [sp, #8]
    c00003e0:	b9401842 	ldr	w2, [x2, #24]
    c00003e4:	7100005f 	cmp	w2, #0x0
    c00003e8:	540000cd 	b.le	c0000400 <get_unsigned_arg+0x2dc>
    c00003ec:	91003c01 	add	x1, x0, #0xf
    c00003f0:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c00003f4:	f94007e1 	ldr	x1, [sp, #8]
    c00003f8:	f9000022 	str	x2, [x1]
    c00003fc:	14000005 	b	c0000410 <get_unsigned_arg+0x2ec>
    c0000400:	f94007e0 	ldr	x0, [sp, #8]
    c0000404:	f9400402 	ldr	x2, [x0, #8]
    c0000408:	93407c20 	sxtw	x0, w1
    c000040c:	8b000040 	add	x0, x2, x0
    c0000410:	f9400000 	ldr	x0, [x0]
    c0000414:	14000058 	b	c0000574 <get_unsigned_arg+0x450>
	case LENGTH_T:
		return (uint64_t)va_arg(*args, ptrdiff_t);
    c0000418:	f94007e0 	ldr	x0, [sp, #8]
    c000041c:	b9401801 	ldr	w1, [x0, #24]
    c0000420:	f94007e0 	ldr	x0, [sp, #8]
    c0000424:	f9400000 	ldr	x0, [x0]
    c0000428:	7100003f 	cmp	w1, #0x0
    c000042c:	540000cb 	b.lt	c0000444 <get_unsigned_arg+0x320>  // b.tstop
    c0000430:	91003c01 	add	x1, x0, #0xf
    c0000434:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c0000438:	f94007e1 	ldr	x1, [sp, #8]
    c000043c:	f9000022 	str	x2, [x1]
    c0000440:	14000011 	b	c0000484 <get_unsigned_arg+0x360>
    c0000444:	11002023 	add	w3, w1, #0x8
    c0000448:	f94007e2 	ldr	x2, [sp, #8]
    c000044c:	b9001843 	str	w3, [x2, #24]
    c0000450:	f94007e2 	ldr	x2, [sp, #8]
    c0000454:	b9401842 	ldr	w2, [x2, #24]
    c0000458:	7100005f 	cmp	w2, #0x0
    c000045c:	540000cd 	b.le	c0000474 <get_unsigned_arg+0x350>
    c0000460:	91003c01 	add	x1, x0, #0xf
    c0000464:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c0000468:	f94007e1 	ldr	x1, [sp, #8]
    c000046c:	f9000022 	str	x2, [x1]
    c0000470:	14000005 	b	c0000484 <get_unsigned_arg+0x360>
    c0000474:	f94007e0 	ldr	x0, [sp, #8]
    c0000478:	f9400402 	ldr	x2, [x0, #8]
    c000047c:	93407c20 	sxtw	x0, w1
    c0000480:	8b000040 	add	x0, x2, x0
    c0000484:	f9400000 	ldr	x0, [x0]
    c0000488:	1400003b 	b	c0000574 <get_unsigned_arg+0x450>
	case LENGTH_J:
		return (uint64_t)va_arg(*args, uintmax_t);
    c000048c:	f94007e0 	ldr	x0, [sp, #8]
    c0000490:	b9401801 	ldr	w1, [x0, #24]
    c0000494:	f94007e0 	ldr	x0, [sp, #8]
    c0000498:	f9400000 	ldr	x0, [x0]
    c000049c:	7100003f 	cmp	w1, #0x0
    c00004a0:	540000cb 	b.lt	c00004b8 <get_unsigned_arg+0x394>  // b.tstop
    c00004a4:	91003c01 	add	x1, x0, #0xf
    c00004a8:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c00004ac:	f94007e1 	ldr	x1, [sp, #8]
    c00004b0:	f9000022 	str	x2, [x1]
    c00004b4:	14000011 	b	c00004f8 <get_unsigned_arg+0x3d4>
    c00004b8:	11002023 	add	w3, w1, #0x8
    c00004bc:	f94007e2 	ldr	x2, [sp, #8]
    c00004c0:	b9001843 	str	w3, [x2, #24]
    c00004c4:	f94007e2 	ldr	x2, [sp, #8]
    c00004c8:	b9401842 	ldr	w2, [x2, #24]
    c00004cc:	7100005f 	cmp	w2, #0x0
    c00004d0:	540000cd 	b.le	c00004e8 <get_unsigned_arg+0x3c4>
    c00004d4:	91003c01 	add	x1, x0, #0xf
    c00004d8:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c00004dc:	f94007e1 	ldr	x1, [sp, #8]
    c00004e0:	f9000022 	str	x2, [x1]
    c00004e4:	14000005 	b	c00004f8 <get_unsigned_arg+0x3d4>
    c00004e8:	f94007e0 	ldr	x0, [sp, #8]
    c00004ec:	f9400402 	ldr	x2, [x0, #8]
    c00004f0:	93407c20 	sxtw	x0, w1
    c00004f4:	8b000040 	add	x0, x2, x0
    c00004f8:	f9400000 	ldr	x0, [x0]
    c00004fc:	1400001e 	b	c0000574 <get_unsigned_arg+0x450>
	default:
		return (uint64_t)va_arg(*args, unsigned int);
    c0000500:	f94007e0 	ldr	x0, [sp, #8]
    c0000504:	b9401801 	ldr	w1, [x0, #24]
    c0000508:	f94007e0 	ldr	x0, [sp, #8]
    c000050c:	f9400000 	ldr	x0, [x0]
    c0000510:	7100003f 	cmp	w1, #0x0
    c0000514:	540000cb 	b.lt	c000052c <get_unsigned_arg+0x408>  // b.tstop
    c0000518:	91002c01 	add	x1, x0, #0xb
    c000051c:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c0000520:	f94007e1 	ldr	x1, [sp, #8]
    c0000524:	f9000022 	str	x2, [x1]
    c0000528:	14000011 	b	c000056c <get_unsigned_arg+0x448>
    c000052c:	11002023 	add	w3, w1, #0x8
    c0000530:	f94007e2 	ldr	x2, [sp, #8]
    c0000534:	b9001843 	str	w3, [x2, #24]
    c0000538:	f94007e2 	ldr	x2, [sp, #8]
    c000053c:	b9401842 	ldr	w2, [x2, #24]
    c0000540:	7100005f 	cmp	w2, #0x0
    c0000544:	540000cd 	b.le	c000055c <get_unsigned_arg+0x438>
    c0000548:	91002c01 	add	x1, x0, #0xb
    c000054c:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c0000550:	f94007e1 	ldr	x1, [sp, #8]
    c0000554:	f9000022 	str	x2, [x1]
    c0000558:	14000005 	b	c000056c <get_unsigned_arg+0x448>
    c000055c:	f94007e0 	ldr	x0, [sp, #8]
    c0000560:	f9400402 	ldr	x2, [x0, #8]
    c0000564:	93407c20 	sxtw	x0, w1
    c0000568:	8b000040 	add	x0, x2, x0
    c000056c:	b9400000 	ldr	w0, [x0]
    c0000570:	2a0003e0 	mov	w0, w0
	}
}
    c0000574:	910043ff 	add	sp, sp, #0x10
    c0000578:	d65f03c0 	ret

00000000c000057c <get_signed_arg>:

static int64_t get_signed_arg(va_list *args, int length)
{
    c000057c:	d10043ff 	sub	sp, sp, #0x10
    c0000580:	f90007e0 	str	x0, [sp, #8]
    c0000584:	b90007e1 	str	w1, [sp, #4]
	switch (length) {
    c0000588:	b94007e0 	ldr	w0, [sp, #4]
    c000058c:	71001c1f 	cmp	w0, #0x7
    c0000590:	54001aa0 	b.eq	c00008e4 <get_signed_arg+0x368>  // b.none
    c0000594:	b94007e0 	ldr	w0, [sp, #4]
    c0000598:	71001c1f 	cmp	w0, #0x7
    c000059c:	54001dec 	b.gt	c0000958 <get_signed_arg+0x3dc>
    c00005a0:	b94007e0 	ldr	w0, [sp, #4]
    c00005a4:	7100181f 	cmp	w0, #0x6
    c00005a8:	54001640 	b.eq	c0000870 <get_signed_arg+0x2f4>  // b.none
    c00005ac:	b94007e0 	ldr	w0, [sp, #4]
    c00005b0:	7100181f 	cmp	w0, #0x6
    c00005b4:	54001d2c 	b.gt	c0000958 <get_signed_arg+0x3dc>
    c00005b8:	b94007e0 	ldr	w0, [sp, #4]
    c00005bc:	7100141f 	cmp	w0, #0x5
    c00005c0:	540011e0 	b.eq	c00007fc <get_signed_arg+0x280>  // b.none
    c00005c4:	b94007e0 	ldr	w0, [sp, #4]
    c00005c8:	7100141f 	cmp	w0, #0x5
    c00005cc:	54001c6c 	b.gt	c0000958 <get_signed_arg+0x3dc>
    c00005d0:	b94007e0 	ldr	w0, [sp, #4]
    c00005d4:	7100101f 	cmp	w0, #0x4
    c00005d8:	54000d80 	b.eq	c0000788 <get_signed_arg+0x20c>  // b.none
    c00005dc:	b94007e0 	ldr	w0, [sp, #4]
    c00005e0:	7100101f 	cmp	w0, #0x4
    c00005e4:	54001bac 	b.gt	c0000958 <get_signed_arg+0x3dc>
    c00005e8:	b94007e0 	ldr	w0, [sp, #4]
    c00005ec:	71000c1f 	cmp	w0, #0x3
    c00005f0:	54000920 	b.eq	c0000714 <get_signed_arg+0x198>  // b.none
    c00005f4:	b94007e0 	ldr	w0, [sp, #4]
    c00005f8:	71000c1f 	cmp	w0, #0x3
    c00005fc:	54001aec 	b.gt	c0000958 <get_signed_arg+0x3dc>
    c0000600:	b94007e0 	ldr	w0, [sp, #4]
    c0000604:	7100041f 	cmp	w0, #0x1
    c0000608:	540000a0 	b.eq	c000061c <get_signed_arg+0xa0>  // b.none
    c000060c:	b94007e0 	ldr	w0, [sp, #4]
    c0000610:	7100081f 	cmp	w0, #0x2
    c0000614:	54000420 	b.eq	c0000698 <get_signed_arg+0x11c>  // b.none
    c0000618:	140000d0 	b	c0000958 <get_signed_arg+0x3dc>
	case LENGTH_HH:
		return (int64_t)(signed char)va_arg(*args, int);
    c000061c:	f94007e0 	ldr	x0, [sp, #8]
    c0000620:	b9401801 	ldr	w1, [x0, #24]
    c0000624:	f94007e0 	ldr	x0, [sp, #8]
    c0000628:	f9400000 	ldr	x0, [x0]
    c000062c:	7100003f 	cmp	w1, #0x0
    c0000630:	540000cb 	b.lt	c0000648 <get_signed_arg+0xcc>  // b.tstop
    c0000634:	91002c01 	add	x1, x0, #0xb
    c0000638:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c000063c:	f94007e1 	ldr	x1, [sp, #8]
    c0000640:	f9000022 	str	x2, [x1]
    c0000644:	14000011 	b	c0000688 <get_signed_arg+0x10c>
    c0000648:	11002023 	add	w3, w1, #0x8
    c000064c:	f94007e2 	ldr	x2, [sp, #8]
    c0000650:	b9001843 	str	w3, [x2, #24]
    c0000654:	f94007e2 	ldr	x2, [sp, #8]
    c0000658:	b9401842 	ldr	w2, [x2, #24]
    c000065c:	7100005f 	cmp	w2, #0x0
    c0000660:	540000cd 	b.le	c0000678 <get_signed_arg+0xfc>
    c0000664:	91002c01 	add	x1, x0, #0xb
    c0000668:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c000066c:	f94007e1 	ldr	x1, [sp, #8]
    c0000670:	f9000022 	str	x2, [x1]
    c0000674:	14000005 	b	c0000688 <get_signed_arg+0x10c>
    c0000678:	f94007e0 	ldr	x0, [sp, #8]
    c000067c:	f9400402 	ldr	x2, [x0, #8]
    c0000680:	93407c20 	sxtw	x0, w1
    c0000684:	8b000040 	add	x0, x2, x0
    c0000688:	b9400000 	ldr	w0, [x0]
    c000068c:	13001c00 	sxtb	w0, w0
    c0000690:	93401c00 	sxtb	x0, w0
    c0000694:	140000ce 	b	c00009cc <get_signed_arg+0x450>
	case LENGTH_H:
		return (int64_t)(short)va_arg(*args, int);
    c0000698:	f94007e0 	ldr	x0, [sp, #8]
    c000069c:	b9401801 	ldr	w1, [x0, #24]
    c00006a0:	f94007e0 	ldr	x0, [sp, #8]
    c00006a4:	f9400000 	ldr	x0, [x0]
    c00006a8:	7100003f 	cmp	w1, #0x0
    c00006ac:	540000cb 	b.lt	c00006c4 <get_signed_arg+0x148>  // b.tstop
    c00006b0:	91002c01 	add	x1, x0, #0xb
    c00006b4:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c00006b8:	f94007e1 	ldr	x1, [sp, #8]
    c00006bc:	f9000022 	str	x2, [x1]
    c00006c0:	14000011 	b	c0000704 <get_signed_arg+0x188>
    c00006c4:	11002023 	add	w3, w1, #0x8
    c00006c8:	f94007e2 	ldr	x2, [sp, #8]
    c00006cc:	b9001843 	str	w3, [x2, #24]
    c00006d0:	f94007e2 	ldr	x2, [sp, #8]
    c00006d4:	b9401842 	ldr	w2, [x2, #24]
    c00006d8:	7100005f 	cmp	w2, #0x0
    c00006dc:	540000cd 	b.le	c00006f4 <get_signed_arg+0x178>
    c00006e0:	91002c01 	add	x1, x0, #0xb
    c00006e4:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c00006e8:	f94007e1 	ldr	x1, [sp, #8]
    c00006ec:	f9000022 	str	x2, [x1]
    c00006f0:	14000005 	b	c0000704 <get_signed_arg+0x188>
    c00006f4:	f94007e0 	ldr	x0, [sp, #8]
    c00006f8:	f9400402 	ldr	x2, [x0, #8]
    c00006fc:	93407c20 	sxtw	x0, w1
    c0000700:	8b000040 	add	x0, x2, x0
    c0000704:	b9400000 	ldr	w0, [x0]
    c0000708:	13003c00 	sxth	w0, w0
    c000070c:	93403c00 	sxth	x0, w0
    c0000710:	140000af 	b	c00009cc <get_signed_arg+0x450>
	case LENGTH_L:
		return (int64_t)va_arg(*args, long);
    c0000714:	f94007e0 	ldr	x0, [sp, #8]
    c0000718:	b9401801 	ldr	w1, [x0, #24]
    c000071c:	f94007e0 	ldr	x0, [sp, #8]
    c0000720:	f9400000 	ldr	x0, [x0]
    c0000724:	7100003f 	cmp	w1, #0x0
    c0000728:	540000cb 	b.lt	c0000740 <get_signed_arg+0x1c4>  // b.tstop
    c000072c:	91003c01 	add	x1, x0, #0xf
    c0000730:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c0000734:	f94007e1 	ldr	x1, [sp, #8]
    c0000738:	f9000022 	str	x2, [x1]
    c000073c:	14000011 	b	c0000780 <get_signed_arg+0x204>
    c0000740:	11002023 	add	w3, w1, #0x8
    c0000744:	f94007e2 	ldr	x2, [sp, #8]
    c0000748:	b9001843 	str	w3, [x2, #24]
    c000074c:	f94007e2 	ldr	x2, [sp, #8]
    c0000750:	b9401842 	ldr	w2, [x2, #24]
    c0000754:	7100005f 	cmp	w2, #0x0
    c0000758:	540000cd 	b.le	c0000770 <get_signed_arg+0x1f4>
    c000075c:	91003c01 	add	x1, x0, #0xf
    c0000760:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c0000764:	f94007e1 	ldr	x1, [sp, #8]
    c0000768:	f9000022 	str	x2, [x1]
    c000076c:	14000005 	b	c0000780 <get_signed_arg+0x204>
    c0000770:	f94007e0 	ldr	x0, [sp, #8]
    c0000774:	f9400402 	ldr	x2, [x0, #8]
    c0000778:	93407c20 	sxtw	x0, w1
    c000077c:	8b000040 	add	x0, x2, x0
    c0000780:	f9400000 	ldr	x0, [x0]
    c0000784:	14000092 	b	c00009cc <get_signed_arg+0x450>
	case LENGTH_LL:
		return (int64_t)va_arg(*args, long long);
    c0000788:	f94007e0 	ldr	x0, [sp, #8]
    c000078c:	b9401801 	ldr	w1, [x0, #24]
    c0000790:	f94007e0 	ldr	x0, [sp, #8]
    c0000794:	f9400000 	ldr	x0, [x0]
    c0000798:	7100003f 	cmp	w1, #0x0
    c000079c:	540000cb 	b.lt	c00007b4 <get_signed_arg+0x238>  // b.tstop
    c00007a0:	91003c01 	add	x1, x0, #0xf
    c00007a4:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c00007a8:	f94007e1 	ldr	x1, [sp, #8]
    c00007ac:	f9000022 	str	x2, [x1]
    c00007b0:	14000011 	b	c00007f4 <get_signed_arg+0x278>
    c00007b4:	11002023 	add	w3, w1, #0x8
    c00007b8:	f94007e2 	ldr	x2, [sp, #8]
    c00007bc:	b9001843 	str	w3, [x2, #24]
    c00007c0:	f94007e2 	ldr	x2, [sp, #8]
    c00007c4:	b9401842 	ldr	w2, [x2, #24]
    c00007c8:	7100005f 	cmp	w2, #0x0
    c00007cc:	540000cd 	b.le	c00007e4 <get_signed_arg+0x268>
    c00007d0:	91003c01 	add	x1, x0, #0xf
    c00007d4:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c00007d8:	f94007e1 	ldr	x1, [sp, #8]
    c00007dc:	f9000022 	str	x2, [x1]
    c00007e0:	14000005 	b	c00007f4 <get_signed_arg+0x278>
    c00007e4:	f94007e0 	ldr	x0, [sp, #8]
    c00007e8:	f9400402 	ldr	x2, [x0, #8]
    c00007ec:	93407c20 	sxtw	x0, w1
    c00007f0:	8b000040 	add	x0, x2, x0
    c00007f4:	f9400000 	ldr	x0, [x0]
    c00007f8:	14000075 	b	c00009cc <get_signed_arg+0x450>
	case LENGTH_Z:
		return (int64_t)(ptrdiff_t)va_arg(*args, size_t);
    c00007fc:	f94007e0 	ldr	x0, [sp, #8]
    c0000800:	b9401801 	ldr	w1, [x0, #24]
    c0000804:	f94007e0 	ldr	x0, [sp, #8]
    c0000808:	f9400000 	ldr	x0, [x0]
    c000080c:	7100003f 	cmp	w1, #0x0
    c0000810:	540000cb 	b.lt	c0000828 <get_signed_arg+0x2ac>  // b.tstop
    c0000814:	91003c01 	add	x1, x0, #0xf
    c0000818:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c000081c:	f94007e1 	ldr	x1, [sp, #8]
    c0000820:	f9000022 	str	x2, [x1]
    c0000824:	14000011 	b	c0000868 <get_signed_arg+0x2ec>
    c0000828:	11002023 	add	w3, w1, #0x8
    c000082c:	f94007e2 	ldr	x2, [sp, #8]
    c0000830:	b9001843 	str	w3, [x2, #24]
    c0000834:	f94007e2 	ldr	x2, [sp, #8]
    c0000838:	b9401842 	ldr	w2, [x2, #24]
    c000083c:	7100005f 	cmp	w2, #0x0
    c0000840:	540000cd 	b.le	c0000858 <get_signed_arg+0x2dc>
    c0000844:	91003c01 	add	x1, x0, #0xf
    c0000848:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c000084c:	f94007e1 	ldr	x1, [sp, #8]
    c0000850:	f9000022 	str	x2, [x1]
    c0000854:	14000005 	b	c0000868 <get_signed_arg+0x2ec>
    c0000858:	f94007e0 	ldr	x0, [sp, #8]
    c000085c:	f9400402 	ldr	x2, [x0, #8]
    c0000860:	93407c20 	sxtw	x0, w1
    c0000864:	8b000040 	add	x0, x2, x0
    c0000868:	f9400000 	ldr	x0, [x0]
    c000086c:	14000058 	b	c00009cc <get_signed_arg+0x450>
	case LENGTH_T:
		return (int64_t)va_arg(*args, ptrdiff_t);
    c0000870:	f94007e0 	ldr	x0, [sp, #8]
    c0000874:	b9401801 	ldr	w1, [x0, #24]
    c0000878:	f94007e0 	ldr	x0, [sp, #8]
    c000087c:	f9400000 	ldr	x0, [x0]
    c0000880:	7100003f 	cmp	w1, #0x0
    c0000884:	540000cb 	b.lt	c000089c <get_signed_arg+0x320>  // b.tstop
    c0000888:	91003c01 	add	x1, x0, #0xf
    c000088c:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c0000890:	f94007e1 	ldr	x1, [sp, #8]
    c0000894:	f9000022 	str	x2, [x1]
    c0000898:	14000011 	b	c00008dc <get_signed_arg+0x360>
    c000089c:	11002023 	add	w3, w1, #0x8
    c00008a0:	f94007e2 	ldr	x2, [sp, #8]
    c00008a4:	b9001843 	str	w3, [x2, #24]
    c00008a8:	f94007e2 	ldr	x2, [sp, #8]
    c00008ac:	b9401842 	ldr	w2, [x2, #24]
    c00008b0:	7100005f 	cmp	w2, #0x0
    c00008b4:	540000cd 	b.le	c00008cc <get_signed_arg+0x350>
    c00008b8:	91003c01 	add	x1, x0, #0xf
    c00008bc:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c00008c0:	f94007e1 	ldr	x1, [sp, #8]
    c00008c4:	f9000022 	str	x2, [x1]
    c00008c8:	14000005 	b	c00008dc <get_signed_arg+0x360>
    c00008cc:	f94007e0 	ldr	x0, [sp, #8]
    c00008d0:	f9400402 	ldr	x2, [x0, #8]
    c00008d4:	93407c20 	sxtw	x0, w1
    c00008d8:	8b000040 	add	x0, x2, x0
    c00008dc:	f9400000 	ldr	x0, [x0]
    c00008e0:	1400003b 	b	c00009cc <get_signed_arg+0x450>
	case LENGTH_J:
		return (int64_t)va_arg(*args, intmax_t);
    c00008e4:	f94007e0 	ldr	x0, [sp, #8]
    c00008e8:	b9401801 	ldr	w1, [x0, #24]
    c00008ec:	f94007e0 	ldr	x0, [sp, #8]
    c00008f0:	f9400000 	ldr	x0, [x0]
    c00008f4:	7100003f 	cmp	w1, #0x0
    c00008f8:	540000cb 	b.lt	c0000910 <get_signed_arg+0x394>  // b.tstop
    c00008fc:	91003c01 	add	x1, x0, #0xf
    c0000900:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c0000904:	f94007e1 	ldr	x1, [sp, #8]
    c0000908:	f9000022 	str	x2, [x1]
    c000090c:	14000011 	b	c0000950 <get_signed_arg+0x3d4>
    c0000910:	11002023 	add	w3, w1, #0x8
    c0000914:	f94007e2 	ldr	x2, [sp, #8]
    c0000918:	b9001843 	str	w3, [x2, #24]
    c000091c:	f94007e2 	ldr	x2, [sp, #8]
    c0000920:	b9401842 	ldr	w2, [x2, #24]
    c0000924:	7100005f 	cmp	w2, #0x0
    c0000928:	540000cd 	b.le	c0000940 <get_signed_arg+0x3c4>
    c000092c:	91003c01 	add	x1, x0, #0xf
    c0000930:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c0000934:	f94007e1 	ldr	x1, [sp, #8]
    c0000938:	f9000022 	str	x2, [x1]
    c000093c:	14000005 	b	c0000950 <get_signed_arg+0x3d4>
    c0000940:	f94007e0 	ldr	x0, [sp, #8]
    c0000944:	f9400402 	ldr	x2, [x0, #8]
    c0000948:	93407c20 	sxtw	x0, w1
    c000094c:	8b000040 	add	x0, x2, x0
    c0000950:	f9400000 	ldr	x0, [x0]
    c0000954:	1400001e 	b	c00009cc <get_signed_arg+0x450>
	default:
		return (int64_t)va_arg(*args, int);
    c0000958:	f94007e0 	ldr	x0, [sp, #8]
    c000095c:	b9401801 	ldr	w1, [x0, #24]
    c0000960:	f94007e0 	ldr	x0, [sp, #8]
    c0000964:	f9400000 	ldr	x0, [x0]
    c0000968:	7100003f 	cmp	w1, #0x0
    c000096c:	540000cb 	b.lt	c0000984 <get_signed_arg+0x408>  // b.tstop
    c0000970:	91002c01 	add	x1, x0, #0xb
    c0000974:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c0000978:	f94007e1 	ldr	x1, [sp, #8]
    c000097c:	f9000022 	str	x2, [x1]
    c0000980:	14000011 	b	c00009c4 <get_signed_arg+0x448>
    c0000984:	11002023 	add	w3, w1, #0x8
    c0000988:	f94007e2 	ldr	x2, [sp, #8]
    c000098c:	b9001843 	str	w3, [x2, #24]
    c0000990:	f94007e2 	ldr	x2, [sp, #8]
    c0000994:	b9401842 	ldr	w2, [x2, #24]
    c0000998:	7100005f 	cmp	w2, #0x0
    c000099c:	540000cd 	b.le	c00009b4 <get_signed_arg+0x438>
    c00009a0:	91002c01 	add	x1, x0, #0xb
    c00009a4:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c00009a8:	f94007e1 	ldr	x1, [sp, #8]
    c00009ac:	f9000022 	str	x2, [x1]
    c00009b0:	14000005 	b	c00009c4 <get_signed_arg+0x448>
    c00009b4:	f94007e0 	ldr	x0, [sp, #8]
    c00009b8:	f9400402 	ldr	x2, [x0, #8]
    c00009bc:	93407c20 	sxtw	x0, w1
    c00009c0:	8b000040 	add	x0, x2, x0
    c00009c4:	b9400000 	ldr	w0, [x0]
    c00009c8:	93407c00 	sxtw	x0, w0
	}
}
    c00009cc:	910043ff 	add	sp, sp, #0x10
    c00009d0:	d65f03c0 	ret

00000000c00009d4 <u64_to_str>:

static size_t u64_to_str(uint64_t value, unsigned int base, bool upper,
			 char *buf)
{
    c00009d4:	d100c3ff 	sub	sp, sp, #0x30
    c00009d8:	f9000fe0 	str	x0, [sp, #24]
    c00009dc:	b90017e1 	str	w1, [sp, #20]
    c00009e0:	39004fe2 	strb	w2, [sp, #19]
    c00009e4:	f90007e3 	str	x3, [sp, #8]
	static const char lower_digits[] = "0123456789abcdef";
	static const char upper_digits[] = "0123456789ABCDEF";
	const char *digits = upper ? upper_digits : lower_digits;
    c00009e8:	39404fe0 	ldrb	w0, [sp, #19]
    c00009ec:	12000000 	and	w0, w0, #0x1
    c00009f0:	7100001f 	cmp	w0, #0x0
    c00009f4:	54000080 	b.eq	c0000a04 <u64_to_str+0x30>  // b.none
    c00009f8:	b0000020 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c00009fc:	910d2000 	add	x0, x0, #0x348
    c0000a00:	14000003 	b	c0000a0c <u64_to_str+0x38>
    c0000a04:	b0000020 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0000a08:	910d8000 	add	x0, x0, #0x360
    c0000a0c:	f90013e0 	str	x0, [sp, #32]
	size_t len = 0U;
    c0000a10:	f90017ff 	str	xzr, [sp, #40]

	do {
		buf[len++] = digits[value % base];
    c0000a14:	b94017e1 	ldr	w1, [sp, #20]
    c0000a18:	f9400fe0 	ldr	x0, [sp, #24]
    c0000a1c:	9ac10802 	udiv	x2, x0, x1
    c0000a20:	9b017c41 	mul	x1, x2, x1
    c0000a24:	cb010000 	sub	x0, x0, x1
    c0000a28:	f94013e1 	ldr	x1, [sp, #32]
    c0000a2c:	8b000021 	add	x1, x1, x0
    c0000a30:	f94017e0 	ldr	x0, [sp, #40]
    c0000a34:	91000402 	add	x2, x0, #0x1
    c0000a38:	f90017e2 	str	x2, [sp, #40]
    c0000a3c:	f94007e2 	ldr	x2, [sp, #8]
    c0000a40:	8b000040 	add	x0, x2, x0
    c0000a44:	39400021 	ldrb	w1, [x1]
    c0000a48:	39000001 	strb	w1, [x0]
		value /= base;
    c0000a4c:	b94017e0 	ldr	w0, [sp, #20]
    c0000a50:	f9400fe1 	ldr	x1, [sp, #24]
    c0000a54:	9ac00820 	udiv	x0, x1, x0
    c0000a58:	f9000fe0 	str	x0, [sp, #24]
	} while (value != 0U);
    c0000a5c:	f9400fe0 	ldr	x0, [sp, #24]
    c0000a60:	f100001f 	cmp	x0, #0x0
    c0000a64:	54fffd81 	b.ne	c0000a14 <u64_to_str+0x40>  // b.any

	return len;
    c0000a68:	f94017e0 	ldr	x0, [sp, #40]
}
    c0000a6c:	9100c3ff 	add	sp, sp, #0x30
    c0000a70:	d65f03c0 	ret

00000000c0000a74 <print_buffer>:

static void print_buffer(struct print_ctx *ctx, const char *buf, size_t len)
{
    c0000a74:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
    c0000a78:	910003fd 	mov	x29, sp
    c0000a7c:	f90017e0 	str	x0, [sp, #40]
    c0000a80:	f90013e1 	str	x1, [sp, #32]
    c0000a84:	f9000fe2 	str	x2, [sp, #24]
	while (len-- > 0U) {
    c0000a88:	14000008 	b	c0000aa8 <print_buffer+0x34>
		print_char(ctx, *buf++);
    c0000a8c:	f94013e0 	ldr	x0, [sp, #32]
    c0000a90:	91000401 	add	x1, x0, #0x1
    c0000a94:	f90013e1 	str	x1, [sp, #32]
    c0000a98:	39400000 	ldrb	w0, [x0]
    c0000a9c:	2a0003e1 	mov	w1, w0
    c0000aa0:	f94017e0 	ldr	x0, [sp, #40]
    c0000aa4:	97fffd6b 	bl	c0000050 <print_char>
	while (len-- > 0U) {
    c0000aa8:	f9400fe0 	ldr	x0, [sp, #24]
    c0000aac:	d1000401 	sub	x1, x0, #0x1
    c0000ab0:	f9000fe1 	str	x1, [sp, #24]
    c0000ab4:	f100001f 	cmp	x0, #0x0
    c0000ab8:	54fffea1 	b.ne	c0000a8c <print_buffer+0x18>  // b.any
	}
}
    c0000abc:	d503201f 	nop
    c0000ac0:	d503201f 	nop
    c0000ac4:	a8c37bfd 	ldp	x29, x30, [sp], #48
    c0000ac8:	d65f03c0 	ret

00000000c0000acc <format_integer>:

static void format_integer(struct print_ctx *ctx, struct format_spec *spec,
			   uint64_t value, bool negative, unsigned int base)
{
    c0000acc:	a9b77bfd 	stp	x29, x30, [sp, #-144]!
    c0000ad0:	910003fd 	mov	x29, sp
    c0000ad4:	f90017e0 	str	x0, [sp, #40]
    c0000ad8:	f90013e1 	str	x1, [sp, #32]
    c0000adc:	f9000fe2 	str	x2, [sp, #24]
    c0000ae0:	39005fe3 	strb	w3, [sp, #23]
    c0000ae4:	b90013e4 	str	w4, [sp, #16]
	char digits[32];
	char prefix[3];
	size_t digits_len;
	size_t prefix_len = 0U;
    c0000ae8:	f90043ff 	str	xzr, [sp, #128]
	size_t zero_pad = 0U;
    c0000aec:	f9003fff 	str	xzr, [sp, #120]
	size_t total_len;
	int pad_len;
	bool precision_specified = spec->precision >= 0;
    c0000af0:	f94013e0 	ldr	x0, [sp, #32]
    c0000af4:	b9400800 	ldr	w0, [x0, #8]
    c0000af8:	2a2003e0 	mvn	w0, w0
    c0000afc:	531f7c00 	lsr	w0, w0, #31
    c0000b00:	3901dfe0 	strb	w0, [sp, #119]
	bool zero_value_suppressed = precision_specified &&
		(spec->precision == 0) && (value == 0U);
    c0000b04:	3941dfe0 	ldrb	w0, [sp, #119]
    c0000b08:	12000000 	and	w0, w0, #0x1
    c0000b0c:	7100001f 	cmp	w0, #0x0
    c0000b10:	54000140 	b.eq	c0000b38 <format_integer+0x6c>  // b.none
    c0000b14:	f94013e0 	ldr	x0, [sp, #32]
    c0000b18:	b9400800 	ldr	w0, [x0, #8]
	bool zero_value_suppressed = precision_specified &&
    c0000b1c:	7100001f 	cmp	w0, #0x0
    c0000b20:	540000c1 	b.ne	c0000b38 <format_integer+0x6c>  // b.any
		(spec->precision == 0) && (value == 0U);
    c0000b24:	f9400fe0 	ldr	x0, [sp, #24]
    c0000b28:	f100001f 	cmp	x0, #0x0
    c0000b2c:	54000061 	b.ne	c0000b38 <format_integer+0x6c>  // b.any
    c0000b30:	52800020 	mov	w0, #0x1                   	// #1
    c0000b34:	14000002 	b	c0000b3c <format_integer+0x70>
    c0000b38:	52800000 	mov	w0, #0x0                   	// #0
	bool zero_value_suppressed = precision_specified &&
    c0000b3c:	3901dbe0 	strb	w0, [sp, #118]
    c0000b40:	3941dbe0 	ldrb	w0, [sp, #118]
    c0000b44:	12000000 	and	w0, w0, #0x1
    c0000b48:	3901dbe0 	strb	w0, [sp, #118]

	if (negative) {
    c0000b4c:	39405fe0 	ldrb	w0, [sp, #23]
    c0000b50:	12000000 	and	w0, w0, #0x1
    c0000b54:	7100001f 	cmp	w0, #0x0
    c0000b58:	54000100 	b.eq	c0000b78 <format_integer+0xac>  // b.none
		prefix[prefix_len++] = '-';
    c0000b5c:	f94043e0 	ldr	x0, [sp, #128]
    c0000b60:	91000401 	add	x1, x0, #0x1
    c0000b64:	f90043e1 	str	x1, [sp, #128]
    c0000b68:	9100e3e1 	add	x1, sp, #0x38
    c0000b6c:	528005a2 	mov	w2, #0x2d                  	// #45
    c0000b70:	38206822 	strb	w2, [x1, x0]
    c0000b74:	14000018 	b	c0000bd4 <format_integer+0x108>
	} else if ((spec->flags & FLAG_PLUS) != 0U) {
    c0000b78:	f94013e0 	ldr	x0, [sp, #32]
    c0000b7c:	b9400000 	ldr	w0, [x0]
    c0000b80:	121f0000 	and	w0, w0, #0x2
    c0000b84:	7100001f 	cmp	w0, #0x0
    c0000b88:	54000100 	b.eq	c0000ba8 <format_integer+0xdc>  // b.none
		prefix[prefix_len++] = '+';
    c0000b8c:	f94043e0 	ldr	x0, [sp, #128]
    c0000b90:	91000401 	add	x1, x0, #0x1
    c0000b94:	f90043e1 	str	x1, [sp, #128]
    c0000b98:	9100e3e1 	add	x1, sp, #0x38
    c0000b9c:	52800562 	mov	w2, #0x2b                  	// #43
    c0000ba0:	38206822 	strb	w2, [x1, x0]
    c0000ba4:	1400000c 	b	c0000bd4 <format_integer+0x108>
	} else if ((spec->flags & FLAG_SPACE) != 0U) {
    c0000ba8:	f94013e0 	ldr	x0, [sp, #32]
    c0000bac:	b9400000 	ldr	w0, [x0]
    c0000bb0:	121e0000 	and	w0, w0, #0x4
    c0000bb4:	7100001f 	cmp	w0, #0x0
    c0000bb8:	540000e0 	b.eq	c0000bd4 <format_integer+0x108>  // b.none
		prefix[prefix_len++] = ' ';
    c0000bbc:	f94043e0 	ldr	x0, [sp, #128]
    c0000bc0:	91000401 	add	x1, x0, #0x1
    c0000bc4:	f90043e1 	str	x1, [sp, #128]
    c0000bc8:	9100e3e1 	add	x1, sp, #0x38
    c0000bcc:	52800402 	mov	w2, #0x20                  	// #32
    c0000bd0:	38206822 	strb	w2, [x1, x0]
	}

	if ((spec->flags & FLAG_ALT) != 0U) {
    c0000bd4:	f94013e0 	ldr	x0, [sp, #32]
    c0000bd8:	b9400000 	ldr	w0, [x0]
    c0000bdc:	121d0000 	and	w0, w0, #0x8
    c0000be0:	7100001f 	cmp	w0, #0x0
    c0000be4:	54000620 	b.eq	c0000ca8 <format_integer+0x1dc>  // b.none
		if ((base == 8U) && ((value != 0U) || !precision_specified || (spec->precision == 0))) {
    c0000be8:	b94013e0 	ldr	w0, [sp, #16]
    c0000bec:	7100201f 	cmp	w0, #0x8
    c0000bf0:	540002a1 	b.ne	c0000c44 <format_integer+0x178>  // b.any
    c0000bf4:	f9400fe0 	ldr	x0, [sp, #24]
    c0000bf8:	f100001f 	cmp	x0, #0x0
    c0000bfc:	54000161 	b.ne	c0000c28 <format_integer+0x15c>  // b.any
    c0000c00:	3941dfe0 	ldrb	w0, [sp, #119]
    c0000c04:	52000000 	eor	w0, w0, #0x1
    c0000c08:	12001c00 	and	w0, w0, #0xff
    c0000c0c:	12000000 	and	w0, w0, #0x1
    c0000c10:	7100001f 	cmp	w0, #0x0
    c0000c14:	540000a1 	b.ne	c0000c28 <format_integer+0x15c>  // b.any
    c0000c18:	f94013e0 	ldr	x0, [sp, #32]
    c0000c1c:	b9400800 	ldr	w0, [x0, #8]
    c0000c20:	7100001f 	cmp	w0, #0x0
    c0000c24:	54000101 	b.ne	c0000c44 <format_integer+0x178>  // b.any
			prefix[prefix_len++] = '0';
    c0000c28:	f94043e0 	ldr	x0, [sp, #128]
    c0000c2c:	91000401 	add	x1, x0, #0x1
    c0000c30:	f90043e1 	str	x1, [sp, #128]
    c0000c34:	9100e3e1 	add	x1, sp, #0x38
    c0000c38:	52800602 	mov	w2, #0x30                  	// #48
    c0000c3c:	38206822 	strb	w2, [x1, x0]
    c0000c40:	1400001a 	b	c0000ca8 <format_integer+0x1dc>
		} else if ((base == 16U) && (value != 0U)) {
    c0000c44:	b94013e0 	ldr	w0, [sp, #16]
    c0000c48:	7100401f 	cmp	w0, #0x10
    c0000c4c:	540002e1 	b.ne	c0000ca8 <format_integer+0x1dc>  // b.any
    c0000c50:	f9400fe0 	ldr	x0, [sp, #24]
    c0000c54:	f100001f 	cmp	x0, #0x0
    c0000c58:	54000280 	b.eq	c0000ca8 <format_integer+0x1dc>  // b.none
			prefix[prefix_len++] = '0';
    c0000c5c:	f94043e0 	ldr	x0, [sp, #128]
    c0000c60:	91000401 	add	x1, x0, #0x1
    c0000c64:	f90043e1 	str	x1, [sp, #128]
    c0000c68:	9100e3e1 	add	x1, sp, #0x38
    c0000c6c:	52800602 	mov	w2, #0x30                  	// #48
    c0000c70:	38206822 	strb	w2, [x1, x0]
			prefix[prefix_len++] = ((spec->flags & FLAG_UPPER) != 0U) ? 'X' : 'x';
    c0000c74:	f94013e0 	ldr	x0, [sp, #32]
    c0000c78:	b9400000 	ldr	w0, [x0]
    c0000c7c:	121b0000 	and	w0, w0, #0x20
    c0000c80:	7100001f 	cmp	w0, #0x0
    c0000c84:	54000060 	b.eq	c0000c90 <format_integer+0x1c4>  // b.none
    c0000c88:	52800b01 	mov	w1, #0x58                  	// #88
    c0000c8c:	14000002 	b	c0000c94 <format_integer+0x1c8>
    c0000c90:	52800f01 	mov	w1, #0x78                  	// #120
    c0000c94:	f94043e0 	ldr	x0, [sp, #128]
    c0000c98:	91000402 	add	x2, x0, #0x1
    c0000c9c:	f90043e2 	str	x2, [sp, #128]
    c0000ca0:	9100e3e2 	add	x2, sp, #0x38
    c0000ca4:	38206841 	strb	w1, [x2, x0]
		}
	}

	if (zero_value_suppressed) {
    c0000ca8:	3941dbe0 	ldrb	w0, [sp, #118]
    c0000cac:	12000000 	and	w0, w0, #0x1
    c0000cb0:	7100001f 	cmp	w0, #0x0
    c0000cb4:	54000060 	b.eq	c0000cc0 <format_integer+0x1f4>  // b.none
		digits_len = 0U;
    c0000cb8:	f90047ff 	str	xzr, [sp, #136]
    c0000cbc:	1400000e 	b	c0000cf4 <format_integer+0x228>
	} else {
		digits_len = u64_to_str(value, base, (spec->flags & FLAG_UPPER) != 0U,
    c0000cc0:	f94013e0 	ldr	x0, [sp, #32]
    c0000cc4:	b9400000 	ldr	w0, [x0]
    c0000cc8:	121b0000 	and	w0, w0, #0x20
    c0000ccc:	7100001f 	cmp	w0, #0x0
    c0000cd0:	1a9f07e0 	cset	w0, ne	// ne = any
    c0000cd4:	12001c01 	and	w1, w0, #0xff
    c0000cd8:	910103e0 	add	x0, sp, #0x40
    c0000cdc:	aa0003e3 	mov	x3, x0
    c0000ce0:	2a0103e2 	mov	w2, w1
    c0000ce4:	b94013e1 	ldr	w1, [sp, #16]
    c0000ce8:	f9400fe0 	ldr	x0, [sp, #24]
    c0000cec:	97ffff3a 	bl	c00009d4 <u64_to_str>
    c0000cf0:	f90047e0 	str	x0, [sp, #136]
				      digits);
	}

	if (precision_specified && ((size_t)spec->precision > digits_len)) {
    c0000cf4:	3941dfe0 	ldrb	w0, [sp, #119]
    c0000cf8:	12000000 	and	w0, w0, #0x1
    c0000cfc:	7100001f 	cmp	w0, #0x0
    c0000d00:	540001c0 	b.eq	c0000d38 <format_integer+0x26c>  // b.none
    c0000d04:	f94013e0 	ldr	x0, [sp, #32]
    c0000d08:	b9400800 	ldr	w0, [x0, #8]
    c0000d0c:	93407c00 	sxtw	x0, w0
    c0000d10:	f94047e1 	ldr	x1, [sp, #136]
    c0000d14:	eb00003f 	cmp	x1, x0
    c0000d18:	54000102 	b.cs	c0000d38 <format_integer+0x26c>  // b.hs, b.nlast
		zero_pad = (size_t)spec->precision - digits_len;
    c0000d1c:	f94013e0 	ldr	x0, [sp, #32]
    c0000d20:	b9400800 	ldr	w0, [x0, #8]
    c0000d24:	93407c01 	sxtw	x1, w0
    c0000d28:	f94047e0 	ldr	x0, [sp, #136]
    c0000d2c:	cb000020 	sub	x0, x1, x0
    c0000d30:	f9003fe0 	str	x0, [sp, #120]
    c0000d34:	14000021 	b	c0000db8 <format_integer+0x2ec>
	} else if (((spec->flags & FLAG_ZERO) != 0U) &&
    c0000d38:	f94013e0 	ldr	x0, [sp, #32]
    c0000d3c:	b9400000 	ldr	w0, [x0]
    c0000d40:	121c0000 	and	w0, w0, #0x10
    c0000d44:	7100001f 	cmp	w0, #0x0
    c0000d48:	54000380 	b.eq	c0000db8 <format_integer+0x2ec>  // b.none
		   ((spec->flags & FLAG_LEFT) == 0U) &&
    c0000d4c:	f94013e0 	ldr	x0, [sp, #32]
    c0000d50:	b9400000 	ldr	w0, [x0]
    c0000d54:	12000000 	and	w0, w0, #0x1
	} else if (((spec->flags & FLAG_ZERO) != 0U) &&
    c0000d58:	7100001f 	cmp	w0, #0x0
    c0000d5c:	540002e1 	b.ne	c0000db8 <format_integer+0x2ec>  // b.any
		   !precision_specified &&
    c0000d60:	3941dfe0 	ldrb	w0, [sp, #119]
    c0000d64:	52000000 	eor	w0, w0, #0x1
    c0000d68:	12001c00 	and	w0, w0, #0xff
		   ((spec->flags & FLAG_LEFT) == 0U) &&
    c0000d6c:	12000000 	and	w0, w0, #0x1
    c0000d70:	7100001f 	cmp	w0, #0x0
    c0000d74:	54000220 	b.eq	c0000db8 <format_integer+0x2ec>  // b.none
		   (spec->width > (int)(prefix_len + digits_len))) {
    c0000d78:	f94013e0 	ldr	x0, [sp, #32]
    c0000d7c:	b9400400 	ldr	w0, [x0, #4]
    c0000d80:	f94043e1 	ldr	x1, [sp, #128]
    c0000d84:	2a0103e2 	mov	w2, w1
    c0000d88:	f94047e1 	ldr	x1, [sp, #136]
    c0000d8c:	0b010041 	add	w1, w2, w1
		   !precision_specified &&
    c0000d90:	6b01001f 	cmp	w0, w1
    c0000d94:	5400012d 	b.le	c0000db8 <format_integer+0x2ec>
		zero_pad = (size_t)spec->width - prefix_len - digits_len;
    c0000d98:	f94013e0 	ldr	x0, [sp, #32]
    c0000d9c:	b9400400 	ldr	w0, [x0, #4]
    c0000da0:	93407c01 	sxtw	x1, w0
    c0000da4:	f94043e0 	ldr	x0, [sp, #128]
    c0000da8:	cb000021 	sub	x1, x1, x0
    c0000dac:	f94047e0 	ldr	x0, [sp, #136]
    c0000db0:	cb000020 	sub	x0, x1, x0
    c0000db4:	f9003fe0 	str	x0, [sp, #120]
	}

	total_len = prefix_len + zero_pad + digits_len;
    c0000db8:	f94043e1 	ldr	x1, [sp, #128]
    c0000dbc:	f9403fe0 	ldr	x0, [sp, #120]
    c0000dc0:	8b000020 	add	x0, x1, x0
    c0000dc4:	f94047e1 	ldr	x1, [sp, #136]
    c0000dc8:	8b000020 	add	x0, x1, x0
    c0000dcc:	f90037e0 	str	x0, [sp, #104]
	pad_len = (spec->width > (int)total_len) ? spec->width - (int)total_len : 0;
    c0000dd0:	f94013e0 	ldr	x0, [sp, #32]
    c0000dd4:	b9400400 	ldr	w0, [x0, #4]
    c0000dd8:	f94037e1 	ldr	x1, [sp, #104]
    c0000ddc:	6b01001f 	cmp	w0, w1
    c0000de0:	540000cd 	b.le	c0000df8 <format_integer+0x32c>
    c0000de4:	f94013e0 	ldr	x0, [sp, #32]
    c0000de8:	b9400400 	ldr	w0, [x0, #4]
    c0000dec:	f94037e1 	ldr	x1, [sp, #104]
    c0000df0:	4b010000 	sub	w0, w0, w1
    c0000df4:	14000002 	b	c0000dfc <format_integer+0x330>
    c0000df8:	52800000 	mov	w0, #0x0                   	// #0
    c0000dfc:	b90067e0 	str	w0, [sp, #100]

	if ((spec->flags & FLAG_LEFT) == 0U) {
    c0000e00:	f94013e0 	ldr	x0, [sp, #32]
    c0000e04:	b9400000 	ldr	w0, [x0]
    c0000e08:	12000000 	and	w0, w0, #0x1
    c0000e0c:	7100001f 	cmp	w0, #0x0
    c0000e10:	540000a1 	b.ne	c0000e24 <format_integer+0x358>  // b.any
		print_repeat(ctx, ' ', pad_len);
    c0000e14:	b94067e2 	ldr	w2, [sp, #100]
    c0000e18:	52800401 	mov	w1, #0x20                  	// #32
    c0000e1c:	f94017e0 	ldr	x0, [sp, #40]
    c0000e20:	97fffc9f 	bl	c000009c <print_repeat>
	}

	print_buffer(ctx, prefix, prefix_len);
    c0000e24:	9100e3e0 	add	x0, sp, #0x38
    c0000e28:	f94043e2 	ldr	x2, [sp, #128]
    c0000e2c:	aa0003e1 	mov	x1, x0
    c0000e30:	f94017e0 	ldr	x0, [sp, #40]
    c0000e34:	97ffff10 	bl	c0000a74 <print_buffer>
	print_repeat(ctx, '0', (int)zero_pad);
    c0000e38:	f9403fe0 	ldr	x0, [sp, #120]
    c0000e3c:	2a0003e2 	mov	w2, w0
    c0000e40:	52800601 	mov	w1, #0x30                  	// #48
    c0000e44:	f94017e0 	ldr	x0, [sp, #40]
    c0000e48:	97fffc95 	bl	c000009c <print_repeat>
	while (digits_len-- > 0U) {
    c0000e4c:	14000007 	b	c0000e68 <format_integer+0x39c>
		print_char(ctx, digits[digits_len]);
    c0000e50:	f94047e0 	ldr	x0, [sp, #136]
    c0000e54:	910103e1 	add	x1, sp, #0x40
    c0000e58:	38606820 	ldrb	w0, [x1, x0]
    c0000e5c:	2a0003e1 	mov	w1, w0
    c0000e60:	f94017e0 	ldr	x0, [sp, #40]
    c0000e64:	97fffc7b 	bl	c0000050 <print_char>
	while (digits_len-- > 0U) {
    c0000e68:	f94047e0 	ldr	x0, [sp, #136]
    c0000e6c:	d1000401 	sub	x1, x0, #0x1
    c0000e70:	f90047e1 	str	x1, [sp, #136]
    c0000e74:	f100001f 	cmp	x0, #0x0
    c0000e78:	54fffec1 	b.ne	c0000e50 <format_integer+0x384>  // b.any
	}

	if ((spec->flags & FLAG_LEFT) != 0U) {
    c0000e7c:	f94013e0 	ldr	x0, [sp, #32]
    c0000e80:	b9400000 	ldr	w0, [x0]
    c0000e84:	12000000 	and	w0, w0, #0x1
    c0000e88:	7100001f 	cmp	w0, #0x0
    c0000e8c:	540000a0 	b.eq	c0000ea0 <format_integer+0x3d4>  // b.none
		print_repeat(ctx, ' ', pad_len);
    c0000e90:	b94067e2 	ldr	w2, [sp, #100]
    c0000e94:	52800401 	mov	w1, #0x20                  	// #32
    c0000e98:	f94017e0 	ldr	x0, [sp, #40]
    c0000e9c:	97fffc80 	bl	c000009c <print_repeat>
	}
}
    c0000ea0:	d503201f 	nop
    c0000ea4:	a8c97bfd 	ldp	x29, x30, [sp], #144
    c0000ea8:	d65f03c0 	ret

00000000c0000eac <format_string>:

static void format_string(struct print_ctx *ctx, struct format_spec *spec,
			  const char *str)
{
    c0000eac:	a9bc7bfd 	stp	x29, x30, [sp, #-64]!
    c0000eb0:	910003fd 	mov	x29, sp
    c0000eb4:	f90017e0 	str	x0, [sp, #40]
    c0000eb8:	f90013e1 	str	x1, [sp, #32]
    c0000ebc:	f9000fe2 	str	x2, [sp, #24]
	size_t len;
	int pad_len;

	if (str == NULL) {
    c0000ec0:	f9400fe0 	ldr	x0, [sp, #24]
    c0000ec4:	f100001f 	cmp	x0, #0x0
    c0000ec8:	54000081 	b.ne	c0000ed8 <format_string+0x2c>  // b.any
		str = "(null)";
    c0000ecc:	b0000020 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0000ed0:	910d0000 	add	x0, x0, #0x340
    c0000ed4:	f9000fe0 	str	x0, [sp, #24]
	}

	len = str_length(str);
    c0000ed8:	f9400fe0 	ldr	x0, [sp, #24]
    c0000edc:	97fffc82 	bl	c00000e4 <str_length>
    c0000ee0:	f9001fe0 	str	x0, [sp, #56]
	if ((spec->precision >= 0) && ((size_t)spec->precision < len)) {
    c0000ee4:	f94013e0 	ldr	x0, [sp, #32]
    c0000ee8:	b9400800 	ldr	w0, [x0, #8]
    c0000eec:	7100001f 	cmp	w0, #0x0
    c0000ef0:	5400016b 	b.lt	c0000f1c <format_string+0x70>  // b.tstop
    c0000ef4:	f94013e0 	ldr	x0, [sp, #32]
    c0000ef8:	b9400800 	ldr	w0, [x0, #8]
    c0000efc:	93407c00 	sxtw	x0, w0
    c0000f00:	f9401fe1 	ldr	x1, [sp, #56]
    c0000f04:	eb00003f 	cmp	x1, x0
    c0000f08:	540000a9 	b.ls	c0000f1c <format_string+0x70>  // b.plast
		len = (size_t)spec->precision;
    c0000f0c:	f94013e0 	ldr	x0, [sp, #32]
    c0000f10:	b9400800 	ldr	w0, [x0, #8]
    c0000f14:	93407c00 	sxtw	x0, w0
    c0000f18:	f9001fe0 	str	x0, [sp, #56]
	}

	pad_len = (spec->width > (int)len) ? spec->width - (int)len : 0;
    c0000f1c:	f94013e0 	ldr	x0, [sp, #32]
    c0000f20:	b9400400 	ldr	w0, [x0, #4]
    c0000f24:	f9401fe1 	ldr	x1, [sp, #56]
    c0000f28:	6b01001f 	cmp	w0, w1
    c0000f2c:	540000cd 	b.le	c0000f44 <format_string+0x98>
    c0000f30:	f94013e0 	ldr	x0, [sp, #32]
    c0000f34:	b9400400 	ldr	w0, [x0, #4]
    c0000f38:	f9401fe1 	ldr	x1, [sp, #56]
    c0000f3c:	4b010000 	sub	w0, w0, w1
    c0000f40:	14000002 	b	c0000f48 <format_string+0x9c>
    c0000f44:	52800000 	mov	w0, #0x0                   	// #0
    c0000f48:	b90037e0 	str	w0, [sp, #52]
	if ((spec->flags & FLAG_LEFT) == 0U) {
    c0000f4c:	f94013e0 	ldr	x0, [sp, #32]
    c0000f50:	b9400000 	ldr	w0, [x0]
    c0000f54:	12000000 	and	w0, w0, #0x1
    c0000f58:	7100001f 	cmp	w0, #0x0
    c0000f5c:	540000a1 	b.ne	c0000f70 <format_string+0xc4>  // b.any
		print_repeat(ctx, ' ', pad_len);
    c0000f60:	b94037e2 	ldr	w2, [sp, #52]
    c0000f64:	52800401 	mov	w1, #0x20                  	// #32
    c0000f68:	f94017e0 	ldr	x0, [sp, #40]
    c0000f6c:	97fffc4c 	bl	c000009c <print_repeat>
	}
	print_buffer(ctx, str, len);
    c0000f70:	f9401fe2 	ldr	x2, [sp, #56]
    c0000f74:	f9400fe1 	ldr	x1, [sp, #24]
    c0000f78:	f94017e0 	ldr	x0, [sp, #40]
    c0000f7c:	97fffebe 	bl	c0000a74 <print_buffer>
	if ((spec->flags & FLAG_LEFT) != 0U) {
    c0000f80:	f94013e0 	ldr	x0, [sp, #32]
    c0000f84:	b9400000 	ldr	w0, [x0]
    c0000f88:	12000000 	and	w0, w0, #0x1
    c0000f8c:	7100001f 	cmp	w0, #0x0
    c0000f90:	540000a0 	b.eq	c0000fa4 <format_string+0xf8>  // b.none
		print_repeat(ctx, ' ', pad_len);
    c0000f94:	b94037e2 	ldr	w2, [sp, #52]
    c0000f98:	52800401 	mov	w1, #0x20                  	// #32
    c0000f9c:	f94017e0 	ldr	x0, [sp, #40]
    c0000fa0:	97fffc3f 	bl	c000009c <print_repeat>
	}
}
    c0000fa4:	d503201f 	nop
    c0000fa8:	a8c47bfd 	ldp	x29, x30, [sp], #64
    c0000fac:	d65f03c0 	ret

00000000c0000fb0 <format_char>:

static void format_char(struct print_ctx *ctx, struct format_spec *spec, char ch)
{
    c0000fb0:	a9bc7bfd 	stp	x29, x30, [sp, #-64]!
    c0000fb4:	910003fd 	mov	x29, sp
    c0000fb8:	f90017e0 	str	x0, [sp, #40]
    c0000fbc:	f90013e1 	str	x1, [sp, #32]
    c0000fc0:	39007fe2 	strb	w2, [sp, #31]
	int pad_len = (spec->width > 1) ? spec->width - 1 : 0;
    c0000fc4:	f94013e0 	ldr	x0, [sp, #32]
    c0000fc8:	b9400400 	ldr	w0, [x0, #4]
    c0000fcc:	52800021 	mov	w1, #0x1                   	// #1
    c0000fd0:	7100001f 	cmp	w0, #0x0
    c0000fd4:	1a81c000 	csel	w0, w0, w1, gt
    c0000fd8:	51000400 	sub	w0, w0, #0x1
    c0000fdc:	b9003fe0 	str	w0, [sp, #60]

	if ((spec->flags & FLAG_LEFT) == 0U) {
    c0000fe0:	f94013e0 	ldr	x0, [sp, #32]
    c0000fe4:	b9400000 	ldr	w0, [x0]
    c0000fe8:	12000000 	and	w0, w0, #0x1
    c0000fec:	7100001f 	cmp	w0, #0x0
    c0000ff0:	540000a1 	b.ne	c0001004 <format_char+0x54>  // b.any
		print_repeat(ctx, ' ', pad_len);
    c0000ff4:	b9403fe2 	ldr	w2, [sp, #60]
    c0000ff8:	52800401 	mov	w1, #0x20                  	// #32
    c0000ffc:	f94017e0 	ldr	x0, [sp, #40]
    c0001000:	97fffc27 	bl	c000009c <print_repeat>
	}
	print_char(ctx, ch);
    c0001004:	39407fe1 	ldrb	w1, [sp, #31]
    c0001008:	f94017e0 	ldr	x0, [sp, #40]
    c000100c:	97fffc11 	bl	c0000050 <print_char>
	if ((spec->flags & FLAG_LEFT) != 0U) {
    c0001010:	f94013e0 	ldr	x0, [sp, #32]
    c0001014:	b9400000 	ldr	w0, [x0]
    c0001018:	12000000 	and	w0, w0, #0x1
    c000101c:	7100001f 	cmp	w0, #0x0
    c0001020:	540000a0 	b.eq	c0001034 <format_char+0x84>  // b.none
		print_repeat(ctx, ' ', pad_len);
    c0001024:	b9403fe2 	ldr	w2, [sp, #60]
    c0001028:	52800401 	mov	w1, #0x20                  	// #32
    c000102c:	f94017e0 	ldr	x0, [sp, #40]
    c0001030:	97fffc1b 	bl	c000009c <print_repeat>
	}
}
    c0001034:	d503201f 	nop
    c0001038:	a8c47bfd 	ldp	x29, x30, [sp], #64
    c000103c:	d65f03c0 	ret

00000000c0001040 <parse_number>:

static bool parse_number(const char **fmt, int *value)
{
    c0001040:	d10083ff 	sub	sp, sp, #0x20
    c0001044:	f90007e0 	str	x0, [sp, #8]
    c0001048:	f90003e1 	str	x1, [sp]
	bool found = false;
    c000104c:	39007fff 	strb	wzr, [sp, #31]
	int result = 0;
    c0001050:	b9001bff 	str	wzr, [sp, #24]

	while ((**fmt >= '0') && (**fmt <= '9')) {
    c0001054:	14000014 	b	c00010a4 <parse_number+0x64>
		found = true;
    c0001058:	52800020 	mov	w0, #0x1                   	// #1
    c000105c:	39007fe0 	strb	w0, [sp, #31]
		result = result * 10 + (**fmt - '0');
    c0001060:	b9401be1 	ldr	w1, [sp, #24]
    c0001064:	2a0103e0 	mov	w0, w1
    c0001068:	531e7400 	lsl	w0, w0, #2
    c000106c:	0b010000 	add	w0, w0, w1
    c0001070:	531f7800 	lsl	w0, w0, #1
    c0001074:	2a0003e1 	mov	w1, w0
    c0001078:	f94007e0 	ldr	x0, [sp, #8]
    c000107c:	f9400000 	ldr	x0, [x0]
    c0001080:	39400000 	ldrb	w0, [x0]
    c0001084:	5100c000 	sub	w0, w0, #0x30
    c0001088:	0b000020 	add	w0, w1, w0
    c000108c:	b9001be0 	str	w0, [sp, #24]
		(*fmt)++;
    c0001090:	f94007e0 	ldr	x0, [sp, #8]
    c0001094:	f9400000 	ldr	x0, [x0]
    c0001098:	91000401 	add	x1, x0, #0x1
    c000109c:	f94007e0 	ldr	x0, [sp, #8]
    c00010a0:	f9000001 	str	x1, [x0]
	while ((**fmt >= '0') && (**fmt <= '9')) {
    c00010a4:	f94007e0 	ldr	x0, [sp, #8]
    c00010a8:	f9400000 	ldr	x0, [x0]
    c00010ac:	39400000 	ldrb	w0, [x0]
    c00010b0:	7100bc1f 	cmp	w0, #0x2f
    c00010b4:	540000c9 	b.ls	c00010cc <parse_number+0x8c>  // b.plast
    c00010b8:	f94007e0 	ldr	x0, [sp, #8]
    c00010bc:	f9400000 	ldr	x0, [x0]
    c00010c0:	39400000 	ldrb	w0, [x0]
    c00010c4:	7100e41f 	cmp	w0, #0x39
    c00010c8:	54fffc89 	b.ls	c0001058 <parse_number+0x18>  // b.plast
	}

	*value = result;
    c00010cc:	f94003e0 	ldr	x0, [sp]
    c00010d0:	b9401be1 	ldr	w1, [sp, #24]
    c00010d4:	b9000001 	str	w1, [x0]
	return found;
    c00010d8:	39407fe0 	ldrb	w0, [sp, #31]
}
    c00010dc:	910083ff 	add	sp, sp, #0x20
    c00010e0:	d65f03c0 	ret

00000000c00010e4 <parse_format>:

static void parse_format(const char **fmt, struct format_spec *spec, va_list *args)
{
    c00010e4:	a9bc7bfd 	stp	x29, x30, [sp, #-64]!
    c00010e8:	910003fd 	mov	x29, sp
    c00010ec:	f90017e0 	str	x0, [sp, #40]
    c00010f0:	f90013e1 	str	x1, [sp, #32]
    c00010f4:	f9000fe2 	str	x2, [sp, #24]
	const char *p = *fmt;
    c00010f8:	f94017e0 	ldr	x0, [sp, #40]
    c00010fc:	f9400000 	ldr	x0, [x0]
    c0001100:	f9001fe0 	str	x0, [sp, #56]
	int value;

	spec->flags = 0U;
    c0001104:	f94013e0 	ldr	x0, [sp, #32]
    c0001108:	b900001f 	str	wzr, [x0]
	spec->width = 0;
    c000110c:	f94013e0 	ldr	x0, [sp, #32]
    c0001110:	b900041f 	str	wzr, [x0, #4]
	spec->precision = -1;
    c0001114:	f94013e0 	ldr	x0, [sp, #32]
    c0001118:	12800001 	mov	w1, #0xffffffff            	// #-1
    c000111c:	b9000801 	str	w1, [x0, #8]
	spec->length = LENGTH_DEFAULT;
    c0001120:	f94013e0 	ldr	x0, [sp, #32]
    c0001124:	b9000c1f 	str	wzr, [x0, #12]
	spec->conv = '\0';
    c0001128:	f94013e0 	ldr	x0, [sp, #32]
    c000112c:	3900401f 	strb	wzr, [x0, #16]

	for (;;) {
		switch (*p) {
    c0001130:	f9401fe0 	ldr	x0, [sp, #56]
    c0001134:	39400000 	ldrb	w0, [x0]
    c0001138:	7100c01f 	cmp	w0, #0x30
    c000113c:	54000680 	b.eq	c000120c <parse_format+0x128>  // b.none
    c0001140:	7100c01f 	cmp	w0, #0x30
    c0001144:	5400076c 	b.gt	c0001230 <parse_format+0x14c>
    c0001148:	7100b41f 	cmp	w0, #0x2d
    c000114c:	54000180 	b.eq	c000117c <parse_format+0x98>  // b.none
    c0001150:	7100b41f 	cmp	w0, #0x2d
    c0001154:	540006ec 	b.gt	c0001230 <parse_format+0x14c>
    c0001158:	7100ac1f 	cmp	w0, #0x2b
    c000115c:	54000220 	b.eq	c00011a0 <parse_format+0xbc>  // b.none
    c0001160:	7100ac1f 	cmp	w0, #0x2b
    c0001164:	5400066c 	b.gt	c0001230 <parse_format+0x14c>
    c0001168:	7100801f 	cmp	w0, #0x20
    c000116c:	540002c0 	b.eq	c00011c4 <parse_format+0xe0>  // b.none
    c0001170:	71008c1f 	cmp	w0, #0x23
    c0001174:	540003a0 	b.eq	c00011e8 <parse_format+0x104>  // b.none
		case '-': spec->flags |= FLAG_LEFT; p++; continue;
		case '+': spec->flags |= FLAG_PLUS; p++; continue;
		case ' ': spec->flags |= FLAG_SPACE; p++; continue;
		case '#': spec->flags |= FLAG_ALT; p++; continue;
		case '0': spec->flags |= FLAG_ZERO; p++; continue;
		default: break;
    c0001178:	1400002e 	b	c0001230 <parse_format+0x14c>
		case '-': spec->flags |= FLAG_LEFT; p++; continue;
    c000117c:	f94013e0 	ldr	x0, [sp, #32]
    c0001180:	b9400000 	ldr	w0, [x0]
    c0001184:	32000001 	orr	w1, w0, #0x1
    c0001188:	f94013e0 	ldr	x0, [sp, #32]
    c000118c:	b9000001 	str	w1, [x0]
    c0001190:	f9401fe0 	ldr	x0, [sp, #56]
    c0001194:	91000400 	add	x0, x0, #0x1
    c0001198:	f9001fe0 	str	x0, [sp, #56]
    c000119c:	1400002c 	b	c000124c <parse_format+0x168>
		case '+': spec->flags |= FLAG_PLUS; p++; continue;
    c00011a0:	f94013e0 	ldr	x0, [sp, #32]
    c00011a4:	b9400000 	ldr	w0, [x0]
    c00011a8:	321f0001 	orr	w1, w0, #0x2
    c00011ac:	f94013e0 	ldr	x0, [sp, #32]
    c00011b0:	b9000001 	str	w1, [x0]
    c00011b4:	f9401fe0 	ldr	x0, [sp, #56]
    c00011b8:	91000400 	add	x0, x0, #0x1
    c00011bc:	f9001fe0 	str	x0, [sp, #56]
    c00011c0:	14000023 	b	c000124c <parse_format+0x168>
		case ' ': spec->flags |= FLAG_SPACE; p++; continue;
    c00011c4:	f94013e0 	ldr	x0, [sp, #32]
    c00011c8:	b9400000 	ldr	w0, [x0]
    c00011cc:	321e0001 	orr	w1, w0, #0x4
    c00011d0:	f94013e0 	ldr	x0, [sp, #32]
    c00011d4:	b9000001 	str	w1, [x0]
    c00011d8:	f9401fe0 	ldr	x0, [sp, #56]
    c00011dc:	91000400 	add	x0, x0, #0x1
    c00011e0:	f9001fe0 	str	x0, [sp, #56]
    c00011e4:	1400001a 	b	c000124c <parse_format+0x168>
		case '#': spec->flags |= FLAG_ALT; p++; continue;
    c00011e8:	f94013e0 	ldr	x0, [sp, #32]
    c00011ec:	b9400000 	ldr	w0, [x0]
    c00011f0:	321d0001 	orr	w1, w0, #0x8
    c00011f4:	f94013e0 	ldr	x0, [sp, #32]
    c00011f8:	b9000001 	str	w1, [x0]
    c00011fc:	f9401fe0 	ldr	x0, [sp, #56]
    c0001200:	91000400 	add	x0, x0, #0x1
    c0001204:	f9001fe0 	str	x0, [sp, #56]
    c0001208:	14000011 	b	c000124c <parse_format+0x168>
		case '0': spec->flags |= FLAG_ZERO; p++; continue;
    c000120c:	f94013e0 	ldr	x0, [sp, #32]
    c0001210:	b9400000 	ldr	w0, [x0]
    c0001214:	321c0001 	orr	w1, w0, #0x10
    c0001218:	f94013e0 	ldr	x0, [sp, #32]
    c000121c:	b9000001 	str	w1, [x0]
    c0001220:	f9401fe0 	ldr	x0, [sp, #56]
    c0001224:	91000400 	add	x0, x0, #0x1
    c0001228:	f9001fe0 	str	x0, [sp, #56]
    c000122c:	14000008 	b	c000124c <parse_format+0x168>
		default: break;
    c0001230:	d503201f 	nop
		}
		break;
    c0001234:	d503201f 	nop
	}

	if (*p == '*') {
    c0001238:	f9401fe0 	ldr	x0, [sp, #56]
    c000123c:	39400000 	ldrb	w0, [x0]
    c0001240:	7100a81f 	cmp	w0, #0x2a
    c0001244:	54000661 	b.ne	c0001310 <parse_format+0x22c>  // b.any
    c0001248:	14000002 	b	c0001250 <parse_format+0x16c>
		switch (*p) {
    c000124c:	17ffffb9 	b	c0001130 <parse_format+0x4c>
		spec->width = va_arg(*args, int);
    c0001250:	f9400fe0 	ldr	x0, [sp, #24]
    c0001254:	b9401801 	ldr	w1, [x0, #24]
    c0001258:	f9400fe0 	ldr	x0, [sp, #24]
    c000125c:	f9400000 	ldr	x0, [x0]
    c0001260:	7100003f 	cmp	w1, #0x0
    c0001264:	540000cb 	b.lt	c000127c <parse_format+0x198>  // b.tstop
    c0001268:	91002c01 	add	x1, x0, #0xb
    c000126c:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c0001270:	f9400fe1 	ldr	x1, [sp, #24]
    c0001274:	f9000022 	str	x2, [x1]
    c0001278:	14000011 	b	c00012bc <parse_format+0x1d8>
    c000127c:	11002023 	add	w3, w1, #0x8
    c0001280:	f9400fe2 	ldr	x2, [sp, #24]
    c0001284:	b9001843 	str	w3, [x2, #24]
    c0001288:	f9400fe2 	ldr	x2, [sp, #24]
    c000128c:	b9401842 	ldr	w2, [x2, #24]
    c0001290:	7100005f 	cmp	w2, #0x0
    c0001294:	540000cd 	b.le	c00012ac <parse_format+0x1c8>
    c0001298:	91002c01 	add	x1, x0, #0xb
    c000129c:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c00012a0:	f9400fe1 	ldr	x1, [sp, #24]
    c00012a4:	f9000022 	str	x2, [x1]
    c00012a8:	14000005 	b	c00012bc <parse_format+0x1d8>
    c00012ac:	f9400fe0 	ldr	x0, [sp, #24]
    c00012b0:	f9400402 	ldr	x2, [x0, #8]
    c00012b4:	93407c20 	sxtw	x0, w1
    c00012b8:	8b000040 	add	x0, x2, x0
    c00012bc:	b9400001 	ldr	w1, [x0]
    c00012c0:	f94013e0 	ldr	x0, [sp, #32]
    c00012c4:	b9000401 	str	w1, [x0, #4]
		if (spec->width < 0) {
    c00012c8:	f94013e0 	ldr	x0, [sp, #32]
    c00012cc:	b9400400 	ldr	w0, [x0, #4]
    c00012d0:	7100001f 	cmp	w0, #0x0
    c00012d4:	5400016a 	b.ge	c0001300 <parse_format+0x21c>  // b.tcont
			spec->flags |= FLAG_LEFT;
    c00012d8:	f94013e0 	ldr	x0, [sp, #32]
    c00012dc:	b9400000 	ldr	w0, [x0]
    c00012e0:	32000001 	orr	w1, w0, #0x1
    c00012e4:	f94013e0 	ldr	x0, [sp, #32]
    c00012e8:	b9000001 	str	w1, [x0]
			spec->width = -spec->width;
    c00012ec:	f94013e0 	ldr	x0, [sp, #32]
    c00012f0:	b9400400 	ldr	w0, [x0, #4]
    c00012f4:	4b0003e1 	neg	w1, w0
    c00012f8:	f94013e0 	ldr	x0, [sp, #32]
    c00012fc:	b9000401 	str	w1, [x0, #4]
		}
		p++;
    c0001300:	f9401fe0 	ldr	x0, [sp, #56]
    c0001304:	91000400 	add	x0, x0, #0x1
    c0001308:	f9001fe0 	str	x0, [sp, #56]
    c000130c:	1400000b 	b	c0001338 <parse_format+0x254>
	} else if (parse_number(&p, &value)) {
    c0001310:	9100d3e1 	add	x1, sp, #0x34
    c0001314:	9100e3e0 	add	x0, sp, #0x38
    c0001318:	97ffff4a 	bl	c0001040 <parse_number>
    c000131c:	12001c00 	and	w0, w0, #0xff
    c0001320:	12000000 	and	w0, w0, #0x1
    c0001324:	7100001f 	cmp	w0, #0x0
    c0001328:	54000080 	b.eq	c0001338 <parse_format+0x254>  // b.none
		spec->width = value;
    c000132c:	b94037e1 	ldr	w1, [sp, #52]
    c0001330:	f94013e0 	ldr	x0, [sp, #32]
    c0001334:	b9000401 	str	w1, [x0, #4]
	}

	if (*p == '.') {
    c0001338:	f9401fe0 	ldr	x0, [sp, #56]
    c000133c:	39400000 	ldrb	w0, [x0]
    c0001340:	7100b81f 	cmp	w0, #0x2e
    c0001344:	540006e1 	b.ne	c0001420 <parse_format+0x33c>  // b.any
		p++;
    c0001348:	f9401fe0 	ldr	x0, [sp, #56]
    c000134c:	91000400 	add	x0, x0, #0x1
    c0001350:	f9001fe0 	str	x0, [sp, #56]
		if (*p == '*') {
    c0001354:	f9401fe0 	ldr	x0, [sp, #56]
    c0001358:	39400000 	ldrb	w0, [x0]
    c000135c:	7100a81f 	cmp	w0, #0x2a
    c0001360:	54000541 	b.ne	c0001408 <parse_format+0x324>  // b.any
			spec->precision = va_arg(*args, int);
    c0001364:	f9400fe0 	ldr	x0, [sp, #24]
    c0001368:	b9401801 	ldr	w1, [x0, #24]
    c000136c:	f9400fe0 	ldr	x0, [sp, #24]
    c0001370:	f9400000 	ldr	x0, [x0]
    c0001374:	7100003f 	cmp	w1, #0x0
    c0001378:	540000cb 	b.lt	c0001390 <parse_format+0x2ac>  // b.tstop
    c000137c:	91002c01 	add	x1, x0, #0xb
    c0001380:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c0001384:	f9400fe1 	ldr	x1, [sp, #24]
    c0001388:	f9000022 	str	x2, [x1]
    c000138c:	14000011 	b	c00013d0 <parse_format+0x2ec>
    c0001390:	11002023 	add	w3, w1, #0x8
    c0001394:	f9400fe2 	ldr	x2, [sp, #24]
    c0001398:	b9001843 	str	w3, [x2, #24]
    c000139c:	f9400fe2 	ldr	x2, [sp, #24]
    c00013a0:	b9401842 	ldr	w2, [x2, #24]
    c00013a4:	7100005f 	cmp	w2, #0x0
    c00013a8:	540000cd 	b.le	c00013c0 <parse_format+0x2dc>
    c00013ac:	91002c01 	add	x1, x0, #0xb
    c00013b0:	927df022 	and	x2, x1, #0xfffffffffffffff8
    c00013b4:	f9400fe1 	ldr	x1, [sp, #24]
    c00013b8:	f9000022 	str	x2, [x1]
    c00013bc:	14000005 	b	c00013d0 <parse_format+0x2ec>
    c00013c0:	f9400fe0 	ldr	x0, [sp, #24]
    c00013c4:	f9400402 	ldr	x2, [x0, #8]
    c00013c8:	93407c20 	sxtw	x0, w1
    c00013cc:	8b000040 	add	x0, x2, x0
    c00013d0:	b9400001 	ldr	w1, [x0]
    c00013d4:	f94013e0 	ldr	x0, [sp, #32]
    c00013d8:	b9000801 	str	w1, [x0, #8]
			if (spec->precision < 0) {
    c00013dc:	f94013e0 	ldr	x0, [sp, #32]
    c00013e0:	b9400800 	ldr	w0, [x0, #8]
    c00013e4:	7100001f 	cmp	w0, #0x0
    c00013e8:	5400008a 	b.ge	c00013f8 <parse_format+0x314>  // b.tcont
				spec->precision = -1;
    c00013ec:	f94013e0 	ldr	x0, [sp, #32]
    c00013f0:	12800001 	mov	w1, #0xffffffff            	// #-1
    c00013f4:	b9000801 	str	w1, [x0, #8]
			}
			p++;
    c00013f8:	f9401fe0 	ldr	x0, [sp, #56]
    c00013fc:	91000400 	add	x0, x0, #0x1
    c0001400:	f9001fe0 	str	x0, [sp, #56]
    c0001404:	14000007 	b	c0001420 <parse_format+0x33c>
		} else {
			parse_number(&p, &value);
    c0001408:	9100d3e1 	add	x1, sp, #0x34
    c000140c:	9100e3e0 	add	x0, sp, #0x38
    c0001410:	97ffff0c 	bl	c0001040 <parse_number>
			spec->precision = value;
    c0001414:	b94037e1 	ldr	w1, [sp, #52]
    c0001418:	f94013e0 	ldr	x0, [sp, #32]
    c000141c:	b9000801 	str	w1, [x0, #8]
		}
	}

	if ((*p == 'h') && (*(p + 1) == 'h')) {
    c0001420:	f9401fe0 	ldr	x0, [sp, #56]
    c0001424:	39400000 	ldrb	w0, [x0]
    c0001428:	7101a01f 	cmp	w0, #0x68
    c000142c:	540001a1 	b.ne	c0001460 <parse_format+0x37c>  // b.any
    c0001430:	f9401fe0 	ldr	x0, [sp, #56]
    c0001434:	91000400 	add	x0, x0, #0x1
    c0001438:	39400000 	ldrb	w0, [x0]
    c000143c:	7101a01f 	cmp	w0, #0x68
    c0001440:	54000101 	b.ne	c0001460 <parse_format+0x37c>  // b.any
		spec->length = LENGTH_HH;
    c0001444:	f94013e0 	ldr	x0, [sp, #32]
    c0001448:	52800021 	mov	w1, #0x1                   	// #1
    c000144c:	b9000c01 	str	w1, [x0, #12]
		p += 2;
    c0001450:	f9401fe0 	ldr	x0, [sp, #56]
    c0001454:	91000800 	add	x0, x0, #0x2
    c0001458:	f9001fe0 	str	x0, [sp, #56]
    c000145c:	14000047 	b	c0001578 <parse_format+0x494>
	} else if (*p == 'h') {
    c0001460:	f9401fe0 	ldr	x0, [sp, #56]
    c0001464:	39400000 	ldrb	w0, [x0]
    c0001468:	7101a01f 	cmp	w0, #0x68
    c000146c:	54000101 	b.ne	c000148c <parse_format+0x3a8>  // b.any
		spec->length = LENGTH_H;
    c0001470:	f94013e0 	ldr	x0, [sp, #32]
    c0001474:	52800041 	mov	w1, #0x2                   	// #2
    c0001478:	b9000c01 	str	w1, [x0, #12]
		p++;
    c000147c:	f9401fe0 	ldr	x0, [sp, #56]
    c0001480:	91000400 	add	x0, x0, #0x1
    c0001484:	f9001fe0 	str	x0, [sp, #56]
    c0001488:	1400003c 	b	c0001578 <parse_format+0x494>
	} else if ((*p == 'l') && (*(p + 1) == 'l')) {
    c000148c:	f9401fe0 	ldr	x0, [sp, #56]
    c0001490:	39400000 	ldrb	w0, [x0]
    c0001494:	7101b01f 	cmp	w0, #0x6c
    c0001498:	540001a1 	b.ne	c00014cc <parse_format+0x3e8>  // b.any
    c000149c:	f9401fe0 	ldr	x0, [sp, #56]
    c00014a0:	91000400 	add	x0, x0, #0x1
    c00014a4:	39400000 	ldrb	w0, [x0]
    c00014a8:	7101b01f 	cmp	w0, #0x6c
    c00014ac:	54000101 	b.ne	c00014cc <parse_format+0x3e8>  // b.any
		spec->length = LENGTH_LL;
    c00014b0:	f94013e0 	ldr	x0, [sp, #32]
    c00014b4:	52800081 	mov	w1, #0x4                   	// #4
    c00014b8:	b9000c01 	str	w1, [x0, #12]
		p += 2;
    c00014bc:	f9401fe0 	ldr	x0, [sp, #56]
    c00014c0:	91000800 	add	x0, x0, #0x2
    c00014c4:	f9001fe0 	str	x0, [sp, #56]
    c00014c8:	1400002c 	b	c0001578 <parse_format+0x494>
	} else if (*p == 'l') {
    c00014cc:	f9401fe0 	ldr	x0, [sp, #56]
    c00014d0:	39400000 	ldrb	w0, [x0]
    c00014d4:	7101b01f 	cmp	w0, #0x6c
    c00014d8:	54000101 	b.ne	c00014f8 <parse_format+0x414>  // b.any
		spec->length = LENGTH_L;
    c00014dc:	f94013e0 	ldr	x0, [sp, #32]
    c00014e0:	52800061 	mov	w1, #0x3                   	// #3
    c00014e4:	b9000c01 	str	w1, [x0, #12]
		p++;
    c00014e8:	f9401fe0 	ldr	x0, [sp, #56]
    c00014ec:	91000400 	add	x0, x0, #0x1
    c00014f0:	f9001fe0 	str	x0, [sp, #56]
    c00014f4:	14000021 	b	c0001578 <parse_format+0x494>
	} else if (*p == 'z') {
    c00014f8:	f9401fe0 	ldr	x0, [sp, #56]
    c00014fc:	39400000 	ldrb	w0, [x0]
    c0001500:	7101e81f 	cmp	w0, #0x7a
    c0001504:	54000101 	b.ne	c0001524 <parse_format+0x440>  // b.any
		spec->length = LENGTH_Z;
    c0001508:	f94013e0 	ldr	x0, [sp, #32]
    c000150c:	528000a1 	mov	w1, #0x5                   	// #5
    c0001510:	b9000c01 	str	w1, [x0, #12]
		p++;
    c0001514:	f9401fe0 	ldr	x0, [sp, #56]
    c0001518:	91000400 	add	x0, x0, #0x1
    c000151c:	f9001fe0 	str	x0, [sp, #56]
    c0001520:	14000016 	b	c0001578 <parse_format+0x494>
	} else if (*p == 't') {
    c0001524:	f9401fe0 	ldr	x0, [sp, #56]
    c0001528:	39400000 	ldrb	w0, [x0]
    c000152c:	7101d01f 	cmp	w0, #0x74
    c0001530:	54000101 	b.ne	c0001550 <parse_format+0x46c>  // b.any
		spec->length = LENGTH_T;
    c0001534:	f94013e0 	ldr	x0, [sp, #32]
    c0001538:	528000c1 	mov	w1, #0x6                   	// #6
    c000153c:	b9000c01 	str	w1, [x0, #12]
		p++;
    c0001540:	f9401fe0 	ldr	x0, [sp, #56]
    c0001544:	91000400 	add	x0, x0, #0x1
    c0001548:	f9001fe0 	str	x0, [sp, #56]
    c000154c:	1400000b 	b	c0001578 <parse_format+0x494>
	} else if (*p == 'j') {
    c0001550:	f9401fe0 	ldr	x0, [sp, #56]
    c0001554:	39400000 	ldrb	w0, [x0]
    c0001558:	7101a81f 	cmp	w0, #0x6a
    c000155c:	540000e1 	b.ne	c0001578 <parse_format+0x494>  // b.any
		spec->length = LENGTH_J;
    c0001560:	f94013e0 	ldr	x0, [sp, #32]
    c0001564:	528000e1 	mov	w1, #0x7                   	// #7
    c0001568:	b9000c01 	str	w1, [x0, #12]
		p++;
    c000156c:	f9401fe0 	ldr	x0, [sp, #56]
    c0001570:	91000400 	add	x0, x0, #0x1
    c0001574:	f9001fe0 	str	x0, [sp, #56]
	}

	spec->conv = *p;
    c0001578:	f9401fe0 	ldr	x0, [sp, #56]
    c000157c:	39400001 	ldrb	w1, [x0]
    c0001580:	f94013e0 	ldr	x0, [sp, #32]
    c0001584:	39004001 	strb	w1, [x0, #16]
	if ((*p >= 'A') && (*p <= 'Z')) {
    c0001588:	f9401fe0 	ldr	x0, [sp, #56]
    c000158c:	39400000 	ldrb	w0, [x0]
    c0001590:	7101001f 	cmp	w0, #0x40
    c0001594:	54000149 	b.ls	c00015bc <parse_format+0x4d8>  // b.plast
    c0001598:	f9401fe0 	ldr	x0, [sp, #56]
    c000159c:	39400000 	ldrb	w0, [x0]
    c00015a0:	7101681f 	cmp	w0, #0x5a
    c00015a4:	540000c8 	b.hi	c00015bc <parse_format+0x4d8>  // b.pmore
		spec->flags |= FLAG_UPPER;
    c00015a8:	f94013e0 	ldr	x0, [sp, #32]
    c00015ac:	b9400000 	ldr	w0, [x0]
    c00015b0:	321b0001 	orr	w1, w0, #0x20
    c00015b4:	f94013e0 	ldr	x0, [sp, #32]
    c00015b8:	b9000001 	str	w1, [x0]
	}
	if (*p != '\0') {
    c00015bc:	f9401fe0 	ldr	x0, [sp, #56]
    c00015c0:	39400000 	ldrb	w0, [x0]
    c00015c4:	7100001f 	cmp	w0, #0x0
    c00015c8:	54000080 	b.eq	c00015d8 <parse_format+0x4f4>  // b.none
		p++;
    c00015cc:	f9401fe0 	ldr	x0, [sp, #56]
    c00015d0:	91000400 	add	x0, x0, #0x1
    c00015d4:	f9001fe0 	str	x0, [sp, #56]
	}
	*fmt = p;
    c00015d8:	f9401fe1 	ldr	x1, [sp, #56]
    c00015dc:	f94017e0 	ldr	x0, [sp, #40]
    c00015e0:	f9000001 	str	x1, [x0]
}
    c00015e4:	d503201f 	nop
    c00015e8:	a8c47bfd 	ldp	x29, x30, [sp], #64
    c00015ec:	d65f03c0 	ret

00000000c00015f0 <debug_vprintf>:

int debug_vprintf(const char *fmt, va_list args)
{
    c00015f0:	a9b87bfd 	stp	x29, x30, [sp, #-128]!
    c00015f4:	910003fd 	mov	x29, sp
    c00015f8:	f9000bf3 	str	x19, [sp, #16]
    c00015fc:	f90017e0 	str	x0, [sp, #40]
    c0001600:	aa0103f3 	mov	x19, x1
	struct print_ctx ctx = { 0 };
    c0001604:	b9006bff 	str	wzr, [sp, #104]
	va_list ap;

	if (fmt == NULL) {
    c0001608:	f94017e0 	ldr	x0, [sp, #40]
    c000160c:	f100001f 	cmp	x0, #0x0
    c0001610:	54000061 	b.ne	c000161c <debug_vprintf+0x2c>  // b.any
		return 0;
    c0001614:	52800000 	mov	w0, #0x0                   	// #0
    c0001618:	1400016f 	b	c0001bd4 <debug_vprintf+0x5e4>
	}

	va_copy(ap, args);
    c000161c:	f9400260 	ldr	x0, [x19]
    c0001620:	f90027e0 	str	x0, [sp, #72]
    c0001624:	f9400660 	ldr	x0, [x19, #8]
    c0001628:	f9002be0 	str	x0, [sp, #80]
    c000162c:	f9400a60 	ldr	x0, [x19, #16]
    c0001630:	f9002fe0 	str	x0, [sp, #88]
    c0001634:	f9400e60 	ldr	x0, [x19, #24]
    c0001638:	f90033e0 	str	x0, [sp, #96]
	while (*fmt != '\0') {
    c000163c:	14000161 	b	c0001bc0 <debug_vprintf+0x5d0>
		struct format_spec spec;
		uint64_t uvalue;
		int64_t svalue;

		if (*fmt != '%') {
    c0001640:	f94017e0 	ldr	x0, [sp, #40]
    c0001644:	39400000 	ldrb	w0, [x0]
    c0001648:	7100941f 	cmp	w0, #0x25
    c000164c:	54000100 	b.eq	c000166c <debug_vprintf+0x7c>  // b.none
			print_char(&ctx, *fmt++);
    c0001650:	f94017e0 	ldr	x0, [sp, #40]
    c0001654:	91000401 	add	x1, x0, #0x1
    c0001658:	f90017e1 	str	x1, [sp, #40]
    c000165c:	39400001 	ldrb	w1, [x0]
    c0001660:	9101a3e0 	add	x0, sp, #0x68
    c0001664:	97fffa7b 	bl	c0000050 <print_char>
			continue;
    c0001668:	14000156 	b	c0001bc0 <debug_vprintf+0x5d0>
		}

		fmt++;
    c000166c:	f94017e0 	ldr	x0, [sp, #40]
    c0001670:	91000400 	add	x0, x0, #0x1
    c0001674:	f90017e0 	str	x0, [sp, #40]
		if (*fmt == '%') {
    c0001678:	f94017e0 	ldr	x0, [sp, #40]
    c000167c:	39400000 	ldrb	w0, [x0]
    c0001680:	7100941f 	cmp	w0, #0x25
    c0001684:	54000101 	b.ne	c00016a4 <debug_vprintf+0xb4>  // b.any
			print_char(&ctx, *fmt++);
    c0001688:	f94017e0 	ldr	x0, [sp, #40]
    c000168c:	91000401 	add	x1, x0, #0x1
    c0001690:	f90017e1 	str	x1, [sp, #40]
    c0001694:	39400001 	ldrb	w1, [x0]
    c0001698:	9101a3e0 	add	x0, sp, #0x68
    c000169c:	97fffa6d 	bl	c0000050 <print_char>
			continue;
    c00016a0:	14000148 	b	c0001bc0 <debug_vprintf+0x5d0>
		}

		parse_format(&fmt, &spec, &ap);
    c00016a4:	910123e2 	add	x2, sp, #0x48
    c00016a8:	9100c3e1 	add	x1, sp, #0x30
    c00016ac:	9100a3e0 	add	x0, sp, #0x28
    c00016b0:	97fffe8d 	bl	c00010e4 <parse_format>
		switch (spec.conv) {
    c00016b4:	394103e0 	ldrb	w0, [sp, #64]
    c00016b8:	7101e01f 	cmp	w0, #0x78
    c00016bc:	540009c0 	b.eq	c00017f4 <debug_vprintf+0x204>  // b.none
    c00016c0:	7101e01f 	cmp	w0, #0x78
    c00016c4:	540026ac 	b.gt	c0001b98 <debug_vprintf+0x5a8>
    c00016c8:	7101d41f 	cmp	w0, #0x75
    c00016cc:	540006c0 	b.eq	c00017a4 <debug_vprintf+0x1b4>  // b.none
    c00016d0:	7101d41f 	cmp	w0, #0x75
    c00016d4:	5400262c 	b.gt	c0001b98 <debug_vprintf+0x5a8>
    c00016d8:	7101cc1f 	cmp	w0, #0x73
    c00016dc:	54000d40 	b.eq	c0001884 <debug_vprintf+0x294>  // b.none
    c00016e0:	7101cc1f 	cmp	w0, #0x73
    c00016e4:	540025ac 	b.gt	c0001b98 <debug_vprintf+0x5a8>
    c00016e8:	7101c01f 	cmp	w0, #0x70
    c00016ec:	54000fe0 	b.eq	c00018e8 <debug_vprintf+0x2f8>  // b.none
    c00016f0:	7101c01f 	cmp	w0, #0x70
    c00016f4:	5400252c 	b.gt	c0001b98 <debug_vprintf+0x5a8>
    c00016f8:	7101bc1f 	cmp	w0, #0x6f
    c00016fc:	54000680 	b.eq	c00017cc <debug_vprintf+0x1dc>  // b.none
    c0001700:	7101bc1f 	cmp	w0, #0x6f
    c0001704:	540024ac 	b.gt	c0001b98 <debug_vprintf+0x5a8>
    c0001708:	7101b81f 	cmp	w0, #0x6e
    c000170c:	54001300 	b.eq	c000196c <debug_vprintf+0x37c>  // b.none
    c0001710:	7101b81f 	cmp	w0, #0x6e
    c0001714:	5400242c 	b.gt	c0001b98 <debug_vprintf+0x5a8>
    c0001718:	7101a41f 	cmp	w0, #0x69
    c000171c:	54000180 	b.eq	c000174c <debug_vprintf+0x15c>  // b.none
    c0001720:	7101a41f 	cmp	w0, #0x69
    c0001724:	540023ac 	b.gt	c0001b98 <debug_vprintf+0x5a8>
    c0001728:	7101901f 	cmp	w0, #0x64
    c000172c:	54000100 	b.eq	c000174c <debug_vprintf+0x15c>  // b.none
    c0001730:	7101901f 	cmp	w0, #0x64
    c0001734:	5400232c 	b.gt	c0001b98 <debug_vprintf+0x5a8>
    c0001738:	7101601f 	cmp	w0, #0x58
    c000173c:	540005c0 	b.eq	c00017f4 <debug_vprintf+0x204>  // b.none
    c0001740:	71018c1f 	cmp	w0, #0x63
    c0001744:	540006c0 	b.eq	c000181c <debug_vprintf+0x22c>  // b.none
    c0001748:	14000114 	b	c0001b98 <debug_vprintf+0x5a8>
		case 'd':
		case 'i':
			svalue = get_signed_arg(&ap, spec.length);
    c000174c:	b9403fe1 	ldr	w1, [sp, #60]
    c0001750:	910123e0 	add	x0, sp, #0x48
    c0001754:	97fffb8a 	bl	c000057c <get_signed_arg>
    c0001758:	f9003fe0 	str	x0, [sp, #120]
			uvalue = (svalue < 0) ? (uint64_t)(-(svalue + 1)) + 1U : (uint64_t)svalue;
    c000175c:	f9403fe0 	ldr	x0, [sp, #120]
    c0001760:	f100001f 	cmp	x0, #0x0
    c0001764:	5400008a 	b.ge	c0001774 <debug_vprintf+0x184>  // b.tcont
    c0001768:	f9403fe0 	ldr	x0, [sp, #120]
    c000176c:	cb0003e0 	neg	x0, x0
    c0001770:	14000002 	b	c0001778 <debug_vprintf+0x188>
    c0001774:	f9403fe0 	ldr	x0, [sp, #120]
    c0001778:	f9003be0 	str	x0, [sp, #112]
			format_integer(&ctx, &spec, uvalue, svalue < 0, 10U);
    c000177c:	f9403fe0 	ldr	x0, [sp, #120]
    c0001780:	d37ffc00 	lsr	x0, x0, #63
    c0001784:	12001c02 	and	w2, w0, #0xff
    c0001788:	9100c3e1 	add	x1, sp, #0x30
    c000178c:	9101a3e0 	add	x0, sp, #0x68
    c0001790:	52800144 	mov	w4, #0xa                   	// #10
    c0001794:	2a0203e3 	mov	w3, w2
    c0001798:	f9403be2 	ldr	x2, [sp, #112]
    c000179c:	97fffccc 	bl	c0000acc <format_integer>
			break;
    c00017a0:	14000108 	b	c0001bc0 <debug_vprintf+0x5d0>
		case 'u':
			format_integer(&ctx, &spec, get_unsigned_arg(&ap, spec.length), false, 10U);
    c00017a4:	b9403fe1 	ldr	w1, [sp, #60]
    c00017a8:	910123e0 	add	x0, sp, #0x48
    c00017ac:	97fffa5e 	bl	c0000124 <get_unsigned_arg>
    c00017b0:	aa0003e2 	mov	x2, x0
    c00017b4:	9100c3e1 	add	x1, sp, #0x30
    c00017b8:	9101a3e0 	add	x0, sp, #0x68
    c00017bc:	52800144 	mov	w4, #0xa                   	// #10
    c00017c0:	52800003 	mov	w3, #0x0                   	// #0
    c00017c4:	97fffcc2 	bl	c0000acc <format_integer>
			break;
    c00017c8:	140000fe 	b	c0001bc0 <debug_vprintf+0x5d0>
		case 'o':
			format_integer(&ctx, &spec, get_unsigned_arg(&ap, spec.length), false, 8U);
    c00017cc:	b9403fe1 	ldr	w1, [sp, #60]
    c00017d0:	910123e0 	add	x0, sp, #0x48
    c00017d4:	97fffa54 	bl	c0000124 <get_unsigned_arg>
    c00017d8:	aa0003e2 	mov	x2, x0
    c00017dc:	9100c3e1 	add	x1, sp, #0x30
    c00017e0:	9101a3e0 	add	x0, sp, #0x68
    c00017e4:	52800104 	mov	w4, #0x8                   	// #8
    c00017e8:	52800003 	mov	w3, #0x0                   	// #0
    c00017ec:	97fffcb8 	bl	c0000acc <format_integer>
			break;
    c00017f0:	140000f4 	b	c0001bc0 <debug_vprintf+0x5d0>
		case 'x':
		case 'X':
			format_integer(&ctx, &spec, get_unsigned_arg(&ap, spec.length), false, 16U);
    c00017f4:	b9403fe1 	ldr	w1, [sp, #60]
    c00017f8:	910123e0 	add	x0, sp, #0x48
    c00017fc:	97fffa4a 	bl	c0000124 <get_unsigned_arg>
    c0001800:	aa0003e2 	mov	x2, x0
    c0001804:	9100c3e1 	add	x1, sp, #0x30
    c0001808:	9101a3e0 	add	x0, sp, #0x68
    c000180c:	52800204 	mov	w4, #0x10                  	// #16
    c0001810:	52800003 	mov	w3, #0x0                   	// #0
    c0001814:	97fffcae 	bl	c0000acc <format_integer>
			break;
    c0001818:	140000ea 	b	c0001bc0 <debug_vprintf+0x5d0>
		case 'c':
			format_char(&ctx, &spec, (char)va_arg(ap, int));
    c000181c:	b94063e1 	ldr	w1, [sp, #96]
    c0001820:	f94027e0 	ldr	x0, [sp, #72]
    c0001824:	7100003f 	cmp	w1, #0x0
    c0001828:	540000ab 	b.lt	c000183c <debug_vprintf+0x24c>  // b.tstop
    c000182c:	91002c01 	add	x1, x0, #0xb
    c0001830:	927df021 	and	x1, x1, #0xfffffffffffffff8
    c0001834:	f90027e1 	str	x1, [sp, #72]
    c0001838:	1400000d 	b	c000186c <debug_vprintf+0x27c>
    c000183c:	11002022 	add	w2, w1, #0x8
    c0001840:	b90063e2 	str	w2, [sp, #96]
    c0001844:	b94063e2 	ldr	w2, [sp, #96]
    c0001848:	7100005f 	cmp	w2, #0x0
    c000184c:	540000ad 	b.le	c0001860 <debug_vprintf+0x270>
    c0001850:	91002c01 	add	x1, x0, #0xb
    c0001854:	927df021 	and	x1, x1, #0xfffffffffffffff8
    c0001858:	f90027e1 	str	x1, [sp, #72]
    c000185c:	14000004 	b	c000186c <debug_vprintf+0x27c>
    c0001860:	f9402be2 	ldr	x2, [sp, #80]
    c0001864:	93407c20 	sxtw	x0, w1
    c0001868:	8b000040 	add	x0, x2, x0
    c000186c:	b9400000 	ldr	w0, [x0]
    c0001870:	12001c02 	and	w2, w0, #0xff
    c0001874:	9100c3e1 	add	x1, sp, #0x30
    c0001878:	9101a3e0 	add	x0, sp, #0x68
    c000187c:	97fffdcd 	bl	c0000fb0 <format_char>
			break;
    c0001880:	140000d0 	b	c0001bc0 <debug_vprintf+0x5d0>
		case 's':
			format_string(&ctx, &spec, va_arg(ap, const char *));
    c0001884:	b94063e1 	ldr	w1, [sp, #96]
    c0001888:	f94027e0 	ldr	x0, [sp, #72]
    c000188c:	7100003f 	cmp	w1, #0x0
    c0001890:	540000ab 	b.lt	c00018a4 <debug_vprintf+0x2b4>  // b.tstop
    c0001894:	91003c01 	add	x1, x0, #0xf
    c0001898:	927df021 	and	x1, x1, #0xfffffffffffffff8
    c000189c:	f90027e1 	str	x1, [sp, #72]
    c00018a0:	1400000d 	b	c00018d4 <debug_vprintf+0x2e4>
    c00018a4:	11002022 	add	w2, w1, #0x8
    c00018a8:	b90063e2 	str	w2, [sp, #96]
    c00018ac:	b94063e2 	ldr	w2, [sp, #96]
    c00018b0:	7100005f 	cmp	w2, #0x0
    c00018b4:	540000ad 	b.le	c00018c8 <debug_vprintf+0x2d8>
    c00018b8:	91003c01 	add	x1, x0, #0xf
    c00018bc:	927df021 	and	x1, x1, #0xfffffffffffffff8
    c00018c0:	f90027e1 	str	x1, [sp, #72]
    c00018c4:	14000004 	b	c00018d4 <debug_vprintf+0x2e4>
    c00018c8:	f9402be2 	ldr	x2, [sp, #80]
    c00018cc:	93407c20 	sxtw	x0, w1
    c00018d0:	8b000040 	add	x0, x2, x0
    c00018d4:	f9400002 	ldr	x2, [x0]
    c00018d8:	9100c3e1 	add	x1, sp, #0x30
    c00018dc:	9101a3e0 	add	x0, sp, #0x68
    c00018e0:	97fffd73 	bl	c0000eac <format_string>
			break;
    c00018e4:	140000b7 	b	c0001bc0 <debug_vprintf+0x5d0>
		case 'p':
			spec.flags |= FLAG_ALT;
    c00018e8:	b94033e0 	ldr	w0, [sp, #48]
    c00018ec:	321d0000 	orr	w0, w0, #0x8
    c00018f0:	b90033e0 	str	w0, [sp, #48]
			spec.length = LENGTH_LL;
    c00018f4:	52800080 	mov	w0, #0x4                   	// #4
    c00018f8:	b9003fe0 	str	w0, [sp, #60]
			format_integer(&ctx, &spec, (uintptr_t)va_arg(ap, void *), false, 16U);
    c00018fc:	b94063e1 	ldr	w1, [sp, #96]
    c0001900:	f94027e0 	ldr	x0, [sp, #72]
    c0001904:	7100003f 	cmp	w1, #0x0
    c0001908:	540000ab 	b.lt	c000191c <debug_vprintf+0x32c>  // b.tstop
    c000190c:	91003c01 	add	x1, x0, #0xf
    c0001910:	927df021 	and	x1, x1, #0xfffffffffffffff8
    c0001914:	f90027e1 	str	x1, [sp, #72]
    c0001918:	1400000d 	b	c000194c <debug_vprintf+0x35c>
    c000191c:	11002022 	add	w2, w1, #0x8
    c0001920:	b90063e2 	str	w2, [sp, #96]
    c0001924:	b94063e2 	ldr	w2, [sp, #96]
    c0001928:	7100005f 	cmp	w2, #0x0
    c000192c:	540000ad 	b.le	c0001940 <debug_vprintf+0x350>
    c0001930:	91003c01 	add	x1, x0, #0xf
    c0001934:	927df021 	and	x1, x1, #0xfffffffffffffff8
    c0001938:	f90027e1 	str	x1, [sp, #72]
    c000193c:	14000004 	b	c000194c <debug_vprintf+0x35c>
    c0001940:	f9402be2 	ldr	x2, [sp, #80]
    c0001944:	93407c20 	sxtw	x0, w1
    c0001948:	8b000040 	add	x0, x2, x0
    c000194c:	f9400000 	ldr	x0, [x0]
    c0001950:	aa0003e2 	mov	x2, x0
    c0001954:	9100c3e1 	add	x1, sp, #0x30
    c0001958:	9101a3e0 	add	x0, sp, #0x68
    c000195c:	52800204 	mov	w4, #0x10                  	// #16
    c0001960:	52800003 	mov	w3, #0x0                   	// #0
    c0001964:	97fffc5a 	bl	c0000acc <format_integer>
			break;
    c0001968:	14000096 	b	c0001bc0 <debug_vprintf+0x5d0>
		case 'n':
			switch (spec.length) {
    c000196c:	b9403fe0 	ldr	w0, [sp, #60]
    c0001970:	7100101f 	cmp	w0, #0x4
    c0001974:	54000ae0 	b.eq	c0001ad0 <debug_vprintf+0x4e0>  // b.none
    c0001978:	7100101f 	cmp	w0, #0x4
    c000197c:	54000dcc 	b.gt	c0001b34 <debug_vprintf+0x544>
    c0001980:	71000c1f 	cmp	w0, #0x3
    c0001984:	54000740 	b.eq	c0001a6c <debug_vprintf+0x47c>  // b.none
    c0001988:	71000c1f 	cmp	w0, #0x3
    c000198c:	54000d4c 	b.gt	c0001b34 <debug_vprintf+0x544>
    c0001990:	7100041f 	cmp	w0, #0x1
    c0001994:	54000080 	b.eq	c00019a4 <debug_vprintf+0x3b4>  // b.none
    c0001998:	7100081f 	cmp	w0, #0x2
    c000199c:	54000360 	b.eq	c0001a08 <debug_vprintf+0x418>  // b.none
    c00019a0:	14000065 	b	c0001b34 <debug_vprintf+0x544>
			case LENGTH_HH:
				*va_arg(ap, signed char *) = (signed char)ctx.count;
    c00019a4:	b9406be3 	ldr	w3, [sp, #104]
    c00019a8:	b94063e1 	ldr	w1, [sp, #96]
    c00019ac:	f94027e0 	ldr	x0, [sp, #72]
    c00019b0:	7100003f 	cmp	w1, #0x0
    c00019b4:	540000ab 	b.lt	c00019c8 <debug_vprintf+0x3d8>  // b.tstop
    c00019b8:	91003c01 	add	x1, x0, #0xf
    c00019bc:	927df021 	and	x1, x1, #0xfffffffffffffff8
    c00019c0:	f90027e1 	str	x1, [sp, #72]
    c00019c4:	1400000d 	b	c00019f8 <debug_vprintf+0x408>
    c00019c8:	11002022 	add	w2, w1, #0x8
    c00019cc:	b90063e2 	str	w2, [sp, #96]
    c00019d0:	b94063e2 	ldr	w2, [sp, #96]
    c00019d4:	7100005f 	cmp	w2, #0x0
    c00019d8:	540000ad 	b.le	c00019ec <debug_vprintf+0x3fc>
    c00019dc:	91003c01 	add	x1, x0, #0xf
    c00019e0:	927df021 	and	x1, x1, #0xfffffffffffffff8
    c00019e4:	f90027e1 	str	x1, [sp, #72]
    c00019e8:	14000004 	b	c00019f8 <debug_vprintf+0x408>
    c00019ec:	f9402be2 	ldr	x2, [sp, #80]
    c00019f0:	93407c20 	sxtw	x0, w1
    c00019f4:	8b000040 	add	x0, x2, x0
    c00019f8:	f9400000 	ldr	x0, [x0]
    c00019fc:	13001c61 	sxtb	w1, w3
    c0001a00:	39000001 	strb	w1, [x0]
				break;
    c0001a04:	14000064 	b	c0001b94 <debug_vprintf+0x5a4>
			case LENGTH_H:
				*va_arg(ap, short *) = (short)ctx.count;
    c0001a08:	b9406be3 	ldr	w3, [sp, #104]
    c0001a0c:	b94063e1 	ldr	w1, [sp, #96]
    c0001a10:	f94027e0 	ldr	x0, [sp, #72]
    c0001a14:	7100003f 	cmp	w1, #0x0
    c0001a18:	540000ab 	b.lt	c0001a2c <debug_vprintf+0x43c>  // b.tstop
    c0001a1c:	91003c01 	add	x1, x0, #0xf
    c0001a20:	927df021 	and	x1, x1, #0xfffffffffffffff8
    c0001a24:	f90027e1 	str	x1, [sp, #72]
    c0001a28:	1400000d 	b	c0001a5c <debug_vprintf+0x46c>
    c0001a2c:	11002022 	add	w2, w1, #0x8
    c0001a30:	b90063e2 	str	w2, [sp, #96]
    c0001a34:	b94063e2 	ldr	w2, [sp, #96]
    c0001a38:	7100005f 	cmp	w2, #0x0
    c0001a3c:	540000ad 	b.le	c0001a50 <debug_vprintf+0x460>
    c0001a40:	91003c01 	add	x1, x0, #0xf
    c0001a44:	927df021 	and	x1, x1, #0xfffffffffffffff8
    c0001a48:	f90027e1 	str	x1, [sp, #72]
    c0001a4c:	14000004 	b	c0001a5c <debug_vprintf+0x46c>
    c0001a50:	f9402be2 	ldr	x2, [sp, #80]
    c0001a54:	93407c20 	sxtw	x0, w1
    c0001a58:	8b000040 	add	x0, x2, x0
    c0001a5c:	f9400000 	ldr	x0, [x0]
    c0001a60:	13003c61 	sxth	w1, w3
    c0001a64:	79000001 	strh	w1, [x0]
				break;
    c0001a68:	1400004b 	b	c0001b94 <debug_vprintf+0x5a4>
			case LENGTH_L:
				*va_arg(ap, long *) = (long)ctx.count;
    c0001a6c:	b9406be3 	ldr	w3, [sp, #104]
    c0001a70:	b94063e1 	ldr	w1, [sp, #96]
    c0001a74:	f94027e0 	ldr	x0, [sp, #72]
    c0001a78:	7100003f 	cmp	w1, #0x0
    c0001a7c:	540000ab 	b.lt	c0001a90 <debug_vprintf+0x4a0>  // b.tstop
    c0001a80:	91003c01 	add	x1, x0, #0xf
    c0001a84:	927df021 	and	x1, x1, #0xfffffffffffffff8
    c0001a88:	f90027e1 	str	x1, [sp, #72]
    c0001a8c:	1400000d 	b	c0001ac0 <debug_vprintf+0x4d0>
    c0001a90:	11002022 	add	w2, w1, #0x8
    c0001a94:	b90063e2 	str	w2, [sp, #96]
    c0001a98:	b94063e2 	ldr	w2, [sp, #96]
    c0001a9c:	7100005f 	cmp	w2, #0x0
    c0001aa0:	540000ad 	b.le	c0001ab4 <debug_vprintf+0x4c4>
    c0001aa4:	91003c01 	add	x1, x0, #0xf
    c0001aa8:	927df021 	and	x1, x1, #0xfffffffffffffff8
    c0001aac:	f90027e1 	str	x1, [sp, #72]
    c0001ab0:	14000004 	b	c0001ac0 <debug_vprintf+0x4d0>
    c0001ab4:	f9402be2 	ldr	x2, [sp, #80]
    c0001ab8:	93407c20 	sxtw	x0, w1
    c0001abc:	8b000040 	add	x0, x2, x0
    c0001ac0:	f9400000 	ldr	x0, [x0]
    c0001ac4:	93407c61 	sxtw	x1, w3
    c0001ac8:	f9000001 	str	x1, [x0]
				break;
    c0001acc:	14000032 	b	c0001b94 <debug_vprintf+0x5a4>
			case LENGTH_LL:
				*va_arg(ap, long long *) = (long long)ctx.count;
    c0001ad0:	b9406be3 	ldr	w3, [sp, #104]
    c0001ad4:	b94063e1 	ldr	w1, [sp, #96]
    c0001ad8:	f94027e0 	ldr	x0, [sp, #72]
    c0001adc:	7100003f 	cmp	w1, #0x0
    c0001ae0:	540000ab 	b.lt	c0001af4 <debug_vprintf+0x504>  // b.tstop
    c0001ae4:	91003c01 	add	x1, x0, #0xf
    c0001ae8:	927df021 	and	x1, x1, #0xfffffffffffffff8
    c0001aec:	f90027e1 	str	x1, [sp, #72]
    c0001af0:	1400000d 	b	c0001b24 <debug_vprintf+0x534>
    c0001af4:	11002022 	add	w2, w1, #0x8
    c0001af8:	b90063e2 	str	w2, [sp, #96]
    c0001afc:	b94063e2 	ldr	w2, [sp, #96]
    c0001b00:	7100005f 	cmp	w2, #0x0
    c0001b04:	540000ad 	b.le	c0001b18 <debug_vprintf+0x528>
    c0001b08:	91003c01 	add	x1, x0, #0xf
    c0001b0c:	927df021 	and	x1, x1, #0xfffffffffffffff8
    c0001b10:	f90027e1 	str	x1, [sp, #72]
    c0001b14:	14000004 	b	c0001b24 <debug_vprintf+0x534>
    c0001b18:	f9402be2 	ldr	x2, [sp, #80]
    c0001b1c:	93407c20 	sxtw	x0, w1
    c0001b20:	8b000040 	add	x0, x2, x0
    c0001b24:	f9400000 	ldr	x0, [x0]
    c0001b28:	93407c61 	sxtw	x1, w3
    c0001b2c:	f9000001 	str	x1, [x0]
				break;
    c0001b30:	14000019 	b	c0001b94 <debug_vprintf+0x5a4>
			default:
				*va_arg(ap, int *) = ctx.count;
    c0001b34:	b94063e1 	ldr	w1, [sp, #96]
    c0001b38:	f94027e0 	ldr	x0, [sp, #72]
    c0001b3c:	7100003f 	cmp	w1, #0x0
    c0001b40:	540000ab 	b.lt	c0001b54 <debug_vprintf+0x564>  // b.tstop
    c0001b44:	91003c01 	add	x1, x0, #0xf
    c0001b48:	927df021 	and	x1, x1, #0xfffffffffffffff8
    c0001b4c:	f90027e1 	str	x1, [sp, #72]
    c0001b50:	1400000d 	b	c0001b84 <debug_vprintf+0x594>
    c0001b54:	11002022 	add	w2, w1, #0x8
    c0001b58:	b90063e2 	str	w2, [sp, #96]
    c0001b5c:	b94063e2 	ldr	w2, [sp, #96]
    c0001b60:	7100005f 	cmp	w2, #0x0
    c0001b64:	540000ad 	b.le	c0001b78 <debug_vprintf+0x588>
    c0001b68:	91003c01 	add	x1, x0, #0xf
    c0001b6c:	927df021 	and	x1, x1, #0xfffffffffffffff8
    c0001b70:	f90027e1 	str	x1, [sp, #72]
    c0001b74:	14000004 	b	c0001b84 <debug_vprintf+0x594>
    c0001b78:	f9402be2 	ldr	x2, [sp, #80]
    c0001b7c:	93407c20 	sxtw	x0, w1
    c0001b80:	8b000040 	add	x0, x2, x0
    c0001b84:	f9400000 	ldr	x0, [x0]
    c0001b88:	b9406be1 	ldr	w1, [sp, #104]
    c0001b8c:	b9000001 	str	w1, [x0]
				break;
    c0001b90:	d503201f 	nop
			}
			break;
    c0001b94:	1400000b 	b	c0001bc0 <debug_vprintf+0x5d0>
		default:
			print_char(&ctx, '%');
    c0001b98:	9101a3e0 	add	x0, sp, #0x68
    c0001b9c:	528004a1 	mov	w1, #0x25                  	// #37
    c0001ba0:	97fff92c 	bl	c0000050 <print_char>
			if (spec.conv != '\0') {
    c0001ba4:	394103e0 	ldrb	w0, [sp, #64]
    c0001ba8:	7100001f 	cmp	w0, #0x0
    c0001bac:	54000080 	b.eq	c0001bbc <debug_vprintf+0x5cc>  // b.none
				print_char(&ctx, spec.conv);
    c0001bb0:	394103e1 	ldrb	w1, [sp, #64]
    c0001bb4:	9101a3e0 	add	x0, sp, #0x68
    c0001bb8:	97fff926 	bl	c0000050 <print_char>
			}
			break;
    c0001bbc:	d503201f 	nop
	while (*fmt != '\0') {
    c0001bc0:	f94017e0 	ldr	x0, [sp, #40]
    c0001bc4:	39400000 	ldrb	w0, [x0]
    c0001bc8:	7100001f 	cmp	w0, #0x0
    c0001bcc:	54ffd3a1 	b.ne	c0001640 <debug_vprintf+0x50>  // b.any
		}
	}
	va_end(ap);
	return ctx.count;
    c0001bd0:	b9406be0 	ldr	w0, [sp, #104]
}
    c0001bd4:	f9400bf3 	ldr	x19, [sp, #16]
    c0001bd8:	a8c87bfd 	ldp	x29, x30, [sp], #128
    c0001bdc:	d65f03c0 	ret

00000000c0001be0 <debug_printf>:

int debug_printf(const char *fmt, ...)
{
    c0001be0:	a9b57bfd 	stp	x29, x30, [sp, #-176]!
    c0001be4:	910003fd 	mov	x29, sp
    c0001be8:	f9001fe0 	str	x0, [sp, #56]
    c0001bec:	f9003fe1 	str	x1, [sp, #120]
    c0001bf0:	f90043e2 	str	x2, [sp, #128]
    c0001bf4:	f90047e3 	str	x3, [sp, #136]
    c0001bf8:	f9004be4 	str	x4, [sp, #144]
    c0001bfc:	f9004fe5 	str	x5, [sp, #152]
    c0001c00:	f90053e6 	str	x6, [sp, #160]
    c0001c04:	f90057e7 	str	x7, [sp, #168]
	int count;
	va_list args;

	va_start(args, fmt);
    c0001c08:	9102c3e0 	add	x0, sp, #0xb0
    c0001c0c:	f90027e0 	str	x0, [sp, #72]
    c0001c10:	9102c3e0 	add	x0, sp, #0xb0
    c0001c14:	f9002be0 	str	x0, [sp, #80]
    c0001c18:	9101c3e0 	add	x0, sp, #0x70
    c0001c1c:	f9002fe0 	str	x0, [sp, #88]
    c0001c20:	128006e0 	mov	w0, #0xffffffc8            	// #-56
    c0001c24:	b90063e0 	str	w0, [sp, #96]
    c0001c28:	b90067ff 	str	wzr, [sp, #100]
	count = debug_vprintf(fmt, args);
    c0001c2c:	f94027e0 	ldr	x0, [sp, #72]
    c0001c30:	f9000be0 	str	x0, [sp, #16]
    c0001c34:	f9402be0 	ldr	x0, [sp, #80]
    c0001c38:	f9000fe0 	str	x0, [sp, #24]
    c0001c3c:	f9402fe0 	ldr	x0, [sp, #88]
    c0001c40:	f90013e0 	str	x0, [sp, #32]
    c0001c44:	f94033e0 	ldr	x0, [sp, #96]
    c0001c48:	f90017e0 	str	x0, [sp, #40]
    c0001c4c:	910043e0 	add	x0, sp, #0x10
    c0001c50:	aa0003e1 	mov	x1, x0
    c0001c54:	f9401fe0 	ldr	x0, [sp, #56]
    c0001c58:	97fffe66 	bl	c00015f0 <debug_vprintf>
    c0001c5c:	b9006fe0 	str	w0, [sp, #108]
	va_end(args);

	return count;
    c0001c60:	b9406fe0 	ldr	w0, [sp, #108]
}
    c0001c64:	a8cb7bfd 	ldp	x29, x30, [sp], #176
    c0001c68:	d65f03c0 	ret

00000000c0001c6c <mini_os_vprintf>:

int mini_os_vprintf(const char *fmt, va_list args)
{
    c0001c6c:	a9bb7bfd 	stp	x29, x30, [sp, #-80]!
    c0001c70:	910003fd 	mov	x29, sp
    c0001c74:	f9000bf3 	str	x19, [sp, #16]
    c0001c78:	f90027e0 	str	x0, [sp, #72]
    c0001c7c:	aa0103f3 	mov	x19, x1
	return debug_vprintf(fmt, args);
    c0001c80:	f9400260 	ldr	x0, [x19]
    c0001c84:	f90013e0 	str	x0, [sp, #32]
    c0001c88:	f9400660 	ldr	x0, [x19, #8]
    c0001c8c:	f90017e0 	str	x0, [sp, #40]
    c0001c90:	f9400a60 	ldr	x0, [x19, #16]
    c0001c94:	f9001be0 	str	x0, [sp, #48]
    c0001c98:	f9400e60 	ldr	x0, [x19, #24]
    c0001c9c:	f9001fe0 	str	x0, [sp, #56]
    c0001ca0:	910083e0 	add	x0, sp, #0x20
    c0001ca4:	aa0003e1 	mov	x1, x0
    c0001ca8:	f94027e0 	ldr	x0, [sp, #72]
    c0001cac:	97fffe51 	bl	c00015f0 <debug_vprintf>
}
    c0001cb0:	f9400bf3 	ldr	x19, [sp, #16]
    c0001cb4:	a8c57bfd 	ldp	x29, x30, [sp], #80
    c0001cb8:	d65f03c0 	ret

00000000c0001cbc <mini_os_printf>:

int mini_os_printf(const char *fmt, ...)
{
    c0001cbc:	a9b57bfd 	stp	x29, x30, [sp, #-176]!
    c0001cc0:	910003fd 	mov	x29, sp
    c0001cc4:	f9001fe0 	str	x0, [sp, #56]
    c0001cc8:	f9003fe1 	str	x1, [sp, #120]
    c0001ccc:	f90043e2 	str	x2, [sp, #128]
    c0001cd0:	f90047e3 	str	x3, [sp, #136]
    c0001cd4:	f9004be4 	str	x4, [sp, #144]
    c0001cd8:	f9004fe5 	str	x5, [sp, #152]
    c0001cdc:	f90053e6 	str	x6, [sp, #160]
    c0001ce0:	f90057e7 	str	x7, [sp, #168]
	int count;
	va_list args;

	va_start(args, fmt);
    c0001ce4:	9102c3e0 	add	x0, sp, #0xb0
    c0001ce8:	f90027e0 	str	x0, [sp, #72]
    c0001cec:	9102c3e0 	add	x0, sp, #0xb0
    c0001cf0:	f9002be0 	str	x0, [sp, #80]
    c0001cf4:	9101c3e0 	add	x0, sp, #0x70
    c0001cf8:	f9002fe0 	str	x0, [sp, #88]
    c0001cfc:	128006e0 	mov	w0, #0xffffffc8            	// #-56
    c0001d00:	b90063e0 	str	w0, [sp, #96]
    c0001d04:	b90067ff 	str	wzr, [sp, #100]
	count = mini_os_vprintf(fmt, args);
    c0001d08:	f94027e0 	ldr	x0, [sp, #72]
    c0001d0c:	f9000be0 	str	x0, [sp, #16]
    c0001d10:	f9402be0 	ldr	x0, [sp, #80]
    c0001d14:	f9000fe0 	str	x0, [sp, #24]
    c0001d18:	f9402fe0 	ldr	x0, [sp, #88]
    c0001d1c:	f90013e0 	str	x0, [sp, #32]
    c0001d20:	f94033e0 	ldr	x0, [sp, #96]
    c0001d24:	f90017e0 	str	x0, [sp, #40]
    c0001d28:	910043e0 	add	x0, sp, #0x10
    c0001d2c:	aa0003e1 	mov	x1, x0
    c0001d30:	f9401fe0 	ldr	x0, [sp, #56]
    c0001d34:	97ffffce 	bl	c0001c6c <mini_os_vprintf>
    c0001d38:	b9006fe0 	str	w0, [sp, #108]
	va_end(args);

	return count;
    c0001d3c:	b9406fe0 	ldr	w0, [sp, #108]
}
    c0001d40:	a8cb7bfd 	ldp	x29, x30, [sp], #176
    c0001d44:	d65f03c0 	ret

00000000c0001d48 <debug_console_init>:

void debug_console_init(void)
{
    c0001d48:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    c0001d4c:	910003fd 	mov	x29, sp
	uart_init();
    c0001d50:	940000c7 	bl	c000206c <uart_init>
}
    c0001d54:	d503201f 	nop
    c0001d58:	a8c17bfd 	ldp	x29, x30, [sp], #16
    c0001d5c:	d65f03c0 	ret

00000000c0001d60 <debug_putc>:

void debug_putc(int ch)
{
    c0001d60:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c0001d64:	910003fd 	mov	x29, sp
    c0001d68:	b9001fe0 	str	w0, [sp, #28]
	uart_putc(ch);
    c0001d6c:	b9401fe0 	ldr	w0, [sp, #28]
    c0001d70:	94000110 	bl	c00021b0 <uart_putc>
}
    c0001d74:	d503201f 	nop
    c0001d78:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c0001d7c:	d65f03c0 	ret

00000000c0001d80 <debug_puts>:

void debug_puts(const char *str)
{
    c0001d80:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c0001d84:	910003fd 	mov	x29, sp
    c0001d88:	f9000fe0 	str	x0, [sp, #24]
	uart_puts(str);
    c0001d8c:	f9400fe0 	ldr	x0, [sp, #24]
    c0001d90:	94000123 	bl	c000221c <uart_puts>
}
    c0001d94:	d503201f 	nop
    c0001d98:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c0001d9c:	d65f03c0 	ret

00000000c0001da0 <debug_write>:

void debug_write(const char *buf, size_t len)
{
    c0001da0:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c0001da4:	910003fd 	mov	x29, sp
    c0001da8:	f9000fe0 	str	x0, [sp, #24]
    c0001dac:	f9000be1 	str	x1, [sp, #16]
	uart_write(buf, len);
    c0001db0:	f9400be1 	ldr	x1, [sp, #16]
    c0001db4:	f9400fe0 	ldr	x0, [sp, #24]
    c0001db8:	94000133 	bl	c0002284 <uart_write>
}
    c0001dbc:	d503201f 	nop
    c0001dc0:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c0001dc4:	d65f03c0 	ret

00000000c0001dc8 <debug_getc>:

int debug_getc(void)
{
    c0001dc8:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    c0001dcc:	910003fd 	mov	x29, sp
	return uart_getc();
    c0001dd0:	94000158 	bl	c0002330 <uart_getc>
}
    c0001dd4:	a8c17bfd 	ldp	x29, x30, [sp], #16
    c0001dd8:	d65f03c0 	ret

00000000c0001ddc <debug_try_getc>:

int debug_try_getc(void)
{
    c0001ddc:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    c0001de0:	910003fd 	mov	x29, sp
	return uart_try_getc();
    c0001de4:	94000141 	bl	c00022e8 <uart_try_getc>
}
    c0001de8:	a8c17bfd 	ldp	x29, x30, [sp], #16
    c0001dec:	d65f03c0 	ret

00000000c0001df0 <debug_put_hex64>:

void debug_put_hex64(uint64_t value)
{
    c0001df0:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c0001df4:	910003fd 	mov	x29, sp
    c0001df8:	f9000fe0 	str	x0, [sp, #24]
	uart_put_hex64(value);
    c0001dfc:	f9400fe0 	ldr	x0, [sp, #24]
    c0001e00:	9400015f 	bl	c000237c <uart_put_hex64>
}
    c0001e04:	d503201f 	nop
    c0001e08:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c0001e0c:	d65f03c0 	ret

00000000c0001e10 <debug_flush>:

void debug_flush(void)
{
    c0001e10:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    c0001e14:	910003fd 	mov	x29, sp
	uart_flush();
    c0001e18:	94000171 	bl	c00023dc <uart_flush>
    c0001e1c:	d503201f 	nop
    c0001e20:	a8c17bfd 	ldp	x29, x30, [sp], #16
    c0001e24:	d65f03c0 	ret

00000000c0001e28 <mmio_write_32>:
	.clock_hz = PLAT_UART0_CLK_HZ,
	.baudrate = PLAT_UART0_BAUDRATE,
};

static inline void mmio_write_32(uintptr_t addr, uint32_t value)
{
    c0001e28:	d10043ff 	sub	sp, sp, #0x10
    c0001e2c:	f90007e0 	str	x0, [sp, #8]
    c0001e30:	b90007e1 	str	w1, [sp, #4]
	*(volatile uint32_t *)addr = value;
    c0001e34:	f94007e0 	ldr	x0, [sp, #8]
    c0001e38:	b94007e1 	ldr	w1, [sp, #4]
    c0001e3c:	b9000001 	str	w1, [x0]
}
    c0001e40:	d503201f 	nop
    c0001e44:	910043ff 	add	sp, sp, #0x10
    c0001e48:	d65f03c0 	ret

00000000c0001e4c <mmio_read_32>:

static inline uint32_t mmio_read_32(uintptr_t addr)
{
    c0001e4c:	d10043ff 	sub	sp, sp, #0x10
    c0001e50:	f90007e0 	str	x0, [sp, #8]
	return *(volatile uint32_t *)addr;
    c0001e54:	f94007e0 	ldr	x0, [sp, #8]
    c0001e58:	b9400000 	ldr	w0, [x0]
}
    c0001e5c:	910043ff 	add	sp, sp, #0x10
    c0001e60:	d65f03c0 	ret

00000000c0001e64 <dsb_sy>:

static inline void dsb_sy(void)
{
	__asm__ volatile ("dsb sy" : : : "memory");
    c0001e64:	d5033f9f 	dsb	sy
}
    c0001e68:	d503201f 	nop
    c0001e6c:	d65f03c0 	ret

00000000c0001e70 <isb>:

static inline void isb(void)
{
	__asm__ volatile ("isb" : : : "memory");
    c0001e70:	d5033fdf 	isb
}
    c0001e74:	d503201f 	nop
    c0001e78:	d65f03c0 	ret

00000000c0001e7c <pl011_calc_baud>:

static void pl011_calc_baud(uint32_t uartclk_hz, uint32_t baud,
			    uint32_t *ibrd, uint32_t *fbrd)
{
    c0001e7c:	d10103ff 	sub	sp, sp, #0x40
    c0001e80:	b9001fe0 	str	w0, [sp, #28]
    c0001e84:	b9001be1 	str	w1, [sp, #24]
    c0001e88:	f9000be2 	str	x2, [sp, #16]
    c0001e8c:	f90007e3 	str	x3, [sp, #8]
	uint64_t denom;
	uint64_t div;
	uint64_t rem;
	uint64_t frac64;

	if ((uartclk_hz == 0U) || (baud == 0U)) {
    c0001e90:	b9401fe0 	ldr	w0, [sp, #28]
    c0001e94:	7100001f 	cmp	w0, #0x0
    c0001e98:	54000080 	b.eq	c0001ea8 <pl011_calc_baud+0x2c>  // b.none
    c0001e9c:	b9401be0 	ldr	w0, [sp, #24]
    c0001ea0:	7100001f 	cmp	w0, #0x0
    c0001ea4:	540000e1 	b.ne	c0001ec0 <pl011_calc_baud+0x44>  // b.any
		*ibrd = 1U;
    c0001ea8:	f9400be0 	ldr	x0, [sp, #16]
    c0001eac:	52800021 	mov	w1, #0x1                   	// #1
    c0001eb0:	b9000001 	str	w1, [x0]
		*fbrd = 0U;
    c0001eb4:	f94007e0 	ldr	x0, [sp, #8]
    c0001eb8:	b900001f 	str	wzr, [x0]
		return;
    c0001ebc:	14000029 	b	c0001f60 <pl011_calc_baud+0xe4>
	}

	denom = 16ULL * (uint64_t)baud;
    c0001ec0:	b9401be0 	ldr	w0, [sp, #24]
    c0001ec4:	d37cec00 	lsl	x0, x0, #4
    c0001ec8:	f90017e0 	str	x0, [sp, #40]
	div = (uint64_t)uartclk_hz / denom;
    c0001ecc:	b9401fe1 	ldr	w1, [sp, #28]
    c0001ed0:	f94017e0 	ldr	x0, [sp, #40]
    c0001ed4:	9ac00820 	udiv	x0, x1, x0
    c0001ed8:	f9001fe0 	str	x0, [sp, #56]
	rem = (uint64_t)uartclk_hz % denom;
    c0001edc:	b9401fe0 	ldr	w0, [sp, #28]
    c0001ee0:	f94017e1 	ldr	x1, [sp, #40]
    c0001ee4:	9ac10802 	udiv	x2, x0, x1
    c0001ee8:	f94017e1 	ldr	x1, [sp, #40]
    c0001eec:	9b017c41 	mul	x1, x2, x1
    c0001ef0:	cb010000 	sub	x0, x0, x1
    c0001ef4:	f90013e0 	str	x0, [sp, #32]
	frac64 = (rem * 64ULL + denom / 2ULL) / denom;
    c0001ef8:	f94013e0 	ldr	x0, [sp, #32]
    c0001efc:	d37ae401 	lsl	x1, x0, #6
    c0001f00:	f94017e0 	ldr	x0, [sp, #40]
    c0001f04:	d341fc00 	lsr	x0, x0, #1
    c0001f08:	8b000021 	add	x1, x1, x0
    c0001f0c:	f94017e0 	ldr	x0, [sp, #40]
    c0001f10:	9ac00820 	udiv	x0, x1, x0
    c0001f14:	f9001be0 	str	x0, [sp, #48]

	if (div == 0U) {
    c0001f18:	f9401fe0 	ldr	x0, [sp, #56]
    c0001f1c:	f100001f 	cmp	x0, #0x0
    c0001f20:	54000061 	b.ne	c0001f2c <pl011_calc_baud+0xb0>  // b.any
		div = 1U;
    c0001f24:	d2800020 	mov	x0, #0x1                   	// #1
    c0001f28:	f9001fe0 	str	x0, [sp, #56]
	}
	if (frac64 > 63U) {
    c0001f2c:	f9401be0 	ldr	x0, [sp, #48]
    c0001f30:	f100fc1f 	cmp	x0, #0x3f
    c0001f34:	54000069 	b.ls	c0001f40 <pl011_calc_baud+0xc4>  // b.plast
		frac64 = 63U;
    c0001f38:	d28007e0 	mov	x0, #0x3f                  	// #63
    c0001f3c:	f9001be0 	str	x0, [sp, #48]
	}

	*ibrd = (uint32_t)div;
    c0001f40:	f9401fe0 	ldr	x0, [sp, #56]
    c0001f44:	2a0003e1 	mov	w1, w0
    c0001f48:	f9400be0 	ldr	x0, [sp, #16]
    c0001f4c:	b9000001 	str	w1, [x0]
	*fbrd = (uint32_t)frac64;
    c0001f50:	f9401be0 	ldr	x0, [sp, #48]
    c0001f54:	2a0003e1 	mov	w1, w0
    c0001f58:	f94007e0 	ldr	x0, [sp, #8]
    c0001f5c:	b9000001 	str	w1, [x0]
}
    c0001f60:	910103ff 	add	sp, sp, #0x40
    c0001f64:	d65f03c0 	ret

00000000c0001f68 <uart_is_configured>:

bool uart_is_configured(void)
{
	return (plat_uart.base != 0UL) &&
    c0001f68:	b0000020 	adrp	x0, c0006000 <hex.0+0xc88>
    c0001f6c:	911bc000 	add	x0, x0, #0x6f0
    c0001f70:	f9400000 	ldr	x0, [x0]
	       (plat_uart.clock_hz != 0U) &&
    c0001f74:	f100001f 	cmp	x0, #0x0
    c0001f78:	540001a0 	b.eq	c0001fac <uart_is_configured+0x44>  // b.none
    c0001f7c:	b0000020 	adrp	x0, c0006000 <hex.0+0xc88>
    c0001f80:	911bc000 	add	x0, x0, #0x6f0
    c0001f84:	b9400800 	ldr	w0, [x0, #8]
	return (plat_uart.base != 0UL) &&
    c0001f88:	7100001f 	cmp	w0, #0x0
    c0001f8c:	54000100 	b.eq	c0001fac <uart_is_configured+0x44>  // b.none
	       (plat_uart.baudrate != 0U);
    c0001f90:	b0000020 	adrp	x0, c0006000 <hex.0+0xc88>
    c0001f94:	911bc000 	add	x0, x0, #0x6f0
    c0001f98:	b9400c00 	ldr	w0, [x0, #12]
	       (plat_uart.clock_hz != 0U) &&
    c0001f9c:	7100001f 	cmp	w0, #0x0
    c0001fa0:	54000060 	b.eq	c0001fac <uart_is_configured+0x44>  // b.none
    c0001fa4:	52800020 	mov	w0, #0x1                   	// #1
    c0001fa8:	14000002 	b	c0001fb0 <uart_is_configured+0x48>
    c0001fac:	52800000 	mov	w0, #0x0                   	// #0
    c0001fb0:	12000000 	and	w0, w0, #0x1
    c0001fb4:	12001c00 	and	w0, w0, #0xff
}
    c0001fb8:	d65f03c0 	ret

00000000c0001fbc <uart_tx_ready>:

bool uart_tx_ready(void)
{
    c0001fbc:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    c0001fc0:	910003fd 	mov	x29, sp
	if (!uart_is_configured()) {
    c0001fc4:	97ffffe9 	bl	c0001f68 <uart_is_configured>
    c0001fc8:	12001c00 	and	w0, w0, #0xff
    c0001fcc:	52000000 	eor	w0, w0, #0x1
    c0001fd0:	12001c00 	and	w0, w0, #0xff
    c0001fd4:	12000000 	and	w0, w0, #0x1
    c0001fd8:	7100001f 	cmp	w0, #0x0
    c0001fdc:	54000060 	b.eq	c0001fe8 <uart_tx_ready+0x2c>  // b.none
		return false;
    c0001fe0:	52800000 	mov	w0, #0x0                   	// #0
    c0001fe4:	1400000a 	b	c000200c <uart_tx_ready+0x50>
	}

	return (mmio_read_32(plat_uart.base + PL011_FR) & FR_TXFF) == 0U;
    c0001fe8:	b0000020 	adrp	x0, c0006000 <hex.0+0xc88>
    c0001fec:	911bc000 	add	x0, x0, #0x6f0
    c0001ff0:	f9400000 	ldr	x0, [x0]
    c0001ff4:	91006000 	add	x0, x0, #0x18
    c0001ff8:	97ffff95 	bl	c0001e4c <mmio_read_32>
    c0001ffc:	121b0000 	and	w0, w0, #0x20
    c0002000:	7100001f 	cmp	w0, #0x0
    c0002004:	1a9f17e0 	cset	w0, eq	// eq = none
    c0002008:	12001c00 	and	w0, w0, #0xff
}
    c000200c:	a8c17bfd 	ldp	x29, x30, [sp], #16
    c0002010:	d65f03c0 	ret

00000000c0002014 <uart_rx_ready>:

bool uart_rx_ready(void)
{
    c0002014:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    c0002018:	910003fd 	mov	x29, sp
	if (!uart_is_configured()) {
    c000201c:	97ffffd3 	bl	c0001f68 <uart_is_configured>
    c0002020:	12001c00 	and	w0, w0, #0xff
    c0002024:	52000000 	eor	w0, w0, #0x1
    c0002028:	12001c00 	and	w0, w0, #0xff
    c000202c:	12000000 	and	w0, w0, #0x1
    c0002030:	7100001f 	cmp	w0, #0x0
    c0002034:	54000060 	b.eq	c0002040 <uart_rx_ready+0x2c>  // b.none
		return false;
    c0002038:	52800000 	mov	w0, #0x0                   	// #0
    c000203c:	1400000a 	b	c0002064 <uart_rx_ready+0x50>
	}

	return (mmio_read_32(plat_uart.base + PL011_FR) & FR_RXFE) == 0U;
    c0002040:	90000020 	adrp	x0, c0006000 <hex.0+0xc88>
    c0002044:	911bc000 	add	x0, x0, #0x6f0
    c0002048:	f9400000 	ldr	x0, [x0]
    c000204c:	91006000 	add	x0, x0, #0x18
    c0002050:	97ffff7f 	bl	c0001e4c <mmio_read_32>
    c0002054:	121c0000 	and	w0, w0, #0x10
    c0002058:	7100001f 	cmp	w0, #0x0
    c000205c:	1a9f17e0 	cset	w0, eq	// eq = none
    c0002060:	12001c00 	and	w0, w0, #0xff
}
    c0002064:	a8c17bfd 	ldp	x29, x30, [sp], #16
    c0002068:	d65f03c0 	ret

00000000c000206c <uart_init>:

void uart_init(void)
{
    c000206c:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c0002070:	910003fd 	mov	x29, sp
	uint32_t ibrd;
	uint32_t fbrd;

	if (!uart_is_configured()) {
    c0002074:	97ffffbd 	bl	c0001f68 <uart_is_configured>
    c0002078:	12001c00 	and	w0, w0, #0xff
    c000207c:	52000000 	eor	w0, w0, #0x1
    c0002080:	12001c00 	and	w0, w0, #0xff
    c0002084:	12000000 	and	w0, w0, #0x1
    c0002088:	7100001f 	cmp	w0, #0x0
    c000208c:	540008c1 	b.ne	c00021a4 <uart_init+0x138>  // b.any
		return;
	}

	mmio_write_32(plat_uart.base + PL011_CR, 0U);
    c0002090:	90000020 	adrp	x0, c0006000 <hex.0+0xc88>
    c0002094:	911bc000 	add	x0, x0, #0x6f0
    c0002098:	f9400000 	ldr	x0, [x0]
    c000209c:	9100c000 	add	x0, x0, #0x30
    c00020a0:	52800001 	mov	w1, #0x0                   	// #0
    c00020a4:	97ffff61 	bl	c0001e28 <mmio_write_32>
	dsb_sy();
    c00020a8:	97ffff6f 	bl	c0001e64 <dsb_sy>
	isb();
    c00020ac:	97ffff71 	bl	c0001e70 <isb>

	while ((mmio_read_32(plat_uart.base + PL011_FR) & FR_BUSY) != 0U) {
    c00020b0:	d503201f 	nop
    c00020b4:	90000020 	adrp	x0, c0006000 <hex.0+0xc88>
    c00020b8:	911bc000 	add	x0, x0, #0x6f0
    c00020bc:	f9400000 	ldr	x0, [x0]
    c00020c0:	91006000 	add	x0, x0, #0x18
    c00020c4:	97ffff62 	bl	c0001e4c <mmio_read_32>
    c00020c8:	121d0000 	and	w0, w0, #0x8
    c00020cc:	7100001f 	cmp	w0, #0x0
    c00020d0:	54ffff21 	b.ne	c00020b4 <uart_init+0x48>  // b.any
	}

	mmio_write_32(plat_uart.base + PL011_ICR, PL011_ICR_ALL);
    c00020d4:	90000020 	adrp	x0, c0006000 <hex.0+0xc88>
    c00020d8:	911bc000 	add	x0, x0, #0x6f0
    c00020dc:	f9400000 	ldr	x0, [x0]
    c00020e0:	91011000 	add	x0, x0, #0x44
    c00020e4:	5280ffe1 	mov	w1, #0x7ff                 	// #2047
    c00020e8:	97ffff50 	bl	c0001e28 <mmio_write_32>
	mmio_write_32(plat_uart.base + PL011_IMSC, 0U);
    c00020ec:	90000020 	adrp	x0, c0006000 <hex.0+0xc88>
    c00020f0:	911bc000 	add	x0, x0, #0x6f0
    c00020f4:	f9400000 	ldr	x0, [x0]
    c00020f8:	9100e000 	add	x0, x0, #0x38
    c00020fc:	52800001 	mov	w1, #0x0                   	// #0
    c0002100:	97ffff4a 	bl	c0001e28 <mmio_write_32>

	pl011_calc_baud(plat_uart.clock_hz, plat_uart.baudrate, &ibrd, &fbrd);
    c0002104:	90000020 	adrp	x0, c0006000 <hex.0+0xc88>
    c0002108:	911bc000 	add	x0, x0, #0x6f0
    c000210c:	b9400804 	ldr	w4, [x0, #8]
    c0002110:	90000020 	adrp	x0, c0006000 <hex.0+0xc88>
    c0002114:	911bc000 	add	x0, x0, #0x6f0
    c0002118:	b9400c00 	ldr	w0, [x0, #12]
    c000211c:	910063e2 	add	x2, sp, #0x18
    c0002120:	910073e1 	add	x1, sp, #0x1c
    c0002124:	aa0203e3 	mov	x3, x2
    c0002128:	aa0103e2 	mov	x2, x1
    c000212c:	2a0003e1 	mov	w1, w0
    c0002130:	2a0403e0 	mov	w0, w4
    c0002134:	97ffff52 	bl	c0001e7c <pl011_calc_baud>
	mmio_write_32(plat_uart.base + PL011_IBRD, ibrd);
    c0002138:	90000020 	adrp	x0, c0006000 <hex.0+0xc88>
    c000213c:	911bc000 	add	x0, x0, #0x6f0
    c0002140:	f9400000 	ldr	x0, [x0]
    c0002144:	91009000 	add	x0, x0, #0x24
    c0002148:	b9401fe1 	ldr	w1, [sp, #28]
    c000214c:	97ffff37 	bl	c0001e28 <mmio_write_32>
	mmio_write_32(plat_uart.base + PL011_FBRD, fbrd);
    c0002150:	90000020 	adrp	x0, c0006000 <hex.0+0xc88>
    c0002154:	911bc000 	add	x0, x0, #0x6f0
    c0002158:	f9400000 	ldr	x0, [x0]
    c000215c:	9100a000 	add	x0, x0, #0x28
    c0002160:	b9401be1 	ldr	w1, [sp, #24]
    c0002164:	97ffff31 	bl	c0001e28 <mmio_write_32>
	mmio_write_32(plat_uart.base + PL011_LCRH, LCRH_WLEN_8 | LCRH_FEN);
    c0002168:	90000020 	adrp	x0, c0006000 <hex.0+0xc88>
    c000216c:	911bc000 	add	x0, x0, #0x6f0
    c0002170:	f9400000 	ldr	x0, [x0]
    c0002174:	9100b000 	add	x0, x0, #0x2c
    c0002178:	52800e01 	mov	w1, #0x70                  	// #112
    c000217c:	97ffff2b 	bl	c0001e28 <mmio_write_32>
	mmio_write_32(plat_uart.base + PL011_CR, CR_UARTEN | CR_TXE | CR_RXE);
    c0002180:	90000020 	adrp	x0, c0006000 <hex.0+0xc88>
    c0002184:	911bc000 	add	x0, x0, #0x6f0
    c0002188:	f9400000 	ldr	x0, [x0]
    c000218c:	9100c000 	add	x0, x0, #0x30
    c0002190:	52806021 	mov	w1, #0x301                 	// #769
    c0002194:	97ffff25 	bl	c0001e28 <mmio_write_32>
	dsb_sy();
    c0002198:	97ffff33 	bl	c0001e64 <dsb_sy>
	isb();
    c000219c:	97ffff35 	bl	c0001e70 <isb>
    c00021a0:	14000002 	b	c00021a8 <uart_init+0x13c>
		return;
    c00021a4:	d503201f 	nop
}
    c00021a8:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c00021ac:	d65f03c0 	ret

00000000c00021b0 <uart_putc>:

void uart_putc(int ch)
{
    c00021b0:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c00021b4:	910003fd 	mov	x29, sp
    c00021b8:	b9001fe0 	str	w0, [sp, #28]
	if (!uart_is_configured()) {
    c00021bc:	97ffff6b 	bl	c0001f68 <uart_is_configured>
    c00021c0:	12001c00 	and	w0, w0, #0xff
    c00021c4:	52000000 	eor	w0, w0, #0x1
    c00021c8:	12001c00 	and	w0, w0, #0xff
    c00021cc:	12000000 	and	w0, w0, #0x1
    c00021d0:	7100001f 	cmp	w0, #0x0
    c00021d4:	540001e1 	b.ne	c0002210 <uart_putc+0x60>  // b.any
		return;
	}

	while (!uart_tx_ready()) {
    c00021d8:	d503201f 	nop
    c00021dc:	97ffff78 	bl	c0001fbc <uart_tx_ready>
    c00021e0:	12001c00 	and	w0, w0, #0xff
    c00021e4:	52000000 	eor	w0, w0, #0x1
    c00021e8:	12001c00 	and	w0, w0, #0xff
    c00021ec:	12000000 	and	w0, w0, #0x1
    c00021f0:	7100001f 	cmp	w0, #0x0
    c00021f4:	54ffff41 	b.ne	c00021dc <uart_putc+0x2c>  // b.any
	}

	mmio_write_32(plat_uart.base + PL011_DR, (uint32_t)ch);
    c00021f8:	90000020 	adrp	x0, c0006000 <hex.0+0xc88>
    c00021fc:	911bc000 	add	x0, x0, #0x6f0
    c0002200:	f9400000 	ldr	x0, [x0]
    c0002204:	b9401fe1 	ldr	w1, [sp, #28]
    c0002208:	97ffff08 	bl	c0001e28 <mmio_write_32>
    c000220c:	14000002 	b	c0002214 <uart_putc+0x64>
		return;
    c0002210:	d503201f 	nop
}
    c0002214:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c0002218:	d65f03c0 	ret

00000000c000221c <uart_puts>:

void uart_puts(const char *str)
{
    c000221c:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c0002220:	910003fd 	mov	x29, sp
    c0002224:	f9000fe0 	str	x0, [sp, #24]
	if (str == NULL) {
    c0002228:	f9400fe0 	ldr	x0, [sp, #24]
    c000222c:	f100001f 	cmp	x0, #0x0
    c0002230:	54000240 	b.eq	c0002278 <uart_puts+0x5c>  // b.none
		return;
	}

	while (*str != '\0') {
    c0002234:	1400000c 	b	c0002264 <uart_puts+0x48>
		if (*str == '\n') {
    c0002238:	f9400fe0 	ldr	x0, [sp, #24]
    c000223c:	39400000 	ldrb	w0, [x0]
    c0002240:	7100281f 	cmp	w0, #0xa
    c0002244:	54000061 	b.ne	c0002250 <uart_puts+0x34>  // b.any
			uart_putc('\r');
    c0002248:	528001a0 	mov	w0, #0xd                   	// #13
    c000224c:	97ffffd9 	bl	c00021b0 <uart_putc>
		}

		uart_putc(*str++);
    c0002250:	f9400fe0 	ldr	x0, [sp, #24]
    c0002254:	91000401 	add	x1, x0, #0x1
    c0002258:	f9000fe1 	str	x1, [sp, #24]
    c000225c:	39400000 	ldrb	w0, [x0]
    c0002260:	97ffffd4 	bl	c00021b0 <uart_putc>
	while (*str != '\0') {
    c0002264:	f9400fe0 	ldr	x0, [sp, #24]
    c0002268:	39400000 	ldrb	w0, [x0]
    c000226c:	7100001f 	cmp	w0, #0x0
    c0002270:	54fffe41 	b.ne	c0002238 <uart_puts+0x1c>  // b.any
    c0002274:	14000002 	b	c000227c <uart_puts+0x60>
		return;
    c0002278:	d503201f 	nop
	}
}
    c000227c:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c0002280:	d65f03c0 	ret

00000000c0002284 <uart_write>:

void uart_write(const char *buf, size_t len)
{
    c0002284:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
    c0002288:	910003fd 	mov	x29, sp
    c000228c:	f9000fe0 	str	x0, [sp, #24]
    c0002290:	f9000be1 	str	x1, [sp, #16]
	size_t i;

	if (buf == NULL) {
    c0002294:	f9400fe0 	ldr	x0, [sp, #24]
    c0002298:	f100001f 	cmp	x0, #0x0
    c000229c:	54000200 	b.eq	c00022dc <uart_write+0x58>  // b.none
		return;
	}

	for (i = 0; i < len; ++i) {
    c00022a0:	f90017ff 	str	xzr, [sp, #40]
    c00022a4:	14000009 	b	c00022c8 <uart_write+0x44>
		uart_putc((int)buf[i]);
    c00022a8:	f9400fe1 	ldr	x1, [sp, #24]
    c00022ac:	f94017e0 	ldr	x0, [sp, #40]
    c00022b0:	8b000020 	add	x0, x1, x0
    c00022b4:	39400000 	ldrb	w0, [x0]
    c00022b8:	97ffffbe 	bl	c00021b0 <uart_putc>
	for (i = 0; i < len; ++i) {
    c00022bc:	f94017e0 	ldr	x0, [sp, #40]
    c00022c0:	91000400 	add	x0, x0, #0x1
    c00022c4:	f90017e0 	str	x0, [sp, #40]
    c00022c8:	f94017e1 	ldr	x1, [sp, #40]
    c00022cc:	f9400be0 	ldr	x0, [sp, #16]
    c00022d0:	eb00003f 	cmp	x1, x0
    c00022d4:	54fffea3 	b.cc	c00022a8 <uart_write+0x24>  // b.lo, b.ul, b.last
    c00022d8:	14000002 	b	c00022e0 <uart_write+0x5c>
		return;
    c00022dc:	d503201f 	nop
	}
}
    c00022e0:	a8c37bfd 	ldp	x29, x30, [sp], #48
    c00022e4:	d65f03c0 	ret

00000000c00022e8 <uart_try_getc>:

int uart_try_getc(void)
{
    c00022e8:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    c00022ec:	910003fd 	mov	x29, sp
	if (!uart_rx_ready()) {
    c00022f0:	97ffff49 	bl	c0002014 <uart_rx_ready>
    c00022f4:	12001c00 	and	w0, w0, #0xff
    c00022f8:	52000000 	eor	w0, w0, #0x1
    c00022fc:	12001c00 	and	w0, w0, #0xff
    c0002300:	12000000 	and	w0, w0, #0x1
    c0002304:	7100001f 	cmp	w0, #0x0
    c0002308:	54000060 	b.eq	c0002314 <uart_try_getc+0x2c>  // b.none
		return -1;
    c000230c:	12800000 	mov	w0, #0xffffffff            	// #-1
    c0002310:	14000006 	b	c0002328 <uart_try_getc+0x40>
	}

	return (int)(mmio_read_32(plat_uart.base + PL011_DR) & 0xFFU);
    c0002314:	90000020 	adrp	x0, c0006000 <hex.0+0xc88>
    c0002318:	911bc000 	add	x0, x0, #0x6f0
    c000231c:	f9400000 	ldr	x0, [x0]
    c0002320:	97fffecb 	bl	c0001e4c <mmio_read_32>
    c0002324:	12001c00 	and	w0, w0, #0xff
}
    c0002328:	a8c17bfd 	ldp	x29, x30, [sp], #16
    c000232c:	d65f03c0 	ret

00000000c0002330 <uart_getc>:

int uart_getc(void)
{
    c0002330:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c0002334:	910003fd 	mov	x29, sp
	int ch;

	if (!uart_is_configured()) {
    c0002338:	97ffff0c 	bl	c0001f68 <uart_is_configured>
    c000233c:	12001c00 	and	w0, w0, #0xff
    c0002340:	52000000 	eor	w0, w0, #0x1
    c0002344:	12001c00 	and	w0, w0, #0xff
    c0002348:	12000000 	and	w0, w0, #0x1
    c000234c:	7100001f 	cmp	w0, #0x0
    c0002350:	54000060 	b.eq	c000235c <uart_getc+0x2c>  // b.none
		return -1;
    c0002354:	12800000 	mov	w0, #0xffffffff            	// #-1
    c0002358:	14000007 	b	c0002374 <uart_getc+0x44>
	}

	do {
		ch = uart_try_getc();
    c000235c:	97ffffe3 	bl	c00022e8 <uart_try_getc>
    c0002360:	b9001fe0 	str	w0, [sp, #28]
	} while (ch < 0);
    c0002364:	b9401fe0 	ldr	w0, [sp, #28]
    c0002368:	7100001f 	cmp	w0, #0x0
    c000236c:	54ffff8b 	b.lt	c000235c <uart_getc+0x2c>  // b.tstop

	return ch;
    c0002370:	b9401fe0 	ldr	w0, [sp, #28]
}
    c0002374:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c0002378:	d65f03c0 	ret

00000000c000237c <uart_put_hex64>:

void uart_put_hex64(uint64_t value)
{
    c000237c:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
    c0002380:	910003fd 	mov	x29, sp
    c0002384:	f9000fe0 	str	x0, [sp, #24]
	static const char hex[] = "0123456789abcdef";
	int shift;

	for (shift = 60; shift >= 0; shift -= 4) {
    c0002388:	52800780 	mov	w0, #0x3c                  	// #60
    c000238c:	b9002fe0 	str	w0, [sp, #44]
    c0002390:	1400000c 	b	c00023c0 <uart_put_hex64+0x44>
		uart_putc(hex[(value >> shift) & 0xFULL]);
    c0002394:	b9402fe0 	ldr	w0, [sp, #44]
    c0002398:	f9400fe1 	ldr	x1, [sp, #24]
    c000239c:	9ac02420 	lsr	x0, x1, x0
    c00023a0:	92400c00 	and	x0, x0, #0xf
    c00023a4:	f0000001 	adrp	x1, c0005000 <topology_mark_cpu_online+0xcc>
    c00023a8:	910de021 	add	x1, x1, #0x378
    c00023ac:	38606820 	ldrb	w0, [x1, x0]
    c00023b0:	97ffff80 	bl	c00021b0 <uart_putc>
	for (shift = 60; shift >= 0; shift -= 4) {
    c00023b4:	b9402fe0 	ldr	w0, [sp, #44]
    c00023b8:	51001000 	sub	w0, w0, #0x4
    c00023bc:	b9002fe0 	str	w0, [sp, #44]
    c00023c0:	b9402fe0 	ldr	w0, [sp, #44]
    c00023c4:	7100001f 	cmp	w0, #0x0
    c00023c8:	54fffe6a 	b.ge	c0002394 <uart_put_hex64+0x18>  // b.tcont
	}
}
    c00023cc:	d503201f 	nop
    c00023d0:	d503201f 	nop
    c00023d4:	a8c37bfd 	ldp	x29, x30, [sp], #48
    c00023d8:	d65f03c0 	ret

00000000c00023dc <uart_flush>:

void uart_flush(void)
{
    c00023dc:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    c00023e0:	910003fd 	mov	x29, sp
	if (!uart_is_configured()) {
    c00023e4:	97fffee1 	bl	c0001f68 <uart_is_configured>
    c00023e8:	12001c00 	and	w0, w0, #0xff
    c00023ec:	52000000 	eor	w0, w0, #0x1
    c00023f0:	12001c00 	and	w0, w0, #0xff
    c00023f4:	12000000 	and	w0, w0, #0x1
    c00023f8:	7100001f 	cmp	w0, #0x0
    c00023fc:	54000161 	b.ne	c0002428 <uart_flush+0x4c>  // b.any
		return;
	}

	while ((mmio_read_32(plat_uart.base + PL011_FR) & FR_BUSY) != 0U) {
    c0002400:	d503201f 	nop
    c0002404:	90000020 	adrp	x0, c0006000 <hex.0+0xc88>
    c0002408:	911bc000 	add	x0, x0, #0x6f0
    c000240c:	f9400000 	ldr	x0, [x0]
    c0002410:	91006000 	add	x0, x0, #0x18
    c0002414:	97fffe8e 	bl	c0001e4c <mmio_read_32>
    c0002418:	121d0000 	and	w0, w0, #0x8
    c000241c:	7100001f 	cmp	w0, #0x0
    c0002420:	54ffff21 	b.ne	c0002404 <uart_flush+0x28>  // b.any
    c0002424:	14000002 	b	c000242c <uart_flush+0x50>
		return;
    c0002428:	d503201f 	nop
	}
    c000242c:	a8c17bfd 	ldp	x29, x30, [sp], #16
    c0002430:	d65f03c0 	ret

00000000c0002434 <gic_init>:
#include <drivers/interrupt/gic.h>

void gic_init(void)
{
    c0002434:	d503201f 	nop
    c0002438:	d65f03c0 	ret

00000000c000243c <print_mini_os_banner>:
#define MINI_OS_BUILD_YEAR 2026

volatile uint64_t boot_magic = PLAT_LOAD_ADDR;

static void print_mini_os_banner(void)
{
    c000243c:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    c0002440:	910003fd 	mov	x29, sp
    debug_puts("\n");
    c0002444:	f0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0002448:	910e4000 	add	x0, x0, #0x390
    c000244c:	97fffe4d 	bl	c0001d80 <debug_puts>
    debug_puts("============================================================\n");
    c0002450:	f0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0002454:	910e6000 	add	x0, x0, #0x398
    c0002458:	97fffe4a 	bl	c0001d80 <debug_puts>
    debug_puts("            __  __   ___   _   _   ___    ___    ____      \n");
    c000245c:	f0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0002460:	910f6000 	add	x0, x0, #0x3d8
    c0002464:	97fffe47 	bl	c0001d80 <debug_puts>
    debug_puts("           |  \\/  | |_ _| | \\ | | |_ _|  / _ \\  / ___|     \n");
    c0002468:	f0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c000246c:	91106000 	add	x0, x0, #0x418
    c0002470:	97fffe44 	bl	c0001d80 <debug_puts>
    debug_puts("           | |\\/| |  | |  |  \\| |  | |  | | | | \\___ \\     \n");
    c0002474:	f0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0002478:	91116000 	add	x0, x0, #0x458
    c000247c:	97fffe41 	bl	c0001d80 <debug_puts>
    debug_puts("           | |  | |  | |  | |\\  |  | |  | |_| |  ___) |    \n");
    c0002480:	f0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0002484:	91126000 	add	x0, x0, #0x498
    c0002488:	97fffe3e 	bl	c0001d80 <debug_puts>
    debug_puts("           |_|  |_| |___| |_| \\_| |___|  \\___/  |____/     \n");
    c000248c:	f0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0002490:	91136000 	add	x0, x0, #0x4d8
    c0002494:	97fffe3b 	bl	c0001d80 <debug_puts>
    debug_puts("============================================================\n");
    c0002498:	f0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c000249c:	910e6000 	add	x0, x0, #0x398
    c00024a0:	97fffe38 	bl	c0001d80 <debug_puts>
    debug_puts("                     2026  Mini-OS  V0.1                    \n");
    c00024a4:	f0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c00024a8:	91146000 	add	x0, x0, #0x518
    c00024ac:	97fffe35 	bl	c0001d80 <debug_puts>
    debug_puts("============================================================\n");
    c00024b0:	f0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c00024b4:	910e6000 	add	x0, x0, #0x398
    c00024b8:	97fffe32 	bl	c0001d80 <debug_puts>
    debug_puts("\n");
    c00024bc:	f0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c00024c0:	910e4000 	add	x0, x0, #0x390
    c00024c4:	97fffe2f 	bl	c0001d80 <debug_puts>

    mini_os_printf("UART ready @ 0x%llx, boot magic: 0x%llx\n\n",
    c00024c8:	90000020 	adrp	x0, c0006000 <hex.0+0xc88>
    c00024cc:	911c0000 	add	x0, x0, #0x700
    c00024d0:	f9400000 	ldr	x0, [x0]
    c00024d4:	aa0003e2 	mov	x2, x0
    c00024d8:	d2a34801 	mov	x1, #0x1a400000            	// #440401920
    c00024dc:	f0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c00024e0:	91156000 	add	x0, x0, #0x558
    c00024e4:	97fffdf6 	bl	c0001cbc <mini_os_printf>
		       (unsigned long long)PLAT_UART0_BASE,
		       (unsigned long long)boot_magic);
}
    c00024e8:	d503201f 	nop
    c00024ec:	a8c17bfd 	ldp	x29, x30, [sp], #16
    c00024f0:	d65f03c0 	ret

00000000c00024f4 <initialize_phase0_modules>:

static void initialize_phase0_modules(void)
{
    c00024f4:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    c00024f8:	910003fd 	mov	x29, sp
	topology_init();
    c00024fc:	940009f2 	bl	c0004cc4 <topology_init>
	scheduler_init();
    c0002500:	940000f0 	bl	c00028c0 <scheduler_init>
	scheduler_join_cpu(0U);
    c0002504:	52800000 	mov	w0, #0x0                   	// #0
    c0002508:	94000101 	bl	c000290c <scheduler_join_cpu>
	smp_init();
    c000250c:	940007c8 	bl	c000442c <smp_init>
	gic_init();
    c0002510:	97ffffc9 	bl	c0002434 <gic_init>
	test_framework_init();
    c0002514:	940009c0 	bl	c0004c14 <test_framework_init>
}
    c0002518:	d503201f 	nop
    c000251c:	a8c17bfd 	ldp	x29, x30, [sp], #16
    c0002520:	d65f03c0 	ret

00000000c0002524 <kernel_main>:

void kernel_main(void)
{
    c0002524:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    c0002528:	910003fd 	mov	x29, sp
	print_mini_os_banner();
    c000252c:	97ffffc4 	bl	c000243c <print_mini_os_banner>
    initialize_phase0_modules();
    c0002530:	97fffff1 	bl	c00024f4 <initialize_phase0_modules>
	shell_run();
    c0002534:	9400065b 	bl	c0003ea0 <shell_run>
    c0002538:	d503201f 	nop
    c000253c:	a8c17bfd 	ldp	x29, x30, [sp], #16
    c0002540:	d65f03c0 	ret

00000000c0002544 <bitmap_set_bit>:
#include <kernel/lib/bitmap.h>

#define BITS_PER_WORD (sizeof(unsigned long) * 8U)

void bitmap_set_bit(unsigned long *bitmap, size_t bit)
{
    c0002544:	d10043ff 	sub	sp, sp, #0x10
    c0002548:	f90007e0 	str	x0, [sp, #8]
    c000254c:	f90003e1 	str	x1, [sp]
	bitmap[bit / BITS_PER_WORD] |= (1UL << (bit % BITS_PER_WORD));
    c0002550:	f94003e0 	ldr	x0, [sp]
    c0002554:	d346fc00 	lsr	x0, x0, #6
    c0002558:	d37df001 	lsl	x1, x0, #3
    c000255c:	f94007e2 	ldr	x2, [sp, #8]
    c0002560:	8b010041 	add	x1, x2, x1
    c0002564:	f9400022 	ldr	x2, [x1]
    c0002568:	f94003e1 	ldr	x1, [sp]
    c000256c:	12001421 	and	w1, w1, #0x3f
    c0002570:	d2800023 	mov	x3, #0x1                   	// #1
    c0002574:	9ac12061 	lsl	x1, x3, x1
    c0002578:	d37df000 	lsl	x0, x0, #3
    c000257c:	f94007e3 	ldr	x3, [sp, #8]
    c0002580:	8b000060 	add	x0, x3, x0
    c0002584:	aa010041 	orr	x1, x2, x1
    c0002588:	f9000001 	str	x1, [x0]
}
    c000258c:	d503201f 	nop
    c0002590:	910043ff 	add	sp, sp, #0x10
    c0002594:	d65f03c0 	ret

00000000c0002598 <bitmap_clear_bit>:

void bitmap_clear_bit(unsigned long *bitmap, size_t bit)
{
    c0002598:	d10043ff 	sub	sp, sp, #0x10
    c000259c:	f90007e0 	str	x0, [sp, #8]
    c00025a0:	f90003e1 	str	x1, [sp]
	bitmap[bit / BITS_PER_WORD] &= ~(1UL << (bit % BITS_PER_WORD));
    c00025a4:	f94003e0 	ldr	x0, [sp]
    c00025a8:	d346fc00 	lsr	x0, x0, #6
    c00025ac:	d37df001 	lsl	x1, x0, #3
    c00025b0:	f94007e2 	ldr	x2, [sp, #8]
    c00025b4:	8b010041 	add	x1, x2, x1
    c00025b8:	f9400022 	ldr	x2, [x1]
    c00025bc:	f94003e1 	ldr	x1, [sp]
    c00025c0:	12001421 	and	w1, w1, #0x3f
    c00025c4:	d2800023 	mov	x3, #0x1                   	// #1
    c00025c8:	9ac12061 	lsl	x1, x3, x1
    c00025cc:	aa2103e1 	mvn	x1, x1
    c00025d0:	d37df000 	lsl	x0, x0, #3
    c00025d4:	f94007e3 	ldr	x3, [sp, #8]
    c00025d8:	8b000060 	add	x0, x3, x0
    c00025dc:	8a010041 	and	x1, x2, x1
    c00025e0:	f9000001 	str	x1, [x0]
}
    c00025e4:	d503201f 	nop
    c00025e8:	910043ff 	add	sp, sp, #0x10
    c00025ec:	d65f03c0 	ret

00000000c00025f0 <bitmap_test_bit>:

bool bitmap_test_bit(const unsigned long *bitmap, size_t bit)
{
    c00025f0:	d10043ff 	sub	sp, sp, #0x10
    c00025f4:	f90007e0 	str	x0, [sp, #8]
    c00025f8:	f90003e1 	str	x1, [sp]
	return (bitmap[bit / BITS_PER_WORD] & (1UL << (bit % BITS_PER_WORD))) != 0UL;
    c00025fc:	f94003e0 	ldr	x0, [sp]
    c0002600:	d346fc00 	lsr	x0, x0, #6
    c0002604:	d37df000 	lsl	x0, x0, #3
    c0002608:	f94007e1 	ldr	x1, [sp, #8]
    c000260c:	8b000020 	add	x0, x1, x0
    c0002610:	f9400001 	ldr	x1, [x0]
    c0002614:	f94003e0 	ldr	x0, [sp]
    c0002618:	12001400 	and	w0, w0, #0x3f
    c000261c:	9ac02420 	lsr	x0, x1, x0
    c0002620:	92400000 	and	x0, x0, #0x1
    c0002624:	f100001f 	cmp	x0, #0x0
    c0002628:	1a9f07e0 	cset	w0, ne	// ne = any
    c000262c:	12001c00 	and	w0, w0, #0xff
    c0002630:	910043ff 	add	sp, sp, #0x10
    c0002634:	d65f03c0 	ret

00000000c0002638 <ringbuffer_init>:
#include <kernel/lib/ringbuffer.h>

void ringbuffer_init(struct ringbuffer *rb, uint8_t *storage, size_t capacity)
{
    c0002638:	d10083ff 	sub	sp, sp, #0x20
    c000263c:	f9000fe0 	str	x0, [sp, #24]
    c0002640:	f9000be1 	str	x1, [sp, #16]
    c0002644:	f90007e2 	str	x2, [sp, #8]
	rb->data = storage;
    c0002648:	f9400fe0 	ldr	x0, [sp, #24]
    c000264c:	f9400be1 	ldr	x1, [sp, #16]
    c0002650:	f9000001 	str	x1, [x0]
	rb->capacity = capacity;
    c0002654:	f9400fe0 	ldr	x0, [sp, #24]
    c0002658:	f94007e1 	ldr	x1, [sp, #8]
    c000265c:	f9000401 	str	x1, [x0, #8]
	rb->head = 0U;
    c0002660:	f9400fe0 	ldr	x0, [sp, #24]
    c0002664:	f900081f 	str	xzr, [x0, #16]
	rb->tail = 0U;
    c0002668:	f9400fe0 	ldr	x0, [sp, #24]
    c000266c:	f9000c1f 	str	xzr, [x0, #24]
	rb->count = 0U;
    c0002670:	f9400fe0 	ldr	x0, [sp, #24]
    c0002674:	f900101f 	str	xzr, [x0, #32]
}
    c0002678:	d503201f 	nop
    c000267c:	910083ff 	add	sp, sp, #0x20
    c0002680:	d65f03c0 	ret

00000000c0002684 <ringbuffer_is_empty>:

bool ringbuffer_is_empty(const struct ringbuffer *rb)
{
    c0002684:	d10043ff 	sub	sp, sp, #0x10
    c0002688:	f90007e0 	str	x0, [sp, #8]
	return rb->count == 0U;
    c000268c:	f94007e0 	ldr	x0, [sp, #8]
    c0002690:	f9401000 	ldr	x0, [x0, #32]
    c0002694:	f100001f 	cmp	x0, #0x0
    c0002698:	1a9f17e0 	cset	w0, eq	// eq = none
    c000269c:	12001c00 	and	w0, w0, #0xff
}
    c00026a0:	910043ff 	add	sp, sp, #0x10
    c00026a4:	d65f03c0 	ret

00000000c00026a8 <ringbuffer_is_full>:

bool ringbuffer_is_full(const struct ringbuffer *rb)
{
    c00026a8:	d10043ff 	sub	sp, sp, #0x10
    c00026ac:	f90007e0 	str	x0, [sp, #8]
	return rb->count == rb->capacity;
    c00026b0:	f94007e0 	ldr	x0, [sp, #8]
    c00026b4:	f9401001 	ldr	x1, [x0, #32]
    c00026b8:	f94007e0 	ldr	x0, [sp, #8]
    c00026bc:	f9400400 	ldr	x0, [x0, #8]
    c00026c0:	eb00003f 	cmp	x1, x0
    c00026c4:	1a9f17e0 	cset	w0, eq	// eq = none
    c00026c8:	12001c00 	and	w0, w0, #0xff
}
    c00026cc:	910043ff 	add	sp, sp, #0x10
    c00026d0:	d65f03c0 	ret

00000000c00026d4 <ringbuffer_push>:

bool ringbuffer_push(struct ringbuffer *rb, uint8_t value)
{
    c00026d4:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c00026d8:	910003fd 	mov	x29, sp
    c00026dc:	f9000fe0 	str	x0, [sp, #24]
    c00026e0:	39005fe1 	strb	w1, [sp, #23]
	if (ringbuffer_is_full(rb)) {
    c00026e4:	f9400fe0 	ldr	x0, [sp, #24]
    c00026e8:	97fffff0 	bl	c00026a8 <ringbuffer_is_full>
    c00026ec:	12001c00 	and	w0, w0, #0xff
    c00026f0:	12000000 	and	w0, w0, #0x1
    c00026f4:	7100001f 	cmp	w0, #0x0
    c00026f8:	54000060 	b.eq	c0002704 <ringbuffer_push+0x30>  // b.none
		return false;
    c00026fc:	52800000 	mov	w0, #0x0                   	// #0
    c0002700:	14000018 	b	c0002760 <ringbuffer_push+0x8c>
	}

	rb->data[rb->head] = value;
    c0002704:	f9400fe0 	ldr	x0, [sp, #24]
    c0002708:	f9400001 	ldr	x1, [x0]
    c000270c:	f9400fe0 	ldr	x0, [sp, #24]
    c0002710:	f9400800 	ldr	x0, [x0, #16]
    c0002714:	8b000020 	add	x0, x1, x0
    c0002718:	39405fe1 	ldrb	w1, [sp, #23]
    c000271c:	39000001 	strb	w1, [x0]
	rb->head = (rb->head + 1U) % rb->capacity;
    c0002720:	f9400fe0 	ldr	x0, [sp, #24]
    c0002724:	f9400800 	ldr	x0, [x0, #16]
    c0002728:	91000400 	add	x0, x0, #0x1
    c000272c:	f9400fe1 	ldr	x1, [sp, #24]
    c0002730:	f9400421 	ldr	x1, [x1, #8]
    c0002734:	9ac10802 	udiv	x2, x0, x1
    c0002738:	9b017c41 	mul	x1, x2, x1
    c000273c:	cb010001 	sub	x1, x0, x1
    c0002740:	f9400fe0 	ldr	x0, [sp, #24]
    c0002744:	f9000801 	str	x1, [x0, #16]
	rb->count++;
    c0002748:	f9400fe0 	ldr	x0, [sp, #24]
    c000274c:	f9401000 	ldr	x0, [x0, #32]
    c0002750:	91000401 	add	x1, x0, #0x1
    c0002754:	f9400fe0 	ldr	x0, [sp, #24]
    c0002758:	f9001001 	str	x1, [x0, #32]
	return true;
    c000275c:	52800020 	mov	w0, #0x1                   	// #1
}
    c0002760:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c0002764:	d65f03c0 	ret

00000000c0002768 <ringbuffer_pop>:

bool ringbuffer_pop(struct ringbuffer *rb, uint8_t *value)
{
    c0002768:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c000276c:	910003fd 	mov	x29, sp
    c0002770:	f9000fe0 	str	x0, [sp, #24]
    c0002774:	f9000be1 	str	x1, [sp, #16]
	if (ringbuffer_is_empty(rb)) {
    c0002778:	f9400fe0 	ldr	x0, [sp, #24]
    c000277c:	97ffffc2 	bl	c0002684 <ringbuffer_is_empty>
    c0002780:	12001c00 	and	w0, w0, #0xff
    c0002784:	12000000 	and	w0, w0, #0x1
    c0002788:	7100001f 	cmp	w0, #0x0
    c000278c:	54000060 	b.eq	c0002798 <ringbuffer_pop+0x30>  // b.none
		return false;
    c0002790:	52800000 	mov	w0, #0x0                   	// #0
    c0002794:	14000019 	b	c00027f8 <ringbuffer_pop+0x90>
	}

	*value = rb->data[rb->tail];
    c0002798:	f9400fe0 	ldr	x0, [sp, #24]
    c000279c:	f9400001 	ldr	x1, [x0]
    c00027a0:	f9400fe0 	ldr	x0, [sp, #24]
    c00027a4:	f9400c00 	ldr	x0, [x0, #24]
    c00027a8:	8b000020 	add	x0, x1, x0
    c00027ac:	39400001 	ldrb	w1, [x0]
    c00027b0:	f9400be0 	ldr	x0, [sp, #16]
    c00027b4:	39000001 	strb	w1, [x0]
	rb->tail = (rb->tail + 1U) % rb->capacity;
    c00027b8:	f9400fe0 	ldr	x0, [sp, #24]
    c00027bc:	f9400c00 	ldr	x0, [x0, #24]
    c00027c0:	91000400 	add	x0, x0, #0x1
    c00027c4:	f9400fe1 	ldr	x1, [sp, #24]
    c00027c8:	f9400421 	ldr	x1, [x1, #8]
    c00027cc:	9ac10802 	udiv	x2, x0, x1
    c00027d0:	9b017c41 	mul	x1, x2, x1
    c00027d4:	cb010001 	sub	x1, x0, x1
    c00027d8:	f9400fe0 	ldr	x0, [sp, #24]
    c00027dc:	f9000c01 	str	x1, [x0, #24]
	rb->count--;
    c00027e0:	f9400fe0 	ldr	x0, [sp, #24]
    c00027e4:	f9401000 	ldr	x0, [x0, #32]
    c00027e8:	d1000401 	sub	x1, x0, #0x1
    c00027ec:	f9400fe0 	ldr	x0, [sp, #24]
    c00027f0:	f9001001 	str	x1, [x0, #32]
	return true;
    c00027f4:	52800020 	mov	w0, #0x1                   	// #1
    c00027f8:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c00027fc:	d65f03c0 	ret

00000000c0002800 <mini_os_strlen>:
#include <kernel/lib/string.h>

size_t mini_os_strlen(const char *str)
{
    c0002800:	d10083ff 	sub	sp, sp, #0x20
    c0002804:	f90007e0 	str	x0, [sp, #8]
	size_t len = 0U;
    c0002808:	f9000fff 	str	xzr, [sp, #24]

	if (str == (const char *)0) {
    c000280c:	f94007e0 	ldr	x0, [sp, #8]
    c0002810:	f100001f 	cmp	x0, #0x0
    c0002814:	540000c1 	b.ne	c000282c <mini_os_strlen+0x2c>  // b.any
		return 0U;
    c0002818:	d2800000 	mov	x0, #0x0                   	// #0
    c000281c:	1400000b 	b	c0002848 <mini_os_strlen+0x48>
	}

	while (str[len] != '\0') {
		len++;
    c0002820:	f9400fe0 	ldr	x0, [sp, #24]
    c0002824:	91000400 	add	x0, x0, #0x1
    c0002828:	f9000fe0 	str	x0, [sp, #24]
	while (str[len] != '\0') {
    c000282c:	f94007e1 	ldr	x1, [sp, #8]
    c0002830:	f9400fe0 	ldr	x0, [sp, #24]
    c0002834:	8b000020 	add	x0, x1, x0
    c0002838:	39400000 	ldrb	w0, [x0]
    c000283c:	7100001f 	cmp	w0, #0x0
    c0002840:	54ffff01 	b.ne	c0002820 <mini_os_strlen+0x20>  // b.any
	}

	return len;
    c0002844:	f9400fe0 	ldr	x0, [sp, #24]
}
    c0002848:	910083ff 	add	sp, sp, #0x20
    c000284c:	d65f03c0 	ret

00000000c0002850 <mini_os_strcmp>:

int mini_os_strcmp(const char *lhs, const char *rhs)
{
    c0002850:	d10043ff 	sub	sp, sp, #0x10
    c0002854:	f90007e0 	str	x0, [sp, #8]
    c0002858:	f90003e1 	str	x1, [sp]
	while ((*lhs != '\0') && (*lhs == *rhs)) {
    c000285c:	14000007 	b	c0002878 <mini_os_strcmp+0x28>
		lhs++;
    c0002860:	f94007e0 	ldr	x0, [sp, #8]
    c0002864:	91000400 	add	x0, x0, #0x1
    c0002868:	f90007e0 	str	x0, [sp, #8]
		rhs++;
    c000286c:	f94003e0 	ldr	x0, [sp]
    c0002870:	91000400 	add	x0, x0, #0x1
    c0002874:	f90003e0 	str	x0, [sp]
	while ((*lhs != '\0') && (*lhs == *rhs)) {
    c0002878:	f94007e0 	ldr	x0, [sp, #8]
    c000287c:	39400000 	ldrb	w0, [x0]
    c0002880:	7100001f 	cmp	w0, #0x0
    c0002884:	540000e0 	b.eq	c00028a0 <mini_os_strcmp+0x50>  // b.none
    c0002888:	f94007e0 	ldr	x0, [sp, #8]
    c000288c:	39400001 	ldrb	w1, [x0]
    c0002890:	f94003e0 	ldr	x0, [sp]
    c0002894:	39400000 	ldrb	w0, [x0]
    c0002898:	6b00003f 	cmp	w1, w0
    c000289c:	54fffe20 	b.eq	c0002860 <mini_os_strcmp+0x10>  // b.none
	}

	return (int)(unsigned char)*lhs - (int)(unsigned char)*rhs;
    c00028a0:	f94007e0 	ldr	x0, [sp, #8]
    c00028a4:	39400000 	ldrb	w0, [x0]
    c00028a8:	2a0003e1 	mov	w1, w0
    c00028ac:	f94003e0 	ldr	x0, [sp]
    c00028b0:	39400000 	ldrb	w0, [x0]
    c00028b4:	4b000020 	sub	w0, w1, w0
    c00028b8:	910043ff 	add	sp, sp, #0x10
    c00028bc:	d65f03c0 	ret

00000000c00028c0 <scheduler_init>:
static unsigned long runnable_cpus[((PLAT_MAX_CPUS + (sizeof(unsigned long) * 8U) - 1U) /
	(sizeof(unsigned long) * 8U))];
static unsigned int runnable_cpu_count;

void scheduler_init(void)
{
    c00028c0:	d10043ff 	sub	sp, sp, #0x10
	unsigned int i;

	for (i = 0U; i < (unsigned int)(sizeof(runnable_cpus) / sizeof(runnable_cpus[0])); ++i) {
    c00028c4:	b9000fff 	str	wzr, [sp, #12]
    c00028c8:	14000008 	b	c00028e8 <scheduler_init+0x28>
		runnable_cpus[i] = 0UL;
    c00028cc:	90000020 	adrp	x0, c0006000 <hex.0+0xc88>
    c00028d0:	911c4000 	add	x0, x0, #0x710
    c00028d4:	b9400fe1 	ldr	w1, [sp, #12]
    c00028d8:	f821781f 	str	xzr, [x0, x1, lsl #3]
	for (i = 0U; i < (unsigned int)(sizeof(runnable_cpus) / sizeof(runnable_cpus[0])); ++i) {
    c00028dc:	b9400fe0 	ldr	w0, [sp, #12]
    c00028e0:	11000400 	add	w0, w0, #0x1
    c00028e4:	b9000fe0 	str	w0, [sp, #12]
    c00028e8:	b9400fe0 	ldr	w0, [sp, #12]
    c00028ec:	7100001f 	cmp	w0, #0x0
    c00028f0:	54fffee0 	b.eq	c00028cc <scheduler_init+0xc>  // b.none
	}
	runnable_cpu_count = 0U;
    c00028f4:	90000020 	adrp	x0, c0006000 <hex.0+0xc88>
    c00028f8:	911c6000 	add	x0, x0, #0x718
    c00028fc:	b900001f 	str	wzr, [x0]
}
    c0002900:	d503201f 	nop
    c0002904:	910043ff 	add	sp, sp, #0x10
    c0002908:	d65f03c0 	ret

00000000c000290c <scheduler_join_cpu>:

void scheduler_join_cpu(unsigned int logical_id)
{
    c000290c:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c0002910:	910003fd 	mov	x29, sp
    c0002914:	b9001fe0 	str	w0, [sp, #28]
	if (!bitmap_test_bit(runnable_cpus, logical_id)) {
    c0002918:	b9401fe0 	ldr	w0, [sp, #28]
    c000291c:	aa0003e1 	mov	x1, x0
    c0002920:	90000020 	adrp	x0, c0006000 <hex.0+0xc88>
    c0002924:	911c4000 	add	x0, x0, #0x710
    c0002928:	97ffff32 	bl	c00025f0 <bitmap_test_bit>
    c000292c:	12001c00 	and	w0, w0, #0xff
    c0002930:	52000000 	eor	w0, w0, #0x1
    c0002934:	12001c00 	and	w0, w0, #0xff
    c0002938:	12000000 	and	w0, w0, #0x1
    c000293c:	7100001f 	cmp	w0, #0x0
    c0002940:	540001a0 	b.eq	c0002974 <scheduler_join_cpu+0x68>  // b.none
		bitmap_set_bit(runnable_cpus, logical_id);
    c0002944:	b9401fe0 	ldr	w0, [sp, #28]
    c0002948:	aa0003e1 	mov	x1, x0
    c000294c:	90000020 	adrp	x0, c0006000 <hex.0+0xc88>
    c0002950:	911c4000 	add	x0, x0, #0x710
    c0002954:	97fffefc 	bl	c0002544 <bitmap_set_bit>
		runnable_cpu_count++;
    c0002958:	90000020 	adrp	x0, c0006000 <hex.0+0xc88>
    c000295c:	911c6000 	add	x0, x0, #0x718
    c0002960:	b9400000 	ldr	w0, [x0]
    c0002964:	11000401 	add	w1, w0, #0x1
    c0002968:	90000020 	adrp	x0, c0006000 <hex.0+0xc88>
    c000296c:	911c6000 	add	x0, x0, #0x718
    c0002970:	b9000001 	str	w1, [x0]
	}
}
    c0002974:	d503201f 	nop
    c0002978:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c000297c:	d65f03c0 	ret

00000000c0002980 <scheduler_cpu_is_runnable>:

bool scheduler_cpu_is_runnable(unsigned int logical_id)
{
    c0002980:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c0002984:	910003fd 	mov	x29, sp
    c0002988:	b9001fe0 	str	w0, [sp, #28]
	return bitmap_test_bit(runnable_cpus, logical_id);
    c000298c:	b9401fe0 	ldr	w0, [sp, #28]
    c0002990:	aa0003e1 	mov	x1, x0
    c0002994:	90000020 	adrp	x0, c0006000 <hex.0+0xc88>
    c0002998:	911c4000 	add	x0, x0, #0x710
    c000299c:	97ffff15 	bl	c00025f0 <bitmap_test_bit>
    c00029a0:	12001c00 	and	w0, w0, #0xff
}
    c00029a4:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c00029a8:	d65f03c0 	ret

00000000c00029ac <scheduler_runnable_cpu_count>:

unsigned int scheduler_runnable_cpu_count(void)
{
	return runnable_cpu_count;
    c00029ac:	90000020 	adrp	x0, c0006000 <hex.0+0xc88>
    c00029b0:	911c6000 	add	x0, x0, #0x718
    c00029b4:	b9400000 	ldr	w0, [x0]
    c00029b8:	d65f03c0 	ret

00000000c00029bc <is_space>:
#define MINI_OS_BUILD_YEAR 2026

extern volatile uint64_t boot_magic;

static bool is_space(char ch)
{
    c00029bc:	d10043ff 	sub	sp, sp, #0x10
    c00029c0:	39003fe0 	strb	w0, [sp, #15]
	return (ch == ' ') || (ch == '\t') || (ch == '\r') || (ch == '\n');
    c00029c4:	39403fe0 	ldrb	w0, [sp, #15]
    c00029c8:	7100801f 	cmp	w0, #0x20
    c00029cc:	54000140 	b.eq	c00029f4 <is_space+0x38>  // b.none
    c00029d0:	39403fe0 	ldrb	w0, [sp, #15]
    c00029d4:	7100241f 	cmp	w0, #0x9
    c00029d8:	540000e0 	b.eq	c00029f4 <is_space+0x38>  // b.none
    c00029dc:	39403fe0 	ldrb	w0, [sp, #15]
    c00029e0:	7100341f 	cmp	w0, #0xd
    c00029e4:	54000080 	b.eq	c00029f4 <is_space+0x38>  // b.none
    c00029e8:	39403fe0 	ldrb	w0, [sp, #15]
    c00029ec:	7100281f 	cmp	w0, #0xa
    c00029f0:	54000061 	b.ne	c00029fc <is_space+0x40>  // b.any
    c00029f4:	52800020 	mov	w0, #0x1                   	// #1
    c00029f8:	14000002 	b	c0002a00 <is_space+0x44>
    c00029fc:	52800000 	mov	w0, #0x0                   	// #0
    c0002a00:	12000000 	and	w0, w0, #0x1
    c0002a04:	12001c00 	and	w0, w0, #0xff
}
    c0002a08:	910043ff 	add	sp, sp, #0x10
    c0002a0c:	d65f03c0 	ret

00000000c0002a10 <strings_equal>:

static bool strings_equal(const char *lhs, const char *rhs)
{
    c0002a10:	d10043ff 	sub	sp, sp, #0x10
    c0002a14:	f90007e0 	str	x0, [sp, #8]
    c0002a18:	f90003e1 	str	x1, [sp]
	while ((*lhs != '\0') && (*rhs != '\0')) {
    c0002a1c:	1400000f 	b	c0002a58 <strings_equal+0x48>
		if (*lhs != *rhs) {
    c0002a20:	f94007e0 	ldr	x0, [sp, #8]
    c0002a24:	39400001 	ldrb	w1, [x0]
    c0002a28:	f94003e0 	ldr	x0, [sp]
    c0002a2c:	39400000 	ldrb	w0, [x0]
    c0002a30:	6b00003f 	cmp	w1, w0
    c0002a34:	54000060 	b.eq	c0002a40 <strings_equal+0x30>  // b.none
			return false;
    c0002a38:	52800000 	mov	w0, #0x0                   	// #0
    c0002a3c:	1400001c 	b	c0002aac <strings_equal+0x9c>
		}
		lhs++;
    c0002a40:	f94007e0 	ldr	x0, [sp, #8]
    c0002a44:	91000400 	add	x0, x0, #0x1
    c0002a48:	f90007e0 	str	x0, [sp, #8]
		rhs++;
    c0002a4c:	f94003e0 	ldr	x0, [sp]
    c0002a50:	91000400 	add	x0, x0, #0x1
    c0002a54:	f90003e0 	str	x0, [sp]
	while ((*lhs != '\0') && (*rhs != '\0')) {
    c0002a58:	f94007e0 	ldr	x0, [sp, #8]
    c0002a5c:	39400000 	ldrb	w0, [x0]
    c0002a60:	7100001f 	cmp	w0, #0x0
    c0002a64:	540000a0 	b.eq	c0002a78 <strings_equal+0x68>  // b.none
    c0002a68:	f94003e0 	ldr	x0, [sp]
    c0002a6c:	39400000 	ldrb	w0, [x0]
    c0002a70:	7100001f 	cmp	w0, #0x0
    c0002a74:	54fffd61 	b.ne	c0002a20 <strings_equal+0x10>  // b.any
	}

	return (*lhs == '\0') && (*rhs == '\0');
    c0002a78:	f94007e0 	ldr	x0, [sp, #8]
    c0002a7c:	39400000 	ldrb	w0, [x0]
    c0002a80:	7100001f 	cmp	w0, #0x0
    c0002a84:	540000e1 	b.ne	c0002aa0 <strings_equal+0x90>  // b.any
    c0002a88:	f94003e0 	ldr	x0, [sp]
    c0002a8c:	39400000 	ldrb	w0, [x0]
    c0002a90:	7100001f 	cmp	w0, #0x0
    c0002a94:	54000061 	b.ne	c0002aa0 <strings_equal+0x90>  // b.any
    c0002a98:	52800020 	mov	w0, #0x1                   	// #1
    c0002a9c:	14000002 	b	c0002aa4 <strings_equal+0x94>
    c0002aa0:	52800000 	mov	w0, #0x0                   	// #0
    c0002aa4:	12000000 	and	w0, w0, #0x1
    c0002aa8:	12001c00 	and	w0, w0, #0xff
}
    c0002aac:	910043ff 	add	sp, sp, #0x10
    c0002ab0:	d65f03c0 	ret

00000000c0002ab4 <shell_help_topic_name>:

static const char *shell_help_topic_name(const char *arg)
{
    c0002ab4:	d10043ff 	sub	sp, sp, #0x10
    c0002ab8:	f90007e0 	str	x0, [sp, #8]
	if ((arg == (const char *)0) || (*arg == '\0')) {
    c0002abc:	f94007e0 	ldr	x0, [sp, #8]
    c0002ac0:	f100001f 	cmp	x0, #0x0
    c0002ac4:	540000a0 	b.eq	c0002ad8 <shell_help_topic_name+0x24>  // b.none
    c0002ac8:	f94007e0 	ldr	x0, [sp, #8]
    c0002acc:	39400000 	ldrb	w0, [x0]
    c0002ad0:	7100001f 	cmp	w0, #0x0
    c0002ad4:	54000061 	b.ne	c0002ae0 <shell_help_topic_name+0x2c>  // b.any
		return (const char *)0;
    c0002ad8:	d2800000 	mov	x0, #0x0                   	// #0
    c0002adc:	1400000e 	b	c0002b14 <shell_help_topic_name+0x60>
	}

	if ((arg[0] == '-') && (arg[1] == '-')) {
    c0002ae0:	f94007e0 	ldr	x0, [sp, #8]
    c0002ae4:	39400000 	ldrb	w0, [x0]
    c0002ae8:	7100b41f 	cmp	w0, #0x2d
    c0002aec:	54000121 	b.ne	c0002b10 <shell_help_topic_name+0x5c>  // b.any
    c0002af0:	f94007e0 	ldr	x0, [sp, #8]
    c0002af4:	91000400 	add	x0, x0, #0x1
    c0002af8:	39400000 	ldrb	w0, [x0]
    c0002afc:	7100b41f 	cmp	w0, #0x2d
    c0002b00:	54000081 	b.ne	c0002b10 <shell_help_topic_name+0x5c>  // b.any
		return arg + 2;
    c0002b04:	f94007e0 	ldr	x0, [sp, #8]
    c0002b08:	91000800 	add	x0, x0, #0x2
    c0002b0c:	14000002 	b	c0002b14 <shell_help_topic_name+0x60>
	}

	return arg;
    c0002b10:	f94007e0 	ldr	x0, [sp, #8]
}
    c0002b14:	910043ff 	add	sp, sp, #0x10
    c0002b18:	d65f03c0 	ret

00000000c0002b1c <parse_u64>:

static bool parse_u64(const char *str, uint64_t *value)
{
    c0002b1c:	d100c3ff 	sub	sp, sp, #0x30
    c0002b20:	f90007e0 	str	x0, [sp, #8]
    c0002b24:	f90003e1 	str	x1, [sp]
	uint64_t result = 0U;
    c0002b28:	f90017ff 	str	xzr, [sp, #40]
	unsigned int base = 10U;
    c0002b2c:	52800140 	mov	w0, #0xa                   	// #10
    c0002b30:	b90027e0 	str	w0, [sp, #36]
	char ch;

	if ((str == (const char *)0) || (*str == '\0')) {
    c0002b34:	f94007e0 	ldr	x0, [sp, #8]
    c0002b38:	f100001f 	cmp	x0, #0x0
    c0002b3c:	540000a0 	b.eq	c0002b50 <parse_u64+0x34>  // b.none
    c0002b40:	f94007e0 	ldr	x0, [sp, #8]
    c0002b44:	39400000 	ldrb	w0, [x0]
    c0002b48:	7100001f 	cmp	w0, #0x0
    c0002b4c:	54000061 	b.ne	c0002b58 <parse_u64+0x3c>  // b.any
		return false;
    c0002b50:	52800000 	mov	w0, #0x0                   	// #0
    c0002b54:	14000058 	b	c0002cb4 <parse_u64+0x198>
	}

	if ((str[0] == '0') && ((str[1] == 'x') || (str[1] == 'X'))) {
    c0002b58:	f94007e0 	ldr	x0, [sp, #8]
    c0002b5c:	39400000 	ldrb	w0, [x0]
    c0002b60:	7100c01f 	cmp	w0, #0x30
    c0002b64:	54000201 	b.ne	c0002ba4 <parse_u64+0x88>  // b.any
    c0002b68:	f94007e0 	ldr	x0, [sp, #8]
    c0002b6c:	91000400 	add	x0, x0, #0x1
    c0002b70:	39400000 	ldrb	w0, [x0]
    c0002b74:	7101e01f 	cmp	w0, #0x78
    c0002b78:	540000c0 	b.eq	c0002b90 <parse_u64+0x74>  // b.none
    c0002b7c:	f94007e0 	ldr	x0, [sp, #8]
    c0002b80:	91000400 	add	x0, x0, #0x1
    c0002b84:	39400000 	ldrb	w0, [x0]
    c0002b88:	7101601f 	cmp	w0, #0x58
    c0002b8c:	540000c1 	b.ne	c0002ba4 <parse_u64+0x88>  // b.any
		base = 16U;
    c0002b90:	52800200 	mov	w0, #0x10                  	// #16
    c0002b94:	b90027e0 	str	w0, [sp, #36]
		str += 2;
    c0002b98:	f94007e0 	ldr	x0, [sp, #8]
    c0002b9c:	91000800 	add	x0, x0, #0x2
    c0002ba0:	f90007e0 	str	x0, [sp, #8]
	}
	if (*str == '\0') {
    c0002ba4:	f94007e0 	ldr	x0, [sp, #8]
    c0002ba8:	39400000 	ldrb	w0, [x0]
    c0002bac:	7100001f 	cmp	w0, #0x0
    c0002bb0:	540006a1 	b.ne	c0002c84 <parse_u64+0x168>  // b.any
		return false;
    c0002bb4:	52800000 	mov	w0, #0x0                   	// #0
    c0002bb8:	1400003f 	b	c0002cb4 <parse_u64+0x198>
	}

	while ((ch = *str++) != '\0') {
		unsigned int digit;

		if ((ch >= '0') && (ch <= '9')) {
    c0002bbc:	39407fe0 	ldrb	w0, [sp, #31]
    c0002bc0:	7100bc1f 	cmp	w0, #0x2f
    c0002bc4:	54000109 	b.ls	c0002be4 <parse_u64+0xc8>  // b.plast
    c0002bc8:	39407fe0 	ldrb	w0, [sp, #31]
    c0002bcc:	7100e41f 	cmp	w0, #0x39
    c0002bd0:	540000a8 	b.hi	c0002be4 <parse_u64+0xc8>  // b.pmore
			digit = (unsigned int)(ch - '0');
    c0002bd4:	39407fe0 	ldrb	w0, [sp, #31]
    c0002bd8:	5100c000 	sub	w0, w0, #0x30
    c0002bdc:	b90023e0 	str	w0, [sp, #32]
    c0002be0:	1400001d 	b	c0002c54 <parse_u64+0x138>
		} else if ((base == 16U) && (ch >= 'a') && (ch <= 'f')) {
    c0002be4:	b94027e0 	ldr	w0, [sp, #36]
    c0002be8:	7100401f 	cmp	w0, #0x10
    c0002bec:	54000161 	b.ne	c0002c18 <parse_u64+0xfc>  // b.any
    c0002bf0:	39407fe0 	ldrb	w0, [sp, #31]
    c0002bf4:	7101801f 	cmp	w0, #0x60
    c0002bf8:	54000109 	b.ls	c0002c18 <parse_u64+0xfc>  // b.plast
    c0002bfc:	39407fe0 	ldrb	w0, [sp, #31]
    c0002c00:	7101981f 	cmp	w0, #0x66
    c0002c04:	540000a8 	b.hi	c0002c18 <parse_u64+0xfc>  // b.pmore
			digit = (unsigned int)(ch - 'a') + 10U;
    c0002c08:	39407fe0 	ldrb	w0, [sp, #31]
    c0002c0c:	51015c00 	sub	w0, w0, #0x57
    c0002c10:	b90023e0 	str	w0, [sp, #32]
    c0002c14:	14000010 	b	c0002c54 <parse_u64+0x138>
		} else if ((base == 16U) && (ch >= 'A') && (ch <= 'F')) {
    c0002c18:	b94027e0 	ldr	w0, [sp, #36]
    c0002c1c:	7100401f 	cmp	w0, #0x10
    c0002c20:	54000161 	b.ne	c0002c4c <parse_u64+0x130>  // b.any
    c0002c24:	39407fe0 	ldrb	w0, [sp, #31]
    c0002c28:	7101001f 	cmp	w0, #0x40
    c0002c2c:	54000109 	b.ls	c0002c4c <parse_u64+0x130>  // b.plast
    c0002c30:	39407fe0 	ldrb	w0, [sp, #31]
    c0002c34:	7101181f 	cmp	w0, #0x46
    c0002c38:	540000a8 	b.hi	c0002c4c <parse_u64+0x130>  // b.pmore
			digit = (unsigned int)(ch - 'A') + 10U;
    c0002c3c:	39407fe0 	ldrb	w0, [sp, #31]
    c0002c40:	5100dc00 	sub	w0, w0, #0x37
    c0002c44:	b90023e0 	str	w0, [sp, #32]
    c0002c48:	14000003 	b	c0002c54 <parse_u64+0x138>
		} else {
			return false;
    c0002c4c:	52800000 	mov	w0, #0x0                   	// #0
    c0002c50:	14000019 	b	c0002cb4 <parse_u64+0x198>
		}
		if (digit >= base) {
    c0002c54:	b94023e1 	ldr	w1, [sp, #32]
    c0002c58:	b94027e0 	ldr	w0, [sp, #36]
    c0002c5c:	6b00003f 	cmp	w1, w0
    c0002c60:	54000063 	b.cc	c0002c6c <parse_u64+0x150>  // b.lo, b.ul, b.last
			return false;
    c0002c64:	52800000 	mov	w0, #0x0                   	// #0
    c0002c68:	14000013 	b	c0002cb4 <parse_u64+0x198>
		}
		result = result * base + digit;
    c0002c6c:	b94027e1 	ldr	w1, [sp, #36]
    c0002c70:	f94017e0 	ldr	x0, [sp, #40]
    c0002c74:	9b007c21 	mul	x1, x1, x0
    c0002c78:	b94023e0 	ldr	w0, [sp, #32]
    c0002c7c:	8b000020 	add	x0, x1, x0
    c0002c80:	f90017e0 	str	x0, [sp, #40]
	while ((ch = *str++) != '\0') {
    c0002c84:	f94007e0 	ldr	x0, [sp, #8]
    c0002c88:	91000401 	add	x1, x0, #0x1
    c0002c8c:	f90007e1 	str	x1, [sp, #8]
    c0002c90:	39400000 	ldrb	w0, [x0]
    c0002c94:	39007fe0 	strb	w0, [sp, #31]
    c0002c98:	39407fe0 	ldrb	w0, [sp, #31]
    c0002c9c:	7100001f 	cmp	w0, #0x0
    c0002ca0:	54fff8e1 	b.ne	c0002bbc <parse_u64+0xa0>  // b.any
	}

	*value = result;
    c0002ca4:	f94003e0 	ldr	x0, [sp]
    c0002ca8:	f94017e1 	ldr	x1, [sp, #40]
    c0002cac:	f9000001 	str	x1, [x0]
	return true;
    c0002cb0:	52800020 	mov	w0, #0x1                   	// #1
}
    c0002cb4:	9100c3ff 	add	sp, sp, #0x30
    c0002cb8:	d65f03c0 	ret

00000000c0002cbc <shell_tokenize>:

static int shell_tokenize(char *line, char *argv[], int max_args)
{
    c0002cbc:	a9bc7bfd 	stp	x29, x30, [sp, #-64]!
    c0002cc0:	910003fd 	mov	x29, sp
    c0002cc4:	f90017e0 	str	x0, [sp, #40]
    c0002cc8:	f90013e1 	str	x1, [sp, #32]
    c0002ccc:	b9001fe2 	str	w2, [sp, #28]
	int argc = 0;
    c0002cd0:	b9003fff 	str	wzr, [sp, #60]

	while (*line != '\0') {
    c0002cd4:	1400002e 	b	c0002d8c <shell_tokenize+0xd0>
		while (is_space(*line)) {
			*line++ = '\0';
    c0002cd8:	f94017e0 	ldr	x0, [sp, #40]
    c0002cdc:	91000401 	add	x1, x0, #0x1
    c0002ce0:	f90017e1 	str	x1, [sp, #40]
    c0002ce4:	3900001f 	strb	wzr, [x0]
		while (is_space(*line)) {
    c0002ce8:	f94017e0 	ldr	x0, [sp, #40]
    c0002cec:	39400000 	ldrb	w0, [x0]
    c0002cf0:	97ffff33 	bl	c00029bc <is_space>
    c0002cf4:	12001c00 	and	w0, w0, #0xff
    c0002cf8:	12000000 	and	w0, w0, #0x1
    c0002cfc:	7100001f 	cmp	w0, #0x0
    c0002d00:	54fffec1 	b.ne	c0002cd8 <shell_tokenize+0x1c>  // b.any
		}

		if (*line == '\0') {
    c0002d04:	f94017e0 	ldr	x0, [sp, #40]
    c0002d08:	39400000 	ldrb	w0, [x0]
    c0002d0c:	7100001f 	cmp	w0, #0x0
    c0002d10:	54000480 	b.eq	c0002da0 <shell_tokenize+0xe4>  // b.none
			break;
		}

		if (argc >= max_args) {
    c0002d14:	b9403fe1 	ldr	w1, [sp, #60]
    c0002d18:	b9401fe0 	ldr	w0, [sp, #28]
    c0002d1c:	6b00003f 	cmp	w1, w0
    c0002d20:	5400044a 	b.ge	c0002da8 <shell_tokenize+0xec>  // b.tcont
			break;
		}

		argv[argc++] = line;
    c0002d24:	b9403fe0 	ldr	w0, [sp, #60]
    c0002d28:	11000401 	add	w1, w0, #0x1
    c0002d2c:	b9003fe1 	str	w1, [sp, #60]
    c0002d30:	93407c00 	sxtw	x0, w0
    c0002d34:	d37df000 	lsl	x0, x0, #3
    c0002d38:	f94013e1 	ldr	x1, [sp, #32]
    c0002d3c:	8b000020 	add	x0, x1, x0
    c0002d40:	f94017e1 	ldr	x1, [sp, #40]
    c0002d44:	f9000001 	str	x1, [x0]
		while ((*line != '\0') && !is_space(*line)) {
    c0002d48:	14000004 	b	c0002d58 <shell_tokenize+0x9c>
			line++;
    c0002d4c:	f94017e0 	ldr	x0, [sp, #40]
    c0002d50:	91000400 	add	x0, x0, #0x1
    c0002d54:	f90017e0 	str	x0, [sp, #40]
		while ((*line != '\0') && !is_space(*line)) {
    c0002d58:	f94017e0 	ldr	x0, [sp, #40]
    c0002d5c:	39400000 	ldrb	w0, [x0]
    c0002d60:	7100001f 	cmp	w0, #0x0
    c0002d64:	54000140 	b.eq	c0002d8c <shell_tokenize+0xd0>  // b.none
    c0002d68:	f94017e0 	ldr	x0, [sp, #40]
    c0002d6c:	39400000 	ldrb	w0, [x0]
    c0002d70:	97ffff13 	bl	c00029bc <is_space>
    c0002d74:	12001c00 	and	w0, w0, #0xff
    c0002d78:	52000000 	eor	w0, w0, #0x1
    c0002d7c:	12001c00 	and	w0, w0, #0xff
    c0002d80:	12000000 	and	w0, w0, #0x1
    c0002d84:	7100001f 	cmp	w0, #0x0
    c0002d88:	54fffe21 	b.ne	c0002d4c <shell_tokenize+0x90>  // b.any
	while (*line != '\0') {
    c0002d8c:	f94017e0 	ldr	x0, [sp, #40]
    c0002d90:	39400000 	ldrb	w0, [x0]
    c0002d94:	7100001f 	cmp	w0, #0x0
    c0002d98:	54fffa81 	b.ne	c0002ce8 <shell_tokenize+0x2c>  // b.any
    c0002d9c:	14000004 	b	c0002dac <shell_tokenize+0xf0>
			break;
    c0002da0:	d503201f 	nop
    c0002da4:	14000002 	b	c0002dac <shell_tokenize+0xf0>
			break;
    c0002da8:	d503201f 	nop
		}
	}

	return argc;
    c0002dac:	b9403fe0 	ldr	w0, [sp, #60]
}
    c0002db0:	a8c47bfd 	ldp	x29, x30, [sp], #64
    c0002db4:	d65f03c0 	ret

00000000c0002db8 <shell_print_cpu_entry>:

static void shell_print_cpu_entry(unsigned int logical_id)
{
    c0002db8:	d10143ff 	sub	sp, sp, #0x50
    c0002dbc:	a9027bfd 	stp	x29, x30, [sp, #32]
    c0002dc0:	910083fd 	add	x29, sp, #0x20
    c0002dc4:	b9003fe0 	str	w0, [sp, #60]
	const struct cpu_topology_descriptor *cpu = topology_cpu(logical_id);
    c0002dc8:	b9403fe0 	ldr	w0, [sp, #60]
    c0002dcc:	9400081d 	bl	c0004e40 <topology_cpu>
    c0002dd0:	f90027e0 	str	x0, [sp, #72]
	const struct smp_cpu_state *state = smp_cpu_state(logical_id);
    c0002dd4:	b9403fe0 	ldr	w0, [sp, #60]
    c0002dd8:	9400071e 	bl	c0004a50 <smp_cpu_state>
    c0002ddc:	f90023e0 	str	x0, [sp, #64]

	if ((cpu == (const struct cpu_topology_descriptor *)0) ||
    c0002de0:	f94027e0 	ldr	x0, [sp, #72]
    c0002de4:	f100001f 	cmp	x0, #0x0
    c0002de8:	54000940 	b.eq	c0002f10 <shell_print_cpu_entry+0x158>  // b.none
    c0002dec:	f94023e0 	ldr	x0, [sp, #64]
    c0002df0:	f100001f 	cmp	x0, #0x0
    c0002df4:	540008e0 	b.eq	c0002f10 <shell_print_cpu_entry+0x158>  // b.none
	    (state == (const struct smp_cpu_state *)0) ||
	    !cpu->present) {
    c0002df8:	f94027e0 	ldr	x0, [sp, #72]
    c0002dfc:	39407400 	ldrb	w0, [x0, #29]
    c0002e00:	52000000 	eor	w0, w0, #0x1
    c0002e04:	12001c00 	and	w0, w0, #0xff
	    (state == (const struct smp_cpu_state *)0) ||
    c0002e08:	12000000 	and	w0, w0, #0x1
    c0002e0c:	7100001f 	cmp	w0, #0x0
    c0002e10:	54000801 	b.ne	c0002f10 <shell_print_cpu_entry+0x158>  // b.any
		return;
	}

	mini_os_printf("cpu%-2u mpidr=0x%llx chip=%u die=%u cluster=%u core=%u online=%s scheduled=%s pending=%s boot=%s\n",
		       cpu->logical_id,
    c0002e14:	f94027e0 	ldr	x0, [sp, #72]
    c0002e18:	b9400808 	ldr	w8, [x0, #8]
		       (unsigned long long)cpu->mpidr,
    c0002e1c:	f94027e0 	ldr	x0, [sp, #72]
    c0002e20:	f9400009 	ldr	x9, [x0]
		       cpu->chip_id,
    c0002e24:	f94027e0 	ldr	x0, [sp, #72]
    c0002e28:	b9400c0a 	ldr	w10, [x0, #12]
		       cpu->die_id,
    c0002e2c:	f94027e0 	ldr	x0, [sp, #72]
    c0002e30:	b9401004 	ldr	w4, [x0, #16]
		       cpu->cluster_id,
    c0002e34:	f94027e0 	ldr	x0, [sp, #72]
    c0002e38:	b9401405 	ldr	w5, [x0, #20]
		       cpu->core_id,
    c0002e3c:	f94027e0 	ldr	x0, [sp, #72]
    c0002e40:	b9401806 	ldr	w6, [x0, #24]
		       state->online ? "yes" : "no",
    c0002e44:	f94023e0 	ldr	x0, [sp, #64]
    c0002e48:	39404000 	ldrb	w0, [x0, #16]
	mini_os_printf("cpu%-2u mpidr=0x%llx chip=%u die=%u cluster=%u core=%u online=%s scheduled=%s pending=%s boot=%s\n",
    c0002e4c:	12000000 	and	w0, w0, #0x1
    c0002e50:	7100001f 	cmp	w0, #0x0
    c0002e54:	54000080 	b.eq	c0002e64 <shell_print_cpu_entry+0xac>  // b.none
    c0002e58:	f0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0002e5c:	91162003 	add	x3, x0, #0x588
    c0002e60:	14000003 	b	c0002e6c <shell_print_cpu_entry+0xb4>
    c0002e64:	f0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0002e68:	91164003 	add	x3, x0, #0x590
		       state->scheduled ? "yes" : "no",
    c0002e6c:	f94023e0 	ldr	x0, [sp, #64]
    c0002e70:	39404400 	ldrb	w0, [x0, #17]
	mini_os_printf("cpu%-2u mpidr=0x%llx chip=%u die=%u cluster=%u core=%u online=%s scheduled=%s pending=%s boot=%s\n",
    c0002e74:	12000000 	and	w0, w0, #0x1
    c0002e78:	7100001f 	cmp	w0, #0x0
    c0002e7c:	54000080 	b.eq	c0002e8c <shell_print_cpu_entry+0xd4>  // b.none
    c0002e80:	f0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0002e84:	91162000 	add	x0, x0, #0x588
    c0002e88:	14000003 	b	c0002e94 <shell_print_cpu_entry+0xdc>
    c0002e8c:	f0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0002e90:	91164000 	add	x0, x0, #0x590
		       state->pending ? "yes" : "no",
    c0002e94:	f94023e1 	ldr	x1, [sp, #64]
    c0002e98:	39404821 	ldrb	w1, [x1, #18]
	mini_os_printf("cpu%-2u mpidr=0x%llx chip=%u die=%u cluster=%u core=%u online=%s scheduled=%s pending=%s boot=%s\n",
    c0002e9c:	12000021 	and	w1, w1, #0x1
    c0002ea0:	7100003f 	cmp	w1, #0x0
    c0002ea4:	54000080 	b.eq	c0002eb4 <shell_print_cpu_entry+0xfc>  // b.none
    c0002ea8:	f0000001 	adrp	x1, c0005000 <topology_mark_cpu_online+0xcc>
    c0002eac:	91162021 	add	x1, x1, #0x588
    c0002eb0:	14000003 	b	c0002ebc <shell_print_cpu_entry+0x104>
    c0002eb4:	f0000001 	adrp	x1, c0005000 <topology_mark_cpu_online+0xcc>
    c0002eb8:	91164021 	add	x1, x1, #0x590
		       cpu->boot_cpu ? "yes" : "no");
    c0002ebc:	f94027e2 	ldr	x2, [sp, #72]
    c0002ec0:	39407042 	ldrb	w2, [x2, #28]
	mini_os_printf("cpu%-2u mpidr=0x%llx chip=%u die=%u cluster=%u core=%u online=%s scheduled=%s pending=%s boot=%s\n",
    c0002ec4:	12000042 	and	w2, w2, #0x1
    c0002ec8:	7100005f 	cmp	w2, #0x0
    c0002ecc:	54000080 	b.eq	c0002edc <shell_print_cpu_entry+0x124>  // b.none
    c0002ed0:	f0000002 	adrp	x2, c0005000 <topology_mark_cpu_online+0xcc>
    c0002ed4:	91162042 	add	x2, x2, #0x588
    c0002ed8:	14000003 	b	c0002ee4 <shell_print_cpu_entry+0x12c>
    c0002edc:	f0000002 	adrp	x2, c0005000 <topology_mark_cpu_online+0xcc>
    c0002ee0:	91164042 	add	x2, x2, #0x590
    c0002ee4:	f9000be2 	str	x2, [sp, #16]
    c0002ee8:	f90007e1 	str	x1, [sp, #8]
    c0002eec:	f90003e0 	str	x0, [sp]
    c0002ef0:	aa0303e7 	mov	x7, x3
    c0002ef4:	2a0a03e3 	mov	w3, w10
    c0002ef8:	aa0903e2 	mov	x2, x9
    c0002efc:	2a0803e1 	mov	w1, w8
    c0002f00:	f0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0002f04:	91166000 	add	x0, x0, #0x598
    c0002f08:	97fffb6d 	bl	c0001cbc <mini_os_printf>
    c0002f0c:	14000002 	b	c0002f14 <shell_print_cpu_entry+0x15c>
		return;
    c0002f10:	d503201f 	nop
}
    c0002f14:	a9427bfd 	ldp	x29, x30, [sp, #32]
    c0002f18:	910143ff 	add	sp, sp, #0x50
    c0002f1c:	d65f03c0 	ret

00000000c0002f20 <shell_print_help_overview>:

static void shell_print_help_overview(void)
{
    c0002f20:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    c0002f24:	910003fd 	mov	x29, sp
	mini_os_printf("Built-in commands:\n");
    c0002f28:	f0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0002f2c:	91180000 	add	x0, x0, #0x600
    c0002f30:	97fffb63 	bl	c0001cbc <mini_os_printf>
	mini_os_printf("  help [--topic]    Show command help or detailed help for one topic\n");
    c0002f34:	f0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0002f38:	91186000 	add	x0, x0, #0x618
    c0002f3c:	97fffb60 	bl	c0001cbc <mini_os_printf>
	mini_os_printf("  version           Show OS version information\n");
    c0002f40:	f0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0002f44:	91198000 	add	x0, x0, #0x660
    c0002f48:	97fffb5d 	bl	c0001cbc <mini_os_printf>
	mini_os_printf("  info              Show current platform/runtime info\n");
    c0002f4c:	f0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0002f50:	911a6000 	add	x0, x0, #0x698
    c0002f54:	97fffb5a 	bl	c0001cbc <mini_os_printf>
	mini_os_printf("  cpu [id]          Show CPU information\n");
    c0002f58:	f0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0002f5c:	911b4000 	add	x0, x0, #0x6d0
    c0002f60:	97fffb57 	bl	c0001cbc <mini_os_printf>
	mini_os_printf("  cpus              List known CPUs\n");
    c0002f64:	f0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0002f68:	911c0000 	add	x0, x0, #0x700
    c0002f6c:	97fffb54 	bl	c0001cbc <mini_os_printf>
	mini_os_printf("  topo              Show topology summary\n");
    c0002f70:	f0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0002f74:	911ca000 	add	x0, x0, #0x728
    c0002f78:	97fffb51 	bl	c0001cbc <mini_os_printf>
	mini_os_printf("  smp status        Show SMP status\n");
    c0002f7c:	f0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0002f80:	911d6000 	add	x0, x0, #0x758
    c0002f84:	97fffb4e 	bl	c0001cbc <mini_os_printf>
	mini_os_printf("  smp start <mpidr> Ask TF-A via SMC/PSCI to start a secondary CPU\n");
    c0002f88:	f0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0002f8c:	911e0000 	add	x0, x0, #0x780
    c0002f90:	97fffb4b 	bl	c0001cbc <mini_os_printf>
	mini_os_printf("  echo ...          Print arguments back to the console\n");
    c0002f94:	f0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0002f98:	911f2000 	add	x0, x0, #0x7c8
    c0002f9c:	97fffb48 	bl	c0001cbc <mini_os_printf>
	mini_os_printf("  clear             Clear the terminal screen\n");
    c0002fa0:	f0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0002fa4:	91202000 	add	x0, x0, #0x808
    c0002fa8:	97fffb45 	bl	c0001cbc <mini_os_printf>
	mini_os_printf("  uname             Print the OS name\n");
    c0002fac:	f0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0002fb0:	9120e000 	add	x0, x0, #0x838
    c0002fb4:	97fffb42 	bl	c0001cbc <mini_os_printf>
	mini_os_printf("  halt              Stop the CPU in a low-power wait loop\n");
    c0002fb8:	f0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0002fbc:	91218000 	add	x0, x0, #0x860
    c0002fc0:	97fffb3f 	bl	c0001cbc <mini_os_printf>
	mini_os_printf("Examples: help --cpus, help --smp, help --topo\n");
    c0002fc4:	f0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0002fc8:	91228000 	add	x0, x0, #0x8a0
    c0002fcc:	97fffb3c 	bl	c0001cbc <mini_os_printf>
}
    c0002fd0:	d503201f 	nop
    c0002fd4:	a8c17bfd 	ldp	x29, x30, [sp], #16
    c0002fd8:	d65f03c0 	ret

00000000c0002fdc <shell_print_help_topic>:

static void shell_print_help_topic(const char *topic)
{
    c0002fdc:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c0002fe0:	910003fd 	mov	x29, sp
    c0002fe4:	f9000fe0 	str	x0, [sp, #24]
	if ((topic == (const char *)0) || strings_equal(topic, "help")) {
    c0002fe8:	f9400fe0 	ldr	x0, [sp, #24]
    c0002fec:	f100001f 	cmp	x0, #0x0
    c0002ff0:	54000120 	b.eq	c0003014 <shell_print_help_topic+0x38>  // b.none
    c0002ff4:	f0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0002ff8:	91234001 	add	x1, x0, #0x8d0
    c0002ffc:	f9400fe0 	ldr	x0, [sp, #24]
    c0003000:	97fffe84 	bl	c0002a10 <strings_equal>
    c0003004:	12001c00 	and	w0, w0, #0xff
    c0003008:	12000000 	and	w0, w0, #0x1
    c000300c:	7100001f 	cmp	w0, #0x0
    c0003010:	54000280 	b.eq	c0003060 <shell_print_help_topic+0x84>  // b.none
		mini_os_printf("help [--topic]\n");
    c0003014:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0003018:	91236000 	add	x0, x0, #0x8d8
    c000301c:	97fffb28 	bl	c0001cbc <mini_os_printf>
		mini_os_printf("  Show the command list or detailed help for a single topic.\n");
    c0003020:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0003024:	9123a000 	add	x0, x0, #0x8e8
    c0003028:	97fffb25 	bl	c0001cbc <mini_os_printf>
		mini_os_printf("Examples:\n");
    c000302c:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0003030:	9124a000 	add	x0, x0, #0x928
    c0003034:	97fffb22 	bl	c0001cbc <mini_os_printf>
		mini_os_printf("  help\n");
    c0003038:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c000303c:	9124e000 	add	x0, x0, #0x938
    c0003040:	97fffb1f 	bl	c0001cbc <mini_os_printf>
		mini_os_printf("  help --cpus\n");
    c0003044:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0003048:	91250000 	add	x0, x0, #0x940
    c000304c:	97fffb1c 	bl	c0001cbc <mini_os_printf>
		mini_os_printf("  help --smp\n");
    c0003050:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0003054:	91254000 	add	x0, x0, #0x950
    c0003058:	97fffb19 	bl	c0001cbc <mini_os_printf>
		return;
    c000305c:	140000fb 	b	c0003448 <shell_print_help_topic+0x46c>
	}

	if (strings_equal(topic, "cpu")) {
    c0003060:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0003064:	91258001 	add	x1, x0, #0x960
    c0003068:	f9400fe0 	ldr	x0, [sp, #24]
    c000306c:	97fffe69 	bl	c0002a10 <strings_equal>
    c0003070:	12001c00 	and	w0, w0, #0xff
    c0003074:	12000000 	and	w0, w0, #0x1
    c0003078:	7100001f 	cmp	w0, #0x0
    c000307c:	540002e0 	b.eq	c00030d8 <shell_print_help_topic+0xfc>  // b.none
		mini_os_printf("cpu [id]\n");
    c0003080:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0003084:	9125a000 	add	x0, x0, #0x968
    c0003088:	97fffb0d 	bl	c0001cbc <mini_os_printf>
		mini_os_printf("  Show one logical CPU entry from the topology/SMP tables.\n");
    c000308c:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0003090:	9125e000 	add	x0, x0, #0x978
    c0003094:	97fffb0a 	bl	c0001cbc <mini_os_printf>
		mini_os_printf("  If no id is given, it prints the current boot CPU entry.\n");
    c0003098:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c000309c:	9126e000 	add	x0, x0, #0x9b8
    c00030a0:	97fffb07 	bl	c0001cbc <mini_os_printf>
		mini_os_printf("Examples:\n");
    c00030a4:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c00030a8:	9124a000 	add	x0, x0, #0x928
    c00030ac:	97fffb04 	bl	c0001cbc <mini_os_printf>
		mini_os_printf("  cpu\n");
    c00030b0:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c00030b4:	9127e000 	add	x0, x0, #0x9f8
    c00030b8:	97fffb01 	bl	c0001cbc <mini_os_printf>
		mini_os_printf("  cpu 0\n");
    c00030bc:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c00030c0:	91280000 	add	x0, x0, #0xa00
    c00030c4:	97fffafe 	bl	c0001cbc <mini_os_printf>
		mini_os_printf("  cpu 1\n");
    c00030c8:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c00030cc:	91284000 	add	x0, x0, #0xa10
    c00030d0:	97fffafb 	bl	c0001cbc <mini_os_printf>
		return;
    c00030d4:	140000dd 	b	c0003448 <shell_print_help_topic+0x46c>
	}

	if (strings_equal(topic, "cpus")) {
    c00030d8:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c00030dc:	91288001 	add	x1, x0, #0xa20
    c00030e0:	f9400fe0 	ldr	x0, [sp, #24]
    c00030e4:	97fffe4b 	bl	c0002a10 <strings_equal>
    c00030e8:	12001c00 	and	w0, w0, #0xff
    c00030ec:	12000000 	and	w0, w0, #0x1
    c00030f0:	7100001f 	cmp	w0, #0x0
    c00030f4:	54000280 	b.eq	c0003144 <shell_print_help_topic+0x168>  // b.none
		mini_os_printf("cpus\n");
    c00030f8:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c00030fc:	9128a000 	add	x0, x0, #0xa28
    c0003100:	97fffaef 	bl	c0001cbc <mini_os_printf>
		mini_os_printf("  List all CPUs that are currently registered in the topology table.\n");
    c0003104:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0003108:	9128c000 	add	x0, x0, #0xa30
    c000310c:	97fffaec 	bl	c0001cbc <mini_os_printf>
		mini_os_printf("  The line shows mpidr/chip/die/cluster/core plus online, scheduled, pending and boot flags.\n");
    c0003110:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0003114:	9129e000 	add	x0, x0, #0xa78
    c0003118:	97fffae9 	bl	c0001cbc <mini_os_printf>
		mini_os_printf("Examples:\n");
    c000311c:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0003120:	9124a000 	add	x0, x0, #0x928
    c0003124:	97fffae6 	bl	c0001cbc <mini_os_printf>
		mini_os_printf("  cpus\n");
    c0003128:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c000312c:	912b6000 	add	x0, x0, #0xad8
    c0003130:	97fffae3 	bl	c0001cbc <mini_os_printf>
		mini_os_printf("  help --cpu\n");
    c0003134:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0003138:	912b8000 	add	x0, x0, #0xae0
    c000313c:	97fffae0 	bl	c0001cbc <mini_os_printf>
		return;
    c0003140:	140000c2 	b	c0003448 <shell_print_help_topic+0x46c>
	}

	if (strings_equal(topic, "topo")) {
    c0003144:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0003148:	912bc001 	add	x1, x0, #0xaf0
    c000314c:	f9400fe0 	ldr	x0, [sp, #24]
    c0003150:	97fffe30 	bl	c0002a10 <strings_equal>
    c0003154:	12001c00 	and	w0, w0, #0xff
    c0003158:	12000000 	and	w0, w0, #0x1
    c000315c:	7100001f 	cmp	w0, #0x0
    c0003160:	54000220 	b.eq	c00031a4 <shell_print_help_topic+0x1c8>  // b.none
		mini_os_printf("topo\n");
    c0003164:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0003168:	912be000 	add	x0, x0, #0xaf8
    c000316c:	97fffad4 	bl	c0001cbc <mini_os_printf>
		mini_os_printf("  Print a compact topology summary for the boot CPU and current CPU counts.\n");
    c0003170:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0003174:	912c0000 	add	x0, x0, #0xb00
    c0003178:	97fffad1 	bl	c0001cbc <mini_os_printf>
		mini_os_printf("  Useful for checking the boot MPIDR and the decoded chip/die/cluster/core affinity.\n");
    c000317c:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0003180:	912d4000 	add	x0, x0, #0xb50
    c0003184:	97ffface 	bl	c0001cbc <mini_os_printf>
		mini_os_printf("Examples:\n");
    c0003188:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c000318c:	9124a000 	add	x0, x0, #0x928
    c0003190:	97fffacb 	bl	c0001cbc <mini_os_printf>
		mini_os_printf("  topo\n");
    c0003194:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0003198:	912ea000 	add	x0, x0, #0xba8
    c000319c:	97fffac8 	bl	c0001cbc <mini_os_printf>
		return;
    c00031a0:	140000aa 	b	c0003448 <shell_print_help_topic+0x46c>
	}

	if (strings_equal(topic, "smp")) {
    c00031a4:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c00031a8:	912ec001 	add	x1, x0, #0xbb0
    c00031ac:	f9400fe0 	ldr	x0, [sp, #24]
    c00031b0:	97fffe18 	bl	c0002a10 <strings_equal>
    c00031b4:	12001c00 	and	w0, w0, #0xff
    c00031b8:	12000000 	and	w0, w0, #0x1
    c00031bc:	7100001f 	cmp	w0, #0x0
    c00031c0:	540003a0 	b.eq	c0003234 <shell_print_help_topic+0x258>  // b.none
		mini_os_printf("smp status\n");
    c00031c4:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c00031c8:	912ee000 	add	x0, x0, #0xbb8
    c00031cc:	97fffabc 	bl	c0001cbc <mini_os_printf>
		mini_os_printf("  Show the same per-CPU runtime table as 'cpus'.\n");
    c00031d0:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c00031d4:	912f2000 	add	x0, x0, #0xbc8
    c00031d8:	97fffab9 	bl	c0001cbc <mini_os_printf>
		mini_os_printf("smp start <mpidr>\n");
    c00031dc:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c00031e0:	91300000 	add	x0, x0, #0xc00
    c00031e4:	97fffab6 	bl	c0001cbc <mini_os_printf>
		mini_os_printf("  Ask TF-A/BL31 through SMC/PSCI CPU_ON to start the target CPU identified by MPIDR.\n");
    c00031e8:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c00031ec:	91306000 	add	x0, x0, #0xc18
    c00031f0:	97fffab3 	bl	c0001cbc <mini_os_printf>
		mini_os_printf("  The shell passes TF-A the target MPIDR and the mini-OS secondary entry address.\n");
    c00031f4:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c00031f8:	9131c000 	add	x0, x0, #0xc70
    c00031fc:	97fffab0 	bl	c0001cbc <mini_os_printf>
		mini_os_printf("Examples:\n");
    c0003200:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0003204:	9124a000 	add	x0, x0, #0x928
    c0003208:	97fffaad 	bl	c0001cbc <mini_os_printf>
		mini_os_printf("  smp status\n");
    c000320c:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0003210:	91332000 	add	x0, x0, #0xcc8
    c0003214:	97fffaaa 	bl	c0001cbc <mini_os_printf>
		mini_os_printf("  smp start 0x80000001\n");
    c0003218:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c000321c:	91336000 	add	x0, x0, #0xcd8
    c0003220:	97fffaa7 	bl	c0001cbc <mini_os_printf>
		mini_os_printf("  smp start 2147483649\n");
    c0003224:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0003228:	9133c000 	add	x0, x0, #0xcf0
    c000322c:	97fffaa4 	bl	c0001cbc <mini_os_printf>
		return;
    c0003230:	14000086 	b	c0003448 <shell_print_help_topic+0x46c>
	}

	if (strings_equal(topic, "info")) {
    c0003234:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0003238:	91342001 	add	x1, x0, #0xd08
    c000323c:	f9400fe0 	ldr	x0, [sp, #24]
    c0003240:	97fffdf4 	bl	c0002a10 <strings_equal>
    c0003244:	12001c00 	and	w0, w0, #0xff
    c0003248:	12000000 	and	w0, w0, #0x1
    c000324c:	7100001f 	cmp	w0, #0x0
    c0003250:	540001c0 	b.eq	c0003288 <shell_print_help_topic+0x2ac>  // b.none
		mini_os_printf("info\n");
    c0003254:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0003258:	91344000 	add	x0, x0, #0xd10
    c000325c:	97fffa98 	bl	c0001cbc <mini_os_printf>
		mini_os_printf("  Show platform-level runtime information such as UART base, load address, boot magic and runnable CPU count.\n");
    c0003260:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0003264:	91346000 	add	x0, x0, #0xd18
    c0003268:	97fffa95 	bl	c0001cbc <mini_os_printf>
		mini_os_printf("Example:\n");
    c000326c:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0003270:	91362000 	add	x0, x0, #0xd88
    c0003274:	97fffa92 	bl	c0001cbc <mini_os_printf>
		mini_os_printf("  info\n");
    c0003278:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c000327c:	91366000 	add	x0, x0, #0xd98
    c0003280:	97fffa8f 	bl	c0001cbc <mini_os_printf>
		return;
    c0003284:	14000071 	b	c0003448 <shell_print_help_topic+0x46c>
	}

	if (strings_equal(topic, "version")) {
    c0003288:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c000328c:	91368001 	add	x1, x0, #0xda0
    c0003290:	f9400fe0 	ldr	x0, [sp, #24]
    c0003294:	97fffddf 	bl	c0002a10 <strings_equal>
    c0003298:	12001c00 	and	w0, w0, #0xff
    c000329c:	12000000 	and	w0, w0, #0x1
    c00032a0:	7100001f 	cmp	w0, #0x0
    c00032a4:	540001c0 	b.eq	c00032dc <shell_print_help_topic+0x300>  // b.none
		mini_os_printf("version\n");
    c00032a8:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c00032ac:	9136a000 	add	x0, x0, #0xda8
    c00032b0:	97fffa83 	bl	c0001cbc <mini_os_printf>
		mini_os_printf("  Show the Mini-OS name, version string and build year.\n");
    c00032b4:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c00032b8:	9136e000 	add	x0, x0, #0xdb8
    c00032bc:	97fffa80 	bl	c0001cbc <mini_os_printf>
		mini_os_printf("Example:\n");
    c00032c0:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c00032c4:	91362000 	add	x0, x0, #0xd88
    c00032c8:	97fffa7d 	bl	c0001cbc <mini_os_printf>
		mini_os_printf("  version\n");
    c00032cc:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c00032d0:	9137e000 	add	x0, x0, #0xdf8
    c00032d4:	97fffa7a 	bl	c0001cbc <mini_os_printf>
		return;
    c00032d8:	1400005c 	b	c0003448 <shell_print_help_topic+0x46c>
	}

	if (strings_equal(topic, "echo")) {
    c00032dc:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c00032e0:	91382001 	add	x1, x0, #0xe08
    c00032e4:	f9400fe0 	ldr	x0, [sp, #24]
    c00032e8:	97fffdca 	bl	c0002a10 <strings_equal>
    c00032ec:	12001c00 	and	w0, w0, #0xff
    c00032f0:	12000000 	and	w0, w0, #0x1
    c00032f4:	7100001f 	cmp	w0, #0x0
    c00032f8:	540001c0 	b.eq	c0003330 <shell_print_help_topic+0x354>  // b.none
		mini_os_printf("echo <text...>\n");
    c00032fc:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0003300:	91384000 	add	x0, x0, #0xe10
    c0003304:	97fffa6e 	bl	c0001cbc <mini_os_printf>
		mini_os_printf("  Print the provided arguments back to the serial console.\n");
    c0003308:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c000330c:	91388000 	add	x0, x0, #0xe20
    c0003310:	97fffa6b 	bl	c0001cbc <mini_os_printf>
		mini_os_printf("Example:\n");
    c0003314:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0003318:	91362000 	add	x0, x0, #0xd88
    c000331c:	97fffa68 	bl	c0001cbc <mini_os_printf>
		mini_os_printf("  echo hello mini-os\n");
    c0003320:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0003324:	91398000 	add	x0, x0, #0xe60
    c0003328:	97fffa65 	bl	c0001cbc <mini_os_printf>
		return;
    c000332c:	14000047 	b	c0003448 <shell_print_help_topic+0x46c>
	}

	if (strings_equal(topic, "clear")) {
    c0003330:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0003334:	9139e001 	add	x1, x0, #0xe78
    c0003338:	f9400fe0 	ldr	x0, [sp, #24]
    c000333c:	97fffdb5 	bl	c0002a10 <strings_equal>
    c0003340:	12001c00 	and	w0, w0, #0xff
    c0003344:	12000000 	and	w0, w0, #0x1
    c0003348:	7100001f 	cmp	w0, #0x0
    c000334c:	540001c0 	b.eq	c0003384 <shell_print_help_topic+0x3a8>  // b.none
		mini_os_printf("clear\n");
    c0003350:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0003354:	913a0000 	add	x0, x0, #0xe80
    c0003358:	97fffa59 	bl	c0001cbc <mini_os_printf>
		mini_os_printf("  Send ANSI escape sequences to clear the serial terminal and move the cursor to the top-left corner.\n");
    c000335c:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0003360:	913a2000 	add	x0, x0, #0xe88
    c0003364:	97fffa56 	bl	c0001cbc <mini_os_printf>
		mini_os_printf("Example:\n");
    c0003368:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c000336c:	91362000 	add	x0, x0, #0xd88
    c0003370:	97fffa53 	bl	c0001cbc <mini_os_printf>
		mini_os_printf("  clear\n");
    c0003374:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0003378:	913bc000 	add	x0, x0, #0xef0
    c000337c:	97fffa50 	bl	c0001cbc <mini_os_printf>
		return;
    c0003380:	14000032 	b	c0003448 <shell_print_help_topic+0x46c>
	}

	if (strings_equal(topic, "uname")) {
    c0003384:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0003388:	913c0001 	add	x1, x0, #0xf00
    c000338c:	f9400fe0 	ldr	x0, [sp, #24]
    c0003390:	97fffda0 	bl	c0002a10 <strings_equal>
    c0003394:	12001c00 	and	w0, w0, #0xff
    c0003398:	12000000 	and	w0, w0, #0x1
    c000339c:	7100001f 	cmp	w0, #0x0
    c00033a0:	540001c0 	b.eq	c00033d8 <shell_print_help_topic+0x3fc>  // b.none
		mini_os_printf("uname\n");
    c00033a4:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c00033a8:	913c2000 	add	x0, x0, #0xf08
    c00033ac:	97fffa44 	bl	c0001cbc <mini_os_printf>
		mini_os_printf("  Print the OS name only.\n");
    c00033b0:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c00033b4:	913c4000 	add	x0, x0, #0xf10
    c00033b8:	97fffa41 	bl	c0001cbc <mini_os_printf>
		mini_os_printf("Example:\n");
    c00033bc:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c00033c0:	91362000 	add	x0, x0, #0xd88
    c00033c4:	97fffa3e 	bl	c0001cbc <mini_os_printf>
		mini_os_printf("  uname\n");
    c00033c8:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c00033cc:	913cc000 	add	x0, x0, #0xf30
    c00033d0:	97fffa3b 	bl	c0001cbc <mini_os_printf>
		return;
    c00033d4:	1400001d 	b	c0003448 <shell_print_help_topic+0x46c>
	}

	if (strings_equal(topic, "halt")) {
    c00033d8:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c00033dc:	913d0001 	add	x1, x0, #0xf40
    c00033e0:	f9400fe0 	ldr	x0, [sp, #24]
    c00033e4:	97fffd8b 	bl	c0002a10 <strings_equal>
    c00033e8:	12001c00 	and	w0, w0, #0xff
    c00033ec:	12000000 	and	w0, w0, #0x1
    c00033f0:	7100001f 	cmp	w0, #0x0
    c00033f4:	540001c0 	b.eq	c000342c <shell_print_help_topic+0x450>  // b.none
		mini_os_printf("halt\n");
    c00033f8:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c00033fc:	913d2000 	add	x0, x0, #0xf48
    c0003400:	97fffa2f 	bl	c0001cbc <mini_os_printf>
		mini_os_printf("  Stop the current CPU in a low-power wait loop.\n");
    c0003404:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0003408:	913d4000 	add	x0, x0, #0xf50
    c000340c:	97fffa2c 	bl	c0001cbc <mini_os_printf>
		mini_os_printf("Example:\n");
    c0003410:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0003414:	91362000 	add	x0, x0, #0xd88
    c0003418:	97fffa29 	bl	c0001cbc <mini_os_printf>
		mini_os_printf("  halt\n");
    c000341c:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0003420:	913e2000 	add	x0, x0, #0xf88
    c0003424:	97fffa26 	bl	c0001cbc <mini_os_printf>
		return;
    c0003428:	14000008 	b	c0003448 <shell_print_help_topic+0x46c>
	}

	mini_os_printf("No detailed help for topic '%s'.\n", topic);
    c000342c:	f9400fe1 	ldr	x1, [sp, #24]
    c0003430:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0003434:	913e4000 	add	x0, x0, #0xf90
    c0003438:	97fffa21 	bl	c0001cbc <mini_os_printf>
	mini_os_printf("Try one of: cpu, cpus, topo, smp, info, version, echo, clear, uname, halt\n");
    c000343c:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0003440:	913ee000 	add	x0, x0, #0xfb8
    c0003444:	97fffa1e 	bl	c0001cbc <mini_os_printf>
}
    c0003448:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c000344c:	d65f03c0 	ret

00000000c0003450 <shell_print_help>:

void shell_print_help(void)
{
    c0003450:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    c0003454:	910003fd 	mov	x29, sp
	shell_print_help_overview();
    c0003458:	97fffeb2 	bl	c0002f20 <shell_print_help_overview>
}
    c000345c:	d503201f 	nop
    c0003460:	a8c17bfd 	ldp	x29, x30, [sp], #16
    c0003464:	d65f03c0 	ret

00000000c0003468 <shell_print_version>:

static void shell_print_version(void)
{
    c0003468:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    c000346c:	910003fd 	mov	x29, sp
	mini_os_printf("%s %s (%d)\n", MINI_OS_NAME, MINI_OS_VERSION,
    c0003470:	5280fd43 	mov	w3, #0x7ea                 	// #2026
    c0003474:	f0000000 	adrp	x0, c0006000 <hex.0+0xc88>
    c0003478:	91002002 	add	x2, x0, #0x8
    c000347c:	f0000000 	adrp	x0, c0006000 <hex.0+0xc88>
    c0003480:	91004001 	add	x1, x0, #0x10
    c0003484:	f0000000 	adrp	x0, c0006000 <hex.0+0xc88>
    c0003488:	91006000 	add	x0, x0, #0x18
    c000348c:	97fffa0c 	bl	c0001cbc <mini_os_printf>
		       MINI_OS_BUILD_YEAR);
}
    c0003490:	d503201f 	nop
    c0003494:	a8c17bfd 	ldp	x29, x30, [sp], #16
    c0003498:	d65f03c0 	ret

00000000c000349c <shell_print_info>:

static void shell_print_info(void)
{
    c000349c:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    c00034a0:	910003fd 	mov	x29, sp
	mini_os_printf("Platform      : %s\n", "Neoverse-N3");
    c00034a4:	f0000000 	adrp	x0, c0006000 <hex.0+0xc88>
    c00034a8:	9100a001 	add	x1, x0, #0x28
    c00034ac:	f0000000 	adrp	x0, c0006000 <hex.0+0xc88>
    c00034b0:	9100e000 	add	x0, x0, #0x38
    c00034b4:	97fffa02 	bl	c0001cbc <mini_os_printf>
	mini_os_printf("UART base     : 0x%llx\n",
    c00034b8:	d2a34801 	mov	x1, #0x1a400000            	// #440401920
    c00034bc:	f0000000 	adrp	x0, c0006000 <hex.0+0xc88>
    c00034c0:	91014000 	add	x0, x0, #0x50
    c00034c4:	97fff9fe 	bl	c0001cbc <mini_os_printf>
		       (unsigned long long)PLAT_UART0_BASE);
	mini_os_printf("Load address  : 0x%llx\n",
    c00034c8:	d2b80001 	mov	x1, #0xc0000000            	// #3221225472
    c00034cc:	f0000000 	adrp	x0, c0006000 <hex.0+0xc88>
    c00034d0:	9101a000 	add	x0, x0, #0x68
    c00034d4:	97fff9fa 	bl	c0001cbc <mini_os_printf>
		       (unsigned long long)PLAT_LOAD_ADDR);
	mini_os_printf("Boot magic    : 0x%llx\n",
    c00034d8:	f0000000 	adrp	x0, c0006000 <hex.0+0xc88>
    c00034dc:	911c0000 	add	x0, x0, #0x700
    c00034e0:	f9400000 	ldr	x0, [x0]
    c00034e4:	aa0003e1 	mov	x1, x0
    c00034e8:	f0000000 	adrp	x0, c0006000 <hex.0+0xc88>
    c00034ec:	91020000 	add	x0, x0, #0x80
    c00034f0:	97fff9f3 	bl	c0001cbc <mini_os_printf>
		       (unsigned long long)boot_magic);
	mini_os_printf("Runnable CPUs : %u\n", scheduler_runnable_cpu_count());
    c00034f4:	97fffd2e 	bl	c00029ac <scheduler_runnable_cpu_count>
    c00034f8:	2a0003e1 	mov	w1, w0
    c00034fc:	f0000000 	adrp	x0, c0006000 <hex.0+0xc88>
    c0003500:	91026000 	add	x0, x0, #0x98
    c0003504:	97fff9ee 	bl	c0001cbc <mini_os_printf>
}
    c0003508:	d503201f 	nop
    c000350c:	a8c17bfd 	ldp	x29, x30, [sp], #16
    c0003510:	d65f03c0 	ret

00000000c0003514 <shell_print_current_cpu>:

static void shell_print_current_cpu(void)
{
    c0003514:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    c0003518:	910003fd 	mov	x29, sp
	shell_print_cpu_entry(0U);
    c000351c:	52800000 	mov	w0, #0x0                   	// #0
    c0003520:	97fffe26 	bl	c0002db8 <shell_print_cpu_entry>
}
    c0003524:	d503201f 	nop
    c0003528:	a8c17bfd 	ldp	x29, x30, [sp], #16
    c000352c:	d65f03c0 	ret

00000000c0003530 <shell_print_cpu_id>:

static void shell_print_cpu_id(const char *arg)
{
    c0003530:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
    c0003534:	910003fd 	mov	x29, sp
    c0003538:	f9000fe0 	str	x0, [sp, #24]
	uint64_t logical_id;
	const struct cpu_topology_descriptor *cpu;

	if (!parse_u64(arg, &logical_id)) {
    c000353c:	910083e0 	add	x0, sp, #0x20
    c0003540:	aa0003e1 	mov	x1, x0
    c0003544:	f9400fe0 	ldr	x0, [sp, #24]
    c0003548:	97fffd75 	bl	c0002b1c <parse_u64>
    c000354c:	12001c00 	and	w0, w0, #0xff
    c0003550:	52000000 	eor	w0, w0, #0x1
    c0003554:	12001c00 	and	w0, w0, #0xff
    c0003558:	12000000 	and	w0, w0, #0x1
    c000355c:	7100001f 	cmp	w0, #0x0
    c0003560:	540000c0 	b.eq	c0003578 <shell_print_cpu_id+0x48>  // b.none
		mini_os_printf("error: invalid cpu id '%s'\n", arg);
    c0003564:	f9400fe1 	ldr	x1, [sp, #24]
    c0003568:	f0000000 	adrp	x0, c0006000 <hex.0+0xc88>
    c000356c:	9102c000 	add	x0, x0, #0xb0
    c0003570:	97fff9d3 	bl	c0001cbc <mini_os_printf>
		return;
    c0003574:	14000016 	b	c00035cc <shell_print_cpu_id+0x9c>
	}

	cpu = topology_cpu((unsigned int)logical_id);
    c0003578:	f94013e0 	ldr	x0, [sp, #32]
    c000357c:	94000631 	bl	c0004e40 <topology_cpu>
    c0003580:	f90017e0 	str	x0, [sp, #40]
	if ((cpu == (const struct cpu_topology_descriptor *)0) || !cpu->present) {
    c0003584:	f94017e0 	ldr	x0, [sp, #40]
    c0003588:	f100001f 	cmp	x0, #0x0
    c000358c:	54000100 	b.eq	c00035ac <shell_print_cpu_id+0x7c>  // b.none
    c0003590:	f94017e0 	ldr	x0, [sp, #40]
    c0003594:	39407400 	ldrb	w0, [x0, #29]
    c0003598:	52000000 	eor	w0, w0, #0x1
    c000359c:	12001c00 	and	w0, w0, #0xff
    c00035a0:	12000000 	and	w0, w0, #0x1
    c00035a4:	7100001f 	cmp	w0, #0x0
    c00035a8:	540000e0 	b.eq	c00035c4 <shell_print_cpu_id+0x94>  // b.none
		mini_os_printf("cpu%u is not present\n", (unsigned int)logical_id);
    c00035ac:	f94013e0 	ldr	x0, [sp, #32]
    c00035b0:	2a0003e1 	mov	w1, w0
    c00035b4:	f0000000 	adrp	x0, c0006000 <hex.0+0xc88>
    c00035b8:	91034000 	add	x0, x0, #0xd0
    c00035bc:	97fff9c0 	bl	c0001cbc <mini_os_printf>
		return;
    c00035c0:	14000003 	b	c00035cc <shell_print_cpu_id+0x9c>
	}

	shell_print_cpu_entry((unsigned int)logical_id);
    c00035c4:	f94013e0 	ldr	x0, [sp, #32]
    c00035c8:	97fffdfc 	bl	c0002db8 <shell_print_cpu_entry>
}
    c00035cc:	a8c37bfd 	ldp	x29, x30, [sp], #48
    c00035d0:	d65f03c0 	ret

00000000c00035d4 <shell_print_cpus>:

static void shell_print_cpus(void)
{
    c00035d4:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
    c00035d8:	910003fd 	mov	x29, sp
    c00035dc:	a90153f3 	stp	x19, x20, [sp, #16]
	unsigned int i;

	for (i = 0U; i < topology_cpu_capacity(); ++i) {
    c00035e0:	b9002fff 	str	wzr, [sp, #44]
    c00035e4:	14000011 	b	c0003628 <shell_print_cpus+0x54>
		const struct cpu_topology_descriptor *cpu = topology_cpu(i);
    c00035e8:	b9402fe0 	ldr	w0, [sp, #44]
    c00035ec:	94000615 	bl	c0004e40 <topology_cpu>
    c00035f0:	f90013e0 	str	x0, [sp, #32]

		if ((cpu != (const struct cpu_topology_descriptor *)0) && cpu->present) {
    c00035f4:	f94013e0 	ldr	x0, [sp, #32]
    c00035f8:	f100001f 	cmp	x0, #0x0
    c00035fc:	54000100 	b.eq	c000361c <shell_print_cpus+0x48>  // b.none
    c0003600:	f94013e0 	ldr	x0, [sp, #32]
    c0003604:	39407400 	ldrb	w0, [x0, #29]
    c0003608:	12000000 	and	w0, w0, #0x1
    c000360c:	7100001f 	cmp	w0, #0x0
    c0003610:	54000060 	b.eq	c000361c <shell_print_cpus+0x48>  // b.none
			shell_print_cpu_entry(i);
    c0003614:	b9402fe0 	ldr	w0, [sp, #44]
    c0003618:	97fffde8 	bl	c0002db8 <shell_print_cpu_entry>
	for (i = 0U; i < topology_cpu_capacity(); ++i) {
    c000361c:	b9402fe0 	ldr	w0, [sp, #44]
    c0003620:	11000400 	add	w0, w0, #0x1
    c0003624:	b9002fe0 	str	w0, [sp, #44]
    c0003628:	94000639 	bl	c0004f0c <topology_cpu_capacity>
    c000362c:	2a0003e1 	mov	w1, w0
    c0003630:	b9402fe0 	ldr	w0, [sp, #44]
    c0003634:	6b01001f 	cmp	w0, w1
    c0003638:	54fffd83 	b.cc	c00035e8 <shell_print_cpus+0x14>  // b.lo, b.ul, b.last
		}
	}
	mini_os_printf("online=%u runnable=%u capacity=%u\n",
    c000363c:	9400063a 	bl	c0004f24 <topology_online_cpu_count>
    c0003640:	2a0003f3 	mov	w19, w0
    c0003644:	97fffcda 	bl	c00029ac <scheduler_runnable_cpu_count>
    c0003648:	2a0003f4 	mov	w20, w0
    c000364c:	94000630 	bl	c0004f0c <topology_cpu_capacity>
    c0003650:	2a0003e3 	mov	w3, w0
    c0003654:	2a1403e2 	mov	w2, w20
    c0003658:	2a1303e1 	mov	w1, w19
    c000365c:	f0000000 	adrp	x0, c0006000 <hex.0+0xc88>
    c0003660:	9103a000 	add	x0, x0, #0xe8
    c0003664:	97fff996 	bl	c0001cbc <mini_os_printf>
		       topology_online_cpu_count(),
		       scheduler_runnable_cpu_count(),
		       topology_cpu_capacity());
}
    c0003668:	d503201f 	nop
    c000366c:	a94153f3 	ldp	x19, x20, [sp, #16]
    c0003670:	a8c37bfd 	ldp	x29, x30, [sp], #48
    c0003674:	d65f03c0 	ret

00000000c0003678 <shell_print_topology_summary>:

static void shell_print_topology_summary(void)
{
    c0003678:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c000367c:	910003fd 	mov	x29, sp
	const struct cpu_topology_descriptor *boot_cpu = topology_boot_cpu();
    c0003680:	940005ed 	bl	c0004e34 <topology_boot_cpu>
    c0003684:	f9000fe0 	str	x0, [sp, #24]

	mini_os_printf("Topology summary:\n");
    c0003688:	f0000000 	adrp	x0, c0006000 <hex.0+0xc88>
    c000368c:	91044000 	add	x0, x0, #0x110
    c0003690:	97fff98b 	bl	c0001cbc <mini_os_printf>
	mini_os_printf("  present cpus : %u\n", topology_present_cpu_count());
    c0003694:	94000620 	bl	c0004f14 <topology_present_cpu_count>
    c0003698:	2a0003e1 	mov	w1, w0
    c000369c:	f0000000 	adrp	x0, c0006000 <hex.0+0xc88>
    c00036a0:	9104a000 	add	x0, x0, #0x128
    c00036a4:	97fff986 	bl	c0001cbc <mini_os_printf>
	mini_os_printf("  online cpus  : %u\n", topology_online_cpu_count());
    c00036a8:	9400061f 	bl	c0004f24 <topology_online_cpu_count>
    c00036ac:	2a0003e1 	mov	w1, w0
    c00036b0:	f0000000 	adrp	x0, c0006000 <hex.0+0xc88>
    c00036b4:	91050000 	add	x0, x0, #0x140
    c00036b8:	97fff981 	bl	c0001cbc <mini_os_printf>
	mini_os_printf("  boot cpu     : cpu%u\n", boot_cpu->logical_id);
    c00036bc:	f9400fe0 	ldr	x0, [sp, #24]
    c00036c0:	b9400800 	ldr	w0, [x0, #8]
    c00036c4:	2a0003e1 	mov	w1, w0
    c00036c8:	f0000000 	adrp	x0, c0006000 <hex.0+0xc88>
    c00036cc:	91056000 	add	x0, x0, #0x158
    c00036d0:	97fff97b 	bl	c0001cbc <mini_os_printf>
	mini_os_printf("  boot mpidr   : 0x%llx\n", (unsigned long long)boot_cpu->mpidr);
    c00036d4:	f9400fe0 	ldr	x0, [sp, #24]
    c00036d8:	f9400000 	ldr	x0, [x0]
    c00036dc:	aa0003e1 	mov	x1, x0
    c00036e0:	f0000000 	adrp	x0, c0006000 <hex.0+0xc88>
    c00036e4:	9105c000 	add	x0, x0, #0x170
    c00036e8:	97fff975 	bl	c0001cbc <mini_os_printf>
	mini_os_printf("  affinity     : chip=%u die=%u cluster=%u core=%u\n",
		       boot_cpu->chip_id,
    c00036ec:	f9400fe0 	ldr	x0, [sp, #24]
    c00036f0:	b9400c01 	ldr	w1, [x0, #12]
		       boot_cpu->die_id,
    c00036f4:	f9400fe0 	ldr	x0, [sp, #24]
    c00036f8:	b9401002 	ldr	w2, [x0, #16]
		       boot_cpu->cluster_id,
    c00036fc:	f9400fe0 	ldr	x0, [sp, #24]
    c0003700:	b9401403 	ldr	w3, [x0, #20]
		       boot_cpu->core_id);
    c0003704:	f9400fe0 	ldr	x0, [sp, #24]
    c0003708:	b9401800 	ldr	w0, [x0, #24]
	mini_os_printf("  affinity     : chip=%u die=%u cluster=%u core=%u\n",
    c000370c:	2a0003e4 	mov	w4, w0
    c0003710:	f0000000 	adrp	x0, c0006000 <hex.0+0xc88>
    c0003714:	91064000 	add	x0, x0, #0x190
    c0003718:	97fff969 	bl	c0001cbc <mini_os_printf>
}
    c000371c:	d503201f 	nop
    c0003720:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c0003724:	d65f03c0 	ret

00000000c0003728 <shell_echo_args>:

static void shell_echo_args(int argc, char *argv[])
{
    c0003728:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
    c000372c:	910003fd 	mov	x29, sp
    c0003730:	b9001fe0 	str	w0, [sp, #28]
    c0003734:	f9000be1 	str	x1, [sp, #16]
	int i;

	for (i = 1; i < argc; ++i) {
    c0003738:	52800020 	mov	w0, #0x1                   	// #1
    c000373c:	b9002fe0 	str	w0, [sp, #44]
    c0003740:	14000015 	b	c0003794 <shell_echo_args+0x6c>
		mini_os_printf("%s", argv[i]);
    c0003744:	b9802fe0 	ldrsw	x0, [sp, #44]
    c0003748:	d37df000 	lsl	x0, x0, #3
    c000374c:	f9400be1 	ldr	x1, [sp, #16]
    c0003750:	8b000020 	add	x0, x1, x0
    c0003754:	f9400000 	ldr	x0, [x0]
    c0003758:	aa0003e1 	mov	x1, x0
    c000375c:	f0000000 	adrp	x0, c0006000 <hex.0+0xc88>
    c0003760:	91072000 	add	x0, x0, #0x1c8
    c0003764:	97fff956 	bl	c0001cbc <mini_os_printf>
		if (i + 1 < argc) {
    c0003768:	b9402fe0 	ldr	w0, [sp, #44]
    c000376c:	11000400 	add	w0, w0, #0x1
    c0003770:	b9401fe1 	ldr	w1, [sp, #28]
    c0003774:	6b00003f 	cmp	w1, w0
    c0003778:	5400008d 	b.le	c0003788 <shell_echo_args+0x60>
			mini_os_printf(" ");
    c000377c:	f0000000 	adrp	x0, c0006000 <hex.0+0xc88>
    c0003780:	91074000 	add	x0, x0, #0x1d0
    c0003784:	97fff94e 	bl	c0001cbc <mini_os_printf>
	for (i = 1; i < argc; ++i) {
    c0003788:	b9402fe0 	ldr	w0, [sp, #44]
    c000378c:	11000400 	add	w0, w0, #0x1
    c0003790:	b9002fe0 	str	w0, [sp, #44]
    c0003794:	b9402fe1 	ldr	w1, [sp, #44]
    c0003798:	b9401fe0 	ldr	w0, [sp, #28]
    c000379c:	6b00003f 	cmp	w1, w0
    c00037a0:	54fffd2b 	b.lt	c0003744 <shell_echo_args+0x1c>  // b.tstop
		}
	}
	mini_os_printf("\n");
    c00037a4:	f0000000 	adrp	x0, c0006000 <hex.0+0xc88>
    c00037a8:	91076000 	add	x0, x0, #0x1d8
    c00037ac:	97fff944 	bl	c0001cbc <mini_os_printf>
}
    c00037b0:	d503201f 	nop
    c00037b4:	a8c37bfd 	ldp	x29, x30, [sp], #48
    c00037b8:	d65f03c0 	ret

00000000c00037bc <shell_clear_screen>:

static void shell_clear_screen(void)
{
    c00037bc:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    c00037c0:	910003fd 	mov	x29, sp
	mini_os_printf("\033[2J\033[H");
    c00037c4:	f0000000 	adrp	x0, c0006000 <hex.0+0xc88>
    c00037c8:	91078000 	add	x0, x0, #0x1e0
    c00037cc:	97fff93c 	bl	c0001cbc <mini_os_printf>
}
    c00037d0:	d503201f 	nop
    c00037d4:	a8c17bfd 	ldp	x29, x30, [sp], #16
    c00037d8:	d65f03c0 	ret

00000000c00037dc <shell_halt>:

static void shell_halt(void)
{
    c00037dc:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    c00037e0:	910003fd 	mov	x29, sp
	mini_os_printf("Halting CPU. Use reset/restart in your emulator or board monitor.\n");
    c00037e4:	f0000000 	adrp	x0, c0006000 <hex.0+0xc88>
    c00037e8:	9107a000 	add	x0, x0, #0x1e8
    c00037ec:	97fff934 	bl	c0001cbc <mini_os_printf>
	for (;;) {
		__asm__ volatile ("wfe");
    c00037f0:	d503205f 	wfe
    c00037f4:	17ffffff 	b	c00037f0 <shell_halt+0x14>

00000000c00037f8 <shell_print_smp_already_online>:
}

static void shell_print_smp_already_online(uint64_t mpidr,
					   unsigned int logical_id,
					   const struct smp_cpu_state *state)
{
    c00037f8:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
    c00037fc:	910003fd 	mov	x29, sp
    c0003800:	f90017e0 	str	x0, [sp, #40]
    c0003804:	b90027e1 	str	w1, [sp, #36]
    c0003808:	f9000fe2 	str	x2, [sp, #24]
	if ((state != (const struct smp_cpu_state *)0) && state->boot_cpu) {
    c000380c:	f9400fe0 	ldr	x0, [sp, #24]
    c0003810:	f100001f 	cmp	x0, #0x0
    c0003814:	54000180 	b.eq	c0003844 <shell_print_smp_already_online+0x4c>  // b.none
    c0003818:	f9400fe0 	ldr	x0, [sp, #24]
    c000381c:	39404c00 	ldrb	w0, [x0, #19]
    c0003820:	12000000 	and	w0, w0, #0x1
    c0003824:	7100001f 	cmp	w0, #0x0
    c0003828:	540000e0 	b.eq	c0003844 <shell_print_smp_already_online+0x4c>  // b.none
		mini_os_printf("cpu%u (mpidr=0x%llx) is the boot CPU, already online by default\n",
    c000382c:	f94017e2 	ldr	x2, [sp, #40]
    c0003830:	b94027e1 	ldr	w1, [sp, #36]
    c0003834:	f0000000 	adrp	x0, c0006000 <hex.0+0xc88>
    c0003838:	9108c000 	add	x0, x0, #0x230
    c000383c:	97fff920 	bl	c0001cbc <mini_os_printf>
			       logical_id,
			       (unsigned long long)mpidr);
		return;
    c0003840:	14000013 	b	c000388c <shell_print_smp_already_online+0x94>
	}

	if ((state != (const struct smp_cpu_state *)0) && state->online) {
    c0003844:	f9400fe0 	ldr	x0, [sp, #24]
    c0003848:	f100001f 	cmp	x0, #0x0
    c000384c:	54000180 	b.eq	c000387c <shell_print_smp_already_online+0x84>  // b.none
    c0003850:	f9400fe0 	ldr	x0, [sp, #24]
    c0003854:	39404000 	ldrb	w0, [x0, #16]
    c0003858:	12000000 	and	w0, w0, #0x1
    c000385c:	7100001f 	cmp	w0, #0x0
    c0003860:	540000e0 	b.eq	c000387c <shell_print_smp_already_online+0x84>  // b.none
		mini_os_printf("cpu%u (mpidr=0x%llx) is a secondary CPU that is already online and scheduled\n",
    c0003864:	f94017e2 	ldr	x2, [sp, #40]
    c0003868:	b94027e1 	ldr	w1, [sp, #36]
    c000386c:	f0000000 	adrp	x0, c0006000 <hex.0+0xc88>
    c0003870:	9109e000 	add	x0, x0, #0x278
    c0003874:	97fff912 	bl	c0001cbc <mini_os_printf>
			       logical_id,
			       (unsigned long long)mpidr);
		return;
    c0003878:	14000005 	b	c000388c <shell_print_smp_already_online+0x94>
	}

	mini_os_printf("TF-A returned already-on for mpidr=0x%llx, but mini-os did not observe this secondary CPU actually boot\n",
    c000387c:	f94017e1 	ldr	x1, [sp, #40]
    c0003880:	f0000000 	adrp	x0, c0006000 <hex.0+0xc88>
    c0003884:	910b2000 	add	x0, x0, #0x2c8
    c0003888:	97fff90d 	bl	c0001cbc <mini_os_printf>
		       (unsigned long long)mpidr);
}
    c000388c:	a8c37bfd 	ldp	x29, x30, [sp], #48
    c0003890:	d65f03c0 	ret

00000000c0003894 <shell_handle_smp>:

static void shell_handle_smp(int argc, char *argv[])
{
    c0003894:	a9ba7bfd 	stp	x29, x30, [sp, #-96]!
    c0003898:	910003fd 	mov	x29, sp
    c000389c:	a90153f3 	stp	x19, x20, [sp, #16]
    c00038a0:	a9025bf5 	stp	x21, x22, [sp, #32]
    c00038a4:	b9003fe0 	str	w0, [sp, #60]
    c00038a8:	f9001be1 	str	x1, [sp, #48]
	uint64_t mpidr;
	unsigned int logical_id = 0U;
    c00038ac:	b90047ff 	str	wzr, [sp, #68]
	int32_t smc_ret = 0;
    c00038b0:	b90043ff 	str	wzr, [sp, #64]
	int ret;
	const struct smp_cpu_state *state = (const struct smp_cpu_state *)0;
    c00038b4:	f9002fff 	str	xzr, [sp, #88]

	if (argc < 2) {
    c00038b8:	b9403fe0 	ldr	w0, [sp, #60]
    c00038bc:	7100041f 	cmp	w0, #0x1
    c00038c0:	540000ac 	b.gt	c00038d4 <shell_handle_smp+0x40>
		mini_os_printf("usage: smp status | smp start <mpidr>\n");
    c00038c4:	f0000000 	adrp	x0, c0006000 <hex.0+0xc88>
    c00038c8:	910ce000 	add	x0, x0, #0x338
    c00038cc:	97fff8fc 	bl	c0001cbc <mini_os_printf>
		return;
    c00038d0:	140000bc 	b	c0003bc0 <shell_handle_smp+0x32c>
	}

	if (strings_equal(argv[1], "status")) {
    c00038d4:	f9401be0 	ldr	x0, [sp, #48]
    c00038d8:	91002000 	add	x0, x0, #0x8
    c00038dc:	f9400002 	ldr	x2, [x0]
    c00038e0:	f0000000 	adrp	x0, c0006000 <hex.0+0xc88>
    c00038e4:	910d8001 	add	x1, x0, #0x360
    c00038e8:	aa0203e0 	mov	x0, x2
    c00038ec:	97fffc49 	bl	c0002a10 <strings_equal>
    c00038f0:	12001c00 	and	w0, w0, #0xff
    c00038f4:	12000000 	and	w0, w0, #0x1
    c00038f8:	7100001f 	cmp	w0, #0x0
    c00038fc:	54000060 	b.eq	c0003908 <shell_handle_smp+0x74>  // b.none
		shell_print_cpus();
    c0003900:	97ffff35 	bl	c00035d4 <shell_print_cpus>
		return;
    c0003904:	140000af 	b	c0003bc0 <shell_handle_smp+0x32c>
	}

	if (strings_equal(argv[1], "start")) {
    c0003908:	f9401be0 	ldr	x0, [sp, #48]
    c000390c:	91002000 	add	x0, x0, #0x8
    c0003910:	f9400002 	ldr	x2, [x0]
    c0003914:	f0000000 	adrp	x0, c0006000 <hex.0+0xc88>
    c0003918:	910da001 	add	x1, x0, #0x368
    c000391c:	aa0203e0 	mov	x0, x2
    c0003920:	97fffc3c 	bl	c0002a10 <strings_equal>
    c0003924:	12001c00 	and	w0, w0, #0xff
    c0003928:	12000000 	and	w0, w0, #0x1
    c000392c:	7100001f 	cmp	w0, #0x0
    c0003930:	540013a0 	b.eq	c0003ba4 <shell_handle_smp+0x310>  // b.none
		if (argc < 3) {
    c0003934:	b9403fe0 	ldr	w0, [sp, #60]
    c0003938:	7100081f 	cmp	w0, #0x2
    c000393c:	540000ac 	b.gt	c0003950 <shell_handle_smp+0xbc>
			mini_os_printf("usage: smp start <mpidr>\n");
    c0003940:	f0000000 	adrp	x0, c0006000 <hex.0+0xc88>
    c0003944:	910dc000 	add	x0, x0, #0x370
    c0003948:	97fff8dd 	bl	c0001cbc <mini_os_printf>
			return;
    c000394c:	1400009d 	b	c0003bc0 <shell_handle_smp+0x32c>
		}
		if (!parse_u64(argv[2], &mpidr)) {
    c0003950:	f9401be0 	ldr	x0, [sp, #48]
    c0003954:	91004000 	add	x0, x0, #0x10
    c0003958:	f9400000 	ldr	x0, [x0]
    c000395c:	910123e1 	add	x1, sp, #0x48
    c0003960:	97fffc6f 	bl	c0002b1c <parse_u64>
    c0003964:	12001c00 	and	w0, w0, #0xff
    c0003968:	52000000 	eor	w0, w0, #0x1
    c000396c:	12001c00 	and	w0, w0, #0xff
    c0003970:	12000000 	and	w0, w0, #0x1
    c0003974:	7100001f 	cmp	w0, #0x0
    c0003978:	54000120 	b.eq	c000399c <shell_handle_smp+0x108>  // b.none
			mini_os_printf("error: invalid mpidr '%s'\n", argv[2]);
    c000397c:	f9401be0 	ldr	x0, [sp, #48]
    c0003980:	91004000 	add	x0, x0, #0x10
    c0003984:	f9400000 	ldr	x0, [x0]
    c0003988:	aa0003e1 	mov	x1, x0
    c000398c:	f0000000 	adrp	x0, c0006000 <hex.0+0xc88>
    c0003990:	910e4000 	add	x0, x0, #0x390
    c0003994:	97fff8ca 	bl	c0001cbc <mini_os_printf>
			return;
    c0003998:	1400008a 	b	c0003bc0 <shell_handle_smp+0x32c>
		}

		ret = smp_start_cpu(mpidr, &logical_id, &smc_ret);
    c000399c:	f94027e0 	ldr	x0, [sp, #72]
    c00039a0:	910103e2 	add	x2, sp, #0x40
    c00039a4:	910113e1 	add	x1, sp, #0x44
    c00039a8:	940002ff 	bl	c00045a4 <smp_start_cpu>
    c00039ac:	b90057e0 	str	w0, [sp, #84]
		state = smp_cpu_state(logical_id);
    c00039b0:	b94047e0 	ldr	w0, [sp, #68]
    c00039b4:	94000427 	bl	c0004a50 <smp_cpu_state>
    c00039b8:	f9002fe0 	str	x0, [sp, #88]

		mini_os_printf("TF-A cpu_on(mpidr=0x%llx, entry=0x%llx, ctx=cpu%u) -> smc=%d (%s)\n",
    c00039bc:	f94027f3 	ldr	x19, [sp, #72]
			       (unsigned long long)mpidr,
			       (unsigned long long)smp_secondary_entrypoint(),
    c00039c0:	94000492 	bl	c0004c08 <smp_secondary_entrypoint>
    c00039c4:	aa0003f6 	mov	x22, x0
		mini_os_printf("TF-A cpu_on(mpidr=0x%llx, entry=0x%llx, ctx=cpu%u) -> smc=%d (%s)\n",
    c00039c8:	b94047f4 	ldr	w20, [sp, #68]
    c00039cc:	b94043f5 	ldr	w21, [sp, #64]
    c00039d0:	b94057e0 	ldr	w0, [sp, #84]
    c00039d4:	9400026c 	bl	c0004384 <smp_start_result_name>
    c00039d8:	aa0003e5 	mov	x5, x0
    c00039dc:	2a1503e4 	mov	w4, w21
    c00039e0:	2a1403e3 	mov	w3, w20
    c00039e4:	aa1603e2 	mov	x2, x22
    c00039e8:	aa1303e1 	mov	x1, x19
    c00039ec:	f0000000 	adrp	x0, c0006000 <hex.0+0xc88>
    c00039f0:	910ec000 	add	x0, x0, #0x3b0
    c00039f4:	97fff8b2 	bl	c0001cbc <mini_os_printf>
			       logical_id,
			       smc_ret,
			       smp_start_result_name(ret));

		if (ret == SMP_START_OK) {
    c00039f8:	b94057e0 	ldr	w0, [sp, #84]
    c00039fc:	7100001f 	cmp	w0, #0x0
    c0003a00:	54000661 	b.ne	c0003acc <shell_handle_smp+0x238>  // b.any
			mini_os_printf("cpu%u power-on confirmed: online=%s scheduled=%s pending=%s runnable=%u\n",
    c0003a04:	b94047f6 	ldr	w22, [sp, #68]
    c0003a08:	f9402fe0 	ldr	x0, [sp, #88]
    c0003a0c:	f100001f 	cmp	x0, #0x0
    c0003a10:	54000120 	b.eq	c0003a34 <shell_handle_smp+0x1a0>  // b.none
				       logical_id,
				       ((state != (const struct smp_cpu_state *)0) && state->online) ? "yes" : "no",
    c0003a14:	f9402fe0 	ldr	x0, [sp, #88]
    c0003a18:	39404000 	ldrb	w0, [x0, #16]
    c0003a1c:	12000000 	and	w0, w0, #0x1
    c0003a20:	7100001f 	cmp	w0, #0x0
    c0003a24:	54000080 	b.eq	c0003a34 <shell_handle_smp+0x1a0>  // b.none
			mini_os_printf("cpu%u power-on confirmed: online=%s scheduled=%s pending=%s runnable=%u\n",
    c0003a28:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0003a2c:	91162013 	add	x19, x0, #0x588
    c0003a30:	14000003 	b	c0003a3c <shell_handle_smp+0x1a8>
    c0003a34:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0003a38:	91164013 	add	x19, x0, #0x590
    c0003a3c:	f9402fe0 	ldr	x0, [sp, #88]
    c0003a40:	f100001f 	cmp	x0, #0x0
    c0003a44:	54000120 	b.eq	c0003a68 <shell_handle_smp+0x1d4>  // b.none
				       ((state != (const struct smp_cpu_state *)0) && state->scheduled) ? "yes" : "no",
    c0003a48:	f9402fe0 	ldr	x0, [sp, #88]
    c0003a4c:	39404400 	ldrb	w0, [x0, #17]
    c0003a50:	12000000 	and	w0, w0, #0x1
    c0003a54:	7100001f 	cmp	w0, #0x0
    c0003a58:	54000080 	b.eq	c0003a68 <shell_handle_smp+0x1d4>  // b.none
			mini_os_printf("cpu%u power-on confirmed: online=%s scheduled=%s pending=%s runnable=%u\n",
    c0003a5c:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0003a60:	91162014 	add	x20, x0, #0x588
    c0003a64:	14000003 	b	c0003a70 <shell_handle_smp+0x1dc>
    c0003a68:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0003a6c:	91164014 	add	x20, x0, #0x590
    c0003a70:	f9402fe0 	ldr	x0, [sp, #88]
    c0003a74:	f100001f 	cmp	x0, #0x0
    c0003a78:	54000120 	b.eq	c0003a9c <shell_handle_smp+0x208>  // b.none
				       ((state != (const struct smp_cpu_state *)0) && state->pending) ? "yes" : "no",
    c0003a7c:	f9402fe0 	ldr	x0, [sp, #88]
    c0003a80:	39404800 	ldrb	w0, [x0, #18]
    c0003a84:	12000000 	and	w0, w0, #0x1
    c0003a88:	7100001f 	cmp	w0, #0x0
    c0003a8c:	54000080 	b.eq	c0003a9c <shell_handle_smp+0x208>  // b.none
			mini_os_printf("cpu%u power-on confirmed: online=%s scheduled=%s pending=%s runnable=%u\n",
    c0003a90:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0003a94:	91162015 	add	x21, x0, #0x588
    c0003a98:	14000003 	b	c0003aa4 <shell_handle_smp+0x210>
    c0003a9c:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0003aa0:	91164015 	add	x21, x0, #0x590
    c0003aa4:	97fffbc2 	bl	c00029ac <scheduler_runnable_cpu_count>
    c0003aa8:	2a0003e5 	mov	w5, w0
    c0003aac:	aa1503e4 	mov	x4, x21
    c0003ab0:	aa1403e3 	mov	x3, x20
    c0003ab4:	aa1303e2 	mov	x2, x19
    c0003ab8:	2a1603e1 	mov	w1, w22
    c0003abc:	f0000000 	adrp	x0, c0006000 <hex.0+0xc88>
    c0003ac0:	910fe000 	add	x0, x0, #0x3f8
    c0003ac4:	97fff87e 	bl	c0001cbc <mini_os_printf>
		} else {
			mini_os_printf("cpu-on failed for mpidr=0x%llx with unexpected smc result %d\n",
				       (unsigned long long)mpidr,
				       smc_ret);
		}
		return;
    c0003ac8:	1400003e 	b	c0003bc0 <shell_handle_smp+0x32c>
		} else if (ret == SMP_START_ALREADY_ONLINE) {
    c0003acc:	b94057e0 	ldr	w0, [sp, #84]
    c0003ad0:	7100041f 	cmp	w0, #0x1
    c0003ad4:	540000c1 	b.ne	c0003aec <shell_handle_smp+0x258>  // b.any
			shell_print_smp_already_online(mpidr, logical_id, state);
    c0003ad8:	f94027e0 	ldr	x0, [sp, #72]
    c0003adc:	b94047e1 	ldr	w1, [sp, #68]
    c0003ae0:	f9402fe2 	ldr	x2, [sp, #88]
    c0003ae4:	97ffff45 	bl	c00037f8 <shell_print_smp_already_online>
		return;
    c0003ae8:	14000036 	b	c0003bc0 <shell_handle_smp+0x32c>
		} else if (ret == SMP_START_INVALID_CPU) {
    c0003aec:	b94057e0 	ldr	w0, [sp, #84]
    c0003af0:	3100041f 	cmn	w0, #0x1
    c0003af4:	54000121 	b.ne	c0003b18 <shell_handle_smp+0x284>  // b.any
			mini_os_printf("TF-A reported invalid target or no logical slot left for mpidr=0x%llx (capacity=%u)\n",
    c0003af8:	f94027f3 	ldr	x19, [sp, #72]
    c0003afc:	94000504 	bl	c0004f0c <topology_cpu_capacity>
    c0003b00:	2a0003e2 	mov	w2, w0
    c0003b04:	aa1303e1 	mov	x1, x19
    c0003b08:	f0000000 	adrp	x0, c0006000 <hex.0+0xc88>
    c0003b0c:	91112000 	add	x0, x0, #0x448
    c0003b10:	97fff86b 	bl	c0001cbc <mini_os_printf>
		return;
    c0003b14:	1400002b 	b	c0003bc0 <shell_handle_smp+0x32c>
		} else if (ret == SMP_START_DENIED) {
    c0003b18:	b94057e0 	ldr	w0, [sp, #84]
    c0003b1c:	31000c1f 	cmn	w0, #0x3
    c0003b20:	540000e1 	b.ne	c0003b3c <shell_handle_smp+0x2a8>  // b.any
			mini_os_printf("TF-A denied cpu-on for mpidr=0x%llx\n",
    c0003b24:	f94027e0 	ldr	x0, [sp, #72]
    c0003b28:	aa0003e1 	mov	x1, x0
    c0003b2c:	f0000000 	adrp	x0, c0006000 <hex.0+0xc88>
    c0003b30:	91128000 	add	x0, x0, #0x4a0
    c0003b34:	97fff862 	bl	c0001cbc <mini_os_printf>
		return;
    c0003b38:	14000022 	b	c0003bc0 <shell_handle_smp+0x32c>
		} else if (ret == SMP_START_UNSUPPORTED) {
    c0003b3c:	b94057e0 	ldr	w0, [sp, #84]
    c0003b40:	3100081f 	cmn	w0, #0x2
    c0003b44:	540000e1 	b.ne	c0003b60 <shell_handle_smp+0x2cc>  // b.any
			mini_os_printf("TF-A/PSCI does not support cpu-on for mpidr=0x%llx\n",
    c0003b48:	f94027e0 	ldr	x0, [sp, #72]
    c0003b4c:	aa0003e1 	mov	x1, x0
    c0003b50:	f0000000 	adrp	x0, c0006000 <hex.0+0xc88>
    c0003b54:	91132000 	add	x0, x0, #0x4c8
    c0003b58:	97fff859 	bl	c0001cbc <mini_os_printf>
		return;
    c0003b5c:	14000019 	b	c0003bc0 <shell_handle_smp+0x32c>
		} else if (ret == SMP_START_TIMEOUT) {
    c0003b60:	b94057e0 	ldr	w0, [sp, #84]
    c0003b64:	3100101f 	cmn	w0, #0x4
    c0003b68:	540000e1 	b.ne	c0003b84 <shell_handle_smp+0x2f0>  // b.any
			mini_os_printf("cpu%u did not report online before timeout; please inspect TF-A handoff or secondary entry path\n",
    c0003b6c:	b94047e0 	ldr	w0, [sp, #68]
    c0003b70:	2a0003e1 	mov	w1, w0
    c0003b74:	f0000000 	adrp	x0, c0006000 <hex.0+0xc88>
    c0003b78:	91140000 	add	x0, x0, #0x500
    c0003b7c:	97fff850 	bl	c0001cbc <mini_os_printf>
		return;
    c0003b80:	14000010 	b	c0003bc0 <shell_handle_smp+0x32c>
			mini_os_printf("cpu-on failed for mpidr=0x%llx with unexpected smc result %d\n",
    c0003b84:	f94027e0 	ldr	x0, [sp, #72]
    c0003b88:	b94043e1 	ldr	w1, [sp, #64]
    c0003b8c:	2a0103e2 	mov	w2, w1
    c0003b90:	aa0003e1 	mov	x1, x0
    c0003b94:	f0000000 	adrp	x0, c0006000 <hex.0+0xc88>
    c0003b98:	9115a000 	add	x0, x0, #0x568
    c0003b9c:	97fff848 	bl	c0001cbc <mini_os_printf>
		return;
    c0003ba0:	14000008 	b	c0003bc0 <shell_handle_smp+0x32c>
	}

	mini_os_printf("unknown smp subcommand: %s\n", argv[1]);
    c0003ba4:	f9401be0 	ldr	x0, [sp, #48]
    c0003ba8:	91002000 	add	x0, x0, #0x8
    c0003bac:	f9400000 	ldr	x0, [x0]
    c0003bb0:	aa0003e1 	mov	x1, x0
    c0003bb4:	f0000000 	adrp	x0, c0006000 <hex.0+0xc88>
    c0003bb8:	9116a000 	add	x0, x0, #0x5a8
    c0003bbc:	97fff840 	bl	c0001cbc <mini_os_printf>
}
    c0003bc0:	a94153f3 	ldp	x19, x20, [sp, #16]
    c0003bc4:	a9425bf5 	ldp	x21, x22, [sp, #32]
    c0003bc8:	a8c67bfd 	ldp	x29, x30, [sp], #96
    c0003bcc:	d65f03c0 	ret

00000000c0003bd0 <shell_execute>:

static void shell_execute(char *line)
{
    c0003bd0:	a9b97bfd 	stp	x29, x30, [sp, #-112]!
    c0003bd4:	910003fd 	mov	x29, sp
    c0003bd8:	f9000fe0 	str	x0, [sp, #24]
	char *argv[SHELL_MAX_ARGS];
	int argc;
	const char *topic;

	argc = shell_tokenize(line, argv, SHELL_MAX_ARGS);
    c0003bdc:	910083e0 	add	x0, sp, #0x20
    c0003be0:	52800102 	mov	w2, #0x8                   	// #8
    c0003be4:	aa0003e1 	mov	x1, x0
    c0003be8:	f9400fe0 	ldr	x0, [sp, #24]
    c0003bec:	97fffc34 	bl	c0002cbc <shell_tokenize>
    c0003bf0:	b9006fe0 	str	w0, [sp, #108]
	if (argc == 0) {
    c0003bf4:	b9406fe0 	ldr	w0, [sp, #108]
    c0003bf8:	7100001f 	cmp	w0, #0x0
    c0003bfc:	54001380 	b.eq	c0003e6c <shell_execute+0x29c>  // b.none
		return;
	}

	if (strings_equal(argv[0], "help")) {
    c0003c00:	f94013e2 	ldr	x2, [sp, #32]
    c0003c04:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0003c08:	91234001 	add	x1, x0, #0x8d0
    c0003c0c:	aa0203e0 	mov	x0, x2
    c0003c10:	97fffb80 	bl	c0002a10 <strings_equal>
    c0003c14:	12001c00 	and	w0, w0, #0xff
    c0003c18:	12000000 	and	w0, w0, #0x1
    c0003c1c:	7100001f 	cmp	w0, #0x0
    c0003c20:	54000180 	b.eq	c0003c50 <shell_execute+0x80>  // b.none
		if (argc >= 2) {
    c0003c24:	b9406fe0 	ldr	w0, [sp, #108]
    c0003c28:	7100041f 	cmp	w0, #0x1
    c0003c2c:	540000ed 	b.le	c0003c48 <shell_execute+0x78>
			topic = shell_help_topic_name(argv[1]);
    c0003c30:	f94017e0 	ldr	x0, [sp, #40]
    c0003c34:	97fffba0 	bl	c0002ab4 <shell_help_topic_name>
    c0003c38:	f90033e0 	str	x0, [sp, #96]
			shell_print_help_topic(topic);
    c0003c3c:	f94033e0 	ldr	x0, [sp, #96]
    c0003c40:	97fffce7 	bl	c0002fdc <shell_print_help_topic>
    c0003c44:	1400008b 	b	c0003e70 <shell_execute+0x2a0>
		} else {
			shell_print_help();
    c0003c48:	97fffe02 	bl	c0003450 <shell_print_help>
    c0003c4c:	14000089 	b	c0003e70 <shell_execute+0x2a0>
		}
	} else if (strings_equal(argv[0], "version")) {
    c0003c50:	f94013e2 	ldr	x2, [sp, #32]
    c0003c54:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0003c58:	91368001 	add	x1, x0, #0xda0
    c0003c5c:	aa0203e0 	mov	x0, x2
    c0003c60:	97fffb6c 	bl	c0002a10 <strings_equal>
    c0003c64:	12001c00 	and	w0, w0, #0xff
    c0003c68:	12000000 	and	w0, w0, #0x1
    c0003c6c:	7100001f 	cmp	w0, #0x0
    c0003c70:	54000060 	b.eq	c0003c7c <shell_execute+0xac>  // b.none
		shell_print_version();
    c0003c74:	97fffdfd 	bl	c0003468 <shell_print_version>
    c0003c78:	1400007e 	b	c0003e70 <shell_execute+0x2a0>
	} else if (strings_equal(argv[0], "info")) {
    c0003c7c:	f94013e2 	ldr	x2, [sp, #32]
    c0003c80:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0003c84:	91342001 	add	x1, x0, #0xd08
    c0003c88:	aa0203e0 	mov	x0, x2
    c0003c8c:	97fffb61 	bl	c0002a10 <strings_equal>
    c0003c90:	12001c00 	and	w0, w0, #0xff
    c0003c94:	12000000 	and	w0, w0, #0x1
    c0003c98:	7100001f 	cmp	w0, #0x0
    c0003c9c:	54000060 	b.eq	c0003ca8 <shell_execute+0xd8>  // b.none
		shell_print_info();
    c0003ca0:	97fffdff 	bl	c000349c <shell_print_info>
    c0003ca4:	14000073 	b	c0003e70 <shell_execute+0x2a0>
	} else if (strings_equal(argv[0], "cpu")) {
    c0003ca8:	f94013e2 	ldr	x2, [sp, #32]
    c0003cac:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0003cb0:	91258001 	add	x1, x0, #0x960
    c0003cb4:	aa0203e0 	mov	x0, x2
    c0003cb8:	97fffb56 	bl	c0002a10 <strings_equal>
    c0003cbc:	12001c00 	and	w0, w0, #0xff
    c0003cc0:	12000000 	and	w0, w0, #0x1
    c0003cc4:	7100001f 	cmp	w0, #0x0
    c0003cc8:	54000120 	b.eq	c0003cec <shell_execute+0x11c>  // b.none
		if (argc >= 2) {
    c0003ccc:	b9406fe0 	ldr	w0, [sp, #108]
    c0003cd0:	7100041f 	cmp	w0, #0x1
    c0003cd4:	5400008d 	b.le	c0003ce4 <shell_execute+0x114>
			shell_print_cpu_id(argv[1]);
    c0003cd8:	f94017e0 	ldr	x0, [sp, #40]
    c0003cdc:	97fffe15 	bl	c0003530 <shell_print_cpu_id>
    c0003ce0:	14000064 	b	c0003e70 <shell_execute+0x2a0>
		} else {
			shell_print_current_cpu();
    c0003ce4:	97fffe0c 	bl	c0003514 <shell_print_current_cpu>
    c0003ce8:	14000062 	b	c0003e70 <shell_execute+0x2a0>
		}
	} else if (strings_equal(argv[0], "cpus")) {
    c0003cec:	f94013e2 	ldr	x2, [sp, #32]
    c0003cf0:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0003cf4:	91288001 	add	x1, x0, #0xa20
    c0003cf8:	aa0203e0 	mov	x0, x2
    c0003cfc:	97fffb45 	bl	c0002a10 <strings_equal>
    c0003d00:	12001c00 	and	w0, w0, #0xff
    c0003d04:	12000000 	and	w0, w0, #0x1
    c0003d08:	7100001f 	cmp	w0, #0x0
    c0003d0c:	54000060 	b.eq	c0003d18 <shell_execute+0x148>  // b.none
		shell_print_cpus();
    c0003d10:	97fffe31 	bl	c00035d4 <shell_print_cpus>
    c0003d14:	14000057 	b	c0003e70 <shell_execute+0x2a0>
	} else if (strings_equal(argv[0], "topo")) {
    c0003d18:	f94013e2 	ldr	x2, [sp, #32]
    c0003d1c:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0003d20:	912bc001 	add	x1, x0, #0xaf0
    c0003d24:	aa0203e0 	mov	x0, x2
    c0003d28:	97fffb3a 	bl	c0002a10 <strings_equal>
    c0003d2c:	12001c00 	and	w0, w0, #0xff
    c0003d30:	12000000 	and	w0, w0, #0x1
    c0003d34:	7100001f 	cmp	w0, #0x0
    c0003d38:	54000060 	b.eq	c0003d44 <shell_execute+0x174>  // b.none
		shell_print_topology_summary();
    c0003d3c:	97fffe4f 	bl	c0003678 <shell_print_topology_summary>
    c0003d40:	1400004c 	b	c0003e70 <shell_execute+0x2a0>
	} else if (strings_equal(argv[0], "smp")) {
    c0003d44:	f94013e2 	ldr	x2, [sp, #32]
    c0003d48:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0003d4c:	912ec001 	add	x1, x0, #0xbb0
    c0003d50:	aa0203e0 	mov	x0, x2
    c0003d54:	97fffb2f 	bl	c0002a10 <strings_equal>
    c0003d58:	12001c00 	and	w0, w0, #0xff
    c0003d5c:	12000000 	and	w0, w0, #0x1
    c0003d60:	7100001f 	cmp	w0, #0x0
    c0003d64:	540000c0 	b.eq	c0003d7c <shell_execute+0x1ac>  // b.none
		shell_handle_smp(argc, argv);
    c0003d68:	910083e0 	add	x0, sp, #0x20
    c0003d6c:	aa0003e1 	mov	x1, x0
    c0003d70:	b9406fe0 	ldr	w0, [sp, #108]
    c0003d74:	97fffec8 	bl	c0003894 <shell_handle_smp>
    c0003d78:	1400003e 	b	c0003e70 <shell_execute+0x2a0>
	} else if (strings_equal(argv[0], "echo")) {
    c0003d7c:	f94013e2 	ldr	x2, [sp, #32]
    c0003d80:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0003d84:	91382001 	add	x1, x0, #0xe08
    c0003d88:	aa0203e0 	mov	x0, x2
    c0003d8c:	97fffb21 	bl	c0002a10 <strings_equal>
    c0003d90:	12001c00 	and	w0, w0, #0xff
    c0003d94:	12000000 	and	w0, w0, #0x1
    c0003d98:	7100001f 	cmp	w0, #0x0
    c0003d9c:	540000c0 	b.eq	c0003db4 <shell_execute+0x1e4>  // b.none
		shell_echo_args(argc, argv);
    c0003da0:	910083e0 	add	x0, sp, #0x20
    c0003da4:	aa0003e1 	mov	x1, x0
    c0003da8:	b9406fe0 	ldr	w0, [sp, #108]
    c0003dac:	97fffe5f 	bl	c0003728 <shell_echo_args>
    c0003db0:	14000030 	b	c0003e70 <shell_execute+0x2a0>
	} else if (strings_equal(argv[0], "clear")) {
    c0003db4:	f94013e2 	ldr	x2, [sp, #32]
    c0003db8:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0003dbc:	9139e001 	add	x1, x0, #0xe78
    c0003dc0:	aa0203e0 	mov	x0, x2
    c0003dc4:	97fffb13 	bl	c0002a10 <strings_equal>
    c0003dc8:	12001c00 	and	w0, w0, #0xff
    c0003dcc:	12000000 	and	w0, w0, #0x1
    c0003dd0:	7100001f 	cmp	w0, #0x0
    c0003dd4:	54000060 	b.eq	c0003de0 <shell_execute+0x210>  // b.none
		shell_clear_screen();
    c0003dd8:	97fffe79 	bl	c00037bc <shell_clear_screen>
    c0003ddc:	14000025 	b	c0003e70 <shell_execute+0x2a0>
	} else if (strings_equal(argv[0], "uname")) {
    c0003de0:	f94013e2 	ldr	x2, [sp, #32]
    c0003de4:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0003de8:	913c0001 	add	x1, x0, #0xf00
    c0003dec:	aa0203e0 	mov	x0, x2
    c0003df0:	97fffb08 	bl	c0002a10 <strings_equal>
    c0003df4:	12001c00 	and	w0, w0, #0xff
    c0003df8:	12000000 	and	w0, w0, #0x1
    c0003dfc:	7100001f 	cmp	w0, #0x0
    c0003e00:	540000e0 	b.eq	c0003e1c <shell_execute+0x24c>  // b.none
		mini_os_printf("%s\n", MINI_OS_NAME);
    c0003e04:	f0000000 	adrp	x0, c0006000 <hex.0+0xc88>
    c0003e08:	91004001 	add	x1, x0, #0x10
    c0003e0c:	f0000000 	adrp	x0, c0006000 <hex.0+0xc88>
    c0003e10:	91172000 	add	x0, x0, #0x5c8
    c0003e14:	97fff7aa 	bl	c0001cbc <mini_os_printf>
    c0003e18:	14000016 	b	c0003e70 <shell_execute+0x2a0>
	} else if (strings_equal(argv[0], "halt")) {
    c0003e1c:	f94013e2 	ldr	x2, [sp, #32]
    c0003e20:	d0000000 	adrp	x0, c0005000 <topology_mark_cpu_online+0xcc>
    c0003e24:	913d0001 	add	x1, x0, #0xf40
    c0003e28:	aa0203e0 	mov	x0, x2
    c0003e2c:	97fffaf9 	bl	c0002a10 <strings_equal>
    c0003e30:	12001c00 	and	w0, w0, #0xff
    c0003e34:	12000000 	and	w0, w0, #0x1
    c0003e38:	7100001f 	cmp	w0, #0x0
    c0003e3c:	54000060 	b.eq	c0003e48 <shell_execute+0x278>  // b.none
		shell_halt();
    c0003e40:	97fffe67 	bl	c00037dc <shell_halt>
    c0003e44:	1400000b 	b	c0003e70 <shell_execute+0x2a0>
	} else {
		mini_os_printf("Unknown command: %s\n", argv[0]);
    c0003e48:	f94013e0 	ldr	x0, [sp, #32]
    c0003e4c:	aa0003e1 	mov	x1, x0
    c0003e50:	f0000000 	adrp	x0, c0006000 <hex.0+0xc88>
    c0003e54:	91174000 	add	x0, x0, #0x5d0
    c0003e58:	97fff799 	bl	c0001cbc <mini_os_printf>
		mini_os_printf("Type 'help' to list supported commands.\n");
    c0003e5c:	f0000000 	adrp	x0, c0006000 <hex.0+0xc88>
    c0003e60:	9117a000 	add	x0, x0, #0x5e8
    c0003e64:	97fff796 	bl	c0001cbc <mini_os_printf>
    c0003e68:	14000002 	b	c0003e70 <shell_execute+0x2a0>
		return;
    c0003e6c:	d503201f 	nop
	}
}
    c0003e70:	a8c77bfd 	ldp	x29, x30, [sp], #112
    c0003e74:	d65f03c0 	ret

00000000c0003e78 <shell_prompt>:

static void shell_prompt(void)
{
    c0003e78:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
    c0003e7c:	910003fd 	mov	x29, sp
	mini_os_printf("%s", SHELL_PROMPT);
    c0003e80:	f0000000 	adrp	x0, c0006000 <hex.0+0xc88>
    c0003e84:	91186001 	add	x1, x0, #0x618
    c0003e88:	f0000000 	adrp	x0, c0006000 <hex.0+0xc88>
    c0003e8c:	91072000 	add	x0, x0, #0x1c8
    c0003e90:	97fff78b 	bl	c0001cbc <mini_os_printf>
}
    c0003e94:	d503201f 	nop
    c0003e98:	a8c17bfd 	ldp	x29, x30, [sp], #16
    c0003e9c:	d65f03c0 	ret

00000000c0003ea0 <shell_run>:

void shell_run(void)
{
    c0003ea0:	a9b67bfd 	stp	x29, x30, [sp, #-160]!
    c0003ea4:	910003fd 	mov	x29, sp
	char line[SHELL_MAX_LINE];
	size_t len = 0U;
    c0003ea8:	f9004fff 	str	xzr, [sp, #152]

	shell_prompt();
    c0003eac:	97fffff3 	bl	c0003e78 <shell_prompt>
	for (;;) {
		int ch = debug_getc();
    c0003eb0:	97fff7c6 	bl	c0001dc8 <debug_getc>
    c0003eb4:	b90097e0 	str	w0, [sp, #148]

		if ((ch == '\r') || (ch == '\n')) {
    c0003eb8:	b94097e0 	ldr	w0, [sp, #148]
    c0003ebc:	7100341f 	cmp	w0, #0xd
    c0003ec0:	54000080 	b.eq	c0003ed0 <shell_run+0x30>  // b.none
    c0003ec4:	b94097e0 	ldr	w0, [sp, #148]
    c0003ec8:	7100281f 	cmp	w0, #0xa
    c0003ecc:	54000181 	b.ne	c0003efc <shell_run+0x5c>  // b.any
			mini_os_printf("\n");
    c0003ed0:	f0000000 	adrp	x0, c0006000 <hex.0+0xc88>
    c0003ed4:	91076000 	add	x0, x0, #0x1d8
    c0003ed8:	97fff779 	bl	c0001cbc <mini_os_printf>
			line[len] = '\0';
    c0003edc:	f9404fe0 	ldr	x0, [sp, #152]
    c0003ee0:	910043e1 	add	x1, sp, #0x10
    c0003ee4:	3820683f 	strb	wzr, [x1, x0]
			shell_execute(line);
    c0003ee8:	910043e0 	add	x0, sp, #0x10
    c0003eec:	97ffff39 	bl	c0003bd0 <shell_execute>
			len = 0U;
    c0003ef0:	f9004fff 	str	xzr, [sp, #152]
			shell_prompt();
    c0003ef4:	97ffffe1 	bl	c0003e78 <shell_prompt>
			continue;
    c0003ef8:	14000034 	b	c0003fc8 <shell_run+0x128>
		}

		if ((ch == '\b') || (ch == 127)) {
    c0003efc:	b94097e0 	ldr	w0, [sp, #148]
    c0003f00:	7100201f 	cmp	w0, #0x8
    c0003f04:	54000080 	b.eq	c0003f14 <shell_run+0x74>  // b.none
    c0003f08:	b94097e0 	ldr	w0, [sp, #148]
    c0003f0c:	7101fc1f 	cmp	w0, #0x7f
    c0003f10:	54000161 	b.ne	c0003f3c <shell_run+0x9c>  // b.any
			if (len > 0U) {
    c0003f14:	f9404fe0 	ldr	x0, [sp, #152]
    c0003f18:	f100001f 	cmp	x0, #0x0
    c0003f1c:	540004c0 	b.eq	c0003fb4 <shell_run+0x114>  // b.none
				len--;
    c0003f20:	f9404fe0 	ldr	x0, [sp, #152]
    c0003f24:	d1000400 	sub	x0, x0, #0x1
    c0003f28:	f9004fe0 	str	x0, [sp, #152]
				mini_os_printf("\b \b");
    c0003f2c:	f0000000 	adrp	x0, c0006000 <hex.0+0xc88>
    c0003f30:	9118a000 	add	x0, x0, #0x628
    c0003f34:	97fff762 	bl	c0001cbc <mini_os_printf>
			}
			continue;
    c0003f38:	1400001f 	b	c0003fb4 <shell_run+0x114>
		}

		if (ch == '\t') {
    c0003f3c:	b94097e0 	ldr	w0, [sp, #148]
    c0003f40:	7100241f 	cmp	w0, #0x9
    c0003f44:	540003c0 	b.eq	c0003fbc <shell_run+0x11c>  // b.none
			continue;
		}

		if ((ch < 32) || (ch > 126)) {
    c0003f48:	b94097e0 	ldr	w0, [sp, #148]
    c0003f4c:	71007c1f 	cmp	w0, #0x1f
    c0003f50:	540003ad 	b.le	c0003fc4 <shell_run+0x124>
    c0003f54:	b94097e0 	ldr	w0, [sp, #148]
    c0003f58:	7101f81f 	cmp	w0, #0x7e
    c0003f5c:	5400034c 	b.gt	c0003fc4 <shell_run+0x124>
			continue;
		}

		if (len + 1U >= SHELL_MAX_LINE) {
    c0003f60:	f9404fe0 	ldr	x0, [sp, #152]
    c0003f64:	91000400 	add	x0, x0, #0x1
    c0003f68:	f101fc1f 	cmp	x0, #0x7f
    c0003f6c:	54000109 	b.ls	c0003f8c <shell_run+0xec>  // b.plast
			mini_os_printf("\nerror: command too long (max %d chars)\n",
    c0003f70:	52800fe1 	mov	w1, #0x7f                  	// #127
    c0003f74:	f0000000 	adrp	x0, c0006000 <hex.0+0xc88>
    c0003f78:	9118c000 	add	x0, x0, #0x630
    c0003f7c:	97fff750 	bl	c0001cbc <mini_os_printf>
				       SHELL_MAX_LINE - 1);
			len = 0U;
    c0003f80:	f9004fff 	str	xzr, [sp, #152]
			shell_prompt();
    c0003f84:	97ffffbd 	bl	c0003e78 <shell_prompt>
			continue;
    c0003f88:	14000010 	b	c0003fc8 <shell_run+0x128>
		}

		line[len++] = (char)ch;
    c0003f8c:	f9404fe0 	ldr	x0, [sp, #152]
    c0003f90:	91000401 	add	x1, x0, #0x1
    c0003f94:	f9004fe1 	str	x1, [sp, #152]
    c0003f98:	b94097e1 	ldr	w1, [sp, #148]
    c0003f9c:	12001c22 	and	w2, w1, #0xff
    c0003fa0:	910043e1 	add	x1, sp, #0x10
    c0003fa4:	38206822 	strb	w2, [x1, x0]
		debug_putc(ch);
    c0003fa8:	b94097e0 	ldr	w0, [sp, #148]
    c0003fac:	97fff76d 	bl	c0001d60 <debug_putc>
    c0003fb0:	17ffffc0 	b	c0003eb0 <shell_run+0x10>
			continue;
    c0003fb4:	d503201f 	nop
    c0003fb8:	17ffffbe 	b	c0003eb0 <shell_run+0x10>
			continue;
    c0003fbc:	d503201f 	nop
    c0003fc0:	17ffffbc 	b	c0003eb0 <shell_run+0x10>
			continue;
    c0003fc4:	d503201f 	nop
	for (;;) {
    c0003fc8:	17ffffba 	b	c0003eb0 <shell_run+0x10>

00000000c0003fcc <smp_read_cntfrq>:
unsigned char secondary_stacks[PLAT_MAX_CPUS][PLAT_STACK_SIZE] __attribute__((aligned(16)));

extern void secondary_cpu_entrypoint(void);

static inline uint64_t smp_read_cntfrq(void)
{
    c0003fcc:	d10043ff 	sub	sp, sp, #0x10
	uint64_t value;

	__asm__ volatile ("mrs %0, cntfrq_el0" : "=r" (value));
    c0003fd0:	d53be000 	mrs	x0, cntfrq_el0
    c0003fd4:	f90007e0 	str	x0, [sp, #8]
	return value;
    c0003fd8:	f94007e0 	ldr	x0, [sp, #8]
}
    c0003fdc:	910043ff 	add	sp, sp, #0x10
    c0003fe0:	d65f03c0 	ret

00000000c0003fe4 <smp_read_cntpct>:

static inline uint64_t smp_read_cntpct(void)
{
    c0003fe4:	d10043ff 	sub	sp, sp, #0x10
	uint64_t value;

	__asm__ volatile ("mrs %0, cntpct_el0" : "=r" (value));
    c0003fe8:	d53be020 	mrs	x0, cntpct_el0
    c0003fec:	f90007e0 	str	x0, [sp, #8]
	return value;
    c0003ff0:	f94007e0 	ldr	x0, [sp, #8]
}
    c0003ff4:	910043ff 	add	sp, sp, #0x10
    c0003ff8:	d65f03c0 	ret

00000000c0003ffc <smp_relax>:

static inline void smp_relax(void)
{
	__asm__ volatile ("nop");
    c0003ffc:	d503201f 	nop
}
    c0004000:	d503201f 	nop
    c0004004:	d65f03c0 	ret

00000000c0004008 <smp_smc_call>:

static int32_t smp_smc_call(uint64_t x0, uint64_t x1, uint64_t x2, uint64_t x3)
{
    c0004008:	d10083ff 	sub	sp, sp, #0x20
    c000400c:	f9000fe0 	str	x0, [sp, #24]
    c0004010:	f9000be1 	str	x1, [sp, #16]
    c0004014:	f90007e2 	str	x2, [sp, #8]
    c0004018:	f90003e3 	str	x3, [sp]
	register uint64_t r0 __asm__("x0") = x0;
    c000401c:	f9400fe0 	ldr	x0, [sp, #24]
	register uint64_t r1 __asm__("x1") = x1;
    c0004020:	f9400be1 	ldr	x1, [sp, #16]
	register uint64_t r2 __asm__("x2") = x2;
    c0004024:	f94007e2 	ldr	x2, [sp, #8]
	register uint64_t r3 __asm__("x3") = x3;
    c0004028:	f94003e3 	ldr	x3, [sp]

	__asm__ volatile ("smc #0"
    c000402c:	d4000003 	smc	#0x0
		: "r" (r1), "r" (r2), "r" (r3)
		: "x4", "x5", "x6", "x7", "x8", "x9", "x10", "x11", "x12",
		  "x13", "x14", "x15", "x16", "x17", "memory");

	return (int32_t)r0;
}
    c0004030:	910083ff 	add	sp, sp, #0x20
    c0004034:	d65f03c0 	ret

00000000c0004038 <smp_find_free_logical_slot>:

static int smp_find_free_logical_slot(void)
{
    c0004038:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c000403c:	910003fd 	mov	x29, sp
	unsigned int i;

	for (i = 0U; i < PLAT_MAX_CPUS; ++i) {
    c0004040:	b9001fff 	str	wzr, [sp, #28]
    c0004044:	1400000e 	b	c000407c <smp_find_free_logical_slot+0x44>
		if (!topology_cpu(i)->present) {
    c0004048:	b9401fe0 	ldr	w0, [sp, #28]
    c000404c:	9400037d 	bl	c0004e40 <topology_cpu>
    c0004050:	39407400 	ldrb	w0, [x0, #29]
    c0004054:	52000000 	eor	w0, w0, #0x1
    c0004058:	12001c00 	and	w0, w0, #0xff
    c000405c:	12000000 	and	w0, w0, #0x1
    c0004060:	7100001f 	cmp	w0, #0x0
    c0004064:	54000060 	b.eq	c0004070 <smp_find_free_logical_slot+0x38>  // b.none
			return (int)i;
    c0004068:	b9401fe0 	ldr	w0, [sp, #28]
    c000406c:	14000008 	b	c000408c <smp_find_free_logical_slot+0x54>
	for (i = 0U; i < PLAT_MAX_CPUS; ++i) {
    c0004070:	b9401fe0 	ldr	w0, [sp, #28]
    c0004074:	11000400 	add	w0, w0, #0x1
    c0004078:	b9001fe0 	str	w0, [sp, #28]
    c000407c:	b9401fe0 	ldr	w0, [sp, #28]
    c0004080:	71001c1f 	cmp	w0, #0x7
    c0004084:	54fffe29 	b.ls	c0004048 <smp_find_free_logical_slot+0x10>  // b.plast
		}
	}

	return -1;
    c0004088:	12800000 	mov	w0, #0xffffffff            	// #-1
}
    c000408c:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c0004090:	d65f03c0 	ret

00000000c0004094 <smp_reset_cpu_state>:

static void smp_reset_cpu_state(unsigned int logical_id)
{
    c0004094:	d10043ff 	sub	sp, sp, #0x10
    c0004098:	b9000fe0 	str	w0, [sp, #12]
	if (logical_id >= PLAT_MAX_CPUS) {
    c000409c:	b9400fe0 	ldr	w0, [sp, #12]
    c00040a0:	71001c1f 	cmp	w0, #0x7
    c00040a4:	54000728 	b.hi	c0004188 <smp_reset_cpu_state+0xf4>  // b.pmore
		return;
	}

	cpu_states[logical_id].logical_id = logical_id;
    c00040a8:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c00040ac:	911c8002 	add	x2, x0, #0x720
    c00040b0:	b9400fe1 	ldr	w1, [sp, #12]
    c00040b4:	aa0103e0 	mov	x0, x1
    c00040b8:	d37ff800 	lsl	x0, x0, #1
    c00040bc:	8b010000 	add	x0, x0, x1
    c00040c0:	d37df000 	lsl	x0, x0, #3
    c00040c4:	8b000040 	add	x0, x2, x0
    c00040c8:	b9400fe1 	ldr	w1, [sp, #12]
    c00040cc:	b9000001 	str	w1, [x0]
	cpu_states[logical_id].mpidr = 0U;
    c00040d0:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c00040d4:	911c8002 	add	x2, x0, #0x720
    c00040d8:	b9400fe1 	ldr	w1, [sp, #12]
    c00040dc:	aa0103e0 	mov	x0, x1
    c00040e0:	d37ff800 	lsl	x0, x0, #1
    c00040e4:	8b010000 	add	x0, x0, x1
    c00040e8:	d37df000 	lsl	x0, x0, #3
    c00040ec:	8b000040 	add	x0, x2, x0
    c00040f0:	f900041f 	str	xzr, [x0, #8]
	cpu_states[logical_id].online = false;
    c00040f4:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c00040f8:	911c8002 	add	x2, x0, #0x720
    c00040fc:	b9400fe1 	ldr	w1, [sp, #12]
    c0004100:	aa0103e0 	mov	x0, x1
    c0004104:	d37ff800 	lsl	x0, x0, #1
    c0004108:	8b010000 	add	x0, x0, x1
    c000410c:	d37df000 	lsl	x0, x0, #3
    c0004110:	8b000040 	add	x0, x2, x0
    c0004114:	3900401f 	strb	wzr, [x0, #16]
	cpu_states[logical_id].scheduled = false;
    c0004118:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c000411c:	911c8002 	add	x2, x0, #0x720
    c0004120:	b9400fe1 	ldr	w1, [sp, #12]
    c0004124:	aa0103e0 	mov	x0, x1
    c0004128:	d37ff800 	lsl	x0, x0, #1
    c000412c:	8b010000 	add	x0, x0, x1
    c0004130:	d37df000 	lsl	x0, x0, #3
    c0004134:	8b000040 	add	x0, x2, x0
    c0004138:	3900441f 	strb	wzr, [x0, #17]
	cpu_states[logical_id].pending = false;
    c000413c:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c0004140:	911c8002 	add	x2, x0, #0x720
    c0004144:	b9400fe1 	ldr	w1, [sp, #12]
    c0004148:	aa0103e0 	mov	x0, x1
    c000414c:	d37ff800 	lsl	x0, x0, #1
    c0004150:	8b010000 	add	x0, x0, x1
    c0004154:	d37df000 	lsl	x0, x0, #3
    c0004158:	8b000040 	add	x0, x2, x0
    c000415c:	3900481f 	strb	wzr, [x0, #18]
	cpu_states[logical_id].boot_cpu = false;
    c0004160:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c0004164:	911c8002 	add	x2, x0, #0x720
    c0004168:	b9400fe1 	ldr	w1, [sp, #12]
    c000416c:	aa0103e0 	mov	x0, x1
    c0004170:	d37ff800 	lsl	x0, x0, #1
    c0004174:	8b010000 	add	x0, x0, x1
    c0004178:	d37df000 	lsl	x0, x0, #3
    c000417c:	8b000040 	add	x0, x2, x0
    c0004180:	39004c1f 	strb	wzr, [x0, #19]
    c0004184:	14000002 	b	c000418c <smp_reset_cpu_state+0xf8>
		return;
    c0004188:	d503201f 	nop
}
    c000418c:	910043ff 	add	sp, sp, #0x10
    c0004190:	d65f03c0 	ret

00000000c0004194 <smp_wait_for_online>:

static bool smp_wait_for_online(unsigned int logical_id, uint32_t timeout_us)
{
    c0004194:	a9bc7bfd 	stp	x29, x30, [sp, #-64]!
    c0004198:	910003fd 	mov	x29, sp
    c000419c:	b9001fe0 	str	w0, [sp, #28]
    c00041a0:	b9001be1 	str	w1, [sp, #24]
	uint64_t freq;
	uint64_t start;
	uint64_t ticks;

	if (logical_id >= PLAT_MAX_CPUS) {
    c00041a4:	b9401fe0 	ldr	w0, [sp, #28]
    c00041a8:	71001c1f 	cmp	w0, #0x7
    c00041ac:	54000069 	b.ls	c00041b8 <smp_wait_for_online+0x24>  // b.plast
		return false;
    c00041b0:	52800000 	mov	w0, #0x0                   	// #0
    c00041b4:	14000054 	b	c0004304 <smp_wait_for_online+0x170>
	}

	if (cpu_states[logical_id].online) {
    c00041b8:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c00041bc:	911c8002 	add	x2, x0, #0x720
    c00041c0:	b9401fe1 	ldr	w1, [sp, #28]
    c00041c4:	aa0103e0 	mov	x0, x1
    c00041c8:	d37ff800 	lsl	x0, x0, #1
    c00041cc:	8b010000 	add	x0, x0, x1
    c00041d0:	d37df000 	lsl	x0, x0, #3
    c00041d4:	8b000040 	add	x0, x2, x0
    c00041d8:	39404000 	ldrb	w0, [x0, #16]
    c00041dc:	12000000 	and	w0, w0, #0x1
    c00041e0:	7100001f 	cmp	w0, #0x0
    c00041e4:	54000060 	b.eq	c00041f0 <smp_wait_for_online+0x5c>  // b.none
		return true;
    c00041e8:	52800020 	mov	w0, #0x1                   	// #1
    c00041ec:	14000046 	b	c0004304 <smp_wait_for_online+0x170>
	}

	freq = smp_read_cntfrq();
    c00041f0:	97ffff77 	bl	c0003fcc <smp_read_cntfrq>
    c00041f4:	f9001be0 	str	x0, [sp, #48]
	if (freq == 0U) {
    c00041f8:	f9401be0 	ldr	x0, [sp, #48]
    c00041fc:	f100001f 	cmp	x0, #0x0
    c0004200:	54000161 	b.ne	c000422c <smp_wait_for_online+0x98>  // b.any
		return cpu_states[logical_id].online;
    c0004204:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c0004208:	911c8002 	add	x2, x0, #0x720
    c000420c:	b9401fe1 	ldr	w1, [sp, #28]
    c0004210:	aa0103e0 	mov	x0, x1
    c0004214:	d37ff800 	lsl	x0, x0, #1
    c0004218:	8b010000 	add	x0, x0, x1
    c000421c:	d37df000 	lsl	x0, x0, #3
    c0004220:	8b000040 	add	x0, x2, x0
    c0004224:	39404000 	ldrb	w0, [x0, #16]
    c0004228:	14000037 	b	c0004304 <smp_wait_for_online+0x170>
	}

	ticks = ((uint64_t)freq * timeout_us + 999999ULL) / 1000000ULL;
    c000422c:	b9401be1 	ldr	w1, [sp, #24]
    c0004230:	f9401be0 	ldr	x0, [sp, #48]
    c0004234:	9b007c21 	mul	x1, x1, x0
    c0004238:	d28847e0 	mov	x0, #0x423f                	// #16959
    c000423c:	f2a001e0 	movk	x0, #0xf, lsl #16
    c0004240:	8b000021 	add	x1, x1, x0
    c0004244:	d2869b60 	mov	x0, #0x34db                	// #13531
    c0004248:	f2baf6c0 	movk	x0, #0xd7b6, lsl #16
    c000424c:	f2dbd040 	movk	x0, #0xde82, lsl #32
    c0004250:	f2e86360 	movk	x0, #0x431b, lsl #48
    c0004254:	9bc07c20 	umulh	x0, x1, x0
    c0004258:	d352fc00 	lsr	x0, x0, #18
    c000425c:	f9001fe0 	str	x0, [sp, #56]
	if (ticks == 0U) {
    c0004260:	f9401fe0 	ldr	x0, [sp, #56]
    c0004264:	f100001f 	cmp	x0, #0x0
    c0004268:	54000061 	b.ne	c0004274 <smp_wait_for_online+0xe0>  // b.any
		ticks = 1U;
    c000426c:	d2800020 	mov	x0, #0x1                   	// #1
    c0004270:	f9001fe0 	str	x0, [sp, #56]
	}

	start = smp_read_cntpct();
    c0004274:	97ffff5c 	bl	c0003fe4 <smp_read_cntpct>
    c0004278:	f90017e0 	str	x0, [sp, #40]
	while (!cpu_states[logical_id].online) {
    c000427c:	14000009 	b	c00042a0 <smp_wait_for_online+0x10c>
		if ((smp_read_cntpct() - start) >= ticks) {
    c0004280:	97ffff59 	bl	c0003fe4 <smp_read_cntpct>
    c0004284:	aa0003e1 	mov	x1, x0
    c0004288:	f94017e0 	ldr	x0, [sp, #40]
    c000428c:	cb000020 	sub	x0, x1, x0
    c0004290:	f9401fe1 	ldr	x1, [sp, #56]
    c0004294:	eb00003f 	cmp	x1, x0
    c0004298:	54000229 	b.ls	c00042dc <smp_wait_for_online+0x148>  // b.plast
			break;
		}
		smp_relax();
    c000429c:	97ffff58 	bl	c0003ffc <smp_relax>
	while (!cpu_states[logical_id].online) {
    c00042a0:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c00042a4:	911c8002 	add	x2, x0, #0x720
    c00042a8:	b9401fe1 	ldr	w1, [sp, #28]
    c00042ac:	aa0103e0 	mov	x0, x1
    c00042b0:	d37ff800 	lsl	x0, x0, #1
    c00042b4:	8b010000 	add	x0, x0, x1
    c00042b8:	d37df000 	lsl	x0, x0, #3
    c00042bc:	8b000040 	add	x0, x2, x0
    c00042c0:	39404000 	ldrb	w0, [x0, #16]
    c00042c4:	52000000 	eor	w0, w0, #0x1
    c00042c8:	12001c00 	and	w0, w0, #0xff
    c00042cc:	12000000 	and	w0, w0, #0x1
    c00042d0:	7100001f 	cmp	w0, #0x0
    c00042d4:	54fffd61 	b.ne	c0004280 <smp_wait_for_online+0xec>  // b.any
    c00042d8:	14000002 	b	c00042e0 <smp_wait_for_online+0x14c>
			break;
    c00042dc:	d503201f 	nop
	}

	return cpu_states[logical_id].online;
    c00042e0:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c00042e4:	911c8002 	add	x2, x0, #0x720
    c00042e8:	b9401fe1 	ldr	w1, [sp, #28]
    c00042ec:	aa0103e0 	mov	x0, x1
    c00042f0:	d37ff800 	lsl	x0, x0, #1
    c00042f4:	8b010000 	add	x0, x0, x1
    c00042f8:	d37df000 	lsl	x0, x0, #3
    c00042fc:	8b000040 	add	x0, x2, x0
    c0004300:	39404000 	ldrb	w0, [x0, #16]
}
    c0004304:	a8c47bfd 	ldp	x29, x30, [sp], #64
    c0004308:	d65f03c0 	ret

00000000c000430c <smp_map_psci_result>:

static int smp_map_psci_result(int32_t ret)
{
    c000430c:	d10043ff 	sub	sp, sp, #0x10
    c0004310:	b9000fe0 	str	w0, [sp, #12]
	if (ret == PSCI_RET_SUCCESS) {
    c0004314:	b9400fe0 	ldr	w0, [sp, #12]
    c0004318:	7100001f 	cmp	w0, #0x0
    c000431c:	54000061 	b.ne	c0004328 <smp_map_psci_result+0x1c>  // b.any
		return SMP_START_OK;
    c0004320:	52800000 	mov	w0, #0x0                   	// #0
    c0004324:	14000016 	b	c000437c <smp_map_psci_result+0x70>
	}
	if (ret == PSCI_RET_ALREADY_ON) {
    c0004328:	b9400fe0 	ldr	w0, [sp, #12]
    c000432c:	3100101f 	cmn	w0, #0x4
    c0004330:	54000061 	b.ne	c000433c <smp_map_psci_result+0x30>  // b.any
		return SMP_START_ALREADY_ONLINE;
    c0004334:	52800020 	mov	w0, #0x1                   	// #1
    c0004338:	14000011 	b	c000437c <smp_map_psci_result+0x70>
	}
	if (ret == PSCI_RET_INVALID_PARAMS) {
    c000433c:	b9400fe0 	ldr	w0, [sp, #12]
    c0004340:	3100081f 	cmn	w0, #0x2
    c0004344:	54000061 	b.ne	c0004350 <smp_map_psci_result+0x44>  // b.any
		return SMP_START_INVALID_CPU;
    c0004348:	12800000 	mov	w0, #0xffffffff            	// #-1
    c000434c:	1400000c 	b	c000437c <smp_map_psci_result+0x70>
	}
	if (ret == PSCI_RET_DENIED) {
    c0004350:	b9400fe0 	ldr	w0, [sp, #12]
    c0004354:	31000c1f 	cmn	w0, #0x3
    c0004358:	54000061 	b.ne	c0004364 <smp_map_psci_result+0x58>  // b.any
		return SMP_START_DENIED;
    c000435c:	12800040 	mov	w0, #0xfffffffd            	// #-3
    c0004360:	14000007 	b	c000437c <smp_map_psci_result+0x70>
	}
	if (ret == PSCI_RET_NOT_SUPPORTED) {
    c0004364:	b9400fe0 	ldr	w0, [sp, #12]
    c0004368:	3100041f 	cmn	w0, #0x1
    c000436c:	54000061 	b.ne	c0004378 <smp_map_psci_result+0x6c>  // b.any
		return SMP_START_UNSUPPORTED;
    c0004370:	12800020 	mov	w0, #0xfffffffe            	// #-2
    c0004374:	14000002 	b	c000437c <smp_map_psci_result+0x70>
	}

	return SMP_START_FAILED;
    c0004378:	12800080 	mov	w0, #0xfffffffb            	// #-5
}
    c000437c:	910043ff 	add	sp, sp, #0x10
    c0004380:	d65f03c0 	ret

00000000c0004384 <smp_start_result_name>:

const char *smp_start_result_name(int result)
{
    c0004384:	d10043ff 	sub	sp, sp, #0x10
    c0004388:	b9000fe0 	str	w0, [sp, #12]
	if (result == SMP_START_OK) {
    c000438c:	b9400fe0 	ldr	w0, [sp, #12]
    c0004390:	7100001f 	cmp	w0, #0x0
    c0004394:	54000081 	b.ne	c00043a4 <smp_start_result_name+0x20>  // b.any
		return "ok";
    c0004398:	d0000000 	adrp	x0, c0006000 <hex.0+0xc88>
    c000439c:	91198000 	add	x0, x0, #0x660
    c00043a0:	14000021 	b	c0004424 <smp_start_result_name+0xa0>
	}
	if (result == SMP_START_ALREADY_ONLINE) {
    c00043a4:	b9400fe0 	ldr	w0, [sp, #12]
    c00043a8:	7100041f 	cmp	w0, #0x1
    c00043ac:	54000081 	b.ne	c00043bc <smp_start_result_name+0x38>  // b.any
		return "already-on";
    c00043b0:	d0000000 	adrp	x0, c0006000 <hex.0+0xc88>
    c00043b4:	9119a000 	add	x0, x0, #0x668
    c00043b8:	1400001b 	b	c0004424 <smp_start_result_name+0xa0>
	}
	if (result == SMP_START_INVALID_CPU) {
    c00043bc:	b9400fe0 	ldr	w0, [sp, #12]
    c00043c0:	3100041f 	cmn	w0, #0x1
    c00043c4:	54000081 	b.ne	c00043d4 <smp_start_result_name+0x50>  // b.any
		return "invalid-params";
    c00043c8:	d0000000 	adrp	x0, c0006000 <hex.0+0xc88>
    c00043cc:	9119e000 	add	x0, x0, #0x678
    c00043d0:	14000015 	b	c0004424 <smp_start_result_name+0xa0>
	}
	if (result == SMP_START_UNSUPPORTED) {
    c00043d4:	b9400fe0 	ldr	w0, [sp, #12]
    c00043d8:	3100081f 	cmn	w0, #0x2
    c00043dc:	54000081 	b.ne	c00043ec <smp_start_result_name+0x68>  // b.any
		return "not-supported";
    c00043e0:	d0000000 	adrp	x0, c0006000 <hex.0+0xc88>
    c00043e4:	911a2000 	add	x0, x0, #0x688
    c00043e8:	1400000f 	b	c0004424 <smp_start_result_name+0xa0>
	}
	if (result == SMP_START_DENIED) {
    c00043ec:	b9400fe0 	ldr	w0, [sp, #12]
    c00043f0:	31000c1f 	cmn	w0, #0x3
    c00043f4:	54000081 	b.ne	c0004404 <smp_start_result_name+0x80>  // b.any
		return "denied";
    c00043f8:	d0000000 	adrp	x0, c0006000 <hex.0+0xc88>
    c00043fc:	911a6000 	add	x0, x0, #0x698
    c0004400:	14000009 	b	c0004424 <smp_start_result_name+0xa0>
	}
	if (result == SMP_START_TIMEOUT) {
    c0004404:	b9400fe0 	ldr	w0, [sp, #12]
    c0004408:	3100101f 	cmn	w0, #0x4
    c000440c:	54000081 	b.ne	c000441c <smp_start_result_name+0x98>  // b.any
		return "timeout";
    c0004410:	d0000000 	adrp	x0, c0006000 <hex.0+0xc88>
    c0004414:	911a8000 	add	x0, x0, #0x6a0
    c0004418:	14000003 	b	c0004424 <smp_start_result_name+0xa0>
	}

	return "failed";
    c000441c:	d0000000 	adrp	x0, c0006000 <hex.0+0xc88>
    c0004420:	911aa000 	add	x0, x0, #0x6a8
}
    c0004424:	910043ff 	add	sp, sp, #0x10
    c0004428:	d65f03c0 	ret

00000000c000442c <smp_init>:

void smp_init(void)
{
    c000442c:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c0004430:	910003fd 	mov	x29, sp
	unsigned int i;
	const struct cpu_topology_descriptor *boot_cpu = topology_boot_cpu();
    c0004434:	94000280 	bl	c0004e34 <topology_boot_cpu>
    c0004438:	f9000be0 	str	x0, [sp, #16]

	for (i = 0U; i < PLAT_MAX_CPUS; ++i) {
    c000443c:	b9001fff 	str	wzr, [sp, #28]
    c0004440:	1400003b 	b	c000452c <smp_init+0x100>
		cpu_states[i].logical_id = i;
    c0004444:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c0004448:	911c8002 	add	x2, x0, #0x720
    c000444c:	b9401fe1 	ldr	w1, [sp, #28]
    c0004450:	aa0103e0 	mov	x0, x1
    c0004454:	d37ff800 	lsl	x0, x0, #1
    c0004458:	8b010000 	add	x0, x0, x1
    c000445c:	d37df000 	lsl	x0, x0, #3
    c0004460:	8b000040 	add	x0, x2, x0
    c0004464:	b9401fe1 	ldr	w1, [sp, #28]
    c0004468:	b9000001 	str	w1, [x0]
		cpu_states[i].mpidr = 0U;
    c000446c:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c0004470:	911c8002 	add	x2, x0, #0x720
    c0004474:	b9401fe1 	ldr	w1, [sp, #28]
    c0004478:	aa0103e0 	mov	x0, x1
    c000447c:	d37ff800 	lsl	x0, x0, #1
    c0004480:	8b010000 	add	x0, x0, x1
    c0004484:	d37df000 	lsl	x0, x0, #3
    c0004488:	8b000040 	add	x0, x2, x0
    c000448c:	f900041f 	str	xzr, [x0, #8]
		cpu_states[i].online = false;
    c0004490:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c0004494:	911c8002 	add	x2, x0, #0x720
    c0004498:	b9401fe1 	ldr	w1, [sp, #28]
    c000449c:	aa0103e0 	mov	x0, x1
    c00044a0:	d37ff800 	lsl	x0, x0, #1
    c00044a4:	8b010000 	add	x0, x0, x1
    c00044a8:	d37df000 	lsl	x0, x0, #3
    c00044ac:	8b000040 	add	x0, x2, x0
    c00044b0:	3900401f 	strb	wzr, [x0, #16]
		cpu_states[i].scheduled = false;
    c00044b4:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c00044b8:	911c8002 	add	x2, x0, #0x720
    c00044bc:	b9401fe1 	ldr	w1, [sp, #28]
    c00044c0:	aa0103e0 	mov	x0, x1
    c00044c4:	d37ff800 	lsl	x0, x0, #1
    c00044c8:	8b010000 	add	x0, x0, x1
    c00044cc:	d37df000 	lsl	x0, x0, #3
    c00044d0:	8b000040 	add	x0, x2, x0
    c00044d4:	3900441f 	strb	wzr, [x0, #17]
		cpu_states[i].pending = false;
    c00044d8:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c00044dc:	911c8002 	add	x2, x0, #0x720
    c00044e0:	b9401fe1 	ldr	w1, [sp, #28]
    c00044e4:	aa0103e0 	mov	x0, x1
    c00044e8:	d37ff800 	lsl	x0, x0, #1
    c00044ec:	8b010000 	add	x0, x0, x1
    c00044f0:	d37df000 	lsl	x0, x0, #3
    c00044f4:	8b000040 	add	x0, x2, x0
    c00044f8:	3900481f 	strb	wzr, [x0, #18]
		cpu_states[i].boot_cpu = false;
    c00044fc:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c0004500:	911c8002 	add	x2, x0, #0x720
    c0004504:	b9401fe1 	ldr	w1, [sp, #28]
    c0004508:	aa0103e0 	mov	x0, x1
    c000450c:	d37ff800 	lsl	x0, x0, #1
    c0004510:	8b010000 	add	x0, x0, x1
    c0004514:	d37df000 	lsl	x0, x0, #3
    c0004518:	8b000040 	add	x0, x2, x0
    c000451c:	39004c1f 	strb	wzr, [x0, #19]
	for (i = 0U; i < PLAT_MAX_CPUS; ++i) {
    c0004520:	b9401fe0 	ldr	w0, [sp, #28]
    c0004524:	11000400 	add	w0, w0, #0x1
    c0004528:	b9001fe0 	str	w0, [sp, #28]
    c000452c:	b9401fe0 	ldr	w0, [sp, #28]
    c0004530:	71001c1f 	cmp	w0, #0x7
    c0004534:	54fff889 	b.ls	c0004444 <smp_init+0x18>  // b.plast
	}

	cpu_states[0].logical_id = 0U;
    c0004538:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c000453c:	911c8000 	add	x0, x0, #0x720
    c0004540:	b900001f 	str	wzr, [x0]
	cpu_states[0].mpidr = boot_cpu->mpidr;
    c0004544:	f9400be0 	ldr	x0, [sp, #16]
    c0004548:	f9400001 	ldr	x1, [x0]
    c000454c:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c0004550:	911c8000 	add	x0, x0, #0x720
    c0004554:	f9000401 	str	x1, [x0, #8]
	cpu_states[0].boot_cpu = true;
    c0004558:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c000455c:	911c8000 	add	x0, x0, #0x720
    c0004560:	52800021 	mov	w1, #0x1                   	// #1
    c0004564:	39004c01 	strb	w1, [x0, #19]
	cpu_states[0].online = true;
    c0004568:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c000456c:	911c8000 	add	x0, x0, #0x720
    c0004570:	52800021 	mov	w1, #0x1                   	// #1
    c0004574:	39004001 	strb	w1, [x0, #16]
	cpu_states[0].scheduled = true;
    c0004578:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c000457c:	911c8000 	add	x0, x0, #0x720
    c0004580:	52800021 	mov	w1, #0x1                   	// #1
    c0004584:	39004401 	strb	w1, [x0, #17]
	online_cpu_count = 1U;
    c0004588:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c000458c:	911f8000 	add	x0, x0, #0x7e0
    c0004590:	52800021 	mov	w1, #0x1                   	// #1
    c0004594:	b9000001 	str	w1, [x0]
}
    c0004598:	d503201f 	nop
    c000459c:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c00045a0:	d65f03c0 	ret

00000000c00045a4 <smp_start_cpu>:

int smp_start_cpu(uint64_t mpidr, unsigned int *logical_id, int32_t *smc_ret)
{
    c00045a4:	a9bb7bfd 	stp	x29, x30, [sp, #-80]!
    c00045a8:	910003fd 	mov	x29, sp
    c00045ac:	f90017e0 	str	x0, [sp, #40]
    c00045b0:	f90013e1 	str	x1, [sp, #32]
    c00045b4:	f9000fe2 	str	x2, [sp, #24]
	const struct cpu_topology_descriptor *cpu;
	int slot;
	int32_t ret;
	int result;
	bool new_cpu = false;
    c00045b8:	39013fff 	strb	wzr, [sp, #79]

	if ((logical_id == (unsigned int *)0) || (smc_ret == (int32_t *)0)) {
    c00045bc:	f94013e0 	ldr	x0, [sp, #32]
    c00045c0:	f100001f 	cmp	x0, #0x0
    c00045c4:	54000080 	b.eq	c00045d4 <smp_start_cpu+0x30>  // b.none
    c00045c8:	f9400fe0 	ldr	x0, [sp, #24]
    c00045cc:	f100001f 	cmp	x0, #0x0
    c00045d0:	54000061 	b.ne	c00045dc <smp_start_cpu+0x38>  // b.any
		return SMP_START_FAILED;
    c00045d4:	12800080 	mov	w0, #0xfffffffb            	// #-5
    c00045d8:	1400011c 	b	c0004a48 <smp_start_cpu+0x4a4>
	}

	*smc_ret = 0;
    c00045dc:	f9400fe0 	ldr	x0, [sp, #24]
    c00045e0:	b900001f 	str	wzr, [x0]
	cpu = topology_find_cpu_by_mpidr(mpidr);
    c00045e4:	f94017e0 	ldr	x0, [sp, #40]
    c00045e8:	94000224 	bl	c0004e78 <topology_find_cpu_by_mpidr>
    c00045ec:	f90023e0 	str	x0, [sp, #64]
	if (cpu != (const struct cpu_topology_descriptor *)0) {
    c00045f0:	f94023e0 	ldr	x0, [sp, #64]
    c00045f4:	f100001f 	cmp	x0, #0x0
    c00045f8:	54000300 	b.eq	c0004658 <smp_start_cpu+0xb4>  // b.none
		*logical_id = cpu->logical_id;
    c00045fc:	f94023e0 	ldr	x0, [sp, #64]
    c0004600:	b9400801 	ldr	w1, [x0, #8]
    c0004604:	f94013e0 	ldr	x0, [sp, #32]
    c0004608:	b9000001 	str	w1, [x0]
		if (cpu_states[cpu->logical_id].online) {
    c000460c:	f94023e0 	ldr	x0, [sp, #64]
    c0004610:	b9400801 	ldr	w1, [x0, #8]
    c0004614:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c0004618:	911c8002 	add	x2, x0, #0x720
    c000461c:	2a0103e1 	mov	w1, w1
    c0004620:	aa0103e0 	mov	x0, x1
    c0004624:	d37ff800 	lsl	x0, x0, #1
    c0004628:	8b010000 	add	x0, x0, x1
    c000462c:	d37df000 	lsl	x0, x0, #3
    c0004630:	8b000040 	add	x0, x2, x0
    c0004634:	39404000 	ldrb	w0, [x0, #16]
    c0004638:	12000000 	and	w0, w0, #0x1
    c000463c:	7100001f 	cmp	w0, #0x0
    c0004640:	54000760 	b.eq	c000472c <smp_start_cpu+0x188>  // b.none
			*smc_ret = PSCI_RET_ALREADY_ON;
    c0004644:	f9400fe0 	ldr	x0, [sp, #24]
    c0004648:	12800061 	mov	w1, #0xfffffffc            	// #-4
    c000464c:	b9000001 	str	w1, [x0]
			return SMP_START_ALREADY_ONLINE;
    c0004650:	52800020 	mov	w0, #0x1                   	// #1
    c0004654:	140000fd 	b	c0004a48 <smp_start_cpu+0x4a4>
		}
	} else {
		slot = smp_find_free_logical_slot();
    c0004658:	97fffe78 	bl	c0004038 <smp_find_free_logical_slot>
    c000465c:	b9003fe0 	str	w0, [sp, #60]
		if (slot < 0) {
    c0004660:	b9403fe0 	ldr	w0, [sp, #60]
    c0004664:	7100001f 	cmp	w0, #0x0
    c0004668:	5400006a 	b.ge	c0004674 <smp_start_cpu+0xd0>  // b.tcont
			return SMP_START_INVALID_CPU;
    c000466c:	12800000 	mov	w0, #0xffffffff            	// #-1
    c0004670:	140000f6 	b	c0004a48 <smp_start_cpu+0x4a4>
		}
		*logical_id = (unsigned int)slot;
    c0004674:	b9403fe1 	ldr	w1, [sp, #60]
    c0004678:	f94013e0 	ldr	x0, [sp, #32]
    c000467c:	b9000001 	str	w1, [x0]
		new_cpu = true;
    c0004680:	52800020 	mov	w0, #0x1                   	// #1
    c0004684:	39013fe0 	strb	w0, [sp, #79]

		topology_register_cpu(*logical_id, mpidr, false);
    c0004688:	f94013e0 	ldr	x0, [sp, #32]
    c000468c:	b9400000 	ldr	w0, [x0]
    c0004690:	52800002 	mov	w2, #0x0                   	// #0
    c0004694:	f94017e1 	ldr	x1, [sp, #40]
    c0004698:	94000289 	bl	c00050bc <topology_register_cpu>
		cpu_states[*logical_id].logical_id = *logical_id;
    c000469c:	f94013e0 	ldr	x0, [sp, #32]
    c00046a0:	b9400001 	ldr	w1, [x0]
    c00046a4:	f94013e0 	ldr	x0, [sp, #32]
    c00046a8:	b9400002 	ldr	w2, [x0]
    c00046ac:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c00046b0:	911c8003 	add	x3, x0, #0x720
    c00046b4:	2a0103e1 	mov	w1, w1
    c00046b8:	aa0103e0 	mov	x0, x1
    c00046bc:	d37ff800 	lsl	x0, x0, #1
    c00046c0:	8b010000 	add	x0, x0, x1
    c00046c4:	d37df000 	lsl	x0, x0, #3
    c00046c8:	8b000060 	add	x0, x3, x0
    c00046cc:	b9000002 	str	w2, [x0]
		cpu_states[*logical_id].mpidr = mpidr;
    c00046d0:	f94013e0 	ldr	x0, [sp, #32]
    c00046d4:	b9400001 	ldr	w1, [x0]
    c00046d8:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c00046dc:	911c8002 	add	x2, x0, #0x720
    c00046e0:	2a0103e1 	mov	w1, w1
    c00046e4:	aa0103e0 	mov	x0, x1
    c00046e8:	d37ff800 	lsl	x0, x0, #1
    c00046ec:	8b010000 	add	x0, x0, x1
    c00046f0:	d37df000 	lsl	x0, x0, #3
    c00046f4:	8b000040 	add	x0, x2, x0
    c00046f8:	f94017e1 	ldr	x1, [sp, #40]
    c00046fc:	f9000401 	str	x1, [x0, #8]
		cpu_states[*logical_id].boot_cpu = false;
    c0004700:	f94013e0 	ldr	x0, [sp, #32]
    c0004704:	b9400001 	ldr	w1, [x0]
    c0004708:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c000470c:	911c8002 	add	x2, x0, #0x720
    c0004710:	2a0103e1 	mov	w1, w1
    c0004714:	aa0103e0 	mov	x0, x1
    c0004718:	d37ff800 	lsl	x0, x0, #1
    c000471c:	8b010000 	add	x0, x0, x1
    c0004720:	d37df000 	lsl	x0, x0, #3
    c0004724:	8b000040 	add	x0, x2, x0
    c0004728:	39004c1f 	strb	wzr, [x0, #19]
	}

	cpu_states[*logical_id].pending = true;
    c000472c:	f94013e0 	ldr	x0, [sp, #32]
    c0004730:	b9400001 	ldr	w1, [x0]
    c0004734:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c0004738:	911c8002 	add	x2, x0, #0x720
    c000473c:	2a0103e1 	mov	w1, w1
    c0004740:	aa0103e0 	mov	x0, x1
    c0004744:	d37ff800 	lsl	x0, x0, #1
    c0004748:	8b010000 	add	x0, x0, x1
    c000474c:	d37df000 	lsl	x0, x0, #3
    c0004750:	8b000040 	add	x0, x2, x0
    c0004754:	52800021 	mov	w1, #0x1                   	// #1
    c0004758:	39004801 	strb	w1, [x0, #18]
	cpu_states[*logical_id].online = false;
    c000475c:	f94013e0 	ldr	x0, [sp, #32]
    c0004760:	b9400001 	ldr	w1, [x0]
    c0004764:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c0004768:	911c8002 	add	x2, x0, #0x720
    c000476c:	2a0103e1 	mov	w1, w1
    c0004770:	aa0103e0 	mov	x0, x1
    c0004774:	d37ff800 	lsl	x0, x0, #1
    c0004778:	8b010000 	add	x0, x0, x1
    c000477c:	d37df000 	lsl	x0, x0, #3
    c0004780:	8b000040 	add	x0, x2, x0
    c0004784:	3900401f 	strb	wzr, [x0, #16]
	cpu_states[*logical_id].scheduled = false;
    c0004788:	f94013e0 	ldr	x0, [sp, #32]
    c000478c:	b9400001 	ldr	w1, [x0]
    c0004790:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c0004794:	911c8002 	add	x2, x0, #0x720
    c0004798:	2a0103e1 	mov	w1, w1
    c000479c:	aa0103e0 	mov	x0, x1
    c00047a0:	d37ff800 	lsl	x0, x0, #1
    c00047a4:	8b010000 	add	x0, x0, x1
    c00047a8:	d37df000 	lsl	x0, x0, #3
    c00047ac:	8b000040 	add	x0, x2, x0
    c00047b0:	3900441f 	strb	wzr, [x0, #17]

	ret = smp_smc_call(PSCI_CPU_ON_64, mpidr,
    c00047b4:	90ffffe0 	adrp	x0, c0000000 <_start>
    c00047b8:	91008001 	add	x1, x0, #0x20
			   (uintptr_t)secondary_cpu_entrypoint,
			   *logical_id);
    c00047bc:	f94013e0 	ldr	x0, [sp, #32]
    c00047c0:	b9400000 	ldr	w0, [x0]
	ret = smp_smc_call(PSCI_CPU_ON_64, mpidr,
    c00047c4:	2a0003e0 	mov	w0, w0
    c00047c8:	aa0003e3 	mov	x3, x0
    c00047cc:	aa0103e2 	mov	x2, x1
    c00047d0:	f94017e1 	ldr	x1, [sp, #40]
    c00047d4:	d2800060 	mov	x0, #0x3                   	// #3
    c00047d8:	f2b88000 	movk	x0, #0xc400, lsl #16
    c00047dc:	97fffe0b 	bl	c0004008 <smp_smc_call>
    c00047e0:	b9003be0 	str	w0, [sp, #56]
	*smc_ret = ret;
    c00047e4:	f9400fe0 	ldr	x0, [sp, #24]
    c00047e8:	b9403be1 	ldr	w1, [sp, #56]
    c00047ec:	b9000001 	str	w1, [x0]
	result = smp_map_psci_result(ret);
    c00047f0:	b9403be0 	ldr	w0, [sp, #56]
    c00047f4:	97fffec6 	bl	c000430c <smp_map_psci_result>
    c00047f8:	b90037e0 	str	w0, [sp, #52]

	if (result == SMP_START_OK) {
    c00047fc:	b94037e0 	ldr	w0, [sp, #52]
    c0004800:	7100001f 	cmp	w0, #0x0
    c0004804:	540004a1 	b.ne	c0004898 <smp_start_cpu+0x2f4>  // b.any
		if (!smp_wait_for_online(*logical_id, SMP_CPU_ON_TIMEOUT_US)) {
    c0004808:	f94013e0 	ldr	x0, [sp, #32]
    c000480c:	b9400000 	ldr	w0, [x0]
    c0004810:	5290d401 	mov	w1, #0x86a0                	// #34464
    c0004814:	72a00021 	movk	w1, #0x1, lsl #16
    c0004818:	97fffe5f 	bl	c0004194 <smp_wait_for_online>
    c000481c:	12001c00 	and	w0, w0, #0xff
    c0004820:	52000000 	eor	w0, w0, #0x1
    c0004824:	12001c00 	and	w0, w0, #0xff
    c0004828:	12000000 	and	w0, w0, #0x1
    c000482c:	7100001f 	cmp	w0, #0x0
    c0004830:	54000300 	b.eq	c0004890 <smp_start_cpu+0x2ec>  // b.none
			cpu_states[*logical_id].pending = false;
    c0004834:	f94013e0 	ldr	x0, [sp, #32]
    c0004838:	b9400001 	ldr	w1, [x0]
    c000483c:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c0004840:	911c8002 	add	x2, x0, #0x720
    c0004844:	2a0103e1 	mov	w1, w1
    c0004848:	aa0103e0 	mov	x0, x1
    c000484c:	d37ff800 	lsl	x0, x0, #1
    c0004850:	8b010000 	add	x0, x0, x1
    c0004854:	d37df000 	lsl	x0, x0, #3
    c0004858:	8b000040 	add	x0, x2, x0
    c000485c:	3900481f 	strb	wzr, [x0, #18]
			if (new_cpu) {
    c0004860:	39413fe0 	ldrb	w0, [sp, #79]
    c0004864:	12000000 	and	w0, w0, #0x1
    c0004868:	7100001f 	cmp	w0, #0x0
    c000486c:	540000e0 	b.eq	c0004888 <smp_start_cpu+0x2e4>  // b.none
				topology_unregister_cpu(*logical_id);
    c0004870:	f94013e0 	ldr	x0, [sp, #32]
    c0004874:	b9400000 	ldr	w0, [x0]
    c0004878:	94000245 	bl	c000518c <topology_unregister_cpu>
				smp_reset_cpu_state(*logical_id);
    c000487c:	f94013e0 	ldr	x0, [sp, #32]
    c0004880:	b9400000 	ldr	w0, [x0]
    c0004884:	97fffe04 	bl	c0004094 <smp_reset_cpu_state>
			}
			return SMP_START_TIMEOUT;
    c0004888:	12800060 	mov	w0, #0xfffffffc            	// #-4
    c000488c:	1400006f 	b	c0004a48 <smp_start_cpu+0x4a4>
		}
		return SMP_START_OK;
    c0004890:	52800000 	mov	w0, #0x0                   	// #0
    c0004894:	1400006d 	b	c0004a48 <smp_start_cpu+0x4a4>
	}

	if (result == SMP_START_ALREADY_ONLINE) {
    c0004898:	b94037e0 	ldr	w0, [sp, #52]
    c000489c:	7100041f 	cmp	w0, #0x1
    c00048a0:	54000a81 	b.ne	c00049f0 <smp_start_cpu+0x44c>  // b.any
		cpu_states[*logical_id].pending = false;
    c00048a4:	f94013e0 	ldr	x0, [sp, #32]
    c00048a8:	b9400001 	ldr	w1, [x0]
    c00048ac:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c00048b0:	911c8002 	add	x2, x0, #0x720
    c00048b4:	2a0103e1 	mov	w1, w1
    c00048b8:	aa0103e0 	mov	x0, x1
    c00048bc:	d37ff800 	lsl	x0, x0, #1
    c00048c0:	8b010000 	add	x0, x0, x1
    c00048c4:	d37df000 	lsl	x0, x0, #3
    c00048c8:	8b000040 	add	x0, x2, x0
    c00048cc:	3900481f 	strb	wzr, [x0, #18]

		/*
		 * 不能单凭 TF-A 返回 already-on 就认定 secondary 已经真正进入 mini-os。
		 * 只有 boot cpu 才天然成立；对于新注册但没观察到 online 的核，必须回滚。
		 */
		if (cpu_states[*logical_id].boot_cpu) {
    c00048d0:	f94013e0 	ldr	x0, [sp, #32]
    c00048d4:	b9400001 	ldr	w1, [x0]
    c00048d8:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c00048dc:	911c8002 	add	x2, x0, #0x720
    c00048e0:	2a0103e1 	mov	w1, w1
    c00048e4:	aa0103e0 	mov	x0, x1
    c00048e8:	d37ff800 	lsl	x0, x0, #1
    c00048ec:	8b010000 	add	x0, x0, x1
    c00048f0:	d37df000 	lsl	x0, x0, #3
    c00048f4:	8b000040 	add	x0, x2, x0
    c00048f8:	39404c00 	ldrb	w0, [x0, #19]
    c00048fc:	12000000 	and	w0, w0, #0x1
    c0004900:	7100001f 	cmp	w0, #0x0
    c0004904:	540003e0 	b.eq	c0004980 <smp_start_cpu+0x3dc>  // b.none
			cpu_states[*logical_id].online = true;
    c0004908:	f94013e0 	ldr	x0, [sp, #32]
    c000490c:	b9400001 	ldr	w1, [x0]
    c0004910:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c0004914:	911c8002 	add	x2, x0, #0x720
    c0004918:	2a0103e1 	mov	w1, w1
    c000491c:	aa0103e0 	mov	x0, x1
    c0004920:	d37ff800 	lsl	x0, x0, #1
    c0004924:	8b010000 	add	x0, x0, x1
    c0004928:	d37df000 	lsl	x0, x0, #3
    c000492c:	8b000040 	add	x0, x2, x0
    c0004930:	52800021 	mov	w1, #0x1                   	// #1
    c0004934:	39004001 	strb	w1, [x0, #16]
			cpu_states[*logical_id].scheduled = true;
    c0004938:	f94013e0 	ldr	x0, [sp, #32]
    c000493c:	b9400001 	ldr	w1, [x0]
    c0004940:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c0004944:	911c8002 	add	x2, x0, #0x720
    c0004948:	2a0103e1 	mov	w1, w1
    c000494c:	aa0103e0 	mov	x0, x1
    c0004950:	d37ff800 	lsl	x0, x0, #1
    c0004954:	8b010000 	add	x0, x0, x1
    c0004958:	d37df000 	lsl	x0, x0, #3
    c000495c:	8b000040 	add	x0, x2, x0
    c0004960:	52800021 	mov	w1, #0x1                   	// #1
    c0004964:	39004401 	strb	w1, [x0, #17]
			topology_mark_cpu_online(*logical_id, true);
    c0004968:	f94013e0 	ldr	x0, [sp, #32]
    c000496c:	b9400000 	ldr	w0, [x0]
    c0004970:	52800021 	mov	w1, #0x1                   	// #1
    c0004974:	94000170 	bl	c0004f34 <topology_mark_cpu_online>
			return SMP_START_ALREADY_ONLINE;
    c0004978:	52800020 	mov	w0, #0x1                   	// #1
    c000497c:	14000033 	b	c0004a48 <smp_start_cpu+0x4a4>
		}

		if (!cpu_states[*logical_id].online && new_cpu) {
    c0004980:	f94013e0 	ldr	x0, [sp, #32]
    c0004984:	b9400001 	ldr	w1, [x0]
    c0004988:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c000498c:	911c8002 	add	x2, x0, #0x720
    c0004990:	2a0103e1 	mov	w1, w1
    c0004994:	aa0103e0 	mov	x0, x1
    c0004998:	d37ff800 	lsl	x0, x0, #1
    c000499c:	8b010000 	add	x0, x0, x1
    c00049a0:	d37df000 	lsl	x0, x0, #3
    c00049a4:	8b000040 	add	x0, x2, x0
    c00049a8:	39404000 	ldrb	w0, [x0, #16]
    c00049ac:	52000000 	eor	w0, w0, #0x1
    c00049b0:	12001c00 	and	w0, w0, #0xff
    c00049b4:	12000000 	and	w0, w0, #0x1
    c00049b8:	7100001f 	cmp	w0, #0x0
    c00049bc:	54000160 	b.eq	c00049e8 <smp_start_cpu+0x444>  // b.none
    c00049c0:	39413fe0 	ldrb	w0, [sp, #79]
    c00049c4:	12000000 	and	w0, w0, #0x1
    c00049c8:	7100001f 	cmp	w0, #0x0
    c00049cc:	540000e0 	b.eq	c00049e8 <smp_start_cpu+0x444>  // b.none
			topology_unregister_cpu(*logical_id);
    c00049d0:	f94013e0 	ldr	x0, [sp, #32]
    c00049d4:	b9400000 	ldr	w0, [x0]
    c00049d8:	940001ed 	bl	c000518c <topology_unregister_cpu>
			smp_reset_cpu_state(*logical_id);
    c00049dc:	f94013e0 	ldr	x0, [sp, #32]
    c00049e0:	b9400000 	ldr	w0, [x0]
    c00049e4:	97fffdac 	bl	c0004094 <smp_reset_cpu_state>
		}

		return SMP_START_ALREADY_ONLINE;
    c00049e8:	52800020 	mov	w0, #0x1                   	// #1
    c00049ec:	14000017 	b	c0004a48 <smp_start_cpu+0x4a4>
	}

	cpu_states[*logical_id].pending = false;
    c00049f0:	f94013e0 	ldr	x0, [sp, #32]
    c00049f4:	b9400001 	ldr	w1, [x0]
    c00049f8:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c00049fc:	911c8002 	add	x2, x0, #0x720
    c0004a00:	2a0103e1 	mov	w1, w1
    c0004a04:	aa0103e0 	mov	x0, x1
    c0004a08:	d37ff800 	lsl	x0, x0, #1
    c0004a0c:	8b010000 	add	x0, x0, x1
    c0004a10:	d37df000 	lsl	x0, x0, #3
    c0004a14:	8b000040 	add	x0, x2, x0
    c0004a18:	3900481f 	strb	wzr, [x0, #18]

	if (new_cpu) {
    c0004a1c:	39413fe0 	ldrb	w0, [sp, #79]
    c0004a20:	12000000 	and	w0, w0, #0x1
    c0004a24:	7100001f 	cmp	w0, #0x0
    c0004a28:	540000e0 	b.eq	c0004a44 <smp_start_cpu+0x4a0>  // b.none
		topology_unregister_cpu(*logical_id);
    c0004a2c:	f94013e0 	ldr	x0, [sp, #32]
    c0004a30:	b9400000 	ldr	w0, [x0]
    c0004a34:	940001d6 	bl	c000518c <topology_unregister_cpu>
		smp_reset_cpu_state(*logical_id);
    c0004a38:	f94013e0 	ldr	x0, [sp, #32]
    c0004a3c:	b9400000 	ldr	w0, [x0]
    c0004a40:	97fffd95 	bl	c0004094 <smp_reset_cpu_state>
	}

	return result;
    c0004a44:	b94037e0 	ldr	w0, [sp, #52]
}
    c0004a48:	a8c57bfd 	ldp	x29, x30, [sp], #80
    c0004a4c:	d65f03c0 	ret

00000000c0004a50 <smp_cpu_state>:

const struct smp_cpu_state *smp_cpu_state(unsigned int logical_id)
{
    c0004a50:	d10043ff 	sub	sp, sp, #0x10
    c0004a54:	b9000fe0 	str	w0, [sp, #12]
	if (logical_id >= PLAT_MAX_CPUS) {
    c0004a58:	b9400fe0 	ldr	w0, [sp, #12]
    c0004a5c:	71001c1f 	cmp	w0, #0x7
    c0004a60:	54000069 	b.ls	c0004a6c <smp_cpu_state+0x1c>  // b.plast
		return (const struct smp_cpu_state *)0;
    c0004a64:	d2800000 	mov	x0, #0x0                   	// #0
    c0004a68:	14000009 	b	c0004a8c <smp_cpu_state+0x3c>
	}

	return &cpu_states[logical_id];
    c0004a6c:	b9400fe1 	ldr	w1, [sp, #12]
    c0004a70:	aa0103e0 	mov	x0, x1
    c0004a74:	d37ff800 	lsl	x0, x0, #1
    c0004a78:	8b010000 	add	x0, x0, x1
    c0004a7c:	d37df000 	lsl	x0, x0, #3
    c0004a80:	d0000041 	adrp	x1, c000e000 <secondary_stacks+0x78e0>
    c0004a84:	911c8021 	add	x1, x1, #0x720
    c0004a88:	8b010000 	add	x0, x0, x1
}
    c0004a8c:	910043ff 	add	sp, sp, #0x10
    c0004a90:	d65f03c0 	ret

00000000c0004a94 <smp_online_cpu_count>:

unsigned int smp_online_cpu_count(void)
{
	return online_cpu_count;
    c0004a94:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c0004a98:	911f8000 	add	x0, x0, #0x7e0
    c0004a9c:	b9400000 	ldr	w0, [x0]
}
    c0004aa0:	d65f03c0 	ret

00000000c0004aa4 <smp_secondary_cpu_online>:

void smp_secondary_cpu_online(unsigned int logical_id)
{
    c0004aa4:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c0004aa8:	910003fd 	mov	x29, sp
    c0004aac:	b9001fe0 	str	w0, [sp, #28]
	if ((logical_id >= PLAT_MAX_CPUS) || cpu_states[logical_id].online) {
    c0004ab0:	b9401fe0 	ldr	w0, [sp, #28]
    c0004ab4:	71001c1f 	cmp	w0, #0x7
    c0004ab8:	540006e8 	b.hi	c0004b94 <smp_secondary_cpu_online+0xf0>  // b.pmore
    c0004abc:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c0004ac0:	911c8002 	add	x2, x0, #0x720
    c0004ac4:	b9401fe1 	ldr	w1, [sp, #28]
    c0004ac8:	aa0103e0 	mov	x0, x1
    c0004acc:	d37ff800 	lsl	x0, x0, #1
    c0004ad0:	8b010000 	add	x0, x0, x1
    c0004ad4:	d37df000 	lsl	x0, x0, #3
    c0004ad8:	8b000040 	add	x0, x2, x0
    c0004adc:	39404000 	ldrb	w0, [x0, #16]
    c0004ae0:	12000000 	and	w0, w0, #0x1
    c0004ae4:	7100001f 	cmp	w0, #0x0
    c0004ae8:	54000561 	b.ne	c0004b94 <smp_secondary_cpu_online+0xf0>  // b.any
		return;
	}

	cpu_states[logical_id].pending = false;
    c0004aec:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c0004af0:	911c8002 	add	x2, x0, #0x720
    c0004af4:	b9401fe1 	ldr	w1, [sp, #28]
    c0004af8:	aa0103e0 	mov	x0, x1
    c0004afc:	d37ff800 	lsl	x0, x0, #1
    c0004b00:	8b010000 	add	x0, x0, x1
    c0004b04:	d37df000 	lsl	x0, x0, #3
    c0004b08:	8b000040 	add	x0, x2, x0
    c0004b0c:	3900481f 	strb	wzr, [x0, #18]
	cpu_states[logical_id].online = true;
    c0004b10:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c0004b14:	911c8002 	add	x2, x0, #0x720
    c0004b18:	b9401fe1 	ldr	w1, [sp, #28]
    c0004b1c:	aa0103e0 	mov	x0, x1
    c0004b20:	d37ff800 	lsl	x0, x0, #1
    c0004b24:	8b010000 	add	x0, x0, x1
    c0004b28:	d37df000 	lsl	x0, x0, #3
    c0004b2c:	8b000040 	add	x0, x2, x0
    c0004b30:	52800021 	mov	w1, #0x1                   	// #1
    c0004b34:	39004001 	strb	w1, [x0, #16]
	cpu_states[logical_id].scheduled = true;
    c0004b38:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c0004b3c:	911c8002 	add	x2, x0, #0x720
    c0004b40:	b9401fe1 	ldr	w1, [sp, #28]
    c0004b44:	aa0103e0 	mov	x0, x1
    c0004b48:	d37ff800 	lsl	x0, x0, #1
    c0004b4c:	8b010000 	add	x0, x0, x1
    c0004b50:	d37df000 	lsl	x0, x0, #3
    c0004b54:	8b000040 	add	x0, x2, x0
    c0004b58:	52800021 	mov	w1, #0x1                   	// #1
    c0004b5c:	39004401 	strb	w1, [x0, #17]
	online_cpu_count++;
    c0004b60:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c0004b64:	911f8000 	add	x0, x0, #0x7e0
    c0004b68:	b9400000 	ldr	w0, [x0]
    c0004b6c:	11000401 	add	w1, w0, #0x1
    c0004b70:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c0004b74:	911f8000 	add	x0, x0, #0x7e0
    c0004b78:	b9000001 	str	w1, [x0]
	topology_mark_cpu_online(logical_id, true);
    c0004b7c:	52800021 	mov	w1, #0x1                   	// #1
    c0004b80:	b9401fe0 	ldr	w0, [sp, #28]
    c0004b84:	940000ec 	bl	c0004f34 <topology_mark_cpu_online>
	scheduler_join_cpu(logical_id);
    c0004b88:	b9401fe0 	ldr	w0, [sp, #28]
    c0004b8c:	97fff760 	bl	c000290c <scheduler_join_cpu>
    c0004b90:	14000002 	b	c0004b98 <smp_secondary_cpu_online+0xf4>
		return;
    c0004b94:	d503201f 	nop
}
    c0004b98:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c0004b9c:	d65f03c0 	ret

00000000c0004ba0 <smp_secondary_entry>:

void smp_secondary_entry(uint64_t logical_id)
{
    c0004ba0:	a9bd7bfd 	stp	x29, x30, [sp, #-48]!
    c0004ba4:	910003fd 	mov	x29, sp
    c0004ba8:	a90153f3 	stp	x19, x20, [sp, #16]
    c0004bac:	f90017e0 	str	x0, [sp, #40]
	smp_secondary_cpu_online((unsigned int)logical_id);
    c0004bb0:	f94017e0 	ldr	x0, [sp, #40]
    c0004bb4:	97ffffbc 	bl	c0004aa4 <smp_secondary_cpu_online>
	mini_os_printf("secondary cpu%u online (mpidr=0x%llx), scheduler runnable=%u\n",
    c0004bb8:	f94017e0 	ldr	x0, [sp, #40]
    c0004bbc:	2a0003f4 	mov	w20, w0
		       (unsigned int)logical_id,
		       (unsigned long long)cpu_states[logical_id].mpidr,
    c0004bc0:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c0004bc4:	911c8002 	add	x2, x0, #0x720
    c0004bc8:	f94017e1 	ldr	x1, [sp, #40]
    c0004bcc:	aa0103e0 	mov	x0, x1
    c0004bd0:	d37ff800 	lsl	x0, x0, #1
    c0004bd4:	8b010000 	add	x0, x0, x1
    c0004bd8:	d37df000 	lsl	x0, x0, #3
    c0004bdc:	8b000040 	add	x0, x2, x0
    c0004be0:	f9400413 	ldr	x19, [x0, #8]
	mini_os_printf("secondary cpu%u online (mpidr=0x%llx), scheduler runnable=%u\n",
    c0004be4:	97fff772 	bl	c00029ac <scheduler_runnable_cpu_count>
    c0004be8:	2a0003e3 	mov	w3, w0
    c0004bec:	aa1303e2 	mov	x2, x19
    c0004bf0:	2a1403e1 	mov	w1, w20
    c0004bf4:	d0000000 	adrp	x0, c0006000 <hex.0+0xc88>
    c0004bf8:	911ac000 	add	x0, x0, #0x6b0
    c0004bfc:	97fff430 	bl	c0001cbc <mini_os_printf>
		       scheduler_runnable_cpu_count());

	for (;;) {
		__asm__ volatile ("wfe");
    c0004c00:	d503205f 	wfe
    c0004c04:	17ffffff 	b	c0004c00 <smp_secondary_entry+0x60>

00000000c0004c08 <smp_secondary_entrypoint>:
	}
}

uintptr_t smp_secondary_entrypoint(void)
{
	return (uintptr_t)secondary_cpu_entrypoint;
    c0004c08:	90ffffe0 	adrp	x0, c0000000 <_start>
    c0004c0c:	91008000 	add	x0, x0, #0x20
    c0004c10:	d65f03c0 	ret

00000000c0004c14 <test_framework_init>:
#include <kernel/test.h>

void test_framework_init(void)
{
    c0004c14:	d503201f 	nop
    c0004c18:	d65f03c0 	ret

00000000c0004c1c <topology_read_mpidr>:
static struct cpu_topology_descriptor cpu_descs[PLAT_MAX_CPUS];
static unsigned int present_cpu_count;
static unsigned int online_cpu_count;

static inline uint64_t topology_read_mpidr(void)
{
    c0004c1c:	d10043ff 	sub	sp, sp, #0x10
	uint64_t mpidr;

	__asm__ volatile ("mrs %0, mpidr_el1" : "=r" (mpidr));
    c0004c20:	d53800a0 	mrs	x0, mpidr_el1
    c0004c24:	f90007e0 	str	x0, [sp, #8]
	return mpidr;
    c0004c28:	f94007e0 	ldr	x0, [sp, #8]
}
    c0004c2c:	910043ff 	add	sp, sp, #0x10
    c0004c30:	d65f03c0 	ret

00000000c0004c34 <topology_fill_descriptor>:

static void topology_fill_descriptor(struct cpu_topology_descriptor *cpu,
				     unsigned int logical_id,
				     uint64_t mpidr,
				     bool boot_cpu)
{
    c0004c34:	d10083ff 	sub	sp, sp, #0x20
    c0004c38:	f9000fe0 	str	x0, [sp, #24]
    c0004c3c:	b90017e1 	str	w1, [sp, #20]
    c0004c40:	f90007e2 	str	x2, [sp, #8]
    c0004c44:	39004fe3 	strb	w3, [sp, #19]
	cpu->logical_id = logical_id;
    c0004c48:	f9400fe0 	ldr	x0, [sp, #24]
    c0004c4c:	b94017e1 	ldr	w1, [sp, #20]
    c0004c50:	b9000801 	str	w1, [x0, #8]
	cpu->mpidr = mpidr;
    c0004c54:	f9400fe0 	ldr	x0, [sp, #24]
    c0004c58:	f94007e1 	ldr	x1, [sp, #8]
    c0004c5c:	f9000001 	str	x1, [x0]
	cpu->chip_id = (unsigned int)((mpidr & MPIDR_AFF3_MASK) >> MPIDR_AFF3_SHIFT);
    c0004c60:	f94007e0 	ldr	x0, [sp, #8]
    c0004c64:	d358fc00 	lsr	x0, x0, #24
    c0004c68:	12001c01 	and	w1, w0, #0xff
    c0004c6c:	f9400fe0 	ldr	x0, [sp, #24]
    c0004c70:	b9000c01 	str	w1, [x0, #12]
	cpu->die_id = (unsigned int)((mpidr & MPIDR_AFF2_MASK) >> MPIDR_AFF2_SHIFT);
    c0004c74:	f94007e0 	ldr	x0, [sp, #8]
    c0004c78:	d350fc00 	lsr	x0, x0, #16
    c0004c7c:	12001c01 	and	w1, w0, #0xff
    c0004c80:	f9400fe0 	ldr	x0, [sp, #24]
    c0004c84:	b9001001 	str	w1, [x0, #16]
	cpu->cluster_id = (unsigned int)((mpidr & MPIDR_AFF1_MASK) >> MPIDR_AFF1_SHIFT);
    c0004c88:	f94007e0 	ldr	x0, [sp, #8]
    c0004c8c:	d348fc00 	lsr	x0, x0, #8
    c0004c90:	12001c01 	and	w1, w0, #0xff
    c0004c94:	f9400fe0 	ldr	x0, [sp, #24]
    c0004c98:	b9001401 	str	w1, [x0, #20]
	cpu->core_id = (unsigned int)(mpidr & MPIDR_AFF0_MASK);
    c0004c9c:	f94007e0 	ldr	x0, [sp, #8]
    c0004ca0:	12001c01 	and	w1, w0, #0xff
    c0004ca4:	f9400fe0 	ldr	x0, [sp, #24]
    c0004ca8:	b9001801 	str	w1, [x0, #24]
	cpu->boot_cpu = boot_cpu;
    c0004cac:	f9400fe0 	ldr	x0, [sp, #24]
    c0004cb0:	39404fe1 	ldrb	w1, [sp, #19]
    c0004cb4:	39007001 	strb	w1, [x0, #28]
}
    c0004cb8:	d503201f 	nop
    c0004cbc:	910083ff 	add	sp, sp, #0x20
    c0004cc0:	d65f03c0 	ret

00000000c0004cc4 <topology_init>:

void topology_init(void)
{
    c0004cc4:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c0004cc8:	910003fd 	mov	x29, sp
	unsigned int i;
	uint64_t mpidr = topology_read_mpidr();
    c0004ccc:	97ffffd4 	bl	c0004c1c <topology_read_mpidr>
    c0004cd0:	f9000be0 	str	x0, [sp, #16]

	for (i = 0U; i < PLAT_MAX_CPUS; ++i) {
    c0004cd4:	b9001fff 	str	wzr, [sp, #28]
    c0004cd8:	1400003b 	b	c0004dc4 <topology_init+0x100>
		cpu_descs[i].logical_id = i;
    c0004cdc:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c0004ce0:	911fa001 	add	x1, x0, #0x7e8
    c0004ce4:	b9401fe0 	ldr	w0, [sp, #28]
    c0004ce8:	d37be800 	lsl	x0, x0, #5
    c0004cec:	8b000020 	add	x0, x1, x0
    c0004cf0:	b9401fe1 	ldr	w1, [sp, #28]
    c0004cf4:	b9000801 	str	w1, [x0, #8]
		cpu_descs[i].present = false;
    c0004cf8:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c0004cfc:	911fa001 	add	x1, x0, #0x7e8
    c0004d00:	b9401fe0 	ldr	w0, [sp, #28]
    c0004d04:	d37be800 	lsl	x0, x0, #5
    c0004d08:	8b000020 	add	x0, x1, x0
    c0004d0c:	3900741f 	strb	wzr, [x0, #29]
		cpu_descs[i].online = false;
    c0004d10:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c0004d14:	911fa001 	add	x1, x0, #0x7e8
    c0004d18:	b9401fe0 	ldr	w0, [sp, #28]
    c0004d1c:	d37be800 	lsl	x0, x0, #5
    c0004d20:	8b000020 	add	x0, x1, x0
    c0004d24:	3900781f 	strb	wzr, [x0, #30]
		cpu_descs[i].boot_cpu = false;
    c0004d28:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c0004d2c:	911fa001 	add	x1, x0, #0x7e8
    c0004d30:	b9401fe0 	ldr	w0, [sp, #28]
    c0004d34:	d37be800 	lsl	x0, x0, #5
    c0004d38:	8b000020 	add	x0, x1, x0
    c0004d3c:	3900701f 	strb	wzr, [x0, #28]
		cpu_descs[i].mpidr = 0U;
    c0004d40:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c0004d44:	911fa001 	add	x1, x0, #0x7e8
    c0004d48:	b9401fe0 	ldr	w0, [sp, #28]
    c0004d4c:	d37be800 	lsl	x0, x0, #5
    c0004d50:	8b000020 	add	x0, x1, x0
    c0004d54:	f900001f 	str	xzr, [x0]
		cpu_descs[i].chip_id = 0U;
    c0004d58:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c0004d5c:	911fa001 	add	x1, x0, #0x7e8
    c0004d60:	b9401fe0 	ldr	w0, [sp, #28]
    c0004d64:	d37be800 	lsl	x0, x0, #5
    c0004d68:	8b000020 	add	x0, x1, x0
    c0004d6c:	b9000c1f 	str	wzr, [x0, #12]
		cpu_descs[i].die_id = 0U;
    c0004d70:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c0004d74:	911fa001 	add	x1, x0, #0x7e8
    c0004d78:	b9401fe0 	ldr	w0, [sp, #28]
    c0004d7c:	d37be800 	lsl	x0, x0, #5
    c0004d80:	8b000020 	add	x0, x1, x0
    c0004d84:	b900101f 	str	wzr, [x0, #16]
		cpu_descs[i].cluster_id = 0U;
    c0004d88:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c0004d8c:	911fa001 	add	x1, x0, #0x7e8
    c0004d90:	b9401fe0 	ldr	w0, [sp, #28]
    c0004d94:	d37be800 	lsl	x0, x0, #5
    c0004d98:	8b000020 	add	x0, x1, x0
    c0004d9c:	b900141f 	str	wzr, [x0, #20]
		cpu_descs[i].core_id = 0U;
    c0004da0:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c0004da4:	911fa001 	add	x1, x0, #0x7e8
    c0004da8:	b9401fe0 	ldr	w0, [sp, #28]
    c0004dac:	d37be800 	lsl	x0, x0, #5
    c0004db0:	8b000020 	add	x0, x1, x0
    c0004db4:	b900181f 	str	wzr, [x0, #24]
	for (i = 0U; i < PLAT_MAX_CPUS; ++i) {
    c0004db8:	b9401fe0 	ldr	w0, [sp, #28]
    c0004dbc:	11000400 	add	w0, w0, #0x1
    c0004dc0:	b9001fe0 	str	w0, [sp, #28]
    c0004dc4:	b9401fe0 	ldr	w0, [sp, #28]
    c0004dc8:	71001c1f 	cmp	w0, #0x7
    c0004dcc:	54fff889 	b.ls	c0004cdc <topology_init+0x18>  // b.plast
	}

	topology_fill_descriptor(&cpu_descs[0], 0U, mpidr, true);
    c0004dd0:	52800023 	mov	w3, #0x1                   	// #1
    c0004dd4:	f9400be2 	ldr	x2, [sp, #16]
    c0004dd8:	52800001 	mov	w1, #0x0                   	// #0
    c0004ddc:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c0004de0:	911fa000 	add	x0, x0, #0x7e8
    c0004de4:	97ffff94 	bl	c0004c34 <topology_fill_descriptor>
	cpu_descs[0].present = true;
    c0004de8:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c0004dec:	911fa000 	add	x0, x0, #0x7e8
    c0004df0:	52800021 	mov	w1, #0x1                   	// #1
    c0004df4:	39007401 	strb	w1, [x0, #29]
	cpu_descs[0].online = true;
    c0004df8:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c0004dfc:	911fa000 	add	x0, x0, #0x7e8
    c0004e00:	52800021 	mov	w1, #0x1                   	// #1
    c0004e04:	39007801 	strb	w1, [x0, #30]
	present_cpu_count = 1U;
    c0004e08:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c0004e0c:	9123a000 	add	x0, x0, #0x8e8
    c0004e10:	52800021 	mov	w1, #0x1                   	// #1
    c0004e14:	b9000001 	str	w1, [x0]
	online_cpu_count = 1U;
    c0004e18:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c0004e1c:	9123b000 	add	x0, x0, #0x8ec
    c0004e20:	52800021 	mov	w1, #0x1                   	// #1
    c0004e24:	b9000001 	str	w1, [x0]
}
    c0004e28:	d503201f 	nop
    c0004e2c:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c0004e30:	d65f03c0 	ret

00000000c0004e34 <topology_boot_cpu>:

const struct cpu_topology_descriptor *topology_boot_cpu(void)
{
	return &cpu_descs[0];
    c0004e34:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c0004e38:	911fa000 	add	x0, x0, #0x7e8
}
    c0004e3c:	d65f03c0 	ret

00000000c0004e40 <topology_cpu>:

const struct cpu_topology_descriptor *topology_cpu(unsigned int logical_id)
{
    c0004e40:	d10043ff 	sub	sp, sp, #0x10
    c0004e44:	b9000fe0 	str	w0, [sp, #12]
	if (logical_id >= PLAT_MAX_CPUS) {
    c0004e48:	b9400fe0 	ldr	w0, [sp, #12]
    c0004e4c:	71001c1f 	cmp	w0, #0x7
    c0004e50:	54000069 	b.ls	c0004e5c <topology_cpu+0x1c>  // b.plast
		return (const struct cpu_topology_descriptor *)0;
    c0004e54:	d2800000 	mov	x0, #0x0                   	// #0
    c0004e58:	14000006 	b	c0004e70 <topology_cpu+0x30>
	}

	return &cpu_descs[logical_id];
    c0004e5c:	b9400fe0 	ldr	w0, [sp, #12]
    c0004e60:	d37be801 	lsl	x1, x0, #5
    c0004e64:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c0004e68:	911fa000 	add	x0, x0, #0x7e8
    c0004e6c:	8b000020 	add	x0, x1, x0
}
    c0004e70:	910043ff 	add	sp, sp, #0x10
    c0004e74:	d65f03c0 	ret

00000000c0004e78 <topology_find_cpu_by_mpidr>:

const struct cpu_topology_descriptor *topology_find_cpu_by_mpidr(uint64_t mpidr)
{
    c0004e78:	d10083ff 	sub	sp, sp, #0x20
    c0004e7c:	f90007e0 	str	x0, [sp, #8]
	unsigned int i;

	for (i = 0U; i < PLAT_MAX_CPUS; ++i) {
    c0004e80:	b9001fff 	str	wzr, [sp, #28]
    c0004e84:	1400001c 	b	c0004ef4 <topology_find_cpu_by_mpidr+0x7c>
		if (cpu_descs[i].present && (cpu_descs[i].mpidr == mpidr)) {
    c0004e88:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c0004e8c:	911fa001 	add	x1, x0, #0x7e8
    c0004e90:	b9401fe0 	ldr	w0, [sp, #28]
    c0004e94:	d37be800 	lsl	x0, x0, #5
    c0004e98:	8b000020 	add	x0, x1, x0
    c0004e9c:	39407400 	ldrb	w0, [x0, #29]
    c0004ea0:	12000000 	and	w0, w0, #0x1
    c0004ea4:	7100001f 	cmp	w0, #0x0
    c0004ea8:	54000200 	b.eq	c0004ee8 <topology_find_cpu_by_mpidr+0x70>  // b.none
    c0004eac:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c0004eb0:	911fa001 	add	x1, x0, #0x7e8
    c0004eb4:	b9401fe0 	ldr	w0, [sp, #28]
    c0004eb8:	d37be800 	lsl	x0, x0, #5
    c0004ebc:	8b000020 	add	x0, x1, x0
    c0004ec0:	f9400000 	ldr	x0, [x0]
    c0004ec4:	f94007e1 	ldr	x1, [sp, #8]
    c0004ec8:	eb00003f 	cmp	x1, x0
    c0004ecc:	540000e1 	b.ne	c0004ee8 <topology_find_cpu_by_mpidr+0x70>  // b.any
			return &cpu_descs[i];
    c0004ed0:	b9401fe0 	ldr	w0, [sp, #28]
    c0004ed4:	d37be801 	lsl	x1, x0, #5
    c0004ed8:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c0004edc:	911fa000 	add	x0, x0, #0x7e8
    c0004ee0:	8b000020 	add	x0, x1, x0
    c0004ee4:	14000008 	b	c0004f04 <topology_find_cpu_by_mpidr+0x8c>
	for (i = 0U; i < PLAT_MAX_CPUS; ++i) {
    c0004ee8:	b9401fe0 	ldr	w0, [sp, #28]
    c0004eec:	11000400 	add	w0, w0, #0x1
    c0004ef0:	b9001fe0 	str	w0, [sp, #28]
    c0004ef4:	b9401fe0 	ldr	w0, [sp, #28]
    c0004ef8:	71001c1f 	cmp	w0, #0x7
    c0004efc:	54fffc69 	b.ls	c0004e88 <topology_find_cpu_by_mpidr+0x10>  // b.plast
		}
	}

	return (const struct cpu_topology_descriptor *)0;
    c0004f00:	d2800000 	mov	x0, #0x0                   	// #0
}
    c0004f04:	910083ff 	add	sp, sp, #0x20
    c0004f08:	d65f03c0 	ret

00000000c0004f0c <topology_cpu_capacity>:

unsigned int topology_cpu_capacity(void)
{
	return PLAT_MAX_CPUS;
    c0004f0c:	52800100 	mov	w0, #0x8                   	// #8
}
    c0004f10:	d65f03c0 	ret

00000000c0004f14 <topology_present_cpu_count>:

unsigned int topology_present_cpu_count(void)
{
	return present_cpu_count;
    c0004f14:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c0004f18:	9123a000 	add	x0, x0, #0x8e8
    c0004f1c:	b9400000 	ldr	w0, [x0]
}
    c0004f20:	d65f03c0 	ret

00000000c0004f24 <topology_online_cpu_count>:

unsigned int topology_online_cpu_count(void)
{
	return online_cpu_count;
    c0004f24:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c0004f28:	9123b000 	add	x0, x0, #0x8ec
    c0004f2c:	b9400000 	ldr	w0, [x0]
}
    c0004f30:	d65f03c0 	ret

00000000c0004f34 <topology_mark_cpu_online>:

void topology_mark_cpu_online(unsigned int logical_id, bool online)
{
    c0004f34:	d10043ff 	sub	sp, sp, #0x10
    c0004f38:	b9000fe0 	str	w0, [sp, #12]
    c0004f3c:	39002fe1 	strb	w1, [sp, #11]
	if (logical_id >= PLAT_MAX_CPUS) {
    c0004f40:	b9400fe0 	ldr	w0, [sp, #12]
    c0004f44:	71001c1f 	cmp	w0, #0x7
    c0004f48:	54000b48 	b.hi	c00050b0 <topology_mark_cpu_online+0x17c>  // b.pmore
		return;
	}

	if (!cpu_descs[logical_id].present) {
    c0004f4c:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c0004f50:	911fa001 	add	x1, x0, #0x7e8
    c0004f54:	b9400fe0 	ldr	w0, [sp, #12]
    c0004f58:	d37be800 	lsl	x0, x0, #5
    c0004f5c:	8b000020 	add	x0, x1, x0
    c0004f60:	39407400 	ldrb	w0, [x0, #29]
    c0004f64:	52000000 	eor	w0, w0, #0x1
    c0004f68:	12001c00 	and	w0, w0, #0xff
    c0004f6c:	12000000 	and	w0, w0, #0x1
    c0004f70:	7100001f 	cmp	w0, #0x0
    c0004f74:	540001e0 	b.eq	c0004fb0 <topology_mark_cpu_online+0x7c>  // b.none
		cpu_descs[logical_id].present = true;
    c0004f78:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c0004f7c:	911fa001 	add	x1, x0, #0x7e8
    c0004f80:	b9400fe0 	ldr	w0, [sp, #12]
    c0004f84:	d37be800 	lsl	x0, x0, #5
    c0004f88:	8b000020 	add	x0, x1, x0
    c0004f8c:	52800021 	mov	w1, #0x1                   	// #1
    c0004f90:	39007401 	strb	w1, [x0, #29]
		present_cpu_count++;
    c0004f94:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c0004f98:	9123a000 	add	x0, x0, #0x8e8
    c0004f9c:	b9400000 	ldr	w0, [x0]
    c0004fa0:	11000401 	add	w1, w0, #0x1
    c0004fa4:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c0004fa8:	9123a000 	add	x0, x0, #0x8e8
    c0004fac:	b9000001 	str	w1, [x0]
	}

	if (online && !cpu_descs[logical_id].online) {
    c0004fb0:	39402fe0 	ldrb	w0, [sp, #11]
    c0004fb4:	12000000 	and	w0, w0, #0x1
    c0004fb8:	7100001f 	cmp	w0, #0x0
    c0004fbc:	54000360 	b.eq	c0005028 <topology_mark_cpu_online+0xf4>  // b.none
    c0004fc0:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c0004fc4:	911fa001 	add	x1, x0, #0x7e8
    c0004fc8:	b9400fe0 	ldr	w0, [sp, #12]
    c0004fcc:	d37be800 	lsl	x0, x0, #5
    c0004fd0:	8b000020 	add	x0, x1, x0
    c0004fd4:	39407800 	ldrb	w0, [x0, #30]
    c0004fd8:	52000000 	eor	w0, w0, #0x1
    c0004fdc:	12001c00 	and	w0, w0, #0xff
    c0004fe0:	12000000 	and	w0, w0, #0x1
    c0004fe4:	7100001f 	cmp	w0, #0x0
    c0004fe8:	54000200 	b.eq	c0005028 <topology_mark_cpu_online+0xf4>  // b.none
		cpu_descs[logical_id].online = true;
    c0004fec:	d0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c0004ff0:	911fa001 	add	x1, x0, #0x7e8
    c0004ff4:	b9400fe0 	ldr	w0, [sp, #12]
    c0004ff8:	d37be800 	lsl	x0, x0, #5
    c0004ffc:	8b000020 	add	x0, x1, x0
    c0005000:	52800021 	mov	w1, #0x1                   	// #1
    c0005004:	39007801 	strb	w1, [x0, #30]
		online_cpu_count++;
    c0005008:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c000500c:	9123b000 	add	x0, x0, #0x8ec
    c0005010:	b9400000 	ldr	w0, [x0]
    c0005014:	11000401 	add	w1, w0, #0x1
    c0005018:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c000501c:	9123b000 	add	x0, x0, #0x8ec
    c0005020:	b9000001 	str	w1, [x0]
    c0005024:	14000024 	b	c00050b4 <topology_mark_cpu_online+0x180>
	} else if (!online && cpu_descs[logical_id].online) {
    c0005028:	39402fe0 	ldrb	w0, [sp, #11]
    c000502c:	52000000 	eor	w0, w0, #0x1
    c0005030:	12001c00 	and	w0, w0, #0xff
    c0005034:	12000000 	and	w0, w0, #0x1
    c0005038:	7100001f 	cmp	w0, #0x0
    c000503c:	540003c0 	b.eq	c00050b4 <topology_mark_cpu_online+0x180>  // b.none
    c0005040:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c0005044:	911fa001 	add	x1, x0, #0x7e8
    c0005048:	b9400fe0 	ldr	w0, [sp, #12]
    c000504c:	d37be800 	lsl	x0, x0, #5
    c0005050:	8b000020 	add	x0, x1, x0
    c0005054:	39407800 	ldrb	w0, [x0, #30]
    c0005058:	12000000 	and	w0, w0, #0x1
    c000505c:	7100001f 	cmp	w0, #0x0
    c0005060:	540002a0 	b.eq	c00050b4 <topology_mark_cpu_online+0x180>  // b.none
		cpu_descs[logical_id].online = false;
    c0005064:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c0005068:	911fa001 	add	x1, x0, #0x7e8
    c000506c:	b9400fe0 	ldr	w0, [sp, #12]
    c0005070:	d37be800 	lsl	x0, x0, #5
    c0005074:	8b000020 	add	x0, x1, x0
    c0005078:	3900781f 	strb	wzr, [x0, #30]
		if (online_cpu_count > 0U) {
    c000507c:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c0005080:	9123b000 	add	x0, x0, #0x8ec
    c0005084:	b9400000 	ldr	w0, [x0]
    c0005088:	7100001f 	cmp	w0, #0x0
    c000508c:	54000140 	b.eq	c00050b4 <topology_mark_cpu_online+0x180>  // b.none
			online_cpu_count--;
    c0005090:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c0005094:	9123b000 	add	x0, x0, #0x8ec
    c0005098:	b9400000 	ldr	w0, [x0]
    c000509c:	51000401 	sub	w1, w0, #0x1
    c00050a0:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c00050a4:	9123b000 	add	x0, x0, #0x8ec
    c00050a8:	b9000001 	str	w1, [x0]
    c00050ac:	14000002 	b	c00050b4 <topology_mark_cpu_online+0x180>
		return;
    c00050b0:	d503201f 	nop
		}
	}
}
    c00050b4:	910043ff 	add	sp, sp, #0x10
    c00050b8:	d65f03c0 	ret

00000000c00050bc <topology_register_cpu>:

void topology_register_cpu(unsigned int logical_id, uint64_t mpidr, bool boot_cpu)
{
    c00050bc:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
    c00050c0:	910003fd 	mov	x29, sp
    c00050c4:	b9001fe0 	str	w0, [sp, #28]
    c00050c8:	f9000be1 	str	x1, [sp, #16]
    c00050cc:	39006fe2 	strb	w2, [sp, #27]
	if (logical_id >= PLAT_MAX_CPUS) {
    c00050d0:	b9401fe0 	ldr	w0, [sp, #28]
    c00050d4:	71001c1f 	cmp	w0, #0x7
    c00050d8:	54000548 	b.hi	c0005180 <topology_register_cpu+0xc4>  // b.pmore
		return;
	}

	if (!cpu_descs[logical_id].present) {
    c00050dc:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c00050e0:	911fa001 	add	x1, x0, #0x7e8
    c00050e4:	b9401fe0 	ldr	w0, [sp, #28]
    c00050e8:	d37be800 	lsl	x0, x0, #5
    c00050ec:	8b000020 	add	x0, x1, x0
    c00050f0:	39407400 	ldrb	w0, [x0, #29]
    c00050f4:	52000000 	eor	w0, w0, #0x1
    c00050f8:	12001c00 	and	w0, w0, #0xff
    c00050fc:	12000000 	and	w0, w0, #0x1
    c0005100:	7100001f 	cmp	w0, #0x0
    c0005104:	54000100 	b.eq	c0005124 <topology_register_cpu+0x68>  // b.none
		present_cpu_count++;
    c0005108:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c000510c:	9123a000 	add	x0, x0, #0x8e8
    c0005110:	b9400000 	ldr	w0, [x0]
    c0005114:	11000401 	add	w1, w0, #0x1
    c0005118:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c000511c:	9123a000 	add	x0, x0, #0x8e8
    c0005120:	b9000001 	str	w1, [x0]
	}

	topology_fill_descriptor(&cpu_descs[logical_id], logical_id, mpidr, boot_cpu);
    c0005124:	b9401fe0 	ldr	w0, [sp, #28]
    c0005128:	d37be801 	lsl	x1, x0, #5
    c000512c:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c0005130:	911fa000 	add	x0, x0, #0x7e8
    c0005134:	8b000020 	add	x0, x1, x0
    c0005138:	39406fe3 	ldrb	w3, [sp, #27]
    c000513c:	f9400be2 	ldr	x2, [sp, #16]
    c0005140:	b9401fe1 	ldr	w1, [sp, #28]
    c0005144:	97fffebc 	bl	c0004c34 <topology_fill_descriptor>
	cpu_descs[logical_id].present = true;
    c0005148:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c000514c:	911fa001 	add	x1, x0, #0x7e8
    c0005150:	b9401fe0 	ldr	w0, [sp, #28]
    c0005154:	d37be800 	lsl	x0, x0, #5
    c0005158:	8b000020 	add	x0, x1, x0
    c000515c:	52800021 	mov	w1, #0x1                   	// #1
    c0005160:	39007401 	strb	w1, [x0, #29]
	cpu_descs[logical_id].online = false;
    c0005164:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c0005168:	911fa001 	add	x1, x0, #0x7e8
    c000516c:	b9401fe0 	ldr	w0, [sp, #28]
    c0005170:	d37be800 	lsl	x0, x0, #5
    c0005174:	8b000020 	add	x0, x1, x0
    c0005178:	3900781f 	strb	wzr, [x0, #30]
    c000517c:	14000002 	b	c0005184 <topology_register_cpu+0xc8>
		return;
    c0005180:	d503201f 	nop
}
    c0005184:	a8c27bfd 	ldp	x29, x30, [sp], #32
    c0005188:	d65f03c0 	ret

00000000c000518c <topology_unregister_cpu>:

void topology_unregister_cpu(unsigned int logical_id)
{
    c000518c:	d10043ff 	sub	sp, sp, #0x10
    c0005190:	b9000fe0 	str	w0, [sp, #12]
	if (logical_id >= PLAT_MAX_CPUS) {
    c0005194:	b9400fe0 	ldr	w0, [sp, #12]
    c0005198:	71001c1f 	cmp	w0, #0x7
    c000519c:	54000c68 	b.hi	c0005328 <topology_unregister_cpu+0x19c>  // b.pmore
		return;
	}

	if (cpu_descs[logical_id].online) {
    c00051a0:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c00051a4:	911fa001 	add	x1, x0, #0x7e8
    c00051a8:	b9400fe0 	ldr	w0, [sp, #12]
    c00051ac:	d37be800 	lsl	x0, x0, #5
    c00051b0:	8b000020 	add	x0, x1, x0
    c00051b4:	39407800 	ldrb	w0, [x0, #30]
    c00051b8:	12000000 	and	w0, w0, #0x1
    c00051bc:	7100001f 	cmp	w0, #0x0
    c00051c0:	54000260 	b.eq	c000520c <topology_unregister_cpu+0x80>  // b.none
		cpu_descs[logical_id].online = false;
    c00051c4:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c00051c8:	911fa001 	add	x1, x0, #0x7e8
    c00051cc:	b9400fe0 	ldr	w0, [sp, #12]
    c00051d0:	d37be800 	lsl	x0, x0, #5
    c00051d4:	8b000020 	add	x0, x1, x0
    c00051d8:	3900781f 	strb	wzr, [x0, #30]
		if (online_cpu_count > 0U) {
    c00051dc:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c00051e0:	9123b000 	add	x0, x0, #0x8ec
    c00051e4:	b9400000 	ldr	w0, [x0]
    c00051e8:	7100001f 	cmp	w0, #0x0
    c00051ec:	54000100 	b.eq	c000520c <topology_unregister_cpu+0x80>  // b.none
			online_cpu_count--;
    c00051f0:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c00051f4:	9123b000 	add	x0, x0, #0x8ec
    c00051f8:	b9400000 	ldr	w0, [x0]
    c00051fc:	51000401 	sub	w1, w0, #0x1
    c0005200:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c0005204:	9123b000 	add	x0, x0, #0x8ec
    c0005208:	b9000001 	str	w1, [x0]
		}
	}

	if (cpu_descs[logical_id].present) {
    c000520c:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c0005210:	911fa001 	add	x1, x0, #0x7e8
    c0005214:	b9400fe0 	ldr	w0, [sp, #12]
    c0005218:	d37be800 	lsl	x0, x0, #5
    c000521c:	8b000020 	add	x0, x1, x0
    c0005220:	39407400 	ldrb	w0, [x0, #29]
    c0005224:	12000000 	and	w0, w0, #0x1
    c0005228:	7100001f 	cmp	w0, #0x0
    c000522c:	54000260 	b.eq	c0005278 <topology_unregister_cpu+0xec>  // b.none
		cpu_descs[logical_id].present = false;
    c0005230:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c0005234:	911fa001 	add	x1, x0, #0x7e8
    c0005238:	b9400fe0 	ldr	w0, [sp, #12]
    c000523c:	d37be800 	lsl	x0, x0, #5
    c0005240:	8b000020 	add	x0, x1, x0
    c0005244:	3900741f 	strb	wzr, [x0, #29]
		if (present_cpu_count > 0U) {
    c0005248:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c000524c:	9123a000 	add	x0, x0, #0x8e8
    c0005250:	b9400000 	ldr	w0, [x0]
    c0005254:	7100001f 	cmp	w0, #0x0
    c0005258:	54000100 	b.eq	c0005278 <topology_unregister_cpu+0xec>  // b.none
			present_cpu_count--;
    c000525c:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c0005260:	9123a000 	add	x0, x0, #0x8e8
    c0005264:	b9400000 	ldr	w0, [x0]
    c0005268:	51000401 	sub	w1, w0, #0x1
    c000526c:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c0005270:	9123a000 	add	x0, x0, #0x8e8
    c0005274:	b9000001 	str	w1, [x0]
		}
	}

	cpu_descs[logical_id].logical_id = logical_id;
    c0005278:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c000527c:	911fa001 	add	x1, x0, #0x7e8
    c0005280:	b9400fe0 	ldr	w0, [sp, #12]
    c0005284:	d37be800 	lsl	x0, x0, #5
    c0005288:	8b000020 	add	x0, x1, x0
    c000528c:	b9400fe1 	ldr	w1, [sp, #12]
    c0005290:	b9000801 	str	w1, [x0, #8]
	cpu_descs[logical_id].boot_cpu = false;
    c0005294:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c0005298:	911fa001 	add	x1, x0, #0x7e8
    c000529c:	b9400fe0 	ldr	w0, [sp, #12]
    c00052a0:	d37be800 	lsl	x0, x0, #5
    c00052a4:	8b000020 	add	x0, x1, x0
    c00052a8:	3900701f 	strb	wzr, [x0, #28]
	cpu_descs[logical_id].mpidr = 0U;
    c00052ac:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c00052b0:	911fa001 	add	x1, x0, #0x7e8
    c00052b4:	b9400fe0 	ldr	w0, [sp, #12]
    c00052b8:	d37be800 	lsl	x0, x0, #5
    c00052bc:	8b000020 	add	x0, x1, x0
    c00052c0:	f900001f 	str	xzr, [x0]
	cpu_descs[logical_id].chip_id = 0U;
    c00052c4:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c00052c8:	911fa001 	add	x1, x0, #0x7e8
    c00052cc:	b9400fe0 	ldr	w0, [sp, #12]
    c00052d0:	d37be800 	lsl	x0, x0, #5
    c00052d4:	8b000020 	add	x0, x1, x0
    c00052d8:	b9000c1f 	str	wzr, [x0, #12]
	cpu_descs[logical_id].die_id = 0U;
    c00052dc:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c00052e0:	911fa001 	add	x1, x0, #0x7e8
    c00052e4:	b9400fe0 	ldr	w0, [sp, #12]
    c00052e8:	d37be800 	lsl	x0, x0, #5
    c00052ec:	8b000020 	add	x0, x1, x0
    c00052f0:	b900101f 	str	wzr, [x0, #16]
	cpu_descs[logical_id].cluster_id = 0U;
    c00052f4:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c00052f8:	911fa001 	add	x1, x0, #0x7e8
    c00052fc:	b9400fe0 	ldr	w0, [sp, #12]
    c0005300:	d37be800 	lsl	x0, x0, #5
    c0005304:	8b000020 	add	x0, x1, x0
    c0005308:	b900141f 	str	wzr, [x0, #20]
	cpu_descs[logical_id].core_id = 0U;
    c000530c:	b0000040 	adrp	x0, c000e000 <secondary_stacks+0x78e0>
    c0005310:	911fa001 	add	x1, x0, #0x7e8
    c0005314:	b9400fe0 	ldr	w0, [sp, #12]
    c0005318:	d37be800 	lsl	x0, x0, #5
    c000531c:	8b000020 	add	x0, x1, x0
    c0005320:	b900181f 	str	wzr, [x0, #24]
    c0005324:	14000002 	b	c000532c <topology_unregister_cpu+0x1a0>
		return;
    c0005328:	d503201f 	nop
    c000532c:	910043ff 	add	sp, sp, #0x10
    c0005330:	d65f03c0 	ret
