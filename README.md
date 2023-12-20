# Dino-Run-Beta
Last Update: 2023/12/19

![alt dino](https://raw.githubusercontent.com/RogelioKG/Dino-Run/main/preview/dino.gif)

---
### New Update (for developers)
+ ...

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
+ 12/20
    > 隨機敵人 & 可任意新增靜態敵人 / 動態敵人，第一階段性任務完成