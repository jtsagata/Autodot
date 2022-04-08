local wezterm = require 'wezterm';

return {
  font_size=7,
  bold_brightens_ansi_colors = true,
  enable_tab_bar = false,
  enable_scroll_bar = false,
  initial_cols = 130,
  initial_rows = 52,
  window_decorations = "NONE",
  default_cursor_style="SteadyUnderline",
  window_background_opacity = 0.1,
  keys = {
    {key="c", mods="CTRL", action="Nop"},
  },
  colors = {
    cursor_bg = "black",
    cursor_fg = "black",
    cursor_border = "black",
  }
}