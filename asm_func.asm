default rel

; Define the code section.
section .text 


; ----------------------------------------------------------------------------------------
; Declare asm_func1 as a globally accessible function.
global asm_func1


; Function: asm_func1
; Purpose: 
; - Uses the Linux system call convention to print msg1 string to standard output.
;
; No parameters are expected. 
; No values are returned.
asm_func1:
        ; Preserve the base pointer.
        push rbp                      

        ; Prepare for the system call to write to stdout.
        mov rax, 1                    ; syscall number for sys_write.
        mov rdi, 1                    ; file descriptor: 1 is stdout.
        
        ; Load the address of the msg1 string into rsi.
        lea rsi, [rel msg1]           ; Move relative address of msg1 to RSI 

        ; Specify the number of bytes to write.
        mov rdx, len                  ; The variable 'len' should contain the length of msg1.

        ; Perform the system call to write to stdout.
        syscall                       

        ; Restore the base pointer.
        pop rbp                      

        ; Return from the function.
        ret                          
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
        ; Preserve the base pointer
        push rbp                     

        ; Prepare RSI for _strlen call: RSI will point to the string
        mov rsi, rdi                

        ; Calculate the length of the string
        call _strlen                 

        ; RAX now contains the length of the string. Save it in RDX for syscall
        mov rdx, rax                

        ; Prepare for the system call to write to stdout
        mov rax, 1                   ; syscall: write
        mov rdi, 1                   ; file descriptor: 1 is stdout

        ; System call
        syscall                      

        ; Restore base pointer and return from function
        pop rbp                      
        ret                          

; Function: _strlen
; Purpose: Calculates the length of a null-terminated string.
; Parameters:
;   rdi: Pointer to the null-terminated string (passed from asm_func2 via RSI)
; Returns:
;   rax: Length of the string

_strlen:
        push rsi
        mov rsi, rdi
        ; Clear RCX, which will store the length of the string
        xor rcx, rcx                

_strlen_next:
        ; Check if we've hit the null byte terminator
        cmp [rsi], byte 0            
        jz _strlen_null              

        ; If not, increment our counter and move to the next character
        inc rcx                      
        inc rsi                      
        jmp _strlen_next            

_strlen_null:
        ; When the null byte is found, move the length from RCX to RAX
        mov rax, rcx  
        pop rsi              
        ret                          

; Function: _exit
; Purpose: Exits the program.
; This function is not called in the above code, but is provided for completeness.
        
;----------------------------------------------------------------------------------------
global                  asm_func3
;
; Receives a string null terminated, converts lowercase chars to UPPERCASE and return new string
;

; Function: asm_func3
; Purpose: Convert all lowercase letters in a source string to uppercase and store the result in a destination buffer.
; Parameters:
;   rdi: Pointer to the source null-terminated string.
;   rsi: Pointer to the destination buffer.
; Returns:
;   rax: Pointer to the destination buffer containing the converted string.

asm_func3:
        ; Preserve the base pointer, as it's callee-saved.
        push  rbp                     

        ; Initialize rcx (our character offset counter) to 0.
        xor   rcx, rcx                 

_toupper:
        ; Load the next character from the source string into the al register.
        mov   al, byte [rdi]           

        ; Check if we've reached the end of the source string.
        cmp   al, 0h                   
        je    _toupper_end              ; If yes, jump to the function's end sequence.

        ; Check if the character is a lowercase letter.
        ; ASCII values: 'a' is 61h and 'z' is 7Ah.
        cmp   al, 61h                  
        jl    _toupper_next             ; If character is less than 'a', skip to the next character.
        cmp   al, 7Ah                  
        jg    _toupper_next             ; If character is greater than 'z', skip to the next character.
        
        ; Convert the lowercase character to uppercase.
        ; ASCII conversion: Uppercase letters are 32 less than their lowercase counterparts.
        sub   al, 20h                  

_toupper_next:   
        ; Store the (potentially converted) character into the destination buffer.
        mov   byte [rsi + rcx], al     

        ; Increment both the source pointer and our character offset counter.
        inc   rdi                      
        inc   rcx                      

        ; Jump back to the start of the loop to process the next character.
        jmp   _toupper                 

_toupper_end:
        ; Null-terminate the destination buffer.
        mov   byte [rsi + rcx], 0h     

        ; Set the return value to the base address of the destination buffer.
        mov   rax, rsi                 

        ; Restore the base pointer and return from the function.
        pop   rbp                      
        ret                           

;--------------------------------------------------------------------------------

;----------------------------------------------------------------------------------------------------
global asm_func4

asm_func4:
        push rbp                ; preserve rbp
        push rbx
        call _strlen            ; get rdi strlen
        mov rdx, rax            ; copy strlen to reverse counter 
        sub rdx, 2              ; we don't neet to move \n and 0h 
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