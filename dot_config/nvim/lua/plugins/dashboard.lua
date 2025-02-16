return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = { enabled = true },
    dashboard = {
      preset = {
          header = [[








          ]],
      },
      enable = true,
      formats = {
        key = function(item)
          return { { "[", hl = "special" }, { item.key, hl = "key" }, { "]", hl = "special" } }
        end,
        header = { "%s", align = "center" },
      },
      sections = {
        -- Header spanning the full width (centered via indent)
        { section = "header", indent = 60 },

        -- LEFT PANE: keys and startup (no pane specified = left column)
        {
          { section = "keys", gap = 1, padding = 3 },
          { section = "startup", indent = 60, padding = 5 },
        },
        {
          pane = 2,
          section = "terminal",
          cmd = string.format('figlet -f "%s/assets/smmono12.flf" -ct -k "Hi $USER"', vim.fn.stdpath('config')),
          height = 9,
          padding = 3,
          indent = -60,
      },
        -- RIGHT PANE (pane = 2): Git status, recent files and projects
        {
          pane = 2,
          -- Git Status section
          {
            icon = " ",
            title = "Git Status",
            section = "terminal",
            enabled = function()
              return Snacks.git.get_root() ~= nil
            end,
            cmd = "git status --short --branch --renames",
            height = 5,
            padding = 1,
            ttl = 5 * 60,
            indent = -60,
          },
          -- Recent Files group
          {
            icon = " ",
            title = "Recent Files",
            padding = 1,
          },
          {
            section = "recent_files",
            opts = { limit = 3 },
            indent = 2,
            padding = 1,
          },
          -- Projects group
          {
            icon = " ",
            title = "Projects",
            padding = 1,
          },
          {
            section = "projects",
            opts = { limit = 3 },
            indent = 2,
            padding = 1,
          },
        },
      },
    },
    indent = { enabled = true },
    input = { enabled = true },
    rename = { enabled = true },
    notifier = {
      enabled = true,
      style = "fancy",
    },
    notify = { enabled = true },
    dim = { enabled = true },
    quickfile = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
  },

  keys = {
    {
      "<leader>nn",
      function()
        Snacks.notifier.show_history()
      end,
      desc = "Notification History",
    },
    {
      "<leader>gB",
      function()
        Snacks.gitbrowse()
      end,
      desc = "Git Browse",
      mode = { "n", "v" },
    },
    {
      "<leader>gb",
      function()
        Snacks.git.blame_line()
      end,
      desc = "Git Blame Line",
    },
    {
      "<leader>gf",
      function()
        Snacks.lazygit.log_file()
      end,
      desc = "Lazygit Current File History",
    },
    {
      "<leader>gg",
      function()
        Snacks.lazygit()
      end,
      desc = "Lazygit",
    },
    {
      "<leader>gl",
      function()
        Snacks.lazygit.log()
      end,
      desc = "Lazygit Log (cwd)",
    },
    {
      "<leader>rf",
      function()
        Snacks.rename.rename_file()
      end,
      desc = "Rename File",
    },
  },
}
