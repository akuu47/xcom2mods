------------------------------------------------------------------------------------------------------------------------
!! Gotcha Again v1.42 (War of the Chosen)                                                                             !!
------------------------------------------------------------------------------------------------------------------------
This mod improves on the Line of Sight indicators that are shown when previewing moves in the tactical game.

This version is specifically for use with War of the Chosen. The original release that works in the base game without
War of the Chosen can be found here: http://steamcommunity.com/sharedfiles/filedetails/?id=866874504

This update was created with the permission of its original author.

------------------------------------------------------------------------------------------------------------------------
! Features                                                                                                             !
------------------------------------------------------------------------------------------------------------------------
Indicators for enemy units
-Regular shootable indicator: Shows the red reticle from the base game next to an enemys healthbar when it is shootable
 from the new position.
-Flanking indicator: If the enemy will not only be shootable but also flanked from the new position, a yellow reticle
 will be shown instead of the red one.
-Squadsight indicators: If the unit being moved has Squadsight and will be able to shoot at an enemy because of this
 ability, a red diamond square will be shown instead of the reticle. If the enemy will also be flanked by the unit at
 the new position, the square will be yellow and half empty. 
-Hacking indicators: For units possesing an ability that allows an action using the Gremlin to either damage or hack,
 a cog-icon will be shown when they will be able to use it on something outside the regular sightrange (inside
 it, the regular shootable indicator is shown already).
-Spotted by enemy indicator: If the unit being moved is a VIP (from a rescue or escort mission) a green diamond square
 outline is shown, indicating that the enemy will see the unit. This feature is not necessary anymore with the
 introduction of pod activation indicators, so it is turned off by default.

Indicators for mission objectives
-Neutralize VIP: The arrow pointing at the VIP will change to include the same indicators that are shown for regular
 enemy units depending on the previewed new position.
-Hacking objectives: The arrow pointing at the objective will change to indicate when hacking is possible from the new
 position.
-Destroy object: The arrow icon will change to show when it is shootable from the new position and if it is shootable
 because of Squadsight.

Indicators for hackable doors
-The indicator showing that hacking a door will be possible will appear for units able to hack remotely using the
 Gremlin, if that will be possible from the previewed location.

Indicators for hackable ADVENT towers
-The first time an ADVENT tower is spotted by one of your units, an indicator arrow like the one used for objectives
 will be spawned and the possibility of hacking the tower will then be indicated in this icon.

Indicators for friendly units
-If there will be LOS to a friendly unit and it will be within the moving units sightrange, this will be indicated by a
 green diamond square outline. The indicator is dimmed along with the rest of the unitflag for friendly units, so it can
 be a bit hard to see, but this also means it's non-intrusive.
-If the moving unit has the ability Lone Wolf (from Long War 2) and the destination tile will make the ability active,
 this is indicated by an icon next to the moving units healthbar.

Indicators along the movement path
-Overwatch indicators: When moving through LOS of a hostile unit on overwatch, the icon indicating that they are in
 overwatch will have a red reticle added indicating that their overwatch will be triggered by the move. The tile on
 which the overwatch will trigger is also indicated by a marker. Shots that will be taken by units suppressing the unit
 being moved will be indicated in the same way.
-Pod activation indicators: When a move will trigger a pod activation, an indicator will appear on the unit that will
 spot you and the tile on which you are first spotted will be indicated by a marker as well.
-Smoke indicator: If the final tile of the movement path contains smoke from a smoke-grenade, this will be indicated by
 a marker similar to the hazard marker.
-PsiBomb indicator: If the final tile of the movement path is in the area of effect of an active PsiBomb, this will be
 indicated by a marker.
-Both the overwatch and pod activation indicators only take enemies currently visible to you into account, so they are
 exclusively based on information already available to you through the UI in the vanilla game (otherwise it would be
 cheating!). This means that pods not visible to you before initiating the move that will activate because of it, will
 NOT be indicated, and units in overwatch outside your current vision will also not be indicated. Similarly, units on
 overwatch using long-watch will only be indicated if another hostile unit that will be able to see you on the
 triggering location is visible to you before initiating the move.
