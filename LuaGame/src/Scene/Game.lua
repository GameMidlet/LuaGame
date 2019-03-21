local Infantry=require("Scene/Enemy/Infantry");

---Game object
---@class Game
local Game=class("Game");

function Game:ctor()
    self:objectInit();
    self:create();
end


function Game:objectInit()
    ---@type Layer
    self.layer=cc.Layer:create();
    ---@type TMXTiledMap
    self.map=nil;

    ---@type Infantry
    self.enemy=nil;

    ---@type table
    self.enemyManage={
        position={};
        object={};
    };

    ---@type table
    self.enemyStartPositon=nil;--敌人位置
end


function Game:create()
    ---@type TMXTiledMap
    local vMap=ccexp.TMXTiledMap:create("map/map.tmx");
    self.map=vMap;
    self.layer:addChild(vMap);

    ---@type TMXObjectGroup
    local vObject=vMap:getObjectGroup("object");---对象层
    --local vObjectArray =vMap:getObjectGroups();
    --for i in vObjectArray do
    --    print("对象名字:"..i.name);
    --end
    --for k ,v in next,vObjectArray do print(k..":"..v);  end
    local heroInfo = vObject:getObject("fyt1");--获取子节点,返回节点信息
    --节点信息 id,type,name,width,height,x,y, 其中xy是左下角坐标
    -- for k ,v in next,heroInfo do print(k..":"..v);  end

    --local hero = cc.Sprite:create("cocosui/sliderballpressed.png");
    --hero:setPosition(heroInfo.x+heroInfo.width*0.5, heroInfo.y+heroInfo.height*0.5);
    --self.map:addChild(hero);

    local vEnemyPosition=vMap:getObjectGroup("enemy");---对象层
    local vTable=vEnemyPosition:getObjects(); --遍历所有的点
    for i in pairs(vTable) do
        local v=cc.p(vTable[i].x+vTable[i].width*0.5,vTable[i].y+vTable[i].height*0.5);
        Log.debug("name:"..vTable[i].name.." x:"..v.x.." y:"..v.y);
        table.insert(self.enemyManage.position,v);
    end

    --local count=#self.enemyManage.position;
    --Log.debug('count:'..count.."----------------");
    --for i=1 ,count do
    --    local vTemp=self.enemyManage.position[i];
    --    if(vTemp)then
    --        Log.debug("x:"..vTemp.x.." y:"..vTemp.y);
    --    end
    --end

    --for i=1,10 do
    --    self.enemyManage.position[i]=cc.p()
    --    ---@type table
    --    --self.enemyManage={
    --    --    position={};
    --    --    object={};
    --    --};
    --end

    --Log.debug('变量objects-----a-----')
    --local zzz=vObject:getObjects(); --遍历所有的点
    --for i in pairs(zzz) do print(zzz[i].name);end
    --for i in pairs(zzz) do
    --    print(zzz[i].name);
    --    local teb=zzz[i];
    --    for k,v in pairs(zzz[i]) do
    --        print("\t\t"..k..":"..v);
    --    end
    --end
    --
    --local enemyInfo = vObject:getObject("enemy");--获取子节点,返回节点信息
    --if(enemyInfo)then
    --    --self.enemy:setPosition(enemyInfo.x,enemyInfo.y);
    --    --self.enemyStartPositon=cc.p(enemyInfo.x,enemyInfo.y);
    --end



    local vButton=ccui.Button:create("cocosui/animationbuttonnormal.png", "cocosui/animationbuttonpressed.png");
    vButton:addClickEventListener(function (s,v)
        --print("按钮事件");
        --self.enemy=Infantry:create("cocosui/sliderballpressed.png");
        --if(self.enemy==nil)then
        --    Log.debug('敌人创建对象失败');
        --else
        --    Log.debug('敌人创建对象成功');
        --    self.map:addChild(self.enemy);
        --    local vMove= cc.MoveTo:create(0.2,cc.p(display.width*0.2,display.height*0.2));
        --    self.enemy:runAction(vMove);
        --end
        self:createEnemy();
    end);
    vButton:setPosition(cc.p(display.width*0.2,display.height*0.2));
    self.layer:addChild(vButton);




    -----@type TMXLayer
    --local vLayer=vMap:getLayer("zs");--地图层
    -----@type Sprite
    --local vSprite=vLayer:getTileAt(cc.p(0,1));--获取地图块(屏幕左上角位置起点)
    --local gid=31;--注意这个地方id有点问题,在Tiled中是0,2dx就是1,用的时候就+1就可以了
    --vLayer:setTileGID(gid, cc.p(4, 12));


    --local label = cc.Label:createWithSystemFont("Lobby","",32);
    ----local label = cc.Label:createWithTTF("hello world", "fonts/arial.ttf", 32);
    --self.layer:addChild(label, 1);
    --label:setAnchorPoint(cc.p(0.5, 0.5));
    --label:setPosition( cc.p(display.cx, display.cy) );
    --
    --local ball = cc.Sprite:create("HelloWorld.png");
    --self.layer:addChild(ball);
    --ball:setPosition(cc.p(display.cx,display.cy+200));
    --ball:setAnchorPoint(cc.p(0.5,0.5));
    --
    --
    --local itemLabel=cc.Label:createWithSystemFont("back","",40);
    --local bItem=cc.MenuItemLabel:create(itemLabel);
    --bItem:setPosition(40,display.height-32);
    --bItem:registerScriptTapHandler(self.loadGame);
    --local vMenu=cc.Menu:create(bItem);
    --vMenu:setPosition(cc.p(0,0))
    --self.layer:addChild(vMenu);
    --

    local button=ccui.Button:create("cocosui/animationbuttonnormal.png", "cocosui/animationbuttonpressed.png");
    button:addClickEventListener(function (s,v)
        --print("按钮事件");
        self:loadLabby();
    end);
    button:setPosition(display.width*0.8,display.height*0.9);
    self.layer:addChild(button);
