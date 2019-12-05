
class uc_ui_screens_EditArchetype extends UICustomize;

`define ClassName uc_ui_screens_EditArchetype
`include( UnrestrictedCustomization\Src\UnrestrictedCustomization\macros.uci )

//======================================================================================================================
// SIGNALS

var privatewrite xmf_Signal OnClosed;

//======================================================================================================================
// FIELDS

var private uc_BodyPartArchetype Archetype;

var private UIScrollingText DisplayNameScrollingText;
var private UICheckbox GenderMaleCheckbox;
var private UICheckbox GenderFemaleCheckbox;
var private UICheckbox ArmorLightCheckbox;
var private UICheckbox ArmorMediumCheckbox;
var private UICheckbox ArmorHeavyCheckbox;
var private UICheckbox ArmorSparkCheckbox;
var private UICheckbox TechPaddedCheckbox;
var private UICheckbox TechPlatedCheckbox;
var private UICheckbox TechPoweredCheckbox;
var private UICheckbox TechAlienCheckbox;
var private UICheckbox StyleCivilianCheckbox;
var private UICheckbox StyleXComCheckbox;
var private UICheckbox StyleAdventCheckbox;
var private UICheckbox StyleOtherCheckbox;
var private UICheckbox BlacklistedCheckbox;

//======================================================================================================================
// CTOR

///
/// Instantiates this class.
///
public static function uc_ui_screens_EditArchetype CreateEditArchetype(
	uc_BodyPartArchetype _archetype
) {
	return EditArchetype( class'uc_ui_screens_EditArchetype', _archetype );
}


protected static function uc_ui_screens_EditArchetype EditArchetype(
	class<uc_ui_screens_EditArchetype> _class,
	uc_BodyPartArchetype _archetype
) {
	local uc_ui_screens_EditArchetype this;
	this = `PresBase.Spawn( _class, `PresBase );
	this.InitEditArchetype(_archetype);
	return this;
}


