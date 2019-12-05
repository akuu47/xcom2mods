class RM_X2StrategyElement_SPARKTechs extends X2StrategyElement config(SPARKUpgradesNull);

//var config int UpgradeTime;
//
//var config bool InstantUpgrades;

//var config int LowSuppliesCost;

//var config int MedSuppliesCost;

//var config int HighSuppliesCost;

//var config int CorpseCost;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Techs;
	class'RM_SPARKTechs_Helpers'.static.SetValues();
	
	Techs.AddItem(SPARKSuppression());
	Techs.AddItem(SPARKRigging());
	Techs.AddItem(SPARKPCS());
	Techs.AddItem(SPARKShields());
	Techs.AddItem(SPARKMayhem());
	Techs.AddItem(SPARKCloseCombat());
	Techs.AddItem(SPARKHeavyWeapon());
	Techs.AddItem(SPARKATA());
	Techs.AddItem(SPARKGauntlet());
	Techs.AddItem(SPARKNanomachines());
	Techs.AddItem(RebuildSPARK());

	Techs.AddItem(ConvertMEC());

	return Techs;
}


static function X2DataTemplate ConvertMEC()
{
	local X2TechTemplate Template;
	local StrategyRequirement AltReq;
	local ArtifactCost Artifacts;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'RM_ConvertMEC');
	Template.PointsToComplete = StafferXDays(1, 14);
	Template.SortingTier = 1;
	Template.strImage = "img:///UILibrary_DLC3Images.TECH_Spark";

	Template.bProvingGround = true;
	Template.bRepeatable = true;
	Template.ResearchCompletedFn = class'X2StrategyElement_DLC_Day90Techs'.static.CreateSparkSoldier;
	
	// Narrative Requirements
	Template.Requirements.SpecialRequirementsFn = class'X2Helpers_DLC_Day90'.static.IsLostTowersNarrativeContentComplete;

	// Non Narrative Requirements
	AltReq.RequiredTechs.AddItem('MechanizedWarfare');
	Template.AlternateRequirements.AddItem(AltReq);
	
	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 25;
	Template.Cost.ResourceCosts.AddItem(Resources);
	
	Resources.ItemTemplateName = 'AlienAlloy';
	Resources.Quantity = 5;
	Template.Cost.ResourceCosts.AddItem(Resources);
	
	Resources.ItemTemplateName = 'EleriumDust';
	Resources.Quantity = 5;
	Template.Cost.ResourceCosts.AddItem(Resources);
	
	Artifacts.ItemTemplateName = 'CorpseAdventMEC';
	Artifacts.Quantity = class'RM_SPARKTechs_Helpers'.default.CorpseCost * 3;
	Template.Cost.ArtifactCosts.AddItem(Artifacts);

	return Template;
}

static function X2DataTemplate SPARKSuppression()
{
	local X2TechTemplate Template;
	local StrategyRequirement AltReq;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'SPARKSuppression');
	Template.PointsToComplete =  class'RM_SPARKTechs_Helpers'.default.UpgradeTime;
	Template.bCheckForceInstant =class'RM_SPARKTechs_Helpers'.default.InstantUpgrades;
	Template.strImage = "img:///UILibrary_DLC3Images.TECH_Spark";
	Template.SortingTier = 2;
	Template.bProvingGround = true;
	Template.ResearchCompletedFn = AchievementCheck;

	Template.Requirements.SpecialRequirementsFn = class'X2Helpers_DLC_Day90'.static.IsLostTowersNarrativeContentComplete;

	AltReq.RequiredTechs.AddItem('MechanizedWarfare');
	Template.AlternateRequirements.AddItem(AltReq);


	return Template;
}

static function X2DataTemplate SPARKRigging()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;
	local StrategyRequirement AltReq;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'SPARKRigging');
	Template.PointsToComplete = class'RM_SPARKTechs_Helpers'.default.UpgradeTime;
	Template.bCheckForceInstant = class'RM_SPARKTechs_Helpers'.default.InstantUpgrades;
	Template.strImage = "img:///UILibrary_DLC3Images.TECH_Spark";
	Template.SortingTier = 2;
	Template.bProvingGround = true;
	Template.ResearchCompletedFn = AchievementCheck;

	Template.Requirements.SpecialRequirementsFn = class'X2Helpers_DLC_Day90'.static.IsLostTowersNarrativeContentComplete;
	Template.Requirements.RequiredTechs.AddItem('AutopsyMuton');

	AltReq.RequiredTechs.AddItem('MechanizedWarfare');
	AltReq.RequiredTechs.AddItem('AutopsyMuton');
	Template.AlternateRequirements.AddItem(AltReq);

	//resource cost
	Resources.ItemTemplateName = 'CorpseMuton';
	Resources.Quantity = class'RM_SPARKTechs_Helpers'.default.CorpseCost;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = class'RM_SPARKTechs_Helpers'.default.MedSuppliesCost;
	Template.Cost.ResourceCosts.AddItem(Resources);


	return Template;
}

