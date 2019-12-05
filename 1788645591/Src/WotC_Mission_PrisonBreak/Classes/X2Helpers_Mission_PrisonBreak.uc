class X2Helpers_Mission_PrisonBreak extends Object
	config(GameCore);

static function BuildUIAlert_Mission_PrisonBreak(
	out DynamicPropertySet PropertySet,
	Name AlertName,
	delegate<X2StrategyGameRulesetDataStructures.AlertCallback> CallbackFunction,
	Name EventToTrigger,
	string SoundToPlay,
	bool bImmediateDisplay)
{
	class'X2StrategyGameRulesetDataStructures'.static.BuildDynamicPropertySet(PropertySet, 'UIAlert_Mission_PrisonBreak', AlertName, CallbackFunction, bImmediateDisplay, true, true, false);
	class'X2StrategyGameRulesetDataStructures'.static.AddDynamicNameProperty(PropertySet, 'EventToTrigger', EventToTrigger);
	class'X2StrategyGameRulesetDataStructures'.static.AddDynamicStringProperty(PropertySet, 'SoundToPlay', SoundToPlay);
}

static function ShowMissionPrisonBreakPopup(XComGameState_MissionSite MissionState, optional bool bInstant = false)
{
	local XComHQPresentationLayer Pres;
	local XComGameState_ResistanceFaction FactionState;
	local DynamicPropertySet PropertySet;

	Pres = `HQPRES;
	FactionState = MissionState.GetResistanceFaction();

	BuildUIAlert_Mission_PrisonBreak(PropertySet, 'eAlert_PrisonBreakMissionAvailable', Pres.RescueSoldierAlertCB, 'OnRescueSoldierPopup', FactionState.GetFanfareEvent(), true);
	class'X2StrategyGameRulesetDataStructures'.static.AddDynamicIntProperty(PropertySet, 'MissionRef', MissionState.ObjectID);
	class'X2StrategyGameRulesetDataStructures'.static.AddDynamicIntProperty(PropertySet, 'FactionRef', FactionState.ObjectID);
	class'X2StrategyGameRulesetDataStructures'.static.AddDynamicBoolProperty(PropertySet, 'bInstantInterp', bInstant);
}