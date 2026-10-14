return {
  {
    "iamcco/markdown-preview.nvim",
    keys = {
      {
        "<leader>bm",
        "<cmd>MarkdownPreviewToggle<cr>",
        ft = "markdown",
        desc = "Markdown Preview (Browser)",
      },
    },
  },
  {
    "mason-org/mason.nvim",
    -- The Markdown Extra already configures prettier as its formatter.
    opts = { ensure_installed = { "prettier" } },
  },
  {
    "HakonHarnes/img-clip.nvim",
    ft = "markdown",
    cmd = { "PasteImage", "ImgClipDebug", "ImgClipConfig" },
    opts = {
      default = {
        dir_path = "assets",
        relative_to_current_file = true,
        use_absolute_path = false,
      },
    },
    keys = {
      {
        "<leader>ip",
        "<cmd>PasteImage<cr>",
        ft = "markdown",
        desc = "Paste Image from Clipboard",
      },
    },
  },
}