-The overwatch activation indicator will sometimes indicate that an overwatch will be triggered on a tile, but if you
 choose to run the overwatch it does not. This is caused by the unit overwatching having Fire Control, preventing it
 from taking the shot of the to-hit chance is below a certain threshold. This is not something that you have any way of
 knowing from the UI, so these are still indicated by the mod!

------------------------------------------------------------------------------------------------------------------------
! Configuration                                                                                                        !
------------------------------------------------------------------------------------------------------------------------
All settings can be changed in-game via Mod Config Menu. This requires the Mod Config Menu mod to be installed, which 
can be found on the workshop at http://steamcommunity.com/sharedfiles/filedetails/?id=667104300.
If Mod Config Menu is not installed, the settings can be changed from XComWOTCGotchaAgainDefaultSettings.ini, where you can 
change the following:

bShowSquadsightHackingIndicator: Enable/disable showing the hacking-indicator for units that are hackable or damagable 
with Haywire Protocol, Combat Protocol, Full Override or Interference because of another units vision.

bShowFriendlyLOSIndicators: Enable/disable the LOS indicators towards friendly units.

bShowVIPSpottedByEnemyIndicators: Enable/disable the indicators for controlled VIPs when they will be spotted by an 
enemy unit. This is not really necessary if using the the pod activation indicators.

bShowLoneWolfIndicator: Enable/disable the Lone Wolf indicator (has no effect without Long War 2).

sIconPack: Set this to the name of the iconpack to use. Currently the following are available, see the Workshop 
screenshots to see what they look like: lewe1, lewe2, lewe3, lewe4, lewe5, vhs0, vhs1 and vhs2.
I recommend using either vhs2 which is used by the mod as default and fallback, or lewe5 that has icons looking a lot 
like the vanilla ones.

bShowTowerHackingArrows: Enable/disable the hacking indicators for ADVENT towers.

bHideTowerArrowsAfterHacking: When set to true, the ADVENT tower indicators will be removed completely after a tower 
has been hacked, thus preventing any tower from being hacked. If set to false, the icon will change to indicate that 
hacking is not possible at all.

bShowRemoteDoorHackingIndicators: Enable/disable showing the doorhacking indicators when remote hacking is possible.

bShowLOSIndicatorsForGrappleDestinations: Enable/disable showing the LOS indicators when selecting a destination for 
the grapple ability.

bDisableHideObjectiveArrowsWhenUsingGrapple: Enable/disable hiding of objective-indicators when selecting a grapple 
destination.

bDisableDimHostileUnitFlagsWhenUsingGrapple: Enable/disable dimming of hostile unit flags when selecting a grapple 
destination.

bUseCustomPathIndicatorSystem: Enable/disable the custom path-indicator system that is required to show the custom 
indicators like overwatch and pod activation triggering.

bShowOverwatchTriggers: Enable/disable the indicators for triggering overwatches.

bShowOverwatchTriggerForSuppression: Enable/disable showing the overwatch trigger when running a suppression.

bShowActivationTriggers: Enable/disable the indicators for triggering pod activations.

bShowNoiseIndicators: Enable/disable the indicators for breaking windows and kicking in doors while not concealed.

bShowSmokeIndicator: Enable/disable the indicator for when the destination tile contains smoke.

bShowPsiBombIndicator: Enable/disable the indicator for when the destination tile is within the AOE of an active 
PsiBomb.

bShowHuntersMarkIndicator: Enable/disable the indicator for when the destination tile is targeted by Hunter's Mark.

