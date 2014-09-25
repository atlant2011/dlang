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

module dllist;

import std.string : format;
import core.memory;

public final class DoublyLinkedList(T) {

	/**
	* Node Structure representing a Node in the list.
	*/
	private final struct Node {
		T value;			// Stored value
		Node* next;		    // Pointer to the next node
		Node* previous;		// Pointer to previous node

		/**
		* CTOR
		* @param val Templated value
		* @param n Following node (aka next node)
		* @param p Precedeting node (aka previous node)
		*/
		this(T val, Node* n, Node* p) {
			next = n;
			previous = p;
			value = val;
		}
	}

	private Node* m_begin;		// On top node
	private Node* m_end;		// Last node.
	private uint m_nodesCount;	// Nodes count || List size

	/**
	* @property count   
	* @returns Real quantity of elements in the list (not the length)
	*/
	public uint count() const pure nothrow @property {
		return m_nodesCount;
	}

	/**
	* @property empty
	* @returns True if list is empty. False otherwise.
	*/
	public bool empty() const pure nothrow @property {
		return (m_nodesCount == 0);
	}

	/**
	* @property max
	* @returns Maximum value in list
	*/
	public T max() pure nothrow @property {
		return getMaxValue();
	}

	/**
	* @property min
	* @returns Minimum value in list
	*/
	public T min() pure nothrow @property {
		return getMinValue();
	}

	/** 
	 * appendList Append a list at the end of this one
	 * @param list List to append at the end of the current list.
	 * @note Use "~=" operator (this ~= otherList)
	 */
	public void appendList(DoublyLinkedList!(T) list) pure @safe {
		if(list.count == 0) {
			return;
		}

		for(uint i = 0; i < list.count; ++i) {
			insertLast(list.getValueAt(i));
		}
	}

	/**
	* clear Clears the list from all items (calls GC.collect(), too)
	*/
	public void clear() @trusted {
		Node* n = m_begin;

		while(n != null) {
			Node* next = n.next; 
			destroy(n);
			n = next;
		}

		m_nodesCount = 0;
		m_begin = null;
		m_end = null;
		core.memory.GC.collect();
	}

	/**
	* contains Find if element 'value' is in list
	* @param value Element to search
	* @returns True if found, false otherwise
	*/
	public bool contains(T value) pure nothrow @safe {
		Node* n = m_begin;

		while(n != null) {
			if(n.value == value) {
				return true;
			}

			n = n.next;
		}

		return false;
	}

	/**
	* countItem Count number of element occurence
	* @param element Element to count
	* @returns : Number of element's occurences in the list.
	*/
	public uint countItem(T element) pure nothrow @safe {
		Node* n = m_begin;
		uint count = 0;

		while(n != null) {
			if(n.value == element) {
				count++;
			}

			n = n.next;
		}

		return count;
	}

	/**
	* getMaxValue Gets the max value in list
	* @returns : Maximum value in the list
	*/
	public T getMaxValue() pure @safe {
		if(m_nodesCount == 0) {
			return T.init;
		}
		if(m_nodesCount < 2) {
			return m_begin.value;
		}

		T maxVal = m_begin.value;
		Node* n = m_begin.next;

		while(n != null) {
			if(n.value > maxVal) {
				maxVal = n.value;
			}
			n = n.next;
		}

		return maxVal;
	}

	/**
	* getMinValue Gets the minimum value in the list
	* @returns Minimum value in the list
	*/
	public T getMinValue() pure @safe {
		if(m_nodesCount == 0) {
			return T.init;
		}
		if(m_nodesCount < 2) {
			return m_begin.value;
		}

		Node* n = m_begin.next;
		T minVal = m_begin.value;

		while(n != null) {
			if(n.value < minVal) {
				minVal = n.value;
			}
			n = n.next;
		}

		return minVal;	
	}

