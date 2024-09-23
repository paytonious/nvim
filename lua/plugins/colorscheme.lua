-- catppuccin colorscheme
--return {
--  {
--    "catppuccin/nvim",
--    name = "catppuccin",
--    priority = 1000,
--    config = function()
--      vim.cmd.colorscheme "catppuccin"
--    end
--  },
--}

-- bluloco dark
return {
  'uloco/bluloco.nvim',
  name = "bluloco",
  lazy = false,
  priority = 1000,
  dependencies = { 'rktjmp/lush.nvim' },
  config = function()
    vim.cmd.colorscheme "bluloco"
    -- your optional config goes here, see below.
  end,
}

-- kanagawa colorscheme
--return {
--  "rebelot/kanagawa.nvim",
--  name = "kanagawa",
--  config = function()
--    vim.cmd.colorscheme "kanagawa"
--  end
--}
