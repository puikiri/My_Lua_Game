local PassScene = class("PassScene", cc.load("mvc").ViewBase) -- 如果有ctor构造函数则会覆盖，导致没有self:getApp(),如果要用ctor则在ctor传入app，然后新建一个getApp函数return这个app即可

local Snake = require ("app.views.SnakeGame.Sp.Snake") -- 导入蛇的文件引用
local AppleFactory = require ("app.views.SnakeGame.Sp.AppleFactory") -- 导入苹果的文件引用
local WallFactory = require ("app.views.SnakeGame.Sp.WallFactory") -- 导入围墙的文件引用
local PortalFactory = require ("app.views.SnakeGame.Sp.PortalFactory") -- 导入传送门的文件引用
local BlockFactory = require ("app.views.SnakeGame.Sp.BlockFactory")  -- 导入障碍工厂的文件引用
require ("app.views.SnakeGame.System.CollideManage") -- 获取 碰撞检测 文件的引用
require ("app.views.Common") -- 获取 全局变量/函数 文件的引用

function PassScene:onEnter()
	print("游玩贪吃蛇小游戏")
    display.newSprite("SnakeGame/SnakeGameBg.jpg")
        :move(display.center)
        :addTo(self)
	self.score = 0 -- 第一次进来的时候分数置零，只在第一次进场景时初始化
	self:CreateScoreBoard() -- 创建计分板
	self:CreateBestScoreBoard() -- 创建记录榜
	self:Reset() -- 初始化界面
	self:ProcessInput() -- 添加监听点击事件
	local tick = function() -- 监听事件循环调用函数，检测是否碰撞/更新蛇/更新苹果
		if self.state == "running" then
			self.snake:Update()
			local headX,headY = self.snake:GetHeadGrid()
			local event = CheckCollide(headX,headY) -- 碰撞检测
			if event ~= nil and event.Name ~="body1" then 
				if event.Name == "apple" then -- 碰到苹果
					self.appleFactory:Generate() -- 创建新苹果
					self.snake:Grow() -- 加长蛇身
					self.score = self.score + 1 -- 计分板 分数+1
					self:SetScore(self.score) -- 重新显示计分板
					if ExPoint ~= 0 and DxPoint ~= 0 then -- 闯关模式才能换关卡
						if self.score ~= 0 and self.score % 6 == 0 then -- 每吃到6个就换关卡,并且更新关卡
							Point = Point + 1
							if Point > MaxPoint then -- 最大9个关卡
								Point = MaxPoint
							end
							print(string.format("换到关卡%d",Point))
							-- self:getApp():enterScene("SnakeGame.System.PassScene","FADE", 0.6, display.COLOR_BLACK)-- 切换新关卡
							ResetCollide()
							self:Reset()
						end
					end
					if DxPoint == 0 and self.score ~= 0 and self.score %6 == 0 then -- 无尽模式，每吃到6个就自动生成多一组传送门
						self.portalFactory = PortalFactory.new( cBound, self ,self.score)
					end
				elseif event.Type == "wall" or event.Type == "body" or event.Type == "block" then -- 碰到非苹果
					self.state = "death" -- 当碰撞死后，状态为Death，不再监听点击事件
					self.snake:Blink(
					function()
						ResetCollide() --重新加载界面时需要清空已经存放进碰撞检测表的东西
						--self:Reset() -- 没提示直接重新开始
						self:DeathBoard() -- 提示，可重来可返回
					end)
				elseif event.Type == "portal" then
					self.snake:SetHeadGrid(event.link.x,event.link.y)
				end
			end
		end
	end
	-- cc.Director:getInstance():getScheduler():scheduleScriptFunc 定时器，每间隔多少秒就自动执行tick函数
	-- callback: 回调函数，Scheduler会传递给回调函数一个参数dt，表示距离上次回调所经过的时间
	-- delay:每次调用回调函数的时间间隔
	-- pause: 是否停住，一般设为false就行，否则定时器停住不执行
	cc.Director:getInstance():getScheduler():scheduleScriptFunc(tick,cMoveSpeed,false)
end

function PassScene:CreateStrBoard(str,x,y,size)
	local ttfConfig = {}
	-- 计分板 ， 先初始化字体
	ttfConfig.fontFilePath = "FZMWFont.ttf"
	ttfConfig.fontSize = size
	local str = cc.Label:createWithTTF(ttfConfig,str) 
	self:addChild(str)
	str:setPosition(x,y)
	return str
end

function PassScene:CreateBestScoreBoard() -- 记录榜
	display.newSprite("SnakeGame/Apple.png")
		:move(display.left + 25,display.cy + 250)
		:addTo(self)
	local bestScore = 0
	if DxPoint == 0 then
		bestScore = DxPointScore
	elseif ExPoint == 0 then
		bestScore = ExPointScore
	else
		bestScore = PointScore
	end
	display.newSprite("SnakeGame/Apple.png")
		:move(display.left + 70,display.cy + 200)
		:addTo(self)
	self:CreateStrBoard(string.format("最高纪录：%d",bestScore),display.left + 100,display.cy + 250,20)
end

