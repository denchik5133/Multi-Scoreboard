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
local ui = DanLib.UI
local DUtils = DanLib.Utils
local DCustomUtils = DanLib.CustomUtils.Create
local THEMES = DanLib.UiPanel()

--- Retrieves the current NPC values.
-- @return table: The current NPC values.
function THEMES:GetValues()
    return DBase:RetrieveUpdatedVariable('SCOREBOARD', 'Themes') or DanLib.ConfigMeta.SCOREBOARD:GetValue('Themes')
end

--- Fills the panel with necessary UI components.
function THEMES:FillPanel()
    local width = ui:ClampScaleW(self, 700, 500)
    local height = ui:ClampScaleH(self, 300, 300)

    self:SetHeader('Themes')
    self:SetPopupWide(width)
    self:SetExtraHeight(height)

    self.scrollPanel = DCustomUtils(self, 'DanLib.UI.Scroll')
    self.scrollPanel:PinMargin(nil, 6, 10, 6, 10)

    self:Refresh()
end

-- Refreshes the panel, updating the displayed NPCs.
function THEMES:Refresh()
	self.scrollPanel:Clear()

    local values = self:GetValues()
    local margin10 = 10
    local margin30 = 30
    local panelH = 125

    for k, v in pairs(values) do
        local tColor = v.color or 0, 0, 0, 140

        local variablePanel = DCustomUtils(self.scrollPanel)
        variablePanel:PinMargin(TOP, nil, nil, 4, 10)
        variablePanel:SetTall(50)
        variablePanel:ApplyBackground(DBase:Theme('secondary_dark'), 6)
        variablePanel:ApplyEvent(nil, function(sl, w, h) 
            DUtils:DrawDualText(14, h / 2, k, 'danlib_font_20', DBase:Theme('decor'), v.description, self.defaultFont, DBase:Theme('text'), TEXT_ALIGN_LEFT, nil, w - margin30 - margin30)
        end)

        local colorPanel = DCustomUtils(variablePanel)
        colorPanel:Pin(RIGHT, 10)
        colorPanel:SetWide(margin30)
        colorPanel:ApplyEvent(nil, function(sl, w, h) 
            DanLib.DrawShadow:Begin()
            local x, y = sl:LocalToScreen(0, 0)
            DUtils:DrawRoundedBox(x, y, w, h, tColor)
            DanLib.DrawShadow:End(1, 1, 1, 255, 0, 0, false) 
        end)

        local colorButton = DCustomUtils(colorPanel, 'DanLib.UI.ColorButton')
        colorButton:Pin()
        colorButton:SetColor(tColor)
        colorButton:ApplyEvent('DoClick', function(sl)
            DBase:RequestColorChangesPopup('Choose a Color', tColor, nil, function(value)
                sl:SetColor(value)
                values[k] = value
                DBase:SetConfigVariable('SCOREBOARD', 'Themes', values)
            end)
        end)
    end
end

THEMES:SetBase('DanLib.UI.PopupBasis')
THEMES:Register('DDI.UI.MLThemes')
