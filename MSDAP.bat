@ECHO Off & Setlocal enableextensions enabledelayedexpansion
REM ============== Variables ============================
set DATESTAMP=!DATE:~10,4!!DATE:~4,2!!DATE:~7,2!
set TIMESTAMP=!TIME:~0,2!:!TIME:~3,2!:!TIME:~6,2!
set DATEANDTIME=!DATESTAMP! !TIMESTAMP!
set _LogPath = %~dp0Logs
set starthour=5
set endhour=22
set _H1=N
set _H2=N
set _BCK=N
set _TVSourcePath=F:\Media\TV Series
set _MVSourcePath=E:\Media\Movies
set _BCKDestPath=E:\Media\TV Series


set _DropboxCheck=N
set _DropBoxSizeCheck=Y
set _DropBoxSizeLimit=1,000,000,000
set _DropboxEXEPath=C:\Program Files (x86)\Dropbox\Client
set _DropboxPath=!userprofile!\Dropbox\Camera Uploads

set _DropboxBCK=Y
set _DropboxBCKDest=\\SERVER\SharedProfiles\Dropbox

set _UTorrentCheck=N
set _UTorrentPath=C:\Users\Administrator\AppData\Roaming\uTorrent
Set _UpdateIPTracker=N

set _VuzeCheck=N
set _VuzePath=C:\Program Files\Vuze

set _EMBYCheck=N
set _EMBYPath=C:\Users\Administrator\AppData\Roaming\Emby-Server\System

set _PlexCheck=Y
set _PlexPath=C:\Program Files (x86)\Plex\Plex Media Server

set _RunPlexScannerList=N
set _PlexListExportPath=E:\Data\Plex\PlexLibrary.txt

set _RunPlexWatch=N
set _PlexWatchPath=E:\Data\Plex\plexWatch

set _TVRenameCheck=Y
set _TVRenamePath=C:\Program Files (x86)\TVRename

set _PeerBlockCheck=Y
set _PeerBlockPath=C:\Program Files\PeerBlock

set _GenieCheck=N
set _GeniePath=C:\Program Files (x86)\NETGEAR Genie\bin

set _7ZipPath=C:\Program Files\7-Zip
set _7ZipArchivePwd=Password

set _SeedBoxCheckForRar=Y
set _SeedBoxDownLocation=E:\Data\Downloads\Seedbox

set _CompletedTorrents=E:\Data\Downloads\Torrents\Completed
set _ProcessedTorrents=E:\Data\Downloads\Torrents\Processed
set _DeletedTorrents=E:\Data\Downloads\Torrents\Deleted
set _FailedTorrents=E:\Data\Downloads\Torrents\Failed

Set _PlexServiceCheck=Y
Set _SonarrServiceCheck=Y
Set _EMBYServiceCheck=N

Set _OldFileCleanup=Y

IF EXIST "!_MVSourcePath!" (GOTO FDRIVECHECK) ELSE (GOTO EDRIVEERROR)

:FDRIVECHECK
IF EXIST "!_TVSourcePath!" (GOTO CONTINUE) ELSE (GOTO FDRIVEERROR)

