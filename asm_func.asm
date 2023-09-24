default rel

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
;----------------------------------------------------------------------------------------
global                  asm_func3
;
; Receives a string null terminated, converts lowercase chars to UPPERCASE and return new string
;

asm_func3:
        push            rbp                     ; must be preserved
        xor             rcx,rcx                 ; zero counter
        mov             dl, byte [rdi+rcx]      ; copy one byte

_toupper:
        cmp             dl, byte 61h            ; is lowercase ascii?
        jl              _toupper_next           ; no, go to next char

        cmp             dl, byte 7Ah            ; is lowercase ascii?
        jg              _toupper_next           ; no, go to next char
        
        sub             dl, 20h                 ; subtract 32 to convert lowercase to uppercase

_toupper_next:   
        mov             byte [rsi+rcx], dl      ; save byte on rsi
        inc             rcx                     ; next char
        mov             dl, byte [rdi+rcx]      ; copy one more byte
        cmp             dl, 0h                  ; is end of string?
        jne             _toupper                ; start again
        mov             rax, rsi                ; copy rsi to rax to return
        mov             rbx, 0h
        pop             rbp                     ; restore rbp
        ret

;----------------------------------------------------------------------------------------------------

section                 .data
        msg1:           db "Hello from asm_func1", 10    ; note the newline at the end
        len             equ $ - msg1    ; calculate length of msg1

