.MODEL LARGE
.STACK 100h

.DATA  

    msg1 DB 10,13,'Select conversion type:', 0Dh, 0Ah, '$'
    msg1a DB ' 0. Binary to Decimal', 0Dh, 0Ah, '$'
    msg1b DB ' 1. Binary to Octal', 0Dh, 0Ah, '$'
    msg1c DB ' 2. Binary to Hexadecimal', 0Dh, 0Ah, '$'
    msg1d DB ' 3. Decimal to Binary', 0Dh, 0Ah, '$'
    msg1e DB ' 4. Decimal to Octal', 0Dh, 0Ah, '$'
    msg1f DB ' 5. Hexadecimal to Binary', 0Dh, 0Ah, '$'
    msg1g DB ' 6. Hexadecimal to Decimal', 0Dh, 0Ah, '$'
    msg1i DB ' 7. Octal to Binary', 0Dh, 0Ah, '$'  
    msg1j DB ' 8. Octal to Decimal', 0Dh, 0Ah, '$'
    msg1k DB ' 9. Octal to Hexadecimal', 0Dh, 0Ah, '$' 
              
    msg2 DB ' Enter your choice (0-9): $'            
    
    msg3 DB 10,13, ' Enter a 4-digit Binary number: $'
    msg4 DB 10,13, ' Enter a Decimal number: $'
    msg5 DB 10, 13, ' Enter hexadecimal number: $'
    msg6 DB 10, 13, ' Binary equivalent: $'  
    msg7 DB 10,13, ' Enter an Octal number: $'
    newline DB 0Dh, 0Ah, '$'                     
    
    msg_dec DB 10,13, ' Decimal Equivalent: $'
    msg_hex DB 10,13, ' Hexadecimal Equivalent: $'
    msg_oct DB 10,13, ' Octal Equivalent: $'
    msg_bin DB 10,13, ' Binary Equivalent: $'
    
    err_msg DB 10,13, ' Invalid input! Please enter a valid number.', 0Dh, 0Ah, '$'
    err_msg1 DB 10,13, ' Invalid binary digit. Please enter only 0 or 1.', 0Dh, 0Ah, '$' 
    error DB 10, 13, ' Invalid input', 0Dh, 0Ah, '$'
    
    errMsg db 10, 13, ' Error:Convertion not perform values are bigger than 7 !$'
    hex_table DB ' 0123456789ABCDEF' ; Hexadecimal lookup table
    
    number db ?           ; Variable to store the input number 
    
    user_input  db 4 dup('$') ; Buffer to store user input (max 4 characters)
    input_index dw 0

.CODE 

MAIN PROC  
    
    ; Set up data segment  
    
    MOV AX, @DATA
    MOV DS, AX

    ; Display conversion options 
    
    MOV AH, 09h
    LEA DX, msg1
    INT 21h
    LEA DX, msg1a
    INT 21h
    LEA DX, msg1b
    INT 21h
    LEA DX, msg1c
    INT 21h
    LEA DX, msg1d
    INT 21h
    LEA DX, msg1e
    INT 21h
    LEA DX, msg1f
    INT 21h
    LEA DX, msg1g
    INT 21h 
    LEA DX, msg1i
    INT 21h 
    LEA DX, msg1j
    INT 21h
    LEA DX, msg1k
    INT 21h

    ; Read user choice  
    
    LEA DX, msg2
    INT 21h
    MOV AH, 01h
    INT 21h
    sub AL,'0'
    CMP AL, 1
    JB invalid_choice
    CMP AL, 9
    JA invalid_choice

    ; Call conversion routines based on choice  
    
    CMP AL, 0
    JE bin_to_dec
    CMP AL, 1
    JE bin_to_oct
    CMP AL, 2
    JE bin_to_hex
    CMP AL, 3
    JE dec_to_bin
    CMP AL, 4
    JE dec_to_oct
    CMP AL, 5
    JE hex_to_bin
    CMP AL, 6
    JE hex_to_deci
    CMP AL, 7
    JE octal_to_binary_conversion
    CMP AL, 8
    JE octal_to_decimal_conversion
    CMP AL, 9
    JE octal_to_hexa_conversion

    JMP MAIN