:CONTINUE
REM =========== SCRIPT ========================================
CLS
ECHO.								
ECHO	               TV Monitoring and Processing script		
ECHO.								
ECHO	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
ECHO.
FOR /F "tokens=1 delims=:" %%A IN ('ECHO %time%') DO (
	ECHO CHECK:       Current Hour is: %%A
	
	if %%A GEQ !starthour! set _H1=Y
	ECHO CHECK:       Is script running within starting hour? !_H1!
	if %%A LEQ !endhour! set _H2=Y
	ECHO CHECK:       Is script running within ending hour? !_H2! 

	ECHO STARTED: Script started: !DATEANDTIME! >> "%~dp0logs\MSDAP-!DATESTAMP!.log"
	REM ECHO ---------------------------------------------- >> "%~dp0logs\MSDAP-!DATESTAMP!.log"

	REM Run if start time is within the start and end hours
	if [!_H1!!_H2!] == [YY] (
		REM Close programs during processing then start it back up
		ECHO ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		ECHO  VERIFIED:     It IS within the hours set, processing episodes 
		ECHO ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		ECHO RUNNING:     Processing TV Shows...
		ECHO ACTIVATE: Processing TV Shows... >> "%~dp0logs\MSDAP-!DATESTAMP!.log"
		if !_uTorrentCheck! == Y (	
			tasklist /FI "IMAGENAME eq uTorrent.exe" 2>NUL | find /I /N "uTorrent.exe">NUL
			if !ERRORLEVEL! EQU 0 (
				ECHO KILL:        utorrent will be terminated
				ECHO KILL: utorrent will be terminated >> "%~dp0logs\MSDAP-!DATESTAMP!.log"
				taskkill /F /IM "uTorrent.exe"
				timeout 10 > NUL
				if !_UpdateIPTracker! == Y (
					ECHO UPDATE: Updating uTorrent's IP filter list >> "%~dp0logs\MSDAP-!DATESTAMP!.log"
					if exist ipfilter.dat copy ipfilter.dat ipfilter.bak > nul
					if exist ipfilter.dat del ipfilter.dat
					!appdata!\uTorrent\wget.exe -r --tries=3 http://emulepawcio.sourceforge.net/nieuwe_site/Ipfilter_fakes/ipfilter.dat -O ipfilter.dat
				)
			) ELSE (
				ECHO CHECK:     utorrent is NOT running
				ECHO CHECK: utorrent is NOT running >> "%~dp0logs\MSDAP-!DATESTAMP!.log"
			) 
		)
	
		if !_VuzeCheck! == Y (	
			tasklist /FI "IMAGENAME eq Azureus.exe" 2>NUL | find /I /N "Azureus.exe">NUL
			if !ERRORLEVEL! EQU 0 (
				ECHO KILL:        Azureus will be terminated
				ECHO KILL: Azureus will be terminated >> "%~dp0logs\MSDAP-!DATESTAMP!.log"
				start "Azureus Closedown" "!_VuzePath!\Azureus.exe" --closedown
				timeout 10 > NUL
			) ELSE (
				ECHO CHECK:     Azureus is NOT running
				ECHO CHECK: Azureus is NOT running >> "%~dp0logs\MSDAP-!DATESTAMP!.log"
			) 
		)

		if !_SeedBoxCheckForRar! == Y (	
			tasklist /FI "IMAGENAME eq winscp.exe" 2>NUL | find /I /N "winscp.exe">NUL
			if !ERRORLEVEL! EQU 0 (
				ECHO KILL:        WinSCP will be terminated
				ECHO KILL: WinSCP will be terminated >> "%~dp0logs\MSDAP-!DATESTAMP!.log"
				taskkill /F /IM "winscp.exe"
				timeout 10 > NUL
			) ELSE (
				ECHO CHECK:     WinSCP is NOT running
				ECHO CHECK: WinSCP is NOT running >> "%~dp0logs\MSDAP-!DATESTAMP!.log"
			) 
			ECHO RUNNING: Downloading rar from dediseedbox >> "%~dp0logs\MSDAP-!DATESTAMP!.log"
			"%~dp0bin\winscp.com" /script="%~dp0configs\winscp-getrar.txt" /log="%~dp0logs\WINSCP-!DATESTAMP!.log"
			ECHO RUNNING: Unzipping rar files >> "%~dp0logs\MSDAP-!DATESTAMP!.log"
			if exist "!_SeedBoxDownLocation!\*.rar" "!_7ZipPath!\7z.exe" x "!_SeedBoxDownLocation!\*.rar" -o"!_SeedBoxDownLocation!\" -p!_7ZipArchivePwd! -aoa
			SET UNZIPERROR=!ERRORLEVEL!
			if !UNZIPERROR! EQU 0 (
				DEL "!_SeedBoxDownLocation!\*.rar" > NUL
			) ELSE (
				ECHO ERROR: Unable to unzip files. ErrorCode: !UNZIPERROR!
			)
		)
		
		
	) ELSE (
   
		ECHO ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		ECHO  VERIFIED:      It is NOT within the hours set, not processing episodes 
		ECHO ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	)
)

