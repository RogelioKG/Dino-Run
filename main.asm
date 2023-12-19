TITLE main.asm
OPTION casemap:none

; third-party library
INCLUDE Irvine32.inc
INCLUDE Macros.inc

; local library
INCLUDE object.inc
INCLUDE draw.inc

mStartGame MACRO
    mov score, 0                                      ; ���ƭ��m
    INVOKE BoxSetPos, ADDR dino_white.box, 20, ground ; �p���s�y�Э��m
    mov is_jumping, 0                                 ; �p���s�W�ɪ��A���m
    mov jump_counter, 0                               ; �p���s�W�ɭp�ƾ����m
ENDM

.data
; �C��
ground          WORD    127
game_mode       DWORD   0   ; 0: ��l�Ҧ�, 1: �C���Ҧ�, 2: �Ȱ��Ҧ�, 3 �����Ҧ�

; �p���s
is_jumping      DWORD   0   ; 0: �D���D���A, 1: �W�ɪ��A, 2: �U�����A
jump_height     DWORD   6   ; �p���s�C����s�W�ɰ���
jump_times      DWORD   12  ; �p���s�W�ɦ^�X
jump_counter    DWORD   0   ; �p���s�W�ɭp�ƾ�
lr_move         DWORD   5   ; �p���s���k����
l_move_boundary DWORD   10  ; �p���s�������
r_move_boundary DWORD   300 ; �p���s�k�����

; �P�H�x
is_cactus       DWORD   0   ; 0: �P�H�x�|���X�{, 1: �P�H�x�w�X�{
cactus_move     DWORD   10  ; �P�H�x�V������
cactus_range    DWORD   30  ; �P�H�x�X�{�H���d��
cactus_initial  DWORD   0   ; �P�H�x�X�{��l�d�� (�����q)
cactus_random1  DWORD   0   ; �P�H�x�H���X�{

; �p��
score           DWORD   0   ; �ثe���� (7���)
high_score      DWORD   0   ; ���v�̰����� (7���)
last_digit_x    DWORD   510 ; score �� X �y�� (�̫�@��ƥ��U��)
score_y         DWORD   30  ; score �� Y �y��
high_score_y    DWORD   20  ; high_score �� Y �y��


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
    INVOKE Sleep, 20                            ; sleep�A�� OS ���ɶ��� time slicing
    call ReadKey                                ; Ū����J��

key_detect:
    .if (game_mode == 0)                        ; @ �C�����}�l    
        .if (dx == VK_SPACE)                    ; ���ť���}�l�C��
            mov game_mode, 1
            mStartGame
        .endif

    .elseif (game_mode == 1)                    ; @ �C���w�}�l
        inc score                               ; �C�V +1 ��
        .if (is_jumping == 1 || is_jumping == 2)
            jmp jump
        .elseif (dx == VK_LEFT)
            mov eax, l_move_boundary
            .if (dino_white.box.pos.X > eax)    ; �p���s�������
                mov eax, lr_move
                sub dino_white.box.pos.X, eax
            .endif
        .elseif (dx == VK_RIGHT)
            mov eax, r_move_boundary
            .if (dino_white.box.pos.X < eax)    ; �p���s�k�����
                mov eax, lr_move
                add dino_white.box.pos.X, eax
            .endif
        .elseif (dx == VK_SPACE)
            .if (is_jumping == 0)
                mov is_jumping, 1
            .endif
        .elseif (dx == VK_RETURN)               ; �Ȱ��C��
            mov game_mode, 2
        .endif

    .elseif (game_mode == 2)                    ; @ �C���w�Ȱ�
        .if (dx == VK_SPACE)                    ; ���ť���u���s�v�}�l�C��
            mov game_mode, 1
        .endif

    .elseif (game_mode == 3)                    ; @ �C���w����
        mov eax, score
        .if (eax > high_score)                  ; �P�_�O�_�ݧ��C���̰���
            mov high_score, eax
        .endif
        .if (dx == VK_SPACE)                    ; ���ť���u���s�v�}�l�C��
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
    .if (game_mode == 0)                        ; @ �C�����}�l
        INVOKE DrawBox, game_start_str.box
    .elseif (game_mode == 3)                    ; @ �C���w����
        INVOKE DrawBox, game_over_str.box
    .endif
    INVOKE DrawBox, dino_white.box
    INVOKE DrawBox, score_str.box
    INVOKE DrawBox, high_score_str.box
    INVOKE DrawScore, score, last_digit_x, score_y
    INVOKE DrawScore, high_score, last_digit_x, high_score_y

cactus:
    .if (game_mode == 1)                        ; @ �C���w�}�l
        .if (is_cactus == 0)                    ; �P�H�x���X�{
            .if (cactus_random1 == 0)           ; �|�����H���ܼ�
                mov eax, cactus_range
                call RandomRange
                add eax, cactus_initial         ; �����q
                mov cactus_random1, eax
            .else                               ; ���H���ܼ�
                dec cactus_random1
                .if (cactus_random1 == 0)       ; �w���ݧ���
                     mov is_cactus, 1
                .endif
            .endif
        .else                                   ; �P�H�x�w�X�{�A�˴��I��
            INVOKE DetectCollision, ADDR cactus_green.box, ADDR dino_white.box
            .if (edx == 1)                      ; ���I���I
                mov game_mode, 3                ; �C���אּ�����Ҧ�
                mov is_cactus, 0                ; �P�H�x�אּ���s�b�Ҧ�
                mov cactus_green.box.pos.X, 361 

            .else                               ; �S���I���I
                mov eax, cactus_green.box.pos.X
                .if (eax <= 1)                  ; ��P�H�x�w��F���
                    mov is_cactus, 0            ; �P�H�x�אּ���s�b�Ҧ�
                    mov cactus_green.box.pos.X, 361
                .else                           ; ��P�H�x����F���
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