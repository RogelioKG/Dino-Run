TITLE main.asm
OPTION casemap:none

; third-party library
INCLUDE Irvine32.inc
INCLUDE Macros.inc

; local library
INCLUDE object.inc
INCLUDE draw.inc

mGameInit MACRO
    mov score, 0                                    ; ���ƭ��m
    INVOKE BoxSetPos, ADDR dino_white.box, 20, ylim ; �p���s�y�Э��m
    mov dino_white.jumping, 0                       ; �p���s�W�ɪ��A���m
    mov dino_white.jump_counter, 0                  ; �p���s�W�ɭp�ƾ����m
    INVOKE DinoSwitchLift, 1                        ; �p���s�@�}�l�索�}
ENDM

mCactusReset MACRO
    mov cactus2_green.exists, 0                     ; �P�H�x�אּ���s�b�Ҧ�
    mov eax, cactus_gen_pos
    mov cactus2_green.box.pos.X, eax                ; �P�H�x�y�Э��m
ENDM

; ���D��s
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
            INVOKE DinoSwitchLift, 2                ; �k�}�ۦa
            call DinoChangeBody
        .else
            mov eax, jump_height
            add dino_white.box.pos.Y, eax
            inc dino_white.jump_counter
        .endif
    .endif
ENDM

; ��}��s
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

; �̰�����s
mHighScoreUpdate MACRO
    mov eax, score
    .if (eax > high_score)                          
        mov high_score, eax
    .endif
ENDM

.data

; �C��
xlim            DWORD   575 ; 
ylim            DWORD   127 ; ground
game_mode       DWORD   0   ; 0: ��l�Ҧ�, 1: �C���Ҧ�, 2: �Ȱ��Ҧ�, 3 �����Ҧ�

; �p���s
jump_height     DWORD   6   ; �p���s�W��/�U������ (�C�^�X)
jump_times      DWORD   12  ; �p���s�W�ɦ^�X
lr_move         DWORD   5   ; �p���s���k����
l_move_xlim     DWORD   0   ; �p���s�������
r_move_xlim     DWORD   400 ; �p���s�k�����
lift_times      DWORD   3   ; �p���s��}�^�X

; �P�H�x
cactus_move     DWORD   10  ; �P�H�x�V������
cactus_gen_pos  DWORD   360 ; �P�H�x�ͦ���m

; �H��
initial_frame   DWORD   0   ; �X�{�̤֩һݴV��
rand_add_frame  DWORD   30  ; �H���[�X�V�� (0 ~ 30 frames)
debut_req_frame DWORD   0   ; �X�{�һݴV��

; �p��
score           DWORD   0   ; �ثe���� (7���)
high_score      DWORD   0   ; ���v�̰����� (7���)
last_digit_x    DWORD   520 ; score �P high_score �� X �y�� (�Ӧ�ƥ��U��)
score_y         DWORD   30  ; score �� Y �y��
high_score_y    DWORD   20  ; high_score �� Y �y��


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
    INVOKE Sleep, 20                                ; sleep�A�� OS ���ɶ��� time slicing
    call ReadKey                                    ; Ū����J��

game_not_started_yet:
    .if (game_mode == 0)                            ; @ �C�����}�l
        .if (dx == VK_SPACE)                        ; ���ť���u�}�l�v�C��
            mov game_mode, 1
            mGameInit
        .endif

gaming:
    .elseif (game_mode == 1)                        ; @ �C���i�椤
        inc score                                   ; �C�V +1 ��

        .if (dx == VK_ESCAPE)                       ; �Ȱ��C��
            mov game_mode, 2
        .elseif (dx == VK_LEFT)
            mov eax, l_move_xlim
            .if (dino_white.box.pos.X > eax)        ; �p���s�������
                mov eax, lr_move
                sub dino_white.box.pos.X, eax
            .endif
        .elseif (dx == VK_RIGHT)
            mov eax, r_move_xlim
            .if (dino_white.box.pos.X < eax)        ; �p���s�k�����
                mov eax, lr_move
                add dino_white.box.pos.X, eax
            .endif
        .endif
            
        .if (dx == VK_DOWN)
            mov eax, ylim                           ; �n�b�a�O�~����
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
        .elseif (dino_white.lifting != 0)           ; �S�����ɡA�~�|���}�A�B�S����}�A�N���|���}�C
            mLiftUpdate
        .endif

        .if (cactus2_green.exists == 0)             ; �P�H�x���X�{
            .if (debut_req_frame == 0)              ; �|�����X�{�һݴV��
                mov eax, rand_add_frame
                call RandomRange
                add eax, initial_frame              ; �X�{�һݴV�� = �X�{�̤֩һݴV�� + �H���[�X�V��
                mov debut_req_frame, eax
            .else                                   ; ���H���ܼ�
                dec debut_req_frame
                .if (debut_req_frame == 0)          ; �w���ݧ���
                     mov cactus2_green.exists, 1
                .endif
            .endif
        .else                                       ; �P�H�x�w�X�{�A�˴��I��
            INVOKE DetectCollision, ADDR cactus2_green.box, ADDR dino_white.box
            .if (edx == 1)                          ; ���I���I
                mov game_mode, 3                    ; �C���אּ�����Ҧ�
                mCactusReset
                mHighScoreUpdate
            .else                                   ; �S���I���I
                .if (cactus2_green.box.pos.X <= 1)  ; ��P�H�x�w��F���
                    mCactusReset
                .else                               ; ��P�H�x����F���
                    mov eax, cactus_move
                    sub cactus2_green.box.pos.X, eax
                .endif
            .endif
        .endif

game_stoped:
    .elseif (game_mode == 2)                        ; @ �C���w�Ȱ�
        .if (dx == VK_SPACE)                        ; ���ť���u�~��v�C��
            mov game_mode, 1
        .endif

game_overed:
    .elseif (game_mode == 3)                        ; @ �C���w����
        .if (dx == VK_SPACE)                        ; ���ť���u�}�l�v�C��
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

    .if (game_mode == 0 || game_mode == 2)          ; @ �C�����}�l / @ �C���w�Ȱ�
        INVOKE DrawBox, game_start_str.box
    .elseif (game_mode == 3)                        ; @ �C���w����
        INVOKE DrawBox, game_over_str.box
    .endif
    .if (cactus2_green.exists == 1)
        INVOKE DrawBox, cactus2_green.box
    .endif

    jmp game_loop

    exit

main ENDP
END main