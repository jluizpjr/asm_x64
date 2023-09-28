set disassembly-flavor intel
display (char *) $rdi
display (char *) $rsi
display (char *) $rax
display (char) $al
display (char) $bl
display (int) $rcx
display (int) $rdx
b asm_func99 
run
x/i $pc

