# LiveConfig-scripts/apache_post_vhost_hook

## Installation

1. Symlink the Lua hook `apache_post_vhost_hook.lua` into LiveConfig's Lua directory:  
  `ln -sf /usr/local/src/liveconfig-scripts/apache_post_vhost_hook/apache_post_vhost_hook.lua /usr/lib/liveconfig/lua/`   
2. Create folder for 3rd party scripts and symlink the substitution script one:  
  `mkdir /usr/lib/liveconfig/scripts`  
  `ln -sf apache_post_vhost_hook.sh /usr/lib/liveconfig/scripts/`  
3. Include the new Lua script in LiveConfig's `custom.lua`:  
  `vi /usr/lib/liveconfig/lua/custom.lua`

```lua
-- LiveConfig-scripts/apache_post_vhost_hook 
-- (https://github.com/frdmn/LiveConfig-scripts/tree/master/apache_post_vhost_hook)
require("apache_post_vhost_hook")
```

## Usage / How to

Follow the installation instructions as described above. Whenever you need a virtual host customization, create a file called `/etc/apache2/sites-available/[domain.name.tld].local` and insert your custom configuration in there. Make sure to let LiveConfig rebuild the virtual hosts. (Log into the web interface, sign in as customer, go to "Domain management", change something in the domain configuration of the regarding web space and last but not least, click on "save")
