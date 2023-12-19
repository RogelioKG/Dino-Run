TITLE object.asm
OPTION casemap:none

; third-party library
INCLUDE Irvine32.inc

; local library
INCLUDE object.inc


.data


; 小恐龍
; ****************************************************************************
; 尺寸
dino_xdim               =    40
dino_ydim               =    42
; ----------------------------------------------------------------------------
; 內容物屬性
dino_attribute_white    WORD dino_xdim DUP(white)
; ----------------------------------------------------------------------------
; 內容物字串
dino_contents           BYTE        "                      @@@@@@@@@@@@@@@@  "
                        BYTE        "                    @@@@@@@@@@@@@@@@@@@@"
                        BYTE        "                    @@@@  @@@@@@@@@@@@@@"
                        BYTE        "                    @@@@  @@@@@@@@@@@@@@"
                        BYTE        "                    @@@@@@@@@@@@@@@@@@@@"
                        BYTE        "                    @@@@@@@@@@@@@@@@@@@@"
                        BYTE        "                    @@@@@@@@@@@@@@@@@@@@"
                        BYTE        "                    @@@@@@@@@@@@@@@@@@@@"
                        BYTE        "                    @@@@@@@@@@@@@@@@@@@@"
                        BYTE        "                    @@@@@@@@@@@@@@@@@@@@"
                        BYTE        "                    @@@@@@@@@@          "
                        BYTE        "                    @@@@@@@@@@          "
                        BYTE        "                    @@@@@@@@@@@@@@@@    "
                        BYTE        "                    @@@@@@@@@@@@@@@@    "
                        BYTE        "@@                @@@@@@@@@@            "
                        BYTE        "@@                @@@@@@@@@@            "
                        BYTE        "@@             @@@@@@@@@@@@@            "
                        BYTE        "@@             @@@@@@@@@@@@@            "
                        BYTE        "@@@@        @@@@@@@@@@@@@@@@@@@@        "
                        BYTE        "@@@@        @@@@@@@@@@@@@@@@@@@@        "
                        BYTE        "@@@@@@    @@@@@@@@@@@@@@@@@@  @@        "
                        BYTE        "@@@@@@    @@@@@@@@@@@@@@@@@@  @@        "
                        BYTE        "@@@@@@@@@@@@@@@@@@@@@@@@@@@@            "
                        BYTE        "@@@@@@@@@@@@@@@@@@@@@@@@@@@@            "
                        BYTE        "@@@@@@@@@@@@@@@@@@@@@@@@@@@@            "
                        BYTE        "@@@@@@@@@@@@@@@@@@@@@@@@@@@@            "
                        BYTE        "  @@@@@@@@@@@@@@@@@@@@@@@@@@            "
                        BYTE        "  @@@@@@@@@@@@@@@@@@@@@@@@              "
                        BYTE        "    @@@@@@@@@@@@@@@@@@@@@@              "
                        BYTE        "    @@@@@@@@@@@@@@@@@@@@@@              "
                        BYTE        "      @@@@@@@@@@@@@@@@@@                "
                        BYTE        "      @@@@@@@@@@@@@@@@@@                "
                        BYTE        "        @@@@@@@@@@@@@@                  "
                        BYTE        "        @@@@@@@@@@@@@@                  "
                        BYTE        "          @@@@@@  @@@@                  "
                        BYTE        "          @@@@@@  @@@@                  "
                        BYTE        "          @@@@      @@                  "
                        BYTE        "          @@@@      @@                  "
                        BYTE        "          @@        @@                  "
                        BYTE        "          @@        @@                  "
                        BYTE        "          @@@@      @@@@                "
                        BYTE        "          @@@@      @@@@                "
; ----------------------------------------------------------------------------
; 角色: 灰色小恐龍
dino_white              CHARACTER   << OFFSET dino_contents,        \
                                       OFFSET dino_attribute_white, \
                                       < dino_xdim, dino_ydim >    >>
; ****************************************************************************


