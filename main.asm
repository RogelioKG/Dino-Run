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
last_key    WORD    ?


.code
main PROC

    mOutputInit

    .repeat
        INVOKE Sleep, 500
        call Clrscr
        mov ax, 0
        call GetMaxXY   ; dx = cols (x:width), ax = rows (y:height)
        call WriteInt
    .until (ax > 80)

    mov ground, ax

    mDinoGreenInit  0, 0
    mRectoRedInit   240, 80
    mRectoBlueInit  120, 80

    call Clrscr
    INVOKE DrawBox, recto_blue.box
    INVOKE DrawBox, recto_red.box
    INVOKE DrawBox, dino_green.box

look_for_key:
    mov  eax, 40                ; sleep，讓 OS 進行 time slicing
    call Delay                  ; 
    call ReadKey                ; 讀取鍵盤輸入
    jz no_key                   ; 沒有任何鍵盤輸入
got_key:
    .if (dx == VK_LEFT)
        sub dino_green.box.pos.X, 1
    .elseif (dx == VK_RIGHT)
        add dino_green.box.pos.X, 1
    .elseif (dx == VK_SPACE)
        sub dino_green.box.pos.Y, 2
    .else
        jmp look_for_key
    .endif
    .if (dx == VK_LEFT)
        sub dino_green.box.pos.X, 1
    .elseif (dx == VK_RIGHT)
        add dino_green.box.pos.X, 1
    .elseif (dx == VK_SPACE)
        sub dino_green.box.pos.Y, 2
    .else
        jmp look_for_key
    .endif
    mov last_key, dx
    jmp draw
no_key:
    call GetMaxXY
    mov ebx, 0
    movzx ebx, dino_green.box.pos.Y
    add ebx, dino_green.box.ydim
    .if (bx >= ax)
        jmp look_for_key
    .else
        add dino_green.box.pos.Y, 1
        jmp draw
    .endif
draw:
    call Clrscr
    INVOKE DrawBox, recto_blue.box
    INVOKE DrawBox, recto_red.box
    INVOKE DrawBox, dino_green.box
    jmp look_for_key

    exit
main ENDP
END main