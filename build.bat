@rem %comspec% /k "E:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build\vcvars64.bat"
@rem call "E:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build\vcvars64.bat"
@rem %comspec% /k "E:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build\vcvars32.bat"
call "E:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build\vcvars32.bat"
set PATH=%PATH%;E:\msys64\usr\bin;
md dyzbuild
pushd dyzbuild
	@rem del * /q /s
	@rem cmake .. -G"Visual Studio 16 2019" -A Win64
	@rem cmake --build . --target clean
	@rem cmake --build . -j16
	cmake ..
	cmake --build . --target examples\helloworld\helloworld
	dir .\examples\helloworld\helloworld.exe
	@rem .\examples\helloworld\helloworld.exe
popd
pause