; 神奇小框
; ****************************************************************************
; 尺寸
recto_xdim              =           24
recto_ydim              =           12
; ----------------------------------------------------------------------------
; 內容物字串
recto_contents          BYTE        recto_xdim * recto_ydim DUP("@")
; ----------------------------------------------------------------------------
; 內容物屬性
recto_attribute_blue    WORD        recto_xdim DUP(lightCyan)
recto_attribute_red     WORD        recto_xdim DUP(lightRed)
; ----------------------------------------------------------------------------
; 物件: 神奇小藍框
recto_blue              OBJECT      << OFFSET recto_contents,       \
                                       OFFSET recto_attribute_blue, \
                                       < recto_xdim, recto_ydim >  >>
; ----------------------------------------------------------------------------
; 物件: 神奇小紅框
recto_red               OBJECT      << OFFSET recto_contents,      \
                                       OFFSET recto_attribute_red, \
                                       < recto_xdim, recto_ydim > >>
; ****************************************************************************



; 仙人掌
; ****************************************************************************
; 尺寸
cactus_xdim             =           23
cactus_ydim             =           46
; ----------------------------------------------------------------------------
; 內容物字串
cactus_contents         BYTE        "         @@@@@         "
                        BYTE        "        @@@@@@@        "
                        BYTE        "        @@@@@@@        "
                        BYTE        "        @@@@@@@        "
                        BYTE        "        @@@@@@@        "
                        BYTE        "        @@@@@@@        "
                        BYTE        "        @@@@@@@        "
                        BYTE        "        @@@@@@@        "
                        BYTE        "        @@@@@@@        "
                        BYTE        "        @@@@@@@        "
                        BYTE        "        @@@@@@@    @@@ "
                        BYTE        "        @@@@@@@   @@@@@"
                        BYTE        " @@@    @@@@@@@   @@@@@"
                        BYTE        "@@@@@   @@@@@@@   @@@@@"
                        BYTE        "@@@@@   @@@@@@@   @@@@@"
                        BYTE        "@@@@@   @@@@@@@   @@@@@"
                        BYTE        "@@@@@   @@@@@@@   @@@@@"
                        BYTE        "@@@@@   @@@@@@@   @@@@@"
                        BYTE        "@@@@@   @@@@@@@   @@@@@"
                        BYTE        "@@@@@   @@@@@@@   @@@@@"
                        BYTE        "@@@@@   @@@@@@@   @@@@@"
                        BYTE        "@@@@@   @@@@@@@   @@@@@"
                        BYTE        "@@@@@   @@@@@@@   @@@@@"
                        BYTE        "@@@@@   @@@@@@@   @@@@@"
                        BYTE        "@@@@@   @@@@@@@   @@@@@"
                        BYTE        "@@@@@   @@@@@@@   @@@@@"
                        BYTE        "@@@@@@@@@@@@@@@@@@@@@@ "
                        BYTE        "@@@@@@@@@@@@@@@@@@@@@  "
                        BYTE        " @@@@@@@@@@@@@@@@@@@   "
                        BYTE        "  @@@@@@@@@@@@@@@@@    "
                        BYTE        "   @@@@@@@@@@@@        "
                        BYTE        "        @@@@@@@        "
                        BYTE        "        @@@@@@@        "
                        BYTE        "        @@@@@@@        "
                        BYTE        "        @@@@@@@        "
                        BYTE        "        @@@@@@@        "
                        BYTE        "        @@@@@@@        "
                        BYTE        "        @@@@@@@        "
                        BYTE        "        @@@@@@@        "
                        BYTE        "        @@@@@@@        "
                        BYTE        "        @@@@@@@        "
                        BYTE        "        @@@@@@@        "
                        BYTE        "        @@@@@@@        "
                        BYTE        "        @@@@@@@        "
                        BYTE        "        @@@@@@@   @    "
                        BYTE        "    @ @@@@@@@@@     @  "
