@echo off
chcp 936 > nul 2>&1
setlocal enabledelayedexpansion

:: ��ȫ��ȡʱ�䣨��������Windows�汾��
for /f "tokens=1-3 delims=:., " %%H in ("%TIME%") do (
    set hour=%%H
    set minute=%%I
    set second=%%J
)

:: ��������Сʱ
if "%hour:~0,1%"==" " set hour=%hour:~1%
set /a hour=1%hour% - 100 2>nul  || set /a hour=%hour%

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

:: �����ж�
if "%~1"=="" (
	echo %hello%%username%, ��ӭʹ��StarredDir·���ղؼ�
	echo ------------------------------------------------------------
	echo �÷�: sd [-d] [-e] [-h] [-l] [-n] [-v] [name]
	echo.

	::��ӡ�б�
	echo �б�
) else if "%~1"=="-d" (
	:: sd -d name
	call :DelDir "%~2"
) else if "%~1"=="-e" (
	:: sd -e name -n name / sd -e name -d dir
	call :DirEditor "%~2" "%~3" "%~4"
) else if "%~1"=="-h" (
	:: sd -h
	echo ����
) else if "%~1"=="-l" (
	:: sd -l
	call :PrintList
) else if "%~1"=="-n" (
	:: sd -n name dir
	call :NewDir "%~2" "%~3"
) else if "%~1"=="-v" (
	:: sd-v
	echo ��ǰ�汾 0.0.0
) else (
	:: sd name
	echo %~1
)

exit /B 0

:: �½�
:NewDir
	:: name dir
	set "name=%~1"
	if "%~2" neq "" (
		set "dir=%~2"
	) else (
		set "dir=%cd%"
	)

	:: ����ļ����Ƿ����
	if not exist "sd_data" (
		mkdir sd_data
	)

	:: ����ļ��Ƿ����
	if not exist "sd_data/%name%.txt" (
		echo %dir% > sd_data/%name%.txt
		echo �ѱ���: %name% = %dir%
		exit /B 0
	)

	:: �Ѵ����Ƿ񸲸�
	set "olddir="
	for /f "delims=" %%i in (sd_data/%name%.txt) do (
    set "olddir=%%i"
		goto :done
	)
	:done

	echo "%name%"�Ѵ���, ·��Ϊ:
	echo %olddir%
	echo �Ƿ񸲸��޸�?
	choice
	if %errorlevel%==1 (
		echo %dir% > sd_data/%name%.txt
		echo �ѱ���: %name%Ϊ%dir%
	) else (
		echo ȡ���޸�
	)

	exit /B 0

:: ɾ��
:DelDir
	:: name
	echo ɾ�� %~1
	exit /B 0

:: �б�
:PrintList
	echo ��ӡ�б�
	exit /B 0

:: �༭
:DirEditor
	:: name -n/-d name/dir
	echo name %~1 and exe %~2 %~3
	exit /B 0

endlocal
