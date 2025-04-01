@echo off
chcp 936 > nul 2>&1
setlocal enabledelayedexpansion

:: ȫ�ֱ���
set "sd_version=0.0.1"

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

echo %hello%%username%, ��ӭʹ��StarredDir·���ղؼ�
echo ------------------------------------------------------------

:: �����ж�
if "%~1"=="" (
	echo �÷�: sd [-d] [-e] [-h] [-l] [-n] [-v] [name]
	echo.

	:: ��ӡ�б�
	echo �Ѵ��ڵ�·��:
	call :PrintList

	:: ����汾
	echo.
	echo ��ǰStarredDir�汾: %sd_version%

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
	echo ��ǰStarredDir�汾: %sd_version%
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
	if not exist "%~dp0/sd_data" (
		mkdir %~dp0/sd_data
	)

	:: ����ļ��Ƿ����
	if not exist "%~dp0/sd_data/%name%.txt" (
		echo %dir% > %~dp0/sd_data/%name%.txt
		echo �ѱ���: %name% = %dir%
		exit /B 0
	)

	:: �Ѵ����Ƿ񸲸�
	set "olddir="
	for /f "delims=" %%i in (%~dp0/sd_data/%name%.txt) do (
    set "olddir=%%i"
		goto :done
	)
	:done

	echo "%name%"�Ѵ���, ·��Ϊ:
	echo %olddir%
	echo �Ƿ񸲸��޸�?
	choice
	if %errorlevel%==1 (
		echo %dir% > %~dp0/sd_data/%name%.txt
		echo �ѱ���: %name%Ϊ%dir%
	) else (
		echo ȡ���޸�
	)

	exit /B 0

:: ɾ��
:DelDir
	:: name
	set "name=%~1"

	:: ����ļ����Ƿ����
	if not exist "%~dp0/sd_data" (
		echo �ļ�������
	)

	:: ����ļ��Ƿ����
	if not exist "%~dp0/sd_data/%name%.txt" (
		echo %name%������
		exit /B 0
	)

	:: ����ļ�
	for /f "usebackq delims=" %%i in ("%~dp0/sd_data/%name%.txt") do (
		echo %name% : %%i
	)

	echo ȷ��ɾ��?
	choice
	if %errorlevel%==1 (
		del %~dp0\sd_data\%name%.txt
		echo %name%��ɾ��
	) else (
		echo ȡ��ɾ��
	)

	exit /B 0

:: �б�
:PrintList
	:: ���·���Ƿ����
	if not exist "%~dp0/sd_data" (
		echo ��·���洢
		exit /B 0
	)

	echo �ѱ����·��:

	cd %~dp0/sd_data
	:: ��ȡ�ļ�
	for %%f in (*) do (
		for /f "usebackq delims=" %%i in ("%%f") do (
			echo     %%~nf : %%i
		)
	)
	cd ..
	exit /B 0

:: �༭
:DirEditor
	:: name -n/-d name/dir
	echo name %~1 and exe %~2 %~3
	exit /B 0

endlocal
