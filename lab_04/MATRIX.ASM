PUBLIC process_matrix
EXTRN rows: byte, cols: byte, matrix: byte, calc_shift: near

DC SEGMENT PARA PUBLIC 'DATA'
    min_val db ?
    max_val db ?
    min_row db ?
    max_row db ?
DC ENDS

CODE SEGMENT PARA PUBLIC 'CODE'
    assume cs:CODE, ds:DC

    process_matrix PROC near
        push ax
        push bx
        push cx
        push dx
        push si
        push di

        mov cl, cols
        mov ch, 0
        xor di, di

        col_loop:
            cmp di, cx
            jae col_loop_end

            mov dl, rows
            mov dh, 0
            xor si, si

            call calc_shift
            mov al, matrix[bx]
            mov min_val, al
            mov max_val, al
            mov min_row, 0
            mov max_row, 0

            row_loop:
            cmp si, dx
            jae row_loop_end

            call calc_shift
            mov al, [matrix + bx]
            cmp al, min_val
            jge skip_min_update
            mov min_val, al
            mov ax, si
            mov min_row, al

            skip_min_update:
            mov al, [matrix + bx]
            cmp max_val, al
            jge skip_max_update
            mov max_val, al
            mov ax, si
            mov max_row, al

            skip_max_update:
            inc si
            jmp row_loop

            row_loop_end:
                call swap_elems
                inc di
                jmp col_loop
        
        col_loop_end:
        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        ret
    process_matrix ENDP

    swap_elems PROC near
        push ax
        push bx
        push cx
        push dx
        push si
        push di

        mov dx, di

        xor ax, ax
        mov al, min_row
        mov si, ax
        ;mov di, dx
        call calc_shift
        push bx

        xor ax, ax
        mov al, max_row
        mov si, ax
        mov di, dx
        call calc_shift

        pop di
        mov al, matrix[di]
        xchg al, matrix[bx]
        mov matrix[di], al

        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        ret
    swap_elems ENDP
CODE ENDS
END