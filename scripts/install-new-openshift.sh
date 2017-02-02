#!/usr/bin/env bash

#
# Prerequisite : install minishift 1.0.0.Beta3
#
# The command './scripts/install-openshift.sh cluster' will :
# 1) Create a new minishift instance/VM in VirtualBox
# 2) Install/Deploy docker + openshift
# 3) Build & deploy the front/service
#

set -e

if [[ -n $1 ]]; then
  source ./create_vm.sh
fi

HOST_IP=$(minishift ip)

echo "========================================="
echo "Log on to OpenShift"
echo "========================================="
oc login https://$HOST_IP:8443 -u admin -p admin

echo "========================================="
echo "Create SnowCamp namespace/project"
echo "========================================="
oc new-project snowcamp

echo "========================================="
echo "Install MysQL server using OpenShift template"
echo "========================================="
oc new-app --template=mysql-ephemeral -p MYSQL_USER=mysql -p MYSQL_PASSWORD=mysql -p MYSQL_DATABASE=catalogdb
sleep 5

echo "========================================="
echo "Use S2I build to deploy the node image using our Front"
echo "========================================="
cd cdfront
mvn clean package
mvn fabric8:deploy

echo "========================================="
echo "Build cd Service using F-M-P "
echo "========================================="
cd ../cdservice

mvn clean package
mvn fabric8:deploy