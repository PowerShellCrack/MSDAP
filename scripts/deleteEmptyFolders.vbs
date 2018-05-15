'------------------------------------------
'
' Delete Empty Folders
'
' USAGE: cscript //nologo 2.deleteEmptyFolders.vbs "D:\Downloads\Torrent\Completed"
'
'-------------------------------------------

Option Explicit

' Declare Variables
dim fso, strPath, foldersToDelete(100000), i, ii 

'Quit if argument does not exist
if WScript.Arguments.Count = 0 then
    wscript.echo "ERROR: No path set."
	wscript.quit
end if

'Since argument is a path get its absolute
Set fso = CreateObject("Scripting.FileSystemObject")
strPath = fso.GetAbsolutePathName(WScript.Arguments.Item(0))

If fso.FolderExists(strPath) Then
	Wscript.Echo "FOUND: Folder path found: " & strPath
	If fso.GetFolder(strPath).SubFolders.count = 0 Then
		Wscript.Echo "FOUND: Folder path has not subfolders, exiting"
		wscript.quit
	End If
Else
	Wscript.Echo "ERROR: Folder does not exist:"  & strPath
	wscript.quit
End If


do 
	for ii = 0 to i-1 
		'if vbNo = msgbox ("delete " & foldersToDelete(ii) & " ?",vbYesNo) then wscript.quit 
		fso.deleteFolder (foldersToDelete(ii)) 
		wscript.echo "REMOVING: " & foldersToDelete(ii) & " directory"
	next 

	i = 0 
		ListEmptyFolders(strPath) 
	loop while i > 0 

	set fso = nothing 
	wscript.echo "COMPLETED: Empty Folder Check" 
	'----- 
	
	
sub ListEmptyFolders(folderSpec) 
	Dim folder 

	if fso.GetFolder(folderSpec).SubFolders.count = 0 _ 
	   and fso.GetFolder(folderSpec).Files.count = 0 then 
	   foldersToDelete(i) = folderSpec 
	   i = i + 1 
	end if 

	For Each folder In fso.GetFolder(folderSpec).Subfolders 
	   ListEmptyFolders(folder.path) 
	Next 
end sub 
