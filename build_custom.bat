@rem %comspec% /k "E:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build\vcvars64.bat"
@rem call "E:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build\vcvars64.bat"
@rem %comspec% /k "E:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build\vcvars32.bat"
call "E:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build\vcvars32.bat"
md dyzbuild
pushd dyzbuild
	del * /q /s
	cmake ..
	@rem cmake --build . --target clean

	@rem cmake --build . -j16
	@rem dir .\examples\helloworld\helloworld.exe
	@rem .\examples\helloworld\helloworld.exe
popd
pause