############################################################################
####################     Files and compiler options     ####################
############################################################################
EXEC         := analyseur

LEX_OUT_C    := lex.yy.c
LEX_OUT_H    := $(LEX_OUT_C:.c=.h)
YACC_OUT_C   := y.tab.c
YACC_OUT_H   := $(YACC_OUT_C:.c=.h)

SRC_DIR      := src
BUILD_DIR    := build
TEST_DIR     := tests
RESULT_DIR   := results

LEX_FILE     := $(SRC_DIR)/$(EXEC).lex
YACC_FILE    := $(SRC_DIR)/$(EXEC).yacc
LEX_C_FILE   := $(BUILD_DIR)/$(LEX_OUT_C)
YACC_C_FILE  := $(BUILD_DIR)/$(YACC_OUT_C)
C_FILES      := $(LEX_C_FILE) $(YACC_C_FILE)
LEX_H_FILE   := $(BUILD_DIR)/$(LEX_OUT_H)
YACC_H_FILE  := $(BUILD_DIR)/$(YACC_OUT_H)
H_FILES      := $(LEX_H_FILE) $(YACC_H_FILE)
LEX_O_FILE   := $(BUILD_DIR)/$(LEX_OUT_C:.c=.o)
YACC_O_FILE  := $(BUILD_DIR)/$(YACC_OUT_C:.c=.o)
O_FILES      := $(LEX_O_FILE) $(YACC_O_FILE)
BIN_FILE     := $(BUILD_DIR)/$(EXEC)
TEST_FILES   := $(wildcard $(TEST_DIR)/*.ical)
RESULT_FILES := $(TEST_FILES:$(TEST_DIR)/%.ical=$(RESULT_DIR)/%.txt)

LEX          := lex
YACC         := yacc
CC           := gcc
LD           := gcc

LEX_FLAGS    := -v --header-file=$(LEX_H_FILE) --outfile=$(LEX_C_FILE)
YACC_FLAGS   := -v --header=$(YACC_H_FILE) --output=$(YACC_C_FILE)
CC_FLAGS     := -v -Wall -Wextra -O3 -I$(BUILD_DIR)/
LD_FLAGS     := -lfl -ly


############################################################################
########################     Rules and commands     ########################
############################################################################
.PHONY: all run test clean re

all : $(BIN_FILE)

run : all
	./$(BIN_FILE)

test : all $(RESULT_FILES)

clean :
	rm -frv $(BUILD_DIR) $(RESULT_DIR)

re : clean all

$(LEX_C_FILE) : $(LEX_FILE) $(YACC_H_FILE)
	mkdir -pv $(dir $@)
	$(LEX) $(LEX_FLAGS) $^

$(YACC_C_FILE) : $(YACC_FILE)
	mkdir -pv $(dir $@)
	$(YACC) $(YACC_FLAGS) $^

$(YACC_H_FILE) : $(YACC_C_FILE)

$(BUILD_DIR)/%.o : $(BUILD_DIR)/%.c
	$(CC) $(CC_FLAGS) -c $^ -o $@ 

$(LEX_O_FILE) : $(LEX_C_FILE)

$(YACC_O_FILE) : $(YACC_C_FILE)

$(BIN_FILE) : $(O_FILES)
	$(LD) $(LD_FLAGS) $^ -o $@

$(RESULT_DIR)/%.txt : $(TEST_DIR)/%.ical
	mkdir -pv $(dir $@)
	./$(BIN_FILE) < $^ > $@

