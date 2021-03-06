# LiveConfig-scripts

[![Current tag](http://img.shields.io/github/tag/frdmn/LiveConfig-scripts.svg)](https://github.com/frdmn/LiveConfig-scripts/tags) [![Repository issues](http://issuestats.com/github/frdmn/LiveConfig-scripts/badge/issue)](http://issuestats.com/github/frdmn/LiveConfig-scripts) [![Flattr this repository](http://api.flattr.com/button/flattr-badge-large.png)](https://flattr.com/submit/auto?user_id=frdmn&url=https://github.com/frdmn/LiveConfig-scripts)

This repository contains some useful scripts (mostly LUA) for [LiveConfig](http://www.liveconfig.com/) web hosting platform.

## Installation

1. Clone this repository:  
  `git clone https://github.com/frdmn/LiveConfig-scripts /usr/local/src/liveconfig-scripts`  
  `cd /usr/local/src/liveconfig-scripts`
2. Open the desired script sub-folder and read the regarding `README.md` for further installation instructions:  
  `open apache_post_vhost_hook/README.md` 

## Script documentation

* [apache\_post\_vhost\_hook](apache_post_vhost_hook): Lua hook, originally made by @megabert (fx998), to support per domain/virtual host customizations in Apache.
 
* [nginx\_post\_vhost\_hook](nginx_post_vhost_hook): Analogous to [apache\_post\_vhost\_hook](apache_post_vhost_hook), to support per domain/virtual host customizations in Nginx server blocks.

* [confixx\_web\_and\_mail\_data\_migrate](confixx_web_and_mail_data_migrate): Bash script to to facilitate the data migration (web and mail) from Confixx to LiveConfig. Presuming you are using LiveConfig's official [cfximport.php](https://github.com/LiveConfig/cfximport/blob/master/cfximport.php).

## Contributing

1. Fork it
2. Create your feature branch: `git checkout -b feature/my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin feature/my-new-feature`
5. Submit a pull request

## Version

1.0.0

## License

[MIT](LICENSE)
