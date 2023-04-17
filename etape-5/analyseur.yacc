%{
	#include "analyseur.h"

  table *y;
  int yyval;

  void init();
  void yyerror(char *s);
  void print_table(table *t);
  void validate();
  int last_empty();
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
  infos_evenement_unique {
    y->t[last_empty()][1] = UNIQ;
  }
  | infos_evenement_repetitif {
    y->t[last_empty()][1] = REPET;
  }
  | infos_evenement_journalier {
    y->t[last_empty()][1] = JOURNEE;
  };

infos_evenement_unique :
  IDEBEVTU DATEVTU IFINEVTU DATEVTU suite_infos_evenement {
    int l = last_empty();
    y->t[l][1] = FIN;
    y->t[l - 1][1] = DEBUT;
  };

suite_infos_evenement :
  les_textes liste_alarmes ;

les_textes :
  IDESCR TEXTE ILIEU TEXTE ITITRE TEXTE {
    int l = last_empty();
    y->t[l][1] = TITRE;
    y->t[l - 1][1] = LIEU;
    y->t[l - 2][1] = DESCR;
    
  };

infos_evenement_repetitif :
  DEBEVTR DATEVTR FINEVTR DATEVTR repetition suite_infos_evenement {
    int l = last_empty();
    y->t[l][1] = FIN;
    y->t[l - 1][1] = DEBUT;
  };

infos_evenement_journalier :
  DEBEVTJ DATEVTJ FINEVTJ DATEVTJ suite_infos_evenement {
    int l = last_empty();
    y->t[l][1] = FIN;
    y->t[l - 1][1] = DEBUT;
  };

liste_alarmes :
  alarme liste_alarmes
  | ;

alarme :
  DEBAL TRIGGER POSAL FINAL {
    int l = last_empty();
    y->t[l][1] = ALARM;
  };

repetition : // LISTJ DATEVTU NOMBRE VALFREQ
  RRULE FREQ VALFREQ PV WKST PV COUNT NOMBRE PV BYDAY LISTJ {
    int l = last_empty();
    y->t[l][1] = JOURS;
    y->t[l - 1][1] = NBREP;
    y->t[l - 2][1] = REP;
  }
  | RRULE FREQ VALFREQ PV UNTIL DATEVTU {
    int l = last_empty();
    y->t[l][1] = FINREP;
    y->t[l - 1][1] = REP;
  }
  | RRULE FREQ VALFREQ PV WKST PV UNTIL DATEVTU {
    int l = last_empty();
    y->t[l][1] = FINREP;
    y->t[l - 1][1] = REP;
  }
  | RRULE FREQ VALFREQ PV UNTIL DATEVTU PV BYDAY LISTJ {
    int l = last_empty();
    y->t[l][1] = JOURS;
    y->t[l - 1][1] = FINREP;
    y->t[l - 2][1] = REP;
  }
  | RRULE FREQ VALFREQ PV WKST PV UNTIL DATEVTU PV BYDAY LISTJ {
    int l = last_empty();
    y->t[l][1] = JOURS;
    y->t[l - 1][1] = FINREP;
    y->t[l - 2][1] = REP;
  };

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
  printf("Erreur : %s\n\n", s);
  print_table(y);
}

void print_table(table *t)
{
  int i, j;
  printf("------- table -------\n1D str :\n%s\n---------------------\n2D str :\n", t->u);
  for (i = 0; i < t->ts; i++)
  {
    for (j = 0; j < 5; j++)
    {
      printf("%*d ", 8, t->t[i][j]);
    }
    printf("\n");
  }
}

int last_empty() // dernière ligne avec le second élément avec la valeur EMPTY
{
  int i;
  for (i = y->ts - 1; i >= 0; i--)
  {
    if (y->t[i][1] == EMPTY)
    {
      return i;
    }
  }
  printf("Erreur : pas de ligne vide.\n");
  exit(1);
}


void validate()
{
  print_table(y);
  ////////////////////////////////////////////////////////////////// à completer 
}
