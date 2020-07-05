modlib.log.create_channel("naturmatica") -- Create log channel
naturmatica = {}
naturmatica.modpath = minetest.get_modpath("naturmatica")

--[[local config =
    modlib.conf.import(
    "hud_timers",
    {
        type = "table",
        children = {
            hud_timers_max = {
                type = "number",
                range = {0, 100}
            },
            hud_pos = {
                type = "table",
                children = {
                    x = {type = "number"},
                    y = {type = "number"}
                }
            },
            globalstep = {
                type = "number",
                range = {0}
            },
            format = {
                type = "string"
            }
        }
    }
)]]

function naturmatica.log( inText )
    modlib.log.write(
        "naturmatica",
        inText
    )
end

naturmatica.log( "[NATURMATICA] Initializing..." )

dofile(naturmatica.modpath.."/define_ants.lua")
--dofile(naturmatica.modpath.."/define_bees.lua")

naturmatica.log( "[NATURMATICA] Done!" )
