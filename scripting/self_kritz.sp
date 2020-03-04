#pragma semicolon 1
#include <tf2_stocks>
#include <sdkhooks>

#define PLUGIN_VERSION  "1.0"

/**
 * Description: Functions to return information about weapons.
 */
#tryinclude <weapons>
#if !defined _weapons_included
    stock GetCurrentWeaponClass(client, String:name[], maxlength)
    {
        new index = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
        if (index > 0)
            GetEntityNetClass(index, name, maxlength);
    }
#endif

public Plugin:myinfo = {
	name = "Self Kritzkrig",
	author = "pily",
	description = "earn self kritz on kritz uber",
	version = PLUGIN_VERSION,
	url = "http://github.com/pily"
};

public OnMapStart()
{
   HookEvent("player_chargedeployed", event_uberdeployed);
}

public Action:event_uberdeployed(Handle:event, const String:name[], bool:dontBroadcast)
{
    new client = GetClientOfUserId(GetEventInt(event, "userid"));
    //new String:s[64];

    if (IsClientInGame(client) && IsPlayerAlive(client))
    {
        new team = GetClientTeam(client);
        if (team >= 2 && team <= 3)
        {
            if (TF2_GetPlayerClass(client) == TFClass_Medic)
            {
                
                decl String:classname[64];
                GetCurrentWeaponClass(client, classname, sizeof(classname));
                
                if (StrEqual(classname, "CWeaponMedigun"))
                {
                    new cond = TF2_IsPlayerInCondition(client, TFCond_Kritzkrieged);
                    if(cond)
                    {
                        new weapon = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");

                        if (GetEntProp(weapon, Prop_Send, "m_iItemDefinitionIndex") == 35)
                        {
                            PrintToChat(client, "kritz_on",cond);
                            TF2_AddCondition(client, TFCond_CritOnWin, 8.0);
                        }
                        
                    }
                }
            }
        }
    }
    return Plugin_Continue;
}