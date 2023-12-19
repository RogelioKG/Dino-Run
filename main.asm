TITLE main.asm
OPTION casemap:none

; third-party library
INCLUDE Irvine32.inc
INCLUDE Macros.inc

; local library
INCLUDE object.inc
INCLUDE draw.inc

mGameInit MACRO
    mov score, 0                                    ; 分數重置
    INVOKE BoxSetPos, ADDR dino_white.box, 20, ylim ; 小恐龍座標重置
    mov dino_white.jumping, 0                       ; 小恐龍上升狀態重置
    mov dino_white.jump_counter, 0                  ; 小恐龍上升計數器重置
    INVOKE DinoSwitchLift, 1                        ; 小恐龍一開始抬左腳
ENDM

mCactusReset MACRO
    mov cactus2_green.exists, 0                     ; 仙人掌改為不存在模式
    mov eax, cactus_gen_pos
    mov cactus2_green.box.pos.X, eax                ; 仙人掌座標重置
ENDM

; 跳躍更新
mJumpUpdate MACRO
    mov ecx, dino_white.jump_counter
    .if (dino_white.jumping == 1)
        .if (ecx == jump_times)
            INVOKE DinoSwitchJump, 2
        .else
            mov eax, jump_height
            sub dino_white.box.pos.Y, eax
            inc dino_white.jump_counter
        .endif
    .elseif (dino_white.jumping == 2)
        .if (ecx == jump_times)
            INVOKE DinoSwitchJump, 0
            INVOKE DinoSwitchLift, 2                ; 右腳著地
            call DinoChangeBody
        .else
            mov eax, jump_height
            add dino_white.box.pos.Y, eax
            inc dino_white.jump_counter
        .endif
    .endif
ENDM

; 抬腳更新
mLiftUpdate MACRO
    mov ecx, dino_white.lift_counter
    .if (ecx == lift_times)
        .if (dino_white.lifting == 1)
            INVOKE DinoSwitchLift, 2
            call DinoChangeBody
        .elseif (dino_white.lifting == 2)
            INVOKE DinoSwitchLift, 1
            call DinoChangeBody
        .endif
    .else
        inc dino_white.lift_counter
    .endif
ENDM

; 最高分更新
mHighScoreUpdate MACRO
    mov eax, score
    .if (eax > high_score)                          
        mov high_score, eax
    .endif
ENDM

.data

; 遊戲
xlim            DWORD   575 ; 
ylim            DWORD   127 ; ground
game_mode       DWORD   0   ; 0: 初始模式, 1: 遊玩模式, 2: 暫停模式, 3 結束模式

; 小恐龍
jump_height     DWORD   6   ; 小恐龍上升/下降高度 (每回合)
jump_times      DWORD   12  ; 小恐龍上升回合
lr_move         DWORD   5   ; 小恐龍左右移動
l_move_xlim     DWORD   0   ; 小恐龍左移邊界
r_move_xlim     DWORD   400 ; 小恐龍右移邊界
lift_times      DWORD   3   ; 小恐龍抬腳回合

; 仙人掌
cactus_move     DWORD   10  ; 仙人掌向左移動
cactus_gen_pos  DWORD   360 ; 仙人掌生成位置

; 隨機
initial_frame   DWORD   0   ; 出現最少所需幀數
rand_add_frame  DWORD   30  ; 隨機加碼幀數 (0 ~ 30 frames)
debut_req_frame DWORD   0   ; 出現所需幀數

; 計分
score           DWORD   0   ; 目前分數 (7位數)
high_score      DWORD   0   ; 歷史最高分數 (7位數)
last_digit_x    DWORD   520 ; score 與 high_score 的 X 座標 (個位數左下角)
score_y         DWORD   30  ; score 的 Y 座標
high_score_y    DWORD   20  ; high_score 的 Y 座標


.code
main PROC

    call OutputInit

    INVOKE BoxSetPos, ADDR     dino_white.box,  20, ylim
    INVOKE BoxSetPos, ADDR  cactus2_green.box, 400, ylim
    INVOKE BoxSetPos, ADDR  game_over_str.box, 250, 50
    INVOKE BoxSetPos, ADDR game_start_str.box, 180, 50
    INVOKE BoxSetPos, ADDR      score_str.box, 400, score_y
    INVOKE BoxSetPos, ADDR high_score_str.box, 364, high_score_y

    jmp draw

game_loop:

read_key:
    INVOKE Sleep, 20                                ; sleep，讓 OS 有時間做 time slicing
    call ReadKey                                    ; 讀取輸入鍵

