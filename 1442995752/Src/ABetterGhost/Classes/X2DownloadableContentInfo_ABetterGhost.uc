class X2DownloadableContentInfo_ABetterGhost extends X2DownloadableContentInfo;

static event OnPostTemplatesCreated()
{
	local X2AbilityTemplateManager			Mgr;
	local X2AbilityTemplate					Template;
	local X2AbilityTrigger					Trigger;
	local X2AbilityTrigger_EventListener	EventListener;

	Mgr = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	Template = Mgr.FindAbilityTemplate('Channel');
	foreach Template.AbilityTriggers(Trigger)
	{
		EventListener = X2AbilityTrigger_EventListener(Trigger);
		if(none != EventListener)
		{
			`log("Patching Channel",,'ABetterGhost');
			EventListener.ListenerData.EventFn = ChannelLootListener;
			break;
		}
	}
}

static function EventListenerReturn ChannelLootListener(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameState_Unit LooterUnit;
	local XComGameState_Item LootItem;
	local X2FocusLootItemTemplate LootTemplate;
	local XComGameState NewGameState;
	local XComGameState_Effect_TemplarFocus FocusState;

	if (GameState.GetContext().InterruptionStatus != eInterruptionStatus_Interrupt)
	{
		LootItem = XComGameState_Item(EventData);
		LooterUnit = XComGameState_Unit(EventSource);
		LootTemplate = X2FocusLootItemTemplate(LootItem.GetMyTemplate());
		FocusState = LooterUnit.GetTemplarFocusEffectState();
		
		if (LootTemplate != none && FocusState != none)
		{
			NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Channel Focus Pickup");
			LooterUnit = XComGameState_Unit(NewGameState.ModifyStateObject(LooterUnit.Class, LooterUnit.ObjectID));
			FocusState = XComGameState_Effect_TemplarFocus(NewGameState.ModifyStateObject(FocusState.Class, FocusState.ObjectID));
			LooterUnit.RemoveItemFromInventory(LootItem, NewGameState);
			NewGameState.RemoveStateObject(LootItem.ObjectID);

			FocusState.SetFocusLevel(FocusState.FocusLevel + LootTemplate.FocusAmount, LooterUnit, NewGameState);
			NewGameState.GetContext().SetAssociatedPlayTiming(SPT_AfterSequential);
			`TACTICALRULES.SubmitGameState(NewGameState);
		}
	}

	return ELR_NoInterrupt;
}