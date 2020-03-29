pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
-- beeeeeees
-- by us

-- ** technical ** --
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
 camera() -- reset camera before drawing

 if(btn(0)) then print("⬅️",x,y+6,7) end
 if(btn(1)) then print("➡️",x+16,y+6,7) end
 if(btn(2)) then print("⬆️",x+8,y,7) end
 if(btn(3)) then print("⬇️",x+8,y+6,7) end
 if(btn(4)) then print("🅾️",x+16,y,7) end
 if(btn(5)) then print("❎",x,y,7) end
 print("tmr:"..p.tmr,x,y+16,7)
 print("p.x:"..p.x,x,y+24,7)
 print("p.y:"..p.y,x,y+32,7)
end

-- ** bees - general ** --
function player_init()
 p={
  name="barry",
  tot_pln=0,  -- cumulative pollen
  cur_pln=0,  -- current pollen
  max_pln=10,  -- max usable pollen before slowdown in speed
  cur_spd=3,  -- speed
  max_spd=3,
  x=64,  -- x,y coordinate, RELATIVE TO THE SCREEN
  y=64,
  box={x1=1,y1=1,x2=14,y2=14},  -- collision box
  sp=0,  -- current sprite
  sp_st=0,  -- first sprite of the animation
  sp_sz=2,  -- sprite size
  flp_x=false,  -- should the sprite be flipped horizontally
  flp_y=false,  -- should the sprite be flipped vertically
  action=false,  -- can't move if action is true
  tmr=0  -- internal timer
 }
end

function player_draw()
 spr(p.sp,p.x,p.y,p.sp_sz,p.sp_sz,p.flp_x,p.flp_y)
end

function bees_init()
 bees={}
 add(bees,{
  name="beeatrice",  -- buzz, beenedict, beelzebub, beeyonce, obee wan, rubee, beely, kirbee, ...
  tot_pln=0,  -- cumulative pollen
  cur_pln=0,  -- current pollen
  max_pln=10,  -- max usable pollen before slowdown in speed
  cur_spd=3,  -- speed
  max_spd=3,
  x=64,  -- x,y coordinate, RELATIVE TO THE SCREEN
  y=64,
  box={x1=1,y1=1,x2=14,y2=14},  -- collision box
  sp=10,  -- current sprite
  sp_st=10,  -- first sprite of the animation
  sp_sz=2,  -- sprite size
  flp_x=false,  -- should the sprite be flipped horizontally
  flp_y=false,  -- should the sprite be flipped vertically
  action=false,  -- can't move if action is true
  tmr=0  -- internal timer
 })
 add(bees,{
  name="beertrand",  -- buzz, beenedict, beelzebub, beeyonce, obee wan, rubee, beely, kirbee, ...
  tot_pln=0,  -- cumulative pollen
  cur_pln=0,  -- current pollen
  max_pln=10,  -- max usable pollen before slowdown in speed
  cur_spd=3,  -- speed
  max_spd=3,
  x=64,  -- x,y coordinate, RELATIVE TO THE SCREEN
  y=64,
  box={x1=1,y1=1,x2=14,y2=14},  -- collision box
  sp=10,  -- current sprite
  sp_st=10,  -- first sprite of the animation
  sp_sz=2,  -- sprite size
  flp_x=false,  -- should the sprite be flipped horizontally
  flp_y=false,  -- should the sprite be flipped vertically
  action=false,  -- can't move if action is true
  tmr=0  -- internal timer
 })
 add(bees,{
  name="beenedict",  -- buzz, beenedict, beelzebub, beeyonce, obee wan, rubee, beely, kirbee, ...
  tot_pln=0,  -- cumulative pollen
  cur_pln=0,  -- current pollen
  max_pln=10,  -- max usable pollen before slowdown in speed
  cur_spd=3,  -- speed
  max_spd=3,
  x=64,  -- x,y coordinate, RELATIVE TO THE SCREEN
  y=64,
  box={x1=1,y1=1,x2=14,y2=14},  -- collision box
  sp=10,  -- current sprite
  sp_st=10,  -- first sprite of the animation
  sp_sz=2,  -- sprite size
  flp_x=false,  -- should the sprite be flipped horizontally
  flp_y=false,  -- should the sprite be flipped vertically
  action=false,  -- can't move if action is true
  tmr=0  -- internal timer
 })
end

-- ** actual game ** --
function _init()
 player_init()
 bees_init()
 
 -- text boxes
 dtb_init()
 
 menu_init()
 --story_init()
 --_update=story_update
 --_draw=story_draw
end
-->8
-- menu and intro
-- ** menu ** --
function menu_init()
 dt=0
 music(0)
 _update=menu_update
 _draw=menu_draw
end

function menu_update()
 dt+=1
 if(btnp(4)) then
  intro_init()
 end
end

function menu_draw()
 cls()
 spr(128,56,0,2,2)
 spr(130,32,16,8,2)
 print("bee-hold ,the queen",26,32,9)
 print("press 🅾️ to start",28,60,6)
 if(dt<15) then
  print("      🅾️",29,61,9)
 else
  print("      🅾️",28,60,9)
 end
 if(dt>30) then
  dt=0
 end
 print("art:",56,86,2)
 print("{heaspery,sarapeljamais}.itch.io",0,93,2)
 print("code:",54,100,2)
 print("astache.itch.io",34,107,2)
 print("music:",52,114,2)
 print("@louismerlin",40,121,2)
end

-- ** intro ** --
function intro_init()
 intro_msg_set(1)
 
 _update=nil
 _draw=intro_draw
end

function intro_draw()
 cls()
 if(intro_msg_draw(4, 4) == "empty") then
  cls()
  _update=dtb_update
  _draw=dtb_draw
  
  dtb_disp("⬅️,➡️,⬆️,⬇️:move;              ❎:action (forage, talk, ..); 🅾️:choose/end dialogue",exploration_init)
 end
