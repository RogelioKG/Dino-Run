TITLE draw.inc
OPTION casemap:none

; 結構的定義：直接放入即可
; ...


; 變數的外部定義：使用 EXTERNDEF 關鍵字
EXTERNDEF output_handle:HANDLE

; 子程序的外部定義：宣告 PROTO 即可
DrawBox PROTO, box:Box


; 巨集的定義：直接放入即可
mOutputInit MACRO
    LOCAL info
    LOCAL buffer_size
    .data
    info CONSOLE_CURSOR_INFO < 0, 0 >
    .code
    INVOKE GetStdHandle, STD_OUTPUT_HANDLE                  ; 獲取 output handle
    mov output_handle, eax
    INVOKE SetConsoleCursorInfo, output_handle, ADDR info   ; 隱藏游標
ENDM