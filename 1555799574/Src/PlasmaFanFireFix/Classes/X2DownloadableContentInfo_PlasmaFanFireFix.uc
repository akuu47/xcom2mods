class X2DownloadableContentInfo_PlasmaFanFireFix extends X2DownloadableContentInfo;

static event OnPostTemplatesCreated()
{
	local X2ItemTemplateManager ItemTemplateManager;
	local array<X2WeaponTemplate> WeaponTemplates;
	local X2WeaponTemplate Template;

    ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	WeaponTemplates = ItemTemplateManager.GetAllWeaponTemplates();

	foreach WeaponTemplates(Template) {
		if (Template.GameArchetype == "TLE3Pistol.WP_TLE3Pistol") {
			Template.GameArchetype = "TLE3Pistol_Fix.WP_TLE3Pistol_Fix";
		}

	}
}

