# System configuration
CC = arm-none-eabi-gcc
SZ = arm-none-eabi-size
RM=rm -rf

# Assembler, Compiler and Linker flags and linker script settings
LINKER_FLAGS=-lm -mthumb -mhard-float -mcpu=cortex-m4 -mfpu=fpv4-sp-d16 -Wl,--gc-sections -T$(LINK_SCRIPT) -static  -Wl,--start-group -lc -lm -Wl,--end-group  -specs=nosys.specs  -Wl,-cref "-Wl,-Map=$(BIN_DIR)/stm32f3_template.map" -Wl,--defsym=malloc_getpagesize_P=0x1000
LINK_SCRIPT="stm32f30_flash.ld"
ASSEMBLER_FLAGS=-c -g -O0 -mcpu=cortex-m4 -mfpu=fpv4-sp-d16 -mthumb -mhard-float  -D"STM32F303xE" -D"USE_STDPERIPH_DRIVER"  -x assembler-with-cpp  -Isrc -ILibraries/CMSIS/Include -ILibraries/Device/STM32F30x/Include -ILibraries/STM32F30x_StdPeriph_Driver/inc
COMPILER_FLAGS=-c -g -mcpu=cortex-m4 -mfpu=fpv4-sp-d16 -O0 -Wall -ffunction-sections -fdata-sections -mthumb -mhard-float  -D"STM32F303xE" -D"USE_STDPERIPH_DRIVER"   -Isrc -ILibraries/CMSIS/Include -ILibraries/Device/STM32F30x/Include -ILibraries/STM32F30x_StdPeriph_Driver/inc 

# Define output directory
OBJECT_DIR = Debug
BIN_DIR = $(OBJECT_DIR)

# Define sources and objects
SRC := $(wildcard */*/*/*/*/*/*/*.c) \
	$(wildcard */*/*/*/*/*/*.c) \
	$(wildcard */*/*/*/*/*.c) \
	$(wildcard */*/*/*/*.c) \
	$(wildcard */*/*/*.c) \
	$(wildcard */*/*.c) \
	$(wildcard */*.c)
SRCSASM := 	$(wildcard */*/*/*/*/*/*/*/*.s) \
	$(wildcard */*/*/*/*/*/*/*.s) \
	$(wildcard */*/*/*/*/*/*.s) \
	$(wildcard */*/*/*/*/*.s) \
	$(wildcard */*/*/*/*.s) \
	$(wildcard */*/*/*.s) \
	$(wildcard */*/*.s) \
	$(wildcard */*.s)
OBJS := $(SRC:%.c=$(OBJECT_DIR)/%.o) $(SRCSASM:%.s=$(OBJECT_DIR)/%.o)
OBJS := $(OBJS:%.S=$(OBJECT_DIR)/%.o)  

###############
# Build project
# Major targets
###############
all: buildelf

buildelf: $(OBJS) 
	$(CC) -o "$(BIN_DIR)/stm32f3_template.elf" $(OBJS) $(LINKER_FLAGS)
	$(SZ) Debug/stm32f3_template.elf

clean:
	$(RM) $(OBJS) "$(BIN_DIR)/stm32f3_template.elf" "$(BIN_DIR)/stm32f3_template.map"
	$(RM) $(OBJECT_DIR)


##################
# Specific targets
##################
$(OBJECT_DIR)/src/main.o: src/main.c
	@mkdir -p $(dir $@) 2> /dev/null
	$(CC) $(COMPILER_FLAGS) src/main.c -o $(OBJECT_DIR)/src/main.o 


##################
# Implicit targets
##################
$(OBJECT_DIR)/%.o: %.c
	@mkdir -p $(dir $@) 2> /dev/null
	$(CC) $(COMPILER_FLAGS) $< -o $@

$(OBJECT_DIR)/%.o: %.s
	@mkdir -p $(dir $@) 2> /dev/null
	$(CC) $(ASSEMBLER_FLAGS) $< -o $@
	
$(OBJECT_DIR)/%.o: %.S
	@mkdir -p $(dir $@) 2> /dev/null
	$(CC) $(ASSEMBLER_FLAGS) $< -o $@
