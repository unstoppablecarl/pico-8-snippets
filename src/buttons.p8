pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

buttons = {}

function update_buttons()
 for b in all(buttons) do
  b:update()
 end
end

button = {
 is_pressed = false, --pressed this frame
 is_down = false, --currently down
 ticks_down = 0, --how long down
}

function button:update()
 self.is_pressed = false
 if btn(self.id) then
  if not self.is_down then
   self.is_pressed = true
  end
  self.is_down = true
  self.ticks_down += 1
 else
  self.is_down = false
  self.is_pressed = false
  self.ticks_down = 0
 end
end

function make_button(id)
 local inst = {
     id = id
 }
 setmetatable(inst, {__index = button})
 add(buttons, inst)
 return inst
end

function _init()
 bz = make_button(4)
 bx = make_button(5)
end

function _update()
 cls()
 update_buttons()
end

function _draw()

 print('z is_pressed: ' .. tostr(bz.is_pressed))
 print('z is_down: ' .. tostr(bz.is_down))
 print('z ticks_down: ' .. tostr(bz.ticks_down))

 print('')

 print('x is_pressed: ' .. tostr(bx.is_pressed))
 print('x is_down: ' .. tostr(bx.is_down))
 print('x ticks_down: ' .. tostr(bx.ticks_down))
end
