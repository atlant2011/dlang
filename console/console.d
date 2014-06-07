/*
The MIT License (MIT)

Copyright (c) 2014 Alexandre "TryHard" Leblanc, <alex.cs00@yahoo.ca>, <www.mrtryhard.info>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE. 

*/
module console;

import std.string;
import std.utf;
import std.conv;
import std.uni;
import core.stdc.stdarg;

version(Windows) {
	public import core.sys.windows.windows;

	extern(Windows) {
		BOOL Beep(DWORD dwFreq, DWORD dwDuration);
		BOOL SetConsoleTitleW(LPCWSTR lpConsoleTitle);
		DWORD GetConsoleTitleW(LPWSTR lpConsoleTitle, DWORD nSize);
		BOOL SetConsoleTextAttribute(HANDLE hConsoleOutput, WORD wAttributes);
		HWND GetConsoleWindow();
		DWORD GetLastError();
		HANDLE GetStdHandle(DWORD nStdHandle);
		BOOL GetConsoleScreenBufferInfo(HANDLE hConsoleOutput, PCONSOLE_SCREEN_BUFFER_INFO lpConsoleScreenBufferInfo);
		DWORD FormatMessageW(DWORD dwFlags, LPCVOID lpSource,  DWORD dwMessageId, DWORD dwLanguageId, LPTSTR lpBuffer,
							DWORD nSize, va_list *Arguments);
	}
}

//version(linux) {
//    public import core.sys.linux.linux;
//}

/**
* ConsoleColor Enum representing console colors, simplified.
*/
public enum ConsoleColor {
	Black		=	0x0000,
	DarkBlue	=	0x0001,
	DarkGreen	=	0x0002,
	DarkRed		=	0x0004,
	DarkGray	=	0x0000 | 0x0008,
	Blue		=	0x0001 | 0x0008,
	Pink		=	0x0001 | 0x0004,
	Green		=	0x0002 | 0x0008,
	DarkYellow	=	0x0002 | 0x0004,
	Red			=	0x0004 | 0x0008,
	Cyan		=   0x0001 | 0x0002 | 0x0008,
	Fuschia		=	0x0001 | 0x0004 | 0x0008,
	Gray		=	0x0002 | 0x0004 | 0x0001,
	White		=	0x0002 | 0x0004 | 0x0001 | 0x0008,
}

public enum ConsoleEncoding  {
	ASCII, 
	UTF8
}

/**
* beep Emits console's sound
*/
public void beep() @system {
	version(Windows) {
		Beep(3100, 250);
	}
}

/**
* beep Emits console's sound
* param freq Frequency between 37 to 32 727 hertz.
* param duration Duration in milliseconds
*/
public void beep(int freq, int duration) @system {
	freq = freq > 32727 ? 32727 : duration;

	version(Windows) {
	    Beep(freq, duration);
	}
}

public void clear() {
}

string getError() {
	version(Windows) {
		string strErrMessage = "";
		PTSTR lpErrorText = null;

		FormatMessageW(cast(uint)(FORMAT_MESSAGE_FROM_SYSTEM | FORMAT_MESSAGE_ALLOCATE_BUFFER), 
					   null, GetLastError(), cast(uint)0, lpErrorText, MAX_PATH, null);

		strErrMessage = to!string(lpErrorText);
	}

	return strErrMessage;
}

ConsoleEncoding getInputEncoding() {
	return ConsoleEncoding.ASCII;
}

int getMaxWindowHeight() { 
	return 0;
}

int getMaxWindowWidth() {
	return 0;
}

ConsoleEncoding getOutputEncoding() { 
	return ConsoleEncoding.ASCII;
}

/**
* getTitle Gets the title of the console's window.
* returns UTF8 String.
*/
public string getTitle() @system {
	version(Windows) {
		wchar buf[255];
		GetConsoleTitleW(buf.ptr, cast(DWORD)255);
	}

	// Convert the title in proper string.
	wstring title = "";
	
	for(int i = 0; i < 255; ++i) {
		if(isAlpha(buf[i]) || isWhite(buf[i]))
		   title ~= buf[i];
	}

	return to!string(title);
}
// http://stackoverflow.com/questions/6812224/getting-terminal-size-in-c-for-windows
int getWindowHeight() {
	return 0;
}

int getWindowLeftPosition() {
	return 0;
}

int getWindowTopPosition() {
	return 0;
}

int getWindowWidth() {
	return 0;
}

bool isCapLockOn() {
	return true;
}

bool isControlCInput() {
	return true;
}

bool isKeyAvailable() {
	return true;
}

bool isNumLockOn() {
	return true;
}

void resetColors() {
}

void setBackgroundColor(ConsoleColor color) {
}

void setBufferHeight(int rows) {
}

void setBufferSize(int rows, int cols) {
}

void setBufferWidth(int cols) {
}

void setControlCInput(bool isInput) {
}

void setCursorLeft(int columnPos) {
}

void setCursorPosition(int row, int col) {
}

void setCursorSize(byte percent) {
}

void setCursorTop(int rowPos) {
}

void setCursorVisisble(bool visible) {
}

void setForegroundColor(ConsoleColor color) @system {
	version(Windows) {
		// http://www.daniweb.com/software-development/cpp/code/216345/add-a-little-color-to-your-console-text
		SetConsoleTextAttribute(GetStdHandle(-11), cast(WORD)color); 
	}
}

void setInputEncoding(ConsoleEncoding encoding) {
}

void setOutputEncoding(ConsoleEncoding encoding) { 
}

/**
* setTitle Sets the console's title
* param title Console's title.
*/
void setTitle(string title) @system {
	version(Windows) {
		SetConsoleTitleW(toUTF16z(title));
	}
}

void setWindowHeight() {
}

void setWindowLeftPosition(int xPos) {
}

void setWindowPosition(int x, int y) {
}

void setWindowSize(int row, int col) {
}

void setWindowTopPosition(int yPos) {
}

void setWindowWidth() {
}