%{
#include <stdio.h>

void yyerror(char *s){
	fprintf (stderr, "%s\n", s);
}

%}

%union{ char Char;}

%token <Char> WHITE_SPACE SEMI LB_SQUARE RB_SQUARE LB_CURLY RB_CURLY LB_ROUND RB_ROUND AMP COMMA PLUS MINUS TIMES DIV EQUAL FOR WHILE IF ELSE INT FLT CHR STR BOOL_DT PROCESSOR LINK MEMORY JOB CLUSTER SCHEDULER BOOL LIBRARY LOGICAL_OPERATORS RELATIONAL_OPERATORS CHAR STRING DIGITS FLOAT ID NUM_OR_ID ERROR MAIN VOID ISA CLOCK_SPEED L1_MEMORY L2_MEMORY NAME START_POINT END_POINT BANDWIDTH LINK_BANDWIDTH LINK_CAPACITY CHANNEL_CAPACITY MEMORY_TYPE MEMORY_SIZE JOB_ID FLOPS_REQUIRED DEADLINE MEM_REQUIRED AFFINITY PROCESSORS TOPOLOGY SCHEDULER_TYPE PREEMPT_TIME IS_RUNNING SUBMIT_JOBS GET_CLOCK_SPEED RUN DISCARD_JOBS GET_MEMORY GET_AVAILABLE_MEMORY ALLOCATE_PROCESSOR SCHEDULE_JOBS SET_AFFINITY DOT

%start PROG

%%

PROG: 				LIBRARIES FUNCTIONS MAIN LB_ROUND ARGS_LIST_DECLR RB_ROUND LB_CURLY STATEMENTS RB_CURLY		{printf ("PROG -> LIBRARIES FUNCTIONS int main(ARGS_LIST_DECLR){STATEMEMTS}\n");}
					;

LIBRARIES: 			LIBRARY LIBRARIES			{printf ("LIBRARIES -> LIBRARY LIBRARIES\n");}
					| /* empty */				{printf ("LIBRARIES -> epsilon \n");}
					;

DATA_TYPE: 			INT 		 				{printf ("DATA_TYPE -> int\n");}
					| VOID 						{printf ("DATA_TYPE -> void\n");}
					| CHR  						{printf ("DATA_TYPE -> char\n");}
					| BOOL_DT  					{printf ("DATA_TYPE -> bool\n");}
					| STR  						{printf ("DATA_TYPE -> string\n");}
					| FLT  						{printf ("DATA_TYPE -> float\n");}
					| INT TIMES  				{printf ("DATA_TYPE -> int*\n");}
					| CHR TIMES  				{printf ("DATA_TYPE -> char*\n");}
					| FLT TIMES  				{printf ("DATA_TYPE -> float*\n");}
					| STR TIMES 				{printf ("DATA_TYPE -> string*\n");}
					;

FUNCTIONS: 			FUNCTION_DECLR FUNCTIONS	{printf("FUNCTIONS -> FUNCTION_DECLR FUNCTIONS\n");}
					| /* empty */				{printf("FUNCTIONS -> epsilon\n");}
					;

FUNCTION_DECLR:		DATA_TYPE ID LB_ROUND ARGS_LIST_DECLR RB_ROUND LB_CURLY STATEMENTS RB_CURLY		{printf("FUNCTION_DECLR -> DATA_TYPE ID ( ARGS_LIST_DECLR ) { STATEMENTS }\n");}
					;

ARGS_LIST_DECLR:	DATA_TYPE ID COMMA ARGS_LIST_DECLR 			{printf("ARGS_LIST_DECLR -> DATA_TYPE ID, ARGS_LIST_DECLR\n");}
					| DATA_TYPE ID ARGS_LIST_DECLR 				{printf("ARGS_LIST_DECLR -> DATA_TYPE ID\n");}
					| /* empty */								{printf("ARGS_LIST_DECLR -> epsilon\n");}
					;

STATEMENTS:			STATEMENT STATEMENTS    			{printf("STATEMENTS -> STATEMENT STATEMENTS\n");}
					| /* empty */       				{printf("STATEMENTS -> epsilon\n");}
					;

