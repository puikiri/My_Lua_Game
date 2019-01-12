
local MainScene = class("MainScene", cc.load("mvc").ViewBase)

function MainScene:onCreate() -- 欢迎界面
    -- add background image
    display.newSprite("HelloWorld.png")
        :move(display.center)
        :addTo(self)

    -- add HelloWorld label
    cc.Label:createWithSystemFont("THANKS ! PLAY THIS GAME !", "Arial", 40)
        :move(display.cx, display.cy - 200)
        :addTo(self)

end

function MainScene:onEnter()
	print("Let's Do SomeThing!")
	self:getApp():enterScene("TitleScene","FADE", 2.5, display.COLOR_BLACK) -- 切换界面
end

return MainScene
