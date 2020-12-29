%{
#include <stdio.h>
extern FILE* yyin;
extern char* yytext;
extern int yylineno;
%}

%token BGIN END ID TIP CLASS
%token IF ELSE CONDITIE WHILE BOOLVALUE BOOLOPERATOR COMPR
%token MATHOPERATOR
%token ASSIGN NR SIZE


%start code 
%%
code: declaratii main_block 
{printf("program corect sintactic\n");}
    ;

declaratii:declaratie
        |declaratii declaratie
        |nothing
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
main_block: BGIN list END
        |BGIN  END
        ;
list:statement ';'
        |list statement ';'
        |list repetitive_structure
        |list if
        |nothing
        ;
statement:ID ASSIGN ID
        |ID ASSIGN NR
        |ID ASSIGN mathexpresions
        |ID ASSIGN boolexpresion
        |ID '(' ')'
        |ID '(' lista_apel ')'
        ;
lista_apel: NR
        |ID
        |BOOLVALUE
        |boolexpresion
        |mathexpresions
        |ID '(' ')'
        |ID '(' lista_apel ')'
        |lista_apel ',' lista_apel
        ;
if:     IF'('boolexpresion')''{'list'}'
        |IF'('boolexpresion')''{'list'}' ELSE '{'list'}'
        ;
repetitive_structure:WHILE '('boolexpresion ')''{'list '}'
        ;
boolexpresion:
        |ID
        |BOOLVALUE
        |ID '(' ')'
        |ID '(' lista_apel ')'
        |mathexpresions COMPR mathexpresions
        |boolexpresion BOOLOPERATOR boolexpresion
        ;
mathexpresions:
        ID
        |NR
        |ID '(' ')'
        |ID '(' lista_apel ')'
        |mathexpresions MATHOPERATOR mathexpresions
        ;
nothing:
;
%%
void yyerror(char * s){
printf("eroare: %s la linia:%d\n",s,yylineno);
}

int main(int argc, char** argv){
yyin=fopen(argv[1],"r");
yyparse();
} 