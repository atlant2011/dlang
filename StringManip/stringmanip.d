/+
	FILE:			StringManip
	AUTHOR:			Alexandre "TryHard" Leblanc, <alex.cs00@mail.com>, <alex.cs00@yahoo.ca>
	DESCRIPTION:	Class used to play more with strings. 
					o getBetween		:	Get the string between 2 occurences in given string.
					o getBetweenLast	:	Get the string between the 2 last occurences in given string.
					o getBetweenN		:	Get the string between the N-th occurence of identifiers in given string. Occurence 0 doesn't exist. First n=1.
					o getBetweenAll		:	Get an array of all strings between all 2 occurences in given string.
					o getAfter			:	Get the string after the first occurence required in given string.
					o getAfterLast		:	Get the string after the last occurence required in given string.
					o getBefore			:	Get the string before the first occurence required in given string.
					o getBeforeLast		:	Get the string before the last occurence required in given string.
					o replaceFirstCopy	:	Replace first occurence by an element in a copied string.
					o replaceFirst		:	Replace first occurence by an element in the string given (reference).
					o replaceLastCopy	:	Replace last occurence by an element in a copied string.
					o replaceLast		:	Replace last occurence by an element in the string given (reference).
					o replaceNCopy		:	Replace th n-th occurence by an element in a copied string given.
					o replaceAllCopy	:	Replace all occurences by an element in a copied string.
					o replaceAll		:	Replace all occurences by an element in the string given (reference).

	NOTE:			Please submit any bugs, comments or suggestion by mail on my @mail domain --TryHard.
					Use with ["import stringmanip;"]
					Then use stringmanip.getBetween(wthis, wthat, inthat);

	D_VER:			Works under DMD2.0.64 +
					Works under Geany and VisualD editors/plugins.

	VERSION_HISTORY:	[1.5]		Transformed functions into templated functions (Added support for all strings)
									Applied @safe attribute
									Tested under 2.065+ DMD
									CaseSensivity doesn't work.
						
						[1.1]		Added case sensivity selection.
									Applied pure functions.
									Applied static import; Already used fully qualified name.
									Dropped off static class, as well as static functions.
									--TryHard
+/

// Module name
module stringmanip;

// Static import to force fully qualified names.
static import std.string;
alias std.string stdstr;

/**
* getBetween Get the first string between the occurence of the identifiers
* type T Must be a string or char array.
* param first Opening identifier (e.g. <p>)
* param last Ending identifier (e.g. </p>)
* param inthat String to search in.
* param isCaseSensitive True if case sensitive, false otherwise.
* returns Matching result. If nothing found, returns an empty string / char array
*/
T getBetween(T = string)(immutable T first, immutable T last, immutable T inthat, bool isCaseSensitive = true) 
pure @trusted {
	stdstr.CaseSensitive cs = cast(stdstr.CaseSensitive)isCaseSensitive;
	immutable auto fPos = std.string.indexOf(inthat, first, cs);
	immutable auto lPos = std.string.indexOf(getAfter!(T)(first, inthat, cast(bool)cs), last, cs);
	
	if(fPos < 0 || lPos < 0) {
		return T.init;
	}
	
	return inthat[(fPos + first.length)..(fPos + first.length + lPos)];
}

/**
* getBetweenLast Get the last string between the occurence of the identifiers
* type T Must be a string or char array
* param first Opening identifier (e.g. <p>)
* param last Ending identifier (e.g. </p>)
* param inthat String to be searched in.
* param isCaseSensitive True if case sensitive, false otherwise.
* returns Matching result. If nothing found, returns an empty string / char array
*/
T getBetweenLast(T = string)(immutable T first, immutable T last, immutable T inthat, bool isCaseSensitive = true)
pure @trusted {
	stdstr.CaseSensitive cs = cast(stdstr.CaseSensitive)isCaseSensitive;
	// Get the last position of wfirst and wlast.
	immutable auto lPos = std.string.lastIndexOf(inthat, last, cs);
	immutable auto fPos = std.string.lastIndexOf(getBeforeLast!(T)(last, inthat, cast(bool)cs), first, cs);

	// If we do not find a matching result, return an empty string.
	if(fPos < 0 || lPos < 0) {
		return T.init;
	}

	// Return the matching result.
	return inthat[(fPos + first.length)..(lPos)];
}

