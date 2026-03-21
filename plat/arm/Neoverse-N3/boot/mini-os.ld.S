#include "platform_def.h"

ENTRY(_start)

PHDRS
{
	text PT_LOAD FLAGS(5);
	data PT_LOAD FLAGS(6);
}

SECTIONS
{
	. = PLAT_LOAD_ADDR;
	__image_start = .;

	.text : ALIGN(16) {
		KEEP(*(.text.boot))
		*(.text*)
	} :text

	.rodata : ALIGN(16) {
		*(.rodata*)
	} :text

	.data : ALIGN(16) {
		*(.data*)
	} :data

	.bss (NOLOAD) : ALIGN(16) {
		__bss_start = .;
		*(.bss*)
		*(COMMON)
		__bss_end = .;
	} :data

	. = ALIGN(16);
	.stack (NOLOAD) : {
		. = . + PLAT_STACK_SIZE;
		__stack_top = .;
	} :data

	__image_end = .;

	/DISCARD/ : {
		*(.comment)
		*(.note*)
	}
}