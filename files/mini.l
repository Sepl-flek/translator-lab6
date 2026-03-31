%{
#include "mini.tab.hpp"
#include <cstdlib>
#include <cstring>
%}

%option noyywrap

%%
[ \t\r\n]+              ;

[a-zA-Z][a-zA-Z0-9]* {
    yylval.sval = strdup(yytext);
    return ID;
}

[0-9]+(\.[0-9]+)?([eE][+-]?[0-9]+)? {
    yylval.dval = atof(yytext);
    return NUMBER;
}

"="     return '=';
"."     return '.';
"+"     return '+';
"-"     return '-';
"*"     return '*';
"/"     return '/';
"("     return '(';
")"     return ')';
";"     return ';';

. {
    printf("Unknown character: %s\n", yytext);
    exit(1);
}
%%