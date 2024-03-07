ESX = exports['es_extended']:getSharedObject()

RegisterServerEvent('brp:removeCashFromJob')
AddEventHandler('brp:removeCashFromJob', function(jobName, cashToRemove, bossrank)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local ajobid = xPlayer.getJob().name
    local GradeName = xPlayer.getJob().grade_name

    if ajobid == jobName and GradeName == bossrank then
        if cashToRemove <= 0 then
            print('Cannot remove non-positive cash amount.')
            return
        end

        local query = "SELECT * FROM job_data WHERE job_id = @jobName"
        MySQL.Async.fetchAll(query, {
            ['@jobName'] = jobName
        }, function(result)
            if result and result[1] then
                local currentCash = tonumber(result[1].stored_cash)
                local newCash = currentCash - cashToRemove

                if newCash < 0 then
                    print('Cash cannot be removed, it would result in negative balance.')
                    TriggerClientEvent('brp:jobmanagernotification', source, 'There is not enough money!', 2)
                    return
                end

                MySQL.Async.execute('UPDATE job_data SET stored_cash = @newCash WHERE job_id = @jobName', {
                    ['@newCash'] = newCash,
                    ['@jobName'] = jobName
                }, function(rowsChanged)
                    if rowsChanged > 0 then
                        print(('Successfully removed %s cash from job %s.'):format(cashToRemove, jobName))
                        TriggerClientEvent('brp:jobmanagernotification', source, 'Successfully Removed '..cashToRemove..' from the storage!')
                        xPlayer.addMoney(cashToRemove)
                    else
                        print(('Failed to remove cash from job %s.'):format(jobName))
                        TriggerClientEvent('brp:jobmanagernotification', source, 'ERROR: CONTACT DEVELOPER ASAP!', 3)
                    end
                end)
            else
                print(('Job %s not found in the database.'):format(jobName))
            end
        end)
    else
        TriggerClientEvent('brp:jobmanagernotification', source, 'You are not a boss.', 3)
    end
end)

RegisterServerEvent('brp:addCashToJob')
AddEventHandler('brp:addCashToJob', function(jobName, cashToAdd, bossrank)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local ajobid = xPlayer.getJob().name
    local GradeName = xPlayer.getJob().grade_name

    if ajobid == jobName and GradeName == bossrank then
        if cashToAdd <= 0 then
            print('Cannot add non-positive cash amount.')
            return
        end

        local query = "SELECT * FROM job_data WHERE job_id = @jobName"
        MySQL.Async.fetchAll(query, {
            ['@jobName'] = jobName
        }, function(result)
            if result and result[1] then
                local currentCash = tonumber(result[1].stored_cash)
                local newCash = currentCash + cashToAdd

                if newCash < 0 then
                    print('Cash cannot be added, it would result in negative balance.')
                    TriggerClientEvent('brp:jobmanagernotification', source, 'There is not enough money!', 2)
                    return
                end

                MySQL.Async.execute('UPDATE job_data SET stored_cash = @newCash WHERE job_id = @jobName', {
                    ['@newCash'] = newCash,
                    ['@jobName'] = jobName
                }, function(rowsChanged)
                    if rowsChanged > 0 then
                        print(('Successfully added %s cash to job %s.'):format(cashToAdd, jobName))
                        TriggerClientEvent('brp:jobmanagernotification', source, 'Successfully Added '..cashToAdd..' to the storage!')
                        xPlayer.removeMoney(cashToAdd)
                    else
                        print(('Failed to add cash to job %s.'):format(jobName))
                        TriggerClientEvent('brp:jobmanagernotification', source, 'ERROR: CONTACT DEVELOPER ASAP!', 3)
                    end
                end)
            else
                print(('Job %s not found in the database.'):format(jobName))
            end
        end)
    else
        TriggerClientEvent('brp:jobmanagernotification', source, 'You are not a boss.', 3)
    end
end)

RegisterServerEvent('brp:checkCashInJob')
AddEventHandler('brp:checkCashInJob', function(jobName, bossrank)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local ajobid = xPlayer.getJob().name
    local GradeName = xPlayer.getJob().grade_name

    if ajobid == jobName and GradeName == bossrank then
        local query = "SELECT * FROM job_data WHERE job_id = @jobName"
        MySQL.Async.fetchAll(query, {
            ['@jobName'] = jobName
        }, function(result)
            if result and result[1] then
                local currentCash = tonumber(result[1].stored_cash)
                TriggerClientEvent('brp:jobmanagernotification', source, ('Current cash in job %s: %s'):format(jobName, currentCash))
            else
                print(('Job %s not found in the database.'):format(jobName))
                TriggerClientEvent('brp:jobmanagernotification', source, ('Job %s not found in the database.'):format(jobName), 3)
            end
        end)
    else
        TriggerClientEvent('brp:jobmanagernotification', source, 'You are not a boss.', 3)
    end
end)

