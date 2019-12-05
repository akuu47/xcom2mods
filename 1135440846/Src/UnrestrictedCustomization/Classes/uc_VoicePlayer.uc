///
/// Wwise events copied from txt files found within XCOM 2\XComGame\CookedPCConsole
/// Cue events copied from XComCharacterVoiceBank
///
class uc_VoicePlayer extends UiDataStore;

`define ClassName uc_VoicePlayer
`include( UnrestrictedCustomization\Src\UnrestrictedCustomization\macros.uci )

//======================================================================================================================
// FIELDS

const MaxVoiceSpeechTries = 10;

var private array<name> CueSoundEvents;
var private array<string> SoldierWwiseSoundEvents;
var private array<string> SparkWwiseSoundEvents;
var private array<string> BradfordWwiseSoundEvents;
var private array<string> ShenWwiseSoundEvents;
var private array<string> ReaperWwiseSoundEvents;
var private array<string> TemplarWwiseSoundEvents;
var private array<string> SkirmisherWwiseSoundEvents;

var private array<string> LoadedVoicePaths;
var private int PreviousAkSoundId;
var private AudioComponent PreviousAudioComponent;

//======================================================================================================================
// CTOR

public static function uc_VoicePlayer GetInstance() {
	return uc_VoicePlayer( class'xmf_SingletonStore'.static.GetInstance(class'uc_VoicePlayer') ).Init();
}

private function uc_VoicePlayer Init() {
	return self;
}

//======================================================================================================================
// METHODS


private function XComCharacterVoice LoadVoice( coerce string _archetypeName ) {
	local XComContentManager _contentMgr;
	local XComCharacterVoice _voice;
	
	_contentMgr = XComContentManager( class'Engine'.static.GetEngine().GetContentManager() );
	_voice = XComCharacterVoice( _contentMgr.RequestGameArchetype(_archetypeName, , , false) );

	// Unlike vanilla, do not uncache voice just yet, or it may stops the sound while it's still playing.
	// AFAIK it happens only when cache is cleaned (every 20sec or so), 
	// but since preview sounds can now be much longer than "yes sir" ; "running" ; etc. this bug is now obvious.
	if( LoadedVoicePaths.Find( PathName(_voice) ) > -1 ) {
		LoadedVoicePaths.AddItem( PathName(_voice) );
	}

	return _voice;
}

///
/// Must be called when voice selection is over.
///
public function DisposeLoadedVoices() {
	local XComContentManager _contentMgr;
	local string _path;
	_contentMgr = XComContentManager( class'Engine'.static.GetEngine().GetContentManager() );
	foreach LoadedVoicePaths(_path) {
		_contentMgr.UnCacheObject( _path );
	}
	LoadedVoicePaths.Length = 0;
}

