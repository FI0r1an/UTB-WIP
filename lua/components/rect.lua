return {
    name = "rect",
    x = 0,
    y = 0,
    w = 0,
    h = 0,
    mode = "fill",
    extend = function (_, rsl, x, y, w, h)
    rsl.x, rsl.y, rsl.w, rsl.h = x, y, w, h
    return rsl
end}