%code top {
#include <stdio.h>
#include "scanner.h"
#include <math.h>
#include <strings.h>
#include <stdlib.h>
#include "calc.h"
}


%union {
    double valorLiteral;
    struct registroDeSimbolos * ptrARegistro;
}

%defines "parser.h"
%output "parser.c"

%token NL "\n"
%token SUMAASIGN "+=" 
%token MENOSASIGN "-=" 
%token PRODUCTASIGN "*="
%token DIVASIGN "/=" 
%right '='
%right "+=" 
%right "-=" 
%right "*=" 
%right "/=" 
%left '+' '-'
%left '*' '/'
%precedence NEG
%right '^'
%token <valorLiteral> LITERAL 
%token <ptrARegistro> IDENTIFICADOR FUN PAL_RESER_VAR PAL_RESER_SALIR
%type <valorLiteral> expresion
%define parse.error verbose

%% //Gramatica
calculadora: 
    sesion { if (yynerrs|| yylexerrs || yyerrsemantic) YYABORT;}
    ;    

sesion :
    %empty
    | sesion linea
    ;

linea :
      "\n"
    | expresion "\n"                                  {printf("\n%lf",$1);}
    | PAL_RESER_VAR IDENTIFICADOR  "\n"               {declararIdentificador($<ptrARegistro>2, 0);}
    | PAL_RESER_VAR IDENTIFICADOR '=' expresion "\n"  {declararIdentificador($<ptrARegistro>2, $4);}     
    | PAL_RESER_SALIR "\n"                            {exit(0);}
    | error "\n"
    ;

expresion:
  LITERAL                                         {$$ = $<valorLiteral>1;}
| IDENTIFICADOR                                   {
                                                    struct registroDeSimbolos *identificador = obtenerIdentificador($<ptrARegistro>1->nombre);
                                                    if(identificador == NULL) {
                                                        YYERROR;
                                                    }
                                                    $$ = identificador->valor.valorDeVariable; 
                                                  }
| FUN '(' expresion ')'                           {$$ = valorFuncion($<ptrARegistro>1, $3);}
| IDENTIFICADOR '=' expresion                     {
                                                    struct registroDeSimbolos *resultadoAsign = asignarPorToken($<ptrARegistro>1->nombre, $3, '=');
                                                    if(resultadoAsign == NULL) {
                                                        YYERROR;
                                                    }
                                                    $$ = resultadoAsign->valor.valorDeVariable; 
                                                  }
| IDENTIFICADOR "+=" expresion                    {
                                                    struct registroDeSimbolos *resultadoAsign = asignarPorToken($<ptrARegistro>1->nombre, $3, SUMAASIGN);
                                                    if(resultadoAsign == NULL) {
                                                        YYERROR;
                                                    }
                                                    $$ = resultadoAsign->valor.valorDeVariable;
                                                   }
| IDENTIFICADOR "-=" expresion                     {
                                                    struct registroDeSimbolos *resultadoAsign = asignarPorToken($<ptrARegistro>1->nombre, $3, MENOSASIGN);
                                                    if(resultadoAsign == NULL) {
                                                        YYERROR;
                                                    }
                                                    $$ = resultadoAsign->valor.valorDeVariable;
                                                   }
| IDENTIFICADOR "*=" expresion                     {
                                                    struct registroDeSimbolos *resultadoAsign = asignarPorToken($<ptrARegistro>1->nombre, $3, PRODUCTASIGN);
                                                    if(resultadoAsign == NULL) {
                                                        YYERROR;
                                                    }
                                                    $$ = resultadoAsign->valor.valorDeVariable;
                                                   }
| IDENTIFICADOR "/=" expresion                     {
                                                    struct registroDeSimbolos *resultadoAsign = asignarPorToken($<ptrARegistro>1->nombre, $3, DIVASIGN);
                                                    if(resultadoAsign == NULL) {
                                                        YYERROR;
                                                    }
                                                    $$ = resultadoAsign->valor.valorDeVariable; 
                                                   }
| expresion '+' expresion                          {$$ = $1 + $3;}
| expresion '-' expresion                          {$$ = $1 - $3;}
| expresion '*' expresion                          {$$ = $1 * $3;}
| expresion '/' expresion                          {$$ = $1 / $3;}
| '-' expresion  %prec NEG                         {$$ = -$2;}
| expresion '^' expresion                          {$$ = pow($1,$3);}
| '(' expresion ')'                                {$$ = $2;}
;

%% //Epilogo