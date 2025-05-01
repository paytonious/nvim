return {
  "akinsho/flutter-tools.nvim",
  lazy = true,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "stevearc/dressing.nvim",
    "mfussenegger/nvim-dap",  -- Debugger core
    "rcarriga/nvim-dap-ui",   -- Debugger UI
  },
  config = function()
    -- Keymaps
    vim.keymap.set("n", "<leader>FS", ":FlutterRun<CR>", { desc = "Flutter Run" })
    vim.keymap.set("n", "<leader>FQ", ":FlutterQuit<CR>", { desc = "Flutter Quit" })
    vim.keymap.set("n", "<leader>FR", ":FlutterRestart<CR>", { desc = "Flutter Restart" })
    vim.keymap.set("n", "<leader>LR", ":FlutterLspRestart<CR>", { desc = "Flutter LSP Restart" })
    vim.keymap.set("n", "<leader>FT", ":FlutterDevTools<CR>", { desc = "Flutter DevTools" })
    vim.keymap.set("n", "<leader>FD", ":FlutterDebugLaunch<CR>", { desc = "Launch Flutter DAP" })

    -- Flutter Tools Setup
    require("flutter-tools").setup({
      decorations = {
        statusline = {
          app_version = true,
          device = true,
        },
      },
      dev_tools = {
        autostart = true,
        auto_open_browser = true,
      },
      debugger = {
        enabled = true,
        run_via_dap = true, -- Use DAP instead of terminal
      },
      lsp = {
        color = { enabled = true },
      },
    })

    -- DAP UI Setup
    local dap = require("dap")
    local dapui = require("dapui")

    dapui.setup()

    -- Auto open/close UI
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end
  end,
}

