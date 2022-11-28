local M = {}

function M.is_array(t)
  local i = 0
  for _ in pairs(t) do
    i = i + 1
    if t[i] == nil then return false end
  end
  return true
end

function M.merge_tables(t1, t2)
  for k, v in pairs(t2) do
    if (type(v) == "table") and (type(t1[k] or false) == "table" and not M.is_array(t1[k])) then
      if not (t1[k]==nil or t2[k]==nil) then
        M.merge_tables(t1[k], t2[k])
      end
    else
      t1[k] = v
    end
  end
  return t1
end

return M
