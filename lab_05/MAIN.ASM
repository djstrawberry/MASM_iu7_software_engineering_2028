.386

PUBLIC number

EXTRN input_signed_decimal: NEAR
EXTRN print_unsigned_binary: NEAR
EXTRN print_signed_hex_truncated: NEAR
EXTRN find_min_power_of_2_above: NEAR
EXTRN print_string: NEAR

DATA SEGMENT PARA PUBLIC 'DATA'
    number dw 0

    menu_prompt db 13, 10, '===== MENU =====', 13, 10
             db '1. Input signed decimal number', 13, 10
             db '2. Print unsigned binary', 13, 10
             db '3. Print truncated signed hex (8-bit)', 13, 10
             db '4. Find min power of two above', 13, 10
             db '5. Exit :(', 13, 10
             db 'Your choice: $'

    error_msg db 'Invalid choice. Read the menu, please!', 13, 10, '$'

    proc_table dw OFFSET read_signed_decimal
               dw OFFSET print_unsigned_binary
               dw OFFSET print_signed_hex_truncated
               dw OFFSET find_min_power_of_2_above
               dw OFFSET exit_program
DATA ENDS

CODE SEGMENT PARA PUBLIC 'CODE'
    ASSUME DS:DATA, CS:CODE

    main PROC:
        mov ax, DATA
        mov ds, ax

        main_loop:
            ; Display menu
            lea dx, menu_prompt
            call print_string

            ; Get user choice
            mov ah, 1
            int 21h
            sub al, '0' 

            ; Validate choice
            cmp al, 1
            jb invalid_choice
            cmp al, 5
            ja invalid_choice

            ; Call the corresponding procedure from the table
            dec al
            mov bl, al 
            xor bh, bh      
            shl bx, 1
            call [proc_table + bx]

            jmp main_loop

        invalid_choice:
            lea dx, error_msg
            call print_string
            jmp main_loop
    main ENDP   

    exit_program PROC NEAR
        mov ax, 4C00h
        int 21h
    exit_program ENDP
    
CODE ENDS
END main