STATEMENT: 			IFSTATEMENT 						{printf("STATEMENT -> IFSTATEMENT\n");}
					| LOOP 								{printf("STATEMENT -> LOOP\n");}
					| DECLARATION SEMI					{printf("STATEMENT -> DECLARATION;\n");}
					| ASSIGNMENT_NESTED SEMI 			{printf("STATEMENT -> ASSIGNMENT_NESTED; \n");}
					| EXPRESSION SEMI					{printf("STATEMENT -> EXPRESSION; \n");}
					;

IFSTATEMENT: 		IF LB_ROUND EXPRESSION RB_ROUND LB_CURLY STATEMENTS RB_CURLY 											{printf("IFSTATEMENT -> if(EXPRESSION) {STATEMENTS}\n");}
					| IF LB_ROUND EXPRESSION RB_ROUND LB_CURLY STATEMENTS RB_CURLY ELSE LB_CURLY STATEMENTS RB_CURLY		{printf("IFSTATEMENT -> if(EXPRESSION) {STATEMENTS} else {STATEMENTS}\n");}
					| IF LB_ROUND EXPRESSION RB_ROUND LB_CURLY STATEMENTS RB_CURLY ELSE IFSTATEMENT 						{printf("IFSTATEMENT -> if(EXPRESSION) {STATEMENTS} else IFSTATEMENT\n");}
					;

LOOP:				WHILELOOP 					{printf("LOOP -> WHILELOOP\n");}
					| FORLOOP					{printf("LOOP -> FORLOOP\n");}
					;

WHILELOOP:			WHILE LB_ROUND WHILELOOP_ARG RB_ROUND LB_CURLY STATEMENTS RB_CURLY		{printf("WHILELOOP -> while (WHILELOOP_ARG) {STATEMENTS}\n");}
					;

WHILELOOP_ARG:		DECLARATION 					{printf("WHILELOOP_ARG -> DECLARATION\n");}
					| EXPRESSION 					{printf("WHILELOOP_ARG -> EXPRESSION\n");}
					| ASSIGNMENT_NESTED 			{printf("WHILELOOP_ARG -> ASSIGNMENT_NESTED\n");}
					;

FORLOOP:		 	FOR LB_ROUND FORLOOP_ARG SEMI FORLOOP_ARG SEMI FORLOOP_ARG RB_ROUND LB_CURLY STATEMENTS RB_CURLY		{printf("FORLOOP -> for (FORLOOP_ARG; FORLOOP_ARG; FORLOOP_ARG) {STATEMENTS}\n");}
					;

FORLOOP_ARG:		DECLARATION 					{printf("FORLOOP_ARG -> DECLARATION\n");}
					| EXPRESSION 					{printf("FORLOOP_ARG -> EXPRESSION\n");}
					| ASSIGNMENT_NESTED 			{printf("FORLOOP_ARG -> ASSIGNMENT_NESTED\n");}
					;

DECLARATION:		DECLR_1 					{printf("DECLARATION -> DECLR_1\n");}
					| DECLR_2 					{printf("DECLARATION -> DECLR_2\n");}
					| DECLR_3  					{printf("DECLARATION -> DECLR_3\n");}
					| DECLR_4  					{printf("DECLARATION -> DECLR_4\n");}
					| DECLR_5 					{printf("DECLARATION -> DECLR_5\n");}
					| /* empty */  				{printf("DECLARATION -> epsilon");}
					;

DECLR_1: 			INT ID EQUAL EXPRESSION   					{printf("DECLR_1 -> int ID = EXPRESSION\n");}
					| BOOL_DT ID EQUAL EXPRESSION   			{printf("DECLR_1 -> bool ID = EXPRESSION\n");}
					| FLT ID EQUAL EXPRESSION   				{printf("DECLR_1 -> float ID = EXPRESSION\n");}
					| INT ID   									{printf("DECLR_1 -> int ID\n");}
					| BOOL_DT ID 								{printf("DECLR_1 -> bool ID\n");}
					| FLT ID   									{printf("DECLR_1 -> float ID\n");}
					| INT ID EQUAL ASSIGNMENT_NESTED   			{printf("DECLR_1 -> int ID = ASSIGNMENT_NESTED\n");}
					| BOOL_DT ID EQUAL ASSIGNMENT_NESTED   		{printf("DECLR_1 -> bool ID = ASSIGNMENT_NESTED\n");}
					| FLT ID EQUAL ASSIGNMENT_NESTED   			{printf("DECLR_1 -> float ID = ASSIGNMENT_NESTED\n");}
					;

