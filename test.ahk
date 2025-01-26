; Define the URL of the updated script
UpdateURL := "https://raw.githubusercontent.com/fredator10/WORK-/main/test.ahk"

; Main script code

; Check if the update has already been applied (if marker file exists)
If !FileExist(A_ScriptDir . "\update_marker.txt") {
    ; Call the AutoUpdate function with all required parameters
    AutoUpdate(UpdateURL, 1, 7, "", "AutoUpdateConfig.ini", 2)
} else {
    ; Skip the update if it has already been applied
    MsgBox, Update already applied, skipping.
}

; Main script logic continues here (without MsgBox for checking)
MsgBox, v7 proof checking ; This is your main script logic

; Define the AutoUpdate function
AutoUpdate(FILE, mode := 0, updateIntervalDays := 7, CHANGELOG := "", iniFile := "", backupNumber := 1) {
    iniFile := iniFile ? iniFile : GetNameNoExt(A_ScriptName) . ".ini"
    
    ; Proceed with the update process only if marker file doesn't exist
    if (UrlDownloadToFile(FILE, A_ScriptFullPath)) {
        ; Create a marker file to indicate that the script was updated
        FileAppend, % A_Now, %A_ScriptDir%\update_marker.txt
        
        MsgBox, Update completed! ; (Optional: Remove this MsgBox later if not needed)
        
        ; Reload the script to apply the update
        Reload
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

; Check if the update marker exists before proceeding with any other action
If FileExist(A_ScriptDir . "\update_marker.txt") {
    ; Delete marker file to avoid applying updates repeatedly
    FileDelete, %A_ScriptDir%\update_marker.txt
}