private function InitEditArchetype(
	uc_BodyPartArchetype _archetype
) {
	local float _spacerHeight;
	local float _itemHeight;
	local float _y;

	_spacerHeight = 10;

	// this must be called first for whatever reason... Or the screen will end up in a stupid state...
	`PresBase.ScreenStack.Push( self, `PresBase.Get3DMovie() );

	// init fields
	Archetype = _archetype;
	OnClosed = new class'xmf_Signal';

	// Name
	DisplayNameScrollingText = GetListItem(List.ItemCount).UpdateDataButton(
		_archetype.Template.DisplayName, `Localize("Rename"), HandleRenameDisplayNameClicked
	).Desc;

	_itemHeight = DisplayNameScrollingText.Height + List.ItemPadding;
	_y = DisplayNameScrollingText.Y;

	// Genders
	_y += _spacerHeight;

	GenderMaleCheckbox = GetListItem(List.ItemCount).UpdateDataCheckbox(
		`Localize("Gender")$":"@`Localize("Male"), "", Archetype.HasGender(eGender_Male)
	).Checkbox;
	GetListItem(List.ItemCount-1).SetY(_y+=_itemHeight);

	GenderFemaleCheckbox = GetListItem(List.ItemCount).UpdateDataCheckbox(
		`Localize("Gender")$":"@`Localize("Female"), "", Archetype.HasGender(eGender_Female)
	).Checkbox;
	GetListItem(List.ItemCount-1).SetY(_y+=_itemHeight);

	// Armor types
	_y += _spacerHeight;

	ArmorLightCheckbox = GetListItem(List.ItemCount).UpdateDataCheckbox(
		`Localize("Armor")$":"@`Localize("Light"), "", Archetype.HasArmorType(uc_EArmorType_Light)
	).Checkbox;
	GetListItem(List.ItemCount-1).SetY(_y+=_itemHeight);

	ArmorMediumCheckbox = GetListItem(List.ItemCount).UpdateDataCheckbox(
		`Localize("Armor")$":"@`Localize("Medium"), "", Archetype.HasArmorType(uc_EArmorType_Medium)
	).Checkbox;
	GetListItem(List.ItemCount-1).SetY(_y+=_itemHeight);
	
	ArmorHeavyCheckbox = GetListItem(List.ItemCount).UpdateDataCheckbox(
		`Localize("Armor")$":"@`Localize("Heavy"), "", Archetype.HasArmorType(uc_EArmorType_Heavy)
	).Checkbox;
	GetListItem(List.ItemCount-1).SetY(_y+=_itemHeight);

	ArmorSparkCheckbox = GetListItem(List.ItemCount).UpdateDataCheckbox(
		`Localize("Armor")$":"@`Localize("Spark"), "", Archetype.HasArmorType(uc_EArmorType_Spark)
	).Checkbox;
	GetListItem(List.ItemCount-1).SetY(_y+=_itemHeight);

	// Tech levels
	_y += _spacerHeight;

	TechPaddedCheckbox = GetListItem(List.ItemCount).UpdateDataCheckbox(
		`Localize("Tech")$":"@`Localize("Padded"), "", Archetype.HasTechLevel(uc_ETechLevel_Padded)
	).Checkbox;
	GetListItem(List.ItemCount-1).SetY(_y+=_itemHeight);
	
	TechPlatedCheckbox = GetListItem(List.ItemCount).UpdateDataCheckbox(
		`Localize("Tech")$":"@`Localize("Plated"), "", Archetype.HasTechLevel(uc_ETechLevel_Plated)
	).Checkbox;
	GetListItem(List.ItemCount-1).SetY(_y+=_itemHeight);
	
	TechPoweredCheckbox = GetListItem(List.ItemCount).UpdateDataCheckbox(
		`Localize("Tech")$":"@`Localize("Powered"), "", Archetype.HasTechLevel(uc_ETechLevel_Powered)
	).Checkbox;
	GetListItem(List.ItemCount-1).SetY(_y+=_itemHeight);
	
	TechAlienCheckbox = GetListItem(List.ItemCount).UpdateDataCheckbox(
		`Localize("Tech")$":"@`Localize("Alien"), "", Archetype.HasTechLevel(uc_ETechLevel_Alien)
	).Checkbox;
	GetListItem(List.ItemCount-1).SetY(_y+=_itemHeight);

	// Character types
	_y += _spacerHeight;

	StyleCivilianCheckbox = GetListItem(List.ItemCount).UpdateDataCheckbox(
		`Localize("Style")$":"@`Localize("Civilian"), "", Archetype.HasStyle(uc_EStyle_Civilian)
	).Checkbox;
	GetListItem(List.ItemCount-1).SetY(_y+=_itemHeight);

	StyleXComCheckbox = GetListItem(List.ItemCount).UpdateDataCheckbox(
		`Localize("Style")$":"@`Localize("XCom"), "", Archetype.HasStyle(uc_EStyle_XCom)
	).Checkbox;
	GetListItem(List.ItemCount-1).SetY(_y+=_itemHeight);

	StyleAdventCheckbox = GetListItem(List.ItemCount).UpdateDataCheckbox(
		`Localize("Style")$":"@`Localize("Advent"), "", Archetype.HasStyle(uc_EStyle_Advent)
	).Checkbox;
	GetListItem(List.ItemCount-1).SetY(_y+=_itemHeight);
	
	StyleOtherCheckbox = GetListItem(List.ItemCount).UpdateDataCheckbox(
		`Localize("Style")$":"@`Localize("Other"), "", Archetype.HasStyle(uc_EStyle_Other)
	).Checkbox;
	GetListItem(List.ItemCount-1).SetY(_y+=_itemHeight);

	// Blacklisted
	_y += _spacerHeight;

	BlacklistedCheckbox = GetListItem(List.ItemCount).UpdateDataCheckbox(
		`Localize("Hide/Delete"), "", _archetype.IsBlacklisted()
	).Checkbox;
	GetListItem(List.ItemCount-1).SetY(_y+=_itemHeight);

	// move checkbox so it wont get covered by the scrollbar...
	GenderMaleCheckbox.SetX( GenderMaleCheckbox.X-30 );
	GenderFemaleCheckbox.SetX( GenderFemaleCheckbox.X-30 );
	ArmorLightCheckbox.SetX( ArmorLightCheckbox.X-30 );
	ArmorMediumCheckbox.SetX( ArmorMediumCheckbox.X-30 );
	ArmorHeavyCheckbox.SetX( ArmorHeavyCheckbox.X-30 );
	ArmorSparkCheckbox.SetX( ArmorSparkCheckbox.X-30 );
	TechPaddedCheckbox.SetX( TechPaddedCheckbox.X-30 );
	TechPlatedCheckbox.SetX( TechPlatedCheckbox.X-30 );
	TechPoweredCheckbox.SetX( TechPoweredCheckbox.X-30 );
	TechAlienCheckbox.SetX( TechAlienCheckbox.X-30 );
	StyleCivilianCheckbox.SetX( StyleCivilianCheckbox.X-30 );
	StyleXComCheckbox.SetX( StyleXComCheckbox.X-30 );
	StyleAdventCheckbox.SetX( StyleAdventCheckbox.X-30 );
	StyleOtherCheckbox.SetX( StyleOtherCheckbox.X-30 );
	BlacklistedCheckbox.SetX( BlacklistedCheckbox.X-30 );

	// space
	//GetListItem(List.ItemCount).Hide();

	// buttons
	//_y += _spacerHeight*2;
	//GetListItem(List.ItemCount).UpdateDataDescription( `Localize("Confirm"), HandleConfirmClicked );
	//GetListItem(List.ItemCount-1).SetY(_y+=_itemHeight);
}

