vim.g.vimtex_syntax_enabled = 1

-- viewer method:
vim.g.vimtex_view_method = 'zathura'
vim.g.vimtex_quickfix_mode = 0

-- Or with a generic interface:
vim.g.vimtex_view_general_viewer = 'okular'
vim.g.vimtex_view_general_options = '--unique file:@pdf#src:@line@tex'
