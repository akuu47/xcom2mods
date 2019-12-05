class X2EventListener_HybridCapture extends X2EventListener config(RM_Hybrid);

var localized string JoinedXCOMTitle;
var localized string JoinedXCOM;

var localized string LootTitle;
var localized string Loot;

var config int NormalChance;
var config int FriendlyChance;
var config int InjuryBonus;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(AddAdventCapture() );
	Templates.AddItem(OverrideEC());

	return Templates;
}

static function X2EventListenerTemplate AddAdventCapture()
{
	local X2EventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'X2EventListenerTemplate', Template, 'HybridCaptureEvent');
	Template.RegisterInTactical = true;
	Template.AddEvent('UnitRemovedFromPlay', WasAdvent);

	return Template;
}

static function X2EventListenerTemplate OverrideEC()
{
	local X2EventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'X2EventListenerTemplate', Template, 'RMHybridsOverride');
	Template.RegisterInTactical = true;
	Template.AddEvent('ExtractCorpses_AwardLoot', ShouldOverride);

	return Template;
}

static protected function EventListenerReturn ShouldOverride(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameState_Unit KilledUnit;
	local XComGameState_BattleData BattleData;
	local XComLWTuple Tuple;

	Tuple = XComLwTuple(EventData);
	KilledUnit = XComGameState_Unit(EventSource);
	BattleData = XComGameState_BattleData( `XCOMHISTORY.GetSingleGameStateObjectForClass( class'XComGameState_BattleData' ) );
	// bad data somewhere
	if ((BattleData == none) || (KilledUnit == none) || (Tuple == none))
		return ELR_NoInterrupt;

	// ignore everybody that leaves the field that isn't advent
	if (KilledUnit.IsSoldier() || !KilledUnit.IsAdvent() || KilledUnit.GetMyTemplate().CharacterGroupName == 'DarkXComSoldier') //added MOCX exclusion
		return ELR_NoInterrupt;

	if(KilledUnit.IsAlive() && (KilledUnit.GetTeam() == eTeam_XCom || KilledUnit.bBodyRecovered))
	{
		if(Tuple.Id == 'ExtractCorpses_AwardLoot')	
			Tuple.Data[0].b = false;  //we'll handle this unit ourselves
			return ELR_NoInterrupt;
	}

	return ELR_NoInterrupt;
}


static protected function EventListenerReturn WasAdvent(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameState_Unit KilledUnit, RewardUnit;
	local XComGameState_BattleData BattleData;
	local XComPresentationLayer Presentation;
	local XGParamTag kTag;
	local int CaptureChance, Roll, Injury;
	local XComGameState NewGameState;
	local Name LootTemplateName;
	local LootResults PendingAutoLoot;
	local int LootIndex;
	local X2ItemTemplateManager ItemTemplateManager;
	local XComGameState_Item ItemState;
	local X2ItemTemplate ItemTemplate;
	local XComGameState_HeadquartersXCom XComHQ;
	local array<Name> RolledLoot;

	KilledUnit = XComGameState_Unit(EventSource);
	BattleData = XComGameState_BattleData( `XCOMHISTORY.GetSingleGameStateObjectForClass( class'XComGameState_BattleData' ) );
	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	CaptureChance = 0;
	// bad data somewhere
	if ((BattleData == none) || (KilledUnit == none))
		return ELR_NoInterrupt;

	// ignore everybody that leaves the field that isn't advent
	if (KilledUnit.IsSoldier() || !KilledUnit.IsAdvent() || KilledUnit.GetMyTemplate().CharacterGroupName == 'DarkXComSoldier') //added MOCX exclusion
		return ELR_NoInterrupt;


	if(KilledUnit.IsAlive() && (KilledUnit.GetTeam() == eTeam_XCom || KilledUnit.bBodyRecovered) ) //successful advent capture by XCOM, OR a friendly ADVENT unit evacing
	{
		CaptureChance = default.NormalChance;

		if(KilledUnit.GetTeam() == eTeam_XCom) //if they were on XCOM's side, presume friendly
			CaptureChance = default.FriendlyChance;

		Injury = (KilledUnit.HighestHP - KilledUnit.LowestHP) * default.InjuryBonus; //so 12 - 1 = 11, for instance

		CaptureChance += Injury;

		Roll = class'Engine'.static.GetEngine().SyncRand(100, "RollForAdventCapture");

		if(Roll < CaptureChance)
		{
			NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Adding Hybrid Unit");
			GiveSoldierToXCOM(NewGameState, BattleData.GetForceLevel(), KilledUnit, RewardUnit);
		
			`GAMERULES.SubmitGameState(NewGameState);

			kTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
			kTag.StrValue0 = RewardUnit.GetName(eNameType_Full);

			Presentation = `PRES;

			Presentation.NotifyBanner(default.JoinedXCOMTitle, "img:///UILibrary_XPACK_Common.WorldMessage", RewardUnit.GetName(eNameType_Full), `XEXPAND.ExpandString(default.JoinedXCOM),  eUIState_Good);

			`SOUNDMGR.PlayPersistentSoundEvent("UI_Blade_Positive");

		}

		if(Roll >= CaptureChance)
		{

			class'X2LootTableManager'.static.GetLootTableManager().RollForLootCarrier(KilledUnit.GetMyTemplate().Loot, PendingAutoLoot);

			if( PendingAutoLoot.LootToBeCreated.Length > 0 )

			{

				foreach PendingAutoLoot.LootToBeCreated(LootTemplateName)

				{

					ItemTemplate = ItemTemplateManager.FindItemTemplate(LootTemplateName);

					RolledLoot.AddItem(ItemTemplate.DataName);

				}



			}

			PendingAutoLoot.LootToBeCreated.Remove(0, PendingAutoLoot.LootToBeCreated.Length);

			PendingAutoLoot.AvailableLoot.Remove(0, PendingAutoLoot.AvailableLoot.Length);


			NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Award ExtractCorpses Loot");
			XComHQ = XComGameState_HeadquartersXCom(`XCOMHistory.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
			XComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));

			for( LootIndex = 0; LootIndex < RolledLoot.Length; ++LootIndex )

			{

				`log(" - " @ String(RolledLoot[LootIndex]));

				// create the loot item

				ItemState = ItemTemplateManager.FindItemTemplate(RolledLoot[LootIndex]).CreateInstanceFromTemplate(NewGameState);
				NewGameState.AddStateObject(ItemState);

				// assign the XComHQ as the new owner of the item
				ItemState.OwnerStateObject = XComHQ.GetReference();

				// add the item to the HQ's inventory of loot items
				XComHQ.PutItemInInventory(NewGameState, ItemState, true);

			}
			GiveLootToXCOM(NewGameState, KilledUnit, XComHQ);
			`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
		}
	}

	return ELR_NoInterrupt;
}


static function GiveSoldierToXCOM(XComGameState NewGameState, int ForceLevel, XComGameState_Unit RetrievedUnit, out XComGameState_Unit ReferenceState)
{
	local XComGameStateHistory History; 
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_HeadquartersResistance ResistanceHQ;
	local X2CharacterTemplateManager CharTemplateMgr;
	local X2CharacterTemplate CharacterTemplate;
    local XComGameState_Unit UnitState;
	local int idx, NewRank, StartingIdx, PreviousGender;

	History = `XCOMHistory;
	CharTemplateMgr = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();
	CharacterTemplate = CharTemplateMgr.FindCharacterTemplate('RM_HybridSoldier'); //we know all soldiers we'll be getting are human only
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	XComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));

	GiveLootToXCOM(NewGameState, RetrievedUnit, XComHQ);
	ResistanceHQ = XComGameState_HeadquartersResistance(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersResistance'));

	// Create the new unit and make sure she has the best gear available (will also update to appropriate armor customizations)
	UnitState = `CHARACTERPOOLMGR.CreateCharacter(NewGameState, eCPSM_RandomOnly, CharacterTemplate.DataName); 
	//we set this to random only so we avoid issues where the game doesn't think a character has been used. We're copying appearance data from the advent taken anyway.
	UnitState.RandomizeStats();
	
	PreviousGender = UnitState.kAppearance.iGender;
	UnitState.kAppearance.iGender = RetrievedUnit.kAppearance.iGender; //gender is always set on advent units
	
	if(RetrievedUnit.GetFirstName() != "")
	{
		UnitState.SetUnitName(RetrievedUnit.GetFirstName(), RetrievedUnit.GetLastName(), "");
	}

	if(PreviousGender != UnitState.kAppearance.iGender)
		FixAppearance(UnitState, NewGameState); //we fix the appearance since we changed genders;

	// set appearance first before we do anything else
	UnitState.ApplyInventoryLoadout(NewGameState);
	NewRank = (Forcelevel / 5); //max level of lieutenant

	if(NewRank < 1)
		NewRank = 1;

	UnitState.SetXPForRank(NewRank);
	UnitState.StartingRank = NewRank;
	StartingIdx = 0;

	if(UnitState.GetMyTemplate().DefaultSoldierClass != '' && UnitState.GetMyTemplate().DefaultSoldierClass != class'X2SoldierClassTemplateManager'.default.DefaultSoldierClass)
	{
		// Some character classes start at squaddie on creation
		StartingIdx = 1;
	}

	for (idx = StartingIdx; idx < NewRank; idx++)
	{
		// Rank up to squaddie
		if (idx == 0)
		{

			UnitState.RankUpSoldier(NewGameState, ResistanceHQ.SelectNextSoldierClass());
			

			UnitState.ApplySquaddieLoadout(NewGameState);
			UnitState.bNeedsNewClassPopup = false;
		}
		else
		{
			UnitState.RankUpSoldier(NewGameState, UnitState.GetSoldierClassTemplate().DataName);
		}
	}
	UnitState.ApplyBestGearLoadout(NewGameState);
	UnitState.SetStatus(eStatus_Active);
	UnitState.bNeedsNewClassPopup = false;

	XComHQ.AddToCrew(NewGameState, UnitState);

	UnitState.SetCurrentStat(eStat_Will, RetrievedUnit.GetCurrentStat(eStat_Will));
	UnitState.SetCurrentStat(eStat_HP, RetrievedUnit.GetCurrentStat(eStat_HP));
	//UnitState.AddXp(MissionUnitState.GetXPValue() - UnitState.GetXPValue());
	//UnitState.CopyKills(MissionUnitState);
	//UnitState.CopyKillAssists(MissionUnitState);
	UnitState.LowestHP = RetrievedUnit.LowestHP;
	UnitState.HighestHP = RetrievedUnit.HighestHP;
	UnitState.bRankedUp = false;
	ReferenceState = UnitState;


}


static function GiveLootToXCOM(XComGameState NewGameState, XComGameState_Unit CapturedUnit, XComGameState_HeadquartersXCom XComHQ)
{
	local X2ItemTemplateManager ItemTemplateManager;
	local X2ItemTemplate ItemTemplate;
	local XComGameState_Item LootItem;
	local name LootName;
	local XComPresentationLayer Presentation;

	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();


	if(CapturedUnit.HasLoot()) //we have normal loot. Since this isn't recovered by extract corpses, we do it ourselves.
	{
		foreach CapturedUnit.PendingLoot.LootToBeCreated(LootName)
		{	
			ItemTemplate = ItemTemplateManager.FindItemTemplate(LootName);
			if (ItemTemplate != none)
			{
				if (CapturedUnit.bKilledByExplosion && !ItemTemplate.LeavesExplosiveRemains) //this shouldn't even proc, but just in case....
					continue;                                                                               //  item leaves nothing behind due to explosive death

				if (CapturedUnit.bKilledByExplosion && ItemTemplate.ExplosiveRemains != '')
					ItemTemplate = ItemTemplateManager.FindItemTemplate(ItemTemplate.ExplosiveRemains);     //  item leaves a different item behind due to explosive death
			
				if (ItemTemplate != none)
				{
				
					LootItem = ItemTemplate.CreateInstanceFromTemplate(NewGameState);

					LootItem.OwnerStateObject = XComHQ.GetReference();
					XComHQ.PutItemInInventory(NewGameState, LootItem, true);
	
				}
			}

		}
		class'XComGameState_Unit_DumbExtension'.static.RemoveAllLoot(CapturedUnit); // so this doesn't get duplicated

		Presentation = `PRES;

		Presentation.NotifyBanner(default.LootTitle, "img:///UILibrary_XPACK_Common.WorldMessage", CapturedUnit.GetName(eNameType_Full), default.Loot,  eUIState_Good);

		`SOUNDMGR.PlayPersistentSoundEvent("UI_Blade_Positive");
	}


}


static function FixAppearance(XComGameState_Unit UnitState, XComGameState NewGameState)
{
	local TSoldier CharacterGeneratorResult;
	local XGCharacterGenerator CharacterGenerator;

	CharacterGenerator = `XCOMGRI.Spawn(UnitState.GetMyTemplate().CharacterGeneratorClass);
	CharacterGeneratorResult = CharacterGenerator.CreateTSoldierFromUnit(UnitState, NewGameState);

	UnitState.SetTAppearance(CharacterGeneratorResult.kAppearance);

	CharacterGenerator.Destroy(); //don't keep this longer than we need to
}