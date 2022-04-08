local function csplit(str,sep)
   local ret={}
   local n=1
   for w in str:gmatch("([^"..sep.."]*)") do
      ret[n] = ret[n] or w -- only set once (so the blank after a string is ignored)
      if w=="" then
         n = n + 1
      end -- step forwards on a blank but not a string
   end
   return ret
end


function get_screen_size()
    local file= io.popen("xdpyinfo  | grep dimensions | awk '{print $2}'")
    local content = file:read "*a"
    file:close()
    res = csplit(content,"x")
    return tonumber(res[1]), tonumber(res[2])
 end