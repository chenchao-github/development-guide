#!/bin/sh
#
# Simple Redis init.d script conceived to work on Linux systems
# as it does use of the /proc filesystem.

### BEGIN INIT INFO
# Provides:     redis_6379
# Default-Start:        2 3 4 5
# Default-Stop:         0 1 6
# Short-Description:    Redis data structure server
# Description:          Redis data structure server. See https://redis.io
### END INIT INFO

REDISPORT=6379
EXEC=/opt/redis-5.0.5/src/redis-server
CLIEXEC=/opt/redis-5.0.5/src/redis-cli
PIDFILE=/opt/redis-5.0.5/redis_${REDISPORT}.pid
CONF="/opt/redis-5.0.5/redis.conf"
PASSWORD=$(cat $CONF|grep '^\s*requirepass'|awk '{print $2}')

case "$1" in
    test)
	    echo "$EXEC $CONF"
	    echo "$CLIEXEC -a $PASSWORD -p $REDISPORT shutdown"
	    ;;
    start)
        if [ -f $PIDFILE ]
        then
                echo "$PIDFILE exists, process is already running or crashed"
        else
                echo "Starting Redis server..."
		$EXEC $CONF
        fi
        ;;
    stop)
        if [ ! -f $PIDFILE ]
        then
                echo "$PIDFILE does not exist, process is not running"
        else
                PID=$(cat $PIDFILE)
                echo "Stopping ..."

		# 关闭
		if [ -z $PASSWORD ]
                then
                    $CLIEXEC -p $REDISPORT shutdown
                else
                    $CLIEXEC -a $PASSWORD -p $REDISPORT shutdown
                fi

		# 判断是否关闭
		while [ -x /proc/${PID} ]
                do
                    echo "Waiting for Redis to shutdown ..."
                    sleep 1
                done
                echo "Redis stopped"
        fi
        ;;
    *)
        echo "Please use start or stop as first argument"
        ;;
esac
