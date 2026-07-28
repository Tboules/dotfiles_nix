local gh = require("util").gh

vim.pack.add({
	{ src = gh("neovim/nvim-lspconfig") },
	{ src = gh("mason-org/mason.nvim") },
	{ src = gh("mason-org/mason-lspconfig.nvim") },
	{ src = gh("WhoIsSethDaniel/mason-tool-installer.nvim") },
	{ src = gh("j-hui/fidget.nvim") },
	{ src = gh("saghen/blink.lib") },
	{ src = gh("saghen/blink.cmp") },
	{ src = gh("rafamadriz/friendly-snippets") },
	{ src = gh("L3MON4D3/LuaSnip"), version = vim.version.range("2.*") },
	{ src = gh("folke/lazydev.nvim") },
})

require("lazydev").setup({
	library = {
		{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
	},
})

require("fidget").setup()

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
	callback = function(event)
		local map = function(keys, func, desc, mode)
			return require("util").map(keys, func, "LSP: " .. desc, mode, event.buf)
		end

		map("rn", vim.lsp.buf.rename, "[R]e[n]ame")

		local picker = require("snacks").picker

		map("gd", picker.lsp_definitions, "[G]oto [D]efinition")
		map("gD", picker.lsp_definitions, "[G]oto [D]eclaration")
		map("gr", picker.lsp_references, "[G]oto [R]eferences")
		map("gI", picker.lsp_implementations, "[G]oto [I]mplementation")
		map("gt", picker.lsp_type_definitions, "[G]oto [I]type def")

		map("ca", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })
		map("<leader>dl", vim.diagnostic.open_float, "[D]iagnostic [L]ine")
		map("<leader>db", vim.diagnostic.open_float, "[D]iagnostic [B]uffer")
		map("<leader>lr", ":lsp restart<enter>", "[l]sp restart")

		map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
		map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
		map("K", vim.lsp.buf.hover, "Hover Documentation")
		map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if client and client:supports_method("textDocument/documentHighlight", event.buf) then
			local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.document_highlight,
			})

			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.clear_references,
			})

			vim.api.nvim_create_autocmd("LspDetach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
				callback = function(event2)
					vim.lsp.buf.clear_references()
					vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
				end,
			})
		end

		if client and client:supports_method("textDocument/inlayHint", event.buf) then
			map("<leader>th", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
			end, "[T]oggle Inlay [H]ints")
		end
	end,
})

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--  See `:help lsp-config` for information about keys and how to configure
---@type table<string, vim.lsp.Config>
local servers = {
	sqls = {},
	clangd = {},
	gopls = {},
	pyright = {},
	html = {
		filetypes = {
			"html",
			"twig",
			"hbs",
		},
	},
	ts_ls = {},
	tailwindcss = {
		filetypes = {
			"astro",
			"html",
			"javascript",
			"typescriptreact",
			"typescript",
			"react",
		},
		init_options = {
			userLanguages = {
				templ = "html",
			},
		},
	},
	lua_ls = {
		on_init = function(client)
			client.server_capabilities.documentFormattingProvider = false -- Disable formatting (formatting is done by stylua)
		end,
		---@type lspconfig.settings.lua_ls
		settings = {
			Lua = {
				format = { enable = false }, -- Disable formatting (formatting is done by stylua)
			},
		},
	},
	nil_ls = {
		on_init = function(client)
			client.server_capabilities.documentFormattingProvider = false -- Disable formatting (formatting is done by alejandra)
		end,
	},
}

require("mason").setup({})
require("mason-lspconfig").setup()

local ensure_installed = vim.tbl_keys(servers or {})
vim.list_extend(ensure_installed, {
	-- You can add other tools here that you want Mason to install
	"stylua",
	"alejandra",
})

require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

vim.lsp.config("*", {
	capabilities = require("blink.cmp").get_lsp_capabilities(),
})

for name, server in pairs(servers) do
	vim.lsp.config(name, server)
	vim.lsp.enable(name)
end

require("luasnip").setup({})
require("luasnip.loaders.from_vscode").lazy_load()
local cmp = require("blink.cmp")
cmp.build():pwait()
cmp.setup({
	keymap = { preset = "default" },
	appearance = {
		nerd_font_variant = "mono",
	},
	completion = {
		documentation = { auto_show = false, auto_show_delay_ms = 500 },
	},
	sources = {
		default = { "lazydev", "lsp", "path", "snippets" },
		providers = {
			lazydev = {
				name = "LazyDev",
				module = "lazydev.integrations.blink",
				-- make lazydev completions top priority (see `:h blink.cmp`)
				score_offset = 100,
			},
		},
	},
	snippets = { preset = "luasnip" },
	fuzzy = { implementation = "lua" },
	signature = { enabled = true },
})
