#!/usr/bin/env bash

# docker-machine rm -y openshift
# oc cluster up --docker-machine=openshift --version=v1.4.1 --create-machine --use-existing-config --host-config-dir /var/lib/minishift/openshift.local.config --host-data-dir /var/lib/minishift/hostdata
# HOST_IP=$(docker-machine ip openshift)

# Issue with minishift 1.0.0.Beta3 - https://github.com/minishift/minishift/issues/355
# ISO_URL=https://github.com/minishift/minishift-centos-iso/releases/download/v1.0.0-beta.1/minishift-centos.iso
# ISO_URL=https://github.com/minishift/minishift-centos-iso/releases/download/v1.0.0-rc.1/minishift-centos7.iso
# minishift start --memory=4000 --vm-driver=virtualbox --iso-url=$ISO_URL --docker-env=[storage-driver=devicemapper]

minishift start --memory=4000 --vm-driver=virtualbox
HOST_IP=$(minishift ip)

oc login https://$HOST_IP:8443 -u system:admin
oc adm policy add-cluster-role-to-user cluster-admin admin

echo "OpenShift server created."