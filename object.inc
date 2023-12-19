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

; 物件
OBJECT STRUCT
    box             BOX     <>  ; (24 Bytes) 物體盒
    exists          DWORD   0   ; (4 Bytes)  存在與否 (BOOL)
OBJECT ENDS

; 角色
CHARACTER STRUCT
    box             BOX     <>  ; (24 Bytes) 物體盒
    jumping         DWORD   0   ; (4 Bytes)  跳躍狀態   (0: 非跳躍狀態 | 1: 上升狀態 | 2: 下降狀態)
    jump_counter    DWORD   0   ; (4 Bytes)  上升計數器 (幀數到時，往下掉或者結束跳躍)
    lifting         DWORD   0   ; (4 Bytes)  抬腳狀態   (0: 非抬腳狀態 | 1: 左抬腳狀態 | 2: 右抬腳狀態)
    lift_counter    DWORD   0   ; (4 Bytes)  抬腳計數器 (幀數到時，換腳)
    bowing          DWORD   0   ; (4 Bytes)  彎腰狀態   (0: 非彎腰狀態 | 1: 彎腰狀態)
CHARACTER ENDS


; 變數的外部定義：使用 EXTERNDEF 關鍵字

; 小恐龍
; ****************************************
; 角色: 白色小恐龍
EXTERNDEF dino_white            :CHARACTER
; ****************************************

; 仙人掌一號
; ****************************************
; 物件: 綠色仙人掌
EXTERNDEF cactus1_green         :OBJECT
; ****************************************

; 仙人掌二號
; ****************************************
; 物件: 綠色仙人掌
EXTERNDEF cactus2_green         :OBJECT
; ****************************************

; 遊戲開始
; ****************************************
; 物件: 遊戲開始字體
EXTERNDEF game_start_str        :OBJECT
; ****************************************

; 遊戲結束
; ****************************************
; 物件: 遊戲結束字體
EXTERNDEF game_over_str         :OBJECT
; ****************************************

; 遊戲分數
; ****************************************
; 物件: 遊戲分數字體
EXTERNDEF score_str             :OBJECT
; ****************************************

; 遊戲最高分數
; ****************************************
; 物件: 遊戲最高分數字體
EXTERNDEF high_score_str        :OBJECT
; ****************************************

; 數字字體
; ****************************************
; 物件指標陣列: 數字字體
EXTERNDEF digits                :DWORD
; ****************************************

; 子程序的外部定義：宣告 PROTO 即可
BoxSetPos       PROTO box_ptr:PTR BOX, x:DWORD, y:DWORD
DetectCollision PROTO box1_ptr:PTR BOX, box2_ptr:PTR BOX
DinoSwitchJump  PROTO state:DWORD
DinoSwitchLift  PROTO state:DWORD
DinoSwitchBow   PROTO state:DWORD
DinoChangeBody  PROTO

; 巨集的定義：直接放入即可
; ...


ENDIF