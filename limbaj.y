%{
#include <stdio.h>
extern FILE* yyin;
extern char* yytext;
extern int yylineno;
%}

%token BGIN END ID TIP CLASS
%token IF ELSE CONDITIE WHILE BOOLVALUE BOOLOPERATOR
%token MATHOPERATOR
%token ASSIGN NR SIZE


%start code 
%%
code: declaratii main_block 
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
        |lista_apel ',' NR
        |lista_apel ',' ID
        |lista_apel ',' boolexpresion
        |lista_apel ',' mathexpresions
        ;
if:     IF'('conditie')''{'list'}'
        ;
repetitive_structure:WHILE '('conditie ')''{'list '}'
        ;
conditie:ID
        |BOOLVALUE
        |boolexpresion
        ;
boolexpresion:
        ID BOOLOPERATOR ID
        |ID BOOLOPERATOR BOOLVALUE
        |ID BOOLOPERATOR boolexpresion
        |BOOLVALUE BOOLOPERATOR ID
        |BOOLVALUE BOOLOPERATOR BOOLVALUE
        |BOOLVALUE BOOLOPERATOR boolexpresion
        ;
mathexpresions:
        ID
        NR
        |ID MATHOPERATOR ID
        |ID MATHOPERATOR NR
        |ID MATHOPERATOR mathexpresions
        |NR MATHOPERATOR ID
        |NR MATHOPERATOR NR
        |NR MATHOPERATOR mathexpresions
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