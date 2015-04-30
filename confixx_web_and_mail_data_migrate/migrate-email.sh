#!/bin/bash
# LiveConfig E-Mail Migration
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

# Sicherheitsabfrage
read -p "Wurde das '${MAIL_PARSE_LOG}' angepasst und auf Korrektheit überprüft? (y/n)? " ANTWORT
if [[ ! "$ANTWORT" =~ ^[Yy]$ ]]; then
	echo "${ERRORPREFIX} durch Sicherheitsabfrage abgebrochen"
	exit 1
fi

# Prüfen ob Maillog existiert, wenn nicht => abbruch
if [ ! -f ${MAIL_PARSE_LOG} ]
then
		echo "${ERRORPREFIX} \"${MAIL_PARSE_LOG}\" existiert nicht"
	exit 1
fi

# Eventuelle Spaces durch Tabs ersetzen
#sed -e 's/\s\+/\t/g' ${MAIL_PARSE_LOG} > ${MAIL_PARSE_LOG}

# Prüfen auf korrektes Format
COLUMNS=$(awk '{print NF}' ${MAIL_PARSE_LOG} | head -n1)
if [ "${COLUMNS}" -ne 2 ]
then
		echo "${ERRORPREFIX} \"${MAIL_PARSE_LOG}\" nicht im korrekten Format. Es werden exakt zwei Spalten erwartet!"
	exit 1
fi

# Prüfen ob log folder existiert
if [ ! -d "${MAIL_LOGFOLDER}" ]; then
	mkdir -p ${MAIL_LOGFOLDER}
fi

###
# Migration
###

# Je Postfach
while read line; do
## Postfach per rsync übertragen
	FROM=`echo "${line}" | cut -f 1`
	TO=`echo "${line}" | cut -f 2`

	# Zweiter Sicherheitscheck
	if [[ -z "${FROM}" || -z "${TO}" ]]; then
			echo "${ERRORPREFIX} ${MAIL_PARSE_LOG} konnte nicht geparst werden. Zum trennen der Werte ausschlißelich _EINEN TAB_ nutzen!"
			echo "${ERRORPREFIX} Betroffene Zeile: '${line}'"
			exit 1
	fi

	echo -e "1. Übertragen des Postfachs '${FROM}' per rsync\n(Confixx: ${FROM} | LiveConfig: ${TO})\n${SPACER}" | tee ${MAIL_LOGFOLDER}/${FROM}.log
	rsync -av /home/email/${FROM}/Maildir/ ${LIVECONFIGHOST}:${TO}/ | tee -a ${MAIL_LOGFOLDER}/${FROM}.log

	## Mapping für Sent/Trash Ordner anpassen
	echo -e "${SPACER}\n2. Mapping für Sent/Trash Ordner anpassen\n${SPACER}" | tee -a ${MAIL_LOGFOLDER}/${FROM}.log
	remoteSudo "mkdir -p ${TO}/.Sent" | tee -a ${MAIL_LOGFOLDER}/${FROM}.log
	remoteSudo "mkdir -p ${TO}/.Trash" | tee -a ${MAIL_LOGFOLDER}/${FROM}.log
	remoteSudo "mv ${TO}/.Sent\ Messages/* ${TO}/.Sent/" | tee -a ${MAIL_LOGFOLDER}/${FROM}.log
	remoteSudo "mv ${TO}/.Deleted\ Messages/* ${TO}/.Trash/" | tee -a ${MAIL_LOGFOLDER}/${FROM}.log
	remoteSudo "rm -rf ${TO}/.Sent\ Messages/" | tee -a ${MAIL_LOGFOLDER}/${FROM}.log
	remoteSudo "rm -rf ${TO}/.Deleted\ Messages/" | tee -a ${MAIL_LOGFOLDER}/${FROM}.log

	## Berechtigungen anpassen
	FOLDER=$(echo ${TO} | sed -e 's/\/[0-9]*$//g')
	echo -e "${SPACER}\n3. Berechtigungen anpassen\n${SPACER}" | tee -a ${MAIL_LOGFOLDER}/${FROM}.log
	remoteSudo "chown -R mail:mail ${FOLDER}" | tee -a ${MAIL_LOGFOLDER}/${FROM}.log
	echo && echo && echo
done < ${MAIL_PARSE_LOG}

# $MAILLOG wegsichern
cp ${MAIL_PARSE_LOG} ${MAIL_LOGFOLDER}/${FROM}_mail.log | tee -a ${MAIL_LOGFOLDER}/${FROM}.log

# Erfolgreich beenden
exit 0
