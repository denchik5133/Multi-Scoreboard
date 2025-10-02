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
local SCOREBOARD = DDI.MultiScoreboard

-- Function to get ping data (corrected logic for low ping = good)
function SCOREBOARD:GetPingData(pPlayer)
	local ping = pPlayer:Ping()
    local color, icon
    if (ping > 999) then
        color = Color(255, 100, 0)
        icon = 'rgD2NCX'
    elseif (ping > 170) then
        color = Color(255, 155, 0)
        icon = 'sWuYNta'
    elseif (ping > 100) then
        color = Color(250, 255, 0)
        icon = 'YnhkWeN'
    elseif (ping >= 5) then
        color = Color(0, 255, 0)
        icon = 'bLnGJwP'
    else
        color = Color(255, 100, 0)
        icon = 'rgD2NCX'
    end

    return color, icon
end

-- Level calculation system (can be extended for different gamemodes)
function SCOREBOARD:GetLevelData(level)
    local levelColor, levelIcon
    if (level > 100) then
        levelColor = Color(255, 0, 255) -- Magenta
        levelIcon = 'cmbLnGr'
    elseif (level > 80) then
        levelColor = Color(153, 50, 204) -- Purple
        levelIcon = 'cmbLnGr'
    elseif (level > 60) then
        levelColor = Color(30, 144, 255) -- Blue
        levelIcon = 'Oxput1h'
    elseif (level > 40) then
        levelColor = Color(0, 255, 0) -- Green
        levelIcon = 'Oxput1h'
    elseif (level >= 20) then
        levelColor = Color(255, 69, 0) -- Orange
        levelIcon = 'Gh5Dk35'
    else
        levelColor = Color(255, 255, 255) -- White
        levelIcon = 'Gh5Dk35'
    end
    return levelColor, levelIcon
end

-- Default gamemode configurations
SCOREBOARD.GamemodeConfig = SCOREBOARD.GamemodeConfig or {}
SCOREBOARD.GamemodeConfig['DarkRP'] = {
    getJob = function(pPlayer) 
        return pPlayer:getDarkRPVar('job') or 'Unknown'
    end,
    getTeamName = function(teamID)
        return team.GetName(teamID) or 'Unknown'
    end,
    getTeamColor = function(teamColor) 
        return team.GetColor(teamColor) or Color(255, 255, 255, 255)
    end,
    getPlayerName = function(pPlayer)
        return pPlayer:Name() or 'Unknown' 
    end,
    getLevel = function(pPlayer) 
        return pPlayer:getDarkRPVar('level') or 1
    end,
    isEnabled = function()
    	return DarkRP ~= nil
    end
}

-- Function to get current gamemode configuration (deterministic priority)
function SCOREBOARD:GetGamemodeConfig()
    -- Check DarkRP first (highest priority)
    if self.GamemodeConfig['DarkRP'] and self.GamemodeConfig['DarkRP'].isEnabled and self.GamemodeConfig['DarkRP'].isEnabled() then
        return self.GamemodeConfig['DarkRP'], 'DarkRP'
    end
    
    -- Check other specific gamemodes
    local config = self.GamemodeConfig['DarkRP']
    if (config and config.isEnabled and config.isEnabled()) then
        return config, gamemodeName
    end
end



--- Deck: Below is administration prefix for commands, do not edit below unless you know what to do
-- You can add your own buttons if you know what you are doing


-- ULX
SCOREBOARD.Administration = {}
SCOREBOARD.Administration['ulx'] = {}
SCOREBOARD.Administration['ulx'].goto = function(pPlayer)
    RunConsoleCommand('ulx', 'goto', pPlayer:Nick())
end

SCOREBOARD.Administration['ulx'].bring = function(pPlayer)
    RunConsoleCommand('ulx', 'bring', pPlayer:Nick())
end

SCOREBOARD.Administration['ulx'].send = function(pPlayer)
    RunConsoleCommand('ulx', 'return', pPlayer:Nick())
end

SCOREBOARD.Administration['ulx'].ban = function(pPlayer)
    DBase:RequestTextPopup('BAN', DBase:L('MS#BanTime', { name = pPlayer:Nick() }), '', nil, function(time)
        DBase:RequestTextPopup('BAN', DBase:L('MS#BanReason', { name = pPlayer:Nick(), time = time }), '', nil, function(reason)
            RunConsoleCommand('ulx', 'banid', pPlayer:Nick(), time, reason)
        end)
    end)
end

SCOREBOARD.Administration['ulx'].kick = function(pPlayer)
    DBase:RequestTextPopup('KICK', DBase:L('MS#KickReason', { name = pPlayer:Nick() }), '', nil, function(kick)
        RunConsoleCommand('ulx', 'kick', pPlayer:Nick(), kick)
    end)
end


-- SAM ADMIN
SCOREBOARD.Administration['sam'] = {}
SCOREBOARD.Administration['sam'].goto = function(pPlayer)
    RunConsoleCommand('sam', 'goto', pPlayer:Nick())
end

SCOREBOARD.Administration['sam'].bring = function(pPlayer)
    RunConsoleCommand('sam', 'bring', pPlayer:Nick())
