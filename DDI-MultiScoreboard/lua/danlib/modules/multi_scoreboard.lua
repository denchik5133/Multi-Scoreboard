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



local MULTI_SCOREBOARD = DanLib.Func.CreateModule('SCOREBOARD')
MULTI_SCOREBOARD:SetTitle(DDI_MSScriptName)
MULTI_SCOREBOARD:SetIcon('CLr2OBI')
MULTI_SCOREBOARD:SetAuthor(DanLib.Author)
MULTI_SCOREBOARD:SetVersion('1.0.0')
-- Multi scoreboard is a modern, minimalistic scoreboard with a user—friendly interface and a set of functional utilities for effective administration. All the necessary tools and quick access to information allow administrators to easily control the gameplay and quickly execute commands.
MULTI_SCOREBOARD:SetDescription('Multi scoreboard is a modern, minimalistic scoreboard with a user—friendly interface and a set of functional utilities for effective administration.')
MULTI_SCOREBOARD:SetColor(Color(30, 144, 255))
MULTI_SCOREBOARD:SetSortOrder(6)

MULTI_SCOREBOARD:AddOption('ServerName', 'Community Name', 'What is the name of your community?', DanLib.Type.String, 'M U L T I   S C O R E B O A R D', nil, nil)
MULTI_SCOREBOARD:AddOption('ShortDescription', 'Community Description', 'What should shown below the community name?', DanLib.Type.String, 'Welcome!', nil, nil)
MULTI_SCOREBOARD:AddOption('OnlineCount', 'Online count', 'Show the online count at the bottom of the scoreboard?', DanLib.Type.Bool, true, nil, nil)
MULTI_SCOREBOARD:AddOption('UserGroups', 'User groups', 'Show user groups?', DanLib.Type.Bool, true, nil, nil)
MULTI_SCOREBOARD:AddOption('ShowJobs', 'Jobs', 'Show Jobs?', DanLib.Type.Bool, true, nil, nil)
MULTI_SCOREBOARD:AddOption('ShowLevel', 'Level', 'Show Level?', DanLib.Type.Bool, false, nil, nil)

local tbl = { 'ulx', 'serverguard', 'xadmin2', 'xadmin', 'fadmin', 'sam', 'ulx' }
MULTI_SCOREBOARD:AddOption('AdminPrefix', 'Admin prefix', 'Type your admin prefix.', DanLib.Type.String, 'sam', false, function()
    local Admins = {}
    for k, v in pairs(tbl) do
        Admins[k] = v
    end
    return Admins
end):SetHelp('Currently supports: ulx, serverguard, xadmin2, xadmin, fadmin, sam, ulx')

MULTI_SCOREBOARD:AddOption('Themes', 'Colour Themes', 'The colours used for various UI elements.', DanLib.Type.Table, {
    ['background'] = {
        color = Color(19, 20, 21, 210),
        description = 'The color of the background.'
    },
    ['text'] = {
        color = Color(30, 144, 255),
        description = 'Тame Community.'
    },
    ['title'] = {
        color = Color(220, 221, 225),
        description = 'Description/categories/name and so on.'
    },
    ['secondaryA'] = {
        color = Color(24, 25, 26, 150),
        description = 'The background color of the categories.'
    },
    ['secondaryB'] = {
        color = Color(24, 25, 26, 180),
        description = 'The color of the list of players.'
    },
    ['hover'] = {
        color = Color(240, 240, 240, 10),
        description = 'The color when pointing the cursor at the list of players.'
    }
}, 'DDI.UI.MLThemes')

MULTI_SCOREBOARD:AddOption('Ranks', 'Ranks', 'Defining and setting up player roles to create a safe and organised play environment.', DanLib.Type.Table, {
    ['owner'] = {
        Name = 'Owner',
        Order = 1,
        Color = Color(255, 165, 0),
        Time = '1707699060'
    },
    ['superadmin'] = {
        Name = 'Superadmin',
        Order = 2,
        Color = Color(127, 255, 0),
        Time = '1707699060'
    },
    ['user'] = {
        Name = 'User',
        Order = 3,
        Color = Color(0, 151, 230),
        Time = '1707699060'
    }
}, 'DDI.UI.MLRanks')

-- MULTI_SCOREBOARD:AddOption('Statistics', 'Statistics', 'Defining and setting up player roles to create a safe and organised play environment.', DanLib.Type.Table, { }, 'DDI.UI.MLStatistics')

MULTI_SCOREBOARD:Register()
