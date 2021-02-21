#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force

IniRead, FilesFrom, %A_ScriptDir%\DemoRenamer.ini, Settings, FilesFrom
IniRead, FilesTo, %A_ScriptDir%\DemoRenamer.ini, Settings, FilesTo

FileSelectFolder, FilesFrom, *%FilesFrom%, 3, Choose Which Folder to Process,
If (!ErrorLevel)
{
	IniWrite, %FilesFrom%, %A_ScriptDir%\DemoRenamer.ini, Settings, FilesFrom
}
else
{
	ExitApp
}
FileSelectFolder, FilesTo, *%FilesTo%, 3, Choose Where to Save Files,
If (!ErrorLevel)
{
	IniWrite, %FilesTo%, %A_ScriptDir%\DemoRenamer.ini, Settings, FilesTo
}
else
{
	ExitApp
}

count := 0
error := 0
errorlist := 
Loop, Files, %FilesFrom%\*.dem, R
; Loop, Files, %FilesFrom%\*.dem
{
	count += 1
}

Gui, Add, Text, vFileCurrent w500, Processing Files...
Gui, Add, Progress, w500 h20 cBlue Range0-%count% vMyProgress, 0
Gui, Add, Text, vFileCount w500, 0 of %count%
Gui, Add, Text, vTextMessage w500, Starting script
Gui, Show

Loop, Files, %FilesFrom%\*.dem, R
; Loop, Files, %FilesFrom%\*.dem
{
	GuiControl,, FileCurrent, Processing %A_LoopFileName%
	FoundPos := InStr(A_LoopFileName, "asrd")
	if (FoundPos == 1)
	{
		GuiControl,, FileCount, %A_Index% of %count%
		GuiControl,, TextMessage, Getting Creation Date...
		
		FileGetTime, CreationDate, %A_LoopFileLongPath%, C 
		FormatTime, CreationDate2,%CreationDate%, [yyyy_MM_dd]-[HH_mm_ss]
		FormatTime, CreationDate3,%CreationDate%, yyyy_MM_dd
		
		GuiControl,, TextMessage, Reading File Header...
		
		FileRead, data, *c %A_LoopFileLongPath%
		ServerName := StrGet( &data + 0x10, "UTF-8" )
		MapName := StrGet( &data + 0x218, "UTF-8" )
		
		GuiControl,, TextMessage, Creating Directory...
		
		NewString := StrSplit(ServerName , ":")
		NewStr := NewString[1]
		FileCreateDir, %FilesTo%\%CreationDate3%\%NewStr%\
		
		GuiControl,, TextMessage, Copying File...
		
		; FileCopy, %A_LoopFileLongPath%, %FilesTo%\%CreationDate3%\%NewStr%\asrd_%CreationDate2%_[%MapName%].dem
		FileMove, %A_LoopFileLongPath%, %FilesTo%\%CreationDate3%\%NewStr%\asrd_%CreationDate2%_[%MapName%].dem
	}
	else
	{
		error += 1
		errorlist .= A_LoopFileName "`n"
	}
	
	GuiControl,, MyProgress, +1 
}
if (error > 0)
{
	newcount := count - error
	msgbox, % newcount " files were processed`n" error " files were not processed`n`n" errorlist
}
else
{
	msgbox, % count " files were processed"
}
ExitApp