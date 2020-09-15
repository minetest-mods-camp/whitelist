whitelist = {}

local S = minetest.get_translator("whitelist")
local storage = minetest.get_mod_storage()





----------------------------------------------
---------------DICHIARAZIONI------------------
----------------------------------------------

local is_whitelist_on = false
local whitelisted_players = {}

if storage:get_int("ENABLED") == 1 then
  is_whitelist_on = true
end

if storage:get_string("PLAYERS") ~= "" then
  whitelisted_players = minetest.deserialize(storage:get_string("PLAYERS"))
end





----------------------------------------------
--------------------CORE----------------------
----------------------------------------------

function whitelist.enable(sender)

  sender = sender or ""

  -- se è già abilitata
  if is_whitelist_on then
    minetest.chat_send_player(sender, minetest.colorize("#e6482e", S("[!] The whitelist is already enabled!")))
    return end

  whitelist.add_player(sender)

  is_whitelist_on = true
  storage:set_int("ENABLED", 1)
  minetest.chat_send_player(sender, "[WHITELIST] " .. S("Whitelist successfully enabled"))
end



function whitelist.disable(sender)

  sender = sender or ""

  -- se è già disabilitata
  if not is_whitelist_on then
    minetest.chat_send_player(sender, minetest.colorize("#e6482e", S("[!] The whitelist is already disabled!")))
    return end

  is_whitelist_on = false
  storage:set_int("ENABLED", 0)
  minetest.chat_send_player(sender, "[WHITELIST] " .. S("Whitelist successfully disabled"))
end



function whitelist.add_player(p_name, sender)

  sender = sender or ""

  -- se già c'è
  if whitelisted_players[p_name] then
    minetest.chat_send_player(sender, minetest.colorize("#e6482e", S("[!] @1 is already whitelisted!", p_name)))
    return end

  whitelisted_players[p_name] = true
  storage:set_string("PLAYERS", minetest.serialize(whitelisted_players))
  minetest.chat_send_player(sender, "[WHITELIST] " .. minetest.colorize("#c8d692", "+ " .. p_name))
end



function whitelist.remove_player(p_name, sender)

  sender = sender or ""

  -- se già non c'è
  if not whitelisted_players[p_name] then
    minetest.chat_send_player(sender, minetest.colorize("#e6482e", S("[!] There is no player whitelisted with that name...")))
    return end

  -- se è lo stesso giocatore
  if p_name == sender then
    minetest.chat_send_player(sender, minetest.colorize("#e6482e", S("[!] You can't remove yourself!")))
    return end

  whitelisted_players[p_name] = nil

  -- se si rimuove l'ultimo giocatore mentre è attiva
  if not next(whitelisted_players) and is_whitelist_on then
    minetest.chat_send_player(sender, minetest.colorize("#e6482e", S("[!] Whitelist can't be empty when enabled!")))
    whitelisted_players[p_name] = true
    return end

  storage:set_string("PLAYERS", minetest.serialize(whitelisted_players))
  minetest.chat_send_player(sender, "[WHITELIST] " .. minetest.colorize("#f16a54", "- " .. p_name))
end





----------------------------------------------
--------------------UTILS---------------------
----------------------------------------------

function whitelist.print_list(sender)
  local msg = ""

  for p_name, _ in pairs(whitelisted_players) do
    msg = msg .. p_name .. ", "
  end

  minetest.chat_send_player(sender, "[WHITELIST] " .. minetest.colorize("#eea160", S("Whitelisted players: ")) .. minetest.colorize("#cfc6b8", msg:sub(1, -3)))
end



function whitelist.is_player_whitelisted(p_name)
  return whitelisted_players[p_name] ~= nil
end



function whitelist.is_whitelist_enabled()
  return is_whitelist_on
end
