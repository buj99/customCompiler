%{
#include <stdio.h>
#include <string.h>
//#include "functionsList.c"
#include "symboltable.c"
extern FILE* yyin;
extern char* yytext;
extern int yylineno;

%}

%union {
int intval;
char* strval;
char* tipString;
}
%token <strval>ID 
%token <strval>TIP
%token BGIN END 
%token CLASS
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
function:ID '(' lista_param ')'
        { 
            if(add_to_symbol_table (&st, "global", create_declaration( $1, "void", function)) == false) {
                yyerror("Deja declarat\n");
                return 0;
            } 
        }
        |ID '(' ')' 
        { 
            if(add_to_symbol_table (&st, "global", create_declaration( $1, "void", function)) == false) {
                yyerror("Deja declarat\n");
                return 0;
            } 
        }
        |ID '('lista_param ')' ':' TIP
        { 
            if(add_to_symbol_table (&st, "global", create_declaration( $1, $6, function)) == false) {
                yyerror("Deja declarat\n");
                return 0;
            } 
        }
        |ID '(' ')' ':' TIP 
        {
            if(add_to_symbol_table (&st, "global", create_declaration( $1, $5, function)) == false) {
                yyerror("Deja declarat\n");
                return 0;
            } 
        }
        ;
lista_param: functionParam
        | functionVector
        | lista_param ','  functionParam
        | lista_param ',' functionVector
        ;
class_declaration: declaratii
        ;

param: ID ':' TIP
        ;

functionParam: ID ':' TIP //{ addFunctionParameterToCurrentFunctionParameterListHead( $1, $3, false); }
        ;

vector:ID ':' TIP '[' NR ']'
        ;

functionVector:ID ':' TIP '[' NR ']' //{ addFunctionParameterToCurrentFunctionParameterListHead( $1, $3, true); }
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
if:     IF '('boolexpresion')''{'list'}'
        |IF '('boolexpresion')''{'list'}' ELSE '{'list'}'
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


//DEBUG
print_symbol_table(st);
// struct FunctionNode* aux = functionsListHead;
//   while(aux != NULL) {
//       printf("Numele este: %s\n", aux->name);
//      aux = aux->nextNode;
//  }
} 