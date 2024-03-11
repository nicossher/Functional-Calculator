#include "calc.h"
#include <math.h>
#include <stdio.h>
#include "parser.h"
#include <strings.h>
#include <stdlib.h>
#include <string.h>

int yylexerrs = 0;
int yyerrsemantic = 0;
struct inicializarFuncion {
    char * nombre;
    double (*fun)(double);
};

struct inicializarFuncion const funs[] =
{
  { "sin", sin },
  { "cos", cos },
  { "tan", tan },
  { "asin", asin },
  { "acos", acos },
  { "atan", atan },
  { "log", log },
  { "sqrt", sqrt },
  { 0, 0 }
};

struct registroDeSimbolos * tablaDeSimbolos;
double valorPorAsignacion(double valorActual, double expresion, int tipoAsignacion);

struct registroDeSimbolos * crearRegistro(char const *nombre, int tipo) {
    struct registroDeSimbolos * nuevoRegistro = (struct registroDeSimbolos *) malloc(sizeof(struct registroDeSimbolos *));
    nuevoRegistro->nombre = strdup(nombre);
    nuevoRegistro->tipoToken = tipo;
    return nuevoRegistro;
}

struct registroDeSimbolos * guardarElemento (char const *nombre, int tipo) {
    struct registroDeSimbolos * nuevoRegistro = crearRegistro(nombre, tipo);
    nuevoRegistro->sigRegistro = tablaDeSimbolos;
    tablaDeSimbolos = nuevoRegistro;
    return nuevoRegistro;
}

struct registroDeSimbolos * obtenerElemento (char const *nombre) {
    struct registroDeSimbolos *elemento = tablaDeSimbolos;
    for (elemento = tablaDeSimbolos; elemento; elemento = elemento->sigRegistro)
        if (strcmp (elemento->nombre, nombre) == 0)
            return elemento;
    return NULL;
}

void iniciarTabla(void) {
    int i;
    struct registroDeSimbolos *ptrRecibido; 
    for (i=0; funs[i].nombre ; i++) {
        ptrRecibido = guardarElemento(funs[i].nombre, FUN);
        ptrRecibido->valor.funcion = funs[i].fun;
    }
    ptrRecibido = guardarElemento("e", IDENTIFICADOR);
    ptrRecibido->valor.valorDeVariable = 2.71828182846;
    ptrRecibido = guardarElemento("pi", IDENTIFICADOR);
    ptrRecibido->valor.valorDeVariable = 3.14159265359;
    return;
}

int tokenPorTablaDeSimbolos(const char *lexemaIdentificador) {
    struct registroDeSimbolos *unElemento;
    unElemento = obtenerElemento(lexemaIdentificador);
    if(unElemento != NULL && unElemento->tipoToken == FUN) {
        return FUN;
    }
    return IDENTIFICADOR;
}

void declararIdentificador(struct registroDeSimbolos *identificador, double valorAsignado) {
    struct registroDeSimbolos *auxiliar;
    if(obtenerElemento(identificador->nombre)) {
        yyerror("Error, la variable ya está declarada");
        yyerrsemantic++;
    } else {
        auxiliar = guardarElemento(identificador->nombre, identificador->tipoToken);
        auxiliar->valor.valorDeVariable = valorAsignado;
        printf("\n%s: %lf", auxiliar->nombre, auxiliar->valor.valorDeVariable);
    }
}

double valorFuncion(struct registroDeSimbolos *funcion, double expresion) {
    struct registroDeSimbolos *elemento = obtenerElemento(funcion->nombre);
    return elemento->valor.funcion(expresion);
}

struct registroDeSimbolos * obtenerIdentificador(char const *nombreIdentificador) {
    struct registroDeSimbolos *idEnTabla = obtenerElemento(nombreIdentificador);
    if(idEnTabla == NULL){
        yyerror("Error, la variable no está declarada");
        yyerrsemantic++; 
    }
    return idEnTabla;
}

struct registroDeSimbolos * asignarPorToken(char const *nombreIdentificador, double expresion, int tipoAsignacion) {
    struct registroDeSimbolos *idEnTabla = obtenerIdentificador(nombreIdentificador);
    if(idEnTabla != NULL) {
        idEnTabla->valor.valorDeVariable = valorPorAsignacion(idEnTabla->valor.valorDeVariable, expresion, tipoAsignacion);
    } 
    return idEnTabla;
}

double valorPorAsignacion(double valorActual, double expresion, int tipoAsignacion) {
    double auxiliar;
    switch(tipoAsignacion) {
        case '=':
            auxiliar = expresion;
            break;
        case SUMAASIGN:
            auxiliar = valorActual + expresion;
            break;
        case MENOSASIGN:
            auxiliar = valorActual - expresion;
            break;
        case PRODUCTASIGN:
            auxiliar = valorActual * expresion;
            break;
        case DIVASIGN:
            auxiliar = valorActual / expresion;
            break;
        default: 
            fprintf(stderr, "Hubo un error"); 
    }
    return auxiliar;
}

void yyerror(char const * frase) {
    fprintf(stderr,"\n%s",frase);
}