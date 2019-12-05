//---------------------------------------------------------------------------------------
//  FILE:    X2Ability_CoilSMGAbilities.uc
//	PURPOSE: Adds stat modifier abilities for Coil tier of SMG
//
//	Borrows HEAVILY from:
//		FILE:    X2Ability_LaserSMGAbilities.uc
//		AUTHOR:  Amineri (Long War Studios)
//  
//           
//---------------------------------------------------------------------------------------
class X2Ability_CoilSMGAbilities extends X2Ability
	dependson (XComGameStateContext_Ability) config(WotC_CoilGuns);
	
// ***** Mobility bonuses for SMGs
var config int SMG_COIL_MOBILITY_BONUS;

// *****DetectionRadius bonuses for SMGs
var config float SMG_COIL_DETECTIONRADIUSMODIFER;

/// <summary>
/// Creates the abilities that add passive Mobility for SMGs
/// </summary>
static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	Templates.AddItem(AddSMGCoilBonusAbility());

	return Templates;
}

// ******************* Stat Bonuses **********************

static function X2AbilityTemplate AddSMGCoilBonusAbility()
{
	local X2AbilityTemplate                 Template;	
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SMG_CG_StatBonus');
	Template.IconImage = "img:///gfxXComIcons.NanofiberVest";

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	// Bonus to Mobility and DetectionRange stat effects
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Passive, "", "", Template.IconImage, false,,Template.AbilitySourceName);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, default.SMG_COIL_MOBILITY_BONUS);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_DetectionModifier, default.SMG_COIL_DETECTIONRADIUSMODIFER);
	Template.AddTargetEffect(PersistentStatChangeEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;	
}
