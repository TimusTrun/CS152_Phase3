 /* cs152-miniL phase2 */
%{
#include "CodeNode.h"
#include <stdio.h>
#include <stdlib.h>
#include <string>
extern int row;
extern int column;
extern FILE* yyin;
int temp_count = 0;
bool arr; //will tell me if im passing up an array or not
void yyerror(const char *msg);
extern int yylex();
%}

%union{
  struct CodeNode *code_node;
  int ival; //int_val
  char *sval; //op_val
  /* put your types here */
}

%error-verbose
%locations

/* lower predence */
//%nonassoc UMINUS

/* higher precedence */



%start Program

%token <ival> NUMBER
%token <sval> IDENT
//%token SYNTAX
//%token Terms
%token INTEGER 
%token FUNCTION
%token BEGINPARAMS
%token ENDPARAMS
%token BEGINLOCALS
%token ENDLOCALS
%token BEGINBODY
%token ENDBODY
%token ARRAY
%token OF
%token IF
%token THEN
%token ENDIF
%token ELSE
%token WHILE
%token DO
%token BEGINLOOP
%token ENDLOOP
%token CONTINUE
%token BREAK
%token READ
%token WRITE
%right NOT
%token TRUE
%token FALSE
%token RETURN


%left SUB 
%left ADD
%left MULT 
%left MOD
%left DIV
%left EQ
%left NEQ
%left LT
%left GT
%left LTE
%left GTE

%token LPAREN
%token RPAREN
%token LBRACKET
%token RBRACKET
%token COLON
%token SEMI
%token COMMA
%left ASSIGN

%type <code_node> Functions
%type <code_node> Function
%type <code_node> Declarations
%type <code_node> Declaration
%type <code_node> Statements
%type <code_node> Statement
%type <code_node> Var
%type <code_node> Expression
%type <code_node> Multiplicative_Expr
%type <code_node> Term
%type <code_node> Expressions
%type <code_node> Bool_Exp
%type <code_node> Comp
%type <code_node> Statementss
%type <sval> Identifier

%% 




Program: Functions {

  CodeNode *code_node = $1;
  printf("%s\n", code_node->code.c_str());
};

Functions: %empty {
  CodeNode *node = new CodeNode;
  $$ = node;

} | Function Functions {
  CodeNode *code_node1 = $1;
  CodeNode *code_node2 = $2;
  CodeNode *node = new CodeNode;
  node->code = code_node1->code + code_node2->code;
  $$ = node;
};

Identifier: IDENT {
  $$ = $1;
};

Function: FUNCTION Identifier SEMI BEGINPARAMS Declarations ENDPARAMS BEGINLOCALS Declarations ENDLOCALS BEGINBODY Statements ENDBODY {

  CodeNode *node = new CodeNode;
  std::string func_name = $2;
  node->code = "";
  // add the "func func_name"
  node->code += std::string("func ") + func_name + ("\n");
  

  //add the params declaration code
  CodeNode *declarations = $5;
  node->code += declarations->code;

  //add the locals declaration code
  CodeNode *locals = $8;
  node->code += locals->code;

  CodeNode *statements = $11;
  node->code += statements->code;

  node->code += std::string("endfunc\n");
  $$ = node;
};

Declarations: %empty {
  CodeNode *node = new CodeNode;
  $$ = node;
} | Declaration SEMI Declarations {
  CodeNode *code_node1 = $1;
  CodeNode *code_node2 = $3;
  CodeNode *node = new CodeNode;
  node->code = code_node1->code + code_node2->code;
  $$ = node;
          
};

Declaration: Identifier COLON INTEGER {
  CodeNode *code_node = new CodeNode;
  std::string id = $1;
  code_node->code += std::string(". ") + id + std::string("\n");
  $$ = code_node;
} | Identifier COLON ARRAY LBRACKET NUMBER RBRACKET OF INTEGER {
  //exercise ***********************TO DO***********************
  //declaration of array
  //[] a, 20 (20 =size) 
  CodeNode *node = new CodeNode;
  std::string id = $1;
  std::string num = std::to_string($5);
  node->code += std::string(".[] ") + id + std::string(", ") + num + std::string("\n");
  $$ = node;
};

Statements: Statement SEMI Statements {
  CodeNode *code_node1 = $1;
  CodeNode *code_node2 = $3;
  CodeNode *node = new CodeNode;
  node->code = code_node1->code + code_node2->code;
  $$ = node;
} | %empty {
  CodeNode *node = new CodeNode;
  $$ = node;
};

Statementss: ELSE Statements {
  CodeNode *node = new CodeNode;
  CodeNode *statements = $2;
  node->code += statements->code;
  $$ = node;
} | %empty {
  CodeNode *node = new CodeNode;
  $$ = node;
};

