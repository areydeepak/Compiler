D			[0-9]
L			[a-zA-Z_]
H			[a-fA-F0-9]
E			[Ee][+-]?{D}+
FS			(f|F|l|L)
IS			(u|U|l|L)*

%{
#include <stdio.h>
#include "y.tab.h"

void count();
void count2();
void count3();
void line();
int check_type();
int comment();
%}

%%
"/*"			{ comment(); }

"auto"			{ count(); return(AUTO); }
"break"			{ count(); return(BREAK); }
"case"			{ count(); return(CASE); }
"char"			{ count(); return(CHAR); }
"const"			{ count(); return(CONST); }
"continue"		{ count(); return(CONTINUE); }
"default"		{ count(); return(DEFAULT); }
"do"			{ count(); return(DO); }
"double"		{ count(); return(DOUBLE); }
"else"			{ count(); return(ELSE); }
"enum"			{ count(); return(ENUM); }
"extern"		{ count(); return(EXTERN); }
"float"			{ count(); return(FLOAT); }
"for"			{ count(); return(FOR); }
"goto"			{ count(); return(GOTO); }
"if"			{ count(); return(IF); }
"int"			{ count(); return(INT); }
"long"			{ count(); return(LONG); }
"register"		{ count(); return(REGISTER); }
"return"		{ count(); return(RETURN); }
"short"			{ count(); return(SHORT); }
"signed"		{ count(); return(SIGNED); }
"sizeof"		{ count(); return(SIZEOF); }
"static"		{ count(); return(STATIC); }
"struct"		{ count(); return(STRUCT); }
"switch"		{ count(); return(SWITCH); }
"typedef"		{ count(); return(TYPEDEF); }
"union"			{ count(); return(UNION); }
"unsigned"		{ count(); return(UNSIGNED); }
"void"			{ count(); return(VOID); }
"volatile"		{ count(); return(VOLATILE); }
"while"			{ count(); return(WHILE); }

{L}({L}|{D})*		{ count(); return(check_type()); }

0[xX]{H}+{IS}?		{ count(); return(CONSTANT); }
0{D}+{IS}?		{ count(); return(CONSTANT); }
{D}+{IS}?		{ count(); return(CONSTANT); }
L?'(\\.|[^\\'])+'	{ count(); return(CONSTANT); }

{D}+{E}{FS}?		{ count(); return(CONSTANT); }
{D}*"."{D}+({E})?{FS}?	{ count(); return(CONSTANT); }
{D}+"."{D}*({E})?{FS}?	{ count(); return(CONSTANT); }

L?\"(\\.|[^\\"])*\"	{ count(); return(STRING_LITERAL); }

"..."			{ count(); return(ELLIPSIS); }
">>="			{ count(); return(RIGHT_ASSIGN); }
"<<="			{ count(); return(LEFT_ASSIGN); }
"+="			{ count(); return(ADD_ASSIGN); }
"-="			{ count(); return(SUB_ASSIGN); }
"*="			{ count(); return(MUL_ASSIGN); }
"/="			{ count(); return(DIV_ASSIGN); }
"%="			{ count(); return(MOD_ASSIGN); }
"&="			{ count(); return(AND_ASSIGN); }
"^="			{ count(); return(XOR_ASSIGN); }
"|="			{ count(); return(OR_ASSIGN); }
">>"			{ count(); return(RIGHT_OP); }
"<<"			{ count(); return(LEFT_OP); }
"++"			{ count(); return(INC_OP); }
"--"			{ count(); return(DEC_OP); }
"->"			{ count(); return(PTR_OP); }
"&&"			{ count(); return(AND_OP); }
"||"			{ count(); return(OR_OP); }
"<="			{ count(); return(LE_OP); }
">="			{ count(); return(GE_OP); }
"=="			{ count(); return(EQ_OP); }
"!="			{ count(); return(NE_OP); }
";"			{ count(); return(Aa); }
("{"|"<%")		{ count(); return(Bb); }
("}"|"%>")		{ count(); return(Cc); }
","			{ count(); return(Dd); }
":"			{ count(); return(Ee); }
"="			{ count(); return(Ff); }
"("			{ count(); return(Gg); }
")"			{ count(); return(Hh); }
("["|"<:")		{ count(); return(Ii); }
("]"|":>")		{ count(); return(Jj); }
"."			{ count(); return(Kk); }
"&"			{ count(); return(Ll); }
"!"			{ count(); return(Mm); }
"~"			{ count(); return(Nn); }
"-"			{ count(); return(Oo); }
"+"			{ count(); return(Pp); }
"*"			{ count(); return(Qq); }
"/"			{ count(); return(Rr); }
"%"			{ count(); return(Ss); }
"<"			{ count(); return(Tt); }
">"			{ count(); return(Uu); }
"^"			{ count(); return(Vv); }
"|"			{ count(); return(Ww); }
"?"			{ count(); return(Xx); }

