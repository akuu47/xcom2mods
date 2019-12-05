class X2Ability_ItemGrantedAbilitySet_PoweredArmorRebalance extends X2Ability_ItemGrantedAbilitySet config(PoweredArmorRebalance);

var config bool PASSIVE_WALL_PHASING;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	if (default.PASSIVE_WALL_PHASING)
	{
		Templates.AddItem(WallPhasing());
		Templates.AddItem(WraithActivation());
	}

	return Templates;
}

static function X2AbilityTemplate WallPhasing()
{
	local X2AbilityTemplate                     Template;
	local X2Effect_PersistentTraversalChange	WallPhasing;
	local X2Effect_TriggerEvent					ActivationWindowEvent;

	Template= new(None, string('WallPhasing')) class'X2AbilityTemplate'; Template.SetTemplateName('WallPhasing');;;

	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_item_wraith";
	Template.AbilityConfirmSound = "TacticalUI_Activate_Ability_Wraith_Armor";

	Template.AdditionalAbilities.AddItem('WraithActivation');

	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.AbilityToHitCalc = default.DeadEye;

	ActivationWindowEvent = new class'X2Effect_TriggerEvent';
	ActivationWindowEvent.TriggerEventName = default.WraithActivationDurationEventName;
	Template.AddTargetEffect(ActivationWindowEvent);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.bSkipFireAction = true;
	Template.FrameAbilityCameraType = eCameraFraming_Never;
	Template.bSkipPerkActivationActions = true; // we'll trigger related perks as part of the movement action

	WallPhasing = new class'X2Effect_PersistentTraversalChange';
	WallPhasing.BuildPersistentEffect(1, true, true);
	WallPhasing.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true);
	WallPhasing.AddTraversalChange(eTraversal_Phasing, true);
	WallPhasing.EffectName = 'PhasingEffect';
	WallPhasing.DuplicateResponse = eDupe_Refresh;
	Template.AddTargetEffect(WallPhasing);

	return Template;
}

static function X2AbilityTemplate WraithActivation()
{
	local X2AbilityTemplate		Template;
	local X2Effect_Persistent	ActivationDuration;
	local X2AbilityTrigger_EventListener EventListener;

	Template= new(None, string('WraithActivation')) class'X2AbilityTemplate'; Template.SetTemplateName('WraithActivation');;;

	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.AbilitySourceName = 'eAbilitySource_Item';

	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityToHitCalc = default.DeadEye;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.bSkipFireAction = true;
	Template.FrameAbilityCameraType = eCameraFraming_Never;

	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.EventID = default.WraithActivationDurationEventName;
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.Filter = eFilter_Unit;
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.WallPhasingActivation;
	Template.AbilityTriggers.AddItem(EventListener);

	ActivationDuration = new class'X2Effect_Persistent';
	ActivationDuration.BuildPersistentEffect(1, true, true);
	ActivationDuration.EffectName = 'ActivationDuration';
	ActivationDuration.DuplicateResponse = eDupe_Refresh;
	Template.AddTargetEffect(ActivationDuration);

	return Template;
}