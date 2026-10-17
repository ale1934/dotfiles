return {
  { import = "lazyvim.plugins.extras.lang.typst" },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tinymist = {
          mason = false,
        },
      },
    },
  },
}
