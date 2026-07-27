local gh = require("util").gh

vim.pack.add({ gh("stevearc/conform.nvim") })
require("conform").setup({
	notify_on_error = false,
	default_format_opts = {
		lsp_format = "fallback",
	},
	format_on_save = {
		lsp_format = "fallback",
		timeout_ms = 500,
	},
	formatters_by_ft = {
		javascript = { "prettier" },
		typescript = { "prettier" },
		javascriptreact = { "prettier" },
		typescriptreact = { "prettier" },
		css = { "prettier" },
		html = { "prettier" },
		json = { "prettier" },
		yaml = { "prettier" },
		markdown = { "prettier" },
		graphql = { "prettier" },
		lua = { "stylua" },
		astro = { "prettierd", "prettier" },
		c = { "clang_format" },
		go = { "gofmt" },
		python = { "black" },
		sh = { "beautysh", "shfmt" },
		sql = { "sqlfmt" },
	},
})

vim.keymap.set({ "n", "v" }, "<leader>f", function()
	require("conform").format({ async = true })
end, { desc = "[F]ormat buffer" })
