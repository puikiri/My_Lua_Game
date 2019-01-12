local BlockFactory = class("BlockFactory")
local Block = require ("app.views.SnakeGame.Sp.Block")
-- 障碍工厂
function BlockFactory:ctor(node)
	self.BlockArr = {}
	self.idAcc = 0
	self.node = node
end

function BlockFactory:Add(x,y,index) -- 添加障碍
	local block = Block.new(self.node)
	block:Set(index)
	block:SetPos(x,y)
	table.insert(self.BlockArr,block)
	
	block:SetBlock()
end

function BlockFactory:Remove(other) -- 清除某一个位置的障碍
	local block,index = self:Hit(other)
	if block ~= nil then
		block:Clear()
		table.remove(self.BlockArr, index)
	end
end

function BlockFactory:Hit(other) -- 碰撞检测
	for index,block in ipairs(self.BlockArr) do
		if block:Hit(other) then
			return block,index
		end
	end
	return nil,-1
end

function BlockFactory:Reset() -- 清空设置的障碍
	for _,block in ipairs(self.BlockArr) do
		block:Clear()
	end
end

function BlockFactory:Save(f) -- 编辑地图时的存盘
	for _,block in ipairs(self.BlockArr) do
		f:write(string.format("{x=%d,y=%d,index=%d},\n",block.x,block.y,block.index))
	end
end

return BlockFactory

