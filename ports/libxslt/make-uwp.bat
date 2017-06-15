set OUTDIR=%1
set PLATFORM=%2

echo make-uwp: OUTDIR=%OUTDIR%

call setVSvars.bat universal10.0%PLATFORM%

nmake -f Makefile.msvc rebuild OUTDIR=%OUTDIR% 
nmake -f Makefile.msvc install OUTDIR=%OUTDIR% 






