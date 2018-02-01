#include "code_gen.h"
#include "name.h"
#include "lex.h"
#include <stdio.h>
#include <error.h>

extern char *newname( void       );
extern void freename( char *name );

statement()
{
    /*  statements -> expression1 SEMI  |  expression1 SEMI statements  */

    char *tempvar = NULL;

   

        if(match(ID))
        {
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
                   goto legal_lookahead_SEMI;
                if(match(THEN))
                {
                    advance();
                   // freename(tempvar);
                    statement();
                }
                else
                    fprintf( stderr, "%d: Inserting missing then\n", yylineno );
            }   
        else if(match(WHILE))
            {   
                advance();
                tempvar = expression1();
                if( !legal_lookahead( DO, 0 ) )
                    goto legal_lookahead_SEMI;
                if(match(DO))
                {

                    advance();

                   // freename(tempvar);
                    statement();
                }
                else
                    fprintf( stderr, "%d: Inserting missing do\n", yylineno );
                
            }
        else if(match(BEGIN))
        {
                advance();
                
                while(!match(END) && !match(EOI))
                {
                    statement();
                    
                }
                
                if(match(END))
                    advance();
                else
                    fprintf( stderr, "%d: Inserting missing end\n", yylineno );
        }
        else tempvar = expression1();

         freename( tempvar);

legal_lookahead_SEMI:
        if( match( SEMI ) )
            {advance();
            
                   
                }
        else
            fprintf( stderr, "%d: Inserting missing semicolon\n", yylineno );
        
    
}

statements()
{
    /*  statements -> expression1 SEMI  |  expression1 SEMI statements  */

    char *tempvar;

    while( !match(EOI) )
    {   

        if(match(ID))
        {
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
                   goto legal_lookahead_SEMI;
                if(match(THEN))
                {
                    advance();
                    freename(tempvar);
                    statements();
                }
                else
                    fprintf( stderr, "%d: Inserting missing then\n", yylineno );
            }   
        else if(match(WHILE))
            {   
                advance();
                tempvar = expression1();
                if( !legal_lookahead( DO, 0 ) )
                    goto legal_lookahead_SEMI;
                if(match(DO))
                {

                    advance();

                    freename(tempvar);
                    statements();
                }
                else
                    fprintf( stderr, "%d: Inserting missing do\n", yylineno );
                
            }
        else if(match(BEGIN))
        {
                advance();
                
                while(!match(END) && !match(EOI) )
                {
                    statement();
                }
                if(match(END)){
                    advance();
                }
                else{
                    fprintf( stderr, "%d: Inserting missing end\n", yylineno );
                }
                goto legal_lookahead_SEMI;

                
        }
        else tempvar = expression1();

        freename( tempvar );
        
legal_lookahead_SEMI:
        if( match( SEMI ) )
            advance();
        else
            fprintf( stderr, "%d: Inserting missing semicolon\n", yylineno );



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
