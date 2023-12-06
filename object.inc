IFNDEF OBJECT_INC
OBJECT_INC EQU < 1 >

TITLE object.inc
OPTION casemap:none


; 結構的定義：直接放入即可

; 數對
PAIRS STRUCT
    X DWORD ?                   ; (4 Bytes) 
    Y DWORD ?                   ; (4 Bytes)
PAIRS ENDS                      ; (8 Bytes)

; 物體盒
BOX STRUCT
    contents_ptr    DWORD   ?   ; (4 Bytes) 內容物字串的指標 (BYTE PTR)
    attr_ptr        DWORD   ?   ; (4 Bytes) 內容物顏色的指標 (WORD PTR)
    dim             PAIRS   <>  ; (8 Bytes) X = 寬度 / Y = 高度
    pos             PAIRS   <>  ; (8 Bytes) 左下角座標
BOX ENDS                        ; (24 Bytes)

; 一般物體
OBJECT STRUCT
    box             BOX     <>  ; (24 Bytes) 物體盒
    status          DWORD   ?   ; (4 Bytes)  NotImplemented
OBJECT ENDS

; 角色
CHARACTER STRUCT
    box             BOX     <>  ; (24 Bytes) 物體盒
    status          DWORD   ?   ; (4 Bytes)  NotImplemented
CHARACTER ENDS


; 變數的外部定義：使用 EXTERNDEF 關鍵字

; 小恐龍
; ****************************************
; 角色: 綠色小恐龍
EXTERNDEF dino_green            :CHARACTER
; ****************************************

; 神奇小框
; ****************************************
; 角色: 神奇小藍框
EXTERNDEF recto_blue            :OBJECT
; ----------------------------------------
; 角色: 神奇小紅框
EXTERNDEF recto_red             :OBJECT
; ****************************************

; 仙人掌
; ****************************************
; 角色: 綠色仙人掌
EXTERNDEF cactus_green          :OBJECT
; ****************************************


; 子程序的外部定義：宣告 PROTO 即可
BoxSetPos PROTO box_ptr:PTR BOX, x:DWORD, y:DWORD


; 巨集的定義：直接放入即可
; ...


ENDIF