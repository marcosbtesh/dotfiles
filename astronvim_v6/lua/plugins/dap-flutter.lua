return {
  {
    "nvim-flutter/flutter-tools.nvim",
    ft = "dart",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim",
      "mfussenegger/nvim-dap",
    },
    opts = {
      flutter_path = vim.fn.expand "$HOME/_dev/flutter/bin/flutter",
      debugger = {
        enabled = true,
        run_via_dap = true,
        register_configurations = function(_)
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
    },
  },
  { "stevearc/dressing.nvim", opts = {} },
}