; ----------------------------------------------------------------------------
; 內容物屬性
cactus_attribute_green  WORD        cactus_xdim DUP(lightGreen)
; ----------------------------------------------------------------------------
; 物件: 綠色仙人掌
cactus_green            OBJECT      << OFFSET cactus_contents,        \
                                       OFFSET cactus_attribute_green, \
                                       < cactus_xdim, cactus_ydim >  >>
; ****************************************************************************

; 遊戲開始
; ****************************************************************************
; 尺寸
game_start_xdim         =    215
game_start_ydim         =    8
; ----------------------------------------------------------------------------
; 內容物屬性
game_start_attribute_white WORD game_start_xdim DUP(white)
; ----------------------------------------------------------------------------
; 內容物字串

game_start_contents     BYTE        " /$$$$$$$  /$$   /$$  /$$$$$$  /$$   /$$       /$$$$$$$$ /$$   /$$ /$$$$$$$$        /$$$$$$  /$$$$$$$   /$$$$$$   /$$$$$$  /$$$$$$$$       /$$$$$$$$  /$$$$$$         /$$$$$$  /$$$$$$$$  /$$$$$$  /$$$$$$$  /$$$$$$$$ "           
                        BYTE        "| $$__  $$| $$  | $$ /$$__  $$| $$  | $$      |__  $$__/| $$  | $$| $$_____/       /$$__  $$| $$__  $$ /$$__  $$ /$$__  $$| $$_____/      |__  $$__/ /$$__  $$       /$$__  $$|__  $$__/ /$$__  $$| $$__  $$|__  $$__/ "           
                        BYTE        "| $$  \ $$| $$  | $$| $$  \__/| $$  | $$         | $$   | $$  | $$| $$            | $$  \__/| $$  \ $$| $$  \ $$| $$  \__/| $$               | $$   | $$  \ $$      | $$  \__/   | $$   | $$  \ $$| $$  \ $$   | $$    "           
                        BYTE        "| $$$$$$$/| $$  | $$|  $$$$$$ | $$$$$$$$         | $$   | $$$$$$$$| $$$$$         |  $$$$$$ | $$$$$$$/| $$$$$$$$| $$      | $$$$$            | $$   | $$  | $$      |  $$$$$$    | $$   | $$$$$$$$| $$$$$$$/   | $$    "           
                        BYTE        "| $$____/ | $$  | $$ \____  $$| $$__  $$         | $$   | $$__  $$| $$__/          \____  $$| $$____/ | $$__  $$| $$      | $$__/            | $$   | $$  | $$       \____  $$   | $$   | $$__  $$| $$__  $$   | $$    "           
                        BYTE        "| $$      | $$  | $$ /$$  \ $$| $$  | $$         | $$   | $$  | $$| $$             /$$  \ $$| $$      | $$  | $$| $$    $$| $$               | $$   | $$  | $$       /$$  \ $$   | $$   | $$  | $$| $$  \ $$   | $$    "           
                        BYTE        "| $$      |  $$$$$$/|  $$$$$$/| $$  | $$         | $$   | $$  | $$| $$$$$$$$      |  $$$$$$/| $$      | $$  | $$|  $$$$$$/| $$$$$$$$         | $$   |  $$$$$$/      |  $$$$$$/   | $$   | $$  | $$| $$  | $$   | $$    "           
                        BYTE        "|__/       \______/  \______/ |__/  |__/         |__/   |__/  |__/|________/       \______/ |__/      |__/  |__/ \______/ |________/         |__/    \______/        \______/    |__/   |__/  |__/|__/  |__/   |__/    "           

; ----------------------------------------------------------------------------
; 物件: 遊戲結束字體
game_start_str          OBJECT   << OFFSET game_start_contents,           \
                                    OFFSET game_start_attribute_white,    \
                                    < game_start_xdim, game_start_ydim > >>
; ****************************************************************************

; 遊戲結束
; ****************************************************************************
; 尺寸
game_over_xdim          =    91
game_over_ydim          =    9
; ----------------------------------------------------------------------------
; 內容物屬性
game_over_attribute_white WORD game_over_xdim DUP(white)
; ----------------------------------------------------------------------------
; 內容物字串

