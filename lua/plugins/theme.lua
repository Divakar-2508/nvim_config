return {
	"loctvl842/monokai-pro.nvim",
	config = function()
		require("monokai-pro").setup({
			terminal_colors = true,
			filter = "pro",
		})
		vim.cmd.colorscheme("monokai-pro")
	end,
}
