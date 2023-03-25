#!/usr/bin/env texlua
local ty = require('markdown-tinyyaml')
local mkd = require('markdown')

function load_yaml(filename)
  local file = io.open(filename, 'r')
  local text = file:read('*a')
  data = ty.parse(text)
end

function table_count(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function str_split(str, pat)
  local tbl = {}
  str:gsub(pat, function(x) tbl[#tbl + 1] = x end)
  return tbl
end

function get_from_path(p)
  local ret = data
  local path = str_split(p, "[^.]*")
  for _, sub in pairs(path) do
    sub_num = tonumber(sub, 10)
    if sub_num ~= nil then
      sub = sub_num
    end
    if ret == nil or ret[sub] == nil then return nil end
    ret = ret[sub]
  end
  return ret
end

function if_has_path(p, a, b)
  if get_from_path(p) ~= nil then
    return a
  else
    return b
  end
end

function str_to_date(str)
  local p = "(%d+)%p(%d+)%p(%d+)"
  local year, month, day = str:gsub("[^%d%p]", ""):match(p)
  return os.time({ day = day, month = month, year = year })
end

function month_to_quarter(month)
  return math.floor((month + 2) / 3)
end

function date_to_quarter(date)
  return month_to_quarter(tonumber(os.date("%m", date)))
end

local function emphasis(text)
  text = text:gsub("\\%*", "\\textasteriskcentered ")
  text = text:gsub("\\%_", "\\textunderscore ")
  for _, s in ipairs { "%*%*", "%_%_" } do
    text = text:gsub(s .. "([^%s][%*%_]?)" .. s, "\\textbf{%1}")
    text = text:gsub(s .. "([^%s][^<>]-[^%s][%*%_]?)" .. s, "\\textbf{%1}")
  end
  for _, s in ipairs { "%*", "%_" } do
    text = text:gsub(s .. "([^%s_])" .. s, "\\emph{%1}")
    text = text:gsub(s .. "([^%s_][^<>_]-[^%s_])" .. s, "\\emph{%1}")
  end
  text = text:gsub("\\textasteriskcentered ", "*")
  text = text:gsub("\\textunderscore ", "\\_")
  return text
end

function print_markdown_simple(str)
  if str == nil then return end
  -- texio.write("log", inspect(emphasis(str)) .. "\n")
  local result = emphasis(str):gsub("[\n\r]+", "\\\\")
  tex.print(result)
end

function print_markdown_full(str)
  if str == nil then return end
  local result = mkd.new()(str)
  tex.print(result)
end

function format_date(str, format)
  local date
  if type(str) == 'string' then
    date = str_to_date(str)
  else
    date = os.time(str)
  end
  format = format:gsub("\\%%", "%%")
  if format == '%q' then
    return date_to_quarter(date)
  else
    return os.date(format, date)
  end
end

function safe_text(str)
  local ret = string.gsub(str, "~", '\\char"7E')
  return ret
end

-- vim: set tabstop=2:softtabstop=2:shiftwidth=2:expandtab
