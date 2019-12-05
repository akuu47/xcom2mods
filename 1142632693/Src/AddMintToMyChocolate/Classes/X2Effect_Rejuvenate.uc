class X2Effect_Rejuvenate extends X2Effect_Persistent config(GamedataSoldierSkills);

var localized string strRejuvenate_WorldMessage;
var config int RejuvenateBonusHealAmount, RejuvenateBonusWillAmount;

//add a component to XComGameState_Effect to listen for medikit heal being applied
simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Effect_Rejuvenate RejuvenateEffectState;
	local X2EventManager EventMgr;
	local Object ListenerObj;

	EventMgr = `XEVENTMGR;

	if (GetEffectComponent(NewEffectState) == none)
	{
		//create component and attach it to GameState_Effect, adding the new state object to the NewGameState container
		RejuvenateEffectState = XComGameState_Effect_Rejuvenate(NewGameState.CreateStateObject(class'XComGameState_Effect_Rejuvenate'));
		RejuvenateEffectState.InitComponent();
		NewEffectState.AddComponentObject(RejuvenateEffectState);
		NewGameState.AddStateObject(RejuvenateEffectState);
	}

	//add listener to new component effect -- do it here because the RegisterForEvents call happens before OnEffectAdded, so component doesn't yet exist
	ListenerObj = RejuvenateEffectState;
	if (ListenerObj == none)
		return;

	EventMgr.RegisterForEvent(ListenerObj, 'XpHealDamage', RejuvenateEffectState.OnMedikitHeal, ELD_OnStateSubmitted,,,true);
}

simulated function OnEffectRemoved(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState, bool bCleansed, XComGameState_Effect RemovedEffectState)
{
	local XComGameState_BaseObject EffectComponent;
	local Object EffectComponentObj;
	
	super.OnEffectRemoved(ApplyEffectParameters, NewGameState, bCleansed, RemovedEffectState);

	EffectComponent = GetEffectComponent(RemovedEffectState);
	if (EffectComponent == none)
		return;

	EffectComponentObj = EffectComponent;
	`XEVENTMGR.UnRegisterFromAllEvents(EffectComponentObj);

	NewGameState.RemoveStateObject(EffectComponent.ObjectID);
}

static function XComGameState_Effect_Rejuvenate GetEffectComponent(XComGameState_Effect Effect)
{
	if (Effect != none) 
		return XComGameState_Effect_Rejuvenate(Effect.FindComponentObject(class'XComGameState_Effect_Rejuvenate'));
	return none;
}

defaultproperties
{
    DuplicateResponse=eDupe_Ignore
	EffectName="Rejuvenate";
	bRemoveWhenSourceDies=true;
}