include $(ROOT_DIR)/plat/arm/Neoverse-N3/boot/boot.mk

PLAT_CPU := neoverse-n3
LOAD_ADDR ?= 0x80000000
STACK_SIZE ?= 0x1000

MODULE_INCLUDES += $(ROOT_DIR)/plat/arm/Neoverse-N3/include
CPPFLAGS += -DPLAT_CPU_$(subst -,_,$(PLAT_CPU))