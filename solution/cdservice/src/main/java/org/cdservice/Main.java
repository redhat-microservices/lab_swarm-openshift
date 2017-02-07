package org.cdservice;

import org.jboss.shrinkwrap.api.ShrinkWrap;
import org.jboss.shrinkwrap.api.asset.ClassLoaderAsset;
import org.wildfly.swarm.Swarm;
import org.wildfly.swarm.jaxrs.JAXRSArchive;
import org.wildfly.swarm.undertow.WARArchive;

public class Main {
    public static void main(String... args) throws Exception {
        final Swarm swarm = new Swarm();

        JAXRSArchive jar = ShrinkWrap.create(JAXRSArchive.class);
        jar.addPackages(true,Main.class.getPackage());
        swarm.start();

        // Repackage the project as a WAR
        WARArchive war = ShrinkWrap.create(WARArchive.class);
        war.addPackages(true,Main.class.getPackage());
        war.addAsWebInfResource(new ClassLoaderAsset("META-INF/persistence.xml", Main.class.getClassLoader()), "classes/META-INF/persistence.xml");

        swarm.deploy(war);
    }
}