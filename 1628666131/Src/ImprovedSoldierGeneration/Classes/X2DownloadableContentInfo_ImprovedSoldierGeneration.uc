class X2DownloadableContentInfo_ImprovedSoldierGeneration extends X2DownloadableContentInfo config(SoldierGeneration);

var config array<name> CHARACTER_TEMPLATES_TO_PATCH_WEAPON_COLOR;

//	Not sure this part is even neccessary or if it does anything
//	most of this mod's "magic" is in XGCharacterGenerator overrides.
static event OnPostTemplatesCreated()
{
	local X2CharacterTemplateManager CharMgr;
	local X2CharacterTemplate CharTemplate;
	local name TemplateName;

	CharMgr = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();
	
	foreach default.CHARACTER_TEMPLATES_TO_PATCH_WEAPON_COLOR(TemplateName)
	{
		CharTemplate = CharMgr.FindCharacterTemplate(TemplateName);

		if(CharTemplate != None)
		{
			//`LOG("Patching default weapon color for: " @ TemplateName @ " to: " @ class'XGCharacterGenerator_Override'.default.DEFAULT_WEAPON_TINT,, 'IRIDAR');
			CharTemplate.DefaultAppearance.iWeaponTint = class'XGCharacterGenerator'.default.iDefaultWeaponTint;

			//	this would work only for characters with Forced Appearance = true, but let's keep it just in case
			CharTemplate.ForceAppearance.iWeaponTint = class'XGCharacterGenerator'.default.iDefaultWeaponTint;	
		}
		else `LOG("Couldn't find char template to patch default weapon color: " @ TemplateName,, 'IRIDAR');
	}
}