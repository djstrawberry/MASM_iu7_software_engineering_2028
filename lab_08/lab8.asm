.386
.model flat, stdcall
option casemap: none

include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc
include \masm32\include\gdi32.inc
include \masm32\include\masm32.inc

includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\gdi32.lib
includelib \masm32\lib\masm32.lib

WinMain proto :DWORD, :DWORD, :DWORD, :DWORD

.data
    ClassName db "lab_08", 0
    EditClassName db "edit", 0
    BtnClassName db "button", 0
    StaticClassName db "static", 0
    AppName db "LAB 08", 0

    BtnText db "Посчитать единицы:", 0
    PromptText db "Введите число:", 0
    ResultPrefix db "Кол-во единиц: ", 0

    FontName db "Verdana", 0
    ColorLilac dd 00F5D1FFh
    ColorDarkPurple dd 0082004Bh

.data?
    hInstance HINSTANCE ?
    hwndEdit HWND ?
    hwndButton HWND ?
    hwndResult HWND ?
    hLilacBrush HBRUSH ?
    hFont HFONT ?

    inputBuffer db 256 dup(?)
    tempBuffer db 256 dup(?)
    outputBuffer db 256 dup(?)

.code
start:
    invoke GetModuleHandle, NULL
    mov hInstance, eax

    invoke CreateSolidBrush, ColorLilac
    mov hLilacBrush, eax
    invoke CreateFont, 18, 0, 0, 0, FW_NORMAL, FALSE, FALSE, FALSE, \
                      DEFAULT_CHARSET, OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS, \
                      DEFAULT_QUALITY, DEFAULT_PITCH or FF_SWISS, addr FontName
    mov hFont, eax

    invoke WinMain, hInstance, NULL, NULL, SW_SHOWDEFAULT

    invoke DeleteObject, hLilacBrush
    invoke DeleteObject, hFont

    invoke ExitProcess, eax

WinMain PROC hInst:HINSTANCE, hPrevInst:HINSTANCE, CmdLine:LPSTR, CmdShow:DWORD
    LOCAL wc:WNDCLASSEX
    LOCAL msg:MSG
    LOCAL hwnd:HWND

    mov wc.cbSize, SIZEOF WNDCLASSEX
    mov wc.style, CS_HREDRAW or CS_VREDRAW
    mov wc.lpfnWndProc, OFFSET WndProc
    mov wc.cbClsExtra, NULL
    mov wc.cbWndExtra, NULL

    mov eax, hInstance
    mov wc.hInstance, eax
    mov eax, hLilacBrush
    mov wc.hbrBackground, eax

    mov wc.lpszMenuName, NULL
    mov wc.lpszClassName, OFFSET ClassName

    invoke LoadIcon, NULL, IDI_APPLICATION
    mov wc.hIcon, eax
    mov wc.hIconSm, eax
    invoke LoadCursor, NULL, IDC_ARROW
    mov wc.hCursor, eax

    invoke RegisterClassEx, ADDR wc 

    invoke CreateWindowEx, NULL, ADDR ClassName, ADDR AppName, \
           WS_OVERLAPPEDWINDOW, CW_USEDEFAULT, CW_USEDEFAULT, \
           350, 250, NULL, NULL, hInst, NULL
    mov hwnd, eax

    invoke ShowWindow, hwnd, SW_SHOWNORMAL
    invoke UpdateWindow, hwnd

    .WHILE TRUE
        invoke GetMessage, ADDR msg, NULL, 0, 0
        .BREAK .IF (!eax)
        invoke TranslateMessage, ADDR msg
        invoke DispatchMessage, ADDR msg
    .ENDW
    mov eax, msg.wParam
    ret
WinMain ENDP
    
WndProc proc hwnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
    LOCAL bitCount:DWORD
    LOCAL hwndTemp:HWND

    .IF uMsg == WM_CREATE
        ; Number input prompt
        invoke CreateWindowEx, 0, ADDR StaticClassName, ADDR PromptText, \
               WS_CHILD or WS_VISIBLE, 30, 20, 200, 20, hwnd, 101, hInstance, NULL
        mov hwndTemp, eax
        invoke SendMessage, hwndTemp, WM_SETFONT, hFont, TRUE
        
        ; Number input field
        invoke CreateWindowEx, WS_EX_CLIENTEDGE, ADDR EditClassName, NULL, \
               WS_CHILD or WS_VISIBLE or WS_BORDER or ES_NUMBER, \
               30, 45, 270, 25, hwnd, 102, hInstance, NULL
        mov hwndEdit, eax
        invoke SendMessage, hwndEdit, WM_SETFONT, hFont, TRUE
        
        ; Set limits
        invoke SendMessage, hwndEdit, EM_LIMITTEXT, 10, 0

        ; Button
        invoke CreateWindowEx, 0, ADDR BtnClassName, ADDR BtnText, \
               WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON, \
               30, 85, 200, 35, hwnd, 103, hInstance, NULL
        mov hwndButton, eax
        invoke SendMessage, hwndButton, WM_SETFONT, hFont, TRUE

        ; Output
        invoke CreateWindowEx, 0, ADDR StaticClassName, NULL, \
               WS_CHILD or WS_VISIBLE, 30, 140, 270, 25, hwnd, 104, hInstance, NULL
        mov hwndResult, eax
        invoke SendMessage, hwndResult, WM_SETFONT, hFont, TRUE
        
    .ELSEIF uMsg == WM_CTLCOLORSTATIC
        invoke SetTextColor, wParam, ColorDarkPurple
        invoke SetBkColor, wParam, ColorLilac
        mov eax, hLilacBrush
        ret

    .ELSEIF uMsg == WM_COMMAND
        mov eax, wParam
        .IF ax == 103
            invoke GetWindowText, hwndEdit, ADDR inputBuffer, 256
            invoke atodw, ADDR inputBuffer

            mov bitCount, 0
            .WHILE eax != 0
                shr eax, 1
                adc bitCount, 0
            .ENDW

            invoke dwtoa, bitCount, ADDR tempBuffer
            invoke szCopy, ADDR ResultPrefix, ADDR outputBuffer
            invoke szCatStr, ADDR outputBuffer, ADDR tempBuffer

            invoke SetWindowText, hwndResult, ADDR outputBuffer
        .ENDIF

    .ELSEIF uMsg == WM_DESTROY
        invoke PostQuitMessage, NULL
    .ELSE
        invoke DefWindowProc, hwnd, uMsg, wParam, lParam
        ret
    .ENDIF
    xor eax, eax
    ret
WndProc ENDP
END start