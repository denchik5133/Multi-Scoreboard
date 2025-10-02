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
local DTheme = DanLib.Config.Theme
local DMaterial = DanLib.Config.Materials
local DCustomUtils = DanLib.CustomUtils.Create
local SCOREBOARD = DDI.MultiScoreboard

local _TEXT_ALIGN_CENTER = TEXT_ALIGN_CENTER
local _TEXT_ALIGN_LEFT = TEXT_ALIGN_LEFT

local _simpleText = draw.SimpleText
local _ipairs = ipairs
local _pairs = pairs
local _pcall = pcall

local LISTPLAYERS = DanLib.UiPanel()

function LISTPLAYERS:Init()
	self.colorText = SCOREBOARD:Theme('title')
    self.colorbListPlayer = SCOREBOARD:Theme('secondaryB')
    self.colorbHListPlayer = SCOREBOARD:Theme('hover')

    self.font18 = 'danlib_font_18'
    self.font20 = 'danlib_font_20'
    self.font22 = 'danlib_font_22'

    -- Constants for better performance
	self.iconSize = 24
	self.margin40 = 40

    self:DescriptionTitle()
    self:PlayerPanel()
end

function LISTPLAYERS:DescriptionTitle()
    self.descriptionTitle = DCustomUtils(self)
    self.descriptionTitle:PinMargin(TOP, nil, nil, nil, 6)
    self.descriptionTitle:ApplyEvent(nil, function(sl, w, h)
        -- NICK
        _simpleText(DBase:L('MS#Nick'), self.font20, 64 + 40, h / 2, self.colorText, _TEXT_ALIGN_CENTER, _TEXT_ALIGN_CENTER)
        -- LEVEL
        if DanLib.CONFIG.SCOREBOARD.ShowLevel then
            _simpleText(DBase:L('MS#Level'), self.font20, w / 4 + 70, h / 2, self.colorText, _TEXT_ALIGN_CENTER, _TEXT_ALIGN_CENTER)
        end
        -- JOBS
        if DanLib.CONFIG.SCOREBOARD.ShowJobs then
            _simpleText(DBase:L('MS#Jobs'), self.font20, w / 2, h / 2, self.colorText, _TEXT_ALIGN_CENTER, _TEXT_ALIGN_CENTER)
        end
        -- PING
        _simpleText(DBase:L('MS#Ping'), self.font20, w - 70, h / 2, self.colorText, _TEXT_ALIGN_CENTER, _TEXT_ALIGN_CENTER)
        -- RANKS
        if DanLib.CONFIG.SCOREBOARD.UserGroups then
            _simpleText(DBase:L('MS#Rank'), self.font20, w - 16 - 4 - 38 - 310,  h / 2, self.colorText, _TEXT_ALIGN_CENTER, _TEXT_ALIGN_CENTER)
        end
    end)
end

