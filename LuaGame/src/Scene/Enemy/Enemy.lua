
---Enemy object
---@Class Enemy : Sprite
local Enemy=class("Enemy",function ()
    return cc.Sprite:create();
end);

function Enemy:ctor()
    Log.debug('enemy.ctor-------');
    self.STATE_TYPE={
        DEFAULT=0,--默认
        MOVE=1,--移动
        INJURED=2,--受伤
        AWAIT=3,--等待
        SUCCEED=4,--成功
        DIE=5,--死亡

        toString={
             "默认",
             "移动",
             "受伤",
             "等待",
             "成功",
             "死亡"
        }
    };

    self.state=self.STATE_TYPE.DEFAULT;--敌人状态

    self.moveTable={};--敌人移动的节点
    self.moveOffCount=2;--敌人移动的节点数

    self.schedulerEntry = nil;--定时器句柄

end

function Enemy:setMoveCount(vTable)
    self.moveTable=vTable;
    local scheduler = cc.Director:getInstance():getScheduler();

    self.schedulerEntry = scheduler:scheduleScriptFunc(function()
            self:update();
    end, 0.1, false);

    self.state=self.STATE_TYPE.MOVE;
    self:runMove();
end

function Enemy:runMove()
    local count=#self.moveTable;
    if(self.moveOffCount<=count)then
        local move= cc.MoveTo:create(1,self.moveTable[self.moveOffCount]);
        local function renewCallBack()
            Log.debug('移动回调函数');
            self.moveOffCount=self.moveOffCount+1;
            self.state=self.STATE_TYPE.AWAIT;--等待
        end
        local call= cc.CallFunc:create(renewCallBack);
        local sequ=cc.Sequence:create(move,call);
        self:runAction(sequ);
    else
        self.state=self.STATE_TYPE.SUCCEED;---成功
        self:destroy();
    end
end

function Enemy:update()
    Log.debug('监听器走 '..self.state);
    if(self.state == self.STATE_TYPE.AWAIT) then
        self.state=self.STATE_TYPE.MOVE;
        self:runMove();
    end
end


function Enemy:toString()
    Log.debug('敌人类');
end

function Enemy:destroy()
    --销毁监听器
    local scheduler = cc.Director:getInstance():getScheduler();
    scheduler:unscheduleScriptEntry(self.schedulerEntry);
    self.schedulerEntry = nil
end





return Enemy;


