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
// NOTE: http://msdn.microsoft.com/en-us/library/windows/desktop/ms687410(v=vs.85).aspx
module console;

import std.string;
import std.utf;
import std.conv;
import std.uni;
import core.stdc.stdarg; // required for va_list

version(Windows) {
	import core.sys.windows.windows;

	extern(Windows) {
		BOOL	Beep(DWORD dwFreq, DWORD dwDuration);
		BOOL	FillConsoleOutputAttribute(HANDLE hConsole, WORD wAttribute, DWORD nLength, COORD dwWriteCoord, 
										   LPDWORD lpNumberOfAttrsWritten);
		BOOL	FillConsoleOutputCharacterW(HANDLE hConsoleOutput, WCHAR cCharacter, DWORD nLength,
											COORD dwWriteCoord, LPDWORD lpNumberOfCharsWritten);
		BOOL	FlushConsoleInputBuffer(HANDLE hConsoleInput);
		DWORD	FormatMessageW(DWORD dwFlags, LPCVOID lpSource,  DWORD dwMessageId, DWORD dwLanguageId, 
							   LPTSTR lpBuffer, DWORD nSize, va_list *Arguments);
		UINT	GetConsoleCP();	// input cp
		BOOL	GetConsoleCursorInfo(HANDLE hConsoleOutput, PCONSOLE_CURSOR_INFO lpConsoleCursorInfo);
		BOOL	GetConsoleMode(HANDLE hConsoleHandle, LPDWORD lpMode);
		UINT	GetConsoleOutputCP();
		DWORD	GetConsoleTitleW(LPWSTR lpConsoleTitle, DWORD nSize);
		BOOL	GetConsoleScreenBufferInfo(HANDLE hConsoleOutput, PCONSOLE_SCREEN_BUFFER_INFO lpConsoleScreenBufferInfo);
		HWND	GetConsoleWindow();
		SHORT	GetKeyState(INT nVirtKey);
		COORD	GetLargestConsoleWindowSize(HANDLE hConsoleOutput);
		DWORD	GetLastError();
		HANDLE	GetStdHandle(DWORD nStdHandle);
		BOOL	SetConsoleCP(UINT wCodePageID);
		BOOL	SetConsoleOuputCP(UINT wCodePageID);
		BOOL	SetConsoleScreenBufferSize(HANDLE hConsoleOutput, COORD dwSize);
		BOOL	SetConsoleTextAttribute(HANDLE hConsoleOutput, WORD wAttributes);
		BOOL	SetConsoleTitleW(LPCWSTR lpConsoleTitle);
		BOOL	SetConsoleCursorInfo(HANDLE hConsoleOutput, const CONSOLE_CURSOR_INFO *lpConsoleCursorInfo);
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

// http://msdn.microsoft.com/en-us/library/dd317756(v=vs.85).aspx
public enum ConsoleEncoding : uint  {
	IBM_037 = 37,
	IBM_437 = 437,
	IBM_500 = 500,
	ASMO_708 = 708,
	ASMO_449 = 709, // ASMO449+ , BCONV4
	ARABTRANS = 710, // Transparent arabic
	DOS_720 = 720,
	IBM_737 = 737,
	IBM_775 = 775,
	IBM_850 = 850, // Default Win7 Pro codepage / encoding
	IBM_852 = 852,
	IBM_855 = 855,
	IBM_857 = 857,
	IBM_00858 = 858,
	IBM_860 = 860,
	IBM_861 = 861,
	DOS_862 = 862,
	IBM_863 = 863,
	IBM_864 = 864,
	IBM_865 = 865,
	CP_866 = 866,
	IBM_869 = 869,
	IBM_870 = 870,
	WINDOWS_874 = 874,
	CP_875 = 875,
	SHIFT_JIS = 932,
	GB_2312 = 936,
	KS_C_5601_1987 = 949,
	BIG5 = 950,
	IBM_1026 = 1026,
	IBM_01047 = 1047,
	IBM_01140 = 1140,
	IBM_01141 = 1141,
	IBM_01142 = 1142,
	IBM_01143 = 1143,
	IBM_01144 = 1144, 
	IBM_01145 = 1145,
	IBM_01146 = 1146,
	IBM_01147 = 1147,
	IBM_01148 = 1148,
	IBM_01149 = 1149,
	UTF_16 = 1200,
	UNICODE_FFFE = 1201,
	WINDOWS_1250 = 1250,
	WINDOWS_1251 = 1251,
	WINDOWS_1252 = 1252,
	WINDOWS_1253 = 1253,
	WINDOWS_1254 = 1254,
	WINDOWS_1255 = 1255,
	WINDOWS_1256 = 1256,
	WINDOWS_1257 = 1257,
	WINDOWS_1258 = 1258,
	JOHAB = 1361,
	MACINTOSH = 10000,
	X_MAC_JAPANESE = 10001,
	X_MAC_CHINESE_TRAD = 10002,
	X_MAC_KOREAN = 10003,
	X_MAC_ARABIC = 10004,
	X_MAC_HEBREW = 10005,
	X_MAC_GREEK = 10006,
	X_MAC_CYRILLIC = 10007,
	X_MAC_CHINESE_SIMP = 10008,
	X_MAC_ROMANIAN = 10010,
	X_MAC_UKRANIAN = 10017,
	X_MAC_THAI = 10021,
	X_MAC_CE = 10029,
	X_MAC_ICELANDIC = 10079,
	X_MAC_TURKISH = 10081,
	X_MAC_CROATIAN = 10082,
	UTF_32 = 12000,
	UTF_32BE = 12001,
	X_CHINESE_CNS = 20000,
	X_CP_20001 = 20001,
	X_CHINESE_ETEN = 20002,
	X_CP_20003 = 20003,
	X_CP_20004 = 20004,
	X_CP_20005 = 20005,
	X_IA5 = 20105,
	X_IA5_GERMAN = 20106,
	X_IA5_SWEDISH = 20107,
	X_IA5_NORWEGIAN = 20108,
	US_ASCII = 20127,
	X_CP_20261 = 20261,
	X_CP_20269 = 20269,
	IBM_273 = 20273,
	IBM_277 = 20277,
	IBM_278 = 20278,
	IBM_280 = 20280,
	IBM_284 = 20284,
	IBM_285 = 20285,
	IBM_290 = 20290,
	IBM_297 = 20297,
	IBM_420 = 20420,
	IBM_423 = 20423,
	IBM_424 = 20424,
	X_EBCDIC_KOREAN_EXTENDED = 20833,
	IBM_THAI = 20838,
	KOI8_R = 20866,
	IBM_871 = 20871,
	IBM_880 = 20880,
	IBM_905 = 20905,
	IBM00924 = 20924,
	EUC_JP_JIS = 20932,
	X_CP_20949 = 20949,
	CP_1025 = 21025,
	KOI8_U = 21866,
	ISO_8859_1 = 28591,
	ISO_8859_2 = 28502,
	ISO_8859_3 = 28593,
	ISO_8859_4 = 28594,
	ISO_8859_5 = 28595,
	ISO_8859_6 = 28596,
	ISO_8859_7 = 28597,
	ISO_8859_8 = 28598,
	ISO_8859_9 = 28599,
	ISO_8859_13 = 28603,
	ISO_8859_15 = 28605,
	X_EUROPA = 29001,
	ISO_8859_8I = 38598, 
	ISO_2022_JP = 50220,
	CS_ISO_2022_JP = 50221,
	ISO_2022_JIS = 50222,	// ISO 2022 Japanese JIS X 0201-1989; Japanese (JIS-Allow 1 byte Kana - SO/SI)
	ISO_2022_KR = 50225,
	X_CP_50227 = 50227,
	ISO_2022_CH_TRAD = 50229,
	EBCDIC_JP_KATA_EXT = 50903, // EBCDIC Japanese (Katakana) Extended
	EBCDIC_CA_US_JP = 50931,
	EBCDIC_KR_EXT_KR = 50933,
	EBCDIC_CN_SIMP_AND_EXT = 50935,	   // EBCDIC Chinese Simplified Extended and Simplified
	EBCDIC_CHINESE = 50936,
	EBCDIC_US_CA_CH_TRAD = 50937,
	EBCDIC_JP_LATIN_AND_EXT = 50939,
	EUC_JP = 51932,
	EUC_CN = 51936,
	EUC_KR = 51949,
	EUC_CN_TRAD = 51950,
	HZ_GB_2312 = 52936,
	GB_18030 = 54936,
	X_ISCII_DE = 57002,
	X_ISCII_BE = 57003,
	X_ISCII_TA = 57004,
	X_ISCII_TE = 57005,
	X_ISCII_AS = 57006,
	X_ISCII_OR = 57007,
	X_ISCII_KA = 57008,
	X_ISCII_MA = 57009,
	X_ISCII_GU = 57010,
	X_ISCII_PA = 57011,
	UTF_7 = 65000,
	UTF_8 = 65001
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

/**
*  clear Clears the console output and set cursor at 0,0
*/
public void clear() @system {
	version(Windows) {
		// http://support.microsoft.com/kb/99261
		COORD coordScreen = { 0, 0 };
		HANDLE hConsole = GetStdHandle(STD_OUTPUT_HANDLE);
		CONSOLE_SCREEN_BUFFER_INFO csbi; // Buffer info.
		DWORD dwConSize; // number of char cells in current buffer

		GetConsoleScreenBufferInfo(hConsole, &csbi);
		dwConSize = csbi.dwSize.X * csbi.dwSize.Y;

		// Flush current input buffer
		FlushConsoleInputBuffer(hConsole);

		// Fill the screen with blanks
		FillConsoleOutputCharacterW(hConsole, cast(WCHAR)' ', dwConSize, coordScreen, null);

		// Get current text attributes
		GetConsoleScreenBufferInfo(hConsole, &csbi);

		// Set buffer's info accordingly.
		FillConsoleOutputAttribute(hConsole, csbi.wAttributes, dwConSize, coordScreen, null);

		// Set cursor at 0,0
		SetConsoleCursorPosition(hConsole, coordScreen);
	}
}

/**
* getBufferHeight Gets the buffer's height in rows.
* returns Row count.
*/
public short getBufferHeight() @system {
	short rows = 0;

	version(Windows) {
		CONSOLE_SCREEN_BUFFER_INFO csbi;
		GetConsoleScreenBufferInfo(GetStdHandle(STD_OUTPUT_HANDLE), &csbi);

		rows = csbi.dwSize.Y;
	}

	return rows;
}

/**
* getBufferWidth Gets the buffer's width in columns.
* returns Columns count.
*/
public short getBufferWidth() @system {
	short cols = 0;

	version(Windows) {
		CONSOLE_SCREEN_BUFFER_INFO csbi;
		GetConsoleScreenBufferInfo(GetStdHandle(STD_OUTPUT_HANDLE), &csbi);

		cols = csbi.dwSize.X;
	}

	return cols;
}

/**
* getError Gets latest error the system provides.
* returns Error string.
*/
public string getError() @system {
	version(Windows) {
		string strErrMessage = "";
		PTSTR lpErrorText = null;

		FormatMessageW(cast(DWORD)(FORMAT_MESSAGE_FROM_SYSTEM | FORMAT_MESSAGE_ALLOCATE_BUFFER), 
					   null, GetLastError(), cast(DWORD)0, lpErrorText, MAX_PATH, null);

		strErrMessage = to!string(lpErrorText);
	}

	return strErrMessage;
}

/**
* getInputEncoding Gets the input encoding (default is UTF_8 for D)
* returns Input encoding
*/
public ConsoleEncoding getInputEncoding() @system {
	ConsoleEncoding enc;

	version(Windows) {
		enc = cast(ConsoleEncoding)(GetConsoleCP());
	}

	return ConsoleEncoding.UTF_8;
}

/**
* getMaxWindowHeight Gets the max window's height of the console, in rows.
* returns Maximum rows count
* remarks The function does not take into consideration the size of the console screen buffer.
*/
public short getMaxWindowHeight() @system { 
	short height = 0;

	version(Windows) {
		COORD c = GetLargestConsoleWindowSize(GetStdHandle(STD_OUTPUT_HANDLE));
		height = c.Y;
	}

	return height;
}

/**
* getMaxWindowWidth Gets the max window's width of the console, in columns.
* returns Maximum columns count
* remarks The function does not take into consideration the size of the console screen buffer.
*/
public short getMaxWindowWidth() @system {
	short width = 0;

	version(Windows) {
		COORD c = GetLargestConsoleWindowSize(GetStdHandle(STD_OUTPUT_HANDLE));
		width = c.X;
	}

	return width;
}

/**
* getOutputEncoding Gets the output encoding.
* returns Output encoding
*/
public ConsoleEncoding getOutputEncoding() @system { 
	ConsoleEncoding enc;

	version(Windows) {
		import std.stdio;

		enc = cast(ConsoleEncoding)(GetConsoleOutputCP());
	}
	
	return enc;
}

/**
* getTitle Gets the title of the console's window.
* returns UTF8 String.
*/
public string getTitle() @system {
	wstring title = "";

	version(Windows) {
		wchar buf[255];
		GetConsoleTitleW(buf.ptr, cast(DWORD)255);

		// Convert title.
		for(int i = 0; i < 255; ++i) {
			if(isAlpha(buf[i]) || isWhite(buf[i]))
				title ~= buf[i];
		}
	}

	return to!string(title);
}

/**
* getWindowHeight Gets the console window's height, in rows.
* returns Rows count.
*/
public short getWindowHeight() @system {
	short rows = 0;
	
	version(Windows) {
		CONSOLE_SCREEN_BUFFER_INFO csbi;
		GetConsoleScreenBufferInfo(GetStdHandle(STD_OUTPUT_HANDLE), &csbi);

		rows = cast(SHORT)(csbi.srWindow.Bottom - csbi.srWindow.Top + 1);
	}

	return rows;
}

/**
* getWindowLeftPosition The leftmost console window's position measured in columns.
* returns Columns's position
*/
public short getWindowLeftPosition() @system {
	short left = 0;

	version(Windows) {
		CONSOLE_SCREEN_BUFFER_INFO csbi;
		GetConsoleScreenBufferInfo(GetStdHandle(STD_OUTPUT_HANDLE), &csbi);

		left = csbi.srWindow.Left;		
	}

	return left;
}

/**
* getWindowTopPosition The topmost console window's position measured in rows.
* returns Row's position
*/
public short getWindowTopPosition() @system {
	short top = 0;

	version(Windows) {
		CONSOLE_SCREEN_BUFFER_INFO csbi;
		GetConsoleScreenBufferInfo(GetStdHandle(STD_OUTPUT_HANDLE), &csbi);

		top = csbi.srWindow.Top;
	}

	return top;
}

/**
* getWindowWidth Gets the console window's width, in columns.
* returns Columns count.
*/
public short getWindowWidth() @system {
	short cols = 0;

	version(Windows) {
		CONSOLE_SCREEN_BUFFER_INFO csbi;
		GetConsoleScreenBufferInfo(GetStdHandle(STD_OUTPUT_HANDLE), &csbi);

		cols = cast(SHORT)(csbi.srWindow.Right - csbi.srWindow.Left + 1);
	}

	return cols;
}

/**
* isCapsLockOn Determine wether caps lock is on or not.
* returns True if caps lock is on. False otherwise.
*/
public bool isCapsLockOn() @system {
	bool isPressed = false;

	version(Windows) {
		short r = GetKeyState(VK_CAPITAL);
		isPressed = ((r & 1) == 1); 
	}

	return isPressed;
}

/**
* isControlCAnInput Determine wether or not ctrl+c is an input
* returns True if ctrl+c is a valid input. False otherwise.	False by default on Windows.
*/
public bool isControlCInput() @system {
	bool isInput = false;

	version(Windows) {
		DWORD lpMode;
		GetConsoleMode(GetStdHandle(STD_OUTPUT_HANDLE), &lpMode);
		isInput = (lpMode & ENABLE_PROCESSED_INPUT) == 0;
	}

	return isInput;
}

/**
*
*/
public bool isKeyAvailable() @system {
	return true;
}

/**
* isNumLockOn Determines wether the number lock is on or off
* returns True if number lock is activated. False otherwise.
*/
public bool isNumLockOn() @system {
	bool isPressed = false;

	version(Windows) {
		short r = GetKeyState(VK_NUMLOCK);
		isPressed = ((r & 1) == 1); 
	}

	return isPressed;
}

/**
* resetColors Resets the console's colors.
*/
public void resetColors() @system {
	version(Windows) {
		COORD coord = { 0, 0 };
		CONSOLE_SCREEN_BUFFER_INFO csbi;
		HANDLE hConsole = GetStdHandle(STD_OUTPUT_HANDLE);

		// Get buffer info.
		GetConsoleScreenBufferInfo(hConsole, &csbi);

		// Get current text attributes
		GetConsoleScreenBufferInfo(hConsole, &csbi);

		// Set buffer's info accordingly.
		FillConsoleOutputAttribute(hConsole, ConsoleColor.Gray | (ConsoleColor.Black << 4), csbi.dwSize.X * csbi.dwSize.Y, coord, null);

		// Set console text attributes.
		SetConsoleTextAttribute(hConsole, ConsoleColor.Gray | (ConsoleColor.Black << 4));
	}
}

/**
* setBackgroundColor Sets the background's color
* param color Background's color.
*/
public void setBackgroundColor(ConsoleColor color) @system {
	version(Windows) {
		CONSOLE_SCREEN_BUFFER_INFO csbi;
		HANDLE hConsole = GetStdHandle(STD_OUTPUT_HANDLE);

		// Get buffer info.
		GetConsoleScreenBufferInfo(hConsole, &csbi);

		SetConsoleTextAttribute(hConsole, cast(WORD)(csbi.wAttributes | (color << 4)));
	}
}

/**
* setBufferHeight Sets the buffer height, in rows.
* param rows Row count in height.
*/
public void setBufferHeight(short rows) @system {
	version(Windows) {
		CONSOLE_SCREEN_BUFFER_INFO csbi;
		HANDLE hConsole = GetStdHandle(STD_OUTPUT_HANDLE);

		GetConsoleScreenBufferInfo(hConsole, &csbi);

		COORD coord = { csbi.dwSize.X, rows };		

		SetConsoleScreenBufferSize(hConsole, coord);
	}
}

/**
* setBufferSize Sets the buffer size in columns and rows.
* param cols Columns (width)
* param rows Rows (height)
*/
public void setBufferSize(short cols, short rows) @system {
	version(Windows) {
		COORD coord = { cols, rows };		

		SetConsoleScreenBufferSize(GetStdHandle(STD_OUTPUT_HANDLE), coord);
	}
}

/**
* setBufferWidth Sets the buffer width, in columns.
* param cols Columns (width)
*/
public void setBufferWidth(short cols) @system {
	version(Windows) {
		CONSOLE_SCREEN_BUFFER_INFO csbi;
		HANDLE hConsole = GetStdHandle(STD_OUTPUT_HANDLE);

		GetConsoleScreenBufferInfo(hConsole, &csbi);

		COORD coord = { cols, csbi.dwSize.Y };		

		SetConsoleScreenBufferSize(hConsole, coord);
	}
}

void setControlCInput(bool isInput) {
}

void setCursorLeft(int columnPos) {
}

void setCursorPosition(int row, int col) {
}

/**
* setCursorSize Sets the console's cursor size
* param percent Size in percentage (100 is max for Windows)
*/
public void setCursorSize(byte percent) @system {
	version(Windows) {
		CONSOLE_CURSOR_INFO cci;
		HANDLE hConsole = GetStdHandle(STD_OUTPUT_HANDLE);
		GetConsoleCursorInfo(hConsole, &cci);
		cci.dwSize = percent > 100 ? 100 : percent;
		SetConsoleCursorInfo(hConsole, &cci);
	}
}

void setCursorTop(int rowPos) {
}

/**
* setCursorVisible Sets the cursor's visibility
* param visible True if visible, or false if invisible.
*/
public void setCursorVisible(bool visible) @system {
	version(Windows) {
		CONSOLE_CURSOR_INFO cci;
		HANDLE hConsole = GetStdHandle(STD_OUTPUT_HANDLE);
		GetConsoleCursorInfo(hConsole, &cci);
		cci.bVisible = visible;
		SetConsoleCursorInfo(hConsole, &cci);
	}
}

/**
* setForegroundColor Sets the output text's color
* param color Text's console color.
*/
public void setForegroundColor(ConsoleColor color) @system {
	version(Windows) {
		CONSOLE_SCREEN_BUFFER_INFO csbi;
		HANDLE hConsole = GetStdHandle(STD_OUTPUT_HANDLE);

		// Get buffer info.
		GetConsoleScreenBufferInfo(hConsole, &csbi);

		SetConsoleTextAttribute(hConsole, cast(WORD)(csbi.wAttributes | color));
	}
}

/**
* setInputEncoding Sets the input encoding (Default is UTF_8)
* param encoding Console input's encoding.
*/
public void setInputEncoding(ConsoleEncoding encoding) @system {
	version(Windows) {
		SetConsoleCP(cast(UINT)(encoding));
	}
}

/**
* setOutputEncoding Set the outputs encoding
* param encoding Console output's encoding
*/
public void setOutputEncoding(ConsoleEncoding encoding) @system { 
	version(Windows) {
		SetConsoleOutputCP(cast(UINT)(encoding));
	}
}

/**
* setTitle Sets the console's title
* param title Console's title.
*/
public void setTitle(string title) @system {
	version(Windows) {
		SetConsoleTitleW(toUTF16z(title));
	}
}

void setWindowHeight(int rows) {
}

void setWindowLeftPosition(int xPos) {
}

void setWindowPosition(int x, int y) {
}

void setWindowSize(int row, int col) {
}

void setWindowTopPosition(int yPos) {
}

void setWindowWidth(int cols) {
}