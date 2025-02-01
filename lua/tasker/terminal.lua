local M = {}

local terminal_job_id = nil
local terminal_bufnr = nil
local terminal_winid = nil
local is_task_running = false
local task_lock = false

function M.is_task_running()
  return is_task_running
end

local function open_terminal_window()
  terminal_bufnr = vim.api.nvim_create_buf(false, true)
  terminal_winid = vim.api.nvim_open_win(
    terminal_bufnr,
    true,
    {
      relative = 'editor',
      width = vim.o.columns,
      height = 10,
      row = vim.o.lines - 10,
      col = 0,
      style = 'minimal',
    }
  )
end

function M.run_task(task)
  if task_lock then
    print("The task is already running. Wait until it is completed.")
    return
  end

  task_lock = true
  is_task_running = true

  local command = "task " .. task

  local task_output = ""

  local delay = 1000
  local timer = vim.loop.new_timer()
  local is_window_opened = false

  terminal_job_id = vim.fn.jobstart(command, {
      on_stdout = function(_, data, _)
        task_output = task_output .. table.concat(data, "\n") .. "\n"

        if is_window_opened then
          vim.api.nvim_buf_set_lines(terminal_bufnr, -1, -1, false, data)
        end
      end,

      on_stderr = function(_, data, _)
        task_output = task_output .. table.concat(data, "\n") .. "\n"

        if is_window_opened then
          vim.api.nvim_buf_set_lines(terminal_bufnr, -1, -1, false, data)
        end
      end,

      on_exit = function(_, exit_code)
        local is_error = exit_code ~= 0

        timer:stop()

        if not is_error and not is_window_opened then
          print("The task was succesfully completed.")
          print(task_output)
        else
            if not is_window_opened then
                open_terminal_window()
                vim.api.nvim_buf_set_lines(terminal_bufnr, 0, -1, false, vim.split(task_output, "\n"))
            end

            if is_error then
              print("The task was complete with an error.")
            else
              print("The task was succesfully completed.")
            end

            vim.api.nvim_buf_set_keymap(
              terminal_bufnr,
              "n",
              "<CR>",
              "",
              {
                callback = function()
                  vim.cmd('close')
                  terminal_job_id = nil
                  terminal_bufnr = nil
                  terminal_winid = nil
                  is_task_running = false
                  task_lock = false
                end,
              }
          )
        end

        is_task_running = false
        task_lock = false
        terminal_job_id = nil
      end,
    }
  )

  timer:start(
    delay,
    0,
    vim.schedule_wrap(
      function()
        if not is_window_opened then
          is_window_opened = true
          open_terminal_window()
        end
      end
    )
  )
end

function M.stop_task()
  if is_task_running and terminal_job_id then
    vim.fn.jobstop(terminal_job_id)
    print("Task forcibly terminated.")
    is_task_running = false
    task_lock = false
    terminal_job_id = nil
  else
      print("There are not active task to stop.")
  end
end

return M