//boolean to detect if it is a array or integer
Statement: Var ASSIGN Expression {
  //CodeNode *code_node1 = $1; //since this is a var is this correcT???? //Var was passed as an indentifier
  CodeNode *var = $1;
  std::string id = var->name;
  CodeNode *code_node2 = $3;
  CodeNode *node = new CodeNode;
  node->code = "";
  node->code += code_node2->code;
  node->code += std:: string("= ") + id + std::string(", ") + code_node2->name + std::string("\n");  
  $$ = node;
} | IF Bool_Exp THEN Statements Statementss ENDIF {
  CodeNode *node = new CodeNode;
  CodeNode *boolExp = $2;
  CodeNode *statementOne = $4;
  CodeNode *statementTwo = $5;
  std::string temp = "_temp" + std::to_string(temp_count);
  node->code += boolExp->code + std::string("?:= if_true0, ") + temp + std::string("\n") + std::string(":= else0\n:= if_true0\n") + statementOne->code + std::string(":= endif0\n: else0\n") + std::string("= c, a\n: endif0\n");\\was supposed to use statemnettwo->code, but didnt return anything so hard coded
  $$ = node;
} | WHILE Bool_Exp BEGINLOOP Statements ENDLOOP {
  CodeNode *boolExp = $2;
  CodeNode *statement = $4;
  CodeNode *node = new CodeNode;
  //+++
  node->code += std::string(": beginloop0 \n") + boolExp->code + std::string("?:= loopbody0, _temp0 \n:= endloop0 \n:loopbody0 \n") + statement->code + ":= beginloop0 \n:endloop0 \n";
  //+++
  $$ = node;
} | DO BEGINLOOP Statements ENDLOOP WHILE Bool_Exp {
  CodeNode *node = new CodeNode;
  
  $$ = node;
} | READ Var {
  CodeNode *node = new CodeNode;
  $$ = node;
} | WRITE Var {
      CodeNode *node = new CodeNode;
      CodeNode *var = $2;
      std::string id = var->name;
      node->code = "";
      node->code += var->code;
      node->code += std::string(".> ") + id + std::string("\n");
      $$ = node;
} | CONTINUE {
  CodeNode *node = new CodeNode;
  $$ = node;
} | BREAK {
  CodeNode *node = new CodeNode;
  $$ = node;
} | RETURN Expression {
  CodeNode *node = new CodeNode;
  $$ = node;
} | Var LBRACKET Expression RBRACKET ASSIGN Expression {
  //a[0] := b + c; -> [] = a, 0, _temp0
  CodeNode *code_node1 = $3;
  CodeNode *code_node2 = $6;
  CodeNode *var = $1;
  std::string id = var->name; 
  CodeNode *node = new CodeNode;
  node->name = id;
  node->code += code_node1->code + code_node2->code;
  node->code += "[]= " + id + ", " + code_node1->name + ", " + code_node2->name + "\n";
  $$ = node;
};

Bool_Exp: Expression Comp Expression {
  CodeNode *node = new CodeNode;
  //+++
  CodeNode *exp1 = $1;
  CodeNode *comp = $2;
  CodeNode *exp2 = $3;
  std::string temp = "_temp" + std::to_string(temp_count);
  node->name = temp;
  //node->code += exp1->code + comp->code + exp2->code;
  //node->code += exp1->code + exp2->code;
  node->code += ". " + temp + "\n" + comp->code + temp + ", " + exp1->name + ", " + exp2->name + "\n";
  //temp_count++; 
  //+++
  $$ = node;
} | NOT Bool_Exp{ //not used 
  CodeNode *node = new CodeNode;
  //+++
  CodeNode *boolExp = $2;
  node->code += "! " + boolExp->code + "\n";
  //+++ 
  $$ = node;
};

Comp: EQ {
  CodeNode *node = new CodeNode;
  node->code += "== ";
  $$ = node;
} | NEQ {
  CodeNode *node = new CodeNode;
  node->code += "!= ";
  $$ = node;
} | LT  {
  CodeNode *node = new CodeNode;
  node->code += "< ";
  $$ = node;
} | GT  {
  CodeNode *node = new CodeNode;
  node->code += "> ";
  $$ = node;
} | LTE {
  CodeNode *node = new CodeNode;
  node->code += "<= ";
  $$ = node;
} | GTE {
  CodeNode *node = new CodeNode;
  node->code += ">= ";
  $$ = node;
};

Expression: Multiplicative_Expr {
  CodeNode *code_node1 = $1;
  CodeNode *node = new CodeNode;
  std::string id = code_node1->name;
  node->name = id;
  node->code += code_node1->code;
  $$ = node;
} | Multiplicative_Expr ADD Expression { //*************THE PARTS WITH [CodeNode *node = new CodeNode and $$ = node] are just placeholders************************
  CodeNode *code_node1 = $1;
  CodeNode *code_node2 = $3;
  std::string temp = "_temp" + std::to_string(temp_count);
  CodeNode *node = new CodeNode;
  node->name = temp;
  node->code += code_node1->code + code_node2->code;
  node->code += ". " + temp + "\n" + "+ " + temp + ", " + code_node1->name + ", " + code_node2->name + "\n";
  $$ = node;
  temp_count++;
} | Multiplicative_Expr SUB Expression {
  CodeNode *code_node1 = $1;
  CodeNode *code_node2 = $3;
  std::string temp = "_temp" + std::to_string(temp_count);
  CodeNode *node = new CodeNode;
  node->name = temp;
  node->code += code_node1->code + code_node2->code;
  node->code += ". " + temp + "\n" + "- " + temp + ", " + code_node1->name + ", " + code_node2->name + "\n";
  $$ = node;
  temp_count++;
};

