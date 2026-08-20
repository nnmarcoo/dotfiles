return {
    {
	"datsfilipe/vesper.nvim",
	priority = 1000,
	lazy = false,
	config = function()
	    vim.cmd.colorscheme "vesper"
	end
    },
    {
	"nvim-lualine/lualine.nvim",
	dependencies = {
	    "nvim-tree/nvim-web-devicons",
	},
	opts = {
	    -- 'theme' belongs under 'options'; at the top level lualine ignores it.
	    options = { theme = 'auto' },
	    sections = {
		-- lsp_status spins while a server is initialising, importing or
		-- indexing, and shows a check once it is idle. Without it there
		-- is no sign that a server is still building its index, and
		-- requests like go-to-definition just come back empty.
		lualine_c = { 'filename', 'lsp_status' },
	    },
	}
    },
}
