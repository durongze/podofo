@echo off

set tools_addr=https://eternallybored.org/misc/wget/releases/wget-1.21.2-win64.zip
set tools_addr=%tools_addr%;https://udomain.dl.sourceforge.net/project/gnuwin32/wget/1.11.4-1/wget-1.11.4-1-dep.zip
set tools_addr=%tools_addr%;https://udomain.dl.sourceforge.net/project/gnuwin32/wget/1.11.4-1/wget-1.11.4-1-bin.zip
set tools_addr=%tools_addr%;https://udomain.dl.sourceforge.net/project/gnuwin32/tar/1.13-1/tar-1.13-1-bin.zip
set tools_addr=%tools_addr%;https://udomain.dl.sourceforge.net/project/gnuwin32/unrar/3.4.3/unrar-3.4.3-bin.zip
set tools_addr=%tools_addr%;https://udomain.dl.sourceforge.net/project/gnuwin32/unzip/5.51-1/unzip-5.51-1-bin.zip
set tools_addr=%tools_addr%;https://udomain.dl.sourceforge.net/project/gnuwin32/gawk/3.1.6-1/gawk-3.1.6-1-bin.zip
set tools_addr=%tools_addr%;https://udomain.dl.sourceforge.net/project/gnuwin32/sed/4.2.1/sed-4.2.1-dep.zip
set tools_addr=%tools_addr%;https://udomain.dl.sourceforge.net/project/gnuwin32/sed/4.2.1/sed-4.2.1-bin.zip
set tools_addr=%tools_addr%;https://udomain.dl.sourceforge.net/project/gnuwin32/grep/2.5.4/grep-2.5.4-bin.zip
set tools_addr=%tools_addr%;https://www.7-zip.org/a/lzma2201.7z
set tools_dir=%cd%\tools_dir

set software_urls=
set software_urls=%software_urls%;http://www.zlib.net/zlib-1.2.12.tar.gz
set software_dir=%cd%\png_dir

set home_dir=E:\program
set build_type=Release
set auto_install_func=%cd%\auto_install_func.bat
call %auto_install_func% gen_all_env %software_dir% %home_dir% all_inc all_lib all_bin
echo all_inc:%all_inc%
echo all_lib:%all_lib%
echo all_bin:%all_bin%
set include=%all_inc%;%include%;%tools_dir%\include;
set lib=%all_lib%;%lib%;%tools_dir%\lib;%tools_dir%\bin;
set path=%all_bin%;%path%;%tools_dir%\bin;

set CMAKE_INCLUDE_PATH=%include%;
set CMAKE_LIBRARY_PATH=%lib%;
@rem set CMAKE_MODULE_PATH=

@rem call %auto_install_func% install_all_package "%tools_addr%" "%tools_dir%"
@rem call %auto_install_func% install_all_package "%software_urls%" "%software_dir%"
call :pkg_install "%software_dir%" %home_dir%
goto :eof

@rem objdump -S E:\program\zlib-1.2.12\lib\zlib.lib | grep -C 5 "lzma_auto_decoder"
:pkg_fix
    setlocal ENABLEDELAYEDEXPANSION
    set pkg_dir=%1
    copy jpegCMakeLists.txt %pkg_dir%\jpeg-9e\CMakeLists.txt
    endlocal
goto :eof

:pkg_uncompress
    setlocal ENABLEDELAYEDEXPANSION
    set pkg_dir=%1
    pushd %pkg_dir%
    for /f %%i in ( 'dir /b *.zip *.tar.*' ) do (
        set pkg_file=%%i
        call %auto_install_func% uncompress_package  !pkg_file! 
    )
    popd
    endlocal
goto :eof

:pkg_install
    set pkg_dir=%1
    set home_dir=%2
    call :pkg_uncompress %pkg_dir%
    call :pkg_fix %pkg_dir%
    pushd %pkg_dir%
        call %auto_install_func% install_package zlib-1.2.12.tar.gz "%home_dir%"
        call %auto_install_func% install_package lpng1637.zip       "%home_dir%"
        call %auto_install_func% install_package jpeg-9e.zip       "%home_dir%"
    popd
goto :eof