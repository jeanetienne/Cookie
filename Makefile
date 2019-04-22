prefix ?= /usr/local
bindir ?= $(prefix)/bin
binname = cookie

build:
	@xcodebuild -scheme "Cookie" -configuration Release CONFIGURATION_BUILD_DIR=".build/release/"

install: build
	@mkdir -p $(bindir)
	@install ".build/release/$(binname)" "$(bindir)"

uninstall:
	@rm -rf "$(bindir)/$(binname)"

clean:
	@rm -rf .build

.PHONY: build install uninstall clean
