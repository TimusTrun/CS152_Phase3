/* cs152-phase1*/

%{   
   int row= 1;
   int column = 1;
%}


   /* some common rules, for example DIGIT */
DIGIT       [0-9]
LETTER      [a-zA-Z]

IDENTIFIER  ({LETTER})({LETTER}|{DIGIT}|"_")*
START       ({DIGIT}|"_")+{IDENTIFIER}
END         {IDENTIFIER}+("_")
WHITESPACE  [\s\S\t\T ]
COMMENT     ##.*


%%
   /* specific lexer rules in regex */
{WHITESPACE}+  {} 
{COMMENT}      {} 
"\n"           {row++; column=1;}
"="            {column += yyleng; return '=';}
"function"     { column += yyleng;return FUNCTION;}
"beginparams"  {column += yyleng;return BEGINPARAMS;}
"endparams"    {column += yyleng;return ENDPARAMS;}
"beginlocals"  {column += yyleng;return BEGINLOCALS;}
"endlocals"    {column += yyleng;return ENDLOCALS;}
"beginbody"    {column += yyleng;return BEGINBODY;}
"endbody"      {column += yyleng;return ENDBODY;}
"integer"      {column += yyleng;return INTEGER;}
"array"        {column += yyleng;return ARRAY;}
"of"           {column += yyleng;return OF;}
"if"           {column += yyleng;return IF;}
"then"         {column += yyleng;return THEN;}
"endif"        {column += yyleng;return ENDIF;}
"else"         {column += yyleng;return ELSE;}
"while"        {column += yyleng;return WHILE;}
"do"           {column += yyleng;return DO;}
"beginloop"    {column += yyleng;return BEGINLOOP;}
"endloop"      {column += yyleng;return ENDLOOP;}
"continue"     {column += yyleng;return CONTINUE;}
"break"        {column += yyleng;return BREAK;}
"read"         {column += yyleng;return READ;}
"write"        {column += yyleng;return WRITE;}
"not"          {column += yyleng;return NOT;}
"true"         {column += yyleng;return TRUE;}
"false"        {column += yyleng;return FALSE;}
"return"       {column += yyleng;return RETURN;}
"-"            {column += yyleng;return SUB;}
"+"            {column += yyleng;return ADD;}
"*"            {column += yyleng;return MULT;}
"/"            {column += yyleng;return DIV;}
"%"            {column += yyleng;return MOD;}
"=="           {column += yyleng;return EQ;}
"<>"           {column += yyleng;return NEQ;}
"<"            {column += yyleng;return LT;}
">"            {column += yyleng;return GT;}
"<="           {column += yyleng;return LTE;}
">="           {column += yyleng;return GTE;}
{DIGIT}+       {column += yyleng;yylval.ival = atoi(yytext); return NUMBER;}
{START}+       {printf("Error at line %i, column %i: identifier \"%s\" must begin with a letter", row, column, yytext); } //fix?
{END}+         {printf("Error at line %i, column %i: identifier \"%s\" cannot end with an underscore", row, column, yytext); } //fix?
{IDENTIFIER}+  {column += yyleng;yylval.sval = strdup(yytext); return IDENT;}
";"            {column += yyleng;return SEMI;}
":"            {column += yyleng;return COLON;}
","            {column += yyleng;return COMMA;}
"("            {column += yyleng;return LPAREN;}
")"            {column += yyleng;return RPAREN;}
"["            {column += yyleng;return LBRACKET;} 
"]"            {column += yyleng;return RBRACKET;}
":="           {column += yyleng;return ASSIGN;}

.              {printf("ERROR\n"); exit(0);}

%%
	/* C functions used in lexer */