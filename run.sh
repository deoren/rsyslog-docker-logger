#!/bin/sh

if [ "$RSYSLOG_LOGGING" = "on" ]
then
    # See notes at http://www.rsyslog.com/how-to-use-debug-on-demand/
    export RSYSLOG_DEBUG="DebugOnDemand NoStdOut"
    export RSYSLOG_DEBUGLOG=/var/log/rsyslog.log

    # Start sending logs to the aggregator (e.g. Loggly)
    # -d is debug mode; -n is foreground mode
    # (if logs are required, -d seems essential - there are no logs at all otherwise)
    rsyslogd -dn
else
    # Die off after a short time
    sleep 10
fi
