public print_string

CODE SEGMENT PARA PUBLIC 'CODE'
    assume CS:CODE

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

CODE ENDS
END