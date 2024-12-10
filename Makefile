parser: dir expr.c lex.c
	gcc out/expr.c out/lex.c -o out/calc -lm

run: parser
	./out/calc

dir:
	mkdir -p out

expr.c: files/expr.y
	bison --defines=out/expr.tab.h --output=out/expr.c --report='all' --report-file=out/report.txt files/expr.y

lex.c: files/expr.l
	flex --outfile=out/lex.c files/expr.l

clean:
	rmdir -f out