/**
 * getBetweenN Get the string between N-th occurence of the identifiers in given input string
 * type T Must be a string or char array
 * param first Opening identifier (e.g. <p>)
 * param last Ending identifier (e.g. </p>)
 * param n N-th occurence
 * param inthat Input string to search in.
 * param isCaseSensitive True if case sensitive, false otherwise.
 * returns String between identifiers at N-th occurence. Empty if nothing found.
 */
T getBetweenN(T = string)(immutable T first, immutable T last, immutable byte n, immutable T inthat, bool isCaseSensitive = true)
pure @trusted {
	stdstr.CaseSensitive cs = cast(stdstr.CaseSensitive)isCaseSensitive;
	
	auto fPos = std.string.indexOf(inthat, first, cs);
	auto lPos = std.string.indexOf(inthat, last, fPos+1, cs);
	
	if(fPos < 0 || lPos < 1) {
		return T.init;
	}

	byte i = 0;
	
	while(i < (n + 1) && fPos >= 0 && lPos >= 0 ) {
		i++;
		
		if(i == (n + 1)) {
			return inthat[(fPos + first.length)..lPos];
		}
		
		fPos = std.string.indexOf(inthat, first, lPos, cs);
		lPos = std.string.indexOf(inthat, last, fPos+1, cs);
	}
	
	return T.init;
}

/**
 * getBetweenAll Get all matching string between all identifiers
 * type T Must be a string or a char array
 * param wthis Opening identifier (e.g. <p>)
 * param that Ending identifier (e.g. </p>)
 * param inthat String to be searched in.
 * param isCaseSensitive True if case sensitive, false otherwise.
 * returns Array containing all matching result. If nothing found, send an array with one empty string / char array
 */
T[] getBetweenAll(T = string)(immutable T wthis, immutable T that, immutable T inthat, bool isCaseSensitive = true)
pure @trusted {
	// Declare list.
	T[] list;
	stdstr.CaseSensitive cs = cast(stdstr.CaseSensitive)isCaseSensitive;
	
	auto fPos = std.string.indexOf(inthat, wthis, cs);
	auto lPos = std.string.indexOf(inthat, that, fPos+1, cs);
	
	if(fPos < 0 || lPos < 1) {
		list ~= T.init;
		return list;
	}
	
	while(fPos >= 0 && lPos >= 0) {
		list ~= inthat[(fPos + wthis.length)..lPos];
		
		fPos = std.string.indexOf(inthat, wthis, lPos, cs);
		lPos = std.string.indexOf(inthat, that, fPos+1, cs);
	}

	// Return list.
	return list;
}

/**
 * getAfter Get string after occurence "wthis"
 * type T Must be a string or a char array
 * param wthis Occurence to look for
 * param inthat String to search in
 * param isCaseSensitive True if case sensitive, false otherwise.
 * returns Matching result.
 */
T getAfter(T = string)(immutable T wthis, immutable T inthat, bool isCaseSensitive = true)
pure @trusted {
	stdstr.CaseSensitive cs = cast(stdstr.CaseSensitive)isCaseSensitive;
	// Ocurrence's position
	immutable auto pos = std.string.indexOf(inthat, wthis, cs);

	// If occurence is not found in string, return an empty string.
	if(pos < 0) {
		return T.init;
	}

	// Return string after "wthis"
	return inthat[(pos + wthis.length)..$]; // Might be problematic
}

/**
 * getAfterLast Get string after last occurence "wthis"
 * type T String or char array
 * param wthis Occurence to look for
 * param inthat String to be searched in
 * param isCaseSensitive True if case sensitive, false otherwise.
 * returns String after last occurence "wthis"
 */
T getAfterLast(T = string)(immutable T wthis, immutable T inthat, bool isCaseSensitive = true)
pure @trusted {
	stdstr.CaseSensitive cs = cast(stdstr.CaseSensitive)isCaseSensitive;
	// Position of the latest occurence "wthis"
	immutable auto pos = std.string.lastIndexOf(inthat, wthis, cs);

	// If not found, return empty string
	if(pos < 0) {
		return T.init;
	}

	// Return the string after last occurence found
	return inthat[(pos + wthis.length)..$];
}

/**
 * getBefore Get the string before occurence of "wthis"
 * type T String or char array
 * param wthis Occurence to look for
 * param inthat String to look occurence in
 * param isCaseSensitive True if case sensitive, false otherwise.
 * returns Returns the string before "wthis"
 */
