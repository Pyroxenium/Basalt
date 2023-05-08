local cols = {}

for i = 0, 15 do
    cols[2^i] = ("%x"):format(i)
end
return cols