class uc_Customizer extends Object;

`define ClassName uc_Customizer
`include( UnrestrictedCustomization\Src\UnrestrictedCustomization\macros.uci )

//======================================================================================================================
// PROPERTIES

public static function XComHumanPawn GetPawn() {
	return XComHumanPawn( GetVanillaCustomizer().ActorPawn );
}

///
/// Returns given unit if not null, or the currently customized unit overwise.
///
public static function XComGameState_Unit GetUnit( optional XComGameState_Unit _unit ) {
	_unit = _unit != none ? _unit : GetVanillaCustomizer().UpdatedUnitState;
	`assert( _unit != none );
	return _unit;
}

private static function XComCharacterCustomization GetVanillaCustomizer() {
	return `PresBase.m_kCustomizeManager;
}

//======================================================================================================================
// METHODS

public static function bool IsSpark( optional XComGameState_Unit _unit ) {
	switch( GetUnit(_unit).GetMyTemplateName() ) {
		case 'SparkSoldier':
		case 'XComMecSoldier': // Mec Troopers mod
		case 'SkirmXComMecSoldier': // Mec Troopers mod
			return true;
	} 
	return false;
}


public static function bool IsReaper( optional XComGameState_Unit _unit ) {
	return GetUnit(_unit).GetMyTemplateName() == 'ReaperSoldier';
}


public static function bool IsTemplar( optional XComGameState_Unit _unit ) {
	return GetUnit(_unit).GetMyTemplateName() == 'TemplarSoldier';
}


public static function bool IsSkirmisher( optional XComGameState_Unit _unit ) {
	return GetUnit(_unit).GetMyTemplateName() == 'SkirmisherSoldier';
}

///
///
///
public static function EGender GetGender( optional XComGameState_Unit _unit ) {
	return EGender( GetUnit(_unit).kAppearance.iGender );
}

///
///
///
public static function ECharacterRace GetRace( optional XComGameState_Unit _unit ) {
	return ECharacterRace( GetUnit(_unit).kAppearance.iRace );
}

