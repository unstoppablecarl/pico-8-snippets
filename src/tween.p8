pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

function quad_in(v)
 return v * v
end

function quad_out(v)
 return v * (2 - v)
end

timers = {}

function update_timers()
 for i=1,#timers do
  timers[i]:update()
 end
end

_timer = {
  started = false,
  duration = 1,
  on_start = false,
  on_update = false,
  on_complete = false,
  once = true,
  loop = false,
  start_loop = false
}

function _timer:start()
 self.started = time()
 if self.on_start then
  self.on_start(0, self)
 end
end

function _timer:update()
 if self.start_loop then
    self.start_loop = false
    self:start()
 end

 if self.started == false then
  return
 end
 -- progress
 local prog = (time() - self.started) / self.duration
 prog = min(prog, 1)

 if self.on_update then
  self.on_update(prog, self)
 end

 if prog == 1 then
  self.started = false

  if self.on_complete then
   self.on_complete(prog, self)
  end

  if self.loop then
    self.start_loop = true
  elseif self.once then
    self:delete()
  end

 end

 return prog
end

function _timer:delete()
  del(timers, self)
end

function make_timer(inst, paused)

 setmetatable(inst, {__index = _timer})
 add(timers, inst)

 if not paused then
  inst:start()
 end
 return inst
end

function tween_value(from, to, progress, ease)
 if ease then
  progress = ease(progress)
 end

 return from + (to - from) * progress
end

function make_tween(inst, paused)
 
 if inst.on_start then
  inst._on_start = inst.on_start
  inst.on_start = function (progress, timer)
   timer._on_start(timer.from, progress, timer)
  end
 end

 inst._on_update = inst.on_update
 inst.on_update = function (progress, timer)
   local value = tween_value(timer.from, timer.to, progress, timer.ease)
   timer._on_update(value, progress, timer)
 end

 if inst.on_complete then
  inst._on_complete = inst.on_complete
  inst.on_complete = function(progress, timer)
   timer._on_complete(timer.to, progress, timer)
  end
 end

 inst = make_timer(inst, paused)
 return inst
end

function _init()
 prop = 0

 prev_ease = quad_in

 demo_tween = make_tween({
  from = 50,
  to = 0,
  duration = 3,
  once = false,
  ease = quad_out,
  on_start = function(value, progress, timer)
   print('on_start')
  end,
  on_update = function(value, progress, timer)
   -- print('on_update')
   prop = value
  end,
  on_complete = function(value, progress, timer)
   print('on_complete')
   local to = timer.to
   timer.to = timer.from
   timer.from = to

   local prev = prev_ease
   prev_ease = timer.ease
   timer.ease = prev

   timer:start()
  end
 })

 cls()

end

function _update()
 update_timers()
end

function _draw()
 clip(64, 0, 128, 128)
 rectfill(64, 0, 128, 128, 3)
 circfill(96, 40 + prop, 20, 15)
 clip()
end
