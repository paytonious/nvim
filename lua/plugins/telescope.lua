return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      -- Configure telescope with vertical layout
      require("telescope").setup({
        defaults = {
          layout_strategy = "vertical",
          layout_config = {
            vertical = {
              prompt_position = "top",
              width = 0.8,
              height = 0.9,
              preview_height = 0.6,
            }
          },
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
      })
      
      local builtin = require("telescope.builtin")
      
      -- Existing keymaps
      vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
      
      -- Buffer navigation keymaps
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { silent = true, desc = 'Find buffers' })
      vim.keymap.set('n', '<C-p>', builtin.buffers, { silent = true, desc = 'Find buffers' })
      
      -- Optional: Enhanced buffer picker with sorting
      vim.keymap.set('n', '<leader>bb', function()
        builtin.buffers({
          sort_mru = true,
          ignore_current_buffer = true,
        })
      end, { silent = true, desc = 'Find buffers (sorted by recent)' })
    end,
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    config = function()
      require("telescope").load_extension("ui-select")
    end,
  },
}
