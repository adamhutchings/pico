# This file is NOT AUTOMATICALLY GENERATED.
# It may be at some point in the future, but not right now.

BIN = bin/

OBJECTS = bin/main.o

CC = clang -c -I.
LINKER = clang

bin/pico : $(OBJECTS)
  @$(LINKER) $(OBJECTS) -o bin/pico
  
bin/main.o : src/main.c
  $(CC) src/main.c -o bin/main.o
