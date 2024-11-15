-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Fuzzy finder
  use {
	  'nvim-telescope/telescope.nvim', tag = '0.1.8',
	  -- or                            , branch = '0.1.x',
	  requires = { {'nvim-lua/plenary.nvim'} }
    }

  -- Themes
  use "rebelot/kanagawa.nvim"
  use "rose-pine/neovim"

  -- Synax Highlighting and Navigating
  use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }
  use ('nvim-treesitter/playground')

  -- Undo Tree Visualizer
  use 'mbbill/undotree'

  -- Git Wrapper
  use 'tpope/vim-fugitive'

  -- LSP
  use({'neovim/nvim-lspconfig'})
  use({'williamboman/mason.nvim'})
  use({'williamboman/mason-lspconfig'})
  use({'hrsh7th/nvim-cmp'})
  use({'hrsh7th/cmp-nvim-lsp'})
  use({'hrsh7th/cmp-buffer'})
  use({'saadparwaiz1/cmp_luasnip'})
  use({'L3MON4D3/LuaSnip'})

  -- Autopairing
  use {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("nvim-autopairs").setup {}
        end
    }

   -- Jumping between small set of files
   use "nvim-lua/plenary.nvim"
   use {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        requires = { {"nvim-lua/plenary.nvim"} }
    }

end)
