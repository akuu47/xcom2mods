///
/// List menu containing body part elements.
///
class uc_ui_screens_BodyPartList extends uc_ui_screens_Customize;

`define ClassName uc_ui_screens_BodyPartList
`include( UnrestrictedCustomization\Src\UnrestrictedCustomization\macros.uci )

//======================================================================================================================
// FIELDS

var private uc_EBodyPartType PartType;
var private array<uc_BodyPartArchetype> Archetypes;

var private uc_ui_BodyPartFilterPanel FilterPanel;

//======================================================================================================================
// PROPERTIES

public function uc_BodyPartArchetype GetSelection() {
	return SelectedIndex >= 0 ? Archetypes[SelectedIndex] : none;
}

//======================================================================================================================
// CTOR

///
/// Instantiates this class.
///
public static function uc_ui_screens_BodyPartList CreateBodyPartList(
	uc_EBodyPartType _partType
) {
	return BodyPartList( class'uc_ui_screens_BodyPartList', _partType );
}

protected static function uc_ui_screens_BodyPartList BodyPartList(
	class<uc_ui_screens_BodyPartList> _class,
	uc_EBodyPartType _partType
) {
	local uc_ui_screens_BodyPartList this;
	this = uc_ui_screens_BodyPartList( Customize(_class) );
	this.InitBodyPartList(_partType);
	return this;
}

private function InitBodyPartList( uc_EBodyPartType _partType ) {
	PartType = _partType;
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


/*override*/ protected function AddListItems() {
	local string _label, _buttonLabel;
	local xmf_ui_ListWrapper _list;
	local xmf_ui_ListItem _item;
	local uc_BodyPartArchetype _archetype;
	local bool _showBothGenders;

	UpdateArchetypes();

	_list = class'xmf_ui_ListWrapper'.static.CreateListWrapper(List);
	_showBothGenders = FilterPanel.GenderMaleCb.bChecked == FilterPanel.GenderFemaleCb.bChecked;

	foreach Archetypes( _archetype) {
		_label = _archetype.GetLabel(_showBothGenders);
		if( IsEditable(_archetype) ) {
			_buttonLabel = "";
			if( _archetype.IsBogus() ) {
				_buttonLabel = class'UIUtilities_Text'.static.InjectImage(class'UIUtilities_Image'.const.HTML_AttentionIcon, 26, 26, -4);
			}
			_buttonLabel @= `Localize("Edit");
			_item = _list.CreateDoubleButton( _label, _buttonLabel, "", HandlePartClicked, HandleEditPartClicked );
		}
		else if( PartType == uc_EBodyPartType_Voice ) {
			_item = _list.CreateDoubleButton( _label, `Localize("Preview"), "", HandlePartClicked, HandlePreviewClicked);
		}
		else {
			_item = _list.CreateSimpleButton( _label, "", "", HandlePartClicked );
		}
		_item.SetWidth( List.Width );	
	}
}


private function UpdateArchetypes() {
	local uc_Config _config;
	local uc_BodyPartFilter _filter;

	_config = class'uc_Config'.static.GetInstance();

	_filter = FilterPanel.CreateFilter();
	_filter.PartTypes.AddItem( PartType );
	_filter.SetBlacklistedOnly( _config.ShowBlacklistedOnly );
	_filter.ExcludeTruncatedArms = ! class'uc_Customizer'.static.IsTemplar() && ! class'uc_Customizer'.static.IsSkirmisher();
	_filter.ExcludeSparkLegs = ! class'uc_Customizer'.static.IsSpark();
	_filter.ExcludeSparkTorsos = _filter.ExcludeSparkLegs;

	Archetypes = _filter.GetAchetypes();

	if( PartType != uc_EBodyPartType_Voice ) PrependInvisiblePart();
}


private function PrependInvisiblePart() {
	local X2BodyPartTemplate _invisibleVanillaTemplate;
	local uc_BodyPartArchetype _invisibleArchetype;

	//TODO retreive existing archetypes instead of creating new ones
	_invisibleVanillaTemplate = class'uc_BodyPartUtil'.static.GetInvisibleTemplate(PartType);
	_invisibleArchetype = class'uc_BodyPartArchetype'.static.CreateBodyPartArchetype( _invisibleVanillaTemplate.ArchetypeName );
	_invisibleArchetype.SetTemplate(_invisibleVanillaTemplate);
	Archetypes.InsertItem( 0, _invisibleArchetype  );
}


/*override*/ protected function UpdateNavigationTree() {
	super.UpdateNavigationTree();
	FilterPanel.NavigationNode.Parent = NavigationNode;
	FilterPanel.NavigationNode.BottomNode = ListNavigationNode;
	ListNavigationNode.TopNode = FilterPanel.NavigationNode;
}


private function bool IsEditable( uc_BodyPartArchetype _archetype ) {
	return PartType != uc_EBodyPartType_Voice && _archetype != Archetypes[0];
}

//======================================================================================================================
// HANDLERS


private function HandlePartClicked() {
	OnConfirmed.Dispatch(self);
	CloseScreen();
}


private function HandleEditPartClicked( UIButton _source ) {
	local uc_ui_screens_EditArchetype _screen;
	local uc_BodyPartArchetype _archetype;

	_archetype = GetSelection();

	_screen = class'uc_ui_screens_EditArchetype'.static.CreateEditArchetype(_archetype);
	_screen.OnClosed.AddHandler( HandleEditArchetypeScreenClosed );
}
private function HandleEditArchetypeScreenClosed( Object _source ) {
	UpdateData();
}


private function HandlePreviewClicked( UIButton _source ) {
	class'uc_VoicePlayer'.static.GetInstance().PlayRandomSoundPreview( GetSelection().GetArchetypeName() );
}


private function HandleFilterChanged( Object _source ) {
	`LogInfo( "Body part filter changed" );
	UpdateData();
}

//======================================================================================================================
defaultProperties // '{' in separate line or defaultProperties will be ignored !
{
	
}