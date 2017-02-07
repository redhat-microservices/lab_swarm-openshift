#!/usr/bin/env bash

#
# Script responsible to setup the project
# It also allows to install using brew jboss-forge and the addons required
#
# command to be used at the root of the project cloned to setup the project and install Forge
# cd scripts
# ./setup.sh forge
#
# To just setup the project
# ./setup.sh

# Install forge if required
if [[ -n $1 ]]; then
 rm -rf ~/.forge
 brew install jboss-forge
 forge -e "addon-install --coordinate io.fabric8.forge:devops,2.3.88"
 forge -e "addon-install --coordinate org.jboss.forge.addon:wildfly-swarm,2017.1"
fi


# Remove snowcamp folder and create a new parent multi-modules project
CURRENT=$(pwd)
rm -rf snowcamp
mvn archetype:generate -DarchetypeGroupId=org.codehaus.mojo.archetypes -DarchetypeArtifactId=pom-root -DarchetypeVersion=RELEASE -DinteractiveMode=false -DgroupId=org.cdstore -DartifactId=project -Dversion=1.0.0-SNAPSHOT
mv project snowcamp && cd snowcamp

# export VERBOSE=true

forge -e "run $CURRENT/cdstore-forge.fsh"

mv $CURRENT/snowcamp/ ..
