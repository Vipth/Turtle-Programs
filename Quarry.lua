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
-- *Stick To Even Numbers*
function quarry()
	local quarryRadius = 2
-- Check Fuel
    shell.run('refuel')
	if turtle.getFuelLevel() == 0 then
		return print("Need Fuel!")
	end

	local rowNumber = 0

	turtle.digDown()
	turtle.down()
	while true do
		for _ = 1, quarryRadius do
			rowNumber = rowNumber + 1
			for _ = 1, quarryRadius - 1 do
				turtle.dig()
				turtle.forward()
			end
			if rowNumber ~= quarryRadius then
				if rowNumber % 2 == 0 then
					turtle.turnLeft()
					while turtle.detect() do
						turtle.dig()
					end
					turtle.forward()
					turtle.turnLeft()
				else
					turtle.turnRight()
					while turtle.detect() do
						turtle.dig()
					end
					turtle.forward()
					turtle.turnRight()
				end
			else
				while true do
					if turtle.digDown() == false then
						if turtle.down() == false then
							return print("Detected Bedrock!")
						else
							break
						end
					else
						break
					end
				end
				turtle.turnRight()
				turtle.down()
			end
		end
	end
end

quarry()