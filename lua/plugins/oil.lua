return {
  {
    "stevearc/oil.nvim",
    lazy = false, -- Handle `nvim .` without opening a permanent tree.
    keys = {
      { "-", "<cmd>Oil<cr>", desc = "Open Parent Directory (Oil)" },
    },
    opts = {
      default_file_explorer = true,
      columns = { "icon" },
      skip_confirm_for_simple_edits = false,
      keymaps = {
        ["<C-h>"] = false, -- Keep LazyVim window navigation.
        ["<C-l>"] = false,
        ["gR"] = "actions.refresh",
      },
    },
  },
}
