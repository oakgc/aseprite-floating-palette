-- Turn of warnings of Aseprite API methods
---@diagnostic disable: undefined-global
---@diagnostic disable: lowercase-global

local PaletteInfo = require("Scripts.PaletteInfo")

local DialogMain = {}


function DialogMain:CreateShadeByHorizontalLimit(paletteShade,shadeColors)
    for index in ipairs(shadeColors) do
        local auxShades = shadeColors[index]
        paletteShade:shades{
            id = "pick-color-"..index,
            mode = "pick",
            colors = auxShades,
            onclick = function(event)
                if event.button == MouseButton.LEFT then
                    app.fgColor = event.color
                    paletteShade:modify{id="FGSelectedColor",color = event.color}
                elseif event.button == MouseButton.RIGHT then
                    app.bgColor = event.color
                    paletteShade:modify{id="BGSelectedColor",color = event.color}
                end
            end
            } 
        paletteShade:newrow()  
    end
end

function DialogMain:ReloadInfoDialog(paletteColor)
    paletteColor:close()
    PaletteInfo:GetPaletteInfo()
    if isStart == true then
        --create a dialog to show 
        DialogMain:CreateDialog(shadeTable)
    end
end

function DialogMain:CreateDialog(shadeColor,name)
    local paletteDlg
    local onSiteChange = app.events:on('sitechange',function ()
        if app.sprite ~= lastSprite then
            DialogMain:ReloadInfoDialog(paletteDlg)
        end
    end)
    local onPaletteChange = app.events:on('aftercommand',function(event)
        if event.name == "SetPalette" then
            DialogMain:ReloadInfoDialog(paletteDlg)
        end
    end)  
   
    paletteDlg = Dialog{
        title = "Floating Palette",
        hexpand = false,
        onclose=function()
            WindowPosition = paletteDlg.bounds
            app.events:off(onSiteChange)
            app.events:off(onPaletteChange)
        end
        }
    paletteDlg:separator{text= "Colors"}
    --turn the corlos selectable with the mouse
    DialogMain:CreateShadeByHorizontalLimit(paletteDlg,shadeColor)
        
    paletteDlg:separator()
    --Foreground Color Selected
    paletteDlg:color{
        id="FGSelectedColor",
        label="FG",
        enabled = false,
        color = app.fgColor,
        }
    --Background Color Selected
    paletteDlg:color{
        id="BGSelectedColor",
        label="BG",
        enabled = false,
        color = app.bgColor
         }

    paletteDlg:separator{text = "Colors By Group"}
    paletteDlg:slider{
        id ="slideMaxColors",
        min = 5,
        max = 10,
        value = maxColorsByRow,
        onrelease = function()
            maxColorsByRow = paletteDlg.data.slideMaxColors
            DialogMain:ReloadInfoDialog(paletteDlg)
        end
    }

    paletteDlg:button{
        id = "bt-Refresh",
        text = "Reload",
        visible = false,
        onclick = function ()
            DialogMain:ReloadInfoDialog(paletteDlg)
        end
    }
    if WindowPosition == nil then
        paletteDlg:show{wait=false}
    else
        paletteDlg:show{
            wait= false, 
            bounds = Rectangle(WindowPosition.x, WindowPosition.y, paletteDlg.bounds.width, paletteDlg.bounds.height)
        }
    end
end

return DialogMain