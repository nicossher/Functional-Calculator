%{
#include <stdio.h>
#include <stdlib.h>
#include <strings.h>
#include "parser.h"
#include "calc.h"
%}

digito [0-9]
enteroOp {digito}*
entero {digito}+
fraccion {enteroOp}\.{entero}|{entero}\.{enteroOp}
expn [Ee][+-]?{entero} 
letra [A-Za-z]
letraOdigito {letra}|{digito}
caractNoIncluido [[:punct:]]{-}[.+/*()=^-]


%option outfile="scanner.c"
%option header-file="scanner.h"
%option noinput
%option nounput
%option noyywrap
%%
[ \t]+                                                              ;
"+"                                                                 return '+';
"-"                                                                 return '-';
"*"                                                                 return '*';
"/"                                                                 return '/';
"^"                                                                 return '^';
"("                                                                 return '(';
")"                                                                 return ')';
"="                                                                 return '=';
"+="                                                                return SUMAASIGN;
"-="                                                                return MENOSASIGN;
"*="                                                                return PRODUCTASIGN;
"/="                                                                return DIVASIGN;
var                                                                 return PAL_RESER_VAR;
salir                                                               return PAL_RESER_SALIR;
{letra}{letraOdigito}*                                              {yylval.ptrARegistro = crearRegistro(yytext, tokenPorTablaDeSimbolos(yytext)); return tokenPorTablaDeSimbolos(yytext);}
{letra}({caractNoIncluido}|{letraOdigito}|\.)+                      {yylexerrs++; yyerror("\nError Identificador mal formado  "); printf("%s",yytext);}
{entero}{expn}?                                                     |
{fraccion}{expn}?                                                   {sscanf(yytext, "%lf", &yylval.valorLiteral); return LITERAL;}
{entero}{letraOdigito}+                                             |
{enteroOp}({letraOdigito}|\.)+{expn}?                               {yylexerrs++; yyerror("\nError Literal mal formado "); printf("%s",yytext);}
{caractNoIncluido}+                                                 {yylexerrs++; yyerror("\nError general ");printf("%s", yytext);}
\n    		                                                        return NL;
%%