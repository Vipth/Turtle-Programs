-- Global Variables
NUM_SLOTS = 16

-- Filter Items We Don't Want
local trash_items = {
    'minecraft:cobblestone',
    'minecraft:dirt',
    'minecraft:diorite',
    'minecraft:andesite',
    'minecraft:granite',
    'minecraft:gravel',
    'minecraft:sand',
    'minecraft:sandstone',
    'chisel:limestone2',
}

-- Function To Throw Away Trash Items
function disposeTrashItems()
    local slotsWithTrash = {}
    for i = 1, NUM_SLOTS do
        if turtle.getItemDetail(i) ~= nil then
            for _, v in pairs(trash_items) do
                if turtle.getItemDetail(i)["name"] == v then
                    table.insert(slotsWithTrash, #slotsWithTrash + 1, i)
                end
            end
        end
    end

    for i = 1, #slotsWithTrash do
        turtle.select(slotsWithTrash[i])
        turtle.drop()
    end
end

-- Function To Mine A Single Layer (default: 64 x 64)
local quarryRadius = 6

function mineLayer()
    -- Check Fuel
    shell.run('refuel')
	if turtle.getFuelLevel() == 0 then
		return print("Need Fuel!")
	end
	turtle.digDown()
	turtle.down()
	for _ = 1, quarryRadius do
		for _ = 1, quarryRadius do
			turtle.dig()
			turtle.forward()
		end
		turtle.turnRight()
		turtle.dig()
		turtle.forward()
		turtle.turnRight()
		for _ = 1, quarryRadius do
			turtle.dig()
			turtle.forward()
		end
		turtle.turnRight()
	end
	disposeTrashItems()
end

for _ = 1, 2 do
	mineLayer()
end
