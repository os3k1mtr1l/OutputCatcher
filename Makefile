COMPILER := g++
DEBUG_FLAGS := -Wall -O0 -g
RELEASE_FLAGS := -Wall -O3

ifeq ($(OS),Windows_NT)
	RM := del
    LIBS := -lShlwapi
    LDFLAGS := -static -static-libgcc -static-libstdc++
else
	RM := rm -f
	LIBS := 
	LDFLAGS :=
endif
#g++ -Wall -O3 -shared -o liboutputcatcher.dll src/outputcatcher.cpp -DMAKEDLL -lShlwapi -s -Wl,--gc-sections -static -static-libgcc -static-libstdc++
SRC := ./src/
CLEARDEBUG := -s -Wl,--gc-sections

TARGET_DEBUG := liboutputcatcher_debug.dll
TARGET_RELEASE := liboutputcatcher.dll

all: build

build:
	$(COMPILER) $(DEBUG_FLAGS) -shared $(SRC)*.cpp -o $(TARGET_DEBUG) $(LIBS)

clean:
	$(RM) $(TARGET_DEBUG) $(TARGET_RELEASE) $(OBJECTS)

distribute:
	$(COMPILER) $(RELEASE_FLAGS) -shared $(SRC)*.cpp -o $(TARGET_RELEASE) $(LIBS) $(LDFLAGS) $(CLEARDEBUG)
	
.PHONY: all build clean distribute