class X2Helpers_SocketAdjustment extends X2DownloadableContentInfo config (Weapon_SocketAdjust);

//From Iridar's Weapon Skin Replacer
struct WeaponSocketStruct
{
    var name WpnTemplateName;
	var name BoneName;
	var name SocketName;
	var array<string> AttachmentType;

	var float Offset_X;
	var float Offset_Y;
	var float Offset_Z;

	var float Pitch;
	var float Yaw;
	var float Roll;

	var float Scale_X;
	var float Scale_Y;
	var float Scale_Z;
	structdefaultproperties
	{
		Offset_X=0;
		Offset_Y=0;
		Offset_Z=0;

		Pitch=0;
		Yaw=0;
		Roll=0;
		
		Scale_X=1;
		Scale_Y=1;
		Scale_Z=1;
	}
};		



var config array<WeaponSocketStruct> EditWeaponSocket;

//From Iridar's Weapon Skin Replacer
static function DLCAppendWeaponSockets(out array<SkeletalMeshSocket> NewSockets, XComWeapon Weapon, XComGameState_Item ItemState)
{
	local X2WeaponTemplate			WeaponTemplate;
	Local XComGameState_Item		InternalWeaponState;
    local vector					RelativeLocation;
	local rotator					RelativeRotation;
	local vector					RelativeScale;
    local SkeletalMeshSocket		Socket;
	local array<name>				CurrWeaponUpgrades;
	local int i, idx, j, iThreshold;

	`Log("Initializing Socket Adjustment for mod",class'X2DownloadableContentInfo_RFData_WotC'.default.ENABLE_DEBUG_LOGGING, '00_ResFirm_Master_Data');
	InternalWeaponState = ItemState;
    if (InternalWeaponState != none)
	{
		`Log("Found ItemState ID: " $ InternalWeaponState.ObjectID,class'X2DownloadableContentInfo_RFData_WotC'.default.ENABLE_DEBUG_LOGGING, '00_ResFirm_Master_Data');
		WeaponTemplate = X2WeaponTemplate(InternalWeaponState.GetMyTemplate());
		if (WeaponTemplate != none)
		{
			`Log("Found Weapon: " $ WeaponTemplate.DataName,class'X2DownloadableContentInfo_RFData_WotC'.default.ENABLE_DEBUG_LOGGING, '00_ResFirm_Master_Data');
			CurrWeaponUpgrades = InternalWeaponState.GetMyWeaponUpgradeTemplateNames();
			for(i = 0; i < default.EditWeaponSocket.Length; i++)
			{
				if(default.EditWeaponSocket[i].WpnTemplateName == WeaponTemplate.DataName)
				{
					`log(WeaponTemplate.DataName $ ": Appending Socket to Weapon with " $ default.EditWeaponSocket[i].AttachmentType.Length $ " attachment entries.",class'X2DownloadableContentInfo_RFData_WotC'.default.ENABLE_DEBUG_LOGGING, '00_ResFirm_Master_Data');

					//Reset iThreshold to 0
					iThreshold = 0;
					for(idx = 0; idx < CurrWeaponUpgrades.length; idx++)
					{
						//If there exists the specified weapon attachment template on the weapon
						for (j = 0; j < default.EditWeaponSocket[i].AttachmentType.Length; j++)
						{
							if(InStr(string(CurrWeaponUpgrades[idx]), default.EditWeaponSocket[i].AttachmentType[j]) != INDEX_NONE)
							{
								`LOG(CurrWeaponUpgrades[idx] $ " == " $ default.EditWeaponSocket[i].AttachmentType[j],class'X2DownloadableContentInfo_RFData_WotC'.default.ENABLE_DEBUG_LOGGING, '00_ResFirm_Master_Data');
								iThreshold++;
							}
							else
							{
								`LOG(CurrWeaponUpgrades[idx] $ " =/= " $ default.EditWeaponSocket[i].AttachmentType[j],class'X2DownloadableContentInfo_RFData_WotC'.default.ENABLE_DEBUG_LOGGING, '00_ResFirm_Master_Data');
							}
						}
					}

					if(iThreshold >= default.EditWeaponSocket[i].AttachmentType.Length || default.EditWeaponSocket[i].AttachmentType.Length == 0)
					{
						Socket = new class'SkeletalMeshSocket';

						Socket.SocketName = default.EditWeaponSocket[i].SocketName;

						if(default.EditWeaponSocket[i].BoneName == '') 
							Socket.BoneName = 'Root';
						else 
							Socket.BoneName = default.EditWeaponSocket[i].BoneName;

						RelativeLocation.X = default.EditWeaponSocket[i].Offset_X;
						RelativeLocation.Y = default.EditWeaponSocket[i].Offset_Y;
						RelativeLocation.Z = default.EditWeaponSocket[i].Offset_Z;
						Socket.RelativeLocation = RelativeLocation;

						RelativeRotation.Pitch = default.EditWeaponSocket[i].Pitch;
						RelativeRotation.Yaw = default.EditWeaponSocket[i].Yaw;
						RelativeRotation.Roll = default.EditWeaponSocket[i].Roll;
						Socket.RelativeRotation = RelativeRotation;

						RelativeScale.X = default.EditWeaponSocket[i].Scale_X;
						RelativeScale.Y = default.EditWeaponSocket[i].Scale_Y;
						RelativeScale.Z = default.EditWeaponSocket[i].Scale_Z;
						Socket.RelativeScale = RelativeScale;
						
						`LOG(WeaponTemplate.DataName $ ": Socket Appended!");
						NewSockets.AddItem(Socket);
					}
					else
					{
						`LOG(WeaponTemplate.DataName $ ": Found " $ iThreshold $ " out of the required " $ default.EditWeaponSocket[i].AttachmentType.Length $ " attachments. FAILED!",class'X2DownloadableContentInfo_RFData_WotC'.default.ENABLE_DEBUG_LOGGING, '00_ResFirm_Master_Data');
					}
				}
				else
				{
					`LOG(default.EditWeaponSocket[i].WpnTemplateName $ " does not match Weapon: " $ WeaponTemplate.DataName $ " of ItemState ID: " $ InternalWeaponState.ObjectID,class'X2DownloadableContentInfo_RFData_WotC'.default.ENABLE_DEBUG_LOGGING, '00_ResFirm_Master_Data');
				}
			}
		}
	}
}