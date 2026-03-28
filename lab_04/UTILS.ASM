public calc_shift

CODE SEGMENT PARA PUBLIC 'CODE'
    assume cs:CODE

    calc_shift PROC near
        mov ax, si
        mov bl, 9
        mul bl
        add ax, di
        mov bx, ax
        ret
    calc_shift ENDP

CODE ENDS

END
