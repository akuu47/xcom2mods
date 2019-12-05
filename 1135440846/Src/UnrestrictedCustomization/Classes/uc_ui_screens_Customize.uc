///
/// List screen that let the player select PrevAppearance stuff within a list, and revert to previous one on cancel.
///
class uc_ui_screens_Customize extends UICustomize;

`define ClassName uc_ui_screens_Customize
`include( UnrestrictedCustomization\Src\UnrestrictedCustomization\macros.uci )

//======================================================================================================================
// SIGNALS

var privatewrite xmf_Signal OnSelectionChangedSignal;
var privatewrite xmf_Signal OnClosed;
var privatewrite xmf_Signal OnCanceled;
var privatewrite xmf_Signal OnConfirmed;

//======================================================================================================================
// FIELDS

var private TAppearance PrevAppearance;
var protected int SelectedIndex;

var protected xmf_ui_ListWrapper ListWrapper;

///
/// Navigation (root) node corresponding to this screen.
///
var privatewrite xmf_ui_NavigationNode NavigationNode;

///
/// Navigation node corresponding to this screen's main list.
///
var privatewrite xmf_ui_NavigationNode ListNavigationNode;

//======================================================================================================================
// CTOR

///
/// Instantiates this class.
///
public static function uc_ui_screens_Customize CreateCustomize() {
	return Customize( class'uc_ui_screens_Customize' );
}

protected static function uc_ui_screens_Customize Customize(
	class<uc_ui_screens_Customize> _class
) {
	local XComPresentationLayerBase _presBase;
	local uc_ui_screens_Customize this;
	_presBase = `PresBase;
	this = _presBase.Spawn( _class, _presBase );
	this.InitCustomize();
	return this;
}


private function InitCustomize() {
	OnSelectionChangedSignal = class'xmf_Signal'.static.CreateSignal();
	OnClosed = class'xmf_Signal'.static.CreateSignal();
	OnCanceled = class'xmf_Signal'.static.CreateSignal();
	OnConfirmed = class'xmf_Signal'.static.CreateSignal();
	PrevAppearance = class'uc_Customizer'.static.GetUnit().kAppearance;
	SelectedIndex = INDEX_NONE; // that way HandleSelectionChanged can be called no matter what
	
	// delay addition to display list, so child's ctor can be called before InitScreen
	SetTimer( EPSILON_ZERO, false, nameof(AddToDisplayList_Delayed), self );
}


private function AddToDisplayList_Delayed() {
	local XComPresentationLayerBase _presBase;
	_presBase = `PresBase;
	_presBase.ScreenStack.Push( self, _presBase.Get3DMovie() );
}


/*override*/ simulated function InitScreen( XComPlayerController _controller, UIMovie _movie, name _name='') {
	super.InitScreen(_controller, _movie, _name);

	ListWrapper = class'xmf_ui_ListWrapper'.static.CreateListWrapper(List);
	List.DisableNavigation();
	List.OnSelectionChanged = HandleSelectionChanged;
}

//======================================================================================================================
// METHODS


/*override*/ simulated function UpdateData() {
	super.UpdateData();
	List.ClearItems();
	AddListItems();
	UpdateNavigationTree();
}

///
/// override in childclass
///
protected function AddListItems() {
	`assert(false); //abstract
};


/*override*/ simulated function UpdateNavHelp() {
	// only show prev button
	NavHelp.ClearButtonHelp();
	NavHelp.AddBackButton(OnCancel);
	NavHelp.Show();
}

///
/// Creates/Updates the navigation tree.
///
protected function UpdateNavigationTree() {
	local UiPanel _uncastedItem;
	local xmf_ui_ListItem _item, _firstItem, _lastItem;

	if( NavigationNode == none ) {
		NavigationNode = class'xmf_ui_NavigationNode'.static.CreateNavigationNode(self);
	}
	else {
		NavigationNode.Stop();
	}

	if( ListNavigationNode == none ) {
		ListNavigationNode = class'xmf_ui_NavigationNode'.static.CreateNavigationNode(List);
		ListNavigationNode.Parent = NavigationNode;
	}

	_lastItem = none;
	foreach List.ItemContainer.ChildPanels(_uncastedItem) {
		_item = xmf_ui_ListItem(_uncastedItem);
		`assert( _item != none );
		_item.NavigationNode.Parent = ListNavigationNode;
		if( _firstItem == none ) _firstItem = _item;
		if( _lastItem != none ) {
			_lastItem.NavigationNode.BottomNode = _item.NavigationNode;
			_item.NavigationNode.TopNode = _lastItem.NavigationNode;
		}
		_lastItem = _item;
	}
	//_lastItem.NavigationNode.BottomNode = _firstItem.NavigationNode; //loop from bottom to top
	ListNavigationNode.LastFocusedChild = _firstItem.NavigationNode;
	NavigationNode.LastFocusedChild = ListNavigationNode;
	NavigationNode.Start();
}


/*override*/ simulated function CloseScreen() {	
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

	// screen-level interactions
	if( ! CheckInputIsReleaseOrDirectionRepeat(_cmd, _arg) ) return false;
	if( _arg == class'UIUtilities_Input'.const.FXS_ACTION_RELEASE ) {
		switch( _cmd ) {
			case class'UIUtilities_Input'.const.FXS_BUTTON_B:
			case class'UIUtilities_Input'.const.FXS_KEY_ESCAPE:
			case class'UIUtilities_Input'.const.FXS_R_MOUSE_DOWN:
				OnCancel();
				return true;
		}
	}

	//no call super : it only does vanilla navigation and soldier cycling
	return false;
}


/*override*/ simulated function OnCancel() {
	class'uc_Customizer'.static.SetBodyAppearance( PrevAppearance );
	OnCanceled.Dispatch(self);
	CloseScreen();
}


private function HandleSelectionChanged( UIList _list, int _itemIndex ) {
	if( _itemIndex < 0 ) return;
	if( _itemIndex == SelectedIndex ) return;
	SelectedIndex = _itemIndex;
	OnSelectionChangedSignal.Dispatch(self);
}

//======================================================================================================================
defaultProperties // '{' in separate line or defaultProperties will be ignored !
{
	//bConsumeMouseEvents = true;
	//MouseGuardClass = class'uc_ui_SimpleRotatorMouseGuard';
	bAnimateOnInit = false;
}
