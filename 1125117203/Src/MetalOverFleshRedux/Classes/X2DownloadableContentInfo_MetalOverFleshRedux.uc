//---------------------------------------------------------------------------------------
//  FILE:   XComDownloadableContentInfo_SPARKUpgrades.uc                                    
//           
//	Use the X2DownloadableContentInfo class to specify unique mod behavior when the 
//  player creates a new campaign or loads a saved game.
//  
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_MetalOverFleshRedux extends X2DownloadableContentInfo config(SPARKUpgrades);

var config int MAYHEM_DMG;

var config int GAUNTLET_DMG;

var config int GAUNTLET_PIERCE;

var config array<name> SPARKWeapons;

var config int NumSlots;

var config array<name> SPARKTemplates;

/// <summary>
/// This method is run if the player loads a saved game that was created prior to this DLC / Mod being installed, and allows the 
/// DLC / Mod to perform custom processing in response. This will only be called once the first time a player loads a save that was
/// create without the content installed. Subsequent saves will record that the content was installed.
/// </summary>
static event OnLoadedSavedGame()
{
	UpdateResearch();
	//AddTracker();
	AddNewStaffSlots();
}

/// <summary>
/// Called when the player starts a new campaign while this DLC / Mod is installed
/// </summary>
static event InstallNewCampaign(XComGameState StartState)
{}


static event OnPostTemplatesCreated()
{
	EditVanillaAbilities();
	EditSparkTemplate();
	EditWeaponTemplates();
	EditFacilityTemplate();
}

static event OnLoadedSavedGameToStrategy()
{
	UpdateResearch();
	//AchievementCheck();
	//AddTracker();
	AddNewStaffSlots();
}


