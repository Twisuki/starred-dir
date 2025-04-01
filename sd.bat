@echo off
chcp 936 > nul 2>&1
setlocal enabledelayedexpansion

:: 全局变量
set "sd_version=1.0"

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
) else if %hour% lss 13 (
	set hello=上午好
) else if %hour% lss 14 (
	set hello=中午好
) else if %hour% lss 19 (
	set hello=下午好
) else (
	set hello=晚上好
)

echo.
echo %hello%%username%, 欢迎使用StarredDir路径收藏夹
echo ------------------------------------------------------------

:: 功能判断
if "%~1"=="" (
	echo 使用方法: sd [-d] [-e] [-h] [-l] [-n] [-v] [name]
	echo.

	:: 打印列表
	call :PrintList

	:: 输出版本
	echo.
	echo 当前StarredDir版本: %sd_version%

	echo.
	echo 使用^'sd -h^'显示更多信息

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
	echo 当前StarredDir版本: sd %sd_version%
) else (
	:: sd name
	set "name=%~1"

	:: 检查文件夹是否存在
	if not exist "%~dp0/sd_data" (
		echo 路径不存在
	)

	:: 检查文件是否存在
	if not exist "%~dp0/sd_data/!name!.txt" (
		echo !name!不存在
		exit /B 0
	)

	for /f "usebackq delims=" %%i in ("%~dp0/sd_data/!name!.txt") do (
		set "cmd=cd %%i"
	)

	powershell -Command "Set-Clipboard -Value '!cmd!'"
	echo 跳转命令已保存的剪贴板, 请右键并回车.
)

echo.

exit /B 0

:: 新建
:NewDir
	:: name dir

	:: 空参数跳转帮助
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

	:: 空参数跳转帮助
	if "%~1"=="" (
		call :SdHelp "-d"
		exit /B 0
	)

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

	:: 空参数跳转帮助
	if "%~1"=="" (
		call :SdHelp "-e"
		exit /B 0
	)

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

	if "%~2"=="-n" (
		:: 重命名
		if "%~3"=="" (
			echo 参数有误, 请查询帮助^'sd -h -e^'
			exit /B 0
		)

		for /f "usebackq delims=" %%i in ("%~dp0/sd_data/%name%.txt") do (
			echo %name% : %%i
		)

		echo 是否重命名%name%为%~3?
		choice
		if !errorlevel!==1 (
			ren "%~dp0\sd_data\%name%.txt" "%~3.txt"
			echo %name%已重命名为%~3
		) else (
			echo 取消重命名
		)

	) else if "%~2"=="-d" (
		:: 修改路径
		if "%~3" neq "" (
			set "dir=%~3"
		) else (
			set "dir=%cd%"
		)

		for /f "usebackq delims=" %%i in ("%~dp0/sd_data/%name%.txt") do (
			echo %name% : %%i
		)

		echo 修改%name%路径为!dir!
		choice
		if !errorlevel!==1 (
			del %~dp0\sd_data\%name%.txt
			echo !dir! > %~dp0/sd_data/%name%.txt
			echo %name%路径已修改为!dir!
		) else (
			echo 取消修改
		)
	) else (
		echo 参数有误, 请查询帮助^'sd -h -e^'
	)

	exit /B 0

:: 帮助
:SdHelp
	:: /-d/-e/-l/-n/-v
	if "%~1"=="" (
		:: 分类
		echo StarredDir是Twisuki开发的基于Bat批处理文本的路径收藏小程序
		echo 使用^'sd -n^'新建一个路径, 使用^'sd ^<name^>^'跳转到已保存的路径
		echo 其他参数使用说明请输入^'sd -h [-d] [-e] [-l] [-n] [-v]^'
	) else if "%~1"=="-d" (
		:: sd -d name
		echo 使用^'sd -d ^<name^>^'删除已保存的路径^<name^>
	) else if "%~1"=="-e" (
		:: sd -e name -n name / sd -e name -d dir
		echo 使用^'sd -d ^<name^> -n ^<new name^>^'重命名已保存的路径^<name^>为^<new name^>
		echo 使用^'sd -d ^<name^> -d ^<new dir^>^'修改已保存的路径^<name^>位置为^<new dir^>
		echo 若^<new dir^>留空则修改为当前位置
	) else if "%~1"=="-l" (
		:: sd -l
		echo 使用^'sd -l^'显示所有保存的路径信息
	) else if "%~1"=="-n" (
		:: sd -n name dir
		echo 使用^'sd -d ^<name^> ^<dir^>^'保存^<dir^>为^<name^>
		echo 若^<dir^>留空则保存当前位置
	) else if "%~1"=="-v" (
		:: sd-v
		echo 使用^'sd -v^'查看版本信息
	) else (
		echo 无效的参数, 请输入^'sd -h^'或^'sd -h [-d] [-e] [-l] [-n] [-v]^'
	)

endlocal
