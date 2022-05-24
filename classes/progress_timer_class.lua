ProgressTimer = {
  fps = 60
}

function ProgressTimer:Start()

end

function ProgressTimer:Render(data)
  data = data or ""
  result, err = pcall(function()
    self.renderTarget.Legend = rapidjson.encode({
      DrawChrome = false,
      IconData = data
    })
  end)
  if err then print(string.format("!! Error Rendering [%s]", err)) end
end

function ProgressTimer:New (o)
  o = o or {}   -- create object if user does not provide one
  if not (o.renderTarget) then return print('!! No Render Target') end 
  if type(o.renderTarget) ~= 'control' then return print('!! Invalid Render Target') end 
  -- if not (o.fps) or (type(o.fps) ~= 'number') then return print('!! [Invalid Render Target]') end
  setmetatable(o, self)
  self.__index = self
  return o
end