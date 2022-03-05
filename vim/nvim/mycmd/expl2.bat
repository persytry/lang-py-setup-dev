
set file=%1
set file=%file:/=\%
start explorer.exe /n,/e,/root,%file%
REM %LocalAppData%/Google/Chrome/Application/chrome.exe %1

