#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force

IniRead, FilesFrom, %A_ScriptDir%\DemoRenamer.ini, Settings, FilesFrom
IniRead, FilesTo, %A_ScriptDir%\DemoRenamer.ini, Settings, FilesTo
Recursion := 0

FileSelectFolder, FilesFrom, *%FilesFrom%, 3, Select *.dem Files Folder,
If (!ErrorLevel)
{
	IniWrite, %FilesFrom%, %A_ScriptDir%\DemoRenamer.ini, Settings, FilesFrom
	Gui, Add, Text, vFileCurrent w200, Do you want to check subfolders as well?
	Gui, Add, Button, w100 Section gYes, Yes
	Gui, Add, Button, w100 ys gNo, No
	Gui, Show
}
else
{
	ExitApp
}
return

GuiClose:
{
	ExitApp
}
return

SearchFiles:
{
	FileSelectFolder, FilesTo, *%FilesTo%, 3, Choose Where to Save Sorted Demos,
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
	if (Recursion = 1)
	{
		Loop, Files, %FilesFrom%\*.dem, R
		{
			count += 1
		}
	}
	else if (Recursion = 0)
	{
		Loop, Files, %FilesFrom%\*.dem
		{
			count += 1
		}
	}
	Gui, New
	Gui, Add, Text, vFileCurrent w500, Processing Files...
	Gui, Add, Progress, w500 h20 cBlue Range0-%count% vMyProgress, 0
	Gui, Add, Text, vFileCount w500, 0 of %count%
	Gui, Add, Text, vTextMessage w500, Starting script
	Gui, Show

	if (Recursion = 1)
	{
		Loop, Files, %FilesFrom%\*.dem, R
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
				
				GuiControl,, TextMessage, Moving File...
				
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
	}
	else if (Recursion = 0)
	{
		Loop, Files, %FilesFrom%\*.dem
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
				
				GuiControl,, TextMessage, Moving File...
				
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
}
return

Yes:
{
	Recursion = 1
	Gui, Destroy
	GoSub, SearchFiles
}
return

No:
{
	Recursion = 0
	Gui, Destroy
	GoSub, SearchFiles
}
return