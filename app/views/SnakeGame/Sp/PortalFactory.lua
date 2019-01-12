local PortalFactory = class("PortalFactory")
-- 传送门
require ("app.views.Common")
function PortalFactory:ctor(bound,node,index) -- 构造函数，随机生成传送门 x->普通模式只会传进来0，无尽模式一直生成传送门的index
	self.bound = bound
	self.node = node
	self.index = index
	self.portalArr = {}
	self.portalArrName = {}
	math.randomseed(os.time()) -- 接收一个整数 n 作为随机序列种子。
	self:Generate()
end

function PortalFactory:Generate() -- 创建传送门-成对的
	local a = string.format("portala%d",self.index)
	local b = string.format("portalb%d",self.index)
	self.portalArr[a] = self:createPortal()
	self.portalArr[b] = self:createPortal()
	table.insert(self.portalArrName,a)
	table.insert(self.portalArrName,b)
	SetCollide(self.portalArr[a].x,self.portalArr[a].y,{Name=a,Type="portal",link=self.portalArr[b]}) -- 传送门互相指向
	SetCollide(self.portalArr[b].x,self.portalArr[b].y,{Name=b,Type="portal",link=self.portalArr[a]}) -- 传送门互相指向
end

function PortalFactory:createPortal() -- 创建传送门 单个
	local sp = cc.Sprite:create("SnakeGame/Portal_1.png")
	local x,y = RandomEmptyPos(self.bound)
	
	local finalX,finalY = Grid2Pos(x,y)
	sp:setPosition(finalX,finalY)
	self.node:addChild(sp)
	return {["x"]=x,["y"]=y,["sp"]=sp}
end

function PortalFactory:Reset() -- 清空传送门
	for _,t in ipairs(self.portalArrName) do
		if self.portalArr[t] ~= nil then
			self.node:removeChild(self.portalArr[t].sp)
		end
	end
end

return PortalFactory