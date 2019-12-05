class X2Character_FactionSoldiers extends X2Character_DefaultCharacters config(GameData_CharacterStats);


static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	///////////FOR XPAC/////////////
	Templates.AddItem(CreateTemplate_ReaperAgent());
	Templates.AddItem(CreateTemplate_ReaperAgentM2());
	Templates.AddItem(CreateTemplate_ReaperAgentM3());

	Templates.AddItem(CreateTemplate_SkirmisherWarrior());
	Templates.AddItem(CreateTemplate_SkirmisherWarriorM2());
	Templates.AddItem(CreateTemplate_SkirmisherWarriorM3());

	Templates.AddItem(CreateTemplate_TemplarDisciple());
	Templates.AddItem(CreateTemplate_TemplarDiscipleM2());
	Templates.AddItem(CreateTemplate_TemplarDiscipleM3());

	Templates.AddItem(CreateResistanceSoldier('ResistanceSoldier'));
	Templates.AddItem(CreateResistanceSoldier('ResistanceSoldier_M2'));
	Templates.AddItem(CreateResistanceSoldier('ResistanceSoldier_M3'));
	Templates.AddItem(CreateTemplate_ResistanceCivilian());

	//used for Operative Escort
	Templates.AddItem(CreateResistanceOperative('ResistanceOperative'));
	Templates.AddItem(CreateResistanceOperative('ResistanceOperative_M2'));
	Templates.AddItem(CreateResistanceOperative('ResistanceOperative_M3'));



	return Templates;
}


static function X2CharacterTemplate CreateResistanceOperative(name TemplateName)
{
	local X2CharacterTemplate CharTemplate;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);	
	CharTemplate.CharacterGroupName = 'CivilianMilitia';
	CharTemplate.UnitSize = 1;
	CharTemplate.BehaviorClass = class'XGAIBehavior';

	CharTemplate.bCanUse_eTraversal_Normal = true;
	CharTemplate.bCanUse_eTraversal_ClimbOver = true;
	CharTemplate.bCanUse_eTraversal_ClimbOnto = true;
	CharTemplate.bCanUse_eTraversal_ClimbLadder = true;
	CharTemplate.bCanUse_eTraversal_DropDown = true;
	CharTemplate.bCanUse_eTraversal_Grapple = false;
	CharTemplate.bCanUse_eTraversal_Landing = true;
	CharTemplate.bCanUse_eTraversal_BreakWindow = true;
	CharTemplate.bCanUse_eTraversal_KickDoor = true;
	CharTemplate.bCanUse_eTraversal_JumpUp = false;
	CharTemplate.bCanUse_eTraversal_WallClimb = false;
	CharTemplate.bCanUse_eTraversal_BreakWall = false;
	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bAppearanceDefinesPawn = true;
	CharTemplate.bIsAfraidOfFire = true;
	CharTemplate.bIsAlien = false;
	CharTemplate.bIsCivilian = true;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;
	CharTemplate.bCanTakeCover = true;
	CharTemplate.bDisplayUIUnitFlag=true;
	CharTemplate.bCanBeCarried = true;	
//	CharTemplate.strMatineePackages.AddItem("CIN_Soldier");
//	CharTemplate.strIntroMatineeSlotPrefix = "Char";
//	CharTemplate.strLoadingMatineeSlotPrefix = "Soldier";
//	CharTemplate.strPawnArchetypes.AddItem("GameUnit_XComCivilians.ARC_Unit_XComCivilianUnisex");
 
	CharTemplate.DefaultLoadout = TemplateName;
	CharTemplate.Abilities.AddItem('KnockoutSelf');
//	CharTemplate.Abilities.AddItem('Panicked');
	CharTemplate.Abilities.AddItem('HunkerDown');
//	CharTemplate.Abilities.AddItem('CivilianEasyToHit');
	CharTemplate.Abilities.AddItem('Evac');
	CharTemplate.Abilities.AddItem('CarryUnit');
	CharTemplate.Abilities.AddItem('PutDownUnit');
	CharTemplate.Abilities.AddItem('Revive');
	//CharTemplate.Abilities.AddItem('DisableConsumeAllPoints');
	//CharTemplate.Abilities.AddItem('Panicked');
	//CharTemplate.Abilities.AddItem('Berserk');
	//CharTemplate.Abilities.AddItem('Obsessed');
	//CharTemplate.Abilities.AddItem('Shattered');
	CharTemplate.Abilities.AddItem('RM_Disabler');
	CharTemplate.Abilities.AddItem('RM_NetworkStun');
	CharTemplate.Abilities.AddItem('RM_HiddenOperative');
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Civilian;
	CharTemplate.CharacterGeneratorClass = class'XGCharacterGenerator';

	CharTemplate.bShouldCreateDifficultyVariants = false;

