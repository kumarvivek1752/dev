-- lua/custom/plugins/mini.lua
return {
  {
    enabled = false,
    'echasnovski/mini.nvim',
    config = function()
      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = true }
    end
  }
}