end
-->8
-- exploration
-- ** exploration - initialisation ** --
function bee_exploration_init(bee)
-- each bee will start at a random position, with a random pollen quantity
 bee.x=flr(rnd(map_width-4 - p.sp_sz * 8)+4)  -- x,y coordinates
 bee.y=flr(rnd(map_height-4 - p.sp_sz * 8)+4)
 bee.cur_pln=flr(rnd(30))  -- could be improved with a nice gaussian
end

function flowers_init(nbr)
-- create a number of flowers between 1 and nbr.
 flowers={}
 
 for i=1,nbr do
  add(flowers,{
   x=flr(rnd(map_width-32)+16),  -- x,y coordinates
   y=flr(rnd(map_height-32)+10),
   box={x1=2,y1=3,x2=29,y2=29},  -- collision box
   sp=74,  -- current sprite
   sp_bs_clr=13,  -- base color, used to change the color
   sp_clr=13,--flr(rnd(4)+13),  -- final color
   sp_sz=4,  -- sprite size
   pln=flr(rnd(6))  -- pollen quantity
  })
 end
end

function hive_init()
-- put the ruche in a random place
-- yes i know it's hive in english gimme a break
 hive={
  x=flr(rnd(map_width/3)+map_width/3),  -- x,y coordinates
  y=flr(rnd(map_height/3)+map_height/3),
  box={x1=10,y1=14,x2=18,y2=22},  -- collision box, centered on the door
  sp=70,  -- current sprite
  sp_sz=4,  -- sprite size
  pln=0  -- pollen quantity
 }
end

function exploration_init()
 -- map
 map_width=128*3
 map_height=128*3
 
 -- flowers
 flowers_init(15)
 
 -- hive
 hive_init()

 -- reset internal timer and set first sprite
 p.sp_st=0
 p.tmr=0
 
 -- player starts at the hive
 p.x=hive.x+hive.sp_sz*4
 p.y=hive.y+hive.sp_sz*4
 
 -- other bees start wherever
 foreach(bees,bee_exploration_init)
 
 -- camera coordinates for the map
 cam_x=p.x-64
 cam_y=p.y-64
 
 -- percentage of match between two objects if collision
 tlrnc=0.10
 
 -- reset internal timer
 p.tmr=0
 
 _update=exploration_update
 _draw=exploration_draw
end

-- ** exploration - updating ** --
function player_exploration_update()
 p.tmr+=1  -- internal timer. 30fps
 
 if(not p.action) then
  -- check for bees: save current position
  local px = p.x
  local py = p.y
 
  -- animation
  if(p.tmr == 10) then
   p.sp = p.sp_st
  end
  if(p.tmr >= 20) then
   p.sp += p.sp_sz
   p.tmr = 0  -- restart timer
  end
  
  -- actions
  -- left
  if(btn(0)) then
   p.sp_st=32
   p.flp_x=true
   
   if(cam_x > 0 and p.x-cam_x<64) then
    cam_x-=p.cur_spd
    p.x-=p.cur_spd
   else
    if(p.x > 4) then
     p.x-=p.cur_spd
    end
   end
  end
  
  -- right
  if(btn(1)) then
   p.sp_st=32
   p.flp_x=false
   
   if(cam_x < map_width-128 and p.x-cam_x>64) then
    cam_x+=p.cur_spd
    p.x+=p.cur_spd
   else
    if(p.x < map_width-4 - p.sp_sz * 8) then
     p.x+=p.cur_spd
    end
   end
  end
  
  -- up
  if(btn(2)) then
   p.sp_st=0
   p.flp_y=false
   
   if(cam_y > 0 and p.y-cam_y<64) then
    cam_y-=p.cur_spd
    p.y-=p.cur_spd
   else
    if(p.y > 4) then
     p.y-=p.cur_spd
    end
   end
  end
  
  -- down
  if(btn(3)) then
   p.sp_st=0
   p.flp_y=true
   
   if(cam_y < map_height-128 and p.y-cam_y>64) then
    cam_y+=p.cur_spd
    p.y+=p.cur_spd
   else
    if(p.y < map_height-4 - p.sp_sz * 8) then
     p.y+=p.cur_spd
    end
   end
  end
  
  -- action (X) -- todo talk w/ bees
  if(btnp(5)) then
   p.action=true  -- lock the player
   p.tmr = 0  -- restart timer
  end
  
  -- check for bees: if there is a bee, then...
  for b in all(bees) do
   if(check_collision_bee(b)) then
    -- back to old position
    p.x=px
    p.y=py
   end
  end
 else
  -- shall we talk?
  local talk=false
  for b in all(bees) do
   b.box.x1-=5
   b.box.y1-=5
   b.box.x2+=5
   b.box.y2+=5
   
   if(check_collision_bee(b)) then
    talk=true
    talk_to_bee(b)
   end
   
   b.box.x1+=5
   b.box.y1+=5
   b.box.x2-=5
   b.box.y2-=5
  end
  if(not talk) then
   get_down()
  end
 end
 
 -- pollen
  p.cur_spd=p.max_spd-flr(p.cur_pln/(p.max_pln + 1))
end

bees_hello = {"hey!","greetings.","hi!","howdy!","bonjour!","good day."}
bees_ok = {"all is right!","you okay?","i'm fine!","all the best for you.","all hail the queen!","la probabilité de voir ce message est de 0.005%."}
bees_ciao = {"see you!","ciao!","au revoir.","see you soon!","thanks."}

