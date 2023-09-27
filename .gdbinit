set disassembly-flavor intel
display (char *) $rdi
display (char *) $rsi
display (char *) $rax
display (char) $al
display (char) $bl
display (int) $rcx
display (int) $rdx
b _reverse_str 
run
x/i $pc

