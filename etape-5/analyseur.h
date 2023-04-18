#pragma once

#include <stdio.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>

#define EMPTY -1
#define NONE -2

#define CAL 0
#define EVT 1
#define ALA 2
#define DAT 3
#define TXT 4
#define LJR 5
#define NUM 6
#define TRG 7
#define FRQ 8

#define UNIQ 101
#define REPET 102
#define JOURNEE 103
#define DEBUT 104
#define FIN 105
#define DESCR 106
#define LIEU 107
#define TITRE 108
#define ALAR 109
#define REP 110
#define JOURS 111
#define FINREP 112
#define NBREP 113


#define IDK 181818

typedef struct {
	int **t;
	int ts;
	char *u;
	int us;
} table;


