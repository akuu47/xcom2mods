///
/// Interface for configurable classes.
///
/// NB : do not create a base class for this interface : revision variable needs to be the first field
/// in the final class (inherited fields are serialized last...) in order to print header at the top of the file
/// instead of at the bottom.
///
/// Example :
///
/// class XXX extends YYY
/// config(ZZZ) implements(xmf_ini_Configurable); var private config string ConfigRevision_DoNotModify;
///
/// var config int FieldA;
/// var config int FieldB;
///
/// //...
///
/// function string GetUserConfigRevision() { return ConfigRevision_DoNotModify; }
/// function SetUserConfigRevision( string _value ) { ConfigRevision_DoNotModify = _value; }
/// function string GetHeader() { return "FieldA: stuff \nFieldB: other suff"; }
/// 
/// function Init() {
/// 	local xmf_ini_ConfigPatcher _patcher;
/// 	_patcher = class'xmf_ini_ConfigPatcher'.static.CreateConfigPatcher(self);
/// 	_patcher.AppendPatch( PatchRev0ToRev1 );
/// 	_patcher.AppendPatch( PatchRev1ToRev2 );
/// 	_patcher.UpdateConfig();
/// }
/// 
/// private function PatchRev0ToRev1() {
/// 	FieldA = 10; // Added fieldA in rev 1
/// }
/// 
/// private function PatchRev1ToRev2() {
/// 	FieldA = 20; // Changed default value on FieldA in rev 2
/// 	FieldB = 30; // Added fieldB in rev 2
/// }
///
interface xmf_ini_Configurable;

///
/// Returns the section's header (ie: [Package.Class] is a section).
///
function string GetHeader();

///
/// Returns the user config's revision.
///
function string GetUserConfigRevision();

///
/// Sets the user config's revision.
///
function SetUserConfigRevision( string _value );

///
/// Schedules SaveConfig call, use it instead of SaveConfig() directly to prevent uncesserssary back to back disk writings.
///
function ScheduleSaveConfig();