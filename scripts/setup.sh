#!/usr/bin/env bash

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

echo # ----------------  Book Store Web Front End [:8081/rest] ---------------
echo # Now we want to create front end swarm service to access CD Catalog Service
mkdir cdstorefrontend
cp $CURRENT/scripts/front cdstorefrontend

cd $CURRENT