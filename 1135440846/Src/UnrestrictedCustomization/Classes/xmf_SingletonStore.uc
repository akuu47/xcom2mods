///
/// Class to manage singleton classes.
/// Usefull since UnrealScript doesn't provide global nor static variables.
/// State is stored for the whole game session.
///
/// eg:
///
/// class Example extends UiDataStore;
///
/// public static function Example GetInstance() {
///		return Example( class'xmf_SingletonStore'.static.GetInstance(class'Example') );
/// }
///
/// defaultProperties // '{' in separate line or defaultProperties will be ignored !
/// {
/// 	Tag=MyMod
/// }
///
class xmf_SingletonStore extends UiDataStore;

///
/// Returns the singleton instance for given class.
///
public static function UiDataStore GetInstance( class<UiDataStore> _class ) {
	local UiDataStore instance;
	local DataStoreClient dataStoreManager;

	dataStoreManager = class'UIInteraction'.static.GetDataStoreClient();

	instance = dataStoreManager.FindDataStore( _class.default.Tag );
	
	if( instance == none ) {
		instance = dataStoreManager.CreateDataStore(_class);
		dataStoreManager.RegisterDataStore(instance);
	}

	return instance;
}
