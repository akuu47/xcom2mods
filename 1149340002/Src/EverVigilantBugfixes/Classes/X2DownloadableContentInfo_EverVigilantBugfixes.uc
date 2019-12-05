class X2DownloadableContentInfo_EverVigilantBugfixes extends X2DownloadableContentInfo;

static event OnPostTemplatesCreated() {
   local X2AbilityTemplateManager	 AllAbilities;
   local X2AbilityTemplate           CurrentAbility;
   
   AllAbilities = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
   // EVER VIGILANT FOG OF WAR FIX
   CurrentAbility = AllAbilities.FindAbilityTemplate('Overwatch');
   CurrentAbility.AbilityTargetConditions.AddItem(new class'X2Condition_EverVigilant_FogFix_JFB'); 
   CurrentAbility = AllAbilities.FindAbilityTemplate('Longwatch');
   CurrentAbility.AbilityTargetConditions.AddItem(new class'X2Condition_EverVigilant_FogFix_JFB'); 
   CurrentAbility = AllAbilities.FindAbilityTemplate('SniperRifleOverwatch');
   CurrentAbility.AbilityTargetConditions.AddItem(new class'X2Condition_EverVigilant_FogFix_JFB'); 
   CurrentAbility = AllAbilities.FindAbilityTemplate('PistolOverwatch');
   CurrentAbility.AbilityTargetConditions.AddItem(new class'X2Condition_EverVigilant_FogFix_JFB');
   CurrentAbility = AllAbilities.FindAbilityTemplate('EverVigilantTrigger');
   CurrentAbility.AbilityTargetConditions.AddItem(new class'X2Condition_EverVigilant_FogFix_JFB');
   CurrentAbility = AllAbilities.FindAbilityTemplate('DeepCoverTrigger');
   CurrentAbility.AbilityTargetConditions.AddItem(new class'X2Condition_EverVigilant_FogFix_JFB');
}
