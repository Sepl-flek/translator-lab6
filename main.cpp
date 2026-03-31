#include <cstdio>
#include <cstdlib>

extern FILE* yyin;
int yyparse();

int main(int argc, char** argv) {
    if (argc != 2) {
        printf("Usage: %s <file>\n", argv[0]);
        return 1;
    }

    yyin = fopen(argv[1], "r");
    if (!yyin) {
        perror("fopen");
        return 1;
    }

    int res = yyparse();
    fclose(yyin);

    return res;
}