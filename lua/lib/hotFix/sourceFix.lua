--! Update Game (Download From  Gitee / Github)

local ltn12 = require("ltn12")
local http = require("socket.http")
local socket = require"socket"

local function requestUrl(url)
    local rsl = {}
    http.request {
        url = url,
        method = "GET",
        sink = ltn12.sink.table(rsl),
    }
    local str = table.concat(rsl)
    print(str)
    return str
end

return function (url)
    requestUrl(url)
end
