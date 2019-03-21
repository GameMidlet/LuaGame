--- Copyright (c) 2019 App
--- Created by  : Gpf
--- Mail        : midletmain@163.com
--- DateTime    : 2019-03-18
--- Use         : 状态机
---
-----状态机
--    setStateBindFunction(状态,当前状态执行函数,弹出状态执行函数) ---绑定函数
--    setStateRunFunction(状态,函数参数[执行函数参数,弹出函数参数]) --执行状态
--
--    pushStack(函数,参数); --- 入栈
--    popAllStack()  --- 弹出所以站内消息(前进前出)
--    popAllStackCallFunction() --- 弹出所以站内消息(前进后出)

---范例:状态机
--    local State=require("Scene/State");
--    local state=State.new();
--    state:setStateBindFunction(1,
--            function (args)
--                print("\t\t1:state 执行函数");
--                for i,v in pairs(args) do
--                    print('\t\t\t'..v);
--                end
--            end,
--            function (args)
--                print("\t\t1:last 执行函数");
--            end
--    );
--    state:setStateBindFunction(2,
--            function (args)
--                print("\t\t2:state 执行函数");
--            end,
--            function (args)
--                print("\t\t2:last 执行函数");
--            end
--    );
--    state:setStateRunFunction(1,"state",11,12,13);
--    state:setStateRunFunction(2,"state",21,22,23,"lastState",24,25,26);
--    日志
--        1:state 执行函数
--        	11
--        	12
--        	13
--        2:state 执行函数
--        1:last 执行函数
---范例:函数吞吐
--    local function funA(arg)
--        print("1:state 执行函数:"..arg);
--    end
--    local function funB(arg)
--        print("2:state 执行函数:"..arg);
--    end
--    state:pushStack(funA,1);
--    state:pushStack(funB,2);
--
--    state:popAllStack();
--    state:popAllStackCallFunction();
--    日志
--    state 执行函数:1
--    state 执行函数:2
--    state 执行函数:2
--    state 执行函数:1



local State=class("State");

function State:ctor()
    self._state = {--状态
        state= nil,--当前状态
        lastState= nil,--上一次状态
        stateBindObject= nil,--当前状态绑定的对象
    };
    self._arguments = { --状态参数参数
        stateArgument=nil,
        lastStateArgument= nil,
    };
    --状态消息队列
    self._messageStack = {
        messageList= nil,
    };
    self.debugLog = false;
    self._isCFRun = false;
end




---绑定函数
---@method setStateBindFunction
---@param state number|string|any(key) 状态,
---@param stateMenthod  function(state(key)->value->key) 当前状态-执行函数
---@param lastMenthod  function(state(key)->value->key)  上一次状态-执行函数
---
function State:setStateBindFunction (state, stateMenthod, lastMenthod)
    if (self._state.stateBindObject == nil) then
        self._state.stateBindObject = {};
    end

    local stateKey = state;--self.modifyKey(state);
    self._state.stateBindObject[stateKey] = {
        stateMenthod=stateMenthod,
        lastMenthod=lastMenthod,
    };
end


--- 执行状态
--- @method setStateRunFunction
--- @generic T
--- @param state number 当前状态(key)
--- @vararg T  状态参数 'state'当前状态参数，'lastState'当前状态弹出参数
function State:setStateRunFunction(state,...)
    self._state.lastState = self._state.state;
    self._state.state = state;
    self:setStateArguments(...);
    self:runStateBindObject(self._state.state, self._state.lastState);
end


