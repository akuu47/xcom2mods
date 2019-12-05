class X2DownloadableContentInfo_WOTCOpenWeaponRestrictions extends X2DownloadableContentInfo config(WOTCOpenWeaponRestrictions);

struct ClassWeaponRestriction
{
	var array<name>				AllowedWeaponType;
	var array<name>				GrantWeaponType;
	var array<EInventorySlot>	Slot;

	structdefaultproperties
	{
		AllowedWeaponType[0] = "any"
		Slot[0] = eInvSlot_Unknown
		Slot[1] = eInvSlot_Unknown
		Slot[2] = eInvSlot_Unknown
		Slot[3] = eInvSlot_Unknown
		Slot[4] = eInvSlot_Unknown
		Slot[5] = eInvSlot_Unknown
		Slot[6] = eInvSlot_Unknown
		Slot[7] = eInvSlot_Unknown
		Slot[8] = eInvSlot_Unknown
		Slot[9] = eInvSlot_Unknown
		Slot[10] = eInvSlot_Unknown
		Slot[11] = eInvSlot_Unknown
		Slot[12] = eInvSlot_Unknown
		Slot[13] = eInvSlot_Unknown
		Slot[14] = eInvSlot_Unknown
		Slot[15] = eInvSlot_Unknown
		Slot[16] = eInvSlot_Unknown
		Slot[17] = eInvSlot_Unknown
		Slot[18] = eInvSlot_Unknown
		Slot[19] = eInvSlot_Unknown
	}
};
/*
struct native SoldierClassWeaponType
{
	var name WeaponType;
	var EInventorySlot SlotType;
};*/


var config array<ClassWeaponRestriction> GRANT_WEAPON;

static event OnPostTemplatesCreated()
{
	local X2SoldierClassTemplateManager	ClassMgr;
	local array<X2SoldierClassTemplate>	arrClassTemplates;
	local X2SoldierClassTemplate		ClassTemplate;
	local SoldierClassWeaponType		WeaponTypeStruct;
	local ClassWeaponRestriction		WeaponConfig;
	local int i, iMax, j;

	//	grab the class manager
	ClassMgr = class'X2SoldierClassTemplateManager'.static.GetSoldierClassTemplateManager();

	//	pull all class templates
	arrClassTemplates = ClassMgr.GetAllSoldierClassTemplates();

	foreach arrClassTemplates(ClassTemplate)
	{
		//	localize the array length so we don't check array entries added by the 'for' cycle
		iMax = ClassTemplate.AllowedWeapons.Length;

		//	cycle through weapons available to this class
		for (i=0;i<iMax;i++)
		{
			//	check each config array entry
			foreach default.GRANT_WEAPON(WeaponConfig)
			{
				if(WeaponConfig.AllowedWeaponType.Find(ClassTemplate.AllowedWeapons[i].WeaponType) != INDEX_NONE || WeaponConfig.AllowedWeaponType[0] == 'any')
				{	
					for(j=0;j<WeaponConfig.GrantWeaponType.Length;j++)
					{
						WeaponTypeStruct.WeaponType = WeaponConfig.GrantWeaponType[j];

						//	if slot was not specified in the config, use the same slot as the required weapon
						if(WeaponConfig.Slot[j] == eInvSlot_Unknown)
						{
							WeaponTypeStruct.SlotType = ClassTemplate.AllowedWeapons[i].SlotType;
						}
						else
						{
							WeaponTypeStruct.SlotType = WeaponConfig.Slot[j];
						}
										
						ClassTemplate.AllowedWeapons.AddItem(WeaponTypeStruct);
					}
				}
			}
		}
	}	
}

//`LOG("IRIDAR OPTC triggered", , 'WOTCOpenWeaponRestrictions');



	






	