///
/// Plays a random sound from given voice.
///
public function PlayRandomSoundPreview( coerce string _archetypeName ) {
	local SoundCue _sound;
	local int i;
	local string _wwiseSoundEvent;
	local array<string> _wwiseSoundEventBank;
	local XComCharacterVoice _voice;
	local Actor _actor;

	_voice = LoadVoice(_archetypeName);

	_actor = class'uc_Customizer'.static.GetPawn();
	StopSoundPreviews(_actor);

	if( _voice.akBankId != 0 ) {
		// Wwise voice
		switch( Left(_voice.AkBankName,2) ) {
			case "SP": _wwiseSoundEventBank = SparkWwiseSoundEvents; break;
			case "CE": _wwiseSoundEventBank = BradfordWwiseSoundEvents; break;
			case "SH": _wwiseSoundEventBank = ShenWwiseSoundEvents; break;
			case "RP": _wwiseSoundEventBank = ReaperWwiseSoundEvents; break;
			case "TP": _wwiseSoundEventBank = TemplarWwiseSoundEvents; break;
			case "SK": _wwiseSoundEventBank = SkirmisherWwiseSoundEvents; break;
			case "SF": case "SM": _wwiseSoundEventBank = SoldierWwiseSoundEvents; break;
		}

		if( _wwiseSoundEventBank.Length > 0 ) {
			_wwiseSoundEvent = _wwiseSoundEventBank[ Rand(_wwiseSoundEventBank.Length) ];
		}else {
			_wwiseSoundEvent = _voice.AkCustomizationEventName;
		}

		PreviousAkSoundId = _actor.PlayAkSound(
			"Play_" $ _voice.AkBankName $ "_" $ _wwiseSoundEvent
		);
		`vlogvar(_wwiseSoundEvent);
	}
	else {
		// Cue voice
		_voice.StreamNextVoiceBank(true);
		for( i=0; i<MaxVoiceSpeechTries; i++ ) {
			_sound = _voice.GetSoundCue( CueSoundEvents[ Rand(CueSoundEvents.Length) ] );
			if( _sound != none ) break;
		}
		if( _sound != none ) {
			PreviousAudioComponent = _actor.CreateAudioComponent( _sound, true, true, false );
		}else {
			_voice.PlaySoundForEvent('Dashing', _actor);
		}
	}
}

///
/// Stops sound previews...
///
private function StopSoundPreviews( Actor _actor ) {
	if( PreviousAkSoundId != INDEX_NONE) {
		_actor.StopAkSound(PreviousAkSoundId);
		PreviousAkSoundId = INDEX_NONE;
	}
	if( PreviousAudioComponent != none ) {
		PreviousAudioComponent.Stop();
		PreviousAudioComponent = none;
	}
}


//======================================================================================================================
defaultProperties // '{' in separate line or defaultProperties will be ignored !
{
	Tag = UnrestrictedCustomization_uc_VoicePlayer

	CueSoundEvents = (HunkerDown, Reload, Overwatching, Moving, Dashing, JetPackMove, LowAmmo, OutOfAmmo, Suppressing, AreaSuppressing, FlushingTarget, HealingAlly, StabilizingAlly, RevivingAlly, CombatStim, FragOut, SmokeGrenadeThrown, SpyGrenadeThrown, FiringRocket, GhostModeActivated, JetPackDeactivated, ArcThrower, RepairSHIV, Kill, MultiKill, Missed, TargetSpotted, TargetSpottedHidden, HeardSomething, TakingFire, FriendlyKilled, Panic, PanickedBreathing, Wounded, Died, Flanked, Suppressed, PsiControlled, CivilianRescued, RunAndGun, GrapplingHook, AlienRetreat, AlienMoving, AlienNotStunned, AlienReinforcements, AlienSighting, DisablingShot, ShredderRocket, PsionicsMindfray, PsionicsPanic, PsionicsInspiration, PsionicsTelekineticField, SoldierControlled, StunnedAlien, Explosion, RocketScatter, PsiRift, Poisoned, HiddenMovement, HiddenMovementVox, ExaltChatter, Strangled, CollateralDamage, ElectroPulse, Flamethrower, JetBoots, KineticStrike, OneForAll, ProximityMine, SoldierVIP, UsefulVIP, GenericVIP, HostileVIP, EngineerScienceVIP);
	SoldierWwiseSoundEvents = (UsefulVIP_COLD, HaywireProtocol, GenericSighting, ObjectFireSpreading, ConcealedSpotted, Panic_TWITCHY, ObjectiveSighted, AttemptingHack, AlienReinforcements, DefensiveProtocol, LootCaptured_COLD, FanFire, HealingAlly, ThroughTheWall, Reloading, AlienMoving_w, LootCaptured_INTENSE, RevivingAlly, TargetKilled_BY_THE_BOOK, VIPsighted, AmmoOut, Acid, UsefulVIP_TWITCHY, StabilizingAlly, ShredderGun, NullShield, ActivateConcealment, RunAndGun, EvacHeavyLosses, ItemCollected, Dashing_w, LootSpotted_INTENSE, GenericHackAttempt, DeathScream, LootSpotted_HAPPY_GO_LUCKY, SoldierVIP_LAID_BACK, TargetKilled_HAPPY_GO_LUCKY, AlienNotStunned, HackWorkstation_HAPPY_GO_LUCKY, Domination, HackUnitFailed, HackAdventTower, GenericVIP_BY_THE_BOOK, CivilianSighted_w, PickingUpBody_TWITCHY, PickingUpBody_HAPPY_GO_LUCKY, Reaper, HunkerDown, ThrowFlashbang, HostileVIP_BY_THE_BOOK, HackTurretFailed, VoidRift, EVAC, SoldierVIP_HARD_LUCK, Confused, AlienFacilitySighted, AlienMoving, Moving_INTENSE, UsefulVIP_HARD_LUCK, TargetKilled_COLD, TargetKilled_LAID_BACK, HackDoorSuccess, Dashing, CapacitorDischarge, PickingUpBody_COLD, StunnedAlien, HackUnitSuccess, StunTarget, Poison, NullLance, Moving_TWITCHY, ThrowGrenade, HostileVIP, ObjectiveSighted_w, HackWorkstation_HARD_LUCK, SoldierVIP_COLD, Moving_COLD, Flamethrower, BleedingOut, TargetHeard_w, LootSpotted_BY_THE_BOOK, LootCaptured_HAPPY_GO_LUCKY, EvacSomeLosses, SquadConcealmentBroken, PlasmaBlaster, MultipleTargetsKilled, TrippedBurrow_w, LootSpotted, TargetEliminated_HAPPY_GO_LUCKY, KillZone, Dodge, TakingDamage, CriticalFeedback, UsefulVIP_HAPPY_GO_LUCKY, AlienRetreat, ObjectOnFire, RestorativeMist, CivilianSighted, EVACrequest, GenericHackSuccess, DroppingBody, GenericVIP_COLD, VIPRescueComplete, HoldTheLine_w, GenericVIP_HAPPY_GO_LUCKY, ADVENTSighting, ArmorHit, SaturationFire, SoldierFlanked, HackTurret, PickingUpBody_BY_THE_BOOK, Panic_HAPPY_GO_LUCKY, LootSpotted_HARD_LUCK, VIPRescueInProgress, TargetHeard, HackWorkstationSuccess, SoldierSuppressed, Mindblast, OverWatch, BlasterLauncher, HostileVIP_INTENSE, TargetKilled, LootCaptured_BY_THE_BOOK, TargetSpotted, SoldierResistsMindControl, HostileVIP_HAPPY_GO_LUCKY, InitialFeedback, LowAmmo, EnterSquadConcealment, Moving_LAID_BACK, CivilianRescue, TargetKilled_INTENSE, ADVENTsighting_w, SwordMiss, TargetSpottedHidden, Panic_LAID_BACK, HackDoor, CoupDeGrace, HackWorkstation_TWITCHY, TargetEliminated_LAID_BACK, TrippedBurrow, VIPsighted_w, Panic_INTENSE, MovingConcealed, MedicalProtocol, PickingUpBody, TurnWhileConfused, LootSpotted_TWITCHY, CriticallyWounded, GenericVIP_LAID_BACK, SmokeGrenade, HackWorkstation_BY_THE_BOOK, TargetWinged, HackWorkstation, OrderConfirm_w, AlienExperimentSighted, LootCaptured_LAID_BACK, Moving_HAPPY_GO_LUCKY, Moving_w, HostileVIP_TWITCHY, LootCaptured_TWITCHY, EvacNoLosses, TargetEliminated_HARD_LUCK, Inspire, TargetEliminated_TWITCHY, Insanity, TargetKilled_HARD_LUCK, PickingUpBody_LAID_BACK, SquadMemberDead, UsefulVIP_BY_THE_BOOK, SoldierControlled, InTheZone, LootCaptured_HARD_LUCK, RocketLauncher, OverWatch_w, BulletShred, LootSpotted_COLD, Panic_HARD_LUCK, TeslaCannon, GenericVIP_HARD_LUCK, HackUnit, GrapplingHook, PickingUpBody_INTENSE, TargetArmorHit, Moving_BY_THE_BOOK, UsefulVIP_LAID_BACK, GenericHackFailed, Suppressing, GenericVIP_INTENSE, HackTurretSuccess, ShredStormCannon, TargetKilled_TWITCHY, GroundZero, HackWorkstation_LAID_BACK, SoldierVIP_BY_THE_BOOK, LootSpotted_LAID_BACK, GraffitiSighted, GenericVIP_TWITCHY, SoldierVIP_HAPPY_GO_LUCKY, AlienFloraSighted, SoldierVIP_INTENSE, MeatFactorySighted, SoldierFailsControl, UsefulVIP_INTENSE, AlienReinforcements_w, Panic_BY_THE_BOOK, UsefulVIP, Moving_HARD_LUCK, Moving, TargetEliminated_BY_THE_BOOK, PickingUpBody_HARD_LUCK, LootCaptured, HostileVIP_COLD, SoldierVIP, TargetEliminated, CheckpointSighted, TargetEliminated_COLD, SoldierVIP_TWITCHY, HackWorkstation_COLD, DisablingShot, Burning, MissionAbortRequest, GenericVIP, HoldTheLine, HostileVIP_LAID_BACK, PanickedBreathing, TargetEliminated_INTENSE, HostileVIP_HARD_LUCK, PanicScream, TakingFire, VIPknockout, HackWorkstation_INTENSE, Panic_COLD, EnemyPatrolSpotted, TargetMissed);
	SparkWwiseSoundEvents = (Acid, Moving, TargetHeard, ObjectOnFire, Dodge, HackUnitFailed, TargetMissed, HackWorkstation, HackTurret, Strike, SquadConcealmentBroken, TurnWhileConfused, ArmorHit, Burning, MultipleTargetsKilled, TargetArmorHit, OrderConfirm_w, OverWatch_w, SquadMemberDead, Dashing, Repair, ObjectiveSighted, TargetSpotted, OverWatch, EnterSquadConcealment, TargetSpottedHidden, ObjectFireSpreading, DeathScream, HackDoor, Confused, EVAC, SoldierFlanked, HunkerDown, HackTurretSuccess, Nova, MovingConcealed, TakingFire, HackWorkstationSuccess, Suppressing, HackTurretFailed, LowAmmo, GENERICCONFIRMATION, HackUnitSuccess, HackUnit, ConcealedSpotted, AlienMoving, HackDoorSuccess, TargetKilled, AlienReinforcements, Overdrive, TakingDamage, ADVENTsighting, MissionAbortRequest, TargetWinged, AttemptingHack, AmmoOut, AlienRetreat, EnemyPatrolSpotted, Sacrifice, Bombard, EVACrequest, ThrowGrenade, CriticallyWounded, SoldierSuppressed, Arsenal, Reloading);
	BradfordWwiseSoundEvents = (ADVENTsighting, EVACrequest, Moving, HackDoor, Generic, TakingDamage, AlienRetreat, HunkerDown, LowAmmo, PanickedBreathing, SquadMemberDead, ObjectiveSighted, ArmorHit, OverWatch_w, Confused, Suppressing, Poison, HackWorkstation, AmmoOut, OverWatch, EVAC, ObjectOnFire, SoldierSuppressed, MovingConcealed, RunAndGun, Acid, HackUnit, PanicScream, AlienMoving, Generic_w, TargetHeard, LootCaptured, TakingFire, Dashing, SquadConcealmentBroken, TargetArmorHit, MultipleTargetsKilled, TargetSpottedHidden, Reloading, HackDoorSuccess, ActivateConcealment, ConcealedSpotted, Reaper, PickingUpBody, TargetMissed, ObjectFireSpreading, Dodge, SoldierFlanked, MissionAbortRequest, TurnWhileConfused, HackUnitFailed, HackWorkstationSuccess, AttemptingHack, TargetSpotted, HackUnitSuccess, TargetWinged, TargetKilled, DroppingBody, CriticallyWounded, DeathScream, LootSpotted, HoldTheLine, ItemCollected, SwordMiss, EnemyPatrolSpotted, AlienReinforcements, Burning, EnterSquadConcealment, BleedingOut, ThrowGrenade);
	ShenWwiseSoundEvents = (TargetWinged, Dodge, Suppressing, ArmorHit, PickingUpBody, RestorativeMist, EnterSquadConcealment, SquadConcealmentBroken, HackTurretSuccess, HackUnitFailed, ObjectOnFire, DroppingBody, HackWorkstation, DefensiveProtocol, DisablingShot, OverWatch, SquadMemberDead, Acid, Burning, DeathScream, AlienReinforcements, HackUnitSuccess, TargetKilled, Dashing, TurnWhileConfused, AlienRetreat, ObjectiveSighted, AlienMoving, CriticallyWounded, ADVENTsighting, GENERIC_CONFIRMATION, HackUnit, HackDoorSuccess, TargetSpotted, SoldierFlanked, TakingDamage, TargetHeard, SoldierSuppressed, LootSpotted, TargetSpottedHidden, MedicalProtocol, OverWatch_W, PanickedBreathing, HackTurret, ConcealedSpotted, MultipleTargetsKilled, EVAC, Poison, TakingFire, EnemyPatrolSpotted, HunkerDown, LootCaptured, BleedingOut, AttemptingHack, LowAmmo, MissionAbortRequest, HackWorkstationSuccess, MovingConcealed, OrderConfirm_W, HackTurretFailed, HaywireProtocol, Confused, TargetArmorHit, ItemCollected, TargetMissed, EVACrequest, ObjectFireSpreading, Reloading, HackDoor, CapacitorDischarge, ThrowGrenade, Moving, AmmoOut, PanicScream);
	ReaperWwiseSoundEvents = (ADVENTSighting, ADVENTsighting_w, Acid, AlienExperimentSighted, AlienFacilitySighted, AlienFloraSighted, AlienMoving, AlienMoving_w, AlienNotStunned, AlienReinforcements, AlienReinforcements_w, AlienRetreat, AmmoOut, Annihilate, ArmorHit, AttemptingHack, Banish, BleedingOut, BloodTrail, Burning, CheckpointSighted, CivilianRescue, CivilianSighted, CivilianSighted_w, Claymore, ConcealedSpotted, Confused, CriticallyWounded, Dashing, Dashing_w, Deadeye, DeathScream, Distraction, Dodge, DroppingBody, EVAC, EVACrequest, EnemyPatrolSpotted, EnterSquadConcealment, EvacHeavyLosses, EvacNoLosses, EvacSomeLosses, Executioner, GenericSighting, GenericVIP, GraffitiSighted, GrapplingHook, HackDoor, HackDoorSuccess, HackUnit, HackUnitFailed, HackUnitSuccess, HackWorkstation, HackWorkstationSuccess, HealingAlly, HomingMine, HostileVIP, HunkerDown, HunkerDown_w, ItemCollected, JoiningXCOMsquad, Killzone, LootCaptured, LootSpotted, LowAmmo, MissionAbortRequest, Moving, MovingConcealed, Moving_w, MultipleTargetsKilled, ObjectFireSpreading, ObjectOnFire, ObjectiveSighted, ObjectiveSighted_w, OverWatch, OverWatch_w, PanicScream, PanickedBreathing, PickingUpBody, Poison, Reloading, RemoteStart, RevivingAlly, Shadow, ShadowRising, SmokeGrenade, SoldierControlled, SoldierFlanked, SoldierResistsMindControl, SoldierSuppressed, SoldierVIP, SoulHarvest, SquadConcealmentBroken, SquadMemberDead, StabilizingAlly, Sting, StunTarget, StunnedAlien, Suppressing, TakingDamage, TakingFire, TargetArmorHit, TargetDefinition, TargetEliminated, TargetHeard, TargetHeard_w, TargetKilled, TargetMissed, TargetSpotted, TargetSpottedHidden, TargetWinged, ThrowFlashbang, ThrowGrenade, TrippedBurrow, TrippedBurrow_w, TurnWhileConfused, UsefulVIP, VIPRescueComplete, VIPRescueInProgress, VIPknockout, VIPsighted, VIPsighted_w);
	TemplarWwiseSoundEvents = (ADVENTSighting, ADVENTsighting_w, Acid, AlienExperimentSighted, AlienFacilitySighted, AlienFloraSighted, AlienMoving, AlienMoving_w, AlienNotStunned, AlienReinforcements, AlienReinforcements_w, AlienRetreat, AmmoOut, Amplify, ArmorHit, AttemptingHack, BleedingOut, Burning, CheckpointSighted, CivilianRescue, CivilianSighted, CivilianSighted_w, ConcealedSpotted, Confused, CriticallyWounded, Dashing, Dashing_w, DeathScream, Dodge, DroppingBody, EVAC, EVACrequest, EnemyPatrolSpotted, EnterSquadConcealment, EvacHeavyLosses, EvacNoLosses, EvacSomeLosses, Exchange, Faceoff, GenericSighting, GenericVIP, Ghost, GraffitiSighted, HackDoor, HackDoorSuccess, HackUnit, HackUnitFailed, HackUnitSuccess, HackWorkstation, HackWorkstationSuccess, HealingAlly, HostileVIP, HunkerDown, HunkerDown_w, Invert, IonicStorm, ItemCollected, JoiningXCOMsquad, LightningHands, LootCaptured, LootSpotted, LowAmmo, MissionAbortRequest, Moving, MovingConcealed, Moving_w, MultipleTargetsKilled, ObjectFireSpreading, ObjectOnFire, ObjectiveSighted, ObjectiveSighted_w, OverWatch, OverWatch_w, PanicScream, PanickedBreathing, PickingUpBody, Pillar, Poison, Reaper, Reloading, Rend, RevivingAlly, SmokeGrenade, SoldierControlled, SoldierFlanked, SoldierResistsMindControl, SoldierSuppressed, SoldierVIP, SquadConcealmentBroken, SquadMemberDead, StabilizingAlly, StunStrike, StunTarget, StunnedAlien, Suppressing, TakingDamage, TakingFire, TargetArmorHit, TargetEliminated, TargetHeard, TargetHeard_w, TargetKilled, TargetMissed, TargetSpotted, TargetSpottedHidden, TargetWinged, ThrowFlashbang, ThrowGrenade, TrippedBurrow, TrippedBurrow_w, TurnWhileConfused, UsefulVIP, VIPRescueComplete, VIPRescueInProgress, VIPknockout, VIPsighted, VIPsighted_w, VoidConduit, Volt);
	SkirmisherWwiseSoundEvents = (ADVENTSighting, ADVENTsighting_w, Acid, AlienExperimentSighted, AlienFacilitySighted, AlienFloraSighted, AlienMoving, AlienMoving_w, AlienNotStunned, AlienReinforcements, AlienReinforcements_w, AlienRetreat, Ambush, AmmoOut, ArmorHit, AttemptingHack, Battlelord, BleedingOut, Burning, CheckpointSighted, CivilianRescue, CivilianSighted, CivilianSighted_w, CombatPresence, ConcealedSpotted, Confused, CriticallyWounded, Dashing, Dashing_w, DeathScream, Dodge, DroppingBody, EVAC, EVACrequest, EnemyPatrolSpotted, EnterSquadConcealment, EvacHeavyLosses, EvacNoLosses, EvacSomeLosses, ForwardOperator, FullThrottle, GenericSighting, GenericVIP, GraffitiSighted, Grapple, GrapplingHook, HackDoor, HackDoorSuccess, HackUnit, HackUnitFailed, HackUnitSuccess, HackWorkstation, HackWorkstationSuccess, HealingAlly, HostileVIP, HunkerDown, HunkerDown_w, Interrupt, ItemCollected, JoiningXCOMsquad, Judgement, Justice, LootCaptured, LootSpotted, LowAmmo, ManualOverride, MissionAbortRequest, Moving, MovingConcealed, Moving_w, MultipleTargetsKilled, ObjectFireSpreading, ObjectOnFire, ObjectiveSighted, ObjectiveSighted_w, OverWatch, OverWatch_w, PanicScream, PanickedBreathing, PickingUpBody, Poison, Reckoning, Reflex, Reloading, Retribution, RevivingAlly, SaturationFire, SmokeGrenade, SoldierControlled, SoldierFlanked, SoldierResistsMindControl, SoldierSuppressed, SoldierVIP, SquadConcealmentBroken, SquadMemberDead, StabilizingAlly, StunTarget, StunnedAlien, Suppressing, TakingDamage, TakingFire, TargetArmorHit, TargetEliminated, TargetHeard, TargetHeard_w, TargetKilled, TargetMissed, TargetSpotted, TargetSpottedHidden, TargetWinged, ThrowFlashbang, ThrowGrenade, TrippedBurrow, TrippedBurrow_w, TurnWhileConfused, UsefulVIP, VIPRescueComplete, VIPRescueInProgress, VIPknockout, VIPsighted, VIPsighted_w, Vengeance, Whiplash);
}