if !_TVRenameCheck! == Y (
	ECHO RUNNING:     File Extensions Removal...   
	cscript //nologo "%~dp0scripts\deletefilesExtensions.vbs" "!_CompletedTorrents!" >> "%~dp0logs\MSDAP-!DATESTAMP!.log"
	cscript //nologo "%~dp0scripts\deletefilesExtensions.vbs" "!_SeedBoxDownLocation!" >> "%~dp0logs\MSDAP-!DATESTAMP!.log"
			
	ECHO RUNNING: Scanning download folder for missing TV shows >> "%~dp0logs\MSDAP-!DATESTAMP!.log"
	REM SWITCH TO USE: /hide /ignoremissing /createmissing /scan /doall /quit
	"!_TVRenamePath!\TVRename.exe" /hide /createmissing /doall
	
	:RSSTORRENT
	timeout 5 > NUL	
	powershell -ExecutionPolicy bypass -noprofile -file "%~dp0scripts\Get-RSSTorrents.ps1"
	If !ERRORLEVEL! EQU 1 GOTO RSSTORRENT
	If !ERRORLEVEL! EQU 2 GOTO MOVE
	If !ERRORLEVEL! EQU 3 GOTO UPLOAD
	
	:UPLOAD
	"%~dp0bin\winscp.com" /script="%~dp0configs\winscp-uploadfiles.txt"
	If !ERRORLEVEL! NEQ 0 GOTO CLEANUP

	:MOVE
	move "E:\Data\Downloads\Torrents\Files\*.torrent" "!_ProcessedTorrents!">NUL

	:CLEANUP
	if !_OldFileCleanup! == Y (
		ECHO RUNNING:     File Cleanup.. 
		ECHO RUNNING:     File Cleanup... >> "%~dp0logs\MSDAP-!DATESTAMP!.log"
		cscript //nologo "%~dp0scripts\deletefilesExtensions.vbs" "!_TVSourcePath!" >> "%~dp0logs\MSDAP-!DATESTAMP!.log"
		::cscript //nologo "%~dp0scripts\keepOnlyRecent.vbs" 14 "!_CompletedTorrents!" >> "%~dp0logs\MSDAP-!DATESTAMP!.log"
		cscript //nologo "%~dp0scripts\keepOnlyRecent.vbs" 30 "!_DeletedTorrents!" >> "%~dp0logs\MSDAP-!DATESTAMP!.log"
		cscript //nologo "%~dp0scripts\keepOnlyRecent.vbs" 14 "!_SeedBoxDownLocation!" >> "%~dp0logs\MSDAP-!DATESTAMP!.log"
		cscript //nologo "%~dp0scripts\keepOnlyRecent.vbs" 30 "!_ProcessedTorrents!" >> "%~dp0logs\MSDAP-!DATESTAMP!.log"
		cscript //nologo "%~dp0scripts\keepOnlyRecent.vbs" 7 "%~dp0logs" >> "%~dp0logs\MSDAP-!DATESTAMP!.log"
		::cscript //nologo "%~dp0scripts\deleteEmptyFolders.vbs" "!_CompletedTorrents!" >> "%~dp0logs\MSDAP-!DATESTAMP!.log"
		ECHO This file is a place holder so this folder does not get deleted > "!_SeedBoxDownLocation!\keep_me_safe"
		cscript //nologo "%~dp0scripts\deleteEmptyFolders.vbs" "!_SeedBoxDownLocation!" >> "%~dp0logs\MSDAP-!DATESTAMP!.log"
		ECHO RUNNING:     IPCAMS Photos Removal...  
		ECHO RUNNING:     IPCAMS Photos Removal... >> "%~dp0logs\MSDAP-!DATESTAMP!.log"
		cscript //nologo "%~dp0scripts\keepOnlyRecent.vbs" 60 "E:\Media\YIPC\IPCAM01" >> "%~dp0logs\MSDAP-!DATESTAMP!.log"
		cscript //nologo "%~dp0scripts\keepOnlyRecent.vbs" 60 "E:\Media\YIPC\IPCAM02" >> "%~dp0logs\MSDAP-!DATESTAMP!.log"
	)
	mkdir "!_SeedBoxDownLocation!" >NUL  2>NUL
	mkdir "!_CompletedTorrents!" >NUL  2>NUL
)

ECHO RUNNING:      Check running processes... >> "%~dp0logs\MSDAP-!DATESTAMP!.log"
REM !!! PLEX SERVER PROCESS CHECK !!!
if !_PlexServiceCheck! == Y (
	tasklist /FI "IMAGENAME eq PlexService.exe" 2>NUL | find /I /N "PlexService.exe">NUL
	if !ERRORLEVEL! EQU 0 (
		ECHO CHECK:       Plex Service is started
		ECHO CHECK: Plex Service is started >> "%~dp0logs\MSDAP-!DATESTAMP!.log"
	) ELSE (
		net start PlexService
		ECHO STARTING: Plex Service >> "%~dp0logs\MSDAP-!DATESTAMP!.log"
	)
)

if !_RunPlexWatch! == Y (
	::START /d "!_PlexWatchPath!" plexWatch.exe
	START "" "!_PlexWatchPath!\plexWatch.exe"
)

