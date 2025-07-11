
creative_enhanced = {}


-- returns true if game is creative or if player is in creative gamemode
creative_enhanced.player_gamemode_is_creative = function(name)
	-- if world is creative, return true ofc
	if minetest.settings:get_bool("creative_mode") then
		return true
	-- if player's gamemode value is set in table, check it
	-- else assume he is in survival
	elseif gamemode and gamemode.players then
		if gamemode.players[name] == 1 then
			return true
		end
	end
	return false
end

if minetest.settings:get_bool("creative_mode") then
	--local digtime = 0.5
	local digtime = 0
	minetest.register_item(":", {
		type = "none",
		wield_image = "wieldhand.png",
		wield_scale = {x=1,y=1,z=2.5},
		range = 10,
		tool_capabilities = {
			full_punch_interval = 0,
			max_drop_level = 3,
			groupcaps = {
---				crumbly = {times={[1]=digtime, [2]=digtime, [3]=digtime}, uses=0, maxlevel=30},
				crumbly = {times={[1]=digtime, [2]=digtime, [3]=digtime}, uses=0, maxlevel=30},
				cracky = {times={[1]=digtime, [2]=digtime, [3]=digtime}, uses=0, maxlevel=30},
				snappy = {times={[1]=digtime, [2]=digtime, [3]=digtime}, uses=0, maxlevel=30},
				choppy = {times={[1]=digtime, [2]=digtime, [3]=digtime}, uses=0, maxlevel=30},
				oddly_breakable_by_hand = {times={[1]=digtime, [2]=digtime, [3]=digtime}, uses=0, maxlevel=30},
			},
			damage_groups = {fleshy = 1000},
		}
	})
end

minetest.register_on_placenode(function(pos, newnode, placer, oldnode, itemstack)
		if creative_enhanced.player_gamemode_is_creative(placer:get_player_name()) then
			return true -- nothing is taken from inventory
		else 
			return false -- pass over to mods
		end
end)

-- overwrite core function and use own gamemode check
old_rotate_and_place = minetest.rotate_and_place
minetest.rotate_and_place = function(itemstack, placer, pointed_thing,infinitestacks, orient_flags)
	if creative_enhanced.player_gamemode_is_creative(placer:get_player_name()) then
		infinitestacks = true
	end
	return old_rotate_and_place(itemstack, placer, pointed_thing,infinitestacks, orient_flags)
end

minetest.log("action","creative_enhanced loaded")
