.section .text.boot, "ax"
.global secondary_cpu_entrypoint
.type secondary_cpu_entrypoint, %function

secondary_cpu_entrypoint:
	ldr x1, =secondary_stacks
	ldr x2, =0x1000
	madd x1, x0, x2, x1
	add x1, x1, x2
	mov sp, x1
	bl smp_secondary_entry

1:
	wfe
	b 1b