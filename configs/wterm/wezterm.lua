local wezterm = require 'wezterm'

return {
  bold_brightens_ansi_colors = true,
  window_background_opacity = 0.6,
  default_cursor_style = "BlinkingUnderline",
  font_size = 10,
  force_reverse_video_cursor = true,
  font = wezterm.font({
    family="JetBrains Mono",
    harfbuzz_features={"calt=0", "clig=0", "liga=0"}
  }),
  window_background_gradient={
    orientation = "Vertical",
    colors = {
      "#367f8c", 
      "#235058",
      "#232e58"
    },
    blend = "Rgb",
  },
  text_background_opacity = 0.95,
}