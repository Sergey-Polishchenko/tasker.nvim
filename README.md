# Tasker

## A Neovim plugin for running tasks from a Taskfile.yml with autocompletion and terminal management.

---

## Features

- Task Autocompletion: Automatically suggests tasks from your Taskfile.yml.
- Terminal Integration: Runs tasks in a dedicated terminal window within Neovim.
- Task Management: Start and stop tasks with simple commands.
- Error Handling: Displays task output and errors in the terminal window.

---

## Installation

Use your favorite plugin manager to install Tasker. For example, with lazy.nvim:

```lua
Copy
{
  "your-repository/tasker",
  config = function()
    require("tasker").setup()
  end,
  dependencies = {
    "nvim-lua/plenary.nvim", -- Required for utility functions
    "ibhagwan/fzf-lua",      -- Optional: For better task selection UI (if you plan to extend the plugin)
  },
}
```

---

## Dependencies

- Neovim 0.8+: Required for Lua API and terminal features.
- yq: A lightweight command-line YAML processor. Install it via your package manager:
    + macOS: brew install yq
    + Linux: sudo apt-get install yq or use snap install yq
    + Windows: Use scoop install yq or download from the official repository.

---

## Usage

### Commands

- Run a Task: :Task <task_name>
    + Use <Tab> for autocompletion of task names.
- Stop a Running Task: :TaskStop

### Example

1. Add a Taskfile.yml to your project root:
```yaml
version: '3'

tasks:
  build:
    desc: Build the project
    cmds:
      - echo "Building..."
      - sleep 5
      - echo "Build complete!"
  test:
    desc: Run tests
    cmds:
      - echo "Running tests..."
      - sleep 3
      - echo "Tests complete!"
```
2. Run a task:
```vim
:Task build
```
3. Stop a running task:
```vim
:TaskStop
```

---

## Configuration

You can customize the terminal window size and position by modifying the open_terminal_window function in lua/tasker/terminal.lua:

```lua
local function open_terminal_window()
  terminal_bufnr = vim.api.nvim_create_buf(false, true)
  terminal_winid = vim.api.nvim_open_win(
    terminal_bufnr,
    true,
    {
      relative = 'editor',
      width = vim.o.columns,  -- Adjust width
      height = 10,            -- Adjust height
      row = vim.o.lines - 10, -- Adjust vertical position
      col = 0,                -- Adjust horizontal position
      style = 'minimal',
    }
  )
end
```

---

## TODO

- [ ] Improve Long-Running Task Handling:
    + Add support for background tasks that don’t block the Neovim UI.
    + Implement progress indicators for long-running tasks.
    + Allow users to minimize or hide the terminal window while the task runs.
- [ ] Better Task Selection UI:
    + Integrate with fzf-lua or telescope.nvim for a more interactive task selection experience.
- [ ] Taskfile Validation:
    + Add validation for Taskfile.yml to ensure it follows the correct schema.
- [ ] Task Output Logging:
    + Save task output to a log file for later inspection.
- [ ] Customizable Keybindings:
    + Allow users to define custom keybindings for task commands.
- [ ] Support for Multiple Taskfiles:
    + Allow users to specify a custom path for the Taskfile.yml.

---

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any improvements or bug fixes.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
