class HistorySavePairs extends Object config(Skirmish);

struct HistorySavePair
{
	var name Filename;
	var string DisplayName;
	var int SelectedEnemyIndex;
};

var config array<HistorySavePair> SkirmishSaves;
var config int HistorySaveIndex;

static function int GetHistory(out array<name> filenames, out array<string> displaynames)
{
	local HistorySavePair HSP;
	local int i;

	foreach default.SkirmishSaves(HSP)
	{
		filenames.AddItem(HSP.Filename);
		displaynames.AddItem(HSP.DisplayName);
		i++;
	}

	return i;
}

static function SaveHistory(XComGameStateHistory History, string NewName, int EnemyIndex)
{
	local int i;
	local HistorySavePair HSP;
	
	for (i = 0; i < default.SkirmishSaves.Length; i++)
	{
		if (default.SkirmishSaves[i].DisplayName == NewName)
		{
			HSP = default.SkirmishSaves[i];
			default.SkirmishSaves[i].SelectedEnemyIndex = EnemyIndex;
			History.WriteHistoryToFile("Skirmishes/", HSP.Filename $ ".x2hist");
				StaticSaveConfig();
			return;
		}
	}

	HSP.Filename = name("Skirmish_" $ ++default.HistorySaveIndex);
	HSP.DisplayName = NewName;
	HSP.SelectedEnemyIndex = EnemyIndex;
	if (History.WriteHistoryToFile("Skirmishes/", HSP.Filename $ ".x2hist"))
	{
		default.SkirmishSaves.AddItem(HSP);
	}

	StaticSaveConfig();
}

static function bool DeleteHistory(name FileName)
{
	local int i;

	for (i = 0; i < default.SkirmishSaves.Length; i++)
	{
		if (default.SkirmishSaves[i].Filename == FileName)
		{
			default.SkirmishSaves.Remove(i, 1);
			StaticSaveConfig();
			return true;
		}
	}

	return false;
}

static function int GetEnemyIndex(name FileName)
{
	local int i;

	`log("Looking up file name:" @ FileName,, 'SkirmishMode');

	for (i = 0; i < default.SkirmishSaves.Length; i++)
	{
		if (default.SkirmishSaves[i].Filename == FileName)
		{
			`log("found index:" @ i @ default.SkirmishSaves[i].SelectedEnemyIndex,, 'SkirmishMode');
			return default.SkirmishSaves[i].SelectedEnemyIndex;
		}
	}

	return 0;
}
