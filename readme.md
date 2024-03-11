# Fully Functional Calculator with Semantic Routines and Dictionary Handling.

This project aims to create a fully functional calculator with semantic routines and dictionary handling recognition. It utilizes Flex to recognize a language with tokens such as Identifier, Integer, and Hexadecimal, as well as error tokens for general errors, malformed integers, and end-of-file conditions. Additionally, Bison is used to implement syntax grammar and a symbol table

### Features:

- Implement semantic routines for error detection.
- Handle dictionary for semantic analysis.
- Recognize and handle semantic and syntactic errors.
- Perform arithmetic calculations accurately.
- Provide comprehensive error messages for better user understanding.

### Example:

Given the input:

```
var a = 1
var b = 2
var c = 3
var z = (a += (b *= c)) / 2
a
b
c
```

The output should be:

```
a: 1
b: 2
c: 3
z: 3.5
7
6
3
```

### Technologies:

- C programming language.
- Flex (Lexical Analyzer Generator).
- Bison (Parser Generator).

### Project Structure:

- main.c: Contains the main program logic.
- calc.c: Contains the calculator functions.
- calc.h: Header file defining the scanner and related functions.
- scanner.l: Flex file defining the lexical grammar of the calculator.
- parser.y: Bison file defining the syntax grammar and symbol table.
- Makefile: Makefile for compiling the project.
