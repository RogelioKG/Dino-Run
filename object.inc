TITLE object.inc
OPTION casemap:none

; 結構的定義：直接放入即可

; 物體盒
Box STRUCT
    contents_ptr    DWORD   ?   ; (4 Bytes) 內容物字串的指標 (BYTE PTR)
    attr_ptr        DWORD   ?   ; (4 Bytes) 內容物屬性的指標 (WORD PTR)
    pos             COORD   <>  ; (4 Bytes) 左上角位置
    xdim            DWORD   ?   ; (4 Bytes) 寬度
    ydim            DWORD   ?   ; (4 Bytes) 高度
Box ENDS                        ; (20 Bytes)

; 神奇小框
RectBuddy STRUCT
    box             Box     <>  ; (20 Bytes) 物體盒
    status          DWORD   ?   ; (4 Bytes)  NotImplemented
RectBuddy ENDS

; 小恐龍
Dino STRUCT
    box             Box     <>  ; (20 Bytes) 物體盒
    status          DWORD   ?   ; (4 Bytes)  NotImplemented
Dino ENDS


; 變數的外部定義：使用 EXTERNDEF 關鍵字

; 神奇小框
; ****************************************
; 尺寸
EXTERNDEF recto_xdim            :ABS
EXTERNDEF recto_ydim            :ABS
; ----------------------------------------
; 角色: 神奇小藍框
EXTERNDEF recto_blue            :RectBuddy
EXTERNDEF recto_attribute_blue  :WORD
; ----------------------------------------
; 角色: 神奇小紅框
EXTERNDEF recto_red             :RectBuddy
EXTERNDEF recto_attribute_red   :WORD
; ----------------------------------------
; 內容物
EXTERNDEF recto_contents        :BYTE
; ****************************************

; 小恐龍
; ****************************************
; 尺寸
EXTERNDEF dino_xdim             :ABS
EXTERNDEF dino_ydim             :ABS
; ----------------------------------------
; 角色: 綠色小恐龍
EXTERNDEF dino_green            :RectBuddy
EXTERNDEF dino_attribute_green  :WORD
; ----------------------------------------
; 內容物
EXTERNDEF dino_contents         :BYTE
; ****************************************


; 子程序的外部定義：宣告 PROTO 即可
; ...


; 巨集的定義：直接放入即可
mRectoBlueInit MACRO x:REQ, y:REQ
    .code
    mov recto_blue.box.contents_ptr, OFFSET recto_contents
    mov recto_blue.box.attr_ptr, OFFSET recto_attribute_blue
    mov recto_blue.box.pos.X, x
    mov recto_blue.box.pos.Y, y
    mov recto_blue.box.xdim, recto_xdim 
    mov recto_blue.box.ydim, recto_ydim
    mov recto_blue.status, 0
ENDM

mRectoRedInit MACRO x:REQ, y:REQ
    .code
    mov recto_red.box.contents_ptr, OFFSET recto_contents
    mov recto_red.box.attr_ptr, OFFSET recto_attribute_red
    mov recto_red.box.pos.X, x
    mov recto_red.box.pos.Y, y
    mov recto_red.box.xdim, recto_xdim 
    mov recto_red.box.ydim, recto_ydim
    mov recto_red.status, 0
ENDM

mDinoGreenInit MACRO x:REQ, y:REQ
    .code
    mov dino_green.box.contents_ptr, OFFSET dino_contents
    mov dino_green.box.attr_ptr, OFFSET dino_attribute_green
    mov dino_green.box.pos.X, x
    mov dino_green.box.pos.Y, y
    mov dino_green.box.xdim, dino_xdim 
    mov dino_green.box.ydim, dino_ydim
    mov dino_green.status, 0
ENDM