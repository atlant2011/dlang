/+
	CLASS:			StringManip
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
					o replaceAllCopy	:	Replace all occurences by an element in a copied string.
					o replaceAll		:	Replace all occurences by an element in the string given (reference).

	NOTE:			Please submit any bugs, comments or suggestion by mail on my @mail domain --TryHard.
					Use with ["import stringmanip;"]
					Then use StringManip.getBetween(wthis, wthat, inthat);
+/

module stringmanip;

import std.stdio;

public static class StringManip
{
	/**
	* getBetween Get the first string between the occurence of the identifiers
	* @param wfirst Opening identifier (e.g. <p>)
	* @param wlast Ending identifier (e.g. </p>)
	* @param inthat String to search in.
	* @returns wstring Matching result. If nothing found, returns an empty string.
	*/
	public static wstring getBetween(immutable wstring wfirst, immutable wstring wlast, immutable wstring inthat, immutable byte isCaseSensitive = 0)
	{
		// Get the indexes of wfirst and wlast.
		immutable auto f_pos = std.string.indexOf(inthat, wfirst);
		immutable auto l_pos = std.string.indexOf(getAfter(wfirst, inthat), wlast);

		// If we do not found a matching pair, return an empty string.
		if(f_pos < 0 || l_pos < 0)
			return ""w;

		// Return the matching result. wfirst.length is important, else you'll include a part of the opening tag in the result.
		return inthat[(f_pos + wfirst.length)..(f_pos + wfirst.length + l_pos)];
	}

	/**
	* getBetweenLast Get the last string between the occurence of the identifiers
	* @param wfirst Opening identifier (e.g. <p>)
	* @param wlast Ending identifier (e.g. </p>)
	* @param inthat String to be searched in.
	* @returns wstring Matching result. If nothing found, returns an empty string.
	*/
	public static wstring getBetweenLast(immutable wstring wfirst, immutable wstring wlast, immutable wstring inthat)
	{
		// Get the last position of wfirst and wlast.
		immutable auto l_pos = std.string.lastIndexOf(inthat, wlast);
		immutable auto f_pos = std.string.lastIndexOf(getBeforeLast(wlast, inthat), wfirst);

		// If we do not find a matching result, return an empty string.
		if(f_pos < 0 || l_pos < 0)
			return ""w;

		// Return the matching result.
		return inthat[(f_pos + wfirst.length)..(f_pos + wfirst.length + l_pos)];
	}
	
	/**
	 * getBetweenN Get the string between N-th occurence of the identifiers in given input string
	 * @param wfirst Opening identifier (e.g. <p>)
	 * @paaram wlast Ending identifier (e.g. </p>)
	 * @param n N-th occurence
	 * @param inthat Input string to search in.
	 * @returns String between identifiers at N-th occurence. Empty if nothing found.
	 */
	public static wstring getBetweenN(immutable wstring wfirst, immutable wstring wlast, immutable byte n, wstring inthat)
	{
		// Initialize the default n occurence to 0.
		byte i = 0;
		
		// While we've not reached the n-th occurence, and that we can still find the occurence, increment index, and get
		// what is after.
		while(i < (n-1) && (std.string.indexOf(inthat, wfirst) >= 0 && std.string.indexOf(getAfter(wfirst, inthat), wlast) >= 0))
		{
			inthat = getAfter(wfirst, getAfter(wlast, inthat));
			i++;
		}

		// If we don't find n-th occurence, just send an empty string.
		if(std.string.indexOf(inthat, wfirst) < 0 || std.string.indexOf(getAfter(wfirst, inthat), wlast) < 0 || i+1 != n)
			return ""w;

		// Get the position of the n-th occurence.
		auto f_pos = std.string.indexOf(inthat, wfirst);
		auto l_pos = std.string.indexOf(getAfter(wfirst, inthat), wlast);

		// Return the resulting string.
		return inthat[(f_pos + wfirst.length)..(f_pos + wfirst.length + l_pos)];
	}