------------------------------------------------------------------------------------------------------------------------
! Compatibility                                                                                                        !
------------------------------------------------------------------------------------------------------------------------
This mod overrides the following classes and will be incompatible with any other mods that overrides any of the same 
classes.
UIUnitFlagManager: For the main functionality.
XComGameState_IndicatorArrow: For objective indicator icon replacements.
X2GrapplePuck: So indicators can be shown when selecting grapple locations.
UISpecialMissionHUD_Arrows: To overrule the hiding of objective indicator when using grapple.
XComPathingPawn: Doing path indicators. This is also overriden by Perfect Information. Gotcha Again implements 
compatibility with Perfect Information and tjnome has agreed to implement compatibility the other way as well, but 
until his new update is released, it can cause issues depending on the load order of the two mods. You can fix this 
manually by removing the override from Perfect Information (see the discussion thread on this for instructions).
X2MeleePathingPawn: Needed in order to do the path indicators when selecting targets for melee attacks.

------------------------------------------------------------------------------------------------------------------------
! Todo                                                                                                                 !
------------------------------------------------------------------------------------------------------------------------
-Add option to show the actual path taken when moving, since it differs from the drawn path slightly, causing the
 movement path indicators to sometimes look like they're on a tile you are not passing through (but you are!).
-Replace some of the icons used for the various indicators.

------------------------------------------------------------------------------------------------------------------------
! Known issues                                                                                                         !
------------------------------------------------------------------------------------------------------------------------
-Please let me know if you encounter any issues, and if a savegame demonstrating it can be provided it will make
 fixing it a lot easier on my part.

------------------------------------------------------------------------------------------------------------------------
! Changelog                                                                                                            !
------------------------------------------------------------------------------------------------------------------------
v1.42 (WOTC):
- Fix the display of Advent Towers when "Location Scout" sitrep is active.
- Add cheat option that will always show pod activation indicator even for unrevealed enemies.

v1.41 (WOTC):
- Added indicator for moving to a tile targeted by the Hunter's Mark skill.
- Fixed overwatch triggered indicator to follow WotC behavior where overwatch can trigger on the final
 tile of the move path.

v1.40 (WOTC):
- Renamed to "WOTCGotchaAgain" to try to avoid CTD issues seen when XCOM 2 launcher loads pre-WOTC version of
 Gotcha Again. Ignore any warnings this may cause when loading a save game.

v1.39 (WOTC):
- Update mod to work with War of the Chosen. This breaks compatibility with the vanilla non-WOTC version of XCOM 2.
 Compatibility with Perfect Information is also now broken. I will attempt to restore compatibility if/when Perfect
 Information is updated for WOTC.

v1.38:
-The indicator showing that hacking a door is possible will now trigger at range if hacking it is possible using the
 Gremlin.
-Fixed small bug with the PsiBomb-indicator.
-Switched to a better way of determining the tile to which LOS should be checked for all non-unit targets. Fixes some
 potential false indicators.
-A few minor performance optimizations.
-Fixed a load-order dependent conflict with Long War 2, caused by the Lone Wolf indicator grabbing the range needed from
 the Long War 2 files, causing loot drops to break.
-If concealment is being broken during a move, pod activation and overwatch indicators will now show if relevant on
 tiles after the one on which concealment is broken.
-Path-indicators will now show breaking concealment on the starting tile if using a melee-ability to move.
-Fixed issue with units unable to hack remotely not always generating indicators for non-unit hacking objects.
-Implemented overwatch-trigger indicators for running a suppression.
-Fixed a bug with the overwatch-trigger indicator when running past high-cover in some instances.
-Fixed a potential issue with all LOS checks.
-Fixed a (vanilla?) bug causing objective arrows pointing at rescued VIPs in a game loaded from a save after the VIP was
 freed to be using an incorrect icon.
-Fixed rare bug with indicators when controlling a Sectopod.

v1.36:
-Added the Avatars Dimensional Rift effect to also trigger the PsiBomb indicator instead of only the Codex's PsiBomb.
-Fixed issue with waypoint indicators caused by turning off the custom path-indicator system while in a tactical game.

v1.35:
-Fixed a bug with objective-indicators that would manifest after reloading a tactical save and could cause them to not
 be correctly updated.
-Indicators for ADVENT Towers will now be removed if the tower is destroyed.
-Changed the overwatch-trigger indicator to check for the Long Watch ability instead of just Squadsight when deciding 
 whether an overwatching enemy unit outside regular sightrange with clear LOS will trigger.
