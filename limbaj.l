%{
#include <stdio.h>
#include "y.tab.h"
%}
%option noyywrap
%%

"begin_progr" {return BGIN;}
"end_progr" {return END;}
"while" {return WHILE;}
"if" {return IF;}
"else" {return ELSE;}
"int"|"float"|"char"|"bool"|"string" {return TIP;}
[_a-zA-Z][_a-zA-Z0-9]* {return ID;}
[0-9] {return NR;}
":=" {return ASSIGN;}
[ \t] ;
\n {yylineno++;}
. {return yytext[0];}

