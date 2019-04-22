prefix ?= /usr/local
bindir = $(prefix)/bin
name = cookie

build:
	xcodebuild -scheme "Cookie" -configuration Release CONFIGURATION_BUILD_DIR=".build/release/"

install: build
	install ".build/release/$(name)" "$(bindir)"

uninstall:
	rm -rf "$(bindir)/$(name)"

clean:
	rm -rf .build

.PHONY: build install uninstall clean
