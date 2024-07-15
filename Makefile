CC = gcc
AS = yasm
CFLAGS = -Wall -I./src -I./lib/jansson-2.10 -DHAVE_CONFIG_H=1 -pthread
ASFLAGS = -f elf64 -DLINUX=1
LDFLAGS = -L./lib
LIBS = -lm
LIB_C_NAME = libc_lib
LIB_ASM_NAME = libasm_lib
EXEC_NAME = ckpool
SRC_DIR = src
OBJ_DIR = obj
LIB_DIR = lib
C_LIB_DIR = $(LIB_DIR)/jansson-2.10
ASM_LIB_DIR = $(LIB_DIR)/sha256_code_release
BIN_DIR = bin

SRC_FILES := $(wildcard $(SRC_DIR)/*.c)
C_LIB_FILES := $(wildcard $(C_LIB_DIR)/*.c)
ASM_FILES := $(wildcard $(ASM_LIB_DIR)/*.asm)
OBJ_FILES := $(patsubst $(SRC_DIR)/%.c, $(OBJ_DIR)/%.o, $(SRC_FILES))
C_LIB_OBJ_FILES := $(patsubst $(C_LIB_DIR)/%.c, $(OBJ_DIR)/%.o, $(C_LIB_FILES))
ASM_OBJ_FILES := $(patsubst $(ASM_LIB_DIR)/%.asm, $(OBJ_DIR)/%.o, $(ASM_FILES))
MAIN_OBJ_FILE := $(OBJ_DIR)/$(EXEC_NAME).o

all: $(BIN_DIR)/$(EXEC_NAME)


$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(OBJ_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(OBJ_DIR)/%.o: $(C_LIB_DIR)/%.c
	@mkdir -p $(OBJ_DIR)
	$(CC) $(CFLAGS) -c $< -o $@
$(OBJ_DIR)/%.o: $(ASM_LIB_DIR)/%.asm
	@mkdir -p $(OBJ_DIR)
	$(AS) $(ASFLAGS) $< -o $@

$(BIN_DIR)/$(EXEC_NAME): $(OBJ_FILES) $(C_LIB_OBJ_FILES) $(ASM_OBJ_FILES)
	@mkdir -p $(BIN_DIR)
	$(CC) $(LDFLAGS) -o $@ $^ $(LIBS) -pthread

clean:
	rm -rf $(OBJ_DIR) $(BIN_DIR)

.PHONY: all clean