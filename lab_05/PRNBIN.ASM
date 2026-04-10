.386

PUBLIC print_unsigned_binary

EXTRN number: WORD

CODE SEGMENT PARA PUBLIC 'CODE' USE16
    ASSUME CS:CODE

    print_unsigned_binary PROC NEAR
        push ax
        push bx
        push cx
        push dx
        push si

        mov si, word ptr [number]
        mov cx, 16
        mov bx, 8000h

    next_bit:
        mov dl, '0'
        test si, bx
        jz emit_bit
        mov dl, '1'

    emit_bit:
        mov ah, 2
        int 21h
        shr bx, 1
        loop next_bit

        mov dl, 0Dh
        mov ah, 2
        int 21h
        mov dl, 0Ah
        int 21h

        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        ret
    print_unsigned_binary ENDP

CODE ENDS
END