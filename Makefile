###
## ljwm Makefile
###

##
# Variables
##

OUTFILE ?= ljwm
BOOTSCRIPT ?= src/boot.lua

CFLAGS ?= -O2

LIBS ?= -lm -ldl $(shell pkg-config --libs xcb xcb-util)

LJBIN ?= luajit
LJLIB ?= $(shell pkg-config --libs luajit)

LUAFILES = $(shell find lua -type f -name '*.lua')
LUAOBJECTS = $(LUAFILES:%.lua=%.o)

##
# Targets
##

all: $(OUTFILE)

# Compile Lua scripts to objects
%.o: %.lua
	@echo LJDUMP	$(shell echo $< | sed -e 's/^lua\///' -e 's/\.lua//' -e 's/\//./g'):	$< -\> $@
	@$(LJBIN) -b -n $(shell echo $< | sed -e 's/^lua\///' -e 's/\.lua//' -e 's/\//./g') $< $@

src/boot.o: $(BOOTSCRIPT)
	@echo LJDUMP	ljwm.bootscript:	$(BOOTSCRIPT) -\> src/boot.o
	@$(LJBIN) -b -n ljwm.bootscript ${BOOTSCRIPT} src/boot.o

# Main bin, Bootscript and shtuff.
$(OUTFILE): src/main.c src/boot.o $(LUAOBJECTS)
	$(CC) -o $(OUTFILE) $(CFLAGS) ${LDFLAGS} -Wl,-E src/main.c src/boot.o $(LUAOBJECTS) $(LJLIB) $(LIBS)

# Clean
clean:
	find lua -type f -name "*.o" -exec rm {} +
	rm -f $(OUTFILE) src/boot.o

# .PHONY: src/boot.lua.o
