%{
#include <stdio.h>
#include "y.tab.h"
%}
%option noyywrap
%%

"begin_progr" {return BGIN;}
"end_progr" {return END;}
"class" {return CLASS;}
"while" {return WHILE;}
"if" {return IF;}
"else" {return ELSE;}
"true"|"TRUE"|"false"|"FALSE" {return BOOLVALUE;}
"&&"|"||"|"!="|"==" {return BOOLOPERATOR;}
"-"|"+"|"/"|"%"|"^"|"*" {return MATHOPERATOR;}
"conditie" {return CONDITIE;}
"int"|"float"|"char"|"bool"|"string" {return TIP;}
[_a-zA-Z][_a-zA-Z0-9]* {return ID;}
[1-9][0-9]* {return NR;}
[1-9][0-9]* {return SIZE;}
":=" {return ASSIGN;}
[ \t] ;
\n {yylineno++;}
. {return yytext[0];}

