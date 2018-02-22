:: Usage : to generate .EXE file
:: Current Directory> a filename . No extension needed like .asm , .obj 
:: ex: c:\lab1> a lab1a

tasm /zi/l/m  %1.asm
tlink /v %1.obj