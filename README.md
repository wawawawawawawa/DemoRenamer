# Alien Swarm DemoRenamer

This tool will allow you to automaticly sort recording of your games in a few clicks!

Download and Extract the files, then Run DemoRenamer.exe (or .ahk if you have AutoHotkey installed).

1 ) You will be asked the demos folder (usually the game directory\reactivedrop\).

    ![record](https://i.imgur.com/gkKfBDH.png)

    Every sub-folder will be checked for any .dem file starting by "asrd"

2 ) You will be asked the folder to sort the demo into.

3 ) The tool will then sort them by Date/Server

    Each file will be moved to the (folder selected)/Day/Server/
    Server is actually an IP adress
   
    ![progress](https://i.imgur.com/BKxUsQ5.png)

4 ) The tool will then rename them into asrd_(Date)-(Time)_(MapName)

    ![renamer](https://i.imgur.com/Dl5tkcQ.png)

    Only files starting with "asrd" will be moved/renamed (the [autorecord tool](https://github.com/wawawawawawawa/Alien-Swarm-AutoRecord) automatically name them asrd_X).
