CC=gcc
LD=ld
AS=nasm

CFLAGS=-I. -ggdb
ASMCFLAGS= -felf64 -F dwarf -g -w+all 
DEPS = prog.h
OBJ = prog.o c_func.o 

default: prog

asm_func.o: asm_func.asm
	$(AS) $(ASMCFLAGS) -o $@ $<

%.o: %.c $(DEPS)
	$(CC) -c -o $@ $< $(CFLAGS)

prog: $(OBJ) asm_func.o
	$(CC) -o $@ $^ 

clean:
	rm prog $(OBJ) asm_func.o