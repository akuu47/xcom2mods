class UIShowEnemies extends Object config(UIShowEnemies_ConfigStructs);

`include(WOTC_ShowEnemiesonMissionPlanning\Src\ModConfigMenuAPI\MCM_API_CfgHelpers.uci)

// Localized Varibales for Titles
var public localized string localized_m_strShadowChamberTitle;
var public localized string localized_m_strEnemiesDetected;
var public localized string localized_PlotType;
var public localized string localized_BiomeType;
var public localized string localized_Time;

// Localized Variables for Content Text
var public localized string localized_Abandoned;
var public localized string localized_Abandoned_Indoors;
var public localized string localized_Abandoned_Occluded;
var public localized string localized_CityCenter;
var public localized string localized_DerelictFacility;
var public localized string localized_LostTower;
var public localized string localized_Facility;
var public localized string localized_Rooftops;
var public localized string localized_SarcophagusRoom;
var public localized string localized_Slums;
var public localized string localized_Shanty;
var public localized string localized_SmallTown;
var public localized string localized_Stronghold;
var public localized string localized_Wilderness;
var public localized string localized_Tunnels_Reverb;
var public localized string localized_Tunnels_Sewer;
var public localized string localized_Tunnels_Subway;
var public localized string localized_Arid;
var public localized string localized_Tundra;
var public localized string localized_Temperate;
var public localized string localized_Xenoform;

struct PositionProperties
{
	var int PosX;
	var int PosY;
};

var config array<PositionProperties> EnemyListPositions;

struct IconStrings
{
	var string Name;
	var string Icon;
};

var config array<IconStrings> PlotIconStrings;
var config array<IconStrings> BiomeIconStrings;
var config array<IconStrings> EnemyNameIconStrings;
var config array<IconStrings> EnemyGroupNameIconStrings;
var config array<IconStrings> BioEnemyGroupNameIconStrings;

// MCM Configuration Variables
// Booleans
var bool				DEBUG;
var bool				bSHOW_WITHOUT_SHADOWCHAMBER;
var bool				bBackground;
var bool				bShowTerrain;
var bool				bShowIcons;
var bool				bShowEnemyIcons;
var bool				bShowBiomeText;
var bool				bShowPlotText;
var bool				bShowTime;
var bool				bShowEnemiesList;
var bool				bShowChosen;
//var bool			bShadowChamberStyle;
// Integers
var int				iEnemiesListPosX;
var int				iEnemiesListPosY;
var int				iSitrepDisplayOffset;
var int				iTerrainPosX;
var int				iTerrainPosY;
var int				iIconSize;
var int				iEnemyIconSize;
var int				iIconVSpace;
var int				iEnemyIconVSpace;
var int				iPanelTerrainSizeX;
var int				iPanelTerrainSizeY;
var int				iPanelEnemiesCountSizeX;
var int				iPanelEnemiesCountSizeY;
var int				iPanelEnemiesListSizeX;
var int				iPanelEnemiesListSizeY;
// Floats
var float			fAlphaBackground;
// Strings
var string			sTerrainTitleColor;
var string			sTerrainColor;
var string			sTimeColor;
var string			sBackground;
var string			sEnemiesListAnchor;
var string			sTerrainAnchor;
// MCM Configuration Variables

// Is a valid Biome present
var bool						IsBiomePresent;

// Has the Shadow Chamber been constructed yet
var bool						IsShadowChamberConstructed;

// Variables used to store content
var name								BackgroundStyle;
var int								AnchorTopRight;
var int								AnchorTopLeft;
var int								PosX;
var int								PosY;
var int								TerrainTitleColor;
var int								TerrainColor;
var int								TimeColor;
var int								SitRepLength;
var string							BiomeStrType;
var string							PlotStrType;
var string							PlotTypeFriendlyName;
var string							LocalizedBiome;
var string							ShadowCount;
var string							ShadowCrew;
var string							EnemyUnknown;
var string							HoursMinutes;
var string							EnemiesIconsString;
var int								iEnemiesListAnchor;
var int								iTerrainAnchor;
var int								ShadowChamberCharactersCount;
var int								ShadowChamberCharacterTemplatesCount;

event OnInit(UIScreen Screen)
{
	local int OffsetY;
	// Init Values
	initValues();

	// ----------------------------- Check if user selected to display Terrain Information ----------------------------- 
	if (bShowTerrain)
	{
		OffsetY = drawTerrainInfo(Screen);
	}

	// ----------------------------- Display Enemies Information ----------------------------- 
	if (bSHOW_WITHOUT_SHADOWCHAMBER || IsShadowChamberConstructed) 
	{
		drawEnemiesList(Screen, OffsetY);
	}
}

`MCM_CH_VersionChecker(class'MCM_Defaults'.default.VERSION, class'UIShowEnemies_MCMScreen'.default.CONFIG_VERSION)

simulated function bool getDEBUG()
{	
	return `MCM_CH_GetValue(class'MCM_Defaults'.default.DEBUG, class'UIShowEnemies_MCMScreen'.default.DEBUG);
}

simulated function bool getbSHOW_WITHOUT_SHADOWCHAMBER()
{	
	return `MCM_CH_GetValue(class'MCM_Defaults'.default.bSHOW_WITHOUT_SHADOWCHAMBER, class'UIShowEnemies_MCMScreen'.default.bSHOW_WITHOUT_SHADOWCHAMBER);
}

simulated function bool getbBackground()
{	
	return `MCM_CH_GetValue(class'MCM_Defaults'.default.bBackground, class'UIShowEnemies_MCMScreen'.default.bBackground);
}

simulated function bool getbShowTerrain()
{	
	return `MCM_CH_GetValue(class'MCM_Defaults'.default.bShowTerrain, class'UIShowEnemies_MCMScreen'.default.bShowTerrain);
}

