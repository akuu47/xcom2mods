"AWC Cost and other Fixes" primarily changes what several abilities which fire the primary weapon cost when granted as an AWC ability. Additionally a couple of other interactions relating to Action Points between AWC and class abilities are fixed. All changes can be individually turned on and off in "XComAWCCostFix.ini" (located in (steam install location)\steamapps\workshop\content\268500\662068623\Config). All except one change are set to be turned on by default.

List of Fixes:
Default to On:
Ability Cost changed to match Primary Weapon fire cost, not hard coded to original class primary weapon fire cost:
	Deadeye
	Rapture
	Hail of bullets
	Kill Zone
Serial changed from requiring 2 remaining action points to activate, to remaining action points of firing the Primary Weapon.
Fixed so they Proc on kills from Second Shot of Rapid Fire or Chain SHot:
	Death from Above
	Serial

Defaults to Off:
Implacable special move only Action Point changed to no longer be consumed by abilities which end a soldiers turn. This avoids Implacable being "wasted" when Death from Above, Serial or Inspire allow another ability to be used after Implcable procs.

If you discover another odd/buggy interaction between abilities, mention it in the comments on Steam and I'll have a look.

Compatability:
Overrides X2AbilityCost_ActionPoints and X2AbilityCost_QuickdrawActionPoints. May also conflict with other mods which modify the above abilities.
It is compatible with AWC Squadsight Fix. That mod does apply the same fix to Hail of Bullets and Rupture, but applying the fix twice does no harm.
Infact I highly recommend that mod for its complementary purpose of making squadsight apply to AWC skills as you would expect.
AWC Squadsight Fix is available here: http://steamcommunity.com/sharedfiles/filedetails/?id=638229956

Other Mods by me:
Cinematic Rapid Fire, available here: http://steamcommunity.com/sharedfiles/filedetails/?id=644426703
This gives Rapid Fire and Chain Shot their cinematic camera back which was removed in the patch. Keeps the other improvements added in the patch.

Original High Hit Dodge Behaviour, available here: http://steamcommunity.com/sharedfiles/filedetails/?id=637362134
This restores the pre-patch behaviour where Hit chance over 100 gradually eliminated dodge chance, not immediately made dodges impossible once Hit chance is 100 or more.