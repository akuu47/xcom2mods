///
/// 
///
class xmf_ui_Screen extends UiScreen;

`define ClassName xmf_ui_Screen
`include( UnrestrictedCustomization\Src\UnrestrictedCustomization\macros.uci )

//======================================================================================================================
// SIGNALS

var privatewrite xmf_Signal OnClosed;

//======================================================================================================================
// FIELDS

///
/// 
///
var protectedwrite xmf_ui_NavigationNode NavigationNode;


var private UINavigationHelp NavHelp;


//======================================================================================================================
// CTOR

///
/// Instantiates this class.
///
public static function xmf_ui_Screen CreateScreen() {
	return Screen( class'xmf_ui_Screen' );
}

protected static function xmf_ui_Screen Screen(
	class<xmf_ui_Screen> _class
) {
	local xmf_ui_Screen this;
	this = `PresBase.Spawn( _class, `PresBase );
	this.InitScreen2();
	return this;
}

private function InitScreen2() {
	OnClosed = class'xmf_Signal'.static.CreateSignal();
	NavigationNode = class'xmf_ui_NavigationNode'.static.CreateNavigationNode(self);

	// ensure InitScreen() is called AFTER construction complete.
	SetTimer( EPSILON_ZERO, false, nameof(AddToStack_Delayed), self );
}

private function AddToStack_Delayed() {
	`PresBase.ScreenStack.Push( self, `PresBase.Get3DMovie() );
}

///
/// Called once the screen is addded in display list.
/// Stuff requiring a proper display list (eg: adding child, resizing, etc.) should be done here instead of ctor.
/// NB: do not initialize all here tho, for example events etc. should be created within ctor.
///
/*override*/ simulated function InitScreen( XComPlayerController _controller, UIMovie _movie, name _name='') {
	local bool _inArmory;

	super.InitScreen(_controller, _movie, _name);

	_inArmory = Movie.Stack.GetLastInstanceOf(class'UIArmory') != none;
	NavHelp = _inArmory ? `HQPRES.m_kAvengerHUD.NavHelp : _controller.Pres.GetNavHelp();
	NavHelp.AddBackButton( CloseScreen );
	NavHelp.Show();
}

//======================================================================================================================
// METHODS

/*override*/ public simulated function CloseScreen() {
	NavHelp.ClearButtonHelp();
	super.CloseScreen();
	OnClosed.Dispatch(self);
}

//======================================================================================================================
// HANDLERS


/*override*/ simulated function bool OnUnrealCommand( int _cmd, int _arg ) {
	local xmf_ui_NavigationNode _focusedNode;

	// handle navigation inputs
	if( NavigationNode.HandleUnrealCommand(_cmd, _arg) ) {
		return true;
	}

	// send input to currently focused panel
	_focusedNode = NavigationNode.GetLastFocusedLeaf();
	if( _focusedNode != none ) {
		if( _focusedNode.Panel.OnUnrealCommand(_cmd, _arg) ) {
			return true;
		}
	}

	if( _arg == class'UIUtilities_Input'.const.FXS_ACTION_RELEASE ) {
		switch( _cmd ) {
			case class'UIUtilities_Input'.const.FXS_BUTTON_B:
			case class'UIUtilities_Input'.const.FXS_KEY_ESCAPE:
			case class'UIUtilities_Input'.const.FXS_R_MOUSE_DOWN:
				CloseScreen();
				return true;
		}
	}

	//no need to call super : it only does vanilla navigation...
	return false;
}

//======================================================================================================================
defaultProperties // '{' in separate line or defaultProperties will be ignored !
{
	bAnimateOnInit = false;
}