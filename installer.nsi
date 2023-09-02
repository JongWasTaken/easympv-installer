; easympv-installer by Jong
; Licensed under the MIT License

; Please have mercy, i have never worked with NSIS before.


Target x86-unicode
RequestExecutionLevel user
!addplugindir /x86-unicode "nsis-plugins"
!include "MUI2.nsh"
!include "Sections.nsh"
!include 'FileFunc.nsh'
!include "LogicLib.nsh"
!insertmacro Locate
Var /GLOBAL switch_overwrite
!include 'MoveFileFolder.nsh'
Name "mpv & easympv"
Var /GLOBAL MPVDIR
Var /GLOBAL EMPVDIR

!define MUI_ICON "mpv-icon.ico"

;
; PAGES
;

; Page 1: Welcome

;!define MUI_WELCOMEPAGE_TEXT "Lorem Ipsum sir dolor amed"
!insertmacro MUI_PAGE_WELCOME

; Page 2: mpv license
!define MUI_LICENSEPAGE_TEXT_TOP "mpv is licensed under the GPLv2+ License:"
!define  MUI_LICENSEPAGE_CHECKBOX
!insertmacro MUI_PAGE_LICENSE "GPLv2.txt"

; Page 3: easympv credits
!define MUI_LICENSEPAGE_TEXT_TOP "Additionally, easympv uses the following components:"
!define  MUI_LICENSEPAGE_CHECKBOX
!insertmacro MUI_PAGE_LICENSE "Credits.txt"

; Page 4: mpv directory

!define MUI_DIRECTORYPAGE_VARIABLE $MPVDIR
!define MUI_DIRECTORYPAGE_TEXT_TOP "Select where to install mpv to.$\r$\nIf mpv is already installed, select its location instead."
!define MUI_DIRECTORYPAGE_TEXT_DESTINATION "mpv destination folder"
!insertmacro MUI_PAGE_DIRECTORY

; Page 5: components
!insertmacro MUI_PAGE_COMPONENTS

; Page 6: Install
!insertmacro MUI_PAGE_INSTFILES

; Page 7: Finish
!define MUI_FINISHPAGE_TEXT "mpv will now launch for the post-install.$\r$\nIf you selected $\"Register mpv as a media player$\" during installation, a powershell window will appear to complete that process.$\r$\nPlease do not close it."
!define MUI_PAGE_CUSTOMFUNCTION_LEAVE onFinish
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_LANGUAGE "English"
ShowInstDetails show

;
; SECTIONS
;

Section mpv section_mpv
    AddSize 30000

    IfFileExists $MPVDIR\mpv.exe end install

    install:
        DetailPrint 'Downloading mpv...'
        NScurl::http get "https://sourceforge.net/projects/mpv-player-windows/files/latest/download" "$pluginsdir\easympv\mpv.7z" /CANCEL /INSIST /Zone.Identifier /END
        Pop $0
        DetailPrint "Status: $0"
        SetOutPath "$MPVDIR"
        ;File "$pluginsdir\easympv\discordgdsk.zip"
        Nsis7z::ExtractWithDetails "$pluginsdir\easympv\mpv.7z" "Installing package %s..."
    end:
        DetailPrint 'mpv is installed.'
SectionEnd

Section /o "Use git master of easympv" section_easympv_git
    AddSize 0
SectionEnd

Section easympv section_easympv
    AddSize 2500

    IfFileExists $EMPVDIR\scripts\easympv\main.js end install

    install:
        DetailPrint 'Downloading easympv...'
        ${If} ${SectionIsSelected} ${section_easympv_git}
            NScurl::http get "https://github.com/JongWasTaken/easympv/archive/refs/heads/master.zip" "$pluginsdir\easympv\easympv.zip" /CANCEL /INSIST /Zone.Identifier /END
            Pop $0
            DetailPrint "Status: $0"
            nsisunz::Unzip "$pluginsdir\easympv\easympv.zip" "$pluginsdir\easympv\"
            !insertmacro MoveFolder "$pluginsdir\easympv\easympv-master\.git" "$EMPVDIR\.git" "*.*"
        ${Else}
            NScurl::http get "https://github.com/JongWasTaken/easympv/releases/latest/download/release.zip" "$pluginsdir\easympv\easympv.zip" /CANCEL /INSIST /Zone.Identifier /END
            Pop $0
            DetailPrint "Status: $0"
            nsisunz::Unzip "$pluginsdir\easympv\easympv.zip" "$pluginsdir\easympv\"
        ${EndIf}

        !insertmacro MoveFolder "$pluginsdir\easympv\easympv-master\fonts" "$EMPVDIR\fonts" "*.*"
        !insertmacro MoveFolder "$pluginsdir\easympv\easympv-master\scripts\easympv" "$EMPVDIR\scripts\easympv" "*.*"
        SetOutPath "$EMPVDIR"
        File "uninstaller.exe"
        DetailPrint 'Placed uninstaller.'
    end:
        DetailPrint 'easympv is installed.'
SectionEnd

Section YT-DLP section_ytdlp
    AddSize 15000

    IfFileExists "$MPVDIR\yt-dlp.exe" end install

    install:
        DetailPrint 'Downloading YT-DLP...'
        NScurl::http get "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe" "$pluginsdir\easympv\yt-dlp.exe" /CANCEL /INSIST /Zone.Identifier /END
        Pop $0
        DetailPrint "Status: $0"
        !insertmacro MoveFile "$pluginsdir\easympv\yt-dlp.exe" "$MPVDIR\yt-dlp.exe"
    end:
        DetailPrint 'YT-DLP is installed.'
