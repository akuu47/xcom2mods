///
/// 
///
class uc_ui_screens_Randomize extends uc_ui_screens_AppearanceList;

`define ClassName uc_ui_screens_Randomize
`include( UnrestrictedCustomization\Src\UnrestrictedCustomization\macros.uci )

//======================================================================================================================
// FIELDS

var private uc_ui_BodyPartFilterPanel FilterPanel;

//======================================================================================================================
// CTOR

public static function uc_ui_screens_Randomize CreateRandomize() {
	return Randomize( class'uc_ui_screens_Randomize' );
}

protected static function uc_ui_screens_Randomize Randomize(
	class<uc_ui_screens_Randomize> _class
) {
	local uc_ui_screens_Randomize this;
	this = uc_ui_screens_Randomize( AppearanceList(_class) );
	this.InitRandomize();
	return this;
}

private function InitRandomize() {
	
}

/*override*/ simulated function InitScreen( XComPlayerController _controller, UIMovie _movie, name _name='') {
	super.InitScreen(_controller, _movie, _name);

	FilterPanel = class'uc_ui_BodyPartFilterPanel'.static.CreateBodyPartFilterPanel(self);
	FilterPanel.OnChanged.AddHandler( HandleFilterChanged );
	FilterPanel.SetPosition( 100, 110 );

	Header.SetAlpha(0);
}

//======================================================================================================================
// METHODS

/*override*/ protected function UpdateNavigationTree() {
	super.UpdateNavigationTree();
	FilterPanel.NavigationNode.Parent = NavigationNode;
	FilterPanel.NavigationNode.BottomNode = ListNavigationNode;
	ListNavigationNode.TopNode = FilterPanel.NavigationNode;
}


/*override*/ protected function AddListItems() {
	ListWrapper.CreateSimpleButton( `Localize("Options"), "", "", HandleOptionsClicked );
	ListWrapper.CreateSimpleButton( `Localize("RandomizeButtonLabel"), "", "", HandleRandomizeClicked );
	super.AddListItems();
}


/*override*/ protected function bool GetAppearance( int _index, out TAppearance _appearance, out string _label ) {
	local uc_AppearenceGenerator _generator;
	local uc_Config _config;
	_config = class'uc_Config'.static.GetInstance();

	if( _index > 15-FirstAppearanceIndex ) return false;

	_generator = class'uc_AppearenceGenerator'.static.CreateAppearenceGenerator();
	_generator.Filter = FilterPanel.CreateFilter();
	_generator.Filter.ArmorTypeTolerance = _config.ArmorTypeTolerance;
	_generator.Filter.TechLevelTolerance = _config.TechLevelTolerance;
	_generator.Filter.ArmorTypeDeltaMax = _config.ArmorTypeDeltaMax;
	_generator.Filter.TechLevelDeltaMax = _config.TechLevelDeltaMax;
	if( _config.UseCustomColorPalette ) {
		_generator.ColorPalette = _config.CustomColorPalette;
	}
	_generator.LimitRandomizationToOneDlc = _config.LimitRandomizationToOneDlc;
	_generator.Filter.ExcludeTruncatedArms = ! class'uc_Customizer'.static.IsTemplar() && ! class'uc_Customizer'.static.IsSkirmisher();
	_generator.Filter.ExcludeSparkLegs = ! class'uc_Customizer'.static.IsSpark();
	_generator.Filter.ExcludeSparkTorsos = _generator.Filter.ExcludeSparkLegs;
	
	_generator.RandomizeOutfit(_appearance);

	_label = `Localize("Randomized") @ string(_index);
	return true;
}

//======================================================================================================================
// HANDLERS

private function HandleFilterChanged( Object _source ) {
	UpdateData();
}

private function HandleOptionsClicked() {
	class'uc_ui_screens_RandomizeOptions'.static.CreateRandomizeOptions();
}

private function HandleRandomizeClicked() {
	UpdateData();
}
