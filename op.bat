@echo off
chcp 65001 > nul

cd %sem%\"Основы программирования"
echo > %DATE%.log
SET /p text=""
echo %text% > %DATE%.log
cd..\..
