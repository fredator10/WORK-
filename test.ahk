; Define the URL of the updated script
UpdateURL := "https://raw.githubusercontent.com/fredator10/WORK-/main/test.ahk"

; Main script code

; Check if update marker file exists, if it does, skip update process
If !FileExist(A_ScriptDir . "\update_marker.txt") {
    ; Call the AutoUpdate function with all required parameters
    AutoUpdate(UpdateURL, 1, 7, "", "AutoUpdateConfig.ini", 2)
} else {
    MsgBox, Update already applied, skipping.
}

; Main script logic continues here (without MsgBox for checking)
MsgBox, v5 proof checking  ; You can remove this later if not needed

; Define the AutoUpdate function
AutoUpdate(FILE, mode := 0, updateIntervalDays := 7, CHANGELOG := "", iniFile := "", backupNumber := 1) {
    iniFile := iniFile ? iniFile : GetNameNoExt(A_ScriptName) . ".ini"
    
    ; Proceed with the update only if the marker file does not exist
    if UrlDownloadToFile(FILE, A_ScriptFullPath) {
        ; Create a marker file to indicate the script has been updated
        FileAppend, % A_Now, %A_ScriptDir%\update_marker.txt
        MsgBox, Update completed! ; (Optional: You can remove this MsgBox later)
        Reload  ; Reload the script to apply the update
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

; At the very start, check for the update marker to avoid unnecessary reloads
If FileExist(A_ScriptDir . "\update_marker.txt") {
    ; If the marker file exists, delete it to prevent future reloads
    FileDelete, %A_ScriptDir%\update_marker.txt
}
