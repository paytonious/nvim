return {
  {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      require("bufferline").setup({
        options = {
          numbers = "none",
          close_command = "bdelete! %d",
          right_mouse_command = "bdelete! %d",
          left_mouse_command = "buffer %d",
          middle_mouse_command = nil,
          indicator = {
            icon = '▎',
            style = 'icon',
          },
          buffer_close_icon = '',
          modified_icon = '●',
          close_icon = '',
          left_trunc_marker = '',
          right_trunc_marker = '',
          diagnostics = "nvim_lsp",
          show_buffer_close_icons = true,
          show_close_icon = true,
          show_tab_indicators = true,
          persist_buffer_sort = true,
          separator_style = "thin",
          -- Only show bufferline when you have more than one buffer
          always_show_bufferline = false,
        }
      })
     
      -- Bufferline navigation keymaps
      vim.keymap.set('n', '<Tab>', '<Cmd>BufferLineCycleNext<CR>', { silent = true, desc = 'Next buffer' })
      vim.keymap.set('n', '<S-Tab>', '<Cmd>BufferLineCyclePrev<CR>', { silent = true, desc = 'Previous buffer' })
      vim.keymap.set('n', '<leader>bd', '<Cmd>bdelete<CR>', { silent = true, desc = 'Delete buffer' })
      vim.keymap.set('n', '<leader>bD', '<Cmd>BufferLinePickClose<CR>', { silent = true, desc = 'Pick buffer to close' })
     
      -- Optional: Go to specific buffer by number
      for i = 1, 9 do
        vim.keymap.set('n', '<leader>' .. i, '<Cmd>BufferLineGoToBuffer ' .. i .. '<CR>', 
          { silent = true, desc = 'Go to buffer ' .. i })
      end
    end,
  },
  {
    'moll/vim-bbye',
    config = function()
      -- Better buffer deletion that preserves window layout
      vim.keymap.set('n', '<leader>bd', '<Cmd>Bdelete<CR>', { silent = true, desc = 'Delete buffer (keep layout)' })
    end,
  },
}
