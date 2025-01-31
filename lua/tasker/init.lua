local M = {}

function M.hello_tasker()
    print("Hello from Tasker plugin!")
end

function M.setup()
    vim.api.nvim_set_keymap('n', '<Leader>t', ':lua require("tasker").hello_tasker()<CR>', { noremap = true, silent = true })
end

return M