DECLR_2: 			STR ID EQUAL STRING							{printf("DECLR_2 -> string ID = STRING\n");}
					| STR ID 									{printf("DECLR_2 -> string ID\n");}
					| STR ID EQUAL ASSIGNMENT_NESTED 			{printf("DECLR_2 -> string ID = ASSIGNMENT_NESTED\n");}
					;

DECLR_3:			CHR ID EQUAL CHAR 							{printf("DECLR_3 -> char ID = CHAR\n");}
					| CHR ID 									{printf("DECLR_3 -> char ID\n");}
					| CHR ID EQUAL ASSIGNMENT_NESTED 			{printf("DECLR_3 -> char ID = ASSIGNMENT_NESTED\n");}
					;

DECLR_4:			INT TIMES ID 							{printf("DECLR_4 -> int* ID\n");}
					| FLT TIMES ID 							{printf("DECLR_4 -> float* ID\n");}
					| CHR TIMES ID 							{printf("DECLR_4 -> char* ID\n");}
					| STR TIMES ID 							{printf("DECLR_4 -> string* ID\n");}
					;

DECLR_5:			INT ID LB_SQUARE NUM_OR_ID RB_SQUARE 					{printf("DECLR_5 -> int ID[NUM_OR_ID]\n");}
					| FLT ID LB_SQUARE NUM_OR_ID RB_SQUARE 					{printf("DECLR_5 -> float ID[NUM_OR_ID]\n");}
					| CHR ID LB_SQUARE NUM_OR_ID RB_SQUARE 					{printf("DECLR_5 -> char ID[NUM_OR_ID]\n");}
					| JOB ID LB_SQUARE NUM_OR_ID RB_SQUARE 					{printf("DECLR_5 -> job ID[NUM_OR_ID]\n");}
					| PROCESSOR ID LB_SQUARE NUM_OR_ID RB_SQUARE 			{printf("DECLR_5 -> processor ID[NUM_OR_ID]\n");}
					| CLUSTER ID LB_SQUARE NUM_OR_ID RB_SQUARE 				{printf("DECLR_5 -> cluster ID[NUM_OR_ID]\n");}
					| INT ID LB_SQUARE ID RB_SQUARE 						{printf("DECLR_5 -> int ID[ID]\n");}
					| FLT ID LB_SQUARE ID RB_SQUARE 						{printf("DECLR_5 -> float ID[ID]\n");}
					| CHR ID LB_SQUARE ID RB_SQUARE 						{printf("DECLR_5 -> char ID[ID]\n");}
					| JOB ID LB_SQUARE ID RB_SQUARE 						{printf("DECLR_5 -> job ID[ID]\n");}
					| PROCESSOR ID LB_SQUARE ID RB_SQUARE 					{printf("DECLR_5 -> processor ID[ID]\n");}
					| CLUSTER ID LB_SQUARE ID RB_SQUARE 					{printf("DECLR_5 -> cluster ID[ID]\n");}
					;

ASSIGNMENT_NESTED:  ID EQUAL ASSIGNMENT_NESTED				{printf("ASSIGNMENT_NESTED -> ID = ASSIGNMENT_NESTED\n");}
					| ASSIGNMENT 							{printf("ASSIGNMENT_NESTED -> ASSIGNMENT\n");}
					| ASSIGNMENT_ARRAY						{printf("ASSIGNMENT_NESTED -> ASSIGNMENT_ARRAY\n");}
					| ASSIGNMENT_POINTER					{printf("ASSIGNMENT_NESTED -> ASSIGNMENT_POINTER\n");}
					;

ASSIGNMENT:			ID EQUAL EXPRESSION 					{printf("ASSIGNMENT -> ID = EXPRESSION\n");}
					;

ASSIGNMENT_ARRAY:	ID LB_SQUARE NUM_OR_ID RB_SQUARE EQUAL EXPRESSION 			{printf("ASSIGNMENT_ARRAY -> ID[NUM_OR_ID] = EXPRESSION\n");}
					| ID LB_SQUARE ID RB_SQUARE EQUAL EXPRESSION 				{printf("ASSIGNMENT_ARRAY -> ID[ID] = EXPRESSION\n");}
					;

