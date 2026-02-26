return {
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        config = function()
            local highlight = { "IblScope" }

            local hooks = require("ibl.hooks")
            hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
                vim.api.nvim_set_hl(0, "IblScope", { fg = "#888888" })
            end)

            require("ibl").setup({
                indent = { char = "│" },
                scope = {
                    enabled = true,
                    show_start = true,
                    show_end = true,
                    highlight = highlight,
                },
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        config = function()
            require("treesitter-context").setup({
                max_lines = 3,
            })
        end,
    },
}
