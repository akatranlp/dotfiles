return {
  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    'catppuccin/nvim',
    lazy = false,
    name = 'catppuccin',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    config = function()
      -- Load the colorscheme here.
      -- Like many other themes, this one has different styles, and you could load
      vim.cmd.colorscheme 'catppuccin'
      require('catppuccin').setup {
        transparent_background = vim.g.transparent_enabled,
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          treesitter = true,
          harpoon = true,
          mason = true,
        },
      }

      -- You can configure highlights by doing something like:
      vim.cmd.hi 'Comment gui=none'
    end,
  },
  'xiyaowong/transparent.nvim',
  lazy = false,
}
