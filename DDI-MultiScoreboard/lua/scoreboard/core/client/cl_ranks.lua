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
local DMaterials = DanLib.Config.Materials
local DCustomUtils = DanLib.CustomUtils.Create
local ui = DanLib.UI

local utils = DanLib.Utils
local RANK = DanLib.UiPanel()

--- Checks the user's access to edit ranks.
-- @return boolean: true if access is denied, otherwise false.
function RANK:CheckAccess()
    if DBase.HasPermission(LocalPlayer(), 'EditRanks') then 
        return 
    end
    DBase:QueriesPopup('WARNING', "You can't edit ranks as you don't have access to them!", nil, nil, nil, nil, true)
    return true
end

--- Gets the current rank value.
-- @return table: rank values.
function RANK:GetRanksValues()
    return DBase:RetrieveUpdatedVariable('SCOREBOARD', 'Ranks') or DanLib.ConfigMeta.SCOREBOARD:GetValue('Ranks')
end

--- Adds a new rank.
function RANK:add_new()
    if self:CheckAccess() then
        return
    end

    local values = self:GetRanksValues()
    if (table.Count(values) >= DanLib.BaseConfig.RanksMax) then
        DBase:QueriesPopup('ERROR', DBase:L('#rank.limit', { limit = DanLib.BaseConfig.RanksMax }), nil, nil, nil, nil, true)
        return
    end

    DBase:RequestTextPopup('ADD NEW', DBase:L('#rank.new'), 'New rank', nil, function(roleName)
        -- Remove extra spaces in the role name
        roleName = string.Trim(roleName) -- Remove spaces at the beginning and end of the role name

        -- Check for invalid characters in role name
        if (not roleName:match('^[%w%s]+$')) then
            DBase:QueriesPopup('WARNING', 'Role name can only contain letters, numbers, and spaces!', nil, nil, nil, nil, true)
            return
        end

        -- Replace spaces with underscores for ID only
        local roleID = 'rank_' .. string.lower(string.gsub(roleName, '%s+', '_')) -- Replace spaces with '_'

        -- ID uniqueness check
        for k, v in pairs(values) do
            if (k == roleID) then
                DBase:QueriesPopup('WARNING', 'A role with this ID already exists!', nil, nil, nil, nil, true)
                return
            end
        end

        -- Creating a new role
        local newRole = {
            Name = roleName,
            Order = table.Count(values) + 1,
            Color = Color(255, 255, 255),
            Time = os.time()
        }

        values[roleID] = newRole
        DBase:SetConfigVariable('SCOREBOARD', 'Ranks', values)
        self:Refresh()
    end)
end

--- Fills the panel with the required interface components.
function RANK:FillPanel()
    local width = ui:ClampScaleW(self, 700, 750)
    local height = ui:ClampScaleH(self, 500, 500)

    self:SetHeader('Rank')
    self:SetPopupWide(width)
    self:SetExtraHeight(height)

    local grid = DBase.CreateGridPanel(self)
    grid:Pin(nil, 14)
    grid:SetColumns(2)
    grid:SetHorizontalMargin(12)
    grid:SetVerticalMargin(12)
    self.grid = grid

    self:Refresh() -- Interface update
end

--- Updates the interface with the current rank values.
function RANK:Refresh()
    self.grid:Clear()
    local values = self:GetRanksValues()

    -- Sorting ranks in order
    local sorted = {}
    for k, v in pairs(values) do
        DTable:Add(sorted, { v.Order, k })
    end
    DTable:SortByMember(sorted, 1, true)

    local panelH = 60
    for k, v in ipairs(sorted) do
        local Key = v[2]
        local rolePanel = DCustomUtils()
        rolePanel:SetTall(panelH)
        self.grid:AddCell(rolePanel, nil, false)
        self:CreateRankPanel(rolePanel, values, Key, sorted, panelH, k)
    end

    self:CreateAddRankButton()
end

