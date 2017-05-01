require("util")
function tableMerge(t1, t2)
    for k,v in pairs(t2) do
        if type(v) == "table" then
            if type(t1[k] or false) == "table" then
                tableMerge(t1[k] or {}, t2[k] or {})
            else
                t1[k] = v
            end
        else
            t1[k] = v
        end
    end
    return t1
end

function ChangePictureFilename(entity, path, newFilename)
	if newFilename ~= nil then
		local filenamePath = entity[path[1]]
		for i = 2, #path do
			filenamePath = filenamePath[path[i]]
		end
		filenamePath.filename = newFilename
	end
end

function makeEntity(entity, name, patch)
	if type(patch) == "table" then
		-- apply patch to entity
		tableMerge(entity, patch)
	end
	entity.name = name
	entity.minable.result = name
	--if no picture is defined then use the default one
	ChangePictureFilename(entity, pictureTablePath, pictureFilename)
	--if no icon is defined then use the default one
	entity.icon = iconPath or entity.icon
	-- add the entity to a technology so it can be unlocked
	--local wasAddedToTech = AddEntityToTech("construction-robotics", name)
	data:extend(
	{
		-- add the entity
		entity,
		-- add the recipe for the entity
		{
			type = "recipe",
			name = name,
			--if the recipe was succesfully attached to the tech then the recipe
			--shouldn't be enabled to begin with.
			--but if the recipe isn't attached to a tech then it should
			--be enabled to begin with because otherwise the player can never use the item ingame
			enabled = true,
			ingredients =
			{
			  {"steel-chest", 1},
			  {"electronic-circuit", 50}
			},
			result = name,
			requester_paste_multiplier = 4
		},
		{
			type = "item",
			name = name,
			icon = entity.icon,
			flags = {"goes-to-quickbar"},
			subgroup = "storage",
			order = "a[items]-b["..name.."]",
			place_result = name,
			stack_size = 50
		}
	})
	return entity
end
-- copy us a steel furnace, but make it BIG and FAST!
makeEntity(table.deepcopy(data.raw["furnace"]["steel-furnace"]), "damnFurnace", {
    collision_box = {{-2.2, -2.2}, {2.2, 2.2}},
    selection_box = {{-2.3, -2.5}, {2.3, 2.5}},
    source_inventory_size = 1,
    result_inventory_size = 2,
    energy_usage = "1000kW",
    crafting_speed = 10,
})
-- create a chest?
makeEntity(table.deepcopy(data.raw["container"]["steel-chest"]), "damnChest")
-- big chest!
makeEntity(table.deepcopy(data.raw["container"]["steel-chest"]), "damnBigChest", {
	collision_box = {{-2.2, -2.2}, {2.2, 2.2}},
    selection_box = {{-2.3, -2.5}, {2.3, 2.5}},
	max_health = 1000,
	picture = {
		shift = {0.1875, 0}
	},
})


-- create transport belts!
makeEntity(table.deepcopy(data.raw["transport-belt"]["express-transport-belt"]), "damnOutputBelt")
makeEntity(table.deepcopy(data.raw["transport-belt"]["express-transport-belt"]), "damnInputBelt")
