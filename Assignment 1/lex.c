#include "lex.h"
#include <stdio.h>
#include <ctype.h>
int previous=-1;

char* yytext = ""; /* Lexeme (not '\0'
                      terminated)              */
int yyleng   = 0;  /* Lexeme length.           */
int yylineno = 0;  /* Input line number        */

//FILE * fp_lex = fopen("temp.txt","w");

int lex(void){

   static char input_buffer[1024];
   char        *current;

   current = yytext + yyleng; /* Skip current
                                 lexeme        */

   while(1){       /* Get the next one         */
      while(!*current ){
         /* Get new lines, skipping any leading
         * white space on the line,
         * until a nonblank line is found.
         */

         current = input_buffer;
         if(!gets(input_buffer)){
            *current = '\0' ;

            return EOI;
         }
         ++yylineno;
         while(isspace(*current))
            ++current;
      }
      for(; *current; ++current){
         /* Get the next token */
         yytext = current;
         yyleng = 1;
         switch( *current ){
           case ';':
            return SEMI;
           case '+':
            return PLUS;
           case '-':
            return MINUS;
           case '*':
            return TIMES;
           case '/':
            return DIV;
           case '(':
            return LP;
           case ')':
            return RP;
           case '<':
            return LT;
           case '>':
            return GT;
            case ':':
            return COL;
           case '=':
            return EQUAL;
           case '\n':
           case '\t':
           case ' ' :
            break;
           default:
            if(!isalnum(*current))
               fprintf(stderr, "Not alphanumeric <%c>\n", *current);
            else{
               while(isalnum(*current))
                  ++current;
               yyleng = current - yytext;
               char subbuff[yyleng+1];
               memcpy( subbuff, yytext, yyleng );
               subbuff[yyleng] = '\0';
               if(strcmp(subbuff, "if") == 0)
               {
                  return IF;
               }
               else if(strcmp(subbuff, "then") == 0)
               {
                  return THEN;
               }
               else if(strcmp(subbuff, "while") == 0)
               {
                  return WHILE;
               }
               else if(strcmp(subbuff, "do") == 0)
               {
                  return DO;
               }
               else if(strcmp(subbuff, "begin") == 0)
               {
                  return BEGIN;
               }
               else if(strcmp(subbuff, "end") == 0)
               {
                  return END;
               }
               return NUM_OR_ID;
            }
            break;
         }
      }
   }
}


static int Lookahead = -1; /* Lookahead token  */

int match(int token){
   /* Return true if "token" matches the
      current lookahead symbol.                */

   if(Lookahead == -1)
      Lookahead = lex();

     if(token == ID && Lookahead == NUM_OR_ID)
    {
       int i;
       char *current = yytext;
       int r=1;

       //printf("%s\n %c\n",current,*(current+yyleng) );
       /*
       for(i=0;i<yyleng;i++)
       {
           if(isdigit(*current))
                {r=0;break;}
            current++;
       }*/
       //if((r==1)&&(*(current)==':'))return 1;
       for(i=0;i<yyleng;i++)current++;
        while(isspace(*current))current++;
       if((*current)==':'){
        if(previous!=token){fprintf(stderr,"ID\n");previous=token;}
        return 1;
      }
       return 0;

    }


   if( token == Lookahead)
   {
      if(previous!=token)
       {
       previous=token;
      switch(token)
      {
      case(0):fprintf(stderr,"END OF INPUT\n");break;
      case(1):fprintf(stderr,"SEMI\n");break;
      case(2):fprintf(stderr,"PLUS\n");break;
      case(3):fprintf(stderr,"TIMES\n");break;
      case(4):fprintf(stderr,"LP\n");break;
      case(5):fprintf(stderr,"RP\n");break;
      case(6):fprintf(stderr,"NUM_OR_ID\n");break;
      case(7):fprintf(stderr,"MINUS\n");break;
      case(8):fprintf(stderr,"DIV\n");break;
      case(9):fprintf(stderr,"LT\n");break;
      case(10):fprintf(stderr,"GT\n");break;
      case(11):fprintf(stderr,"EQUAL\n");break;
      case(12):fprintf(stderr,"IF\n");break;
      case(13):fprintf(stderr,"THEN\n");break;
      case(14):fprintf(stderr,"WHILE\n");break;
      case(15):fprintf(stderr,"DO\n");break;
      case(16):fprintf(stderr,"BEGIN\n");break;
      case(17):fprintf(stderr,"END\n");break;
      case(18):fprintf(stderr,"ID\n");break;
      case(19):fprintf(stderr,"COL\n");break;

      }
    }
      return 1;
   }
   else return 0;
}

void advance(void){
/* Advance the lookahead to the next
   input symbol.                               */

    Lookahead = lex();
}
