#!/bin/bash
set -e

arduino=${arduino:=/home/gasco/into-cps-projects/arduino-1.8.5}
arduino_path=${arduino_path:=/home/gasco/Arduino}
toolsavr=${toolsavr:=/home/gasco/into-cps-projects/arduino-1.8.5/hardware/tools/avr}
avr=${avr:=/home/gasco/into-cps-projects/arduino-1.8.5/hardware/arduino/avr}
port=${port:=/dev/ttyACM0}
avrdudeconfig=${avrdude:=/home/gasco/into-cps-projects/arduino-1.8.5/hardware/tools/avr/etc/avrdude.conf}


if [ $# -eq 0 ]
then
	echo "No arguments supplied.  Please specify the path to the C source code FMU."
	exit -1
fi

rm -rf data
mkdir data

cp $1 data/fmu.zip
cd data
unzip -o fmu.zip > /dev/null
cd ..

rm -rf /tmp/arduino_build
rm -rf /tmp/arduino_cache
mkdir /tmp/arduino_build
mkdir /tmp/arduino_cache

${arduino}/arduino-builder -dump-prefs -logger=machine -hardware ${arduino}/hardware -tools ${arduino}/tools-builder -tools ${toolsavr} -built-in-libraries ${arduino}/libraries -libraries ${arduino_path}/libraries -fqbn=arduino:avr:uno -vid-pid=0X2341_0X0043 -ide-version=10805 -build-path /tmp/arduino_build -warnings=none -build-cache /tmp/arduino_cache -prefs=build.warn_data_percentage=75 -prefs=runtime.tools.arduinoOTA.path=${toolsavr} -prefs=runtime.tools.avr-gcc.path=${toolsavr} -prefs=runtime.tools.avrdude.path=${toolsavr} -verbose ./main.ino
${arduino}/arduino-builder -compile -logger=machine -hardware ${arduino}/hardware -tools ${arduino}/tools-builder -tools ${toolsavr} -built-in-libraries ${arduino}/libraries -libraries ${arduino_path}/libraries -fqbn=arduino:avr:uno -vid-pid=0X2341_0X0043 -ide-version=10805 -build-path /tmp/arduino_build -warnings=none -build-cache /tmp/arduino_cache -prefs=build.warn_data_percentage=75 -prefs=runtime.tools.arduinoOTA.path=${toolsavr} -prefs=runtime.tools.avr-gcc.path=${toolsavr} -prefs=runtime.tools.avrdude.path=${toolsavr} -verbose ./main.ino


"${toolsavr}/bin/avr-g++" -c -g -Os -w -std=gnu++11 -fpermissive -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics  -flto -w -x c++ -E -CC -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10805 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR   "-I${avr}/cores/arduino" "-I${avr}/variants/standard" "-I${arduino}/libraries/Servo/src" "/tmp/arduino_build/sketch/main.ino.cpp" -o "/tmp/arduino_build/preproc/ctags_target_for_gcc_minus_e.cpp"
"${arduino}/tools-builder/ctags/5.8-arduino11/ctags" -u --language-force=c++ -f - --c++-kinds=svpf --fields=KSTtzns --line-directives "/tmp/arduino_build/preproc/ctags_target_for_gcc_minus_e.cpp"

"${toolsavr}/bin/avr-g++" -c -g -Os -w -std=gnu++11 -fpermissive -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -MMD -flto -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10805 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR   "-I${avr}/cores/arduino" "-I${avr}/variants/standard" "-I${arduino}/libraries/Servo/src" "/tmp/arduino_build/sketch/main.ino.cpp" -o "/tmp/arduino_build/sketch/main.ino.cpp.o"

"${toolsavr}/bin/avr-g++" -c -g -Os -w -std=gnu++11 -fpermissive -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -MMD -flto -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10805 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR   "-I${avr}/cores/arduino" "-I${avr}/variants/standard" "-I${arduino}/libraries/Servo/src" "${arduino}/libraries/Servo/src/avr/Servo.cpp" -o "/tmp/arduino_build/libraries/Servo/avr/Servo.cpp.o"
"${toolsavr}/bin/avr-g++" -c -g -Os -w -std=gnu++11 -fpermissive -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -MMD -flto -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10805 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR   "-I${avr}/cores/arduino" "-I${avr}/variants/standard" "-I${arduino}/libraries/Servo/src" "${arduino}/libraries/Servo/src/nrf52/Servo.cpp" -o "/tmp/arduino_build/libraries/Servo/nrf52/Servo.cpp.o"
"${toolsavr}/bin/avr-g++" -c -g -Os -w -std=gnu++11 -fpermissive -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -MMD -flto -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10805 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR   "-I${avr}/cores/arduino" "-I${avr}/variants/standard" "-I${arduino}/libraries/Servo/src" "${arduino}/libraries/Servo/src/sam/Servo.cpp" -o "/tmp/arduino_build/libraries/Servo/sam/Servo.cpp.o"
"${toolsavr}/bin/avr-g++" -c -g -Os -w -std=gnu++11 -fpermissive -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -MMD -flto -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10805 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR   "-I${avr}/cores/arduino" "-I${avr}/variants/standard" "-I${arduino}/libraries/Servo/src" "${arduino}/libraries/Servo/src/samd/Servo.cpp" -o "/tmp/arduino_build/libraries/Servo/samd/Servo.cpp.o"
"${toolsavr}/bin/avr-g++" -c -g -Os -w -std=gnu++11 -fpermissive -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -MMD -flto -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10805 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR   "-I${avr}/cores/arduino" "-I${avr}/variants/standard" "-I${arduino}/libraries/Servo/src" "${arduino}/libraries/Servo/src/stm32f4/Servo.cpp" -o "/tmp/arduino_build/libraries/Servo/stm32f4/Servo.cpp.o"

"${toolsavr}/bin/avr-gcc" -c -g -x assembler-with-cpp -flto -MMD -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10805 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR   "-I${avr}/cores/arduino" "-I${avr}/variants/standard" "${avr}/cores/arduino/wiring_pulse.S" -o "/tmp/arduino_build/core/wiring_pulse.S.o"
"${toolsavr}/bin/avr-gcc" -c -g -Os -w -std=gnu11 -ffunction-sections -fdata-sections -MMD -flto -fno-fat-lto-objects -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10805 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR   "-I${avr}/cores/arduino" "-I${avr}/variants/standard" "${avr}/cores/arduino/WInterrupts.c" -o "/tmp/arduino_build/core/WInterrupts.c.o"
"${toolsavr}/bin/avr-gcc" -c -g -Os -w -std=gnu11 -ffunction-sections -fdata-sections -MMD -flto -fno-fat-lto-objects -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10805 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR   "-I${avr}/cores/arduino" "-I${avr}/variants/standard" "${avr}/cores/arduino/hooks.c" -o "/tmp/arduino_build/core/hooks.c.o"
"${toolsavr}/bin/avr-gcc" -c -g -Os -w -std=gnu11 -ffunction-sections -fdata-sections -MMD -flto -fno-fat-lto-objects -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10805 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR   "-I${avr}/cores/arduino" "-I${avr}/variants/standard" "${avr}/cores/arduino/wiring.c" -o "/tmp/arduino_build/core/wiring.c.o"
"${toolsavr}/bin/avr-gcc" -c -g -Os -w -std=gnu11 -ffunction-sections -fdata-sections -MMD -flto -fno-fat-lto-objects -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10805 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR   "-I${avr}/cores/arduino" "-I${avr}/variants/standard" "${avr}/cores/arduino/wiring_analog.c" -o "/tmp/arduino_build/core/wiring_analog.c.o"
"${toolsavr}/bin/avr-gcc" -c -g -Os -w -std=gnu11 -ffunction-sections -fdata-sections -MMD -flto -fno-fat-lto-objects -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10805 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR   "-I${avr}/cores/arduino" "-I${avr}/variants/standard" "${avr}/cores/arduino/wiring_digital.c" -o "/tmp/arduino_build/core/wiring_digital.c.o"
"${toolsavr}/bin/avr-gcc" -c -g -Os -w -std=gnu11 -ffunction-sections -fdata-sections -MMD -flto -fno-fat-lto-objects -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10805 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR   "-I${avr}/cores/arduino" "-I${avr}/variants/standard" "${avr}/cores/arduino/wiring_pulse.c" -o "/tmp/arduino_build/core/wiring_pulse.c.o"
"${toolsavr}/bin/avr-gcc" -c -g -Os -w -std=gnu11 -ffunction-sections -fdata-sections -MMD -flto -fno-fat-lto-objects -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10805 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR   "-I${avr}/cores/arduino" "-I${avr}/variants/standard" "${avr}/cores/arduino/wiring_shift.c" -o "/tmp/arduino_build/core/wiring_shift.c.o"
"${toolsavr}/bin/avr-g++" -c -g -Os -w -std=gnu++11 -fpermissive -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -MMD -flto -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10805 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR   "-I${avr}/cores/arduino" "-I${avr}/variants/standard" "${avr}/cores/arduino/CDC.cpp" -o "/tmp/arduino_build/core/CDC.cpp.o"
"${toolsavr}/bin/avr-g++" -c -g -Os -w -std=gnu++11 -fpermissive -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -MMD -flto -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10805 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR   "-I${avr}/cores/arduino" "-I${avr}/variants/standard" "${avr}/cores/arduino/HardwareSerial.cpp" -o "/tmp/arduino_build/core/HardwareSerial.cpp.o"
"${toolsavr}/bin/avr-g++" -c -g -Os -w -std=gnu++11 -fpermissive -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -MMD -flto -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10805 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR   "-I${avr}/cores/arduino" "-I${avr}/variants/standard" "${avr}/cores/arduino/HardwareSerial0.cpp" -o "/tmp/arduino_build/core/HardwareSerial0.cpp.o"
"${toolsavr}/bin/avr-g++" -c -g -Os -w -std=gnu++11 -fpermissive -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -MMD -flto -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10805 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR   "-I${avr}/cores/arduino" "-I${avr}/variants/standard" "${avr}/cores/arduino/HardwareSerial1.cpp" -o "/tmp/arduino_build/core/HardwareSerial1.cpp.o"
"${toolsavr}/bin/avr-g++" -c -g -Os -w -std=gnu++11 -fpermissive -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -MMD -flto -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10805 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR   "-I${avr}/cores/arduino" "-I${avr}/variants/standard" "${avr}/cores/arduino/HardwareSerial2.cpp" -o "/tmp/arduino_build/core/HardwareSerial2.cpp.o"
"${toolsavr}/bin/avr-g++" -c -g -Os -w -std=gnu++11 -fpermissive -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -MMD -flto -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10805 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR   "-I${avr}/cores/arduino" "-I${avr}/variants/standard" "${avr}/cores/arduino/HardwareSerial3.cpp" -o "/tmp/arduino_build/core/HardwareSerial3.cpp.o"
"${toolsavr}/bin/avr-g++" -c -g -Os -w -std=gnu++11 -fpermissive -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -MMD -flto -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10805 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR   "-I${avr}/cores/arduino" "-I${avr}/variants/standard" "${avr}/cores/arduino/IPAddress.cpp" -o "/tmp/arduino_build/core/IPAddress.cpp.o"
"${toolsavr}/bin/avr-g++" -c -g -Os -w -std=gnu++11 -fpermissive -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -MMD -flto -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10805 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR   "-I${avr}/cores/arduino" "-I${avr}/variants/standard" "${avr}/cores/arduino/PluggableUSB.cpp" -o "/tmp/arduino_build/core/PluggableUSB.cpp.o"
"${toolsavr}/bin/avr-g++" -c -g -Os -w -std=gnu++11 -fpermissive -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -MMD -flto -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10805 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR   "-I${avr}/cores/arduino" "-I${avr}/variants/standard" "${avr}/cores/arduino/Print.cpp" -o "/tmp/arduino_build/core/Print.cpp.o"
"${toolsavr}/bin/avr-g++" -c -g -Os -w -std=gnu++11 -fpermissive -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -MMD -flto -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10805 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR   "-I${avr}/cores/arduino" "-I${avr}/variants/standard" "${avr}/cores/arduino/Stream.cpp" -o "/tmp/arduino_build/core/Stream.cpp.o"
"${toolsavr}/bin/avr-g++" -c -g -Os -w -std=gnu++11 -fpermissive -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -MMD -flto -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10805 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR   "-I${avr}/cores/arduino" "-I${avr}/variants/standard" "${avr}/cores/arduino/Tone.cpp" -o "/tmp/arduino_build/core/Tone.cpp.o"
"${toolsavr}/bin/avr-g++" -c -g -Os -w -std=gnu++11 -fpermissive -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -MMD -flto -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10805 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR   "-I${avr}/cores/arduino" "-I${avr}/variants/standard" "${avr}/cores/arduino/USBCore.cpp" -o "/tmp/arduino_build/core/USBCore.cpp.o"
"${toolsavr}/bin/avr-g++" -c -g -Os -w -std=gnu++11 -fpermissive -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -MMD -flto -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10805 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR   "-I${avr}/cores/arduino" "-I${avr}/variants/standard" "${avr}/cores/arduino/WMath.cpp" -o "/tmp/arduino_build/core/WMath.cpp.o"
"${toolsavr}/bin/avr-g++" -c -g -Os -w -std=gnu++11 -fpermissive -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -MMD -flto -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10805 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR   "-I${avr}/cores/arduino" "-I${avr}/variants/standard" "${avr}/cores/arduino/WString.cpp" -o "/tmp/arduino_build/core/WString.cpp.o"
"${toolsavr}/bin/avr-g++" -c -g -Os -w -std=gnu++11 -fpermissive -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -MMD -flto -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10805 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR   "-I${avr}/cores/arduino" "-I${avr}/variants/standard" "${avr}/cores/arduino/abi.cpp" -o "/tmp/arduino_build/core/abi.cpp.o"
"${toolsavr}/bin/avr-g++" -c -g -Os -w -std=gnu++11 -fpermissive -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -MMD -flto -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10805 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR   "-I${avr}/cores/arduino" "-I${avr}/variants/standard" "${avr}/cores/arduino/main.cpp" -o "/tmp/arduino_build/core/main.cpp.o"
"${toolsavr}/bin/avr-g++" -c -g -Os -w -std=gnu++11 -fpermissive -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -MMD -flto -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10805 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR   "-I${avr}/cores/arduino" "-I${avr}/variants/standard" "${avr}/cores/arduino/new.cpp" -o "/tmp/arduino_build/core/new.cpp.o"

"${toolsavr}/bin/avr-gcc-ar" rcs  "/tmp/arduino_build/core/core.a" "/tmp/arduino_build/core/wiring_pulse.S.o"
"${toolsavr}/bin/avr-gcc-ar" rcs  "/tmp/arduino_build/core/core.a" "/tmp/arduino_build/core/WInterrupts.c.o"
"${toolsavr}/bin/avr-gcc-ar" rcs  "/tmp/arduino_build/core/core.a" "/tmp/arduino_build/core/hooks.c.o"
"${toolsavr}/bin/avr-gcc-ar" rcs  "/tmp/arduino_build/core/core.a" "/tmp/arduino_build/core/wiring.c.o"
"${toolsavr}/bin/avr-gcc-ar" rcs  "/tmp/arduino_build/core/core.a" "/tmp/arduino_build/core/wiring_analog.c.o"
"${toolsavr}/bin/avr-gcc-ar" rcs  "/tmp/arduino_build/core/core.a" "/tmp/arduino_build/core/wiring_digital.c.o"
"${toolsavr}/bin/avr-gcc-ar" rcs  "/tmp/arduino_build/core/core.a" "/tmp/arduino_build/core/wiring_pulse.c.o"
"${toolsavr}/bin/avr-gcc-ar" rcs  "/tmp/arduino_build/core/core.a" "/tmp/arduino_build/core/wiring_shift.c.o"
"${toolsavr}/bin/avr-gcc-ar" rcs  "/tmp/arduino_build/core/core.a" "/tmp/arduino_build/core/CDC.cpp.o"
"${toolsavr}/bin/avr-gcc-ar" rcs  "/tmp/arduino_build/core/core.a" "/tmp/arduino_build/core/HardwareSerial.cpp.o"
"${toolsavr}/bin/avr-gcc-ar" rcs  "/tmp/arduino_build/core/core.a" "/tmp/arduino_build/core/HardwareSerial0.cpp.o"
"${toolsavr}/bin/avr-gcc-ar" rcs  "/tmp/arduino_build/core/core.a" "/tmp/arduino_build/core/HardwareSerial1.cpp.o"
"${toolsavr}/bin/avr-gcc-ar" rcs  "/tmp/arduino_build/core/core.a" "/tmp/arduino_build/core/HardwareSerial2.cpp.o"
"${toolsavr}/bin/avr-gcc-ar" rcs  "/tmp/arduino_build/core/core.a" "/tmp/arduino_build/core/HardwareSerial3.cpp.o"
"${toolsavr}/bin/avr-gcc-ar" rcs  "/tmp/arduino_build/core/core.a" "/tmp/arduino_build/core/IPAddress.cpp.o"
"${toolsavr}/bin/avr-gcc-ar" rcs  "/tmp/arduino_build/core/core.a" "/tmp/arduino_build/core/PluggableUSB.cpp.o"
"${toolsavr}/bin/avr-gcc-ar" rcs  "/tmp/arduino_build/core/core.a" "/tmp/arduino_build/core/Print.cpp.o"
"${toolsavr}/bin/avr-gcc-ar" rcs  "/tmp/arduino_build/core/core.a" "/tmp/arduino_build/core/Stream.cpp.o"
"${toolsavr}/bin/avr-gcc-ar" rcs  "/tmp/arduino_build/core/core.a" "/tmp/arduino_build/core/Tone.cpp.o"
"${toolsavr}/bin/avr-gcc-ar" rcs  "/tmp/arduino_build/core/core.a" "/tmp/arduino_build/core/USBCore.cpp.o"
"${toolsavr}/bin/avr-gcc-ar" rcs  "/tmp/arduino_build/core/core.a" "/tmp/arduino_build/core/WMath.cpp.o"
"${toolsavr}/bin/avr-gcc-ar" rcs  "/tmp/arduino_build/core/core.a" "/tmp/arduino_build/core/WString.cpp.o"
"${toolsavr}/bin/avr-gcc-ar" rcs  "/tmp/arduino_build/core/core.a" "/tmp/arduino_build/core/abi.cpp.o"
"${toolsavr}/bin/avr-gcc-ar" rcs  "/tmp/arduino_build/core/core.a" "/tmp/arduino_build/core/main.cpp.o"
"${toolsavr}/bin/avr-gcc-ar" rcs  "/tmp/arduino_build/core/core.a" "/tmp/arduino_build/core/new.cpp.o"

"${toolsavr}/bin/avr-gcc" -w -Os -g -flto -fuse-linker-plugin -Wl,--gc-sections -mmcu=atmega328p  -o "/tmp/arduino_build/main.ino.elf" "/tmp/arduino_build/sketch/main.ino.cpp.o" "/tmp/arduino_build/libraries/Servo/avr/Servo.cpp.o" "/tmp/arduino_build/libraries/Servo/nrf52/Servo.cpp.o" "/tmp/arduino_build/libraries/Servo/sam/Servo.cpp.o" "/tmp/arduino_build/libraries/Servo/samd/Servo.cpp.o" "/tmp/arduino_build/libraries/Servo/stm32f4/Servo.cpp.o" "/tmp/arduino_build/core/core.a" "-L/tmp/arduino_build" -lm
"${toolsavr}/bin/avr-objcopy" -O ihex -j .eeprom --set-section-flags=.eeprom=alloc,load --no-change-warnings --change-section-lma .eeprom=0  "/tmp/arduino_build/main.ino.elf" "/tmp/arduino_build/main.ino.eep"
"${toolsavr}/bin/avr-objcopy" -O ihex -R .eeprom  "/tmp/arduino_build/main.ino.elf" "/tmp/arduino_build/main.ino.hex"

${toolsavr}/bin/avrdude -C${avrdude} -v -patmega328p -carduino -P${port} -b115200 -D -Uflash:w:/tmp/arduino_build/main.ino.hex:i 
