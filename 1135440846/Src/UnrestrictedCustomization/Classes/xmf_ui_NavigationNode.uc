///
/// Unlike XCom2 vanilla UiNavigator, this class represent a node in a graph of navigation nodes,
/// each node corresponding to exactly one panel.
///
/// The inputs are passed using HandleUnrealCommand() on the root node,
/// then they propagate thought the graph and gives focus to the appropriate panel.
///
class xmf_ui_NavigationNode extends Object;

`define ClassName xmf_ui_NavigationNode
`include( UnrestrictedCustomization\Src\UnrestrictedCustomization\macros.uci )

//======================================================================================================================
// FIELDS

///
/// The panel corresponding to this node.
///
var UiPanel Panel;

///
/// Parent node (or none for root).
///
var xmf_ui_NavigationNode Parent;

///
/// Child node that received focus last (may be none).
///
var xmf_ui_NavigationNode LastFocusedChild;

///
/// Node at the top.
///
var xmf_ui_NavigationNode TopNode;

///
/// Node at the bottom.
///
var xmf_ui_NavigationNode BottomNode;

///
/// Node at the left.
///
var xmf_ui_NavigationNode LeftNode;

///
/// Node at the right.
///
var xmf_ui_NavigationNode RightNode;

//======================================================================================================================
// CTOR

///
/// Instantiates this class.
///
public static function xmf_ui_NavigationNode CreateNavigationNode(
	UiPanel _panel
) {
	return NavigationNode(class'xmf_ui_NavigationNode', _panel);
}

protected static function xmf_ui_NavigationNode NavigationNode(
	class<xmf_ui_NavigationNode> _class,
	UiPanel _panel
) {
	local xmf_ui_NavigationNode this;
	this = new _class;
	this.InitNavigationNode(_panel);
	return this;
}

private function InitNavigationNode(
	UiPanel _panel
) {
	`assert(_panel != none);
	Panel = _panel;
}

//======================================================================================================================
// METHODS



public function Start() {
	local xmf_ui_NavigationNode _node;
	`assert( IsRoot() );
	_node = GetLastFocusedLeaf();
	_node.Panel.OnReceiveFocus();
	_node.HandlePanelReceivedFocus();
}


public function Stop() {
	`assert( IsRoot() );
	GetLastFocusedLeaf().Panel.OnLoseFocus();
}

/*
public function Focus() {
	GetRoot().GetLastFocusedLeaf().Panel.OnLoseFocus();
	if( ! Panel.bIsFocused) Panel.OnReceiveFocus();
	HandlePanelReceivedFocus();
}
*/

///
/// Call it from UiPanel when it receives focus.
///
public function HandlePanelReceivedFocus() {
	local xmf_ui_NavigationNode _node;

	// remove focus on old focused
	_node = GetRoot().GetLastFocusedLeaf();
	if( _node != none && _node != self && _node.Panel.bIsFocused ) {
		_node.Panel.OnLoseFocus();
	}

	// update LastFocusedChild on parents
	_node = self;
	while( ! _node.IsRoot() ) {
		_node.Parent.LastFocusedChild = _node;
		_node = _node.Parent;
	}
	`assert( GetRoot().GetLastFocusedLeaf() == self );
}

///
///
///
public function bool HandleUnrealCommand( int _cmd, int _arg ) {
	local xmf_ui_NavigationNode _focusedNode;

	if( ! IsRoot() ) {
		`LogError("Should only be called on root navigator.");
		return false;
	}

	if( ! Panel.CheckInputIsReleaseOrDirectionRepeat(_cmd, _arg) ) return false;

	_focusedNode = GetLastFocusedLeaf();
	if( _focusedNode.HandleUnrealCommand_Inner(_cmd, _arg) ) {
		_focusedNode.Panel.OnLoseFocus();
		return true;
	}

	return false;
}

private function bool HandleUnrealCommand_Inner( int _cmd, int _arg ) {
	local xmf_ui_NavigationNode _target;
	local xmf_ui_NavigationNode _targetLeaf;

	_target = GetTarget(_cmd, _arg);
	if( _target != none ) {
		_targetLeaf = _target.GetLastFocusedLeaf();
		_targetLeaf.Panel.OnReceiveFocus();
		_targetLeaf.HandlePanelReceivedFocus();
		if( xmf_ui_ListItem(_targetLeaf.Panel) != none ) {
			xmf_ui_ListItem(_targetLeaf.Panel).EnsureVisible();
		}
		return true;
	}
	else if( ! IsRoot() ) {
		return Parent.HandleUnrealCommand_Inner(_cmd, _arg);
	}

	return false;
}

///
/// Returns true if this node is root node, false otherwise.
///
private function bool IsRoot() {
	return Parent == none;
}

///
/// Returns the root node.
///
private function xmf_ui_NavigationNode GetRoot() {
	local xmf_ui_NavigationNode _node;
	_node = self;
	while( ! _node.IsRoot() ) {
		_node = _node.Parent;
	}
	return _node;
}

///
/// Returns the child of this node that received focus the last.
///
public function xmf_ui_NavigationNode GetLastFocusedLeaf() {
	local xmf_ui_NavigationNode _focusedLeaf;
	_focusedLeaf = self;
	while( _focusedLeaf.LastFocusedChild != none ) {
		_focusedLeaf = _focusedLeaf.LastFocusedChild;
	}
	return _focusedLeaf;
}


private function xmf_ui_NavigationNode GetTarget( int _cmd, int _arg ) {
	switch( _cmd ) {
		case class'UIUtilities_Input'.const.FXS_ARROW_UP:
		case class'UIUtilities_Input'.const.FXS_DPAD_UP:
		case class'UIUtilities_Input'.const.FXS_VIRTUAL_LSTICK_UP:
			return TopNode;
		case class'UIUtilities_Input'.const.FXS_ARROW_DOWN:
		case class'UIUtilities_Input'.const.FXS_DPAD_DOWN:
		case class'UIUtilities_Input'.const.FXS_VIRTUAL_LSTICK_DOWN:
			return BottomNode;
		case class'UIUtilities_Input'.const.FXS_ARROW_LEFT:
		case class'UIUtilities_Input'.const.FXS_DPAD_LEFT:
		case class'UIUtilities_Input'.const.FXS_VIRTUAL_LSTICK_LEFT:
			return LeftNode;
		case class'UIUtilities_Input'.const.FXS_ARROW_RIGHT:
		case class'UIUtilities_Input'.const.FXS_DPAD_RIGHT:
		case class'UIUtilities_Input'.const.FXS_VIRTUAL_LSTICK_RIGHT:
			return RightNode;
	}
	return none;
}
