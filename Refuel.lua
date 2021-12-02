print("Refueling...")

NUM_SLOTS = 16

-- Buffer to prevent the turtle from using all fuel in inventory.
local fuelBuffer = 1600

-- More to be added for E2E
local itemsThatCanRefuel = {"minecraft:coal", "minecraft:coal_block", "minecraft:blaze_rod",
                            "minecraft:charcoal", "minecraft:lava_bucket"}

local slotsWithFuel = {}

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
        print(turtle.getFuelLevel().. fuelBuffer)
        return print("Already At Fuel Limit.")
    end

    ITEMNAME = ''
    for i = 1, #slotsWithFuel do
        turtle.select(slotsWithFuel[i])

        if ITEMNAME ~= turtle.getItemDetail()['name'] then
            ITEMNAME = turtle.getItemDetail()['name']
        end

        if ITEMNAME ~= turtle.getItemDetail()['name'] then
            local oldFuel = turtle.getFuelLevel()
            turtle.refuel(1)
            AMOUNTINITEM = turtle.getFuelLevel() - oldFuel
            AMOUNTNEEDED = fuelBuffer - turtle.getFuelLevel()
        end

        if AMOUNTNEEDED <= 0 then
            return print("My Fuel Is Already At The Limit. ("..fuelBuffer..")")
        end

        local useAmount = math.floor(AMOUNTNEEDED / AMOUNTINITEM)
        if useAmount > turtle.getItemCount() then
            turtle.refuel()
        else
            turtle.refuel(useAmount)
        end

        if turtle.getFuelLevel() >= fuelBuffer then
            print("Refuel Complete!")
            print("Fuel: "..turtle.getFuelLevel())
        end
    end 
end