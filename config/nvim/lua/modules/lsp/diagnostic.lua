local M = {}

function M.setup()
	vim.diagnostic.config({
		virtual_text = false,
	})

	local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
	for type, icon in pairs(signs) do
		local hl = "DiagnosticSign" .. type
		vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
	end

	vim.cmd([[autocmd! CursorHold,CursorHoldI * Lspsaga show_line_diagnostics]])
end

return M
