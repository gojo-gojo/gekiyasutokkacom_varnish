#!/bin/sh
set -e

# this will check if the first argument is a flag
# but only works if all arguments require a hyphenated flag
# -v; -SL; -f arg; etc will work, but not arg1 arg2
if [ "$#" -eq 0 ] || [ "${1#-}" != "$1" ]; then
    set -- varnishd \
            -F \
            -f /etc/varnish/default.vcl \
            -a http=:${VARNISH_HTTP_PORT:-80},HTTP \
            -a proxy=:${VARNISH_PROXY_PORT:-8443},PROXY \
            -p feature=+http2 \
            -s malloc,2G \
            "$@"
fi

varnishncsa -F '%{X-Forwarded-For}i %l %u %t "%r" %s %b "%{Referer}i" "%{User-Agent}i" %{Varnish:handling}x' -w /var/log/varnish/access.log &
exec "$@"
