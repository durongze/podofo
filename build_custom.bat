@rem %comspec% /k "E:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build\vcvars64.bat"
@rem call "E:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build\vcvars64.bat"
@rem %comspec% /k "E:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build\vcvars32.bat"
@rem call "E:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build\vcvars32.bat"
@rem call "E:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvars64.bat"
@rem call "E:\Program Files\Microsoft Visual Studio\2022\Enterprise\Common7\Tools\VsDevCmd.bat"
call "E:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvars32.bat"
set BuildType=Release
md dyzbuild
pushd dyzbuild
	del * /q /s
	@rem cmake .. -G"Visual Studio 16 2019" -A Win64
	@rem cmake --build . --target clean
	cmake .. -DCMAKE_BUILD_TYPE=%BuildType%
	cmake --build . -j16  --config %BuildType%
	@rem dir .\examples\helloworld\helloworld.exe
	@rem .\examples\helloworld\helloworld.exe
popd
pause