ASSIGNMENT_POINTER: ID EQUAL AMP ID 						{printf("ASSIGNMENT_POINTER -> ID = &ID\n");}
					| TIMES ID EQUAL NUM_OR_ID 				{printf("ASSIGNMENT_POINTER -> *ID = NUM_OR_ID\n");}
					| TIMES ID EQUAL TIMES ID 				{printf("ASSIGNMENT_POINTER -> *ID = *ID\n");}
					;

CONDITION:			TERM RELATIONAL_OPERATORS TERM			{printf("CONDITION -> TERM RELATIONAL_OPERATORS TERM\n");}
					;

EXPRESSION:		    TERM EXPRESSION1 						{printf("EXPRESSION -> TERM EXPRESSION1\n");}
					| CONDITION 							{printf("EXPRESSION -> CONDITION\n");}
					;

EXPRESSION1:        PLUS TERM EXPRESSION1    				{printf("EXPRESSION1 -> + TERM EXPRESSION1\n");}
					| MINUS TERM EXPRESSION1 				{printf("EXPRESSION1 -> - TERM EXPRESSION1\n");}
					| /*empty*/ 							{printf("EXPRESSION1 -> epsilon\n");}
					;

TERM:				FACTOR TERM1 							{printf("TERM -> FACTOR TERM1\n");}
					;

TERM1:			    TIMES FACTOR TERM1 	 					{printf("TERM1 -> * FACTOR TERM1\n");}
					| DIV FACTOR TERM1 	 					{printf("TERM1 -> / FACTOR TERM1\n");}
					| /*empty*/ 							{printf("TERM1 -> epsilon\n");}
					;

FACTOR:  			NUM_OR_ID 								{printf("FACTOR -> NUM_OR_ID\n");}
					| ID 									{printf("FACTOR -> ID\n");}
					| LB_ROUND TIMES ID RB_ROUND 			{printf("FACTOR -> (* ID)\n");}
					| LB_ROUND EXPRESSION RB_ROUND 			{printf("FACTOR ->  (EXPRESSION)\n");}
					| CONSTRUCTORS	 						{printf("FACTOR -> CONSTRUCTORS\n");}
					| MEMBER_FUNCTIONS	 					{printf("FACTOR -> MEMBER_FUNCTIONS\n");}
					;

ARRAY:				LB_SQUARE ARRAY_LIST RB_SQUARE 			{printf("ARRAY -> [ARRAY_LIST]\n");}
					;

ARRAY_LIST:			EXPRESSION COMMA ARRAY_LIST 			{printf("ARRAY_LIST -> EXPRESSION , ARRAY_LIST\n");}
					| EXPRESSION ARRAY_LIST 				{printf("ARRAY_LIST -> EXPRESSION ARRAY_LIST\n");}
					| /*empty*/ 							{printf("ARRAY_LIST -> epsilon\n");}
					;

CONSTRUCTORS:		PROCESSOR_CNSTR  				{printf("CONTRUCTORS -> PROCESSOR_CNSTR\n");}
					| LINK_CNSTR  					{printf("CONTRUCTORS -> LINK_CNSTR\n");}
					| MEMORY_CNSTR  				{printf("CONTRUCTORS -> MEMORY_CNSTR\n");}
					| JOB_CNSTR  					{printf("CONTRUCTORS -> JOB_CNSTR\n");}
					| CLUSTER_CNSTR  				{printf("CONTRUCTORS -> CLUSTER_CNSTR\n");}
					| SCHEDULER_CNSTR 				{printf("CONTRUCTORS -> SCHEDULER_CNSTR\n");}
					;

PROCESSOR_CNSTR: 	PROCESSOR LB_ROUND PROCESSOR_ARGS RB_ROUND				{printf("PROCESSOR_CNSTR -> Processor(PROCESSOR_ARGS)\n");}
					;

LINK_CNSTR: 		LINK LB_ROUND LINK_ARGS RB_ROUND						{printf("LINK_CNSTR -> Link(LINK_ARGS)\n");}
					;

MEMORY_CNSTR: 		MEMORY LB_ROUND MEMORY_ARGS RB_ROUND					{printf("MEMORY_CNSTR -> Memory(MEMORY_ARGS)\n");}
					;

JOB_CNSTR: 			JOB LB_ROUND JOB_ARGS RB_ROUND							{printf("JOB_CNSTR -> Job(JOB_ARGS)\n");}
					;

