## Changelog
+ 2023/12/07
    > 嘗試 MASM32 SDK，寫個批次檔進行組譯連結，有成功。小木偶的 [input.asm](https://wanker742126.neocities.org/old/win32asm/w32asm_ch03) 和 [parabola.asm](https://wanker742126.neocities.org/old/win32asm/w32asm_ch04) 自己試著組譯連結後，運作良好。這表示將專案改以 MASM32 SDK 是可行方案，但開發上記憶體/暫存器除錯可能是一大困難。
+ 2023/12/16
    > 成功以批次檔自訂 Console 視窗 / 緩衝區大小，並兼容新舊版，決定僅使用 Irvine Library 開發，而不使用 MASM32 SDK。
+ 2023/12/18
    > 初步完成最小可行性 demo。
+ 2023/12/19
    > 新增抬腳 / 彎腰。
+ 2023/12/20
    > 隨機敵人 & 可任意新增靜態敵人 / 動態敵人，階段性任務完成。
+ 2023/12/21
    > 新增飛碟 (動態敵人)、介面文字，難度根據分數變化，蹲從連續動作改成切換動作。