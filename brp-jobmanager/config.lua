config = {
    unemployedJob = 'unemployed'
}

config.jobmenus = {
    {
        prompt = "Open Job Menu",
        bossrank = "boss",
        jobid = "police",
        coords = vector3(329.4726, -601.7949, 43.2155),
        permissions = {
            withdraw = false,
            deposit = true,
            checkbalance = true,
            hireaccess = true,
            fireaccess = true
        }
    },
    {
        prompt = "Open Job Menu",
        bossrank = "boss",
        jobid = "ambulance",
        coords = vector3(330.9095, -595.5886, 43.2676),
        permissions = {
            withdraw = true,
            deposit = true,
            checkbalance = true,
            hireaccess = true,
            ranksetaccess = true,
            fireaccess = true
        }
    }
}

return config 