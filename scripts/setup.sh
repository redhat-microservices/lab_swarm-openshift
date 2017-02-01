#!/usr/bin/env bash

#
# Script responsible to setup the project
# IT alos allow to install using brew jboss-forge and the addons required
#
# command to be used at the root of the project cloned
# ./setup.sh install-forge

CURRENT=$(pwd)

cd $TMPDIR && rm -rf snowcamp
mvn archetype:generate -DarchetypeGroupId=org.codehaus.mojo.archetypes -DarchetypeArtifactId=pom-root -DarchetypeVersion=RELEASE -DinteractiveMode=false -DgroupId=org.cdstore -DartifactId=project -Dversion=1.0.0-SNAPSHOT
mv project snowcamp && cd snowcamp

if [[ -n $1 ]]; then
 rm -rf ~/.forge
 brew install jboss-forge
 forge -e "addon-install --coordinate io.fabric8.forge:devops,2.3.88"
 forge -e "addon-install --coordinate org.jboss.forge.addon:wildfly-swarm,2017.1"
fi

forge -e "run $CURRENT/scripts/cdstore-forge.fsh"

echo # ----------------  CD Store Web Front End [:8081/rest] ---------------
echo # Now we want to create front end swarm service to access CD Catalog Service
# mkdir -p cdfront/public
#
# cp -r $CURRENT/scripts/front/ cdfront

echo # ---------------- Project created ------------------
pwd && ls -la

cd $CURRENT