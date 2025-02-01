local M = {}

function M.filter_tasks(tasks, arg_lead)
  local matches = {}
  for _, task in ipairs(tasks) do
    if string.sub(task, 1, #arg_lead) == arg_lead then
      table.insert(matches, task)
    end
  end
  return matches
end

return M
