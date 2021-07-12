local balls = {}

local items = require("data.items")

for k, v in pairs(items) do
	if v.isPokeball then
		balls[k] = {name = v.name, spritenum = v.spritenum, num = v.num, gen = v.gen, isPokeball = true}
	end
end

return balls