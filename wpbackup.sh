#!/bin/bash
# Wordpress Backup Shell Script - wpbackup.sh v0.5
# 
# https://github.com/dkoryto/wpbackup
# dariusz@koryto.eu

# usage: ./wpbackup.sh domain.com
# ToDo:
#       restore backups
#       script execution time sent to email
#       information about the copies made

DOMAIN="$1";            # domain name to backup
BACKUP="$HOME/backups"; # store backups here
HOSTPATH="$HOME";       # path where hosted domains are

backupmake () {
    local _N _U _P _H FDB FT TD WPC;
    FT=`date +$BACKUP/$DOMAIN-%m-%d-%g-%H%M.tar.gz`;
    FDB=`date +$BACKUP/$DOMAIN-%m-%d-%g-%H%M.sql`;
    TD=$HOSTPATH/websites/$DOMAIN;
    WPC=$TD/wp-config.php;
    ( cd $TD || {
        echo "bad $TD" && return 2
    };
    eval $(sed -n "s/^d[^D]*DB_\([NUPH]\)[ASO].*',[^']*'\([^']*\)'.*/_\1='\2'/p" $WPC);
    mysqldump -u$_U -p$_P -h$_H $_N > $FDB;
    tar -czPf $FT $TD )
}

if [ "$#" -ne 1 ]; then
    echo "usage: $0 domain.com"
    exit 0
fi

if [ -d "$HOSTPATH/$DOMAIN/" ]; then
    backupmake
    exit 0
else
    echo "directory not found" 
    exit 0
fi
