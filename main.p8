pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
-- beeeeeees
-- by us

-- ** technical ** --
function delay(frames)
-- wait, in frames
-- 30 fps
 for x=1,frames do
  yield()
 end
end

function abs_box(o)
-- absolute box for object o
 local box = {}
 box.x1 = o.box.x1 + o.x
 box.y1 = o.box.y1 + o.y
 box.x2 = o.box.x2 + o.x
 box.y2 = o.box.y2 + o.y
 return box
end

function iou(o1,o2)
-- intersection over union of two objects
-- return percentage in [0,1], 1 is perfect match
 local box_o1 = abs_box(o1)
 local box_o2 = abs_box(o2)
 
 -- x,y coordinates of intersection
 local x1 = max(box_o1.x1,box_o2.x1)
 local y1 = max(box_o1.y1,box_o2.y1)
 local x2 = min(box_o1.x2,box_o2.x2)
 local y2 = min(box_o1.y2,box_o2.y2)
 
 -- area of intersection
 local inter_area = max(0, x2 - x1 + 1) * max(0, y2 - y1 + 1)
 
 -- area of both boxes
 local o1_area = (box_o1.x2 - box_o1.x1 + 1) * (box_o1.y2 - box_o1.y1 + 1)
 local o2_area = (box_o2.x2 - box_o2.x1 + 1) * (box_o2.y2 - box_o2.y1 + 1)

 return inter_area / (o1_area + o2_area - inter_area)
end

function debug_infos(x,y)
 print(dt.."/"..stat(7),x,y,3)
 if(btn(0)) then print("⬅️",x,y+12,3) end
 if(btn(1)) then print("➡️",x+16,y+12,3) end
 if(btn(2)) then print("⬆️",x+8,y+6,3) end
 if(btn(3)) then print("⬇️",x+8,y+12,3) end
 if(btn(4)) then print("🅾️",x+16,y+6,3) end
 if(btn(5)) then print("❎",x,y+6,3) end
 print("cur_pln:"..p.cur_pln,x,y+24,3)
 print("tot_pln:"..p.tot_pln,x,y+32,3)
end

-- ** bee - general ** --
function init_bee_base()
 p={
  name="barry",
  tot_pln=0,  -- cumulative polen
  cur_pln=0,  -- current polen
  max_pln=10,  -- max usable polen before slowdown in speed
  cur_spd=3,  -- speed
  max_spd=3,
  x=64,  -- x,y coordinate
  y=64,
  box={x1=1,y1=1,x2=14,y2=14},  -- collision box
  sp=0,  -- current sprite
  view=5,  -- current direction cf. num_pad
  action=false  -- can't move if action is true
 }
end

function draw_bee()
 spr(p.sp,p.x,p.y,2,2)
end

-- ** actual game ** --
function _init()
 dt=0
 w=128 -- width of the game map
 h=128 -- height of the game map
 
 init_bee_base()
 -- todo
 exploration_init()
end

function _update()
 -- todo
 exploration_update()
end

function _draw()
 -- todo
 exploration_draw()
 debug_infos(0,0)
end
-->8
-- exploration
-- ** exploration - initialisation ** --
function exploration_init()
 -- flowers
 flowers={}
 for i=1,rnd(10) do
  add(flowers,{
   x=rnd(100)+10,
   y=rnd(100)+10,
   box={x1=2,y1=3,x2=29,y2=29},
   sp=2+4*flr(rnd(3)),
   sp_sz=4,
   pln=flr(rnd(6))
  })
 end
 
 tlrnc=0.25  -- percentage of match between bee and flower
end

-- ** exploration - updating ** --
function update_bee()
 -- actions
 if(not p.action) then
  if(btn(0)) then p.x-=p.cur_spd end  -- left
  if(btn(1)) then p.x+=p.cur_spd end  -- right
  if(btn(2)) then p.y-=p.cur_spd end  -- up
  if(btn(3)) then p.y+=p.cur_spd end  -- down
  -- action (X) -- todo talk w/ bees
  if btnp(5) then  
   get_pln()
  end
 end
 
 -- polen
  p.cur_spd=p.max_spd-(p.cur_pln/(p.max_pln + 1))
end

