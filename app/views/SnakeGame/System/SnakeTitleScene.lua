local SnakeTitleScene = class("SnakeTitleScene", cc.load("mvc").ViewBase)
require ("app.views.Common") --  -- 全局变量/函数 文件的引用
function SnakeTitleScene:onEnter()
	print("这里是贪吃蛇小游戏 ------")
	LoadScore() -- 每次进来前先Load一次，更新最高记录
    display.newSprite("SnakeGame/SnakeGameBg.jpg")
        :move(display.center)
        :addTo(self)
	for i=1,Point do -- 创建已完成的闯关的按钮供选择
		local minI = i
		if (i / 5) > 1 then
			minI = i%5
		end
		createButton(self,string.format("SnakeGame/Point_%d.png",i),string.format("SnakeGame/Point_%d.png",i),display.cx - 300 + 100 * minI, display.cy + 300 - 100*(math.ceil(i/5)),
		function()
			print("开始闯关模式")
			Point = i
			ExPoint = -1
			DxPoint = -1
			self:getApp():enterScene("SnakeGame.System.PassScene","FADE", 0.6, display.COLOR_BLACK)
		end) 
	end
	createButton(self,"Begin_btn_1.png","Begin_btn_2.png",display.cx, display.cy - 100,
		function()
			print("开始闯关模式")
			ExPoint = -1
			DxPoint = -1
			self:getApp():enterScene("SnakeGame.System.PassScene","FADE", 0.6, display.COLOR_BLACK)
		end) 
	createButton(self,"SnakeGame/Build_map_1.png","SnakeGame/Build_map_2.png",display.cx, display.cy - 150,
		function()
			print("编辑地图")
			self:getApp():enterScene("SnakeGame.System.EditScene","FADE", 0.6, display.COLOR_BLACK)
		end)
	createButton(self,"SnakeGame/Play_map_1.png","SnakeGame/Play_map_2.png",display.cx, display.cy - 200,
		function()
			print("自定义游戏")
			ExPoint = 0
			DxPoint = -1
			self:getApp():enterScene("SnakeGame.System.PassScene","FADE", 0.6, display.COLOR_BLACK)
		end)
	createButton(self,"SnakeGame/Endless_btn_1.png","SnakeGame/Endless_btn_2.png",display.cx, display.cy - 250,
		function()
			print("无尽模式")
			ExPoint = -1
			DxPoint = 0
			self:getApp():enterScene("SnakeGame.System.PassScene","FADE", 0.6, display.COLOR_BLACK)
		end)
	createButton(self,"Back_btn_1.png","Back_btn_2.png",display.cx + 400, display.bottom + 45,
		function()
			print("返回到选择游戏界面")
			self:getApp():enterScene("TitleScene","FADE", 0.6, display.COLOR_BLACK)		
		end)
end

return SnakeTitleScene
