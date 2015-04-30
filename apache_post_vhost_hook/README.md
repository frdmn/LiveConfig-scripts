# LiveConfig-scripts/apache_post_vhost_hook

## Installation

1. Open this directory:  
  `cd /usr/local/src/liveconfig-scripts/apache_post_vhost_hook`
2. Symlink the Lua hook `apache_post_vhost_hook.lua` into LiveConfig's Lua directory:  
  `ln -sf apache_post_vhost_hook.lua /usr/lib/liveconfig/lua/`   
3. Create folder for 3rd party scripts and symlink the substitution script one:  
  `mkdir /usr/lib/liveconfig/scripts`  
  `ln -sf apache_post_vhost_hook.sh /usr/lib/liveconfig/scripts/`  
4. Include the new Lua script in LiveConfig's `custom.lua`:  
  `vi /usr/lib/liveconfig/lua/custom.lua`

```lua
require("apache_post_vhost_hook")
```

## Usage / How to
