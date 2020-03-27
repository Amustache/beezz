pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
function _init()
	player = {
	 x=64,
	 y=64,
	 spd=3,
	 pts=0
	}
	circs={}
	presents={}
end

function add_circ(x, y)
 add(circs,{
  x=x,
  y=y,
  r=rnd(6),
  col=rnd(9)+7
 })
end

function add_present(x, y)
 add(presents,{
  sp=rnd(3)+1,
  x=x,
  y=y
 })
end

function _update()
 if(btn(0)) then
  player.x-=player.spd
  if(player.x<0) then
   player.x=0
  end
 end
	if(btn(1)) then
  player.x+=player.spd
  if(player.x>127) then
   player.x=127
  end
 end
	if(btn(2)) then
  player.y-=player.spd
  if(player.y<0) then
   player.y=0
  end
 end
	if(btn(3)) then
  player.y+=player.spd
  if(player.y>127) then
   player.y=127
  end
 end
 add_circ(player.x, player.y)
 
 if((#circs % 10) == 0) then
  add_present(rnd(128),rnd(128))
 end
 
 player.spd = 1+(player.pts/10)
end

function _draw()
	cls()
	print("pts: "..player.pts, 0, 0)
	print("spd: "..player.spd, 0, 8)
	
	for c in all(circs) do
	 circ(
	  c.x,
	  c.y,
	  c.r,
	  c.col
	 )
	end
	
	for p in all(presents) do
	 spr(
	  p.sp,
	  p.x,
	  p.y
	 )
	end
end
-->8
-- ⧗his is a test
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000090000000a0000000e0000000b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007000090900000a0a00000e0e00000b0b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000022922200bbabbb00cceccc0033b33300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000099999900aaaaaa00eeeeee00bbbbbb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700022922200bbabbb00cceccc0033b33300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000022922200bbabbb00cceccc0033b33300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
