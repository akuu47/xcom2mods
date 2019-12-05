class X2EventListener_TacticalSuppressors extends X2EventListener config(TacticalSuppressors);

struct AkMapping {
	var name WeaponTemplateName;
	var AnimNotifyEvent AkSoundEvent;
};

struct ProjectileSoundMapping {
	var string ProjectilePathname;
	var string SoundCuePath;
};

var config bool bUseSoundMapping;
var config array<ProjectileSoundMapping> FireSoundMapping;
var config array<ProjectileSoundMapping> DeathSoundMapping;
var config array<AkMapping> AkWeaponMapping;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	if (default.bUseSoundMapping)
	{
		Templates.AddItem(CreateTacticalSuppressorsProjectileOverrideTemplate());
	}

	return Templates;
}

static function CHEventListenerTemplate CreateTacticalSuppressorsProjectileOverrideTemplate()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'TacticalSuppressorsProjectileOverride');

	Template.RegisterInTactical = true;
	
	Template.AddCHEvent('OnProjectileFireSound', OnProjectileFireSound, ELD_Immediate);
	`LOG("Register Event OnProjectileFireSound",, 'TacticalSuppressors');

	return Template;
}

static function EventListenerReturn OnProjectileFireSound(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComLWTuple Tuple;
	local int AbilityContextAbilityRefID;
	local XComGameState_Ability AbilityState;
	local XComGameState_Item SourceWeapon;
	local String ProjectileElementArchetypePath;
	local SoundCue Sound;
	
	Tuple = XComLWTuple(EventData);
	ProjectileElementArchetypePath = Tuple.Data[1].s;
	AbilityContextAbilityRefID = Tuple.Data[2].i;

	AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(AbilityContextAbilityRefID));
	SourceWeapon = AbilityState.GetSourceWeapon();

	`LOG("Event"  @ Event @ "triggered" @ SourceWeapon.GetMyTemplateName(),, 'TacticalSuppressors');

	if (HasSilencerUpgrade(SourceWeapon))
	{
		Sound = FindSound(ProjectileElementArchetypePath);
		`LOG("Event"  @ Event @ "found sound" @ Sound @ "for" @ ProjectileElementArchetypePath,, 'TacticalSuppressors');
		if (Sound != none)
		{
			Tuple.Data[0].o = Sound;
			ToggleAkEvent(SourceWeapon, true);
		}
	}
	else
	{
		ToggleAkEvent(SourceWeapon, false);
	}

	return ELR_NoInterrupt;
}

function static SoundCue FindSound(String ProjectileElementArchetypePath)
{
	local string strKey;
	local int SoundIdx;
	local XComSoundManager SoundMgr;
	local string SoundCuePath;

	SoundIdx = -1;

	
	if (Len(ProjectileElementArchetypePath) > 0)
	{
		SoundIdx = default.DeathSoundMapping.Find('ProjectilePathname', ProjectileElementArchetypePath);

		if (SoundIdx >= 0 && default.DeathSoundMapping[SoundIdx].SoundCuePath != "")
		{
			SoundCuePath = default.DeathSoundMapping[SoundIdx].SoundCuePath;
		}

		if (Len(SoundCuePath) == 0)
		{
			SoundIdx = default.FireSoundMapping.Find('ProjectilePathname', ProjectileElementArchetypePath);

			if (SoundIdx >= 0 && default.FireSoundMapping[SoundIdx].SoundCuePath != "")
			{
				SoundCuePath = default.FireSoundMapping[SoundIdx].SoundCuePath;
			}
		}
	}

	if (Len(SoundCuePath) > 0)
	{
		`LOG(GetFuncName() @ "found" @ SoundCuePath,, 'TacticalSuppressors');
		SoundMgr = `SOUNDMGR;
		SoundIdx = SoundMgr.SoundCues.Find('strKey', SoundCuePath);
		if (SoundIdx >= 0)
		{
			`LOG(GetFuncName() @ "found SoundCue Index" @ SoundIdx,, 'TacticalSuppressors');
			return SoundMgr.SoundCues[SoundIdx].Cue;
		}
	}

	return none;
}


