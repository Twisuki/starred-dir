@echo off
chcp 936 > nul 2>&1
setlocal enabledelayedexpansion

:: ��ȫ��ȡʱ�䣨��������Windows�汾��
for /f "tokens=1-3 delims=:., " %%H in ("%TIME%") do (
    set hour=%%H
    set minute=%%I
    set second=%%J
)

:: ��������Сʱ��ȥ��ǰ���ո�
if "%hour:~0,1%"==" " set hour=%hour:~1%

:: ת��Ϊ��ֵ
set /a hour=%hour%

:: �����ʺ���
if %hour% lss 9 (
    set hello=���Ϻ�
) else if %hour% lss 12 (
    set hello=�����
) else if %hour% equ 12 (
    set hello=�����
) else if %hour% lss 18 (
    set hello=�����
) else (
    set hello=���Ϻ�
)

:: ������
echo %hello%%username%, ��ӭʹ��StarredDir·���ղؼ�
echo ------------------------------------------------------------
echo �÷�: sd [name] [-n] [-d] [-l] [-e] [-h]
echo.

:: ��ӡ�б�

:: �����ж�
if "%~1"=="-n" (
	:: sd -n <name> <dir>
	call :NewDir "%~2", "%~3"
) else if "%~1"=="-d" (
	:: sd -d <name>
	echo d
) else if "%~1"=="-l" (
	:: sd -l
	echo l
) else if "%~1"=="-e" (
	:: sd -e <name> -n <name>
	:: sd -e <name> -d <dir>
	echo e
) else if "%~1"=="-h" (
	:: sd -h
	echo h
) else (
	:: sd <name>
	echo name
)

EXIT /B 0

:: �½�
:NewDir
:: <name> <dir>
echo name %~1 and di %~2
EXIT /B 0

:: ɾ��

endlocal