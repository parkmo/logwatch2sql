#!/bin/bash

BIN_SQLITE=sqlite3
LOG_WATCH_DATA=/dev/shm/lastlogwatch.txt
TEMP_FILE=/dev/shm/temp_lw.sql
SQLITE_FILE="logwatch.dbb"

SQLITE_SCH="CREATE
TABLE logwatch_abuseIP (
	reg_date TEXT NOT NULL,
	ipver    INTEGER default 4,
	cnt      INTEGER NOT NULL,
	ip       VARCHAR(45),
  PRIMARY KEY(reg_date,ip)
);"


if [ ! -f ${SQLITE_FILE} ]; then
  ${BIN_SQLITE} ${SQLITE_FILE} "${SQLITE_SCH}"
fi

CUR_DATE=`date +%Y-%m-%d`

echo "BEGIN;" > ${TEMP_FILE}
egrep '^( ){7}[A-Za-z0-9]{1,20} \(.*\): [0-9]{1,5} Time\(s\)' ${LOG_WATCH_DATA}|awk ' { print $2 } '|sort |uniq -c |sort -nr |awk ' { if ( $1 > 2 ) { print "INSERT INTO logwatch_abuseIP (reg_date, cnt, ip) VALUES ( ${CUR_DATE}," $1 ",\""substr($2,2,length($2)-3)"\");" } } ' |sed -e "s/\${CUR_DATE}/\"${CUR_DATE}\"/g" >> ${TEMP_FILE}
echo "COMMIT;" >> ${TEMP_FILE}

${BIN_SQLITE} ${SQLITE_FILE} < ${TEMP_FILE}
