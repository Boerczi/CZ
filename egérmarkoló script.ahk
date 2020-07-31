SPI_GETMOUSECLICKLOCK = 0x101E
SPI_SETMOUSECLICKLOCK = 0x101F
SPI_GETMOUSECLICKLOCKTIME = 0x2008
SPI_SETMOUSECLICKLOCKTIME = 0x2009


Gui +LastFound
hwnd := WinExist()
Gui, Add, Text
Gui, Add, Checkbox, vlock, Markoló bekapcsolása
Gui, Add, Text
Gui, Add, Text, xs, Mennyi ideig legyen lenyomva az egér gombja, hogy megmarkolja az elemet (1200ms az alap)
Gui, Add, Edit, vlocktime, 1200
Gui, Add, Text,
Gui, Add, Button, Default w200 gApply, Alkalmaz
Gui, Add, Text,
Gui, Add, Text, xs, Gyorsgomb
Gui, Add, Hotkey,   vHK gLabel     ;add a hotkey control
Gui, Add, Text, xs, 
Gui, Add, CheckBox, vCB x+5, Windows gomb plusz modosítónak  ;add a checkbox to allow the Windows key (#) as a modifier.
Gui, Show,,Dynamic Hotkeys
Gui, Show, ,Mouse Settings

Return

GuiEscape:
WinMinimize, ahk_id %hwnd%
Return

GuiClose:
ExitApp

Apply:
Gui, Submit, NoHide
DllCall("SystemParametersInfo", "UInt", SPI_SETMOUSECLICKLOCK, "UInt", 0, "UInt", lock, UInt, 0)
DllCall("SystemParametersInfo", "UInt", SPI_SETMOUSECLICKLOCKTIME, "UInt", 0, "UInt", locktime, UInt, 0)
Return

#MaxThreadsPerHotkey, 2

Label:
 If HK in +,^,!,+^,+!,^!,+^!            ;If the hotkey contains only modifiers, return to wait for a key.
  return
 If (savedHK) {                         ;If a hotkey was already saved...
  Hotkey, %savedHK%, Label1, Off        ;     turn the old hotkey off
  savedHK .= " OFF"                     ;     add the word 'OFF' to display in a message.
 }
 If (HK = "") {                         ;If the new hotkey is blank...
  TrayTip, Label1, %savedHK%, 5         ;     show a message: the old hotkey is OFF
  savedHK =                             ;     save the hotkey (which is now blank) for future reference.
  return                                ;This allows an old hotkey to be disabled without enabling a new one.
 }
 Gui, Submit, NoHide
 If CB                                  ;If the 'Win' box is checked, then add its modifier (#).
  HK := "#" HK
 If StrLen(HK) = 1                      ;If the new hotkey is only 1 character, then add the (~) modifier.
  HK := "~" HK                          ;     This prevents any key from being blocked.
 Hotkey, %HK%, Label1, On               ;Turn on the new hotkey.
 TrayTip, Label1,% HK " ON`n" savedHK   ;Show a message: the new hotkey is ON.
 savedHK := HK                          ;Save the hotkey for future reference.
return


Label1:
T := !T
If (T=1)
{
DllCall("SystemParametersInfo", "UInt", SPI_SETMOUSECLICKLOCK, "UInt", 0, "UInt", true, UInt, 0)
ToolTip, Markoló bekapcsolva
SetTimer, RemoveToolTip, -5000
return

}

else
{
DllCall("SystemParametersInfo", "UInt", SPI_SETMOUSECLICKLOCK, "UInt", 0, "UInt", false, UInt, 0)
ToolTip, Markoló kikapcsolva
SetTimer, RemoveToolTip, -5000
return
}
RemoveTooltip:
Tooltip
return

return