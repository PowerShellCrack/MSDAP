'------------------------------------------
'
' Delete Files based on extensions
'
' USAGE: cscript //nologo 1.deleteEmptyFolders.vbs "D:\Downloads\Torrent\Completed"
'
'-------------------------------------------

Option Explicit

' Declare Variables
Dim fso, path, dDelete, arFiles, nDeleted, n

'Quit if argument does not exist
if WScript.Arguments.Count = 0 then
    wscript.echo "ERROR: No path set."
	wscript.quit
end if

'Since argument is a path get its absolute
Set fso = CreateObject("Scripting.FileSystemObject")
path = fso.GetAbsolutePathName(WScript.Arguments.Item(0))

'List extension to search for deletion
Set dDelete = createobject("scripting.dictionary")
'dDelete.Add "rar", ""
dDelete.Add "jpg", ""
dDelete.Add "png", ""
dDelete.Add "txt", ""
dDelete.Add "torrent", ""
dDelete.Add "nfo", ""
dDelete.Add "lnk", ""
dDelete.Add "htm", ""
dDelete.Add "mht", ""
dDelete.Add "css", ""	
dDelete.Add "gif", ""
dDelete.Add "bat", ""
dDelete.Add "db", ""
dDelete.Add "dvd", ""
dDelete.Add "sample", ""
dDelete.Add "tbn", ""
	
arFiles = array()
SelectFiles path, arFiles, true

nDeleted = 0
wscript.echo "SEARCHING: un-needed files in " & path & "..."
for n = 0 to ubound(arFiles)
	on error resume next 'in case of 'in use' files...
	wscript.echo "DELETING: " & arFiles(n).path
	arFiles(n).delete True
	if err.number <> 0 then
		wscript.echo "ERROR: Unable to delete: " & arFiles(n).path
	else
		nDeleted = nDeleted + 1
	end if
	on error goto 0
next
wscript.echo "COMPLETED: " & nDeleted & " of " & ubound(arFiles)+1 _
	& " eligible files were deleted"

sub SelectFiles(sPath,arFilesToKill,bIncludeSubFolders)
	Dim folder,file,files,fldr,Count
	'on error resume next
	set folder = fso.getfolder(sPath)
	set files = folder.files
	for each file in files
		'''''If Not dDelete.Exists(lcase(fso.getExtensionName(file)))Then
		if dDelete.Exists(lcase(fso.getExtensionName(file))) then
		'If instr(file.name, dDelete) > 0 Then
			'wscript.echo "FOUND:" & dDelete
			count = ubound(arFilesToKill) + 1
			redim preserve arFilesToKill(count)
			set arFilesToKill(count) = file
		end If
	next

	if bIncludeSubFolders then
		for each fldr in folder.subfolders
			SelectFiles fldr.path,arFilesToKill,true
		Next
	end if
end sub

'set oShell = CreateObject("WScript.Shell")
'oShell.run "D:\Downloads\Torrents"
