require "src.View.screen"
require "src.Model.field"

---Creating new field with random crystals
---@return table
function init()
    field = createField()
    return field
end

---Display created field to console
function dump()
    showField()
end

---Move crystal
---@param from table with x and y coordinates of moving crystal
---@param to table with x and y coordinnates of its new place
function move(from, to)
    local xFrom, yFrom = table.unpack(from)
    local xTo, yTo = table.unpack(to)
    if IsMovePossible(xFrom, yFrom, xTo, yTo) then
        field = MoveCrystal(field, xFrom, yFrom, xTo, yTo)
        tick()
    end
end

--Function that make cryatalls falling after moving
function tick()
    field = CrystalsFAlling(field)
    --Check to mathces of new or felt crystals
    for i = 1, fieldSize.xSize do
        for j = 1, fieldSize.ySize do
            if MatchCheck(field, i, j) then
                RemoveMatchedCrystals(field, i, j, nil, nil)
                tick()
            end
        end
    end
    --If in the end field have no one possible move, then it mixed
    if not(IsPossibleMatchExist(field)) then
        mix()
    end
end

function mix()
    MixField()
end