#pragma semicolon 1
#define PLUGIN_AUTHOR "PigPig"
#define PLUGIN_VERSION "0.0.1"

//#define DEBUG

#include <sourcemod>
#include <tf2_stocks>
//Cvar setup
static ConVar cvar_Enabled;


public Plugin myinfo = 
{
	name = "TF:No Shadows",
	author = PLUGIN_AUTHOR,
	description = "Remove world shadows",
	version = PLUGIN_VERSION,
	url = "None, Sorry."
};
public void OnPluginStart()
{
	cvar_Enabled = CreateConVar("tfns_disable_shadows", "1", "Enable/Disable the plugin 1/0", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	HookEvent("teamplay_round_start", Event_Round_Start);
	if(cvar_Enabled.BoolValue)
		SetShadowController();//When the plugin is loaded, check these things.
}
public Action:Event_Round_Start(Event event, const char[] name, bool dontBroadcast)
{
	if(cvar_Enabled.BoolValue)//Yes, kill shadows.
		SetShadowController();
}
void SetShadowController()
{
	bool isControllerFound = false;
	new ent = -1;
	while ((ent = FindEntityByClassname(ent, "shadow_control")) != -1)
	{
		if(IsValidEntity(ent))
		{
			SetVariantInt(1);
			AcceptEntityInput(ent, "SetShadowsDisabled");
			isControllerFound = true;
			#if defined DEBUG
			PrintToServer("[DEBUG]Found shadow entity, Disabling shadows.");
			#endif
		}
	}
	
	if(!isControllerFound)
	{
		CreateCustomShadowController();
	}
}
void CreateCustomShadowController()
{
	new ent = CreateEntityByName("shadow_control"); //Some maps don't include this entity, shame on them.
	if(IsValidEntity(ent))
	{
		DispatchKeyValue(ent, "disableallshadows", "1");
		DispatchSpawn(ent);
		#if defined DEBUG
			PrintToServer("[DEBUG]Couldn't find shadow_control, Created new entity.");
		#endif
	}
}
