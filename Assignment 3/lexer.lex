%option noyywrap
%{
	#include <stdio.h>
	#include "parser.tab.h"
%}

%s HASH

WHITE_SPACE					[ \n\t]
SEMI						";"
LB_SQUARE					"["
RB_SQUARE					"]"
LB_CURLY					"{"
RB_CURLY					"}"
LB_ROUND					"("
RB_ROUND					")"
AMP							"&"
COMMA						","
PLUS						"+"
MINUS						"-"
TIMES						"*"
DIV							"/"
EQUAL						"="
DOT 						"."
FOR							"for"
WHILE						"while"
IF							"if"
ELSE						"else"
INT							"int"
FLT 						"float"
CHR							"char"
STR							"string"
BOOL_DT						"bool"
VOID						"void"
MAIN 						"int main"|"void main"
PROCESSOR					"Processor"
LINK						"Link"
MEMORY						"Memory"
JOB							"Job"
CLUSTER						"Cluster"
SCHEDULER					"Scheduler"
ISA 						"isa"
CLOCK_SPEED 			    "clock_speed"
L1_MEMORY					"l1_memory"
L2_MEMORY					"l2_memory"
NAME 						"name"
START_POINT					"start_point"
END_POINT					"end_point"
BANDWIDTH					"bandwidth"
LINK_BANDWIDTH				"link_bandwidth"
LINK_CAPACITY				"link_capacity"
CHANNEL_CAPACITY			"channel_capacity"
MEMORY_TYPE					"memory_type"
MEMORY_SIZE					"mem_size"
JOB_ID						"job_id"
FLOPS_REQUIRED 				"flops_required"
DEADLINE 					"deadline"
MEM_REQUIRED 				"mem_required"
AFFINITY 					"affinity"
PROCESSORS 					"processors"
TOPOLOGY					"topology"
SCHEDULER_TYPE 				"scheduler_type"
PREEMPT_TIME 				"preempt_time"
IS_RUNNING 					{ID}".is_running"
SUBMIT_JOBS					{ID}".submit_jobs"
GET_CLOCK_SPEED 			{ID}".get_clock_speed"
RUN 						"run"
DISCARD_JOBS 				{ID}".discard_job"
GET_MEMORY 					{ID}".get_memory"
GET_AVAILABLE_MEMORY		{ID}".get_available_memory"
ALLOCATE_PROCESSOR			{ID}".allocate_processor"
SCHEDULE_JOBS				{ID}".schedule_jobs"
SET_AFFINITY				{ID}".set_affinity"

BOOL						("true"|"false"|"TRUE"|"FALSE")
LIBRARY						("#include"[ \t]*["<].*[">])
LOGICAL_OPERATORS			("&&"|"||"|"!")
RELATIONAL_OPERATORS		("=="|"<"|">"|"<="|">="|"!=")
CHAR						\'([^\']|\\.)?\'
STRING 				 		\"([^\"]|\\.)*\"
DIGITS 						([0-9]+)
FLOAT						([0-9]*\.?[0-9]+|[0-9]+)
ID 							[a-zA-Z]([_a-zA-Z0-9])*
NUM_OR_ID					({DIGITS}|{FLOAT}|{STRING}|{CHAR}|{BOOL}|{ID})

%%


{SEMI}							{return SEMI;}
{LB_SQUARE}						{return  LB_SQUARE;}
{RB_SQUARE}						{return RB_SQUARE;}
{LB_CURLY}						{return LB_CURLY;}
{RB_CURLY}						{return RB_CURLY;}
{LB_ROUND}						{return LB_ROUND;}
{RB_ROUND}						{return RB_ROUND;}
{AMP}							{return AMP;}
{PLUS}							{return PLUS;}
{MINUS}							{return MINUS;}
{TIMES}							{return TIMES;}
{DIV}							{return DIV;}
{COMMA}							{return COMMA;}
{EQUAL}							{return EQUAL;}
{DOT}							{return DOT;}
{FOR}							{return FOR;}
{WHILE}							{return WHILE;}
{IF}							{return IF;}
{ELSE}							{return ELSE;}
{INT}							{return INT;}
{FLT}							{return FLT;}
{CHR}							{return CHR;}
{STR}							{return STR;}
{BOOL_DT}						{return BOOL_DT;}
{VOID}							{return VOID;}
{MAIN}							{return MAIN;}
{PROCESSOR}						{return PROCESSOR;}
{LINK}							{return LINK;}
{MEMORY}						{return MEMORY;}
{JOB}							{return JOB;}
{CLUSTER}						{return CLUSTER;}
{SCHEDULER}						{return SCHEDULER;}
{ISA}							{return ISA;}
{CLOCK_SPEED}					{return CLOCK_SPEED;}
{L1_MEMORY}						{return L1_MEMORY;}
{L2_MEMORY}						{return L2_MEMORY;}
{NAME}							{return NAME;}
{START_POINT}					{return START_POINT;}
{END_POINT}						{return END_POINT;}
{BANDWIDTH}						{return BANDWIDTH;}
{LINK_BANDWIDTH}				{return LINK_BANDWIDTH;}
{LINK_CAPACITY}					{return LINK_CAPACITY;}
{CHANNEL_CAPACITY}				{return CHANNEL_CAPACITY;}
{MEMORY_TYPE}					{return MEMORY_TYPE;}
{MEMORY_SIZE}					{return MEMORY_SIZE;}
{JOB_ID}						{return JOB_ID;}
{FLOPS_REQUIRED}				{return FLOPS_REQUIRED;}
{DEADLINE}						{return DEADLINE;}
{MEM_REQUIRED}					{return MEM_REQUIRED;}
{AFFINITY}						{return AFFINITY;}
{PROCESSORS}					{return PROCESSORS;}
{TOPOLOGY}						{return TOPOLOGY;}
{SCHEDULER_TYPE}				{return SCHEDULER_TYPE;}
{PREEMPT_TIME}					{return PREEMPT_TIME;}
{IS_RUNNING}					{return IS_RUNNING;}
{SUBMIT_JOBS}					{return SUBMIT_JOBS;}
{GET_CLOCK_SPEED}				{return GET_CLOCK_SPEED;}
{RUN}							{return RUN;}
{DISCARD_JOBS}					{return DISCARD_JOBS;}
{GET_MEMORY}					{return GET_MEMORY;}
{GET_AVAILABLE_MEMORY}			{return GET_AVAILABLE_MEMORY;}
{ALLOCATE_PROCESSOR}			{return ALLOCATE_PROCESSOR;}
{SCHEDULE_JOBS}					{return SCHEDULE_JOBS;}
{SET_AFFINITY}					{return SET_AFFINITY;}
{BOOL}							{return BOOL;}
{LIBRARY}						{return LIBRARY;}
{LOGICAL_OPERATORS}				{return LOGICAL_OPERATORS ;}
{RELATIONAL_OPERATORS}			{return RELATIONAL_OPERATORS ;}
{CHAR}							{return CHAR ;}

{STRING}						{return STRING ;}
{ID}							{return ID ;}
{NUM_OR_ID}						{return NUM_OR_ID ;}
{WHITE_SPACE}					{ECHO;}
.								{return ERROR;}

%%