if !_RunPlexScannerList! == Y (
	ECHO ID:SectionName > "!_PlexListExportPath!"
	"!_PlexPath!\Plex Media Scanner.exe" --list >> "!_PlexListExportPath!"
)

if !_PlexCheck! == Y (
	tasklist /FI "IMAGENAME eq Plex Media Server.exe" 2>NUL | find /I /N "Plex Media Server.exe">NUL
	if !ERRORLEVEL! EQU 0 (
		ECHO CHECK:       Plex Media Server is running
		ECHO CHECK: Plex Media Server is running >> "%~dp0logs\MSDAP-!DATESTAMP!.log"
	) ELSE (
		START "" "!_PlexPath!\Plex Media Server.exe"
		ECHO STARTING: Plex Media Server >> "%~dp0logs\MSDAP-!DATESTAMP!.log"
	)
)

REM !!! EMBY CHECK !!!
if !_EMBYCheck! == Y (
	tasklist /FI "IMAGENAME eq MediaBrowser.ServerApplication.exe" 2>NUL | find /I /N "MediaBrowser.ServerApplic">NUL
	if !ERRORLEVEL! EQU 0 (
		ECHO CHECK:       Emby is running
		ECHO CHECK: Emby is running >> "%~dp0logs\MSDAP-!DATESTAMP!.log"
	) ELSE (
		::net start Emby
		START "" "!_EMBYPath!\MediaBrowser.ServerApplication.exe"
		ECHO STARTING: Emby Server >> "%~dp0logs\MSDAP-!DATESTAMP!.log"
	)
)

if !_EMBYServiceCheck! == Y (
	tasklist /FI "IMAGENAME eq MediaBrowser.ServerApplication.exe" 2>NUL | find /I /N "MediaBrowser.ServerApplic">NUL
	if !ERRORLEVEL! EQU 0 (
		ECHO CHECK:       Emby service is started
		ECHO CHECK: Emby service is started >> "%~dp0logs\MSDAP-!DATESTAMP!.log"
	) ELSE (
		net start Emby
		ECHO STARTING: Emby service >> "%~dp0logs\MSDAP-!DATESTAMP!.log"
	)
)

REM !!! PEERBLOCK CHECK !!!
if !_PeerBlockCheck! == Y (
	tasklist /FI "IMAGENAME eq peerblock.exe" 2>NUL | find /I /N "peerblock.exe">NUL
	if !ERRORLEVEL! EQU 0 (
		ECHO CHECK:       PeerBlock is running
		ECHO CHECK: PeerBlock is running >> "%~dp0logs\MSDAP-!DATESTAMP!.log"
	) ELSE (
		START /d "!_PeerBlockPath!" peerblock.exe
		ECHO STARTING: PeerBlock >> "%~dp0logs\MSDAP-!DATESTAMP!.log"
	)
)	

REM !!! RUNNING TORRENT CLIENT CHECK !!!
if !_VuzeCheck! == Y (	
	tasklist /FI "IMAGENAME eq Azureus.exe" 2>NUL | find /I /N "Azureus.exe">NUL
	if !ERRORLEVEL! EQU 0 (
		ECHO CHECK:       Azureus is running
		ECHO CHECK: Azureus is running >> "%~dp0logs\MSDAP-!DATESTAMP!.log"
	) ELSE (
		START /d "!_VuzePath!" Azureus.exe
		ECHO STARTING: Azureus >> "%~dp0logs\MSDAP-!DATESTAMP!.log"
	)
)

if !_UTorrentCheck! == Y (	
	tasklist /FI "IMAGENAME eq uTorrent.exe" 2>NUL | find /I /N "uTorrent.exe">NUL
	if !ERRORLEVEL! EQU 0 (
		ECHO CHECK:       utorrent is running
		ECHO CHECK: utorrent is running >> "%~dp0logs\MSDAP-!DATESTAMP!.log"
	) ELSE (
		START "" "!_UTorrentPath!\uTorrent.exe"
		ECHO STARTING: uTorrent >> "%~dp0logs\MSDAP-!DATESTAMP!.log"
	) 
) 

if !_SonarrServiceCheck! == Y (
	tasklist /FI "IMAGENAME eq NzbDrone.Console.exe" 2>NUL | find /I /N "NzbDrone.Console.exe">NUL
	if !ERRORLEVEL! EQU 0 (
		ECHO CHECK:       SONARR service is started
		ECHO CHECK: SONARR service is started >> "%~dp0logs\MSDAP-!DATESTAMP!.log"
	) ELSE (
		net start NzbDrone
		ECHO STARTING: SONARR service >> "%~dp0logs\MSDAP-!DATESTAMP!.log"
	)
)


