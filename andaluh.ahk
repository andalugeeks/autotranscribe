#NoEnv 
#SingleInstance force
#MenuMaskKey vk19
Menu, Tray, Icon, andalûh-p.ico, , 1 ; set the icon to use when AutoHotkey is suspended
Menu, Tray, Icon, andalûh.ico ; set the icon to use when AutoHotkey is running
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.



~^!p:: ; Ctrl+Alt+a
   Suspend
   if A_IsSuspended ; check if AutoHotkey is suspended
    Menu, Tray, Icon, andalûh-p.ico, , 1 ; set the suspended icon
    else
    Menu, Tray, Icon, andalûh.ico ; set the running icon

return

::abad::abá
::abona::abona
::adeje::adehe
::adra::adra
::adrián::adrián
