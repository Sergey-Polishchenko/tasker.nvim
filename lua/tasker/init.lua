local taskfile = require("tasker.taskfile")
local terminal = require("tasker.terminal")
local utils = require("tasker.utils")

local M = {}

function M.task_complete(arg_lead, cmd_line, cursor_pos)
  local tasks = taskfile.read_taskfile()
  return utils.filter_tasks(tasks, arg_lead)
end

function M.run_task(task)
  if terminal.is_task_running() then
    print("The task is already running. Wait until it is completed.")
    return
  end

  local tasks = taskfile.read_taskfile()
  if not vim.tbl_contains(tasks, task) then
    print("Task '" .. task .. "' not found. Available tasks:")
    for _, t in ipairs(tasks) do
      print("  - " .. t)
    end
    return
  end

  terminal.run_task(task)
end

function M.stop_task()
  terminal.stop_task()
end

function M.setup()
  vim.api.nvim_create_user_command(
    "Task",
    function(opts)
      M.run_task(opts.args)
    end, 
    {
      nargs = 1,
      complete = function(arg_lead, cmd_line, cursor_pos)
        return M.task_complete(arg_lead, cmd_line, cursor_pos)
      end,
    }
  )

  vim.api.nvim_create_user_command(
    "TaskStop",
    function()
      M.stop_task()
    end,
    {}
  )
end

return M
