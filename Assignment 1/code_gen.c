#include "code_gen.h"
#include "name.h"
#include "lex.h"
#include <stdio.h>
#include <stdlib.h>
#include <error.h>

extern char *newname( void       );
extern void freename( char *name );

FILE *assFile, *interFile;
char *REG[8] = {'A','B','C','D','E','F','G','H'};

statements()
{
	assFile = fopen("Assembly.asm", "w");
	interFile = fopen("Intermediate.txt", "w");

	fprintf(assFile, "%s\n", "ORG 0000h");

	while(!match(EOI))
		statement();

	fprintf(assFile, "%s\n", "END");
	fclose(assFile);
	fclose(interFile);
}

statement()
{
	/*  statements -> expression1 SEMI  |  expression1 SEMI statements  */

	char *tempvar;


		if(match(ID))
		{
			char assignment[100];
			int loop_var=0;
			for(;loop_var<yyleng;loop_var++)assignment[loop_var]=*(yytext+loop_var);
			assignment[loop_var]='\0';

			advance();
			if( !legal_lookahead( COL, 0 ) )
				goto legal_lookahead_SEMI;
			if(match(COL))
			{
				advance();
				if( !legal_lookahead( EQUAL, 0 ) )
					goto legal_lookahead_SEMI;
				if(match(EQUAL))
				{
					advance();
					tempvar = expression1();
					fprintf(interFile,"_%s <- %s\n",assignment,tempvar);

					if(strcmp(tempvar, "t0") == 0){
						fprintf(assFile, "STA _%s\n", assignment);
					} else {
						fprintf(assFile, "PUSH A\nMOV A %c\nSTA _%s\nPOP A\n", REG[tempvar[1]-'0'], assignment);
					}
				}
				else
				{
					fprintf( stderr, "%d: Inserting missing equal\n", yylineno );
				}
			}
			else
			{
				fprintf( stderr, "%d: Inserting missing colon\n", yylineno );
			}
		}
		else if(match(IF))
			{
				advance();

				tempvar = expression1();
				if( !legal_lookahead( THEN, 0 ) )
				{
					freename(tempvar);
					goto legal_lookahead_SEMI;
				}
				if(match(THEN))
				{
					fprintf(interFile, "if (%s)\n", tempvar);
					int ifthenLabel = getIfThenLabel();
					fprintf(assFile, "CMP %c 0\nJZ IFTHEN%d\n", REG[tempvar[1] -'0'], ifthenLabel);
					fprintf(interFile, "%s\n", "then {");
					advance();
					freename(tempvar);
					statement();
					fprintf(interFile, "%s\n", "}");
					fprintf(assFile, "IFTHEN%d:\n", ifthenLabel);
					return;
				}
				else
					fprintf( stderr, "%d: Inserting missing then\n", yylineno );
			}
		else if(match(WHILE))
			{
				advance();
				int loopLabel1 = getLoopLabel();
				fprintf(assFile, "LOOP%d:\n",loopLabel1);

				tempvar = expression1();
				if( !legal_lookahead( DO, 0 ) )
				{
					freename(tempvar);
					goto legal_lookahead_SEMI;
				}
				if(match(DO))
				{
					fprintf(interFile, "while (%s)\n", tempvar);
					int loopLabel = getLoopLabel();
					fprintf(assFile, "CMP %c 0\nJZ LOOP%d\n", REG[tempvar[1]-'0'], loopLabel);

					fprintf(interFile, "%s\n", "do {");
					advance();

					freename(tempvar);
					statement();
					fprintf(interFile, "%s\n", "}");
					fprintf(assFile, "JMP LOOP%d\nLOOP%d:\n", loopLabel1, loopLabel);
					// freename(tempvar);
					return;
				}
				else
					fprintf( stderr, "%d: Inserting missing do\n", yylineno );

			}
		else if(match(BEGIN))
		{

				fprintf(interFile, "%s\n", "BEGIN{");
				advance();
				if(match(END)){printf("END\n");advance();return;}
				stmt_list();
				if(!legal_lookahead(END,0))
				{
					fprintf( stderr, "%d: Inserting missing END\n", yylineno );
					goto legal_lookahead_SEMI;
				}

				fprintf(interFile, "%s}\n", "END");
				advance();
				return;
		}
		else tempvar = expression1();

		freename( tempvar );

legal_lookahead_SEMI:
		if( match( SEMI ) )
			advance();
		else
			fprintf( stderr, "%d: Inserting missing semicolon\n", yylineno );
}

stmt_list()
{
	while(!match(END)&&!match(EOI))
		statement();
	if(match(EOI))fprintf( stderr, "%d: End of file reached no END found\n", yylineno );
}

