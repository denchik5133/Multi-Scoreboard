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
local DTable = DanLib.Table
local DUtils = DanLib.Utils
local DCustomUtils = DanLib.CustomUtils.Create
local PANEL = DanLib.UiPanel()

--- Retrieves the current NPC values.
-- @return table: The current NPC values.
function PANEL:GetValues()
    return DBase:RetrieveUpdatedVariable('SCOREBOARD', 'Themes') or DanLib.ConfigMeta.SCOREBOARD:GetValue('Themes')
end

--- Fills the panel with necessary UI components.
function PANEL:FillPanel()
    local width = ui:ClampScaleW(self, 900, 700)
    local height = ui:ClampScaleH(self, 700, 500)

    self:SetHeader('Statistics')
    self:SetPopupWide(width)
    self:SetExtraHeight(height)

    self.scrollPanel = DCustomUtils(self, 'DanLib.UI.Scroll')
    self.scrollPanel:PinMargin(nil, 6, 10, 6, 10)


    -- Create a var for the highest and lowest playercount recorded.
	local highestCount, lowestCount = 0, 9999
	-- Create a table for all the graphs.
	self.rightside_Graphs = {
		{
			name = 'Player Count',
			durution = '3h',
			graphData = {
				{
					ID = 'Lowest', 
					data = 0, 
					getData = function()
						return highestCount
					end, 
					useHighest = false
				},
				{
					ID = 'Highest', 
					data = 0, 
					getData = function()
						return highestCount
					end,
					useHighest = true
				},
				{
					ID = 'Average', 
					data = 0
				},
				{
					ID = 'Current', 
					getData = function()
						return #player.GetAll()
					end
				}
			},
			lineColor = Color(13, 128, 217, 255),
			dotColor = Color(51, 147, 222, 255),
			textColor = Color(128, 191, 255, 255),
		},
		{
			name = 'K/D',
			durution = '1h',
			graphData = {
				{
					ID = 'Kills',
					getData = function()
						return LocalPlayer():Frags()
					end
				},
				{
					ID = 'Deaths',
					getData = function()
						return LocalPlayer():Deaths()
					end
				}
			},
			lineColor = Color(197, 119, 56, 255),
			dotColor = Color(205, 137, 83, 255),
			textColor = Color(227, 164, 113, 255)
		}
	}

    self:Refresh()
end

--- Refreshes the panel, updating the displayed NPCs.
function PANEL:Refresh()
	self.scrollPanel:Clear()

    local values = self:GetValues()
    local margin10 = 10
    local margin30 = 30
    local panelH = 125

    for k, v in pairs(self.rightside_Graphs) do
    	local graphTitle = DCustomUtils(self.scrollPanel)
    	graphTitle:Pin(TOP, 6)
    	graphTitle:SetTall(40)
    	graphTitle:ApplyEvent(nil, function(sl, w, h)
    		DUtils:DrawDualText(4, h / 2, v.name, 'danlib_font_18', DBase:Theme('decor'), v.durution, 'danlib_font_16', DBase:Theme('text'), TEXT_ALIGN_LEFT, nil, w - margin30 - margin30)
    	end)

		-- Create the graph.
		local graph = DCustomUtils(self.scrollPanel, 'DDI.UI.MLGraph')
		graph:Pin(TOP, 6)
		graph:SetTall(120)

		-- Insert the graphPanel into self.rightside_Graphs.
		self.rightside_Graphs[k].graphElement = graph
	end
end

PANEL:SetBase('DanLib.UI.PopupBasis')
PANEL:Register('DDI.UI.MLStatistics')
