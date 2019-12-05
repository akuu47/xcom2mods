class X2Character_NewCivie extends X2Character config(XComGameData_CharacterStats);

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateCivilianTemplate());
	Templates.AddItem(CreateFacelessCivilianTemplate());
	Templates.AddItem(CreateHostileCivilianTemplate());

return Templates;
}

static function X2CharacterTemplate CreateCivilianTemplate(optional name TemplateName = 'Civilian')
{
	local X2CharacterTemplate CharTemplate;
	
	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);
	CharTemplate.UnitSize = 1;
	CharTemplate.CanFlankUnits = false;
	CharTemplate.BehaviorClass = class'XGAIBehavior_Civilian';
	CharTemplate.bCanUse_eTraversal_Normal = true;
	CharTemplate.bCanUse_eTraversal_ClimbOver = true;
	CharTemplate.bCanUse_eTraversal_ClimbOnto = true;
	CharTemplate.bCanUse_eTraversal_ClimbLadder = true;
	CharTemplate.bCanUse_eTraversal_DropDown = false;
	CharTemplate.bCanUse_eTraversal_Grapple = false;
	CharTemplate.bCanUse_eTraversal_Landing = true;
	CharTemplate.bCanUse_eTraversal_BreakWindow = true;
	CharTemplate.bCanUse_eTraversal_KickDoor = true;
	CharTemplate.bCanUse_eTraversal_JumpUp = false;
	CharTemplate.bCanUse_eTraversal_WallClimb = false;
	CharTemplate.bCanUse_eTraversal_BreakWall = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bAppearanceDefinesPawn = true;
	CharTemplate.bIsAfraidOfFire = true;
	CharTemplate.bIsAlien = false;
	CharTemplate.bIsCivilian = true;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;
	CharTemplate.bCanTakeCover = true;
	CharTemplate.bDisplayUIUnitFlag=false;
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_XComCivilians.ARC_Unit_XComCivilianUnisex");

	CharTemplate.Abilities.AddItem('Evac');
	CharTemplate.Abilities.AddItem('HunkerDown');
	CharTemplate.Abilities.AddItem('CivilianPanicked');
	CharTemplate.Abilities.AddItem('CivilianInitialState');
	CharTemplate.Abilities.AddItem('CivilianRescuedState');
	CharTemplate.strBehaviorTree="CivRoot";

	CharTemplate.DefaultAppearance.nmVoice = 'CivilianUnisexVoice1_Localized';

	CharTemplate.bShouldCreateDifficultyVariants = false;

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Civilian;
	CharTemplate.CharacterGeneratorClass = class'XGCharacterGenerator';

	return CharTemplate;
}

static function X2CharacterTemplate CreateFacelessCivilianTemplate(optional name TemplateName = 'FacelessCivilian')
{
	local X2CharacterTemplate CharTemplate;
	
	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);
	CharTemplate.UnitSize = 1;
	CharTemplate.CanFlankUnits = false;
	CharTemplate.BehaviorClass = class'XGAIBehavior_Civilian';
	CharTemplate.bCanUse_eTraversal_Normal = true;
	CharTemplate.bCanUse_eTraversal_ClimbOver = true;
	CharTemplate.bCanUse_eTraversal_ClimbOnto = true;
	CharTemplate.bCanUse_eTraversal_ClimbLadder = true;
	CharTemplate.bCanUse_eTraversal_DropDown = false;
	CharTemplate.bCanUse_eTraversal_Grapple = false;
	CharTemplate.bCanUse_eTraversal_Landing = true;
	CharTemplate.bCanUse_eTraversal_BreakWindow = true;
	CharTemplate.bCanUse_eTraversal_KickDoor = true;
	CharTemplate.bCanUse_eTraversal_JumpUp = false;
	CharTemplate.bCanUse_eTraversal_WallClimb = false;
	CharTemplate.bCanUse_eTraversal_BreakWall = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bAppearanceDefinesPawn = true;
	CharTemplate.bIsAfraidOfFire = true;
	CharTemplate.bIsAlien = true;
	CharTemplate.bIsCivilian = true;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;
	CharTemplate.bCanTakeCover = true;
	CharTemplate.bDisplayUIUnitFlag=false;
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_XComCivilians.ARC_Unit_XComCivilianUnisex");

	CharTemplate.Abilities.AddItem('ChangeForm');
	CharTemplate.Abilities.AddItem('HunkerDown');
	CharTemplate.Abilities.AddItem('CivilianPanicked');
	CharTemplate.Abilities.AddItem('CivilianInitialState');
	CharTemplate.Abilities.AddItem('FacelessUntouchable');

	CharTemplate.strBehaviorTree="FacelessCivRoot";
	CharTemplate.strPanicBT = "";

	CharTemplate.bShouldCreateDifficultyVariants = false;

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Civilian;
	CharTemplate.CharacterGeneratorClass = class'XGCharacterGenerator';

	return CharTemplate;
}

static function X2CharacterTemplate CreateHostileCivilianTemplate( )
{
	local X2CharacterTemplate CharTemplate;

	CharTemplate = CreateCivilianTemplate( 'HostileCivilian' );
	
	CharTemplate.Abilities.AddItem('LostHeadshotInit');

	CharTemplate.bIsHostileCivilian = true;
	CharTemplate.strBehaviorTree = "HostileCivRoot";

	CharTemplate.bShouldCreateDifficultyVariants = false;

	return CharTemplate;
}

