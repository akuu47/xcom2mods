class X2Effect_HyperReactiveRounds extends X2Effect_Persistent;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local RM_XComGameState_Effect_LastShotDetails	LastShotDetails;
	local X2EventManager						EventMgr;
	local Object								ListenerObj;
	local XComGameState_Unit					UnitState;

	EventMgr = `XEVENTMGR;
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(NewEffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

	if (GetLastShotDetails(NewEffectState) == none)
	{
		LastShotDetails = RM_XComGameState_Effect_LastShotDetails(NewGameState.CreateStateObject(class'RM_XComGameState_Effect_LastShotDetails'));
		LastShotDetails.InitComponent();
		NewEffectState.AddComponentObject(LastShotDetails);
		NewGameState.AddStateObject(LastShotDetails);
	}
	ListenerObj = LastShotDetails;
	if (ListenerObj == none)
	{
		`Redscreen("LSD: Failed to find LSD Component when registering listener");
		return;
	}
    EventMgr.RegisterForEvent(ListenerObj, 'AbilityActivated', LastShotDetails.RecordShot, ELD_OnStateSubmitted, 50, UnitState);
}

static function RM_XComGameState_Effect_LastShotDetails GetLastShotDetails(XComGameState_Effect Effect)
{
	if (Effect != none) 
		return RM_XComGameState_Effect_LastShotDetails (Effect.FindComponentObject(class'RM_XComGameState_Effect_LastShotDetails'));
	return none;
}

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local XComGameState_Item						SourceWeapon;
    local ShotModifierInfo							ShotInfo;
	local RM_XComGameState_Effect_LastShotDetails		LastShot;

	if (XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID)) == none)
		return;
	if (AbilityState == none)
		return;
	LastShot = GetLastShotDetails(EffectState);
	if (!LastShot.b_AnyShotTaken)
		return;
    SourceWeapon = AbilityState.GetSourceWeapon();    
	if (SourceWeapon == Attacker.GetItemInSlot(eInvSlot_PrimaryWeapon))
	{
		if ((SourceWeapon != none) && (Target != none))
		{
			if (!LastShot.b_LastShotHit)
			{
				ShotInfo.ModType = eHit_Success;
				ShotInfo.Reason = FriendlyName;
				ShotInfo.Value = class'RM_SPARKTechs_Helpers'.default.SelfAimBonus;
				ShotModifiers.AddItem(ShotInfo);
			}
        }
    }    
}

defaultproperties
{
    DuplicateResponse=eDupe_Refresh
    EffectName="HyperReactiveRounds"
}