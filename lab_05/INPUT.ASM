PUBLIC input_digit, input_signed_decimal

EXTRN print_newline: NEAR
EXTRN print_string: NEAR

DATA SEGMENT PARA PUBLIC 'DATA' USE16
    input_prompt db 'Enter a signed decimal number (-32768..32767): $'
    error_input  db 'Number is invalid or out of range, try again: $'
    buffer    db 7, 0, 8 dup (0)
    choice_buffer db 2, 0, 3 dup (0)
DATA ENDS

CODE SEGMENT PARA PUBLIC 'CODE' USE16
    assume CS:CODE, DS:DATA

    input_digit PROC near
        push ds
        mov ax, DATA
        mov ds, ax

        read_again:
            mov byte ptr choice_buffer[1], 0
            lea dx, choice_buffer
            mov ah, 0Ah
            int 21h

            cmp byte ptr choice_buffer[1], 1
            jne read_again

            mov al, byte ptr choice_buffer[2]
            cmp al, '0'
            jb read_again
            cmp al, '9'
            ja read_again
            sub al, '0'
            call print_newline
            pop ds
            ret
    input_digit ENDP

    input_signed_decimal PROC near
        push ds
        mov ax, DATA
        mov ds, ax

        push bx
        push cx
        push dx
        push si
        push di

        ; Достаточно сбросить длину; DOS сам заполняет введенные символы.
        mov byte ptr buffer, 7
        mov byte ptr buffer[1], 0

        input_loop:
            lea dx, input_prompt
            call print_string

            lea dx, buffer
            mov ah, 0Ah
            int 21h

            call print_newline

            lea si, buffer[2]
            mov cl, buffer[1]
            cmp cl, 0
            je  input_error

            mov bx, 0
            xor di, di
            mov al, [si]
            cmp al, '-'
            jne check_plus

            mov di, 1 ; 1 means negative, 0 means positive
            inc si
            dec cl
            jmp parse_start

        check_plus:
            cmp al, '+'
            jne parse_start
            inc si
            dec cl

        parse_start:
            cmp cl, 0
            je  input_error

        next_char:
            mov al, [si]
            cmp al, '0'
            jb  input_error
            cmp al, '9'
            ja  input_error

            sub al, '0'

            ; BX = BX * 10 + AX
            mov dx, bx
            shl bx, 1 ; * 2
            shl dx, 1 ; * 2
            shl dx, 1 ; * 4
            shl dx, 1 ; * 8
            add bx, dx ; BX = BX * 2 + BX * 8 = BX * 10

            xor ah, ah
            add bx, ax

            cmp di, 0
            jne check_overflow_neg
            cmp bx, 32767
            ja input_error
            jmp next_step

        check_overflow_neg:
            cmp bx, 32768
            ja input_error

        next_step:
            inc si
            dec cl
            jnz next_char

        finish_input:
            cmp di, 0
            je store_positive
            neg bx

        store_positive:
            mov ax, bx
            jmp done_input

        input_error:
            lea dx, error_input
            call print_string
            jmp input_loop
        
        done_input:
            pop di
            pop si
            pop dx
            pop cx
            pop bx
            pop ds
            ret
    input_signed_decimal ENDP
    
CODE ENDS
END