game_not_started_yet:
    .if (game_mode == 0)                            ; @ 遊戲未開始
        .if (dx == VK_SPACE)                        ; 按空白鍵「開始」遊戲
            mov game_mode, 1
            mGameInit
        .endif

gaming:
    .elseif (game_mode == 1)                        ; @ 遊戲進行中
        inc score                                   ; 每幀 +1 分

        .if (dx == VK_ESCAPE)                       ; 暫停遊戲
            mov game_mode, 2
        .elseif (dx == VK_LEFT)
            mov eax, l_move_xlim
            .if (dino_white.box.pos.X > eax)        ; 小恐龍左移邊界
                mov eax, lr_move
                sub dino_white.box.pos.X, eax
            .endif
        .elseif (dx == VK_RIGHT)
            mov eax, r_move_xlim
            .if (dino_white.box.pos.X < eax)        ; 小恐龍右移邊界
                mov eax, lr_move
                add dino_white.box.pos.X, eax
            .endif
        .endif
            
        .if (dx == VK_DOWN)
            mov eax, ylim                           ; 要在地板才能蹲
            .if (dino_white.bowing == 0 && dino_white.box.pos.Y == eax)
                INVOKE DinoSwitchLift, 1
                INVOKE DinoSwitchBow, 1
                call DinoChangeBody
            .endif
        .elseif (dino_white.bowing == 1)
            INVOKE DinoSwitchLift, 1
            INVOKE DinoSwitchBow, 0
            call DinoChangeBody
        .elseif (dx == VK_SPACE)
            .if (dino_white.jumping == 0)
                INVOKE DinoSwitchJump, 1
                INVOKE DinoSwitchLift, 0
                INVOKE DinoSwitchBow, 0
                call DinoChangeBody
            .endif
        .endif

        .if (dino_white.jumping != 0)
            mJumpUpdate
        .elseif (dino_white.lifting != 0)           ; 沒有跳時，才會換腳，且沒有抬腳，就不會換腳。
            mLiftUpdate
        .endif

        .if (cactus2_green.exists == 0)             ; 仙人掌未出現
            .if (debut_req_frame == 0)              ; 尚未有出現所需幀數
                mov eax, rand_add_frame
                call RandomRange
                add eax, initial_frame              ; 出現所需幀數 = 出現最少所需幀數 + 隨機加碼幀數
                mov debut_req_frame, eax
            .else                                   ; 有隨機變數
                dec debut_req_frame
                .if (debut_req_frame == 0)          ; 已等待完畢
                     mov cactus2_green.exists, 1
                .endif
            .endif
        .else                                       ; 仙人掌已出現，檢測碰撞
            INVOKE DetectCollision, ADDR cactus2_green.box, ADDR dino_white.box
            .if (edx == 1)                          ; 有碰撞！
                mov game_mode, 3                    ; 遊戲改為結束模式
                mCactusReset
                mHighScoreUpdate
            .else                                   ; 沒有碰撞！
                .if (cactus2_green.box.pos.X <= 1)  ; 當仙人掌已抵達邊界
                    mCactusReset
                .else                               ; 當仙人掌未抵達邊界
                    mov eax, cactus_move
                    sub cactus2_green.box.pos.X, eax
                .endif
            .endif
        .endif

game_stoped:
    .elseif (game_mode == 2)                        ; @ 遊戲已暫停
        .if (dx == VK_SPACE)                        ; 按空白鍵「繼續」遊戲
            mov game_mode, 1
        .endif

game_overed:
    .elseif (game_mode == 3)                        ; @ 遊戲已結束
        .if (dx == VK_SPACE)                        ; 按空白鍵「開始」遊戲
            mov game_mode, 1
            mGameInit
        .endif

    .endif

draw:
    call Clrscr

    INVOKE DrawBox, dino_white.box
    INVOKE DrawBox, score_str.box
    INVOKE DrawBox, high_score_str.box
    INVOKE DrawScore, score, last_digit_x, score_y
    INVOKE DrawScore, high_score, last_digit_x, high_score_y

    .if (game_mode == 0 || game_mode == 2)          ; @ 遊戲未開始 / @ 遊戲已暫停
        INVOKE DrawBox, game_start_str.box
    .elseif (game_mode == 3)                        ; @ 遊戲已結束
        INVOKE DrawBox, game_over_str.box
    .endif
    .if (cactus2_green.exists == 1)
        INVOKE DrawBox, cactus2_green.box
    .endif

    jmp game_loop

    exit

main ENDP
END main