static function X2DataTemplate SPARKPCS()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;
	local StrategyRequirement AltReq;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'SPARKPCS');
	Template.PointsToComplete = class'RM_SPARKTechs_Helpers'.default.UpgradeTime;
	Template.bCheckForceInstant = class'RM_SPARKTechs_Helpers'.default.InstantUpgrades;
	Template.strImage = "img:///UILibrary_DLC3Images.TECH_Spark";
	Template.SortingTier = 2;
	Template.bProvingGround = true;
	Template.ResearchCompletedFn = AchievementCheck;

	Template.Requirements.SpecialRequirementsFn = class'X2Helpers_DLC_Day90'.static.IsLostTowersNarrativeContentComplete;
	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventOfficer');

	AltReq.RequiredTechs.AddItem('MechanizedWarfare');
	AltReq.RequiredTechs.AddItem('AutopsyAdventOfficer');
	Template.AlternateRequirements.AddItem(AltReq);

	//resource cost
	Resources.ItemTemplateName = 'CorpseAdventOfficer';
	Resources.Quantity = class'RM_SPARKTechs_Helpers'.default.CorpseCost;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = class'RM_SPARKTechs_Helpers'.default.LowSuppliesCost;
	Template.Cost.ResourceCosts.AddItem(Resources);


	return Template;
}

static function X2DataTemplate SPARKShields()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;
	local StrategyRequirement AltReq;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'SPARKShields');
	Template.PointsToComplete = class'RM_SPARKTechs_Helpers'.default.UpgradeTime;
	Template.bCheckForceInstant = class'RM_SPARKTechs_Helpers'.default.InstantUpgrades;
	Template.strImage = "img:///UILibrary_DLC3Images.TECH_Spark";
	Template.SortingTier = 2;
	Template.bProvingGround = true;
	Template.ResearchCompletedFn = AchievementCheck;

	Template.Requirements.SpecialRequirementsFn = class'X2Helpers_DLC_Day90'.static.IsLostTowersNarrativeContentComplete;
	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventShieldbearer');

	AltReq.RequiredTechs.AddItem('MechanizedWarfare');
	AltReq.RequiredTechs.AddItem('AutopsyAdventShieldbearer');
	Template.AlternateRequirements.AddItem(AltReq);

	//resource cost
	Resources.ItemTemplateName = 'CorpseAdventShieldbearer';
	Resources.Quantity = class'RM_SPARKTechs_Helpers'.default.CorpseCost;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = class'RM_SPARKTechs_Helpers'.default.MedSuppliesCost;
	Template.Cost.ResourceCosts.AddItem(Resources);


	return Template;
}

static function X2DataTemplate SPARKMayhem()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;
	local StrategyRequirement AltReq;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'SPARKMayhem');
	Template.PointsToComplete = class'RM_SPARKTechs_Helpers'.default.UpgradeTime;
	Template.bCheckForceInstant = class'RM_SPARKTechs_Helpers'.default.InstantUpgrades;
	Template.strImage = "img:///UILibrary_DLC3Images.TECH_Spark";
	Template.SortingTier = 2;
	Template.bProvingGround = true;
	Template.ResearchCompletedFn = AchievementCheck;

	Template.Requirements.SpecialRequirementsFn = class'X2Helpers_DLC_Day90'.static.IsLostTowersNarrativeContentComplete;
	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventMEC');

	AltReq.RequiredTechs.AddItem('MechanizedWarfare');
	AltReq.RequiredTechs.AddItem('AutopsyAdventMEC');
	Template.AlternateRequirements.AddItem(AltReq);

	//resource cost
	Resources.ItemTemplateName = 'CorpseAdventMEC';
	Resources.Quantity = class'RM_SPARKTechs_Helpers'.default.CorpseCost;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = class'RM_SPARKTechs_Helpers'.default.LowSuppliesCost;
	Template.Cost.ResourceCosts.AddItem(Resources);


	return Template;
}


