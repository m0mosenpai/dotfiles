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

  -- GitHub Copilot
  {
    "zbirenbaum/copilot.lua",
    dependencies = {
      "copilotlsp-nvim/copilot-lsp",
    },
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
          keymap = {
            accept = "<M-y>",
            accept_word = "<C-l>",
            accept_line = "<M-l>",
            next = "<M-n>",
            prev = "<M-p>",
            dismiss = "<C-]>",
          },
        },
        panel = {
          enabled = true,
          auto_refresh = true,
          keymap = {
            open = "<M-CR>",
          },
        },
      })
    end,
  },

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
