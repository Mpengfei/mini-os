ARCH ?= aarch64
PLAT ?= Neoverse-N3
MODE ?= debug
V ?= 0
CROSS_COMPILE ?= aarch64-none-elf-

ROOT_DIR ?= $(CURDIR)
PLAT_DIR ?= $(ROOT_DIR)/plat/arm/$(PLAT)
BUILD_DIR := $(ROOT_DIR)/build/$(PLAT)/$(MODE)

ELF := $(BUILD_DIR)/mini-os.elf
BIN := $(BUILD_DIR)/mini-os.bin
MAP := $(BUILD_DIR)/mini-os.map
DISASM := $(BUILD_DIR)/mini-os.asm
LD_SCRIPT := $(BUILD_DIR)/mini-os.ld

BASE_INCLUDE_DIRS := \
	$(ROOT_DIR)/include
MODULE_INCLUDES :=
INCLUDE_DIRS = $(sort $(BASE_INCLUDE_DIRS) $(MODULE_INCLUDES))

CPPFLAGS += $(addprefix -I,$(INCLUDE_DIRS))
CPPFLAGS += -DPLAT_$(subst -,_,$(PLAT))

COMMON_FLAGS := -ffreestanding -fno-builtin -Wall -Wextra -MMD -MP
ASFLAGS +=
LDFLAGS += -nostdlib -Wl,-Map=$(MAP) -Wl,-T,$(LD_SCRIPT)

ifeq ($(MODE),debug)
CFLAGS += -O0 -g3
else
CFLAGS += -O2 -g0
endif

ifeq ($(V),1)
Q :=
else
Q := @
endif

CFLAGS += $(COMMON_FLAGS)