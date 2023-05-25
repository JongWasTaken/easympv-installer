# easympv-installer

This repository contains both the linux installer script as well as the source code for the Windows installer.  

## Windows Installer Outline

0. Generic welcome screen.
1. License agreement.
2. Check for mpv. If it is not found, ask the if it is installed.  
    If yes, ask for location, then skip next step.  
    If no, proceed.
3. Ask user where to install mpv.
4. Prompt for installation of additional components, like YTDLP and DiscordGameSDK.
5. Download, extract and move mpv to user-selected location.  
    Download, extract and move latest easympv release to `%APPDATA%\\mpv`.  
    Create simple easympv.conf, set mpv location and enable migration.
6. Install any selected additional components.
7. Finish screen. Ask whether to launch mpv now for the first time setup, or just exit.

## Relevant links
[NSIS Documentation](https://nsis.sourceforge.io/Docs/Chapter2.html)  
[NSIS curl plugin](https://github.com/negrutiu/nsis-nscurl)  
