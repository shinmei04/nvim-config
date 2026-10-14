return {
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = { enabled = false },
      explorer = { replace_netrw = false }, -- Oil handles directory buffers.
      image = {
        enabled = true,
        doc = { enabled = false }, -- Use image viewing without changing document rendering.
      },
      terminal = {
        win = {
          -- Shells use Snacks' bottom split; command UIs such as lazygit stay floating.
          height = function(win)
            return win.opts.position == "bottom" and 0.30 or 0.90
          end,
        },
      },
    },
    keys = {
      {
        "<F7>",
        function()
          Snacks.terminal(nil, { cwd = LazyVim.root() })
        end,
        mode = { "n", "t" },
        desc = "Toggle Terminal (Root Dir)",
      },
    },
  },
}
