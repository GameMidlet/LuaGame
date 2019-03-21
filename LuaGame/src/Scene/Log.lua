---日志管理类
--    require("src.Log");
--    Log.info("abc:%d,fa:%s",23,"zz")
--    Log.warn("abc:%d,fa:%s",23,"zz")
--    Log.log("abc:%d,fa:%s",23,"zz")
--    Log.error("abc:%d,fa:%s",23,"zz")
--    Log.debug("abc:%d,fa:%s",23,"zz")
--    Log.getSceneLog()获取场景日志
--  注意:Log类是全局对象，2dx需要config.lua:CC_DISABLE_GLOBAL = false 修改一下

---@class Log
Log = {
    sceneLog = {}; --场景日志
    logUneHistoireNumber = 4; --日志历史条目

    isShowTitle = true; --是否显示log的类型(none,error,warn,info,debug);
    showTitle = { 'none', 'error', 'warn', 'info', 'log', 'debug' };
    gameLogType = {
        NONE = 1, --什么都不打印
        ERROR = 2, --打印error及以上，其实最高就是error
        WARN = 3, --打印warn及以上
        INFO = 4, --打印info及以上
        LOG = 5, --打印log及以上
        DEBUG = 6, --打印debug及以上
    };
    logObject = print or debug; ---日志输出函数对象
};

--Log.logType=Log.gameLogType.NONE;--不显示日志
Log.logType = Log.gameLogType.DEBUG;--显示全部日志

---@overload fun(args:string,...):void
---@generic T
---@param args string
---@vararg T
function Log.info(args, ...)
    local vSubst = Log.setLinkString(args, ...);
    Log.showContent(vSubst, Log.gameLogType.INFO);
end

---@overload fun(args:string,...):void
---@generic T
---@param args string
---@vararg T
function Log.warn (args, ...)
    local vstring = debug.traceback("", 2);
    --print("warn.trace:" .. vpath);
    local vpath = Log.csA(vstring);
    --print("path:" .. vpath);
    args=vpath.." "..args;
    --args=vstring.." "..args;

    local vSubst = Log.setLinkString(args, ...);
    Log.showContent(vSubst, Log.gameLogType.WARN);
end


---@overload fun(args:string,...):void
---@generic T
---@param args string
---@vararg T
function Log.debug(args, ...)
    local vSubst = Log.setLinkString(args, ...);
    Log.showContent(vSubst, Log.gameLogType.DEBUG);
end

---@overload fun(args:string,...):void
---@generic T
---@param args string
---@vararg T
function Log.error (args, ...)
    local vSubst = Log.setLinkString(args, ...);
    Log.showContent(vSubst, Log.gameLogType.ERROR);
end

---@overload fun(args:string,...):void
---@generic T
---@param args string
---@vararg T
function Log.log(args, ...)
    local vSubst = Log.setLinkString(args, ...);
    Log.showContent(vSubst, Log.gameLogType.LOG);
end

---@overload fun(vShow:string,vType:number):void
---@param vShow string
---@param vType number
function Log.showContent(vShow, vType)
    if (vShow == nil) then
        return ;
    end
    local show = "" .. vShow;
    if (false) then
        show = string.format("cocos2dx:%s", show);
    end
    --print("vType:"..vType.."  "..type(vType));
    if (Log.isShowTitle) then
        if (type(vType) == "number") then
            local stype = Log.showTitle[vType];
            --print("stype:"..stype);
            show = string.format("%s:%s", stype, show);
        end
    end

    if (Log.logType ~= Log.gameLogType.NONE) then
        Log.outLog(show, vType);
        --Log.logObject(show);
    end

    Log.setSceneLog(show);
end

-----输出日志
-----@overload fun(args:string,vType:number)
-----@param args string
-----@param vType number
function Log.outLog(args, vType)
    Log.logObject(args);
end

---日志记录
--    local arr =Log.sceneLog;
--    for i in pairs(arr) do
--        print('\t'..i);
--        for j in pairs(arr[i]) do
--            print("\t\t" .. arr[i][j]);
--        end
--    end
---@overload fun(args:string)
---@param args string
function Log.setSceneLog(args)
    local vname = "12";
    local fgf = '\n';
    if (Log.sceneLog[vname] == nil) then
        Log.sceneLog[vname] = {};
        --print("vname:nil")
    end

    --Log.sceneLog[vname][leng+1]=args;
    table.insert(Log.sceneLog[vname], args);

    local leng = #Log.sceneLog[vname];
    --print("leng:"..leng);
    if (leng > Log.logUneHistoireNumber) then
        table.remove(Log.sceneLog[vname], 1);
    end

    --local arr =Log.sceneLog;
    --for i in pairs(arr) do
    --    print('\t'..i);
    --    for j in pairs(arr[i]) do
    --        print("\t\t" .. arr[i][j]);
    --    end
    --end
end


