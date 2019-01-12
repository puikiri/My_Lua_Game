local AppleFactory = class("AppleFactory")
require ("app.views.Common")
-- 苹果工厂
function AppleFactory:ctor(bound , node) -- bound 苹果生成范围  node-父窗口 self
	self.bound = bound
	self.node = node
	math.randomseed(os.time()) -- 接收一个整数 n 作为随机序列种子。
	self:Generate()
end

function AppleFactory:Generate()
	if self.appleSprite ~= nil then -- 每次进来如果已经有苹果对象则先删除，避免浪费资源
		self.node:removeChild(self.appleSprite)
	end
	-- cc.Sprite:create (filename)。指定图片创建精灵。
	-- cc.Sprite:create (filename, rect)。指定图片和裁剪的矩形区域来创建精灵。
	-- cc.Sprite:createWithTexture (texture)。指定纹理创建精灵。
	-- cc.Sprite:createWithTexture(texture, rect, rotated=false)。指定纹理和裁剪的矩形区域来创建精灵，第三个参数是否旋转纹理，默认不旋转。
	-- cc.Sprite:createWithSpriteFrame(pSpriteFrame)。通过一个精灵帧对象创建另一个精灵对象。
	-- cc.Sprite:createWithSpriteFrameName (spriteFrameName)。通过指定帧缓存中精灵帧名创建精灵对象。
	local sp = cc.Sprite:create("SnakeGame/Apple.png") --创建苹果的精灵
	local x,y = RandomEmptyPos(self.bound) -- self.bound - 1不生成在边缘
	local finalX,finalY = Grid2Pos(x,y) -- 获取图形界面的位置坐标
	sp:setPosition(finalX,finalY) -- 精灵位置 系统函数
	self.node:addChild(sp) -- 把当前精灵加到当前节点去显示
	-- x,y 逻辑坐标，finalX，finalY 图形界面坐标
	SetCollide(x,y,{Name="apple",Type="apple"}) -- 添加进碰撞表碰撞
	--备份苹果数据
	self.appleX = x
	self.appleY = y
	self.appleSprite = sp
end

function AppleFactory:Reset() -- 重置函数
	self.node:removeChild(self.appleSprite)
end

return AppleFactory