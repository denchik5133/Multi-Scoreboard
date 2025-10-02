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



DDI_MSScriptName, DDI_MSScriptVersion, DDI_MSAuthor, DDI_MSKey = 'Multi Scoreboard', '1.0.0', '76561198405398290', 'GhT4nM8pL2qV9xZ5kR3J'


local function scoreboard_load()
	DDI.MultiScoreboard = DDI.MultiScoreboard or {}
	DDI.MultiScoreboard.Func = DDI.MultiScoreboard.Func or {}
	DDI.MultiScoreboard.UI = DDI.MultiScoreboard.UI or {}
	DDI.MultiScoreboard.Tabs = DDI.MultiScoreboard.Tabs or {}

	local SCOREBOARD = DanLib.Func.CreateLoader()
	SCOREBOARD:SetName(DDI_MSScriptName)
	SCOREBOARD:SetColor(Color(255, 20, 147))
	SCOREBOARD:SetStartsLoading()
	SCOREBOARD:SetLoadDirectory('scoreboard')

	SCOREBOARD:IncludeDir('core/shared')
	SCOREBOARD:IncludeDir('core/client')

	SCOREBOARD:Register()
end
scoreboard_load()

local function scoreboard_reload()
	DDI.MultiScoreboard = DDI.MultiScoreboard or {}
	DDI.MultiScoreboard.UI = DDI.MultiScoreboard.UI or {}
	DDI.MultiScoreboard.Tabs = DDI.MultiScoreboard.Tabs or {}
	scoreboard_load()
end
concommand.Add('scoreboard_reload', scoreboard_reload)