///
///
///
public static function X2BodyPartTemplate GetBodyPart( uc_EBodyPartType _partType, optional XComGameState_Unit _unit ) {
	_unit = GetUnit(_unit);
	switch(_partType) {
		case uc_EBodyPartType_Pawn: return class'uc_BodyPartFilter'.static.GetTemplate( _partType, _unit.kAppearance.nmPawn );
		case uc_EBodyPartType_Torso: return class'uc_BodyPartFilter'.static.GetTemplate( _partType, _unit.kAppearance.nmTorso );
		case uc_EBodyPartType_Arms: return class'uc_BodyPartFilter'.static.GetTemplate( _partType, _unit.kAppearance.nmArms );
		case uc_EBodyPartType_Legs: return class'uc_BodyPartFilter'.static.GetTemplate( _partType, _unit.kAppearance.nmLegs );
		case uc_EBodyPartType_Head: return class'uc_BodyPartFilter'.static.GetTemplate( _partType, _unit.kAppearance.nmHead );
		case uc_EBodyPartType_Haircut: return class'uc_BodyPartFilter'.static.GetTemplate( _partType, _unit.kAppearance.nmHaircut );
		case uc_EBodyPartType_Helmet: return class'uc_BodyPartFilter'.static.GetTemplate( _partType, _unit.kAppearance.nmHelmet );
		case uc_EBodyPartType_ArmorPattern: return class'uc_BodyPartFilter'.static.GetTemplate( _partType, _unit.kAppearance.nmPatterns );
		case uc_EBodyPartType_Voice: return class'uc_BodyPartFilter'.static.GetTemplate( _partType, _unit.kAppearance.nmVoice );
		case uc_EBodyPartType_Eyes: return class'uc_BodyPartFilter'.static.GetTemplate( _partType, _unit.kAppearance.nmEye );
		case uc_EBodyPartType_Teeth: return class'uc_BodyPartFilter'.static.GetTemplate( _partType, _unit.kAppearance.nmTeeth );
		case uc_EBodyPartType_Beard: return class'uc_BodyPartFilter'.static.GetTemplate( _partType, _unit.kAppearance.nmBeard );
		case uc_EBodyPartType_FacePropUpper: return class'uc_BodyPartFilter'.static.GetTemplate( _partType, _unit.kAppearance.nmFacePropUpper );
		case uc_EBodyPartType_FacePropLower: return class'uc_BodyPartFilter'.static.GetTemplate( _partType, _unit.kAppearance.nmFacePropLower );
		case uc_EBodyPartType_Tattoo_LeftArm: return class'uc_BodyPartFilter'.static.GetTemplate( _partType, _unit.kAppearance.nmTattoo_LeftArm );
		case uc_EBodyPartType_Tattoo_RightArm: return class'uc_BodyPartFilter'.static.GetTemplate( _partType, _unit.kAppearance.nmTattoo_RightArm );
		case uc_EBodyPartType_Scars: return class'uc_BodyPartFilter'.static.GetTemplate( _partType, _unit.kAppearance.nmScars );
		case uc_EBodyPartType_Facepaint: return class'uc_BodyPartFilter'.static.GetTemplate( _partType, _unit.kAppearance.nmFacepaint );
		case uc_EBodyPartType_LeftArm: return class'uc_BodyPartFilter'.static.GetTemplate( _partType, _unit.kAppearance.nmLeftArm );
		case uc_EBodyPartType_RightArm: return class'uc_BodyPartFilter'.static.GetTemplate( _partType, _unit.kAppearance.nmRightArm );
		case uc_EBodyPartType_LeftArmDeco: return class'uc_BodyPartFilter'.static.GetTemplate( _partType, _unit.kAppearance.nmLeftArmDeco );
		case uc_EBodyPartType_RightArmDeco: return class'uc_BodyPartFilter'.static.GetTemplate( _partType, _unit.kAppearance.nmRightArmDeco );
		case uc_EBodyPartType_LeftForearm: return class'uc_BodyPartFilter'.static.GetTemplate( _partType, _unit.kAppearance.nmLeftForearm );
		case uc_EBodyPartType_RightForearm: return class'uc_BodyPartFilter'.static.GetTemplate( _partType, _unit.kAppearance.nmRightForearm );
		case uc_EBodyPartType_Thighs: return class'uc_BodyPartFilter'.static.GetTemplate( _partType, _unit.kAppearance.nmThighs );
		case uc_EBodyPartType_Shins: return class'uc_BodyPartFilter'.static.GetTemplate( _partType, _unit.kAppearance.nmShins );
		case uc_EBodyPartType_TorsoDeco: return class'uc_BodyPartFilter'.static.GetTemplate( _partType, _unit.kAppearance.nmTorsoDeco );
	}
}

///
///
///
public static function string GetBodyPartLabel( uc_EBodyPartType _partType ) {
	local X2BodyPartTemplate _template;
	local uc_BodyPartArchetype _archetype;
	local string _templateLabel;

	_template = class'uc_Customizer'.static.GetBodyPart(_partType);
	if( _template != none ) {
		_archetype = class'uc_BodyPartArchetype'.static.GetArchetypeFromVanillaTemplate(_template);
		`assert( _archetype != none );
		_templateLabel = _archetype.GetLabel(true);
	}
	else {
		_templateLabel = `Localize("None");
	}
	return _templateLabel;
}

