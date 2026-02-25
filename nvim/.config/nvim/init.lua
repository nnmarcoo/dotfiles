require('config.options')
require('config.keybinds')
require('config.lazy')

vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
        vim.api.nvim_set_hl(0, "Normal",      { bg = "#000000" })
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#000000" })
        vim.api.nvim_set_hl(0, "SignColumn",  { bg = "#000000" })
    end,
})

