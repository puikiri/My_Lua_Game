local WallFactory = class("WallFactory")
require ("app.views.Common")
-- 围墙工厂
function WallFactory:WallGenerator(node,bound,callback)
	for i = -bound,bound do
		local sp = cc.Sprite:create("SnakeGame/Wall_1.png") -- 用本地sp，如果用self.sp那么只能创建一个，那么每次循环都会覆盖前一个
		local posx,posy = callback(i)
		sp:setPosition(posx,posy)
		table.insert(self.wallSpArray,sp)
		node:addChild(sp)
	end
end

function WallFactory:ctor(bound,node)
	self.bound = bound
	self.node = node
	self.wallSpArray = {} -- 围墙精灵数组
	-- 创建上下左右的围墙
	self:WallGenerator(node,bound,function(i)
		SetCollide(i,bound,{Type="wall"}) -- {Type="wall"} 只有类型，没有名字的碰撞
		return Grid2Pos(i,bound)
	end)
	self:WallGenerator(node,bound,function(i)
		SetCollide(i,-bound,{Type="wall"}) 
		return Grid2Pos(i,-bound)
	end)
	self:WallGenerator(node,bound,function(i)
		SetCollide(bound,i, {Type="wall"}) 
		return Grid2Pos(bound,i)
	end)
	self:WallGenerator(node,bound,function(i)
		SetCollide(-bound,i, {Type="wall"}) 
		return Grid2Pos(-bound,i)
	end)
end

function WallFactory:Reset(x,y) -- 重置精灵
	for _,sp in ipairs(self.wallSpArray) do
		self.node:removeChild(sp)
	end
end

return WallFactory