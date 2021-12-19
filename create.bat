@echo off
chcp 65001 > nul
SET sem=%1

md %sem%
md %sem%\"Алгебра и геометрия"
md %sem%\"Математический анализ"
md %sem%\"Основы программирования"
md %sem%\"Дискретная математика"

cd %sem%\"Алгебра и геометрия"
echo Ведякова Анастасия Олеговна > readme.txt
echo "Начало занятий: %DATE%" >> readme.txt
cd..\"Математический анализ"
echo Евстафьевна Виктория Викторовна > readme.txt
echo "Начало занятий: %DATE%" >> readme.txt
cd..\"Основы программирования"
echo Погожев Сергей Владимирович > readme.txt
echo "Начало занятий: %DATE%" >> readme.txt
cd..\"Дискретная математика"
echo Максимов Алексей Юрьевич > readme.txt
echo "Начало занятий: %DATE%" >> readme.txt
cd..\..