local gh = require("util").gh

vim.pack.add({
	gh("christoomey/vim-tmux-navigator"),
	gh("JoosepAlviste/nvim-ts-context-commentstring"),
	-- gh("lukas-reineke/indent-blankline.nvim"),
	gh("EdenEast/nightfox.nvim"),
	gh("windwp/nvim-autopairs"),
})

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
