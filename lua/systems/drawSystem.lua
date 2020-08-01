local drawSystem = {}

function drawSystem:update() end
function drawSystem:draw()
    for _, entity in pairs(self.entities) do
        local rect = entity:getComponent("rect")
        _G.love.graphics.rectangle(rect.mode, rect.x, rect.y, rect.w, rect.h)
    end
end

return drawSystem