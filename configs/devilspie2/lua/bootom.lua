if (get_window_class()=="rg.wezfurlong.wezres") then
    set_skip_tasklist(true)
    pin_window()
    set_skip_pager(true)
    set_window_below(true)
    stick_window()
    set_window_type("WINDOW_TYPE_DESKTOP")
    x, y, width, height = get_window_geometry();
    screen_w,screen_h = get_screen_size()
    set_window_position2(screen_w - width -560 , 10)
end