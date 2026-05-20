require('nvim-treesitter').install({
    'python', 'javascript', 'typescript', 'c', 'cpp', 'lua', 'go',
    'vim', 'vimdoc', 'query', 'markdown', 'markdown_inline'
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = '*',
    callback = function(args)
        if args.match ~= 'latex' then
            pcall(vim.treesitter.start)
        end
    end,
})
