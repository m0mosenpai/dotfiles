require("rose-pine").setup({
	disable_background = true,
	disable_italics = true,
})

function ColorConfig(color)
	-- color = color or "kanagawa-dragon"
	-- color = color or "vague"
	color = color or "rose-pine-moon"
	vim.cmd.colorscheme(color)

	-- Setting transparency
	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
end

ColorConfig()
