TITLE main.asm
OPTION casemap:none

; third-party library
INCLUDE Irvine32.inc
INCLUDE Macros.inc

; local library
INCLUDE object.inc
INCLUDE draw.inc

.data
ground      WORD    ?

.code
main PROC

    mOutputInit

    .repeat
        INVOKE Sleep, 500
        call Clrscr
        mov ax, 0
        call GetMaxXY               ; dx = cols, ax = rows
        call WriteInt
    .until (ax > 80)

    sub ax, 1
    mov ground, ax                  ; 地板座標 (94 cols -> y = 93)

    mDinoGreenInit    20, 93
    mCactusGreenInit 240, 93
    mRectoRedInit    120, 93
    mRectoBlueInit    60, 93

    call Clrscr
    INVOKE DrawBox, dino_green.box
    INVOKE DrawBox, cactus_green.box
    INVOKE DrawBox, recto_blue.box
    INVOKE DrawBox, recto_red.box

look_for_key:
    mov  eax, 40                    ; sleep，讓 OS 有時間做 time slicing
    call Delay                      ; 
    call ReadKey                    ; 讀取輸入鍵
    jz no_key                       ; 如果沒有輸入鍵
got_key:
    .if (dx == VK_LEFT)
        sub dino_green.box.pos.X, 2
    .elseif (dx == VK_RIGHT)
        add dino_green.box.pos.X, 2
    .elseif (dx == VK_SPACE)
        sub dino_green.box.pos.Y, 2
    .else
        jmp look_for_key
    .endif
    jmp draw
no_key:
    mov ebx, dino_green.box.pos.Y
    .if (bx >= ground)
        jmp look_for_key
    .else
        add dino_green.box.pos.Y, 2
        jmp draw
    .endif
draw:
    call Clrscr
    INVOKE DrawBox, dino_green.box
    INVOKE DrawBox, cactus_green.box
    INVOKE DrawBox, recto_blue.box
    INVOKE DrawBox, recto_red.box
    jmp look_for_key

    exit
main ENDP
END main