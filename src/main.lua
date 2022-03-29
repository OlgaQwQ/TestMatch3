require "src.Model.interface"
require "src.Controller.eventListner"

--Creating and showing field with random crystals
init()
dump()
--Infinit cycle with check for user's commant to exit game
while true do
    ReadUserCommand()
    dump()
    if IsGameAboutToBeClosed then
        break
    end
end
