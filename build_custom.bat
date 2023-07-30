@rem %comspec% /k "E:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build\vcvars64.bat"
@rem call "E:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build\vcvars64.bat"
@rem %comspec% /k "E:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build\vcvars32.bat"
@rem call "E:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build\vcvars32.bat"
@rem call "E:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvars64.bat"
@rem call "E:\Program Files\Microsoft Visual Studio\2022\Enterprise\Common7\Tools\VsDevCmd.bat"
@rem call "E:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvars32.bat"

set VSCMD_DEBUG=2

@rem HKCU\SOFTWARE  or  HKCU\SOFTWARE\Wow6432Node
@rem see winsdk.bat -> GetWin10SdkDir -> GetWin10SdkDirHelper -> reg query "%1\Microsoft\Microsoft SDKs\Windows\v10.0" /v "InstallationFolder"
@rem see winsdk.bat -> GetUniversalCRTSdkDir -> GetUniversalCRTSdkDirHelper -> reg query "%1\Microsoft\Windows Kits\Installed Roots" /v "KitsRoot10"

call "E:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvars32.bat"

set PATH=F:\program\cmake\bin;%PATH%

set SystemBinDir=.\
set BuildDir=dyzbuild
set BuildType=Release
call :CompileProject %BuildDir% %BuildType%
call :CopyTarget %BuildDir% %BuildType% %SystemBinDir%

pause
goto :eof

:CompileProject
	setlocal ENABLEDELAYEDEXPANSION
	set BuildDir=%~1
	set BuildType=%2
	md %BuildDir%
	pushd %BuildDir%
		@rem del * /q /s
		@rem cmake .. -G"Visual Studio 16 2019" -A Win64
		@rem cmake --build . --target clean
		cmake .. -DCMAKE_BUILD_TYPE=%BuildType%
		cmake --build . -j16  --config %BuildType%
		@rem dir .\examples\helloworld\helloworld.exe
		@rem .\examples\helloworld\helloworld.exe
	popd
	endlocal
goto :eof

:CopyTarget
	setlocal ENABLEDELAYEDEXPANSION
	set BuildDir=%~1
	set BuildType=%2
	set SystemBinDir=%3
	for /f %%i in ('dir /s /b "%BuildDir%\examples\helloworld\%BuildType%\*.exe"') do (   copy %%i %SystemBinDir%\ )
	endlocal
goto :eof

:ShowUserInfo
	echo %date:~6,4%_%date:~0,2%_%date:~3,2%
	echo %time:~0,2%_%time:~3,2%
goto :eof