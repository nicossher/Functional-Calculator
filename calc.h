struct registroDeSimbolos {
        char * nombre;    // Nombre del ID o de la funcion
        int tipoToken;
        union {
            double valorDeVariable;
            double (*funcion)(double);
        } valor;
        struct registroDeSimbolos *sigRegistro;
    };
int tokenPorTablaDeSimbolos(const char *lexemaIdentificador);
void iniciarTabla(void);


struct registroDeSimbolos * crearRegistro(char const *nombre, int tipo);
extern int yylexerrs;
extern int yyerrsemantic;
void yyerror(char const *);
void declararIdentificador(struct registroDeSimbolos *identificador, double valorAsignado);
double valorFuncion(struct registroDeSimbolos *funcion, double expresion);
struct registroDeSimbolos * guardarElemento (char const *nombre, int tipo);
struct registroDeSimbolos * obtenerElemento (char const *nombre);
struct registroDeSimbolos * asignarPorToken(char const * nombreIdentificador, double expresion, int tipoAsignacion);
struct registroDeSimbolos * obtenerIdentificador(char const *nombreIdentificador);