CLUSTER_CNSTR: 		CLUSTER LB_ROUND CLUSTER_ARGS RB_ROUND					{printf("CLUSTER_CNSTR -> Cluster(CLUSTER_ARGS)\n");}
					;

SCHEDULER_CNSTR: 	SCHEDULER LB_ROUND SCHEDULER_ARGS RB_ROUND				{printf("SCHEDULER_CNSTR -> Scheduler(SCHEDULER_ARGS)\n");}
					;

PROCESSOR_ARGS:		 PROCESSOR_ARG PROCESSOR_ARGS 							{printf("PROCESSOR_ARGS -> PROCESSOR_ARG PROCESSOR_ARGS\n");}
					| PROCESSOR_ARG COMMA PROCESSOR_ARGS 					{printf("PROCESSOR_ARGS -> PROCESSOR_ARG , PROCESSOR_ARGS\n");}
					|  /* empty */ 											{printf("PROCESSOR_ARGS -> epsilon\n");}
					;

PROCESSOR_ARG:		 EXPRESSION 										{printf("PROCESSOR_ARG -> EXPRESSION\n");}
					| STRING 		 									{printf("PROCESSOR_ARG -> STRING\n");}
					| ISA EQUAL STRING 									{printf("PROCESSOR_ARG -> isa = STRING\n");}
					| ISA EQUAL ID 										{printf("PROCESSOR_ARG -> isa = ID\n");}
					| CLOCK_SPEED EQUAL EXPRESSION 						{printf("PROCESSOR_ARG -> clock_speed = EXPRESSION\n");}
					| L1_MEMORY EQUAL MEMORY_CNSTR 						{printf("PROCESSOR_ARG -> l1_memory = MEMORY_CNSTR\n");}
					| L1_MEMORY EQUAL ID 								{printf("PROCESSOR_ARG -> l1_memory = ID\n");}
					| L2_MEMORY EQUAL MEMORY_CNSTR 						{printf("PROCESSOR_ARG -> l2_memory = MEMORY_CNSTR\n");}
					| L2_MEMORY EQUAL ID 								{printf("PROCESSOR_ARG -> l2_memory = ID\n");}
					| NAME EQUAL STRING 								{printf("PROCESSOR_ARG -> name = STRING\n");}
					| NAME EQUAL ID 									{printf("PROCESSOR_ARG -> name = ID\n");}
					;

LINK_ARGS:		 	LINK_ARG LINK_ARGS 									{printf("LINK_ARGS -> LINK_ARG LINK_ARGS\n");}
					| LINK_ARG COMMA LINK_ARGS 							{printf("LINK_ARGS -> LINK_ARG, LINK_ARGS\n");}
					|  /* empty */ 										{printf("LINK_ARGS -> epsilon\n");}
					;

LINK_ARG:		 	EXPRESSION 											{printf("LINK_ARG -> EXPRESSION\n");}
					| STRING 											{printf("LINK_ARG -> STRING\n");}
					| START_POINT EQUAL STRING 							{printf("LINK_ARG -> start_point = STRING\n");}
					| START_POINT EQUAL ID 								{printf("LINK_ARG -> start_point = ID\n");}
					| END_POINT EQUAL STRING 							{printf("LINK_ARG -> end_point = STRING\n");}
					| END_POINT EQUAL ID 								{printf("LINK_ARG -> end_point = ID\n");}
					| BANDWIDTH EQUAL EXPRESSION 						{printf("LINK_ARG -> bandwidth = EXPRESSION\n");}
					| CHANNEL_CAPACITY EQUAL EXPRESSION 				{printf("LINK_ARG -> CHANNEL_CAPACITY = EXPRESSION\n");}
					| NAME EQUAL STRING 								{printf("LINK_ARG -> name = STRING\n");}
					| NAME EQUAL ID 									{printf("LINK_ARG -> name = ID\n");}
					;


MEMORY_ARGS:		 MEMORY_ARG MEMORY_ARGS 							{printf("MEMORY_ARGS -> MEMORY_ARG MEMORY_ARGS\n");}
					| MEMORY_ARG COMMA MEMORY_ARGS 						{printf("MEMORY_ARGS -> MEMORY_ARG, MEMORY_ARGS\n");}
					|  /* empty */ 										{printf("MEMORY_ARGS -> epsilon\n");}
					;

