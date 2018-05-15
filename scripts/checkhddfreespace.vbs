Const AlertHigh = .1                       'This is the upper percentage of free space for an alert; 10% = .1
Const emailFrom = "email address"        'Enter the from address the email will appear from
Const emailTo = "email address"          'Enter the to address which the email will be sent to
Const ExchangeServer = "email server name" 'Enter your Exchange server name here
Const WaitTimeInMinutes = 10                'Wait time between polls measured in minutes

Dim strMessage
Dim arrServerList
 
arrServerList = array("server name")    'Enter the list of servers to monitor
 
Do until i = 2
    'Clear the message variable
    strMessage = ""
    
    'Poll the array of servers
    PollServers(arrServerList)
    
    'Email if there is a message
    if strMessage <> "" then
        EmailAlert(strMessage)
    end if
    
    'Wait for set number of minutes then loop
    WScript.Sleep(WaitTimeInMinutes*60000)
    
    'Uncomment next line to test a few loops and quit
    'i = i + 1

Loop
 
Sub PollServers(arrServers)
    on error resume next
    for each Server in arrServers
        set objSvc = GetObject("winmgmts:{impersonationLevel=impersonate}//" & Server & "/root/cimv2")
        set objRet = objSvc.InstancesOf("win32_LogicalDisk")
        for each item in objRet
            if item.DriveType = 7 then
                end if
                if item.FreeSpace/item.size <= AlertHigh then
                    strMessage = strMessage & UCase(Server) & ": Alert, drive '" & item.caption & "' is low on HDD space!  There are " & FormatNumber((item.FreeSpace/1024000),0) & " MB free <7%" & vbCRLF
                end if
        next
    next
    set objSvc = Nothing
    set objRet = Nothing
End Sub
 
Sub EmailAlert(Message)
    on error resume next
    Set objMessage = CreateObject("CDO.Message")
    with objMessage
        .From = emailFrom
        .To = emailTo
        .Subject = "Low Disk Space Update"
        .TextBody = Message
        .Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
        .Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpserver") = ExchangeServer
        .Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25
        .Configuration.Fields.Update
        .Send
    end with
    Set objMessage = Nothing
End Sub 
