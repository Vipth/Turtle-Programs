-- Global Variables
NUM_SLOTS = 16

-- Filter Items We Don't Want
local trash_items = {
    'minecraaft:cobblestone',
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
    local slotsWithTrash
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

disposeTrashItems()