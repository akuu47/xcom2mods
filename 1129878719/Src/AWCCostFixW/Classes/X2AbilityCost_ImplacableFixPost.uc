//-----------------------------------------------------------
//	Class:	X2AbilityCost_ImplacableFixPost
//	Author: Mr. Nice
//	
//-----------------------------------------------------------

class X2AbilityCost_ImplacableFixPost extends X2AbilityCost;

var bool RestoreMoveAP;

simulated function ApplyCost(XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_BaseObject AffectState, XComGameState_Item AffectWeapon, XComGameState NewGameState)
{
	if (RestoreMoveAP)
	{
		XComGameState_Unit(AffectState).ActionPoints.additem('move');
		if (AbilityContext.PostBuildVisualizationFn.Find(kAbility.DidNotConsumeAll_PostBuildVisualization)==INDEX_NONE)
			AbilityContext.PostBuildVisualizationFn.AddItem(kAbility.DidNotConsumeAll_PostBuildVisualization);
	}
	RestoreMoveAP=false;
}