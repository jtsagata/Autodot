local function make_widget() 
    set_skip_tasklist(true)
    pin_window()
    set_skip_pager(true)
    set_window_below(true)
    stick_window()
    set_window_type("WINDOW_TYPE_DESKTOP")
end

local screen_w,screen_h = get_screen_size()
local t_width = 540
local t_height = 700 

if (get_window_class()=="rg.wezfurlong.wezweather") then
    make_widget()
    set_window_size(t_width, t_height)
    set_window_position2(screen_w - t_width - 10 , 10)
end


if (get_window_class()=="rg.wezfurlong.wezres") then
    make_widget()
    set_window_size(t_width, t_height)
    set_window_position2(screen_w - 2 * t_width - 20 , 10)
end



if (get_window_class()=="rg.wezfurlong.wezlog") then
    make_widget()
    local width = 2 * t_width + 10
    local height = screen_h -  t_height
    set_window_size(width, height)
    set_window_position2(screen_w - width - 10 , screen_h - height)
end