game_over_contents      BYTE        "  /$$$$$$                                                                                  "
                        BYTE        " /$$__  $$                                                                                 "
                        BYTE        "| $$  \__/  /$$$$$$  /$$$$$$/$$$$   /$$$$$$         /$$$$$$  /$$    /$$ /$$$$$$   /$$$$$$  "
                        BYTE        "| $$ /$$$$ |____  $$| $$_  $$_  $$ /$$__  $$       /$$__  $$|  $$  /$$//$$__  $$ /$$__  $$ "
                        BYTE        "| $$|_  $$  /$$$$$$$| $$ \ $$ \ $$| $$$$$$$$      | $$  \ $$ \  $$/$$/| $$$$$$$$| $$  \__/ "
                        BYTE        "| $$  \ $$ /$$__  $$| $$ | $$ | $$| $$_____/      | $$  | $$  \  $$$/ | $$_____/| $$       "
                        BYTE        "|  $$$$$$/|  $$$$$$$| $$ | $$ | $$|  $$$$$$$      |  $$$$$$/   \  $/  |  $$$$$$$| $$       "
                        BYTE        " \______/  \_______/|__/ |__/ |__/ \_______/       \______/     \_/    \_______/|__/       "
                        BYTE        "                                                                                           "

                            

; ----------------------------------------------------------------------------
; 物件: 遊戲結束字體
game_over_str           OBJECT   << OFFSET game_over_contents,          \
                                    OFFSET game_over_attribute_white,   \
                                    < game_over_xdim, game_over_ydim > >>
; ****************************************************************************

; 遊戲分數
; ****************************************************************************
; 尺寸
score_xdim              =    49
score_ydim              =    5
; ----------------------------------------------------------------------------
; 內容物屬性
score_attribute_white   WORD score_xdim DUP(white)
; ----------------------------------------------------------------------------
; 內容物字串                        
score_contents          BYTE        "@@@@@@@  @@@@@@  @@@@@@  @@@@@@  @@@@@@@         "   
                        BYTE        "@@      @@      @@    @@ @@   @@ @@          @@  "  
                        BYTE        "@@@@@@@ @@      @@    @@ @@@@@@  @@@@@@          "    
                        BYTE        "     @@ @@      @@    @@ @@   @@ @@          @@  "   
                        BYTE        "@@@@@@@  @@@@@@  @@@@@@  @@   @@ @@@@@@@         "
; ----------------------------------------------------------------------------
; 物件: 遊戲分數字體
score_str               OBJECT   << OFFSET score_contents,        \
                                    OFFSET score_attribute_white, \
                                    < score_xdim, score_ydim >   >>
; ****************************************************************************

; 遊戲最高分數
; ****************************************************************************
; 尺寸
high_score_xdim         =    85
high_score_ydim         =    5
; ----------------------------------------------------------------------------
; 內容物屬性
high_score_attribute_white WORD high_score_xdim DUP(white)
; ----------------------------------------------------------------------------
; 內容物字串               
high_score_contents     BYTE        "@@   @@ @@@@@@  @@@@@@  @@   @@     @@@@@@@  @@@@@@  @@@@@@  @@@@@@  @@@@@@@         "     
                        BYTE        "@@   @@   @@   @@       @@   @@     @@      @@      @@    @@ @@   @@ @@          @@  "   
                        BYTE        "@@@@@@@   @@   @@   @@@ @@@@@@@     @@@@@@@ @@      @@    @@ @@@@@@  @@@@@@          "    
                        BYTE        "@@   @@   @@   @@    @@ @@   @@          @@ @@      @@    @@ @@   @@ @@          @@  "   
                        BYTE        "@@   @@ @@@@@@  @@@@@@  @@   @@     @@@@@@@  @@@@@@  @@@@@@  @@   @@ @@@@@@@         "
; ----------------------------------------------------------------------------
; 物件: 遊戲最高分數字體
high_score_str          OBJECT   << OFFSET high_score_contents,           \
                                    OFFSET high_score_attribute_white,    \
                                    < high_score_xdim, high_score_ydim > >>
