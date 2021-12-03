-- Global Variables
NUM_SLOTS = 16

local quarryRadius = 16

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


-- Find The Index Of An Item
local function getItemIndex(itemName)
	for i = 1, NUM_SLOTS do
		if turtle.getItemDetail(i) ~= nil then
			if turtle.getItemDetail(i)['name'] == itemName then
				return i
			end
		end
	end
end


-- Function To Throw Away Trash Items
local function disposeTrashItems()
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


-- Sort Inventory Function (https://pastebin.com/AqukeQKf)
local slot = 0

local function stack()
	print("SORTER: Stacking Items")
	for i = 1, 15 do
		slot = turtle.getItemSpace(i)
		for j = i + 1, NUM_SLOTS do
			turtle.select(j)
			if turtle.compareTo(i) then
				turtle.transferTo(i,slot)
				if turtle.getItemSpace(i) == 0 then
					break
				end
			end
		end
	end
end

local function compact()
	print("SORTER: Compressing Open Space")
	for i = 1, NUM_SLOTS do
		if turtle.getItemCount(i) == 0 then
			for j = i + 1, NUM_SLOTS do
				if turtle.getItemCount(j) > 0 then
					turtle.select(j)
					turtle.transferTo(i)
					break
				end
			end
		end
	end
end

local function verifySpace()
	if s == 1 then
		print("SORTER: Verified space")
		return
	else
		print("SORTER: Not enough space. Please clear at least 1 slot and press enter")
		read()
		space()
	end
end

local function space()
	print("SORTER: Checking for available space")

	s = 0

	for i=1,16 do
		if turtle.getItemCount(i) == 0 then
			s = 1
			l = i-1
			break
		end
	end
	verifySpace()
end

local function sort()
	print("SORTER: Commensing sorting")
	for i=1,l-1 do
		for j=i+2,l+1 do
			turtle.select(j)
			if turtle.compareTo(i) then
				turtle.select(i+1)
				turtle.transferTo(l+1,64)
				turtle.select(j)
				turtle.transferTo(i+1,64)
				turtle.select(l+1)
				turtle.transferTo(j,64)
				break
			end
		end
	end
	l=l+1
	compact()
	stack()
	turtle.select(1)
end

-- Store Inventory
local function depositItems()
	
end




-- Function To Mine A Single Layer (default: 64 x 64)
-- *Stick To Even Numbers*
local function quarry()
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
			shell.run('refuel')
			stack()
			compact()
			space()
			sort()
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
							return print("QUARRY: Detected Bedrock!")
						else
							break
						end
					else
						break
					end
				end
				turtle.turnRight()
				disposeTrashItems()
				turtle.down()
				rowNumber = 0
			end
		end
	end
end


getItemIndex("minecraft:cobblestone")