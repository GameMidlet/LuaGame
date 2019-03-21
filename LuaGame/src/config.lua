
--0 -禁用调试信息,少1 -调试信息,2 -详细的调试信息
-- 0 - disable debug info, 1 - less debug info, 2 - verbose debug info
DEBUG = 2

--使用框架,将禁用所有弃用API,错:使用遗留API
-- use framework, will disable all deprecated API, false - use legacy API
CC_USE_FRAMEWORK = true

-- show FPS on screen
CC_SHOW_FPS = false

-- disable create unexpected global variable
CC_DISABLE_GLOBAL = true
CC_ANIMATION_INTERVAL = 1.0/60

-- for module display
CC_DESIGN_RESOLUTION = {
    --Ipone SE width =1136.00, height =640
    width = 1280,
    height = 960,
    autoscale = "FIXED_HEIGHT",
    callback = function(framesize)
        local ratio = framesize.width / framesize.height
        if ratio <= 1.34 then
            -- iPad 768*1024(1536*2048) is 4:3 screen
            return {autoscale = "FIXED_WIDTH"}
        end
    end
}