T getBefore(T = string)(immutable T wthis, immutable T inthat, bool isCaseSensitive = true)
pure @trusted {
	stdstr.CaseSensitive cs = cast(stdstr.CaseSensitive)isCaseSensitive;
	// Get position of the occurence
	immutable auto pos = std.string.indexOf(inthat, wthis, cs);

	// If not found, return an empty string.
	if(pos < 0) {
		return T.init;
	}
	
	// returns the string before occurence's position.
	return inthat[0..pos];
}

/**
 * getBeforeLast Get the string before the last occurence "wthis"
 * type T Must be a string or char array
 * param wthis Occurence to look for
 * param inthat String to search occurence in
 * param isCaseSensitive True if case sensitive, false otherwise.
 * returns Returns the string before the last occurence given
 */
T getBeforeLast(T = string)(immutable T wthis, immutable T inthat, bool isCaseSensitive = true)
pure @trusted {
	stdstr.CaseSensitive cs = cast(stdstr.CaseSensitive)isCaseSensitive;
	// Ge the last position of occurence
	immutable auto pos = std.string.lastIndexOf(inthat, wthis, cs);

	// If not found, return an empty string
	if(pos < 0) {
		return T.init;
	}

	// Return the string before the last occurence
	return inthat[0..pos];
}

/**
 * replaceFirstCopy Replace the first occurence "wthis" by the element "bythat" in a copied given string.
 * type T String or char array
 * param wthis First occurence to replace
 * param bythat Element to replace "wthis" with.
 * param inthat String to replace things in.
 * param isCaseSensitive True if case sensitive, false otherwise.
 * returns A modified copy of the original string (leaves the original string safe).
 */
T replaceFirstCopy(T = string)(immutable T wthis, immutable T bythat, immutable T inthat, bool isCaseSensitive = true)
pure @trusted {
	stdstr.CaseSensitive cs = cast(stdstr.CaseSensitive)isCaseSensitive;
	// If occurence is not found, just return the original string.
	if(std.string.indexOf(inthat, wthis, cs) < 0) {
		return inthat;
	}

	// Get the string copy with the replaced element.
	T str = getBefore!(T)(wthis, inthat, cast(bool)cs) ~ bythat ~ getAfter!(T)(wthis, inthat, cast(bool)cs);

	// Return resulting string.
	return str;
}

/**
 * replaceFirst Replace the first occurence "wthis" by the element "bythat" in a given string.
 * type T String or char array
 * param wthis Occurence to replace.
 * param bythat Element to replace "wthis" with.
 * param inthat String to replace occurences in.
 * param isCaseSensitive True if case sensitive, false otherwise.
 * returns True if occurence "wthis" is found, else it returns false.
 */
bool replaceFirst(T = string)(immutable T wthis, immutable T bythat, ref T inthat, bool isCaseSensitive = true)
pure @trusted {
	stdstr.CaseSensitive cs = cast(stdstr.CaseSensitive)isCaseSensitive;
	// If occurence is not found, just return false
	if(std.string.indexOf(inthat, wthis, cs) < 0) {
		return false;
	}

	// Change the string for the new one with replaced element.
	inthat = getBefore!(T)(wthis, inthat, cast(bool)cs) ~ bythat ~ getAfter(wthis, inthat, cast(bool)cs);

	// Return the fact it worked.
	return true;
}

/**
 * replaceLastCopy Replace the last occurence "wthis" by the element "bythat" in a copied string given.
 * type T String or char array
 * param wthis Occurence to replace.
 * param bythat Element replacing given occurence "wthis".
 * param inthat String to search and replace in.
 * param isCaseSensitive True if case sensitive, false otherwise.
 * returns Copied original string with replaced elements.
 */
T replaceLastCopy(T = string)(immutable T wthis, immutable T bythat, immutable T inthat, bool isCaseSensitive = true)
pure @trusted {
	stdstr.CaseSensitive cs = cast(stdstr.CaseSensitive)isCaseSensitive;
	// If occurence is not found, return original string.
	if(std.string.indexOf(inthat, wthis, cs) < 0) {
		return inthat;
	}

	// Create a copied string based on the original string with replaced elements.
	T str = getBeforeLast!(T)(wthis, inthat, cast(bool)cs) ~ bythat ~ getAfterLast!(T)(wthis, inthat, cast(bool)cs);

	// Return final string.
	return str;
}

