%{
	#include "analyseur.h"
  table *y;
  int yyval;
  void init();
  void yyerror(char *s);
  void print_table(table *t);
  int last_empty();
  void validate();
  void check_dates();
  void check_dates_fin_deb();
  void check_dates_lim_deb();
  void check_alarms();
  int get_element(int e, int v);
  int get_elementi(int e, int v, int k);
  int event_exists(int e);
  void translate();
  void print_date(FILE *f, int l);
  void print_heure(FILE *f, int l);
  void print_lstr(FILE *f, char *p, int l);
  int scan_jrs(int l);
  int print_alarm(FILE *f, int l);
  static int ft_charcmp(int c1, int c2);
  int ft_strcmp(const char *s1, const char *s2);
  int ft_strequ(const char *s1, const char *s2);
  int ft_strncmp(const char *s1, const char *s2, size_t n);
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
    y->t[l][1] = ALAR;
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
  translate();
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
  check_dates();
  check_dates_fin_deb();
  check_dates_lim_deb();
  check_alarms();
}
void check_dates()
{
  /////////////////////////// Vérifier la validité de chaque date
}
void check_dates_fin_deb()
{
  // Pour chaque événement, vérifier que la date de fin est bien postérieure à la date de début.
  int e = 0, i, j;
  while (event_exists(e))
  {
    j = get_element(e, FINREP);
    if (j != -1) 
    {
      i = get_element(e, DEBUT);
      if (ft_strncmp(y->u + y->t[i][3], y->u + y->t[j][3], y->t[i][4]) > 0)
      {
        printf("Erreur : date d'expiration antérieure à la date de début.\nOccurence %d et %d de l'évènement %d.\n", i, j, e);
        exit(1);
      }
    }
    e++;
  }
}
void check_dates_lim_deb()
{
  // Pour chaque événement répétitif avec date limite, vérifier que la date limite est bien postérieure à la date de début
  int e = 0, i, j;
  while (event_exists(e))
  {
    i = get_element(e, DEBUT);
    j = get_element(e, FIN);
    if (ft_strncmp(y->u + y->t[i][3], y->u + y->t[j][3], y->t[i][4]) > 0)
    {
      printf("Erreur : date de fin antérieure à la date de début.\nOccurence %d et %d de l'évènement %d.\n", i, j, e);
      exit(1);
    }
    e++;
  }
}
void check_alarms()
{
  int e = 0, i, j, k, l;
  while (event_exists(e))
  {
    i = j = 0;
    while ((k = get_elementi(e, ALAR, i)) != -1)
    {
      for (j = i + 1; (l = get_elementi(e, ALAR, j)) != -1; j++)
      {
        if (ft_strncmp(y->u + y->t[k][3], y->u + y->t[l][3], y->t[k][4]) == 0)
        {
          printf("Erreur : alarmes identiques.\nOccurence %d et %d de l'évènement %d.\n", i, j, e);
          exit(1);
        }
      }
      i++;
    }
    e++;
  }
}
int get_element(int e, int v)
{
  return get_elementi(e, v, 0);
}
int get_elementi(int e, int v, int k)
{
  int i;
  for (i = 0; i < y->ts; i++)
  {
    if (y->t[i][1] == v && y->t[i][2] == e)
    {
      if (k == 0)
      {
        return i;
      } else {
        k--;
      }
    }
  }
  return -1;
}
int event_exists(int e)
{
  int i;
  for (i = 0; i < y->ts; i++)
  {
    if (y->t[i][2] == e)
    {
      return 1;
    }
  }
  return 0;
}
void translate()
{
  FILE *f = fopen("calendrier.html", "w");
  if (f == NULL)
  {
    printf("Erreur d'ouverture du fichier.\n");
    exit(1);
  }
  fprintf(f, "<!DOCTYPE html>\n<html>\n<head>\n<meta charset=\"utf-8\" />\n<title>Calendrier</title>\n<style>\n"
    "body {\nfont-family: monospace;\n}\n.g {\ncolor: green;\n}\n.r {\ncolor: red;\n}\n.b {\ncolor: black;\n}\n"
    "</style></head>\n<body>\n");
  int event = 0, l = 0, unique = 0, repetitif = 0, journee = 0, i, j, k;
  while (event_exists(event))
  {
    while (l < y->ts && l != -1)
    {
      if (y->t[l][0] != EVT) {
        l++;
      } else {
        break;
      }
    }
    if (l == -1)
    {
      break;
    }
    i = get_element(event, DEBUT);
    j = get_element(event, FIN);
    switch (y->t[l][1])
    {
      case UNIQ:
        fprintf(f, "<div class=\"b\">\n<h1>\nDu ");
        print_date(f, i);
        fprintf(f, " ");
        print_heure(f, i);
        fprintf(f, " au ");
        print_date(f, j);
        fprintf(f, " ");
        print_heure(f, j);
        fprintf(f, "\n</h1>\n");
        unique++;
        break;
      case REPET:
        fprintf(f, "<div class=\"g\">\n<h1>\nDu ");
        print_date(f, i);
        fprintf(f, " ");
        print_heure(f, i);
        fprintf(f, " au ");
        print_date(f, j);
        fprintf(f, " ");
        print_heure(f, j);
        fprintf(f, "\n</h1>\n");
        repetitif++;
        break;
      case JOURNEE:
        fprintf(f, "<div class=\"r\">\n<h1>\nLe ");
        print_date(f, i);
        fprintf(f, ", toute la journée\n</h1>\n"); 
        journee++;
        break;
    }
    // titre h2
    i = get_element(event, TITRE);
    if (i == -1 || y->t[i][4] == 0)
    {
      fprintf(f, "<h2>\nSans titre\n</h2>\n");
    } else {
      fprintf(f, "<h2>\n");
      print_lstr(f, y->u + y->t[i][3], y->t[i][4]);
      fprintf(f, "\n</h2>\n");
    }
    // lieu p
    i = get_element(event, LIEU);
    if (i == -1 || y->t[i][4] == 0)
    {
      fprintf(f, "<p>\nPas de lieu\n<br>\n");
    } else {
      fprintf(f, "<p>\nLieu : ");
      print_lstr(f, y->u + y->t[i][3], y->t[i][4]);
      fprintf(f, "\n<br>\n");
    }
    // description p
    i = get_element(event, DESCR);
    if (i == -1 || y->t[i][4] == 0)
    {
      fprintf(f, "Pas de description\n<br>\n");
    } else {
      fprintf(f, "Description : ");
      print_lstr(f, y->u + y->t[i][3], y->t[i][4]);
      fprintf(f, "\n<br>\n");
    }
    // REPETITIONS
    if (y->t[l][1] == REPET)
    {
      i = get_element(event, REPET);
      fprintf(f, "Doit se répéter chaque ");
      j = get_element(event, REP);
      switch(y->u[y->t[j][3]])
      {
        case 'D':
          fprintf(f, "jour, ");
          break;
        case 'W':
          fprintf(f, "semaine, ");
          break;
        case 'M':
          fprintf(f, "mois, ");
          break;
        case 'Y':
          fprintf(f, "année, ");
          break;
      }
      j = get_element(event, FINREP);
      if (j != -1) 
      {
        fprintf(f, "jusqu'au ");
        print_date(f, j);
        fprintf(f, " à ");
        print_heure(f, j);
      } else {
        j = get_element(event, JOURS);
        fprintf(f, "les ");
        j = scan_jrs(j);
        k = 0;
        char *jours[] = {"lundi", "mardi", "mercredi", "jeudi", "vendredi", "samedi", "dimanche"};
        while (j) {
          if (j & 1) {
            fprintf(f, "%s", jours[k]);
            if (j > 1) {
              if (j > 2) {
                fprintf(f, ", ");
              } else {
                fprintf(f, " et ");
              }
            }
          }
          j >>= 1;
          k++;
        }
        fprintf(f, ", ");
        j = get_element(event, NBREP);
        print_lstr(f, y->u + y->t[j][3], y->t[j][4]);
        fprintf(f, " fois");
      }
      fprintf(f, "\n<br>\n");
    }
    // ALARMS
    i = get_element(event, ALAR);
    if (i != -1)
    {
      fprintf(f, "Alarmes définies : ");
      j = 0;
      while (i != -1)
      {
        print_alarm(f, i);
        i = get_elementi(event, ALAR, ++j);
        if (i != -1)
        {
          fprintf(f, ", ");
        }
      }
      fprintf(f, "\n");
    }
    fprintf(f, "</p>\n</div>\n");
    event++;l++;
  }
  fprintf(f, "<div>\n<p>\n%d événements au total dont :\n</p>\n<ul>\n<li>\n%d événements uniques\n"
    "</li>\n<li>\n%d événements répétitifs\n</li>\n<li>\n%d événements à la journée\n</li>\n</ul>\n"
    "</div>\n</body>\n</html>\n", event, unique, repetitif, journee);
  fclose(f);
}
void print_date(FILE *f, int l)
{
  print_lstr(f, y->u + y->t[l][3] + 6, 2);
  fprintf(f, "/");
  print_lstr(f, y->u + y->t[l][3] + 4, 2);
  fprintf(f, "/");
  print_lstr(f, y->u + y->t[l][3], 4);
}
void print_heure(FILE *f, int l)
{
  print_lstr(f, y->u + y->t[l][3] + 9, 2);
  fprintf(f, ":");
  print_lstr(f, y->u + y->t[l][3] + 11, 2);
  fprintf(f, ":");
  print_lstr(f, y->u + y->t[l][3] + 13, 2);
}
void print_lstr(FILE *f, char *p, int l)
{
  while (l--)
  {
    fprintf(f, "%c", *p++);
  }
}
int scan_jrs(int l)
{
  int i = 0, o = y->t[l][3];
  while (o < y->t[l][3] + y->t[l][4])
  {
    switch (y->u[o])
    {
      case 'M':
        i += 0b00000001;
        break;
      case 'T':
        if (y->u[o + 1] == 'U')
        {
          i += 0b00000010;
        } else {
          i += 0b00001000;
        }
        break;
      case 'W':
        i += 0b00000100;
        break;
      case 'F':
        i += 0b00010000;
        break;
      case 'S':
        if (y->u[o + 1] == 'A')
        {
          i += 0b00100000;
        } else {
          i += 0b01000000;
        }
        break;
    }
    o += 3;
  }
  return i;
}
int print_alarm(FILE *f, int l)
{
  int p = y->t[l][3];
  while (y->u[p] != 'T')
  {
    p++;
  }
  p++;
  print_lstr(f, y->u + p, y->t[l][3] + y->t[l][4] - p);
}
static int ft_charcmp(int c1, int c2)
{
  if (c1 > c2)
  {
    return (1);
  }
  else if (c1 < c2)
  {
    return (-1);
  }
  return (0);
}
int ft_strcmp(const char *s1, const char *s2)
{
  size_t i;

  i = 0;
  while (s1[i] && s2[i])
  {
    if (s1[i] == s2[i])
    {
      i++;
    }
    else
    {
      break;
    }
  }
  return (ft_charcmp(s1[i], s2[i]));
}
int ft_strequ(const char *s1, const char *s2)
{
  if (!s1 || !s2)
  {
    return (0);
  }
  return (!ft_strcmp(s1, s2));
}
int ft_strncmp(const char *s1, const char *s2, size_t n)
{
  size_t i;

  i = 0;
  if (n == 0)
  {
    return (0);
  }
  while (s1[i] && s2[i] && i < n - 1)
  {
    if (s1[i] != s2[i])
    {
      break;
    }
    i++;
  }
  return (s1[i] - s2[i]);
}
