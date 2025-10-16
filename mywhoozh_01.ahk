SetKeyDelay, 500

#Requires AutoHotkey v1.1
#NoEnv ; ����
#Warn ; ����
#SingleInstance Force

; MyWhoosh�E�B���h�E�̃^�C�g����ݒ�i�K�v�ɉ����ĕύX���Ă��������j
SetTitleMatchMode, 2
TargetWinTitle := "MyWhoosh" ; �A�v���P�[�V�����̃E�B���h�E�^�C�g���̈ꕔ

; ��{���W�ƊԊu�̐ݒ�
CoordMode, Mouse, Screen ; �}�E�X���W���X�N���[���S�̂ɑ΂��Đݒ�
CameraPaletteButtonX := 650
CameraPaletteButtonY := 1015
UturnButtonX := 950
UturnButtonY := 1015
WaitTime := 1000 ; �҂����� (�~���b)

; �J�����{�^���̍��W�v�Z
StartX_Upper := 760
StartY_Upper := 830
StartY_Lower := 930
X_Interval := 97.5

; ----------------------------------------------------------------------
; ���W�v�Z�ƃ}�b�s���O
; ----------------------------------------------------------------------
ButtonCoords := {}
; ��i (1-5) �̍��W�v�Z
Loop, 5
{
    ButtonNum := A_Index
    X_Coord := Round(StartX_Upper + (A_Index - 1) * X_Interval)
    Y_Coord := StartY_Upper
    ButtonCoords[ButtonNum] := {X: X_Coord, Y: Y_Coord}
}
; ���i (6-10) �̍��W�v�Z
Loop, 5
{
    ButtonNum := A_Index + 5
    X_Coord := Round(StartX_Upper + (A_Index - 1) * X_Interval)
    Y_Coord := StartY_Lower
    ButtonCoords[ButtonNum] := {X: X_Coord, Y: Y_Coord}
}

; �L�[�ƑΉ�����{�^���ԍ� (1-9) �̃}�b�s���O
KeyMap := {}
Loop, 9
{
    KeyMap[A_Index] := A_Index ; "1" -> 1, ..., "9" -> 9
    KeyMap["Numpad" . A_Index] := A_Index
}

; ----------------------------------------------------------------------
; ���C������: �z�b�g�L�[��`
; ----------------------------------------------------------------------

; 1����9�܂ł̃z�b�g�L�[�o�^
Loop, 9
{
    KeyName := A_Index
    NumPadName := "Numpad" . A_Index
    Hotkey, ~%KeyName%, SwitchCamera
    Hotkey, ~%NumPadName%, SwitchCamera
}

; 0 (�[��) �L�[�� Numpad0 �𖾎��I�ɒǉ� (�J����10�ɑΉ�)
Hotkey, ~0, SwitchCamera
Hotkey, ~Numpad0, SwitchCamera

; U-turn �z�b�g�L�[��`
Hotkey, ~-, ClickUturnButton
Hotkey, ~NumpadSub, ClickUturnButton

Return

; ----------------------------------------------------------------------
; U-turn �{�^���N���b�N �T�u���[�`��
; ----------------------------------------------------------------------
ClickUturnButton:
    ; ���݃A�N�e�B�u�ȃE�B���h�E��MyWhoosh�ł��邱�Ƃ��m�F
    IfWinActive, %TargetWinTitle%
    {
        ; U-turn �{�^�����N���b�N
        Click, %UturnButtonX%, %UturnButtonY%
    }
Return

; ----------------------------------------------------------------------
; �J�����؂�ւ��T�u���[�`��
; ----------------------------------------------------------------------
SwitchCamera:
    ; ���݃A�N�e�B�u�ȃE�B���h�E��MyWhoosh�ł��邱�Ƃ��m�F
    IfWinActive, %TargetWinTitle%
    {
        ; �����ꂽ�z�b�g�L�[�� (~�͏���)
        PressedKey := RegExReplace(A_ThisHotkey, "^~")
        
        ; 0�܂���Numpad0�������ꂽ�ꍇ�́A�{�^��10�Ƀ}�b�s���O
        If (PressedKey = "0" or PressedKey = "Numpad0")
        {
            ButtonNumber := 10
        }
        ; Numpad1-9�̏ꍇ�̏���
        Else If InStr(PressedKey, "Numpad")
        {
            ; Numpad����菜�������� ('1'...'9')���擾
            StringReplace, CleanKey, PressedKey, Numpad
            ButtonNumber := KeyMap[CleanKey]
        }
        ; �ʏ�̃L�[1-9�̏ꍇ�̏���
        Else
        {
            ButtonNumber := KeyMap[PressedKey]
        }
        
        
        If (ButtonNumber = "") ; �}�b�s���O�ɂȂ��L�[�̏ꍇ�͉������Ȃ�
            Return

        ; 1. �J�����p���b�g�{�^�����N���b�N���ăp���b�g���J��
        Click, %CameraPaletteButtonX%, %CameraPaletteButtonY%

        ; 2. 1�b�ҋ@
        Sleep, %WaitTime%

        ; 3. �Ή�����J�����{�^���̍��W���擾
        TargetX := ButtonCoords[ButtonNumber].X
        TargetY := ButtonCoords[ButtonNumber].Y

        ; 4. �J�����{�^�����N���b�N
        Click, %TargetX%, %TargetY%

        ; 5. 1�b�ҋ@
        Sleep, %WaitTime%

        ; 6. �J�����p���b�g�{�^�����N���b�N���ăp���b�g�����
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

