@rem %comspec% /k "E:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build\vcvars64.bat"
@rem call "E:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build\vcvars64.bat"
@rem %comspec% /k "E:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build\vcvars32.bat"
@rem call "E:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build\vcvars32.bat"
@rem %comspec% /k "E:\Program Files\Microsoft Visual Studio\2022\Enterprise\Common7\Tools\VsDevCmd.bat"
@rem call "E:\Program Files\Microsoft Visual Studio\2022\Enterprise\Common7\Tools\VsDevCmd.bat"
@rem %comspec% /k "E:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvars64.bat"
@rem call "E:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvars64.bat"
@rem call "E:\Program Files\Microsoft Visual Studio\2022\Enterprise\Common7\Tools\VsDevCmd.bat"
call "E:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvars32.bat"
set PATH=%PATH%;E:\msys64\usr\bin;
set BuildType=Release
md dyzbuild
pushd dyzbuild
	del * /q /s
	@rem cmake .. -G"Visual Studio 17 2022" -A Win64
	@rem cmake .. -G"Visual Studio 16 2019" -A Win64
	@rem cmake --build . --target clean
	@rem cmake --build . -j16
	cmake .. -DCMAKE_BUILD_TYPE=%BuildType%
	cmake --build . --config %BuildType% --target examples\helloworld\helloworld  -j16
	@rem cmake --build .
	dir .\examples\helloworld\helloworld.exe
	@rem .\examples\helloworld\helloworld.exe
popd
pause