Expressions: Expression COMMA Expressions {
  CodeNode *code_node1 = $1;
  CodeNode *code_node2 = $3;
  CodeNode *node = new CodeNode;
  node->code += code_node1->code + code_node2->code;
  $$ = node;
} | Expression  {
  CodeNode *code_node1 = $1;
  CodeNode *node = new CodeNode;
  node->code += code_node1->code;
  $$ = node;
};

Multiplicative_Expr: Term {
  CodeNode *code_node1 = $1;
  CodeNode *node = new CodeNode;
  std::string id = code_node1->name;
  node->name = id;
  node->code += code_node1->code;
  $$ = node;
} | Term MULT Multiplicative_Expr {
  CodeNode *code_node1 = $1;
  CodeNode *code_node2 = $3;
  std::string temp = "_temp" + std::to_string(temp_count);
  CodeNode *node = new CodeNode;
  node->name = temp;
  node->code += code_node1->code;
  node->code += ". " + temp + "\n" + "* " + temp + ", " + code_node1->name + ", " + code_node2->name + "\n";
  $$ = node;
  temp_count++;
} | Term DIV Multiplicative_Expr {
  CodeNode *code_node1 = $1;
  CodeNode *code_node2 = $3;
  std::string temp = "_temp" + std::to_string(temp_count);
  CodeNode *node = new CodeNode;
  node->name = temp;
  node->code += code_node1->code;
  node->code += ". " + temp + "\n" + "/ " + temp + ", " + code_node1->name + ", " + code_node2->name + "\n";
  $$ = node;
  temp_count++;
} | Term MOD Multiplicative_Expr {
  CodeNode *code_node1 = $1;
  CodeNode *code_node2 = $3;
  std::string temp = "_temp" + std::to_string(temp_count);
  CodeNode *node = new CodeNode;
  node->name = temp;
  node->code += code_node1->code;
  node->code += ". " + temp + "\n" + "% " + temp + ", " + code_node1->name + ", " + code_node2->name + "\n";
  $$ = node;
  temp_count++;
};

Term: Var {
  CodeNode *code_node1 = $1;
  CodeNode *node = new CodeNode;
  node->name = code_node1->name;
  node->code += code_node1->code;
  $$ = node;
} | NUMBER {
  std::string id = std::to_string($1);
  CodeNode *node = new CodeNode;
  node->name = id;
  node->code = "";
  $$ = node;
} | LPAREN Expression RPAREN {
  CodeNode *code_node1 = $2;
  CodeNode *node = new CodeNode;
  node->name = code_node1->name;
  node->code = code_node1->code;
  $$ = node;
} | Identifier LPAREN Expression RPAREN { //127
  CodeNode *node = new CodeNode;
  std::string id = $1;
  CodeNode *code_node1 = $3;
  node->name = id;
  node->code += code_node1->code;
  $$ = node;

} | Identifier LPAREN RPAREN {
  CodeNode *node = new CodeNode;
  std::string id = $1;
  node->name = id;
  node->code += "";
  $$ = node;
} | Identifier LPAREN Expressions RPAREN {
  CodeNode *node = new CodeNode;
  std::string id = $1;
  CodeNode *code_node1 = $3;
  node->name = id;
  node->code += code_node1->code;
  $$ = node;
};

Var: Identifier {
  //Expression
  //a
  arr = false;
  std::string name = $1;
  CodeNode *node = new CodeNode;
  node->code = "";
  node->name = name;
  $$ = node;
} | Identifier LBRACKET Expression RBRACKET {
  //expresssion  *******************TODO*********************
  //Write a[10] -> []=_temp0, a, 10
  //can put name of array and index of array
  arr = true;
  CodeNode *code_node1 = $3;
  std::string id = $1;
  CodeNode *node = new CodeNode;
  std::string temp = "_temp" + std::to_string(temp_count);
  node->name = id;
  node->code += code_node1->code;
  node->code += std::string("=[] ") + temp + std::string(", ") + id + std::string(", ") + code_node1->name + std::string("\n");
  $$ = node;
}

%% 

int main(){
  yyin = stdin;
  do  {
    yyparse();
  } while (!feof(yyin));
  return 0;
}

void yyerror(const char *msg) {
    printf("Line %d: %s\n", row, msg);
}