-Added hackable indicator for hostile units on overwatch if the selected unit has the Long War 2 ability Interference.
-Added path-indicator for if the final tile contains smoke.
-Added path-indicator for if the final tile is within the area of effect of an active PsiBomb.
-Added indicator for if the Long War 2 ability Lone Wolf will be active on the destination tile.
-Fixed a bug with very specific traversal-chains that did not generate break concealment and noise-markers.
-Implemented in-game configuration of the mod using Mod Config Menu.
-Fixed issue causing the custom path-indicator system to not be used when selecting targets for melee attacks.

v1.34:
-Reinstated some of the indicator cleanups removed in v1.30 (specifically when previewing an ability, like where to
 throw a grenade).
-Redid the way the default indicators are created with the custom path-indicator system. They are now placed on a tile
 the vanilla system would place one, instead of investigating everything myself. This solves some edge-cases where an
 indicator could be missing for primarily poison, but the main motivator for it was performance increases. 
 This means that the options to show indicators for effects the moving unit are already affected by are removed since
 that is not something that is done in vanilla (and not really useful anyway).
 Break-concealment indicators due to making noise are still done my own way since the vanilla system places them one
 tile earlier than they should be!
-Tried fixing an issue with the cursor not disappearing when using a controller.

v1.33:
-Thanks to an awesome tip from tracktwo, the break-concealment markers are now also present with the custom path-
 indicator system!

v1.32:
-Tiles on fire will now be properly detected by the custom path-indicator, so I turned it on by default again. This
 means that overwatch-trigger and pod-activation indicators are back on by default as well!
-Fixed the issue with raised PsiZombies indicating that they would trigger an activation.

v1.31:
-Added option to disable the custom path-indicator system, necessary for generating the overwatch and pod-activation
 trigger indicators, and turned it off by default since it was causing incorrect indicators with tiles containing
 embers. Also turned the "VIP spotted by enemy"-indicator back on by default.
-Made hazard indicators (fire, poison, acid) in the custom path-indicator system take immunities into account.

v1.30:
-Added feature for indicating when overwatch-shots and pod-activations will be triggered.
-Fixed a few bugs that could potentially cause false indicators.
-Changed when indicators are cleared once more.
-Replaced the indicator for hackable units in squadsight and renamed the configuration entry for this.
-Turned off the special "VIP spotted by enemy"-indicator by default, since it is not needed anymore with the new pod-
 activation indicators.
-Enabled the LOS towards friendly units indicator for concealed units, where it will be shown below the concealed icon.
-Moved the LOS towards friendly units for friendlies that are bleeding out so it is shown below the bleedout counter.
-Added an optional alert marker for breaking windows/kicking in doors when not concealed. This is turned off by default.

v1.25:
-Fixed the VIP Spotted by Enemy icons that I broke in v1.22.

v1.24:
-Fixed the issue with hacking objectives on ADVENT trains!
-Fixed an issue where only part of a target was within range, but distance was checked to a part that was not.

v1.23:
-Fixed hacked ADVENT towers not preserving the unhackable indicator through tactical saves.

v1.22:
-Did some heavy refactoring to make the code cleaner and get rid of a few dodgy hacks that was introduced in order to
 handle some of the edge-cases that were causing problems. There's a chance this might have introduced some new bugs, so
 if you experience any please let me know and I'll look into it ASAP.
-Switched to a new method of creating the unit-indicators which will let me use more than the 5 icons available for it
 so far. For now the regular icons are still being used (just in a different way technically).
-The size of a unit is now taken into account, meaning that LOS will be detected correctly towards units taking up more
 than one tile (e.g. Sectopods and Gatekeepers). This includes the height of units, so it will also fix potential issues
 with taller units (e.g. Berserkers and Faceless).
-Added LOS indicators towards friendly units. These can be turned off from the .ini.
-Added some additional clearing of indicators when they are not needed.

v1.21:
-Fixed a couple of false indications caused by a unit having both remote hacking-abilities and the squadsight ability.

