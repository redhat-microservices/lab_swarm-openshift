#!/usr/bin/env bash

export ACCESS_TOKEN=4ed79763b4742a374857c0c5283b66f413c874fed14347289ffdb601bd26b32f
oc secret new-basicauth threescale-portal-endpoint-secret --password=https://$ACCESS_TOKEN@cmoulliard-admin.3scale.net

docker pull registry.access.redhat.com/rhamp10/apicast-gateway:1.0.0-4

oc new-app -f apicast-gateway-template.yml


curl "https://api-2445581273767.apicast.io:443/1.0/auth" -i -H'X-3scale-user-key: 4cfe488d5c96XXXXXc597a93715ea36cb' -H 'Content-Type: application/json;charset=UTF-8' -H 'Accept: application/json, text/plain, */*' --data-binary '{"username":"cmoulliard@redhat.com","password":"B1kers99!","remember":false}'