SectionEnd

Section mpvcord section_mpvcord
    AddSize 2500

    IfFileExists "$MPVDIR\discord_game_sdk.dll" end1 install1

    install1:
        DetailPrint 'Downloading Discord Game SDK...'
        NScurl::http get "https://dl-game-sdk.discordapp.net/3.2.1/discord_game_sdk.zip" "$pluginsdir\easympv\discordgdsk.zip" /CANCEL /INSIST /Zone.Identifier /END
        Pop $0
        DetailPrint "Status: $0"
        SetOutPath "$pluginsdir\easympv\"
        ;File "$pluginsdir\easympv\discordgdsk.zip"
        nsisunz::Unzip "$pluginsdir\easympv\discordgdsk.zip" "$pluginsdir\easympv\"
        !insertmacro MoveFile "$pluginsdir\easympv\lib\x86_64\discord_game_sdk.dll" "$MPVDIR\discord_game_sdk.dll"
    end1:
        DetailPrint 'Discord Game SDK is installed.'

    IfFileExists "$EMPVDIR\scripts\mpvcord\main.lua" end2 install2

    install2:
        DetailPrint 'Downloading mpvcord...'
        NScurl::http get "https://raw.githubusercontent.com/yutotakano/mpvcord/master/lua-discordGameSDK.lua" "$pluginsdir\easympv\lua-discordGameSDK.lua" /CANCEL /INSIST /Zone.Identifier /END
        Pop $0
        DetailPrint "Status: $0"
        NScurl::http get "https://raw.githubusercontent.com/yutotakano/mpvcord/master/main.lua" "$pluginsdir\easympv\main.lua" /CANCEL /INSIST /Zone.Identifier /END
        Pop $0
        DetailPrint "Status: $0"
        CreateDirectory "$EMPVDIR\scripts\mpvcord"
        !insertmacro MoveFile "$pluginsdir\easympv\lua-discordGameSDK.lua" "$EMPVDIR\scripts\mpvcord\lua-discordGameSDK.lua"
        !insertmacro MoveFile "$pluginsdir\easympv\main.lua" "$EMPVDIR\scripts\mpvcord\main.lua"
    end2:
        DetailPrint 'mpvcord is installed.'
SectionEnd

Section "Register mpv as a media player" section_register
    AddSize 0
    DetailPrint 'Telling mpv to register itself on next launch...'
    FileOpen $9 "$EMPVDIR\INSTALLER_DATA_REGISTER" w
    FileWrite $9 "the contents of this file dont matter, so hello there"
    FileClose $9

SectionEnd

LangString DESC_section_mpv ${LANG_ENGLISH} "mpv itself, cannot be deselected."
LangString DESC_section_easympv_git ${LANG_ENGLISH} "Select this to use the latest git master version of easympv instead of the stable release."
LangString DESC_section_easympv ${LANG_ENGLISH} "easympv, cannot be deselected."
LangString DESC_section_mpvcord ${LANG_ENGLISH} "Discord integration for mpv."
LangString DESC_section_ytdlp ${LANG_ENGLISH} "Allows mpv to play files from the web, such as YouTube videos. Cannot be deselected."
LangString DESC_section_register ${LANG_ENGLISH} "This will register mpv as a media player and optionally allow you to set it as the default media player."
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${section_mpv} $(DESC_section_mpv)
    !insertmacro MUI_DESCRIPTION_TEXT ${section_easympv_git} $(DESC_section_easympv_git)
    !insertmacro MUI_DESCRIPTION_TEXT ${section_easympv} $(DESC_section_easympv)
    !insertmacro MUI_DESCRIPTION_TEXT ${section_mpvcord} $(DESC_section_mpvcord)
    !insertmacro MUI_DESCRIPTION_TEXT ${section_ytdlp} $(DESC_section_ytdlp)
    !insertmacro MUI_DESCRIPTION_TEXT ${section_register} $(DESC_section_register)
!insertmacro MUI_FUNCTION_DESCRIPTION_END

Function .onInit
    InitPluginsDir
    ;ExecShell open $PLUGINSDIR
    StrCpy $switch_overwrite 0
    !insertmacro SetSectionFlag ${section_mpv} ${SF_RO}
    !insertmacro SetSectionFlag ${section_easympv} ${SF_RO}
    !insertmacro SetSectionFlag ${section_easympv_git} 0
    !insertmacro SetSectionFlag ${section_ytdlp} ${SF_RO}
    StrCpy $MPVDIR "$LocalAppData\mpv"
    CreateDirectory "$MPVDIR"
    StrCpy $EMPVDIR "$AppData\mpv"
    CreateDirectory "$EMPVDIR"
    CreateDirectory "$pluginsdir\easympv\"
FunctionEnd

Function onFinish
    WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\mpv" \
                    "DisplayName" "mpv Media Player"
    WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\mpv" \
                    "UninstallString" "$\"$MPVDIR\mpv.exe$\""
    FileOpen $9 "$EMPVDIR\INSTALLER_DATA_LOCATION" w
    FileWrite $9 "$MPVDIR"
    FileClose $9
    ExecShell open '$MPVDIR\mpv.exe'
FunctionEnd

Function SetFilePermission
    AccessControl::GrantOnFile "$R9" "(S-1-5-32-545)" "FullAccess"
    Push $0
FunctionEnd