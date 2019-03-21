cc.FileUtils:getInstance():setPopupNotify(false)

require "Scene/Log"
require "config"
require "cocos.init"

local director =cc.Director:getInstance();
---@type GLView
local glView= director:getOpenGLView();

if (glView==nil) then
    glView=cc.GLViewImpl:createWithRect("LuaGame",cc.rect(0,0,CC_DESIGN_RESOLUTION.width,CC_DESIGN_RESOLUTION.height));
    director:setOpenGLView(glView);
    --print("glview == nill");
else
    --print("glview ~= nill");
end

director:setDisplayStats(CC_SHOW_FPS);
director:setAnimationInterval(CC_ANIMATION_INTERVAL);

--glView:setDesignResolutionSize(CC_DESIGN_RESOLUTION.width,CC_DESIGN_RESOLUTION.height,cc.ResolutionPolicy.NO_BORDER);
local fileUtils =cc.FileUtils:getInstance();

local function addSearchPath(resPrefix)
    local searchPaths=fileUtils:getSearchPaths();
    table.insert(searchPaths,1,resPrefix);
    table.insert(searchPaths,1,resPrefix.."cocosbuilderRes");

    --if (screenSize.height>320) then
    --    table.insert(searchPaths,1,resPrefix.."hd");
    --    table.insert(searchPaths,1,resPrefix.."css-res");
    --    table.insert(searchPaths,1,resPrefix.."css-res/hd");
    --end
    fileUtils:setSearchPaths(searchPaths);

end


addSearchPath("res/");
addSearchPath("");

local function runScene(layer)
    local scene=cc.Scene:create();
    scene:addChild(layer);
    if(director:getRunningScene())then
        director:replaceScene(scene);
    else
        director:runWithScene(scene);
    end
end


local function main()
    --local Layer= require("Scene/Lobby");
    local Layer= require("Scene/Game");
    local layer=Layer.new();
    runScene(layer:getLayer());
end

--Log.debug('Main---------------');
local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end



--local State=require("Scene/State");
--local state=State.new();
--
--state:setStateBindFunction(1,
--        function (args)
--            print("\t\t1:state 执行函数");
--            for i,v in pairs(args) do
--                print('\t\t\t'..v);
--            end
--        end,
--        function (args)
--            print("\t\t1:last 执行函数");
--        end
--);
--state:setStateBindFunction(2,
--        function (args)
--            print("\t\t2:state 执行函数");
--        end,
--        function (args)
--            print("\t\t2:last 执行函数");
--        end
--);
--state:setStateRunFunction(1,"state",11,12,13);
--state:setStateRunFunction(2,"state",21,22,23,"lastState",24,25,26);


--local function funA(arg)
--    print("1:state 执行函数:"..arg);
--end
--
--local function funB(arg)
--    print("2:state 执行函数:"..arg);
--end
--
--state:pushStack(funA,1);
--state:pushStack(funB,2);
--
--state:popAllStack();
--state:popAllStackCallFunction();





--state:setStateBindFunction(1,
--        function (args)
--            print("\t\t1:state 执行函数");
--            for i,v in pairs(args) do
--                print('\t\t\t'..v);
--            end
--         end,
--        function (args)
--            print("\t\t1:last 执行函数");
--            for i,v in pairs(args) do
--                print('\t\t\t'..v);
--            end
--        end
--);
--
--state:setStateBindFunction(2,
--        function (args)
--            print("\t\t2:state 执行函数");
--            for i,v in pairs(args) do
--                print('\t\t\t'..v);
--            end
--        end,
--        function (args)
--            print("\t\t2:last 执行函数");
--            for i,v in pairs(args) do
--                print('\t\t\t'..v);
--            end
--        end
--);
--
--print("State------run--1----");
--state:setStateRunFunction(1,"state",11,12,13);
--print("State------run--2----");
--state:setStateRunFunction(2,"state",21,22,23,"lastState",24,25,26);
--print("State------run--1----");
--state:setStateRunFunction(1,"state",31,32,33,"lastState",34,35,36);

--cc.FileUtils:getInstance():setPopupNotify(false)
--
--require "config"
--require "cocos.init"
--
--local function main()
--    require("app.MyApp"):create():run()
--end
--
--local status, msg = xpcall(main, __G__TRACKBACK__)
--if not status then
--    print(msg)
--end







