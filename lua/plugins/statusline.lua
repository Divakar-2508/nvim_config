return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "arkav/lualine-lsp-progress" },
	config = function()
		-- Function to get active LSPs
		local function get_active_lsp()
			local clients = vim.lsp.get_active_clients()
			if next(clients) == nil then
				return "No LSP"
			end
			local names = {}
			for _, client in ipairs(clients) do
				table.insert(names, client.name)
			end
			return table.concat(names, " | ")
		end

		require("lualine").setup({
			options = {
				theme = "monokai-pro",
				component_separators = { left = "│", right = "│" },
				section_separators = { left = "", right = "" },
				globalstatus = true,
			},
			sections = {
				lualine_a = { {
					"mode",
					fmt = function(str)
						return str:sub(1, 1)
					end,
				} }, -- Single-letter mode
				lualine_b = { "filename" },
				lualine_c = {
					{
						"diagnostics",
						sources = { "nvim_diagnostic" },
						symbols = { error = " ", warn = " ", info = " ", hint = " " },
					},
					{ "lsp_progress" },
				},
				lualine_d = {
					{
						function()
							return " " .. os.date("%H:%M") -- Clock icon + time
						end,
						cond = nil, -- Ensure it always shows
						color = { fg = "#ffffff", gui = "bold" },
						padding = { left = 1, right = 1 },
					},
				},
				lualine_w = {
					{
						function()
							return " " .. os.date("%H:%M") -- Clock icon + time
						end,
						cond = nil, -- Ensure it always shows
						color = { fg = "#ffffff", gui = "bold" },
						padding = { left = 1, right = 1 },
					},
				},
				lualine_x = { get_active_lsp }, -- Active LSPs shown here
				lualine_y = { "location", "progress" },
				lualine_z = {},
			},
		})
	end,
}
