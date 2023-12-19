# Dino-Run-Beta
Last Update: 2023/12/19

![alt dino](https://raw.githubusercontent.com/RogelioKG/Dino-Run/main/preview/dino.gif)

---
### New Update (for developers)

+ 12 /18
  + `digits`
      > digit_0 ~ digit_9 統一以 digits 存取，前者已不對檔案外公開 (private)
      ```nasm
      ; 數字指標陣列 (array of OBJECT PTR)
      ; ****************************************
      EXTERNDEF digits:DWORD
      ; ****************************************
      ; 數字指標陣列
      digits DWORD OFFSET digit_0, OFFSET digit_1, OFFSET digit_2, OFFSET digit_3, OFFSET digit_4, \
                   OFFSET digit_5, OFFSET digit_6, OFFSET digit_7, OFFSET digit_8, OFFSET digit_9
      ```
      > 假設你想調用某個數字的物體盒，你應該要以如下方式調用
      ```nasm
          mov esi, digits[4 * TYPE DWORD]        ; 先取出 OFFSET digit_4
          INVOKE DrawBox, (OBJECT PTR [esi]).box ; 將位址解釋為 OBJECT PTR，調用 box
          lea edi, (OBJECT PTR [esi]).box        ; 你要再取出 digit_4.box 的位址也行
      ```

  + `DrawScore`
      ```nasm
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
      ```

  + `DetectCollison`
    ```nasm
      ; -------------------------------------------------
      ; Name:
      ;     DetectCollison
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
      ;     INVOKE DetectCollison, ADDR cactus_green.box, ADDR dino_white.box
      ;     引數可交換，下方註解以舉例進行說明
      ; -------------------------------------------------
      DetectCollison PROC USES eax ebx ecx esi edi box1_ptr:PTR BOX, box2_ptr:PTR BOX
    ```
+ 12/19
  + `DinoSwitchJump`
  + `DinoSwitchLift`
  + `DinoSwitchBow`
  + `DinoChangeBody`

---
### Idea

+ **白天/黑夜模式**
    > Caution:
    > 1. 可能要刷新整個背景，而且無法漸變 (4-bit 色彩)

---
### Problem
+ **物體盒很大，內容物卻很少，造成黑色覆蓋問題**
    > Solution:
    > 1. 可行：先渲染大物體盒，再渲染小的 (workaround)
    >（碰撞盒沒有要做的很精細的話，這樣也好）

+ **MASM32 似乎對 16-bit 結構的取值有些問題 (COORD)**
    > Solution:
    > 1. 可行：全面改用 DWORD

---
### Note
+ 12/07
    > 嘗試 MASM32 SDK，寫個批次檔進行組譯連結，有成功。小木偶的 [input.asm](https://wanker742126.neocities.org/old/win32asm/w32asm_ch03) 和 [parabola.asm](https://wanker742126.neocities.org/old/win32asm/w32asm_ch04) 自己試著組譯連結後，運作良好。這表示將專案改以 MASM32 SDK 是可行方案，但開發上記憶體/暫存器除錯可能是一大困難。
+ 12/16
    > 成功以批次檔自訂 Windows Console 視窗 / 緩衝區大小，並兼容新舊版終端機，決定僅使用 Irvine Library 開發，而不使用 MASM32 SDK。
+ 12/18
    > 初步完成最小可行性 demo。
+ 12/19
    > 新增抬腳 / 彎腰。