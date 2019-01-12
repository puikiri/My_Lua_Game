local Body = class("Body")
-- 蛇身
function Body:Update() -- 更新蛇身/头
	local posx,posy = Grid2Pos(self.X,self.Y)
	self.sp:setPosition(posx,posy)
end

function Body:ctor(snake, x, y, node, isHead) --蛇身构造函数
	self.snake = snake
	self.X = x
	self.Y = y	
	
	if isHead then
		self.sp = cc.Sprite:create("SnakeGame/Snake_head.png") -- 创建精灵
	else
		self.sp = cc.Sprite:create("SnakeGame/Snake_body.png") -- 创建精灵
	end	
	node:addChild(self.sp)
	self:Update()	
end

return Body