class X2Effect_NewReflex extends X2Effect_Persistent;

function ModifyTurnStartActionPoints(XComGameState_Unit UnitState, out array<name> ActionPoints, XComGameState_Effect EffectState)
{

	if (UnitState.IsAbleToAct())
			ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.StandardActionPoint);


}

DefaultProperties
{
	EffectName = "NewSkirmisherReflex"
	DuplicateResponse = eDupe_Ignore
}