function PassScene:CreateScoreBoard() -- 计分板
	display.newSprite("SnakeGame/Apple.png")
		:move(display.left + 70,display.cy + 200)
		:addTo(self)
	self.scoreLabel = self:CreateStrBoard(self.score,display.left + 100,display.cy+200,30)
end

function PassScene:DeathBoard() -- 死亡面板，可选择重来还是返回
	if DxPoint == 0 then -- 各模式更新最新记录
		SaveScore("DxPointScore",self.score,0)
	elseif ExPoint == 0 then
		SaveScore("ExPointScore",self.score,0)
	else
		SaveScore("PointScore",self.score,Point)
	end
	display.newSprite("SnakeGame/SnakeGameBg_death.png")
		:move(display.center)
		:addTo(self)
	
	self:CreateStrBoard(string.format("您的得分是：%d",self.score),display.cx, display.cy ,30)

	ccui.Button:create("Again_btn_1.png","Again_btn_2.png")
		:move(display.cx, display.cy - 100)
		:addTo(self)
		:addClickEventListener(
		function()
			print("重新加载界面")
			self:getApp():enterScene("SnakeGame.System.PassScene","FADE", 0.6, display.COLOR_BLACK)-- 重新开始，重新加载界面				
		end)
	ccui.Button:create("Back_btn_1.png","Back_btn_2.png")
		:move(display.cx + 400, display.bottom + 45)
		:addTo(self)
		:addClickEventListener(
		function()
			print("返回贪吃蛇选择界面")
			self:getApp():enterScene("SnakeGame.System.SnakeTitleScene","FADE", 0.6, display.COLOR_BLACK) --返回开始选择界面
		end)
end

function PassScene:Load() -- 读取障碍 -- 全局关卡/自定义关卡
	local f = assert(dofile(string.format("src/app/views/SnakeGame/System/CheckPoint/Point_%d.lua",self.p)))
	self.blockFactory:Reset() -- 重置障碍
	for _,t in ipairs(f) do
		self.blockFactory:Add(t.x,t.y,t.index)
	end
	print("Load")
end

function PassScene:Reset() -- 初始化
	if self.snake ~= nil then
		self.snake:Kill() -- 重置蛇
	end
	if self.appleFactory ~= nil then
		self.appleFactory:Reset() -- 重置苹果
	end
	if self.wallFactory ~= nil then
		self.wallFactory:Reset() -- 重置围墙
	end
	if self.portalFactory ~= nil then -- 重置传送门
		self.portalFactory:Reset()
	end
	if self.blockFactory ~= nil then -- 重置障碍
		self.blockFactory:Reset()
	end
	self.blockFactory = BlockFactory.new( self ) -- 障碍工厂
	if DxPoint ~= 0 then -- 不是无尽模式才有障碍
		self.p = Point -- 初始化为已闯过关/自己选择的关卡
		if ExPoint == 0 then -- ExPoint == 0 点击的是进入自定义地图
			self.p = ExPoint
		end
		self:Load() -- 创建障碍，不是无尽模式才回创建障碍
	end
	self.wallFactory = WallFactory.new( cBound,self ) -- 创建城墙
	self.portalFactory = PortalFactory.new( cBound, self ,0) -- 创建传送门
	self.appleFactory = AppleFactory.new( cBound, self ) -- 创建苹果
	self.snake = Snake.new(self) -- 创建蛇
	
	self.state = "running" -- 初始化状态为可动
	self:SetScore(self.score)
end

function PassScene:SetScore(s) -- 刷新计分板
	self.scoreLabel:setString(string.format("%d",s))
end

local function vector2Dir( x,y ) -- 从点击位置判断方向
	if math.abs(x) > math.abs(y) then -- math.abs(...)获取某数的绝对值
		if x < 0 then
			return "left"
		else
			return "right"
		end
	else
		if y < 0 then
			return "down"
		else
			return "up"
		end
	end
end

function PassScene:ProcessInput() -- 处理输入
	local function onTouchBegan(touch,ebent)
		local location = touch:getLocation() --点击位置
		local visibleSize = cc.Director:getInstance():getVisibleSize() -- 取到 图形/可视 区域大小
		local origin = cc.Director:getInstance():getVisibleOrigin() -- 取到 图形/可视 原点
		
		local finalX = location.x - origin.x - visibleSize.width /2 
		local finalY = location.y - origin.x - visibleSize.height /2 
		
		local dir =  vector2Dir( finalX, finalY)-- 方向
		self.snake:SetDir(dir)
	end
	local listener = cc.EventListenerTouchOneByOne:create() -- // 创建一个事件监听器 OneByOne 为单点触摸
	listener:registerScriptHandler( onTouchBegan , cc.Handler.EVENT_TOUCH_BEGAN) --单点触摸监听者 cc.Handler.EVENT_TOUCH_BEGAN
	local eventDispatcher = self:getEventDispatcher() -- 获得当前事件
	eventDispatcher:addEventListenerWithSceneGraphPriority( listener, self) --响应点击，监听点击后 更新事件/蛇的移动方向
end
-- registerScriptTouchHandler             注册触屏事件
-- registerScriptTapHandler                  注册点击事件
-- registerScriptHandler                         注册基本事件 包括 触屏 层的进入 退出 事件
-- registerScriptKeypadHandler           注册键盘事件
-- registerScriptAccelerateHandler      注册加速事件

return PassScene
