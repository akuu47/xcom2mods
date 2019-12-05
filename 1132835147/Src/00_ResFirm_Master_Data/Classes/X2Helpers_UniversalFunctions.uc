class X2Helpers_UniversalFunctions extends Object config(Null);

static function bool IsDLCInstalled(name DLCName)
{
	local XComOnlineEventMgr EventManager;
	local int i;
		
	EventManager = `ONLINEEVENTMGR;
	for(i = 0; i < EventManager.GetNumDLC(); ++i)
	{
		if (DLCName == EventManager.GetDLCNames(i))
		{
			return true;
		}
	}
	return false;
}