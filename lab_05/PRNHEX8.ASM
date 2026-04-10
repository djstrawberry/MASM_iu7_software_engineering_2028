.386

PUBLIC print_signed_hex_truncated

EXTRN number: WORD

CODE SEGMENT PARA PUBLIC 'CODE' USE16
    ASSUME CS:CODE

    print_signed_hex_truncated PROC NEAR
        push ax
        push bx
        push dx

        ; Truncate to 8 bits and interpret as signed char.
        mov al, byte ptr [number]
        cbw

        cmp ax, 0
        jge print_value

        push ax
        mov dl, '-'
        mov ah, 2
        int 21h
        pop ax
        neg ax

    print_value:
        mov bl, al

        ; High nibble.
        mov dl, bl
        shr dl, 4
        call print_nibble

        ; Low nibble.
        mov dl, bl
        and dl, 0Fh
        call print_nibble

        mov dl, 0Dh
        mov ah, 2
        int 21h
        mov dl, 0Ah
        int 21h

        pop dx
        pop bx
        pop ax
        ret

    print_nibble:
        add dl, '0'
        cmp dl, '9'
        jbe emit_nibble
        add dl, 7
    emit_nibble:
        push ax
        mov ah, 2
        int 21h
        pop ax
        ret
    print_signed_hex_truncated ENDP

CODE ENDS
END