/*simulated function bool getbShadowChamberStyle()
{	
	return `MCM_CH_GetValue(class'MCM_Defaults'.default.bShadowChamberStyle, class'UIShowEnemies_MCMScreen'.default.bShadowChamberStyle);
}*/

simulated function bool getbShowIcons()
{	
	return `MCM_CH_GetValue(class'MCM_Defaults'.default.bShowIcons, class'UIShowEnemies_MCMScreen'.default.bShowIcons);
}

simulated function bool getbShowEnemyIcons()
{	
	return `MCM_CH_GetValue(class'MCM_Defaults'.default.bShowEnemyIcons, class'UIShowEnemies_MCMScreen'.default.bShowEnemyIcons);
}

simulated function bool getbShowBiomeText()
{	
	return `MCM_CH_GetValue(class'MCM_Defaults'.default.bShowBiomeText, class'UIShowEnemies_MCMScreen'.default.bShowBiomeText);
}

simulated function bool getbShowPlotText()
{	
	return `MCM_CH_GetValue(class'MCM_Defaults'.default.bShowPlotText, class'UIShowEnemies_MCMScreen'.default.bShowPlotText);
}

simulated function bool getbShowTime()
{	
	return `MCM_CH_GetValue(class'MCM_Defaults'.default.bShowTime, class'UIShowEnemies_MCMScreen'.default.bShowTime);
}

simulated function bool getbShowChosen()
{	
	return `MCM_CH_GetValue(class'MCM_Defaults'.default.bShowChosen, class'UIShowEnemies_MCMScreen'.default.bShowChosen);
}

simulated function bool getbShowEnemiesList()
{	
	return `MCM_CH_GetValue(class'MCM_Defaults'.default.bShowEnemiesList, class'UIShowEnemies_MCMScreen'.default.bShowEnemiesList);
}

simulated function int getiEnemiesListPosX()
{	
	return `MCM_CH_GetValue(class'MCM_Defaults'.default.iEnemiesListPosX, class'UIShowEnemies_MCMScreen'.default.iEnemiesListPosX);
}

simulated function int getiEnemiesListPosY()
{	
	return `MCM_CH_GetValue(class'MCM_Defaults'.default.iEnemiesListPosY, class'UIShowEnemies_MCMScreen'.default.iEnemiesListPosY);
}

simulated function int getiSitrepDisplayOffset()
{	
	return `MCM_CH_GetValue(class'MCM_Defaults'.default.iSitrepDisplayOffset, class'UIShowEnemies_MCMScreen'.default.iSitrepDisplayOffset);
}

simulated function int getiTerrainPosX()
{	
	return `MCM_CH_GetValue(class'MCM_Defaults'.default.iTerrainPosX, class'UIShowEnemies_MCMScreen'.default.iTerrainPosX);
}

simulated function int getiTerrainPosY()
{	
	return `MCM_CH_GetValue(class'MCM_Defaults'.default.iTerrainPosY, class'UIShowEnemies_MCMScreen'.default.iTerrainPosY);
}

simulated function float getfAlphaBackground()
{	
	return `MCM_CH_GetValue(class'MCM_Defaults'.default.fAlphaBackground, class'UIShowEnemies_MCMScreen'.default.fAlphaBackground);
}

simulated function string getsTerraintitleColor()
{	
	return `MCM_CH_GetValue(class'MCM_Defaults'.default.sTerraintitleColor, class'UIShowEnemies_MCMScreen'.default.sTerraintitleColor);
}

simulated function string getsTerrainColor()
{	
	return `MCM_CH_GetValue(class'MCM_Defaults'.default.sTerrainColor, class'UIShowEnemies_MCMScreen'.default.sTerrainColor);
}

simulated function string getsTimeColor()
{	
	return `MCM_CH_GetValue(class'MCM_Defaults'.default.sTimeColor, class'UIShowEnemies_MCMScreen'.default.sTimeColor);
}

simulated function string getsBackground()
{	
	return `MCM_CH_GetValue(class'MCM_Defaults'.default.sBackground, class'UIShowEnemies_MCMScreen'.default.sBackground);
}

simulated function int getiIconSize()
{	
	return `MCM_CH_GetValue(class'MCM_Defaults'.default.iIconSize, class'UIShowEnemies_MCMScreen'.default.iIconSize);
}

simulated function int getiEnemyIconSize()
{	
	return `MCM_CH_GetValue(class'MCM_Defaults'.default.iEnemyIconSize, class'UIShowEnemies_MCMScreen'.default.iEnemyIconSize);
}

simulated function int getiIconVSpace()
{	
	return `MCM_CH_GetValue(class'MCM_Defaults'.default.iIconVSpace, class'UIShowEnemies_MCMScreen'.default.iIconVSpace);
}

simulated function int getiEnemyIconVSpace()
{	
	return `MCM_CH_GetValue(class'MCM_Defaults'.default.iEnemyIconVSpace, class'UIShowEnemies_MCMScreen'.default.iEnemyIconVSpace);
}

simulated function int getiPanelTerrainSizeX()
{	
	return `MCM_CH_GetValue(class'MCM_Defaults'.default.iPanelTerrainSizeX, class'UIShowEnemies_MCMScreen'.default.iPanelTerrainSizeX);
}

simulated function int getiPanelTerrainSizeY()
{	
	return `MCM_CH_GetValue(class'MCM_Defaults'.default.iPanelTerrainSizeY, class'UIShowEnemies_MCMScreen'.default.iPanelTerrainSizeY);
}

simulated function int getiPanelEnemiesCountSizeX()
{	
	return `MCM_CH_GetValue(class'MCM_Defaults'.default.iPanelEnemiesCountSizeX, class'UIShowEnemies_MCMScreen'.default.iPanelEnemiesCountSizeX);
}