///
///
///
public static function SetBodyPart(
	uc_EBodyPartType _partType,
	X2BodyPartTemplate _template,
	optional XComGameState_Unit _unit
) {
	local name _templateName;

	_unit = GetUnit(_unit);
	_templateName = _template!=none ? _template.DataName : '';
	
	`VVLogVar( _unit );
	`VVLogVar( _partType );
	`VVLogVar( _template.DisplayName );
	`VVLogVar( _template.DataName );
	`VVLogVar( _template.CharacterTemplate );
	`VVLogVar( _template.ArmorTemplate );
	`VVLogVar( _template.ArchetypeName );
	`VVLogVar( _template.DLCName );
	
	switch(_partType) {
		case uc_EBodyPartType_Pawn: _unit.kAppearance.nmPawn = _templateName; break;
		case uc_EBodyPartType_Torso: _unit.kAppearance.nmTorso = _templateName; break;
		case uc_EBodyPartType_Arms:
			if( _template != none ) {
				_unit.kAppearance.nmLeftArm = '';
				_unit.kAppearance.nmRightArm = '';
				/*
				_unit.kAppearance.nmLeftArmDeco = '';
				_unit.kAppearance.nmRightArmDeco = '';
				_unit.kAppearance.nmLeftForearm = '';
				_unit.kAppearance.nmRightForearm = '';
				*/
			}
			_unit.kAppearance.nmArms = _templateName;
			break;
		case uc_EBodyPartType_Legs: _unit.kAppearance.nmLegs = _templateName; break;
		case uc_EBodyPartType_Head: _unit.kAppearance.nmHead = _templateName; break;
		case uc_EBodyPartType_Haircut: _unit.kAppearance.nmHaircut = _templateName; break;
		case uc_EBodyPartType_Helmet: _unit.kAppearance.nmHelmet = _templateName; break;
		case uc_EBodyPartType_ArmorPattern: _unit.kAppearance.nmPatterns = _templateName; break;
		case uc_EBodyPartType_Voice: _unit.kAppearance.nmVoice = _templateName; break;
		case uc_EBodyPartType_Eyes: _unit.kAppearance.nmEye = _templateName; break;
		case uc_EBodyPartType_Teeth: _unit.kAppearance.nmTeeth = _templateName; break;
		case uc_EBodyPartType_Beard: _unit.kAppearance.nmBeard = _templateName; break;
		case uc_EBodyPartType_FacePropUpper: _unit.kAppearance.nmFacePropUpper = _templateName; break;
		case uc_EBodyPartType_FacePropLower: _unit.kAppearance.nmFacePropLower = _templateName; break;
		case uc_EBodyPartType_Tattoo_LeftArm: _unit.kAppearance.nmTattoo_LeftArm = _templateName; break;
		case uc_EBodyPartType_Tattoo_RightArm: _unit.kAppearance.nmTattoo_RightArm = _templateName; break;
		case uc_EBodyPartType_Scars: _unit.kAppearance.nmScars = _templateName; break;
		case uc_EBodyPartType_Facepaint: _unit.kAppearance.nmFacePaint = _templateName; break;
		case uc_EBodyPartType_LeftArm:
			if( _template != none ) _unit.kAppearance.nmArms = '';
			_unit.kAppearance.nmLeftArm = _templateName;
			break;
		case uc_EBodyPartType_RightArm:
			if( _template != none ) _unit.kAppearance.nmArms = '';
			_unit.kAppearance.nmRightArm = _templateName;
			break;
		case uc_EBodyPartType_LeftArmDeco: _unit.kAppearance.nmLeftArmDeco = _templateName; break;
		case uc_EBodyPartType_RightArmDeco: _unit.kAppearance.nmRightArmDeco = _templateName; break;
		case uc_EBodyPartType_LeftForearm: _unit.kAppearance.nmLeftForearm = _templateName; break;
		case uc_EBodyPartType_RightForearm: _unit.kAppearance.nmRightForearm = _templateName; break;
		case uc_EBodyPartType_Thighs: _unit.kAppearance.nmThighs = _templateName; break;
		case uc_EBodyPartType_Shins: _unit.kAppearance.nmShins = _templateName; break;
		case uc_EBodyPartType_TorsoDeco: _unit.kAppearance.nmTorsoDeco = _templateName; break;
	}
	StoreUnitAppearance( _unit );
}
/*

private static function Removuc_EBodyPartType(	uc_EBodyPartType _partType, optional XComGameState_Unit _unit ) {
	_unit = GetUnit(_unit);

	switch( _partType ) {
		case uc_EBodyPartType_Arms:
			_unit.kAppearance.nmArms = '';
			if(m_kArmsMC != none && m_kArmsMC.SkeletalMesh != none) {
				m_kArmsMC.SetSkeletalMesh(none);
			}
			break;


	}
	
}

*/
///
///
///
private static function StoreUnitAppearance( optional XComGameState_Unit _unit ) {
	//local XComHumanPawn _pawn;
	local name _armorName;
	_unit = GetUnit(_unit);
	//_pawn = GetPawn();
	//_pawn.SetAppearance(_unit.kAppearance);
	UpdatePawn(_unit);

	_armorName = _unit.GetItemInSlot(eInvSlot_Armor).GetMyTemplateName();
	_unit.StoreAppearance( GetGender(_unit), _armorName );
}


