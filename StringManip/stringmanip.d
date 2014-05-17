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

enum CaseSensitive { no, yes }

/**
* getBetween Get the first string between the occurence of the identifiers
* type T Must be a string or char array.
* param first Opening identifier (e.g. <p>)
* param last Ending identifier (e.g. </p>)
* param inthat String to search in.
* param isCaseSensitive True if case sensitive, false otherwise.
* returns Matching result. If nothing found, returns an empty string / char array
*/
T getBetween(T = string)(immutable T first, immutable T last, immutable T inthat, CaseSensitive isCaseSensitive = CaseSensitive.yes) 
pure @trusted {
	//immutable auto fPos = std.string.indexOf(inthat, first, isCaseSensitive);
	immutable auto fPos = std.string.indexOf(inthat, first);
	//immutable auto lPos = std.string.indexOf(getAfter!(T)(first, inthat, isCaseSensitive), last, isCaseSensitive);
	immutable auto lPos = std.string.indexOf(getAfter!(T)(first, inthat), last);
	
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
T getBetweenLast(T = string)(immutable T first, immutable T last, immutable T inthat, CaseSensitive isCaseSensitive = CaseSensitive.yes)
pure @trusted {
	// Get the last position of wfirst and wlast.
	//immutable auto lPos = std.string.lastIndexOf(inthat, last, isCaseSensitive);
	immutable auto lPos = std.string.lastIndexOf(inthat, last);
	//immutable auto fPos = std.string.lastIndexOf(getBeforeLast!(T)(last, inthat, isCaseSensitive), first, isCaseSensitive);
	immutable auto fPos = std.string.lastIndexOf(getBeforeLast!(T)(last, inthat), first);

	// If we do not find a matching result, return an empty string.
	if(fPos < 0 || lPos < 0) {
		return T.init;
	}

	// Return the matching result.
	return inthat[(fPos + first.length)..(fPos + first.length + lPos)];
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
T getBetweenN(T = string)(immutable T first, immutable T last, immutable byte n, T inthat, CaseSensitive isCaseSensitive = CaseSensitive.yes)
pure @trusted {
	// Initialize the default n occurence to 0.
	byte i = 0;
	
	// While we've not reached the n-th occurence, and that we can still find the occurence, increment index, and get
	// what is after.
	/*
	while(i < (n-1) && (std.string.indexOf(inthat, first, isCaseSensitive) >= 0 
	      && std.string.indexOf(getAfter!(T)(first, inthat, isCaseSensitive), last, isCaseSensitive) >= 0)) {
		inthat = getAfter!(T)(first, getAfter!(T)(last, inthat, isCaseSensitive), isCaseSensitive);
		i++;
	}
	*/
	
	while(i < (n-1) && (std.string.indexOf(inthat, first) >= 0 
	      && std.string.indexOf(getAfter!(T)(first, inthat, isCaseSensitive), last) >= 0)) {
		inthat = getAfter!(T)(first, getAfter!(T)(last, inthat, isCaseSensitive), isCaseSensitive);
		i++;
	}
	
	// If we don't find n-th occurence, just send an empty string.
	/*
	if(std.string.indexOf(inthat, first, isCaseSensitive) < 0 
	   || std.string.indexOf(getAfter!(T)(first, inthat, isCaseSensitive), last, isCaseSensitive) < 0 
	   || i+1 != n) {
		return T.init;
	}*/
	if(std.string.indexOf(inthat, first) < 0 
	   || std.string.indexOf(getAfter!(T)(first, inthat, isCaseSensitive), last) < 0 
	   || i+1 != n) {
		return T.init;
	}

	// Get the position of the n-th occurence.
	//immutable auto fPos = std.string.indexOf(inthat, first, isCaseSensitive);
	//immutable auto lPos = std.string.indexOf(getAfter!(T)(first, inthat, isCaseSensitive), last, isCaseSensitive);
	immutable auto fPos = std.string.indexOf(inthat, first);
    immutable auto lPos = std.string.indexOf(getAfter!(T)(first, inthat, isCaseSensitive), last);
	
	// Return the resulting string.
	return inthat[(fPos + first.length)..(fPos + first.length + lPos)];
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
T[] getBetweenAll(T = string)(immutable T wthis, immutable T that, immutable T inthat, CaseSensitive isCaseSensitive = CaseSensitive.yes)
pure @trusted {
	// Declare list.
	T[] list;

	// If there is no match of at least one of the identifiers, return an empty array
	//if(std.string.indexOf(inthat, wthis, isCaseSensitive) < 0 || 0 > std.string.indexOf(inthat, that, isCaseSensitive)) {
	if(std.string.indexOf(inthat, wthis) < 0 || 0 > std.string.indexOf(inthat, that))
		// Add at least one empty string then return it.
		list ~= T.init;
		return list;
	}

	// Initialize the index.
	ushort index = 0;
	// Copy the original string.
	T original = inthat.dup;

	// While we can find both identifiers
	//while(std.string.indexOf(original, wthis, isCaseSensitive) >= 0 
	//      && std.string.indexOf(original, wthat, isCaseSensitive) >= 0) {
	while(std.string.indexOf(original, wthis) >= 0 
	      && std.string.indexOf(original, wthat) >= 0) {
		// Get what is between the first identifiers.	
		list ~= getBetween!(T)(wthis, wthat, original, isCaseSensitive);

		// Get the matching string with identifier
		T str = (wthis ~ list[index] ~ wthat).dup;
		// Then get what comes after.
		original = getAfter!(T)(str, original, isCaseSensitive);
		// Increment index.
		index++;
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
T getAfter(T = string)(immutable T wthis, immutable T inthat, CaseSensitive isCaseSensitive = CaseSensitive.yes)
pure @trusted {
	// Ocurrence's position
	//immutable auto pos = std.string.indexOf(inthat, wthis, isCaseSensitive);
	immutable auto pos = std.string.indexOf(inthat, wthis);

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
T getAfterLast(T = string)(immutable T wthis, immutable T inthat, CaseSensitive isCaseSensitive = CaseSensitive.yes)
pure @trusted {
	// Position of the latest occurence "wthis"
	immutable auto pos = std.string.lastIndexOf(inthat, wthis);

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
T getBefore(T = string)(immutable T wthis, immutable T inthat, CaseSensitive isCaseSensitive = CaseSensitive.yes)
pure @trusted {
	// Get position of the occurence
	immutable auto pos = std.string.indexOf(inthat, wthis);

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
T getBeforeLast(T = string)(immutable T wthis, immutable T inthat, CaseSensitive isCaseSensitive = CaseSensitive.yes)
pure @trusted {
	// Ge the last position of occurence
	immutable auto pos = std.string.lastIndexOf(inthat, wthis);

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
T replaceFirstCopy(T = string)(immutable T wthis, immutable T bythat, immutable T inthat, CaseSensitive isCaseSensitive = CaseSensitive.yes)
pure @trusted {
	// If occurence is not found, just return the original string.
	if(std.string.indexOf(inthat, wthis) < 0) {
		return inthat;
	}

	// Get the string copy with the replaced element.
	T str = getBefore!(T)(wthis, inthat, isCaseSensitive) ~ bythat ~ getAfter!(T)(wthis, inthat, isCaseSensitive);

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
bool replaceFirst(T = string)(immutable T wthis, immutable T bythat, ref T inthat, CaseSensitive isCaseSensitive = CaseSensitive.yes)
pure @trusted {
	// If occurence is not found, just return false
	if(std.string.indexOf(inthat, wthis) < 0) {
		return false;
	}

	// Change the string for the new one with replaced element.
	inthat = getBefore!(T)(wthis, inthat, isCaseSensitive) ~ bythat ~ getAfter(wthis, inthat, isCaseSensitive);

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
T replaceLastCopy(T = string)(immutable T wthis, immutable T bythat, immutable T inthat, CaseSensitive isCaseSensitive = CaseSensitive.yes)
pure @trusted {
	// If occurence is not found, return original string.
	if(std.string.indexOf(inthat, wthis) < 0) {
		return inthat;
	}

	// Create a copied string based on the original string with replaced elements.
	T str = getBeforeLast!(T)(wthis, inthat, isCaseSensitive) ~ bythat ~ getAfterLast!(T)(wthis, inthat, isCaseSensitive);

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
bool replaceLast(T = string)(immutable T wthis, immutable T bythat, ref T inthat, CaseSensitive isCaseSensitive = CaseSensitive.yes)
pure @trusted {
	// If occurence is not found, return false.
	if(std.string.indexOf(inthat, wthis) < 0) {
		return false;
	}

	// Modify the string with replaced elements.
	inthat = getBeforeLast!(T)(wthis, inthat, isCaseSensitive) ~ bythat ~ getAfterLast!(T)(wthis, inthat, isCaseSensitive);

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
T replaceNCopy(T = string)(immutable T wthis, immutable T bythat, immutable byte n, T inthat, CaseSensitive isCaseSensitive = CaseSensitive.yes)
pure @trusted {
	// Before continuing, abort if occurence not even found.
	if(std.string.indexOf(inthat, wthis) < 0) {
		return inthat;
	}

	// Initialize index.
	byte i = 0;

	// Declare after string.
	T after = inthat.dup;	

	// While we found occurence and we've haven't reached the number of occurence...
	// Increment and ge the after part.
	while(i < n-1 && std.string.indexOf(after, wthis) >= 0) {
		after = getAfter!(T)(wthis, after, isCaseSensitive);
		i++;
	}

	// If we don't find anything or n isn't corresponding 
	if(std.string.indexOf(after, wthis, isCaseSensitive) < 0 || i+1 != n) {
		return inthat;
	}

	// Get the part before
	T before = getBefore!(T)(after, inthat, isCaseSensitive);

	// Replace in the part after
	after = replaceFirstCopy!(T)(wthis, bythat, after, isCaseSensitive);

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
T replaceAllCopy(T = string)(immutable T wthis, immutable T bythat, immutable T inthat, CaseSensitive isCaseSensitive = CaseSensitive.yes)
pure @trusted {
	// If occurence is not found, return false.
	if(std.string.indexOf(inthat, wthis) < 0) {
		return inthat;
	}

	// Create a copied string.
	T str = inthat.dup;

	// While an occurence is found, replace the first occurence.
	while(replaceFirst!(T)(wthis, bythat, str, isCaseSensitive)) { }

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
bool replaceAll(T = string)(immutable T wthis, immutable T bythat, ref T inthat, CaseSensitive isCaseSensitive = CaseSensitive.yes)
pure @trusted {
	// If occurence is not found, return false.
	if(std.string.indexOf(inthat, wthis) < 0) {
		return false;
	}

	// While an occurence is found, replace the first occurence.
	while(replaceFirst!(T)(wthis, bythat, inthat, isCaseSensitive)) { }
		
	// Return true;
	return true;
}