simulated function int getiPanelEnemiesCountSizeY()
{	
	return `MCM_CH_GetValue(class'MCM_Defaults'.default.iPanelEnemiesCountSizeY, class'UIShowEnemies_MCMScreen'.default.iPanelEnemiesCountSizeY);
}

simulated function int getiPanelEnemiesListSizeX()
{	
	return `MCM_CH_GetValue(class'MCM_Defaults'.default.iPanelEnemiesListSizeX, class'UIShowEnemies_MCMScreen'.default.iPanelEnemiesListSizeX);
}

simulated function int getiPanelEnemiesListSizeY()
{	
	return `MCM_CH_GetValue(class'MCM_Defaults'.default.iPanelEnemiesListSizeY, class'UIShowEnemies_MCMScreen'.default.iPanelEnemiesListSizeY);
}

simulated function string getsEnemiesListAnchor()
{	
	return `MCM_CH_GetValue(class'MCM_Defaults'.default.sEnemiesListAnchor, class'UIShowEnemies_MCMScreen'.default.sEnemiesListAnchor);
}

simulated function string getsTerrainAnchor()
{	
	return `MCM_CH_GetValue(class'MCM_Defaults'.default.sTerrainAnchor, class'UIShowEnemies_MCMScreen'.default.sTerrainAnchor);
}


simulated function UIPanel DrawBackground(UIScreen Screen, UIPanel Panel, bool bAnimateOnInit, name PanelName, name Background, int Anchor, float Alpha, int PositionX, int PositionY, int SizeX, int SizeY)
{
	//local string HexColor;
	//HexColor = class'UIUtilities_Colors'.static.GetHexColorFromState(PanelColor);
	Panel = Screen.Spawn(class'UIPanel', Screen);
	Panel.bAnimateOnInit = bAnimateOnInit; 
	Panel.InitPanel(PanelName,Background);
	Panel.SetAnchor(Anchor);
	//Panel.SetColor(HexColor);
	Panel.SetAlpha(Alpha);
	Panel.SetX(PositionX);
	Panel.SetY(PositionY);
	Panel.SetSize(SizeX, SizeY);
	return Panel;
}

simulated function UIText DrawText(UIScreen Screen, UIText Text, bool bAnimateOnInit, name PanelName, string TextToDisplay, int Anchor, int PositionX, int PositionY, optional int Width)
{
	Text = Screen.Spawn(class'UIText', Screen);
	Text.bAnimateOnInit = bAnimateOnInit;
	Text.InitText(PanelName);
	Text.SetText(TextToDisplay);
	Text.SetAnchor(Anchor);
	Text.SetX(PositionX);
	Text.SetY(PositionY);
	if ((Width > 0) && (Width < 500))
	{
		Text.SetWidth(Width);
	}
	return Text;
}

/*simulated function DrawShadowChamberPanel(UIScreen Screen, int PositionX, int PositionY)
{
	local UIAlertShadowChamberPanel ShadowChamber;
	ShadowChamber = Screen.Spawn(class'UIAlertShadowChamberPanel', Screen);
	ShadowChamber.InitPanel('UIAlertPanel_ShowEnemies', 'Alert_ShadowChamber');
	ShadowChamber.SetPosition(PositionX, PositionY);
	ShadowChamber.MC.BeginFunctionOp("UpdateShadowChamber");
	ShadowChamber.MC.QueueString(localized_m_strShadowChamberTitle);
	ShadowChamber.MC.QueueString(localized_m_strEnemiesDetected);
	ShadowChamber.MC.QueueString(ShadowCrew);
	ShadowChamber.MC.QueueString(ShadowCount);
	ShadowChamber.MC.EndOp();
	ShadowChamber.Show();
}*/

simulated function int getAnchorByText(string AnchorText)
{
	switch (AnchorText)
	{
		case "TopLeft"	: return class'UIUtilities'.const.ANCHOR_TOP_LEFT;
		case "TopRight"	: return class'UIUtilities'.const.ANCHOR_TOP_RIGHT;
		default			: return class'UIUtilities'.const.ANCHOR_TOP_RIGHT;
	}
}

simulated function int getColorByText(string ColorString)
{
	switch (ColorString)
	{
		case "Cyan" : return eUIState_Normal;
		case "Red" : return eUIState_Bad;
		case "Yellow" : return eUIState_Warning;
		case "Orange" : return eUIState_Warning2;
		case "Green" : return eUIState_Good;
		case "Gray" : return eUIState_Disabled;
		case "Faded" : return eUIState_Faded;
		case "Psyonic" : return eUIState_Psyonic;
		case "Header" : return eUIState_Header;
		case "Cash" : return eUIState_Cash;
		case "Thelost" : return eUIState_TheLost;
		default : return eUIState_Disabled;
	}
}

simulated function name getBackgroundByText(string BackgroundText)
{
	switch (BackgroundText)
	{
		case "Panel" : return class'UIUtilities_Controls'.const.MC_X2Background;
		case "Simple" : return class'UIUtilities_Controls'.const.MC_X2BackgroundSimple;
		case "Shading" : return class'UIUtilities_Controls'.const.MC_X2BackgroundShading;
		default : return '';
	}
}

simulated function string getPlotFriendlyName(string PlotString)
{
	switch (PlotString)
	{
		case "Abandoned" : return localized_Abandoned;
		case "Abandoned_Indoors" : return localized_Abandoned_Indoors;
		case "Abandoned_Occluded" : return localized_Abandoned_Occluded;
		case "CityCenter" : return localized_CityCenter;
		case "DerelictFacility" : return localized_DerelictFacility;
		case "LostTower" : return localized_LostTower;
		case "Facility" : return localized_Facility;
		case "Rooftops" : return localized_Rooftops;
		case "SarcophagusRoom" : return localized_SarcophagusRoom;
		case "Slums" : return localized_Slums;
		case "Shanty" : return localized_Shanty;
		case "SmallTown" : return localized_SmallTown;
		case "Stronghold" : return localized_Stronghold;
		case "Wilderness" : return localized_Wilderness;
		case "Tunnels_Reverb" : return localized_Tunnels_Reverb;
		case "Tunnels_Sewer" : return localized_Tunnels_Sewer;
		case "Tunnels_Subway" : return localized_Tunnels_Subway;
		default : return "Friendly PlotString not recognized! " $ PlotString;
	}
}

simulated function string getLocalizedBiome(string BiomeString)
{
	switch (BiomeString)
	{
		case "Arid" : return localized_Arid;
		case "Tundra" : return localized_Tundra;
		case "Temperate" : return localized_Temperate;
		case "Xenoform" : return localized_Xenoform;
		default : return "Localized BiomeString not recognized! " $ BiomeString;
	}
}

simulated function string getBiomeImagePath(string BiomeString)
{
	local string tempString;

	if(GetIconString('Biome', BiomeString, iIconSize, (DEBUG ? iIconVSpace : -iIconSize/2), tempString) != INDEX_NONE)
	{
		return tempString;
	}
	else return "Biome Image Path not recognized! " $ BiomeString;
}

simulated function string getPlotImagePath(string PlotString)
{
	local string tempString;

	if(GetIconString('Plot', PlotString, iIconSize, (DEBUG ? iIconVSpace : -iIconSize/2), tempString) != INDEX_NONE)
	{
		return tempString;
	}
	else return "PlotString not recognized! " $ PlotString;
}

simulated function string getEnemiesIconString(array<X2CharacterTemplate> EnemiesTemplateArray, XComGameState_HeadquartersXCom	XComHQ, optional UIScreen Screen)
{
	local X2CharacterTemplate	CharacterTemplate;
	local string					returnString;
	local int					index;
	local int					ArrayLength;
	//debug
	//local bool					bDebug;
	//local UIText					debugText;
	//local string					debugString;
	//debugString = "";
	//bDebug = true;

	//StringArray = SplitString(ShadowCrewString, ", ", false);
	
	index = 0;
	ArrayLength = EnemiesTemplateArray.Length-1;
	ShadowCrew = "";
	returnString = "";
	ShadowChamberCharacterTemplatesCount = 0;
	foreach EnemiesTemplateArray(Charactertemplate, index)
	{
		if (bShowChosen)
		{
			//debugString $= tempString;	{
			if (Charactertemplate.bIsCivilian)
			{
				continue;
			}

			if (XComHQ.HasSeenCharacterTemplate(Charactertemplate))
			{
				ShadowCrew = ShadowCrew $ Class'UIUtilities_Text'.static.GetColoredText(Charactertemplate.strCharacterName, eUIState_Normal);
				returnString $= getEnemyIconPath(CharacterTemplate);
			}
			else
			{
				ShadowCrew = ShadowCrew $ Class'UIUtilities_Text'.static.GetColoredText(EnemyUnknown, eUIState_Bad);
				returnString $= "<img src='img:///UILibrary_ShowEnemiesonMissionPlanning.Tag_Revealer-WotC' width='" $ iEnemyIconSize $ "' height='" $ iEnemyIconSize $ "' vspace='" $ (DEBUG ? iEnemyIconVSpace-iEnemyIconSize/8 : 2) $ "'> ";
			}
			if (ShadowCrew != "" && index < ArrayLength)
			{
				ShadowCrew = ShadowCrew $ ", ";
			}
		}
		else
		{
			if (Charactertemplate.bIsCivilian||CharacterTemplate.bHideInShadowChamber)
			{
				continue;
			}

			if (XComHQ.HasSeenCharacterTemplate(CharacterTemplate))
			{
				ShadowCrew = ShadowCrew $ Class'UIUtilities_Text'.static.GetColoredText(Charactertemplate.strCharacterName, eUIState_Normal);
				returnString $= getEnemyIconPath(CharacterTemplate);
			}
			else
			{
				ShadowCrew = ShadowCrew $ Class'UIUtilities_Text'.static.GetColoredText(EnemyUnknown, eUIState_Bad);
				returnString $= "<img src='img:///UILibrary_ShowEnemiesonMissionPlanning.Tag_Revealer-WotC' width='" $ iEnemyIconSize $ "' height='" $ iEnemyIconSize $ "' vspace='" $ (DEBUG ? iEnemyIconVSpace-iEnemyIconSize/8 : 2) /*iEnemyIconVSpace-iEnemyIconSize/8*/ $ "'> ";
			}
			if (ShadowCrew != "" && index < ArrayLength)
			{
				ShadowCrew = ShadowCrew $ ", ";
			}
		}
		ShadowChamberCharacterTemplatesCount++;
	}
	ShadowCrew = class'UIUtilities_Text'.static.FormatCommaSeparatedNouns(ShadowCrew);

	// debug
	//if (bDebug)
	//{
		//tempString = "";
		//foreach StringArray(tempString)
		//{
		//	debugString $= tempString$",";
		//}
		//debugString $= class'UIUtilities_Text'.static.  GetColoredText(EnemyUnknown, eUIState_Bad);
		//debugText = DrawText(Screen, debugText, false, 'debugText', debugString, AnchorTopLeft, 600, 600, );
		//debugText.Show();
	//}
	return returnString;
}

simulated function string getEnemyIconPath(X2CharacterTemplate CharacterTemplate)
{
	local string tempString;
	// Specific tests to exclude BioTroopers (who bill be treated in the 'else' block)
	if (InStr(CharacterTemplate.strCharacterName, "Bio") == -1)
	{
		// Specific group test to do some Shaenannigans in order to display the right icon (depends vastly on other mods)
		if ((CharacterTemplate.strCharacterName == "Valentines Viper") || (CharacterTemplate.strCharacterName == "Archon Shaman" ) || (CharacterTemplate.strCharacterName == "Archon Warrior"))
		{
			if(GetIconString('EnemyName', CharacterTemplate.strCharacterName, iEnemyIconSize, (DEBUG ? iEnemyIconVSpace : 2), tempString) != INDEX_NONE) return tempString $ " ";
			else return "Enemy Character Name not recognized! " $ CharacterTemplate.strCharacterName;
		}
		else
		{
			if(GetIconString('EnemyGroupName', string(CharacterTemplate.CharacterGroupName), iEnemyIconSize, (DEBUG ? iEnemyIconVSpace : 2), tempString) != INDEX_NONE) return tempString $ " ";
			else return "Enemy Group not recognized! " $ string(CharacterTemplate.CharacterGroupName);
		}
	}
	// If Bio Troopers
	else
	{
		if(GetIconString('BioEnemyGroupName', string(CharacterTemplate.CharacterGroupName), iEnemyIconSize, (DEBUG ? iEnemyIconVSpace : 2), tempString) != INDEX_NONE) return tempString $ " ";
		else return "Bio Enemy Character Group not recognized! " $ string(CharacterTemplate.CharacterGroupName);
	}
}

simulated function int GetIconString(name Type, string PropertyValue, int IconSize, int IconVSpace, out string OutString)
{
	local int index;

	switch(Type)
	{
		case 'Biome' :
			index = BiomeIconStrings.Find('Name', PropertyValue);
			if(index != INDEX_NONE)
			{
				OutString = class'UIUtilities_Text'.static.InjectImage(class'UIUtilities_Image'.static.ValidateImagePath(BiomeIconStrings[index].Icon), IconSize, IconSize, IconVSpace);
				return index;
			}
			else return INDEX_NONE;
			break;
		case 'Plot' :
			index = PlotIconStrings.Find('Name', PropertyValue);
			if(index != INDEX_NONE)
			{
				OutString = class'UIUtilities_Text'.static.InjectImage(class'UIUtilities_Image'.static.ValidateImagePath(PlotIconStrings[index].Icon), IconSize, IconSize, IconVSpace);
				return index;
			}
			else return INDEX_NONE;
			break;
		case 'EnemyName' :
			index = EnemyNameIconStrings.Find('Name', PropertyValue);
			if(index != INDEX_NONE)
			{
				OutString = class'UIUtilities_Text'.static.InjectImage(class'UIUtilities_Image'.static.ValidateImagePath(EnemyNameIconStrings[index].Icon), IconSize, IconSize, IconVSpace);
				return index;
			}
			else return INDEX_NONE;
			break;
		case 'EnemyGroupName' :
			index = EnemyGroupNameIconStrings.Find('Name', PropertyValue);
			if(index != INDEX_NONE)
			{
				OutString = class'UIUtilities_Text'.static.InjectImage(class'UIUtilities_Image'.static.ValidateImagePath(EnemyGroupNameIconStrings[index].Icon), IconSize, IconSize, IconVSpace);
				return index;
			}
			else return INDEX_NONE;
			break;
		case 'BioEnemyGroupName' :
			index = BioEnemyGroupNameIconStrings.Find('Name', PropertyValue);
			if(index != INDEX_NONE)
			{
				OutString = class'UIUtilities_Text'.static.InjectImage(class'UIUtilities_Image'.static.ValidateImagePath(BioEnemyGroupNameIconStrings[index].Icon), IconSize, IconSize, IconVSpace);
				return index;
			}
			else return INDEX_NONE;
			break;
		default :
			return INDEX_NONE;
			break;
	}
}

simulated function initValues(optional UIScreen Screen)
{
	local XComGameState_MissionSite			MissionState;
	local XComGameState_HeadquartersXCom		XComHQ;
	local GeneratedMissionData				MissionData;
	local array<X2CharacterTemplate>			ShadowChamberCrewCharacterTemplateArray;
	local int								TotalNumberofSeconds;
	local int								Remainder;
	local int								Minutes;
	local int								Hours;
	local string								sMinutes;
	local string								sHours;
	local UIMission							Mission;

	// Getting XCOM MissionData and MissionState; this is done to extract values to display on screen (like enemies list from Shadow Chamber :-))
	XComHQ = class'UIUtilities_Strategy'.static.GetXComHQ();
	MissionData = XComHQ.GetGeneratedMissionData(XComHQ.MissionRef.ObjectID);	

	bSHOW_WITHOUT_SHADOWCHAMBER = getbSHOW_WITHOUT_SHADOWCHAMBER();
	if (XComHQ.GetFacilityByName('ShadowChamber') != none)
	{
		IsShadowChamberConstructed = true;
	}
	else { IsShadowChamberConstructed = false; }

	if(bSHOW_WITHOUT_SHADOWCHAMBER && !IsShadowChamberConstructed)	UpdateMissionSchedules(XComHQ.MissionRef);

	MissionState = XComGameState_MissionSite(`XCOMHISTORY.GetGameStateForObjectID(XComHQ.MissionRef.ObjectID));

	//MissionState.UpdateSelectedMissionData();
	MissionState.GetShadowChamberMissionInfo(ShadowChamberCharactersCount, ShadowChamberCrewCharacterTemplateArray);

	TotalNumberofSeconds = int(MissionState.GetCurrentTime().m_fTime);
	
	Remainder = TotalNumberofSeconds % 3600;
	Hours = TotalNumberofSeconds / 3600;
	Minutes = Remainder / 60;
	sHours = string(Hours);
	sMinutes = string(Minutes);
	if (Hours < 10)
	{
		sHours = "0" $ sHours;
	}
	if (Minutes < 10)
	{
		sMinutes = "0" $ sMinutes;
	}
	HoursMinutes = sHours $ " : " $ sMinutes;
	
	ShadowCount = MissionState.m_strShadowCount;
	EnemyUnknown = MissionState.m_strEnemyUnknown;
	PlotStrType = MissionData.Plot.strType;
	SitRepLength = MissionData.SitReps.Length;
	// If Biome exists
	if (MissionData.Biome.strType != "")
	{
		// This is done to store if Biome is present or not, in order to symplify tests
		IsBiomePresent = true;
		BiomeStrType = MissionData.Biome.strType;
	}
	else { IsBiomePresent = false; }

	// Init Config Variables with MCM Values or Default Values
	bBackground = getbBackground();
	bShowTerrain = getbShowTerrain();
	bShowEnemiesList = getbShowEnemiesList();
	bShowTime = getbShowTime();
	bShowChosen = getbShowChosen();
	//bShadowChamberStyle = getbShadowChamberStyle();
	bShowIcons = getbShowIcons();
	bShowEnemyIcons = getbShowEnemyIcons();
	bShowBiomeText = getbShowBiomeText();
	bShowPlotText = getbShowPlotText();
	iSitrepDisplayOffset = getiSitrepDisplayOffset();
	fAlphaBackground = getfAlphaBackground();
	sTerrainTitleColor = getsTerrainTitleColor();
	sTerrainColor = getsTerrainColor();
	sTimeColor = getsTimeColor();
	sBackground = getsBackground();
	iIconSize = getiIconSize();
	iEnemyIconSize = getiEnemyIconSize();
	sEnemiesListAnchor = getsEnemiesListAnchor();
	DEBUG = getDEBUG();

	if(DEBUG)
	{
		sTerrainAnchor = getsTerrainAnchor();
		iEnemiesListPosX = getiEnemiesListPosX();
		iEnemiesListPosY = getiEnemiesListPosY();
		iTerrainPosX = getiTerrainPosX();
		iTerrainPosY = getiTerrainPosY();
		iPanelTerrainSizeX = getiPanelTerrainSizeX();
		iPanelTerrainSizeY = getiPanelTerrainSizeY();
		iPanelEnemiesCountSizeX = getiPanelEnemiesCountSizeX();
		iPanelEnemiesCountSizeY = getiPanelEnemiesCountSizeY();
		iPanelEnemiesListSizeX = getiPanelEnemiesListSizeX();
		iPanelEnemiesListSizeY = getiPanelEnemiesListSizeY();
		iEnemyIconVSpace = getiEnemyIconVSpace();
		iIconVSpace = getiIconVSpace();
	}

	// Init Anchor int variables
	iEnemiesListAnchor = getAnchorByText(sEnemiesListAnchor);
	iTerrainAnchor = getAnchorByText(sTerrainAnchor);

	// Get background style, plot friendly name, and localized biome
	BackgroundStyle = getBackgroundByText(sBackground);
	PlotTypeFriendlyName = getPlotFriendlyName(MissionData.Plot.strType);
	LocalizedBiome = getLocalizedBiome(MissionData.Biome.strType);

	// Get int values (eUIState) from text for text coloring
	TerrainTitleColor = getColorByText(sTerrainTitleColor);
	TerrainColor = getColorByText(sTerrainColor);
	TimeColor = getColorByText(sTimeColor);

	// Construct Icon String to be dispayed in Enemies List Panel if User selected to do so
	// Compatibility with new type of enemies is tricky and absolutely not guaranteed!
	// I've gotta find a way to display something even if I can't recognize an enemy Name...
	EnemiesIconsString = getEnemiesIconString(ShadowChamberCrewCharacterTemplateArray, XComHQ, );
}

