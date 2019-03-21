
local Shape=require("example/class/Shape");

local Rectangle = class("Rectangle", Shape)

function Rectangle:ctor()
    Rectangle.super.ctor(self, "rectangle")
end

return Rectangle;
