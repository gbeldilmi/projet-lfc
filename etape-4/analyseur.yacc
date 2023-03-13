%{
#include <stdio.h>
#include <stdlib.h>
void yyerror(char *s);
%}

%token DEBCAL FINCAL DEBEVT FINEVT IDEBEVTU IFINEVTU ITITRE ILIEU IDESCR DEBAL FINAL TRIGGER RRULE FREQ COUNT BYDAY UNTIL WKST VALFREQ PV DEBEVTR FINEVTR DEBEVTJ FINEVTJ POSAL DATEVTJ NOMBRE DATEVTR DATEVTU LISTJ TEXTE
%start fichier
/*
fichier 
liste_evenements
evenement infos_evenements infos_evenement_unique infos_evenement_repetitif infos_evenement_journalier suite_infos_evenement les_textes liste_alarmes répétition alarme
DEBCAL // Début calendrier
FINCAL // Fin calendrier
DEBEVT // Début événement
FINEVT // Fin événement
IDEBEVTU // intro heure début evt unique
IFINEVTU // intro heure fin evt unique
ITITRE // intro titre
ILIEU // intro lieu
IDESCR // intro description
DEBAL // Début alarme
FINAL // Fin alarme
TRIGGER // intro position alarme
RRULE // intro règle répétition
FREQ // intro fréquence
COUNT // intro compteur
BYDAY // intro liste jours
UNTIL // intro limite
WKST // changement de semaine
VALFREQ // frequence
PV // séparateur options
DEBEVTR // intro heure début evt répétitif
FINEVTR // intro heure fin evt répétitif
DEBEVTJ // intro heure début evt journée
FINEVTJ // intro heure fin evt journée
POSAL // position alarme
DATEVTJ // date evt journée
NOMBRE // nombre entier
DATEVTR // date et heure evt répétitif
DATEVTU // date et heure evt unique
LISTJ // liste jours
TEXTE // Lieu, description ou titre
*/
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
  return 0;
}
