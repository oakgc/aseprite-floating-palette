--[[
MIT LICENSE
Copyright © 2024 Gabriel Carvalho [oakgc]

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

######################################
Author: Gabriel Carvalho
Last Update: October/2024
Release Updates:
    Version 1.0 (10/24)
        First version of the extension.
######################################
]]
-- Turn of warnings of Aseprite API methods
---@diagnostic disable: undefined-global
---@diagnostic disable: lowercase-global
-----------------------------
local PaletteInfo = require("Scripts.PaletteInfo")
local DialogMain = require("Scripts.DialogMain")
-----------------------------

maxColorsByRow = 10 --Quantity of colors for each row
nColors = 0
isStart = false
shadeTable = {}
paletteName = ""

--Main function to execute commands 
local function Main()
    PaletteInfo:GetPaletteInfo()
    if isStart  == true then
        DialogMain:CreateDialog(shadeTable)
    end
end

local function ImportExtensionInMenu(plugin)
    plugin:newCommand {
        id = "floatingPalette",
        title = "Floating Palette",
        group = "palette_main",   
        onclick = function ()
            Main()
        end -- run main function
    }
end
--Initialize the extension as a menu in the Aseprite
function init(plugin)
    ImportExtensionInMenu(plugin)
end

