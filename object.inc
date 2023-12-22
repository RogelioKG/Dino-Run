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
    contents_ptr    DWORD   ?   ; (4 Bytes)  內容物字串的指標 (BYTE PTR)
    attr_ptr        DWORD   ?   ; (4 Bytes)  內容物顏色的指標 (WORD PTR)
    dim             PAIRS   <>  ; (8 Bytes)  X = 寬度 / Y = 高度
    pos             PAIRS   <>  ; (8 Bytes)  左下角座標
BOX ENDS                        ; (24 Bytes)

; 小恐龍
DINO STRUCT
    box             BOX     <>  ; (24 Bytes) 物體盒
    jumping         DWORD   0   ; (4 Bytes)  跳躍狀態   (0: 非跳躍狀態 | 1: 上升狀態 | 2: 下降狀態)
    jump_counter    DWORD   0   ; (4 Bytes)  上升計數器 (幀數到時，往下掉或者結束跳躍)
    lifting         DWORD   0   ; (4 Bytes)  抬腳狀態   (0: 非抬腳狀態 | 1: 左抬腳狀態 | 2: 右抬腳狀態)
    lift_counter    DWORD   0   ; (4 Bytes)  抬腳計數器 (幀數到時，換腳)
    bowing          DWORD   0   ; (4 Bytes)  彎腰狀態   (0: 非彎腰狀態 | 1: 彎腰狀態)
DINO ENDS

; 靜態敵人
STATIC_ENEMY STRUCT
    box             BOX     <>  ; (24 Bytes) 物體盒
    _undefined      DWORD   0   ; (4 Bytes)  Not Implemented
STATIC_ENEMY ENDS

; 動態敵人
DYNAMIC_ENEMY STRUCT
    box             BOX     <>  ; (24 Bytes) 物體盒
    status          DWORD   1   ; (4 Bytes)  鳥: 展翅狀態 (1: 向上展翅狀態 | 2: 向下展翅狀態)
                                ;            ...
    status_counter  DWORD   0   ; (4 Bytes)  狀態計數器
    next            DWORD   ?   ; (4 Bytes)  儲存下一狀態的 contents_ptr
DYNAMIC_ENEMY ENDS

; 物件
OBJECT STRUCT
    box             BOX     <>  ; (24 Bytes) 物體盒
    _undefined      DWORD   0   ; (4 Bytes)  Not Implemented
OBJECT ENDS

; 變數的外部定義：使用 EXTERNDEF 關鍵字

; ****************************************
; 小恐龍: 白色小恐龍
EXTERNDEF dino_white            :DINO
; ****************************************

; ****************************************
; 靜態敵人: 綠色仙人掌一號
EXTERNDEF cactus1_green         :STATIC_ENEMY
; ****************************************

; 仙人掌二號
; ****************************************
; 靜態敵人: 綠色仙人掌二號
EXTERNDEF cactus2_green         :STATIC_ENEMY
; ****************************************

; 鳥一號
; ****************************************
; 動態敵人: 棕色鳥一號
EXTERNDEF bird1_brown           :DYNAMIC_ENEMY
; ****************************************

; UFO一號
; ****************************************
; 動態敵人: 藍色UFO一號
EXTERNDEF ufo1_blue             :DYNAMIC_ENEMY
; ****************************************

; 遊戲名稱1
; ****************************************
; 物件: 遊戲開始文字
EXTERNDEF game_title1_str       :OBJECT
; ****************************************

; 遊戲名稱2
; ****************************************
; 物件: 遊戲開始文字
EXTERNDEF game_title2_str       :OBJECT
; ****************************************

; 遊戲開始
; ****************************************
; 物件: 遊戲開始文字
EXTERNDEF game_start_str        :OBJECT
; ****************************************

; 遊戲重新開始
; ****************************************
; 物件: 遊戲重新開始文字
EXTERNDEF game_restart_str      :OBJECT
; ****************************************

; 遊戲結束
; ****************************************
; 物件: 遊戲結束文字
EXTERNDEF game_over_str         :OBJECT
; ****************************************

; 遊戲分數
; ****************************************
; 物件: 遊戲分數文字
EXTERNDEF score_str             :OBJECT
; ****************************************

; 遊戲最高分數
; ****************************************
; 物件: 遊戲最高分數文字
EXTERNDEF high_score_str        :OBJECT
; ****************************************

; 空白鍵操作提示
; ****************************************
; 物件: 空白鍵操作提示文字
EXTERNDEF hint_space_str        :OBJECT
; ****************************************

; 左右鍵操作提示
; ****************************************
; 物件: 跳脫鍵操作提示文字
EXTERNDEF hint_rightleft_str    :OBJECT
; ****************************************

; 下鍵操作提示
; ****************************************
; 物件: 跳脫鍵操作提示文字
EXTERNDEF hint_down_str         :OBJECT
; ****************************************

; 跳脫鍵操作提示
; ****************************************
; 物件: 跳脫鍵操作提示文字
EXTERNDEF hint_esc_str          :OBJECT
; ****************************************

; 數字
; ****************************************
; OBJECT PTR 陣列: 數字文字
EXTERNDEF digits                :DWORD
; ****************************************

; 子程序的外部定義：宣告 PROTO 即可
BoxSetPos               PROTO box_ptr:PTR BOX, x:DWORD, y:DWORD
DetectCollision         PROTO box1_ptr:PTR BOX, box2_ptr:PTR BOX
DinoSwitchJump          PROTO state:DWORD
DinoSwitchLift          PROTO state:DWORD
DinoSwitchBow           PROTO state:DWORD
DinoChangeBody          PROTO
DynamicEnemyChangeBody  PROTO enemy_ptr:PTR DYNAMIC_ENEMY
ChangeColor             PROTO box_ptr:PTR BOX, color:WORD

; 巨集的定義：直接放入即可
; ...


ENDIF