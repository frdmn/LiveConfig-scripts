-- Funktion die ueberschrieben wird zunaechst sichern
apache_orig_configureVHost = require("apache").configureVHost

LC.apache = require("apache")

function LC.apache.configureVHost(cfg, opts)

   -- Erst Konfiguration erzeugen lassen und danach anpassen
   res = apache_orig_configureVHost(cfg,opts)

   -- VHost-Config-File ermitteln
   local vhostpath  = cfg["available_dir"] or cfg["enabled_dir"]
   if opts and opts.prefix then vhostpath = opts.prefix .. vhostpath end -- use prefix (for testing etc.)
   local vhost_config_file = vhostpath .. "/" .. opts["name"] .. ".conf"

   LC.log.print(LC.log.INFO, "Using custom.lua for apache-vhost config "..vhost_config_file)

   local script = "/etc/apache2/lc_post_vhost_hook.sh"
   local cmd = script .. " "..vhost_config_file

   local os_res = os.execute(cmd)
   if os_res ~= 0 then
        LC.log.print(LC.log.ERR, "custom.lua: Error executing " .. script)
   else
        LC.log.print(LC.log.INFO, "custom.lua: Script executed successfully: " .. script)
   end

   -- Rückgabewerte der Originalfunktion zurückgeben
   return res
end