function talk_to_bee(bee)
 dtb_disp(bee.name..": "..bees_hello[1+flr(rnd(#bees_hello))])
 if(bee.cur_pln > bee.max_pln) then
  dtb_disp(bee.name..": i have too much pollen!")
  dtb_disp(bee.name..": can you take me some?")
  if(p.cur_pln<p.max_pln) then
   local qt=min(p.max_pln-p.cur_pln,bee.cur_pln-bee.max_pln)
   bee.cur_pln-=qt
   p.cur_pln+=qt
  end
 else
  if(bee.cur_pln < bee.max_pln) then
   dtb_disp(bee.name..": i don't have enough pollen...")
   dtb_disp(bee.name..": do you have any?")
  if(p.cur_pln>0) then
   local qt=min(p.cur_pln,bee.max_pln-bee.cur_pln)
   bee.cur_pln+=qt
   p.cur_pln-=qt
  end
  else
   dtb_disp(bee.name..": "..bees_ok[1+flr(rnd(#bees_ok))])
  end
 end
 dtb_disp(bee.name..": "..bees_ciao[1+flr(rnd(#bees_ciao))])
 p.action=false
end

function choice_take()
 p.action=false
end

function get_down()
-- basically an animation with black magic...
 if(p.tmr == 15) then
  sfx(13)
  p.sp = p.sp_st + 2 * p.sp_sz
 end
 if(p.tmr == 30) then
  p.sp += p.sp_sz
 end
 if(p.tmr == 45) then
  p.sp += p.sp_sz
 end
 if(p.tmr == 75) then
  -- first try to get into hive
  if(not get_into_hive()) then
   -- if not into hive, try to collect pollen
   for f in all(flowers) do
    if(check_flower(f)) then
     -- todo break, idk how to do that
    end
   end
  end
 end
 if(p.tmr == 120) then
  p.sp -= p.sp_sz
 end
 if(p.tmr == 135) then
  p.sp -= p.sp_sz
 end
 if(p.tmr == 150) then
  p.sp -= p.sp_sz
  p.action=false
 end
end

function check_collision_bee(bee)
 if(iou(p,bee) >= .1*tlrnc) then
  return true
 else
  return false
 end
end

function get_into_hive()
 if(iou(p,hive) >= 2*tlrnc) then
  story_init()
  return true
 else
  return false
 end
end

function check_flower(f)
 if(iou(p,f) >= tlrnc) then
  p.cur_pln+=f.pln
  f.pln = 0
  return true
 else
  return false
 end
end

function bee_exploration_update(bee)
 -- todo random mouvement
 -- animation
 -- internal timer
 bee.tmr+=1
 if(bee.tmr == 10) then
  bee.sp = bee.sp_st
 end
 if(bee.tmr >= 20) then
  bee.sp += bee.sp_sz
  bee.tmr = 0  -- restart timer
 end
end

function exploration_update()
 player_exploration_update()
 foreach(bees,bee_exploration_update)
 
 -- text boxes
 dtb_update()
end

-- ** exploration - drawing ** --
function bee_draw(bee)
 spr(bee.sp,bee.x,bee.y,bee.sp_sz,bee.sp_sz,bee.flp_x,bee.flp_y)
end

function hive_draw()
 spr(hive.sp,hive.x,hive.y,hive.sp_sz,hive.sp_sz)
end

function flower_draw(f)
 -- general flower color
 pal(f.sp_bs_clr,f.sp_clr)
 
 -- if the flower is empty, the pistil is not shown
 if(f.pln == 0) then
  pal(9,1)
 end
 -- the actual flower
 spr(f.sp,f.x,f.y,f.sp_sz,f.sp_sz)
 pal() 
 if(f.pln > 0) then
  for i=1,f.pln do
   -- beautiful pollen bits...
   modificator_x=(6+(i*17))%(f.sp_sz*8)
   modificator_y=(7+(i*41))%(f.sp_sz*8)
   
   pset(f.x+modificator_x,f.y+modificator_y,9)
   pset(1+f.x+modificator_x,f.y+modificator_y,9)
   pset(f.x+modificator_x,1+f.y+modificator_y,9)
   pset(1+f.x+modificator_x,1+f.y+modificator_y,9)
  end
 end
end

function exploration_draw()
 -- first reset the fucker
 cls()
 
 -- set the camera to the current location
 camera(cam_x, cam_y)
 
 -- draw the entire map
 for i=0,map_width/16 do
  for j=0,map_width/16 do
   map(24, 0, 16*i, 16*j, 2, 2)
  end
 end
 
 -- hive
 hive_draw()
 
 -- flowers
 foreach(flowers,flower_draw)
 
 -- bees
 foreach(bees,bee_draw)
 
 -- player
 player_draw()
 
 -- reset camera
 camera()
  
 -- pollen
 draw_pollen_sphere(2,1,p.cur_pln,p.max_pln)
 
 -- textboxes
 dtb_draw()
end

function draw_pollen_sphere(x,y,curr,maxx)
 if(curr < 0.25*maxx) then
  palt(9,true)
 else
  palt(9,false)
 end
 spr(84,x,y+8,2,1)
 if(curr < 0.75*maxx) then
  palt(9,true)
 else
  palt(9,false)
 end
 spr(68,x,y,2,1)
 palt(9,false)
end
-->8
-- story
-- ** story initialisation ** --
function story_init()
 -- map
 map_width=128*1.5
 map_height=128
 
 -- camera coordinates for the map
 cam_x=0
 cam_y=0

 -- reset internal timer and set first sprite
 p.flp_x=false
 p.flp_y=false
 p.sp_st=14
 p.tmr=0
 
 -- start position
 p.x=0
 p.y=74
 
 -- pollen!
 -- player
 p.tot_pln+=p.cur_pln
 hive.pln+=p.cur_pln
 p.cur_pln=0
 
 -- bees
 for b in all(bees) do
  if(b.cur_pln > b.max_pln) then
   -- the bee did not get here...
   b.cur_pln=0
  end
  b.tot_pln+=b.cur_pln
  hive.pln+=b.cur_pln
  b.cur_pln=0
 end
 
 queen_status()
 
 _update=story_update
 _draw=story_draw
end

function queen_status()
 if(hive.pln<20) then
  dtb_disp("the queen seems to be in really bad shape...")
  dtb_disp("we need to forage more!")
 end
 if(hive.pln>=20 and hive.pln<40) then
  dtb_disp("the bees went back to work.")
  dtb_disp("maybe there is hope.")
 end
 if(hive.pln>=40 and hive.pln<60) then
  dtb_disp("we're going to make it... probably!")
 end
 if(hive.pln>=60 and hive.pln<80) then
  dtb_disp("more pollen, more pollen...")
 end
 if(hive.pln>=80) then
  dtb_disp("the queen is back! hooray")
 end
end

-- ** story updating ** --
function player_story_update()
 p.tmr+=1  -- internal timer. 30fps
 
 -- animation
 if(p.tmr == 10) then
  p.sp = p.sp_st
 end
 if(p.tmr >= 20) then
  p.sp = 46
  p.tmr = 0  -- restart timer
 end
 
 -- actions
 -- left
 if(btn(0)) then
  p.flp_x=true
  
  if(cam_x > 0 and p.x-cam_x<64) then
   cam_x-=p.cur_spd
   p.x-=p.cur_spd
  else
   p.x-=p.cur_spd
   if(p.x < -8) then
    exploration_init()
   end
  end
 end
 
 -- right
 if(btn(1)) then
  p.flp_x=false
 
  if(cam_x < map_width-128 and p.x-cam_x>64) then
   cam_x+=p.cur_spd
   p.x+=p.cur_spd
  else
   if(p.x < map_width-4 - p.sp_sz * 8) then
    p.x+=p.cur_spd
   end
  end
 end
 
 -- action (X) -- todo talk w/ bees
 if btnp(5) then
  --p.action=true  -- lock the player
  p.tmr = 0  -- restart timer
 end

 -- pollen
  p.cur_spd=p.max_spd-flr(p.cur_pln/(p.max_pln + 1))
end

function story_update()
 player_story_update()
 
 -- text boxes
 dtb_update()
end

-- ** story drawing ** --
function story_draw()
 cls()
 
 -- set the camera to the current location
 camera(cam_x, cam_y)
 
 -- draw the entire map -- todo
 map(0, 0, 0, 0, 32, 16)
 
  -- bee
 player_draw()
 
 -- pollen...
 draw_pollen_sphere(17,38,min(hive.pln,20),20)
 draw_pollen_sphere(33,6,min(hive.pln,40),40)
 draw_pollen_sphere(65,38,min(hive.pln,60),60)
 draw_pollen_sphere(113,38,min(hive.pln,80),80)
 draw_pollen_sphere(129,6,min(hive.pln,100),100)
 
 -- reset camera
 camera()
 
 -- text boxes
 dtb_draw()
end
-->8
-- textboxes
-- code courtesy of oli414/bbs

-- call this before you start using dtb.
-- optional parameter is the number of lines that are displayed. default is 3.
function dtb_init(numlines)
 dtb_queu={}
 dtb_queuf={}
 dtb_numlines=3
 if numlines then
  dtb_numlines=numlines
 end
 _dtb_clean()
end

-- this will add a piece of text to the queu. the queu is processed automatically.
function dtb_disp(txt,callback)
 local lines={}
 local currline=""
 local curword=""
 local curchar=""
 local upt=function()
  if #curword+#currline>29 then
   add(lines,currline)
   currline=""
  end
  currline=currline..curword
  curword=""
 end
 for i=1,#txt do
  curchar=sub(txt,i,i)
  curword=curword..curchar
  if curchar==" " then
   upt()
  elseif #curword>28 then
   curword=curword.."-"
   upt()
  end
 end
 upt()
 if currline~="" then
  add(lines,currline)
 end
 add(dtb_queu,lines)
 if callback==nil then
  callback=0
 end
 add(dtb_queuf,callback)
end

-- functions with an underscore prefix are ment for internal use, don't worry about them.
function _dtb_clean()
 dtb_dislines={}
 for i=1,dtb_numlines do
  add(dtb_dislines,"")
 end
 dtb_curline=0
 dtb_ltime=0
end

function _dtb_nextline()
 dtb_curline+=1
 for i=1,#dtb_dislines-1 do
  dtb_dislines[i]=dtb_dislines[i+1]
 end
 dtb_dislines[#dtb_dislines]=""
 sfx(2)
end

function _dtb_nexttext()
 if dtb_queuf[1]~=0 then
  dtb_queuf[1]()
 end
 del(dtb_queuf,dtb_queuf[1])
 del(dtb_queu,dtb_queu[1])
 _dtb_clean()
 sfx(2)
end

-- make sure that this function is called each update.
function dtb_update()
 if #dtb_queu>0 then
  if dtb_curline==0 then
   dtb_curline=1
  end
  local dislineslength=#dtb_dislines
  local curlines=dtb_queu[1]
  local curlinelength=#dtb_dislines[dislineslength]
  local complete=curlinelength>=#curlines[dtb_curline]
  if complete and dtb_curline>=#curlines then
   if btnp(4) then
    _dtb_nexttext()
    return
   end
  elseif dtb_curline>0 then
   dtb_ltime-=1
   if not complete then
    if dtb_ltime<=0 then
     local curchari=curlinelength+1
     local curchar=sub(curlines[dtb_curline],curchari,curchari)
     dtb_ltime=1
     if curchar~=" " then
      sfx(0)
     end
     if curchar=="." then
      dtb_ltime=6
     end
     dtb_dislines[dislineslength]=dtb_dislines[dislineslength]..curchar
    end
    if btnp(4) then
     dtb_dislines[dislineslength]=curlines[dtb_curline]
    end
   else
    --if btnp(4) then
     _dtb_nextline()
    --end
   end
  end
 end
end

-- make sure to call this function everytime you draw.
function dtb_draw()
 -- reset camera
 camera()
 
 if #dtb_queu>0 then
  local dislineslength=#dtb_dislines
  local offset=0
  if dtb_curline<dislineslength then
   offset=dislineslength-dtb_curline
  end
  rectfill(2,125-dislineslength*8,125,125,0)
  if dtb_curline>0 and #dtb_dislines[#dtb_dislines]==#dtb_queu[1][dtb_curline] then
   print("\x8e",118,120,1)
  end
  for i=1,dislineslength do
   print(dtb_dislines[i],4,i*8+119-(dislineslength+offset)*8,7)
  end
 end
 
 -- camera is back
 camera(cam_x, cam_y)
end
-->8
-- introduction
-- code courtesy of shooting★/bbs

--★ is used as my signature.
--[[
  text codes:
  
  $u1 = underline text (0 for
         no underline)
         
  $b## = border color, ##= a
         number, 0-15
         
  $o## = outline color
  
  $c## = text color
  
  $d## = delay extra (0-99)
         if more delay is
         needed, use $f##
         and create a custom
         fx for it.
         
  $f## = special effects
  
  for any of these, you can use
  xx instead of a number to
  reset it to default (based
  on the default config you
  have set up)
  
  alternatively, you can use
  16 to set it to nil and
  remove it.
]]--
  --==configurations==--
  
  --[[
   configure your defaults
   here
  --]]
★intro_msg_cnf = {
 --default color 1
 15,
 --default highlight 2
 nil,
 --default outline 3
 1,
 --letter spacing 4
 4,
 --new line spacing 5
 7,
 --blip sound 6
 14,
 --next msg sound 7
 13,
 
 ---------------------
 
 --skip text/fast finish
 --button 8
 4,
 --next action character
 '🅾️',
 --next action character color
 9
}

  --[[
   standard variables,dont edit
  --]]
★intro_msg_i=1
★intro_msg_t=0
★intro_msg_del=1
★intro_msg_cur=1
  --==edit special fx here==--
  --[[
   special effects can be
   applied to all text after
   the fx code: $fid
   
   where id=a number starting
   with 1. in this sample,
   $f01 gives a wavy text
   effect. its auto-indexed,
   so make sure you comment
   similar to what i did
   to avoid confusion.
   
   self values:
    _dx (draw x)
    _dy (draw y)
    _fxv (fx value)
    _c (color)
    c (character)
    _b (border color, nil for
        none)
    _o (outline color, nil for
        none)
    _img (image index from
          sprite list)
    _upd (function, dont mod
          this)
    _id  (index id of the 
          character)
  --]]
★intro_msg_fx = {
 --$f01
 function(i, fxv)
  --floaty effect
  --[[
   first, we get the self
   value (i) by using
   local self=★intro_msg_str[i].
   
   self._fxv = fx value
   self._dy = draw y, adds
   to the already rendering
   y position.
  --]]
  local self=★intro_msg_str[i]
  self._dy=sin(self._fxv+fxv)
  self._fxv+=0.05
 end,
 --$f02
 function(i, fxv)
  --floaty effect 2
  --[[
   this time with random x
   locations.
  --]]
  local self=★intro_msg_str[i]
  self._dy=sin(self._fxv+fxv)
  self._dx=rnd(4)-rnd(2)
  self._fxv+=0.05
 end
 
}

  --[[
   store your messages here
   in this variable. make sure
   to comment the number to 
   avoid confusion. empty text
   will end the text
   displaying. when you press
   the configured 'next' key,
   it auto-continues to the
   next string.
  --]]
★intro_msg_ary={
 -- keep first line whitespace to start the fucker.
 -- keep the last line empty to end the fucker.
 -- last character is discarded
 ' ',
 'the $c09queen$cxx is $c09ill$cxx. ',
 'recent $c09pollen$cxx harvests have   \n not been very successful, and \n it is the main source of      \n $c09energy$cxx for the entire $c09hive$cxx. ',
 'the $c09queen$cxx is the personifica- \n tion of the health of the\n $c09hive$cxx. if the $c09hive$cxx falls,\n so does the $c09queen$cxx. ',
 'as a faithful member of the   \n $c09hive$cxx - your home - it is your  \n duty to collect $c09pollen$cxx, with   \n the help of your companions.\n give it enough resources and\n $c09energy$cxx to survive for years\n to come. ',
 'good thing, the $c09flowers$cxx came  \n back. go, collect the $c09pollen$cxx   \n from the $c09flowers$cxx, and bring\n it back to the $c09hive$cxx. only the\n work of all the bees can save\n the $c09hive$cxx! ',
 ''
 --'$c09welcome$cxx to the introduction!',
 --'you can draw sprites\n$i01   like this, and you can\n\nadd a delay$d04...$dxxlike this!',
 --'looking for $d08$f01spooky$fxx$dxx effects?$d30\n$dxxhmm, how about some\n$oxx$o16$c01$b10highlighting$bxx',
 --'$o16$u1underlining?$u0$d30$oxx $dxx geeze, you\'re\na $f02hard one to please!',
 --''
}

 --string storage--
★intro_msg_str={}

 --function to set message
 --id=index in ★intro_msg_ary
function intro_msg_set(id)
 --sine variable
 ★intro_msg_sin=0
 ★intro_msg_cur=id
 --reset message string
 ★intro_msg_str={}
 --reset index counter
 ★intro_msg_i=1
 local __id=0
 for i=1,#★intro_msg_ary[id] do
  --add characters
  add(★intro_msg_str, {
   --character
   c=sub(★intro_msg_ary[id], i, i),
   --color
   _c=★intro_msg_cnf[1],
   --bg color
   _b=★intro_msg_cnf[2],
   --outline color
   _o=★intro_msg_cnf[3],
   --draw_x and draw_y
   _dx=0,
   _dy=0,
   --fx value
   _fxv=0,
   --image to draw
   _img=nil,
   --extra delay
   _del=0,
   
   --update function for fx
   _upd=function() end,
   _id=__id
  })
  __id+=1
 end
 msgparse()
end

--parse entire message :u
function msgparse()
 for i=1,#★intro_msg_str do
  if not ★intro_msg_str[i+1] then return "msgparse" end
  local t=★intro_msg_str[i].c
  local c=★intro_msg_str[i+1].c
  if t=='$' and (c=='c' or c=='b' or c=='f' or c=='d' or c=='o' or c=='i') then
   ★intro_msg_str[i].skp=true
   ★intro_msg_str[i+1].skp=true
   ★intro_msg_str[i+2].skp=true
   ★intro_msg_str[i+3].skp=true
   local val=tonum(★intro_msg_str[i+2].c..★intro_msg_str[i+3].c)
   for j=i,#★intro_msg_str do
    if c=='c' then
     ★intro_msg_str[j]._c=val or ★intro_msg_cnf[1]
    end
    if c=='b' then
     ★intro_msg_str[j]._b=val or nil
    end
    if c=='f' then
     ★intro_msg_str[j]._upd=★intro_msg_fx[val] or function() end
    end
    if c=='d' then
     ★intro_msg_str[j]._del=val or 0
    end
    if c=='o' then
     ★intro_msg_str[j]._o=val or ★intro_msg_cnf[3]
    end
    if c=='i' then
     ★intro_msg_str[i+4]._img=val or nil
    end
   end
  end
  
  
  if t=='$' and c=='u' then
   ★intro_msg_str[i].skp=true
   ★intro_msg_str[i+1].skp=true
   ★intro_msg_str[i+2].skp=true
   for j=i,#★intro_msg_str do
    ★intro_msg_str[j]._un=tonum(★intro_msg_str[i+2].c) or 0
   end
  end
 end
end
 --function to draw msg
function intro_msg_draw(x, y)
 --return if text is empty
 if ★intro_msg_ary[★intro_msg_cur] == '' then return "empty" end
 --set a btnp value
 if not btn(★intro_msg_cnf[8]) then ★intro_msg_btnp=false end
 --loop...
 while ★intro_msg_i<#★intro_msg_str do
  --idk why you're trying to
  --read this
  if btnp(★intro_msg_cnf[8]) then
   ★intro_msg_i=#★intro_msg_str-1
   ★intro_msg_btnp=true
  end
  --like seriously, its just
  --vital function stuff.
  ★intro_msg_t+=1
  if ★intro_msg_str[★intro_msg_i].skp then ★intro_msg_i+=1 end
  if ★intro_msg_t>=★intro_msg_del+★intro_msg_str[★intro_msg_i]._del then
   ★intro_msg_i+=1
   sfx(14)
   ★intro_msg_t=0
  end
  break;
 end
  --i mean, hey... if you want
  --to keep reading, go ahead.
 local i=1
 local _x=0
 local _y=0
 while i<★intro_msg_i do
  if not ★intro_msg_str[i] then return "no intro" end
  if not ★intro_msg_str[i].skp then
  --i wont try and stop you. 
   _x+=★intro_msg_cnf[4]
   if ★intro_msg_str[i]._b and ★intro_msg_str[i]._b != 16 then
    rectfill(x+_x, y+_y-1, x+_x+★intro_msg_cnf[4], y+_y+5, ★intro_msg_str[i]._b)
   end
   
   if ★intro_msg_str[i]._img then
    spr(★intro_msg_str[i]._img, x+_x+★intro_msg_str[i]._dx, y+★intro_msg_str[i]._dy+_y)
   end
   --you're probably getting
   --bored now, right?
   if ★intro_msg_str[i]._o and ★intro_msg_str[i]._o != 16 then
    local __x=x+_x+★intro_msg_str[i]._dx
    local __y=y+★intro_msg_str[i]._dy+_y
    for i4=1,3 do
     for j4=1,3 do
      print(★intro_msg_str[i].c, __x-2+i4, __y-2+j4, ★intro_msg_str[i]._o)
     end
    end
   end
   
   --yep, not much here...
   print(★intro_msg_str[i].c, x+_x+★intro_msg_str[i]._dx, y+★intro_msg_str[i]._dy+_y, ★intro_msg_str[i]._c)
   if ★intro_msg_str[i]._un == 1 then
    line(x+_x, y+_y+5, x+_x+★intro_msg_cnf[4], y+_y+5)
   end
   
   if ★intro_msg_str[i].c == '\n' then
    _x=0
    _y+=★intro_msg_cnf[5]
   end
  else
   --why am ☉ even trying
   --to get you to not read it?
  end
  i+=1
 end
 
 if ★intro_msg_i>=#★intro_msg_str then
  --print(★intro_msg_cnf[9], x+★intro_msg_cnf[4]+_x+cos(★intro_msg_sin), y+_y+sin(★intro_msg_sin), ★intro_msg_cnf[10])
  ★intro_msg_sin+=0.05
  if btnp(★intro_msg_cnf[8]) and ★intro_msg_btnp != true then
   sfx(20) -- not defined hehe
   ★intro_msg_cur+=1
   intro_msg_set(★intro_msg_cur)
  end
 end
  --i mean, its not like
  --i care.
 for ii=1,#★intro_msg_str do
  ★intro_msg_str[ii]._upd(ii, ii/3)
 end
 
 --enjoy the script :)--
end
__gfx__
0000000000000000000000999000000000000000000000000000000000000000000000000000000000000000000000000000009990d000000000000000000000
0000009990000000000009191900000000000000000000000000000000000000000000000000000000000099900d000000000d1d1d0000000000067706700000
0000091919000000000002222200000000000019100000000000000000000000000000000000000000000d1d1dd000000000099999d0000000000d6776770000
00000222220000000007776d6777000000000022200000000000001910000000000000000000000000000999990d000000077766677d000000000d6677670000
0000776d67700000007776d2d67770000000006d600000000000007d700000000000001910000000000077666770d0000077766966777000000000d677670000
000776d2d677000007766d999d677700000076d2d6700000000007d2d700000000000072700000000007766966770000077666ddd66677000000222d67670000
007776d9d67770000766d22222d6670000076d999d67000000007d999d7000000000076967000000007766ddd6677000066677696776660000022929d6260000
00776d222d67700006dd9999999dd6000066d22222d660000000d22222d00000000006222600000007766769676677000007766d66770000001929292d299900
0076d99999d6700000002222222000000000099999000000000000999000000000000099900000000766776d6776670000776699966770001119292929299190
006dd22222dd60000000999999900000000002222200000000000022200000000000000100000000066776696677660000666ddddd6660000019292929299990
00009999999000000000222222200000000009999900000000000001000000000000000000000000000766ddd667000000009999999000000002292929299900
00002222222000000000099999000000000000222000000000000000000000000000000000000000000669999966000000000ddddd0000000000292922000000
0000099999000000000000111000000000000001000000000000000000000000000000000000000000000ddddd00000000000011100000000000000000000000
00000011100000000000000100000000000000010000000000000000000000000000000000000000000000111000000000000001000000000000000000000000
00000001000000000000000100000000000000000000000000000000000000000000000000000000000000010000000000000001000000000000000000000000
00000001000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000067700000000000000000000000000000000000000000000000000000000000677000000000000000067000000000000000000000
000000677700000000000000d6770000000000006000000000000000000000000000000000000000000000667700000000000067067700000000067007700000
000000d67770000000000000d6677000000000006700000000000000000000000000000000000000000067766770000000000067766770000000d67767770000
000029dd67770000000002929d67700000000000d670000000000000d70000000000000000000000000066776677000000000966776770000000d67776770000
00092929d66729000000929292d67290000009292d600000000000002d7000000000000067000000000d966776679d000000d9d6676679d000000d6776770000
001929292dd6219000019292929d62190000292929d621000000002929d710000000000926710000001d9d666d6691900001d9d966d66919000022d676670000
11192929292d2990011192929292d29900112929292d290000000129292d90000000001929290000111d9d9d9d969d900111d9d9d9d969d90002292d67260000
001929292dd6219000019292929d62190000292929d621000000002929d710000000000926710000001d9d666d6691900001d9d966d6691900192929d6299900
00092929d66729000000929292d67290000009292d600000000000002d7000000000000067000000000d966776679d000000d9d6676679d0111929292d299190
000029dd67770000000002929d67700000000000d670000000000000d700000000000000000000000000667766770d000000096677677d0d0019292929299990
000000d67770000000000000d6777000000000006700000000000000000000000000000000000000000067766770d0d0000000677667d0000002292929299900
000000677700000000000000d677000000000000600000000000000000000000000000000000000000000066770d000000000067067700000000292922000000
00000000000000000000000067700000000000000000000000000000000000000000000000000000000000677000000000000000067000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001111111997111111
00300000300000000000900d0d000000000000000000000000000000000000000000000000000000000000777777700000007777777000001111111997111111
00090900000000000000000ddd000090000000000000000000000000000222222222200000000000000007776777610000667777777700001111111997111111
0d09990d000000000900009199090000000000999900000000000000002222222222220000000000000007776677611000677776677700001111111997711111
003133000d00000000000099990000000000099977900000000000002229999999999222000000000000077771177d10011676d1177600001111119999977111
303333177000d200000900099900d2000000999997790000000000226666666666666666200000000000066677d11d111116dd17776600001111999999999771
000333167770d20000000002677dd200000299999977900000000222222222222222222222200000000001dd677d1d222211d117776600001119999119999997
d000113d6777d20000000099d677d2000002999999979000000029999999999999999999999200000000011dd66d127777221167766600001999911111199999
0030333d6677720009090022d677720000029999999990000002666666666666666666666666200000000011dddd279999721d66661000009991111111111999
00001111d6677200000000999d677709000229999999900000022222222222222222222222222000000000011dd2299999922dddd11000009711111111111119
000003333d6662000000002222d66600000022999999000000029999999999999999999999992000000000661112999999992ddd110000009711111111111119
0000001111ddd20000000099999ddd000000022999900000000266666666666666666666666620000000777666d2999999992111166777009711111111111119
000000233330d200000000122222d2000000002222000000000222222222222222222222222220007777776666d2299999922dd6666777779711111111111119
0000022dddddd2000000011dddddd2000000000000000000000299999999999999999999999920007777776ddddd22999922ddddd66667779711111111111119
0000020dddddd2000000010dddddd200000000000000000000026666666666666666666666662000666711111111292222921111111116779711111111111119
0000020222222200000001022222220000000000000000000002222222222222222222222222200011666666dddd22999922dddd666666719711111111111119
00000000000000000000000000000000111122222222271100029999999999999999999999992000011d66666ddd12222221ddd6666666119711111111111119
000000000000000000000000000000001112111111112271000266666666666666666666666620000011dddddddd11222211ddddddddd1109711111111111119
00000000000000000000000000000000112111111111127100022222222222222222222222222000000111dd11111111111111111dd111009711111111111119
00000000000000000000000000000000112111111111127100029999999999999999999999992000000001111dddd1dd1dd1dddd111100009711111111111119
0000000000000000000000000000000011219711111112710002999999996222222699999999200000000066677d1ddd1ddd1776610000009711111111111119
00000000000000000000000000000000112999997199127100029999999962111126999999992000000006666761666d1d666177666000009711111111111119
0000000000000000000000000000000077777777777777770002999999996211112699999999200000000666761776dd1d677617766700009977711111111199
0000000000000000000000000000000022222222222222220002999999996211112699999999200000000767717776d111667761777700001999771111119991
d666666700000000d66666666666666711111111111111110002999999996211112699999999200000000777767766d101167776677700001199997111199911
2d666676000000002d666666666666761111222222222271000299999999621111269999999920000000077777776d1100666777777700001111999779991111
22dddd660000000022dddddddddddd66111222222222227100029999999962111126999999992000000007777776611000666677777700001111119999911111
22dddd660000000022dddddddddddd66112222222222227100029999999962111126999999992000000000777776100000006677777700001111111999111111
22dddd660000000022dddddddddddd66112222222222277100022999999962111126999999922000000000000000000000000000000000001111111997111111
22dddd660000000022dddddddddddd66112222222222271100002299999962111126999999220000000000000000000000000000000000001111111997111111
2d3333d6000000002d333333333333d6111222222222271100000222299962111126999992200000000000000000000000000000000000001111111997111111
d333333d00000000d33333333333333d111222222222771100000022222222222222222222000000000000000000000000000000000000001111111997111111
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003333333333333333
09900000000009900000000000000000000000000000000000000000000000000000000000000000007700000000000000000000000000003313d3333dd3dd33
09920000000029901222222220012222222001222222200122222222001222222220012222222200077700000000000000000000000000003333333333313d33
0002200000022000229777772212d977772212d977772212d9777772212d9777772212d977777220777777770000000000000000000000003333373333313331
00002200002200002d9222297212d999997212d999997212d9999997212d9999997212d999999720777777770000000000000000000000003d33797333333333
00000999999000002d9201297212d999972212d999972212d9999972212d9999972212d99999722007770000000000000000000000000000313dd73333333d31
00009999999900002d9222297212d922222112d92222711222229972012222299720122222997200007700000000000000000000000000003333333313333333
00099999999990002d9999972212d977772212d977772211112d9722001112d9722001112d972200000000000000000000000000000000003333333333333333
00999999999999002d9999222012d999997212d99999721012d9722000012d9722000012d97220000000000000000000000000000000000033133dd333333333
00990799990799002d9777772212d999972212d9999722112d9720000012d9720000012d97200000000000000000000000000000000000003d133333333d3333
00920099990029002d9222297212d922222112d922222112d9722222012d9722222012d972222200000000000000000000000000000000003333333333373333
00922990099229002d9201297212d977772212d977772212d9977772212d9977772212d997777220000000000000000000000000000000003333333333797333
00999999999999002d9222297212d999997212d999997212d9999997212d9999997212d99999972000000000000000000000000000000000311331d3333733d3
0009999999999000229999972212d999972212d999972212d9999972212d9999972212d999997220000000000000000000000000000000003333333333333333
00009999999900001222222220012222222111222222200122222222001222222220012222222200000000000000000000000000000000003d333333333d3133
00000999999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003333313333333333
__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003030303000000000000000000000000030303030000000000000000000000000101010100000000000000000000000001010101000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
4e4f64654e4f4e4f4e4f4e4f4e4f4e4f4e4f4e4f4e4f4e4f8e8f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5e5f74755e5f5e5f5e5f5e5f5e5f5e5f5e5f5e5f5e5f5e5f9e9f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6e707072736f6e6f6e6f6e6f6e6f6e6f6e6f6e64656f6e6f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7e7f707072737e72737f7e72737f7e7f7e7f7e74757f7e7f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4e4f4e4f4e727370727372734e64654f4e4f7273707273700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
705f5e5f5e64655f5e5f5e5f5e74757273707273727372730000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
70706e6f6e74756f6e6f6e727372737072737072736f6e6f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7070707f7e70707f7e7f72737e7f7e7f7e7070707e7f7e7f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4e4f4e4f707072734e4f4e4f4e4f4e4f4e4f704f4e4f40410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
8a5f5e5f5e5f5e5f64655e5f5e5f5e5f5e5f5e5f5e5f50510000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6e6f6e6f6e6f6e6f74756e6f6e6f6e6f6e6f6e6f6e7072730000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7273727370707273707072737273707273707273727372730000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5455545554555455545554555455545554555455545554555455545554555455545554555455545554555455545554550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
011000000063300000000000000000000000001863300000006330000000000000001863300000000000000000633000001863300000000000000000000000000063300000000000000000000000001863300000
011000001803418030180301803018030180301803018035000000000000000000000000000000000000000023534235302353023530235302353023530235351f5341f5301f5301f5301f5301f5301f5301f535
011000001c0341c0301c0301c0301c0301c0301c0301c035000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01100000240342403024030240302403024030240302403500000000000000000000000000000000000000001f5341f5301f5301f5301f5301f5301f5301f5351c5341c5301c5301c5301c5301c5301c5301c535
011000001a0341a0301a0301a0301a0301a0301a0301a035000000000000000000000000000000000000000021534215302153021530215302153021530215351d5341d5301d5301d5301d5301d5301d5301d535
011000001c0341c0301c0301c0301c0301c0301c0301c035000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01100000260342603026030260302603026030260302603500004000000000000000000000000000000000001d5341d5301d5301d5301d5301d5301d5301d5351a5341a5301a5301a5301a5301a5301a5301a535
011000001a0341a0301a0301a0301a0301a0301a0301a03500000000000000000000000000000000000000001f5341f5301f5301f5301f5301f5301f5301f5352353423530235302353023530235302353023535
011000001d0341d0301d0301d0301d0301d0301d0301d035000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01100000260342603026030260302603026030260302603500000000000000000000000000000000000000001c5341c5301c5301c5301c5301c5301c5301c5351f5341f5301f5301f5301f5301f5301f5301f535
011000001803418030180301803018030180301803018035000000000000000000000000000000000000000023534235302353023530235302353023530235351f5341f5301f5301f5301f5301f5301f5301f533
011000001c0341c0301c0301c0301c0301c0301c0301c03500000000000000000000000000000000000000001f5341f5301f5301f5301f5301f5301f5301f5351c5341c5301c5301c5301c5301c5301c5301c533
01100000240342403024030240302403024030240302403500000000000000000000000000000000000000001c5341c5301c5301c5301c5301c5301c5301c5351853418530185301853018530185301853018533
000700000d2200a2200922008220072200622005220042200322003220032200322003220032200322003220032200322003220032200322003220032200422005220062200722008220092200a2200b2200d220
000300000952007520075200652005520055200552005520055200652007520085200952009520095200952009520085200752007520065200652005520045200452004520045200452004520045200452004520
01100000180521805218052180551805218052180521805318052180521805218055180521805218052180531c0521c0521c0521c0551c0521c0521c0521c0531d0521d0521d0521d0551f0521f0521f0521f053
011000001d0521d0521d0521d0551d0521d0521d0521d0531d0521d0521d0521d0551d0521d0521d0521d0531f0521f0521f0521f0551f0521f0521f0521f0531a0521a0521a0521a0551c0521c0521c0521c053
011000001805218052180521805518052180521805218053210522105221052210551f0521f0521f0521f0531d0521d0521d0521d0551c0521c0521c0521c0531d0521d0521d0521d0551a0521a0521a0521a053
01100000180521805218052180551805218052180521805318052180521805218055180521805218052180531c0521c0521c0521c0551a0521a0521a0521a0531c0521c0521c0521c0551f0521f0521f0521f053
__music__
00 01020344
00 04050644
00 07080944
00 0a0b0c46
01 01054300
00 04084600
00 04024600
00 0a0b4c00
00 0f034300
00 10064000
00 11034300
02 120c4300
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 19424344