; ****************************************************************************

; 數字
; ****************************************************************************
; 尺寸
digit_xdim               =    10
digit_ydim               =    5
; ----------------------------------------------------------------------------
; 內容物屬性
digit_attribute_white    WORD digit_xdim DUP(white)
; ----------------------------------------------------------------------------
; 內容物字串               
digit_0_contents         BYTE        " @@@@@@   "  
                         BYTE        "@@  @@@@  "   
                         BYTE        "@@ @@ @@  "   
                         BYTE        "@@@@  @@  "   
                         BYTE        " @@@@@@   "

digit_1_contents         BYTE        "    @@    "     
                         BYTE        "  @@@@    "     
                         BYTE        "    @@    "     
                         BYTE        "    @@    "     
                         BYTE        "    @@    "

digit_2_contents         BYTE        " @@@@@@@  "   
                         BYTE        "      @@  " 
                         BYTE        "  @@@@@   "
                         BYTE        " @@       "
                         BYTE        " @@@@@@@  "

digit_3_contents         BYTE        " @@@@@@   "
                         BYTE        "      @@  "
                         BYTE        "  @@@@@   "
                         BYTE        "      @@  "
                         BYTE        " @@@@@@   "

digit_4_contents         BYTE        " @@   @@  "
                         BYTE        " @@   @@  "
                         BYTE        " @@@@@@@  "
                         BYTE        "      @@  "
                         BYTE        "      @@  "

digit_5_contents         BYTE        " @@@@@@@  "
                         BYTE        " @@       "
                         BYTE        " @@@@@@@  "
                         BYTE        "      @@  "
                         BYTE        " @@@@@@@  "

digit_6_contents         BYTE        "  @@@@@@  " 
                         BYTE        " @@       "
                         BYTE        " @@@@@@@  "
                         BYTE        " @@    @@ "
                         BYTE        "  @@@@@@  "

digit_7_contents         BYTE        " @@@@@@@  "
                         BYTE        "      @@  "
                         BYTE        "     @@   "
                         BYTE        "    @@    "
                         BYTE        "    @@    "

digit_8_contents         BYTE        "  @@@@@   "
                         BYTE        " @@   @@  "
                         BYTE        "  @@@@@   "
                         BYTE        " @@   @@  "
                         BYTE        "  @@@@@   "

digit_9_contents         BYTE        "  @@@@@   " 
                         BYTE        " @@   @@  "
                         BYTE        "  @@@@@@  "
                         BYTE        "      @@  "
                         BYTE        "  @@@@@   "
; ----------------------------------------------------------------------------
; 物件: 數字0
digit_0                  OBJECT   << OFFSET digit_0_contents,       \
                                     OFFSET digit_attribute_white,  \
                                     < digit_xdim, digit_ydim >    >>
; 物件: 數字1
digit_1                  OBJECT   << OFFSET digit_1_contents,       \
                                     OFFSET digit_attribute_white,  \
                                     < digit_xdim, digit_ydim >    >>
; 物件: 數字2
digit_2                  OBJECT   << OFFSET digit_2_contents,       \
                                     OFFSET digit_attribute_white,  \
                                     < digit_xdim, digit_ydim >    >>
; 物件: 數字3
digit_3                  OBJECT   << OFFSET digit_3_contents,       \
                                     OFFSET digit_attribute_white,  \
                                     < digit_xdim, digit_ydim >    >>
; 物件: 數字4
digit_4                  OBJECT   << OFFSET digit_4_contents,       \
                                     OFFSET digit_attribute_white,  \
                                     < digit_xdim, digit_ydim >    >>
; 物件: 數字5
digit_5                  OBJECT   << OFFSET digit_5_contents,       \
                                     OFFSET digit_attribute_white,  \
                                     < digit_xdim, digit_ydim >    >>
; 物件: 數字6
digit_6                  OBJECT   << OFFSET digit_6_contents,       \
                                     OFFSET digit_attribute_white,  \
                                     < digit_xdim, digit_ydim >    >>
