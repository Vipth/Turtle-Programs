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
    if turtle.getFuelLevel() >= fuelBuffer then
        return print("Already At Fuel Limit.")
    end
    for i = 1, #slotsWithFuel do
        turtle.select(slotsWithFuel[i])
        for _ = 1, turtle.getItemCount() do
            turtle.refuel()
            if turtle.getFuelLevel() < fuelBuffer then
                print('Fuel Limit Reached!')
                print("Fuel: "..turtle.getFuelLevel())
                return
            end
        end
    end
end