	/**
	* getNodeAt Gets the node at 'index' position
	* @param index Node's position in list
	* @returns A Pointer on the node. (Node*)
	*/
	private Node* getNodeAt(uint index) pure nothrow @safe {
		Node* n = m_begin;

		for(uint i = 0; i < index && n != null; ++i) {
			n = n.next;
		}

		return n;
	}

	/**
	* getValueAt Returns element at 'index' position
	* @param index Element's position in list
	* @returns Element of type T
	* @exception Throws an exception if out of range.
	*/
	public T getValueAt(uint index) pure @safe {
		if(index >= m_nodesCount) {
			throw new Exception(format("Index out-of-range error. Index: %s, Count: %s (getValueAt())", index, m_nodesCount));
		}
		
		Node* n;
		if(index > m_nodesCount / 2) {
			uint count = 0;
			n = m_begin;
	
			while(count < index) {
				n = n.next;
				count++;
			}
		} else {
			uint count = m_nodesCount-1;
			n = m_end;
	
			while(count > index) {
				n = n.previous;
				count--;
			}		
		}
		
		if(n == null)
			throw new Exception(format("Index out-of-range error. Index: %s, Count: %s (getValueAt())", index, m_nodesCount));

		return n.value;
	}

	/**
	* insert Inserts an element on top of the list (becomes first)
	* @param value Value to insert in the list
	*/
	public void insert(T value) pure nothrow @safe {
		// Copy the pointer of the will-be-second-in-list element
		Node* d = m_begin;

		// Create new node for the new value
		Node* n = new Node(value, m_begin, null);

		// If this is not the first element we add, we set the next node's previous element
		if(d != null)
			d.previous = n;

		// We point the top element to the new.
		m_begin = n;

		// If there was no last element, we set it.
		if(m_end == null)
			m_end = n;

		m_nodesCount++;
	}

	/**
	* insertAt Inserts an element 'element' at 'index' position in the list
	* @param element Element to insert
	* @param index Position to be inserted at. 
	* @note Elements after 'index' position will be moved toward the bottom of the list.
	*/
	public void insertAt(T element, uint index) pure nothrow @safe {
		// If the index is too big. Not sure if need to crash or silently place it last.
		if(index >= m_nodesCount) {
			insertLast(element);
		}
		
		uint pos = 0;
		Node* n = m_begin;

		while(pos != index) {
			n = n.next;
			pos++;
		}

		Node* newNode = new Node(element, n, n.previous);
		n.previous.next = newNode;
		n.previous = newNode;

		m_nodesCount++;
	}

	/**
	* insertLast Inserts value at the end of list 
	* @param element Element to insert.
	*/
	public void insertLast(T element) pure nothrow @safe {
		Node* e = m_end;

		Node* n = new Node(element, null, m_end);

		if(e != null)
			e.next = n;

		m_end = n;

		// If that's the first element in the list we set it as first as well
		if(m_begin == null)
			m_begin = n;

		m_nodesCount++;
	}

	/**
	* makeSingleValues Remove all duplicates of each elements
	*/
	public void makeSingleValues() {
		// If we don't even have 2 elements, it's stupid to do whatever.
		if(m_nodesCount < 2) {
			return;
		}

		Node* n = m_begin;
		Node* next = null;
		Node* prev = null;
		auto lstFound = new DoublyLinkedList!(T)();

		while(n != null) {
			if(!lstFound.contains(n.value)) {
				lstFound.insert(n.value);
				n = n.next;
				continue;
			} 

			next = n.next;
			prev = n.previous;

			if(prev != null) {
				prev.next = next;
			} else {
				m_begin = next;
			}

			if(next != null) {
				next.previous = prev;
			} else {
				m_end = prev;
			}

			// GC auto collect.
			destroy(n);

			n = next;
			m_nodesCount--;
		}
		destroy(lstFound);
	}

