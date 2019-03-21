
local MainScene = class("MainScene", cc.load("mvc").ViewBase)

function MainScene:onCreate()
    -- add background image
    display.newSprite("HelloWorld.png")
        :move(display.center)
        :addTo(self)

    -- add HelloWorld label
    cc.Label:createWithSystemFont("Hello World", "Arial", 40)
        :move(display.cx, display.cy + 200)
        :addTo(self)

    print("MainScene-------------");
    local director=cc.Director:getInstance();
    local size=director:getWinSize();
    print("dir:width:"..size.width);
    print("dir:height:"..size.height);

    print("display:width:"..display.width);
    print("display:height:"..display.height);

    print("display:cx:"..display.cx.."\t cy:"..display.cy);
end

return MainScene
