function loadUnlockerAPI()
    local unlocked = false
    -- EWT Unlocker
    if EasyWoWToolbox ~= nil then
        -- Active Player
        StopFalling = StopFalling
        FaceDirection = FaceDirection
        -- Object
        ObjectTypes = ObjectTypes
        ObjectPointer = ObjectPointer
        ObjectExists = ObjectExists
        ObjectIsVisible = ObjectIsVisible
        ObjectPosition = ObjectPosition
        ObjectFacing = ObjectFacing
        ObjectName = ObjectName
        ObjectID = ObjectID
        ObjectIsUnit = ObjectIsUnit
        GetDistanceBetweenPositions = GetDistanceBetweenPositions
        GetDistanceBetweenObjects = GetDistanceBetweenObjects
        GetPositionBetweenObjects = GetPositionBetweenObjects
        GetPositionFromPosition = GetPositionFromPosition
        ObjectIsFacing = ObjectIsFacing
        ObjectInteract = ObjectInteract
        -- Object Manager
        GetObjectCountBR = GetObjectCount
        GetObjectWithIndex = GetObjectWithIndex
        GetObjectWithGUID = GetObjectWithGUID
        -- Unit
        UnitBoundingRadius = UnitBoundingRadius
        UnitCombatReach = UnitCombatReach
        UnitTarget = UnitTarget
        UnitCastID = UnitCastID
        -- World
        TraceLine = TraceLine
        GetCameraPosition = GetCameraPosition
        CancelPendingSpell = CancelPendingSpell
        ClickPosition = ClickPosition
        IsAoEPending = IsAoEPending
        GetTargetingSpell = GetTargetingSpell
        WorldToScreen = WorldToScreen
        ScreenToWorld = ScreenToWorld
        GetMousePosition = GetMousePosition
        -- Hacks
        IsHackEnabled = IsHackEnabled
        SetHackEnabled = SetHackEnabled
        -- Files
        GetDirectoryFiles = GetDirectoryFiles
        ReadFile = ReadFile
        WriteFile = WriteFile
        CreateDirectory = CreateDirectory
        GetWoWDirectory = GetWoWDirectory
        -- Callbacks
        AddEventCallback = AddEventCallback
        -- Misc
        SendHTTPRequest = SendHTTPRequest
        GetKeyState = GetKeyState
        -- Drawing
        GetWoWWindow = GetWoWWindow
        Draw2DLine = Draw2DLine
        Draw2DText = Draw2DText
        WorldToScreenRaw = WorldToScreenRaw
        unlocked = true
    end
    -- No Unlocker
    if EasyWoWToolbox == nil then
        -- -- Active Player
        -- StopFalling = function() return true end
        -- FaceDirection = function() return true end
        -- -- Object
        -- ObjectTypes = {
        --     None = 0,
        --     Object = 1,
        --     Item = 2,
        --     Container = 4,
        --     Unit = 8,
        --     Player = 16,
        --     GameObject = 32,
        --     DynamicObject = 64,
        --     Corpse = 128,
        --     AreaTrigger = 256,
        --     SceneObject = 512,
        --     All = -1
        -- };
        -- ObjectPointer = function() return "" end
        -- ObjectExists = UnitExists
        -- ObjectIsVisible = UnitIsVisible
        -- ObjectPosition = function() return 0,0,0 end
        -- ObjectFacing = function() return 0,0 end
        -- ObjectName = function() return "" end
        -- ObjectID = function() return 0 end
        -- ObjectIsUnit = UnitIsUnit
        -- GetDistanceBetweenPositions = function() return 999 end
        -- GetDistanceBetweenObjects = function() return 999 end
        -- GetPositionBetweenObjects = function() return 0,0,0 end
        -- GetPositionFromPosition = function() return 0,0,0 end
        -- ObjectIsFacing = function() return true end
        -- ObjectInteract = function() return true end
        -- -- Object Manager
        -- GetObjectCountBR = function() return 0,false,{},{} end
        -- GetObjectWithIndex = function() return "target" end
        -- GetObjectWithGUID = function() return "target" end
        -- -- Unit
        -- UnitBoundingRadius = function() return 0 end
        -- UnitCombatReach = function() return 0 end
        -- UnitTarget = function() return "target" end
        -- UnitCastID = function() return 0 end
        -- -- World
        -- TraceLine = function() return 0,0,0 end
        -- GetCameraPosition = function() return 0,0,0 end
        -- CancelPendingSpell = function() return true end
        -- ClickPosition = function() return true end
        -- IsAoEPending = function() return false end
        -- GetTargetingSpell = function() return 0 end
        -- WorldToScreen = function() return 0,0,true end
        -- ScreenToWorld = function() return 0,0,0 end
        -- GetMousePosition = function() return 0,0,0 end
        -- -- Hacks
        -- IsHackEnabled = function() return false end
        -- SetHackEnabled = function() return true end
        -- -- Files
        -- GetDirectoryFiles = function() return {} end
        -- ReadFile = function() return "" end
        -- WriteFile = function() return true end
        -- CreateDirectory = function() return true end
        -- GetWoWDirectory = function() return "" end
        -- -- Callbacks
        -- AddEventCallback = function() return true end
        -- -- Misc
        -- SendHTTPRequest = function() return true end
        -- GetKeyState = function() return false end
        unlocked = false
    end

    return unlocked
end

-- Checks for BR Out of Date with current version based on TOC file
local brlocVersion = GetAddOnMetadata("BadRotations","Version")
local brcurrVersion
local brUpdateTimer
function checkBrOutOfDate()
    if (brcurrVersion == nil or not brUpdateTimer or (GetTime() - brUpdateTimer) > 300) then --and EasyWoWToolbox ~= nil then
        -- Request Current Version from GitHub
        if EasyWoWToolbox ~= nil then -- EWT
            SendHTTPRequest('https://raw.githubusercontent.com/CuteOne/BadRotations/master/BadRotations.toc', nil, function(body) brcurrVersion =(string.match(body, "(%d+%p%d+%p%d+)")) end)
        elseif wmbapi ~= nil then -- MB
            local info = {
            Url = 'https://raw.githubusercontent.com/CuteOne/BadRotations/master/BadRotations.toc',
            Method = 'GET'
            }
            if not brlocVersionRequest then
                brlocVersionRequest = SendHTTPRequest(info)
            else
                brlocVersionStatus, brlocVersionResponce = wmbapi.ReceiveHttpResponse(brlocVersionRequest)
                if brlocVersionResponce then
                    brcurrVersion = string.match(brlocVersionResponce.Body, "(%d+%p%d+%p%d+)")
                end
            end
        end
        -- Check against current version installed
        if brlocVersion and brcurrVersion then
            brcleanCurr = gsub(tostring(brcurrVersion),"%p","")
            brcleanLoc = gsub(tostring(brlocVersion),"%p","")
            if tonumber(brcleanCurr) ~= tonumber(brcleanLoc) then 
                local msg = "BadRotations is currently out of date. Local Version: "..brlocVersion.. " Current Version: "..brcurrVersion..".  Please download latest version for best performance."
                if isChecked("Overlay Messages") then
                    RaidNotice_AddMessage(RaidWarningFrame, msg, {r=1, g=0.3, b=0.1})
                else
                    Print(msg)
                end
            end
            brUpdateTimer = GetTime()
        end
    end
end
