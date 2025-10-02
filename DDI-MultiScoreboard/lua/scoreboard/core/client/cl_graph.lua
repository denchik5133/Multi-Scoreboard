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


function PANEL:Paint(w, h)
	DUtils:DrawRoundedBox(0, 0, w, h, DBase:Theme('secondary_dark'))
end

-- Create a function to set the stats.
function PANEL:SetStats(statsTable)
	-- Saving data for redrawing when resizing
	self.statsTable = statsTable
	-- Calling the internal function to generate HTML
	self:UpdateGraph()
end

-- An internal function for generating and installing HTML (so that it can be re-called)
function PANEL:UpdateGraph()
	-- If no data is specified, exit
	if (not self.statsTable) then 
		return 
	end
end

-- A hook for redrawing the graph when resizing the panel
function PANEL:OnSizeChanged(w, h)
	self:UpdateGraph() -- Regenerating HTML with new dimensions
end

PANEL:SetBase('DHTML')
PANEL:Register('DDI.UI.MLGraph')
