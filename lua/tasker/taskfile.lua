local M = {}

function M.read_taskfile()
  local cwd = vim.fn.getcwd()
  local taskfile_path = cwd .. "/Taskfile.yml"

  if vim.fn.filereadable(taskfile_path) == 0 then
    print("Taskfile.yml not found in root!")
    return {}
  end

  local handle = io.popen("yq e -o=json " .. taskfile_path)
  local content = handle:read("*a")
  handle:close()

  local tasks = {}
  local parsed = vim.fn.json_decode(content)

  if parsed and parsed.tasks then
    for task_name, _ in pairs(parsed.tasks) do
      table.insert(tasks, task_name)
    end
  end

  return tasks
end

return M
