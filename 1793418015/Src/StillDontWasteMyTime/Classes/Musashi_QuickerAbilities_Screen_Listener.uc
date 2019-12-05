class Musashi_QuickerAbilities_Screen_Listener extends UIScreenListener config (StillDontWasteMyTime);

struct CustomAbilitySpeed {
	var name Ability;
	var float Speed;
};

var XComPlayerController PC;
var config float HOLO_TARGETING_SPEED_MULTIPLIER;
var config float DEFAULT_SPEED;
var config array<CustomAbilitySpeed> CustomAbilities;

event OnInit(UIScreen Screen)
{
	local UITacticalHUD	HUDScreen;
	
	if(Screen == none)
	{
		return;
	}

	HUDScreen = UITacticalHUD(Screen);
	if(HUDScreen == none)
	{
		return;
	}

	RegisterEvents();

	PC = Screen.PC;

	//class'WorldInfo'.static.GetWorldInfo().MyWatchVariableMgr.RegisterWatchVariable(XComTacticalController(PC), 'm_kActiveUnit', self, Update);

	`LOG("Musashi_Holotarget_Screen_Listener initialized",, 'StillDontWasteMyTime');
}

function RegisterEvents()
{
	local X2EventManager EventManager;
	local Object ThisObj;

	EventManager = `XEVENTMGR;
	ThisObj = self;

	`LOG("Musashi_Holotarget_Screen_Listener Register Events",, 'StillDontWasteMyTime');

	EventManager.RegisterForEvent(ThisObj, 'AbilityActivated', class'Musashi_QuickerAbilities_Screen_Listener'.static.OnReEvaluationEvent, ELD_Immediate);
}

function static EventListenerReturn OnReEvaluationEvent(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Unit UnitState;
	local XComGameState_Unit GremlinUnitState;
	local X2AbilityTemplate AbilityTemplate;
	local int AbilityIndex;

	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	if (AbilityContext != none) 
	{
		AbilityTemplate = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate(AbilityContext.InputContext.AbilityTemplateName);
		
		UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID));

		AbilityIndex = default.CustomAbilities.Find('Ability', AbilityTemplate.DataName);
	
		if (AbilityIndex != INDEX_NONE)
		{
			`LOG(AbilityTemplate.DataName @ "activated" @ default.CustomAbilities[AbilityIndex].Speed,, 'StillDontWasteMyTime');
			Update(XGUnit(UnitState.GetVisualizer()).GetPawn(), default.CustomAbilities[AbilityIndex].Speed);
			
			GremlinUnitState = GetGremlinState(AbilityContext.InputContext.ItemObject.ObjectID);
			if (GremlinUnitState != none)
			{
				Update(XGUnit(GremlinUnitState.GetVisualizer()).GetPawn(), default.CustomAbilities[AbilityIndex].Speed);
			}

			AbilityContext.PostBuildVisualizationFn.AddItem(Reset_PostBuildVisualization);
			return ELR_NoInterrupt;
		}
	}
	
	return ELR_NoInterrupt;
}

static function XComGameState_Unit GetGremlinState(int OwnerObjectID)
{
	local XComGameState_Item GremlinItemState;
	local XComGameState_Unit GremlinUnitState;

	GremlinItemState = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(OwnerObjectID));
	//if (GremlinItemState == none)
	//{
	//	GremlinItemState = XComGameState_Item(NewGameState.ModifyStateObject(class'XComGameState_Item', AbilityContext.InputContext.ItemObject.ObjectID));
	//}
	GremlinUnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(GremlinItemState.CosmeticUnitRef.ObjectID));
	//if (GremlinUnitState == none)
	//{
	//	GremlinUnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', GremlinItemState.CosmeticUnitRef.ObjectID));
	//}
	return GremlinUnitState;
}

static function Reset_PostBuildVisualization(XComGameState VisualizeGameState)
{
	local VisualizationActionMetadata MetaData;
	local XComGameState_Unit UnitState;

	if (VisualizeGameState.GetNumGameStateObjects() > 0)
	{
		foreach VisualizeGameState.IterateByClassType(class'XComGameState_Unit', UnitState)
		{
			MetaData.StateObject_NewState = UnitState;
			MetaData.VisualizeActor = UnitState.GetVisualizer();
			Musashi_Action_ResetSlomo(class'Musashi_Action_ResetSlomo'.static.AddToVisualizationTree(MetaData, VisualizeGameState.GetContext()));
		}
	}
}

function static Reset(XComUnitPawn Pawn)
{
	`LOG("Reset to default speed",, 'StillDontWasteMyTime');
	Update(Pawn, default.DEFAULT_SPEED);
}

function UnregisterEvents()
{
	local X2EventManager EventManager;
	local Object ThisObj;

	EventManager = `XEVENTMGR;
	ThisObj = self;

	EventManager.UnRegisterFromAllEvents(ThisObj);
}
event OnRemoved(UIScreen Screen)
{
	UnregisterEvents();
}

function static Update(XComUnitPawn Pawn, float Speed)
{
	`LOG("Set slomo " @ Speed,, 'StillDontWasteMyTime');
	//`CHEATMGR.Slomo(Speed);
	Pawn.Mesh.GlobalAnimRateScale = Speed;
}

defaultproperties
{
	ScreenClass = class'UITacticalHUD';
}