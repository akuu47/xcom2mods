///
/// Class used to serialize data to string.
/// 
/// It is designed to be able to serialize data into a string that may also contain other stuff
/// eg: to store serialized customization states in biography.
///
class xmf_Serializer extends Object;

const StartingTag = "JSON_START";
const EndingTag = "JSON_END";
/*
///
/// Serializes given data into given string, replacing previously serialized data if any.
///
/// @param jsonObj - The data to serialize.
/// @param str - The string to prepend (eg: biography).
///
/// @return Serialized data $ given string
///
public static function string SerializeInto( JsonObject jsonObj, string str ) {
	return StripSerializedData(str) $ StartingTag $ class'JsonObject'.static.EncodeJson(jsonObj) $ EndingTag;
}
*/

public static function string Serialize( JsonObject jsonObj ) {
	return StartingTag $ class'JsonObject'.static.EncodeJson(jsonObj) $ EndingTag;
}

///
/// Returns deserialized data if given string contains any, none otherwise.
///
public static function JsonObject Deserialize( string str ) {
	local string jsonStr;
	local int startIndex, endIndex;
	if( ! ContainsSerializedData(str) ) return none;
	startIndex = InStr(str, StartingTag, false, false, 0) + Len(StartingTag);
	endIndex = InStr(str, EndingTag, false, false, startIndex);
	jsonStr = Mid( str, startIndex, endIndex-startIndex );
	return class'JsonObject'.static.DecodeJson(jsonStr);
}

///
/// Returns true if given string contains serialized data, false otherwise.
///
public static function bool ContainsSerializedData( string str ) {
	return InStr(str, StartingTag, false, false, 0) != INDEX_NONE;
}

///
/// Returns the given string, but without serialization data (if any).
/// (eg: to get biography alone)
///
public static function string StripSerializedData( string str ) {
	local int startIndex, endIndex;
	startIndex = InStr(str, StartingTag, false, false, 0);
	endIndex = InStr(str, EndingTag, false, false, startIndex) + Len(EndingTag);
	return Left(str, startIndex) $ Right(str, Len(str)-endIndex);
}
