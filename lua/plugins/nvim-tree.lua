local opt = { noremap = true, silent = true }

-- natural sort numbers
local function natural_cmp(left, right)
  -- directories come first
  if left.type ~= "directory" and right.type == "directory" then
    return false
  elseif left.type == "directory" and right.type ~= "directory" then
    return true
  end

  -- helper function to split a string into array of strings and numbers
  local function split_name(name)
    local parts = {}
    local i = 1
    local len = string.len(name)

    while i <= len do
      -- try to match a sequence of digits first
      local num_start, num_end = string.find(name, "^%d+", i)

      if num_start then
        -- found a number sequence
        local num_str = string.sub(name, num_start, num_end)
        table.insert(parts, tonumber(num_str))
        i = num_end + 1
      else
        -- no digits found, match non-digit sequence
        local text_start, text_end = string.find(name, "^%D+", i)
        if text_start then
          local text_str = string.sub(name, text_start, text_end)
          table.insert(parts, text_str:lower())
          i = text_end + 1
        else
          -- shouldn't happen, but safety break
          break
        end
      end
    end

    return parts
  end

  local left_parts = split_name(left.name)
  local right_parts = split_name(right.name)

  -- compare element by element
  local max_parts = math.max(#left_parts, #right_parts)

  for i = 1, max_parts do
    local l_part = left_parts[i]
    local r_part = right_parts[i]

    -- if one array is shorter, the shorter one comes first
    if l_part == nil then
      return true
    elseif r_part == nil then
      return false
    end

    -- both parts exist, compare them
    local l_type = type(l_part)
    local r_type = type(r_part)

    if l_type == r_type then
      -- same type, direct comparison
      if l_part ~= r_part then
        return l_part < r_part
      end
    else
      -- different types: numbers come before strings
      if l_type == "number" and r_type == "string" then
        return true
      elseif l_type == "string" and r_type == "number" then
        return false
      end
    end
  end

  -- all parts are equal
  return false
end

return {
  'nvim-tree/nvim-tree.lua',
  dependencies = {
    'nvim-tree/nvim-web-devicons', -- optional, for file icon
  },
  keys = {
    { '<leader>to', '<cmd>NvimTreeOpen<cr>', mode = 'n', unpack(opt) },
  },
  opts = {
    diagnostics = {
      enable = true,
      icons = {
        hint = "",
        info = "",
        warning = "",
        error = "",
      },
    },
    sync_root_with_cwd = true,
    actions = {
      change_dir = {
        enable = true,
        global = true,
      },
    },
    filters = {
      dotfiles = true,
    },
    sort_by = function(nodes)
      table.sort(nodes, natural_cmp)
    end,
  },
}