end


function Game:createEnemy()
    --local vvv= cc.Sprite:create("cocosui/sliderballpressed.png")
    --vvv:setPosition(cc.p(200,400));
    --self.layer:addChild(vvv);
    --local spriteFrame= vvv:getSpriteFrame();

    self.enemy=Infantry:create();
    self.map:addChild(self.enemy);
    self.enemy:setPosition(cc.p(self.enemyManage.position[1].x, self.enemyManage.position[1].y));

    local vvv= cc.Sprite:create("cocosui/sliderballpressed.png")
    local spriteFrame= vvv:getSpriteFrame();
    self.enemy:setSpriteFrame(spriteFrame);

    self.enemy:setMoveCount(self.enemyManage.position);

    --local move1=cc.MoveTo:create(0.2,cc.p(0,0));
    --local move2=cc.MoveTo:create(0.2,cc.p(display.width,display.height));
    --local move3=cc.MoveTo:create(0.2,cc.p(display.cx,display.cy));
    --local vSequ=cc.Sequence:create(cc.DelayTime:create(0.2),move1,cc.DelayTime:create(0.2),move2,cc.DelayTime:create(0.2),move3);
    --self.enemy:runAction(vSequ);


    ----local cache = cc.Director:getInstance():getTextureCache():addImage("tree1.png")
    --local texture=cc.Director:getInstance():getTextureCache():addImage("cocosui/sliderballpressed.png");
    --if(texture)then
    --    --self.enemy:setTexture(texture);
    --    Log.debug('有这个问题了');
    --end

end


function Game:getLayer()
    return self.layer;
end

function Game:loadLabby(tag, sender)
    print("执行回调函数-Game---加载Lobby---------");
    local game=display.newScene("Labby");
    local Layer=require("Scene/Lobby");
    local layer=Layer.new();
    game:addChild(layer:getLayer());
    display.runScene(game);
end


function Game:actionFunciton()
    print("执行动画回调函数");
end

return Game;