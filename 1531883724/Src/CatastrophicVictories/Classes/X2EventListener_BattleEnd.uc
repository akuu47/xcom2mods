class X2EventListener_BattleEnd extends X2EventListener;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(BattleEndCheck() );

	return Templates;
}

static function CHEventListenerTemplate BattleEndcheck()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'TONAT_BattleEndCheck');
	//explanation: vanilla X2EvenetLIstenerTemplates do not specify deferrals, instead always being on ELD_OnStateSubmitted.
	//PCSes need to engage as soon as possible, so we use the CH highlander instead.

	Template.RegisterInTactical = true;
	Template.AddCHEvent('OverrideVictoriousPlayer', OverrideVictoryState, ELD_Immediate);

	return Template;
}


static protected function EventListenerReturn OverrideVictoryState(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComLWTuple Tuple;
	local XComGameStateHistory History;
	local XComGameState_BattleData BattleData;
	local XComGameState_MissionSite MissionState;
	local X2MissionSourceTemplate MissionSource;
	local int LocalPlayerID;
	local XComGameState_Player PlayerState;
	Tuple = XComLWTuple(EventData);
	LocalPlayerID = -1;
	if(Tuple == none || Tuple.Id != 'OverrideVictoriousPlayer')
	{
		return ELR_NoInterrupt;
	}
	History = `XCOMHistory;
	BattleData = XComGameState_BattleData(History.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));

	if(BattleData == none)
	{
		return ELR_NoInterrupt;
	}
	
	foreach History.IterateByClassType(class'XComGameState_Player', PlayerState)
	{
		if (PlayerState.TeamFlag == eTeam_XCom)
		{
			LocalPlayerID = XGPlayer(PlayerState.GetVisualizer()).ObjectID;
		}
	}

	if(LocalPlayerID < 0)
	{
		`log("TONAT: We somehow got no XCOM playerID from this match???");
		return ELR_NoInterrupt;
	}
	MissionState = XComGameState_MissionSite(History.GetGameStateForObjectID(BattleData.m_iMissionID));
	MissionSource = MissionState.GetMissionSource();

	if(MissionSource.WasMissionSuccessfulFn != none) // we should only get missions that have this
	{
		if(MissionSource.WasMissionSuccessfulFn(BattleData))
		{
			if(Tuple.Data[0].i != LocalPlayerID) // generally speaking, if the mission was successful, it SHOULD count as a mission victory in some regards
			{
				Tuple.Data[0].i = LocalPlayerID;
			}
		}
	}

	return ELR_NoInterrupt;

}