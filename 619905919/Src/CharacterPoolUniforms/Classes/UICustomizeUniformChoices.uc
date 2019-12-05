class UICustomizeUniformChoices extends UICustomize;

var array<int> UniformIndices;

simulated function UpdateData()
{
	local CharacterPoolManager PoolMgr;
	local int i;

	super.UpdateData();
	UniformIndices.Length = 0;
	List.OnItemClicked = UniformClicked;
	PoolMgr = `CHARACTERPOOLMGR;
	if (PoolMgr != none)
	{
		for (i = 0; i < PoolMgr.CharacterPool.Length; ++i)
		{
			if (PoolMgr.CharacterPool[i].GetMyTemplateName() == 'Soldier' && PoolMgr.CharacterPool[i].GetLastName() ~= "UNIFORM")
			{
				if (CustomizeManager.UpdatedUnitState.kAppearance.iGender == PoolMgr.CharacterPool[i].kAppearance.iGender)
				{
					UniformIndices.AddItem(i);
				}
			}
		}
		for (i = 0; i < UniformIndices.Length; ++i)
		{
			GetListItem(i).UpdateDataDescription(PoolMgr.CharacterPool[UniformIndices[i]].GetFullName());
		}
	}
}

simulated function UniformClicked(UIList ContainerList, int ItemIndex)
{
	local TAppearance AppearanceToCopy;

	AppearanceToCopy = `CHARACTERPOOLMGR.CharacterPool[UniformIndices[ItemIndex]].kAppearance;
	class'UniformCharacterGenerator'.static.CopyUniformAppearance(CustomizeManager.UpdatedUnitState.kAppearance, AppearanceToCopy);
	XComHumanPawn(CustomizeManager.ActorPawn).SetAppearance(CustomizeManager.UpdatedUnitState.kAppearance);
	CustomizeManager.UpdatedUnitState.StoreAppearance();

	CustomizeManager.OnCategoryValueChange(eUICustomizeCat_WeaponColor, 0, AppearanceToCopy.iWeaponTint);

	CloseScreen();
}