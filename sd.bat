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
echo sd [name] [-n ^| -new] [-d ^| -del] [-l ^| -list] [-e ^| -edit]


endlocal