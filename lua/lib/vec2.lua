local vec2

local vmt = {
    __sub = function (self, v)
        return vec2(self.x - v.x, self.y - v.y) 
    end,
    __add = function (self, v)
        return vec2(self.x + v.x, self.y + v.y) 
    end,
    __div = function (self, n)
        return vec2(self.x / n, self.y / n) 
    end,
    __mul = function (self, v)
        return self.x * v.x + self.y * v.y
    end
}

local function _norm(self, s)
    local rsl = self:clone()
    if s then rsl = rsl - s end
    local m = math.sqrt(self.x^2 + self.y^2)
    if m ~= 0 then
        rsl = rsl / m
    end
    return rsl
end

local function _clone(self)
    return vec2(self.x, self.y)
end

local function _norml(self)
    return vec2(-self.y, self.x)
end

local function _distance(self, v)
    return math.sqrt((self.x - v.x)^2 + (self.y - v.y)^2)
end

local function _length(self)
    return self:distance(vec2(0, 0))
end

local function _rotate(self, center, r)
    return vec2((self.x - center.x) * math.cos(r) - (self.y - center.y) * math.sin(r) + center.x,
            (self.x - center.x) * math.sin(r) + (self.y - center.y) * math.cos(r) + center.y)
end

vec2 = function (x, y)
    return setmetatable({x = x, y = y, rotate = _rotate,
        normL = _norml, normalize = _norm, clone = _clone,
        distance = _distance, length = _length, unpack = function (self)
            return self.x, self.y
        end }
        , vmt)
end

return vec2