end

SCOREBOARD.Administration['sam'].send = function(pPlayer)
    RunConsoleCommand('sam', 'return', pPlayer:Nick())
end

SCOREBOARD.Administration['sam'].ban = function(pPlayer, time, reason)
    DBase:RequestTextPopup('BAN', DBase:L('MS#BanTime', { name = pPlayer:Nick() }), '', nil, function(time)
        DBase:RequestTextPopup('BAN', DBase:L('MS#BanReason', { name = pPlayer:Nick(), time = time }), '', nil, function(reason)
            RunConsoleCommand('sam', 'banid', pPlayer:Nick(), time, reason)
        end)
    end)
end

SCOREBOARD.Administration['sam'].kick = function(pPlayer)
    DBase:RequestTextPopup('KICK', DBase:L('MS#KickReason', { name = pPlayer:Nick() }), '', nil, function(kick)
        RunConsoleCommand('sam', 'kick', pPlayer:Nick(), kick)
    end)
end


-- FADMIN
SCOREBOARD.Administration['fadmin'] = {}
SCOREBOARD.Administration['fadmin'].goto = function(pPlayer)
    RunConsoleCommand('fadmin', 'goto', pPlayer:Nick())
end

SCOREBOARD.Administration['fadmin'].bring = function(pPlayer)
    RunConsoleCommand('fadmin', 'bring', pPlayer:Nick())
end

SCOREBOARD.Administration['fadmin'].send = function(pPlayer)
    RunConsoleCommand('fadmin', 'return', pPlayer:Nick())
end

SCOREBOARD.Administration['fadmin'].ban = function(pPlayer)
    DBase:RequestTextPopup('BAN', DBase:L('MS#BanTime', { name = pPlayer:Nick() }), '', nil, function(time)
        DBase:RequestTextPopup('BAN', DBase:L('MS#BanReason', { name = pPlayer:Nick(), time = time }), '', nil, function(reason)
            RunConsoleCommand('fadmin', 'banid', pPlayer:Nick(), time, reason)
        end)
    end)
end

SCOREBOARD.Administration['fadmin'].kick = function(pPlayer)
    DBase:RequestTextPopup('KICK', DBase:L('MS#KickReason', { name = pPlayer:Nick() }), '', nil, function(kick)
        RunConsoleCommand('fadmin', 'kick', pPlayer:Nick(), kick)
    end)
end


-- SERVER GUARD
SCOREBOARD.Administration['serverguard'] = {}
SCOREBOARD.Administration['serverguard'].goto = function(pPlayer)
    RunConsoleCommand('sg', 'goto', pPlayer:Nick())
end

SCOREBOARD.Administration['serverguard'].bring = function(pPlayer)
    RunConsoleCommand('sg', 'bring', pPlayer:Nick())
end

SCOREBOARD.Administration['serverguard'].send = function(pPlayer)
    RunConsoleCommand('sg', 'return', pPlayer:Nick())
end

SCOREBOARD.Administration['serverguard'].ban = function(pPlayer)
    DBase:RequestTextPopup('BAN', DBase:L('MS#BanTime', { name = pPlayer:Nick() }), '', nil, function(time)
        DBase:RequestTextPopup('BAN', DBase:L('MS#BanReason', { name = pPlayer:Nick(), time = time }), '', nil, function(reason)
            RunConsoleCommand('sg', 'banid', pPlayer:Nick(), time, reason)
        end)
    end)
end

SCOREBOARD.Administration['serverguard'].kick = function(pPlayer)
    DBase:RequestTextPopup('KICK', DBase:L('MS#KickReason', { name = pPlayer:Nick() }), '', nil, function(kick)
        RunConsoleCommand('sg', 'kick', pPlayer:Nick(), kick)
    end)
end


-- XADMIN
SCOREBOARD.Administration['xadmin'] = {}
SCOREBOARD.Administration['xadmin'].goto = function(pPlayer)
    RunConsoleCommand('xadmin_goto', 'goto', pPlayer:Nick())
end

SCOREBOARD.Administration['xadmin'].bring = function(pPlayer)
    RunConsoleCommand('xadmin_bring', 'bring', pPlayer:Nick())
end

SCOREBOARD.Administration['xadmin'].send = function(pPlayer)
    RunConsoleCommand('xadmin_return', 'return', pPlayer:Nick())
end

SCOREBOARD.Administration['xadmin'].ban = function(pPlayer)
    DBase:RequestTextPopup('BAN', DBase:L('MS#BanTime', { name = pPlayer:Nick() }), '', nil, function(time)
        DBase:RequestTextPopup('BAN', DBase:L('MS#BanReason', { name = pPlayer:Nick(), time = time }), '', nil, function(reason)
            RunConsoleCommand('xadmin_ban', 'banid', pPlayer:Nick(), time, reason)
        end)
    end)
end

SCOREBOARD.Administration['xadmin'].kick = function(pPlayer)
    DBase:RequestTextPopup('KICK', DBase:L('MS#KickReason', { name = pPlayer:Nick() }), '', nil, function(kick)
        RunConsoleCommand('xadmin', 'kick', pPlayer:Nick(), kick)
    end)
end
