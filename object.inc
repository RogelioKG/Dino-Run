TITLE object.inc
OPTION casemap:none


; 結構的定義：直接放入即可

; 4 Bytes COORD
; (2 Bytes 存取經常發生問題)
PAIRS STRUCT
    X DWORD ?
    Y DWORD ?
PAIRS ENDS

; 物體盒
Box STRUCT
    contents_ptr    DWORD   ?   ; (4 Bytes) 內容物字串的指標 (BYTE PTR)
    attr_ptr        DWORD   ?   ; (4 Bytes) 內容物顏色的指標 (WORD PTR)
    dim             PAIRS   <>  ; (8 Bytes) 高度
    pos             PAIRS   <>  ; (8 Bytes) 左下角座標
Box ENDS                        ; (24 Bytes)

; 一般物體
Object STRUCT
    box             Box     <>  ; (24 Bytes) 物體盒
    status          DWORD   ?   ; (4 Bytes)  NotImplemented
Object ENDS

; 角色
Character STRUCT
    box             Box     <>  ; (24 Bytes) 物體盒
    status          DWORD   ?   ; (4 Bytes)  NotImplemented
Character ENDS


; 變數的外部定義：使用 EXTERNDEF 關鍵字

; 小恐龍
; ****************************************
; 尺寸
EXTERNDEF dino_xdim             :ABS
EXTERNDEF dino_ydim             :ABS
; ----------------------------------------
; 角色: 綠色小恐龍
EXTERNDEF dino_green            :Character
EXTERNDEF dino_attribute_green  :WORD
; ----------------------------------------
; 內容物
EXTERNDEF dino_contents         :BYTE
; ****************************************

; 神奇小框
; ****************************************
; 尺寸
EXTERNDEF recto_xdim            :ABS
EXTERNDEF recto_ydim            :ABS
; ----------------------------------------
; 角色: 神奇小藍框
EXTERNDEF recto_blue            :Object
EXTERNDEF recto_attribute_blue  :WORD
; ----------------------------------------
; 角色: 神奇小紅框
EXTERNDEF recto_red             :Object
EXTERNDEF recto_attribute_red   :WORD
; ----------------------------------------
; 內容物
EXTERNDEF recto_contents        :BYTE
; ****************************************

; 仙人掌
; ****************************************
; 尺寸
EXTERNDEF cactus_xdim           :ABS
EXTERNDEF cactus_ydim           :ABS
; ----------------------------------------
; 角色: 綠色仙人掌
EXTERNDEF cactus_green          :Object
EXTERNDEF cactus_attribute_green:WORD
; ----------------------------------------
; 內容物
EXTERNDEF cactus_contents       :BYTE
; ****************************************


; 子程序的外部定義：宣告 PROTO 即可
; ...


; 巨集的定義：直接放入即可
mRectoBlueInit MACRO x:REQ, y:REQ
    .code
    mov recto_blue.box.pos.X, x
    mov recto_blue.box.pos.Y, y
    mov recto_blue.status, 0
ENDM

mRectoRedInit MACRO x:REQ, y:REQ
    .code
    mov recto_red.box.pos.X, x
    mov recto_red.box.pos.Y, y
    mov recto_red.status, 0
ENDM

mDinoGreenInit MACRO x:REQ, y:REQ
    .code
    mov dino_green.box.pos.X, x
    mov dino_green.box.pos.Y, y
    mov dino_green.status, 0
ENDM

mCactusGreenInit MACRO x:REQ, y:REQ
    .code
    mov cactus_green.box.pos.X, x
    mov cactus_green.box.pos.Y, y
    mov cactus_green.status, 0
ENDM