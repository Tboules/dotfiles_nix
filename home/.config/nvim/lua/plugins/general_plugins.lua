local gh = require("util").gh

-- vim-herdr-navigation drives <C-hjkl> instead; avoid double-mapping.
vim.g.tmux_navigator_no_mappings = 1

vim.pack.add({
	gh("christoomey/vim-tmux-navigator"),
	gh("paulbkim-dev/vim-herdr-navigation"),
	gh("JoosepAlviste/nvim-ts-context-commentstring"),
	-- gh("lukas-reineke/indent-blankline.nvim"),
	gh("EdenEast/nightfox.nvim"),
	gh("windwp/nvim-autopairs"),
})

-- Seamless Ctrl+h/j/k/l navigation across herdr panes and Vim splits.
dofile(vim.fn.stdpath("data") .. "/site/pack/core/opt/vim-herdr-navigation/editor/nvim.lua")

--THEME
require("nightfox").setup({
	options = {
		transparent = true,
	},
})
vim.cmd.colorscheme("nightfox")
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })

-- Indent Blank Line
-- require("ibl").setup()

-- Autopairs
require("nvim-autopairs").setup()
