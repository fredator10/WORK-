; Define the URL of the updated script
UpdateURL := "https://raw.githubusercontent.com/fredator10/WORK-/main/test.ahk"

; Define the path to the update_marker file (adjust path as needed)
UpdateMarker := A_ScriptDir . "\update_marker.txt"

; If update_marker exists, delete it
If (FileExist(UpdateMarker)) {
    FileDelete, %UpdateMarker%
}

; Call the AutoUpdate function with all required parameters
AutoUpdate(UpdateURL, 1, 7, "", "AutoUpdateConfig.ini", 2)

; Main script code
MsgBox, v11 proof checking

; Define the AutoUpdate function
AutoUpdate(FILE, mode := 0, updateIntervalDays := 7, CHANGELOG := "", iniFile := "", backupNumber := 1) {
    iniFile := iniFile ? iniFile : GetNameNoExt(A_ScriptName) . ".ini"
    
    ; Check if an update is needed - remove the MsgBox here
    ; MsgBox, Checking for updates at URL: %FILE%
    
    if UrlDownloadToFile(FILE, A_ScriptFullPath) {
        ; MsgBox, Update downloaded successfully! ; Remove this MsgBox
    } else {
        ; MsgBox, Error downloading update from %FILE%. ; Remove this MsgBox
    }
}

; Helper function to get the script name without the extension
GetNameNoExt(FileName) {
    SplitPath, FileName,,, Extension, NameNoExt
    Return NameNoExt
}

; Function to download a file from the internet
UrlDownloadToFile(URL, OutputFile) {
    try {
        ; Create the COM object for HTTP requests
        WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
        WebRequest.Open("GET", URL, false)
        WebRequest.Send()
        ; Check the status of the request
        Status := WebRequest.Status
        StatusText := WebRequest.StatusText  ; Get the status text
        if (Status != 200) {
            ; MsgBox, Error: HTTP %Status% - %StatusText% ; Remove this MsgBox
            return false
        }
        ; Write the response to the output file
        File := FileOpen(OutputFile, "w")
        if !File {
            ; MsgBox, Unable to open file for writing: %OutputFile% ; Remove this MsgBox
            return false
        }
        File.Write(WebRequest.ResponseText)
        File.Close()
        return true
    } catch e {
        ; MsgBox, Error: %ErrorLevel% ; Remove this MsgBox
        return false
    }
}
