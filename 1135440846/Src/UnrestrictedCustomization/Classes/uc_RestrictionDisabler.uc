///
/// Prevents vanilla code to mess customizations when equipping armors.
///
/// Note: since the culprit vanilla code is within a very important class (XComGameState_Unit),
/// it cannot be overrided.
///
class uc_RestrictionDisabler extends UiDataStore;

`define ClassName uc_RestrictionDisabler
`include( UnrestrictedCustomization\Src\UnrestrictedCustomization\macros.uci )

//======================================================================================================================
// FIELDS

var private bool Inited;

/// Stores previously assigned callbacks
var private xmf_HashMap EquippedCallbacksByTemplates;

var private array<X2BodyPartTemplate> TemplateQueue;
var private array<name> ArmorNameQueue;

//======================================================================================================================
// CTOR

public static function uc_RestrictionDisabler GetInstance() {
	return uc_RestrictionDisabler( class'xmf_SingletonStore'.static.GetInstance(class'uc_RestrictionDisabler') ).Init();
}

private function uc_RestrictionDisabler Init() {
	if( ! Inited ) {
		EquippedCallbacksByTemplates = class'xmf_HashMap'.static.CreateHashMap();
	}
	Inited = true;
	return self;
}

//======================================================================================================================
// METHODS

///
/// Prevents character pool to modify torso (and other parts ?) to a kevlar version...
///
public function UnrestrictBodyParts() {
	local array<X2EquipmentTemplate> _templates;
	local X2EquipmentTemplate _template;

	_templates = class'X2ItemTemplateManager'.static.GetItemTemplateManager().GetAllArmorTemplates();
	foreach _templates(_template) {
		if( _template.DataName == 'SparkArmor' ) continue;
		if( _template.DataName == 'PlatedSparkArmor' ) continue;
		if( _template.DataName == 'PoweredSparkArmor' ) continue;
		if( _template.OnEquippedFn != none ) {
			EquippedCallbacksByTemplates.Set(
				_template.Name,
				class'uc_ItemEquippedCallback'.static.CreateItemEquippedCallback( _template.OnEquippedFn )
			);
		}
		_template.OnEquippedFn = OnArmorEquipped;
	}
}

///
/// Prevents XComGameState_Unit.AddItemToInventory from changing given unit's appearance.
///
private function LockAppearance( XComGameState_Unit _unit ) {
	local X2BodyPartTemplateManager _mgr;
	local X2BodyPartTemplate _torsoTemplate;

	_mgr = class'X2BodyPartTemplateManager'.static.GetBodyPartTemplateManager();
	_torsoTemplate = _mgr.FindUberTemplate("Torso", _unit.kAppearance.nmTorso);

	`logvar(_unit.kAppearance.nmTorso);
	`logvar(_torsoTemplate);


	if( _torsoTemplate == none ) {
		return;
	}

	TemplateQueue.AddItem(_torsoTemplate);
	ArmorNameQueue.AddItem(_torsoTemplate.ArmorTemplate);
	`LogInfo("Replacing armor template to none for template " $ _torsoTemplate.DataName );
	_torsoTemplate.ArmorTemplate = '';

	`PresBase.SetTimer( 0.01, false, nameof(RevertArmorTemplates), self );
}

///
///
///
private function RevertArmorTemplates() {
	local int i;
	local X2BodyPartTemplate _template;
	local name _armorName;

	`assert( TemplateQueue.Length == ArmorNameQueue.Length );

	foreach TemplateQueue(_template, i) {
		`LogInfo("Reverting armor template to what it was for template " $ _template.DataName );
		_armorName = ArmorNameQueue[i];
		_template.ArmorTemplate = _armorName;
	}
	TemplateQueue.Length = 0;
	ArmorNameQueue.Length = 0;
}

///
///
///
private function OnArmorEquipped( XComGameState_Item _item, XComGameState_Unit _unit, XComGameState _newState ) {
	local name _armorName;
	local int _gender;
	local bool _withinCharPool;
	local uc_ItemEquippedCallback _replacedCallback;
	local uc_Config _config;
	local TAppearance _newAppearance;
	
	_config = class'uc_Config'.static.GetInstance();
	_withinCharPool = class'uc_CharacterPoolUtil'.static.IsOpen();
	_gender = _unit.kAppearance.iGender;
	_armorName = _item.GetMyTemplateName();
	_replacedCallback = uc_ItemEquippedCallback( EquippedCallbacksByTemplates.Get(_armorName) );
	
	// call previous callback
	if( _replacedCallback != none ) {
		_replacedCallback.OnEquippedFn( _item, _unit, _newState);
	}
	
	if( !_withinCharPool && !_config.GlobalAppearance ) {
		if( HasStoredAppearance(_unit, _gender, _armorName)  ) {
			// load previous appearance for this armor
			_unit.GetStoredAppearance( _newAppearance, _gender, _armorName );
			class'uc_Customizer'.static.SetBodyAppearance(_newAppearance, _unit);
		}else {
			//armor equipped for the first time
		}
	}

	LockAppearance(_unit);
}

///
/// Returns true if given unit has stored appearance for given gender and armor.
/// Use this instead of XComGameState_Unit.HasStoredAppearance which returns true for empty appearances...
///
private static function bool HasStoredAppearance( XComGameState_Unit _unit, int _gender, name _armorName ) {
	local TAppearance _appearance;
	if( ! _unit.HasStoredAppearance(_gender, _armorName) ) return false;
	_unit.GetStoredAppearance( _appearance, _gender, _armorName );
	return ! IsAppearanceEmpty(_appearance);
}

///
///
///
private static function bool IsAppearanceEmpty( TAppearance _appearance ) {
	return _appearance.nmTorso == '';
}

//======================================================================================================================
defaultProperties // '{' in separate line or defaultProperties will be ignored !
{
	Tag = UnrestrictedCustomization_uc_CharacterPoolUtil
}
