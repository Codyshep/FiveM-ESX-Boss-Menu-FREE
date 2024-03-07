ESX = exports['es_extended']:getSharedObject()

RegisterNetEvent('brp:jobmanagernotification')
AddEventHandler('brp:jobmanagernotification', function(title, ntype)
    local player = PlayerId()
    exports['notifications']:sendnotify(title, ntype, 5000)
end)