	/**
	* getBetweenAll Get all matching string between all identifiers
	* @param wthis Opening identifier (e.g. <p>)
	* @param wthat Ending identifier (e.g. </p>)
	* @param inthat String to be searched in.
	* @returns wstring Array containing all matching result. If nothing found, send an array with one empty string.
	*/
	public static wstring[] getBetweenAll(immutable wstring wthis, immutable wstring wthat, immutable wstring inthat)
	{
		// Declare list.
		wstring[] list;

		// If there is no match of at least one of the identifiers, return an empty array
		if(std.string.indexOf(inthat, wthis) < 0 || 0 > std.string.indexOf(inthat, wthat))
		{
			// Add at least one empty string then return it.
			list ~= "";
			return list;
		}

		// Initialize the index.
		ushort index = 0;
		// Copy the original string.
		wstring original = inthat.dup;

		// While we can find both identifiers
		while(std.string.indexOf(original, wthis) >= 0 && std.string.indexOf(original, wthat) >= 0)
		{
			// Get what is between the first identifiers.	
			list ~= getBetween(wthis, wthat, original);

			// Get the matching string with identifier
			wstring str = (wthis ~ list[index] ~ wthat).dup;
			// Then get what comes after.
			original = getAfter(str, original);
			// Increment index.
			index++;
		}

		// Return list.
		return list;
	}

	/**
	 * getAfter Get string after occurence "wthis"
	 * @param wthis Occurence to look for
	 * @param inthat String to search in
	 * @returns String coming after occurence "wthis"
	 */
	public static wstring getAfter(immutable wstring wthis, immutable wstring inthat)
	{
		// Ocurrence's position
		immutable auto pos = std.string.indexOf(inthat, wthis);

		// If occurence is not found in string, return an empty string.
		if(pos < 0)
			return ""w;

		// Return string after "wthis"
		return inthat[(pos + wthis.length)..$];
	}

	/**
	 * getAfterLast Get string after last occurence "wthis"
	 * @param wthis Occurence to look for
	 * @param inthat String to be searched in
	 * @returns String after last occurence "wthis"
	 */
	public static wstring getAfterLast(immutable wstring wthis, immutable wstring inthat)
	{
		// Position of the latest occurence "wthis"
		immutable auto pos = std.string.lastIndexOf(inthat, wthis);

		// If not found, return empty string
		if(pos < 0)
			return ""w;

		// Return the string after last occurence found
		return inthat[(pos + wthis.length)..$];
	}

	/**
	 * getBefore Get the string before occurence of "wthis"
	 * @param wthis Occurence to look for
	 * @param inthat String to look occurence in
	 * @returns Returns the string before "wthis"
	 */
	public static wstring getBefore(immutable wstring wthis, immutable wstring inthat)
	{
		// Get position of the occurence
		immutable auto pos = std.string.indexOf(inthat, wthis);

		// If not found, return an empty string.
		if(pos < 0)
			return ""w;

		// returns the string before occurence's position.
		return inthat[0..pos];
	}

	/**
	 * getBeforeLast Get the string before the last occurence "wthis"
	 * @param wthis Occurence to look for
	 * @param inthat String to search occurence in
	 * @returns Returns the string before the last occurence given
	 */
	public static wstring getBeforeLast(immutable wstring wthis, immutable wstring inthat)
	{
		// Ge the last position of occurence
		immutable auto pos = std.string.lastIndexOf(inthat, wthis);

		// If not found, return an empty string
		if(pos < 0)
			return ""w;

		// Return the string before the last occurence
		return inthat[0..pos];
	}

	/**
	 * replaceFirstCopy Replace the first occurence "wthis" by the element "bythat" in a copied given string.
	 * @param wthis First occurence to replace
	 * @param bythat Element to replace "wthis" with.
	 * @param inthat String to replace things in.
	 * @returns A modified copy of the original string (leaves the original string safe).
	 */
	public static wstring replaceFirstCopy(immutable wstring wthis, immutable wstring bythat, immutable wstring inthat)
	{
		// If occurence is not found, just return the original string.
		if(std.string.indexOf(inthat, wthis) < 0)
			return inthat;

		// Get the string copy with the replaced element.
		wstring str = getBefore(wthis, inthat) ~ bythat ~ getAfter(wthis, inthat);

		// Return resulting string.
		return str;
	}

