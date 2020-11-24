# logwatch2sql
`cp log2sql.sh /root/bin/log2sql.sh`

# dependency
`awk, sqlite3, sed, bash`

# edit "/etc/cron.daily/00logwatch"
```bash
LAST_WATCH_LOG=/dev/shm/lastlogwatch.txt
/usr/sbin/logwatch --filename ${LAST_WATCH_LOG}
echo "`cat ${LAST_WATCH_LOG}`" | mailx -s "Title of logwatch" user@yourmail.com
/root/bin/log2sql.sh
```
