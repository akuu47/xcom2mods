///
/// Class contain utility method for array.
///
/// Note: do not use macro for method signatures, so it works with autocompletion
///
class uc_ArrayUtil extends Object dependson(uc_BodyPartUtil);

`define ClassName uc_ArrayUtil
`include( UnrestrictedCustomization\Src\UnrestrictedCustomization\macros.uci )


`define GenContainsImpl(type) \n\
	return IndexOf_`{type} (_arr, _elem) != INDEX_NONE;


`define GenContainsAllImpl(type) \n\}(
	local `{type} _elem; \n\
	foreach _elems(_elem) { \n\
		if( IndexOf_`{type} (_arr, _elem) == INDEX_NONE) return false; \n\
	} \n\
	return true;
	
`define GenContainsAnyImpl(type) \n\}(
	local `{type} _elem; \n\
	foreach _elems(_elem) { \n\
		if( IndexOf_`{type} (_arr, _elem) != INDEX_NONE) return true; \n\
	} \n\
	return false;

`define GenIndexOfImpl(type) \n\
	local int _i; \n\
	for( _i=_arr.Length-1; _i>=0; _i-- ) { \n\
		if( AreEqual_`{type} (_elem, _arr[_i]) ) return _i; \n\
	} \n\
	return -1


`define GenContainSameElementsImpl(type) \n\
	return ContainsAll_`{type} (_arr,_arr2) && ContainsAll_`{type} (_arr2,_arr);


`define GenRemoveDuplicatesImpl(type) \n\
	local array< `{type} > _copy; \n\
	local  `{type}  _elem; \n\
	_copy.Length = 0; \n\
	foreach _arr(_elem) { \n\
		AddIfNotPresent_`{type} (_copy, _elem); \n\
	} \n\
	return _copy


`define GenConcatImpl(type) \n\
	local array< `{type} > _ret; \n\
	local `{type} _t; \n\
	foreach _head(_t) _ret.AddItem(_t); \n\
	foreach _tail(_t) _ret.AddItem(_t); \n\
	return _ret


`define GenAddIfNotPresentImpl(type) \n\
	if( Contains_`{type} (_arr, _elem ) ) return false; \n\
	_arr.AddItem(_elem);\n\
	return true

	`define GenCloneImpl(type) \n\
		local `{type} _elem; \n\
		local array< `{type} > _clone; \n\
		foreach _arr(_elem) { \n\
			_clone.AddItem(_elem); \n\
		} \n\
		return _clone;
	/*
	`define GenCreateArrayOfImpl(type, typeDefaultValue) \n\
		local array< `{type} > _arr; \n\
		if( _value0 != `typeDefaultValue ) _arr.AddItem(_value0); \n\
		if( _value1 != `typeDefaultValue ) _arr.AddItem(_value1); \n\
		if( _value2 != `typeDefaultValue ) _arr.AddItem(_value2); \n\
		if( _value3 != `typeDefaultValue ) _arr.AddItem(_value3); \n\
		if( _value4 != `typeDefaultValue ) _arr.AddItem(_value4); \n\
		if( _value5 != `typeDefaultValue ) _arr.AddItem(_value5); \n\
		if( _value6 != `typeDefaultValue ) _arr.AddItem(_value6); \n\
		if( _value7 != `typeDefaultValue ) _arr.AddItem(_value7); \n\
		if( _value8 != `typeDefaultValue ) _arr.AddItem(_value8); \n\
		if( _value9 != `typeDefaultValue ) _arr.AddItem(_value9); \n\
		return _arr;
		*/

`define Gen(type) \n\
	public static function bool Contains_`{type} ( array< `{type} > _arr, `{type} _elem ) { \n\
		`GenContainsImpl( `{type} ); \n\
	} \n\
	\n\
	public static function bool ContainsAll_`{type} ( array< `{type} > _arr, array< `{type} > _elems ) { \n\
		`GenContainsAllImpl( `{type} ); \n\
	} \n\
	public static function bool ContainsAny_`{type} ( array< `{type} > _arr, array< `{type} > _elems ) { \n\
		`GenContainsAnyImpl( `{type} ); \n\
	} \n\
	\n\
	public static function bool ContainSameElements_`{type} ( array< `{type} > _arr, array< `{type} > _arr2 ) { \n\
		`GenContainSameElementsImpl( `{type} ); \n\
	} \n\
	\n\
	public static function array< `{type} > RemoveDuplicates_`{type} ( array< `{type} > _arr ) { \n\
		`GenRemoveDuplicatesImpl( `{type} ); \n\
	} \n\
	\n\
	public static function array< `{type} > Concat_`{type} ( const array< `{type} > _head, const array< `{type} > _tail ) { \n\
		`GenConcatImpl( `{type} ); \n\
	} \n\
	\n\
	public static function bool AddIfNotPresent_`{type} ( array< `{type} > _arr, `{type} _elem ) { \n\
		`GenAddIfNotPresentImpl( `{type} ); \n\
	} \n\
	\n\
	public static function int IndexOf_`{type} ( array< `{type} > _arr, `{type} _elem ) { \n\
		`GenIndexOfImpl( `{type} ); \n\
	} \n\
	\n\
	public static function array< `{type} > Clone_`{type} ( array< `{type} > _arr ) { \n\
		`GenCloneImpl( `{type} ); \n\
	} \n\
	private static function bool AreEqual_`{type} ( `{type} _obj1, `{type} _obj2 ) {
		/*
	public function CreateArrayOf_Object( \n\
		optional `{type} _value0, optional `{type} _value1, optional `{type} _value2, optional `{type} _value3, optional `{type} _value4, \n\
		optional `{type} _value5, optional `{type} _value6, optional `{type} _value7, optional `{type} _value8, optional `{type} _value9 \n\
	) { \n\
		`GenCreateArrayOfImpl( `{type} , `{typeDefaultValue} );
	} \n\
	*/


//======================================================================================================================
// array<Object>

public static function bool Contains_Object( array<Object> _arr, Object _elem ) {
	`GenContainsImpl(Object);
}

public static function bool ContainsAny_Object( array<Object> _arr, array<Object> _elems ) {
	`GenContainsAnyImpl(Object);
}

public static function bool ContainsAll_Object( array<Object> _arr, array<Object> _elems ) {
	`GenContainsAllImpl(Object);
}

public static function bool ContainSameElements_Object( array<Object> _arr, array<Object> _arr2 ) {
	`GenContainSameElementsImpl(Object);
}

public static function array<Object> RemoveDuplicates_Object( array<Object> _arr ) {
	`GenRemoveDuplicatesImpl(Object);
}

public static function array<Object> Concat_Object( const array<Object> _head, const array<Object> _tail ) {
	`GenConcatImpl(Object);
}

public static function bool AddIfNotPresent_Object( array<Object> _arr, Object _elem ) {
	`GenAddIfNotPresentImpl(Object);
}

public static function int IndexOf_Object( array<Object> _arr, Object _elem ) {
	`GenIndexOfImpl(Object);
}

public static function array<Object> Clone_Object( array<Object> _arr ) {
	`GenCloneImpl(Object);
}
/*
public function CreateArrayOf_Object(
	optional string _value0, optional string _value1, optional string _value2, optional string _value3, optional string _value4,
	optional string _value5, optional string _value6, optional string _value7, optional string _value8, optional string _value9
) {
	`GenCreateArrayOfImpl( Object , "" );
}
*/

private static function bool AreEqual_Object( Object _obj1, Object _obj2 ) {
	return _obj1 == _obj2;
}

//======================================================================================================================

`Gen(String)
	return _obj1 == _obj2;
}

`Gen(X2BodyPartTemplate)
	return _obj1.ArchetypeName == _obj2.ArchetypeName;
}

`Gen(uc_BodyPartArchetype)
	return _obj1.Template.ArchetypeName == _obj2.Template.ArchetypeName;
}

`Gen(EGender)
	return _obj1 == _obj2;
}

`Gen(uc_EBodyPartType)
	return _obj1 == _obj2;
}

`Gen(uc_EArmorType)
	return _obj1 == _obj2;
}

`Gen(uc_ETechLevel)
	return _obj1 == _obj2;
}

`Gen(uc_EStyle)
	return _obj1 == _obj2;
}