--- 执行状态函数
--- @method runStateBindObject
--- @param stateKey number 当前状态(key)
--- @param lastStateKey number 上一个状态(key)
---
function State:runStateBindObject(stateKey, lastStateKey)
    --当前状态
    local stateObject = self._state.stateBindObject[stateKey];
    if (stateObject~= nil)then
        if (stateObject.stateMenthod ~= nil) then
            local sKey =self._arguments.stateArgument[stateKey];
            --print("当前状态参数类型:"..type(sKey));
            --for i in pairs(sKey) do
            --    print('\t\t'..sKey[i]);
            --end
            --print("--------------------");
            if(sKey~=nil and #sKey>=1)then
                stateObject.stateMenthod(sKey);
            else
                stateObject.stateMenthod();
            end
        end
    end

    --上一个状态
    local lastStateObject = self._state.stateBindObject[lastStateKey];
    if (lastStateObject~= nil)then
        if (lastStateObject.lastMenthod ~= nil) then
            local eKey =self._arguments.lastStateArgument[lastStateKey];
            if(eKey~=nil and #eKey>=1)then
                lastStateObject.lastMenthod(eKey);
            else
                lastStateObject.lastMenthod();
            end
        end
    end
end



--- 入栈
--- @method pushStack
--- @param key  function 执行的函数名字(函数名字)
--- @param args any 参数
---
function State:pushStack(key, args)
    local msg = {
        key= key,
        args= args
    };
    --print('添加队列方法:' .. msg.key);
    if(self._messageStack.messageList==nil)then
        self._messageStack.messageList={};
    end
    table.insert(self._messageStack.messageList,msg);
end

--- 弹出所以站内消息(前进前出)
--- @method popAllStack
--- @param object any 谁执行谁调用
function State:popAllStack(object)
    local count = #self._messageStack.messageList;
    for i = 1, count do
        local vObject=self._messageStack.messageList[i];
        if(vObject~=nil)then
            if(type(vObject.key)=="function")then
                vObject.key(vObject.args);
            end
        end
    end
end

--- 弹出所以站内消息(前进后出)
--- @method popAllStackCallFunction
--- @param object any 谁执行谁调用
function State:popAllStackCallFunction (object)
    local count = #self._messageStack.messageList;
    for i = count, 0,-1 do
        local vObject=self._messageStack.messageList[i];
        if(vObject~=nil)then
            if(type(vObject.key)=="function")then
                vObject.key(vObject.args);
            end
        end
    end
end








--- 状态参数处理
--- @method setStateArguments
--- @generic T
--- @vararg T  状态参数 'state'当前状态参数，'lastState'当前状态弹出参数
function State:setStateArguments(...)
    local vStart=self._state.state;
    local vEnd=self._state.lastState or vStart;

    if(self._arguments.stateArgument ==nil)then
        self._arguments.stateArgument={};
    end

    if(self._arguments.lastStateArgument ==nil)then
        self._arguments.lastStateArgument={};
    end
    --'state'当前状态参数，'lastState'当前状态弹出参数
    local argunmentType=0;-- [1:state当前状态参数,2:lastState当前状态弹出参数]
    local count=select('#', ...);
    --print("\tcount:"..count);
    for i = 1, count do
        local arg = select(i, ...); -- 如果selector为数字n,那么select返回它的第n个可变实参
        --print("\t\t:"..arg);
        if(arg=="state")then
            argunmentType=1;
            self._arguments.stateArgument[vStart]={};
        elseif(arg=="lastState")then
            argunmentType=2;
            self._arguments.lastStateArgument[vEnd]={};
        else
            if(argunmentType==1)then
                table.insert(self._arguments.stateArgument[vStart],arg);
            elseif(argunmentType==2)then
                table.insert(self._arguments.lastStateArgument[vEnd],arg);
            end
        end
    end

    --print("statr----------stateArgument------");
    --local arr =self._arguments.stateArgument;
    --for i in pairs(arr) do
    --    print('\t'..i);
    --    for j in pairs(arr[i]) do
    --        print("\t\t" .. arr[i][j]);
    --    end
    --end
    --
    --print("statr----------lastStateArgument------");
    --local arr =self._arguments.lastStateArgument;
    --for i in pairs(arr) do
    --    print('\t'..i);
    --    for j in pairs(arr[i]) do
    --        print("\t\t" .. arr[i][j]);
    --    end
    --end

end




function State:getTableKey(vObject,vKey)
    if(vObject==nil)then
        return nil;
    end
    for i in pairs(vObject) do
        if(i ==vKey)then
            return vObject[i];
        end
    end
    return nil;
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
function State:getArguments (...)
    local vStr = "";
    local vArray = {};
    for i = 1, select('#', ...) do
        local arg = select(i, ...); -- 如果selector为数字n,那么select返回它的第n个可变实参
        local vType = type(arg);
        local vcType = '';
        if (vType == 'number') then
            vcType = "%d";
        elseif (vType == 'string' or vType == 'function') then
            vcType = "%s";
        end
        vStr = string.format("%s" .. vcType, vStr, arg);
        vArray[i] = arg;
    end
    return vStr, vArray;
end








return State;











