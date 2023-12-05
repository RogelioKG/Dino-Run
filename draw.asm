TITLE draw.asm
OPTION casemap:none

; third-party library
INCLUDE Irvine32.inc

; local library
INCLUDE object.inc
INCLUDE draw.inc

.data
output_handle   HANDLE              ?
cells_written   DWORD               ?
count           DWORD               0

.code
DrawBox PROC box:Box

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

END