local class = _G.class

local component = {}

function component.get(...)
    local tbl = select(1, ...)
    local name
    if type(tbl) == "table" then
        name = tbl
    else
        name = {...}
    end
    local rsl = {}
    for _, v in pairs(component.components) do
        rsl[#rsl + 1] = v
    end
    return unpack(rsl)
end

function component.create(name, property, init)
    local rsl = class(property)
    if init then
        rsl.extend = init
    end
    rsl.name = name
    rsl.__component = true
    component.components[name] = rsl
    return rsl
end

function component.load(path)
    local content = require(path)
    assert(content, ("Got a nil component at \"%s\""):format(tostring(path)))
    return component.create(content)
end

function component.set(...)
    for i = 1, select("#", ...) do
        local element = select(i, ...)
        assert(element.__component, "Got a non-component table")
        component.components[element.name] = element
    end
end

return component
