return {
  "akinsho/flutter-tools.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "stevearc/dressing.nvim",
    "mfussenegger/nvim-dap",  -- Debugger core
    "rcarriga/nvim-dap-ui",   -- Debugger UI
    "jay-babu/mason-nvim-dap.nvim",
    "nvim-neotest/nvim-nio",
  },
  config = function()
    -- Keymaps
    vim.keymap.set("n", "<leader>FS", ":FlutterRun<CR>", { desc = "Flutter Run" })
    vim.keymap.set("n", "<leader>FQ", ":FlutterQuit<CR>", { desc = "Flutter Quit" })
    vim.keymap.set("n", "<leader>FR", ":FlutterRestart<CR>", { desc = "Flutter Restart" })
    vim.keymap.set("n", "<leader>LR", ":FlutterLspRestart<CR>", { desc = "Flutter LSP Restart" })
    vim.keymap.set("n", "<leader>FT", ":FlutterDevTools<CR>", { desc = "Flutter DevTools" })
    vim.keymap.set("n", "<leader>FD", ":FlutterDebugLaunch<CR>", { desc = "Launch Flutter DAP" })
    
    -- Fixed diagnostic keymaps with different keys to avoid conflicts
    vim.keymap.set("n", "<leader>le", function()
      local bufnr, winnr = vim.diagnostic.open_float(nil, { 
        focusable = true,
        scope = "cursor",
        source = true,
        border = "rounded",
      })
      
      -- If a window was created, set up keybinding for ESC to close it
      if winnr then
        -- Create autocommand to close the window with ESC
        vim.api.nvim_create_autocmd("BufEnter", {
          buffer = bufnr,
          once = true,
          callback = function()
            vim.api.nvim_buf_set_keymap(bufnr, "n", "<Esc>", ":close<CR>", {silent = true, noremap = true})
            vim.api.nvim_buf_set_keymap(bufnr, "n", "q", ":close<CR>", {silent = true, noremap = true})
          end
        })
      end
      
      return true
    end, { desc = "Show diagnostic error under cursor" })
    
    -- Changed from <leader>ld to <leader>la to avoid conflicts
    vim.keymap.set("n", "<leader>la", function()
      local diagnostics = vim.diagnostic.get(0) -- 0 = current buffer
      if vim.tbl_isempty(diagnostics) then
        print("No diagnostics in current buffer.")
        return
      end
     
      -- Use vim.diagnostic.open_float but with format option to display line numbers
      local bufnr, winnr = vim.diagnostic.open_float(0, {
        scope = "buffer",
        focusable = true,
        border = "rounded",
        header = "All Diagnostics in Buffer",
        prefix = function(diag, i, total)
          -- Add line number prefix to each diagnostic
          local line = diag.lnum + 1 -- Convert to 1-based line numbering
          return string.format("Line %d: ", line)
        end,
        format = function(diagnostic)
          -- Just return the message - prefix will add the line number
          return diagnostic.message
        end,
        severity_sort = true
      })
     
      -- If a window was created, set up keybinding for ESC to close it
      if winnr then
        -- Create autocommand to close the window with ESC
        vim.api.nvim_create_autocmd("BufEnter", {
          buffer = bufnr,
          once = true,
          callback = function()
            vim.api.nvim_buf_set_keymap(bufnr, "n", "<Esc>", ":close<CR>", {silent = true, noremap = true})
            vim.api.nvim_buf_set_keymap(bufnr, "n", "q", ":close<CR>", {silent = true, noremap = true})
          end
        })
      end
    end, { desc = "List all diagnostics with line numbers" })

    -- Alternative keymap that might work better
    vim.keymap.set("n", "<leader>dl", function()
      vim.diagnostic.setloclist()
    end, { desc = "Send diagnostics to location list" })

    -- Add debug device selection keybind
    vim.keymap.set("n", "<leader>FW", ":FlutterDevices<CR>", { desc = "Select Flutter Device" })

    -- Set up DAP FIRST before flutter-tools
    local dap = require("dap")
    local dapui = require("dapui")

    -- DAP UI Setup with more information displayed
    dapui.setup({
      icons = { expanded = "▾", collapsed = "▸", current_frame = "→" },
      controls = {
        icons = {
          pause = "⏸",
          play = "▶",
          step_into = "⏎",
          step_over = "⏭",
          step_out = "⏮",
          step_back = "b",
          run_last = "▶▶",
          terminate = "⏹",
          disconnect = "⏏",
        },
      },
    })

    -- Add a delay before closing UI to see errors
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    
    -- Add a delay before closing to see error messages
    dap.listeners.before.event_terminated["dapui_config"] = function()
      vim.defer_fn(function() dapui.close() end, 1000) -- 1000ms delay
    end
    
    dap.listeners.before.event_exited["dapui_config"] = function()
      vim.defer_fn(function() dapui.close() end, 1000) -- 1000ms delay
    end

    -- Debug logging for dap
    dap.set_log_level('TRACE')

    -- Set up Dart adapter - modified to be more robust
    dap.adapters.dart = {
      type = "executable",
      command = "fvm",
      args = { "flutter", "debug_adapter" },
      options = {
        detached = false,  -- Keep process attached
      }
    }

    -- Get the project root directory
    local project_root = vim.fn.getcwd()
    
    -- Print the current directory for debugging
    print("Current working directory: " .. project_root)
    
    -- Helper function to list available devices
    local function list_flutter_devices()
      local Job = require("plenary.job")
      Job:new({
        command = "fvm",
        args = { "flutter", "devices" },
        on_exit = function(_, return_val)
          if return_val == 0 then
            print("Device listing complete. Check output above.")
          else
            print("Failed to list devices.")
          end
        end,
      }):start()
    end
    
    -- Auto-list devices on load for debugging
    vim.defer_fn(list_flutter_devices, 500)
    
    -- Modified configurations with better device handling
    dap.configurations.dart = {
      {
        name = "Clinical App Dev2 Mobile",
        type = "dart",
        request = "launch",
        flutterMode = "debug",
        cwd = project_root,
        program = "lib/app/targets/main_mobile_app.dart",
        -- Add device selection
        deviceId = "${command:flutter.listDevices}",
        toolArgs = {
          "--dart-define-from-file",
          ".env/dev2.json",
          "--dart-define",
          "BUILD_VERSION=1.0.0",
          "--dart-define",
          "BUILD_NUMBER=1",
          "--flavor",
          "development"
        }
      },
      -- Add a few more common configurations
      {
        name = "Clinical App Development Mobile",
        type = "dart",
        request = "launch",
        flutterMode = "debug",
        cwd = project_root .. "/apps/field-app",
        program = "lib/app/targets/main_mobile_app.dart",
        deviceId = "${command:flutter.listDevices}",
        toolArgs = {
          "--dart-define-from-file",
          ".env/development.json",
          "--dart-define",
          "BUILD_VERSION=1.0.0",
          "--dart-define",
          "BUILD_NUMBER=1",
          "--flavor",
          "development"
        }
      },
      {
        name = "CareHub Dev2",
        type = "dart",
        request = "launch",
        flutterMode = "debug",
        cwd = project_root .. "/apps/web-portal",
        program = "lib/app/targets/main_web_app.dart",
        deviceId = "chrome", -- Directly specify browser
        toolArgs = {
          "--dart-define-from-file",
          ".env/dev2.json",
          "--dart-define",
          "BUILD_VERSION=1.0.0",
          "--dart-define",
          "BUILD_NUMBER=1",
          "--web-port", 
          "61234",
          "--web-browser-flag",
          "--disable-web-security"
        }
      },
      -- Add a general debug with device picker
      {
        name = "Flutter: Attach to Device",
        type = "dart",
        request = "attach",
        deviceId = "${command:flutter.listDevices}",
      }
    }

    -- Try to load launch.json (this will merge with our manual configurations)
    local function try_load_launch_json()
      local vscode = require("dap.ext.vscode")
      
      -- Helper function to safely load launch.json from a path
      local function safe_load(path)
        local ok, _ = pcall(vscode.load_launchjs, path, { dart = { "dart" } })
        if ok then
          print("Loaded launch.json from: " .. path)
        end
        return ok
      end
      
      -- Try loading from different possible locations
      local cwd = vim.fn.getcwd()
      local possible_paths = {
        cwd .. "/.vscode/launch.json",
        cwd .. "/apps/field-app/.vscode/launch.json",
        cwd .. "/apps/web-portal/.vscode/launch.json"
      }
      
      for _, path in ipairs(possible_paths) do
        if vim.fn.filereadable(path) == 1 then
          safe_load(path)
          return true
        end
      end
      
      return false
    end
    
    try_load_launch_json()

    -- Flutter Tools Setup - AFTER setting up DAP
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
        run_via_dap = true,
        exception_breakpoints = {}, -- Empty but defined to avoid nil errors
        register_configurations = function(_)
          -- Let our manual config take precedence
          return true
        end,
      },
      lsp = {
        color = { enabled = true },
        settings = {
          showTodos = true,
          completeFunctionCalls = true,
          analysisExcludedFolders = {
            vim.fn.expand("$HOME/.pub-cache"),
            vim.fn.expand("$HOME/fvm"),
          },
        },
      },
      fvm = true, -- Explicitly enable FVM support
      device_picker = "integrated", -- Use integrated device picker
    })

    -- Add a command to reload configurations if needed
    vim.api.nvim_create_user_command("FlutterReloadConfigs", function()
      try_load_launch_json()
      print("Flutter debug configurations reloaded")
    end, {})
    
    -- Add a command to list available devices
    vim.api.nvim_create_user_command("FlutterDevices", function()
      list_flutter_devices()
    end, {})
    
    -- Add a command for troubleshooting
    vim.api.nvim_create_user_command("FlutterTroubleshoot", function()
      print("Checking Flutter installation...")
      local Job = require("plenary.job")
      Job:new({
        command = "fvm",
        args = { "flutter", "doctor", "-v" },
        on_exit = function(_, return_val)
          if return_val == 0 then
            print("Flutter doctor completed successfully")
          else
            print("Flutter doctor found issues")
          end
        end,
      }):start()
    end, {})
  end,
}