--- Creates a panel for a specific rank.
-- @param rolePanel Panel: The panel on which the rank will be displayed.
-- @param values table: Current rank values.
-- @param Key string: The key of the rank.
-- @param RankColor Color: The colour of the rank.
-- @param name string: The name of the rank.
-- @param panelH number: Height of the panel.
-- @param k number: Rank index.
function RANK:CreateRankPanel(rolePanel, values, Key, sorted, panelH, k)
    local RankColor = values[Key].Color or DBase:Theme('title')
    local name = values[Key].Name or 'unknown'
    local id = Key or 'unknown'

    local orderNum = DCustomUtils(rolePanel)
    orderNum:PinMargin(LEFT, nil, nil, 10)
    orderNum:SetWide(26)
    orderNum:ApplyBackground(Color(35, 46, 62), 6)
    orderNum:ApplyText(values[Key].Order, 'danlib_font_18', nil, nil, Color(255, 255, 255, 50), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    local function createMoveButton(icon, direction)
        local moveButton = DBase.CreateUIButton(orderNum, {
            background = { nil },
            hover = { nil },
            hoverClick = { nil },
            tall = panelH / 2 - 8,
            wide = size,
            paint = function(sl, w, h)
                self:DrawMoveButtonEffect(sl, h, icon, direction)
            end,
            click = function(sl)
                self:MoveRank(sl, direction, k, sorted, values, Key)
            end
        })
        return moveButton
    end

    createMoveButton(DMaterials['Up-Arrow'], 'up'):Pin(TOP)
    createMoveButton(DMaterials['Arrow'], 'down'):Dock(BOTTOM)

    local Panel = DCustomUtils(rolePanel)
    Panel:Pin()
    Panel:ApplyBackground(DBase:Theme('secondary_dark'), 6)
    Panel:ApplyEvent(nil, function(sl, w, h)
        DUtils:DrawRoundedMask(6, 0, 0, w, h, function()
            DUtils:DrawRect(0, 0, 4, h, RankColor)
        end)
        DUtils:DrawDualText(13, h / 2 - 10, name, 'danlib_font_18', RankColor, 'Added ' .. DBase:FormatHammerTime(values[Key].Time) or '', 'danlib_font_16', DBase:Theme('text'), TEXT_ALIGN_LEFT, nil, w - 50)
        draw.SimpleText('ID: ' .. Key or nil, 'danlib_font_16', 13, h / 2 + 16, DBase:Theme('text'), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end)

    self:CreateRankActionButton(Panel, Key, values, RankColor, name)
end

--- Draws an effect on the move button.
-- @param sl Panel: The panel of the button.
-- @param h number: Height of the button.
-- @param direction string: The direction of movement.
function RANK:DrawMoveButtonEffect(sl, h, icon, direction)
    local lastClicked = sl.lastClicked or 0
    local clickPercent = math.Clamp((CurTime() - lastClicked) / 0.3, 0, 1)

    if (CurTime() < lastClicked + 0.3) then
        local w = sl:GetWide()
        local boxH = h * clickPercent
        DUtils:DrawRoundedMask(6, 0, 0, w, h, function()
            DUtils:DrawRect(0, direction == 'up' and h - boxH or 0, w, boxH, ColorAlpha(DanLib.Config.Theme['Red'], 100))
        end)
    end

    local iconSize = 14 * clickPercent
    DUtils:DrawIcon(sl:GetWide() / 2 - iconSize / 2, h / 2 - iconSize / 2, iconSize, iconSize, icon, Color(238, 238, 238, 50))
end

--- Moves the rank up or down.
-- @param sl Panel: The panel of the button.
-- @param direction string: Direction of movement.
-- @param k number: Index of the current rank.
-- @param sorted table: Sorted list of ranks.
-- @param values table: Current rank values.
-- @param key string: Rank key.
function RANK:MoveRank(sl, direction, k, sorted, values, Key)
    sl.lastClicked = CurTime()

    -- We get the current rank of the player
    local actor = LocalPlayer()
    local actorRankKey = actor:get_danlib_rank() -- Get the player's rank key

    if (direction == 'up' and k > 1) then
        local aboveKey = sorted[k - 1][2]
        -- Moving rank
        values[aboveKey].Order, values[Key].Order = values[Key].Order, values[aboveKey].Order
        DBase:SetConfigVariable('SCOREBOARD', 'Ranks', values)
        self:Refresh()
    elseif (direction == 'down' and k < #sorted) then
        local belowKey = sorted[k + 1][2]
        -- Moving rank
        values[belowKey].Order, values[Key].Order = values[Key].Order, values[belowKey].Order
        DBase:SetConfigVariable('SCOREBOARD', 'Ranks', values)
        self:Refresh()
    end
end

--- Creates a button for rank actions.
-- @param Panel Panel: Panel for the button.
-- @param Key string: The key of the rank.
-- @param values table: Current rank values.
-- @param RankColor Color: The colour of the rank.
-- @param name string: The name of the rank.
function RANK:CreateRankActionButton(Panel, Key, values, RankColor, name)
    local size = 30
    local topMargin = (60 - size) / 2
    local buttons = {
        {
            Name = 'Edit name', 
            Icon = DMaterials['Edit'], 
            Col = DanLib.Config.Theme['Blue'], 
            Func = function() 
                self:EditRankName(Key, values, name) 
            end
        },
        {
            Name = 'Color', 
            Icon = 'PHLbyno', 
            Func = function() 
                self:ChangeRankColor(Key, values) 
            end
        },
        {
            Name = DBase:L('#delete'),
            Icon = DMaterials['Delete'],
            Col = DanLib.Config.Theme['Red'],
            hide = (Key == 'rank_owner'), -- Hide the button if it is the owner's rank
            Func = function() 
                self:DeleteRank(Key, values) 
            end
        }
    }

    local button = DBase.CreateUIButton(Panel, {
        dock_indent = { RIGHT, nil, topMargin, topMargin, topMargin },
        wide = size,
        icon = { DMaterials['Edit'] },
        tooltip = { DBase:L('#edit'), nil, nil, TOP },
        click = function(sl)
            if self:CheckAccess() then
                return 
            end
            local menu = DBase:UIContextMenu(self)
            for _, v in ipairs(buttons) do
                if (not v.hide) then
                    menu:Option(v.Name, v.Col or nil, v.Icon, v.Func)
                end
            end

            local mouse_x = gui.MouseX()
            local mouse_y = gui.MouseY()
            menu:Open(mouse_x + 30, mouse_y - 24, sl)
        end
    })
end

--- Edits the rank name.
-- @param Key string: The key of the rank.
-- @param values table: Current rank values.
-- @param name string: Rank name.
function RANK:EditRankName(Key, values, name)
    DBase:RequestTextPopup('RANK NAME', DBase:L('#rank.name'), name, nil, function(newName)
        if values[newName] then
            DBase:QueriesPopup('WARNING', DBase:L('#rank.name.exists'), nil, nil, nil, nil, true)
            return
        end

        -- Saving old data
        local rankData = values[Key]
        values[newName] = rankData
        values[newName].Time = os.time() -- Updating time
        values[Key] = nil -- Deleting an old rank

        DBase:SetConfigVariable('SCOREBOARD', 'Ranks', values)
        self:Refresh()
    end)
end

--- Deletes the rank.
-- @param Key string: Rank key.
-- @param values table: Current rank values.
function RANK:DeleteRank(Key, values)
    -- if (table.Count(values) <= 1) then
    --     DBase:QueriesPopup('WARNING', "You can't delete this rank, at least one rank must remain!", nil, nil, nil, nil, true)
    --     return
    -- end

    DBase:QueriesPopup('DELETION', DBase:L('#deletion.description'), nil, function()
        values[Key] = nil
        DBase:SetConfigVariable('SCOREBOARD', 'Ranks', values)
        self:Refresh()
    end)
end

--- Changes the colour of the rank.
-- @param Key string: Rank key.
-- @param values table: Current rank values.
function RANK:ChangeRankColor(Key, values)
    local RankColor = values[Key].Color
    DBase:RequestColorChangesPopup('COLOR', RankColor, nil, function(value)
        values[Key].Color = value
        DBase:SetConfigVariable('SCOREBOARD', 'Ranks', values)
        self:Refresh()
    end)
end

--- Creates a button to add a new rank.
function RANK:CreateAddRankButton()
    local createNew = DBase.CreateUIButton(nil, {
        dock_indent = { RIGHT, nil, 7, 6, 7 },
        tall = 30,
        text = { 'Add a new rank', nil, nil, nil, DBase:Theme('text', 200) },
        click = function()
            self:add_new() 
        end
    })

    self.grid:AddCell(createNew, nil, false)
end

RANK:SetBase('DanLib.UI.PopupBasis')
RANK:Register('DDI.UI.MLRanks')
