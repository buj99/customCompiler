%{
#include <stdio.h>
extern FILE* yyin;
extern char* yytext;
extern int yylineno;
%}

%token BGIN END ID TIP CLASS
%token WHILE IF ELSE 
%token ASSIGN NR SIZE

%start code 
%%
code: declaratii bloc_comenzi 
{printf("program corect sintactic\n");}
    ;

declaratii:declaratie
        |declaratii declaratie
        ;
declaratie:param';'
        |vector';'
        |function';'
        |CLASS ID '{' class_declaration '}' 
        ;
function:ID '('lista_param')'
        |ID '(' ')'
        |ID '('lista_param ')' ':' TIP
        |ID '(' ')' ':' TIP
        ;
lista_param: param
        | vector
        | lista_param ','  param
        | lista_param ',' vector
        ;
class_declaration: declaratii
        ;
param: ID ':' TIP
        ;
vector:ID ':' TIP '[' SIZE ']'
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