private static function UpdatePawn( XComGameState_Unit _unit ) {
	local XComHumanPawn _pawn;

	`Assert( _unit != none );
	_pawn = GetPawn();

	if( _pawn == none ) return;
	
	if( _unit.kAppearance.nmHelmet == '' ) _unit.kAppearance.nmHelmet = class'uc_BodyPartUtil'.static.GetInvisibleTemplate(uc_EBodyPartType_Helmet).DataName;
	if( _unit.kAppearance.nmFacePropLower == '' ) _unit.kAppearance.nmFacePropLower = class'uc_BodyPartUtil'.static.GetInvisibleTemplate(uc_EBodyPartType_FacePropLower).DataName;
	if( _unit.kAppearance.nmFacePropUpper == '' ) _unit.kAppearance.nmFacePropUpper = class'uc_BodyPartUtil'.static.GetInvisibleTemplate(uc_EBodyPartType_FacePropUpper).DataName;
	if( _unit.kAppearance.nmTorso == '' ) _unit.kAppearance.nmTorso = class'uc_BodyPartUtil'.static.GetInvisibleTemplate(uc_EBodyPartType_Torso).DataName;
	//if( _unit.kAppearance.nmArms == '' ) _unit.kAppearance.nmArms = class'uc_BodyPartUtil'.static.GetInvisibleTemplate(uc_EBodyPartType_Arms).DataName;
	if( _unit.kAppearance.nmLegs == '' ) _unit.kAppearance.nmLegs = class'uc_BodyPartUtil'.static.GetInvisibleTemplate(uc_EBodyPartType_Legs).DataName;
	//if( _unit.kAppearance.nmLeftArm == '' ) _unit.kAppearance.nmLeftArm = class'uc_BodyPartUtil'.static.GetInvisibleTemplate(uc_EBodyPartType_LeftArm).DataName;
	//if( _unit.kAppearance.nmRightArm == '' ) _unit.kAppearance.nmRightArm = class'uc_BodyPartUtil'.static.GetInvisibleTemplate(uc_EBodyPartType_RightArm).DataName;
	if( _unit.kAppearance.nmLeftArmDeco == '' ) _unit.kAppearance.nmLeftArmDeco = class'uc_BodyPartUtil'.static.GetInvisibleTemplate(uc_EBodyPartType_LeftArmDeco).DataName;
	if( _unit.kAppearance.nmRightArmDeco == '' ) _unit.kAppearance.nmRightArmDeco = class'uc_BodyPartUtil'.static.GetInvisibleTemplate(uc_EBodyPartType_RightArmDeco).DataName;
	if( _unit.kAppearance.nmLeftForearm == '' ) _unit.kAppearance.nmLeftForearm = class'uc_BodyPartUtil'.static.GetInvisibleTemplate(uc_EBodyPartType_LeftForearm).DataName;
	if( _unit.kAppearance.nmRightForearm == '' ) _unit.kAppearance.nmRightForearm = class'uc_BodyPartUtil'.static.GetInvisibleTemplate(uc_EBodyPartType_RightForearm).DataName;
	if( class'xmf_DlcUtil'.static.IsWarOfTheChosenActive() ) {
		if( _unit.kAppearance.nmThighs == '' ) _unit.kAppearance.nmThighs = class'uc_BodyPartUtil'.static.GetInvisibleTemplate(uc_EBodyPartType_Thighs).DataName;
		if( _unit.kAppearance.nmShins == '' ) _unit.kAppearance.nmShins = class'uc_BodyPartUtil'.static.GetInvisibleTemplate(uc_EBodyPartType_Shins).DataName;
		if( _unit.kAppearance.nmTorsoDeco == '' ) _unit.kAppearance.nmTorsoDeco = class'uc_BodyPartUtil'.static.GetInvisibleTemplate(uc_EBodyPartType_TorsoDeco).DataName;
	}

	if( _unit.kAppearance.nmArms == '' && _pawn.m_kArmsMC != none ) {
		_pawn.m_kArmsMC.SetSkeletalMesh(none);
	}
	if( _unit.kAppearance.nmLeftArm == '' && _pawn.m_kLeftArm != none ) {
		_pawn.m_kLeftArm.SetSkeletalMesh(none);
	}
	if( _unit.kAppearance.nmRightArm == '' && _pawn.m_kRightArm != none ) {
		_pawn.m_kRightArm.SetSkeletalMesh(none);
	}
	/*
	if( _unit.kAppearance.nmLegs == class'uc_BodyPartUtil'.static.GetInvisibleTemplate(uc_EBodyPartType_Torso).DataName ) {
		_unit.kAppearance.nmLegs = class'uc_BodyPartUtil'.static.GetInvisibleTemplate(uc_EBodyPartType_Legs).DataName;
	}
	*/

	_pawn.SetAppearance(_unit.kAppearance);
}



public static function uc_EArmorType GetArmorType( optional XComGameState_Unit _unit ) {
	local name _templateName;
	local uc_EArmorType _armorType;
	local XComGameState_Item _armor;

	_unit = GetUnit(_unit);
	_armor = _unit.GetItemInSlot(eInvSlot_Armor);
	_templateName = _armor != none ? _armor.GetMyTemplateName() : '';
	_armorType = class'uc_BodyPartUtil'.static.GetArmorType( _templateName );

	`VVLogInfo( `ToString(_unit) @ `ToString(_armor) @ `ToString(_templateName) @ "=" @ `ToString(_armorType) );

	return _armorType;
}


