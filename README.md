# Dino-Run

Under Construction...

Last Update: 2023/12/06

+ **Idea**：**白天/黑夜模式**
    > Caution:
    > 1. 可能要刷新整個背景，而且無法漸變 (4-bit 色彩)

+ **Problem**：**小恐龍太大**
    > Solution:
    > 1. 可行：滾動滑鼠滾輪再開始遊戲 (先 scale down 再 draw)
    > (遊戲內鎖滾輪)
    > 2. 未試：或者開始執行時自動滑滾輪 (類似 SendKey)，要找找看有沒有

+ **Problem**：**物體盒很大，內容物卻很少，造成黑色覆蓋問題**
    > Solution:
    > 1. 可行：(Compromise) 先渲染大物體盒，再渲染小的
    >（碰撞盒沒有要做的很精細的話，這樣也好）

+ **被噁心到**：**MASM32 似乎對 16-bit 結構的取值有些問題 (COORD)**
    > Solution:
    > 1. 可行：全面改用 DWORD

![alt dino](https://raw.githubusercontent.com/RogelioKG/Dino-Run/main/Image/dino.png)