static function AddNewStaffSlots()
{
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_FacilityXCom FacilityState;
	local X2FacilityTemplate FacilityTemplate;
	local XComGameState_StaffSlot StaffSlotState, ExistingStaffSlot, LinkedStaffSlotState;
	local X2StaffSlotTemplate StaffSlotTemplate;
	local StaffSlotDefinition SlotDef;
	local int i, j;
	local bool bReplaceSlot, DidChange;
	local X2StrategyElementTemplateManager StratMgr;
	local array<int> SkipIndices;
	local XComGameState NewGameState;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Metal Over Flesh -- Adding New Slots");

	XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	StratMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();


	FacilityState = XComHQ.GetFacilityByName('Storage');
	if (FacilityState != none)
	{
		FacilityState = XComGameState_FacilityXCom(NewGameState.ModifyStateObject(class'XComGameState_FacilityXCom', FacilityState.ObjectID));
		FacilityTemplate = FacilityState.GetMyTemplate();

		for (i = 0; i < FacilityTemplate.StaffSlotDefs.Length; i++)
		{
			if(SkipIndices.Find(i) == INDEX_NONE)
			{
				SlotDef = FacilityTemplate.StaffSlotDefs[i];
				// Check to see if the existing staff slot at this index no longer matches the template and needs to be replaced
				bReplaceSlot = false;
				if(i < FacilityState.StaffSlots.Length && FacilityState.StaffSlots[i].ObjectID != 0)
				{
					ExistingStaffSlot = FacilityState.GetStaffSlot(i);
					if(ExistingStaffSlot.GetMyTemplateName() != SlotDef.StaffSlotTemplateName)
					{
						bReplaceSlot = true;
					}
				}

				if(i >= FacilityState.StaffSlots.Length || bReplaceSlot) // Only add a new staff slot if it doesn't already exist or needs to be replaced
				{
					StaffSlotTemplate = X2StaffSlotTemplate(StratMgr.FindStrategyElementTemplate(SlotDef.StaffSlotTemplateName));
					DidChange = true;
					if(StaffSlotTemplate != none)
					{
						// Create slot state and link to this facility
						StaffSlotState = StaffSlotTemplate.CreateInstanceFromTemplate(NewGameState);
						StaffSlotState.Facility = FacilityState.GetReference();

						// Check for starting the slot locked
						if(SlotDef.bStartsLocked)
						{
							StaffSlotState.LockSlot();
						}

						if(bReplaceSlot)
						{
							FacilityState.StaffSlots[i] = StaffSlotState.GetReference();
						}
						else
						{
							FacilityState.StaffSlots.AddItem(StaffSlotState.GetReference());
						}

						// Check rest of list for partner slot
						if(SlotDef.LinkedStaffSlotTemplateName != '')
						{
							StaffSlotTemplate = X2StaffSlotTemplate(StratMgr.FindStrategyElementTemplate(SlotDef.LinkedStaffSlotTemplateName));

							if(StaffSlotTemplate != none)
							{
								for(j = (i + 1); j < FacilityTemplate.StaffSlotDefs.Length; j++)
								{
									SlotDef = FacilityTemplate.StaffSlotDefs[j];

									if(SkipIndices.Find(j) == INDEX_NONE && SlotDef.StaffSlotTemplateName == StaffSlotTemplate.DataName)
									{
										// Check to see if the existing staff slot at this index no longer matches the template and needs to be replaced
										bReplaceSlot = false;
										if(j < FacilityState.StaffSlots.Length && FacilityState.StaffSlots[j].ObjectID != 0)
										{
											ExistingStaffSlot = FacilityState.GetStaffSlot(j);
											if(ExistingStaffSlot.GetMyTemplateName() != SlotDef.StaffSlotTemplateName)
											{
												bReplaceSlot = true;
											}
										}

										if(j >= FacilityState.StaffSlots.Length || bReplaceSlot) // Only add a new staff slot if it doesn't already exist or needs to be replaced
										{
											// Create slot state and link to this facility
											LinkedStaffSlotState = StaffSlotTemplate.CreateInstanceFromTemplate(NewGameState);
											LinkedStaffSlotState.Facility = FacilityState.GetReference();

											// Check for starting the slot locked
											if(SlotDef.bStartsLocked)
											{
												LinkedStaffSlotState.LockSlot();
											}

											// Link the slots
											StaffSlotState.LinkedStaffSlot = LinkedStaffSlotState.GetReference();
											LinkedStaffSlotState.LinkedStaffSlot = StaffSlotState.GetReference();

											if(bReplaceSlot)
											{
												FacilityState.StaffSlots[j] = LinkedStaffSlotState.GetReference();
											}
											else
											{
												FacilityState.StaffSlots.AddItem(LinkedStaffSlotState.GetReference());
											}

											// Add index to list to be skipped since we already added it
											SkipIndices.AddItem(j);
											break;
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}
		
	

	if (NewGameState.GetNumGameStateObjects() > 0 && DidChange)
	{
		XComGameInfo(class'Engine'.static.GetCurrentWorldInfo().Game).GameRuleset.SubmitGameState(NewGameState);
	}
	else
	{
		`XCOMHistory.CleanupPendingGameState(NewGameState);
	}

}

static Event EditFacilityTemplate()
{
	local X2FacilityTemplate FacilityTemplate;
	local array<X2FacilityTemplate> FacilityTemplates;
	local StaffSlotDefinition StaffSlotDef;

	FindFacilityTemplateAllDifficulties('Storage', FacilityTemplates);
	StaffSlotDef.StaffSlotTemplateName = 'SparkStaffSlot';
	foreach FacilityTemplates(FacilityTemplate)
	{


		FacilityTemplate.StaffSlotDefs.AddItem(StaffSlotDef);

	}

}


//retrieves all difficulty variants of a given facility template
static function FindFacilityTemplateAllDifficulties(name DataName, out array<X2FacilityTemplate> FacilityTemplates, optional X2StrategyElementTemplateManager StrategyTemplateMgr)
{
	local array<X2DataTemplate> DataTemplates;
	local X2DataTemplate DataTemplate;
	local X2FacilityTemplate FacilityTemplate;

	if(StrategyTemplateMgr == none)
		StrategyTemplateMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();

	StrategyTemplateMgr.FindDataTemplateAllDifficulties(DataName, DataTemplates);
	FacilityTemplates.Length = 0;
	foreach DataTemplates(DataTemplate)
	{
		FacilityTemplate = X2FacilityTemplate(DataTemplate);
		if( FacilityTemplate != none )
		{
			FacilityTemplates.AddItem(FacilityTemplate);
		}
	}
}


//
//static function AddTracker()
//{
	//local XComGameStateHistory History;
	//local XComGameState NewGameState;
	//local RM_XComGameState_TriggerObj AchievementObject;
//
	//History = class'XComGameStateHistory'.static.GetGameStateHistory();
	//NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Metal Over Flesh -- Adding Mod Achievement State");
//
	//// Add Achievement Object
	//AchievementObject = RM_XComGameState_TriggerObj(History.GetSingleGameStateObjectForClass(class'RM_XComGameState_TriggerObj', true));
	//if (AchievementObject == none) // Prevent duplicate Achievement Objects
	//{
		//AchievementObject = RM_XComGameState_TriggerObj(NewGameState.CreateStateObject(class'RM_XComGameState_TriggerObj'));
		//NewGameState.AddStateObject(AchievementObject);
	//}
	//
//
	//if (NewGameState.GetNumGameStateObjects() > 0)
	//{
		//AddAchievementTriggers(AchievementObject);
		//History.AddGameStateToHistory(NewGameState);
	//}
	//else
	//{
		//History.CleanupPendingGameState(NewGameState);
	//}
//
//}
//
//static function AddAchievementTriggers(Object TriggerObj)
//{
	//local X2EventManager EventManager;
//
	//// Set up triggers for achievements
	//EventManager = class'X2EventManager'.static.GetEventManager();
	//
	//EventManager.RegisterForEvent(TriggerObj, 'TacticalGameEnd', class'RM_X2AchievementTracker'.static.OnTacticalGameEnd, ELD_OnStateSubmitted, 50, , true);
	//EventManager.RegisterForEvent(TriggerObj, 'KillMail', class'RM_X2AchievementTracker'.static.OnKillMail, ELD_OnStateSubmitted, 50, , true);
//}

//
//static function AchievementCheck()
//{
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
	//return;
//}

static function bool IsResearchInHistory(name ResearchName)
{
	// Check if we've already injected the tech templates
	local XComGameState_Tech	TechState;
	
	foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_Tech', TechState)
	{
		if ( TechState.GetMyTemplateName() == ResearchName )
		{
			return true;
		}
	}
	return false;
}


static function UpdateResearch()
{
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local X2TechTemplate TechTemplate;
	//local XComGameState_Tech TechState;
	local X2StrategyElementTemplateManager	StratMgr;

	//In this method, we demonstrate functionality that will add ExampleWeapon to the player's inventory when loading a saved
	//game. This allows players to enjoy the content of the mod in campaigns that were started without the mod installed.
	StratMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	History = `XCOMHISTORY;	

	//Create a pending game state change
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Adding Research Templates");


	//Find tech template
	if ( !IsResearchInHistory('SPARKSuppression') )
	{
	TechTemplate = X2TechTemplate(StratMgr.FindStrategyElementTemplate('SPARKSuppression'));
	NewGameState.CreateNewStateObject(class'XComGameState_Tech', TechTemplate);
	}
	if ( !IsResearchInHistory('SPARKRigging') )
	{
	TechTemplate = X2TechTemplate(StratMgr.FindStrategyElementTemplate('SPARKRigging'));
	NewGameState.CreateNewStateObject(class'XComGameState_Tech', TechTemplate);
	}
	if ( !IsResearchInHistory('SPARKPCS') )
	{
	TechTemplate = X2TechTemplate(StratMgr.FindStrategyElementTemplate('SPARKPCS'));
	NewGameState.CreateNewStateObject(class'XComGameState_Tech', TechTemplate);
	}

	if ( !IsResearchInHistory('SPARKShields') )
	{
	TechTemplate = X2TechTemplate(StratMgr.FindStrategyElementTemplate('SPARKShields'));
	NewGameState.CreateNewStateObject(class'XComGameState_Tech', TechTemplate);
	}
	
	if ( !IsResearchInHistory('SPARKMayhem') )
	{
	TechTemplate = X2TechTemplate(StratMgr.FindStrategyElementTemplate('SPARKMayhem'));
	NewGameState.CreateNewStateObject(class'XComGameState_Tech', TechTemplate);
	}

	if ( !IsResearchInHistory('SPARKCloseCombat') )
	{
	TechTemplate = X2TechTemplate(StratMgr.FindStrategyElementTemplate('SPARKCloseCombat'));
	NewGameState.CreateNewStateObject(class'XComGameState_Tech', TechTemplate);
	}

	if ( !IsResearchInHistory('SPARKHeavyWeapon') )
	{
	TechTemplate = X2TechTemplate(StratMgr.FindStrategyElementTemplate('SPARKHeavyWeapon'));
	NewGameState.CreateNewStateObject(class'XComGameState_Tech', TechTemplate);
	}

	if ( !IsResearchInHistory('SPARKATA') )
	{
	TechTemplate = X2TechTemplate(StratMgr.FindStrategyElementTemplate('SPARKATA'));
	NewGameState.CreateNewStateObject(class'XComGameState_Tech', TechTemplate);
	}

	if ( !IsResearchInHistory('SPARKGauntlet') )
	{
	TechTemplate = X2TechTemplate(StratMgr.FindStrategyElementTemplate('SPARKGauntlet'));
	NewGameState.CreateNewStateObject(class'XComGameState_Tech', TechTemplate);
	}

	if ( !IsResearchInHistory('SPARKNanomachines') )
	{
	TechTemplate = X2TechTemplate(StratMgr.FindStrategyElementTemplate('SPARKNanomachines'));
	NewGameState.CreateNewStateObject(class'XComGameState_Tech', TechTemplate);
	}
		
	if ( !IsResearchInHistory('RebuildSPARK') )
	{
	TechTemplate = X2TechTemplate(StratMgr.FindStrategyElementTemplate('RebuildSPARK'));
	NewGameState.CreateNewStateObject(class'XComGameState_Tech', TechTemplate);
	}

	if ( !IsResearchInHistory('RM_ConvertMEC') )
	{
	TechTemplate = X2TechTemplate(StratMgr.FindStrategyElementTemplate('RM_ConvertMEC'));
	NewGameState.CreateNewStateObject(class'XComGameState_Tech', TechTemplate);
	}

	if( NewGameState.GetNumGameStateObjects() > 0 )
	{
		//Commit the state change into the history.
		History.AddGameStateToHistory(NewGameState);
	}
	else
	{
		History.CleanupPendingGameState(NewGameState);
	}
}

static event OnPreMission(XComGameState NewGameState, XComGameState_MissionSite MissionState)
{
	local SPARKUpgrades_TacticalCleanup EndMissionListener;

	`log("SPARKUpgrades :: Ensuring presence of tactical game state listeners");
	
	EndMissionListener = SPARKUpgrades_TacticalCleanup(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'SPARKUpgrades_TacticalCleanup', true));

	if (EndMissionListener == none)
	{
		EndMissionListener = SPARKUpgrades_TacticalCleanup(NewGameState.CreateStateObject(class'SPARKUpgrades_TacticalCleanup'));
		NewGameState.AddStateObject(EndMissionListener);
	}

	EndMissionListener.RegisterToListen();
}

static function EditVanillaAbilities()
 {
	local X2AbilityTemplateManager							AbilityManager;
	local X2AbilityTemplate									AbilityTemplate;
	local X2Condition_AbilityProperty						AbilityCondition;
	local X2Effect_ApplyWeaponDamage						WeaponDamageEffect;
	local RM_SparkCondition									SparkCondition;

	AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	AbilityTemplate = AbilityManager.FindAbilityTemplate('Suppression');
	SparkCondition = new class'RM_SparkCondition';
	AbilityTemplate.AbilityShooterConditions.AddItem(SparkCondition);
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bIgnoreBaseDamage = true;
	WeaponDamageEffect.EffectDamageValue.Damage = default.MAYHEM_DMG;
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('RMGrimyMayhem');
	WeaponDamageEffect.TargetConditions.AddItem(AbilityCondition);
	AbilityTemplate.AddTargetEffect(WeaponDamageEffect);

	//for LW's perk pack, since apparently SPARKs can get this
	AbilityTemplate = AbilityManager.FindAbilityTemplate('AreaSuppression');
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bIgnoreBaseDamage = true;
	WeaponDamageEffect.EffectDamageValue.Damage = default.MAYHEM_DMG;
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('RMGrimyMayhem');
	WeaponDamageEffect.TargetConditions.AddItem(AbilityCondition);
	AbilityTemplate.AddTargetEffect(WeaponDamageEffect);


	//this SHOULD assign the abilitytemplate to something else and have the ability target switch
	AbilityTemplate = AbilityManager.FindAbilityTemplate('Strike');
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bIgnoreBaseDamage = true;
	WeaponDamageEffect.EffectDamageValue.Damage = default.GAUNTLET_DMG;
	WeaponDamageEffect.EffectDamageValue.Pierce = default.GAUNTLET_PIERCE;
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('BerserkerGauntlet');
	WeaponDamageEffect.TargetConditions.AddItem(AbilityCondition);
	AbilityTemplate.AddTargetEffect(WeaponDamageEffect);
}



static function EditSparkTemplate()
{
	local X2CharacterTemplateManager	CharManager;
	local X2CharacterTemplate			CharTemplate;
	local LootReference Loot;
	local name	CustomName;
	local array<X2DataTemplate>		DifficultyTemplates;
	local X2DataTemplate			DifficultyTemplate;

	CharManager = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();

	CharManager.FindDataTemplateAllDifficulties('SparkSoldier',DifficultyTemplates);
	
	foreach DifficultyTemplates(DifficultyTemplate) 
	{
		CharTemplate = X2CharacterTemplate(DifficultyTemplate);
		if ( CharTemplate != none ) 
		{
				CharTemplate.CharacterBaseStats[eStat_UtilityItems] = default.NumSlots;
				//CharTemplate.CharacterBaseStats[eStat_CombatSims] = 1; //this actually apparently does work, it's just that with testing this results in SPARKs being hideously OP.
				CharTemplate.Abilities.AddItem('RMGrimyMayhem');
				//CharTemplate.Abilities.AddItem('RMGrimyCloseCombat');
				CharTemplate.Abilities.AddItem('UtilityRigging');
				CharTemplate.Abilities.AddItem('PCSAdaptation');
				CharTemplate.Abilities.AddItem('SPARKShields');
				CharTemplate.Abilities.AddItem('HeavyWeaponStorage');
				CharTemplate.Abilities.AddItem('AutomatedThreatAssessment');
				CharTemplate.Abilities.AddItem('BerserkerGauntlet');
				CharTemplate.Abilities.AddItem('NanomachinesSon');
				CharTemplate.Abilities.AddItem('RM_Punch');
				Loot.ForceLevel=0;
				Loot.LootTableName='SPARK_BaseLoot';
				CharTemplate.Loot.LootReferences.AddItem(Loot);
		}
	}

	
	CharManager.FindDataTemplateAllDifficulties('LostTowersSpark',DifficultyTemplates);
	
	foreach DifficultyTemplates(DifficultyTemplate) 
	{
		CharTemplate = X2CharacterTemplate(DifficultyTemplate);
		if ( CharTemplate != none ) 
		{
				CharTemplate.CharacterBaseStats[eStat_UtilityItems] = default.NumSlots;
				//CharTemplate.CharacterBaseStats[eStat_CombatSims] = 1; 
				CharTemplate.Abilities.AddItem('RMGrimyMayhem');
				CharTemplate.Abilities.AddItem('RMGrimyCloseCombat');
				CharTemplate.Abilities.AddItem('UtilityRigging');
				CharTemplate.Abilities.AddItem('PCSAdaptation');
				CharTemplate.Abilities.AddItem('SPARKShields');
				CharTemplate.Abilities.AddItem('HeavyWeaponStorage');
				CharTemplate.Abilities.AddItem('AutomatedThreatAssessment');
				CharTemplate.Abilities.AddItem('BerserkerGauntlet');
				CharTemplate.Abilities.AddItem('NanomachinesSon');
				CharTemplate.Abilities.AddItem('RM_Punch');
				CharTemplate.Abilities.Additem('RM_Suppression');
				Loot.ForceLevel=0;
				Loot.LootTableName='SPARK_BaseLoot';
				CharTemplate.Loot.LootReferences.AddItem(Loot);
		}
	}

	foreach default.SPARKTemplates(CustomName)
	{
		CharManager.FindDataTemplateAllDifficulties(CustomName,DifficultyTemplates);
	
		foreach DifficultyTemplates(DifficultyTemplate) 
		{
			CharTemplate = X2CharacterTemplate(DifficultyTemplate);
			if ( CharTemplate != none ) 
			{
					CharTemplate.CharacterBaseStats[eStat_UtilityItems] = default.NumSlots;
					//CharTemplate.CharacterBaseStats[eStat_CombatSims] = 1; 
					CharTemplate.Abilities.AddItem('RMGrimyMayhem');
					CharTemplate.Abilities.AddItem('RMGrimyCloseCombat');
					CharTemplate.Abilities.AddItem('UtilityRigging');
					CharTemplate.Abilities.AddItem('PCSAdaptation');
					CharTemplate.Abilities.AddItem('SPARKShields');
					CharTemplate.Abilities.AddItem('HeavyWeaponStorage');
					CharTemplate.Abilities.AddItem('AutomatedThreatAssessment');
					CharTemplate.Abilities.AddItem('BerserkerGauntlet');
					CharTemplate.Abilities.AddItem('NanomachinesSon');
					CharTemplate.Abilities.AddItem('RM_Punch');
					CharTemplate.Abilities.Additem('RM_Suppression');
					Loot.ForceLevel=0;
					Loot.LootTableName='SPARK_BaseLoot';
					CharTemplate.Loot.LootReferences.AddItem(Loot);
			}
		}




	}


}

static function EditWeaponTemplates()
{
	local X2ItemTemplateManager		ItemManager;
	local array<X2WeaponTemplate>	WeaponTemplates;
	local X2WeaponTemplate			WeaponTemplate;
	local name						WeaponName;
	local array<X2DataTemplate>		DifficultyTemplates;
	local X2DataTemplate			DifficultyTemplate;


	ItemManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	WeaponTemplates = ItemManager.GetAllWeaponTemplates();

	foreach WeaponTemplates(WeaponTemplate) 
	{
		foreach default.SPARKWeapons(WeaponName)
		{
			if (WeaponTemplate.DataName == WeaponName) 
			{
				if ( WeaponTemplate.Abilities.Find('Suppression') == INDEX_NONE )
				{
					ItemManager.FindDataTemplateAllDifficulties(WeaponTemplate.DataName,DifficultyTemplates);
					foreach DifficultyTemplates(DifficultyTemplate) 
					{
						WeaponTemplate = X2WeaponTemplate(DifficultyTemplate);
						if ( WeaponTemplate != none && WeaponTemplate.Abilities.Find('Suppression') == INDEX_NONE ) 
						{
							WeaponTemplate.Abilities.AddItem('Suppression');
						}
					}
				}

				if ( WeaponTemplate.Abilities.Find('RMGrimyCloseCombat') == INDEX_NONE )
				{
					ItemManager.FindDataTemplateAllDifficulties(WeaponTemplate.DataName,DifficultyTemplates);
					foreach DifficultyTemplates(DifficultyTemplate) 
					{
						WeaponTemplate = X2WeaponTemplate(DifficultyTemplate);
						if ( WeaponTemplate != none && WeaponTemplate.Abilities.Find('RMGrimyCloseCombat') == INDEX_NONE ) 
						{
							WeaponTemplate.Abilities.AddItem('RMGrimyCloseCombat');
						}
					}
				}
			}
		}
	}

}

exec function GiveALLSPARKResearch()
{
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local X2TechTemplate TechTemplate;
	local XComGameState_Tech TechState;
	local X2StrategyElementTemplateManager	StratMgr;

	//In this method, we demonstrate functionality that will add ExampleWeapon to the player's inventory when loading a saved
	//game. This allows players to enjoy the content of the mod in campaigns that were started without the mod installed.
	StratMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	History = `XCOMHISTORY;	

	//Create a pending game state change
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Adding Research Templates");


	//Find tech template
	if ( !IsResearchInHistory('SPARKSuppression') )
	{
	TechTemplate = X2TechTemplate(StratMgr.FindStrategyElementTemplate('SPARKSuppression'));
	TechState = XComGameState_Tech(NewGameState.CreateStateObject(class'XComGameState_Tech'));
	TechState.OnCreation(TechTemplate);
	NewGameState.AddStateObject(TechState);
	}
	if ( !IsResearchInHistory('SPARKRigging') )
	{
	TechTemplate = X2TechTemplate(StratMgr.FindStrategyElementTemplate('SPARKRigging'));
	TechState = XComGameState_Tech(NewGameState.CreateStateObject(class'XComGameState_Tech'));
	TechState.OnCreation(TechTemplate);
	NewGameState.AddStateObject(TechState);
	}
	if ( !IsResearchInHistory('SPARKPCS') )
	{
	TechTemplate = X2TechTemplate(StratMgr.FindStrategyElementTemplate('SPARKPCS'));
	TechState = XComGameState_Tech(NewGameState.CreateStateObject(class'XComGameState_Tech'));
	TechState.OnCreation(TechTemplate);
	NewGameState.AddStateObject(TechState);
	}

	if ( !IsResearchInHistory('SPARKShields') )
	{
	TechTemplate = X2TechTemplate(StratMgr.FindStrategyElementTemplate('SPARKShields'));
	TechState = XComGameState_Tech(NewGameState.CreateStateObject(class'XComGameState_Tech'));
	TechState.OnCreation(TechTemplate);
	NewGameState.AddStateObject(TechState);
	}
	
	if ( !IsResearchInHistory('SPARKMayhem') )
	{
	TechTemplate = X2TechTemplate(StratMgr.FindStrategyElementTemplate('SPARKMayhem'));
	TechState = XComGameState_Tech(NewGameState.CreateStateObject(class'XComGameState_Tech'));
	TechState.OnCreation(TechTemplate);
	NewGameState.AddStateObject(TechState);
	}

	if ( !IsResearchInHistory('SPARKCloseCombat') )
	{
	TechTemplate = X2TechTemplate(StratMgr.FindStrategyElementTemplate('SPARKCloseCombat'));
	TechState = XComGameState_Tech(NewGameState.CreateStateObject(class'XComGameState_Tech'));
	TechState.OnCreation(TechTemplate);
	NewGameState.AddStateObject(TechState);
	}

	if ( !IsResearchInHistory('SPARKHeavyWeapon') )
	{
	TechTemplate = X2TechTemplate(StratMgr.FindStrategyElementTemplate('SPARKHeavyWeapon'));
	TechState = XComGameState_Tech(NewGameState.CreateStateObject(class'XComGameState_Tech'));
	TechState.OnCreation(TechTemplate);
	NewGameState.AddStateObject(TechState);
	}

	if ( !IsResearchInHistory('SPARKATA') )
	{
	TechTemplate = X2TechTemplate(StratMgr.FindStrategyElementTemplate('SPARKATA'));
	TechState = XComGameState_Tech(NewGameState.CreateStateObject(class'XComGameState_Tech'));
	TechState.OnCreation(TechTemplate);
	NewGameState.AddStateObject(TechState);
	}

	if ( !IsResearchInHistory('SPARKGauntlet') )
	{
	TechTemplate = X2TechTemplate(StratMgr.FindStrategyElementTemplate('SPARKGauntlet'));
	TechState = XComGameState_Tech(NewGameState.CreateStateObject(class'XComGameState_Tech'));
	TechState.OnCreation(TechTemplate);
	NewGameState.AddStateObject(TechState);
	}

	
	if ( !IsResearchInHistory('SPARKNanomachines') )
	{
	TechTemplate = X2TechTemplate(StratMgr.FindStrategyElementTemplate('SPARKNanomachines'));
	TechState = XComGameState_Tech(NewGameState.CreateStateObject(class'XComGameState_Tech'));
	TechState.OnCreation(TechTemplate);
	NewGameState.AddStateObject(TechState);
	}

		
	if ( !IsResearchInHistory('RebuildSPARK') )
	{
	TechTemplate = X2TechTemplate(StratMgr.FindStrategyElementTemplate('RebuildSPARK'));
	TechState = XComGameState_Tech(NewGameState.CreateStateObject(class'XComGameState_Tech'));
	TechState.OnCreation(TechTemplate);
	NewGameState.AddStateObject(TechState);
	}

	if ( !IsResearchInHistory('RM_ConvertMEC') )
	{
	TechTemplate = X2TechTemplate(StratMgr.FindStrategyElementTemplate('RM_ConvertMEC'));
	NewGameState.CreateNewStateObject(class'XComGameState_Tech', TechTemplate);
	}

	if( NewGameState.GetNumGameStateObjects() > 0 )
	{
		//Commit the state change into the history.
		History.AddGameStateToHistory(NewGameState);
	}
	else
	{
		History.CleanupPendingGameState(NewGameState);
	}
}

exec function GiveSPARKUpgradeResearch(name TechName)
{
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local X2TechTemplate TechTemplate;
	local XComGameState_Tech TechState;
	local X2StrategyElementTemplateManager	StratMgr;

	//In this method, we demonstrate functionality that will add ExampleWeapon to the player's inventory when loading a saved
	//game. This allows players to enjoy the content of the mod in campaigns that were started without the mod installed.
	StratMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	History = `XCOMHISTORY;	

	//Create a pending game state change
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Adding Research Templates");


	//Find tech template
	TechTemplate = X2TechTemplate(StratMgr.FindStrategyElementTemplate(TechName));
	if(TechTemplate != none)
	{
		TechState = XComGameState_Tech(NewGameState.CreateStateObject(class'XComGameState_Tech'));
		TechState.OnCreation(TechTemplate);
		NewGameState.AddStateObject(TechState);
	}

	//Commit the state change into the history.
	History.AddGameStateToHistory(NewGameState);
}

exec function SPARKUpgradeHelp()
{
	class'Helpers'.static.OutputMsg("The tech names that can be used are:");
	class'Helpers'.static.OutputMsg("SPARKSuppression, SPARKRigging, SPARKPCS, SPARKShields");
	class'Helpers'.static.OutputMsg("SPARKMayhem, SPARKCloseCombat, SPARKHeavyWeapon, SPARKATA");
	class'Helpers'.static.OutputMsg("SPARKGauntlet, SPARKNanomachines");
}

static function bool AbilityTagExpandHandler(string InString, out string OutString)
{
	local name Type;

	Type = name(InString);

	switch(Type)
	{
	case 'CLOSE_COMBAT_DISTANCE':
		OutString = string(class'GrimyClassRebalance_Condition_Distance'.default.CLOSE_COMBAT_DISTANCE);
		return true;
	case 'MAYHEM_DMG':
		OutString = string(default.MAYHEM_DMG);
		return true;
	case 'AIM_POINTS':
		OutString = string(class'RM_SPARKTechs_Helpers'.default.AIM_POINTS);
		return true;
	case 'MUSCLE_MOBILITY':
		OutString = string(class'RM_SPARKTechs_Helpers'.default.MUSCLE_MOBILITY);
		return true;
	case 'SPARK_SHIELD':
		OutString = string(class'RM_SPARKTechs_Helpers'.default.SHIELD_POINTS);
		return true;
	case 'HEAVY_STORAGE':
		OutString = string(class'RM_SPARKTechs_Helpers'.default.HEAVY_CHARGES);
		return true;
	case 'AUTOMATED_THREAT':
		OutString = string(class'RM_SPARKTechs_Helpers'.default.ATA_DEFENSE);
		return true;
	case 'GAUNTLET_DMG':
		OutString = string(default.GAUNTLET_DMG);
		return true;
	case 'NANOREPAIR':
		OutString = string(class'RM_SPARKTechs_Helpers'.default.NanoRepair);
		return true;
	case 'SELF_AIM':
		OutString = string(class'RM_SPARKTechs_Helpers'.default.SelfAimBonus);
		return true;
	case 'NANOWEAVE':
		OutString = string(class'RM_SPARKTechs_Helpers'.default.NanoArmour);
		return true;
	case 'CODEX_DODGE':
		OutString = string(class'RM_SPARKTechs_Helpers'.default.CodexDodge);
		return true;
	case 'CODEX_MAX':
		OutString = string(class'RM_SPARKTechs_Helpers'.default.CodexMax);
		return true;
	}
	return false;
}



static function bool CanAddItemToInventory_CH(out int bCanAddItem, const EInventorySlot Slot, const X2ItemTemplate ItemTemplate, int Quantity, XComGameState_Unit UnitState, optional XComGameState CheckGameState, optional out string DisabledReason)
{
	local XGParamTag LocTag;
	local X2GrenadeTemplate GrenadeTemplate;


	GrenadeTemplate = X2GrenadeTemplate(ItemTemplate);
	//DisabledReason = "";

	if(CheckGameState != none)
		return CanAddItemToInventory(bCanAddItem, Slot, ItemTemplate, Quantity, UnitState, CheckGameState);


	if(CheckGameState == none && UnitState.GetMyTemplateName() == 'SparkSoldier' && GrenadeTemplate != none) //only do this check for our grenades on SPARKs
	{

		LocTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
		LocTag.StrValue0 = class'X2SoldierClassTemplateManager'.static.GetSoldierClassTemplateManager().FindSoldierClassTemplate('Spark').DisplayName;
		DisabledReason = class'UIUtilities_Text'.static.CapsCheckForGermanScharfesS(`XEXPAND.ExpandString(class'UIArmory_Loadout'.default.m_strUnavailableToClass));
	
		return false; //return false to give our disabled reason;

	}

	return true; //return true as a fallback or if we got nothing to do with the item
}

static function bool CanAddItemToInventory(out int bCanAddItem, const EInventorySlot Slot, const X2ItemTemplate ItemTemplate, int Quantity, XComGameState_Unit UnitState, XComGameState CheckGameState)
{
	local X2GrenadeTemplate GrenadeTemplate;

	GrenadeTemplate = X2GrenadeTemplate(ItemTemplate);


	if(UnitState.GetMyTemplateName() == 'SparkSoldier' && GrenadeTemplate != none) //is a grenade item and is for a SPARK
	{
		bCanAddItem = 0;
		return true; //we set this to true so grenades return false for SPARKs
	}

	return false;
}



/// <summary>
/// Called from XComGameState_Unit:GatherUnitAbilitiesForInit after the game has built what it believes is the full list of
/// abilities for the unit based on character, class, equipment, et cetera. You can add or remove abilities in SetupData.
/// </summary>
static function FinalizeUnitAbilitiesForInit(XComGameState_Unit UnitState, out array<AbilitySetupData> SetupData, optional XComGameState StartState, optional XComGameState_Player PlayerState, optional bool bMultiplayerDisplay)
{

	local int AbilityIndex;
	local X2AbilityTemplateManager AbilityTemplateMan;
	local X2AbilityTemplate AbilityTemplate;
	local AbilitySetupData Data, EmptyData;
	local XComGameState_HeadquartersXCom XComHQ;
	XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	AbilityTemplateMan = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	if(!XComHQ.IsTechResearched('SPARKSuppression') && !XComHQ.IsTechResearched('SPARKCloseCombat'))
		return; // don't bother if we haven't researched either

	if(UnitState.GetMyTemplateName() == 'SparkSoldier' || default.SPARKTemplates.Find(UnitState.GetMyTemplateName()) != INDEX_NONE) //is a spark or a spark supported unit
	{
		AbilityIndex = SetupData.Find('TemplateName', 'RM_Suppression');
		if (AbilityIndex == INDEX_NONE && XComHQ.IsTechResearched('SPARKSuppression'))
		{
			AbilityTemplate = AbilityTemplateMan.FindAbilityTemplate('RM_Suppression');
			Data = EmptyData;
			Data.TemplateName = AbilityTemplate.DataName;
			Data.Template = AbilityTemplate;
			Data.SourceWeaponRef = UnitState.GetItemInSlot(AbilityTemplate.DefaultSourceItemSlot).GetReference();
			SetupData.AddItem(Data);
		}

		AbilityIndex = SetupData.Find('TemplateName', 'RMGrimyCloseCombat');
		if (AbilityIndex == INDEX_NONE && XComHQ.IsTechResearched('SPARKCloseCombat'))
		{
			AbilityTemplate = AbilityTemplateMan.FindAbilityTemplate('RMGrimyCloseCombat');
			Data = EmptyData;
			Data.TemplateName = AbilityTemplate.DataName;
			Data.Template = AbilityTemplate;
			Data.SourceWeaponRef = UnitState.GetItemInSlot(AbilityTemplate.DefaultSourceItemSlot).GetReference();
			SetupData.AddItem(Data);
		}

	}

}