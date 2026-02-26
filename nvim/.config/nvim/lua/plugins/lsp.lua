return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
    },

    config = function()
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        -- Setup Mason
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "rust_analyzer",
                "clangd",
                "lua_ls",
                "ts_ls",
                "jdtls",
            },
        })

        local function setup(server, opts)
            opts = opts or {}
            opts.capabilities = capabilities

            vim.lsp.config(server, opts)
            vim.lsp.enable(server)
        end

        for _, server in ipairs(require("mason-lspconfig").get_installed_servers()) do
            -- jdtls is handled by nvim-jdtls (lua/plugins/java.lua)
            if server == "jdtls" then goto continue end

            local opts = {}

            if server == "rust_analyzer" then
                opts.settings = {
                    ["rust-analyzer"] = {
                        cargo = { allFeatures = true },
                        checkOnSave = true,
                        check = { command = "clippy" },
                        procMacro = { enable = true },
                    },
                }
            end

            if server == "lua_ls" then
                opts.settings = {
                    Lua = {
                        runtime = { version = "LuaJIT" },
                        workspace = {
                            checkThirdParty = false,
                            library = vim.api.nvim_get_runtime_file("", true),
                        },
                        diagnostics = { globals = { "vim" } },
                        telemetry = { enable = false },
                    },
                }
            end

            if server == "ts_ls" then
                opts.settings = {
                    typescript = { format = { semicolons = "insert" } },
                    javascript = { format = { semicolons = "insert" } },
                }
            end

            setup(server, opts)

            ::continue::
        end

	vim.api.nvim_create_autocmd("CursorHold", {
	callback = function()
	    local line = vim.api.nvim_win_get_cursor(0)[1] - 1

	    -- Get all diagnostics for the current line
	    local diags = vim.diagnostic.get(0, { lnum = line })

	    if vim.tbl_isempty(diags) then
		return
	    end

	    vim.diagnostic.open_float(nil, {
		focus = false,
		border = "rounded",
		scope = "line",  -- show ALL diagnostics for the line
	    })
	end,
    })


    end,
}

