pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

_mouse = {
 prev_x = 0,
 prev_y = 0,
 x = 0,
 y = 0,
 moved = false,
}

function _mouse:update() 
 self.prev_x = self.x
 self.prev_y = self.y

 -- mouse sometimes reads outside screen
 self.x = mid(0, stat(32), 127)
 self.y = mid(0, stat(33), 127)

 self.moved = (self.x ~= self.prev_x or self.y ~= self.prev_y)
end

_button = {
 id = nil,
 is_mouse = false,
 is_pressed = false, --pressed this frame
 is_down = false, --currently down
 ticks_down = 0, --how long down
}

function _button:update()
 self.is_pressed = false
 if (self.is_mouse and stat(34) == self.id) or (not self.is_mouse and btn(self.id)) then
 -- without mouse support
 --  if btn(self.id)) then
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

function make_button(id, is_mouse)
 local inst = {}
 setmetatable(inst, {__index = _button})
 inst.id = id
 inst.is_mouse = is_mouse

 return inst
end

function _init()
 -- enable mouse support
 poke(0x5f2d, 1)

 bz = make_button(4)
 bx = make_button(5)

 lmb = make_button(1, true)
 rmb = make_button(2, true)
end

function _update()
 cls()
 mouse:update()
 bz:update()
 bx:update()
 lmb:update()
 rmb:update()

end

function _draw()
 color(7)

 print('z is_pressed: ' .. tostr(bz.is_pressed))
 print('z is_down: ' .. tostr(bz.is_down))
 print('z ticks_down: ' .. tostr(bz.ticks_down))

 print('')

 print('x is_pressed: ' .. tostr(bx.is_pressed))
 print('x is_down: ' .. tostr(bx.is_down))
 print('x ticks_down: ' .. tostr(bx.ticks_down))

 print('')

 print('mouse x: ' .. tostr(mouse.x))
 print('mouse y: ' .. tostr(mouse.y))
 print('mouse moved: ' .. tostr(mouse.moved))

 print('')

 print('lmb is_pressed: ' .. tostr(lmb.is_pressed))
 print('lmb is_down: ' .. tostr(lmb.is_down))
 print('lmb ticks_down: ' .. tostr(lmb.ticks_down))

 print('')

 print('rmb is_pressed: ' .. tostr(rmb.is_pressed))
 print('rmb is_down: ' .. tostr(rmb.is_down))
 print('rmb ticks_down: ' .. tostr(rmb.ticks_down))

 circfill(mouse.x, mouse.y, 1,8)
end
