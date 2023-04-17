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
#define DEBUT 102
#define FIN 103

typedef struct {
	int **t;
	int ts;
	char *u;
	int us;
} table;


