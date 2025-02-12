return {
  -- LSP
  {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
    }
  },
  { 'saadparwaiz1/cmp_luasnip'},
  { 'L3MON4D3/LuaSnip'},
  { 'mfussenegger/nvim-jdtls' },

  -- Autopairing
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = true
  },

   -- Jumping between small set of files
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" }
  },
}
