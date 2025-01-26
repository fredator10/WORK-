; Define the URL of the updated script
UpdateURL := "https://raw.githubusercontent.com/fredator10/WORK-/main/test.ahk"

; Call the AutoUpdate function with all required parameters
AutoUpdate(UpdateURL, 1, 7, "", "AutoUpdateConfig.ini", 2)

; Main script code
MsgBox, v5 auto updates  ; Keep this for the initial verification, but can be removed later

; Define the AutoUpdate function
AutoUpdate(FILE, mode := 0, updateIntervalDays := 7, CHANGELOG := "", iniFile := "", backupNumber := 1) {
    iniFile := iniFile ? iniFile : GetNameNoExt(A_ScriptName) . ".ini"
    
    ; Perform the update check silently
    if UrlDownloadToFile(FILE, A_ScriptFullPath) {
        ; If the update is successful, it will replace the file without any popups
        Reload  ; Reload the script to apply the update
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
            return false  ; Return false if the download fails
        }
        
        ; Write the response to the output file
        File := FileOpen(OutputFile, "w")
        if !File {
            return false  ; Return false if unable to open file for writing
        }
        File.Write(WebRequest.ResponseText)
        File.Close()
        return true  ; Return true if the file is successfully written
    } catch e {
        return false  ; Return false if any error occurs during the process
    }
}
