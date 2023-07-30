; easympv-installer by Jong
; Licensed under the MIT License

; Please have mercy, i have never worked with NSIS before.


Target x86-unicode
RequestExecutionLevel user
!addplugindir /x86-unicode "nsis-plugins"
!include "MUI2.nsh"
!include "Sections.nsh"
!include 'FileFunc.nsh'
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
!insertmacro MUI_UNPAGE_WELCOME

; Page 2: Confirm
!insertmacro  MUI_UNPAGE_CONFIRM

; Page 3: Uninstall
!insertmacro MUI_UNPAGE_INSTFILES

; Page 4: Finish
!insertmacro MUI_UNPAGE_FINISH

!insertmacro MUI_LANGUAGE "English"
ShowInstDetails show

;
; SECTIONS
;

Section mpv section_mpv
    AddSize 30000
    DetailPrint 'Removing mpv...'
    RMDir /r "$MPVDIR"
    DetailPrint 'Removed mpv.'
SectionEnd

Section easympv section_plugins
    AddSize 2500
    DetailPrint 'Removing mpv config folder...'
    RMDir /r "$EMPVDIR"
    DetailPrint 'Removed mpv config.'
SectionEnd

LangString DESC_section_mpv ${LANG_ENGLISH} "mpv itself, cannot be deselected."
LangString DESC_section_plugins ${LANG_ENGLISH} "The mpv configuration directory, containing all plugins. Cannot be deselected."
!insertmacro MUI_UNFUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${section_mpv} $(DESC_section_mpv)
    !insertmacro MUI_DESCRIPTION_TEXT ${section_plugins} $(DESC_section_plugins)
!insertmacro MUI_UNFUNCTION_DESCRIPTION_END

Function .onInit
    ;InitPluginsDir
    Sleep 10000
    StrCpy $switch_overwrite 0
    !insertmacro SetSectionFlag ${section_mpv} ${SF_RO}
    !insertmacro SetSectionFlag ${section_plugins} ${SF_RO}
    StrCpy $MPVDIR "$LocalAppData\mpv"
    StrCpy $EMPVDIR "$AppData\mpv"

    IfFileExists "$EMPVDIR\INSTALLER_UNINSTALL_DATA" present notpresent

    present:
        FileOpen $4 "$EMPVDIR\INSTALLER_UNINSTALL_DATA" r
        FileRead $4 $MPVDIR
        FileClose $4
        Return
    notpresent:
        MessageBox MB_OK "The uninstaller has not been launched by easympv and cannot continue."
        Quit
FunctionEnd