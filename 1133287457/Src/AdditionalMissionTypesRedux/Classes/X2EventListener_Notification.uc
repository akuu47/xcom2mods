class X2EventListener_Notification extends X2EventListener;

var localized string LootNotifyTitle;
var localized string LootNotify;

var localized string OperativeNotifyTitle;
var localized string OperativeNotify;

var localized string IntelNotifyTitle;
var localized string IntelNotify;


static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(AddLootNotify() );
	Templates.AddItem(AddBonusIntelReward()); //neutralize avatar VIP reward
	Templates.AddItem(AddBonusLootReward()); //operative escort reward

	return Templates;
}

static function X2EventListenerTemplate AddBonusIntelReward()
{
	local X2EventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'X2EventListenerTemplate', Template, 'AMTBonusIntel');
	Template.RegisterInTactical = true;
	Template.AddEvent('UnitEvacuated', WasAvatarVIP);

	return Template;
}

static protected function EventListenerReturn WasAvatarVIP(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameState_Unit KilledUnit;
	local XComGameState_BattleData BattleData;
	local XComPresentationLayer Presentation;
	local XGParamTag kTag;
	local XComGameState NewGameState;
	//local XComGameState_MissionSite MissionState;
	local string MissionType;

	KilledUnit = XComGameState_Unit(EventSource);
	BattleData = XComGameState_BattleData( `XCOMHISTORY.GetSingleGameStateObjectForClass( class'XComGameState_BattleData' ) );
	//MissionState = XComGameState_MissionSite(`XCOMHistory.GetGameStateForObjectID(BattleData.m_iMissionID));
	// bad data somewhere
	if ((BattleData == none) || (KilledUnit == none))
		return ELR_NoInterrupt;

	MissionType = BattleData.MapData.ActiveMission.sType;
	if(MissionType != "RM_Sabotage_Neutralize")
		return ELR_NoInterrupt;

	// ignore everybody that leaves the field that isn't a dark vip, or is not alive.
	if (!KilledUnit.IsAlive() || KilledUnit.GetMyTemplateName() != 'HostileVIPCivilian')
		return ELR_NoInterrupt;

	if(KilledUnit.IsAlive()) //successful capture or extraction by XCOM of a hostile unit
	{

		Presentation = `PRES;
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Adding Hybrid Unit");
		GiveIntelToXCOM(NewGameState, KilledUnit);
		`GAMERULES.SubmitGameState(NewGameState);

		kTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
		kTag.StrValue0 = KilledUnit.GetName(eNameType_Full);

		Presentation.NotifyBanner(default.IntelNotifyTitle, "img:///UILibrary_XPACK_Common.WorldMessage", KilledUnit.GetName(eNameType_Full), `XEXPAND.ExpandString(default.IntelNotify),  eUIState_Good);

		`SOUNDMGR.PlayPersistentSoundEvent("UI_Blade_Positive");


	}

	return ELR_NoInterrupt;
}


static function GiveIntelToXCOM(XComGameState NewGameState, XComGameState_Unit CapturedUnit)
{
	local XComGameStateHistory History; 
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Reward RewardState;
	local X2RewardTemplate RewardTemplate;
	local XComGameState_HeadquartersResistance ResHQ;
	local X2StrategyElementTemplateManager StratMgr;

	History = `XCOMHistory;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	XComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
	ResHQ = class'UIUtilities_Strategy'.static.GetResistanceHQ();
	StratMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();

	RewardTemplate = X2RewardTemplate(StratMgr.FindStrategyElementTemplate('Reward_Intel'));
	RewardState = RewardTemplate.CreateInstanceFromTemplate(NewGameState);
	RewardState.GenerateReward(NewGameState, ResHQ.GetMissionResourceRewardScalar(RewardState));

	RewardState.GiveReward(NewGameState);


}

static function X2EventListenerTemplate AddBonusLootReward()
{
	local X2EventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'X2EventListenerTemplate', Template, 'AMTBonusLoot');
	Template.RegisterInTactical = true;
	Template.AddEvent('RM_OperativeSurvived', WasOperative); //event fired from kismet

	return Template;
}

static protected function EventListenerReturn WasOperative(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameState_Unit KilledUnit;
	local XComPresentationLayer Presentation;
	local XGParamTag kTag;
	local XComGameState NewGameState;

	KilledUnit = XComGameState_Unit(EventSource);

	if(KilledUnit == none)
		KilledUnit = GenerateTempUnit(GameState);

	Presentation = `PRES;
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Adding Hybrid Unit");
	GiveLootToXCOM(NewGameState, KilledUnit);
	`GAMERULES.SubmitGameState(NewGameState);

	kTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	kTag.StrValue0 = KilledUnit.GetMyTemplate().strCharacterName;

	Presentation.NotifyBanner(default.OperativeNotifyTitle, "img:///UILibrary_XPACK_Common.WorldMessage", KilledUnit.GetMyTemplate().strCharacterName, `XEXPAND.ExpandString(default.OperativeNotify),  eUIState_Good);

	`SOUNDMGR.PlayPersistentSoundEvent("UI_Blade_Positive");


	
	return ELR_NoInterrupt;
}

static function XComGameState_Unit GenerateTempUnit(XComGameState StartState)
{
	local X2CharacterTemplate Template;
	local XComGameState_Unit SoldierState;

	Template = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager().FindCharacterTemplate('ResistanceOperative');

	SoldierState = Template.CreateInstanceFromTemplate(StartState);

	return SoldierState;
}

static function GiveLootToXCOM(XComGameState NewGameState, XComGameState_Unit CapturedUnit)
{
	local XComGameStateHistory History; 
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Reward RewardState;
	local X2RewardTemplate RewardTemplate;
	local XComGameState_HeadquartersResistance ResHQ;
	local X2StrategyElementTemplateManager StratMgr;

	History = `XCOMHistory;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	XComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
	ResHQ = class'UIUtilities_Strategy'.static.GetResistanceHQ();
	StratMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();

	RewardTemplate = X2RewardTemplate(StratMgr.FindStrategyElementTemplate('Reward_Intel'));
	RewardState = RewardTemplate.CreateInstanceFromTemplate(NewGameState);
	RewardState.GenerateReward(NewGameState, ResHQ.GetMissionResourceRewardScalar(RewardState));

	RewardState.GiveReward(NewGameState);


}

