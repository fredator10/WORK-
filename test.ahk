; Define the URL of the updated script
UpdateURL := "https://raw.githubusercontent.com/fredator10/WORK-/main/test.ahk"

; Delete the update marker file before starting
FileDelete, % A_ScriptDir "\update_marker.txt"

; Call the AutoUpdate function with all required parameters
AutoUpdate(UpdateURL, 1, 7, "", "AutoUpdateConfig.ini", 2)

; Main script code
MsgBox, v13 proof checking

; Define the AutoUpdate function
AutoUpdate(FILE, mode := 0, updateIntervalDays := 7, CHANGELOG := "", iniFile := "", backupNumber := 1) {
    iniFile := iniFile ? iniFile : GetNameNoExt(A_ScriptName) . ".ini"
    
    ; Check if an update is needed
    MsgBox, Checking for updates at URL: %FILE%
    
    if UrlDownloadToFile(FILE, A_ScriptFullPath) {
        MsgBox, Update downloaded successfully! ; This will show the download result
    } else {
        MsgBox, Error downloading update from %FILE%. ; Show the error if the download failed
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
            MsgBox, Error: HTTP %Status% - %StatusText% ; Show error if download fails
            return false
        }
        ; Write the response to the output file
        File := FileOpen(OutputFile, "w")
        if !File {
            MsgBox, Unable to open file for writing: %OutputFile% ; Show if file can't be opened
            return false
        }
        File.Write(WebRequest.ResponseText)
        File.Close()
        return true
    } catch e {
        MsgBox, Error: %ErrorLevel% ; Show error if there is an exception
        return false
    }
}
