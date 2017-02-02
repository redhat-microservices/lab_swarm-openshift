#!/usr/bin/env bash

$to_be_clean=${1:-}
$box=${2:-centos}

if [[ $to_be_clean -eq "clean" ]]; then
  echo "Delete $home/.minishift"
  rm -rf ~/.minishift
fi

  case $box in
    *"boot2docker"*)
    minishift start --memory=4000 --vm-driver=virtualbox
    ;;
    *"centos"*)
    # Issue with minishift 1.0.0.Beta3 - https://github.com/minishift/minishift/issues/355
    # ISO_URL=https://github.com/minishift/minishift-centos-iso/releases/download/v1.0.0-beta.1/minishift-centos.iso
    ISO_URL=https://github.com/minishift/minishift-centos-iso/releases/download/v1.0.0-rc.1/minishift-centos7.iso
    minishift start --memory=4000 --vm-driver=virtualbox --iso-url=$ISO_URL --docker-env=[storage-driver=devicemapper]
    ;;
esac

HOST_IP=$(minishift ip)

oc login https://$HOST_IP:8443 -u system:admin
oc adm policy add-cluster-role-to-user cluster-admin admin