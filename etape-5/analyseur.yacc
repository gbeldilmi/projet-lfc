%{
	#include "analyseur.h"

  table *y;
  int yyval;

  void init();
  void yyerror(char *s);
  void print_table(table *t);
  void validate();
%}

%token DEBCAL FINCAL DEBEVT FINEVT IDEBEVTU IFINEVTU ITITRE ILIEU IDESCR DEBAL FINAL TRIGGER RRULE FREQ COUNT BYDAY UNTIL WKST VALFREQ PV DEBEVTR FINEVTR DEBEVTJ FINEVTJ POSAL DATEVTJ NOMBRE DATEVTR DATEVTU LISTJ TEXTE
%start fichier

%%

fichier :
  DEBCAL liste_evenements FINCAL ;

liste_evenements : 
  evenement liste_evenements
  | ;

evenement :
  DEBEVT infos_evenement FINEVT ;

infos_evenement :
  infos_evenement_unique
  | infos_evenement_repetitif
  | infos_evenement_journalier ;

infos_evenement_unique :
  IDEBEVTU DATEVTU IFINEVTU DATEVTU suite_infos_evenement ;

suite_infos_evenement :
  les_textes liste_alarmes ;

les_textes :
  IDESCR TEXTE ILIEU TEXTE ITITRE TEXTE ;

infos_evenement_repetitif :
  DEBEVTR DATEVTR FINEVTR DATEVTR repetition suite_infos_evenement ;

infos_evenement_journalier :
  DEBEVTJ DATEVTJ FINEVTJ DATEVTJ suite_infos_evenement ;

liste_alarmes :
  alarme liste_alarmes
  | ;

alarme :
  DEBAL TRIGGER POSAL FINAL ;

repetition :
  RRULE FREQ VALFREQ PV WKST PV COUNT NOMBRE PV BYDAY LISTJ
  | RRULE FREQ VALFREQ PV UNTIL DATEVTU
  | RRULE FREQ VALFREQ PV WKST PV UNTIL DATEVTU
  | RRULE FREQ VALFREQ PV UNTIL DATEVTU PV BYDAY LISTJ
  | RRULE FREQ VALFREQ PV WKST PV UNTIL DATEVTU PV BYDAY LISTJ ;

%%

int main()
{
  init();
  yyparse();
  validate();
  printf("\nFin.\n");
  return 0;
}

void init()
{
  y = (table *) malloc(sizeof(table));
  if (y == NULL)
  {
    printf("Erreur d'allocation mémoire.\n");
    exit(1);
  }
	y->ts = 0;
	y->t = (int **) malloc(y->ts * sizeof(int*));
	y->us = 0;
	y->u = (char *) malloc(y->us * sizeof(char));
  if (y->t == NULL || y->u == NULL)
  {
    printf("Erreur d'allocation mémoire.\n");
    exit(1);
  }
}

void yyerror(char *s)
{
  printf("Erreur : %s", s);
}

void print_table(table *t)
{
  int i, j;
  printf("------- table -------\n1D str :\n%s\n---------------------\n2D str :\n", t->u);
  for (i = 0; i < t->ts; i++)
  {
    for (j = 0; j < 5; j++)
    {
      // long long int
      printf("%*d ", 6, t->t[i][j]);
    }
    printf("\n");
  }
}

void validate()
{
  print_table(y);
  //
}
