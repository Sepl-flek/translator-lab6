%{
#include <cstdio>
#include <cstdlib>
#include <map>
#include <string>
#include <cstring>

int yylex();
void yyerror(const char* s);

std::map<std::string, double> vars;
%}

%union {
    double dval;
    char* sval;
}

%token <dval> NUMBER
%token <sval> ID

%type <dval> expr sum prod primary
%type <sval> field_tail full_id

%%

program:
    stmt_list
;

stmt_list:
    stmt
  | stmt stmt_list
;

stmt:
    full_id '=' expr ';' {
        vars[$1] = $3;
        printf("%s = %f\n", $1, $3);
    }
;

full_id:
    ID field_tail {
        std::string res = $1;
        if ($2) res += $2;
        $$ = strdup(res.c_str());
    }
;

field_tail:
    '.' ID field_tail {
        std::string res = "." + std::string($2);
        if ($3) res += $3;
        $$ = strdup(res.c_str());
    }
  | /* empty */ {
        $$ = nullptr;
    }
;

expr:
    '-' sum { $$ = -$2; }
  | sum     { $$ = $1; }
;

sum:
    prod                { $$ = $1; }
  | sum '+' prod        { $$ = $1 + $3; }
  | sum '-' prod        { $$ = $1 - $3; }
;

prod:
    primary             { $$ = $1; }
  | prod '*' primary    { $$ = $1 * $3; }
  | prod '/' primary    { $$ = $1 / $3; }
;

primary:
    '(' expr ')' { $$ = $2; }
  | NUMBER       { $$ = $1; }
  | full_id {
        if (vars.count($1))
            $$ = vars[$1];
        else {
            printf("Undefined variable: %s\n", $1);
            exit(1);
        }
    }
;

%%

void yyerror(const char* s) {
    printf("Parse error: %s\n", s);
    exit(1);
}