/* Grammar for a base version of Planck : only variables in classes, no traits, etc. */

%{
  #include "token_types.h"
  void yyerror(char const*); /* Called on error */
  int yylex(void); /* TODO */
%}

/* TEMPORARY SOLUTION - FROM token_types.h */

%token IDENTIFIER
%token LITERAL
%token SEMICOLON
%token COLON
%token DOT
%token COMMA
%token OPENPAREN
%token CLOSEPAREN
%token OPENBRACKET
%token CLOSEBRACKET
%token OPENBRACE
%token CLOSEBRACE
%token ASSIGN_OP
%token NORMAL_OP
%token CREMENT_OP
%token UNARY_OP
%token TYPENAME
%token CLASS
%token ACCESS_MOD
%token JUMP_STATEMENT
%token IF
%token ELIF
%token ELSE
%token WHILE
%token LOOP
%token USE
%token RANGE
%token FROM

%start translation_unit

%%

/* Any value that cannot be "broken down" any further. */
value
  : IDENTIFIER
  | LITERAL
  ;
  
/* Any value that can appear on the left of an assignment, or a crement expression. */
lvalue
  : IDENTIFIER
  ;
  
/* With a leading "-" or "!" */
unary_expression
  : UNARY_OP value
  ;
  
/* An expression with ++ or -- (prefix or postfix) */
crement_expression
  : CREMENT_OP lvalue
  | lvalue CREMENT_OP
  ;
  
/* An expression with an operator at its core (not assignment) */
operator_expression
  : expression NORMAL_OP expression
  ;
  
/* For the non-type part of a declaration */
declarator_list
  : IDENTIFIER
  | IDENTIFIER COMMA declarator_list
  ;
  
/* Variable declarations, are not an expression. */
declaration
  : TYPENAME declarator_list SEMICOLON
  ;
  
/* For calling functions - specifically non-empty so foo(a,); isn't valid syntax. */
non_empty_call_list
  : expression
  | expression COMMA non_empty_call_list
  ;
  
/* A call list - either empty or a non_empty_call_list */
call_list
  :
  | non_empty_call_list
  ;
  
/* An expression representinng a function call */
function_call_expression
  : IDENTIFIER OPENPAREN call_list CLOSEPAREN
  ;
  
/* The jump keywords on their own are also valid statements. */
jump_statement
  : JUMP_STATEMENT SEMICOLON
  ;
  
assignment_expression
  : lvalue ASSIGN_OP expression
  ;
  
/* Any expression with a meaningful value */
expression
  : value
  | assignment_expression
  | unary_expression
  | crement_expression
  | operator_expression
  | function_call_expression
  | IDENTIFIER DOT IDENTIFIER /* Don't forget a class member */
  ;
  
/* Anything that constitutes a full "statement". */
statement
  : SEMICOLON /* Could be empty */
  | declaration
  | expression SEMICOLON
  | block_statement
  | if_statement
  | loop_statement
  | while_statement
  | jump_statement
  ;
  
/* The internals of a block statement, a list of statements */
block_statement_body
  :
  | statement block_statement_body
  ;
  
/* { statement1; statement2; } */
block_statement
  : OPENBRACE block_statement_body CLOSEBRACE
  ;
  
/* Useful for elif, if, and while. */
condition_and_block
  : OPENPAREN expression CLOSEPAREN statement
  ;
  
/* A trailing else from an if */
else_statement
  : ELSE block_statement
  ;
  
elif_statement
  : ELIF condition_and_block
  ;
  
/* The elif-else chain - any number of elifs, and then an else. Or maybe not. */
elif_else_chain
  : /* No else at the end */
  | else_statement /* An else at the end */
  | elif_statement /* An elif plus another chain */
  ;
  
/* An if statement alone, without elif/else. */
if_alone
  : IF condition_and_block
  ;
  
/* A full if statement, with trailing elif / else. */
if_statement
  : if_alone
  | if_alone elif_else_chain
  ;
  
/* A full while */
while_statement
  : WHILE condition_and_block
  ;
  
/* For ranges in a loop condition */
range_expression
  : expression RANGE expression
  ;
  
loop_condition
  : expression
  | range_expression
  ;
  
/* A loop - almost the same as a while but could have a counter variable */
loop_statement
  : LOOP OPENPAREN loop_condition CLOSEPAREN statement
  | LOOP OPENPAREN loop_condition CLOSEPAREN COLON TYPENAME IDENTIFIER statement
  ;
  
/* A variable template in the function argument list */
function_argument_template
  : IDENTIFIER COLON TYPENAME
  ;
  
/* The list of arguments (same story here as in function calls) */
non_empty_argument_list
  : function_argument_template
  | function_argument_template COMMA non_empty_argument_list
  ;
  
argument_list
  :
  | non_empty_argument_list
  ;
  
/* Can be used in declarations or definitions */
function_header
  : IDENTIFIER OPENPAREN argument_list CLOSEPAREN COLON TYPENAME
  ;
  
/* header and semicolon, for a complete statement */
function_declaration
  : function_header SEMICOLON
  ;
  
/* header with a body */
function_definition
  : function_header block_statement
  ;
 
 /* A variable declaration */
class_body_member
  : IDENTIFIER COLON TYPENAME SEMICOLON
  | IDENTIFIER COLON TYPENAME ACCESS_MOD SEMICOLON
  ;
  
class_body_body
  :
  | class_body_member class_body
  ;
  
class_body
  : OPENBRACE class_body_body CLOSEBRACE
  ;

/* Classes cannot be forward-declared at the moment. */
class_definition
  : CLASS IDENTIFIER COLON class_body
  ;
  
/* foo, foo.bar, foo.bar.baz, etc. */
use_statement_predicate
  : IDENTIFIER
  | IDENTIFIER DOT use_statement_predicate
  ;
  
/* use a, or use a from b */
use_statement
  : USE use_statement_predicate SEMICOLON
  | USE use_statement_predicate FROM use_statement_predicate SEMICOLON
  ;
  
/* Something on its own in the file (except for use statements which appear at the beginning always) */
top_level_declaration
  : function_definition
  | class_definition
  ;

/* Everything but use statements */
program_after_imports
  :
  | top_level_declaration program_after_imports
  ;
  
/* All the use statements */
import_list
  :
  | use_statement import_list
  ;
 
/* A complete program */
translation_unit
  : import_list
  | program_after_imports
  ;
