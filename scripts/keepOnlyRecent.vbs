'------------------------------------------
'
' Keep only recent files
'
' USAGE: cscript //nologo 3.keepOnlyRecent.vbs 7 "D:\Downloads\Torrent\Completed"
'
'-------------------------------------------

Option Explicit

' Declare Variables
Dim fso, dtOld, Checked, Deleted, verb, sSource

'Quit if argument does not exist
if WScript.Arguments.Count = 0 then
    wscript.echo "ERROR: No path set."
	wscript.quit
end if

'Constants
Const Active     = True
Const MaxAge     = 7 'days
Const Recursive  = True

'Since argument is a path get its absolute
Set fso = CreateObject("Scripting.FileSystemObject")
'MaxAge = fso.GetAbsolutePathName(WScript.Arguments.Item(0))
sSource  = fso.GetAbsolutePathName(WScript.Arguments.Item(1))
dtOld   = Now - MaxAge
Checked = 0
Deleted = 0

If Active Then verb = "DELETING: """ Else verb = "Old file: """

Validate sSource
Cleanup sSource

WScript.Echo
If Active Then verb = " old file(s) deleted" Else verb = " file(s) would be deleted"
WScript.Echo "COMPLETED: " & Checked & " old file(s) checked, " & Deleted & verb

Sub Validate(sFolder)
    With CreateObject("Scripting.FileSystemObject")
        If Not .FolderExists(sFolder) Then
            Err.Raise 76 'Path not found
        End If
        If .GetFolder(sFolder).IsRootFolder Then
            If .GetDrive(.GetDriveName(sFolder)) = _
            CreateObject("WScript.Shell").Environment(_
            "PROCESS")("HOMEDRIVE") Then
                Err.Raise 75 'Path/File access error
            End If
        End If
    End With
End Sub

Sub Cleanup(sFolder)
    Dim obj
    With CreateObject("Scripting.FileSystemObject").GetFolder(sFolder)
        'recurse first
        If Recursive Then
            For Each obj In .SubFolders
                Cleanup obj
            Next
        End If
        'next delete oldest files
        For Each obj In .Files
            If obj.DateCreated < dtOld Then
                Deleted = Deleted + 1
                WScript.Echo verb & obj.Path & """"
                If Active Then obj.Delete(True)
            End If
        Next
        Checked = Checked + .Files.Count
        'and then delete old or empty folders
        For Each obj In .SubFolders
            If obj.DateCreated < dtOld Or 0 = obj.Size Then
                'count here in a variable if you like...
                If Active Then obj.Delete(True)
            End If
        Next
    End With
End Sub
