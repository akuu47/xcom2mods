class X2_Character_MutonElite extends X2Character config(XComGameData_CharacterStats);

struct AIJobInfo_Addition
{
	var Name JobName;						// Name of this job.
	var Name Preceding;						// Name of unit before current in the list, if any
	var Name Succeeding;					// Name of unit after current in the list, if any
	var int DefaultPosition;				// Default index to insert at if cannot find based on name
};

var config array<AIJobInfo_Addition> JobListingAdditions;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateTemplate_MutonElite());

	return Templates;
}

static function X2CharacterTemplate CreateTemplate_MutonElite()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'MutonElite');
	CharTemplate.CharacterGroupName = 'MutonElite';
	CharTemplate.DefaultLoadout='MutonElite_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("LWMutonM3.Archetypes.ARC_GameUnit_MutonM3");
	Loot.ForceLevel=0;
	Loot.LootTableName='MutonElite_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'Muton_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'Muton_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Muton");
	CharTemplate.strTargetingMatineePrefix = "CIN_Muton_FF_StartPos";

	CharTemplate.UnitSize = 1;
	// Traversal Rules
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
	CharTemplate.bAppearanceDefinesPawn = false;    
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bIsAlien = true;
	CharTemplate.bIsAdvent = false;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;
	CharTemplate.bAllowRushCam = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;
	CharTemplate.AcquiredPhobiaTemplate = 'FearOfMutons';

	CharTemplate.bAllowSpawnFromATT = false;

	CharTemplate.Abilities.AddItem('CounterattackPreparation');
	CharTemplate.Abilities.AddItem('CounterattackDescription');
	CharTemplate.Abilities.AddItem('HeavyOrdnance');
	CharTemplate.Abilities.AddItem('Salvo');
	CharTemplate.Abilities.AddItem('MutonElite_PersonalShield');	

	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');
	


	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;
	CharTemplate.strBehaviorTree = "MutonEliteRoot";

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_Muton');

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Alien;

	return CharTemplate;
}

