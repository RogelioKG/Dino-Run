IFNDEF DRAW_INC
DRAW_INC EQU < 1 >

TITLE draw.inc
OPTION casemap:none


; 結構的定義：直接放入即可
; ...


; 變數的外部定義：使用 EXTERNDEF 關鍵字
; ...


; 子程序的外部定義：宣告 PROTO 即可
OutputInit PROTO
DrawBox    PROTO box:BOX
DrawScore  PROTO score:DWORD, x:DWORD, y:DWORD

; 巨集的定義：直接放入即可
; ...

ENDIF