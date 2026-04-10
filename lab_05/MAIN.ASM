.386

PUBLIC number

EXTRN print_string: NEAR
EXTRN print_menu_string: NEAR
EXTRN print_menu_string_plain: NEAR
EXTRN input_digit: NEAR
EXTRN input_signed_decimal: NEAR
EXTRN print_unsigned_binary: NEAR
EXTRN print_signed_hex_truncated: NEAR
EXTRN find_min_power_of_2_above: NEAR
EXTRN exit_program: NEAR

DATA SEGMENT PARA PUBLIC 'DATA' USE16
    number dw 0
    selected_choice db 0

    menu_prompt db 13, 10, '+----------------------------------------------------------+', 13, 10
             db '|                           MENU                           |', 13, 10
             db '+----------------------------------------------------------+', 13, 10
             db '| 1 | Input signed decimal number                          |', 13, 10
             db '| 2 | Print unsigned binary                                |', 13, 10
             db '| 3 | Print truncated signed hex (8-bit)                   |', 13, 10
             db '| 4 | Find min power of two above number                   |', 13, 10
             db '| 5 | Exit :(                                              |', 13, 10
             db '+----------------------------------------------------------+', 13, 10
             db 'Your choice: $'

    error_msg db 'Invalid choice. Please read the menu :).', 13, 10, '$'
    proc_table dw 5 dup (?)
DATA ENDS

CODE SEGMENT PARA PUBLIC 'CODE' USE16
    ASSUME DS:DATA, CS:CODE

    main PROC NEAR
        mov ax, DATA
        mov ds, ax

        mov word ptr proc_table, OFFSET input_signed_decimal
        mov word ptr proc_table + 2, OFFSET print_unsigned_binary
        mov word ptr proc_table + 4, OFFSET print_signed_hex_truncated
        mov word ptr proc_table + 6, OFFSET find_min_power_of_2_above
        mov word ptr proc_table + 8, OFFSET exit_program

        main_loop:
            mov ax, DATA
            mov ds, ax

            ; Display menu
            lea dx, menu_prompt
            call print_menu_string_plain

            ; Get user choice
            call input_digit

            ; Validate choice
            cmp al, 1
            jb invalid_choice
            cmp al, 5
            ja invalid_choice

            mov selected_choice, al
            xor bx, bx
            mov bl, selected_choice
            dec bl
            shl bx, 1

            ; Required by task: array-indexed dispatch by menu index.
            push ds
            call word ptr [proc_table + bx]
            pop ds

            cmp selected_choice, 1
            jne skip_store_number
            mov word ptr [number], ax

        skip_store_number:

            mov ax, DATA
            mov ds, ax

            jmp main_loop

        invalid_choice:
            lea dx, error_msg
            call print_string
            jmp main_loop
    main ENDP
    
CODE ENDS
END main