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

    LOCAL cur_pos:COORD             ; ø�s���
    LOCAL cur_address:DWORD         ; ø�s��} (�s�����鲰���P���ת���V�r��)

    lea edi, cur_pos                ; ø�s��Ъ�l��m�����鲰�����W��
    mov ax, box.pos.X
    mov (COORD PTR [edi]).X, ax
    mov ax, box.pos.Y
    mov (COORD PTR [edi]).Y, ax

    mov edi, box.contents_ptr
    mov cur_address, edi            ; ø�s��}��l���������e���}�Y��}

    mov ecx, box.ydim               ; ���鲰������
draw:                               ; �}�l�v�Cø�s
    push ecx                        ; �U�����l�{�������ϥ� ecx�A�]�ӹw�� push

    INVOKE WriteConsoleOutputAttribute,
        output_handle,
        box.attr_ptr,
        box.xdim,
        cur_pos,
        OFFSET cells_written 

    INVOKE WriteConsoleOutputCharacter,
        output_handle,
        cur_address,
        box.xdim,
        cur_pos,
        OFFSET count

    pop ecx                         ; �l�{�ǩI�s�����A�N ecx pop �^��
    inc cur_pos.Y                   ; ø�s��Щ��U����
    mov eax, box.xdim
    add cur_address, eax            ; ø�s��}���ʨ�U�Ӱ���
    loop draw
 
    ret

DrawBox ENDP

END