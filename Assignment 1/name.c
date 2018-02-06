#include "name.h"
#include "lex.h"
#include <stdio.h>
#include <stdlib.h>

char  *Names[] = { "t0", "t1", "t2", "t3", "t4", "t5", "t6", "t7" };
char  **Namep  = Names;

int expressionLabelCounter = 0;
int ifthenLabelCounter = 0;
int loopLabelCounter = 0;

char  *newname()
{
    if( Namep >= &Names[ sizeof(Names)/sizeof(*Names) ] )
    {
        fprintf( stderr, "%d: Expression too complex\n", yylineno );
        exit( 1 );
    }

    return( *Namep++ );
}

freename(s)
char    *s;
{
    if( Namep > Names )
    *--Namep = s;
    else
    fprintf(stderr, "%s  %d: (Internal error) Name stack underflow\n",
                               s, yylineno );
}

int getCompareLabel(){
    return expressionLabelCounter++;
}

int getIfThenLabel(){
    return ifthenLabelCounter++;
}

int getLoopLabel(){
    return loopLabelCounter++;
}