MEMORY_ARG:		 	EXPRESSION 											{printf("MEMORY_ARG -> EXPRESSION\n");}
					| STRING 											{printf("MEMORY_ARG -> STRING\n");}
					| MEMORY_TYPE EQUAL STRING 							{printf("MEMORY_ARG -> memory_type = STRING\n");}
 					| MEMORY_TYPE EQUAL ID 								{printf("MEMORY_ARG -> memory_type = ID\n");}
  					| MEMORY_SIZE EQUAL EXPRESSION 						{printf("MEMORY_ARG -> memory_type = EXPRESSION\n");}
  					| NAME EQUAL STRING 								{printf("MEMORY_ARG -> name = STRING\n");}
  					| NAME EQUAL ID 									{printf("MEMORY_ARG -> name = ID\n");}
  					;

JOB_ARGS:		 	JOB_ARG JOB_ARGS 									{printf("JOB_ARGS -> JOB_ARG JOB_ARGS\n");}
					| JOB_ARG COMMA JOB_ARGS 							{printf("JOB_ARGS -> JOB_ARG, JOB_ARGS\n");}
					|  /* empty */ 										{printf("JOB_ARGS -> epsilon\n");}
					;

JOB_ARG:		 	EXPRESSION 											{printf("JOB_ARG -> EXPRESSION\n");}
					| ARRAY 											{printf("JOB_ARG -> ARRAY\n");}
					| JOB_ID EQUAL EXPRESSION 							{printf("JOB_ARG -> job_id = EXPRESSION\n");}
					| FLOPS_REQUIRED EQUAL EXPRESSION 					{printf("JOB_ARG -> flops_required = EXPRESSION\n");}
  		    		| DEADLINE EQUAL EXPRESSION 						{printf("JOB_ARG -> deadline = EXPRESSION\n");}
  		    		| MEM_REQUIRED EQUAL EXPRESSION 					{printf("JOB_ARG -> mem_required = EXPRESSION\n");}
  		    		| AFFINITY EQUAL ID 								{printf("JOB_ARG -> affinity = ID\n");}
					| AFFINITY EQUAL ARRAY 								{printf("JOB_ARG -> affinity = ARRAY\n");}
					;

CLUSTER_ARGS:		 CLUSTER_ARG CLUSTER_ARGS 							{printf("CLUSTER_ARGS -> CLUSTER_ARG CLUSTER_ARGS\n");}
					| CLUSTER_ARG COMMA CLUSTER_ARGS 					{printf("CLUSTER_ARGS -> CLUSTER_ARG, CLUSTER_ARGS\n");}
					|  /* empty */ 										{printf("CLUSTER_ARGS -> epsilon\n");}
					;

CLUSTER_ARG:		 EXPRESSION 										{printf("CLUSTER_ARG -> EXPRESSION\n");}
					| ARRAY 											{printf("CLUSTER_ARG -> ARRAY\n");}
					| STRING 											{printf("CLUSTER_ARG -> STRING\n");}
					| PROCESSORS EQUAL ARRAY 							{printf("CLUSTER_ARG -> processors = ARRAY\n");}
					| PROCESSORS EQUAL ID 								{printf("CLUSTER_ARG -> processors = ID\n");}
					| TOPOLOGY EQUAL STRING 							{printf("CLUSTER_ARG -> topology = STRING\n");}
					| LINK_BANDWIDTH EQUAL EXPRESSION 					{printf("CLUSTER_ARG -> link_bandwidth = EXPRESSION\n");}
					| LINK_CAPACITY EQUAL EXPRESSION 					{printf("CLUSTER_ARG -> link_capacity = EXPRESSION\n");}
					| NAME EQUAL STRING 								{printf("CLUSTER_ARG -> name = STRING\n");}
					| NAME EQUAL ID 									{printf("CLUSTER_ARG -> name = ID\n");}
					;


SCHEDULER_ARGS:		SCHEDULER_ARG SCHEDULER_ARGS 						{printf("SCHEDULER_ARGS -> SCHEDULER_ARG SCHEDULER_ARGS\n");}
					| SCHEDULER_ARG COMMA SCHEDULER_ARGS 				{printf("SCHEDULER_ARGS -> SCHEDULER_ARG, SCHEDULER_ARGS\n");}
					|  /* empty */ 										{printf("SCHEDULER_ARGS -> epsilon\n");}
					;

