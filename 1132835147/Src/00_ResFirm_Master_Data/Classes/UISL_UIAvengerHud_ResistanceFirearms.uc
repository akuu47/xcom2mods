class UISL_UIAvengerHud_ResistanceFirearms extends UIScreenListener;


event OnInit(UIScreen Screen)
{
	local UIAvengerHud AvengerHud;
	local array<X2WeaponTemplate> WeaponTemplates;
	local X2WeaponTemplate Template;

	AvengerHud = UIAvengerHud(Screen);
	if (AvengerHud == none)
		return;
	
	// Preload all weapons
	WeaponTemplates = class'X2ItemTemplateManager'.static.GetItemTemplateManager().GetAllWeaponTemplates();
	foreach WeaponTemplates(Template)
	{
		if (InStr(String(Template.DataName), "TC_WOTC") != INDEX_NONE)
		{
			`CONTENT.RequestGameArchetype(Template.GameArchetype, none, none, true);
		}
	}
}

defaultproperties
{
	ScreenClass=none
}