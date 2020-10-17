arm-none-eabi-gcc -DUltibo -D_POSIX_THREADS -O2 -mabi=aapcs -marm -march=armv7-a -mfpu=vfpv3-d16 -mfloat-abi=hard -D__DYNAMIC_REENT__ -c src/lv_core/*.c src/lv_draw/*.c src/lv_font/*.c src/lv_gpu/*.c src/lv_hal/*.c src/lv_misc/*.c src/lv_themes/*.c src/lv_widgets/*.c
arm-none-eabi-ar rcs ..\liblvgl.a *.o
