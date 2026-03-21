C_SRCS := $(sort $(C_SRCS))
ASM_SRCS := $(sort $(ASM_SRCS))

OBJS := \
	$(patsubst $(ROOT_DIR)/%.c,$(BUILD_DIR)/%.o,$(C_SRCS)) \
	$(patsubst $(ROOT_DIR)/%.S,$(BUILD_DIR)/%.o,$(ASM_SRCS))
DEPS := $(OBJS:.o=.d)

AARCH64_FLAGS := -march=armv8.2-a -mgeneral-regs-only -mstrict-align
CFLAGS += $(AARCH64_FLAGS)
ASFLAGS += $(AARCH64_FLAGS)

quiet_cmd_cc = printf '  CC      %s\n' "$<"
quiet_cmd_as = printf '  AS      %s\n' "$<"
quiet_cmd_lds = printf '  LDS     %s\n' "$(LD_SCRIPT_SRC)"

$(BUILD_DIR):
	$(Q)mkdir -p $@

$(LD_SCRIPT): $(LD_SCRIPT_SRC) | $(BUILD_DIR)
	$(if $(filter 1,$(V)),,@$(quiet_cmd_lds))
	$(Q)$(CC) $(CPPFLAGS) -E -P -x assembler-with-cpp $< -o $@

$(ELF): $(OBJS) $(LD_SCRIPT_SRC) | $(BUILD_DIR)
	$(if $(filter 1,$(V)),,@$(quiet_cmd_lds))
	$(Q)$(CC) $(CPPFLAGS) -E -P -x assembler-with-cpp $(LD_SCRIPT_SRC) -o $(LD_SCRIPT)
	$(Q)$(LD) $(CFLAGS) $(OBJS) $(LDFLAGS) -o $@

$(BIN): $(ELF)
	$(Q)$(OBJCOPY) -O binary $< $@

$(MAP): $(ELF)
	$(Q)test -f $@

$(DISASM): $(ELF)
	$(Q)$(OBJDUMP) -dS $< > $@

$(BUILD_DIR)/%.o: $(ROOT_DIR)/%.c
	$(Q)mkdir -p $(dir $@)
	$(if $(filter 1,$(V)),,@$(quiet_cmd_cc))
	$(Q)$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

$(BUILD_DIR)/%.o: $(ROOT_DIR)/%.S
	$(Q)mkdir -p $(dir $@)
	$(if $(filter 1,$(V)),,@$(quiet_cmd_as))
	$(Q)$(AS) $(CPPFLAGS) $(ASFLAGS) -c $< -o $@

-include $(DEPS)