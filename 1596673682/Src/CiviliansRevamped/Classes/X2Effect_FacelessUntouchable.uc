//-----------------------------------------------------------
//	Class:	X2Effect_FacelessUntouchable
//	Author: Mr. Nice
//	
//-----------------------------------------------------------


class X2Effect_FacelessUntouchable extends X2Effect_Persistent;

function bool CanAbilityHitUnit(name AbilityName)
{
	local X2AbilityToHitCalc_StandardAim StandardAim;
	
	StandardAim=X2AbilityToHitCalc_StandardAim(class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate(AbilityName).AbilityToHitCalc);

	if (StandardAim!=None && !StandardAim.bIndirectFire && !StandardAim.bGuaranteedHit)
	{
		return false;
	}
	return true;
}

defaultproperties
{
	DuplicateResponse = eDupe_Ignore
}