v1.20:
-Fixed objective arrows persisting through the stages of Shen's Last Gift mission.
-Implemented a fix for an incorrectly placed objective arrow for the elevator computer in the first stage of Shen's Last
 Gift that prevented indicators from being shown on it.

v1.19:
-LOS indicators will now be shown when selecting a grapple destination.
-Updated the icons for ADVENT towers in both LeWe0FuN's and .vhs's iconpacks.
-The icons for ADVENT towers will change to indicate that hacking is no longer possible or optionally, be removed
 entirely, when a hacking attempt has been made.
-Removed the original and lewe iconpack since lewe5 is basically a better version of both of these.
-Switched to another method of determining whether to show an objective as hackable from an adjacent tile that should be
 more accurate.
-Fixed an issue where loading a tactical save that was saved using a different iconpack that the currently selected one
 would prevent arrow indicator icons from being updated for the remainder of that mission.

v1.18:
-Fix for a false flanking indicator, that was caused by accepting LOS caused by a stepout when checking for LOS for a
 stepout tile, so essentially stepping out twice in the same direction to get LOS.

v1.17:
-Updated ADVENT tower icons in the lewe5 iconpack by LeWe0FuN.
-Yet another stab at a bug spewing forth from the v1.12 fix, that because of the fix from v1.16 would prevent squadsight
 indicators entirely for enemy units that are not able to take cover, unless the enemy unit had squadsight as well
 (previous to v1.16 they would have the green box indicator). There might still be false indicators, if burning or some
 other effect prevents a unit from being able to take cover, but I don't think such an effect exists, this could result
 in no indicator at all even though a shot is possible.

v1.16:
-Fixed another bug caused by the fix from v1.12, causing the green-diamond square indicator to be used instead of the
 red squadsight indicator.
-ADVENT towers will now be checked for LOS at 3 points along its height:, ground floor-level, 1st floor-level and 2nd
 floor-level, to correctly determine if there is LOS to the tower. The feature is still turned off by default until I
 implement the not-hackable-anymore icons for them.

v1.15:
-Implemented a fix for a bug where the mod would use an invalid stepout as the basis for the indicators. I am not
 entirely happy about the fix, as there could theoretically be cases it will not catch, since it relies on 2 out of 3
 possible values in a return value from a native function being correct even though I know for sure the 3rd value is not
 correct.
-Fixed hacking objectives being treated as unhackable if the hacking screen had been brought up and cancelled again,
 without hacking actually being attempted.
-Makes the ADVENT tower indicators take into account that hacking one tower on the map prevents hacking the others.

v1.14:
-Enabled squadsight-indicator for units with CombatProtocol when bShowSquadsightHackingIndicator is enabled.
-Added hacking indicators for ADVENT towers. Both .vhs and LeWe0FuN have kindly created icons for their iconpacks that
 are used to indicate when a tower is hackable. It works by spawning an arrow pointing at the tower when it is seen by
 one of your units for the first time. I have not had the (mis)fortune of my squad spawning with a tower in sightrange
 in any of my tests, so I have not been able to test that there are no quirks in this situation.
-Fixed a bug causing objective-arrows being moved down to floor-level after being manipulated by this mod.
-Fixed a bug caused by the fix implemented in v1.12 that would cause the green diamond-square to be shown for robotic
 units instead of the correct squadsight-indicator when bShowSquadsightHackingIndicator was enabled.

v1.13:
-Fixed an issue where enemies that would be at a distance of exactly the moving units sightrange (using internal units,
 which are 1/64th the width of a tile) would be indicated as hootable, which apparently they are not.
-Added another iconpack created by LeWe0FuN.

v1.12:
-Fixed the issue with units that are not able to take cover that would be marked as shootable when they were not.

v1.11:
-Fixed a case of incorrectly not reporting a position as a flanking one, when there is no LOS from the tile that will
 be used for stepping out into to take the shot.
-Added missing squadsight-version of DestroyAlienRelay-icon to the 4 iconpacks that were added in v1.10.

