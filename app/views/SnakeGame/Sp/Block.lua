local Block = class("Block")
-- 障碍
require ("app.views.SnakeGame.System.CollideManage") -- 获取碰撞检测的文件引用
require ("app.views.Common") -- 全局函数的引用

function Block:ctor(node)
	self.node = node
end

function Block:Set(index) -- index 使用哪一张图片
	if self.sp ~= nil then
		self.node:removeChild(self.sp)
	end
	self.index = index
	self.sp = display.newSprite(string.format("SnakeGame/Big_wall_%d.png",index))
	self.node:addChild(self.sp)
	
	local rawSize = self.sp:getContentSize() -- 获取精灵纹理大小
	self.size = rawSize.width/cGridSize * display.contentScaleFactor -- display.ContentScaleFactor内容缩放因子 影响图片在设计分辨率中的显示问题，如果不设置就是不缩放，原图大小；
end

function Block:SetPos(x,y) -- 设置障碍的位置
	local bound = cBound - 1
	-- x,y 最大最小范围
	x = math.max(x,-bound) --取参数最大值
	x = math.ceil(math.min(x,bound-self.size + 1)) -- 取参数最小值
	y = math.max(y,-bound)
	y = math.ceil(math.min(y,bound-self.size + 1))
	local posx,posy = Grid2Pos(x,y)
	local rawSize = self.sp:getContentSize() -- 获取精灵纹理大小
	self.sp:setPosition(posx+rawSize.width/2-cGridSize,posy+rawSize.height/2-cGridSize)
	self.x = x
	self.y = y
end

function Block:SetBlock() -- 放进碰撞检测表，注意，需要放入的是整个块  -1 左下角       math.ceil(self.size) - 1 左上角
	for bx = -1,math.ceil(self.size) - 1 do
		for by = -1,math.ceil(self.size) - 1 do
			SetCollide(self.x+bx,self.y+by,{Type="block"})
		end
	end
end

local function AxisHit(a,asize,b,bsize) -- 两个图形 是否重叠/碰撞
	if a<b then
		return a+asize>b
	else
		return b+bsize>a
	end
end

function Block:Hit(other) -- 重叠检测
	return AxisHit(self.x,self.size,other.x,other.size) and AxisHit(self.y,self.size,other.y,other.size)
end

function Block:Clear()
	self.node:removeChild(self.sp)
end

return Block