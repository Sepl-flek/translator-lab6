/* ====================================================
   mini.l — лексер для мини-интерпретатора
   ==================================================== */
%{
#include "mini.tab.hpp"   /* Коды токенов от Bison */
#include <cstring>
#include <cstdlib>

/* Счётчик строк — используем для диагностики ошибок */
int yylineno_manual = 1;
%}

/* Опции:
   noyywrap — не нужна функция yywrap()
   nounput  — не генерировать функцию unput (убирает предупреждение)
   noinput  — аналогично для input()                               */
%option noyywrap nounput noinput

/* Именованные выражения для удобства */
DIGIT   [0-9]
LETTER  [a-z]
WS      [ \t\r]

%%

"if"        { return IF;    }
"else"      { return ELSE;  }
"while"     { return WHILE; }
"print"     { return PRINT; }

{LETTER}    { yylval.ival = yytext[0] - 'a';
              return VAR; }

{DIGIT}+    { yylval.ival = atoi(yytext);
              return NUMBER; }

"=="        { return EQEQ; }
"!="        { return NEQ;  }
"<="        { return LE;   }
">="        { return GE;   }

{WS}+       { /* пропускаем */ }
"\n"        { yylineno_manual++; }

.           { return yytext[0]; }

%%