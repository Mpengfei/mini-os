PROJECT := mini-os

ROOT_DIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
ARCH ?= aarch64
PLAT ?= Neoverse-N3
MODE ?= debug
V ?= 0
CROSS_COMPILE ?= aarch64-none-elf-
PLAT_DIR := $(ROOT_DIR)/plat/arm/$(PLAT)

include $(ROOT_DIR)/mk/config.mk
include $(ROOT_DIR)/mk/toolchain.mk
include $(ROOT_DIR)/mk/dirs.mk
include $(MODULE_MK)
include $(ROOT_DIR)/mk/rules.mk

.DEFAULT_GOAL := all

.PHONY: all elf bin map clean disasm print-vars summary

all: $(BIN) $(MAP) $(DISASM) summary
elf: $(ELF)
bin: $(BIN)
map: $(MAP)
disasm: $(DISASM)

summary:
	@printf '\nBuild summary\n'
	@printf '  ELF     %s\n' "$(ELF)"
	@printf '  BIN     %s\n' "$(BIN)"
	@printf '  MAP     %s\n' "$(MAP)"
	@printf '  DISASM  %s\n' "$(DISASM)"
	@printf '  MODE    %s\n' "$(MODE)"
	@printf '  PLAT    %s\n' "$(PLAT)"
	@printf '\nImage size\n'
	@$(SIZE) $(ELF)

print-vars:
	@echo "ROOT_DIR=$(ROOT_DIR)"
	@echo "PROJECT=$(PROJECT)"
	@echo "PLAT=$(PLAT)"
	@echo "ARCH=$(ARCH)"
	@echo "V=$(V)"
	@echo "CROSS_COMPILE=$(CROSS_COMPILE)"
	@echo "BUILD_DIR=$(BUILD_DIR)"
	@echo "PLAT_DIR=$(PLAT_DIR)"
	@echo "ELF=$(ELF)"
	@echo "BIN=$(BIN)"
	@echo "MAP=$(MAP)"
	@echo "DISASM=$(DISASM)"
	@echo "C_SRCS=$(C_SRCS)"
	@echo "ASM_SRCS=$(ASM_SRCS)"
	@echo "INCLUDE_DIRS=$(INCLUDE_DIRS)"
	@echo "OBJS=$(OBJS)"

clean:
	rm -rf build