STK SEGMENT PARA STACK 'STACK'
    db 100 dup(0)
STK ENDS

DATA SEGMENT PARA PUBLIC 'DATA'
    A db ?
    B db ?
DATA ENDS

CODE SEGMENT PARA PUBLIC 'CODE'
    ASSUME CS:CODE, DS:DATA, SS:STK

    main:
        mov ax, DATA
        mov ds, ax

        call read_digit
        mov A, al

        call read_digit
        mov B, al

        mov al, A
        sub al, B
        add al, '0'
        mov bl, al ; на всякий случай 

        mov ah, 2
        mov dl, 13
        int 21h
        mov dl, 10
        int 21h
        mov dl, bl
        int 21h

        mov ax, 4c00h
        int 21h

    read_digit proc near
        mov ah, 1
        int 21h
        sub al, '0'
        ret
    read_digit endp
CODE ENDS
END main