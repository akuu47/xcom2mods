class X2TargetingMethod_Line_Extend extends X2TargetingMethod_Line;

function Init(AvailableAction InAction, int NewTargetIndex)
{
	UpdateParameters();
	super.Init(InAction, NewTargetIndex);
}

function Update(float DeltaTime)
{
	UpdateParameters();
	super.Update(DeltaTime);
}

simulated function UpdateParameters()
{
	local X2AbilityMultiTarget_Line MultiTarget;
	
	MultiTarget = X2AbilityMultiTarget_Line(Ability.GetMyTemplate().AbilityMultiTargetStyle);

	if (MultiTarget == none)
		return;
	
	MultiTarget.TileWidthExtension = 2;
}