class X2DownloadableContentInfo_SlagAndMelta extends X2DownloadableContentInfo;

static function bool AbilityTagExpandHandler(string InString, out string OutString)
{
	local name TagText;
	
	TagText = name(InString);
	switch (TagText)
	{
	case 'SINGE_TRIGGER_CHANCE':
			OutString = string(class'X2Ability_SlagAndMelta'.default.SLAG_TRIGGER_CHANCE);
			return true;
	case 'SINGE_ARMOR_SHRED':
			OutString = string(class'X2Ability_SlagAndMelta'.default.SLAG_BONUS_DAMAGE.Shred);
			return true;
//End
	default:
            return false;
    }  
}