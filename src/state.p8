pico-8 cartridge // http://www.pico-8.com
version 16
__lua__


state = (function()

 local current = false
 local new_state = false

 local s = {}

 function s:set(state)
  new_state = state
 end

 function s:get()
  return current
 end

 function s:update()
  if new_state then
   if current and current.shutdown then
    current:shutdown()   
   end

   if new_state and new_state.init then
    new_state:init()
   end

   current = new_state
   new_state = false
  end

  if current then
   current:update()
  end
 end  

 function s:draw()
  if current then
   current:draw()
  end
 end

 return s
end)()

-- create scope for state variables
state_menu = (function()

 local timer = time()
 local c = 12
 local printed_update = false

 local menu = {}

 function menu:init()
  color(c)
  print('menu:init()')
  printed_update = false
 end
 
 function menu:update()
  if not printed_update then
   color(c)
   print('menu:update() press x for menu')
   printed_update = true
  end 
 
  if btnp(5) then
   state:set(state_game)
  end
 end
 
 function menu:draw()
  rectfill(120, 0, 128, 8, c)
 end
 
 function menu:shutdown()
  color(c)
  print('menu:shutdown()')
 end

 return menu
end)()


-- create scope for state variables
state_game = (function()

 local c = 8
 local printed_update = false

 local game = {}
 
 function game:init()
  color(c)
  print('game:init()')
  printed_update = false
 end
 
 function game:update()
  if not printed_update then
   color(c)
   print('menu:update() press z for game')
   printed_update = true
  end 
 
  if btnp(4) then
   state:set(state_menu)
  end
 end
 
 function game:draw()
  rectfill(120, 0, 128, 8, c)
 end
 
 function game:shutdown()
  color(c)
  print('game:shutdown()')
 end

 return game
end)()


function _init()
 cls(0)
 state:set(state_menu)
end

function _update()
 state:update()
end

function _draw()
 state:draw()
end