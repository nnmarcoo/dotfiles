vim.g.mapleader = " "
vim.keymap.set('n', '<leader>cd', vim.cmd.Ex)

vim.keymap.set('n', '<leader>q', ':quit<CR>')
vim.keymap.set('n', '<leader>w', ':write<CR>')
vim.keymap.set('n', '<leader>o', ':update<CR> :source<CR>')

vim.keymap.set({ 'n', 'x' }, '<leader>y', '"+y', { desc = 'Yank to system clipboard' })
vim.keymap.set({ 'n', 'x' }, '<leader>d', '"+d', { desc = 'Delete to system clipboard' })

vim.keymap.set('n', '<leader>e', ':e<CR>')


-- ---------------------------------------------------------------------------
-- LSP / IDE navigation
-- ---------------------------------------------------------------------------
-- Neovim 0.11+ ships default LSP maps behind a `gr` prefix (grn, gra, grr,
-- gri, grt, grx). Keeping them would make a bare `gr` wait out 'timeoutlen'
-- before resolving to "goto references", so they're dropped in favour of the
-- explicit bindings below.
for _, lhs in ipairs({ "grn", "gra", "grr", "gri", "grt", "grx" }) do
    pcall(vim.keymap.del, "n", lhs)
end

-- Telescope gives a picker + preview when a symbol has several results, which
-- is the common case in Java/Kotlin (interfaces, overloads, overrides). Fall
-- back to the plain LSP handler if telescope isn't loaded for some reason.
local function pick(builtin_name, lsp_fn)
    return function()
        local ok, builtin = pcall(require, "telescope.builtin")
        if ok and builtin[builtin_name] then
            builtin[builtin_name]({ reuse_win = true })
        else
            lsp_fn()
        end
    end
end

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local buf = args.buf
        local function map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = buf, silent = true, desc = "LSP: " .. desc })
        end

        -- Navigation
        map("n", "gd", pick("lsp_definitions", vim.lsp.buf.definition), "Goto definition")
        map("n", "gD", vim.lsp.buf.declaration, "Goto declaration")
        map("n", "gi", pick("lsp_implementations", vim.lsp.buf.implementation), "Goto implementation")
        map("n", "gy", pick("lsp_type_definitions", vim.lsp.buf.type_definition), "Goto type definition")
        map("n", "gr", pick("lsp_references", vim.lsp.buf.references), "List references")
        map("n", "gO", pick("lsp_document_symbols", vim.lsp.buf.document_symbol), "Document symbols")
        map("n", "<leader>fs", pick("lsp_dynamic_workspace_symbols", function() vim.lsp.buf.workspace_symbol("") end),
            "Workspace symbols")
        map("n", "<leader>ci", pick("lsp_incoming_calls", vim.lsp.buf.incoming_calls), "Incoming calls")
        map("n", "<leader>co", pick("lsp_outgoing_calls", vim.lsp.buf.outgoing_calls), "Outgoing calls")

        -- Documentation
        map("n", "K", function() vim.lsp.buf.hover({ border = "rounded" }) end, "Hover docs")
        map("n", "gs", function() vim.lsp.buf.signature_help({ border = "rounded" }) end, "Signature help")
        map("i", "<C-s>", function() vim.lsp.buf.signature_help({ border = "rounded" }) end, "Signature help")

        -- Refactoring
        map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
        map({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
        map("n", "<leader>cl", vim.lsp.codelens.run, "Run code lens")

        -- Diagnostics ('<leader>d' is taken by delete-to-clipboard, so 'l' here)
        map("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, "Prev diagnostic")
        map("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, "Next diagnostic")
        map("n", "[e", function() vim.diagnostic.jump({ count = -1, float = true, severity = vim.diagnostic.severity.ERROR }) end, "Prev error")
        map("n", "]e", function() vim.diagnostic.jump({ count = 1, float = true, severity = vim.diagnostic.severity.ERROR }) end, "Next error")
        map("n", "<leader>ll", function() vim.diagnostic.open_float({ scope = "line", border = "rounded" }) end, "Line diagnostics")
        map("n", "<leader>lq", pick("diagnostics", function() vim.diagnostic.setqflist() end), "List all diagnostics")

        -- Inlay hints: parameter names and inferred types, the IntelliJ
        -- default. Enabled unconditionally rather than behind a
        -- supports_method() check -- jdtls registers textDocument/inlayHint
        -- dynamically some time *after* LspAttach fires, so the check is
        -- still false here. Neovim only issues the request to clients that
        -- advertise it, so this is a no-op for servers without support.
        vim.lsp.inlay_hint.enable(true, { bufnr = buf })
        map("n", "<leader>lh", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = buf }), { bufnr = buf })
        end, "Toggle inlay hints")
    end,
})
