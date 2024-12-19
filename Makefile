CC=gcc
EXEC=exec

all: $(EXEC)

exec: main.o station.o avl.o request.o avl.o output.o
	$(CC) -o $@ $^ 

%.o: %.c %.h
	$(CC) -o $@ -c $<

clean:
	rm -f *.o

mrproper: clean
	rm -f $(EXEC)