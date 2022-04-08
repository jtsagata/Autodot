local wezterm = require 'wezterm';

return {
  font_size=10,
  bold_brightens_ansi_colors = true,
  enable_tab_bar = false,
  enable_scroll_bar = false,
  initial_cols = 120,
  initial_rows = 20,
  window_decorations = "NONE",
  window_background_opacity = 0.1,
  keys = {
    {key="c", mods="CTRL", action="Nop"},
  }
}