///
/// 
///
class xmf_ui_Util extends Object;

`define ClassName xmf_ui_Util
`include( UnrestrictedCustomization\Src\UnrestrictedCustomization\macros.uci )

//======================================================================================================================
// MOUSE

///
/// Returns the position of the mouse within given panel's coods system.
///
public static function float GetMouseX( UiPanel _panel ) {
	return GetFlashNumber(_panel, "_xmouse");
}

///
/// Returns the position of the mouse within given panel's coods system.
///
public static function float GetMouseY( UiPanel _panel ) {
	return GetFlashNumber(_panel, "_ymouse");
}

///
/// Returns true if given panel is *directly* under mouse cursor.
///
public static function bool IsUnderMouse( UiPanel _panel ) {
	//TODO ensure it works
	local float _mx, _my;
	_mx = GetMouseX(_panel);
	_my = GetMouseY(_panel);
	if( _mx < 0 ) return false;
	if( _my < 0 ) return false;
	if( _mx > _panel.Width ) return false;
	if( _my > _panel.Height ) return false;
	return true;
}

//======================================================================================================================
// WIDTH/HEIGHT

///
/// Returns the width (in pixels) of given panel, with its children (scale isn't applied).
///
public static function float ComputePanelWidth( UiPanel _panel ) {
	local UiPanel _child;
	local float _width;
	local float _maxWidth;

	_maxWidth = _panel.Width;
	foreach _panel.ChildPanels(_child) {
		_width = _child.X + ComputePanelWidth(_child);
		if( _width > _maxWidth ) {
			_maxWidth = _width;
		}
	}

	return _maxWidth;
}

///
/// Returns the height (in pixels) of given panel, with its children (scale isn't applied).
///
public static function float ComputePanelHeight( UiPanel _panel ) {
	local UiPanel _child;
	local float _height;
	local float _maxHeight;

	_maxHeight = _panel.Height;
	foreach _panel.ChildPanels(_child) {
		_height = _child.Y + ComputePanelHeight(_child);
		if( _height > _maxHeight ) {
			_maxHeight = _height;
		}
	}

	return _maxHeight;
}

//======================================================================================================================
// TOOLTIP

///
/// 
///
public static function SetTooltip( UIPanel _panel, string _text, float _maxWidth=500, float _maxHeight=500 ) {
	if( _panel.bHasTooltip ) {
		_panel.RemoveTooltip();
	}

	_panel.ProcessMouseEvents();
	//_panel.bProcessesMouseEvents = true;
	
	if( _text != "" ) {
		_panel.CachedTooltipId = _panel.Movie.Pres.m_kTooltipMgr.AddNewTooltipTextBox(
			_text,
			100,
			100,
			string(_panel.MCPath),
			"",
			class'UITextTooltip'.default.bRelativeLocation,
			class'UITextTooltip'.default.Anchor,
			class'UITextTooltip'.default.bFollowMouse,
			_maxWidth, // class'UITextTooltip'.default.maxW,
			_maxHeight, // class'UITextTooltip'.default.maxH,
			class'UITextTooltip'.default.eTTBehavior,
			class'UITextTooltip'.default.eTTColor,
			class'UITextTooltip'.default.tDisplayTime,
			0.0f, //class'UITextTooltip'.default.tDelay
			class'UITextTooltip'.default.tAnimateIn,
			class'UITextTooltip'.default.tAnimateOut
		);

		_panel.bHasTooltip = true;
	}
}

//======================================================================================================================
// FLASH

public static function bool GetFlashBool( UiPanel _panel, string _fieldName ) {
	return _panel.Movie.GetVariableBool( _panel.McPath$"."$_fieldName );
}


public static function float GetFlashNumber( UiPanel _panel, string _fieldName ) {
	return _panel.Movie.GetVariableNumber( _panel.McPath$"."$_fieldName );
}


public static function string GetFlashString( UiPanel _panel, string _fieldName ) {
	return _panel.Movie.GetVariableString( _panel.McPath$"."$_fieldName );
}


public static function SetFlashBool( UiPanel _panel, string _fieldName, bool _value  ) {
	_panel.Movie.SetVariableBool( _panel.McPath$"."$_fieldName, _value );
}


public static function SetFlashNumber( UiPanel _panel, string _fieldName, float _value  ) {
	_panel.Movie.SetVariableNumber( _panel.McPath$"."$_fieldName, _value );
}


public static function SetFlashString( UiPanel _panel, string _fieldName, string _value  ) {
	_panel.Movie.SetVariableString( _panel.McPath$"."$_fieldName, _value );
}


public static function ASValue FlashCallMethod( UiPanel _panel, string _funcName, array<ASValue> _args ) {
	return _panel.Movie.Invoke( _panel.McPath$"."$_funcName, _args );
}