//	CharTemplate.strBehaviorTree="CivRoot";
//	CharTemplate.strScamperBT = "SkipMove";

	return CharTemplate;

}

static function X2CharacterTemplate CreateTemplate_ResistanceCivilian()
{
	local X2CharacterTemplate CharTemplate;
	
	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'ResistanceCivilian');
	CharTemplate.UnitSize = 1;
	CharTemplate.BehaviorClass = class'XGAIBehavior_Civilian';
	CharTemplate.bCanUse_eTraversal_Normal = true;
	CharTemplate.bCanUse_eTraversal_ClimbOver = true;
	CharTemplate.bCanUse_eTraversal_ClimbOnto = true;
	CharTemplate.bCanUse_eTraversal_ClimbLadder = true;
    // Note: different from 'Civilian': rebels can dropdown. Needed to allow controllable rebels to move appropriately in some
    // retaliation maps. Failure to dropdown means they need to take roundabout ways to some areas.
	CharTemplate.bCanUse_eTraversal_DropDown = true;
	CharTemplate.bCanUse_eTraversal_Grapple = false;
	CharTemplate.bCanUse_eTraversal_Landing = true;
	CharTemplate.bCanUse_eTraversal_BreakWindow = false;
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
	CharTemplate.bDisplayUIUnitFlag=true;
	CharTemplate.bCanBeCarried = true;	
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_XComCivilians.ARC_Unit_XComCivilianUnisex");
 
	CharTemplate.Abilities.AddItem('Evac');
	CharTemplate.Abilities.AddItem('HunkerDown');
//	CharTemplate.Abilities.AddItem('CivilianInitialState');
//	CharTemplate.Abilities.AddItem('CivilianEasyToHit');
//	CharTemplate.Abilities.AddItem('CivilianRescuedState');
	CharTemplate.strBehaviorTree="CivRoot";

	CharTemplate.bShouldCreateDifficultyVariants = false;

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Civilian;
	CharTemplate.CharacterGeneratorClass = class'XGCharacterGenerator';

	return CharTemplate;
}

static function X2CharacterTemplate CreateResistanceSoldier(name TemplateName)
{
	local X2CharacterTemplate CharTemplate;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);	
	CharTemplate.CharacterGroupName = 'CivilianMilitia';
	CharTemplate.UnitSize = 1;
	CharTemplate.BehaviorClass = class'XGAIBehavior';

	CharTemplate.bCanUse_eTraversal_Normal = true;
	CharTemplate.bCanUse_eTraversal_ClimbOver = true;
	CharTemplate.bCanUse_eTraversal_ClimbOnto = true;
	CharTemplate.bCanUse_eTraversal_ClimbLadder = true;
	CharTemplate.bCanUse_eTraversal_DropDown = true;
	CharTemplate.bCanUse_eTraversal_Grapple = false;
	CharTemplate.bCanUse_eTraversal_Landing = true;
	CharTemplate.bCanUse_eTraversal_BreakWindow = true;
	CharTemplate.bCanUse_eTraversal_KickDoor = true;
	CharTemplate.bCanUse_eTraversal_JumpUp = false;
	CharTemplate.bCanUse_eTraversal_WallClimb = false;
	CharTemplate.bCanUse_eTraversal_BreakWall = false;
	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bAppearanceDefinesPawn = true;
	CharTemplate.bIsAfraidOfFire = true;
	CharTemplate.bIsAlien = false;
	CharTemplate.bIsCivilian = true;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;
	CharTemplate.bCanTakeCover = true;
	CharTemplate.bDisplayUIUnitFlag=true;
	CharTemplate.bCanBeCarried = true;	
//	CharTemplate.strMatineePackages.AddItem("CIN_Soldier");
//	CharTemplate.strIntroMatineeSlotPrefix = "Char";
//	CharTemplate.strLoadingMatineeSlotPrefix = "Soldier";

	CharTemplate.DefaultLoadout = TemplateName;
	CharTemplate.Abilities.AddItem('KnockoutSelf');
//	CharTemplate.Abilities.AddItem('Panicked');
	CharTemplate.Abilities.AddItem('HunkerDown');