	/**
	 * prependList Prepend list at the beginning. Keeps the same order.
	 * @param list List to prepend to the current list.
	 */
	public void prependList(DoublyLinkedList!(T) list) pure @safe {
		if(list.count == 0) {
			return;
		}

		for(uint i = list.count; i > 0; --i) {
			insert(list.getValueAt(i-1));
		}
	}

	/**
	* removeAt Remove element at 'index' position
	* @param index Index of the element to remove
	* @exception Throws an exception if index is out of range
	*/
	public void removeAt(uint index) pure @safe {
		if(index >= m_nodesCount) {
			throw new Exception(format("Index out-of-range error. Index: %s, Count: %s (removeAt())", index, m_nodesCount));
		}

		uint count = 0;

		Node* n = m_begin;

		while(count < index && n != null) {
			n = n.next;
			count++;
		}

		if(n == null) {
			return;
		} 

		// Swap pointers.
		if(n == m_end) {
			n.previous.next = null;
			m_end = n.previous;
		} else {
			n.previous.next = n.next; 
			n.next.previous = n.previous;
		}

		n = null;
		m_nodesCount--;
	}

	/**
	* removeItem Removes the first or all occurence of T element.
	* @param element Element to remove
	* @param firstOnly (Default=true) If set at false, it will delete all occurence (recursive)
	*/
	public void removeItem(T element, bool firstOnly = true) pure nothrow @safe {
		Node* n = m_begin;
		bool isFound = false;

		while(n!= null) {
			if(n.value == element) {
				isFound = true;
				break;
			}

			n = n.next;
		}

		// Swap pointers.
		if(n == m_end) {
			n.previous.next = null;
			m_end = n.previous;
		} 

		if(n == m_begin) {
			n.next.previous = null;
			m_begin = n.next;
		}

		if(n == null)
			return;

		n = null;
		m_nodesCount--;

		if(!firstOnly) {
			removeItem(element, firstOnly);
		}
	}

	/**
	* reverse Reverse the list order
	*/
	public void reverse() pure nothrow @safe {
		Node* n = m_begin; 

		while(n != null) {
			m_end = m_begin;
			Node* nextNode = n.next;
			n.next = n.previous;
			n.previous = nextNode;

			if(nextNode == null) {
				m_begin = n;
			}

			n = nextNode;
		}
	}

	/**
	* sort Quicksort (NOT IMPLEMENTED) (TODO)
	*/
	public void sort() pure @safe {
		if(m_nodesCount < 2) {
			return;
		}

		qsort();
	}
	
	/**
	* swapIndexes Swap the nodes at the specified indexes.
	* @param inx1 First index to swap.
	* @param inx2 Second index to swap.
	*/
	private void swapIndexes(uint inx1, uint inx2) pure @safe {
		swapNodes(getNodeAt(inx1), getNodeAt(inx2));
	}
	
	/**
	* qsortPartition Does one iteration of the partition step of the in-place
	*                Quicksort algorithm.
	* @param left The lower bound to partition (inclusive).
	* @param right The upper bound to partition (inclusive).
	* @param pivot The index of the pivot to use.
	* @returns The final postion of the pivot.
	*/
	private uint qsortPartition(uint left, uint right, uint pivot) pure @safe {
		T pivotValue = getValueAt(pivot);
		// Place the pivot at the end of the range.
		swapIndexes(pivot, right);

		// Indicates at which position the values smaller than the pivot will be
		// swapped with.
		uint storeIndex = left;
		for(uint i = left; i < right; i++) {
			if(getValueAt(i) <= pivotValue) {
				swapIndexes(i, storeIndex);
				storeIndex++;
			}
		}
		// Place the pivot where it belongs.
		swapIndexes(storeIndex, right);
		
		return storeIndex;
	}
	
