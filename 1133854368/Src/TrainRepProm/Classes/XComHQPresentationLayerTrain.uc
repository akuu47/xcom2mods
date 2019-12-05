//---------------------------------------------------------------------------------------
//  FILE:    XComHQPresentationLayerTrain.uc
//  AUTHOR:  Mr. Nice
//           
//---------------------------------------------------------------------------------------


class XComHQPresentationLayerTrain extends XComHQPresentationLayer;

function ShowPromotionUI(StateObjectReference UnitRef, optional bool bInstantTransition)
{
	local UIArmory_Promotion PromotionUI;
	local XComGameState_Unit UnitState;

	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitRef.ObjectID));

	if (UnitState.IsResistanceHero() || ScreenStack.IsInStack(class'UIFacility_TrainingCenter') || 
		(UnitState.GetSoldierClassTemplate().bAllowAWCAbilities && !UnitState.ShowPromoteIcon()
			&& `XComHQ.HasFacilityByName('RecoveryCenter')) )
		PromotionUI = UIArmory_PromotionHero(ScreenStack.Push(Spawn(class'UIArmory_PromotionHero', self), Get3DMovie()));
	else if (UnitState.GetSoldierClassTemplateName() == 'PsiOperative')
		PromotionUI = UIArmory_PromotionPsiOp(ScreenStack.Push(Spawn(class'UIArmory_PromotionPsiOp', self), Get3DMovie()));
	else
		PromotionUI = UIArmory_Promotion(ScreenStack.Push(Spawn(class'UIArmory_Promotion', self), Get3DMovie()));
	
	PromotionUI.InitPromotion(UnitRef, bInstantTransition);
}
