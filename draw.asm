TITLE draw.asm
OPTION casemap:none

; third-party library
INCLUDE Irvine32.inc

; local library
INCLUDE object.inc
INCLUDE draw.inc


.data
output_handle   HANDLE              ?
info            CONSOLE_CURSOR_INFO < 100, 0 >
cells_written   DWORD               ?
count           DWORD               0

.code
; -------------------
; Name:
;     OutputInit
; Brief:
;     初始化繪製
; Uses:
;     ...
; Params:
;     ...
; Returns:
;     eax = output handle
; Example:
;     call OutputInit
; -------------------
OutputInit PROC
    INVOKE GetStdHandle, STD_OUTPUT_HANDLE                  ; 獲取 output handle
    mov output_handle, eax
    INVOKE SetConsoleCursorInfo, output_handle, ADDR info   ; 隱藏游標
    ret
OutputInit ENDP


; ----------------------------------
; Name:
;     DrawBox
; Brief:
;     繪製物體盒
; Uses:
;     eax ecx edi
; Params:
;     box = 物體盒 (BOX)
; Returns:
;     ...
; Example:
;     INVOKE DrawBox, dino_green.box
;     繪製綠色小恐龍的物體盒
; ----------------------------------
DrawBox PROC USES eax ecx edi box:BOX

    LOCAL cur_pos:COORD             ; 繪製游標
    LOCAL cur_address:DWORD         ; 繪製位址 (存取物體盒不同高度的渲染字元)

    lea edi, cur_pos                ; 繪製游標初始位置為物體盒的左上角
    mov eax, box.pos.X
    mov (COORD PTR [edi]).X, ax
    mov eax, box.pos.Y
    sub eax, box.dim.Y
    add eax, 1
    mov (COORD PTR [edi]).Y, ax

    mov edi, box.contents_ptr
    mov cur_address, edi            ; 繪製位址初始值應為內容的開頭位址

    mov ecx, box.dim.Y              ; 物體盒的高度
draw:                               ; 開始逐列繪製
    push ecx                        ; 下面的子程序隱式使用 ecx，因而預先 push

    INVOKE WriteConsoleOutputAttribute,
        output_handle,
        box.attr_ptr,
        box.dim.X,
        cur_pos,
        OFFSET cells_written 

    INVOKE WriteConsoleOutputCharacter,
        output_handle,
        cur_address,
        box.dim.X,
        cur_pos,
        OFFSET count

    pop ecx                         ; 子程序呼叫結束，將 ecx pop 回來
    inc cur_pos.Y                   ; 繪製游標往下移動
    mov eax, box.dim.X
    add cur_address, eax            ; 繪製位址移動到下個高度
    loop draw
 
    ret

DrawBox ENDP


; ----------------------------------
; Name:
;     DrawScore
; Brief:
;     繪製分數
; Uses:
;     eax ebx edx esi edi
; Params:
;     score = 分數 (DWORD)
;         x = 最後一位數左下角 x 座標 (DWORD)
;         y = 最後一位數左下角 y 座標 (DWORD)
; Returns:
;     ...
; Example:
;     INVOKE DrawScore, 390, 10, 10
;     繪製分數
; ----------------------------------
DrawScore PROC USES eax ebx edx esi edi score:DWORD, x:DWORD, y:DWORD

    LOCAL score_digits:DWORD    ; 位數 (7)
    LOCAL spacing_offset:DWORD  ; 偏移 (10)
    mov score_digits, 7
    mov spacing_offset, 10

    mov eax, score
    .while (score_digits != 0)
        xor edx, edx                            ;
        mov ebx, 10                             ; 10 進制
        div ebx                                 ; 取出 score 的每一位數

        mov esi, digits[edx * TYPE DWORD]       ; 繪製
        lea edi, (OBJECT PTR [esi]).box         ;
        INVOKE BoxSetPos, edi, x, y             ;
        INVOKE DrawBox, (OBJECT PTR [esi]).box  ;

        mov ebx, spacing_offset                 ; 結束時更新條件
        sub x, ebx                              ;
        dec score_digits                        ;
    .endw

    ret
DrawScore ENDP

END