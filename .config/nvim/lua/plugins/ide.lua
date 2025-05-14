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
  },

  -- Markdown
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.cmd [[Lazy load markdown-preview.nvim]]
      vim.fn["mkdp#util#install"]()
    end,
    config = function()
      vim.cmd([[do FileType]])
      vim.cmd([[
        function OpenMarkdownPreview (url)
          let cmd = "firefox --new-window " . shellescape(a:url) . " &"
          silent call system(cmd)
        endfunction
      ]])
      vim.g.mkdp_browserfunc = "OpenMarkdownPreview"
   end,
  },
}

