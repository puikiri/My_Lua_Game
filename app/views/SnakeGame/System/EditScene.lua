local WallFactory = require ("app.views.SnakeGame.Sp.WallFactory") -- 导入围墙的文件引用
require ("app.views.SnakeGame.System.CollideManage") -- 获取 碰撞检测 文件的引用
require ("app.views.Common") -- 获取 全局变量/函数 文件的引用
local Block = require ("app.views.SnakeGame.Sp.Block") -- 导入障碍的文件引用
local BlockFactory = require ("app.views.SnakeGame.Sp.BlockFactory") -- 导入障碍工厂的文件引用

local EditScene = class("EditScene", cc.load("mvc").ViewBase)

function EditScene:onEnter()
	print("贪吃蛇缔造地图")
	self.wallFactory = WallFactory.new( cBound,self ) -- 创建城墙
	self.curX = 0
	self.curY = 0
	self.curIndex = 0
	self:SwitchCursor(1)
	self:ProcessInput()
	self.blockFactory = BlockFactory.new(self)
end
--[[
-- function EditScene:ProcessInput() -- 上下左右翻页点击监听事件
	-- local function keyboardPressed(keyCode,event)
		-- if keyCode == 28 then
			-- self:MoveCursor(0,1)
		-- elseif keyCode == 29 then
			-- self:MoveCursor(0,-1)
		-- elseif keyCode ==26 then
			-- self:MoveCursor(-1,0)
		-- elseif keyCode == 27 then
			-- print("buliung")
			-- self:MoveCursor(1,0)
		-- elseif keyCode == 33 or keyCode == 49 then
			-- self:SwitchCursor(-1)
		-- elseif keyCode == 34 or keyCode == 50 then
			-- self:SwitchCursor(1)
		-- end
	-- end	
		-- local listener = cc.EventListenerKeyboard:create() -- 键盘监听
		-- listener:registerScriptHandler(keyboardPressed,cc.Handler.EVENT_KEYBOARD_PRESSED)
		-- local eventDispatcher = self:getEventDispatcher()
		-- eventDispatcher:addEventListenerWithSceneGraphPriority(listener,self)
-- end
-- function EditScene:MoveCursor(deltaX,deltaY)
	-- self.cur:SetPos(self.curX + deltaX,self.curY + deltaY)
	-- self.curX = self.cur.x
	-- self.curY = self.cur.y
-- end
-- function EditScene:SwitchCursor(delta) -- 切换图片/障碍
	-- if self.cur == nil then
		-- self.cur = Block.new(self)
	-- end
	-- local newIndex = self.curIndex + delta
	-- newIndex = math.max(newIndex,1)
	-- newIndex = math.min(newIndex,2)
	-- self.curIndex = newIndex
	-- self.cur:Set(newIndex)
	-- self.cur:SetPos(self.curX,self.curY)
-- end
]]--

function EditScene:Place() -- 如果当前光标下没有和其他重叠，则放置
	if self.blockFactory:Hit(self.cur) then
		return 
	end
	self.blockFactory:Add(self.curX,self.curY, self.cur.index)
end
function EditScene:Delete() -- 删除当前光标下的障碍
	self.blockFactory:Remove(self.cur)
end

function EditScene:ProcessInput() -- 点击 切换障碍/保存/读取/返回
	createButton(self,"SnakeGame/Add_block_1.png","SnakeGame/Add_block_1.png",display.cx + 375, display.bottom + 90,
		function()
			print("放置障碍") 
			self:Place()
		end) 
	createButton(self,"SnakeGame/Clear_block_1.png","SnakeGame/Clear_block_1.png",display.cx + 425, display.bottom + 90,
		function()
			print("清除障碍") 
			self:Delete()
		end) 
	createButton(self,"SnakeGame/Save_map_1.png","SnakeGame/Save_map_1.png",display.cx + 375, display.cy + 275,
		function()
			print("保存地图") 
			self:Save()
		end)
	createButton(self,"SnakeGame/Load_map_1.png","SnakeGame/Load_map_1.png",display.cx + 425, display.cy + 275,
		function()
			print("加载地图") 
			self:Load()
		end)
	createButton(self,"SnakeGame/Big_wall_1.png","SnakeGame/Big_wall_1.png",display.cx + 400, display.bottom + 150,
		function()
			print("障碍1")
			self:SwitchCursor(1)
		end) 
	createButton(self,"SnakeGame/Big_wall_2.png","SnakeGame/Big_wall_2.png",display.cx + 400, display.bottom + 225,
		function()
			print("障碍2")
			self:SwitchCursor(2)
		end) 
	createButton(self,"Back_btn_1.png","Back_btn_2.png",display.cx + 400, display.bottom + 45,
		function()
			print("返回贪吃蛇选择界面")
			self:getApp():enterScene("SnakeGame.System.SnakeTitleScene","FADE", 0.6, display.COLOR_BLACK) --返回开始选择界面
		end)
	-- 切换位置
	local function onTouchBegan(touch,ebent)
		local location = touch:getLocation() --点击位置
		local fx,fy = Pos2Grid(location.x,location.y)
		local ceilfx,ceilfy = math.ceil(fx),math.ceil(fy)
		if -cBound <= ceilfx and ceilfx <= cBound and -cBound <= ceilfy and ceilfy <= cBound then			
			self:MoveCursor(ceilfx,ceilfy)
		end
	end
	local listener = cc.EventListenerTouchOneByOne:create() -- // 创建一个事件监听器 OneByOne 为单点触摸
	listener:registerScriptHandler( onTouchBegan , cc.Handler.EVENT_TOUCH_BEGAN) --单点触摸监听者 cc.Handler.EVENT_TOUCH_BEGAN
	local eventDispatcher = self:getEventDispatcher() -- 获得当前事件
	eventDispatcher:addEventListenerWithSceneGraphPriority( listener, self) --响应点击，监听点击后 更新事件/蛇的移动方向
end

function EditScene:MoveCursor(deltaX,deltaY) -- 障碍位置
	self.cur:SetPos(deltaX,deltaY)
	self.curX = self.cur.x
	self.curY = self.cur.y
end

function EditScene:SwitchCursor(delta) -- 切换图片/障碍
	if self.cur == nil then
		self.cur = Block.new(self)
	end
	local newIndex = delta
	newIndex = math.max(newIndex,1)
	newIndex = math.min(newIndex,2)
	self.curIndex = newIndex
	self.cur:Set(newIndex)
	self.cur:SetPos(self.curX,self.curY)
end

-- 编辑的地图的存取
function EditScene:Save()
	local f = assert(io.open("src/app/views/SnakeGame/System/CheckPoint/Point_0.lua","w"))
	f:write("return {\n") -------文件的内容保存的样子类似这样：return{ blockFactory创建的全部的block的Table bolckArr[1],
	self.blockFactory:Save(f)----						bolckArr[2],.....bolckArr[n]
	f:write("}\n")---------------						} 下面difile读文档的时候就直接读到return回来的 bolckArr Table
	f:close()
	print("Save")
end
function EditScene:Load()
	local f = assert(dofile("src/app/views/SnakeGame/System/CheckPoint/Point_0.lua"))
	self.blockFactory:Reset()
	for _,t in ipairs(f) do
		self.blockFactory:Add(t.x,t.y,t.index)
	end
	print("Load")
end

return EditScene