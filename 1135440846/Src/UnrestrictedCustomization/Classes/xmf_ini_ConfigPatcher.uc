///
/// Class to manage patching of configured class and corresponding ini-file.
///
/// - Allows to overwrite as less as possible user's modifications.
/// - Allows to add a header on top of class config section.
///   (assuming that the config field for config revision is the first one declared within the class).
/// - Requires that you populate default value using UScript, 
///   bc if UEngine find the ini file in mod's folder, it will not read/write within user profile...
///
/// Known bugs : 
/// - CANTFIX: Header EOF character sequence is LF only (it's impossible to inject CR in there).
///   Windows users should be told to use a proper text editor in mod's readme.
///
class xmf_ini_ConfigPatcher extends Object;

`define ClassName xmf_ini_ConfigPatcher
`include( UnrestrictedCustomization\Src\UnrestrictedCustomization\macros.uci )

//======================================================================================================================
// FIELDS

var private array< delegate<Patch> > Patches;

var privatewrite xmf_ini_Configurable ConfigObject;

public delegate Patch();

//======================================================================================================================
// CTOR

///
/// Instantiates this class.
///
/// @param _configuredObject - The object holding config field to patch.
///
public static function xmf_ini_ConfigPatcher CreateConfigPatcher(
	xmf_ini_Configurable _configObject
) {
	return ConfigPatcher( class'xmf_ini_ConfigPatcher', _configObject );
}

///
/// Ctor.
///
protected static function xmf_ini_ConfigPatcher ConfigPatcher(
	class<xmf_ini_ConfigPatcher> _class,
	xmf_ini_Configurable _configObject
) {
	local xmf_ini_ConfigPatcher this;
	this = new _class;
	this.InitConfigPatcher( _configObject );
	return this;
}

///
/// Ctor's impl.
///
private function InitConfigPatcher(
	xmf_ini_Configurable _configObject
) {
	ConfigObject = _configObject;
}

//======================================================================================================================
// METHODS

///
/// Appends a patch, which should be added by accending revision order.
///
/// Onces a mod version is released, existing patches implementation should never change
/// (if you have to, be extra causious).
///
/// Try to modify as little as possible the configured object's config fields,
/// to overwrite user's modification only when it's absolutly necessary.
///
public function AppendPatch( delegate<Patch> _patch ) {
	Patches.AddItem( _patch );
}

///
/// Patches ConfiguredObject's config (only if needed, and accordingly to its current revision) then save&reload it.
///
/// Note that saving the config is a side effect (since UE doesn't provide method to load config only), 
/// if you only need to save the config state to the disk, use RequestSaveConfig() instead.
///
/// Note : Per-class config's header will be overwritten (replaced by xmf_ini_Configurable.GetHeader() result) if patching occurs
///        So if you just want to upate the header, you can create a new patch with an empty implementation ;
///        this will count as a new revision.
///
public function UpdateConfig() {
	local int _userRevision;
	local int _currentRevision;
	local int _i;
	local string _header;
	local delegate<Patch> _patch;

	_userRevision = int( ConfigObject.GetUserConfigRevision() );
	_currentRevision = Patches.Length;

	if( _userRevision == _currentRevision ) {
		`LogInfo( "Config file is up to date.");
	}
	
	if( _userRevision < 0 || _userRevision > _currentRevision ) {
		`LogInfo( "Invalid stored config revision, config file will be reset...");
		_userRevision = 0;
	}
	
	for( _i=_userRevision; _i<_currentRevision; _i++ ) {
		`LogInfo( "Patching config file from rev " $ _i $ " to rev " $ _i+1 $ " ..." );
		_patch = Patches[_i];
		_patch();
	}

	// inject header after revision's value since UE3 ini serializer allows to inject LFs and semicolons
	// unfortunaltly not CRs (sorry Microsoft Notepad's users ! )
	_header = ConfigObject.GetHeader();
	if( _header != "" ) {
		_header = "\n\n;" $ Repl(_header, "\n", "\n;") $ "\n";
	}
	ConfigObject.SetUserConfigRevision( string(_currentRevision) $ _header );
	
	`LogInfo( "Saving & reloading config file...");
	ConfigObject.SaveConfig();
}

///
/// Schedules SaveConfig call, use it instead of SaveConfig() directly to prevent uncesserssary back to back disk writings.
///
public function ScheduleSaveConfig() {
	//TODO implement using a single timer.
	ConfigObject.SaveConfig();
}