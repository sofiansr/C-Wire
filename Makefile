all: exec

exec: main.o station.o avl.o
	gcc -o exec main.o station.o avl.o

main.o: main.c station.h avl.h
	gcc -o main.o -c main.c

station.o: station.c station.h
	gcc -o station.o -c station.c

avl.o: avl.c avl.h station.h
	gcc -o avl.o -c avl.c

clean:
	rm -f *.o

mrproper: clean
	rm -f exec