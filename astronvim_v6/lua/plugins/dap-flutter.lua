return {
  -- Configure flutter-tools, letting the community pack handle LSP.
  -- Debugger adapter is registered directly on nvim-dap below.
  {
    "akinsho/flutter-tools.nvim",
    ft = "dart",
    dependencies = { "nvim-lua/plenary.nvim", "stevearc/dressing.nvim" },
    opts = function(_, opts)
      opts.flutter_path = vim.fn.expand "$HOME/_dev/flutter/bin/flutter"
      opts.debugger = { enabled = true, run_via_dap = true }
    end,
  },
  -- Register dart adapter directly on nvim-dap (community dart pack does not
  -- do this — it relies on mason-nvim-dap which maps to dart-debug-adapter,
  -- a binary that only supports "web" and exits with code 1 for Flutter).
  {
    "mfussenegger/nvim-dap",
    optional = true,
    config = function()
      local dap = require "dap"
      dap.adapters.dart = {
        type = "executable",
        command = vim.fn.expand "$HOME/_dev/flutter/bin/flutter",
        args = { "debug_adapter" },
      }
      dap.configurations.dart = {
        {
          type = "dart",
          request = "launch",
          name = "Launch Flutter",
          dartSdkPath = vim.fn.expand "$HOME/_dev/flutter/bin/cache/dart-sdk",
          flutterSdkPath = vim.fn.expand "$HOME/_dev/flutter",
          program = "${workspaceFolder}/lib/main.dart",
          cwd = "${workspaceFolder}",
        },
      }
    end,
  },
  -- Prevent mason-nvim-dap from overriding the dart adapter with dart-debug-adapter.
  {
    "jay-babu/mason-nvim-dap.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = vim.tbl_filter(function(v) return v ~= "dart" end, opts.ensure_installed or {})
      opts.handlers = opts.handlers or {}
      opts.handlers.dart = function() end
    end,
  },
  { "stevearc/dressing.nvim", opts = {} },
}