	/**
	 * replaceFirst Replace the first occurence "wthis" by the element "bythat" in a given string.
	 * @param wthis Occurence to replace.
	 * @param bythat Element to replace "wthis" with.
	 * @param inthat String to replace occurences in.
	 * @returns True if occurence "wthis" is found, else it returns false.
	 */
	public static bool replaceFirst(immutable wstring wthis, immutable wstring bythat, ref wstring inthat)
	{
		// If occurence is not found, just return false
		if(std.string.indexOf(inthat, wthis) < 0)
			return false;

		// Change the string for the new one with replaced element.
		inthat = getBefore(wthis, inthat) ~ bythat ~ getAfter(wthis, inthat);

		// Return the fact it worked.
		return true;
	}

	/**
	 * replaceLastCopy Replace the last occurence "wthis" by the element "bythat" in a copied string given.
	 * @param wthis Occurence to replace.
	 * @param bythat Element replacing given occurence "wthis".
	 * @param inthat String to search and replace in.
	 * @returns Copied original string with replaced elements.
	 */
	public static wstring replaceLastCopy(immutable wstring wthis, immutable wstring bythat, immutable wstring inthat)
	{
		// If occurence is not found, return original string.
		if(std.string.indexOf(inthat, wthis) < 0)
			return inthat;

		// Create a copied string based on the original string with replaced elements.
		wstring str = getBeforeLast(wthis, inthat) ~ bythat ~ getAfterLast(wthis, inthat);

		// Return final string.
		return str;
	}

	/**
	* replaceLast Replace the last occurence "wthis" by the element "bythat" in a given string.
	* @param wthis Occurence to replace.
	* @param bythat Element replacing given occurence "wthis".
	* @param inthat String to search and replace in.
	* @returns True if elements are replaced, false if occurence is not found.
	*/
	public static bool replaceLast(immutable wstring wthis, immutable wstring bythat, ref wstring inthat)
	{
		// If occurence is not found, return false.
		if(std.string.indexOf(inthat, wthis) < 0)
			return false;

		// Modify the string with replaced elements.
		inthat = getBeforeLast(wthis, inthat) ~ bythat ~ getAfterLast(wthis, inthat);

		// Return true for success
		return true;
	}

	/**
	* replaceAllCopy Replace all occurences "wthis" by element "bythat" in the given string.
	* @param wthis Occurence to replace.
	* @param bythat Element replacing given occurence "wthis".
	* @param inthat String to search and replace in.
	* @returns True if elements are replaced, false if occurence is not found.
	*/
	public static wstring replaceAllCopy(immutable wstring wthis, immutable wstring bythat, immutable wstring inthat)
	{
		// If occurence is not found, return false.
		if(std.string.indexOf(inthat, wthis) < 0)
			return inthat;

		// Create a copied string.
		wstring str = inthat.dup;

		// While an occurence is found, replace the first occurence.
		while(replaceFirst(wthis, bythat, str)) { }

		// Return parsed string.
		return str;
	}

	/**
	* replaceAll Replace all occurences "wthis" by element "bythat" in the given string.
	* @param wthis Occurence to replace.
	* @param bythat Element replacing given occurence "wthis".
	* @param inthat String to search and replace in.
	* @returns The parsed copied string with replaced occurences.
	*/
	public static bool replaceAll(immutable wstring wthis, immutable wstring bythat, ref wstring inthat)
	{
		// If occurence is not found, return false.
		if(std.string.indexOf(inthat, wthis) < 0)
			return false;

		// While an occurence is found, replace the first occurence.
		while(replaceFirst(wthis, bythat, inthat)) { }
			
		// Return true;
		return true;
	}

}
