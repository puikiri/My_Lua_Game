local TitleScene = class("TitleScene", cc.load("mvc").ViewBase) -- 类似继承
require ("app.views.Common") -- 全局变量/函数 文件的引用
function TitleScene:onEnter()
    -- add background image
    display.newSprite("bg.jpg")
        :move(display.center)
        :addTo(self)
	-- 	display.cx, display.cy 屏幕中心 display.bottom 屏幕底端
	createButton(self,"Snake_game_Begin_btn_1.png","Snake_game_Begin_btn_2.png",display.cx - 275, display.cy + 175,
		function()
			print("开始贪吃蛇游戏")
			-- 切换界面			 							  -- 场景  切换效果  速度  切换时颜色
			self:getApp():enterScene("SnakeGame.System.SnakeTitleScene","FADE", 0.6, display.COLOR_BLACK)
			
			--local s = require("..").new()
			--display.replaceScene(s,"Fade",0.6,display.COLOR_BLACK) -- 不能正确切换
			
			--local s = display.newScene("..")
			--display.runScene(s, "FADE", 0.6, display.COLOR_BLACK) -- 不能正确切换
			
		end) -- 贪吃蛇
	createButton(self,"Setup_btn_1.png","Setup_btn_2.png",display.cx + 400, display.bottom + 90,
		function()
			print("设置")
		end)
	createButton(self,"Exit_btn_1.png","Exit_btn_2.png",display.cx + 400, display.bottom + 45,
		function()
			print("退出")
			os.exit() -- 退出程序
		end)
		
end
    -- add HelloWorld label -- 创建文字内容
    -- cc.Label:createWithSystemFont("Hello World", "Arial", 40)
        -- :move(display.cx, display.cy + 200)
        -- :addTo(self)

return TitleScene
