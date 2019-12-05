//---------------------------------------------------------------------------------------
//  FILE:  SMP_TemplateModifier.uc                                  
//           
//	Applies changes to the mission source templates.
//  
//---------------------------------------------------------------------------------------
//  
//---------------------------------------------------------------------------------------

class SMP_TemplateModifier extends Object config (SensibleMissions);

var config array<name> ApplyToMissions;

function ModifyTemplates(){
	local name MissionName;
	
	foreach default.ApplyToMissions(MissionName) {
		`LOG("Modify template for mission " @ string(MissionName));
		HandleSingleTemplate(MissionName);
	}
}

function HandleSingleTemplate(name templateName){
	local array<X2DataTemplate> Templates;
	local X2DataTemplate Tmp;
	local X2MissionSourceTemplate Template;

	GetManager().FindDataTemplateAllDifficulties(templateName, Templates);

	foreach Templates(Tmp) {
		Template = X2MissionSourceTemplate(Tmp);
		ReplaceFunctions(Template, templateName);
	}
}


function ReplaceFunctions(X2MissionSourceTemplate Template, name templateName){
	switch (templateName){
		case 'MissionSource_GuerillaOp': 
			Template.OnFailureFn = GuerillaOpOnFailure;
			Template.OnExpireFn = GuerillaOpOnExpire;
			
			return;
		case 'MissionSource_Council': 
			Template.OnFailureFn = CouncilOnFailure;
			Template.OnExpireFn = CouncilOnExpire;
			Template.bDisconnectRegionOnFail = false;
			
			return;
		case 'MissionSource_SupplyRaid':
			Template.OnFailureFn = SupplyRaidOnFailure;
			Template.OnExpireFn = SupplyRaidOnExpire; 
			Template.bDisconnectRegionOnFail = false;

			return;
		case 'MissionSource_LandedUFO':
			Template.OnFailureFn = LandedUFOOnFailure;
			Template.OnExpireFn = LandedUFOOnExpire; 
			Template.bDisconnectRegionOnFail = false;

			return;
		case 'MissionSource_ResistanceOp':
			Template.OnFailureFn = ResOpOnFailure;
			Template.OnExpireFn = ResOpOnExpire;
			Template.bDisconnectRegionOnFail = false;
			
			return;
		default: 
			return;
	}
}

static function X2StrategyElementTemplateManager GetManager(){
	return class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
}

// guerrilla op
static function GuerillaOpOnFailure(XComGameState NewGameState, XComGameState_MissionSite MissionState)
{
	local XComGameState_DarkEvent DarkEventState;
	local XComGameState_BattleData BattleData;
	local X2StrategyElement_DefaultMissionSources MissionSources;
	MissionSources = new class'X2StrategyElement_DefaultMissionSources';

	BattleData = XComGameState_BattleData(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));

	DarkEventState = MissionState.GetDarkEvent();
	if(DarkEventState != none)
	{
		// Completed objective then aborted or wiped still cancels dark event
		if(BattleData.OneStrategyObjectiveCompleted())
		{
			MissionSources.StopMissionDarkEvent(NewGameState, MissionState);
		}
		else
		{
			// DON'T Set the Dark Event to activate immediately
		}
	}
	
	MissionSources.CleanUpGuerillaOps(NewGameState, MissionState.ObjectID);
	class'XComGameState_HeadquartersResistance'.static.DeactivatePOI(NewGameState, MissionState.POIToSpawn);
	class'XComGameState_HeadquartersResistance'.static.RecordResistanceActivity(NewGameState, 'ResAct_GuerrillaOpsFailed');
}

static function GuerillaOpOnExpire(XComGameState NewGameState, XComGameState_MissionSite MissionState)
{
	class'XComGameState_HeadquartersResistance'.static.DeactivatePOI(NewGameState, MissionState.POIToSpawn);
}

// landed UFO results

static function LandedUFOOnFailure(XComGameState NewGameState, XComGameState_MissionSite MissionState)
{	
	MissionState.RemoveEntity(NewGameState);
	class'XComGameState_HeadquartersResistance'.static.DeactivatePOI(NewGameState, MissionState.POIToSpawn);
	class'XComGameState_HeadquartersResistance'.static.RecordResistanceActivity(NewGameState, 'ResAct_LandedUFOsFailed');
}
static function LandedUFOOnExpire(XComGameState NewGameState, XComGameState_MissionSite MissionState)
{
	class'XComGameState_HeadquartersResistance'.static.DeactivatePOI(NewGameState, MissionState.POIToSpawn);
	class'XComGameState_HeadquartersResistance'.static.RecordResistanceActivity(NewGameState, 'ResAct_LandedUFOsFailed');		
}

// supply raid results

static function SupplyRaidOnFailure(XComGameState NewGameState, XComGameState_MissionSite MissionState)
{
	`LOG("Handling failure of supply raid...");
	MissionState.RemoveEntity(NewGameState);
	class'XComGameState_HeadquartersResistance'.static.DeactivatePOI(NewGameState, MissionState.POIToSpawn);
	class'XComGameState_HeadquartersResistance'.static.RecordResistanceActivity(NewGameState, 'ResAct_SupplyRaidsFailed');
}

static function SupplyRaidOnExpire(XComGameState NewGameState, XComGameState_MissionSite MissionState)
{
	`LOG("Handling expiry of supply raid...");
	class'XComGameState_HeadquartersResistance'.static.DeactivatePOI(NewGameState, MissionState.POIToSpawn);
	class'XComGameState_HeadquartersResistance'.static.RecordResistanceActivity(NewGameState, 'ResAct_SupplyRaidsFailed');
}

// council mission

static function CouncilOnFailure(XComGameState NewGameState, XComGameState_MissionSite MissionState)
{
	`LOG("Handling failure of council mission...");
	MissionState.RemoveEntity(NewGameState);
	class'XComGameState_HeadquartersResistance'.static.DeactivatePOI(NewGameState, MissionState.POIToSpawn);
	class'XComGameState_HeadquartersResistance'.static.RecordResistanceActivity(NewGameState, 'ResAct_CouncilMissionsFailed');
}
static function CouncilOnExpire(XComGameState NewGameState, XComGameState_MissionSite MissionState)
{
	`LOG("Handling expiry of council mission...");
	class'XComGameState_HeadquartersResistance'.static.DeactivatePOI(NewGameState, MissionState.POIToSpawn);
	class'XComGameState_HeadquartersResistance'.static.RecordResistanceActivity(NewGameState, 'ResAct_CouncilMissionsFailed');
}

static function ResOpOnFailure(XComGameState NewGameState, XComGameState_MissionSite MissionState)
{
	local array<int> ExcludeIndices;

	// Even though the primary objective was failed, we still want to check if secondary objectives were completed and award those soldiers
	ExcludeIndices = class'X2StrategyElement_XpackMissionSources'.static.GetResOpExcludeRewards(MissionState);
	ExcludeIndices.AddItem(0); // Exclude the primary VIP
	ExcludeIndices.AddItem(1); // Exclude the Intel reward
	class'X2StrategyElement_XpackMissionSources'.static.GiveRewards(NewGameState, MissionState, ExcludeIndices);

	MissionState.RemoveEntity(NewGameState);
	class'XComGameState_HeadquartersResistance'.static.DeactivatePOI(NewGameState, MissionState.POIToSpawn);
	class'XComGameState_HeadquartersResistance'.static.RecordResistanceActivity(NewGameState, 'ResAct_ResistanceOpsFailed');

	`XEVENTMGR.TriggerEvent('ResistanceOpComplete', , , NewGameState);
}

static function ResOpOnExpire(XComGameState NewGameState, XComGameState_MissionSite MissionState)
{
	class'XComGameState_HeadquartersResistance'.static.DeactivatePOI(NewGameState, MissionState.POIToSpawn);
	class'XComGameState_HeadquartersResistance'.static.RecordResistanceActivity(NewGameState, 'ResAct_ResistanceOpsFailed');
}

