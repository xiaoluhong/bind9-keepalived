#!/bin/bash

PORT=${PORT:-8090}

lines=`curl -o /dev/null -s -w %{http_code} http://0.0.0.0:${PORT}/admin`
if [ "000" = "$lines" ]; then
    exit -1
else
    exit 0
fi
