class UniformCharacterGenerator extends XGCharacterGenerator;

function TSoldier CreateTSoldier( optional name CharacterTemplateName, optional EGender eForceGender, optional name nmCountry = '', optional int iRace = -1, optional name ArmorName )
{
	local TSoldier Soldier;
	local TAppearance UniformAppearance;
	local CharacterPoolManager PoolMgr;
	local int i;
	local array<int> UniformIndices;

	Soldier = super.CreateTSoldier(CharacterTemplateName, eForceGender, nmCountry, iRace, ArmorName);

	if (CharacterTemplateName == 'Soldier')
	{		
		PoolMgr = `CHARACTERPOOLMGR;

		if (PoolMgr != none)
		{
			for (i = 0; i < PoolMgr.CharacterPool.Length; ++i)
			{
				if (PoolMgr.CharacterPool[i].GetMyTemplateName() == 'Soldier' && PoolMgr.CharacterPool[i].GetLastName() ~= "UNIFORM")
				{
					if (PoolMgr.CharacterPool[i].kAppearance.iGender == Soldier.kAppearance.iGender)
					{
						UniformIndices.AddItem(i);
					}
				}
			}

			if (UniformIndices.Length > 0)
			{
				i = `SYNC_RAND(UniformIndices.Length);
				UniformAppearance = PoolMgr.CharacterPool[UniformIndices[i]].kAppearance;
				CopyUniformAppearance(Soldier.kAppearance, UniformAppearance);
			}
			else
			{
				`log("NO UNIFORMS FOUND!");
			}
		}
	}

	return Soldier;
}

static function CopyUniformAppearance(out TAppearance NewAppearance, const out TAppearance UniformAppearance)
{
	NewAppearance.iArmorDeco = UniformAppearance.iArmorDeco;
	NewAppearance.iArmorTint = UniformAppearance.iArmorTint;
	NewAppearance.iArmorTintSecondary = UniformAppearance.iArmorTintSecondary;
	NewAppearance.iWeaponTint = UniformAppearance.iWeaponTint;
	NewAppearance.iTattooTint = UniformAppearance.iTattooTint;
	NewAppearance.nmWeaponPattern = UniformAppearance.nmWeaponPattern;
	NewAppearance.nmTorso = UniformAppearance.nmTorso;
	NewAppearance.nmArms = UniformAppearance.nmArms;
	NewAppearance.nmLegs = UniformAppearance.nmLegs;
	NewAppearance.nmHelmet = UniformAppearance.nmHelmet;
	NewAppearance.nmPatterns = UniformAppearance.nmPatterns;
	NewAppearance.nmTattoo_LeftArm = UniformAppearance.nmTattoo_LeftArm;
	NewAppearance.nmTattoo_RightArm = UniformAppearance.nmTattoo_RightArm;
	NewAppearance.nmScars = UniformAppearance.nmScars;
	NewAppearance.nmTorso_Underlay = UniformAppearance.nmTorso_Underlay;
	NewAppearance.nmArms_Underlay = UniformAppearance.nmArms_Underlay;
	NewAppearance.nmLegs_Underlay = UniformAppearance.nmLegs_Underlay;
	NewAppearance.nmFacePaint = UniformAppearance.nmFacePaint;
}