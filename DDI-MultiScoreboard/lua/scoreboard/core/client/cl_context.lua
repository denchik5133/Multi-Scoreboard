/***
 *   @addon         Scoreboard
 *   @version       1.0.0
 *   @release_date  16/09/2025
 *   @author        denchik
 *   @contact       Discord: denchik_gm
 *                  Steam: https://steamcommunity.com/profiles/76561198405398290/
 *                  GitHub: https://github.com/denchik5133
 *
 *   @script        Steam: https://steamcommunity.com/sharedfiles/filedetails/?id=2522126872
 *                  GitHub: https://github.com/denchik5133/Multi-Scoreboard
 *                
 *   @description   Multi scoreboard is a modern, minimalistic scoreboard with a user—friendly interface and a set of functional utilities for effective administration.
 *                  All the necessary tools and quick access to information allow administrators to easily control the gameplay and quickly execute commands.
 *
 *   @usage         !danlibmenu (chat) | danlibmenu (console)
 *   @license       MIT License
 *   @notes         For feature requests or contributions, please open an issue on GitHub.
 */



local DBase = DanLib.Func
local DUtils = DanLib.Utils
local DMaterials = DanLib.Config.Materials
local SCOREBOARD = DDI.MultiScoreboard

function SCOREBOARD:ContextMenu(pPlayer)
	local menu = DBase:UIContextMenu()

	menu:Option(DBase:L('#copy_name'), nil, DMaterials['Copy'], function() 
        DBase:ClipboardText(pPlayer:Name())
    end)

    menu:Option(DBase:L('#copy_id'), nil, DMaterials['Copy'], function() 
        DBase:ClipboardText(pPlayer:SteamID())
    end)

    menu:Option('Open a Steam profile', nil, nil, function() 
        pPlayer:ShowProfile()
    end)

	menu:Open()
end

function SCOREBOARD:ContextMenuAdmin(pPlayer)
	local menu = DBase:UIContextMenu()
	local prefix = DanLib.CONFIG.SCOREBOARD.AdminPrefix

    menu:Option('Move', nil, nil, function()
        SCOREBOARD.Administration[prefix].goto(pPlayer)
    end)

    menu:Option('Bring', nil, nil, function()
        SCOREBOARD.Administration[prefix].bring(pPlayer)
    end)

    menu:Option('Kick', nil, nil, function()
        SCOREBOARD.Administration[prefix].kick(pPlayer)
    end)

    menu:Option('Ban', nil, nil, function()
        SCOREBOARD.Administration[prefix].ban(pPlayer)
    end)

	menu:Open()
end