---获取场景日志
---@overload fun(sName:string|nil)
--    local arr=Log.getSceneLog("12");
--    local show="";
--    if(arr)then
--        for i in pairs(arr) do --局部节点
--            print("\t\t" .. arr[i]);
--            show=string.format("%s%s\n",show,  arr[i]);
--        end
--        for i in pairs(arr) do --全部节点
--            print('\t'..i);
--            for j in pairs(arr[i]) do
--                print("\t\t" .. arr[i][j]);
--                show=string.format("%s%s\n",show, arr[i][j]);
--            end
--        end
--    end
--    print("show:"..show);
---@param sName string
function Log.getSceneLog(sName)
    local vScene = Log.sceneLog;
    if (sName ~= nil) then
        for i in pairs(vScene) do
            if (i == sName) then
                --print("有"..sName);
                return Log.sceneLog[sName];
            end
        end
    else
        --print("无"..sName);
        return vScene;
    end
    return nil;
end

---连接参数内容
---@overload fun(args:string,...):string
---@generic T
---@param args string
---@vararg T
---@return string
function Log.setLinkString(args, ...)
    if (args == nil) then
        return nil;
    end

    local value = { ... };
    local index = 0;
    local count = select('#', ...);
    --print("c count:"..count);

    local show = "" .. args;
    --/%\d{0,}[c|d|i|e|f|g|o|s|x|p|n|u]/
    local pattern = '%%[c,d,i,e,f,g,o,s,x,p,n,u]';
    for s in string.gmatch(show, pattern) do
        --print(s)
        local len = string.len(s);
        local vc = "";
        if (len >= 2) then
            local i = 1;
            local a = string.sub(s, i, i);
            i = 2;
            local b = string.sub(s, i, i);
            vc = "%" .. a .. "" .. b;
            --print("a:"..a.." b:"..b.." vc:"..vc);
        else
            vc = s;
        end

        if(index == 0)then
            index=1;
        end
        --print("s:"..s.." len:"..len.." vc:"..vc);
        if (index <= count) then
            local a = string.gsub(show, vc, value[index], 1);
            --print(index.." value:"..value[index].." a:"..a);
            show = a;
        end
        index = index + 1;
    end

    --print("\t\tindex:"..index);
    --print("\t\tcount:"..count);
    local varg="";
    if(index < count)then
        for i=count-index, count do
            varg=string.format("%s%s",varg,value[i]);
        end
    end
    --print("\t\tvarg:"..varg);
    --print("show:"..show);
    return show..varg;
end





---字符串切割
----@overload fun(str:string,reps:string):table
---@param str string 切割的字符串
---@param reps string 切割符号
function Log.split(str, reps)
    local resultStrList = {}
    string.gsub(str, '[^' .. reps .. ']+', function(w)
        table.insert(resultStrList, w)
    end)
    return resultStrList
end

---获取函数调用类和函数名字
function Log.csA(vstring)
    local vUpName = "";--调用类
    local vUpFunction = ""; --调用函数
    local vUpLine = "";--行数
    --print("str:"..vstring);
    local tv = Log.split(vstring, "\n");
    --for k,v in pairs(tv) do
    --    print(k..":"..tv[k]);
    --end
    if (tv and tv[3]) then
        --local a = string.match(tv[3], "%d%d");
        --print("str:"..tv[3].."  a:"..a);  --	[string "Scene/Lobby.lua"]:10: in function 'ctor'
        local tva = Log.split(tv[3], "\"");
        --for k,v in pairs(tva) do
        --    print(k..":"..tva[k]);
        --end
        if (tva and tva[2]) then
            vUpName = tva[2];
        end

        if (tva and tva[3]) then
            local tvb = Log.split(tva[3], "'");
            if (tvb and tvb[2]) then
                vUpFunction = tvb[2];
            end
        end

        local tvc = Log.split(tv[3], ":");
        if (tvc and tvc[2]) then
            vUpLine = tvc[2];
        end

    end
    return vUpName .. " " .. vUpFunction .. " " .. vUpLine;
end

---获取参数内容
---@overload fun(...):string table
---     local a,b=Log.getArguments(1,2,4,5);
--      print("a:"..a);---a:1245
--      for i in pairs(b)  do
--          print("b:"..i);  --b:1 b:2 ...
--      end
---@generic T
---@vararg T
---@return string table
function Log.getArguments (...)
    local vStr = "";
    local vArray = {};
    for i = 1, select('#', ...) do
        local arg = select(i, ...); -- 如果selector为数字n,那么select返回它的第n个可变实参
        local vType = type(arg);
        local vcType = '';
        if (vType == 'number') then
            vcType = "%d";
        elseif (vType == 'string') then
            vcType = "%s";
        end
        vStr = string.format("%s" .. vcType, vStr, arg);
        vArray[i] = arg;
    end
    return vStr, vArray;
end

return Log;

