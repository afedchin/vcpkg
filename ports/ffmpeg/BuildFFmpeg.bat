@setlocal
@echo off

if "%1" == "/?" goto Usage
if "%~1" == "" goto Usage

:: Initialize build configuration
set BUILD.ARM=N
set BUILD.x86=N
set BUILD.x64=N
set BUILD.win7=N
set BUILD.win10=N
set CONFIGURATION=%2
set PREFIX=%4
set SOURCES_DIR=%5
set PATH_TO_BUILD_DIR=%CD%

:: Export full current PATH from environment into MSYS2
set MSYS2_PATH_TYPE=inherit

echo *****%1 %3 CONFIGURATION:%CONFIGURATION% PREFIX:%PREFIX% SOURCES:%SOURCES_DIR%


if "%1"=="win10" (
	set BUILD.win10=Y
) else if "%1"=="win7" (
	set BUILD.win7=Y
) else (
	goto Usage
)

if "%3"=="x86" (
	set BUILD.x86=Y
) else if "%3"=="x64" (
	set BUILD.x64=Y
) else if "%3"=="arm" (
	set BUILD.ARM=Y
) else (
	goto Usage
)

:: Check for required tools
if defined MSYS2_BIN (
    if exist %MSYS2_BIN% goto Win10
)

echo:
echo MSYS2 is needed. Set it up properly and provide the executable path in MSYS2_BIN environment variable. E.g.
echo:
echo     set MSYS2_BIN="C:\msys64\usr\bin\bash.exe"
echo:
echo See https://trac.ffmpeg.org/wiki/CompilationGuide/WinRT#PrerequisitesandFirstTimeSetupInstructions
goto Cleanup

:: Build and deploy Windows 10 library
:Win10
if %BUILD.win10%==N goto Win7

:: Check for required tools
if not defined VS140COMNTOOLS (
    echo:
    echo VS140COMNTOOLS environment variable is not found. Check your Visual Studio 2015 installation
    goto Cleanup
)

:Win10x86
if %BUILD.x86%==N goto Win10x64
echo Building FFmpeg for Windows 10 apps x86...
echo:

setlocal
call "%VS140COMNTOOLS%..\..\VC\vcvarsall.bat" x86 store
set LIB=%VSINSTALLDIR%VC\lib\store;%VSINSTALLDIR%VC\atlmfc\lib;%UniversalCRTSdkDir%lib\%UCRTVersion%\ucrt\x86;;%UniversalCRTSdkDir%lib\%UCRTVersion%\um\x86;C:\Program Files (x86)\Windows Kits\NETFXSDK\4.6\lib\um\x86;;C:\Program Files (x86)\Windows Kits\NETFXSDK\4.6\Lib\um\x86;%LIB%
set LIBPATH=%VSINSTALLDIR%VC\atlmfc\lib;%VSINSTALLDIR%VC\lib;
set INCLUDE=%VSINSTALLDIR%VC\include;%VSINSTALLDIR%VC\atlmfc\include;%UniversalCRTSdkDir%Include\%UCRTVersion%\ucrt;%UniversalCRTSdkDir%Include\%UCRTVersion%\um;%UniversalCRTSdkDir%Include\%UCRTVersion%\shared;%UniversalCRTSdkDir%Include\%UCRTVersion%\winrt;C:\Program Files (x86)\Windows Kits\NETFXSDK\4.6\Include\um;%INCLUDE%

%MSYS2_BIN% --noprofile -x %PATH_TO_BUILD_DIR%\FFmpegConfig.sh Win10 x86 %CONFIGURATION% %PREFIX% %SOURCES_DIR% %BUILD_DIR%
endlocal

:Win10x64
if %BUILD.x64%==N goto Win10ARM
echo Building FFmpeg for Windows 10 apps x64...
echo:

setlocal
call "%VS140COMNTOOLS%..\..\VC\vcvarsall.bat" x64 store
set LIB=%VSINSTALLDIR%VC\lib\store\amd64;%VSINSTALLDIR%VC\atlmfc\lib\amd64;%UniversalCRTSdkDir%lib\%UCRTVersion%\ucrt\x64;;%UniversalCRTSdkDir%lib\%UCRTVersion%\um\x64;C:\Program Files (x86)\Windows Kits\NETFXSDK\4.6\lib\um\x64;;C:\Program Files (x86)\Windows Kits\NETFXSDK\4.6\Lib\um\x64;%LIB%
set LIBPATH=%VSINSTALLDIR%VC\atlmfc\lib\amd64;%VSINSTALLDIR%VC\lib\amd64;
set INCLUDE=%VSINSTALLDIR%VC\include;%VSINSTALLDIR%VC\atlmfc\include;%UniversalCRTSdkDir%Include\%UCRTVersion%\ucrt;%UniversalCRTSdkDir%Include\%UCRTVersion%\um;%UniversalCRTSdkDir%Include\%UCRTVersion%\shared;%UniversalCRTSdkDir%Include\%UCRTVersion%\winrt;C:\Program Files (x86)\Windows Kits\NETFXSDK\4.6\Include\um;%INCLUDE%