static function X2DataTemplate SPARKCloseCombat()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;
	local StrategyRequirement AltReq;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'SPARKCloseCombat');
	Template.PointsToComplete = class'RM_SPARKTechs_Helpers'.default.UpgradeTime;
	Template.bCheckForceInstant = class'RM_SPARKTechs_Helpers'.default.InstantUpgrades;
	Template.strImage = "img:///UILibrary_DLC3Images.TECH_Spark";
	Template.SortingTier = 2;
	Template.bProvingGround = true;
	Template.ResearchCompletedFn = AchievementCheck;

	Template.Requirements.SpecialRequirementsFn = class'X2Helpers_DLC_Day90'.static.IsLostTowersNarrativeContentComplete;
	Template.Requirements.RequiredTechs.AddItem('AutopsyAndromedon');

	AltReq.RequiredTechs.AddItem('MechanizedWarfare');
	AltReq.RequiredTechs.AddItem('AutopsyAndromedon');
	Template.AlternateRequirements.AddItem(AltReq);

	//resource cost
	Resources.ItemTemplateName = 'CorpseAndromedon';
	Resources.Quantity = class'RM_SPARKTechs_Helpers'.default.CorpseCost;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = class'RM_SPARKTechs_Helpers'.default.HighSuppliesCost;
	Template.Cost.ResourceCosts.AddItem(Resources);


	return Template;
}

static function X2DataTemplate SPARKHeavyWeapon()
{
	local X2TechTemplate Template;
	local StrategyRequirement AltReq;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'SPARKHeavyWeapon');
	Template.PointsToComplete = class'RM_SPARKTechs_Helpers'.default.UpgradeTime;
	Template.bCheckForceInstant = class'RM_SPARKTechs_Helpers'.default.InstantUpgrades;
	Template.strImage = "img:///UILibrary_DLC3Images.TECH_Spark";
	Template.SortingTier = 2;
	Template.bProvingGround = true;
	Template.ResearchCompletedFn = AchievementCheck;

	Template.Requirements.SpecialRequirementsFn = class'X2Helpers_DLC_Day90'.static.IsLostTowersNarrativeContentComplete;
	Template.Requirements.RequiredTechs.AddItem('AutopsySectopod');

	AltReq.RequiredTechs.AddItem('MechanizedWarfare');
	AltReq.RequiredTechs.AddItem('AutopsySectopod');
	Template.AlternateRequirements.AddItem(AltReq);

	//resource cost
	Resources.ItemTemplateName = 'CorpseSectopod';
	Resources.Quantity = 1;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = class'RM_SPARKTechs_Helpers'.default.HighSuppliesCost;
	Template.Cost.ResourceCosts.AddItem(Resources);


	return Template;
}

static function X2DataTemplate SPARKATA()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;
	local StrategyRequirement AltReq;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'SPARKATA');
	Template.PointsToComplete = class'RM_SPARKTechs_Helpers'.default.UpgradeTime;
	Template.bCheckForceInstant = class'RM_SPARKTechs_Helpers'.default.InstantUpgrades;
	Template.strImage = "img:///UILibrary_DLC3Images.TECH_Spark";
	Template.SortingTier = 2;
	Template.bProvingGround = true;
	Template.ResearchCompletedFn = AchievementCheck;

	Template.Requirements.SpecialRequirementsFn = class'X2Helpers_DLC_Day90'.static.IsLostTowersNarrativeContentComplete;
	Template.Requirements.RequiredTechs.AddItem('AutopsyGatekeeper');

	AltReq.RequiredTechs.AddItem('MechanizedWarfare');
	AltReq.RequiredTechs.AddItem('AutopsyGatekeeper');
	Template.AlternateRequirements.AddItem(AltReq);

	//resource cost
	Resources.ItemTemplateName = 'CorpseGatekeeper';
	Resources.Quantity = 1;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = class'RM_SPARKTechs_Helpers'.default.MedSuppliesCost;
	Template.Cost.ResourceCosts.AddItem(Resources);


	return Template;
}


