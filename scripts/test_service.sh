#!/usr/bin/env bash

echo "========================================="
echo "Test if the service is running"
echo "========================================="
APP=http://cdservice-snowcamp.$HOST_IP.xip.io/

while [ $(curl --write-out %{http_code} --silent --output /dev/null $APP/rest/catalogs) != 200 ]
 do
   echo "Wait till we get http response 200 .... from $APP/rest/catalogs"
   sleep 20
done
echo "SUCCESS !"