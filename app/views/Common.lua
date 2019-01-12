local Common = class("Common")
--全局变量/函数文件

-- 新版本 cc.exports.*** 才是声明是一个全局的
-- 贪吃蛇 专有 begin
cc.exports.MaxPoint = 9 -- 总共九个关卡
cc.exports.Point = 1 -- 初始为第一个关卡
cc.exports.ExPoint = -1 -- 游玩自定义地图标记，0 为游玩，-1为游玩其他的
cc.exports.DxPoint = -1 -- 游玩无尽模式，0 为游玩，-1为游玩其他的
cc.exports.PointScore = 0 -- 对应记录分数
cc.exports.ExPointScore = 0 -- 
cc.exports.DxPointScore = 0 -- 

cc.exports.cMoveSpeed = 0.3 -- 移动速度
cc.exports.cBound = 9  -- 逻辑地图大小 9+9  *  9+9
cc.exports.cGridSize = 33 -- 屏幕分辨率单格
local scaleRate = 1/display.contentScaleFactor
function cc.exports.Grid2Pos(x,y) -- 通过逻辑坐标获取图形/屏幕坐标
	local visibleSize = cc.Director:getInstance():getVisibleSize() -- 取到 图形/可视 区域大小
	local origin = cc.Director:getInstance():getVisibleOrigin() -- 取到 图形/可视 原点
	local finxlX = origin.x + visibleSize.width /2 + x * cGridSize * scaleRate
	local finxlY = origin.y + visibleSize.height /2 + y * cGridSize * scaleRate	
	return finxlX,finxlY
end
function cc.exports.Pos2Grid(x,y) -- 通过图形/屏幕坐标获取逻辑坐标
	local visibleSize = cc.Director:getInstance():getVisibleSize() -- 取到 图形/可视 区域大小
	local origin = cc.Director:getInstance():getVisibleOrigin() -- 取到 图形/可视 原点
	local finxlX = (x - origin.x - visibleSize.width /2 )/(cGridSize * scaleRate)
	local finxlY = (y - origin.y - visibleSize.height /2 )/(cGridSize * scaleRate)
	return finxlX,finxlY
end

-- 各模式分数的存取
function cc.exports.SaveScore(str,score,pass) -- 对应 PointScore/ExPointScore/DxPointScore 对应分数值 闯关层数(闯关传Point，非闯关传0)
	LoadScore() -- 先获取最高纪录数据再更新
	local f = assert(io.open("src/app/views/SnakeGame/System/BaseScore.lua","w"))
	if pass ~= 0 and Point < pass then
			Point = pass
	end
	if str == "PointScore" and PointScore < score then
		PointScore = score
	elseif str == "ExPointScore" and ExPointScore < score then
		ExPointScore = score
	elseif str == "DxPointScore" and DxPointScore < score then
		DxPointScore = score
	end
	f:write("return {\n")
	f:write(string.format("PointScore=%d,\n",PointScore))
	f:write(string.format("ExPointScore=%d,\n",ExPointScore))
	f:write(string.format("DxPointScore=%d,\n",DxPointScore))
	f:write(string.format("pass=%d,\n",Point))
	f:write("}\n")
	f:close()
	print("保存新纪录")
end
function cc.exports.LoadScore()
	local scoreTable = assert(dofile("src/app/views/SnakeGame/System/BaseScore.lua"))
	if scoreTable ~= nil then
		if scoreTable["PointScore"] ~= nil then
			PointScore = scoreTable["PointScore"]
		end
		if scoreTable["pass"] ~= nil then
			Point = scoreTable["pass"]
		end
		if scoreTable["ExPointScore"] ~= nil then
			ExPointScore = scoreTable["ExPointScore"]
		end
		if scoreTable["DxPointScore"] ~= nil then
			DxPointScore = scoreTable["DxPointScore"]
		end
	end
	print("读取本地存储数据")
end
-- 贪吃蛇 专有 end

function cc.exports.createButton(node,imageName_1,imageName_2,x,y,callback) -- 按钮模板
	ccui.Button:create(imageName_1,imageName_2)
		:move(x, y)
		:addTo(node)
		:addClickEventListener(callback) -- 点击回调函数
end

return Common