local love = _G.love

--[[
_G.lua = {}
_G.lua.file = require("lua/lib/file")
local util = require("lua/util")
local cisp = require("lua/lib/cisp")

for _, path in pairs(util.getRealName(love.filesystem.getDirectoryItems("cisp"), "cisp")) do
    local compiled, luaPath = cisp:compileFile(path)
    lua.file.write(luaPath, compiled, "io")
end
]]

_G.lua = require("lua.lib.hotFix.sourceUpdate")()

local vec2 = _G.lua.vec2

VEC_ZERO = vec2(0, 0)
VEC_LEFT = vec2(-1, 0)
VEC_RIGHT = vec2(1, 0)
VEC_UP = vec2(0, -1)
VEC_DOWN = vec2(0, 1)

local cfgLoader = _G.lua.cfgLoader
SPRITE = cfgLoader.load"sprite.cfg"
SPRITE_WIDTH = SPRITE.WIDTH
SPRITE_HEIGHT = SPRITE.HEIGHT