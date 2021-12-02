print("Refueling...")

NUM_SLOTS = 16

-- More to be added for E2E
local itemsThatCanRefuel = {"minecraft:coal", "minecraft:coal_block", "minecraft:blaze_rod",
                            "minecraft:charcoal", "minecraft:lava_bucket"}

local slotsWithFuel = {}

-- Buffer to prevent the turtle from using all fuel in inventory.
local fuelBuffer = 1600

for i = 1, NUM_SLOTS do
        if turtle.getItemDetail(i) ~= nil then
            for k, v in pairs(itemsThatCanRefuel) do
                if turtle.getItemDetail(i)["name"] == v then
                    table.insert(slotsWithFuel, #slotsWithFuel+1, i)
                end
            end
        end
end

if #slotsWithFuel == 0 then
    print("No fuel in inventory.")
else
    while turtle.getFuelLevel() < fuelBuffer do
        for i = 1, #slotsWithFuel do
            turtle.select(slotsWithFuel[i])
            while turtle.getFuelLevel() < fuelBuffer and turtle.getItemCount() ~= 0 do
                turtle.refuel(1)
            end
        end
    end
end