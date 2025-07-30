local config = require 'config'
lib.locale()

local function CheckJob(jobs)
    local playerJob = ESX.PlayerData.job.name
    if not playerJob then return false end
    for _, allowed in ipairs(jobs) do
        if playerJob == allowed then return true end
    end
    return false
end

local function fadeScreen()
    DoScreenFadeOut(1000)
    Wait(1000)

    SendNUIMessage({ Action = "sound", soundname = "start.mp3" })
    Wait(4000)

    SendNUIMessage({ Action = "sound", soundname = "middle.mp3" })
    Wait(9000)

    SendNUIMessage({ Action = "sound", soundname = "end.mp3" })
    Wait(4000)

    DoScreenFadeIn(1000)
end

local function openElevator(possibleFloors, currentFloor, elevatorName)
    SetNuiFocus(true, true)
    SendNUIMessage({
        Action = "open",
        PossibleEntrys = possibleFloors,
        Current = currentFloor,
        ElevatorName = elevatorName
    })
end

RegisterNUICallback("number_selected", function(data, cb)
    local playerPed = PlayerPedId()
    ClearPedTasks(playerPed)
    SetNuiFocus(false, false)

    local selected = tonumber(data.floor)
    local current = tonumber(data.current)
    local elevatorName = data.ElevatorName

    if selected == current then
        lib.notify({
            title = locale("notify.Label"),
            description = locale("notify.Description"),
            type = 'error',
            position = 'top',
            icon = 'fa-solid fa-elevator'
        })
        cb("ok")
        return
    end

    local ok, floors = pcall(require, "elevators/" .. elevatorName)
    if ok then
        for _, loc in ipairs(floors) do
            if loc.PositionNumber == selected then
                fadeScreen()
                SetEntityCoords(playerPed, loc.PositionCoords.x, loc.PositionCoords.y, loc.PositionCoords.z, false, false, false, true)
                break
            end
        end
    else
        print("Error: Elevator name not found " .. tostring(elevatorName))
    end

    cb("ok")
end)

RegisterNUICallback("elevator_cancel", function(_, cb)
    ClearPedTasks(PlayerPedId())
    SetNuiFocus(false, false)
    cb("ok")
end)

local function Setup()
    for _, name in ipairs(config.Elevators) do
        local ok, data = pcall(require, "elevators/" .. name)
        if ok then
            for _, location in ipairs(data) do
                exports.ox_target:addSphereZone({
                    name = "elevator_" .. name .. "_" .. location.PositionNumber,
                    coords = location.PositionCoords,
                    radius = 1.5,
                    options = {
                        {
                            label = locale("target.UseElevator"),
                            icon = "fa-solid fa-elevator",
                            onSelect = function()
                                TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_PARKING_METER", 0, true)
                                openElevator(location.PossibleEntrys, location.PositionNumber, name)
                            end,
                            canInteract = function()
                                if location.CanEnter then
                                    return CheckJob(location.CanEnter)
                                end
                                return true
                            end
                        }
                    }
                })
            end
        else
            print(("Hissin lataus epäonnistui: %s"):format(name))
        end
    end
end

Setup()

