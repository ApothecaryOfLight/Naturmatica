--Naturmatica by ApothecaryOfLight

print( "[NATURMATICA] Defining ants..." )

--[[
TODO: Overlay a transparent outlike of the ant ontop of the any
So that it can be inked. Black or at least dark and also colorized but very lightly.
INKED!
It'll look way better.
]]

local effects = {
	grows = function( pos ) print( "Grows grass near colony." ) end,
	poison = function( pos ) print("Poisons the player!") end,
	freezing = function( pos ) print("Turns water in the area to ice.") end,
	barbed = function( pos ) print("Causes a significant amount of damage.") end,
}

local ant_prototypes = {
	grassy = {
		species_name = "Grassy",
		species_idname = "grassy",
		climate = "Normal",
		humidity = "Normal",
		temp_tol = 1,
		humid_tol = -1,
		lifespan = "Short",
		speed = "Slower",
		pollination = "Slowest",
		flowers = "Jungle",
		fertility = 2,
		areaX = 9,
		areaZ = 9,
		diurnal = true,
		nocturnal = false,
		effect = effects.grows,
		stack_max = 0,
		inventory_image = "grassy",
		description = "Grassy Ant",
		breed_data = {},
		production_data = {
			seed = {
				tag = "default:wheat_seed",
				quantity = 1,
				frequency = 3.8,
			},
		},
		inline_biomes = { "rainforest_swamp", "rainforest_under" }
	},
	commonissimus = {
		species_name = "Commonissimus",
		species_idname = "commonissimus",
		climate = "Normal",
		humidity = "Normal",
		temp_tol = 3,
		humid_tol = 3,
		lifespan = "Short",
		speed = "Slower",
		pollination = "Slowest",
		flowers = "Flowers",
		fertility = 2,
		areaX = 9,
		areaZ = 9,
		diurnal = true,
		nocturnal = false,
		effect = effects.grows,
		stack_max = 0,
		inventory_image = "commonissimus",
		description = "Commonissimus",
		breed_data = {},
		production_data = {
			seed = {
				tag = "default:wheat_seed",
				quantity = 1,
				frequency = 3.8,
			},
		},
		inline_biomes = { "rainforest_swamp", "rainforest_under", "deciduous_forest_shore", "cold_desert", "tundra_under", "savanna_ocean", "coniferous_forest", "snowy_grassland", "deciduous_forest_under", "cold_desert_under", "coniferous_forest_ocean", "deciduous_forest", "coniferous_forest_under", "icesheet_under", "snowy_grassland_under", "deciduous_forest_ocean", "icesheet", "desert", "tundra_ocean", "desert_ocean", "icesheet_ocean", "tundra", "rainforest_ocean", "rainforest", "savanna_under", "savanna", "sandstone_desert_under", "cold_desert_ocean", "coniferous_forest_dunes", "taiga", "sandstone_desert_ocean", "sandstone_desert", "taiga_under", "desert_under", "tundra_beach", "savanna_shore", "snowy_grassland_ocean", "taiga_ocean", "tundra_highland" }
	},
}

local branches = {
	overworld = { "grassy", "commonissimus" },
}

function registerAnt( inSpeciesID )
	print( "[NATURMATICA] registerAnt()" )
	local antProfile = ant_prototypes[inSpeciesID]
	local speciesName = antProfile.species_name
	local idNamedrone = "naturmatica:"..antProfile.species_idname
	minetest.register_craftitem( idNamedrone.."_queen", {
		species_id = inSpeciesID,
		species_name = speciesName,
		dominant = antProfile,
		recessive = antProfile,
		stack_max = 1,
		inventory_image = "naturmatica_ant_base.png^[colorize:#008000:80",
		description = speciesName.." Queen",
		effect = antProfile.effect
	} )
end

function doRegisterAnts()
	for k,v in pairs( ant_prototypes ) do
		registerAnt( k )
	end
end

function registerColonySpawner( inAntID, inBiomes )
	print( "RegisterColonySpawner" )
	print( "inAntID: "..inAntID )
	if not inBiomes then print("Error no biomes!") end

	local colonyName = "naturmatica:"..inAntID.."_colony"
	local myBiomes = inBiomes[inAntID]

	for k,v in pairs( myBiomes ) do
		print( k.."/"..v )
	end

	if not myBiomes then print("ERROR!!!!!"..inAntID) return end

	minetest.register_decoration({
		deco_type = "simple",
		place_on = {
			"default:snow",
			"default:dirt_with_snow",
			"default:dirt",
			"default:dirt_with_grass",
			"default:snowblock",
			"default:sand",
			"default:dirt_with_rainforest_litter",
			"default:dirt_with_coniferous_litter",
			"default:dry_dirt_with_dry_grass",
			"default:silver_sand",
			"default:desert_sand",
			"default:permafrost_with_moss",
			"default:permafrost_with_stones",
			"ethereal:bamboo_dirt",
			"ethereal:prairie_dirt",
			"ethereal:onion",
			"ethereal:dirt_with_leaves",
		},
		sidelen = 16,
		fill_ratio = 0.100,
		biomes = myBiomes,
		decoration = "naturmatica:ant_hill", --colony name
		height = 1
	})
	print("Added.\n")
