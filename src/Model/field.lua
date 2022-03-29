require "src.Model.crystal"

---Playing field size. xSize is count of crystals horisontally, ySize is count of crystals vertically
fieldSize = {
    xSize = 10,
    ySize = 10
}

---Creating new field with random crystals
---@return table - field with at least one possible match
function createField()
    --Creating two-dismensional array
    local field = {}
    for i = 1,fieldSize.xSize do
        field[i] = {}
    end

    --Filling array by the crystals (random)
    for i = 1,fieldSize.xSize do
        for j = 1,fieldSize.ySize do
            field[i][j] = colour[math.random(#colour)]
        end
    end

    --Checking if there's matches. if there's then one crystal changes to another (which is not one of the crystals near)
    for i = 1, fieldSize.xSize do
        for j = 1, fieldSize.ySize do
            if MatchCheck(field, i, j) then
                local AvaliableColours = GetAvaliableColour(colour,GetNearCrystals(field, i, j))
                field[i][j] = AvaliableColours[math.random(#AvaliableColours)]
            end
        end
    end

    --Checking for at least one possible match. if it is, returning the field, if not - creating new one
    if IsPossibleMatchExist(field) then
        return field
    else return createField()
    end
end

---Function to getting crystal colour safe (with checking bounds)
---@param field table two-dismensional array with crystals
---@param xPosition integer x position of desired crystal colour
---@param yPosition integer y position of desired crystal colour
---@return string if there's such element or -1 if not
function getFieldElement(field, xPosition, yPosition)
    if xPosition < 1 or yPosition < 1 or xPosition > fieldSize.xSize or yPosition > fieldSize.ySize then
        return -1
    end
    return field[xPosition][yPosition]
end

---Defines what colours avaliable in selected crystal place (avaliable is those that are not near crystals)
---@param AllPossibleCrystals table with all possible crystals colours
---@param NearCrystals table with ctystals in top, bottom, left and right of the selected crystal
---@return table AvaliableColours colours which are not near crystal's colours
function GetAvaliableColour(AllPossibleCrystals, NearCrystals)
    local AvaliableColours = {table.unpack(AllPossibleCrystals)}
    for i = 1, #NearCrystals do
        for j = 1, #AvaliableColours do
            if AvaliableColours[j] == NearCrystals[i] then
                table.remove(AvaliableColours, j)
                break
            end
        end
    end
    return AvaliableColours
end

---Defines crystals colour in top, bottom, left and right of the selected crystal
---@param field table two-dismensional array with crystals
---@param xPosition integer x position of the selected crystal
---@param yPosition integer y position of the selected crystal
---@return table NearCrystals colour in top, bottom, left and right of the selected crystal
function GetNearCrystals(field, xPosition, yPosition)
    local NearCrystals = {getFieldElement(field, xPosition + 1, yPosition), getFieldElement(field, xPosition - 1, yPosition), 
    getFieldElement(field, xPosition, yPosition + 1), getFieldElement(field, xPosition, yPosition - 1)}
    return NearCrystals
end

---Moving crystal according to user's command (if its possible)
---@param field table two-dismensional array with crystals
---@param xFrom integer x position of crystal before moving
---@param yFrom integer y position of crystal before moving
---@param xTo integer x position of crystal after moving
---@param yTo integer y position of crystal after moving
---@return table ModifiedField if move possible and old field - if not possible, or there isn't match
function MoveCrystal(field, xFrom, yFrom, xTo, yTo)
    local ModifiedField = clone(field)
    if IsMovePossible(xFrom, yFrom, xTo, yTo) then
        ModifiedField[xTo + 1][yTo + 1] = field[xFrom + 1][yFrom + 1]
        ModifiedField[xFrom + 1][yFrom + 1] = field[xTo + 1][yTo + 1]
    end
    if MatchCheck(ModifiedField, xTo + 1, yTo + 1) or MatchCheck(ModifiedField, xFrom + 1, yFrom + 1) then
        RemoveMatchedCrystals(ModifiedField, xFrom + 1, yFrom + 1, xTo + 1, yTo + 1)
        return ModifiedField
    else return field
    end
end

---Defines if player's move inside the bounds of the field
---@param xFrom integer x position of crystal before moving
---@param yFrom integer y position of crystal before moving
---@param xTo integer x position of crystal after moving
---@param yTo integer y position of crystal after moving
---@return boolean - true if moving is inside the bounds of the field, and false if its not
function IsMovePossible(xFrom, yFrom, xTo, yTo)
    if xTo > fieldSize.xSize - 1 or yTo > fieldSize.ySize - 1 or xTo < 0 or yTo < 0 or
    xFrom > fieldSize.xSize - 1 or yFrom > fieldSize.ySize - 1 or xFrom < 0 or yFrom < 0 then
        return false
    else return true
    end
end

---Checking of the entire field for existense at least one possible match
---@param field table two-dismensional array with crystals
---@return boolean - true if there's at least one possible match on the field, and false if there isn't
function IsPossibleMatchExist(field)
    ---Local var to safe old state of field
    local fieldClone = clone(field)
    local HorisontalMatches = 0
    local VerticalMatchs = 0

    --Scaning field to find possible horisontal matches
    for i = 1, fieldSize.xSize do
        for j = 1, fieldSize.ySize do
            if IsMovePossible(i, j, i + 1, j) then
                fieldClone[i][j] = field[i+1][j]
                fieldClone[i+1][j] = field[i][j]
                if MatchCheck(fieldClone, i, j) or MatchCheck(fieldClone, i+1, j) then
                    HorisontalMatches = HorisontalMatches + 1
                else
                    fieldClone[i][j] = field[i][j]
                    fieldClone[i+1][j] = field[i+1][j]
                end
            end
        end
    end

    --Scaning field to find possible vertical matches
    for i = 1, fieldSize.xSize do
        for j = 1, fieldSize.ySize do
            if IsMovePossible(i, j, i, j + 1) then
                fieldClone[i][j] = field[i][j+1]
                fieldClone[i][j+1] = field[i][j]
                if MatchCheck(fieldClone, i, j) or MatchCheck(fieldClone, i, j + 1) then
                    VerticalMatchs = VerticalMatchs + 1
                else
                    fieldClone[i][j] = field[i][j]
                    fieldClone[i][j+1] = field[i][j+1]
                end
            end
        end
    end
    if HorisontalMatches >= 1 or VerticalMatchs >= 1 then
        return true
    else return false
    end
end


---It make crystals up fall to emty space down. Random crystals appear in top of the field
---@param field table two-dismensional array with crystals
---@return table ModifiedField
function CrystalsFAlling(field)
    local ModifiedField = clone(field)
    for i = 1, fieldSize.ySize do
        for j = 1, fieldSize.xSize do
            if getFieldElement(field, j, i) == emptyColour then
                for k = i, 2, -1 do
                    ModifiedField[j][k] = field[j][k-1]
                end
                local AvaliableColours = GetAvaliableColour(colour,GetNearCrystals(field, j, 1))
                ModifiedField[j][1] = AvaliableColours[math.random(#AvaliableColours)]
                field = ModifiedField
            end
        end
    end
    return ModifiedField
end

---Mixing all elements on the field. It choose random element on the field amd put them in the end of the array
function MixField()
    for i = 1, fieldSize.xSize do
        for j = 1, fieldSize.ySize do
            local count = 0
            --Repeats if in process some match appears
            repeat
                count = count + 1
                --Checking if there will too much repeats in random generation, or no possible move without match
                if count > 50 then
                    field[fieldSize.xSize + 1 - i][fieldSize.ySize + 1 - j] = colour[math.random(#colour)]
                else
                    local m = math.random(fieldSize.xSize - i + 1)
                    local n = math.random(fieldSize.ySize - j + 1)
                    local cloneColour = getFieldElement(field, fieldSize.xSize + 1 - i, fieldSize.ySize + 1 - j)
                    field[fieldSize.xSize + 1 - i][fieldSize.ySize + 1 - j] = field[m][n]
                    field[m][n] = cloneColour
                end
            until not MatchCheck(field, fieldSize.xSize + 1 - i, fieldSize.ySize + 1 - j)
        end
    end
    if not IsPossibleMatchExist(field) then
        MixField()
    end
end

---Function to copy array
---@param m table any array
---@return table clone array
function clone(m)
    local clone = {}
    for i = 1, #m do
        clone[i] = {table.unpack(m[i])}
    end
    return clone;
end