function static ToggleAkEvent(XComGameState_Item SourceWeapon, bool bSilencerUpgrade)
{
	local X2WeaponTemplate WeaponTemplate;
	local XComWeapon WeaponMesh;
	local AnimSequence FoundAnimSeq;
	local array<AnimNotifyEvent> NotifyEventsCopy;
	local AnimNotifyEvent NotifyEvent;
	local AnimNotify Notify;
	local AkMapping AkMapItem;
	local int AkIndex;

	WeaponTemplate = X2WeaponTemplate(SourceWeapon.GetMyTemplate());

	if (WeaponTemplate == none)
		return;

	WeaponMesh = GetXComWeapon(SourceWeapon);

	if (WeaponMesh == none)
		return;

	FoundAnimSeq = SkeletalMeshComponent(WeaponMesh.Mesh).FindAnimSequence('FF_FireA');
	NotifyEventsCopy = FoundAnimSeq.Notifies;
	foreach NotifyEventsCopy(NotifyEvent)
	{
		Notify = NotifyEvent.Notify;
		if (InStr(String(Notify), "AkEvent") >= 0 && bSilencerUpgrade)
		{
			if (FindAkSoundIndex(WeaponTemplate.DataName) == INDEX_NONE)
			{
				AkMapItem.WeaponTemplateName = WeaponTemplate.DataName;
				AkMapItem.AkSoundEvent = NotifyEvent;
				default.AkWeaponMapping.AddItem(AkMapItem);
			}
			`Log("Removing AkEvent" @ String(Notify) @ "for" @ WeaponTemplate.DataName, , 'LWTacticalSuppressors');
			FoundAnimSeq.Notifies.RemoveItem(NotifyEvent);
			break;
		}
	}

	if (!bSilencerUpgrade)
	{
		AkIndex = FindAkSoundIndex(WeaponTemplate.DataName);
		if (AkIndex != INDEX_NONE)
		{
			`Log("Adding AkEvent for" @ WeaponTemplate.DataName, , 'LWTacticalSuppressors');
			FoundAnimSeq.Notifies.AddItem(default.AkWeaponMapping[AkIndex].AkSoundEvent);
			default.AkWeaponMapping.RemoveItem(default.AkWeaponMapping[AkIndex]);
		}
	}
}

function static int FindAkSoundIndex(Name WeaponTemlateName)
{
	return default.AkWeaponMapping.Find('WeaponTemplateName', WeaponTemlateName);
}

static function XComWeapon GetXComWeapon(XComGameState_Item SourceWeaponState)
{
	local XGWeapon WeaponVis;
	local XComWeapon WeaponMeshVis;

	if (SourceWeaponState != none)
	{
		WeaponVis = XGWeapon(SourceWeaponState.GetVisualizer());
		if (WeaponVis != None)
		{
			WeaponMeshVis = WeaponVis.GetEntity();
			if (WeaponMeshVis != None)
			{
				return WeaponMeshVis;
			}
		}
	}

	return none;
}

function static bool HasSilencerUpgrade(XComGameState_Item SourceWeaponState)
{
	local name Upgrade;
	local array<name> SupressorUpgrades;
	local array<name> WeaponUpgrades;
	
	SupressorUpgrades.AddItem('FreeKillUpgrade_Bsc');
	SupressorUpgrades.AddItem('FreeKillUpgrade_Adv');
	SupressorUpgrades.AddItem('FreeKillUpgrade_Sup');

	WeaponUpgrades = SourceWeaponState.GetMyWeaponUpgradeTemplateNames();

	foreach SupressorUpgrades(Upgrade)
	{
		if (WeaponUpgrades.Find(Upgrade) != INDEX_NONE)
		{
			return true;
		}
	}
	return false;
}


