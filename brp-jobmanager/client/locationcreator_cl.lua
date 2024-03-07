
for i_, menu in ipairs(config.jobmenus) do
    local menudata = {}

        -- Check if menu permissions are defined and insert corresponding options
        if menu.permissions then
            if menu.permissions.withdraw == true then
                table.insert(menudata, {
                    title = 'Withdraw Cash',
                    onSelect = function()
                        local input = lib.inputDialog('Withdraw', {
                            {type = 'number', label = 'Ammount', description = 'Ammount you would like to withdraw!', icon = 'hashtag'},
                        }) if input then
                            TriggerServerEvent('brp:removeCashFromJob', menu.jobid, input[1], menu.bossrank)
                        else
                            TriggerEvent('brp:jobmanagernotification', 'Not Enought Input', 3)
                        end
                    end
                })
            end
    
            if menu.permissions.deposit == true then
                table.insert(menudata, {
                    title = 'Deposit Cash',
                    onSelect = function()
                        local input = lib.inputDialog('Deposit', {
                            {type = 'number', label = 'Ammount', description = 'Ammount you would like to add!', icon = 'hashtag'},
                        }) if input then
                            TriggerServerEvent('brp:addCashToJob', menu.jobid, input[1], menu.bossrank)
                        else
                            TriggerEvent('brp:jobmanagernotification', 'Not Enought Input', 3)
                        end
                    end
                })
            end

            if menu.permissions.checkbalance == true then
                table.insert(menudata, {
                    title = 'Check Balance',
                    onSelect = function()
                        TriggerServerEvent('brp:checkCashInJob', menu.jobid, menu.bossrank)
                    end
                })
            end

            if menu.permissions.hireaccess == true then
                table.insert(menudata, {
                    title = 'Hire Member',
                    onSelect = function()
                        local input = lib.inputDialog('Hire', {
                            {type = 'number', label = 'ID', description = 'ID of person you would like to hire', icon = 'hashtag'},
                        }) if input then
                            TriggerServerEvent('brp:hireJobMember', menu.jobid, input[1], menu.bossrank)
                        else
                            TriggerEvent('brp:jobmanagernotification', 'Not Enought Input', 3)
                        end
                    end
                })
            end

            if menu.permissions.ranksetaccess == true then
                table.insert(menudata, {
                    title = 'Set Rank',
                    onSelect = function()
                        local input = lib.inputDialog('Hire', {
                            {type = 'number', label = 'ID', description = 'ID of person who has the rank you want to update!', icon = 'hashtag'},
                            {type = 'number', label = 'Grade', description = 'Rank you want to set them to!', icon = 'hashtag'},
                        }) if input then
                            TriggerServerEvent('brp:setJobMemberRank', menu.jobid, input[1], input[2], menu.bossrank)
                        else
                            TriggerEvent('brp:jobmanagernotification', 'Not Enought Input', 3)
                        end
                    end
                })
            end

            
            if menu.permissions.fireaccess == true then
                table.insert(menudata, {
                    title = 'Fire Member',
                    onSelect = function()
                        local input = lib.inputDialog('Fire', {
                            {type = 'number', label = 'ID', description = 'ID of person who you want to fire!', icon = 'hashtag'},
                        }) if input then
                            TriggerServerEvent('brp:fireJobMember', menu.jobid, input[1], menu.bossrank)
                        else
                            TriggerEvent('brp:jobmanagernotification', 'Not Enought Input', 3)
                        end
                    end
                })
            end
        end

        if next(menudata) ~= nil then
            lib.registerContext({
                id = 'job_menu_' .. i_,  -- Unique identifier for each menu
                title = 'Job Menu',
                options = menudata
            })
        end

        exports.ox_target:addBoxZone({
            coords = menu.coords,
            size = vec3(2, 2, 2),
            options = {
                {
                    label = menu.prompt,
                    onSelect = function()
                        lib.showContext('job_menu_' .. i_)
                    end
                }
            }
        })
end