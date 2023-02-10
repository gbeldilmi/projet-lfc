######################################################################
#################     Files and compiler options     #################
######################################################################
EXEC          := analyseur

SRC_DIR       := src
LEX 		      := lex
LEX_FLAGS     := -v
LEX_FILE  	  := $(SRC_DIR)/$(EXEC).lex
LEX_OUTPUT    := lex.yy.c

BUILD_DIR     := build
CC            := gcc
C_FLAGS       := -v -Wall -Wextra -lfl -O3
C_FILE        := $(BUILD_DIR)/lex.yy.c
BIN_FILE      := $(BUILD_DIR)/$(EXEC)

TEST_DIR			:= tests
RESULT_DIR		:= results
TEST_FILES    := $(wildcard $(TEST_DIR)/*.ical)
RESULT_FILES  := $(TEST_FILES:$(TEST_DIR)/%.ical=$(RESULT_DIR)/%.txt)


######################################################################
#####################     Rules and commands     #####################
######################################################################
.PHONY: all run test clean re

all : $(BIN_FILE)

run : all
	./$(BIN_FILE)

test : all $(RESULT_FILES)

clean : all
	rm -frv $(BUILD_DIR) $(RESULT_DIR)

re : clean all

$(C_FILE) : $(LEX_FILE)
	mkdir -pv $(dir $@)
	$(LEX) $(LEX_FLAGS) $^
	mv -v $(LEX_OUTPUT) $@

$(BIN_FILE) : $(C_FILE)
	$(CC) $(C_FLAGS) $^ -o $@

$(RESULT_DIR)/%.txt : $(TEST_DIR)/%.ical
	mkdir -pv $(dir $@)
	./$(BIN_FILE) < $^ > $@

