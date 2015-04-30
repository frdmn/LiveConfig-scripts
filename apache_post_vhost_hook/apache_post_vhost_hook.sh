#!/bin/bash

#
# Einbinden der Datei ...meine-seite.de.local nach der Apache
# Direktivenzeile "ServerName www.meine-seite.de"
#

vhost_config_file="${1}"
url="${2}"
conf_include="/etc/apache2/sites-available/${url}.local"

# Als erstes eine evtl. schon vorhandene Include-Zeile rausfiltern und
# dann erst die neue einfügen. Das soll doppelte Includes bei Mehr-
# fachaufrufen verhindern.

if [[ -f ${conf_include} ]]; then
  sed -ri -e "/Include $conf_include/d"          \
          -e "s=^(.*ServerName.*$url.*)\$=\1\n    Include $conf_include=" $vhost_config_file
fi