static function X2DataTemplate SPARKGauntlet()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;
	local StrategyRequirement AltReq;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'SPARKGauntlet');
	Template.PointsToComplete = class'RM_SPARKTechs_Helpers'.default.UpgradeTime;
	Template.bCheckForceInstant = class'RM_SPARKTechs_Helpers'.default.InstantUpgrades;
	Template.strImage = "img:///UILibrary_DLC3Images.TECH_Spark";
	Template.SortingTier = 2;
	Template.bProvingGround = true;
	Template.ResearchCompletedFn = AchievementCheck;

	Template.Requirements.SpecialRequirementsFn = class'X2Helpers_DLC_Day90'.static.IsLostTowersNarrativeContentComplete;
	Template.Requirements.RequiredTechs.AddItem('AutopsyBerserker');

	AltReq.RequiredTechs.AddItem('MechanizedWarfare');
	AltReq.RequiredTechs.AddItem('AutopsyBerserker');
	Template.AlternateRequirements.AddItem(AltReq);

	//resource cost
	Resources.ItemTemplateName = 'CorpseBerserker';
	Resources.Quantity = 1;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = class'RM_SPARKTechs_Helpers'.default.MedSuppliesCost;
	Template.Cost.ResourceCosts.AddItem(Resources);


	return Template;
}

static function X2DataTemplate SPARKNanomachines()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;
	local StrategyRequirement AltReq;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'SPARKNanomachines');
	Template.PointsToComplete = class'RM_SPARKTechs_Helpers'.default.UpgradeTime;
	Template.bCheckForceInstant = class'RM_SPARKTechs_Helpers'.default.InstantUpgrades;
	Template.strImage = "img:///UILibrary_DLC3Images.TECH_Spark";
	Template.SortingTier = 2;
	Template.bProvingGround = true;
	Template.ResearchCompletedFn = AchievementCheck;

	Template.Requirements.SpecialRequirementsFn = class'X2Helpers_DLC_Day90'.static.IsLostTowersNarrativeContentComplete;
	Template.Requirements.RequiredTechs.AddItem('AutopsyArchon');

	AltReq.RequiredTechs.AddItem('MechanizedWarfare');
	AltReq.RequiredTechs.AddItem('AutopsyArchon');
	Template.AlternateRequirements.AddItem(AltReq);

	//resource cost
	Resources.ItemTemplateName = 'CorpseArchon';
	Resources.Quantity = class'RM_SPARKTechs_Helpers'.default.CorpseCost;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = class'RM_SPARKTechs_Helpers'.default.MedSuppliesCost;
	Template.Cost.ResourceCosts.AddItem(Resources);


	return Template;
}

static function X2DataTemplate RebuildSPARK()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;
	local StrategyRequirement AltReq;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'RebuildSPARK');
	Template.PointsToComplete = StafferXDays(1, 10);
	Template.bCheckForceInstant = class'RM_SPARKTechs_Helpers'.default.InstantUpgrades;
	Template.strImage = "img:///UILibrary_DLC3Images.TECH_Spark";
	Template.SortingTier = 2;
		Template.bProvingGround = true;
	Template.bRepeatable = true;
	Template.ResearchCompletedFn = CreateSparkSoldier;

	Template.Requirements.SpecialRequirementsFn = class'X2Helpers_DLC_Day90'.static.IsLostTowersNarrativeContentComplete;

	AltReq.RequiredTechs.AddItem('MechanizedWarfare');
	Template.AlternateRequirements.AddItem(AltReq);

	//resource cost
	Resources.ItemTemplateName = 'CorpseSPARK';
	Resources.Quantity = 1;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = class'RM_SPARKTechs_Helpers'.default.MedSuppliesCost;
	Template.Cost.ResourceCosts.AddItem(Resources);


	return Template;
}

function CreateSparkSoldier(XComGameState NewGameState, XComGameState_Tech TechState)
{
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_FacilityXCom FacilityState;
	local StateObjectReference		DeadSpark;

	XComHQ = class'UIUtilities_Strategy'.static.GetXComHQ();

	DeadSpark = GetDeadSpark(XComHQ, NewGameState);

	if(DeadSpark.ObjectID > 0)
		RemakeSparkSoldier(NewGameState, DeadSpark, TechState);

	if(DeadSpark.ObjectID <= 0)
		class'X2Helpers_DLC_Day90'.static.CreateSparkSoldier(NewGameState, , TechState);


	FacilityState = XComHQ.GetFacilityByName('Storage');
	if (FacilityState != none && FacilityState.GetNumLockedStaffSlots() > 0)
	{
		// Unlock the Repair SPARK staff slot in Engineering
		FacilityState.UnlockStaffSlot(NewGameState);
	}
}