static function X2EventListenerTemplate AddLootNotify()
{
	local X2EventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'X2EventListenerTemplate', Template, 'AMTLootNotify');
	Template.RegisterInTactical = true;
	Template.AddEvent('UnitEvacuated', WasCivilian);

	return Template;
}


static protected function EventListenerReturn WasCivilian(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameState_Unit KilledUnit;
	local XComGameState_BattleData BattleData;
	local XComPresentationLayer Presentation;
	local XGParamTag kTag;
	local string MissionType;

	KilledUnit = XComGameState_Unit(EventSource);
	BattleData = XComGameState_BattleData( `XCOMHISTORY.GetSingleGameStateObjectForClass( class'XComGameState_BattleData' ) );

	// bad data somewhere
	if ((BattleData == none) || (KilledUnit == none))
		return ELR_NoInterrupt;

	MissionType = BattleData.MapData.ActiveMission.sType;
	if(MissionType != "TerrorEscape")
		return ELR_NoInterrupt;

	// ignore everybody that leaves the field that isn't a civilian
	if (!KilledUnit.IsCivilian())
		return ELR_NoInterrupt;


	if(KilledUnit.IsAlive()) //successful civilian evac on terror escape, so make the notification
	{
		kTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
		kTag.StrValue0 = KilledUnit.GetName(eNameType_Full);

		Presentation = `PRES;

		Presentation.NotifyBanner(default.LootNotifyTitle, "img:///UILibrary_XPACK_Common.WorldMessage", KilledUnit.GetName(eNameType_Full), `XEXPAND.ExpandString(default.LootNotify),  eUIState_Good);

		`SOUNDMGR.PlayPersistentSoundEvent("UI_Blade_Positive");

	
	}

	return ELR_NoInterrupt;
}