function LISTPLAYERS:PlayerPanel()
    self.scroll = DCustomUtils(self, 'DanLib.UI.Scroll')
    self.scroll:Pin(nil)

    local categories = {} 
    local sortedPlayers = player.GetAll()

    -- Sort players by team
    table.sort(sortedPlayers, function(a, b)
        return a:Team() > b:Team() 
    end)
       
    for k, pPlayer in _pairs(sortedPlayers) do
        -- Skip invalid players
        if (not IsValid(pPlayer)) then
            continue
        end

        -- Get ping data using centralized system with fallback
        local pingColor, pingIcon = SCOREBOARD:GetPingData(pPlayer)
        -- Use centralized gamemode configuration with load-order guard
        local gamemodeConfig, gamemodeName = SCOREBOARD:GetGamemodeConfig()
        -- Get job and level using flexible gamemode system
        local playerJob = 'Unknown'
        local playerTeamName = 'Unknown'
        local playerTeamColor = Color(255, 255, 255, 255)
        local playerName = 'Unknown'
        local playerColor = Color(255, 255, 255, 255)
        local playerLevel = 1
        
        -- Create or get team category
        local teamID = pPlayer:Team()
        local playerCategory = categories[teamID]

        if DanLib.CONFIG.SCOREBOARD.ShowJobs then
            local success, job = _pcall(gamemodeConfig.getJob, pPlayer)
            playerJob = success and job or 'Unknown'
        end
        
        if DanLib.CONFIG.SCOREBOARD.ShowLevel then
            local success, level = _pcall(gamemodeConfig.getLevel, pPlayer)
            playerLevel = success and level or 1
        end

        local success, teamColor = _pcall(gamemodeConfig['getTeamColor'], teamID)
        playerTeamColor = success and teamColor or self.colorText

        local success, teamName = _pcall(gamemodeConfig.getTeamName, teamID)
        playerTeamName = success and teamName or 'Unknown'

        local success, PlayerName = _pcall(gamemodeConfig.getPlayerName, pPlayer)
        playerName = success and PlayerName or 'Unknown'

        if (not IsValid(playerCategory)) then
            playerCategory = self.scroll:Add('DCollapsibleCategory')
            categories[teamID] = playerCategory
            
            playerCategory:CustomUtils()
            playerCategory:SetLabel('')
            playerCategory:PinMargin(TOP, nil, nil, 2, 6)
            playerCategory:SetAnimTime(0.35)
            playerCategory:UpdateAltLines()
            playerCategory:ApplyClearPaint()
            -- Team category styling
            playerCategory:ApplyEvent(nil, function(sl, w, h)
                DUtils:DrawRoundedBox(0, 0, w, h, SCOREBOARD:Theme('secondaryA'))
                DUtils:DrawRoundedMask(6, 0, 0, w, h, function()
                    DUtils:DrawRect(0, 0, 4, h, playerTeamColor)
                end)
            end)
            
            -- Team header
            playerCategory.Header:CustomUtils()
            playerCategory.Header:SetTall(30)
            playerCategory.Header:ApplyEvent(nil, function(sl, w, h)
                local expanded = playerCategory:GetExpanded()
                local iconStr = expanded and DMaterial['Arrow'] or DMaterial['Up-Arrow']
                local iconColor = expanded and DBase:Theme('mat', 200) or DBase:Theme('mat', 80)
                DUtils:DrawIconOrMaterial(w - self.margin40, h / 2 - self.iconSize / 2, self.iconSize, iconStr, iconColor)
                
                local teamPlayerCount = 0
                for _, pl in _ipairs(sortedPlayers) do
                    if (IsValid(pl) and pl:Team() == teamID) then 
                        teamPlayerCount = teamPlayerCount + 1
                    end
                end
                _simpleText(playerTeamName .. ' ( ' .. teamPlayerCount .. ' )', self.font22, 16, h / 2, playerTeamColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            end)

            local PlayerList = DCustomUtils(playerCategory, 'DPanelList')
            PlayerList:GetSpacing()
            PlayerList:GetItems()
            PlayerList:InvalidateLayout(true)
            PlayerList:SetSpacing(5)
            playerCategory:SetContents(PlayerList)
            playerCategory.list = PlayerList
        end

        -- Create player panel
        local playerPanel = DBase.CreateUIButton(playerCategory.list, {
        	background = { Color(self.colorbListPlayer.r, self.colorbListPlayer.g, self.colorbListPlayer.b, self.colorbListPlayer.a), 6 },
        	hover = { Color(self.colorbHListPlayer.r, self.colorbHListPlayer.g, self.colorbHListPlayer.b, self.colorbHListPlayer.a), nil, 6 },
        	dock_indent = { TOP, 4, nil, nil, 5 },
        	tall = self.margin40,
            think = function(sl)
                if (not IsValid(pPlayer)) then
                    sl.playerOut = true
                else
                    sl.playerOut = false
                end
            end,
        	paint = function(sl, w, h)
                if sl.playerOut then
                    _simpleText(DBase:L('MS#PlayerOut'), self.font20, 64 + 5, h / 2, DTheme['Red'], _TEXT_ALIGN_LEFT, _TEXT_ALIGN_CENTER)
                    return
                end

                -- Normal display if the player is valid
                -- Additional check just in case
                if (not IsValid(pPlayer)) then
                    return
                end

                -- Player name with status indicators
                local nameText = playerName
                if (LocalPlayer() == pPlayer) then
                    nameText = DBase:L('MS#You', { nick = nameText })
                elseif (pPlayer:GetFriendStatus() == 'friend') then
                    nameText = DBase:L('MS#Friend', { nick = nameText })
                end
                DUtils:DrawParseText(nameText, self.font20, 64 + 5, h / 2, self.colorText, _TEXT_ALIGN_LEFT, _TEXT_ALIGN_CENTER)

                -- Level display (if enabled)
                if DanLib.CONFIG.SCOREBOARD.ShowLevel then
                    _simpleText(tostring(playerLevel), self.font18, w / 4 + 70, h / 2 - 1, self.colorText, _TEXT_ALIGN_CENTER, _TEXT_ALIGN_CENTER)
                    -- Level icon
                    local levelColor, levelIcon = SCOREBOARD:GetLevelData(playerLevel)
                    if levelIcon then
                        local iconSize = 32
                        DUtils:DrawIconOrMaterial(w / 4 + 54, h / 2 - iconSize / 2, iconSize, levelIcon, levelColor)
                    end
                end

                -- Job display (flexible gamemode support)
                if DanLib.CONFIG.SCOREBOARD.ShowJobs then
                    _simpleText(playerJob, self.font22, w / 2, h / 2, self.colorText, _TEXT_ALIGN_CENTER, _TEXT_ALIGN_CENTER)
                end

                -- User group display
                if DanLib.CONFIG.SCOREBOARD.UserGroups then
                    local groupData = DanLib.CONFIG.SCOREBOARD.Ranks[pPlayer:SteamID()] or DanLib.CONFIG.SCOREBOARD.Ranks[pPlayer:GetUserGroup()]
                    if groupData then
                        local groupColor = groupData.Color or self.colorText
                        local groupName = groupData.Name or DBase:L('Undefined')
                        _simpleText(groupName, self.font20, w - 360, h / 2, groupColor, _TEXT_ALIGN_CENTER, _TEXT_ALIGN_CENTER)
                    end
                end

                -- Ping display with centralized configuration
                if pingIcon then
                    DUtils:DrawIconOrMaterial(w - 66, h / 2 - self.iconSize / 2 + 4, self.iconSize, pingIcon, pingColor)
                end
        	end,
        	click = function()
                -- Future: Context menu functionality can be added here
                SCOREBOARD:ContextMenu(pPlayer)
        	end,
        	rclick = function()
        		-- Future: Right-click context menu
                SCOREBOARD:ContextMenuAdmin(pPlayer)
        	end
        })
        playerCategory.list:AddItem(playerPanel)

        -- Player avatar
        local Avatar = DCustomUtils(playerPanel)
        Avatar:ApplyAvatar()
        Avatar:SetSize(playerPanel:GetTall() - 8, playerPanel:GetTall() - 8)
        Avatar:SetPos(12, playerPanel:GetTall() * 0.5 - Avatar:GetTall() * 0.5)
        Avatar:SetPlayer(pPlayer, 32)
        Avatar:SetMouseInputEnabled(false)

        -- Mute toggle button
        DBase.CreateUIButton(playerPanel, {
        	background = { nil },
        	hover = { nil },
          	dock = { RIGHT },
            hoverClick = { nil },
          	wide = 40,
          	tooltip = { pPlayer:IsMuted() and DBase:L('MS#OFF') or DBase:L('MS#ON'), nil, nil, TOP },
          	paint = function(sl, w, h)
                if IsValid(pPlayer) then
                    local iconStr = pPlayer:IsMuted() and 'KNwdojj' or 'oaYHvLR'
                    DUtils:DrawIconOrMaterial(w / 2 - self.iconSize / 2, h / 2 - self.iconSize / 2, self.iconSize, iconStr, Color(58, 58, 68))
                end
            end,
            click = function()
                pPlayer:SetMuted(not pPlayer:IsMuted())
            end
        })
    end
end

LISTPLAYERS:Register('DDI.MSListPlayer')
