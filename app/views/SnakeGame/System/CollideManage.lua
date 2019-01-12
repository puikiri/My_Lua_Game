-- 碰撞检测管理器  Lua传统的写法，类似C++宏/公有接口

-- 逻辑是 ： SetCollide 把全部的坐标/位置统一放进表里，每次检测碰撞的时候，只需要查看传进来的x，y组成的key是否在Table里面能找到值，不为空则碰撞了！
cc.exports.Pos2EventMap = {}

local function makePosKey(x,y) -- 生成 x,y Key
	return string.format("%d,%d",x,y);
end

function cc.exports.SetCollide(x,y,event) -- 放置坐标
	if event.Name ~= nil then -- 判断传入的事件有没有Name -> 有就是专有碰撞，比如蛇碰蛇身，蛇碰苹果，没有则是特殊碰撞，比如蛇碰围墙
		for key,ev in pairs(Pos2EventMap) do -- 专有碰撞的话就要先清空之前的数据
			if ev.Name == event.Name then
				Pos2EventMap[key] = nil
			end
		end
	end
	local key = makePosKey(x,y)
	if Pos2EventMap[key] ~= nil then
		return 
	end
	Pos2EventMap[key] = event
end

function cc.exports.CheckCollide(x,y) -- 碰撞检测
	return Pos2EventMap[makePosKey(x,y)]
end

function cc.exports.ResetCollide() -- 清空
	Pos2EventMap = {}
end

function cc.exports.RandomEmptyPos(bound) -- 随机算法，生成的时候检查是否生成了已存在的，如果是则重新生成，针对苹果/障碍的生成
	local genBoundLimit = bound - 1
	local x,y
	while true do
		x =  math.random( -genBoundLimit, bound ) --在指定范围内创建一个随机数
		y =  math.random( -genBoundLimit, bound ) --在指定范围内创建一个随机数
		if CheckCollide(x,y) == nil then
			break
		end
	end
	return x,y
end