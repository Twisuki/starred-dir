@echo off
chcp 936 > nul 2>&1
setlocal enabledelayedexpansion

:: 全局变量
set "sd_version=0.0.1"

:: 安全获取时间（兼容所有Windows版本）
for /f "tokens=1-3 delims=:., " %%H in ("%TIME%") do (
	set hour=%%H
	set minute=%%I
	set second=%%J
)

:: 处理单数字小时
if "%hour:~0,1%"==" " set hour=%hour:~1%
set /a hour=1%hour% - 100 2>nul  || set /a hour=%hour%

:: 设置问候语
if %hour% lss 9 (
	set hello=早上好
) else if %hour% lss 12 (
	set hello=上午好
) else if %hour% equ 12 (
	set hello=中午好
) else if %hour% lss 18 (
	set hello=下午好
) else (
	set hello=晚上好
)

echo %hello%%username%, 欢迎使用StarredDir路径收藏夹
echo ------------------------------------------------------------

:: 功能判断
if "%~1"=="" (
	echo 用法: sd [-d] [-e] [-h] [-l] [-n] [-v] [name]
	echo.

	:: 打印列表
	echo 已存在的路径:
	call :PrintList

	:: 输出版本
	echo.
	echo 当前StarredDir版本: %sd_version%

) else if "%~1"=="-d" (
	:: sd -d name
	call :DelDir "%~2"
) else if "%~1"=="-e" (
	:: sd -e name -n name / sd -e name -d dir
	call :DirEditor "%~2" "%~3" "%~4"
) else if "%~1"=="-h" (
	:: sd -h
	echo 帮助
) else if "%~1"=="-l" (
	:: sd -l
	call :PrintList
) else if "%~1"=="-n" (
	:: sd -n name dir
	call :NewDir "%~2" "%~3"
) else if "%~1"=="-v" (
	:: sd-v
	echo 当前StarredDir版本: %sd_version%
) else (
	:: sd name
	echo %~1
)

exit /B 0

:: 新建
:NewDir
	:: name dir
	set "name=%~1"
	if "%~2" neq "" (
		set "dir=%~2"
	) else (
		set "dir=%cd%"
	)

	:: 检查文件夹是否存在
	if not exist "%~dp0/sd_data" (
		mkdir %~dp0/sd_data
	)

	:: 检查文件是否存在
	if not exist "%~dp0/sd_data/%name%.txt" (
		echo %dir% > %~dp0/sd_data/%name%.txt
		echo 已保存: %name% = %dir%
		exit /B 0
	)

	:: 已存在是否覆盖
	set "olddir="
	for /f "delims=" %%i in (%~dp0/sd_data/%name%.txt) do (
    set "olddir=%%i"
		goto :done
	)
	:done

	echo "%name%"已存在, 路径为:
	echo %olddir%
	echo 是否覆盖修改?
	choice
	if %errorlevel%==1 (
		echo %dir% > %~dp0/sd_data/%name%.txt
		echo 已保存: %name%为%dir%
	) else (
		echo 取消修改
	)

	exit /B 0

:: 删除
:DelDir
	:: name
	set "name=%~1"

	:: 检查文件夹是否存在
	if not exist "%~dp0/sd_data" (
		echo 文件不存在
	)

	:: 检查文件是否存在
	if not exist "%~dp0/sd_data/%name%.txt" (
		echo %name%不存在
		exit /B 0
	)

	:: 输出文件
	for /f "usebackq delims=" %%i in ("%~dp0/sd_data/%name%.txt") do (
		echo %name% : %%i
	)

	echo 确认删除?
	choice
	if %errorlevel%==1 (
		del %~dp0\sd_data\%name%.txt
		echo %name%已删除
	) else (
		echo 取消删除
	)

	exit /B 0

:: 列表
:PrintList
	:: 检测路径是否存在
	if not exist "%~dp0/sd_data" (
		echo 无路径存储
		exit /B 0
	)

	echo 已保存的路径:

	cd %~dp0/sd_data
	:: 读取文件
	for %%f in (*) do (
		for /f "usebackq delims=" %%i in ("%%f") do (
			echo     %%~nf : %%i
		)
	)
	cd ..
	exit /B 0

:: 编辑
:DirEditor
	:: name -n/-d name/dir
	echo name %~1 and exe %~2 %~3
	exit /B 0

endlocal
