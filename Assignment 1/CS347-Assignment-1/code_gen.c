#include "code_gen.h"
#include "name.h"
#include "lex.h"
#include <stdio.h>
#include <error.h>

extern char *newname( void       );
extern void freename( char *name );

statements()
{
    /*  statements -> expression1 SEMI  |  expression1 SEMI statements  */

    char *tempvar;

    while( !match(EOI) )
    {
        tempvar = expression1();

        if( match( SEMI ) )
            advance();
        else
            fprintf( stderr, "%d: Inserting missing semicolon\n", yylineno );

        freename( tempvar );
    }
}

char *expression1()
{
    /*expression1 -> expression | expression<expression |expression=expression |expression>expression | */
    char * tempvar=expression();
    if(match(GT))
    {
        advance();
        char *tempvar2=expression();
        printf("    %s > %s\n",tempvar,tempvar2);
        freename(tempvar2);
        //freename(tempvar1);

    }
    else if(match(LT))
    {
        advance();
        char *tempvar2=expression();
        printf("    %s < %s\n",tempvar,tempvar2);
        freename(tempvar2);
        //freename(tempvar1);
    }
    else if(match(EQUAL))
    {
        advance();
        char *tempvar2=expression();
        printf("    %s == %s\n",tempvar,tempvar2);
        freename(tempvar2);
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
        if(r)printf("    %s += %s\n", tempvar, tempvar2 );
        else printf("    %s -= %s\n", tempvar, tempvar2 );
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
        if(r)printf("    %s *= %s\n", tempvar, tempvar2 );
        else printf("    %s /= %s\n", tempvar, tempvar2 );
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

        printf("    %s = %0.*s\n", tempvar = newname(), yyleng, yytext );
        // printf("rohan\n");
        advance();
        // printf("roopansh\n");
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
