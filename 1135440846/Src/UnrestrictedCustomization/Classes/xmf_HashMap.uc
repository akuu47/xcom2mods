
class xmf_HashMap extends Object;

`define ClassName xmf_HashMap
`include( UnrestrictedCustomization\Src\UnrestrictedCustomization\macros.uci )

//======================================================================================================================
// FIELDS

var private JsonObject Null; // used to differentiate between uninitialized/initialized none values.
var private JsonObject Map;
var private array<string> Keys;
var private array<Object> Values;
var private bool IsValuesUpToDate;

//======================================================================================================================
// CTOR

///
/// Instantiates this class.
///
public static function xmf_HashMap CreateHashMap() {
	return HashMap(class'xmf_HashMap');
}

protected static function xmf_HashMap HashMap( class<xmf_HashMap> _class ) {
	local xmf_HashMap this;
	this = new _class;
	this.InitHashMap();
	return this;
}

private function InitHashMap() {
	Null = new class'JsonObject';
	Map = new class'JsonObject';
}

//======================================================================================================================
// METHODS


public function array<string> GetKeys() {
	return Keys;
}


public function array<Object> GetValues() {
	local Object _value;
	local string _key;

	if( ! IsValuesUpToDate ) {
		foreach Keys(_key) {
			_value = Get(_key);
			if( _value != none ) {
				Values.AddItem(_value);
			}
		}
		IsValuesUpToDate = true;
	}

	return Values;
}


public function Object Get( coerce string _key ) {
	local JsonObject _value;

	_value = Map.GetObject(_key);
	if( _value == Null ) _value = none;
	return _value;
}


public function Set( coerce string _key, JsonObject _value ) {
	if( _value == none ) {
		_value = Null;
	}
	if( Map.GetObject(_key) == none ) {
		Keys.AddItem( _key);
	}
	else {
		IsValuesUpToDate = false;
		Values.Length = 0;
	}
	
	Map.SetObject( _key, _value );
}

//======================================================================================================================
// TESTS

public static function TEST() {
	TEST_GetKeys_contains_key_corresponding_to_null_values();
	TEST_GetValues_does_not_contain_none_values();
	TEST_GetValues_may_contain_duplicates();
	TEST_Get_returns_proper_value_when_non_null();
	TEST_Get_returns_proper_value_when_null();
	TEST_Get_returns_proper_value_when_set_multiple_times();
}


private static function TEST_GetKeys_contains_key_corresponding_to_null_values() {
	local xmf_HashMap _map;
	_map = class'xmf_HashMap'.static.CreateHashMap();

	_map.Set( "test", none );
	_map.Set( "test2", none );

	`Assert( _map.GetKeys().Length == 2 );
}


private static function TEST_GetValues_does_not_contain_none_values() {
	local xmf_HashMap _map;
	local array<Object> _values;
	_map = class'xmf_HashMap'.static.CreateHashMap();

	_map.Set( "test", none );
	_map.Set( "test2", none );

	_values = _map.GetValues();

	`Assert( _values.Length == 0 );
}


private static function TEST_GetValues_may_contain_duplicates() {
	local JsonObject _obj;
	local array<Object> _values;
	local xmf_HashMap _map;
	_map = class'xmf_HashMap'.static.CreateHashMap();

	_obj = new class'JsonObject';
	_map.Set( "test", _obj );
	_map.Set( "test2", _obj );

	_values = _map.GetValues();
	`Assert( _values.Length == 2 );
}


private static function TEST_Get_returns_proper_value_when_non_null() {
	local Object _actual;
	local JsonObject _obj;
	local xmf_HashMap _map;
	_map = class'xmf_HashMap'.static.CreateHashMap();

	_obj = new class'JsonObject';
	_map.Set( "test", _obj );

	_actual = _map.Get("test");
	`Assert( _actual == _obj );
}


private static function TEST_Get_returns_proper_value_when_null() {
	local Object _actual;
	local JsonObject _obj;
	local xmf_HashMap _map;
	_map = class'xmf_HashMap'.static.CreateHashMap();

	_obj = none;
	_map.Set( "test", _obj );

	_actual = _map.Get("test");
	`Assert( _actual == _obj );
}


private static function TEST_Get_returns_proper_value_when_set_multiple_times() {
	local Object _actual;
	local JsonObject _obj;
	local JsonObject _obj2;
	local xmf_HashMap _map;
	_map = class'xmf_HashMap'.static.CreateHashMap();

	_obj = new class'JsonObject';
	_obj2 = new class'JsonObject';
	_map.Set( "test", _obj );
	_map.Set( "test", _obj2 );

	_actual = _map.Get("test");
	`Assert( _actual == _obj2 );
}