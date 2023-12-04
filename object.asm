TITLE object.asm
OPTION casemap:none

; third-party library
INCLUDE Irvine32.inc

; local library
INCLUDE object.inc


.data

; 神奇小框
; ************************************************************************
; 尺寸
recto_xdim              =           7
recto_ydim              =           7
; ------------------------------------------------------------------------
; 角色: 神奇小藍框
recto_blue              RectBuddy   <>
recto_attribute_blue    WORD        recto_xdim DUP(lightCyan)
; ------------------------------------------------------------------------
; 角色: 神奇小紅框
recto_red               RectBuddy   <>
recto_attribute_red     WORD        recto_xdim DUP(lightRed)
; ------------------------------------------------------------------------
; 內容物
recto_contents          BYTE        0DAh, (recto_xdim - 2) DUP(0C4h), 0BFh
                        BYTE        0B3h, (recto_xdim - 2) DUP(' ') , 0B3h
                        BYTE        0B3h, (recto_xdim - 2) DUP(' ') , 0B3h
                        BYTE        0B3h, (recto_xdim - 2) DUP(' ') , 0B3h
                        BYTE        0B3h, (recto_xdim - 2) DUP(' ') , 0B3h
                        BYTE        0B3h, (recto_xdim - 2) DUP(' ') , 0B3h
                        BYTE        0C0h, (recto_xdim - 2) DUP(0C4h), 0D9h
; ************************************************************************


; 小恐龍
; *********************************************************************
; 尺寸
dino_xdim               =    40
dino_ydim               =    42
; ---------------------------------------------------------------------
; 角色: 綠色小恐龍
dino_green              Dino <>
dino_attribute_green    WORD dino_xdim DUP(lightGreen)
; ---------------------------------------------------------------------
dino_contents           BYTE "                      ****************  "
                        BYTE "                    ********************"
                        BYTE "                    ****  **************"
                        BYTE "                    ****  **************"
                        BYTE "                    ********************"
                        BYTE "                    ********************"
                        BYTE "                    ********************"
                        BYTE "                    ********************"
                        BYTE "                    ********************"
                        BYTE "                    ********************"
                        BYTE "                    **********          "
                        BYTE "                    **********          "
                        BYTE "                    ****************    "
                        BYTE "                    ****************    "
                        BYTE "**                **********            "
                        BYTE "**                **********            "
                        BYTE "**             *************            "
                        BYTE "**             *************            "
                        BYTE "****        ********************        "
                        BYTE "****        ********************        "
                        BYTE "******    ******************  **        "
                        BYTE "******    ******************  **        "
                        BYTE "****************************            "
                        BYTE "****************************            "
                        BYTE "****************************            "
                        BYTE "****************************            "
                        BYTE "  **************************            "
                        BYTE "  ************************              "
                        BYTE "    **********************              "
                        BYTE "    **********************              "
                        BYTE "      ******************                "
                        BYTE "      ******************                "
                        BYTE "        **************                  "
                        BYTE "        **************                  "
                        BYTE "          ******  ****                  "
                        BYTE "          ******  ****                  "
                        BYTE "          ****      **                  "
                        BYTE "          ****      **                  "
                        BYTE "          **        **                  "
                        BYTE "          **        **                  "
                        BYTE "          ****      ****                "
                        BYTE "          ****      ****                "
; *********************************************************************

.code

END