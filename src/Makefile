moving files : lexer
	mv lexer ../bin
	
lexer: lex.yy.c
	gcc -lfl -o lexer lex.yy.c
	
lex.yy.c: lexer.l y.tab.h
	lex  lexer.l


