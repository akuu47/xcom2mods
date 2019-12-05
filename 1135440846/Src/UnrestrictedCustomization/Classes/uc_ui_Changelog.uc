///
/// 
///
class uc_ui_Changelog extends UIScreenListener;

`define ClassName uc_ui_Changelog
`include( UnrestrictedCustomization\Src\UnrestrictedCustomization\macros.uci )

//======================================================================================================================
// FIELDS


//======================================================================================================================
// HANDLERS

event OnInit(UIScreen _screen) {
	local TDialogueBoxData _dialogData;

	if( UIFinalShell(_screen)==none ) return;
	
	if( class'uc_Config'.static.GetInstance().LastLaunchVersion == `ModVersion ) return;
	class'uc_Config'.static.GetInstance().SetLastLaunchVersion( `ModVersion );

	if( Len( `ChangeLog ) == 0 ) return;

	_dialogData.eType = eDialog_Normal;
	_dialogData.isModal = true;
	_dialogData.strTitle = `ModPackage @ `ModVersion;
	_dialogData.strAccept = class'UIDialogueBox'.default.m_strDefaultAcceptLabel;
	_dialogData.strText = Repl( `ChangeLog, "§", "\n");
	_screen.Movie.Pres.UIRaiseDialog( _dialogData );
}

//======================================================================================================================
defaultProperties // '{' in separate line or defaultProperties will be ignored !
{
	ScreenClass=none
}
