ifneq ($(shell command -v $(CROSS_COMPILE)gcc 2>/dev/null),)
TOOLCHAIN_FLAVOR := gcc
else
TOOLCHAIN_FLAVOR := clang
endif

ifeq ($(TOOLCHAIN_FLAVOR),gcc)
CC := $(CROSS_COMPILE)gcc
AS := $(CROSS_COMPILE)gcc
LD := $(CROSS_COMPILE)gcc
OBJCOPY := $(CROSS_COMPILE)objcopy
OBJDUMP := $(CROSS_COMPILE)objdump
SIZE := $(CROSS_COMPILE)size
LDFLAGS += -Wl,--no-warn-rwx-segments
else
CLANG_TARGET := --target=aarch64-none-elf
CC := clang $(CLANG_TARGET)
AS := clang $(CLANG_TARGET)
LD := clang $(CLANG_TARGET) -fuse-ld=lld
OBJCOPY := llvm-objcopy
OBJDUMP := llvm-objdump
SIZE := size
endif