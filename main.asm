TITLE main.asm
OPTION casemap:none

; third-party library
INCLUDE Irvine32.inc
INCLUDE Macros.inc

; local library
INCLUDE object.inc
INCLUDE draw.inc
INCLUDE game_macros.inc

RandomChooseEnemy PROTO etype:DWORD

.data
; ***************************************************************************
; 遊戲
xlim            =       575         ; boundary
ylim            =       127         ; ground
game_mode       DWORD   0           ; 遊戲模式 - (0: 未開始 | 1: 遊玩中 | 2: 暫停 | 3 結束 | 4: 說明)
countdown       DWORD   100         ; 說明模式倒計時 (給遊玩者時間看說明)
; -------------------------------------------------------------------------------
; 小恐龍
lr_move         DWORD   5           ; 小恐龍左右移動速度
l_move_xlim     DWORD   0           ; 小恐龍左移邊界
r_move_xlim     DWORD   450         ; 小恐龍右移邊界
jump_height     DWORD   6           ; 小恐龍上升/下降高度 (每回合)
jump_frame      DWORD   12          ; 小恐龍上升回合
lift_frame      DWORD   3           ; 小恐龍抬腳回合
; -------------------------------------------------------------------------------
; 敵人
current_enemy   DWORD   ?           ; 當前敵人指標
enemy_exists    DWORD   0           ; 畫面中是否有敵人
enemy_type      DWORD   0           ; 當前生成敵人類型 - (0: 尚未決定 | 1: 靜態 | 2: 動態)
; -------------------------------------------------------------------------------
; 靜態敵人
static_move     DWORD   10          ; 靜態敵人向左移動速度 (難度)
static_gen_x    DWORD   450         ; 靜態敵人重置位置 (x 座標)
static_gen_y    DWORD   ylim        ; 靜態敵人重置位置 (y 座標)
                                    ; 靜態敵人陣列
static_enemies  DWORD   OFFSET cactus1_green, OFFSET cactus2_green
                                    ; 靜態敵人數量
static_num      =       ($ - static_enemies) / TYPE DWORD
; -------------------------------------------------------------------------------
; 動態敵人
status_frame    DWORD   3           ; 動態敵人狀態更新回合 (難度)
dynamic_move    DWORD   13          ; 動態敵人向左移動速度 (難度)
dynamic_gen_x   DWORD   450         ; 動態敵人重置位置 (x 座標)
dynamic_gen_y   DWORD   ylim - 30   ; 動態敵人重置位置 (y 座標)
                                    ; 動態敵人陣列
dynamic_enemies DWORD   OFFSET bird1_brown, OFFSET ufo1_blue
                                    ; 動態敵人數量
dynamic_num     =       ($ - dynamic_enemies) / TYPE DWORD
; -------------------------------------------------------------------------------
; 隨機
initial_frame   DWORD   3           ; 出現最少所需幀數 (難度)
rand_add_frame  DWORD   10          ; 隨機加碼幀數 (難度)
debut_req_frame DWORD   0           ; 出現所需幀數
; -------------------------------------------------------------------------------
; 計分
score           DWORD   0           ; 目前分數 (7位數)
high_score      DWORD   0           ; 歷史最高分數 (7位數)
max_score       DWORD   9999999     ; 分數上限
last_digit_x    DWORD   520         ; score 與 high_score 的 X 座標 (個位數左下角)
score_y         DWORD   30          ; score 的 Y 座標
high_score_y    DWORD   20          ; high_score 的 Y 座標
; ***************************************************************************

.code
main PROC

    call OutputInit

    mTextSetPos
    mCharacterSetPos
    
    jmp draw

game_loop:

read_key:
    INVOKE Sleep, 20                                    ; sleep，讓 OS 有時間做 time slicing
    call ReadKey                                        ; 讀取輸入鍵

game_not_started_yet:
    .if (game_mode == 0)                                ; @ 遊戲未開始
        .if (dx == VK_SPACE)                            ; 按空白鍵「開始」遊戲
            mov game_mode, 4                            ; 進入遊戲說明
            mGameInit
        .endif

