.386

PUBLIC print_string, print_newline, print_menu_string, print_menu_string_plain

;EXTRN number: WORD

CODE SEGMENT PARA PUBLIC 'CODE' USE16
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
        push ax
        push dx
        mov ah, 9
        int 21h
        call print_newline
        pop dx
        pop ax
        ret
    print_string ENDP

    ; Prints $-terminated string in light magenta directly to text VRAM.
    ; Input: DS:DX -> string ending with '$'
    print_menu_string PROC near
        push ax
        push bx
        push cx
        push dx
        push si
        push di
        push bp
        push es

        mov bp, dx

        ; Clear full text screen before drawing menu.
        mov ax, 0600h
        mov bh, 07h
        mov cx, 0000h
        mov dx, 184Fh
        int 10h

        mov dh, 0
        mov dl, 0
        mov ah, 02h
        mov bh, 00h
        int 10h

        mov si, bp

        mov ax, 0B800h
        mov es, ax

    next_char:
        mov al, [si]
        cmp al, '$'
        je done_print
        cmp al, 0Dh
        je do_cr
        cmp al, 0Ah
        je do_lf

        xor ax, ax
        mov al, dh
        mov bl, 80
        mul bl
        xor bx, bx
        mov bl, dl
        add ax, bx
        shl ax, 1
        mov di, ax

        mov al, [si]
        mov es:[di], al
        mov byte ptr es:[di+1], 0Dh

        inc dl
        cmp dl, 80
        jb advance_ptr
        mov dl, 0
        inc dh
        cmp dh, 25
        jb advance_ptr
        mov dh, 0

    advance_ptr:
        inc si
        jmp next_char

    do_cr:
        mov dl, 0
        inc si
        jmp next_char

    do_lf:
        inc dh
        cmp dh, 25
        jb lf_ok
        mov dh, 0
    lf_ok:
        inc si
        jmp next_char

    done_print:
        mov ah, 02h
        mov bh, 00h
        int 10h

        pop es
        pop bp
        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        ret
    print_menu_string ENDP

    ; Plain DOS menu output for debugging (no VRAM writes).
    print_menu_string_plain PROC near
        push ax
        push dx
        mov ah, 9
        int 21h
        call print_newline
        pop dx
        pop ax
        ret
    print_menu_string_plain ENDP

    print_hex_word PROC NEAR
        push ax
        push bx
        push cx
        push dx
        mov cx, 4
        mov bx, ax
    next_hex:
        rol bx, 4
        mov dl, bl
        and dl, 0Fh
        add dl, '0'
        cmp dl, '9'
        jbe print_digit
        add dl, 7          ; для A-F
    print_digit:
        mov ah, 2
        int 21h
        loop next_hex
        pop dx
        pop cx
        pop bx
        pop ax
        ret
    print_hex_word ENDP

    ; show_unsigned_binary PROC NEAR
    ; push ax
    ; push cx
    ; push dx
    ; push bx

    ; mov ax, word ptr [number]
    ; mov cx, 16
    ; mov bx, 8000h

    ; next_bit:
    ;     test ax, bx
    ;     jz print_zero
    ;     mov dl, '1'
    ;     jmp print_char
    ; print_zero:
    ;     mov dl, '0'
    ; print_char:
    ;     mov ah, 2
    ;     int 21h
    ;     shr bx, 1       ; сдвигаем маску вправо
    ;     loop next_bit

    ;     call print_newline

    ;     pop bx
    ;     pop dx
    ;     pop cx
    ;     pop ax
    ;     ret
    ; show_unsigned_binary ENDP

CODE ENDS
END