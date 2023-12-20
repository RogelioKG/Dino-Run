IFNDEF CONST_INC
CONST_INC EQU < 1 >

TITLE const.inc
OPTION casemap:none


; 結構的定義：直接放入即可
; ...


; 變數的外部定義：使用 EXTERNDEF 關鍵字



; 子程序的外部定義：宣告 PROTO 即可
; ...


; 巨集的定義：直接放入即可

mCharacterSetPos MACRO
    INVOKE BoxSetPos, ADDR     dino_white.box,            20,          ylim
    INVOKE BoxSetPos, ADDR  cactus1_green.box,  static_gen_x,  static_gen_y
    INVOKE BoxSetPos, ADDR  cactus2_green.box,  static_gen_x,  static_gen_y
    INVOKE BoxSetPos, ADDR    bird1_brown.box, dynamic_gen_x, dynamic_gen_y
ENDM

; 遊戲重設
mGameInit MACRO
    mCharacterSetPos                                ; 位置重置
    mov score, 0                                    ; 分數重置
    INVOKE DinoSwitchJump, 0                        ; 小恐龍跳躍狀態重置
    INVOKE DinoSwitchLift, 1                        ; 小恐龍抬腳狀態重置 (抬左腳)
ENDM

; 跳躍更新
mJumpUpdate MACRO
    mov ecx, dino_white.jump_counter
    .if (dino_white.jumping == 1)
        .if (ecx == jump_frame)
            INVOKE DinoSwitchJump, 2
        .else
            mov eax, jump_height
            sub dino_white.box.pos.Y, eax
            inc dino_white.jump_counter
        .endif
    .elseif (dino_white.jumping == 2)
        .if (ecx == jump_frame)
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
    .if (ecx == lift_frame)
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

; 動態敵人更新
mDynamicEnemyUpdate MACRO
    mov ecx, (DYNAMIC_ENEMY PTR [esi]).status_counter
    .if (ecx == status_frame)
        mov (DYNAMIC_ENEMY PTR [esi]).status_counter, 0
        INVOKE DynamicEnemyChangeBody, current_enemy
    .else
        inc (DYNAMIC_ENEMY PTR [esi]).status_counter
    .endif
ENDM

; 最高分更新
mHighScoreUpdate MACRO
    mov eax, score
    .if (eax > high_score)                          
        mov high_score, eax
    .endif
ENDM

; 獲取出現所需幀數
mGetDebutFrame MACRO
    mov eax, rand_add_frame
    call RandomRange
    add eax, initial_frame              ; 出現所需幀數 = 出現最少所需幀數 + 隨機加碼幀數
    mov debut_req_frame, eax
ENDM

ENDIF