; 物件: 數字7
digit_7                  OBJECT   << OFFSET digit_7_contents,       \
                                     OFFSET digit_attribute_white,  \
                                     < digit_xdim, digit_ydim >    >>
; 物件: 數字8
digit_8                  OBJECT   << OFFSET digit_8_contents,       \
                                     OFFSET digit_attribute_white,  \
                                     < digit_xdim, digit_ydim >    >>
; 物件: 數字9
digit_9                  OBJECT   << OFFSET digit_9_contents,       \
                                     OFFSET digit_attribute_white,  \
                                     < digit_xdim, digit_ydim >    >>
; ----------------------------------------------------------------------------
; 數字指標陣列
digits                   DWORD    OFFSET digit_0, OFFSET digit_1, OFFSET digit_2, OFFSET digit_3, OFFSET digit_4, \
                                  OFFSET digit_5, OFFSET digit_6, OFFSET digit_7, OFFSET digit_8, OFFSET digit_9
; ****************************************************************************

.code
; -------------------------------------------------
; Name:
;     BoxSetPos
; Brief:
;     將物體盒左下角置於某位置
; Uses:
;     eax esi
; Params:
;     box_ptr = 物體盒指標    (PTR BOX)
;           x = 左下角 x 座標 (DWORD)
;           y = 左下角 y 座標 (DWORD)
; Returns:
;     ...
; Example:
;     INVOKE BoxSetPos, ADDR dino_white.box, 20, 50
;     將灰色小恐龍左下角置於位置 (20, 50)
; -------------------------------------------------
BoxSetPos PROC USES eax esi box_ptr:PTR BOX, x:DWORD, y:DWORD
    mov esi, box_ptr
    mov eax, x
    mov (BOX PTR [esi]).pos.X, eax
    mov eax, y
    mov (BOX PTR [esi]).pos.Y, eax
    ret
BoxSetPos ENDP

; -------------------------------------------------
; Name:
;     DetectCollision
; Brief:
;     檢測兩物體盒的碰撞與否
; Uses:
;     eax ebx ecx esi edi
; Params:
;     box1_ptr = 物體盒指標 (PTR BOX)
;     box2_ptr = 物體盒指標 (PTR BOX)
; Returns:
;     edx = 0: 未碰撞, 1: 碰撞
; Example:
;     INVOKE DetectCollision, ADDR cactus_green.box, ADDR dino_white.box
;     引數可交換，下方註解以舉例進行說明
; -------------------------------------------------
DetectCollision PROC USES eax ebx ecx esi edi box1_ptr:PTR BOX, box2_ptr:PTR BOX
    LOCAL collided:DWORD
    mov collided, 0                             ; 一開始假設沒有相撞

    mov esi, box1_ptr
    mov edi, box2_ptr

    mov eax, (BOX PTR [esi]).pos.Y
    sub eax, (BOX PTR [esi]).dim.Y              ; eax = 仙人掌最上側的 Y 座標
    mov ebx, (BOX PTR [edi]).pos.Y
    sub ebx, (BOX PTR [edi]).dim.Y              ; ebx = 小恐龍最上側的 Y 座標

    mov ecx, (BOX PTR [edi]).pos.Y
    .if (eax < ecx)
        mov ecx, (BOX PTR [esi]).pos.Y
        .if (ebx < ecx)

            mov eax, (BOX PTR [esi]).pos.X
            add eax, (BOX PTR [esi]).dim.X      ; eax = 仙人掌最右側的 X 座標
            mov ebx, (BOX PTR [edi]).pos.X
            add ebx, (BOX PTR [edi]).dim.X      ; ebx = 小恐龍最右側的 X 座標

            mov ecx, (BOX PTR [edi]).pos.X
            .if (eax > ecx)
                mov ecx, (BOX PTR [esi]).pos.X
                .if (ebx > ecx)
                    mov collided, 1
                .endif
            .endif

        .endif
    .endif

    mov edx, collided
    ret
DetectCollision ENDP

END