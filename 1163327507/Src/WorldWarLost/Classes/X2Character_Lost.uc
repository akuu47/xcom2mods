class X2Character_Lost extends X2Character_DefaultCharacters config(GameData_CharacterStats);

var config array<string> EnabledArchetypes;

var config int Version;
var config bool EnableChildren, EnableHalloween, EnablePoliceForce, EnableResistance, EnableClown, EnableMilitary, EnableHealthcare, EnableGovernment, EnableSports, EnableGeneric, EnableTLE;
 
  static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateTemplate_LostZombie());
	Templates.AddItem(CreateTemplate_LostZombieHuman());

	Templates.AddItem(CreateTemplate_TheLost('TheLost', 'TheLostTier1_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostDasher('TheLostDasher', 'TheLostTier1_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostBrute('TheLostBrute', 'TheLostBruteTier1_MeleeAttack'));
	Templates.AddItem(CreateTemplate_TheLostHowler('TheLostHowler', 'TheLostHowlerTier1_MeleeAttack'));
	
	Templates.AddItem(CreateTemplate_TheLost('TheLostHP2', 'TheLostTier1_Loadout'));
	Templates.AddItem(CreateTemplate_TheLost('TheLostHP3', 'TheLostTier1_Loadout'));
	Templates.AddItem(CreateTemplate_TheLost('TheLostHP4', 'TheLostTier1_Loadout'));
	Templates.AddItem(CreateTemplate_TheLost('TheLostHP5', 'TheLostTier1_Loadout'));
	Templates.AddItem(CreateTemplate_TheLost('TheLostHP6', 'TheLostTier2_Loadout'));
	Templates.AddItem(CreateTemplate_TheLost('TheLostHP7', 'TheLostTier2_Loadout'));
	Templates.AddItem(CreateTemplate_TheLost('TheLostHP8', 'TheLostTier3_Loadout'));
	Templates.AddItem(CreateTemplate_TheLost('TheLostHP9', 'TheLostTier3_Loadout'));
	Templates.AddItem(CreateTemplate_TheLost('TheLostHP10', 'TheLostTier3_Loadout'));
	Templates.AddItem(CreateTemplate_TheLost('TheLostHP11', 'TheLostTier3_Loadout'));
	Templates.AddItem(CreateTemplate_TheLost('TheLostHP12', 'TheLostTier3_Loadout'));

	Templates.AddItem(CreateTemplate_TheLostDasher('TheLostDasherHP2', 'TheLostTier1_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostDasher('TheLostDasherHP3', 'TheLostTier1_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostDasher('TheLostDasherHP4', 'TheLostTier1_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostDasher('TheLostDasherHP5', 'TheLostTier1_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostDasher('TheLostDasherHP6', 'TheLostTier2_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostDasher('TheLostDasherHP7', 'TheLostTier2_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostDasher('TheLostDasherHP8', 'TheLostTier3_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostDasher('TheLostDasherHP9', 'TheLostTier3_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostDasher('TheLostDasherHP10', 'TheLostTier3_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostDasher('TheLostDasherHP11', 'TheLostTier3_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostDasher('TheLostDasherHP12', 'TheLostTier3_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostDasher('TheLostDasherHP13', 'TheLostTier3_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostDasher('TheLostDasherHP14', 'TheLostTier3_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostDasher('TheLostDasherHP15', 'TheLostTier3_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostDasher('TheLostDasherHP16', 'TheLostTier3_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostDasher('TheLostDasherHP17', 'TheLostTier3_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostDasher('TheLostDasherHP18', 'TheLostTier3_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostDasher('TheLostDasherHP19', 'TheLostTier3_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostDasher('TheLostDasherHP20', 'TheLostTier3_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostDasher('TheLostDasherHP21', 'TheLostTier3_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostDasher('TheLostDasherHP22', 'TheLostTier3_Loadout'));

	Templates.AddItem(CreateTemplate_TheLostHowler('TheLostHowlerHP4', 'TheLostHowlerTier1_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostHowler('TheLostHowlerHP5', 'TheLostHowlerTier1_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostHowler('TheLostHowlerHP6', 'TheLostHowlerTier1_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostHowler('TheLostHowlerHP7', 'TheLostHowlerTier1_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostHowler('TheLostHowlerHP8', 'TheLostHowlerTier2_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostHowler('TheLostHowlerHP9', 'TheLostHowlerTier2_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostHowler('TheLostHowlerHP10', 'TheLostHowlerTier2_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostHowler('TheLostHowlerHP11', 'TheLostHowlerTier2_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostHowler('TheLostHowlerHP12', 'TheLostHowlerTier2_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostHowler('TheLostHowlerHP13', 'TheLostHowlerTier3_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostHowler('TheLostHowlerHP14', 'TheLostHowlerTier3_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostHowler('TheLostHowlerHP15', 'TheLostHowlerTier3_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostHowler('TheLostHowlerHP16', 'TheLostHowlerTier3_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostHowler('TheLostHowlerHP17', 'TheLostHowlerTier3_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostHowler('TheLostHowlerHP18', 'TheLostHowlerTier3_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostHowler('TheLostHowlerHP19', 'TheLostHowlerTier3_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostHowler('TheLostHowlerHP20', 'TheLostHowlerTier3_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostHowler('TheLostHowlerHP21', 'TheLostHowlerTier3_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostHowler('TheLostHowlerHP22', 'TheLostHowlerTier3_Loadout'));

	Templates.AddItem(CreateTemplate_TheLostBrute('TheLostBruteHP10', 'TheLostBruteTier1_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostBrute('TheLostBruteHP11', 'TheLostBruteTier1_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostBrute('TheLostBruteHP12', 'TheLostBruteTier1_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostBrute('TheLostBruteHP14', 'TheLostBruteTier2_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostBrute('TheLostBruteHP15', 'TheLostBruteTier2_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostBrute('TheLostBruteHP16', 'TheLostBruteTier2_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostBrute('TheLostBruteHP19', 'TheLostBruteTier3_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostBrute('TheLostBruteHP22', 'TheLostBruteTier3_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostBrute('TheLostBruteHP24', 'TheLostBruteTier3_Loadout'));
	Templates.AddItem(CreateTemplate_TheLostBrute('TheLostBruteHP26', 'TheLostBruteTier3_Loadout'));
	
	return Templates;
}

static function X2CharacterTemplate CreateTemplate_TheLost(name LostName, name LoadoutName)
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;
	local string ArchetypeStr;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, LostName);
	CharTemplate.CharacterGroupName = 'TheLost';
	CharTemplate.strBehaviorTree = "TheLostNew::CharacterRoot";
	CharTemplate.BehaviorClass = class'XGAIBehavior';
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'TheLostCX_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);
	CharTemplate.DefaultLoadout = LoadoutName;
	
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_TheLost.ARC_GameUnit_TheLost_A"); //Base Lost
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_TheLost.ARC_GameUnit_TheLost_B"); //Base Lost
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_TheLost.ARC_GameUnit_TheLost_C"); //Base Lost
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_TheLost.ARC_GameUnit_TheLost_D"); //Base Lost
	

	// Ginger (10.8.17): Make archetype choice ini-editable
	foreach default.EnabledArchetypes(ArchetypeStr)
	{
		CharTemplate.strPawnArchetypes.AddItem(ArchetypeStr);
	}

	// Ginger (12.9.17): Make archetype categories which are compatible with MCM
	if (default.EnableMilitary || class'UIScreenListener_MCM_WorldWarLost'.default.bMilitaryEnabled)
	{
		// Put Military archetypes here
		CharTemplate.strPawnArchetypes.AddItem("CX_Extra_Lost_Cosmetics.ARC_GameUnit_TheLost_ArmyGer_M"); // German Soldier Lost
	}
	if (default.EnableSports || class'UIScreenListener_MCM_WorldWarLost'.default.bSportsEnabled)
	{
		// Put Sports archetypes here
		CharTemplate.strPawnArchetypes.AddItem("CX_Extra_Lost_Sport.ARC_GameUnit_TheLost_AmericanFootball_M"); // AmericanFootball Lost
		CharTemplate.strPawnArchetypes.AddItem("CX_Extra_Lost_Sport.ARC_GameUnit_TheLost_AmericanFootball_CX"); // CX Player Lost
		CharTemplate.strPawnArchetypes.AddItem("CX_Extra_Lost_Sport.ARC_GameUnit_TheLost_AmericanFootball_Odd"); // Odd Player Lost
		CharTemplate.strPawnArchetypes.AddItem("CX_Extra_Lost_Sport.ARC_GameUnit_TheLost_Cheerleader_F"); // Cheerleader Lost
	}
	if (default.EnableHealthcare || class'UIScreenListener_MCM_WorldWarLost'.default.bHealthcareEnabled)
	{
		// Put Healthcare archetypes here
		CharTemplate.strPawnArchetypes.AddItem("CX_Extra_Lost_HealthCare.ARC_GameUnit_TheLost_PatientZ"); // MalePatient Lost
		CharTemplate.strPawnArchetypes.AddItem("CX_Extra_Lost_HealthCare.ARC_GameUnit_TheLost_MaleSurgeon001"); // MaleSurgeon001 Lost
	}
	if (default.EnableGovernment || class'UIScreenListener_MCM_WorldWarLost'.default.bGovernmentEnabled)
	{
		// Put Government archetypes here
	    CharTemplate.strPawnArchetypes.AddItem("CX_Extra_Lost_Cosmetics.ARC_GameUnit_TheLost_G"); // FemalePantsSuit Lost
		CharTemplate.strPawnArchetypes.AddItem("CX_Extra_Lost_Cosmetics.ARC_GameUnit_TheLost_K"); // HasmatNoMask Lost
	    CharTemplate.strPawnArchetypes.AddItem("CX_Extra_Lost_Cosmetics.ARC_GameUnit_TheLost_L"); // HasmatMask Lost	
	}
	if (default.EnableChildren || class'UIScreenListener_MCM_WorldWarLost'.default.bChildrenEnabled)
	{
		// Put children archetypes here
		CharTemplate.strPawnArchetypes.AddItem("CX_Extra_Lost_Cosmetics.ARC_GameUnit_TheLost_I"); // LittleGirl Lost
		CharTemplate.strPawnArchetypes.AddItem("CX_Extra_Lost_Cosmetics.ARC_GameUnit_TheLost_N"); // LittleBoy Lost
	}
	if (default.EnableHalloween || class'UIScreenListener_MCM_WorldWarLost'.default.bHalloweenEnabled)
	{
		// Put Halloween archetypes here
		CharTemplate.strPawnArchetypes.AddItem("CX_Extra_Lost_Seasonal.ARC_GameUnit_TheLost_PumpkinHead001"); // Halloween pumpkin1
		CharTemplate.strPawnArchetypes.AddItem("CX_Extra_Lost_Seasonal.ARC_GameUnit_TheLost_PumpkinHead002"); // Halloween pumpkin2
		CharTemplate.strPawnArchetypes.AddItem("CX_Extra_Lost_Seasonal.Archetypes.ARC_GameUnit_TheLost_PennyWise"); //Robert "Bob" Gray

	}
	if (default.EnablePoliceForce || class'UIScreenListener_MCM_WorldWarLost'.default.bPoliceForceEnabled)
	{
		// Put Police archetypes here
		CharTemplate.strPawnArchetypes.AddItem("CX_Extra_Lost_PoliceForce.ARC_GameUnit_TheLost_MaleCop001"); // MalePolice Lost
		CharTemplate.strPawnArchetypes.AddItem("CX_Extra_Lost_PoliceForce.ARC_GameUnit_TheLost_FemaleCop001"); // FemalePolice Lost
		CharTemplate.strPawnArchetypes.AddItem("CX_Extra_Lost_PoliceForce.ARC_GameUnit_TheLost_FatCop001"); // MalePolice Fat Lost
	}
	if (default.EnableResistance || class'UIScreenListener_MCM_WorldWarLost'.default.bResistanceEnabled)
	{
		// Put Resistance archetypes here
		CharTemplate.strPawnArchetypes.AddItem("CX_Extra_Lost_Resistance.ARC_GameUnit_TheLost_ResistanceA_M"); //Resistance Lost Male A
		CharTemplate.strPawnArchetypes.AddItem("CX_Extra_Lost_Resistance.ARC_GameUnit_TheLost_ResistanceA_F"); //Resistance Lost Female A
		CharTemplate.strPawnArchetypes.AddItem("CX_Extra_Lost_Resistance.ARC_GameUnit_TheLost_ResistanceB_M"); //Resistance Lost Male B
		CharTemplate.strPawnArchetypes.AddItem("CX_Extra_Lost_Resistance.ARC_GameUnit_TheLost_ResistanceB_F"); //Resistance Lost Female B
		CharTemplate.strPawnArchetypes.AddItem("CX_Extra_Lost_Resistance.ARC_GameUnit_TheLost_ResistanceC_M"); //Resistance Lost Male C
		CharTemplate.strPawnArchetypes.AddItem("CX_Extra_Lost_Resistance.ARC_GameUnit_TheLost_ResistanceD_M"); //Resistance Lost Male D
		CharTemplate.strPawnArchetypes.AddItem("CX_Extra_Lost_Resistance.ARC_GameUnit_TheLost_ResistanceE_M"); //Resistance Lost Male E
	}
	if (default.EnableClown || class'UIScreenListener_MCM_WorldWarLost'.default.bClownEnabled)
	{
		// Put Clown archetypes here
		CharTemplate.strPawnArchetypes.AddItem("CX_Extra_Lost_Cosmetics.ARC_GameUnit_TheLost_J"); // Clown Lost
	}
	if (default.EnableGeneric || class'UIScreenListener_MCM_WorldWarLost'.default.bGenericEnabled)
	{
		// Put Generic archetypes here
		CharTemplate.strPawnArchetypes.AddItem("CX_Extra_Lost_Cosmetics.ARC_GameUnit_TheLost_H"); //FemaleSkimpy Lost
		CharTemplate.strPawnArchetypes.AddItem("CX_Extra_Lost_Cosmetics.ARC_GameUnit_TheLost_Cook_M"); //Male Cook Lost
	}
	if (default.EnableTLE || class'UIScreenListener_MCM_WorldWarLost'.default.bTLEEnabled)
	{
		// Put Generic archetypes here
		CharTemplate.strPawnArchetypes.AddItem("CX_Extra_Lost_TLE.ARC_PsiZombieCivilian_F_1"); //TLE Female 001
		CharTemplate.strPawnArchetypes.AddItem("CX_Extra_Lost_TLE.ARC_PsiZombieCivilian_F_2"); //TLE Female 002
		CharTemplate.strPawnArchetypes.AddItem("CX_Extra_Lost_TLE.ARC_PsiZombieCivilian_M_1"); //TLE Male 001
		CharTemplate.strPawnArchetypes.AddItem("CX_Extra_Lost_TLE.ARC_PsiZombieCivilian_M_2"); //TLE Male 002
		CharTemplate.strPawnArchetypes.AddItem("CX_Extra_Lost_TLE.ARC_PsiZombieCivilian_M_3"); //TLE Male 003
		
	}
	// Ginger (12.9.17): end

	CharTemplate.strMatineePackages.AddItem("CIN_XP_Lost");

	CharTemplate.UnitSize = 1;

	CharTemplate.KillContribution = 0.25;

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
	CharTemplate.bCanTakeCover = false;

	CharTemplate.bSkipDefaultAbilities = true;

	CharTemplate.bIsAlien = false;
	CharTemplate.bIsAdvent = false;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;
	CharTemplate.bIsMeleeOnly = true;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;

	CharTemplate.bDisplayUIUnitFlag = true;
	
	CharTemplate.bAllowSpawnFromATT = false;

	CharTemplate.strScamperBT = "TheLostScamperRoot";

	CharTemplate.ImmuneTypes.AddItem('Mental');
	CharTemplate.ImmuneTypes.AddItem('Poison');
	CharTemplate.ImmuneTypes.AddItem('EleriumPoisoning');

	CharTemplate.Abilities.AddItem('StandardMove');
	CharTemplate.Abilities.AddItem('ZombieInitialization');
	CharTemplate.Abilities.AddItem('LostHeadshotInit');
	CharTemplate.Abilities.AddItem('LostColorPassive');

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_CEN_T_First_Seen_Lost');
	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_CEN_T_First_Lost_Seen_A');
	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_CEN_T_First_Lost_Seen_B');

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_TheLost;

	CharTemplate.bDontUseOTSTargetingCamera = true;

	CharTemplate.AcquiredPhobiaTemplate = 'FearOfTheLost';

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_TheLostDasher(name LostName, name LoadoutName)
{
	local X2CharacterTemplate CharTemplate;

	CharTemplate = CreateTemplate_TheLost(LostName, LoadoutName);
	CharTemplate.strPawnArchetypes.Length = 0;
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_TheLost.ARC_GameUnit_TheLost_Wolf");
	CharTemplate.SightedNarrativeMoments.Length = 0;
	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_CEN_T_First_Dasher_A');
	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_CEN_T_First_Dasher_B');

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_TheLostHowler(name LostName, name LoadoutName)
{
	local X2CharacterTemplate CharTemplate;

	CharTemplate = CreateTemplate_TheLost(LostName, LoadoutName);
	
	CharTemplate.strPawnArchetypes.Length = 0;
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_TheLost.ARC_GameUnit_TheLost_Howler");

	CharTemplate.AIOrderPriority = 100;
	CharTemplate.Abilities.AddItem('LostHowl');

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_TheLostBrute(name LostName, name LoadoutName)
{
	local X2CharacterTemplate CharTemplate;

	CharTemplate = CreateTemplate_TheLost(LostName, LoadoutName);
	CharTemplate.strPawnArchetypes.Length = 0;
	CharTemplate.CharacterGroupName = 'TheLostBrute';
	CharTemplate.strPawnArchetypes.AddItem("CX_Extra_Lost_Brute.Archetypes.ARC_GameUnit_TheLost_CXBrute"); //Brute Lost
	CharTemplate.SightedNarrativeMoments.Length = 0;
	CharTemplate.Abilities.AddItem('WallBreaking');

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_LostZombie(Name TemplateName = 'LostZombie')
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);
	CharTemplate.CharacterGroupName = 'TheLost';
	CharTemplate.DefaultLoadout='LostZombie_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("CX_Extra_Lost_Cosmetics.ARC_GameUnit_NewZombie");
    CharTemplate.strPawnArchetypes.AddItem("CX_Extra_Lost_Cosmetics.ARC_GameUnit_NewZombie_F");
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'TheLost_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_XP_Lost");

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
	CharTemplate.bCanTakeCover = false;

	CharTemplate.bSkipDefaultAbilities = true;

	CharTemplate.bIsAlien = false;
	CharTemplate.bIsAdvent = false;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;
	CharTemplate.bIsMeleeOnly = true;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;
	
	CharTemplate.bAllowSpawnFromATT = false;

	CharTemplate.strScamperBT = "ScamperRoot_NoCover";

	CharTemplate.ImmuneTypes.AddItem('Mental');
	CharTemplate.ImmuneTypes.AddItem('Poison');
	CharTemplate.ImmuneTypes.AddItem('EleriumPoisoning');

	CharTemplate.Abilities.AddItem('StandardMove');
	CharTemplate.Abilities.AddItem('ZombieInitialization');
    CharTemplate.Abilities.AddItem('LostHeadshotInit');

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_PsiZombie');
	

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_TheLost;

	CharTemplate.AcquiredPhobiaTemplate = 'FearOfTheLost';

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_LostZombieHuman()
{
	local X2CharacterTemplate CharTemplate;
	CharTemplate = CreateTemplate_LostZombie('LostZombieHuman');
	CharTemplate.strPawnArchetypes.Length = 0;
	CharTemplate.strPawnArchetypes.AddItem("CX_Extra_Lost_Cosmetics.ARC_GameUnit_NewZombie_Human_M");
    CharTemplate.strPawnArchetypes.AddItem("CX_Extra_Lost_Cosmetics.ARC_GameUnit_NewZombie_Human_F");

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_TheLost;

	return CharTemplate;
}