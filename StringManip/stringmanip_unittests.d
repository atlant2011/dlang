/+
	FILE:			StringManip
	DESCRIPTION:	Unit tests
+/
import std.stdio;
import stringmanip;

unittest {
	// Conventional string
	immutable string str1 = "Les chemises de : l'archiduchesse : sont-elle sèches : ou archi-sèches : ?";


	writeln("Step 1: getBetween\r\n",
		  "-----------------------\r\n",
		  "Expected ' chemises '\r\nReturned '", getBetween!(string)("Les", "de", str1), "'\r\n",
		  "Expected ''\r\nReturned '", getBetween!(string)("les", "de", str1), "'\r\n",
		  "Expected ' chemises '\r\nReturned '", getBetween!(string)("Les", "DE", str1, false), "'\r\n",
		  "Expected 'duchesse : sont-elle '\r\nReturned '", getBetween!(string)("archi", "sèches", str1), "'\r\n");
	
	assert(getBetween!(string)("Les", "de", str1) == " chemises ");	// Case sensitive
	assert(getBetween!(string)("les", "de", str1) != " chemises ");	// Shouldn't work.
	assert(getBetween!(string)("Les", "DE", str1, false) == " chemises "); // Should work, case insensitive
	assert(getBetween!(string)("archi", "sèches", str1) == "duchesse : sont-elle ");

	// getBetweenLast
	assert(getBetweenLast!(string)("archi", "sèches", str1) == "-");	// Case sensitive
	assert(getBeforeLast!(string)("sèches", str1) != "lol");

	readln();
	writeln("Step 2: getBetweenLast\r\n",
		  "-----------------------\r\n",
		  "Expected '-', returned '", getBetweenLast!(string)("archi", "sèches", str1), "'\r\n");
	
	// getBetweenN
	assert(getBetweenN!(string)(":", ":", 1, str1) == " sont-elle sèches ");
	
	readln();
	
	writeln("Step 3: getBetweenN\r\n", 
		  "-----------------------\r\n",
		  "Expected ' sont-elle sèches '\r\nReturned '", getBetweenN!(string)(":", ":", 1, str1), "'\r\n");

	readln();
		  
	writeln("Step 4: getBetweenAll\r\n",
			"---------------------\r\n",
			"Expected [\" l'archiduchesse \", \" sont-elle sèches \", \" ou archi-sèches \"]\r\nReturned ", getBetweenAll!(string)(":", ":", str1), "\r\n");
			
	readln();
	
	writeln("Step 5: getAfter\r\n",
			"------------------\r\n",
			"Expected ' : l'archiduchesse : sont-elle sèches : ou archi-sèches : ?'\r\nReturned '", 
			getAfter!(string)("de", str1), "'");
			
	readln();
	writeln("Step 6: getBefore\r\n",
			"------------------\r\n",
			"Expected 'Les chemises de : l'archiduchesse : '\r\n",
			"Returned '", getBefore!(string)("sont-elle", str1), "'");
	
	readln();
	writeln("Step 7: getAfterLast\r\n",
			"------------------\r\n",
			"Expected ' : ?'\r\n",
			"Returned '", getAfterLast!(string)("sèches", str1), "'");	
			
	readln();
	writeln("Step 8: getBeforeLast\r\n",
			"------------------\r\n",
			"Expected 'Les chemises de : l'archiduchesse : sont-elle sèches : ou archi-'\r\n",
			"Returned '", getBeforeLast!(string)("sèches", str1), "'");				

	readln();
	writeln("Step 9: replaceFirstCopy\r\n",
			"------------------\r\n",
			"Expected 'Les [cailloux] de : l'archiduchesse : sont-elle sèches : ou archi-sèches : ?'\r\n",
			"Returned '", replaceFirstCopy!(string)("chemises", "[cailloux]", str1), "'");
			
	readln();
	writeln("Step 10: replaceLastCopy\r\n",
			"------------------\r\n",
			"Expected 'Les chemises de : l'archiduchesse : sont-elle sèches : ou archi-[cailloux] : ?'\r\n",
			"Returned '", replaceLastCopy!(string)("sèches", "[cailloux]", str1), "'");	
			
	readln();
	writeln("Step 11: replaceNCopy\r\n",
			"------------------\r\n",
			"Expected 'Les chemises de : l'archiduchesse [cailloux] sont-elle sèches : ou archi-sèches : ?'\r\n",
			"Returned '", replaceNCopy!(string)(":", "[cailloux]", 2, str1), "'");		
			
	readln();
	writeln("Step 12: replaceAllCopy\r\n",
			"------------------\r\n",
			"Expected 'Les chemises de [cailloux] l'archiduchesse [cailloux] sont-elle sèches [cailloux] ou archi-sèches [cailloux] ?'\r\n",
			"Returned '", replaceAllCopy!(string)(":", "[cailloux]", str1), "'");			
}

int main() {
	return 0;
}