class Musashi_Effect_Silencer extends X2Effect_Persistent config (TacticalSuppressors);

//struct AkMapping {
//	var name WeaponTemplateName;
//	var AnimNotifyEvent AkSoundEvent;
//};
//
//var config bool bUseSoundMapping;
//var config array<ProjectileSoundMapping> SoundMapping;
//var config array<AkMapping> AkWeaponMapping;
//
//simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
//{
//	local XComGameState_Unit UnitState;
//	
//	UnitState = XComGameState_Unit(kNewTargetState);
//	
//	if (UnitState != none)
//	{
//		UnitState.SetUnitFloatValue('SilencerWeapon', 1, eCleanup_BeginTactical);
//		NewGameState.AddStateObject(UnitState);
//	}
//
//	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
//}
//
//function RegisterForEvents(XComGameState_Effect EffectGameState)
//{
//	local X2EventManager EventMgr;
//	local Object EffectObj;
//
//	EventMgr = `XEVENTMGR;
//
//	EffectObj = EffectGameState;
//
//	if (default.bUseSoundMapping)
//	{
//		EventMgr.RegisterForEvent(EffectObj, 'AbilityActivated', class'Musashi_Effect_Silencer'.static.AbilityActivated, ELD_Immediate);
//	}
//}
//
//static function EventListenerReturn AbilityActivated(Object EventData, Object EventSource, XComGameState GameState, Name EventID)
//{
//	local XComGameStateContext_Ability AbilityContext;
//	local XComGameStateHistory History;
//	local XComGameState_Item SourceWeaponState;
//	local XComGameState_Unit PrimaryTargetUnitState, SourceUnitState;
//	local bool bSilencerUpgrade;
//	local ProjectileSoundMapping Mapping;
//
//	History = `XCOMHISTORY;
//	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
//	
//	SourceWeaponState = XComGameState_Item(History.GetGameStateForObjectID(AbilityContext.InputContext.ItemObject.ObjectID));
//	SourceUnitState = XComGameState_Unit(AbilityContext.AssociatedState.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID));
//	PrimaryTargetUnitState = XComGameState_Unit(AbilityContext.AssociatedState.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
//		
//	if (SourceWeaponState != none && PrimaryTargetUnitState.IsEnemyUnit(SourceUnitState))
//	{
//		bSilencerUpgrade = HasSilencerUpgrade(SourceWeaponState);
//
//		ApplySoundConfig(SourceWeaponState, bSilencerUpgrade);
//
//		//if (bSilencerUpgrade)
//		//{
//		//	foreach class'Helpers_LW'.default.ProjectileSounds(Mapping)
//		//	{
//		//		`Log("CURRENT SOUND OVERWRITE" @ Mapping.ProjectileName @ Mapping.FireSoundPath, , 'LWTacticalSuppressors');
//		//	}
//		//}
//	}
//
//	return ELR_NoInterrupt;
//}
//
//function static ApplySoundConfig(XComGameState_Item SourceWeaponState, bool bSilencerUpgrade)
//{
//	local X2UnifiedProjectile ProjectileTemplate;
//	local X2WeaponTemplate WeaponTemplate;
//	local XComWeapon WeaponMesh;
//	local int Index, FireSoundIndex, LWSoundIndex;
//	local Helpers_LW LW2Helper;
//	local ProjectileSoundMapping Mapping;
//	
//	WeaponTemplate = X2WeaponTemplate(SourceWeaponState.GetMyTemplate());
//	WeaponMesh = GetXComWeapon(SourceWeaponState);
//	ProjectileTemplate = WeaponMesh.DefaultProjectileTemplate;
//	
//	if (ProjectileTemplate != none && ProjectileTemplate.ProjectileElements.Length > 0)
//	{
//		ToggleAkEvent(WeaponTemplate, WeaponMesh, bSilencerUpgrade);
//
//		for (Index = 0; Index < 100; ++Index)
//		{		
//			FireSoundIndex = FindFireSoundIndex(string(ProjectileTemplate), Index);
//			LWSoundIndex = FindLWFireSoundIndex(string(ProjectileTemplate), Index);
//
//			if (FireSoundIndex != INDEX_NONE)
//			{
//				LW2Helper = Helpers_LW(class'Engine'.static.FindClassDefaultObject("Helpers_LW"));
//				if (bSilencerUpgrade)
//				{
//					if (LWSoundIndex == INDEX_NONE)
//					{
//						Mapping = default.SoundMapping[FireSoundIndex];
//						Mapping.ProjectileName = ProjectileTemplate $ "_" $ String(Index);
//						LW2Helper.ProjectileSounds.AddItem(Mapping);
//						
//						`Log(WeaponTemplate.DataName @ " ADD sound " @ default.SoundMapping[FireSoundIndex].ProjectileName, , 'LWTacticalSuppressors');
//					}
//				}
//				else
//				{		
//					if (LWSoundIndex != INDEX_NONE)
//					{
//						`Log(WeaponTemplate.DataName @ " REMOVE sound " @ LW2Helper.ProjectileSounds[LWSoundIndex].ProjectileName, , 'LWTacticalSuppressors');
//						LW2Helper.ProjectileSounds.RemoveItem(LW2Helper.ProjectileSounds[LWSoundIndex]);
//					}
//				}
//			}
//		}
//	}
//}
//
//function static ToggleAkEvent(X2WeaponTemplate WeaponTemplate, XComWeapon WeaponMesh, bool bSilencerUpgrade)
//{
//	local AnimSequence FoundAnimSeq;
//	local array<AnimNotifyEvent> NotifyEventsCopy;
//	local AnimNotifyEvent NotifyEvent;
//	local AnimNotify Notify;
//	local AkMapping AkMapItem;
//	local int AkIndex;
//
//	FoundAnimSeq = SkeletalMeshComponent(WeaponMesh.Mesh).FindAnimSequence('FF_FireA');
//	NotifyEventsCopy = FoundAnimSeq.Notifies;
//	foreach NotifyEventsCopy(NotifyEvent)
//	{
//		Notify = NotifyEvent.Notify;
//		if (InStr(String(Notify), "AkEvent") >= 0 && bSilencerUpgrade)
//		{
//			if (FindAkSoundIndex(WeaponTemplate.DataName) == INDEX_NONE)
//			{
//				AkMapItem.WeaponTemplateName = WeaponTemplate.DataName;
//				AkMapItem.AkSoundEvent = NotifyEvent;
//				default.AkWeaponMapping.AddItem(AkMapItem);
//			}
//			`Log("Removing AkEvent" @ String(Notify) @ "for" @ WeaponTemplate.DataName, , 'LWTacticalSuppressors');
//			FoundAnimSeq.Notifies.RemoveItem(NotifyEvent);
//			break;
//		}
//	}
//
//	if (!bSilencerUpgrade)
//	{
//		AkIndex = FindAkSoundIndex(WeaponTemplate.DataName);
//		if (AkIndex != INDEX_NONE)
//		{
//			`Log("Adding AkEvent for" @ WeaponTemplate.DataName, , 'LWTacticalSuppressors');
//			FoundAnimSeq.Notifies.AddItem(default.AkWeaponMapping[AkIndex].AkSoundEvent);
//			default.AkWeaponMapping.RemoveItem(default.AkWeaponMapping[AkIndex]);
//		}
//	}
//}
//
//function static bool HasSilencerUpgrade(XComGameState_Item SourceWeaponState)
//{
//	local SilenceUpgrade Upgrade;
//	local array<name> WeaponUpgrades;
//	
//	WeaponUpgrades = SourceWeaponState.GetMyWeaponUpgradeTemplateNames();
//
//	foreach class'Musashi_Gamestate_Takedown'.default.SilencerUpgrades(Upgrade)
//	{
//		if (WeaponUpgrades.Find(Upgrade.AttachementTemplate) != INDEX_NONE)
//		{
//			return true;
//		}
//	}
//	return false;
//}
//
//function static int FindAkSoundIndex(Name WeaponTemlateName)
//{
//	return default.AkWeaponMapping.Find('WeaponTemplateName', WeaponTemlateName);
//}
//
//function static int FindFireSoundIndex(String ObjectArchetypeName, int Index)
//{
//	local String strKey;
//
//	strKey = ObjectArchetypeName $ "_" $ String(Index);
//
//	return default.SoundMapping.Find('ProjectileName', strKey);
//}
//
//function static int FindLWFireSoundIndex(String ObjectArchetypeName, int Index)
//{
//	local String strKey;
//
//	strKey = ObjectArchetypeName $ "_" $ String(Index);
//
//	return Helpers_LW(class'Engine'.static.FindClassDefaultObject("Helpers_LW")).ProjectileSounds.Find('ProjectileName', strKey);
//}
//
//static function XComWeapon GetXComWeapon(XComGameState_Item SourceWeaponState)
//{
//	local XGWeapon WeaponVis;
//	local XComWeapon WeaponMeshVis;
//
//	if (SourceWeaponState != none)
//	{
//		WeaponVis = XGWeapon(SourceWeaponState.GetVisualizer());
//		if (WeaponVis != None)
//		{
//			WeaponMeshVis = WeaponVis.GetEntity();
//			if (WeaponMeshVis != None)
//			{
//				return WeaponMeshVis;
//			}
//		}
//	}
//
//	return none;
//}