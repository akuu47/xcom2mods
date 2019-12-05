class TemplateEdits_Techs extends X2DownloadableContentInfo;
 
static event OnPostTemplatesCreated()
{
		local X2StrategyElementTemplateManager	StrategyElementTemplateManager;
		local array<X2StrategyElementTemplate>	TechTemplates;
		local X2StrategyElementTemplate			TechTemplate;
		local X2TechTemplate					Template;
		local name								TemplateName;

		StrategyElementTemplateManager = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
		TechTemplates = StrategyElementTemplateManager.GetAllTemplatesOfClass(class'X2TechTemplate');

		foreach TechTemplates(TechTemplate){

			Template = X2TechTemplate(TechTemplate);

			TemplateName = Template.DataName;

			//remove experimentals
			switch(TemplateName)
			{
				case 'ExperimentalAmmo':
				case 'ExperimentalGrenade':
				case 'ExperimentalVests':
					Template.Requirements.RequiredTechs.AddItem('NullTech');
					Template.Requirements.bVisibleIfTechsNotMet = false;
					break;
				default:
					break;
			}
		}
		
}