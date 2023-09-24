; ----------------------------------------------------------------------------------------
global                  asm_func1 
;
; Prints msg1 string
;

section                 .text 

asm_func1:mov           rax, 1          ; system call for write
        mov             rdi, 1          ; file handle 1 is stdout
        lea             rsi, [rel msg1] ; address of string to output
        mov             rdx, len         ; number of bytes
        syscall                         ; invoke operating system to do the write
        ret
;------------------------------------------------------------------------------------------------
global                  asm_func2
;
; Receives a string null terminated, prints the string and returns the length of the string
;

asm_func2:
        mov             rsi, rax        ; stores argument received 
        call            _strlen         ; get argument length
        mov             rdx, rax        ; saves in rdx for syscall 
        mov             rax, 1          ; system call for write
        mov             rdi, 1          ; file handle 1 is stdout
        syscall                         ; invoke operating system to do the write
        ret

_strlen:
        push            rcx             ; save and clear out counter
        xor             rcx, rcx        ; clear rcx

_strlen_next:
        cmp             [rdi], byte 0   ; null byte yet?
        jz              _strlen_null    ; yes, get out

        inc             rcx             ; char is ok, count it
        inc             rdi             ; move to next char
        jmp             _strlen_next    ; process again

_strlen_null:
        mov             rax, rcx        ; rcx = the length (put in rax)
        pop             rcx             ; restore rcx
        ret                             ; get out

_exit:
        mov             rax, 60         ; system call for exit
        xor             rdi, rdi        ; exit code 0
        syscall                         ; invoke operating system to exit

;----------------------------------------------------------------------------------------------------

section                 .data
        msg1:           db "Hello from asm_func1", 10    ; note the newline at the end
        len             equ $ - msg1    ; calculate length of msg1

