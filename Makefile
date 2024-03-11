calculadora: parser.y scanner.l calc.c main.c

	bison parser.y && flex scanner.l && gcc -Wall -D_GNU_SOURCE -std=c2x -pedantic-errors scanner.c parser.c calc.c main.c -o calculadora -lfl -lm

clean:
	rm -f calculadora
	rm -f scanner.h
	rm -f scanner.c
	rm -f parser.h
	rm -f parser.c
