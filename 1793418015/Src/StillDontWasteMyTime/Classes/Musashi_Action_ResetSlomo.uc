class Musashi_Action_ResetSlomo extends X2Action;

simulated state Executing
{
	simulated private function ResetSlomo()
	{
		local XComGameState_Unit GremlinUnitState;

		class'Musashi_QuickerAbilities_Screen_Listener'.static.Reset(UnitPawn);

		GremlinUnitState = class'Musashi_QuickerAbilities_Screen_Listener'.static.GetGremlinState(UnitPawn.ObjectID);
		if (GremlinUnitState != none)
		{
			class'Musashi_QuickerAbilities_Screen_Listener'.static.Reset((XGUnit(GremlinUnitState.GetVisualizer()).GetPawn()));
		}
	}

Begin:
	ResetSlomo();

	CompleteAction();
}