function check_flower(f)
 if(iou(p,f) >= tlrnc) then
  p.cur_pln+=f.pln
  f.pln = 0
 end
end

function get_pln()
 -- todo add animation
 foreach(flowers,check_flower)
end

function exploration_update()
 -- delta time
 dt+=1
 
 update_bee()
end

-- ** exploration - drawing ** --
function draw_flower(f)
 spr(f.sp,f.x,f.y,f.sp_sz,f.sp_sz)
 if(f.pln > 0) then
  for i=1,f.pln do
   pset(f.x+4*f.sp_sz+i*.8,f.y+4*f.sp_sz+i*.7,9)
  end
 end
end

function testt(f)
 if(iou(p,f) >= tlrnc) then
  print("flower! "..iou(p,f),26,8,rnd(8))
 else
  print("bzz...",2,8,2)
 end
end

function exploration_draw()
 cls()
 foreach(flowers,draw_flower)
 draw_bee() 
end
-->8
-- story


__gfx__
999999999999999988888888888888888888888888888888ddddddddddddddddddddddddddddddddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0000000000000000
999999999999999988888888888888888888888888888888ddddddddddddddddddddddddddddddddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0000000000000000
999999999999999988888888888888888888888888888888ddddddddddddddddddddddddddddddddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0000000000000000
999999999999999988888888888888888888888888888888ddddddddddddddddddddddddddddddddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0000000000000000
999999999999999988888888888888888888888888888888ddddddddddddddddddddddddddddddddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0000000000000000
999999999999999988888888888888888888888888888888ddddddddddddddddddddddddddddddddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0000000000000000
999999999999999988888888888888888888888888888888ddddddddddddddddddddddddddddddddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0000000000000000
999999999999999988888888888888888888888888888888ddddddddddddddddddddddddddddddddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0000000000000000
999999999999999988888888888888888888888888888888ddddddddddddddddddddddddddddddddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0000000000000000
999999999999999988888888888888888888888888888888ddddddddddddddddddddddddddddddddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0000000000000000
999999999999999988888888888888888888888888888888ddddddddddddddddddddddddddddddddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0000000000000000
999999999999999988888888888888888888888888888888ddddddddddddddddddddddddddddddddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0000000000000000
999999999999999988888888888888888888888888888888ddddddddddddddddddddddddddddddddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0000000000000000
999999999999999988888888888888888888888888888888ddddddddddddddddddddddddddddddddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0000000000000000
999999999999999988888888888888888888888888888888ddddddddddddddddddddddddddddddddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0000000000000000
999999999999999988888888888888888888888888888888ddddddddddddddddddddddddddddddddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0000000000000000
000000000000000088888888888888888888888888888888ddddddddddddddddddddddddddddddddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0000000000000000
000000000000000088888888888888888888888888888888ddddddddddddddddddddddddddddddddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0000000000000000
000000000000000088888888888888888888888888888888ddddddddddddddddddddddddddddddddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0000000000000000
000000000000000088888888888888888888888888888888ddddddddddddddddddddddddddddddddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0000000000000000
000000000000000088888888888888888888888888888888ddddddddddddddddddddddddddddddddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0000000000000000
000000000000000088888888888888888888888888888888ddddddddddddddddddddddddddddddddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0000000000000000
000000000000000088888888888888888888888888888888ddddddddddddddddddddddddddddddddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0000000000000000
000000000000000088888888888888888888888888888888ddddddddddddddddddddddddddddddddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0000000000000000
000000000000000088888888888888888888888888888888ddddddddddddddddddddddddddddddddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0000000000000000
000000000000000088888888888888888888888888888888ddddddddddddddddddddddddddddddddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0000000000000000
000000000000000088888888888888888888888888888888ddddddddddddddddddddddddddddddddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0000000000000000
000000000000000088888888888888888888888888888888ddddddddddddddddddddddddddddddddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0000000000000000
000000000000000088888888888888888888888888888888ddddddddddddddddddddddddddddddddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0000000000000000
000000000000000088888888888888888888888888888888ddddddddddddddddddddddddddddddddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0000000000000000
000000000000000088888888888888888888888888888888ddddddddddddddddddddddddddddddddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0000000000000000
000000000000000088888888888888888888888888888888ddddddddddddddddddddddddddddddddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0000000000000000
__map__
0101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