%MSYS2_BIN% --noprofile -x %PATH_TO_BUILD_DIR%\FFmpegConfig.sh Win10 x64 %CONFIGURATION% %PREFIX% %SOURCES_DIR% %BUILD_DIR%
endlocal

:Win10ARM
if %BUILD.ARM%==N goto Win7
echo Building FFmpeg for Windows 10 apps ARM...
echo:

setlocal
call "%VS140COMNTOOLS%..\..\VC\vcvarsall.bat" x86_arm store
set UCRTVersion=10.0.14393.0
set LIB=%VSINSTALLDIR%VC\lib\store\ARM;%VSINSTALLDIR%VC\atlmfc\lib\ARM;%UniversalCRTSdkDir%lib\%UCRTVersion%\ucrt\arm;;%UniversalCRTSdkDir%lib\%UCRTVersion%\um\arm;C:\Program Files (x86)\Windows Kits\NETFXSDK\4.6\lib\um\arm;;C:\Program Files (x86)\Windows Kits\NETFXSDK\4.6\Lib\um\arm;%LIB%
set LIBPATH=%VSINSTALLDIR%VC\atlmfc\lib\ARM;%VSINSTALLDIR%VC\lib\ARM;
set INCLUDE=%VSINSTALLDIR%VC\include;%VSINSTALLDIR%VC\atlmfc\include;%UniversalCRTSdkDir%Include\%UCRTVersion%\ucrt;%UniversalCRTSdkDir%Include\%UCRTVersion%\um;%UniversalCRTSdkDir%Include\%UCRTVersion%\shared;%UniversalCRTSdkDir%Include\%UCRTVersion%\winrt;C:\Program Files (x86)\Windows Kits\NETFXSDK\4.6\Include\um;%INCLUDE%

%MSYS2_BIN% --noprofile -x %PATH_TO_BUILD_DIR%\FFmpegConfig.sh Win10 ARM %CONFIGURATION% %PREFIX% %SOURCES_DIR% %BUILD_DIR%
endlocal

:: Build and deploy Windows 7 library
:Win7
if %BUILD.win7%==N goto Cleanup

:: Check for required tools
if not defined VS120COMNTOOLS (
    echo:
    echo VS120COMNTOOLS environment variable is not found. Check your Visual Studio 2013 installation
    goto Cleanup
)

:Win7x86
if %BUILD.x86%==N goto Win7x64
echo Building FFmpeg for Windows 7 desktop x86...
echo:

setlocal
call "%VS120COMNTOOLS%..\..\VC\vcvarsall.bat" x86
set LIB=%VSINSTALLDIR%VC\lib;%VSINSTALLDIR%VC\atlmfc\lib;%WindowsSdkDir%lib\winv6.3\um\x86;
set LIBPATH=%WindowsSdkDir%References\CommonConfiguration\Neutral;%VSINSTALLDIR%VC\lib;
set INCLUDE=%VSINSTALLDIR%VC\include;%WindowsSdkDir%Include\um;%WindowsSdkDir%Include\shared;

%MSYS2_BIN% --login -x %~dp0FFmpegConfig.sh Win7 x86 $CONFIGURATION $PREFIX
endlocal

:Win7x64
if %BUILD.x64%==N goto Cleanup
echo Building FFmpeg for Windows 7 desktop x64...
echo:

setlocal
call "%VS120COMNTOOLS%..\..\VC\vcvarsall.bat" x64
set LIB=%VSINSTALLDIR%VC\lib\amd64;%VSINSTALLDIR%VC\atlmfc\lib\amd64;%WindowsSdkDir%lib\winv6.3\um\x64;
set LIBPATH=%WindowsSdkDir%References\CommonConfiguration\Neutral;%VSINSTALLDIR%VC\lib\amd64;
set INCLUDE=%VSINSTALLDIR%VC\include;%WindowsSdkDir%Include\um;%WindowsSdkDir%Include\shared;

%MSYS2_BIN% --login -x %~dp0FFmpegConfig.sh Win7 x64 $CONFIGURATION $PREFIX
endlocal

goto Cleanup

:: Display help message
:Usage
echo The correct usage is:
echo:
echo     %0 [target platform] [configuration] [architecture] [prefix]
echo:
echo where
echo:
echo [target platform] is: win10 ^| win7 
echo [architecture]    is: x86 ^| x64 ^| ARM (optional)
echo [target configuration] is: debug ^| release 
echo [prefix]    is: path to build install  folder
echo:
goto :eof

:Cleanup
@endlocal