gaming:
    .elseif (game_mode == 1)                            ; @ 遊戲進行中

        ; ----------------------------------------------; # 難度
        inc score                                       ; 每幀 +1 分
        mov eax, score
        .if (eax == max_score)
            mov game_mode, 3 
        .else
            mChangeDifficulty
        .endif
        ; ----------------------------------------------; # 移動與暫停
        .if (dx == VK_ESCAPE)                           ; 暫停遊戲
            mov game_mode, 2
        .elseif (dx == VK_LEFT)
            mov eax, l_move_xlim
            .if (dino_white.box.pos.X > eax)            ; 小恐龍左移邊界
                mov eax, lr_move
                sub dino_white.box.pos.X, eax
            .endif
        .elseif (dx == VK_RIGHT)
            mov eax, r_move_xlim
            .if (dino_white.box.pos.X < eax)            ; 小恐龍右移邊界
                mov eax, lr_move
                add dino_white.box.pos.X, eax
            .endif
        .endif
        ; ----------------------------------------------; # 蹲與跳
        .if (dx == VK_DOWN)
            mov eax, ylim                               ; 要在地板才能蹲
            .if (dino_white.bowing == 0 && dino_white.box.pos.Y == eax)
                INVOKE DinoSwitchLift, 1
                INVOKE DinoSwitchBow, 1
                call DinoChangeBody
            .elseif (dino_white.bowing == 1)
                INVOKE DinoSwitchLift, 1
                INVOKE DinoSwitchBow, 0
                call DinoChangeBody
            .endif
        .elseif (dx == VK_SPACE)
            .if (dino_white.jumping == 0)
                INVOKE DinoSwitchJump, 1
                INVOKE DinoSwitchLift, 0
                INVOKE DinoSwitchBow, 0
                call DinoChangeBody
            .endif
        .endif
        ; ----------------------------------------------; # 小恐龍狀態更新
        .if (dino_white.jumping != 0)
            mJumpUpdate
        .elseif (dino_white.lifting != 0)               ; 沒有跳時，才會換腳，且沒有抬腳，就不會換腳。
            mLiftUpdate
        .endif
        ; ----------------------------------------------; # 敵人生成與碰撞檢測
        .if (enemy_exists == 0)                         ; 敵人未出現
            .if (enemy_type == 0)                       ; 如果尚未決定敵人類型
                mov eax, 2
                call RandomRange                        ; 隨機選擇敵人類型: 1 或 2
                add eax, 1
                mov enemy_type, eax
                INVOKE RandomChooseEnemy, enemy_type    ; 隨機選擇敵人 (回傳 current_enemy)
                mGetDebutFrame
            .else
                dec debut_req_frame
                .if (debut_req_frame == 0)
                    mov enemy_exists, 1
                .endif
            .endif
        .else                                           ; 敵人已出現，檢測碰撞
            mov esi, current_enemy                      
            .if (enemy_type == 1)                       ; 靜態敵人
                lea edi, (STATIC_ENEMY PTR [esi]).box
                INVOKE DetectCollision, edi, ADDR dino_white.box
                .if (edx == 1)                          ; 有碰撞！
                    mov game_mode, 3                    ; 遊戲改為結束模式
                    mov enemy_exists, 0                 ; 畫面不存在敵人
                    mov enemy_type, 0                   ; 畫面敵人尚未決定
                    mHighScoreUpdate
                .else                                   ; 沒有碰撞！
                    mov eax, (BOX PTR [edi]).pos.X
                    sub eax, static_move
                    .if (eax >= xlim)                   ; 靜態敵人已抵達邊界 (暫存器正負不分，二補數負數會被視為超大正整數)
                        INVOKE BoxSetPos, edi, static_gen_x, static_gen_y
                        mov enemy_exists, 0             ; 畫面不存在敵人
                        mov enemy_type, 0               ; 畫面敵人尚未決定
                    .else
                        mov (BOX PTR [edi]).pos.X, eax
                    .endif
                .endif
            .elseif (enemy_type == 2)                   ; 動態敵人
                lea edi, (DYNAMIC_ENEMY PTR [esi]).box  
                INVOKE DetectCollision, edi, ADDR dino_white.box
                mDynamicEnemyUpdate                     ; 動態敵人狀態更新
                .if (edx == 1)                          ; 有碰撞！
                    mov game_mode, 3                    ; 遊戲改為結束模式
                    mov enemy_exists, 0                 ; 畫面不存在敵人
                    mov enemy_type, 0                   ; 畫面敵人尚未決定
                    mHighScoreUpdate
                .else                                   ; 沒有碰撞！
                    mov eax, (BOX PTR [edi]).pos.X
                    sub eax, dynamic_move
                    .if (eax >= xlim)                   ; 動態敵人已抵達邊界 (暫存器正負不分，二補數負數會被視為超大正整數)
                        INVOKE BoxSetPos, edi, dynamic_gen_x, dynamic_gen_y
                        mov enemy_exists, 0             ; 畫面不存在敵人
                        mov enemy_type, 0               ; 畫面敵人尚未決定
                    .else
                        mov (BOX PTR [edi]).pos.X, eax
                    .endif
                .endif
            .endif
        .endif
        ; ----------------------------------------------