//	CharTemplate.Abilities.AddItem('CivilianEasyToHit');
	CharTemplate.Abilities.AddItem('Evac');
	CharTemplate.Abilities.AddItem('CarryUnit');
	CharTemplate.Abilities.AddItem('PutDownUnit');
	CharTemplate.Abilities.AddItem('Revive');
	//CharTemplate.Abilities.AddItem('DisableConsumeAllPoints');
	//CharTemplate.Abilities.AddItem('Panicked');
	//CharTemplate.Abilities.AddItem('Berserk');
	//CharTemplate.Abilities.AddItem('Obsessed');
	//CharTemplate.Abilities.AddItem('Shattered');
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Civilian;
	CharTemplate.CharacterGeneratorClass = class'XGCharacterGenerator';

	CharTemplate.bShouldCreateDifficultyVariants = false;

//	CharTemplate.strBehaviorTree="CivRoot";
//	CharTemplate.strScamperBT = "SkipMove";

	return CharTemplate;

}

///////////FOR XPAC/////////////
static function X2CharacterTemplate CreateTemplate_ReaperAgent()
{
	local X2CharacterTemplate CharTemplate;

	CharTemplate = CreateSoldierTemplate('ReaperAgent');

	CharTemplate.bIsResistanceHero = true;
	CharTemplate.DefaultSoldierClass = 'ReaperAgent';
	CharTemplate.DefaultLoadout = 'ReaperAgentM1';

	CharTemplate.CharacterGeneratorClass = class'XGCharacterGenerator_Reaper';
	CharTemplate.CustomizationManagerClass = class'XComCharacterCustomization_FactionHero';
	CharTemplate.GetPawnNameFn = GetReaperPawnName;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_ReaperAgentM2()
{
	local X2CharacterTemplate CharTemplate;

	CharTemplate = CreateSoldierTemplate('ReaperAgent_M2');

	CharTemplate.bIsResistanceHero = true;
	CharTemplate.DefaultSoldierClass = 'ReaperAgent';
	CharTemplate.DefaultLoadout = 'ReaperAgentM2';
	CharTemplate.Abilities.AddItem('Shrapnel');
	CharTemplate.CharacterGeneratorClass = class'XGCharacterGenerator_Reaper';
	CharTemplate.CustomizationManagerClass = class'XComCharacterCustomization_FactionHero';
	CharTemplate.GetPawnNameFn = GetReaperPawnName;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_ReaperAgentM3()
{
	local X2CharacterTemplate CharTemplate;

	CharTemplate = CreateSoldierTemplate('ReaperAgent_M3');

	CharTemplate.bIsResistanceHero = true;
	CharTemplate.DefaultSoldierClass = 'ReaperAgent';
	CharTemplate.DefaultLoadout = 'ReaperAgentM3';
	CharTemplate.Abilities.AddItem('Shrapnel');
	CharTemplate.Abilities.AddItem('Distraction');
	CharTemplate.CharacterGeneratorClass = class'XGCharacterGenerator_Reaper';
	CharTemplate.CustomizationManagerClass = class'XComCharacterCustomization_FactionHero';
	CharTemplate.GetPawnNameFn = GetReaperPawnName;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_SkirmisherWarrior()
{
	local X2CharacterTemplate CharTemplate;

	CharTemplate = CreateSoldierTemplate('SkirmisherWarrior');

	CharTemplate.bIsResistanceHero = true;
	CharTemplate.DefaultSoldierClass = 'SkirmisherWarrior';
	CharTemplate.DefaultLoadout = 'SkirmisherWarrior';
	
	// Ensure only Skirmisher heads are available for customization
	CharTemplate.bHasCharacterExclusiveAppearance = true;
	CharTemplate.Abilities.AddItem('TotalCombat');
	CharTemplate.Abilities.AddItem('RM_HiddenOperative');

	CharTemplate.CharacterGeneratorClass = class'XGCharacterGenerator_Skirmisher';
	CharTemplate.CustomizationManagerClass = class'XComCharacterCustomization_FactionHero';
	CharTemplate.UICustomizationHeadClass = class'UICustomize_SkirmisherHead';
	CharTemplate.GetPawnNameFn = GetSkirmisherPawnName;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_SkirmisherWarriorM2()
{
	local X2CharacterTemplate CharTemplate;

	CharTemplate = CreateSoldierTemplate('SkirmisherWarrior_M2');

	CharTemplate.bIsResistanceHero = true;
	CharTemplate.DefaultSoldierClass = 'SkirmisherWarrior';
	CharTemplate.DefaultLoadout = 'SkirmisherWarriorM2';
	
	// Ensure only Skirmisher heads are available for customization
	CharTemplate.bHasCharacterExclusiveAppearance = true;
	CharTemplate.Abilities.AddItem('TotalCombat');
	CharTemplate.Abilities.AddItem('SkirmisherVengeance');
	CharTemplate.Abilities.AddItem('RM_HiddenOperative');

	CharTemplate.CharacterGeneratorClass = class'XGCharacterGenerator_Skirmisher';
	CharTemplate.CustomizationManagerClass = class'XComCharacterCustomization_FactionHero';
	CharTemplate.UICustomizationHeadClass = class'UICustomize_SkirmisherHead';
	CharTemplate.GetPawnNameFn = GetSkirmisherPawnName;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_SkirmisherWarriorM3()
{
	local X2CharacterTemplate CharTemplate;

	CharTemplate = CreateSoldierTemplate('SkirmisherWarrior_M3');

	CharTemplate.bIsResistanceHero = true;
	CharTemplate.DefaultSoldierClass = 'SkirmisherWarrior';
	CharTemplate.DefaultLoadout = 'SkirmisherWarriorM3';
	
	// Ensure only Skirmisher heads are available for customization
	CharTemplate.bHasCharacterExclusiveAppearance = true;
	CharTemplate.Abilities.AddItem('TotalCombat');
	CharTemplate.Abilities.AddItem('SkirmisherVengeance');
	CharTemplate.Abilities.AddItem('Whiplash');
	CharTemplate.Abilities.AddItem('RM_HiddenOperative');

	CharTemplate.CharacterGeneratorClass = class'XGCharacterGenerator_Skirmisher';
	CharTemplate.CustomizationManagerClass = class'XComCharacterCustomization_FactionHero';
	CharTemplate.UICustomizationHeadClass = class'UICustomize_SkirmisherHead';
	CharTemplate.GetPawnNameFn = GetSkirmisherPawnName;

	return CharTemplate;
}


static function X2CharacterTemplate CreateTemplate_TemplarDisciple()
{
	local X2CharacterTemplate CharTemplate;

	CharTemplate = CreateSoldierTemplate('TemplarDisciple');

	CharTemplate.bIsResistanceHero = true;
	CharTemplate.DefaultSoldierClass = 'TemplarDisciple';
	CharTemplate.DefaultLoadout = 'TemplarDisciple';
	CharTemplate.Abilities.AddItem('RM_HiddenOperative');

	CharTemplate.strIntroMatineeSlotPrefix = "Templar";

	CharTemplate.CharacterGeneratorClass = class'XGCharacterGenerator_Templar';
	CharTemplate.CustomizationManagerClass = class'XComCharacterCustomization_FactionHero';
	CharTemplate.UICustomizationInfoClass = class'UICustomize_TemplarInfo';
	CharTemplate.GetPawnNameFn = GetTemplarPawnName;

	CharTemplate.strMatineePackages.AddItem("CIN_XP_Heroes");

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_TemplarDiscipleM2()
{
	local X2CharacterTemplate CharTemplate;

	CharTemplate = CreateSoldierTemplate('TemplarDisciple_M2');

	CharTemplate.bIsResistanceHero = true;
	CharTemplate.DefaultSoldierClass = 'TemplarDisciple';
	CharTemplate.DefaultLoadout = 'TemplarDiscipleM2';

	CharTemplate.strIntroMatineeSlotPrefix = "Templar";
	CharTemplate.Abilities.AddItem('Overcharge');
	CharTemplate.Abilities.AddItem('RM_HiddenOperative');
	CharTemplate.CharacterGeneratorClass = class'XGCharacterGenerator_Templar';
	CharTemplate.CustomizationManagerClass = class'XComCharacterCustomization_FactionHero';
	CharTemplate.UICustomizationInfoClass = class'UICustomize_TemplarInfo';
	CharTemplate.GetPawnNameFn = GetTemplarPawnName;

	CharTemplate.strMatineePackages.AddItem("CIN_XP_Heroes");

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_TemplarDiscipleM3()
{
	local X2CharacterTemplate CharTemplate;

	CharTemplate = CreateSoldierTemplate('TemplarDisciple_M3');

	CharTemplate.bIsResistanceHero = true;
	CharTemplate.DefaultSoldierClass = 'TemplarDisciple';
	CharTemplate.DefaultLoadout = 'TemplarDiscipleM3';

	CharTemplate.strIntroMatineeSlotPrefix = "Templar";
	CharTemplate.Abilities.AddItem('Overcharge');
	CharTemplate.Abilities.AddItem('RM_HiddenOperative');
	CharTemplate.CharacterGeneratorClass = class'XGCharacterGenerator_Templar';
	CharTemplate.CustomizationManagerClass = class'XComCharacterCustomization_FactionHero';
	CharTemplate.UICustomizationInfoClass = class'UICustomize_TemplarInfo';
	CharTemplate.GetPawnNameFn = GetTemplarPawnName;

	CharTemplate.strMatineePackages.AddItem("CIN_XP_Heroes");

	return CharTemplate;
}