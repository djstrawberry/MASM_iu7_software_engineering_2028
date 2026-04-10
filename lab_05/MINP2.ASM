.386

PUBLIC find_min_power_of_2_above

EXTRN number: WORD

CODE SEGMENT PARA PUBLIC 'CODE' USE16
    ASSUME CS:CODE

    find_min_power_of_2_above PROC NEAR
        push ax
        push cx
        push dx

        ; Unsigned input value from MAIN.DATA.
        mov ax, word ptr [number]

        ; k = minimal exponent such that 2^k > n (unsigned).
        ; For n=0 -> k=0; for n>0 -> k = bit_length(n), range 1..16.
        xor cx, cx
        cmp ax, 0
        je print_decimal

    count_bits:
        shr ax, 1
        inc cx
        cmp ax, 0
        jne count_bits

    print_decimal:
        ; cx in [0..16], print as decimal.
        mov al, cl
        cmp al, 10
        jb print_ones

        mov dl, '1'
        call emit_char
        sub al, 10

    print_ones:
        add al, '0'
        mov dl, al
        call emit_char

    print_eol:
        mov dl, 0Dh
        call emit_char
        mov dl, 0Ah
        call emit_char

        pop dx
        pop cx
        pop ax
        ret

    emit_char:
        push ax
        mov ah, 2
        int 21h
        pop ax
        ret
    find_min_power_of_2_above ENDP

CODE ENDS
END