RegisterServerEvent('brp:hireJobMember')
AddEventHandler('brp:hireJobMember', function(jobName, playerID, bossrank)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local ajobid = xPlayer.getJob().name
    local GradeName = xPlayer.getJob().grade_name
    local PlayerToSet = ESX.GetPlayerFromId(playerID)

    if PlayerToSet then
        if ajobid == jobName and GradeName == bossrank then
            if playerID then
                local PlayerName = PlayerToSet.getName(playerID)
                local PlayersJob = PlayerToSet.getJob().name

                if ESX.DoesJobExist(jobName, 0) then
                    if PlayersJob ~= jobName then
                        PlayerToSet.setJob(jobName, 0)
                        TriggerClientEvent('brp:jobmanagernotification', source, ('You have hired %s as a %s'):format(PlayerName, jobName))
                        TriggerClientEvent('brp:jobmanagernotification', playerID, ('You have been hired as %s'):format(jobName))
                    else
                        print('You are already part of this job')
                        TriggerClientEvent('brp:jobmanagernotification', source, ('%s is already a %s'):format(PlayerName, jobName), 3)
                    end
                else
                    print('The specified job does not exist in the database')
                end
            else
                print('No player ID provided')
            end
        else
            TriggerClientEvent('brp:jobmanagernotification', source, 'You are not a boss.', 3)
        end
    else
        print('Player with provided ID not found')
        TriggerClientEvent('brp:jobmanagernotification', source, 'Player with provided ID not found', 3)
    end
end)


RegisterServerEvent('brp:setJobMemberRank')
AddEventHandler('brp:setJobMemberRank', function(jobName, playerID, Rank, bossrank)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local ajobid = xPlayer.getJob().name
    local GradeName = xPlayer.getJob().grade_name
    local PlayerToSet = ESX.GetPlayerFromId(playerID)

    if PlayerToSet then
        if ajobid == jobName and GradeName == bossrank then
            if playerID then
                local PlayerName = PlayerToSet.getName(playerID)
                local sourcerank = xPlayer.getJob().grade

                if ESX.DoesJobExist(jobName, Rank) then
                    if sourcerank > Rank then
                        PlayerToSet.setJob(jobName, Rank)
                        TriggerClientEvent('brp:jobmanagernotification', playerID, ('You have been set to %s'):format(Rank))
                    else
                        TriggerClientEvent('brp:jobmanagernotification', source, 'The rank you are trying to set is higher than yours.', 2)
                    end
                else
                    print('The specified job or rank does not exist in the database')
                end
            else
                print('No player ID provided')
            end
        else
            TriggerClientEvent('brp:jobmanagernotification', source, 'You are not a boss.', 3)
        end
    else
        print('Player with provided ID not found')
        TriggerClientEvent('brp:jobmanagernotification', source, 'Player with provided ID not found', 3)
    end
end)


RegisterServerEvent('brp:fireJobMember')
AddEventHandler('brp:fireJobMember', function(jobName, playerID, bossrank)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local ajobid = xPlayer.getJob().name
    local GradeName = xPlayer.getJob().grade_name
    local PlayerToSet = ESX.GetPlayerFromId(playerID)

    if ajobid == jobName and GradeName == bossrank then
        if playerID then
            local PlayerName = PlayerToSet.getName(playerID)
            local sourcerank = xPlayer.getJob().grade
            local PlayerRank = PlayerToSet.getJob().grade

            if ESX.DoesJobExist(config.unemployedJob, 0) then
                if sourcerank >= PlayerRank then
                    print('check 1')
                    TriggerClientEvent('brp:jobmanagernotification', playerID, ('You have been fired from %s'):format(jobName), 2)
                    TriggerClientEvent('brp:jobmanagernotification', source, ('%s has been fired!'):format(PlayerName))
                    PlayerToSet.setJob(config.unemployedJob, 0)
                else
                    TriggerClientEvent('brp:jobmanagernotification', source, 'The rank you are trying to fire is a boss', 2)
                end
            else
                print('The specified job does not exist in the database')
            end
        else
            print('No player ID provided')
        end
    else
        TriggerClientEvent('brp:jobmanagernotification', source, 'You are not a boss.', 3)
    end
end)