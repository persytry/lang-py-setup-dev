@echo off

if "%2"=="" (
    start explorer /select,%1
) else (
    start explorer %1
)
