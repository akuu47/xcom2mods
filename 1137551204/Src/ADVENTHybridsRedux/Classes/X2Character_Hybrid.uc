class X2Character_Hybrid extends X2Character config(GameData_CharacterStats);

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateTemplate_HybridSoldier());

	return Templates;
}


static function X2CharacterTemplate CreateTemplate_HybridSoldier()
{
	local X2CharacterTemplate CharTemplate;

	CharTemplate= new(None, string('RM_HybridSoldier')) class'X2CharacterTemplate'; CharTemplate.SetTemplateName('RM_HybridSoldier');;
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
	CharTemplate.bCanBeCriticallyWounded = true;
	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bDiesWhenCaptured = false;
	CharTemplate.bAppearanceDefinesPawn = true;
	CharTemplate.bIsAfraidOfFire = true;
	CharTemplate.bIsAlien = false;
	CharTemplate.bIsAdvent = true;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = true;
	CharTemplate.bCanTakeCover = true;
	CharTemplate.bCanBeCarried = true;
	CharTemplate.bCanBeRevived = true;
	CharTemplate.bUsePoolSoldiers = true;
	CharTemplate.bIsTooBigForArmory = false;
	CharTemplate.bStaffingAllowed = true;
	CharTemplate.bAppearInBase = true; // Do not appear as filler crew or in any regular staff slots throughout the base
	//CharTemplate.bWearArmorInBase = true;
	CharTemplate.bUsesWillSystem = true;
	CharTemplate.bAllowRushCam = true;
	CharTemplate.strMatineePackages.AddItem("CIN_Soldier");
	CharTemplate.strIntroMatineeSlotPrefix = "Char";
	CharTemplate.strLoadingMatineeSlotPrefix = "Soldier";
	CharTemplate.bHasCharacterExclusiveAppearance = true;
	
	CharTemplate.DefaultSoldierClass = 'Rookie';
	CharTemplate.DefaultLoadout = 'RookieSoldier';
	CharTemplate.RequiredLoadout = 'RequiredSoldier';
	CharTemplate.Abilities.AddItem('Loot');
	CharTemplate.Abilities.AddItem('Interact_PlantBomb');
	CharTemplate.Abilities.AddItem('Interact_TakeVial');
	CharTemplate.Abilities.AddItem('Interact_StasisTube');
	CharTemplate.Abilities.AddItem('Interact_MarkSupplyCrate');
	CharTemplate.Abilities.AddItem('Interact_ActivateAscensionGate');
	CharTemplate.Abilities.AddItem('Interact_ActivateSpark');
	CharTemplate.Abilities.AddItem('Interact_AtmosphereComputer');
	CharTemplate.Abilities.AddItem('Interact_UseElevator');
	CharTemplate.Abilities.AddItem('CarryUnit');
	CharTemplate.Abilities.AddItem('PutDownUnit');
	CharTemplate.Abilities.AddItem('Evac');
	CharTemplate.Abilities.AddItem('PlaceEvacZone');
	CharTemplate.Abilities.AddItem('LiftOffAvenger');
	CharTemplate.Abilities.AddItem('Knockout');
	CharTemplate.Abilities.AddItem('KnockoutSelf');
	CharTemplate.Abilities.AddItem('Panicked');
	CharTemplate.Abilities.AddItem('Berserk');
	CharTemplate.Abilities.AddItem('Obsessed');
	CharTemplate.Abilities.AddItem('Shattered');
	CharTemplate.Abilities.AddItem('DisableConsumeAllPoints');
	CharTemplate.Abilities.AddItem('Revive');
	CharTemplate.Abilities.AddItem('HunkerDown');


	// bondmate abilities
	//CharTemplate.Abilities.AddItem('BondmateResistantWill');
	CharTemplate.Abilities.AddItem('BondmateSolaceCleanse');
	CharTemplate.Abilities.AddItem('BondmateSolacePassive');
	CharTemplate.Abilities.AddItem('BondmateTeamwork');
	CharTemplate.Abilities.AddItem('BondmateTeamwork_Improved');
	CharTemplate.Abilities.AddItem('BondmateSpotter_Aim');
	CharTemplate.Abilities.AddItem('BondmateSpotter_Aim_Adjacency');
	//CharTemplate.Abilities.AddItem('BondmateSpotter_Crit');
	//CharTemplate.Abilities.AddItem('BondmateSpotter_Crit_Adjacency');
	//CharTemplate.Abilities.AddItem('BondmateReturnFire_Passive');
	//CharTemplate.Abilities.AddItem('BondmateReturnFire');
	//CharTemplate.Abilities.AddItem('BondmateReturnFire_Adjacency');
	//CharTemplate.Abilities.AddItem('BondmateReturnFire_Improved_Passive');
	//CharTemplate.Abilities.AddItem('BondmateReturnFire_Improved');
	//CharTemplate.Abilities.AddItem('BondmateReturnFire_Improved_Adjacency');
	CharTemplate.Abilities.AddItem('BondmateDualStrike');

	//CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	//CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_XCom;

	CharTemplate.CharacterGeneratorClass = class'XGCharacterGenerator_Hybrid';
	CharTemplate.CustomizationManagerClass = class'XComCharacterCustomization_Hybrid';
	CharTemplate.UICustomizationHeadClass = class'UICustomize_HybridHead';
	CharTemplate.Abilities.AddItem('RM_Mark');

	CharTemplate.PhotoboothPersonality = 'Personality_Normal';

	//CharTemplate.OnEndTacticalPlayFn = SparkEndTacticalPlay;
	//CharTemplate.GetPhotographerPawnNameFn = GetSparkPawnName;

	return CharTemplate;
}
