# Prerequisites




# Installation of Minishift

Minishift is a Go Application which has been created from Minikube project of Kubernetes. It extends the features proposed by the Kubernetes client to package/Deploy
OpenShift within a VM machine. Different hypervisors are supported as Virtualbox, xhyve & VMWare. You can find more information about Minishift like also how to intall it from the project:
https://github.com/minishift/minishift

# Setup OpenShift

```
minishift start --openshift-version v1.4.0-rc1 --memory 4000 --vm-driver virtualbox

Starting local OpenShift instance using 'virtualbox' hypervisor...
 21.34 MB / 21.34 MB [============================================================================================================================================================================================================================] 100.00% 0s
Provisioning OpenShift via '/Users/chmoulli/.minishift/cache/oc/v1.4.0/oc [cluster up --use-existing-config --host-config-dir /var/lib/minishift/openshift.local.config --host-data-dir /var/lib/minishift/hostdata]'
-- Checking OpenShift client ... OK
-- Checking Docker client ... OK
-- Checking Docker version ... OK
-- Checking for existing OpenShift container ... 
   Deleted existing OpenShift container
-- Checking for openshift/origin:v1.4.0 image ... 
   Pulling image openshift/origin:v1.4.0
   Pulled 0/3 layers, 2% complete
   Pulled 1/3 layers, 63% complete
   Pulled 2/3 layers, 89% complete
   Pulled 3/3 layers, 100% complete
   Extracting
   Image pull complete
-- Checking Docker daemon configuration ... OK
-- Checking for available ports ... OK
-- Checking type of volume mount ... 
   Using nsenter mounter for OpenShift volumes
-- Creating host directories ... OK
-- Finding server IP ... 
   Using 192.168.99.100 as the server IP
-- Starting OpenShift container ... 
   Starting OpenShift using container 'origin'
   Waiting for API server to start listening
   OpenShift server started
-- Removing temporary directory ... OK
-- Server Information ... 
   OpenShift server started.
   The server is accessible via web console at:
       https://192.168.99.100:8443

   To login as administrator:
       oc login -u system:admin
```

Next, we will provide more rights for the admin `default` user in order to let it to access the different projects/namespaces to manage the resources

```
oc login https://192.168.99.101:8443 -u system:admin
oc adm policy add-cluster-role-to-user cluster-admin admin
oc login -u admin -p admin   
```

Optionally, you can also install some projects which are available as an OpenShift Template to play with the technology proposed/supported by Red Hat

```
cd $TMPDIR
rm -rf openshift-ansible && git clone https://github.com/openshift/openshift-ansible.git
cd openshift-ansible/roles/openshift_examples/files/examples/latest/
for f in image-streams/image-streams-centos7.json; do cat $f | oc create -n openshift -f -; done
for f in db-templates/*.json; do cat $f | oc create -n openshift -f -; done
for f in quickstart-templates/*.json; do cat $f | oc create -n openshift -f -; done   
```

