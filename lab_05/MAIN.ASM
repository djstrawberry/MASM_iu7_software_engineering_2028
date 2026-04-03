.386

PUBLIC number

; Temporary: menu handlers are stubbed locally until real implementations are ready.
; EXTRN input_signed_decimal: NEAR
; EXTRN print_unsigned_binary: NEAR
; EXTRN print_signed_hex_truncated: NEAR
; EXTRN find_min_power_of_2_above: NEAR
EXTRN print_string: NEAR
EXTRN print_menu_string: NEAR
EXTRN input_digit: NEAR

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
    selected_msg db 13, 10, 'Selected option: $'
    continue_msg db 'Press any key to continue...$'

    proc_table dw OFFSET read_signed_decimal
               dw OFFSET print_unsigned_binary
               dw OFFSET print_signed_hex_truncated
               dw OFFSET find_min_power_of_2_above
               dw OFFSET exit_program
DATA ENDS

CODE SEGMENT PARA PUBLIC 'CODE' USE16
    ASSUME DS:DATA, CS:CODE

    main PROC NEAR
        mov ax, DATA
        mov ds, ax

        main_loop:
            ; Display menu
            lea dx, menu_prompt
            call print_menu_string

            ; Get user choice
            call input_digit

            ; Validate choice
            cmp al, 1
            jb invalid_choice
            cmp al, 5
            ja invalid_choice

            mov selected_choice, al

            lea dx, selected_msg
            mov ah, 09h
            int 21h

            mov dl, selected_choice
            add dl, '0'
            mov ah, 02h
            int 21h

            mov dl, 0Dh
            mov ah, 02h
            int 21h
            mov dl, 0Ah
            int 21h

            lea dx, continue_msg
            call print_string
            mov ah, 08h
            int 21h

            mov al, selected_choice

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
            lea dx, continue_msg
            call print_string
            mov ah, 08h
            int 21h
            jmp main_loop
    main ENDP   

    read_signed_decimal PROC NEAR
        ret
    read_signed_decimal ENDP

    print_unsigned_binary PROC NEAR
        ret
    print_unsigned_binary ENDP

    print_signed_hex_truncated PROC NEAR
        ret
    print_signed_hex_truncated ENDP

    find_min_power_of_2_above PROC NEAR
        ret
    find_min_power_of_2_above ENDP

    exit_program PROC NEAR
        mov ax, 4C00h
        int 21h
    exit_program ENDP
    
CODE ENDS
END main