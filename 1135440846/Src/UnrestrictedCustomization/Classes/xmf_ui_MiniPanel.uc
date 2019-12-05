
class xmf_ui_MiniPanel extends UiPanel;

`define ClassName xmf_ui_MiniPanel
`include( UnrestrictedCustomization\Src\UnrestrictedCustomization\macros.uci )

//======================================================================================================================
// CONSTS

const Padding = 5;

//======================================================================================================================
// FIELDS

var privatewrite UIX2PanelHeader Header;
var privatewrite UIBGBox Background;
var privatewrite xmf_ui_NavigationNode NavigationNode;

//======================================================================================================================
// CTOR

///
/// Instantiates this class.
///
public static function xmf_ui_MiniPanel CreateMiniPanel(
	UiPanel _parent
) {
	return MiniPanel( class'xmf_ui_MiniPanel', _parent);
}


protected static function xmf_ui_MiniPanel MiniPanel(
	class<xmf_ui_MiniPanel> _class,
	UiPanel _parent
) {
	local xmf_ui_MiniPanel this;
	this = _parent.Spawn( _class, _parent );
	this.InitMiniPanel();
	return this;
}


private function InitMiniPanel() {
	super.InitPanel();

	NavigationNode = class'xmf_ui_NavigationNode'.static.CreateNavigationNode(self);

	Background = Spawn(class'UIBGBox', self);
	Background.InitBG();

	Header = Spawn(class'UIX2PanelHeader', self);
	Header.InitPanelHeader();
	Header.SetX( Padding );
}

//======================================================================================================================
// METHODS

/*override*/ public simulated function UiPanel SetSize(float _w, float _h) {
	//super.Resize(_w, _h);
	Width = _w;
	Height = _h;
	Background.SetSize(_w, _h);
	Header.SetHeaderWidth( _w - Padding ); // padding left only

	return self;
}

//======================================================================================================================
defaultProperties // '{' in separate line or defaultProperties will be ignored !
{
	bAnimateOnInit = false;
	bIsNavigable = false;
	bCascadeFocus = false;
}