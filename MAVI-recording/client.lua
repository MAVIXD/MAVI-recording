--  __  __        __      __ ______ 
-- |  \/  |    /\ \ \    / /|_   _|
-- | \  / |   /  \ \ \  / /   | |  
-- | |\/| |  / /\ \ \ \/ /    | |  
-- | |  | | / ____ \ \  /    _| |_ 
-- |_|  |_|/_/    \_\ \/    |_____|
-- 

HT = nil
IsRecording = false

Citizen.CreateThread(function()
    while HT == nil do
        TriggerEvent('HT_base:getBaseObjects', function(obj) HT = obj end)
        Citizen.Wait(0)
    end
end)

RegisterCommand("record", function()            
    local elements = {}

    table.insert(elements, {label = 'Start Recording', value = 'startRec'})
    table.insert(elements, {label = 'Stop Recording', value = 'stopRec'})
    table.insert(elements, {label = 'Rockstar Editor', value = 'openEditor'})

    HT.UI.Menu.Open('default', GetCurrentResourceName(), 'dead_citizen', 
        {
            title    = 'Vælg mulighed',
            align    = 'top-left',
            elements = elements,
        },
        function(data, menu)
            local ac = data.current.value
    
            if ac == 'startRec' then
                if IsRecording then
                    exports['mythic_notify']:SendAlert('error', 'Du optager allerede et clip!', 2500)
                else
                    StartRecording(1)
                    exports['mythic_notify']:SendAlert('inform', 'Du optager nu!', 2500)
                    IsRecording = true
                end
            end
    
            if ac == 'stopRec' then
                if IsRecording then
                    StopRecordingAndSaveClip()
                    exports['mythic_notify']:SendAlert('inform', 'Du optager ikke mere!', 2500)
                    IsRecording = false
                else
                    exports['mythic_notify']:SendAlert('error', 'Du optager ikke et clip!', 2500)
                end
            end
            if ac == 'openEditor' then
                ActivateRockstarEditor()
                menu.close()
            end


        end,
        function(data, menu)
            menu.close()
        end
    )
end)