invalid_choice:
    MOV AH, 09h
    LEA DX, newline
    INT 21h
    JMP MAIN

hex_to_deci:
    lea dx, msg5
    mov ah, 09h
    int 21h
    
    mov ah,01h
    int 21h
   
    mov bl,al 
    jmp go
go:   
    cmp bl,'9'
    ja hex
    jb num
    je num

hex:
    cmp bl,'F'
    ja illegal      
    lea dx,msg_dec
    mov ah,9
    int 21h

    mov dl,49d
    mov ah,2
    int 21h
    
    sub bl,17d
    mov dl,bl
    mov ah,2
    int 21h
    
    jmp inp
inp:
    jmp main
num:
    cmp bl,'0'
    jb illegal

    lea dx,msg_dec 
    mov ah,9
    int 21h
   
    mov dl,bl
    mov ah,2
    int 21h
    jmp inp
   
illegal:
       lea dx,err_msg
       mov ah,9
       int 21h

       mov ah,1
       int 21h

       mov bl,al 
       jmp go


   ; New line after printing 
    
    mov ah, 09h
    lea dx, newline
    int 21h
    jmp main
   ; Binary to Decimal Conversion Procedure 

bin_to_dec:
    lea dx, msg3
    mov ah, 09h
    int 21h

    ; Read 4 binary digits  
    
    mov cx, 4
    mov bx, 0          ; Clear BX to store the binary value

read_loop:
    mov ah, 01h
    int 21h
    sub al, '0'        ; Convert ASCII to binary

    ; Check if input is valid (only 0 or 1 allowed)  
    
    cmp al, 2
    ja error_invalid_digit
    shl bx, 1          ; Shift BX left by 1 (multiply by 2)
    or bl, al          ; OR the bit into BX
    loop read_loop

    ; Display decimal equivalent 
    
    lea dx, msg_dec
    mov ah, 09h
    int 21h
    mov ax, bx
    call print_decimal
    jmp main

error_invalid_digit:
    lea dx, err_msg1
    mov ah, 09h
    int 21h
    jmp bin_to_dec

    ; Binary to Octal Conversion Procedure  
    
bin_to_oct:
    lea dx, msg3
    mov ah,09h
    int 21h

    ; Read 4 binary digits  
    
    mov cx, 4
    mov bx, 0          ; Clear BX to store the binary value

bin_oct_read_loop:
    mov ah, 01h
    int 21h
    sub al, '0'        ; Convert ASCII to binary   
    
    ; Check if input is valid (only 0 or 1 allowed) 
    
    cmp al, 2
    ja error_invalid_digit_oct
    shl bx, 1          ; Shift BX left by 1 (multiply by 2)
    or bl, al          ; OR the bit into BX
    loop bin_oct_read_loop

    ; Display octal equivalent 
    
    lea dx, msg_oct
    mov ah, 09h
    int 21h
    mov ax, bx
    call print_octal
    jmp main

error_invalid_digit_oct:
    lea dx, err_msg1
    mov ah, 09h
    int 21h
    jmp bin_to_oct

; Binary to Hexadecimal Conversion Procedure  

bin_to_hex:
    lea dx, msg3
    mov ah, 09h
    int 21h

    ; Read 4 binary digits   
    
    mov cx, 4
    mov bx, 0          ; Clear BX to store the binary value

bin_hex_read_loop:
    mov ah, 01h
    int 21h
    sub al, '0'        ; Convert ASCII to binary

    ; Check if input is valid (only 0 or 1 allowed)
    
    cmp al, 2
    ja error_invalid_digit_hex
    shl bx, 1          ; Shift BX left by 1 (multiply by 2)
    or bl, al          ; OR the bit into BX
    loop bin_hex_read_loop

    ; Display hexadecimal equivalent  
    
    lea dx, msg_hex
    mov ah, 09h
    int 21h

    ; Use lookup table to convert binary to hexadecimal 
    
    mov al, bl
    mov ah, 0
    mov si, offset hex_table
    add si, ax
    mov dl, [si]
    mov ah, 02h
    int 21h

    jmp main

