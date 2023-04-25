#SingleInstance force
#NoTrayIcon
DllCall("AllocConsole")
WinHide % "ahk_id " DllCall("GetConsoleWindow", "ptr")
spacevar := true
trâccrîççión := true
return

^!p::
    ; pauçamô la trâccrîççión 
    trâccrîççión := !trâccrîççión
    if (trâccrîççión){
        ShowNotification("AutoTranscribe ÂTTIBO", "La trâccrîççion automatica êttá âttiba.", 3000)
    }
    else {
        ShowNotification("AutoTranscribe PAUÇA", "La trâccrîççion automatica êttá pauçá.", 3000)
    }
return

ShowNotification(title, message, duration) {
    ; Display the notification using TrayTip
    TrayTip, % title, % message, % duration
}

#InputLevel 1
; teclâ que dîpparan la çûttituçion dé palabrâ 
$Space::
    if (spacevar) {
        Send {Space}
    } else {
        if (trâccrîççión) {
            Clipboard := ""  ; limpia el portapapelê
            Clipboard := " "
            Send {_}
        }
        else{
            Send {Space}
        }
    }
    spacevar := true
return

$Enter::
    if (spacevar) {
        Send {Enter}
    } else {
        if (trâccrîççión) {
            Clipboard := ""  ; limpia el portapapelê
            Clipboard := "`n"
            Send {_}
        }
        else{
            Send {Enter}
        }
    }
    spacevar := true
return

$,::
    Clipboard := ""  ; limpia el portapapelê
    if (spacevar) {
        Send {,}
    } else {
        if (trâccrîççión) {
            Clipboard := ","
            Send {_}
        }
        else{
            Send {,}
        }
    }
    spacevar := true
return

$.::
    Clipboard := ""  ; limpia el portapapelê
    if (spacevar) {
        Send {.}
    } else {
        if (trâccrîççión) {
            Clipboard := "."
            Send {_}
        }
        else{
            Send {.}
        }
    }
    spacevar := true
return

$?::
    Clipboard := ""  ; limpia el portapapelê
    if (spacevar) {
        Send {?}
    } else {
        if (trâccrîççión) {
            Clipboard := "?"
            Send {_}
        }
        else{
            Send {?}
        }
    }
    spacevar := true
return

$/::
    Clipboard := ""  ; limpia el portapapelê
    if (spacevar) {
        Send {/}
    } else {
        if (trâccrîççión) {
            Clipboard := "/"
            Send {_}
        }
        else{
            Send {/}
        }
    }
    spacevar := true
return

$-::
    Clipboard := ""  ; limpia el portapapelê
    if (spacevar) {
        Send {-}
    } else {
        if (trâccrîççión) {
            Clipboard := "-"
            Send {_}
        }
        else{
            Send {-}
        }
    }
    spacevar := true
return


; rehîttrando cuando una tecla êh purçá 
; rehîttramô cuando çé çuerta la tecla y açînnamô el balôh farço a la bariable spaçebâh 
~*a up::
    spacevar := false
return

~*z up::
    spacevar := false
return

~*e up::
    spacevar := false
return

~*r up::
    spacevar := false
return

~*t up::
    spacevar := false
return

~*y up::
    spacevar := false
return

~*u up::
    spacevar := false
return

~*i up::
    spacevar := false
return

~*o up::
    spacevar := false
return

~*p up::
    spacevar := false
return

~*q up::
    spacevar := false
return

~*s up::
    spacevar := false
return

~*d up::
    spacevar := false
return

~*f up::
    spacevar := false
return

~*g up::
    spacevar := false
return

~*h up::
    spacevar := false
return

~*j up::
    spacevar := false
return

~*k up::
    spacevar := false
return

~*l up::
    spacevar := false
return

~*m up::
    spacevar := false
return

~*w up::
    spacevar := false
return

~*x up::
    spacevar := false
return

~*c up::
    spacevar := false
return

~*v up::
    spacevar := false
return

~*b up::
    spacevar := false
return

~*n up::
    spacevar := false
return

~*$SC01A up:: ; SC01A is the scan code for "ñ" key
    spacebar := true
return

~*1 up::
    spacevar := True
return

~*2 up::
    spacevar := True
return

~*3 up::
    spacevar := True
return

~*4 up::
    spacevar := True
return

~*5 up::
    spacevar := True
return

~*6 up::
    spacevar := True
return

~*7 up::
    spacevar := True
return

~*8 up::
    spacevar := True
return

~*9 up::
    spacevar := True
return

~*0 up::
    spacevar := True
return

;trâccribe er têtto çelêççionao
^!m::
    Clipboard := ""
    SendInput, ^c
    ClipWait, 2
    if ErrorLevel
        return
    selected_text := Clipboard
    cmd := A_ScriptDir . "\andaluh-cli.exe " . """" selected_text . """"
    shell := ComObjCreate("WScript.Shell")
    exec := shell.Exec(ComSpec " /C " cmd )
    andaluh := exec.StdOut.ReadAll()
    my_string := StrReplace(andaluh, "([\t\s\n]+)", "")
    Send,  %my_string%{BS 2}
Return
