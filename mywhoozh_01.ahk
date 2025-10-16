SetKeyDelay, 500

#Requires AutoHotkey v1.1
#NoEnv ; 推奨
#Warn ; 推嘱
#SingleInstance Force

; MyWhooshウィンドウのタイトルを設定（必要に応じて変更してください）
SetTitleMatchMode, 2
TargetWinTitle := "MyWhoosh" ; アプリケーションのウィンドウタイトルの一部

; 基本座標と間隔の設定
CoordMode, Mouse, Screen ; マウス座標をスクリーン全体に対して設定
CameraPaletteButtonX := 650
CameraPaletteButtonY := 1015
UturnButtonX := 950
UturnButtonY := 1015
WaitTime := 1000 ; 待ち時間 (ミリ秒)

; カメラボタンの座標計算
StartX_Upper := 760
StartY_Upper := 830
StartY_Lower := 930
X_Interval := 97.5

; ----------------------------------------------------------------------
; 座標計算とマッピング
; ----------------------------------------------------------------------
ButtonCoords := {}
; 上段 (1-5) の座標計算
Loop, 5
{
    ButtonNum := A_Index
    X_Coord := Round(StartX_Upper + (A_Index - 1) * X_Interval)
    Y_Coord := StartY_Upper
    ButtonCoords[ButtonNum] := {X: X_Coord, Y: Y_Coord}
}
; 下段 (6-10) の座標計算
Loop, 5
{
    ButtonNum := A_Index + 5
    X_Coord := Round(StartX_Upper + (A_Index - 1) * X_Interval)
    Y_Coord := StartY_Lower
    ButtonCoords[ButtonNum] := {X: X_Coord, Y: Y_Coord}
}

; キーと対応するボタン番号 (1-9) のマッピング
KeyMap := {}
Loop, 9
{
    KeyMap[A_Index] := A_Index ; "1" -> 1, ..., "9" -> 9
    KeyMap["Numpad" . A_Index] := A_Index
}

; ----------------------------------------------------------------------
; メイン処理: ホットキー定義
; ----------------------------------------------------------------------

; 1から9までのホットキー登録
Loop, 9
{
    KeyName := A_Index
    NumPadName := "Numpad" . A_Index
    Hotkey, ~%KeyName%, SwitchCamera
    Hotkey, ~%NumPadName%, SwitchCamera
}

; 0 (ゼロ) キーと Numpad0 を明示的に追加 (カメラ10に対応)
Hotkey, ~0, SwitchCamera
Hotkey, ~Numpad0, SwitchCamera

; U-turn ホットキー定義
Hotkey, ~-, ClickUturnButton
Hotkey, ~NumpadSub, ClickUturnButton

Return

; ----------------------------------------------------------------------
; U-turn ボタンクリック サブルーチン
; ----------------------------------------------------------------------
ClickUturnButton:
    ; 現在アクティブなウィンドウがMyWhooshであることを確認
    IfWinActive, %TargetWinTitle%
    {
        ; U-turn ボタンをクリック
        Click, %UturnButtonX%, %UturnButtonY%
    }
Return

; ----------------------------------------------------------------------
; カメラ切り替えサブルーチン
; ----------------------------------------------------------------------
SwitchCamera:
    ; 現在アクティブなウィンドウがMyWhooshであることを確認
    IfWinActive, %TargetWinTitle%
    {
        ; 押されたホットキー名 (~は除く)
        PressedKey := RegExReplace(A_ThisHotkey, "^~")
        
        ; 0またはNumpad0が押された場合は、ボタン10にマッピング
        If (PressedKey = "0" or PressedKey = "Numpad0")
        {
            ButtonNumber := 10
        }
        ; Numpad1-9の場合の処理
        Else If InStr(PressedKey, "Numpad")
        {
            ; Numpadを取り除いた数字 ('1'...'9')を取得
            StringReplace, CleanKey, PressedKey, Numpad
            ButtonNumber := KeyMap[CleanKey]
        }
        ; 通常のキー1-9の場合の処理
        Else
        {
            ButtonNumber := KeyMap[PressedKey]
        }
        
        
        If (ButtonNumber = "") ; マッピングにないキーの場合は何もしない
            Return

        ; 1. カメラパレットボタンをクリックしてパレットを開く
        Click, %CameraPaletteButtonX%, %CameraPaletteButtonY%

        ; 2. 1秒待機
        Sleep, %WaitTime%

        ; 3. 対応するカメラボタンの座標を取得
        TargetX := ButtonCoords[ButtonNumber].X
        TargetY := ButtonCoords[ButtonNumber].Y

        ; 4. カメラボタンをクリック
        Click, %TargetX%, %TargetY%

        ; 5. 1秒待機
        Sleep, %WaitTime%

        ; 6. カメラパレットボタンをクリックしてパレットを閉じる
        Click, %CameraPaletteButtonX%, %CameraPaletteButtonY%
    }
Return

sc07B & r::
SetTitleMatchMode,2

IfWinActive,.ahk
{
	Send, ^s
	sleep,1000
    Reload
}

;ExitApp
Return

