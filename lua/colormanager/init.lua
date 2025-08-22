local colormanager = {}
local initialized = false

local function read_file(path)
  local file_exists = vim.fn.filereadable(path) == 1
  if not file_exists then return end

  local file, err = io.open(path, 'r')
  if not file then
    vim.notify('Failed to open file for reading: ' .. (err or 'unknown error'), vim.log.levels.ERROR)
    return
  end

  local content, read_err
  local success = pcall(function()
    content = file:read '*a'
    file:close()
  end)

  if not success then
    vim.notify('Failed to read file: ' .. (read_err or 'unknown error'), vim.log.levels.ERROR)
    file:close()
    return
  end

  if not content or #content <= 0 then return end

  return content
end

local function write_file(path, contents)
  if not contents or type(contents) ~= 'string' then
    vim.notify('Invalid color value provided', vim.log.levels.ERROR)
    return
  end

  local file, err = io.open(path, 'w')
  if not file then
    vim.notify('Failed to open file for writing: ' .. (err or 'unknown error'), vim.log.levels.ERROR)
    return
  end

  local success, write_err = pcall(function()
    file:write(contents)
    file:close()
  end)

  if not success then
    vim.notify('Failed to write to file: ' .. (write_err or 'unknown error'), vim.log.levels.ERROR)
    file:close()
    return
  end
end

---@return string?
local function load_last_color()
  local fallback = colormanager.fallback
  local path = colormanager.lastcolor_path
  if not path then return fallback end

  return read_file(path) or fallback
end

---@return string
local function load_last_mode()
  local fallback = vim.o.background
  local path = colormanager.lastmode_path
  if not path then return fallback end

  return read_file(path) or fallback
end

---@param color string
local function save_last_color(color)
  local path = colormanager.lastcolor_path
  if path then write_file(path, color) end
end

local function save_last_mode()
  local path = colormanager.lastmode_path
  if path then write_file(path, vim.o.background) end
end

---@param color string?
local function apply_color(color)
  local choosen = colormanager.colors[color]
  local dark = vim.o.background == 'dark'

  if not choosen then return end

  if dark then
    local command = choosen.dark or choosen.set
    if command then vim.cmd.colorscheme(command) end
  else
    local command = choosen.light or choosen.set
    if command then vim.cmd.colorscheme(command) end
  end

  save_last_color(color)
  colormanager.lastcolor = color
  save_last_mode()
end

local function select_color()
  local items = colormanager.colornames or {}

  vim.ui.select(items, {}, function(item)
    if item == nil then return end
    apply_color(item)
  end)
end

local function toggle_mode()
  if vim.o.background == 'dark' then
    vim.o.background = 'light'
  else
    vim.o.background = 'dark'
  end
end

---@param opts ColormodeOpts?
function colormanager.setup(opts)
  if initialized then return end
  initialized = true

  opts = opts or {}
  local colors = opts.colors or {}
  local names = {}
  local extracted_colors = {}

  for _, color in pairs(colors) do
    extracted_colors[color.name] = { set = color.set, dark = color.dark, light = color.light }
    table.insert(names, color.name)
  end

  colormanager.colors = extracted_colors
  colormanager.colornames = names
  colormanager.fallback = opts.fallback
  colormanager.lastcolor_path = vim.fn.stdpath 'data' .. '/colormanager.lastcolor'
  colormanager.lastmode_path = vim.fn.stdpath 'data' .. '/colormanager.lastmode'
  colormanager.lastcolor = load_last_color()
  colormanager.lastmode = load_last_mode()

  if colormanager.lastmode == 'dark' or colormanager.lastmode == 'light' then
    vim.o.background = colormanager.lastmode
  else
    colormanager.lastmode = vim.o.background
  end

  apply_color(colormanager.lastcolor)

  vim.api.nvim_create_autocmd('OptionSet', {
    pattern = 'background',
    callback = function() apply_color(colormanager.lastcolor) end,
  })

  colormanager.select = select_color
  colormanager.toggle = toggle_mode
end

return colormanager
