class XComGameState_GamblerRolls extends XComGameState_BaseObject config(AimRoll);

var int RNGTrack;
var int RNGTrack_Crit;
var int RNGTrack_Dodge;
var int RNGTrack_Alien;
var int RNGTrack_AlienCrit;
var int RNGTrack_AlienDodge;

var config int GAMBLER_VARIANCE;
var config bool SEPARATE_CRITS_AND_DODGES;
var config bool SEPARATE_ALIEN_ROLLS;

static function SetUpManager(XComGameState StartState)
{
    local XComGameState_GamblerRolls GamblerMgr;

    // End:0x71
    foreach StartState.IterateByClassType(class'XComGameState_GamblerRolls', GamblerMgr)
    {
        // End:0x71
        break;        
    }    
    // End:0xF6
    if(GamblerMgr == none)
    {
        GamblerMgr = XComGameState_GamblerRolls(StartState.CreateNewStateObject(class'XComGameState_GamblerRolls'));
    }
	GamblerMgr.SetUpRNG();
}

function SetUpRNG()
{
	RNGTrack = `SYNC_RAND(100);
	RNGTrack_Crit = `SYNC_RAND(100);
	RNGTrack_Dodge = `SYNC_RAND(100);
	RNGTrack_Alien = `SYNC_RAND(100);
	RNGTrack_AlienCrit = `SYNC_RAND(100);
	RNGTrack_AlienDodge = `SYNC_RAND(100);
}

function bool InternalRoll(int TargetRoll, out int TrackNumber)
{
	if (TrackNumber < TargetRoll)
	{
		// Success, decrease track number by chance to fail and modulo it
		TrackNumber = TrackNumber + TargetRoll - GAMBLER_VARIANCE + `SYNC_RAND(2 * GAMBLER_VARIANCE);
		while (TrackNumber < 0)
			TrackNumber += 100;
		while (TrackNumber >= 100)
			TrackNumber -= 100;
		return true;
	}
	else
	{
		// Fail, decrease track number by chance to success
		TrackNumber = TrackNumber - TargetRoll - GAMBLER_VARIANCE + `SYNC_RAND(2 * GAMBLER_VARIANCE);
		while (TrackNumber < 0)
			TrackNumber += 100;
		while (TrackNumber >= 100)
			TrackNumber -= 100;
		return false;
	}
}

function int Roll(int TargetRoll, bool IsCrit, bool IsDodge, bool IsAlien)
{
    local XComGameStateHistory History;
    local XComGameState NewGameState;
    local XComGameState_GamblerRolls GambleMgr;
	local int RollMade;

    History = `XCOMHISTORY;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Moving track forward");
    GambleMgr = XComGameState_GamblerRolls(NewGameState.ModifyStateObject(class'XComGameState_GamblerRolls', ObjectID));
	if (!IsAlien || !SEPARATE_ALIEN_ROLLS)
	{
		if (SEPARATE_CRITS_AND_DODGES)
		{
			if (IsCrit)
			{
				RollMade = GambleMgr.RNGTrack_Crit;
				InternalRoll(TargetRoll, GambleMgr.RNGTrack_Crit);
			}
			else if (IsDodge)
			{
				RollMade = GambleMgr.RNGTrack_Dodge;
				InternalRoll(TargetRoll, GambleMgr.RNGTrack_Dodge);
			}
			else
			{
				RollMade = GambleMgr.RNGTrack;
				InternalRoll(TargetRoll, GambleMgr.RNGTrack);
			}
		}
		else
		{
			RollMade = GambleMgr.RNGTrack;
			InternalRoll(TargetRoll, GambleMgr.RNGTrack);
		}
	}
	else
	{
		if (SEPARATE_CRITS_AND_DODGES)
		{
			if (IsCrit)
			{
				RollMade = GambleMgr.RNGTrack_AlienCrit;
				InternalRoll(TargetRoll, GambleMgr.RNGTrack_AlienCrit);
			}
			else if (IsDodge)
			{
				RollMade = GambleMgr.RNGTrack_AlienDodge;
				InternalRoll(TargetRoll, GambleMgr.RNGTrack_AlienDodge);
			}
			else
			{
				RollMade = GambleMgr.RNGTrack_Alien;
				InternalRoll(TargetRoll, GambleMgr.RNGTrack_Alien);
			}
		}
		else
		{
			RollMade = GambleMgr.RNGTrack_Alien;
			InternalRoll(TargetRoll, GambleMgr.RNGTrack_Alien);
		}
	}
	if(NewGameState.GetNumGameStateObjects() > 0)
	{
		History.AddGameStateToHistory(NewGameState);
	}
	else
	{
		History.CleanupPendingGameState(NewGameState);
	}
	return RollMade;
}

static function int StaticRoll(int TargetRoll, bool IsCrit, bool IsDodge, bool IsAlien)
{
    local XComGameState_GamblerRolls GambleMgr;
	GambleMgr = GetSingleton();
	return GambleMgr.Roll(TargetRoll, IsCrit, IsDodge, IsAlien);
}

static function XComGameState_GamblerRolls GetSingleton()
{
    local XComGameStateHistory History;
    local XComGameState NewGameState;
    local XComGameState_GamblerRolls GambleMgr;

    History = `XCOMHISTORY;
    GambleMgr = XComGameState_GamblerRolls(History.GetSingleGameStateObjectForClass(class'XComGameState_GamblerRolls', true));
    if(GambleMgr == none)
    {
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Adding Gamble Manager");
        GambleMgr = XComGameState_GamblerRolls(NewGameState.CreateNewStateObject(class'XComGameState_GamblerRolls'));
		GambleMgr.SetUpRNG();
		if(NewGameState.GetNumGameStateObjects() > 0)
		{
			History.AddGameStateToHistory(NewGameState);
		}
		else
		{
			History.CleanupPendingGameState(NewGameState);
		}
    }
    return GambleMgr;    
}