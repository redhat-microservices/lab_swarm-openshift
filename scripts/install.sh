#!/usr/bin/env bash

#
# Prerequisite : install minishift 1.0.0.Beta3
#
# The command './scripts/install.sh cluster' will :
# 1) Create a new minishift instance/VM in VirtualBox
# 2) Install/Deploy docker/openshift
# 3) Build & deploy the front/service
#

set -e

if [[ -n $1 ]]; then
  # docker-machine rm -y openshift
  # oc cluster up --docker-machine=openshift --version=v1.4.1 --create-machine --use-existing-config --host-config-dir /var/lib/minishift/openshift.local.config --host-data-dir /var/lib/minishift/hostdata
  # HOST_IP=$(docker-machine ip openshift)

  # Issue with minishift 1.0.0.Beta3
  minishift start --memory=4000 --vm-driver=virtualbox --iso-url=https://github.com/minishift/minishift-centos-iso/releases/download/v1.0.0-rc.1/minishift-centos7.iso --docker-env=[storage-driver=devicemapper]

  # minishift start --memory=4000 --vm-driver=virtualbox
  HOST_IP=$(minishift ip)

  oc login https://$HOST_IP:8443 -u system:admin
  oc adm policy add-cluster-role-to-user cluster-admin admin
  echo "OpenShift server created."
else
  HOST_IP=$(minishift ip)
fi

echo "========================================="
echo "Log on to OpenShift"
echo "========================================="
oc login https://$HOST_IP:8443 -u admin -p admin
oc project snowcamp

echo "========================================="
echo "Create SnowCamp namespace/project"
echo "========================================="
oc new-project snowcamp

echo "========================================="
echo "Install MysQL server using OpenShift template"
echo "========================================="
oc new-app --template=mysql-ephemeral -p MYSQL_USER=mysql -p MYSQL_PASSWORD=mysql -p MYSQL_DATABASE=catalogdb
#sleep 5

echo "========================================="
echo "Use S2I build to deploy the node image using our Front"
echo "========================================="
cd cdfront
oc new-build --binary --name=cdfront -l app=cdfront
#npm install
oc start-build cdfront --from-dir=. --follow
oc new-app cdfront -l app=cdfront
oc env dc/cdfront BACKEND_URL=http://cdservice-snowcamp.$HOST_IP.xip.io/rest/catalogs/
oc env dc/cdfront PORT=8080
oc env dc/cdfront OS_SUBDOMAIN=$HOST_IP.xip.io
oc env dc/cdfront OS_PROJECT=snowcamp
oc expose service cdfront

echo "========================================="
echo "Build cd Service using F-M-P "
echo "========================================="
cd ../cdservice
cp ../scripts/import.sql src/main/config-openshift

mvn clean package
mvn fabric8:deploy -Popenshift

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