char *expression1()
{
	/*expression1 -> expression | expression<expression |expression=expression |expression>expression | */
	char *tempvar3;
	char * tempvar=expression();
	if(match(GT))
	{
		freename(tempvar);
		tempvar3=newname();
		tempvar=newname();
		fprintf(interFile, "%s <- %s\n", tempvar, tempvar3);
		fprintf(assFile, "MOV %c %c\n", REG[tempvar[1]-'0'], REG[tempvar3[1]-'0']);

		advance();
		char *tempvar2=expression();


		// printf("    %s > %s\n",tempvar,tempvar2);
		fprintf(interFile, "%s <-  %s > %s\n",tempvar3,tempvar,tempvar2);
		int compLabel = getCompareLabel();
		fprintf(assFile, "CMP %c %c\n",REG[tempvar[1]-'0'],REG[tempvar2[1]-'0']);
		fprintf(assFile, "MVI %c 1\nJNZ COMPARE%d\nMVI %c 0\nCOMPARE%d:\n", REG[tempvar3[1]-'0'], compLabel, REG[tempvar3[1]-'0'], compLabel);

		freename(tempvar2);
		freename(tempvar);
		return tempvar3;
		//freename(tempvar1);

	}
	else if(match(LT))
	{
		freename(tempvar);
		tempvar3=newname();
		tempvar=newname();
		fprintf(interFile, "%s <- %s\n", tempvar, tempvar3);
		fprintf(assFile, "MOV %c %c\n", REG[tempvar[1]-'0'], REG[tempvar3[1]-'0']);

		advance();
		char *tempvar2=expression();
		// printf("    %s < %s\n",tempvar,tempvar2);
		fprintf(interFile, "%s <-  %s < %s\n",tempvar3,tempvar,tempvar2);
		int compLabel = getCompareLabel();
		fprintf(assFile, "CMP %c %c\n",REG[tempvar[1]-'0'],REG[tempvar2[1]-'0']);
		fprintf(assFile, "MVI %c 1\nJC COMPARE%d\nMVI %c 0\nCOMPARE%d:\n", REG[tempvar3[1]-'0'], compLabel, REG[tempvar3[1]-'0'], compLabel);

		freename(tempvar);
		freename(tempvar2);
		return tempvar3;
		//freename(tempvar1);
	}
	else if(match(EQUAL))
	{
		freename(tempvar);
		tempvar3=newname();
		tempvar=newname();
		fprintf(interFile, "%s <- %s\n", tempvar, tempvar3);
		fprintf(assFile, "MOV %c %c\n", REG[tempvar[1]-'0'], REG[tempvar3[1]-'0']);

		advance();
		char *tempvar2=expression();
		// printf("    %s == %s\n",tempvar,tempvar2);
		fprintf(interFile, "%s <-  %s == %s\n",tempvar3,tempvar,tempvar2);
		int compLabel = getCompareLabel();
		fprintf(assFile, "CMP %c %c\n",REG[tempvar[1]-'0'],REG[tempvar2[1]-'0']);
		fprintf(assFile, "MVI %c 1\nJZ COMPARE%d\nMVI %c 0\nCOMPARE%d:\n", REG[tempvar3[1]-'0'], compLabel, REG[tempvar3[1]-'0'], compLabel);


		freename(tempvar);
		freename(tempvar2);
		return tempvar3;
		//freename(tempvar1);
	}
	return tempvar;
}

char    *expression()
{
	/* expression -> term expression'
	 * expression' -> PLUS term expression' |  epsilon
	 */

	char  *tempvar, *tempvar2;

	tempvar = term();
	while( match( PLUS ) || match(MINUS) )
	{
		int r=(match(PLUS))?1:0;
		advance();
		tempvar2 = term();
		if(r){
			// printf("    %s += %s\n", tempvar, tempvar2 );
			fprintf(interFile, "%s += %s\n",tempvar,tempvar2);				// Intermediate Code
			if(strcmp(tempvar, "t0") == 0){
				fprintf(assFile, "ADD %c\n",REG[tempvar2[1]-'0']);
			} else {
				fprintf(assFile, "PUSH A\nMOV A %c\nADD %c\nMOV %c, A\nPOP A\n",REG[tempvar[1]-'0'], REG[tempvar2[1]-'0'],REG[tempvar[1]-'0']);				// Assembly Code
			}
		}
		else{
			// printf("    %s -= %s\n", tempvar, tempvar2 );
			fprintf(interFile, "%s -= %s\n",tempvar,tempvar2);
			if(strcmp(tempvar, "t0") == 0){
				fprintf(assFile, "SUB %c\n",REG[tempvar2[1]-'0']);
			} else {
				fprintf(assFile, "PUSH A\nMOV A %c\nSUB %c\nMOV %c, A\nPOP A\n",REG[tempvar[1]-'0'], REG[tempvar2[1]-'0'],REG[tempvar[1]-'0']);				// Assembly Code
			}
		}
		freename( tempvar2 );
	}

	return tempvar;
}

