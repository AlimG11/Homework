@echo off
set depth=0
:ack
if %1==0 goto m0
if %2==0 goto n0
 
:else
set /a n=%2-1
set /a depth+=1
call :ack %1 %n%
set t=%errorlevel%
set /a m=%1-1
call :ack %m% %t%
set t=%errorlevel%
set /a depth-=1
if %depth%==0 ( 
echo %t%
goto ex
) else ( exit /b %t% )
 
:m0
set/a n=%2+1
if %depth%==0 ( 
echo %n%
goto ex
) else ( exit /b %n% )
 
:n0
set /a m=%1-1
set /a depth+=1
call :ack %m% 1
set t=%errorlevel%
set /a depth-=1
if %depth%==0 ( 
echo %t%
goto ex
) else ( exit /b %t% )

:ex
exit /b
