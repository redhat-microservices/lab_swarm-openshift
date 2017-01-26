#!/usr/bin/env bash

set -e

oc cluster up --docker-machine=openshift --version=v1.4.1 --create-machine
HOST_IP=$(docker-machine ip openshift)

oc login https://$HOST_IP:8443 -u system:admin
oc adm policy add-cluster-role-to-user cluster-admin admin
oc login -u admin -p admin
oc project default

oc new-project snowcamp
oc new-app --template=mysql-ephemeral -p MYSQL_USER=mysql -p MYSQL_PASSWORD=mysql -p MYSQL_DATABASE=catalogdb
sleep 5

cd cdstorefrontend
oc new-build --binary --name=cdfrontend -l app=cdfrontend
#npm install
oc start-build cdfrontend --from-dir=. --follow
oc new-app cdfrontend -l app=cdfrontend
oc env dc/cdfrontend BACKEND_URL=http://cdservice-snowcamp.$HOST_IP.xip.io/rest/catalogs/
#oc env dc/cdfrontend URL=http://cdservice-snowcamp.172.28.128.4.xip.io/rest/catalogs/
oc env dc/cdfrontend PORT=8080
oc env dc/cdfrontend OS_SUBDOMAIN=$HOST_IP.xip.io
oc env dc/cdfrontend OS_PROJECT=snowcamp
oc expose service cdfrontend

cd ../cdservice
mvn clean package
mvn fabric8:deploy -Popenshift