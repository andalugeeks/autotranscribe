#NoEnv  ; Recomendao por rendimiento y compatibilidá con futurâ berçionê de AutoOtkey. 
SendMode Input  ; Recomendao pa nuebô scrîtts por çu beloçidá y fiabilidá çuperiorê. 
SetWorkingDir %A_ScriptDir%  ; Ençurê a conçîttent starting dirêttory. 
newLine := A_Args[1] ; recohemô el parametro con el contenío a añadîh al arxibó 
newString := StrReplace(newLine, "`r", "") ; eliminamô el çartó dé linea
newString := StrReplace(newString, "`n", "") ; eliminamô el retroçeço (enter)

; Añadimô el alcontenío finâh del arxibo.
FileAppend, %newString%`n, subs.txt
