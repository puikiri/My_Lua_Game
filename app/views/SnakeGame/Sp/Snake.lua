local Snake = class("Snake")
local Body = require ("app.views.SnakeGame.Sp.Body")
require ("app.views.Common")
-- 蛇
local cInitLen = 3
function Snake:ctor(node) -- 构造函数
	self.BodyArray = {}
	self.node = node
	for i=1,cInitLen do -- 初始创建长度为3的蛇
		self:Grow(i==1)
	end
	self:SetDir("left")
end

function Snake:Kill() -- 销毁函数
	print("销毁蛇！")
	for _,body in ipairs(self.BodyArray) do -- 销毁蛇
		self.node:removeChild(body.sp)
	end
	self.BodyArray = {}
end

function Snake:GetTailGrid() -- 创建蛇的时候，蛇的状态/坐标
	if #self.BodyArray == 0 then
		return 0,0
	end
	local tail = self.BodyArray[#self.BodyArray]
	return tail.X,tail.Y
end

function Snake:GetHeadGrid() -- 取出头，用来吃苹果
	if #self.BodyArray == 0 then
		return nil
	end
	local head = self.BodyArray[1]
	return head.X,head.Y
end

function Snake:SetHeadGrid(x,y) -- 设置头，传送门用
	local head = self.BodyArray[1]
	head.X = x
	head.Y = y
end

function Snake:Grow(isHead) --创建蛇/添加蛇身
	print("创建蛇头/身")
	local tailX,tailY = self:GetTailGrid()
	local body = Body.new(self,tailX,tailY,self.node,isHead)
	table.insert(self.BodyArray , body) -- 每次创建都把创建的放进蛇的Table中
end

local function OffsetGridByDir(x,y,dir) --更新蛇的位置 里
	if dir=="left" then
		return x-1,y
	elseif dir=="right" then
		return x+1,y
	elseif dir=="up" then
		return x,y+1
	elseif dir=="down" then
		return x,y-1
	end
	print("UnKnowDir",dir)
	return x,y
end

local hvTable = { --方向
	["left"] = "h",
	["right"] = "h",
	["up"] = "v",
	["down"] = "v",
}

local rotTable = { --方向 蛇头png
	["left"] = 90,
	["right"] = -90,
	["up"] = 180,
	["down"] = 0,
}

function Snake:SetDir( dir ) -- 更新蛇的方向
	if Snake.MoveDir ~= nil then
		if hvTable[Snake.MoveDir] ~= hvTable[dir] then -- lua 的不等于 ~=
			Snake.MoveDir = dir
			-- 根据方向改变蛇头
			local head = self.BodyArray[1]
			head.sp:setRotation(rotTable[Snake.MoveDir])
		end
	else
		Snake.MoveDir = "left"
	end
end

function Snake:Blink(callback) -- 蛇死亡时的闪烁效果
	for index,body in ipairs(self.BodyArray) do
		local blink = cc.Blink:create(1,5)
		if index == 1 then
			local a = cc.Sequence:create(blink,cc.CallFunc:create(callback)) -- blink效果完成后才调用callback
			body.sp:runAction(a) -- 头执行这种效果
		else
			body.sp:runAction(blink)
		end
	end
end

function Snake:Update() --更新蛇的位置 表
	if #self.BodyArray == 0 then
		return
	end
	for i = #self.BodyArray,1,-1 do
		local body = self.BodyArray[i]
		if i==1 then
			body.X,body.Y = OffsetGridByDir(body.X,body.Y,self.MoveDir)
		else
			local front = self.BodyArray[i-1]
			body.X,body.Y = front.X,front.Y
		end
	SetCollide(body.X,body.Y,{Name=string.format("body%d",i),Type="body"}) -- 蛇的碰撞Table置入
	body:Update()
	end
end

return Snake
