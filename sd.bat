@echo off
chcp 936 > nul 2>&1
setlocal enabledelayedexpansion

:: 安全获取时间（兼容所有Windows版本）
for /f "tokens=1-3 delims=:., " %%H in ("%TIME%") do (
    set hour=%%H
    set minute=%%I
    set second=%%J
)

:: 处理单数字小时（去掉前导空格）
if "%hour:~0,1%"==" " set hour=%hour:~1%

:: 转换为数值
set /a hour=%hour%

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

:: 输出结果
echo %hello%%username%, 欢迎使用StarredDir路径收藏夹
echo ------------------------------------------------------------
echo sd [name] [-n ^| -new] [-d ^| -del] [-l ^| -list] [-e ^| -edit]


endlocal