game_stoped:
    .elseif (game_mode == 2)                            ; @ 遊戲已暫停
        .if (dx == VK_SPACE)                            ; 按空白鍵「繼續」遊戲
            mov game_mode, 1
        .endif

game_overed:
    .elseif (game_mode == 3)                            ; @ 遊戲已結束
        .if (dx == VK_SPACE)                            ; 按空白鍵「開始」遊戲
            mov game_mode, 1
            mGameInit
        .endif

game_instruction:
    .elseif (game_mode == 4)                            ; @ 遊戲說明
        mLiftUpdate
        dec countdown                                   ; 給遊玩者時間看說明
        .if (countdown == 0)
            mov game_mode, 1
        .endif
    .endif

draw:
    call Clrscr

    INVOKE DrawBox, dino_white.box

    .if (enemy_exists == 1)
        mov esi, current_enemy
        .if (enemy_type == 1)
            INVOKE DrawBox, (STATIC_ENEMY PTR [esi]).box
         .elseif (enemy_type == 2)
            INVOKE DrawBox, (DYNAMIC_ENEMY PTR [esi]).box
        .endif
    .endif

    .if (game_mode != 0)                            ; @ 遊戲非未開始
        INVOKE DrawBox, score_str.box
        INVOKE DrawBox, high_score_str.box
        INVOKE DrawScore, score, last_digit_x, score_y
        INVOKE DrawScore, high_score, last_digit_x, high_score_y
    .endif

    .if (game_mode == 0)                            ; @ 遊戲未開始
        INVOKE DrawBox, game_name_str 
        INVOKE DrawBox, game_start_str.box
    .elseif (game_mode == 2)                        ; @ 遊戲已暫停
        INVOKE DrawBox, game_restart_str.box
    .elseif (game_mode == 3)                        ; @ 遊戲已結束
        INVOKE DrawBox, game_over_str.box
    .elseif (game_mode == 4)                        ; @ 遊戲說明
        INVOKE DrawBox, hint_space_str.box
        INVOKE DrawBox, hint_rightleft_str.box
        INVOKE DrawBox, hint_down_str.box
        INVOKE DrawBox, hint_esc_str.box
    .endif

    jmp game_loop

    exit

main ENDP

; ----------------------------------
; Name:
;     RandomChooseEnemy
; Brief:
;     隨機選擇敵人
; Uses:
;     eax esi
; Params:
;     etype = 靜態敵人: 1, 動態敵人: 2
; Returns:
;     current_enemy = 敵人指標 (STATIC_ENEMY PTR || DYNAMIC_ENEMY PTR)
; Example:
;     INVOKE RandomChooseEnemy, 1
; ----------------------------------
RandomChooseEnemy PROC USES eax esi etype:DWORD
    call Randomize
    .if (etype == 1)
        mov eax, static_num
        call RandomRange
        mov esi, static_enemies[eax * TYPE DWORD]
    .elseif (etype == 2)
        mov eax, dynamic_num
        call RandomRange
        mov esi, dynamic_enemies[eax * TYPE DWORD]
    .endif
    mov current_enemy, esi
    ret
RandomChooseEnemy ENDP

END main