error_invalid_digit_hex:
    lea dx, err_msg1
    mov ah, 09h
    int 21h
    jmp bin_to_hex

    ; Decimal to Binary Conversion Procedure 

dec_to_bin:
    lea dx, msg4
    mov ah, 09h
    int 21h

    ; Read decimal input        
    
    mov ah, 01h
    int 21h
    sub al, '0'
    mov bl, al         ; Store decimal in BL
    mov bh, 0          ; Clear BH for 8-bit value in BX

    ; Display binary equivalent  
    
    lea dx, msg_bin
    mov ah, 09h
    int 21h

    ; Convert to binary and print in reverse   
    
    mov cx, 8
    mov bp, sp         ; Store the initial stack pointer

dec_bin_loop:
    mov dx, bx
    and dx, 1
    mov ax, bx
    shr bx, 1
    add dl, '0'
    push dx
    loop dec_bin_loop

print_binary:
    pop dx
    mov ah, 02h
    int 21h
    cmp sp, bp
    jne print_binary

    ; New line after printing  
    
    mov ah, 09h
    lea dx, newline
    int 21h
    jmp main

    ; Decimal to Octal Conversion Procedure  

dec_to_oct:
    lea dx, msg4
    mov ah, 09h
    int 21h

    ; Read decimal input     
    
    mov ah, 01h
    int 21h
    sub al, '0'
    mov bl, al         ; Store decimal in BL
    mov bh, 0          ; Clear BH for 8-bit value in BX

    ; Display octal equivalent   
    
    lea dx, msg_oct
    mov ah, 09h
    int 21h
    mov ax, bx
    call print_octal
    jmp main

    ; Hexadecimal to Binary Conversion Procedure 

hex_to_bin:
    lea dx, msg5
    mov ah, 09h
    int 21h

    ; Reset input buffer and index   
    
    lea di, user_input
    mov cx, 4
fill_buffer:
    mov byte ptr [di], '$'
    inc di
    loop fill_buffer
    mov input_index, 0

read_input:
    mov ah, 1
    int 21h
    cmp al, 0dh         ; Check for Enter key
    je display_binary
    cmp input_index, 4  ; Ensure input doesn't exceed buffer size
    ja error_exit

    ; Store valid input in the buffer   
    
    lea di, user_input
    add di, input_index
    mov [di], al
    inc input_index
    jmp read_input

display_binary:            

    ; Display output message    
    
    mov dx, offset msg_bin
    mov ah, 9
    int 21h

    ; Convert and display each character in the buffer   
    
    lea si, user_input
convert_loop:
    lodsb
    cmp al, '$'
    call convert_hex_to_binary
    jmp convert_loop

convert_hex_to_binary:
    cmp al, '0'
    jb error_exit
    cmp al, '9'
    ja check_upper
    sub al, '0'
    jmp process_character

check_upper:
    cmp al, 'A'
    jb error_exit
    cmp al, 'F'
    ja check_lower
    sub al, 'A'
    add al, 10
    jmp process_character

check_lower:
    cmp al, 'a'
    jb error_exit
    cmp al, 'f'
    ja error_exit
    sub al, 'a'
    add al, 10

process_character:                                  

    ; Convert a single hex digit to binary           
    
    mov ch, 4
    mov cl, 3
    mov bl, al

binary_conversion:
    mov al, bl
    ror al, cl
    and al, 1
    add al, '0'
    mov ah, 2
    mov dl, al
    int 21h

    dec cl
    dec ch
    jnz binary_conversion

    ; Print a space between binary outputs      
    
    mov dl, 20h
    mov ah, 2
    int 21h
    ret

error_exit:
    jmp main

; Octal Printing Procedure          