if !_GenieCheck! == Y (
	tasklist /FI "IMAGENAME eq NETGEARGenie.exe" 2>NUL | find /I /N "NETGEARGenie.exe">NUL
	if !ERRORLEVEL! EQU 0 (
		ECHO CHECK:       NETGEARGenie.exe is running
		ECHO CHECK: NETGEARGenie.exe is running >> "%~dp0logs\MSDAP-!DATESTAMP!.log"
	) ELSE (
		START /d "!_GeniePath!" NETGEARGenie.exe
		ECHO STARTING: NETGEARGenie.exe >> "%~dp0logs\MSDAP-!DATESTAMP!.log"
	)
)
		

if !_BCK! == Y (
	ECHO RUNNING:       Robocopy Backup
	ECHO RUNNING: Robocopy Backup >> "%~dp0logs\MSDAP-!DATESTAMP!.log"
	robocopy "!_TVSourcePath!" "!_BCKDestPath!" /MIR /R:10 /W:10 /ETA /X /NP /NJH /NDL /NJS /XF desktop.ini >> "%~dp0logs\MSDAP-!DATESTAMP!.log"
) ELSE (
	ECHO DISABLED: Robocopy Backup >> "%~dp0logs\MSDAP-!DATESTAMP!.log"
)


if !_DropboxCheck! == Y (
	tasklist /FI "IMAGENAME eq Dropbox.exe" 2>NUL | find /I /N "Dropbox.exe">NUL
	if !ERRORLEVEL! EQU 0 (
		ECHO CHECK:       Dropbox is running
		ECHO CHECK: Dropbox is running >> "%~dp0logs\MSDAP-!DATESTAMP!.log"
	) ELSE (
		START "" "!_DropboxEXEPath!\Dropbox.exe"
		ECHO STARTING: Dropbox >> "%~dp0logs\MSDAP-!DATESTAMP!.log"
		timeout 10
	)

	@For /F "tokens=*" %%a IN ('"dir /s "!_DropboxPath!" | find "bytes" | find /v "free""') do @Set folderinfo=%%a
	@For /f "tokens=1,2 delims=)" %%a in ("!folderinfo!") do @set filesout=%%a&set foldersize=%%b
	ECHO CHECK: Dropbox folder size is:!foldersize! >> "%~dp0logs\MSDAP-!DATESTAMP!.log"
	if !foldersize! GTR !_DropBoxSizeLimit! (
		ECHO RUNNING:   Dropbox Backup and cleanup
		ECHO RUNNING: Dropbox Backup and cleanup >> "%~dp0logs\MSDAP-!DATESTAMP!.log"
		robocopy "!_DropboxPath!" "!_DropboxBCKDest!" /MOVE /R:10 /W:10 /NP /XX /NJH /NDL /NJS /XF .dropbox folderInfo.inc desktop.ini >> "%~dp0logs\MSDAP-!DATESTAMP!.log"	
	) ELSE (
		if !_DropboxBCK! == Y (
			ECHO RUNNING:     Dropbox Backup
			ECHO RUNNING: Dropbox Backup >> "%~dp0logs\MSDAP-!DATESTAMP!.log"
			robocopy "!_DropboxPath!" "!_DropboxBCKDest!" /R:10 /W:10 /NP /XX /NJH /NDL /NJS /XF .dropbox folderInfo.inc desktop.ini >> "%~dp0logs\MSDAP-!DATESTAMP!.log"
		) ELSE (
			ECHO DISABLED: Dropbox Backup >> "%~dp0logs\MSDAP-!DATESTAMP!.log"
		)
	)
) ELSE (
	ECHO DISABLED: Dropbox Backup >> "%~dp0logs\MSDAP-!DATESTAMP!.log"
)

ECHO END: Script finished: !DATEANDTIME! >> "%~dp0logs\MSDAP-!DATESTAMP!.log"
GOTO EOF

:EDRIVEERROR
ECHO END: Script unable to finish, missing E: drive: !DATEANDTIME! >> "%~dp0logs\MSDAP-!DATESTAMP!.log"
GOTO EOF

:FDRIVEERROR
ECHO END: Script unable to finish, missing F: drive: !DATEANDTIME! >> "%~dp0logs\MSDAP-!DATESTAMP!.log"
GOTO EOF


:EOF
ECHO ========================================== >> "%~dp0logs\MSDAP-!DATESTAMP!.log"
timeout 10
EXIT
