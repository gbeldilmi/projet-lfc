%{
    #include <stdio.h>
    /*
        lex -v progName.lex ==> compilation lex
        gcc -Wall -o executableName lex.yy.c -lfl  ==> compilation
    */
%}


/** 1-6 **/
DEBUT_CALENDRIER "BEGIN:VCALENDAR"
FIN_CALENDRIER "END:VCALENDAR"
DEBUT_EVENEMENT "BEGIN:VEVENT"
FIN_EVENEMENT "END:VEVENT"
INTRO_HEURE_DEBUT_EVT_UNIQUE "DTSTART:"
INTRO_HEURE_FIN_EVT_UNIQUE "DTEND:"

/** 7 **/
HEURE_DATE_EVT_UNIQUE [0-9]{8}"T"[0-9]{6}"Z"

/** 8-10 **/
INTRO_TITRE "SUMMARY:"
INTRO_LIEU "LOCATION:"
INTRO_DESCRIPTION "DESCRIPTION:"

/** 11 **/
CHAINE_QUELCONQUE [^\n\r:]+

/** 12-14 **/
DEBUT_ALARM "BEGIN:VALARM"
FIN_ALARM "END:VALARM"
INTRO_POSITION_ALARM "TRIGGER:"
POSITION_ALARM "-P"[0-9]+"DT"[0-9]+"H"[0-9]+"M"[0-9]+"S"

/** 15-17 **/
INTRO_DEBUT_HEURE_EVT_REPETITIF "DTSTART;TZID="[A-Z][a-z]+"/"[A-Z][a-z]+":"
INTRO_FIN_HEURE_EVT_REPETITIF "DTEND;TZID="[A-Z][a-z]+"/"[A-Z][a-z]+":"
HEURE_DATE_EVT_REPETITIF [0-9]{8}"T"[0-9]{6}

/** 19-24**/
INTRO_REGLE_REPETION "RRULE:"
INTRO_FREQUENCE "FREQ="
INTRO_COMPTEUR "COUNT="
INTRO_LISTE_JOURS "BYDAY="
INTRO_LIMITE "UNTIL="
FREQUENCE "DAILY"|"WEEKLY"|MONTHLY|"YEARLY"

/** 25-26 **/
NOMBRE_ENTIER [0-9]+
LISTE_JOURS ("SU"|"MO"|"TU"|"WE"|"TH"|"FR"|"SA")(","("SU"|"MO"|"TU"|"WE"|"TH"|"FR"|"SA"))*

/** 27-30 **/
CHANGEMENT_SEMAINE "WKST=SU"
SEPARATEUR_OPTION ";"
INTRO_HEURE_DEBUT_EVT_JOURNEE "DTSTART;VALUE=DATE"
INTRO_HEURE_FIN_EVT_JOURNEE "DTEND;VALUE=DATE"

/** 31 **/
DATE_EVT_JOURNEE [0-9]{8}


%%
{DEBUT_CALENDRIER} {
    printf("début calendrier \n");
}
{FIN_CALENDRIER} {
    printf("fin calendrier \n");
}

{DEBUT_EVENEMENT} {
    printf("début evenement \n");
}
{FIN_EVENEMENT} {
    printf("fin evenement \n");
}

{INTRO_HEURE_DEBUT_EVT_UNIQUE} {
    printf("intro heure début evt unique \n");
}
{INTRO_HEURE_FIN_EVT_UNIQUE} {
    printf("intro heure fin evt unique \n");
}

{HEURE_DATE_EVT_UNIQUE} {
    printf("date et heure evt unique: %s\n", yytext);
}

{INTRO_TITRE} {
    printf("intro titre \n");
}
{INTRO_LIEU} {
    printf("intro lieu \n");
}
{INTRO_DESCRIPTION} {
    printf("intro description \n");
}

{DEBUT_ALARM} {
    printf("debut alarme \n");
}
{FIN_ALARM} {
    printf("fin alarme \n");
}
{INTRO_POSITION_ALARM} {
    printf("intro postion alarme \n");
}

{POSITION_ALARM} {
    printf("postion alarme: %s\n", yytext);
}

{INTRO_DEBUT_HEURE_EVT_REPETITIF} {
    printf("intro heure debut evt repetitif \n");
}
{INTRO_FIN_HEURE_EVT_REPETITIF} {
    printf("intro heure fin evt repetitif \n");
}
{HEURE_DATE_EVT_REPETITIF} {
    printf("date heure evt repetitif: %s\n", yytext);
}

{INTRO_REGLE_REPETION} {
    printf("intro règle répetion \n");
}
{INTRO_FREQUENCE} {
    printf("intro fréquence \n");
}
{INTRO_COMPTEUR} {
    printf("intro compteur \n");
}
{INTRO_LISTE_JOURS} {
    printf("intro liste jours \n");
}
{INTRO_LIMITE} {
    printf("intro limite \n");
}
{FREQUENCE} {
    printf("frequence: %s\n", yytext);
}

{NOMBRE_ENTIER} {
    printf("nombre entier: %s \n", yytext);
}

{LISTE_JOURS} {
    printf("liste jours: %s \n", yytext);
}

{CHANGEMENT_SEMAINE} {
    printf("changement de semaine \n");
}
{SEPARATEUR_OPTION} {
    printf("sépareteur d'option \n");
}
{INTRO_HEURE_DEBUT_EVT_JOURNEE} {
    printf("intro heure début evt journée \n");
}
{INTRO_HEURE_FIN_EVT_JOURNEE} {
    printf("intro heure fin evt journée \n");
}

{DATE_EVT_JOURNEE} {
    printf("date evt journée: %s\n", yytext);
}

.|\n ;

%%
