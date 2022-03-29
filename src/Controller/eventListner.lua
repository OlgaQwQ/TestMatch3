require "src.Model.interface"

--Global var to close app
IsGameAboutToBeClosed = false

---Parse player's command from console
function ReadUserCommand()
    command = io.read()
    if IsMoveCommandCorrect(command) then
        local xFrom = tonumber(command:sub(3, 3))
        local yFrom = tonumber(command:sub(5, 5))
        local xTo, yTo
        local direction = command:sub(-1, -1)
        if direction == "l" then
            yTo = yFrom
            xTo = xFrom - 1
        end
        if direction == "r" then
            yTo = yFrom
            xTo = xFrom + 1
        end
        if direction == "u" then
            yTo = yFrom - 1
            xTo = xFrom
        end
        if direction == "d" then
            yTo = yFrom + 1
            xTo = xFrom
        end
        move({xFrom, yFrom}, {xTo, yTo})
    end
    if command == "q" then
        IsGameAboutToBeClosed = true
    end
end

---Check of the user's command
---@param command string with command from the console
---@return boolean - true if command correct, false - if its not
function IsMoveCommandCorrect(command)
    --Check that last letter means dirrection
    if not(command:sub(-1, -1) == "l" or command:sub(-1, -1) == "r" or command:sub(-1, -1) == "u" or command:sub(-1, -1) == "d") then
        return false
    end
    --Check that first letter means move
    if not(command:sub(1, 1) == "m") then
        return false
    end
    --Check that 2nd and 3rd - is numbers
    if not(tonumber(command:sub(3, 3))) or not(tonumber(command:sub(5, 5))) then
        return false
    end
    return true
end