-- Turn of warnings of Aseprite API methods
---@diagnostic disable: undefined-global
---@diagnostic disable: lowercase-global

local PaletteInfo = {}

function PaletteInfo:GetSprite()
    local sprite = app.sprite
    return sprite
end

function PaletteInfo:SplitFilename(strFilename)
    -- Returns the Path, Filename, and Extension as 3 values
    return string.match(strFilename, "(.-)([^\\]-([^\\%.]+))$")
  end

function PaletteInfo:GetPaletteName(spriteInfo)
    local adressName = spriteInfo.filename
    local path,file,extension = PaletteInfo:SplitFilename(adressName)
    file = string.gsub(file,"."..extension,"")
    return file
end

function PaletteInfo:GetColorsOfActualPalette(spriteInfo)
    if spriteInfo ~= nil then
        --Array with the all colors in the palettes
        local spritePalette = spriteInfo.palettes[1]
        return spritePalette
    end
end

function PaletteInfo:HasSpriteInfo(spriteInfo)
    if spriteInfo == nil then
        return false
    else
        return true
    end
end

function PaletteInfo:GetPaletteInfo()
    lastSprite = PaletteInfo:GetSprite()
    isStart = PaletteInfo:HasSpriteInfo(lastSprite)
    --paletteName = PaletteInfo:GetPaletteName(lastSprite)
    if isStart == true then
        paletteAllColors = PaletteInfo:GetColorsOfActualPalette(lastSprite) 
        nColors = #paletteAllColors  
        shadeTable = PaletteInfo:LoadShadeColors(paletteAllColors,nColors)
    end
end

function PaletteInfo:CheckSizeRow()
    local limitQuantity
    if nColors > maxColorsByRow then
        limitQuantity = maxColorsByRow    
    else
        limitQuantity = nColors
    end

    return limitQuantity
end    

function PaletteInfo:LoadShadeColors(paletteSprite,nColors)
    local auxTable = {}
    local shadesTable = {}
    local qtdColorByRow = PaletteInfo:CheckSizeRow()
    local countItem = 1
    local i = 1

    for auxInd = 0, nColors-1 do
        auxTable[countItem]= Color(paletteSprite:getColor(auxInd))
        countItem = countItem + 1
        if countItem > qtdColorByRow then
            shadesTable[i] = auxTable
            i = i + 1
            countItem = 1
            auxTable = {}
        else
            if auxInd == nColors-1 then
                shadesTable[i] = auxTable
            end
        end
    end
    return shadesTable
end

return PaletteInfo