simulated function int drawTerrainInfo(UIScreen Screen)
{
	local UIText		Plot;
	local UIText		Biome;
	local UIText		Time;
	local UIPanel	PlotPanel;
	local UIPanel	BiomePanel;
	local UIPanel	TimePanel;
	local string		PlotStringToDisplay;
	local string		BiomeStringToDisplay;
	local string		TimeStringToDisplay;
	local int		OffestY;

	if(!DEBUG)
	{
		iPanelTerrainSizeY = iIconSize + 10;
	}

	// Check if user selected to display the faded Background under displayed text, if so, display background
	if (bBackground)
	{								
		if (bShowTerrain)
		{
			// Draw Panel
			PlotPanel = DrawBackground(Screen, PlotPanel, false, 'PlotPanel', BackgroundStyle, iTerrainAnchor, fAlphaBackground, iTerrainPosX, iTerrainPosY, iPanelTerrainSizeX, iPanelTerrainSizeY);
			if (IsBiomePresent)
			{					
				// Draw Panel
				BiomePanel = DrawBackground(Screen, BiomePanel, false, 'BiomePanel', BackgroundStyle, iTerrainAnchor, fAlphaBackground, iTerrainPosX, iTerrainPosY + iPanelTerrainSizeY + 5, iPanelTerrainSizeX, iPanelTerrainSizeY);
				if  (bShowTime) { TimePanel = DrawBackground(Screen, TimePanel, false, 'TimePanel', BackgroundStyle, iTerrainAnchor, fAlphaBackground, iTerrainPosX, iTerrainPosY + iPanelTerrainSizeY * 2 + 10, iPanelTerrainSizeX, iPanelTerrainSizeY); }
				BiomePanel.Show();
			}
			else
			{
				if  (bShowTime) { TimePanel = DrawBackground(Screen, TimePanel, false, 'TimePanel', BackgroundStyle, iTerrainAnchor, fAlphaBackground, iTerrainPosX, iTerrainPosY + iPanelTerrainSizeY + 5, iPanelTerrainSizeX, iPanelTerrainSizeY); }
			}
			if  (bShowTime) { TimePanel.Show(); }
			PlotPanel.Show();
		
			// Construct Display String
			PlotStringToDisplay = class'UIUtilities_Text'.static.GetColoredText(localized_PlotType, TerrainTitleColor);
			if (bShowIcons)
			{
				PlotStringToDisplay = PlotStringToDisplay $ "  " $ getPlotImagePath(PlotStrType);
			}
			if (bShowPlotText)
			{
				PlotStringToDisplay = PlotStringToDisplay $ " " $ class'UIUtilities_Text'.static.GetColoredText(PlotTypeFriendlyName, TerrainColor);
			}
			// Draw Text
			Plot = DrawText(Screen, Plot, false, 'Plot', PlotStringToDisplay, iTerrainAnchor, iTerrainPosX + 35, iTerrainPosY + 5, iPanelTerrainSizeX - 35);
			Plot.Show();
			OffestY = iTerrainPosY + iPanelTerrainSizeY + 10;

			TimeStringToDisplay = class'UIUtilities_Text'.static.GetColoredText(localized_Time,TerrainTitleColor) $ " " $ class'UIUtilities_Text'.static.GetColoredText(HoursMinutes, TimeColor);
			// If Biome exists
			if (IsBiomePresent)
			{
				BiomeStringToDisplay = class'UIUtilities_Text'.static.GetColoredText(localized_BiomeType, TerrainTitleColor);
				if (bShowIcons)
				{
					BiomeStringToDisplay = BiomeStringToDisplay $ "  " $ getBiomeImagePath(BiomeStrType);
				}
				// Draw Text
				if (bShowBiomeText)
				{
					BiomeStringToDisplay = BiomeStringToDisplay $ " " $ class'UIUtilities_Text'.static.GetColoredText(LocalizedBiome, TerrainColor);
				}
				Biome = DrawText(Screen, Biome, false, 'Biome', BiomeStringToDisplay, iTerrainAnchor, iTerrainPosX + 35, iTerrainPosY + iPanelTerrainSizeY + 10, iPanelTerrainSizeX - 35);
				OffestY = iTerrainPosY + iPanelTerrainSizeY * 2 + 20;
				if (bShowTime)
				{
					Time = DrawText(Screen, Time, false, 'Time', TimeStringToDisplay, iTerrainAnchor, iTerrainPosX + 35, iTerrainPosY + iPanelTerrainSizeY * 2 + 20, );
					OffestY = iTerrainPosY + iPanelTerrainSizeY * 3 + 30;
				}
				Biome.Show();
			}
			else
			{
				if (bShowTime)
				{
					Time = DrawText(Screen, Time, false, 'Time', TimeStringToDisplay, iTerrainAnchor, iTerrainPosX + 35, iTerrainPosY + iPanelTerrainSizeY + 10, );
					OffestY = iTerrainPosY + iPanelTerrainSizeY * 2 + 20;
				}
			}
			if (bShowTime) { Time.Show(); }
		}
	}
	return OffestY;
}