SCHEDULER_ARG:		EXPRESSION 											{printf("SCHEDULER_ARG -> EXPRESSION\n");}
					| STRING 					 						{printf("SCHEDULER_ARG -> STRING\n");}
					| SCHEDULER_TYPE EQUAL STRING 						{printf("SCHEDULER_ARG -> scheduler_type = STRING\n");}
					| SCHEDULER_TYPE EQUAL ID 							{printf("SCHEDULER_ARG -> scheduler_type = ID\n");}
					| PREEMPT_TIME EQUAL EXPRESSION 					{printf("SCHEDULER_ARG -> preempt_time = EXPRESSION\n");}
					;

MEMBER_FUNCTIONS: 	IS_RUNNING LB_ROUND RB_ROUND 						{printf("MEMBER_FUNCTIONS -> ID.is_running()\n");}
					| SUBMIT_JOBS LB_ROUND ID RB_ROUND 					{printf("MEMBER_FUNCTIONS -> ID.submit_jobs(ID)\n");}
					| SUBMIT_JOBS LB_ROUND ARRAY RB_ROUND 				{printf("MEMBER_FUNCTIONS -> ID.submit_jobs(ARRAY)\n");}
					| GET_CLOCK_SPEED LB_ROUND RB_ROUND 				{printf("MEMBER_FUNCTIONS -> ID.get_clock_speed()\n");}
					| RUN LB_ROUND ID RB_ROUND 							{printf("MEMBER_FUNCTIONS -> run(ID)\n");}
					| RUN LB_ROUND ARRAY RB_ROUND 						{printf("MEMBER_FUNCTIONS -> run(ARRAY)\n");}
					| DISCARD_JOBS LB_ROUND ID RB_ROUND 				{printf("MEMBER_FUNCTIONS -> ID.discard_jobs(ID)\n");}
					| GET_MEMORY LB_ROUND RB_ROUND 						{printf("MEMBER_FUNCTIONS -> ID.get_memory()\n");}
					| GET_AVAILABLE_MEMORY LB_ROUND RB_ROUND 			{printf("MEMBER_FUNCTIONS -> ID.get_available_memory()\n");}
					| ALLOCATE_PROCESSOR LB_ROUND ID RB_ROUND 			{printf("MEMBER_FUNCTIONS -> ID.allocate_processor(ID)\n");}
					| ALLOCATE_PROCESSOR LB_ROUND ARRAY RB_ROUND 		{printf("MEMBER_FUNCTIONS -> ID.allocate_processor(ARRAY)\n");}
					| SCHEDULE_JOBS LB_ROUND STRING COMMA STRING COMMA JOB_PRECEDENCE_RATE_ARGS RB_ROUND 		{printf("MEMBER_FUNCTIONS -> ID.schedule_jobs(STRING, STRING, JOB_PRECEDENCE_RATE_ARGS)\n");}
					| SET_AFFINITY LB_ROUND ID COMMA ID COMMA EXPRESSION RB_ROUND 								{printf("MEMBER_FUNCTIONS -> ID.set_affinity(ID,ID,EXPRESSION)\n");}
					;

JOB_PRECEDENCE_RATE_ARGS: 	JOB_PRECEDENCE_RATE_ARG JOB_PRECEDENCE_RATE_ARGS 							{printf("JOB_PRECEDENCE_RATE_ARGS -> JOB_PRECEDENCE_RATE_ARG JOB_PRECEDENCE_RATE_ARGS\n");}
							| JOB_PRECEDENCE_RATE_ARG COMMA JOB_PRECEDENCE_RATE_ARGS 					{printf("JOB_PRECEDENCE_RATE_ARGS -> JOB_PRECEDENCE_RATE_ARG, JOB_PRECEDENCE_RATE_ARGS\n");}
							| /* empty */ 																{printf("JOB_PRECEDENCE_RATE_ARGS -> epsilon\n");}
							;

JOB_PRECEDENCE_RATE_ARG: 	EXPRESSION 									{printf("JOB_PRECEDENCE_RATE_ARG -> EXPRESSION\n");}
							;

%%

int main(){
	yyparse();
	return 0;
}
