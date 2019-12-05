///
/// Array that can be referenced ; to use with hashmap or for multidimentional array.
///
class xmf_Array extends JsonObject;

`define ClassName xmf_Array
`include( UnrestrictedCustomization\Src\UnrestrictedCustomization\macros.uci )

//======================================================================================================================
// FIELDS

var private array<Object> _array;

//======================================================================================================================
// PROPERTIES

/**
 * The length of the array.
 */
public function int GetLength() { return _array.Length; }
public function SetLength(int _value) { _array.Length = _value; }

//======================================================================================================================
// CTOR

///
/// Instantiates this class.
///
public static function xmf_Array CreateArray() {
	return Array(class'xmf_Array');
}

protected static function xmf_Array Array( class<xmf_Array> _class ) {
	local xmf_Array this;
	this = new _class;
	this.InitArray();
	return this;
}

private function InitArray() {
	
}

//======================================================================================================================
// METHODS

public function Object Get( int _index ) {
	return _array[_index];
}

public function Set( int _index, Object _value ) {
	_array[_index] = _value;
}

/**
 * Adds a item to the array.
 *
 * @param	item - The item to add.
 */
public final function AddItem( object item ){ _array.AddItem(item); }

/**
 * Removes a specified item.
 *
 * @param	item - The item to remove.
 */
public final function RemoveItem( object item ){ _array.RemoveItem(item); }

/**
 * Inserts a item at a specified index.
 *
 * @param	index - The index to insert the item at.
 * @param	count - The item to insert.
 */
public final function InsertItem( int index, object item ){ _array.InsertItem(index,item); }

/**
 * Find and returns the found element with a specified value, if nothing is found it will return -1.
 *
 * @param	value - The value to look for.
 *
 * @return	The found index or -1 if value wasn't found.
 */
public final function int Find( object value ){ return _array.Find(value); }

/**
 * Find and returns the found element with a specified value, if nothing is found it will return -1.
 *
 * @param	propertyName - The property name of within a struct to test against.
 * @param	value - The value to look for.
 *
 * @return	The found index or -1 if value wasn't found.
 */
//todo public final function int FindStruct( name propertyName, object value ){ return _array.Find(propertyName,value);}

/**
 * Sorts the array.
 *
 * @param	sortDelegate - The method to use for sorting.
 */
//TODO public final function Sort( delegate sortDelegate ){ _array.Sort(sortDelegate); }