simulated function drawEnemiesList(UIScreen Screen, int Offset)
{
	local UIText		EnemiesList;
	local UIText		EnemiesDetectedTitle;
	local UIText		EnemiesIcons;
	local UIPanel	EnemiesPanel;
	local UIPanel	EnemiesPanelDetail;
	local UIPanel	EnemiesIconsPanel;
	local int		iPanelEnemiesIconSizeY;
	local float		MaxEnemiesIconsPerLine;

	if(!DEBUG)
	{
		switch(sEnemiesListAnchor)
		{
			case "TopLeft" : 
				PosX=EnemyListPositions[0].PosX;
				PosY=EnemyListPositions[0].PosY;
				if (SitRepLength > 0) PosY+=iSitrepDisplayOffset;
				break;
			case "TopRight" :
				PosX=EnemyListPositions[1].PosX;
				if(EnemyListPositions[1].PosY >= Offset) PosY=EnemyListPositions[1].PosY;
				else PosY=Offset;
				break;
		}
	}
	//iPanelEnemiesListSizeYSingleLine = iPanelEnemiesCountSizeY;
	// Check for a SITREP in order to adjust enemies list position if Enemies List is positioned to the left side, elsewhere you don't want to apply offset
	else
	{
		if (SitRepLength > 0 && sEnemiesListAnchor == "TopLeft")
		{
			PosY=iEnemiesListPosY+iSitrepDisplayOffset;
		}
		else
		{
			PosY=iEnemiesListPosY;
		}
		PosX=iEnemiesListPosX;
	}

	// For Enemies Icon, we've got to get the size of Icons, multiply it by the number of Icons to be displayed
	// then if total length is superior to Panel Length, set Panel Y size accordingly
	MaxEnemiesIconsPerLine = Round(float(iPanelEnemiesListSizeX - 35) / float(iEnemyIconSize + 14));
	if(ShadowChamberCharacterTemplatesCount > MaxEnemiesIconsPerLine)
	// * (iEnemyIconSize + 10) > iPanelEnemiesListSizeX - 35)
	{
		iPanelEnemiesIconSizeY = FCeil(ShadowChamberCharacterTemplatesCount / MaxEnemiesIconsPerLine) * (iEnemyIconSize + 14);
	}
	else iPanelEnemiesIconSizeY = iEnemyIconSize + 14;

	// Check if user selected to display the selected Background under displayed text, if so, display background
//	if (bShadowChamberStyle)
//	{
//		DrawShadowChamberPanel(Screen, PosX, PosY);
//	}
//	else
//	{
		if (bBackground)
		{								
			// Draw Panel
			EnemiesPanel = DrawBackground(Screen, EnemiesPanel, false, 'EnemiesPanel', BackgroundStyle, iEnemiesListAnchor, fAlphaBackground, PosX, PosY, iPanelEnemiesCountSizeX, iPanelEnemiesCountSizeY);
			if (bShowEnemiesList)
			{
				EnemiesPanelDetail = DrawBackground(Screen, EnemiesPanelDetail, false, 'EnemiesPanelDetail', BackgroundStyle, iEnemiesListAnchor, fAlphaBackground, PosX, PosY + iPanelEnemiesCountSizeY + 5, iPanelEnemiesListSizeX, iPanelEnemiesListSizeY);
				EnemiesPanelDetail.Show();
			}
			EnemiesPanel.Show();
		}
		// Draw Text
		EnemiesDetectedTitle = DrawText(Screen, EnemiesDetectedTitle, false, 'EnemiesDetectedTitle', class'UIUtilities_Text'.static.GetSizedText(class'UIUtilities_Text'.static.GetColoredText(localized_m_strEnemiesDetected $ " " $ ShadowCount, eUIState_Bad),25), iEnemiesListAnchor, PosX + 35, PosY + 5, iPanelEnemiesCountSizeX - 35);
		if (bShowEnemiesList)
		{
			EnemiesList = DrawText(Screen, EnemiesList, false, 'EnemiesList', class'UIUtilities_Text'.static.GetColoredText(ShadowCrew, eUIState_Normal), iEnemiesListAnchor, PosX + 35, PosY + iPanelEnemiesCountSizeY + 10, iPanelEnemiesListSizeX - 35);
			EnemiesList.Show();
		}
		EnemiesDetectedTitle.Show();

		// Check if user chose to display Enemies Icons
		if (bShowEnemyIcons)
		{
			if (bBackground)
			{								
				if (bShowEnemiesList)
				{
					EnemiesIconsPanel = DrawBackground(Screen, EnemiesIconsPanel, false, 'EnemiesIconsPanel', BackgroundStyle, iEnemiesListAnchor, fAlphaBackground, PosX, PosY + iPanelEnemiesListSizeY + iPanelEnemiesCountSizeY + 10, iPanelEnemiesListSizeX, iPanelEnemiesIconSizeY /*iEnemyIconSize + 20*/);
				}
				else
				{
					EnemiesIconsPanel = DrawBackground(Screen, EnemiesIconsPanel, false, 'EnemiesIconsPanel', BackgroundStyle, iEnemiesListAnchor, fAlphaBackground, PosX, PosY + iPanelEnemiesCountSizeY + 5, iPanelEnemiesListSizeX, iPanelEnemiesIconSizeY /*iEnemyIconSize + 20*/);
				}
				EnemiesIconsPanel.ProcessMouseEvents();
				EnemiesIconsPanel.SetTooltipText(ShadowCrew, localized_m_strEnemiesDetected);
				EnemiesIconsPanel.Show();
			}
			if (bShowEnemiesList)
			{
				EnemiesIcons = DrawText(Screen, EnemiesIcons, false, 'EnemiesIcons', EnemiesIconsString, iEnemiesListAnchor, PosX + 35, PosY + iPanelEnemiesListSizeY + iPanelEnemiesCountSizeY + 15, iPanelEnemiesListSizeX - 35);
			}
			else
			{
				EnemiesIcons = DrawText(Screen, EnemiesIcons, false, 'EnemiesIcons', EnemiesIconsString, iEnemiesListAnchor, PosX + 35, PosY + iPanelEnemiesCountSizeY + 10, iPanelEnemiesListSizeX - 35);
			}
			EnemiesIcons.Show();
		}
//	}
}

