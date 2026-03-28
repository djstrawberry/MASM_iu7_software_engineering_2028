PUBLIC rows, cols, matrix
EXTRN print_string:NEAR, input_number:NEAR, input_matrix:NEAR, print_matrix:NEAR, process_matrix:NEAR

DC SEGMENT PARA PUBLIC 'DATA'

    rows db ?
    cols db ?
    matrix db 9 * 9 dup (?)

    msg_enter_rows db 'Enter number of rows (1-9): $'
    msg_enter_cols db 'Enter number of columns (1-9): $'
    msg_enter_matrix db 'Enter matrix elements (0-9): $'
    msg_before db 'Input matrix:$'
    msg_after db 'Processed matrix:$'

DC ENDS

CODE SEGMENT PARA PUBLIC 'CODE'
    ASSUME DS:DC, CS:CODE

    main PROC

        mov ax, DC
        mov ds, ax

        ; Get number of rows and columns from user
        lea dx, msg_enter_rows
        call print_string
        call input_number
        mov rows, al

        lea dx, msg_enter_cols
        call print_string
        call input_number
        mov cols, al

        ; Get matrix elements from user
        lea dx, msg_enter_matrix
        call print_string
        call input_matrix

        ; Print the original matrix
        lea dx, msg_before
        call print_string
        call print_matrix

        ; Process the matrix
        call process_matrix

        ; Print the processed matrix
        lea dx, msg_after
        call print_string
        call print_matrix

        mov ax, 4C00h
        int 21h
    main ENDP
CODE ENDS
END main