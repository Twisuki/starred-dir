@echo off
chcp 936 > nul 2>&1
setlocal enabledelayedexpansion

:: ȫ�ֱ���
set "sd_version=1.0"

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
) else if %hour% lss 13 (
	set hello=�����
) else if %hour% lss 14 (
	set hello=�����
) else if %hour% lss 19 (
	set hello=�����
) else (
	set hello=���Ϻ�
)

echo.
echo %hello%%username%, ��ӭʹ��StarredDir·���ղؼ�
echo ------------------------------------------------------------

:: �����ж�
if "%~1"=="" (
	echo ʹ�÷���: sd [-d] [-e] [-h] [-l] [-n] [-v] [name]
	echo.

	:: ��ӡ�б�
	call :PrintList

	:: ����汾
	echo.
	echo ��ǰStarredDir�汾: %sd_version%

	echo.
	echo ʹ��^'sd -h^'��ʾ������Ϣ

) else if "%~1"=="-d" (
	:: sd -d name
	call :DelDir "%~2"
) else if "%~1"=="-e" (
	:: sd -e name -n name / sd -e name -d dir
	call :DirEditor "%~2" "%~3" "%~4"
) else if "%~1"=="-h" (
	:: sd -h
	call :SdHelp "%~2"
) else if "%~1"=="-l" (
	:: sd -l
	call :PrintList
) else if "%~1"=="-n" (
	:: sd -n name dir
	call :NewDir "%~2" "%~3"
) else if "%~1"=="-v" (
	:: sd-v
	echo ��ǰStarredDir�汾: sd %sd_version%
) else (
	:: sd name
	set "name=%~1"

	:: ����ļ����Ƿ����
	if not exist "%~dp0/sd_data" (
		echo ·��������
	)

	:: ����ļ��Ƿ����
	if not exist "%~dp0/sd_data/!name!.txt" (
		echo !name!������
		exit /B 0
	)

	for /f "usebackq delims=" %%i in ("%~dp0/sd_data/!name!.txt") do (
		set "cmd=cd %%i"
	)

	powershell -Command "Set-Clipboard -Value '!cmd!'"
	echo ��ת�����ѱ���ļ�����, ���Ҽ����س�.
)

echo.

exit /B 0

:: �½�
:NewDir
	:: name dir

	:: �ղ�����ת����
	if "%~1"=="" (
		call :SdHelp "-n"
		exit /B 0
	)

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

	:: �ղ�����ת����
	if "%~1"=="" (
		call :SdHelp "-d"
		exit /B 0
	)

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

	:: �ղ�����ת����
	if "%~1"=="" (
		call :SdHelp "-e"
		exit /B 0
	)

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

	if "%~2"=="-n" (
		:: ������
		if "%~3"=="" (
			echo ��������, ���ѯ����^'sd -h -e^'
			exit /B 0
		)

		for /f "usebackq delims=" %%i in ("%~dp0/sd_data/%name%.txt") do (
			echo %name% : %%i
		)

		echo �Ƿ�������%name%Ϊ%~3?
		choice
		if !errorlevel!==1 (
			ren "%~dp0\sd_data\%name%.txt" "%~3.txt"
			echo %name%��������Ϊ%~3
		) else (
			echo ȡ��������
		)

	) else if "%~2"=="-d" (
		:: �޸�·��
		if "%~3" neq "" (
			set "dir=%~3"
		) else (
			set "dir=%cd%"
		)

		for /f "usebackq delims=" %%i in ("%~dp0/sd_data/%name%.txt") do (
			echo %name% : %%i
		)

		echo �޸�%name%·��Ϊ!dir!
		choice
		if !errorlevel!==1 (
			del %~dp0\sd_data\%name%.txt
			echo !dir! > %~dp0/sd_data/%name%.txt
			echo %name%·�����޸�Ϊ!dir!
		) else (
			echo ȡ���޸�
		)
	) else (
		echo ��������, ���ѯ����^'sd -h -e^'
	)

	exit /B 0

:: ����
:SdHelp
	:: /-d/-e/-l/-n/-v
	if "%~1"=="" (
		:: ����
		echo StarredDir��Twisuki�����Ļ���Bat�������ı���·���ղ�С����
		echo ʹ��^'sd -n^'�½�һ��·��, ʹ��^'sd ^<name^>^'��ת���ѱ����·��
		echo ��������ʹ��˵��������^'sd -h [-d] [-e] [-l] [-n] [-v]^'
	) else if "%~1"=="-d" (
		:: sd -d name
		echo ʹ��^'sd -d ^<name^>^'ɾ���ѱ����·��^<name^>
	) else if "%~1"=="-e" (
		:: sd -e name -n name / sd -e name -d dir
		echo ʹ��^'sd -d ^<name^> -n ^<new name^>^'�������ѱ����·��^<name^>Ϊ^<new name^>
		echo ʹ��^'sd -d ^<name^> -d ^<new dir^>^'�޸��ѱ����·��^<name^>λ��Ϊ^<new dir^>
		echo ��^<new dir^>�������޸�Ϊ��ǰλ��
	) else if "%~1"=="-l" (
		:: sd -l
		echo ʹ��^'sd -l^'��ʾ���б����·����Ϣ
	) else if "%~1"=="-n" (
		:: sd -n name dir
		echo ʹ��^'sd -d ^<name^> ^<dir^>^'����^<dir^>Ϊ^<name^>
		echo ��^<dir^>�����򱣴浱ǰλ��
	) else if "%~1"=="-v" (
		:: sd-v
		echo ʹ��^'sd -v^'�鿴�汾��Ϣ
	) else (
		echo ��Ч�Ĳ���, ������^'sd -h^'��^'sd -h [-d] [-e] [-l] [-n] [-v]^'
	)

endlocal
