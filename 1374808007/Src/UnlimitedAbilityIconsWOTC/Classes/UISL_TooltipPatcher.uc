class UISL_TooltipPatcher extends UIScreenListener;

event OnInit(UIScreen Screen)
{
	local UITacticalHUD_AbilityTooltip	AbilityTooltip;
	local UITacticalHUD_Tooltips Tooltips;
	local AbilityTooltipDelegateHook DelegateHook;
	if (UITacticalHUD(Screen) != none)
	{
		//`log("TacHUD Init",,'Ability30');
		Tooltips = UITacticalHUD(Screen).m_kTooltips;
		`log("Tooltips NOT FOUND",Tooltips == none,'Ability30');
		AbilityTooltip = UITacticalHUD_AbilityTooltip(Tooltips.Movie.Pres.m_kTooltipMgr.GetChildByName('TooltipAbility', false));
		`log("Ability tooltips NOT FOUND",AbilityTooltip == none,'Ability30');
		if (AbilityTooltip != none)
		{
			DelegateHook = AbilityTooltipDelegateHook(AbilityTooltip.GetChildByName('TooltipThirtyHook', false));

			if (DelegateHook == none)
			{
				DelegateHook = AbilityTooltip.Spawn(class'AbilityTooltipDelegateHook', AbilityTooltip);
				DelegateHook.InitPanel('TooltipThirtyHook');
				DelegateHook.Hide();
				//`log("Patching ability tooltip...",,'Ability30');
				DelegateHook.del_OnMouseIn = AbilityTooltip.del_OnMouseIn;
				AbilityTooltip.del_OnMouseIn = DelegateHook.OnAbilityTooptipMouseIn;
			}
		}
	}
}
