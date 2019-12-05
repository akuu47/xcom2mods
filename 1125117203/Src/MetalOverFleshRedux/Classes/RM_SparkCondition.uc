class RM_SparkCondition extends X2Condition;


event name CallMeetsCondition(XComGameState_BaseObject kTarget) 
{ 
	local XComGameState_Unit UnitState;
	local XComGameState_HeadquartersXCom XComHQ;
	local X2StrategyElementTemplateManager StratMgr;
	local X2TechTemplate TechTemplate;

	XComHQ = class'UIUtilities_Strategy'.static.GetXComHQ();

	UnitState = XComGameState_Unit(kTarget);

	if (UnitState == none)
		return 'AA_NotAUnit';

	if (UnitState.IsDead() || UnitState.IsUnconscious() || UnitState.IsBleedingOut())
		return 'AA_UnitIsDead';

	if(UnitState.GetMyTemplateName() != 'SparkSoldier' && UnitState.GetMyTemplateName() != 'LostTowersSPARK')
	{
		return 'AA_Success';
	}

	if(UnitState.GetMyTemplateName() == 'SparkSoldier' || UnitState.GetMyTemplateName() == 'LostTowersSPARK')
	{
		StratMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();

			TechTemplate = X2TechTemplate(StratMgr.FindStrategyElementTemplate('SPARKSuppression'));

			if(TechTemplate != none)
			{
				if(XComHQ.TechTemplateIsResearched(TechTemplate))
				{
					return 'AA_Success';
				}

				
			}
	

	}


	return 'AA_AbilityUnavailable'; 
}