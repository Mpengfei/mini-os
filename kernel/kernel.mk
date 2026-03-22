include $(ROOT_DIR)/kernel/init/init.mk
include $(ROOT_DIR)/kernel/lock/lock.mk
include $(ROOT_DIR)/kernel/lib/lib.mk
include $(ROOT_DIR)/kernel/topology/topology.mk
include $(ROOT_DIR)/kernel/smp/smp.mk
include $(ROOT_DIR)/kernel/tests/tests.mk
include $(ROOT_DIR)/kernel/scheduler/scheduler.mk
include $(ROOT_DIR)/drivers/gic/gic.mk
include $(ROOT_DIR)/kernel/shell/shell.mk

MODULE_INCLUDES += $(ROOT_DIR)/include/kernel