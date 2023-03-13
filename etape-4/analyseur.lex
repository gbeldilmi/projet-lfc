%{

	#include <stdio.h>
	#include <stddef.h>
	#include <stdlib.h>
	#include <string.h>

	#include "y.tab.h"

	#define NONE -1LL
	#define CAL 0
	#define EVT 1
	#define ALA 2
	#define DAT 3
	#define TXT 4
	#define LJR 5
	#define NUM 6
	#define TRG 7
	#define FRQ 8
	/* 
	#define UNIQ 
	#define DEBUT 
	#define FIN 
	*/

	typedef struct {
		long long int **t;
		long long int ts;
		char *u;
		long long int us;
	} table;

	table *y;

	long long int b = NONE;
	long long int c = 0, d = 0;
	void fill(long long int a, char *txt);

%}

%start LIGNEOK
%start DATEUOK
%start DATEROK
%start DATEJOK
%start NBOK
%start JOUROK
%start ALARM
%start TEXTOK

%%

BEGIN:VCALENDAR	{
	printf("Début calendrier\n");
	}
END:VCALENDAR	{
	printf("Fin calendrier\n");
	}
BEGIN:VEVENT	{
	printf("Début événement\n");
	fill(EVT,NULL);
	c++;
	BEGIN LIGNEOK;
	}
END:VEVENT	{
	printf("Fin événement\n");
	}
<LIGNEOK>DTSTART:	{
	printf("intro heure début evt unique\n");
	BEGIN DATEUOK;
	}
<LIGNEOK>DTEND:		{
	printf("intro heure fin evt unique\n");
	BEGIN DATEUOK;
	}
<LIGNEOK>SUMMARY:	{
	printf("intro titre\n");
	BEGIN TEXTOK;
	}
<LIGNEOK>LOCATION:	{
	printf("intro lieu\n");
	BEGIN TEXTOK;
	}
<LIGNEOK>DESCRIPTION:	{
	printf("intro description\n");
	BEGIN TEXTOK;
	}
<LIGNEOK>BEGIN:VALARM	{
	printf("Début alarme\n");
	BEGIN ALARM;
	}
<ALARM>END:VALARM	{
	printf("Fin alarme\n");
	BEGIN LIGNEOK;
	}
<ALARM>TRIGGER:	{
	printf("intro position alarme\n");
	}
<LIGNEOK>RRULE:		{
	printf("intro règle répétition\n");
	}
<LIGNEOK>FREQ=		{
	printf("intro fréquence\n");
	}
<LIGNEOK>COUNT=		{
	printf("intro compteur\n");
	BEGIN NBOK;
	}
<LIGNEOK>BYDAY=		{
	printf("intro liste jours\n");
	BEGIN JOUROK;
	}
<LIGNEOK>UNTIL=		{
	printf("intro limite\n");
	BEGIN DATEUOK;
	}
<LIGNEOK>WKST=SU		{
	printf("changement de semaine\n");
	}
<LIGNEOK>DAILY|WEEKLY|MONTHLY|YEARLY	{
	printf("frequence : %s\n", yytext);
	fill(FRQ,yytext);
	}
<LIGNEOK>;		{
	printf("séparateur options\n");
	}
<LIGNEOK>DTSTART;TZID=[a-zA-Z/]+:	{
	printf("intro heure début evt répétitif\n");
	BEGIN DATEROK;
	}
<LIGNEOK>DTEND;TZID=[a-zA-Z/]+:		{
	printf("intro heure fin evt répétitif\n");
	BEGIN DATEROK;
	}
<LIGNEOK>DTSTART;VALUE=DATE:	{
	printf("intro heure début evt journée\n");
	BEGIN DATEJOK;
	}
<LIGNEOK>DTEND;VALUE=DATE:		{
	printf("intro heure fin evt journée\n");
	BEGIN DATEJOK;
	}
<ALARM>"-P"[0-9]+DT[0-9]+H[0-9]+M[0-9]+S	{
	printf("position alarme : %s\n", yytext);
	fill(TRG,yytext);
	}
<DATEJOK>[0-9]{8}	{
	printf("date evt journée : %s\n", yytext);
	fill(DAT,yytext);
	BEGIN LIGNEOK;
	}
<NBOK>[0-9]+		{
	printf("nombre entier : %s\n", yytext);
	fill(NUM,yytext);
	BEGIN LIGNEOK;
	}
<DATEROK>[0-9]{8}T[0-9]{6}		{
	printf("date et heure evt répétitif : %s\n", yytext);
	fill(DAT,yytext);
	BEGIN LIGNEOK;
	}
<DATEUOK>[0-9]{8}T[0-9]{6}Z		{
	printf("date et heure evt unique : %s\n", yytext);
	fill(DAT,yytext);
	BEGIN LIGNEOK;
	}
<JOUROK>(SU|MO|TU|WE|TH|FR|SA)(,(SU|MO|TU|WE|TH|FR|SA)){0,6}	{
	printf("liste jours : %s\n", yytext);
	fill(LJR,yytext);
	BEGIN LIGNEOK;
	}
<TEXTOK>[^:\n]*$	{
	printf("Lieu, description ou titre : %s\n",yytext);
	fill(TXT,yytext);
	BEGIN LIGNEOK;
	}
.|\n ;

%%

void fill(long long int a, char *txt)
{
	long long int *n = (long long int *) malloc(5 * sizeof(long long int));
	if (n) {
		n[0] = a;
		n[1] = b;
		if (txt) {
			n[2] = c;
			n[3] = (y) ? y->us : 0;
			n[4] = (txt) ? (long long int) strlen(yytext) : NONE;
		} else {
			n[2] = n[3] = n[4] = NONE;
		}
	}
	if (!y) {
		y = (table *) calloc(1, sizeof(table));
		y->ts++;
		y->t = (long long int **) malloc(y->ts * sizeof(long long int*));
		y->us++;
		y->u = (char *) calloc(y->us, sizeof(char));
	} else {
		y->ts++;
		long long int **nt = (long long int **) malloc(y->ts * sizeof(long long int*));
		for (int i = 0; y->ts; i++){
			nt[i] = y->t[i];
		}
		free((void *) y->t);
		y->t = nt;
		if (txt) {
			y->us+=strlen(txt);
			char *nu = (char *) calloc(y->us, sizeof(char));
			strcpy(nu, y->u);
			strcpy(nu, txt);
			free((void *) y->u);
			y->u = nu;
		}
	}
	y->t[y->ts-1] = n;
}