v1.10:
-Fixed an issue with custom icons having incorrect color nuances.
-Fixed a bug causing Broadcast-objectives to use the UFO-objective icons.
-Changed the way iconpacks are implemented, making it cleaner and easier for me to add new ones.
-Added 4 new iconpacks created by LeWe0FuN.

v1.09:
-Identified and fixed the issue with indicating hostiles that were just outside of sightrange as shootable.

v1.08:
-Excluded units that cannot take cover from using a stepout in my LOS check (fixes issue with SPARK units).
-Added 3 more iconpacks, all created by .vhs. These include modified versions of the UFO, DestroyAlienFacility, and 
 HackWorkstation objectives, which will be used even when no indicators are displayed. The vhs2 pack is now used as the
 default pack of the mod.

v1.07:
-Hacking indicator will no longer show for objectives that have a clear LOS, but is not within the own units
 sightrange since it is not possible to hack these via squadsight. This change only affects hackable objectives, not
 the hackable unit squadsight indicator that was added in v1.06.
-Added a new iconpacks provided by LeWe0FuN that changes the color of some of the objective icons when indicators are
 overlayed to avoid the contrast issues with indicators of the same color as the icon. Currently the original icons
 are still used by default, but this can be changed in the XComGotchaAgain.ini file. Screenshots containing all the
 icons of each pack are available on the Workshop page.

v1.06:
-Removed some unnecessary code related to the temporary fix for Dark VIP icons implemented in v1.02.
-Added optional feature, showing the red diamond square for units that will be hackable because of another units
 vision.

v1.05:
-Implemented a "Spotted by enemy" indicator on hostiles. This will only be shown when previewing moves for a civilian
 unit (VIP), and is represented by the outline of a green diamond square. This might interfere with civilians helping
 defend in Long War 2 missions, but I don't have a savegame with such a mission available to test and I cannot seem to
 spawn one on command using the debugging interface. Please let me know if it causes problem and if possible provide a 
 savegame.

v1.04:
-Tweaked fix for Dark VIP icon, so it should no longer replace the icon for VIPs that should be rescued.
-Implemented alternative way of checking if unit can take cover, fixing the no flanking indicators until initial squad 
 concealment is broken issue.
-Various fixes related to clearing the indicators when not actually previewing moves.

v1.03:
-Reimplemented fix for Dark VIP icon. Let me know if there are any problems with this...

v1.02:
-Fixed issue that caused all non-VIP objectives to be treated as objectives to be hacked and thus resulting in 
 incorrect indicators.
-Removed fix for Dark VIP icon as it was causing problems. Temporary fix implemented, to be fixed properly later.

v1.01:
-Actually fixes the false flanking indicator bug I initially set out to fix.

v1.00:
-Initial release. It lacks thorough testing!

------------------------------------------------------------------------------------------------------------------------
! Credits                                                                                                              !
------------------------------------------------------------------------------------------------------------------------
Inspiration:
MachDelta and BadWolf: Authors of the original Gotcha mod that inspired me to make this mod in order to fix a few bugs
with their mod that is not being maintained anymore. It has since evolved to include a lot more features.

Artwork:
.vhs: The main graphics guy for the mod! Created the logo, the default iconpack plus a few alternate ones and all icons 
that are not part of iconpacks.
LeWe0FuN: Submitted several additional iconpacks included with the mod.
Qrack: Created the modified objective icons included with the early versions of the mod.

Technical assistance:
tracktwo: Identifying the issue causing me to not be able to use the debugger when loading LW2 savegames and providing 
a quick fix for it.
robojumper: Helping me with DLC debugging and quickly identifying the cause of an issue I had with objective indicators 
in Shen's Last Gift.

Testers:
xwynns: Testing and giving input on some of the more complex issues causing incorrect indicators in the earlier 
versions of the mod, helping identify the root-cause as well as offering valuable input on my ideas on to how to fix 
them.
.vhs: In addition to creating most of the art, he has also been awesome at spotting and reporting issues with new 
features I have implemented, as well as providing ideas for features.