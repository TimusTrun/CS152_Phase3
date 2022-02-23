 /* cs152-miniL phase2 */
%{
#include "CodeNode.h"
#include <stdio.h>
#include <stdlib.h>
#include <string>
extern int row;
extern int column;
int temp_count = 0;
void yyerror(const char *msg);
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
%type <sval> Identifier

%% 




Program: Functions {

  CodeNode *code_node = $1;
  printf("%s\n", code_node->code.c_str();
};

Functions: %empty {
  CodeNode *node = new CodeNode;
  $$ = node;

} | Function Functions {
  CodeNode *code_node1 = $1;
  CodeNode *code_node 2= $2;
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
  node->code += std::string("func ") + func_name;
  

  //add the params declaration code
  CodeNode *declarations = $5;
  node->code += Declarations->code;

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
  nade->code = code_node1->code + code_node2->code;
  $$ = node;
          
};

Declaration: Identifier COLON INTEGER {
  CodeNode *code_node = new CodeNode;
  std::string id = $1;
  code_node->code += std::string(". ") + id + std::string("\n");
  $$ = code_node;
} | Identifier COLON ARRAY LBRACKET NUMBER RBRACKET OF INTEGER {
  //exercise **TO DO**
  CodeNode *node = new CodeNode;
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

Statementss: ELSE Statements {printf("Statementss -> ELSE Statements\n");};
        | %empty {printf("Statementss -> epsilon\n");};

Statement: Var ASSIGN Expression {
  //CodeNode *code_node1 = $1; //since this is a var is this correcT????
  CodeNode *var = $1;
  std::string id = var->name;
  CodeNode *code_node2 = $3;
  CodeNode *node = new CodeNode;
  node->code = "";
  node->code += code_node2->code;
  node->code += std:: string("= ") + id + std::string(", ") + code_node2->name + std::string("\n"); //code_node1->code or code_node1->code.c_str() (???) 
  $$ = node;
} | IF Bool_Exp THEN Statements Statementss ENDIF {
  CodeNode *node = new CodeNode;
  $$ = node;
} | WHILE Bool_Exp BEGINLOOP Statements ENDLOOP {
  CodeNode *node = new CodeNode;
  $$ = node;
} | DO BEGINLOOP Statements ENDLOOP WHILE Bool_Exp {
  CodeNode *node = new CodeNode;
  $$ = node;
} | READ Var {
  CodeNode *node = new CodeNode;
  $$ = node;
} | WRITE Var {
  CodeNode *node = new CodeNode;
  CodeNode *var = $2
  std::string id = var->name
  node->code = "";
  node->code += std::string(".>") + id + std::string("\n");
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
};


Bool_Exp: Expression Comp Expression {printf("Bool_Exp -> Bool_Exps Expression Comp Expression\n");};
        | NOT Bool_Exp{printf("BoolExp -> NOT BoolExp\n");};

Comp: EQ { printf("Comp -> '=='\n");};
    | NEQ { printf("Comp -> '<>'\n");};
    | LT  { printf("Comp -> '<'\n");};
    | GT  { printf("Comp -> '>'\n");};
    | LTE { printf("Comp -> '<='\n");};
    | GTE { printf("Comp -> '>='\n");};

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
  std::string temp = "_temp" + temp_count;
  CodeNode *node = new CodeNode;
  node->name = temp;
  node->code += ". " + temp + "\n" + "+ " + temp + ", " + code_node1->name + ", " + code_node2->name + "\n";
  $$ = node;
  temp_count++;
} | Multiplicative_Expr SUB Expression {
  CodeNode *code_node1 = $1;
  CodeNode *code_node2 = $3;
  std::string temp = "_temp" + temp_count;
  CodeNode *node = new CodeNode;
  node->name = temp;
  node->code += ". " + temp + "\n" + "- " + temp + ", " + code_node1->name + ", " + code_node2->name + "\n";
  $$ = node;
  temp_count++;
};

Expressions: Expression COMMA Expressions {printf("Expressions -> Expression ',' Expressions\n");};
                     | Expression  {printf("Expressions -> Expression\n");};

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
  std::string temp = "_temp" + temp_count;
  CodeNode *node = new CodeNode;
  node->name = temp;
  node->code += ". " + temp + "\n" + "* " + temp + ", " + code_node->name + ", " + code_node2->name + "\n";
  $$ = node;
  temp_count++;
} | Term DIV Multiplicative_Expr {
  CodeNode *code_node1 = $1;
  CodeNode *code_node2 = $3;
  std::string temp = "_temp" + temp_count;
  CodeNode *node = new CodeNode;
  node->name = temp;
  node->code += ". " + temp + "\n" + "/ " + temp + ", " + code_node->name + ", " + code_node2->name + "\n";
  $$ = node;
  temp_count++;
} | Term MOD Multiplicative_Expr {
  CodeNode *code_node1 = $1;
  CodeNode *code_node2 = $3;
  std::string temp = "_temp" + temp_count;
  CodeNode *node = new CodeNode;
  node->name = temp;
  node->code += ". " + temp + "\n" + "% " + temp + ", " + code_node->name + ", " + code_node2->name + "\n";
  $$ = node;
  temp_count++;
};

// Term: Var {
//   CodeNode *code_node1 = $1;
//   std::string id = code_node1->name;
//   CodeNode *node = new CodeNode;
//   node->name = id;
//   node->code += code_node1->code;
//   $$ = node;
// } | NUMBER {
//   CodeNode *node = new CodeNode;
//   $$ = node;
// } | LPAREN Expression RPAREN {
//   CodeNode *node = new CodeNode;
//   $$ = node;
// } | Identifier LPAREN Expression RPAREN {
//   CodeNode *node = new CodeNode;
//   $$ = node;
// } | Identifier LPAREN Expression COMMA RPAREN {
//   CodeNode *node = new CodeNode;
//   $$ = node;
// } | Identifier LPAREN RPAREN {
//   CodeNode *node = new CodeNode;
//   $$ = node;
// };


Term: Var {

} | NUMBER {

} | LPAREN Expression RPAREN {

} | Identifier LPAREN Expression RPAREN {

} | Identifier LPAREN RPAREN {

} | Identifier LPAREN Expressions RPAREN {

};

Var: Identifier {
  //Expression
  //a
  std::string name = $1;
  CodeNode *node = new CodeNode;
  node->code = "";
  node->name = name;
  $$ = node;
} | Identifier LBRACKET Expression RBRACKET {
  //expresssion  *******************TODO*********************
  //a[10]
  CodeNode *node = new CodeNode;
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