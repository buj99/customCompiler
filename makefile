all : yacc flex cc 

yacc : limbaj.y
	yacc -d limbaj.y
flex : limbaj.l
	flex limbaj.l
cc: y.tab.c lex.yy.c
	gcc y.tab.c lex.yy.c -o out
out : yacc flex cc clean_c
clean_c: 
	rm y.tab.c y.tab.h lex.yy.c
clean : 
	rm y.tab.c y.tab.h out lex.yy.c