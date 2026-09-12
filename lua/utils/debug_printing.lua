local M = {}

local loggers = {
  javascript = function(expr)
    return 'console.log("' .. expr .. ': ", ' .. expr .. ")"
  end,

  typescript = function(expr)
    return 'console.log("' .. expr .. ': ", ' .. expr .. ")"
  end,

  vue = function(expr)
    return 'console.log("' .. expr .. ': ", ' .. expr .. ")"
  end,

  go = function(expr)
    return 'log.Printf("' .. expr .. ': %v", ' .. expr .. ")"
  end,

  python = function(expr)
    return 'print("' .. expr .. ':", ' .. expr .. ")"
  end,

  lua = function(expr)
    return 'print("' .. expr .. ': ", ' .. expr .. ")"
  end,
}

local function make_log_line(expr)
  local logger = loggers[vim.bo.filetype]

  if not logger then
    vim.notify("No logger configured for filetype: " .. vim.bo.filetype, vim.log.levels.WARN)
    return nil
  end

  return logger(expr)
end

function M.console_log()
  local mode = vim.fn.mode()

  -- Visual mode
  if mode == "v" or mode == "V" or mode == "\22" then
    local start_pos = vim.fn.getpos("v")
    local end_pos = vim.fn.getpos(".")

    local start_row = start_pos[2]
    local start_col = start_pos[3]
    local end_row = end_pos[2]
    local end_col = end_pos[3]

    if start_row > end_row or (start_row == end_row and start_col > end_col) then
      start_row, end_row = end_row, start_row
      start_col, end_col = end_col, start_col
    end

    local lines = vim.api.nvim_buf_get_text(0, start_row - 1, start_col - 1, end_row - 1, end_col, {})

    if #lines == 0 then
      return
    end

    local expression = table.concat(lines, "\n")
    local log_line = make_log_line(expression)

    if not log_line then
      return
    end

    local last_line = vim.api.nvim_buf_get_lines(0, end_row - 1, end_row, false)[1]

    local indent = last_line:match("^%s*") or ""

    vim.api.nvim_buf_set_lines(0, end_row, end_row, false, { indent .. log_line })

    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)

    return
  end

  -- Normal mode
  local word = vim.fn.expand("<cword>")

  if word == "" then
    return
  end

  local log_line = make_log_line(word)

  if not log_line then
    return
  end

  local row = vim.api.nvim_win_get_cursor(0)[1]
  local current_line = vim.api.nvim_get_current_line()
  local indent = current_line:match("^%s*") or ""

  vim.api.nvim_buf_set_lines(0, row, row, false, { indent .. log_line })
end

return M
