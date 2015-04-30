#!/bin/bash

#
# Einbinden der Datei ...meine-seite.de.local nach der Apache
# Direktivenzeile "ServerName www.meine-seite.de"
#

vhost_config_file="${1}"
url="${2}"
conf_include="/etc/nginx/sites-available/${url}.local"

conf_include_stripped="${conf_include//\//\\/}"

# Als erstes eine evtl. schon vorhandene Include-Zeile rausfiltern und
# dann erst die neue einfügen. Das soll doppelte Includes bei Mehr-
# fachaufrufen verhindern.

if [[ -f ${conf_include} ]]; then
  sed -ri -e "/include $conf_include_stripped;/d"          \
          -e "s=^(.*server_name.*$url.*;)\$=\1\n    include $conf_include_stripped;=" $vhost_config_file
fi