public static function uc_ETechLevel GetArmorTechLevel( optional XComGameState_Unit _unit ) {
	local name _templateName;
	local uc_ETechLevel _techLevel;
	local XComGameState_Item _armor;

	_unit = GetUnit(_unit);
	_armor = _unit.GetItemInSlot(eInvSlot_Armor);
	_templateName = _armor != none ? _armor.GetMyTemplateName() : '';
	_techLevel = class'uc_BodyPartUtil'.static.GetArmorTechLevel( _templateName );

	`VVLogInfo( `ToString(_unit) @ `ToString(_armor) @ `ToString(_templateName) @ "=" @ `ToString(_techLevel) );

	return _techLevel;
}


///
/// Sets appearance for body, but leaves face, attitude, gender, race unmoddifed.
///
public static function SetBodyAppearance( TAppearance _newAppearance, optional XComGameState_Unit _unit ) {
	_unit = GetUnit(_unit);

	// head
	_unit.kAppearance.nmHelmet = _newAppearance.nmHelmet;
	_unit.kAppearance.nmFacePropLower = _newAppearance.nmFacePropLower;
	_unit.kAppearance.nmFacePropUpper = _newAppearance.nmFacePropUpper;
	
	// body
	_unit.kAppearance.nmTorso = _newAppearance.nmTorso;
	_unit.kAppearance.nmArms = _newAppearance.nmArms;
	_unit.kAppearance.nmLegs = _newAppearance.nmLegs;
	_unit.kAppearance.nmLeftArm = _newAppearance.nmLeftArm;
	_unit.kAppearance.nmRightArm = _newAppearance.nmRightArm;
	_unit.kAppearance.nmLeftArmDeco = _newAppearance.nmLeftArmDeco;
	_unit.kAppearance.nmRightArmDeco = _newAppearance.nmRightArmDeco;
	_unit.kAppearance.nmLeftForearm = _newAppearance.nmLeftForearm;
	_unit.kAppearance.nmRightForearm = _newAppearance.nmRightForearm;
	if( class'xmf_DlcUtil'.static.IsWarOfTheChosenActive() ) {
		_unit.kAppearance.nmThighs = _newAppearance.nmThighs;
		_unit.kAppearance.nmShins = _newAppearance.nmShins;
		_unit.kAppearance.nmTorsoDeco = _newAppearance.nmTorsoDeco;
	}
	
	// colors / pattern
	_unit.kAppearance.nmPatterns = _newAppearance.nmPatterns;
	_unit.kAppearance.iArmorTint = _newAppearance.iArmorTint;
	_unit.kAppearance.iArmorTintSecondary = _newAppearance.iArmorTintSecondary;

	StoreUnitAppearance( _unit );
}
