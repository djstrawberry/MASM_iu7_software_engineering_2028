public print_newline, print_string, input_number, input_matrix, print_matrix
extrn rows:byte, cols:byte, matrix:byte, calc_shift:near

CODE SEGMENT PARA PUBLIC 'CODE'
    assume cs:CODE

    print_newline PROC near
        push ax
        push dx
        mov ah, 2
        mov dl, 0Dh
        int 21h
        mov dl, 0Ah
        int 21h
        pop dx
        pop ax
        ret
    print_newline ENDP

    print_string PROC near
        mov ah, 9
        int 21h
        call print_newline
        ret
    print_string ENDP

    input_number PROC near
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
    input_number ENDP

    input_matrix PROC near
        push ax
        push bx
        push cx
        push dx
        push si
        push di

        mov cl, rows
        mov ch, 0     

        xor si, si

        row_loop:
            cmp si, cx
            jae row_loop_end

            mov dl, cols
            mov dh, 0
            xor di, di

            col_loop:
                cmp di, dx
                jae col_loop_end

                call calc_shift

                call input_number
                mov [matrix + bx], al

                inc di
                jmp col_loop

                col_loop_end:
                    inc si
                    jmp row_loop

        row_loop_end:
        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        ret
    input_matrix ENDP

    print_matrix PROC near
        push ax
        push bx
        push cx
        push dx
        push si
        push di

        mov cl, rows
        mov ch, 0
        xor si, si

        row_loop_print:
            cmp si, cx
            jae row_loop_print_end

            xor di, di

            col_loop_print:
                xor ax, ax
                mov al, cols
                cmp di, ax
                jae col_loop_print_end

                call calc_shift

                mov dl, matrix[bx]
                add dl, '0'
                mov ah, 2
                int 21h

                mov dl, ' '
                mov ah, 2
                int 21h

                inc di
                jmp col_loop_print

            col_loop_print_end:
                call print_newline
                inc si
                jmp row_loop_print

        row_loop_print_end:
        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        ret
    print_matrix ENDP

CODE ENDS

END