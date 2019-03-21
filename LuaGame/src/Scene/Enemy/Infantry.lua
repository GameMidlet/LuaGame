
local Enemy=require("Scene/Enemy/Enemy");

---Infantry object
---@Class Infantry : Enemy
local Infantry=class("Infantry",Enemy);

function Infantry:ctor()
    self.super:ctor();
    Log.debug('Infantry.ctor-------');

    local vsu=cc.Sprite:create("cocosui/slidbar.png");
    vsu:setPosition(0,50);
    self:addChild(vsu);

end


return Infantry;