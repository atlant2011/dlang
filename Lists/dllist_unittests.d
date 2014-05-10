import std.stdio;

import std.stdio;
import dllist;

unittest {
	auto list = new DoublyLinkedList!(int)();
	list.insert(10);
	list.insert(20);
	list.insertLast(25);
	list.insertLast(30);
	list.insert(12);

	// List should be 12 20 10 25 30
	assert(list[0] == 12);
	assert(list[1] == 20);
	assert(list[2] == 10);
	assert(list[3] == 25);
	assert(list[4] == 30);

	writeln("STEP 1 : insert & insertLast\n", 
			"----------------------------\n",
			"Expected result: [12, 20, 10, 25, 30]\n",
			"Obtained result: ", list.toArray());
	readln();

	list.reverse();
	list.reverse();
	list.reverse();
	// Test reversing. 30 25 10 20 12
	assert(list[0] == 30);
	assert(list[1] == 25);
	assert(list[2] == 10);
	assert(list[3] == 20);
	assert(list[4] == 12);	

	writeln("STEP 2 : reverse\n", 
			"----------------------------\n",
			"Expected result: [30, 25, 10, 20, 12]\n",
			"Obtained result: ", list.toArray());
	readln();

	auto rarr = list.toReverseArray();

	// Array should be 12 20 10 25 30
	assert(rarr[0] == 12);
	assert(rarr[1] == 20);
	assert(rarr[2] == 10);
	assert(rarr[3] == 25);
	assert(rarr[4] == 30);

	writeln("STEP 3 : toReverseArray\n", 
			"----------------------------\n",
			"Expected result: [12, 20, 10, 25, 30]\n",
			"Obtained result: ", list.toReverseArray(), "\n",
			"Actual list order: ", list.toArray());
	readln();

	// Test properties
	assert(list.count == 5);
	assert(list.max	== 30);
	assert(list.min == 10);
	assert(list.empty == false);

	writeln("STEP 4 : Properties\n", 
			"----------------------------\n",
			"Expected result: count=5 max=30 min=10 empty=false\n",
			"Obtained result: ", "count=", list.count, " max=", 
			list.max, " min=", list.min, " empty=", list.empty);
	readln();

	//Test clear()
	list.clear();
	assert(list.count == 0);
	assert(list.empty == true);
	assert(list.min == 0);
	assert(list.max == 0);

	writeln("STEP 5 : clear and properties\n", 
			"----------------------------\n",
			"Expected result: []\n",
			"Obtained result: ", list.toArray(),
			"\nExpected properties: count=0 max=0 min=0 empty=true\n",
			"Obtained properties: count=", list.count, " max=", list.max,
			" min=", list.min, " empty=", list.empty);
	readln();

	list.insert(10);
	list.insert(15);
	list.insert(10);
	list.insert(10);
	list.insertLast(10);
	list.insertAt(13, 1);
	assert(list[1] == 13);
	assert(list[0] == 10);
	assert(list[3] == 15);

	writeln("STEP 6 : insert & insertAt after clear\n", 
			"----------------------------\n",
			"Expected result: [10, 13, 10, 15, 10, 10]\n",
			"Obtained result: ", list.toArray());
	readln();

	assert(list.count == 6);
	assert(list.empty == false);

	// Test makeSingleValues to remove duplicates
	list.makeSingleValues();
	// List should be 10 13, 15
	assert(list[0] == 10);
	assert(list[1] == 13);
	assert(list[2] == 15);

	writeln("STEP 7 : makeSingleValues\n", 
			"----------------------------\n",
			"Expected result: [10, 13, 15]\n",
			"Obtained result: ", list.toArray(), "\n",
			"Properties: count=", list.count, " max=", list.max,
			" min=", list.min, " empty=", list.empty);
	readln();

	// Testing removeAt
	list.removeAt(1);
	assert(list.count == 2);
	assert(list[1] == 15);

	writeln("STEP 8 : removeAt\n", 
			"----------------------------\n",
			"Expected result: [10, 15]\n",
			"Obtained result: ", list.toArray(), "\n",
			"Properties: count=", list.count, " max=", list.max,
			" min=", list.min, " empty=", list.empty);
	readln();

	// Testing removeItem
	list.removeItem(10);
	assert(list[0] == 15);
	assert(list.count == 1);

	writeln("STEP 9 : removeItem\n", 
			"----------------------------\n",
			"Expected result: [15]\n",
			"Obtained result: ", list.toArray(), "\n",
			"Properties: count=", list.count, " max=", list.max,
			" min=", list.min, " empty=", list.empty);
	readln();

	// Testing removeItem recursive
	list.insert(12);
	list.insert(10);
	list.insert(10);
	list.insertLast(10);

	writeln("STEP 10 : insert (again)\n", 
			"----------------------------\n",
			"Expected result: [10, 10, 12, 15, 10]\n",
			"Obtained result: ", list.toArray(), "\n",
			"Properties: count=", list.count, " max=", list.max,
			" min=", list.min, " empty=", list.empty);
	readln();


	list.removeItem(10, false);
	assert(list[0] == 12);
	assert(list[1] == 15);
	assert(list.count == 2);

	writeln("STEP 11 : removeItem Recursive\n", 
			"----------------------------\n",
			"Expected result: [12, 15]\n",
			"Obtained result: ", list.toArray(), "\n",
			"Properties: count=", list.count, " max=", list.max,
			" min=", list.min, " empty=", list.empty);
	readln();

	// Testing slices + $ operator
	auto slice = list[0..$];
	assert(slice.length == list.count-1);
	assert(slice[0] == list[0]);

	writeln("STEP 12 : Slice (with $)\n", 
			"----------------------------\n",
			"Expected result: [12, 15]\n",
			"Obtained result: ", list.toArray(), "\n",
			"Properties: count=", list.count, " max=", list.max,
			" min=", list.min, " empty=", list.empty);
	readln();

	auto anotherList = new DoublyLinkedList!(int)();
	anotherList.insertLast(11);
	anotherList.insertLast(25);
	anotherList.insertLast(50);
	list.appendList(anotherList);

	writeln("STEP 13 : appendList\n", 
			"----------------------------\n",
			"Expected result: [12, 15, 11, 25, 50]\n",
			"Obtained result: ", list.toArray(), "\n",
			"Properties: count=", list.count, " max=", list.max,
			" min=", list.min, " empty=", list.empty);
	readln();

	list.clear();
	list ~= anotherList;

	writeln("STEP 14 : ~= operator\n", 
			"----------------------------\n",
			"Expected result: [11, 25, 50]\n",
			"Obtained result: ", list.toArray(), "\n",
			"Properties: count=", list.count, " max=", list.max,
			" min=", list.min, " empty=", list.empty);
	readln();
	
	list.clear();
	list.insertLast(10);
	list.insertLast(10);
	list.insertLast(11);
	list.prependList(anotherList);

	writeln("STEP 15 : prependList\n", 
			"----------------------------\n",
			"Expected result: [11, 25, 50, 10, 10, 11]\n",
			"Obtained result: ", list.toArray(), "\n",
			"Properties: count=", list.count, " max=", list.max,
			" min=", list.min, " empty=", list.empty);
	readln();
	
	list.clear();
	list.insertLast(50);
	list.insertLast(23);
	list.insertLast(78);
	list.insertLast(20);
	list.insertLast(8);
	list.insertLast(9);
	list.insertLast(32);
	list.insertLast(12);
	
	list.sort();
	// List should be 8 9 12 20 23 32 50 78
	assert(list[0] == 8);
	assert(list[1] == 9);
	assert(list[2] == 12);
	assert(list[3] == 20);
	assert(list[4] == 23);
	assert(list[5] == 32);
	assert(list[6] == 50);
	assert(list[7] == 78);
	assert(list[8] == 9);
	assert(list[9] == 12);
	assert(list[10] == 20);
	assert(list[11] == 23);
	assert(list[12] == 32);
	assert(list[13] == 50);
	assert(list[14] == 78);

	writeln("STEP 16 : sort\n", 
			"----------------------------\n",
			"Expected result: [8, 9, 12, 20, 23, 32, 50, 78]\n",
			"Obtained result: ", list.toArray());
	readln();
	
	list.clear();
	list.insertLast(12);
	list.insertLast(20);
	list.insertLast(10);
	list.insertLast(25);
	list.insertLast(30);

	list.sort();
	// List should be 10 12 20 25 30
	assert(list[0] == 10);
	assert(list[1] == 12);
	assert(list[2] == 20);
	assert(list[3] == 25);
	assert(list[4] == 30);

	writeln("STEP 17 : sort (final pivot position at the beginning)\n", 
			"----------------------------\n",
			"Expected result: [10, 12, 20, 25, 30]\n",
			"Obtained result: ", list.toArray());
	readln();
	
	list.clear();
	list.insertLast(12);
	list.insertLast(20);
	list.insertLast(30);
	list.insertLast(25);
	list.insertLast(10);

	list.sort();
	// List should be 10 12 20 25 30
	assert(list[0] == 10);
	assert(list[1] == 12);
	assert(list[2] == 20);
	assert(list[3] == 25);
	assert(list[4] == 30);

	writeln("STEP 18 : sort (final pivot position at the end)\n", 
			"----------------------------\n",
			"Expected result: [10, 12, 20, 25, 30]\n",
			"Obtained result: ", list.toArray());
	readln();
}

int main()
{
	return 0;
}