	/**
	* qsort Implementation of the in-place Quicksort algorithm.
	* @param left The lower bound of the list to sort.
	* @param right The upper bound of the list to sort.
	*/
	private void qsort(uint left, uint right) pure @safe {
		// Nothing to sort.
		if(left >= right) {
			return;
		}
	
		// The pivot is the element at the center of the range.
		uint pivot = left + (right - left + 1) / 2;
		uint newPivotIndex = qsortPartition(left, right, pivot);
		
		// Avoid index overflow and underflow.
		
		if(newPivotIndex != left) {
			qsort(left, newPivotIndex - 1);
		}
		
		if(newPivotIndex != right) {
			qsort(newPivotIndex + 1, right);
		}
	}
	
	/**
	* qsort Implementation of the in-place Quicksort algorithm.
	*       Overload to sort the whole list.
	*/
	private void qsort() pure @safe {
		uint left = 0;
		uint right = m_nodesCount - 1;
	
		qsort(left, right);
	}
	
	/**
	* swapNodes Swap nodes' values
	* @param n1 First node
	* @param n2 Second node
	*/
	private void swapNodes(Node* n1, Node* n2) nothrow {
		if(n1 == n2) {
			return;
		}
				
		//T ele = n1.value;
		//n1.value = n2.value;
		//n2.value = ele;
		
		if(n1.previous != null) { n1.previous.next = n2; }
		if(n2.previous != null) { n2.previous.next = n1; }
		if(n1.next != null) { n1.next.previous = n2; }
		if(n2.next != null) { n2.next.previous = n1; }
		
		Node* temp;
		
		temp = n1.previous;
		n1.previous = n2.previous;    
		n2.previous = temp;
		temp = n1.next;
		n1.next = n2.next;    
		n2.next = temp;
		
		if(m_begin == n1) { m_begin = n2; }
		else if(m_begin == n2) { m_begin = n1; }
		if(m_end == n2) { m_end = n1; }
		else if(m_end == n1) { m_end = n2; }
	}

	/**
	* toArray Creates a copy of the list into an array
	* @returns List as an array
	*/
	public T[] toArray() pure nothrow {
		T[] elements = new T[m_nodesCount];

		Node* n = m_begin;

		for(uint i = 0; i < m_nodesCount; ++i) {
			if(n == null) {
				break;
			}
			elements[i] = n.value;
			n = n.next;
		}

		return elements;
	}

	/**
	* toReverseArray Creates an array of the reversed list. Better performance than reverse() + toArray(). 
	*                Doesn't actually reverse it.
	* @returns Reversed list in array format.
	*/
	public T[] toReverseArray() pure nothrow {
		Node* n = m_end;
		T[] elements = new T[m_nodesCount];

		for(uint i = 0; i < m_nodesCount; ++i) {
			if(n == null) {
				break;
			}

			elements[i] = n.value;

			n = n.previous;
		}

		return elements;
	}

	/**
	* DEFAULT CTOR
	*/
	public this() {
		m_end = null;
		m_begin = null;
		m_nodesCount = 0;
	}

	/**
	* DTOR
	*/
	public ~this() {
		clear();
	}

	/**
	* opIndex Index operator (e.g. myVar[index] || myVar[4]). Equivalent to getValueAt(index)
	* @param Element's position in list
	* @returns T element
	*/
	public T opIndex(uint index) pure {
		return getValueAt(index);
	}

	/**
	 * opOpAssign "~" Concatenation assignement operator
	 * @param list Same type list.
	 */
	public void opOpAssign(string op : "~")(DoublyLinkedList!(T) list) pure {
		appendList(list);
	}

	/**
	* opSlice Slice operator (e.g. myVar[x..y] || myVar[4..6]). Equivalent to toArray()[x..y]
	* @param x Starting position
	* @param y Ending position
	* @returns Array representing the slice
	*/
	public T[] opSlice(uint x, uint y) pure {
		return toArray()[x..y];
	}

	/**
	* opDollar Dollar 'operator'. It corresponds to count-1.
	*/
	public uint opDollar() pure nothrow {
		return m_nodesCount-1;
	}
}