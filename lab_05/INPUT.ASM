PUBLIC input_digit

EXTRN print_newline: NEAR

CODE SEGMENT PARA PUBLIC 'CODE' USE16
    assume CS:CODE

    input_digit PROC near
        read_again:
            mov ah, 1
            int 21h
            cmp al, '0'
            jb read_again
            cmp al, '9'
            ja read_again
            sub al, '0'
            call print_newline
            ret
    input_digit ENDP

CODE ENDS
END