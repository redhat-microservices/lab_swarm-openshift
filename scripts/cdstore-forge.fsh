# create the CD Catalog Service project
# ----------------  CD Catalog Service [:8080/rest] ---------------
project-new --named cdservice --stack JAVA_EE_7

# Define PostgreSQL DB
jpa-setup --jpa-provider hibernate --db-type MYSQL --data-source-name java:jboss/datasources/CatalogDS --persistence-unit-name cdservice-persistence-unit

jpa-new-entity --named Catalog
jpa-new-field --named artist --target-entity org.cdservice.model.Catalog
jpa-new-field --named title --target-entity org.cdservice.model.Catalog
jpa-new-field --named description --length 2000 --target-entity org.cdservice.model.Catalog
jpa-new-field --named price --type java.lang.Float --target-entity org.cdservice.model.Catalog
jpa-new-field --named publicationDate --type java.util.Date --temporalType DATE --target-entity org.cdservice.model.Catalog

scaffold-setup --provider AngularJS
scaffold-generate --provider AngularJS --generate-rest-resources --targets org.cdservice.model.*
wildfly-swarm-setup
#wildfly-swarm-detect-fractions --depend --build

# Add CORS REST Filter class
rest-new-cross-origin-resource-sharing-filter

# Return to the root of the cdservice
cd ~~

# Inject Fabric8 Maven plugin
fabric8-setup

# Return to the parent project
cd ..