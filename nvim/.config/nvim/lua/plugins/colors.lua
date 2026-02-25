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
	    theme = 'vesper'
	}
    },
}
