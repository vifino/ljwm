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
LJCFLAGS ?= $(shell pkg-config --cflags luajit)

LUAFILES = $(shell find lua -type f -name '*.lua')
LUAOBJECTS = $(LUAFILES:%.lua=%.o)

XCBINCLUDE = $(shell pkg-config --variable=includedir xcb)/xcb/

##
# Targets
##

# ffi_cdefs has to be generated first so that things don't break
all: lua/xcb/ffi_cdefs.lua $(OUTFILE)

# Generate CDefs
lua/xcb/ffi_cdefs.lua: $(XCBINCLUDE)xcb.h $(XCBINCLUDE)xproto.h tools/pulldefs.lua
	$(CC) -E $(XCBINCLUDE)xproto.h | $(LJBIN) tools/pulldefs.lua $(XCBINCLUDE) > lua/xcb/ffi_cdefs.lua

# Compile Lua scripts to objects
%.o: %.lua
	@echo LJDUMP	$(shell echo $< | sed -e 's/^lua\///' -e 's/\.lua//' -e 's/\//./g'):	$< -\> $@
	@$(LJBIN) -b -g -n $(shell echo $< | sed -e 's/^lua\///' -e 's/\.lua//' -e 's/\//./g') $< $@

src/boot.o: $(BOOTSCRIPT)
	@echo LJDUMP	ljwm.bootscript:	$(BOOTSCRIPT) -\> src/boot.o
	@$(LJBIN) -b -g -n ljwm.bootscript ${BOOTSCRIPT} src/boot.o

# Main bin, Bootscript and shtuff.
$(OUTFILE): src/main.c src/boot.o lua/xcb/ffi_cdefs.o $(LUAOBJECTS)
	$(CC) -std=gnu99 -o $(OUTFILE) $(CFLAGS) ${LDFLAGS} $(LJCFLAGS) -Wl,-E src/main.c src/boot.o $(LUAOBJECTS) $(LJLIB) $(LIBS)

# Clean
clean:
	find lua -type f -name "*.o" -exec rm {} +
	rm -f $(OUTFILE) src/boot.o
	rm -f lua/xcb/ffi_cdefs.lua

# .PHONY: src/boot.lua.o
