--All possible colours of crystals
colour = {"A","B", "C", "D", "E", "F"}
--Colour means emply place after deleting crystal
emptyColour = "N"


---Define if there's matches near crystal. Could detect only 3-ctystal match
---@param field table - two-dismensional array with crystals
---@param xPosition integer x position of crystal
---@param yPosition integer y position of crystal
---@return boolean - true if there's matches and false if there isn't
function MatchCheck(field, xPosition, yPosition)
    --Checking for the same colour left and right crystal
    if getFieldElement(field, xPosition, yPosition) == getFieldElement(field, xPosition -1, yPosition) and
    getFieldElement(field, xPosition, yPosition) == getFieldElement(field, xPosition + 1, yPosition) then
        return true
    end

    --Checking for the same colour in 2 positions right crystal
    if getFieldElement(field, xPosition, yPosition) == getFieldElement(field, xPosition + 1, yPosition) and
    getFieldElement(field, xPosition, yPosition) == getFieldElement(field, xPosition + 2, yPosition) then
        return true
    end

    --Checking for the same colour in 2 positions left crystal
    if getFieldElement(field, xPosition, yPosition) == getFieldElement(field, xPosition - 1, yPosition) and
    getFieldElement(field, xPosition, yPosition) == getFieldElement(field, xPosition - 2, yPosition) then
        return true
    end

    --Checking for the fame colour up and down crystal
    if getFieldElement(field, xPosition, yPosition) == getFieldElement(field, xPosition, yPosition - 1) and
    getFieldElement(field, xPosition, yPosition) == getFieldElement(field, xPosition, yPosition + 1) then
        return true
    end

    --Checking for the same colour in 2 positions up crystal
    if getFieldElement(field, xPosition, yPosition) == getFieldElement(field, xPosition, yPosition - 1) and
    getFieldElement(field, xPosition, yPosition) == getFieldElement(field, xPosition, yPosition - 2) then
        return true;
    end

    --Checking for the same colour in 2 positions down crystal
    if getFieldElement(field, xPosition, yPosition) == getFieldElement(field, xPosition, yPosition + 1) and
    getFieldElement(field, xPosition, yPosition) == getFieldElement(field, xPosition, yPosition +2) then
        return true
    end
end

---Count and remove matched crystals after player's turn
---@param field table - two-dismensional array with crystals
---@param xFrom integer x position of crystal before moving
---@param yFrom integer y position of crystal before moving
---@param xTo integer x position of crystal after moving
---@param yTo integer y position of crystal before moving
function RemoveMatchedCrystals(field, xFrom, yFrom, xTo, yTo)
    --Checking for 2 different colours bcos user could move not only that crystal where match expected, but also crystal next that
    local col1 = getFieldElement(field, xFrom, yFrom)

    --Tables with coordinates of cystals to remove
    local HorizontalMatch = {}
    local VerticalMatch = {}

    --4 cycles to detect more than 3-crystal match. It check whole lines up, dow, left and right moved crystal
    --This one for first colour
    for i = xFrom, 1, -1 do
        if getFieldElement(field, i, yFrom) == col1 then
            HorizontalMatch[#HorizontalMatch+1] = {i, yFrom}
        else break
        end
    end
    for i = xFrom, fieldSize.xSize do
        if getFieldElement(field, i, yFrom) == col1 then
            HorizontalMatch[#HorizontalMatch+1] = {i, yFrom}
        else break
        end
    end
    for i = yFrom, 1, -1 do
        if getFieldElement(field, xFrom, i) == col1 then
            VerticalMatch[#VerticalMatch+1] = {xFrom, i}
        else break
        end
    end
    for i = yFrom, fieldSize.ySize do
        if getFieldElement(field, xFrom, i) == col1 then
            VerticalMatch[#VerticalMatch+1] = {xFrom, i}
        else break
        end
    end

    --Removing crystals if there's more than 4 crystals (4 bcos in cycles moved crystal check twice :)
    if #HorizontalMatch >= 4 then
        for i = 1, #HorizontalMatch do
            RemoveCrystal(field, HorizontalMatch[i][1], HorizontalMatch[i][2])
        end
    end
    if #VerticalMatch >= 4 then
        for i = 1, #VerticalMatch do
            RemoveCrystal(field, VerticalMatch[i][1], VerticalMatch[i][2])
        end
    end
    --Clear tables before next colour check
    HorizontalMatch = {}
    VerticalMatch = {}

    if xTo == nil or yTo == nil then
        return;
    end
    local col2 = getFieldElement(field, xTo, yTo)

    --4 cycles to detect more than 3-crystal match. It check whole lines up, dow, left and right moved crystal
    --This one for the second colour
    for i = xTo, 1, -1 do
        if getFieldElement(field, i, yTo) == col2 then
            HorizontalMatch[#HorizontalMatch+1] = {i, yTo}
        else break
        end
    end
    for i = xTo, fieldSize.xSize do
        if getFieldElement(field, i, yTo) == col2 then
            HorizontalMatch[#HorizontalMatch+1] = {i, yTo}
        else break
        end
    end
    for i = yTo, 1, -1 do
        if getFieldElement(field, xTo, i) == col2 then
            VerticalMatch[#VerticalMatch+1] = {xTo, i}
        else break
        end
    end
    for i = yTo, fieldSize.ySize do
        if getFieldElement(field, xTo, i) == col2 then
            VerticalMatch[#VerticalMatch+1] = {xTo, i}
        else break
        end
    end

    --Removing crystals if there's more than 4 crystals (4 bcos in cycles moved crystal check twice :)
    if #HorizontalMatch >= 4 then
        for i = 1, #HorizontalMatch do
            RemoveCrystal(field, HorizontalMatch[i][1], HorizontalMatch[i][2])
        end
    end
    if #VerticalMatch >= 4 then
        for i = 1, #VerticalMatch do
            RemoveCrystal(field, VerticalMatch[i][1], VerticalMatch[i][2])
        end
    end
end

---Remove crystal. It change crystal colour on field to "empty colour"
---@param field table - two-dismensional array with crystals
---@param x integer x position of crystal to remove
---@param y integer y position of crystal to remove
function RemoveCrystal(field, x, y)
    field[x][y] = emptyColour
end