//======================================================================================================================
// METHODS

private function ApplyChanges() {
	local array<EGender> _genders;
	local array<uc_EArmorType> _armorTypes;
	local array<uc_ETechLevel> _techLevels;
	local array<uc_EStyle> _charTypes;
	local uc_Config _config;

	if( GenderMaleCheckbox.bChecked ) _genders.AddItem(eGender_Male);
	if( GenderFemaleCheckbox.bChecked ) _genders.AddItem(eGender_Female);

	if( ArmorLightCheckbox.bChecked ) _armorTypes.AddItem(uc_EArmorType_Light);
	if( ArmorMediumCheckbox.bChecked ) _armorTypes.AddItem(uc_EArmorType_Medium);
	if( ArmorHeavyCheckbox.bChecked ) _armorTypes.AddItem(uc_EArmorType_Heavy);
	if( ArmorSparkCheckbox.bChecked ) _armorTypes.AddItem(uc_EArmorType_Spark);

	if( TechPaddedCheckbox.bChecked ) _techLevels.AddItem(uc_ETechLevel_Padded);
	if( TechPlatedCheckbox.bChecked ) _techLevels.AddItem(uc_ETechLevel_Plated);
	if( TechPoweredCheckbox.bChecked ) _techLevels.AddItem(uc_ETechLevel_Powered);
	if( TechAlienCheckbox.bChecked ) _techLevels.AddItem(uc_ETechLevel_Alien);

	if( StyleCivilianCheckbox.bChecked ) _charTypes.AddItem(uc_EStyle_Civilian);
	if( StyleXComCheckbox.bChecked ) _charTypes.AddItem(uc_EStyle_XCom);
	if( StyleAdventCheckbox.bChecked ) _charTypes.AddItem(uc_EStyle_Advent);
	if( StyleOtherCheckbox.bChecked ) _charTypes.AddItem(uc_EStyle_Other);
	
	if( Archetype.Update(DisplayNameScrollingText.htmlText, _genders, _armorTypes, _techLevels, _charTypes) ) {
		Archetype.Save();
	}

	if( BlacklistedCheckbox.bChecked != Archetype.IsBlacklisted() ) {
		_config = class'uc_Config'.static.GetInstance();
		if( BlacklistedCheckbox.bChecked ) {
			Archetype.SetBlacklist( uc_EBlacklist_User );
			_config.BlackListedArchetypeNames.AddItem( Archetype.Template.ArchetypeName );
		}else {
			Archetype.SetBlacklist( uc_EBlacklist_None );
			_config.BlackListedArchetypeNames.RemoveItem( Archetype.Template.ArchetypeName );	
		}
		_config.ScheduleSaveConfig();
	}
}

//======================================================================================================================
// HANDLERS

private function HandleRenameDisplayNameClicked( UIButton _btn ) {
	local TInputDialogData _data;

	_data.strTitle = DisplayNameScrollingText.htmlText;
	_data.strInputBoxText = DisplayNameScrollingText.htmlText;
	_data.iMaxChars = 100;
	_data.fnCallback = HandleDisplayNameRenamed;

	`PresBase.UIInputDialog(_data);
}
private function HandleDisplayNameRenamed( string _newName ) {
	DisplayNameScrollingText.SetHTMLText(_newName);
}



private function HandleCancelClicked() {
	CloseScreen();
}


private function HandleConfirmClicked() {
	ApplyChanges();
	CloseScreen();
}


/*override*/ simulated function CloseScreen() {	
	super.CloseScreen();
	ApplyChanges();
	OnClosed.Dispatch(self);
}
