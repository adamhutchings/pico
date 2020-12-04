/**
 * All possible token types. Used by both the tokenizer and the parser.
 *
 * Author: Adam Hutchings (adam.abahot@gmail.com)
 */
 
 #ifndef PICO_PARSE_TOKEN_TYPES_H
 #define PICO_PARSE_TOKEN_TYPES_H
 
 enum {
 
  IDENTIFIER,
  LITERAL,
  SEMICOLON,
  COLON,
  DOT,
  COMMA,
  OPENPAREN,
  CLOSEPAREN,
  OPENBRACKET,
  CLOSEBRACKET,
  OPENBRACE,
  CLOSEBRACE,
  ASSIGN_OP,
  NORMAL_OP,
  CREMENT_OP,
  UNARY_OP,
  TYPENAME,
  CLASS,
  ACCESS_MOD,
  JUMP_STATEMENT,
  IF,
  ELIF,
  ELSE,
  WHILE,
  LOOP,
  USE,
  RANGE,
  FROM
 
 };
 
 #endif /* PICO_PARSE_TOKEN_TYPES_H */
 
