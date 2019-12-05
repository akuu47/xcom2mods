//OrderControl.uc revision 2.06
class OrderControl extends Object config(OrderControl);

var config array<string> RunBefore;
var config array<string> RunAfter;

static function LocalSetup(OrderControl_Controller Controller) {
	local string s;

	if (default.RunBefore.Length > 0) {
		foreach default.RunBefore(s) {
			Controller.AddRunBefore(s);
		}
	}

	if (default.RunAfter.Length > 0) {
		foreach default.RunAfter(s) {
			Controller.AddRunAfter(s);
		}
	}
}

static function X2DownloadableContentInfo GetMyInstance(string DLCName) {
	return class'OrderControl_Controller'.static.GetMyInstance(DLCName);
}

static function bool IsBefore(string DLCName, string SecondDLCName) {
	local array<X2DownloadableContentInfo> DLCInfos;
	local X2DownloadableContentInfo DLCInfo;
	local int i;
	
	DLCInfos = `ONLINEEVENTMGR.GetDLCInfos(false);
	for(i=0;i<DLCInfos.Length;i++)
	{
		DLCInfo = DLCInfos[i];
		//`log("LOOKING AT DLC: " $ DLCInfo.DLCIdentifier); 

		if (DLCInfo.DLCIdentifier == DLCName) {
			return true;
		} else if (DLCInfo.DLCIdentifier == SecondDLCName) {
			return false;
		}
	}
	
	return false;
}