/**
* replaceLast Replace the last occurence "wthis" by the element "bythat" in a given string.
* type T String or char array
* param wthis Occurence to replace.
* param bythat Element replacing given occurence "wthis".
* param inthat String to search and replace in.
* param isCaseSensitive True if case sensitive, false otherwise.
* returns True if elements are replaced, false if occurence is not found.
*/
bool replaceLast(T = string)(immutable T wthis, immutable T bythat, ref T inthat, bool isCaseSensitive = true)
pure @trusted {
	stdstr.CaseSensitive cs = cast(stdstr.CaseSensitive)isCaseSensitive;
	// If occurence is not found, return false.
	if(std.string.indexOf(inthat, wthis, cs) < 0) {
		return false;
	}

	// Modify the string with replaced elements.
	inthat = getBeforeLast!(T)(wthis, inthat, cast(bool)cs) ~ bythat ~ getAfterLast!(T)(wthis, inthat, cast(bool)cs);

	// Return true for success
	return true;
}

/**
 * replaceNCopy Replace n-th occurence by the given replacement 'bythat'. 
 * type T String or char array
 * param wthis Occurence to replace
 * param bythat Element replacing the occurence
 * param n N-th occurence to replace
 * param inthat String to replace term in.
 * param isCaseSensitive True if case sensitive, false otherwise.
 * returns A copy of the string with replaced n-th occurence.
 */
T replaceNCopy(T = string)(immutable T wthis, immutable T bythat, immutable byte n, T inthat, bool isCaseSensitive = true)
pure @trusted {
	stdstr.CaseSensitive cs = cast(stdstr.CaseSensitive)isCaseSensitive;
	// Before continuing, abort if occurence not even found.
	if(std.string.indexOf(inthat, wthis, cs) < 0) {
		return inthat;
	}

	// Initialize index.
	byte i = 0;

	// Declare after string.
	T after = inthat.dup;	

	// While we found occurence and we've haven't reached the number of occurence...
	// Increment and ge the after part.
	while(i < n-1 && std.string.indexOf(after, wthis, cs) >= 0) {
		after = getAfter!(T)(wthis, after, cast(bool)cs);
		i++;
	}

	// If we don't find anything or n isn't corresponding 
	if(std.string.indexOf(after, wthis, cs) < 0 || i+1 != n) {
		return inthat;
	}

	// Get the part before
	T before = getBefore!(T)(after, inthat, cast(bool)cs);

	// Replace in the part after
	after = replaceFirstCopy!(T)(wthis, bythat, after, cast(bool)cs);

	// Return concataned string.
	return before ~ after;		
}

/**
 * replaceAllCopy Replace all occurences "wthis" by element "bythat" in the given string.
 * type T String or char array
 * param wthis Occurence to replace.
 * param bythat Element replacing given occurence "wthis".
 * param inthat String to search and replace in.
 * param isCaseSensitive True if case sensitive, false otherwise.
 * returns True if elements are replaced, false if occurence is not found.
 */
T replaceAllCopy(T = string)(immutable T wthis, immutable T bythat, immutable T inthat, bool isCaseSensitive = true)
pure @trusted {
	stdstr.CaseSensitive cs = cast(stdstr.CaseSensitive)isCaseSensitive;
	// If occurence is not found, return false.
	if(std.string.indexOf(inthat, wthis, cs) < 0) {
		return inthat;
	}

	// Create a copied string.
	T str = inthat.dup;

	// While an occurence is found, replace the first occurence.
	while(replaceFirst!(T)(wthis, bythat, str, cast(bool)cs)) { }

	// Return parsed string.
	return str;
}

/**
 * replaceAll Replace all occurences "wthis" by element "bythat" in the given string.
 * type T String or char array
 * param wthis Occurence to replace.
 * param bythat Element replacing given occurence "wthis".
 * param inthat String to search and replace in.
 * param isCaseSensitive True if case sensitive, false otherwise.
 * returns The parsed copied string with replaced occurences.
 */
bool replaceAll(T = string)(immutable T wthis, immutable T bythat, ref T inthat, bool isCaseSensitive = true)
pure @trusted {
	stdstr.CaseSensitive cs = cast(stdstr.CaseSensitive)isCaseSensitive;
	// If occurence is not found, return false.
	if(std.string.indexOf(inthat, wthis, cs) < 0) {
		return false;
	}

	// While an occurence is found, replace the first occurence.
	while(replaceFirst!(T)(wthis, bythat, inthat, cast(bool)cs)) { }
		
	// Return true;
	return true;
}