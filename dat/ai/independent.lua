include("dat/ai/tpl/generic.lua")
include("dat/ai/personality/civilian.lua")


mem.shield_run = 100
mem.armour_run = 100
mem.defensive  = false
mem.enemyclose = 500
mem.distressmsgfunc = sos


-- Sends a distress signal which causes faction loss
function sos ()
   msg = {
      "Local security: requesting assistance!",
      "Requesting assistance. We are under attack!",
      "Vessel under attack! Requesting help!",
      "Help! Ship under fire!",
      "Taking hostile fire! Need assistance!",
      "We are under attack, require support!",
      "Mayday! Ship taking damage!",
   }
   ai.settarget( ai.target() )
   ai.distress( msg[ rnd.int(1,#msg) ])
end


function create ()

   -- Credits.
   ai.setcredits( rnd.int(ai.pilot():ship():price()/500, ai.pilot():ship():price()/200) )

   -- No bribe
   local bribe_msg = {
      "\"Just leave me alone!\"",
      "\"What do you want from me!?\"",
      "\"Get away from me!\""
   }
   mem.bribe_no = bribe_msg[ rnd.int(1,#bribe_msg) ]

   -- Refuel
   mem.refuel = rnd.rnd( 1000, 3000 )
   p = player.pilot()
   if p:exists() then
      standing = ai.getstanding( p ) or -1
      mem.refuel_msg = string.format("\"I'll supply your ship with fuel for %d credits.\"",
            mem.refuel);
   end

   mem.loiter = 3 -- This is the amount of waypoints the pilot will pass through before leaving the system
   create_post()
end

