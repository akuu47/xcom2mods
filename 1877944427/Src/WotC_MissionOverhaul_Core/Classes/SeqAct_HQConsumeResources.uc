//Class that consumes X amount of Y resources

class SeqAct_HQConsumeResources extends SequenceAction;

var string	ResourceName;		// the name of the resource
var int		ResourceQuantity;	// quantity of the resource
var bool	bSkipResChecks;		// Bool that allows us to skip the resource check

function ModifyKismetGameState(out XComGameState GameState)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local StrategyCost StratCost;
	local ArtifactCost ArtCost;
	local array<StrategyCostScalar> CostScalars;			//Dummy Scalar

	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));


	//Check if the cost is possible AND if Skip Resource checks is false
	if (XComHQ.CanAffordResourceCost(name(ResourceName), ResourceQuantity) && !bSkipResChecks)
	{
		XComHQ = XComGameState_HeadquartersXCom(GameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));

		//Setup resource cost
		StratCost.ResourceCosts.Length = 0;
		ArtCost.ItemTemplateName = name(ResourceName);
		ArtCost.Quantity = ResourceQuantity;
		StratCost.ResourceCosts.AddItem(ArtCost);

		CostScalars.Length = 0;

		//Pay the fine
		XComHQ.PayStrategyCost(GameState, StratCost, CostScalars);
	
		OutputLinks[0].bHasImpulse = true;
		OutputLinks[1].bHasImpulse = false;
	}
	else if (bSkipResChecks)					//We don't care if the Avenger has enough resources, just do it anyways (Might be unsafe).
	{
		XComHQ = XComGameState_HeadquartersXCom(GameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));

		//Setup resource cost
		StratCost.ResourceCosts.Length = 0;
		ArtCost.ItemTemplateName = name(ResourceName);
		ArtCost.Quantity = ResourceQuantity;
		StratCost.ResourceCosts.AddItem(ArtCost);

		CostScalars.Length = 0;

		//Pay the fine
		XComHQ.PayStrategyCost(GameState, StratCost, CostScalars);

		OutputLinks[0].bHasImpulse = true;
		OutputLinks[1].bHasImpulse = false;
	}
	else										//The Avenger can't afford this, so set link 1 to true (Failed)
	{
		OutputLinks[0].bHasImpulse = false;
		OutputLinks[1].bHasImpulse = true;
	}
}

defaultproperties
{
	ObjName = " Avenger - Consume Resources"
	ObjCategory = "WotC Mission Overhaul"
	bCallHandler = false

	bConvertedForReplaySystem = true
	bCanBeUsedForGameplaySequence = true
	bAutoActivateOutputLinks = false

	OutputLinks(0) = (LinkDesc = "Success")
	OutputLinks(1) = (LinkDesc = "Failed")

	VariableLinks(0) = (ExpectedType = class'SeqVar_String',LinkDesc = "Resource Name",PropertyName = ResourceName)
	VariableLinks(1) = (ExpectedType = class'SeqVar_Int',LinkDesc = "Quantity",PropertyName = ResourceQuantity)
	VariableLinks(2) = (ExpectedType = class'SeqVar_Bool',LinkDesc = "Skip Resource Checks",PropertyName = bSkipResChecks)
}