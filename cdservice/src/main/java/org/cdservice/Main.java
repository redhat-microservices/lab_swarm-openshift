package org.cdservice;

import org.jboss.shrinkwrap.api.ShrinkWrap;
import org.wildfly.swarm.Swarm;
import org.wildfly.swarm.jaxrs.JAXRSArchive;

public class Main {
    public static void main(String... args) throws Exception {
        Swarm container = new Swarm();
        container.start();

        JAXRSArchive jar = ShrinkWrap.create(JAXRSArchive.class );
        jar.as(JAXRSArchive.class).addPackage("org.cdservice.rest");
        container.start();
        container.deploy(jar);
    }
}