print_octal proc                    
    mov bx, 8            ; Base 8 for octal
    xor cx, cx           ; Clear digit count

print_octal_loop:
    xor dx, dx           ; Clear DX for division
    div bx                ; Divide AX by 8
    push dx              ; Push remainder onto stack
    inc cx               ; Increment digit count
    test ax, ax          ; Check if AX is zero
    jnz print_octal_loop

print_octal_digits:
    pop dx               ; Get digit from stack
    add dl, '0'          ; Convert to ASCII
    mov ah, 02h          ; DOS function to print character
    int 21h
    loop print_octal_digits

    ; New line after printing  
    
    mov ah, 09h
    lea dx, newline
    int 21h

    ret
print_octal endp

    ; Decimal Printing Procedure   

print_decimal proc
    mov bx, 10           ; Base 10 for decimal
    xor cx, cx           ; Clear digit count

print_decimal_loop:
    xor dx, dx           ; Clear DX for division
    div bx                ; Divide AX by 10
    push dx              ; Push remainder onto stack
    inc cx               ; Increment digit count
    test ax, ax          ; Check if AX is zero
    jnz print_decimal_loop

print_decimal_digits:
    pop dx               ; Get digit from stack
    add dl, '0'          ; Convert to ASCII
    mov ah, 02h          ; DOS function to print character
    int 21h
    loop print_decimal_digits

    ; New line after printing 
    
    mov ah, 09h
    lea dx, newline
    int 21h

    ret
print_decimal endp 

octal_to_binary_conversion PROC    
    
    lea dx, msg7
    mov ah, 09h
    int 21h

    mov ah,01h
    int 21h
    sub al,30h          
    mov bl,al
    mov bh,0
    mov cx,3
    mov bp,sp

print_loop:
    mov dx,bx
    and dx,1
    mov ax,bx
    shr bx,1
    add dl,48
    push dx 
loop print_loop

    lea dx,msg_bin
    mov ah,09h
    int 21h

print_reverse:
    pop dx
    mov ah,02h 
    int 21h
    cmp sp,bp
jne print_reverse  

    mov dl,0Dh
    mov ah,02h 
    int 21h
    mov dl,0Ah
    mov ah,02h 
    int 21h

    ; New line after printing    
    
    mov ah, 09h
    lea dx, newline
    int 21h
    jmp main
octal_to_binary_conversion ENDP


octal_to_decimal_conversion PROC     
    
    lea dx, msg7
    mov ah, 09h
    int 21h

    mov ah, 01h           
    int 21h              
    mov number, al        

    ; Check if the entered number is greater than '7'   
    
    cmp number, '7'       
    jg displayError       

    ; Display the output message          
    
    mov ah, 09h
    lea dx, msg_dec
    int 21h

    ; Display the entered number    
    
    mov ah, 02h           
    mov dl, number        
    int 21h               

    jmp main

displayError:                    

    ; Display the error message  
    
    mov ah, 09h
    lea dx, errMsg
    int 21h
    
octal_to_decimal_conversion ENDP

octal_to_hexa_conversion PROC   
    
    lea dx, msg7
    mov ah, 09h
    int 21h
    
    ; Read a single character from the user  
        
    mov ah, 01h           
    int 21h              
    mov number, al        

    ; Check if the entered number is greater than '7'
    
    cmp number, '7'       
    jg displayError       

    ; Display the output message   
    
    mov ah, 09h
    lea dx, msg_hex
    int 21h

    ; Display the entered number  
    
    mov ah, 02h           
    mov dl, number        
    int 21h               

    ; Exit the program        
    
    jmp main

display_Error:                   

    ; Display the error message  
    
    mov ah, 09h
    lea dx, errMsg
    int 21h

    ; New line after printing    
    
    mov ah, 09h                  
    lea dx, newline
    int 21h
    jmp main                  
    
octal_to_hexa_conversion ENDP    

exitProgram:                   

    ; Exit the program     
    
    mov ax, 4C00h
    int 21h
end main