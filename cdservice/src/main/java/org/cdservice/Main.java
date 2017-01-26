package org.cdservice;

import org.cdservice.rest.CatalogEndpoint;
import org.cdservice.rest.RestApplication;
import org.cdservice.rest.filter.CrossOriginResourceSharing;
import org.jboss.shrinkwrap.api.ShrinkWrap;
import org.wildfly.swarm.Swarm;
import org.wildfly.swarm.jaxrs.JAXRSArchive;

public class Main {
    public static void main(String... args) throws Exception {
        final Swarm container = new Swarm();
        container.start();

        JAXRSArchive jar = ShrinkWrap.create(JAXRSArchive.class);
        jar.addResource(RestApplication.class);
        jar.addResource(CatalogEndpoint.class);
        jar.addResource(CrossOriginResourceSharing.class);
        container.start();
        container.deploy(jar);
    }
}