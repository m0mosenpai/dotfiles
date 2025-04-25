return {
  -- Fuzzy finder
  {
      'nvim-telescope/telescope.nvim', version = '0.1.8',
      dependencies = { {'nvim-lua/plenary.nvim'} }
  },

  -- Synax Highlighting and Navigating
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate'
  },

  -- Undo Tree Visualizer
  { 'mbbill/undotree' },

  -- Git Wrapper
  { 'tpope/vim-fugitive' },

  -- LaTeX
  {
    "lervag/vimtex",
    lazy = false,
    init = function()
    vim.g.vimtex_view_method = "zathura"
    end
  }
}
