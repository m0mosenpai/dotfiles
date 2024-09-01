local builtin = require('telescope.builtin')

-- Description: All files search ("Project Files")
-- Function: Remap '<space>ff' -> '<space>pf'
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})

-- Description: Git files search
-- Function: 'C+p'
vim.keymap.set('n', '<C-p>', builtin.git_files, {})

-- Description: Project Search
-- Function: '<space>ps'
vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)