function StateObjectReference GetDeadSpark(XComGameState_HeadquartersXCom XComHQ, XComGameState NewGameState)
{
	local int i;
	local StateObjectReference DeadCrew, SparkToRevive;
	local array<StateObjectReference> DeadSparks;
	local XComGameState_Unit UnitState;
	//local MAS_API_AchievementName AchievementName;
//
	foreach XComHQ.DeadCrew(DeadCrew)
	{
		UnitState = XComGameState_Unit(`XCOMHistory.GetGameStateForObjectID(DeadCrew.ObjectID ));

		if(UnitState.GetMyTemplateName() == 'SparkSoldier')
		{
		DeadSparks.AddItem(DeadCrew);
		}

	}

	if(DeadSparks.Length > 0) 
	{
	i = `SYNC_RAND(DeadSparks.Length);

	XComHQ = XComGameState_HeadquartersXCom(NewGameState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
	NewGameState.AddStateObject(XComHQ);

	XComHQ.DeadCrew.RemoveItem(DeadSparks[i]);
	SparkToRevive = DeadSparks[i];
//
	//AchievementName = new class'MAS_API_AchievementName';
	//AchievementName.AchievementName = 'RM_NewBT';
	//`XEVENTMGR.TriggerEvent('UnlockAchievement', AchievementName );	
//
	return SparkToRevive;
	}

	if(DeadSparks.Length <= 0)
		return SparkToRevive;
}


function RemakeSparkSoldier(XComGameState NewGameState, optional StateObjectReference CopiedSpark, optional XComGameState_Tech SparkCreatorTech)
{
	local XComGameStateHistory History;
	local XComOnlineProfileSettings ProfileSettings;
	local X2CharacterTemplateManager CharTemplateMgr;
	local X2CharacterTemplate CharacterTemplate;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Unit NewSparkState, CopiedSparkState;

	History = class'XComGameStateHistory'.static.GetGameStateHistory();

	foreach NewGameState.IterateByClassType(class'XComGameState_HeadquartersXCom', XComHQ)
	{
		break;
	}

	if (XComHQ == none)
	{
		XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
		XComHQ = XComGameState_HeadquartersXCom(NewGameState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
		NewGameState.AddStateObject(XComHQ);
	}

	CopiedSparkState = XComGameState_Unit(History.GetGameStateForObjectID(CopiedSpark.ObjectID));

	// Either copy lost towers unit or generate a new unit from the character pool
	if(CopiedSparkState != none)
	{
		CharTemplateMgr = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();
		CharacterTemplate = CharTemplateMgr.FindCharacterTemplate('SparkSoldier');

		NewSparkState = CharacterTemplate.CreateInstanceFromTemplate(NewGameState);
		NewSparkState.SetTAppearance(CopiedSparkState.kAppearance);
		NewSparkState.SetCharacterName(CopiedSparkState.GetFirstName(), CopiedSparkState.GetLastName(), CopiedSparkState.GetNickName());
		NewSparkState.SetCountry(CopiedSparkState.GetCountry());

	//	NewSparkState.AddXp(CopiedSparkState.GetXPValue() - NewSparkState.GetXPValue());
		NewSparkState.CopyKills(CopiedSparkState);
		NewSparkState.CopyKillAssists(CopiedSparkState);
		NewSparkState.RandomizeStats();
		NewSparkState.ApplyInventoryLoadout(NewGameState);
	}
	else
	{
		// Create a Spark from the Character Pool (will be randomized if no Sparks have been created)
		ProfileSettings = XComOnlineProfileSettings(class'Engine'.static.GetEngine().GetProfileSettings());
		NewSparkState = CharacterPoolManager(class'Engine'.static.GetEngine().GetCharacterPoolManager()).CreateCharacter(NewGameState, ProfileSettings.Data.m_eCharPoolUsage, 'SparkSoldier');
		NewSparkState.RandomizeStats();
		NewSparkState.ApplyInventoryLoadout(NewGameState);
	}
	
	// Make sure the new Spark has the best gear available (will also update to appropriate armor customizations)
	NewSparkState.ApplySquaddieLoadout(NewGameState);
	NewSparkState.ApplyBestGearLoadout(NewGameState);

	NewSparkState.kAppearance.nmPawn = 'XCom_Soldier_Spark';
	NewSparkState.kAppearance.iAttitude = 2; // Force the attitude to be Normal
	NewSparkState.UpdatePersonalityTemplate(); // Grab the personality based on the one set in kAppearance
	NewSparkState.SetStatus(eStatus_Active);
	NewSparkState.bNeedsNewClassPopup = false;
	NewGameState.AddStateObject(NewSparkState);

	XComHQ.AddToCrew(NewGameState, NewSparkState);

	if (SparkCreatorTech != none)
	{
		SparkCreatorTech.UnitRewardRef = NewSparkState.GetReference();
	}
}


function bool IsLostTowersNarrativeEnabled()
{
	local XComGameStateHistory History;
	local XComGameState_CampaignSettings CampaignSettings;

	History = class'XComGameStateHistory'.static.GetGameStateHistory();
	CampaignSettings = XComGameState_CampaignSettings(History.GetSingleGameStateObjectForClass(class'XComGameState_CampaignSettings'));

	// Return true if the Narrative content is enabled
	return (CampaignSettings.HasOptionalNarrativeDLCEnabled(name(class'X2DownloadableContentInfo_DLC_Day90'.default.DLCIdentifier)));
}

// Only returns true if narrative content is enabled AND completed
function bool IsLostTowersNarrativeContentComplete()
{
	if (IsLostTowersNarrativeEnabled())
	{
		if (class'XComGameState_HeadquartersXCom'.static.IsObjectiveCompleted('DLC_LostTowersMissionComplete'))
		{
			return true;
		}
	}

	return false;
}

static function int StafferXDays(int iNumScientists, int iNumDays)
{
	return (iNumScientists * 5) * (24 * iNumDays); // Scientists at base skill level
}

static function AchievementCheck(XComGameState NewGameState, XComGameState_Tech TechState)
{
	//local XComGameState_HeadquartersXCom XComHQ, NewXComHQ;
	//local XComGameStateHistory History;	
	//local X2StrategyElementTemplateManager StratMgr;
	//local array<X2TechTemplate> TechTemplates;
	//local X2TechTemplate TechTemplate;
	//local int idx, TechsResearched;
	//local MAS_API_AchievementName AchNameObj;
//
	//History = `XCOMHISTORY;
//
	//XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
//
	//StratMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
//
	//TechTemplates.AddItem(X2TechTemplate(StratMgr.FindStrategyElementTemplate('SPARKNanomachines')));
	//TechTemplates.AddItem(X2TechTemplate(StratMgr.FindStrategyElementTemplate('SPARKSuppression')));
	//TechTemplates.AddItem(X2TechTemplate(StratMgr.FindStrategyElementTemplate('SPARKRigging')));
	//TechTemplates.AddItem(X2TechTemplate(StratMgr.FindStrategyElementTemplate('SPARKPCS')));
	//TechTemplates.AddItem(X2TechTemplate(StratMgr.FindStrategyElementTemplate('SPARKShields')));
	//TechTemplates.AddItem(X2TechTemplate(StratMgr.FindStrategyElementTemplate('SPARKMayhem')));
	//TechTemplates.AddItem(X2TechTemplate(StratMgr.FindStrategyElementTemplate('SPARKCloseCombat')));
	//TechTemplates.AddItem(X2TechTemplate(StratMgr.FindStrategyElementTemplate('SPARKATA')));
	//TechTemplates.AddItem(X2TechTemplate(StratMgr.FindStrategyElementTemplate('SPARKHeavyWeapon')));
	//TechTemplates.AddItem(X2TechTemplate(StratMgr.FindStrategyElementTemplate('SPARKGauntlet')));
//
	//for(idx = 0; idx < TechTemplates.Length; idx++)
	//{
		//TechTemplate = TechTemplates[idx];
//
		//if(TechTemplate != none)
		//{
			//if(!XComHQ.TechTemplateIsResearched(TechTemplate))
			//{
				//break;
			//}
			//if(XComHQ.TechTemplateIsResearched(TechTemplate))
			//{
				//TechsResearched = TechsResearched + 1;
				//continue;
			//}
		//}
		//else
		//{
			//return;
		//}
	//}
//
	//if(TechsResearched >= 10)
	//{
	//AchNameObj = new class'MAS_API_AchievementName';
	//AchNameObj.AchievementName = 'RM_FullyUpgradedSPARKs';
	//`XEVENTMGR.TriggerEvent('UnlockAchievement', AchNameObj);
//
	//}
//
	return;
}