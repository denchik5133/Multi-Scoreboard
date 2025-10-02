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
local DHook = DanLib.Hook
local DCustomUtils = DanLib.CustomUtils.Create

if IsValid(DDI.MultiScoreboard.Сontainer) then
    DDI.MultiScoreboard.Сontainer:Remove()
end

function DDI.MultiScoreboard:Open()
    if IsValid(self.Сontainer) then
        self.Сontainer:Remove()
    end

    local container = DCustomUtils()
    container:ApplyBackground(DDI.MultiScoreboard:Theme('background'))
    container:ApplyBlur(2, 2)
    container:ApplyEvent(nil, function(sl, w, h) 
        draw.SimpleText(DanLib.CONFIG.SCOREBOARD.ServerName, 'danlib_font_44', w / 2, 60, DDI.MultiScoreboard:Theme('text'), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText(DanLib.CONFIG.SCOREBOARD.ShortDescription, 'danlib_font_30', w / 2, 100, DDI.MultiScoreboard:Theme('title'), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        if DanLib.CONFIG.SCOREBOARD.OnlineCount then
            local pcount = table.Count(player.GetAll())
            DUtils:DrawParseText(DBase:L('MS#CurrentPlayers', { pcount = pcount }), 'danlib_font_24', w / 2, h - 100, DDI.MultiScoreboard:Theme('title'), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end)
    container:SetSize(ScrW(), ScrH())
    container:Center()
    container:MakePopup()
    container:ApplyAttenuation(0.2)
    self.Сontainer = container

    local listPlayer = DCustomUtils(container, 'DDI.MSListPlayer')
    listPlayer:SetSize(DanLib.ScrW * .8, DanLib.ScrH * .7 + 40)
    listPlayer:Center()
    self.ListPlayer = listPlayer
end

function DDI.MultiScoreboard:Hide()
    local container = self.Сontainer
    if IsValid(container) then
        container:AlphaTo(0, 0.15, 0, function()
            container:Remove()
        end)
    end
end


-- Called when player presses the scoreboard button (tab by default).
hook.Add('ScoreboardShow', 'Scoreboard_Open', function()
    DDI.MultiScoreboard:Open()
    return true
end)

-- Called when player released the scoreboard button (tab by default).
hook.Add('ScoreboardHide', 'Scoreboard_Closes', function()
    DDI.MultiScoreboard:Hide()
    return true
end)
