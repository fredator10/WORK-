; Define the URL of the updated script
UpdateURL := "https://raw.githubusercontent.com/fredator10/WORK-/main/test.ahk"

; Check if the update marker exists to prevent repeated updates
If !FileExist(A_ScriptDir . "\update_marker.txt") {
    ; Call the AutoUpdate function with all required parameters
    AutoUpdate(UpdateURL, 1, 7, "", "AutoUpdateConfig.ini", 2)
} else {
    ; Skip the update process if marker exists
    MsgBox, Update already applied, skipping.
}

; Main script code logic continues here
MsgBox, v10 proof checking ; This is your main script logic

; Define the AutoUpdate function
AutoUpdate(FILE, mode := 0, updateIntervalDays := 7, CHANGELOG := "", iniFile := "", backupNumber := 1) {
    iniFile := iniFile ? iniFile : GetNameNoExt(A_ScriptName) . ".ini"
    
    ; Proceed with the update process only if marker file doesn't exist
    if (UrlDownloadToFile(FILE, A_ScriptFullPath)) {
        ; Create a marker file to indicate that the script was updated
        FileAppend, % A_Now, %A_ScriptDir%\update_marker.txt
        
        ; Reload the script only once after the update
        MsgBox, Update completed successfully! Script will reload.
        Reload ; This reload should happen only once after the update
    } else {
        MsgBox, Error downloading the update.
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