end

--Returns a list of biomes that meet the heat and humidity critera specified in the params.
--Temps: Icy(-), Cold(-), Normal(-), Warm(-), Hot(80-), Hellish(-)
--Humidities: Arid(-), Normal(-), Damp(-)
function getBiomes( inHeatLevel, inHumidityLevel )
	local testingBiomes = minetest.registered_biomes
	local testing_ants = {}
	for ant_key,ant_name in pairs( branches.overworld ) do
		print(ant_name)
		table.insert( testing_ants, ant_prototypes[ant_name] )
	end

	local myHumidity = {
		Arid = {},
		Normal = {},
		Damp = {}
	}
	for k,v in pairs(testingBiomes) do
		local currHumid = v.humidity_point
		local currHeat = v.heat_point
		print( "\nBIOME: "..k )
		print( "  TEMP: "..currHeat )
		print( "  HUMIDITY: "..currHumid )
		if currHumid < 30 then
			table.insert( myHumidity.Arid, k ) 
		elseif currHumid >= 30 and currHumid <65 then
			table.insert( myHumidity.Normal, k ) --normal
		elseif currHumid >=65 then
			table.insert( myHumidity.Damp, k )
		end
	end

	print("\n\n")

	print("\nARID:" )
	for k,v in pairs( myHumidity.Arid ) do print(v) end
	print("\nNORMAL:" )
	for k,v in pairs( myHumidity.Normal ) do print(v) end
	print("\nDAMP:" )
	for k,v in pairs( myHumidity.Damp ) do print(v) end

	local myTemperatures = {
		Icy = {},
		Cold = {},
		Normal = {},
		Warm = {},
		Hot = {},
		Hellish = {}
	}
	for k,v in pairs(testingBiomes) do
		local currHeat = v.heat_point
		--print( "BIOME: "..k )
		--print( "  TEMP: "..currHeat )
		--print( "  HUMIDITY: "..currHumid )
		if currHeat < 40 then
			table.insert( myTemperatures.Icy, k )
		elseif currHeat >= 40 and currHeat <50 then
			table.insert( myTemperatures.Cold, k )
		elseif currHeat >= 50 and currHeat <70 then
			table.insert( myTemperatures.Normal, k )
		elseif currHeat >= 70 and currHeat <=85 then
			table.insert( myTemperatures.Warm, k )
		elseif currHeat >85 and currHeat<=100 then
			table.insert( myTemperatures.Hot, k )
		elseif currHeat >100 then
			table.insert( myTemperatures.Hellish, k )
		end
	end
	print("\nICY:" )
	for k,v in pairs(myTemperatures.Icy) do print(v) end
	print("\nCOLD:" )
	for k,v in pairs(myTemperatures.Cold) do print(v) end
	print("\nNORMAL:" )
	for k,v in pairs(myTemperatures.Normal) do print(v) end
	print("\nWARM:" )
	for k,v in pairs(myTemperatures.Warm) do print(v) end
	print("\nHOT:" )
	for k,v in pairs(myTemperatures.Hot) do print(v) end
	print("\nHELLISH:" )
	for k,v in pairs(myTemperatures.Hellish) do print(v) end

	print( "\n\n\nMATCHES:" )
	local outAnts = {}
	for ant_id,ant_profile in pairs( testing_ants ) do
		outAnts[ant_profile.species_idname] = {}
		print( "ant_id:"..ant_id )
		print( ant_profile.species_idname )
		for key,biome_name in pairs( ant_profile.inline_biomes ) do
			print( "[NAUTRMATICA] >>>>> Adding ant "..biome_name )
			table.insert( outAnts[ant_profile.species_idname], biome_name )
		end
		--climate & humidity
		--print( "ant: "..ant_id )
		local heatBiomes = myTemperatures[ ant_profile.climate ]
		local humidityBiomes = myHumidity[ ant_profile.humidity ]
		for k,v in pairs( heatBiomes ) do
			--print( k )
			--print( v )
			for k1,v1 in pairs( humidityBiomes ) do
				--print( v1 )
				if v==v1 then
					print("Match: "..v)
					table.insert( outAnts[ant_profile.species_idname], v )
				end
			end
		end
		--print("\n\n")
	end

	--print( "\nFinal table of ants and biomes: " )
	for k,v in pairs( outAnts ) do
		print( "Bee_ID: "..k)
		for k1,v1 in pairs(v) do
			print( "  BIOME: "..v1 )
		end
		print("\n")
	end

	--print( "=================BiomeData" )
	local myFilledBiomes = {}
	for ant_id,ant_data in pairs( outAnts ) do
		for biome_key,biome_name in pairs(ant_data) do
			for biomes_name,biome_data in pairs( testingBiomes ) do
				if biome_name == biomes_name then
					table.insert( myFilledBiomes, biome_name )
				end
			end
		end
	end
	local myUnfilledBiomes = {}
	for biome_name,biome_key in pairs(testingBiomes) do
		local found = false
		--print( biome_name )
		for biomes_data,biomes_name in pairs(myFilledBiomes) do
			--print( biome_name.." vs "..biomes_name )
			if biome_name == biomes_name then
				found = true
				--print( biome_name.." now has ants!")
				break
			end
		end
		if found == false then
			--print( "But "..biome_name.." doesn't have any ants. :(  <==================" )
			table.insert( myUnfilledBiomes, biome_name )
		end
	end
	print( "========== BIOMES WITHOUT ANTS ========== " )
	for biome_key,biome_name in pairs( myUnfilledBiomes ) do
		local currHumid = testingBiomes[biome_name].humidity_point
		local currHeat = testingBiomes[biome_name].heat_point
		print( biome_name )
		print( "  TEMP: "..currHeat )
		print( "  HUMIDITY: "..currHumid )
	end
	--print("=================EndBiomeData")
	print("\n\n")

	return outAnts
