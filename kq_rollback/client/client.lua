Citizen.CreateThread(function()
    local usedForce = 0

    while true do
        local sleep = 3000
        
        local playerPed = PlayerPedId()
        if IsPedInAnyVehicle(playerPed) then
            local veh = GetVehiclePedIsIn(playerPed)
            
            -- Whether or not the ped is the driver
            if GetPedInVehicleSeat(veh, -1) == playerPed then
                sleep = 250

                local speed = GetEntitySpeedVector(veh, true).y
                if speed < 20 then
                    sleep = 100
                    local throttle = GetVehicleThrottleOffset(veh)

                    if speed < 0 and (throttle == 0.0 or usedForce > 0) then
                        if Config.betterRollback.enabled then
                            -- Apply vehicle clutch to allow for free rollback
                            SetVehicleClutch(veh, 1.0)

                            -- We'll apply a bit of force to push the car back more
                            if usedForce < Config.betterRollback.duration then
                                usedForce = usedForce + 1
                                ApplyForceToEntity(veh, 0, vector3(0, math.max(-6, speed * Config.betterRollback.strength), 0), 0.0, 0.0, 0.0, 0, 1, 1, 1, 0, 0)
                            end
                            sleep = 1
                        end
                    else
                        if Config.betterHandbrakeTurns.enabled then
                            if throttle == 0.0 and speed < 15 and speed > 2 and GetVehicleHandbrake(veh) and math.abs(GetVehicleSteeringAngle(veh)) > 0.5 then
                                -- Apply sideways sway force to turn the vehicle quicker
                                ApplyForceToEntity(veh, 1, vector3(GetVehicleSteeringAngle(veh) * speed * Config.betterHandbrakeTurns.strength, 0.0, 0), 0.0, -3.0, 0, 0, 1, 1, 0, 0)
                            end
                        end
                        if usedForce > 0 then
                            usedForce = math.max(0, usedForce - 10)
                        end
                    end
                end
            end
        end
        
        Citizen.Wait(sleep)
    end
end)
