############################################################################
####################     Files and compiler options     ####################
############################################################################
EXEC         := analyseur

LEX          := lex
YACC         := yacc
CC           := gcc

LEX_FLAGS    := -v
YACC_FLAGS   := -v -d
CC_FLAGS     := -v -Wall -Wextra -O3
LD_FLAGS     := -lfl

LEX_FILE     := $(EXEC).lex
YACC_FILE    := $(EXEC).yacc
LEX_C_FILE   := lex.yy.c
YACC_C_FILE  := y.tab.c
BIN_FILE     := $(EXEC)


############################################################################
########################     Rules and commands     ########################
############################################################################
.PHONY: all clean re

all : $(BIN_FILE)

clean :
	rm -v *.o *.c *.h *.output

re : clean all

$(BIN_FILE) : $(LEX_FILE) $(YACC_FILE)
	$(YACC) $(YACC_FLAGS) $(YACC_FILE)
	$(LEX) $(LEX_FLAGS) $(LEX_FILE)
	$(CC) $(CC_FLAGS) -c $(LEX_C_FILE)
	$(CC) $(CC_FLAGS) $(YACC_C_FILE) $(LEX_C_FILE:%.c=%.o) $(LD_FLAGS) -o $@
