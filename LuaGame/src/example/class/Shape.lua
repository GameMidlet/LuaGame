
--定义名为 Shape 的基础类
local Shape = class("Shape")

--ctor() 是类的构造函数，在调用 Shape.new() 创建 Shape 对象实例时会自动执行
function Shape:ctor(shapeName)
    self.shapeName = shapeName;
    printf("Shape:ctor(%s)", self.shapeName)
end

--shapeName是类的一个成员变量，在lua中成员变量可以直接通过self.shapeName=shapeName来生成并同时赋值，不用先声明，另外，前面不用local修饰，用local修饰的是局部变量而不是成员变量，成员变量前面用self.

--为 Shape 定义个名为 draw() 的方法
function Shape:draw()
    printf("draw %s", self.shapeName)
end

return Shape;


