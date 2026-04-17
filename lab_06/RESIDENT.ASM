.MODEL TINY
.CODE
org 100h

    ; Entry point of the program
    main proc far
        jmp init
    main endp

    ; -------------------------
    ; Resident code starts here
    ; --------------------------
    ; Resident data
    old_1C_offset dw 0
    old_1C_segment dw 0
    tick_counter db 0
    speed db 0

    ; Autorepeat params
    speed_table LABEL BYTE
        db 00000000b 
        db 00100100b
        db 01001000b
        db 01101100b
        db 10010000b
        db 10110100b
        db 11011000b
        db 11111111b
    table_size EQU 8

    ; New interrupt handler for 1Ch
    new_1C_handler proc far
        push ax
        push bx
        push cx
        push dx
        push ds

        push cs
        pop ds

        ; Increment tick counter
        inc tick_counter
        cmp tick_counter, 18
        jb exit_to_old_handler

        mov tick_counter, 0 ; One second has passed, reset counter
        xor bh, bh
        mov bl, speed
        
        ; ---------------------------------------------------------------
        ; Send command to keyboard controller to set new autorepeat speed
        ; ---------------------------------------------------------------
        call wait_for_keyboard  ; Wait for keyboard to be ready to accept command
        mov al, 0F3h            ; Command: set autorepeat speed
        out 60h, al
        call wait_for_ack       ; Read acknowledgment from keyboard

        call wait_for_keyboard  
        mov al, cs:speed_table[bx] ; Parameter for autorepeat speed
        out 60h, al
        call wait_for_ack  

        ; Increment speed and check if it has reached the maximum
        inc speed
        cmp speed, table_size
        jb exit_to_old_handler
        mov speed, 0 ; Reset speed after reaching max

    exit_to_old_handler:
        ; Call the old handler
        pop ds 
        pop dx
        pop cx  
        pop bx 
        pop ax

        jmp dword ptr cs:old_1C_offset ; Jump to the old handler
    
    new_1C_handler endp

    ; -----------------------------
    ; Wait for keyboard to be ready 
    ; -----------------------------
    wait_for_keyboard proc near
        push ax
        wait_loop:
            in al, 64h 
            test al, 00000010b ; Buffer is empty (ready to accept command)
            jnz wait_loop 
        pop ax
        ret
    wait_for_keyboard endp

    ; -----------------------------
    ; Чтение подтверждения от клавиатуры (ACK)
    ; -----------------------------
    wait_for_ack proc near
        push ax
        push cx
        mov cx, 0FFFFh         ; Таймаут, чтобы не зависнуть намертво, если клавиатура не ответит
    ack_loop:
        in al, 64h
        test al, 00000001b     ; Бит 0 = 1 означает, что буфер ВЫВОДА полон (есть данные для чтения)
        jnz read_port
        loop ack_loop          ; Если данных нет, ждем
        jmp done_ack
    read_port:
        in al, 60h             ; Читаем байт (очищаем буфер контроллера)
    done_ack:
        pop cx
        pop ax
        ret
    wait_for_ack endp

    resident_end LABEL BYTE

    ; -------------------------------------------------------
    ; Initialization code to set up the new interrupt handler
    ; -------------------------------------------------------
    init proc near
        push cs
        pop ds
        ; Save old interrupt vector
        mov ax, 351Ch
        int 21h
        mov word ptr old_1C_offset, bx
        mov word ptr old_1C_segment, es

        ; Set new interrupt vector for 1Ch
        mov ax, 251Ch
        mov dx, offset new_1C_handler
        int 21h

        ; Output message to indicate resident code is active
        lea dx, resident_msg
        call print_string

        ; Return to main program
        mov dx, offset resident_end
        int 27h ; Terminate and stay resident
    init endp

    resident_msg db 'Now your laptop has a RESIDENT. Be afraid...$'

    print_string proc near
        mov ah, 09h
        int 21h
        ret
    print_string endp

END main