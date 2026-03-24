return {
    framework = 'QBOX',
    language = 'EN',
    interaction = 'ox_target', -- ox_target or sleepless_interact
    icons = {
        open = 'fa fa-hand',
        returnVehicle = 'fa fa-rotate'
    },
    garages = {
        ['test'] = {
            label = 'Police Garage',
            access = {type = 'job', name = 'police'}, -- type = 'job' or 'gang'
            chooseColor = true, -- If true players can choose a color with a color picker
            setIntoVehicle = true,
            icon = 'fa fa-car',
            interaction = {
                coords = vec4(459.0657, -1017.1562, 27.1540, 269.2597),
                prop = 'prop_parkingpay',
                openDistance = 2.0,
                returnDistance = 10.0,
                additionalReturns = {
                    vec4(442.5634, -986.0591, 42.6916, 90.8470)
                }
            },
            preview = {
                ['ground'] = {
                    camCoords = vec4(-1337.7008, 149.1388, -99.1943, 260.4223),
                    vehCoords = vec4(-1333.5176, 147.0370, -99.8013, 31.1188)
                },
                ['air'] = {
                    camCoords = vec4(-1267.0325, -3006.3640, -48.4902, 182.2130),
                    vehCoords = vec4(-1267.4834, -3013.7236, -48.1012, 319.8245)
                },
                ['water'] = {
                    camCoords = vec4(-810.1638, -1451.4164, 1.4453, 31.9208),
                    vehCoords = vec4(-812.7426, -1447.0427, -0.0690, 179.4453)
                },
            },
            spawnCoords = {
                ['ground'] = {
                    vec4(446.1568, -1025.3232, 28.2351, 1.1783),
                    vec4(442.4481, -1026.3156, 28.3197, 3.5508),
                    vec4(438.8127, -1026.8069, 28.3908, 4.8672),
                    vec4(434.9696, -1027.0127, 28.4590, 4.2734),
                    vec4(431.3097, -1027.5186, 28.5256, 3.7730),
                    vec4(427.4945, -1027.7642, 28.5933, 1.0120)
                },
                ['air'] = {
                    vec4(449.0534, -981.1594, 43.6916, 273.5021),
                    vec4(481.5452, -982.1037, 41.0081, 90.5527)
                },
                ['water'] = {
                    vec4(678.1103, -1678.2533, 8.5344, 174.0659)
                },
            },
            vehicles = { 
                --[[
                If image = false the image will be pulled from https://docs.fivem.net/vehicles/ if it's a gta v vehicle
                You can check the arguments for mods here https://coxdocs.dev/ox_lib/Modules/VehicleProperties/Client#vehicle-properties
                color = {r, g, b}
                ]]
                {model = 'police', brand = 'Vapid', label = 'Police Cruiser', minGrade = 0, mods = {modLivery = 2}, color = {255, 255, 255}, image = false, spawnType = 'ground', previewType = 'ground'},
                {model = 'polgauntlet', brand = 'Bravado', label = 'Gauntlet', minGrade = 0, mods = {modLivery = 2}, image = false, spawnType = 'ground', previewType = 'ground'},
                {model = 'polcoquette4', brand = 'Invetero', label = 'Coquette D10', minGrade = 0, mods = {extras = {1, 1, 1, 0, 0}}, image = false, spawnType = 'ground', previewType = 'ground'},
                {model = 'polcaracara', brand = 'Vapid', label = 'Caracara', minGrade = 0, mods = {extras = {1, 0, 1, 1}, modLivery = 2}, image = false, spawnType = 'ground', previewType = 'ground'},
                {model = 'comet7', brand = 'Pfister', label = 'Comet S2 Cabrio', minGrade = 0, mods = {modLivery = 2}, image = false, spawnType = 'ground', previewType = 'ground'},
                {model = 'domgtcoupe', brand = 'Vapid', label = 'Dominator GT', minGrade = 0, mods = {}, image = 'https://media1.tenor.com/m/z4ZXWc5YRRwAAAAd/dog-funny.gif', spawnType = 'ground', previewType = 'ground'},
                {model = 'polmav', brand = 'Benefactor', label = 'Maverick', minGrade = 3, mods = {}, image = false, spawnType = 'air', previewType = 'air'},
                {model = 'frogger', brand = 'Maibatsu', label = 'Frogger', minGrade = 2, mods = {}, image = false, spawnType = 'air', previewType = 'air'},
                {model = 'seashark', brand = 'Speedophile', label = 'Seashark', minGrade = 2, mods = {}, image = false, spawnType = 'water', previewType = 'water'},
                {model = 'predator', brand = 'Unknown', label = 'Predator', minGrade = 2, mods = {}, image = false, spawnType = 'water', previewType = 'water'},
            }
        },
    }
}