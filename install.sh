#!/usr/bin/env bash

#
# The command ./install.sh cluster will tell to minishift to create a new VM & install/Deploy docker/openshift
# openshift oc client that a new openshift cluster must be started
# If it exists as docker-machine, then it will be deleted first
#

set -e

if [[ -n $1 ]]; then
  # docker-machine rm -y openshift
  # oc cluster up --docker-machine=openshift --version=v1.4.1 --create-machine --use-existing-config --host-config-dir /var/lib/minishift/openshift.local.config --host-data-dir /var/lib/minishift/hostdata
  # HOST_IP=$(docker-machine ip openshift)

  # Issue with minishift 1.0.0.Beta3
  # minishift start --openshift-version=v1.4.1 --memory=4000 --vm-driver=virtualbox --iso-url=https://github.com/minishift/minishift-centos-iso/releases/download/v1.0.0-rc.1/minishift-centos7.iso --docker-env=[storage-driver=devicemapper]

  minishift start --memory=4000 --vm-driver=virtualbox
  HOST_IP=$(minishift ip)

  oc login https://$HOST_IP:8443 -u system:admin
  oc adm policy add-cluster-role-to-user cluster-admin admin
  echo "OpenShift server created."
else
  HOST_IP=$(minishift ip)
fi

oc login https://$HOST_IP:8443 -u admin -p admin
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
oc env dc/cdfrontend PORT=8080
oc env dc/cdfrontend OS_SUBDOMAIN=$HOST_IP.xip.io
oc env dc/cdfrontend OS_PROJECT=snowcamp
oc expose service cdfrontend

cd ../cdservice
mvn clean package
mvn fabric8:deploy -Popenshift

# Test service
APP=http://cdservice-snowcamp.$HOST_IP.xip.io/

while [ $(curl --write-out %{http_code} --silent --output /dev/null $APP/rest/catalogs) != 200 ]
 do
   echo "Wait till we get http response 200 .... from $APP/rest/catalogs"
   sleep 20
done
echo "SUCCESS !"