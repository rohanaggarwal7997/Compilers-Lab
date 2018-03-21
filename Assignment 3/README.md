### HOW TO

	$ bison -d -v parser.y
	$ flex lexer.lex
	$ gcc -w parser.tab.c lex.yy.c -o main
	$ ./main < sample.c
