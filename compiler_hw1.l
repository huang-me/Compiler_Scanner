/* Definition section */
%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    #define YY_NO_UNPUT
    #define YY_NO_INPUT

    int line_num = 0;
    int comment_num = 0;
%}

/* Define regular expression label */
letter      [a-zA-Z_]
digit       [0-9]
id          {letter}+({letter}|{digit})*
inumber     {digit}+
fnumber     ({digit}*\.{digit}+)
ws          [ \t]+
cppcomment  ([/]{2}.*)
ccomment    ([/]\*.*[\n])

/* Rules section */
%START  str strdec comment
%%

"\n"        { line_num++; printf("%-8s \t NEWLINE\n", ""); }
"+"         { printf("%-8s \t %s\n", yytext, "ADD"); }
"="         { printf("%-8s \t %s\n", yytext, "ASSIGN"); }
"++"        { printf("%-8s \t %s\n", yytext, "INC"); }
"-"         { printf("%-8s \t %s\n", yytext, "SUB"); }
"--"        { printf("%-8s \t %s\n", yytext, "DEC"); }
"*"         { printf("%-8s \t %s\n", yytext, "MUL"); }
"/"         { printf("%-8s \t %s\n", yytext, "QUO"); }
"("         { printf("%-8s \t %s\n", yytext, "LPAREN"); }
")"         { printf("%-8s \t %s\n", yytext, "RPAREN"); }
"{"         { printf("%-8s \t %s\n", yytext, "LBRACE"); }
"}"         { printf("%-8s \t %s\n", yytext, "RBRACE"); }
"["         { printf("%-8s \t %s\n", yytext, "RBRACK"); }
"]"         { printf("%-8s \t %s\n", yytext, "RBRACK"); }
"\""        { printf("%-8s \t %s\n", yytext, "QUOTA"); }
"%"         { printf("%-8s \t %s\n", yytext, "REM"); }
";"         { printf("%-8s \t %s\n", yytext, "SEMICOLON"); }
","         { printf("%-8s \t %s\n", yytext, "COMMA"); }
"float32"   { printf("%-8s \t %s\n", yytext, "FLOAT"); }
"int32"     { printf("%-8s \t %s\n", yytext, "INT"); }
"string"    { printf("%-8s \t %s\n", yytext, "STRING"); BEGIN str; }
"bool"      { printf("%-8s \t %s\n", yytext, "BOOL"); }
"true"      { printf("%-8s \t %s\n", yytext, "TRUE"); }
"false"     { printf("%-8s \t %s\n", yytext, "FALSE"); }
"<"         { printf("%-8s \t %s\n", yytext, "LSS"); }
">"         { printf("%-8s \t %s\n", yytext, "GTR"); }
">="        { printf("%-8s \t %s\n", yytext, "GEQ"); }
"<="        { printf("%-8s \t %s\n", yytext, "LEQ"); }
"=="        { printf("%-8s \t %s\n", yytext, "EQL"); }
"!="        { printf("%-8s \t %s\n", yytext, "NEQ"); }
"+="        { printf("%-8s \t %s\n", yytext, "ADD_ASSIGN"); }
"-="        { printf("%-8s \t %s\n", yytext, "SUB_ASSIGN"); }
"*="        { printf("%-8s \t %s\n", yytext, "MUL_ASSIGN"); }
"/="        { printf("%-8s \t %s\n", yytext, "QUO_ASSIGN"); }
"%="        { printf("%-8s \t %s\n", yytext, "REM_ASSIGN"); }
"var"       { printf("%-8s \t %s\n", yytext, "VAR"); }
"if"        { printf("%-8s \t %s\n", yytext, "IF"); }
"for"       { printf("%-8s \t %s\n", yytext, "FOR"); }
"else"      { printf("%-8s \t %s\n", yytext, "ELSE"); }


{id}            { printf("%-8s \t %s\n", yytext, "IDENT"); }
{fnumber}       { printf("%-8s \t %s\n", yytext, "FLOAT_LIT"); }
{inumber}       { printf("%-8s \t %s\n", yytext, "INT_LIT"); }
{cppcomment}    { printf("%-8s \t %s\n", yytext, "C++ Comment"); comment_num++; }
{ccomment}      { printf("%-8s \t\t\t %s\n", yytext, "C Comment"); comment_num++; line_num++; BEGIN comment; }
{ws}            {;}

<comment>.*\*[/]  { printf("%-8s \t %s\n", yytext, "C Comment"); BEGIN 0; comment_num++; }
<comment>.*[\n]   { printf("%-8s \t\t\t %s\n", yytext, "C Comment"); comment_num++; line_num++; }
<str>\"/{id}    { printf("%-8s \t %s\n", yytext, "QUOTA"); BEGIN strdec; }
<strdec>{id}/\" { printf("%-8s \t %s\n", yytext, "STRING"); BEGIN 0; }
<<EOF>>         { line_num++; yyterminate(); }
.               {;}


%%

/*  C Code section */
int yywrap(void)
{
    return 1;
}

int main(int argc, char *argv[])
{
    if (argc == 2) {
        yyin = fopen(argv[1], "r");
    } else {
        yyin = stdin;
    }
    yylex();
    printf("\nFinish scanning,\n");
    printf("total line: %d\n", line_num);
    printf("comment line: %d\n", comment_num);
    fclose(yyin);
    return 0;
}
