moving files : lexer
	mkdir ../bin
	mv lexer ../bin
	
lexer: lex.yy.c
	gcc -o lexer lex.yy.c
	
lex.yy.c: lexer.l y.tab.h
	lex  lexer.l
