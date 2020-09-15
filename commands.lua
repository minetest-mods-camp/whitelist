ChatCmdBuilder.new("whitelist", function(cmd)

  cmd:sub("off", function(sender)
      whitelist.disable(sender)
      end)

  cmd:sub("on", function(sender)
      whitelist.enable(sender)
      end)

  cmd:sub("add :player:text", function(sender, p_name)
      whitelist.add_player(p_name, sender)
      end)

  cmd:sub("remove :player:text", function(sender, p_name)
      whitelist.remove_player(p_name, sender)
      end)

  cmd:sub("who", function(sender)
      whitelist.print_list(sender)
      end)

end, {
  description = "whitelist commands",
  privs = { server = true }
})
