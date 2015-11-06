local lfs = require "lfs"
local globtopattern = require 'globtopattern'.globtopattern
local cjson = require "cjson"

function sort_dict_by_value(dict)
  local sorted = {}
  for k, v in pairs(dict) do
    table.insert(sorted, {k, v})
  end
  local function sortbyvalue(a, b)
    if a[2] == b[2] then
        return a[1] < b[1]
    else
        return a[2] > b[2]
    end
  end
  table.sort(sorted, sortbyvalue)
  return sorted
end

function escapeCSV(s)
  if string.find(s, '[,"]') then
    s = '"' .. string.gsub(s, '"', '""') .. '"'
  end
  return s
end

function process(field, folder)
  pattern = globtopattern("*.json")
  frequencies = {}
  for file in lfs.dir(folder) do
    if string.match(file, pattern) then
      local path = folder.."/"..file
      local f = io.open(path, "r")
      local contents = f:read("*all")
      f:close()
      local data = cjson.decode(contents)
      local value = data[field]
      if not value then
        error("Field is missing")
      end
      if type(value) ~= "string" then
        error("Field is not a string")
      end
      if value ~= "" then
        frequencies[value] = (frequencies[value] or 0) + 1
      end
    end
  end
  local sorted = sort_dict_by_value(frequencies)
  local of = io.open("output.csv", "w")
  for i, v in ipairs(sorted) do
    of:write(escapeCSV(v[1])..","..escapeCSV(v[2]).."\n")
  end
  of:close()
end
