default rel

; Define the code section.
section .text 


; ----------------------------------------------------------------------------------------
global asm_func1
; Function: asm_func1
; Purpose: 
; - Uses the Linux system call convention to print msg1 string to standard output.
;
; No parameters are expected. 
; No values are returned.
asm_func1:
        push rbp             ; preserve rbp
        mov  rax, 1          ; syscall: write
        mov  rdi, 1          ; file descriptor: stdout
        lea  rsi, [rel msg1] ; address of msg1
        mov  rdx, len        ; message length
        syscall              ; execute syscall
        pop  rbp             ; restore rbp
        ret                  ; return
          
;--------------------------------------------------------------------------------

global asm_func2

; Function: asm_func2
; Purpose: 
; - Receives a pointer to a null-terminated string in RDI
; - Prints the string to standard output
; - Returns the length of the string
;
; Parameters:
;   rdi: Pointer to the null-terminated string
;
; Returns:
;   rax: Length of the string

asm_func2:
        
        push rbp                ; Preserve the base pointer                     
        mov rsi, rdi            ; Prepare RSI for _strlen call: RSI will point to the string                
        call _strlen            ; Calculate the length of the string                 
        mov rdx, rax            ; RAX now contains the length of the string. Save it in RDX for syscall                                             
        pop rbp                 ; Restore base pointer and return from function                      
        ret                          

; Function: _strlen
; Purpose: Calculates the length of a null-terminated string.
; Parameters:
;   rdi: Pointer to the null-terminated string (passed from asm_func2 via RSI)
; Returns:
;   rax: Length of the string

_strlen:
        xor  rcx, rcx          ; initialize counter to 0

_strlen_next:       
        cmp  [rdi+rcx], byte 0 ; check for null terminator
        jz   _strlen_null      ; if found, end the loop
        inc  rcx               ; increment length counter
        jmp  _strlen_next      ; loop for next char

_strlen_null:
        mov  rax, rcx          ; return string length in rax
        sub  rax,1             ; we don't want \n
        ret                    ; return

        
;----------------------------------------------------------------------------------------
global                  asm_func3
; Function: asm_func3
; Purpose: Convert all lowercase letters in a source string to uppercase and store the result in a destination buffer.
; Parameters:
;   rdi: Pointer to the source null-terminated string.
;   rsi: Pointer to the destination buffer.
; Returns:
;   rax: Pointer to the destination buffer containing the converted string.

asm_func3:
        push rbp                  ; preserve rbp
        xor  rcx, rcx             ; initialize rcx to 0

_toupper:
        mov  al, byte [rdi]       ; load next char from string
        cmp  al, 0h              
        je   _toupper_end         ; if end of string, exit
        cmp  al, 61h             
        jl   _toupper_next        ; skip if char < 'a'
        cmp  al, 7Ah             
        jg   _toupper_next        ; skip if char > 'z'
        sub  al, 20h              ; convert lowercase to uppercase

_toupper_next:   
        mov  byte [rsi + rcx], al ; store converted char
        inc  rdi                  ; move to next source char
        inc  rcx                  ; increment counter
        jmp  _toupper             ; loop to process next char

_toupper_end:
        mov  byte [rsi + rcx], 0h ; null-terminate the output
        mov  rax, rsi             ; set return value to destination buffer address
        pop  rbp                  ; restore rbp
        ret                       ; return
                   

;--------------------------------------------------------------------------------

;----------------------------------------------------------------------------------------------------
global asm_func4

asm_func4:
        push rbp                ; preserve rbp
        push rbx                ; preserve rbx
        call _strlen            ; get string strlen
        mov rdx, rax            ; copy strlen to reverse counter 
        sub rdx, 1              ; we don't need to move \n  
        xor rcx, rcx            ; clear counter        

_reverse_str:
        mov al, [rdi+rdx]       ; copy last char to al
        mov bl, [rdi+rcx]       ; copy first char to bl
        mov byte [rdi+rcx], al  ; swap
        mov byte [rdi+rdx], bl  ; swap
        inc rcx                 ; increment destination counter
        dec rdx                 ; decrement reverse counter
        cmp rcx, rdx            ; compare counters
        jle  _reverse_str       ; did we reach the middle?

_reverse_end:
        mov rax,rdi             ; return value
        pop rbx                 ; housekeeping
        pop rbp                 ; housekeeping
        ret

;---------------------------------------------------------------------------------
; Function: _asm_func99
; Purpose: test function
global asm_func99
asm_func99:
        push rbp
        mov rbp, rsp

_99_loop:
        nop
        nop
        nop

        mov rax, rdi
_end_99:
        pop rbp
        ret

;---------------------------------------------------------------------------------
; Function: _exit
; Purpose: Exits the program.
_exit:
        ; System call for exit
        mov rax, 60                 

        ; Exit code 0
        xor rdi, rdi                

        ; Invoke operating system call to terminate the process
        syscall                      
;----------------------------------------------------------------------------------------------------





;----------------------------------------------------------------------------------------------------

section .data
        msg1:           db "Hello from asm_func1", 10   ; note the newline at the end
        len             equ $ - msg1                    ; calculate length of msg1