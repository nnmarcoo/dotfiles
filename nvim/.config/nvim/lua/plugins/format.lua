return {
    {
        "stevearc/conform.nvim",
        cmd = { "ConformInfo" },
        keys = {
            {
                "<leader>F",
                function()
                    require("conform").format({ async = true, lsp_format = "fallback" })
                end,
                mode = { "n", "x" },
                desc = "Format buffer (Prettier)",
            },
        },
        opts = {
            -- prettierd is fast; fall back to a project-local/global prettier.
            formatters_by_ft = {
                javascript      = { "prettierd", "prettier", stop_after_first = true },
                javascriptreact = { "prettierd", "prettier", stop_after_first = true },
                typescript      = { "prettierd", "prettier", stop_after_first = true },
                typescriptreact = { "prettierd", "prettier", stop_after_first = true },
                css             = { "prettierd", "prettier", stop_after_first = true },
                scss            = { "prettierd", "prettier", stop_after_first = true },
                json            = { "prettierd", "prettier", stop_after_first = true },
                jsonc           = { "prettierd", "prettier", stop_after_first = true },
                html            = { "prettierd", "prettier", stop_after_first = true },
                markdown        = { "prettierd", "prettier", stop_after_first = true },
                yaml            = { "prettierd", "prettier", stop_after_first = true },
            },
        },
    },
    {
        -- prettierd isn't an LSP server, so mason-lspconfig can't install it;
        -- this keeps it provisioned declaratively alongside the servers.
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        dependencies = { "williamboman/mason.nvim" },
        opts = {
            ensure_installed = { "prettierd" },
            run_on_start = true,
        },
    },
}
