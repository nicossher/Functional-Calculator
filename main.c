#include <stdio.h>
#include <stdlib.h>
#include "parser.h"
#include "calc.h"

int main(){
   iniciarTabla();
   yyparse();
   return EXIT_SUCCESS;
}


