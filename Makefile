#Makefile for webduino.

#This file is part of webduino.

#webduino is free software; you can redistribute it and/or modify it under
#the terms of the GNU General Public License as published by the Free
#Software Foundation; either version 3, or (at your option) any later
#version.

#webduino is distributed in the hope that it will be useful, but WITHOUT ANY
#WARRANTY; without even the implied warranty of MERCHANTABILITY or
#FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
#for more details.

#You should have received a copy of the GNU General Public License
#along with webduino; see the file LICENSE.  If not see
#<http://www.gnu.org/licenses/>.

#TARGET = attiny4
TARGET = atmega8
SRC = blink
BASENAME = $(SRC)_$(TARGET)

all: $(BASENAME).elf $(BASENAME).dis $(BASENAME).hex index.html

$(BASENAME).elf: $(SRC).c
	avr-gcc $< -o $(BASENAME).elf -mmcu=$(TARGET)

$(BASENAME).dis: $(BASENAME).elf
	avr-objdump -d $(BASENAME).elf > $(BASENAME).dis

$(BASENAME).hex: $(BASENAME).elf
#	avr-objcopy -I elf32-avr -O ihex $(BASENAME).elf $(BASENAME).hex --change-section-address .text=0x4000 --change-section-address .data=0x40
	avr-objcopy -I elf32-avr -O ihex $(BASENAME).elf $(BASENAME).hex --change-section-address .text=0x460 --change-section-address .data=0x60

.PHONY index.html: $(BASENAME).hex
	cat header > $@
	printf '\t  var hex = "' >> $@
	tr '\r\n' '\\n' < $(BASENAME).hex >> $@
	printf '";\n' >> $@
	cat js/avrcore.js >> $@
	cat footer >> $@

clean: 
	-@rm *.elf *.dis *.hex index.html