/+
CLASS:			DoubleLinkedList(T)
AUTHORS:		Alexandre "TryHard" Leblanc, <alex.cs00@mail.com>, <alex.cs00@yahoo.ca>
				Michael Tran (makrattaur)
DESCRIPTION:	Doubly Linked List!
# Properties
o count					:	Number of element in the list
o empty					:	Returns wether or not the list is empty
o max					:	Returns maximum value
o min					:	Returns minimum value
# Methods
o appendList()			:	Append another list at the end of this list
o clear()				:	Clear the list and its elements
o contains()			:	Returns wether or not the element is in list
o countItem()			:	Returns number of an item occurence in list
o getMaxValue()			:	Returns the max value. Use 'max' property instead.
o getMinValue()			:	Returns the min value. Use 'min' property instead.
o getValueAt()			:	Returns the value T at given position
o insert()				:	Inserts a T element on TOP of the list (becomes first)
o insertAt()			:	Inserts a T element at a given position (push on bottom)
o insertLast()			:	Inserts a T element at the BOTTOM of the list (becomes last)
o makeSingleValues()	:	Remove all duplicates of each elements.
o prependList()			:	Prepend a list (on top of current) while conserving same order.
o removeAt()			:	Remove item at a given position
o removeItem()			:	Remove first or all occurence of and item T in the list (firstOnly = true by default)
o reverse()				:	Reverse the list
o sort()				:	TODO (As in: not implemented)
o toArray()				:	Copy the list into an array
o toReverseArray()		:	Copy the reversed list into	an array (More performant than reverse() then toArray())
# Operators
o opIndex (List[index]) :	Equivalent to getValueAt(index)
o opOpAssign(~=)		:	Equivalent to appendList(DoublyLinkedList!(T) anotherList)
o opSlice (List[x..y])	:	Equivalent to toArray()[x..y]
o opDollar (List[x..$])	:	Dollar represents count-1. Therefore [x..$] is equivalent to [x..count-1]

NOTE:			Please submit any bugs, comments or suggestion by mail on my @mail domain --TryHard.
Use with ["import dllist;"]
Then use auto myVar = DoublyLinkedList!(T type)();
Unittests passed.
Sorting will come eventually.

D_VER:			Works under DMD2.0.65+ 
Works under Geany and VisualD editors/plugins.

VERSION_HISTORY:	[1.2.1] Added ~= operator (appendList)
							Added functions appendList and prependList
					[1.0] Comitted to GitHub
+/

module dllist;

import std.string : format;
import core.memory;

public class DoublyLinkedList(T) {

	/**
	* Node Structure representing a Node in the list.
	*/
	private struct Node {
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
	public uint count() const pure @property {
		return m_nodesCount;
	}

	/**
	* @property empty
	* @returns True if list is empty. False otherwise.
	*/
	public bool empty() const pure @property {
		return (m_nodesCount == 0);
	}

	/**
	* @property max
	* @returns Maximum value in list
	*/
	public T max() @property {
		return getMaxValue();
	}

	/**
	* @property min
	* @returns Minimum value in list
	*/
	public T min() @property {
		return getMinValue();
	}

	/** 
	 * appendList Append a list at the end of this one
	 * @param list List to append at the end of the current list.
	 * @note Use "~=" operator (this ~= otherList)
	 */
	public void appendList(DoublyLinkedList!(T) list) {
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
	public void clear() {
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
	public bool contains(T value) nothrow {
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
	public uint countItem(T element) nothrow {
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
	public T getMaxValue() {
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
	public T getMinValue() {
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
	private Node* getNodeAt(uint index) {
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
	public T getValueAt(uint index) {
		if(index >= m_nodesCount) {
			throw new Exception(format("Index out-of-range error. Index: %s, Count: %s (getValueAt())", index, m_nodesCount));
		}

		uint count = 0;
		Node* n = m_begin;

		while(count < index) {
			n = n.next;
			count++;
		}

		if(n == null)
			throw new Exception(format("Index out-of-range error. Index: %s, Count: %s (getValueAt())", index, m_nodesCount));

		return n.value;
	}

	/**
	* insert Inserts an element on top of the list (becomes first)
	* @param value Value to insert in the list
	*/
	public void insert(T value) nothrow {
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
	public void insertAt(T element, uint index) nothrow {
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
	public void insertLast(T element) nothrow {
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
	public void prependList(DoublyLinkedList!(T) list) {
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
	public void removeAt(uint index) {
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
	public void removeItem(T element, bool firstOnly = true) nothrow {
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
	public void reverse() nothrow {
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
	public void sort() {
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
	private void swapIndexes(uint inx1, uint inx2) {
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
	private uint qsortPartition(uint left, uint right, uint pivot) {
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
	private void qsort(uint left, uint right) {
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
	private void qsort()
	{
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
		T ele = n1.value;
		n1.value = n2.value;
		n2.value = ele;
	}

	/**
	* toArray Creates a copy of the list into an array
	* @returns List as an array
	*/
	public T[] toArray() nothrow {
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
	public T[] toReverseArray() nothrow {
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
	public T opIndex(uint index) {
		return getValueAt(index);
	}

	/**
	 * opOpAssign "~" Concatenation assignement operator
	 * @param list Same type list.
	 */
	public void opOpAssign(string op : "~")(DoublyLinkedList!(T) list) {
		appendList(list);
	}

	/**
	* opSlice Slice operator (e.g. myVar[x..y] || myVar[4..6]). Equivalent to toArray()[x..y]
	* @param x Starting position
	* @param y Ending position
	* @returns Array representing the slice
	*/
	public T[] opSlice(uint x, uint y) {
		return toArray()[x..y];
	}

	/**
	* opDollar Dollar 'operator'. It corresponds to count-1.
	*/
	public uint opDollar() pure nothrow {
		return m_nodesCount-1;
	}
}