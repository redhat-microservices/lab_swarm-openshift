#!/usr/bin/env bash

#!/usr/bin/env bash

REALM=master
USER=admin
PASSWORD=admin
CLIENT_ID=cdservice
SECRET=2428f7c7-65bb-4d3e-aec7-8c65327f6d26

HOST=localhost
PORT_HTTP=8180
PORT_HTTPS=8443

echo "Token request : http --verify=no -f http://$HOST:$PORT_HTTP/auth/realms/$REALM/protocol/openid-connect/token username=$USER password=$PASSWORD client_secret=$SECRET grant_type=password client_id=$CLIENT_ID"
auth_result=$(http --verify=no -f http://$HOST:$PORT_HTTP/auth/realms/$REALM/protocol/openid-connect/token username=$USER password=$PASSWORD client_secret=$SECRET grant_type=password client_id=$CLIENT_ID)
access_token=$(echo -e "$auth_result" | awk -F"," '{print $1}' | awk -F":" '{print $2}' | sed s/\"//g | tr -d ' ')

APIGATEWAY=https://$HOST:$PORT_HTTPS/apiman-gateway
ORG=fuse
SERVICE=cdservice
VERSION=3.0
URL=$APIGATEWAY/$ORG/$SERVICE/$VERSION

#echo ">>> Token query"
#echo "http --verify=no -f http://$HOST:$PORT_HTTP/auth/realms/$REALM/protocol/openid-connect/token username=$USER password=$PASSWORD grant_type=password client_id=$CLIENT_ID"

#echo ">>> TOKEN Received"
#echo $access_token

#echo ">>> Gateway Service URL"
#echo "$URL"

echo ">>> GET CD : 1"
#echo "http --verify=no GET $URL/1 \"Authorization: Bearer $access_token\""
http --verify=no GET $URL/1 "Authorization: Bearer $access_token"

echo ">>> GET CDs"
http --verify=no GET $URL "Authorization: Bearer $access_token"

echo "Update CD - Artist"
echo '{"id": "101", "version": "2", "artist": "ACDC", "title": "Back in Black", "description": "Australian hard rock band", "publicationDate": "1980-07-25", "price": "18"}' | http --verify=no PUT $URL/101 "Authorization: Bearer $access_token"

echo ">>> PUT CD - ColdPlay"
echo '{"version": "1", "artist": "Coldplay", "title": "Parachutes", "description": "Pop Rock UK band", "publicationDate": "2000-01-01T00:00:00.000Z", "price": "25"}' | http --verify=no POST $URL "Authorization: Bearer $access_token"

echo ">>> GET CD : 2"
http --verify=no GET $URL/2 "Authorization: Bearer $access_token"

echo ">>> DELETE CD 2"
http --verify=no DELETE $URL/2 "Authorization: Bearer $access_token"