simulated function UpdateMissionSchedules(StateObjectReference MissionRef)
{
	local XComGameState NewGameState;
	local XComGameState_MissionSite MissionState;
	local XComOnlineEventMgr EventManager;
	local array<X2DownloadableContentInfo> DLCInfos;
	local bool bSpawnUpdateFromDLC;
	local int i;

	// Check for update to spawning from DLC
	EventManager = `ONLINEEVENTMGR;
	DLCInfos = EventManager.GetDLCInfos(false);
	bSpawnUpdateFromDLC = false;
	for (i = 0; i < DLCInfos.Length; ++i)
	{
		if (DLCInfos[i].UpdateMissionSpawningInfo(MissionRef))
		{
			bSpawnUpdateFromDLC = true;
		}
	}

	// If we have a spawning update, clear out the missions selected spawn data so that it regenerates
	if (bSpawnUpdateFromDLC)
	{
		MissionState = XComGameState_MissionSite(`XCOMHISTORY.GetGameStateForObjectID(MissionRef.ObjectID));

		if (MissionState.SelectedMissionData.SelectedMissionScheduleName != '')
		{
			NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Clear Cached Mission Data");
			MissionState = XComGameState_MissionSite(NewGameState.ModifyStateObject(class'XComGameState_MissionSite', MissionState.ObjectID));
			MissionState.SelectedMissionData.SelectedMissionScheduleName = '';
			`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
		}
	}

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Update Cached Mission Data");
	MissionState = XComGameState_MissionSite(NewGameState.ModifyStateObject(class'XComGameState_MissionSite', MissionRef.ObjectID));
	if (MissionState.UpdateSelectedMissionData()) // This function also updates the Shadow Chamber strings
	{
		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	}
	else
	{
		NewGameState.PurgeGameStateForObjectID(MissionState.ObjectID);
		`XCOMHISTORY.CleanupPendingGameState(NewGameState);
	}		
}

simulated function debugScreen(UISCreen Screen, string debugText)
{
	local UIText UIDebugText;

	UIDebugText = DrawText(Screen, UIDebugText, false, 'DebugText', class'UIUtilities_Text'.static.GetColoredText(debugText, eUIState_Bad), class'UIUtilities'.const.ANCHOR_MIDDLE_CENTER, 0, -100, );
	UIDebugText.Show();
}

defaultproperties
{
	sTerrainAnchor = "TopRight";
	iTerrainAnchor = ANCHOR_TOP_RIGHT;
	iTerrainPosX = -400;
	iTerrainPosY = 30;
	// Terrain Panel Size (for BOTH panels)
	iPanelTerrainSizeX = 400;
	iPanelTerrainSizeY = 45;

	// Enemies Count Panel Size
	iPanelEnemiesCountSizeX = 400;
	iPanelEnemiesCountSizeY = 40;

	// Enemies List Panel Size
	iPanelEnemiesListSizeX = 400;
	iPanelEnemiesListSizeY = 130;
	iEnemyIconVSpace = 15;
	iIconVSpace = -12;
}