[ \t\v\f]		{ count2(); }
[\n]                    { count3();line(); }
.			{ printf("Error\n"); }

%%

int yywrap()
{
	return(1);
}


int comment()
{
	char c, c1;

loop:
	while ((c = input()) != '*' && c != 0)
		putchar(c);

	if ((c1 = input()) != '/' && c != 0)
	{
		unput(c1);
		goto loop;
	}

	if (c != 0)
		putchar(c1);
	printf("   (comment)\n");
}


int column = 1;
int lno=1;
void count()
{
	int i;
	printf(" %d  %d  ",lno,column);
	for (i = 0; yytext[i] != '\0'; i++)
	{
		if (yytext[i] == '\n')
		{
			column = 1;
		}
		else if (yytext[i] == '\t')
		{
			column += 8 - (column % 8);
		}
		else
		{
			column++;
		}
	}
	ECHO;
}
void count2()
{
	column=column+1;
}
void count3()
{
        column=1;
}
void line()
{
	lno=lno+1;
}
int check_type()
{
/*
* pseudo code --- this is what it should check
*
*	if (yytext == type_name)
*		return(TYPE_NAME);
*
*	return(IDENTIFIER);
*/

/*
*	it actually will only return IDENTIFIER
*/

	return(IDENTIFIER);
}
int main()
{
	int val, total = 0, n = 0;
	printf("row,coloumn,lexeme,token\n");
   	while ( (val = yylex()) > 0 ) 
	{
		switch(val)
		{
			case 1001:
				printf(" CONSTANT \n");
				break;
			case 1002:
				printf(" IDENTIFIER \n");
				break;
			case 1003:
				printf(" AUTO \n");
				break;
			case 1004:
				printf(" BREAK \n");
				break;
			case 1005:
				printf(" CASE \n");
				break;
			case 1006:
				printf(" CHAR \n");
				break;
			case 1007:
				printf(" CONST \n");
				break;
			case 1008:
				printf(" CONTINUE \n");
				break;
			case 1009:
				printf(" DEFAULT \n");
				break;
			case 1010:
				printf(" DO \n");
				break;
			case 1011:
				printf(" DOUBLE \n");
				break;
			case 1012:
				printf(" ELSE \n");
				break;
			case 1013:
				printf(" ENUM \n");
				break;
			case 1014:
				printf(" EXTERN \n");
				break;
			case 1015:
				printf(" FLOAT \n");
				break;
			case 1016:
				printf(" FOR \n");
				break;
			case 1017:
				printf(" GOTO \n");
				break;
			case 1018:
				printf(" IF \n");
				break;
			case 1019:
				printf(" INT \n");
				break;
			case 1020:
				printf(" LONG \n");
				break;
			case 1021:
				printf(" REGISTER \n");
				break;
			case 1022:
				printf(" RETURN \n");
				break;
			case 1023:
				printf(" SHORT \n");
				break;
			case 1024:
				printf(" SIGNED \n");
				break;
			case 1025:
				printf(" SIZEOF \n");
				break;
			case 1026:
				printf(" STATIC \n");
				break;
			case 1028:
				printf(" SWITCH \n");
				break;
			case 1029:
				printf(" TYPEDEF \n");
				break;
			case 1030:
				printf(" UNION \n");
				break;
			case 1031:
				printf(" UNSIGNED \n");
				break;
			case 1032:
				printf(" VOID \n");
				break;
			case 1033:
				printf(" VOLATILE \n");
				break;
			case 1033+1:
				printf(" WHILE \n");
				break;
			case 1034+1:
				printf(" STRING_LITERAL \n");
				break;
			case 1035+1:
				printf(" ELLIPSIS \n");
				break;
			case 1036+1:
				printf(" RIGHT_ASSIGN \n");
				break;
			case 1037+1:
				printf(" LEFT_ASSIGN \n");
				break;
			case 1038+1:
				printf(" ADD_ASSIGN \n");
				break;
			case 1039+1:
				printf(" SUB_ASSIGN \n");
				break;
			case 1040+1:
				printf(" MUL_aSSIGN \n");
				break;
			case 1041+1:
				printf(" DIV_ASSIGN \n");
				break;
			case 1042+1:
				printf(" MOD_ASSIGN \n");
				break;
			case 1043+1:
				printf(" AND_ASSIGN \n");
				break;
			case 1044+1:
				printf(" XOR_ASSIGN \n");
				break;
			case 1045+1:
				printf(" OR_ASSIGN \n");
				break;
			case 1046+1:
				printf(" RIGHT_OP \n");
				break;
			case 1047+1:
				printf(" LEFT_OP \n");
				break;
			case 1048+1:
				printf(" INC_OP \n");
				break;
			case 1049+1:
				printf(" DEC_OP \n");
				break;
			case 1050+1:
				printf(" PTR_OP \n");
				break;
			case 1051+1:
				printf(" AND_OP \n");
				break;
			case 1052+1:
				printf(" OR_OP \n");
				break;
			case 1053+1:
				printf(" LE_OP \n");
				break;
			case 1054+1:
				printf(" GE_OP \n");
				break;
			case 1055+1:
				printf(" EQ_OP \n");
				break;
			case 1056+1:
				printf(" NE_OP \n");
				break;
			case 1057+1:
				printf(" ; \n");
				break;
			case 1058+1:
				printf(" { \n");
				break;
			case 1059+1:
				printf(" } \n");
				break;
			case 1060+1:
				printf(" , \n");
				break;
			case 1061+1:
				printf(" : \n");
				break;
			case 1062+1:
				printf(" = \n");
				break;
			case 1063+1:
				printf(" ( \n");
				break;
			case 1064+1:
				printf(" ) \n");
				break;
			case 1065+1:
				printf(" [ \n");
				break;
			case 1066+1:
				printf(" ] \n");
				break;
			case 1067+1:
				printf(" . \n");
				break;
			case 1068+1:
				printf(" & \n");
				break;
			case 1069+1:
				printf(" ! \n");
				break;
			case 1070+1:
				printf(" ~ \n");
				break;
			case 1071+1:
				printf(" - \n");
				break;
			case 1072+1:
				printf(" + \n");
				break;
			case 1073+1:
				printf(" * \n");
				break;
			case 1074+1:
				printf(" / \n");
				break;
			case 1075+1:
				printf(" REMAINDER \n");
				break;
			case 1076+1:
				printf(" < \n");
				break;
			case 1077+1:
				printf(" > \n");
				break;
			case 1078+1:
				printf(" ^ \n");
				break;
			case 1079+1:
				printf(" | \n");
				break;
			case 1080+1:
				printf(" ? \n");
				break;
                        case 1027:
   				printf(" STRUCT \n");
				break;
		}
	}
}
