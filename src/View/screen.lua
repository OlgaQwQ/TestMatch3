
---Function to display fiels to console
function showField()
    io.write("  ")
    for i = 1, fieldSize.xSize do
        io.write(i-1)
    end
    io.write("\n")
    io.write("  ")
    for i = 1, fieldSize.xSize do
        io.write("-")
    end
    io.write("\n")
    for i = 1, fieldSize.xSize do
        io.write(i-1)
        io.write("|")
        for j = 1, fieldSize.ySize do
            io.write()
            io.write(field[j][i])
        end
        io.write("\n")
    end
end
