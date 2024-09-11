COMPILER := g++
DEBUG_FLAGS := -Wall -O0 -g
RELEASE_FLAGS := -Wall -O3
DYNAMIC_MACRO := -DMAKEDLL

ifeq ($(OS),Windows_NT)
	DYNAMIC := .dll
	STATIC := .lib
	RM := del
    LIBS := -lShlwapi -lShell32
    LDFLAGS := -static -static-libgcc -static-libstdc++
else
	DYNAMIC := .so
	STATIC := .a
	RM := rm -f
	LIBS := 
	LDFLAGS :=
	DYNAMIC_MACRO += -fPIC
endif
DYNAMIC_MACRO += -shared

SRC := ./src/
CLEARDEBUG := -s -Wl,--gc-sections

TARGET_NAME := liboutputcatcher

TARGET_DEBUG_DYNAMIC := $(TARGET_NAME)_debug$(DYNAMIC)
TARGET_DEBUG_STATIC := $(TARGET_NAME)_debug$(STATIC)
TARGET_RELEASE_DYNAMIC := $(TARGET_NAME)$(DYNAMIC)
TARGET_RELEASE_STATIC := $(TARGET_NAME)$(STATIC)

all: build

build:
	$(COMPILER) $(DEBUG_FLAGS) $(DYNAMIC_MACRO)  $(SRC)*.cpp -o $(TARGET_DEBUG_DYNAMIC) $(LIBS)
	$(COMPILER) $(DEBUG_FLAGS) -c $(SRC)*.cpp -o $(TARGET_NAME).o $(LIBS) && ar rcs $(TARGET_DEBUG_STATIC) $(TARGET_NAME).o

clean:
	$(RM) $(TARGET_NAME)*

distribute:
	$(COMPILER) $(RELEASE_FLAGS) $(DYNAMIC_MACRO) $(SRC)*.cpp -o $(TARGET_RELEASE_DYNAMIC) $(LIBS) $(LDFLAGS) $(CLEARDEBUG)
	$(COMPILER) $(DEBUG_FLAGS) -c $(SRC)*.cpp -o $(TARGET_NAME).o $(LIBS) $(CLEARDEBUG) && ar rcs $(TARGET_RELEASE_STATIC) $(TARGET_NAME).o
	
.PHONY: all build clean distribute
