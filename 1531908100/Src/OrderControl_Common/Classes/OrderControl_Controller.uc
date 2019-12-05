//OrderControl_Controller.uc revision 1.07
class OrderControl_Controller extends Object;

var string AttachedToMod;
var bool isSetup;
var int runcount;
var array<string> RunBefore;
var array<string> RunAfter;

static function X2DownloadableContentInfo GetMyInstance(string DLCName) {
	local array<X2DownloadableContentInfo> DLCInfos;
	local X2DownloadableContentInfo DLCInfo;
	
	DLCInfos = `ONLINEEVENTMGR.GetDLCInfos(false);
	foreach DLCInfos(DLCInfo)
	{
		//`log("LOOKING AT DLC: " $ DLCInfo.DLCIdentifier); 

		if (DLCInfo.DLCIdentifier == DLCName) {
			return DLCInfo;
		}
	}
	
	return none;
}

function AddRunBefore(string rb) {
	RunBefore.AddItem(rb);
}

function AddRunAfter(string ra) {
	RunAfter.AddItem(ra);
}

function bool CheckRunBeforeFor(string RBCheck) {
	local int isFound;

	isFound = RunBefore.Find(RBCheck);
	if (isFound == INDEX_NONE) {
		return false;
	}
	
	return true;
}

function bool CheckRunAfterFor(string RACheck) {
	local int isFound;

	isFound = RunAfter.Find(RACheck);
	if (isFound == INDEX_NONE) {
		return false;
	}
	
	return true;
}

function Setup(string DLCName) {
	local string Current;
	local X2DownloadableContentInfo CurrentInstance;
	local OrderControl_Interface CurrentInterface;
	local OrderControl_Controller RAController;
	local bool RBCheckResult;

	if (isSetup == true) {
		return;
	}

	AttachedToMod = DLCName;

	runcount = 1;
	if (RunAfter.Length > 0) {
		foreach RunAfter(Current) {
			CurrentInstance = GetMyInstance(Current);
			if (CurrentInstance != none) {				
				CurrentInterface = OrderControl_Interface(CurrentInstance);
				if (CurrentInterface != none) {
					RAController = CurrentInterface.GetController();
					RBCheckResult = RAController.CheckRunBeforeFor(DLCName);
					
					if (RBCheckResult) {
						runcount++;
						`log(DLCName $ " RunAfter " $ Current $ " is valid");
					} else {
						`log(DLCName $ " RunAfter " $ Current $ " does not have a matching RunBefore");
					}

				} else {
					`log(DLCName $ " RunAfter " $ Current $ " DOES NOT HAVE OC interface -- ignoring!");
				}

			} else {
				`log(DLCName $ " RunAfter " $ Current $ " NOT FOUND!");
			}
		}
	}

	`log(DLCName $ " initial RC: " $ string(runcount));
	isSetup = true;

}

function bool IsReady() {
	runcount--;

	if (runcount == 0) {
		`log(AttachedToMod $ " is running!");
		return true;
	}

	`log(AttachedToMod $ " is not ready! RC: " $ string(runcount));

	return false;
}

function Finished() {
	local X2DownloadableContentInfo RunInstance;
	local OrderControl_Interface RunInterface;
	local OrderControl_Controller RBController;
	local bool RACheckResult;
	local string Current;

	if (RunBefore.Length > 0) {
		foreach RunBefore(Current) {
			RunInstance = GetMyInstance(Current);
			if (RunInstance != none) {
				RunInterface = OrderControl_Interface(RunInstance);
				if (RunInterface != none) {
					RBController = RunInterface.GetController();

					RACheckResult = RBController.CheckRunAfterFor(AttachedToMod);

					if (RACheckResult) {
						RunInstance.OnPostTemplatesCreated();
					} else {
						`log(AttachedToMod $ " RunBefore " $ Current $ " does not have a matching RunAfter");
					}
				}	
			}
		}
	}
}