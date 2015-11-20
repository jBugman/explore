require "process"

if #arg == 2 then
  local ok, err = pcall(function() process(arg[1], arg[2]) end)
  if not ok then print(err) end
else
  print("Args are: <field name> <folder>")
end

-- -- Benchmark
-- for i=1, 100 do
--   process("Name", "../test_data/")
-- end
