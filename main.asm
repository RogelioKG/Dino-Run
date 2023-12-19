TITLE main.asm
OPTION casemap:none

; third-party library
INCLUDE Irvine32.inc
INCLUDE Macros.inc

; local library
INCLUDE object.inc
INCLUDE draw.inc

mStartGame MACRO
    mov score, 0                                      ; 分數重置
    INVOKE BoxSetPos, ADDR dino_white.box, 20, ground ; 小恐龍座標重置
    mov is_jumping, 0                                 ; 小恐龍上升狀態重置
    mov jump_counter, 0                               ; 小恐龍上升計數器重置
ENDM

.data
; 遊戲
ground          WORD    127
game_mode       DWORD   0   ; 0: 初始模式, 1: 遊玩模式, 2: 暫停模式, 3 結束模式

; 小恐龍
is_jumping      DWORD   0   ; 0: 非跳躍狀態, 1: 上升狀態, 2: 下降狀態
jump_height     DWORD   6   ; 小恐龍每次更新上升高度
jump_times      DWORD   12  ; 小恐龍上升回合
jump_counter    DWORD   0   ; 小恐龍上升計數器
lr_move         DWORD   5   ; 小恐龍左右移動
l_move_boundary DWORD   10  ; 小恐龍左移邊界
r_move_boundary DWORD   300 ; 小恐龍右移邊界

; 仙人掌
is_cactus       DWORD   0   ; 0: 仙人掌尚未出現, 1: 仙人掌已出現
cactus_move     DWORD   10  ; 仙人掌向左移動
cactus_range    DWORD   30  ; 仙人掌出現隨機範圍
cactus_initial  DWORD   0   ; 仙人掌出現初始範圍 (偏移量)
cactus_random1  DWORD   0   ; 仙人掌隨機出現

; 計分
score           DWORD   0   ; 目前分數 (7位數)
high_score      DWORD   0   ; 歷史最高分數 (7位數)
last_digit_x    DWORD   510 ; score 的 X 座標 (最後一位數左下角)
score_y         DWORD   30  ; score 的 Y 座標
high_score_y    DWORD   20  ; high_score 的 Y 座標


.code
main PROC

    call OutputInit

    INVOKE BoxSetPos, ADDR     dino_white.box,  20, ground
    INVOKE BoxSetPos, ADDR   cactus_green.box, 400, ground
    INVOKE BoxSetPos, ADDR  game_over_str.box, 250, 50
    INVOKE BoxSetPos, ADDR game_start_str.box, 180, 50
    INVOKE BoxSetPos, ADDR      score_str.box, 400, score_y
    INVOKE BoxSetPos, ADDR high_score_str.box, 364, high_score_y

    jmp draw

look_for_key:
    INVOKE Sleep, 20                            ; sleep，讓 OS 有時間做 time slicing
    call ReadKey                                ; 讀取輸入鍵

key_detect:
    .if (game_mode == 0)                        ; @ 遊戲未開始    
        .if (dx == VK_SPACE)                    ; 按空白鍵開始遊戲
            mov game_mode, 1
            mStartGame
        .endif

    .elseif (game_mode == 1)                    ; @ 遊戲已開始
        inc score                               ; 每幀 +1 分
        .if (is_jumping == 1 || is_jumping == 2)
            jmp jump
        .elseif (dx == VK_LEFT)
            mov eax, l_move_boundary
            .if (dino_white.box.pos.X > eax)    ; 小恐龍左移邊界
                mov eax, lr_move
                sub dino_white.box.pos.X, eax
            .endif
        .elseif (dx == VK_RIGHT)
            mov eax, r_move_boundary
            .if (dino_white.box.pos.X < eax)    ; 小恐龍右移邊界
                mov eax, lr_move
                add dino_white.box.pos.X, eax
            .endif
        .elseif (dx == VK_SPACE)
            .if (is_jumping == 0)
                mov is_jumping, 1
            .endif
        .elseif (dx == VK_RETURN)               ; 暫停遊戲
            mov game_mode, 2
        .endif

    .elseif (game_mode == 2)                    ; @ 遊戲已暫停
        .if (dx == VK_SPACE)                    ; 按空白鍵「重新」開始遊戲
            mov game_mode, 1
        .endif

    .elseif (game_mode == 3)                    ; @ 遊戲已結束
        mov eax, score
        .if (eax > high_score)                  ; 判斷是否需更改遊戲最高分
            mov high_score, eax
        .endif
        .if (dx == VK_SPACE)                    ; 按空白鍵「重新」開始遊戲
            mov game_mode, 1
            mStartGame
        .endif

    .endif
    jmp draw

jump:
    mov ecx, jump_counter
    .if (is_jumping == 1)
        .if (ecx == jump_times)
            mov is_jumping, 2
            mov jump_counter, 0
            jmp draw
        .else
            mov eax, jump_height
            sub dino_white.box.pos.Y, eax
            inc jump_counter
            jmp draw
        .endif
    .elseif (is_jumping == 2)
        .if (ecx == jump_times)
            mov is_jumping, 0
            mov jump_counter, 0
            jmp draw
        .else
            mov eax, jump_height
            add dino_white.box.pos.Y, eax
            inc jump_counter
            jmp draw
        .endif
    .endif

draw:
    call Clrscr
    .if (game_mode == 0)                        ; @ 遊戲未開始
        INVOKE DrawBox, game_start_str.box
    .elseif (game_mode == 3)                    ; @ 遊戲已結束
        INVOKE DrawBox, game_over_str.box
    .endif
    INVOKE DrawBox, dino_white.box
    INVOKE DrawBox, score_str.box
    INVOKE DrawBox, high_score_str.box
    INVOKE DrawScore, score, last_digit_x, score_y
    INVOKE DrawScore, high_score, last_digit_x, high_score_y

cactus:
    .if (game_mode == 1)                        ; @ 遊戲已開始
        .if (is_cactus == 0)                    ; 仙人掌未出現
            .if (cactus_random1 == 0)           ; 尚未有隨機變數
                mov eax, cactus_range
                call RandomRange
                add eax, cactus_initial         ; 偏移量
                mov cactus_random1, eax
            .else                               ; 有隨機變數
                dec cactus_random1
                .if (cactus_random1 == 0)       ; 已等待完畢
                     mov is_cactus, 1
                .endif
            .endif
        .else                                   ; 仙人掌已出現，檢測碰撞
            INVOKE DetectCollision, ADDR cactus_green.box, ADDR dino_white.box
            .if (edx == 1)                      ; 有碰撞！
                mov game_mode, 3                ; 遊戲改為結束模式
                mov is_cactus, 0                ; 仙人掌改為不存在模式
                mov cactus_green.box.pos.X, 361 

            .else                               ; 沒有碰撞！
                mov eax, cactus_green.box.pos.X
                .if (eax <= 1)                  ; 當仙人掌已抵達邊界
                    mov is_cactus, 0            ; 仙人掌改為不存在模式
                    mov cactus_green.box.pos.X, 361
                .else                           ; 當仙人掌未抵達邊界
                    INVOKE DrawBox, cactus_green.box
                    mov eax, cactus_move
                    sub cactus_green.box.pos.X, eax
                .endif
            .endif
        .endif
    .endif
    jmp look_for_key

    exit

main ENDP
END main