#!/bin/bash
# LiveConfig Webinhalt Migration
# (c) 2014 by Jonas Friedmann (iWelt AG)

##################################
# Konfiguration - ggf. anpassen
##################################

###
# Variablen
###

# Load settings file
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
. ${DIR}/settings.conf

##################################
# Logik - ab hier nichts verändern
##################################

###
# Funktionen
###

function remoteSudo {
  ssh -n root@${LIVECONFIGHOST} -C $1
}

###
# Checks
###

## Prüfen ob log folder existiert
if [ ! -d "${WEB_LOGFOLDER}" ]; then
  mkdir -p ${WEB_LOGFOLDER}
fi

# Aufnehmen der alten und neuen Web nummer
read -p "Bitte gib die _ALTE_ Web-Nummer von 'Confixx' an (webXXX)? " ANTWORT1
read -p "Bitte gib die _NEU_ Web-Nummer von 'LiveConfig' an (webXXX)? " ANTWORT2
if [[ -z "${ANTWORT1}" || -z "${ANTWORT2}" ]]; then
    echo "${ERRORPREFIX} Webnummern nicht vollständig. Bitte Eingabe prüfen!"
    exit 1
fi

# Dump erzeugen?
read -p "Soll anschließend ein MySQL Dump von der Confixx Datenbank des Web Benutzers erzeugt und übertragen werden? (y/n)? " ANTWORT3
if [[ "${ANTWORT3}" =~ ^[Yy]$ ]]; then
  read -p "Bitte gib den/die genauen Datenbanknamen des Web Benutzers an (\"usr_webXXX_1\" oder \"usr_webXXX_1 usr_webXXX_2\")? " ANTWORT4
  if [[ -z "${ANTWORT4}" ]]; then
      echo "${ERRORPREFIX} Datenbankname nicht gesetzt. Bitte Eingabe prüfen!"
      exit 1
  fi
fi

echo ${SPACER}

###
# Sicherheitscheck
###

echo "Bitte überprüfe folgende Angaben:"
echo "Web-Nummer auf Confixx System: ${ANTWORT1}"
echo "Web-Nummer auf LiveConfig System: ${ANTWORT2}"
if [[ ! -z "${ANTWORT4}" ]]; then
    echo "Datenbanken dumpen und übertragen: ja"
    echo "Ausgewählte Datenbank(en): ${ANTWORT4}"
else
    echo "Datenbanken dumpen und übertragen: nein"
fi

read -p "Sind die Angaben so korrekt? (y/n)? " ANTWORT5
if [[ ! "${ANTWORT5}" =~ ^[Yy]$ ]]; then
    echo "${ERRORPREFIX} Überprüfung fehlgeschlagen! Migration abgebrochen... "
  exit 1
fi

echo ${SPACER}

###
# Migration
###

shopt -s dotglob
rsync /var/www/${ANTWORT1}/log/* -ave ssh root@${LIVECONFIGHOST}:/var/www/${ANTWORT2}/logs | tee -a ${WEB_LOGFOLDER}/${ANTWORT1}.log
rsync /var/www/${ANTWORT1}/html/* -ave ssh root@${LIVECONFIGHOST}:/var/www/${ANTWORT2}/htdocs | tee -a ${WEB_LOGFOLDER}/${ANTWORT1}.log

###
# Dump erstellen und übertragen
###
if [[ ! -z "${ANTWORT4}" ]]; then
  echo ${SPACER}
  echo "MySQL Dump und übertragung gewünscht..."
  ## Prüfen ob dump folder existiert
  if [ ! -d "${WEB_SQL_DUMPFOLDER}" ]; then
    mkdir -p ${WEB_SQL_DUMPFOLDER}
  fi
  # Dump erzeugen und archivieren - ANPASSEN VOR PRODUKTIVBETRIEB
  mysqldump -u root -p${WEB_MYSQLPW} --add-drop-table --lock-tables --add-locks --allow-keywords --quote-names ${ANTWORT4} > ${WEB_SQL_DUMPFOLDER}/${ANTWORT1}.sql
  # Dump auf LiveConfig System übertragen
  rsync ${WEB_SQL_DUMPFOLDER}/${ANTWORT1}.sql -ave ssh root@${LIVECONFIGHOST}:/var/www/${ANTWORT2} | tee -a ${WEB_LOGFOLDER}/${ANTWORT1}.log
fi

echo "chmod auf entferntem Server absetzen"
remoteSudo "chown -R ${ANTWORT2}:${ANTWORT2} /var/www/${ANTWORT2}/htdocs" | tee -a ${WEB_LOGFOLDER}/${ANTWORT1}.log
remoteSudo "chmod -R 755 /var/www/${ANTWORT2}/htdocs" | tee -a ${WEB_LOGFOLDER}/${ANTWORT1}.log

# Erfolgreich beenden
exit 0
