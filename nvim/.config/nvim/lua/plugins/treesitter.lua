return {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ":TSUpdate",
    config = function()
        local parsers = {
            "lua",
            "tsx",
            "typescript",
            "javascript",
            "css",
            "rust",
            "c",
            "cpp",
            "java",
            "python",
            "markdown",
            "markdown_inline",
        }
        require("nvim-treesitter").install(parsers)

        vim.api.nvim_create_autocmd("FileType", {
            callback = function(args)
                local ok = pcall(vim.treesitter.start, args.buf)
                if ok then
                    vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end
            end,
        })
    end
}
