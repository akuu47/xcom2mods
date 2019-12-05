class X2DownloadableContentInfo_WOTCRevertOverwatchRules extends X2DownloadableContentInfo;

var config array<name> OVERWATCH_TO_PATCH;

static event OnPostTemplatesCreated()
{
    local X2AbilityTemplateManager			AbilityTemplateManager;
	local X2AbilityTemplate					AbilityTemplate;
	local name								AbilityName;
    local X2AbilityTrigger_Event            Trigger;
	local X2AbilityTrigger_EventListener	TriggerCovFire;

	
	// Locate each ability template
	AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	foreach default.OVERWATCH_TO_PATCH(AbilityName)
	{
		AbilityTemplate = AbilityTemplateManager.FindAbilityTemplate(AbilityName);
		if (AbilityTemplate == none)
		{
			`log("Ability not found:" @ AbilityName,, 'OldOverwatch');
			continue;
		}
		else
		{
			`log("Ability patched:" @ AbilityName,, 'OldOverwatch');
		}
        Trigger = new class'X2AbilityTrigger_Event';
        Trigger.EventObserverClass = class'X2TacticalGameRuleset_MovementObserver';
        Trigger.MethodName = 'InterruptGameState';
        AbilityTemplate.AbilityTriggers.Length = 0;
        AbilityTemplate.AbilityTriggers.AddItem(Trigger);
	}

	// Killzone is special, do it separately
	// Switch to old movement
	AbilityTemplate = AbilityTemplateManager.FindAbilityTemplate('KillZoneShot');
	Trigger = new class'X2AbilityTrigger_Event';
    Trigger.EventObserverClass = class'X2TacticalGameRuleset_MovementObserver';
    Trigger.MethodName = 'InterruptGameState';
    AbilityTemplate.AbilityTriggers.Length = 0;
    AbilityTemplate.AbilityTriggers.AddItem(Trigger);
	//  restore the covering fire style trigger
	TriggerCovFire = new class'X2AbilityTrigger_EventListener';
	TriggerCovFire.ListenerData.EventID = 'AbilityActivated';
	TriggerCovFire.ListenerData.Deferral = ELD_OnStateSubmitted;
	TriggerCovFire.ListenerData.Filter = eFilter_None;
	TriggerCovFire.ListenerData.EventFn = class'XComGameState_Ability'.static.TypicalAttackListener;
	AbilityTemplate.AbilityTriggers.AddItem(TriggerCovFire);
}