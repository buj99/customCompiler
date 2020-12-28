%{
#include <stdio.h>
extern FILE* yyin;
extern char* yytext;
extern int yylineno;
%}

%token BGIN END ID TIP
%token  WHILE IF ELSE
%token ASSIGN NR
%start code 
%%
code: declaratii bloc_comenzi 
{printf("program corect sintactic\n");}
    ;

declaratii:declaratie
        |declaratii declaratie
        ;
declaratie: ID ':' TIP ';'
        ;

bloc_comenzi: BGIN END
        ;
%%
void yyerror(char * s){
printf("eroare: %s la linia:%d\n",s,yylineno);
}

int main(int argc, char** argv){
yyin=fopen(argv[1],"r");
yyparse();
} 