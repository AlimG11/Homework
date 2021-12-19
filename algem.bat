@echo off
chcp 65001 > nul

cd %sem%\"Алгебра и геометрия"
echo > %DATE%.log
SET /p text=""
echo %text% > %DATE%.log
cd..\..