end

function registerColony( inSpeciesID )
	local antProfile = ant_prototypes[inSpeciesID]
	local speciesName = antProfile.species_idname
	local colonyName = "naturmatica:"..speciesName.."_colony"
	local panelTop = speciesName.."_top.png"
	local panelSide = speciesName.."_side.png"
	local ants_drop = {
		max_items = 3,
		items = {
			{
				items = { "naturmatica:"..speciesName.."_queen" }
			},
			{
				items = { "naturmatica:"..speciesName.."_drone" }
			},

		},
	}
	--[[minetest.register_node( colonyName, {
		drawtype = "mesh",
		paramtype = "light",
		paramtype2 = "facedir",
		sunlight_propogates = true,
		visual_scale = "mesh",
		mesh = "naturmatica_ant_colony.b3d",
		drop = ants_drop,
		description = "Ant Colony",
		groups = { oddly_breakable_by_hand=2,flammable=0,snappy=1,choppy=2 },
		tiles = {
			"default_junglewood.png",
			"naturmatica_glass.png",
			"default_junglewoodB.png",
			"default_desert_sand.png",
		},
	})]]
end

local ants_drop = {
	max_items = 3,
	items = {
		{
			items = { "naturmatica:grassy_queen" }
		},
	},
}

minetest.register_node( "naturmatica:ant_hill", {
	drawtype = "mesh",
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propogates = true,
	visual_scale = "mesh",
	mesh = "naturmatica_ant_hill.b3d",
	drop = ants_drop,
	description = "Ant hill",
	groups = { oddly_breakable_by_hand=2,flammable=0,snappy=1,choppy=2 },
	tiles = {
		"default_junglewood.png"
	},
})
minetest.register_node( "naturmatica:ant_colony", {
	drawtype = "mesh",
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propogates = true,
	visual_scale = "mesh",
	mesh = "naturmatica_ant_colony.b3d",
	description = "Ant Colony",
	groups = { oddly_breakable_by_hand=2,flammable=0,snappy=1,choppy=2 },
	tiles = {
		"default_junglewood.png",
		"naturmatica_glass.png",
		"default_junglewoodB.png",
		"default_desert_sand.png",
	},
})
minetest.register_craft({
	output = "naturmatica:ant_colony",
	type = "shaped",
	recipe = {
		{"group:wood", "group:wood", "group:wood"},
		{"default:glass", "default:sand", "default:glass"},
		{"group:wood", "group:wood", "group:wood"},
	},
})

function registerColonies()
	print("registerColonies")
	local myBiomesAndAnts = getBiomes()
	for k,v in pairs( branches.overworld ) do
		print( v )
		registerColony( v )
		registerColonySpawner( v, myBiomesAndAnts)
	end
end

--local function doRunPunnet( inParentA, inParentB )

--end

doRegisterAnts()
registerColonies()

minetest.register_tool("naturmatica:biome_dowsing_rod", {
	description = "Biome Dowsing Rod",
	inventory_image = "biome_dowsing_rod.png",
	stack_max = 1,
	punch_attack_uses = nil,
	on_use = function(itemstack, user, pointed_thing)
		--print("Dowsing!")
		if not pointed_thing.above then return end
		local biome = minetest.get_biome_data( pointed_thing.above )
		print( minetest.get_biome_name( biome.biome ).." with heat: "..biome.heat.." and humidity: "..biome.humidity )
	end,
})

minetest.register_tool("naturmatica:jumpstick", {
	description = "Jumpstick",
	inventory_image = "biome_dowsing_rod.png",
	stack_max = 1,
	punch_attack_uses = nil,
	on_use = function(itemstack, user, pointed_thing)
		local lookDir = user:get_look_dir()
		user:add_player_velocity( { x=lookDir.x*80, y=20, z=lookDir.z*80 } )
	end,
})

print( "[NATURMATICA] Ants defined!" )
