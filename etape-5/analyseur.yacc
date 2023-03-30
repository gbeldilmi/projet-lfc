%{
	#include "analyseur.h"

  table *y;

  void yyerror(char *s);
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
  yyparse();
  validate();
  printf("\nFin.\n");
  return 0;
}

void yyerror(char *s)
{
  printf("Erreur : %s", s);
}

void validate() {
  //
}