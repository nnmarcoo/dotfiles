-- Keybind reference for this config: see KEYBINDS.md
require('config.options')
require('config.keybinds')

-- Force a true-black (#000000) background across the whole UI, preserving
-- each group's foreground. CursorLine / PmenuSel are left untouched so the
-- current line and selected completion item stay visible against black.
-- Registered before config.lazy so it fires when the colorscheme is applied
-- during plugin startup.
vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
        local groups = {
            "Normal", "NormalNC", "NormalFloat", "FloatBorder", "FloatTitle",
            "SignColumn", "LineNr", "CursorLineNr", "FoldColumn", "EndOfBuffer",
            "StatusLine", "StatusLineNC", "WinBar", "WinBarNC", "MsgArea",
            "TelescopeNormal", "TelescopeBorder",
            "TelescopePromptNormal", "TelescopePromptBorder",
            "TelescopeResultsNormal", "TelescopeResultsBorder",
            "TelescopePreviewNormal", "TelescopePreviewBorder",
        }
        for _, group in ipairs(groups) do
            local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
            hl.bg = "#000000"
            vim.api.nvim_set_hl(0, group, hl)
        end
    end,
})

require('config.lazy')
