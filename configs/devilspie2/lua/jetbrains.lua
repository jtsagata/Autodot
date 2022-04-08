if (get_window_name()=="JetBrains Toolbox") then
    toolbox_window_xid = get_window_xid
    debug_print( "Handling JetBrains Toolbox")
    set_skip_tasklist(true)
    set_window_position2(1920+1920+2560-window_w,0)
end