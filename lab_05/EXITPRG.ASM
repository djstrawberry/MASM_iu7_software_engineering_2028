.386

PUBLIC exit_program

CODE SEGMENT PARA PUBLIC 'CODE' USE16
    ASSUME CS:CODE

    exit_program PROC NEAR
        mov ax, 4C00h
        int 21h
    exit_program ENDP

CODE ENDS
END