#Requires AutoHotkey v2.0
#Include VD.ah2

; Alt+Z -> Toggle Windows Terminal Quake mode (Win+`)
!z::Send("#``")

; Alt+N -> Ñ
!n::Send("{U+00F1}")

; Ctrl+Shift+Win+Left/Right -> Mover ventana activa al desktop virtual anterior/siguiente
^+#Left::
{
    hwnd := WinGetID("A")
    VD.MoveWindowToRelativeDesktopNum(hwnd, -1)
    VD.gotoRelativeDesktopNum(-1)
}

^+#Right::
{
    hwnd := WinGetID("A")
    VD.MoveWindowToRelativeDesktopNum(hwnd, 1)
    VD.gotoRelativeDesktopNum(1)
}