char    *term()
{
	char  *tempvar, *tempvar2 ;

	tempvar = factor();
	while( match( TIMES ) || match(DIV))
	{
		int r=(match(TIMES))?1:0;
		advance();
		tempvar2 = factor();
		if(r){
			// printf("    %s *= %s\n", tempvar, tempvar2 );
			fprintf(interFile, "%s *= %s\n",tempvar,tempvar2);
			if(strcmp(tempvar, "t0") == 0){
				fprintf(assFile, "MUL %c\n",REG[tempvar2[1]-'0']);
			} else {
				fprintf(assFile, "PUSH A\nMOV A %c\nMUL %c\nMOV %c, A\nPOP A\n",REG[tempvar[1]-'0'], REG[tempvar2[1]-'0'],REG[tempvar[1]-'0']);				// Assembly Code
			}
		}
		else {
			// printf("    %s /= %s\n", tempvar, tempvar2 );
			fprintf(interFile, "%s /= %s\n",tempvar,tempvar2);
			if(strcmp(tempvar, "t0") == 0){
				fprintf(assFile, "DIV %c\n",REG[tempvar2[1]-'0']);
			} else {
				fprintf(assFile, "PUSH A\nMOV A %c\nDIV %c\nMOV %c, A\nPOP A\n",REG[tempvar[1]-'0'], REG[tempvar2[1]-'0'],REG[tempvar[1]-'0']);				// Assembly Code
			}
		}
		freename( tempvar2 );
	}

	return tempvar;
}

char    *factor()
{
	char *tempvar;

	if( match(NUM_OR_ID) )
	{
	/* Print the assignment instruction. The %0.*s conversion is a form of
	 * %X.Ys, where X is the field width and Y is the maximum number of
	 * characters that will be printed (even if the string is longer). I'm
	 * using the %0.*s to print the string because it's not \0 terminated.
	 * The field has a default width of 0, but it will grow the size needed
	 * to print the string. The ".*" tells printf() to take the maximum-
	 * number-of-characters count from the next argument (yyleng).
	 */

		// printf("    %s = %0.*s\n", tempvar = newname(), yyleng, yytext );
		fprintf(interFile, "%s = %0.*s\n", tempvar = newname(), yyleng, yytext );
		int condition_check_digit=1;
		int loop_var=0;
		for(;loop_var<yyleng;loop_var++)
		{
			if(!isdigit(*(yytext+loop_var)))
			{
				condition_check_digit=0;
				break;
			}
		}
		if(condition_check_digit){
			fprintf(assFile, "MVI %c %0.*s\n",REG[tempvar[1]-'0'], yyleng,  yytext);
		} else {
			// printf("%s\n", yytext);
			if(strcmp(tempvar, "t0") == 0){
				fprintf(assFile, "LDA _%0.*s\n",yyleng,  yytext);
			} else {
				fprintf(assFile, "PUSH A\nLDA _%0.*s\nMOV %c A\nPOP A\n",yyleng,  yytext,REG[tempvar[1]-'0']);
			}
		}

		advance();
	}
	else if( match(LP) )
	{
		advance();
		tempvar = expression();
		if( match(RP) )
			advance();
		else
			fprintf(stderr, "%d: Mismatched parenthesis\n", yylineno );
	}
	else
	fprintf( stderr, "%d: Number or identifier expected\n", yylineno );

	return tempvar;
}

#include <stdarg.h>

#define MAXFIRST 16
#define SYNCH    SEMI

int legal_lookahead( int first_arg , ...)
{
	/* Simple error detection and recovery. Arguments are a 0-terminated list of
	 * those tokens that can legitimately come next in the input. If the list is
	 * empty, the end of file must come next. Print an error message if
	 * necessary. Error recovery is performed by discarding all input symbols
	 * until one that's in the input list is found
	 *
	 * Return true if there's no error or if we recovered from the error,
	 * false if we can't recover.
	 */

	va_list     args;
	int     tok;
	int     lookaheads[MAXFIRST], *p = lookaheads, *current;
	int     error_printed = 0;
	int     rval          = 0;

	va_start( args, first_arg );

	if( !first_arg )
	{
		if( match(EOI) )
			rval = 1;
	}
	else
	{
		*p++ = first_arg;
		while( (tok = va_arg(args, int)) && p < &lookaheads[MAXFIRST] )
			*p++ = tok;

		while( !match( SYNCH ) )
		{
			for( current = lookaheads; current < p ; ++current )
			if( match( *current ) )
			{
				rval = 1;
				goto exit;
			}

			if( !error_printed )
			{
			fprintf( stderr, "Line %d: Syntax error\n", yylineno );
			error_printed = 1;
			}

			advance();
	   }
	}

exit:
	va_end( args );
	return rval;
}
