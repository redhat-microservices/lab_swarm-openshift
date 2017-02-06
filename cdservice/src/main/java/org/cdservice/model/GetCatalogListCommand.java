/*
 * JBoss, Home of Professional Open Source.
 * Copyright 2017, Red Hat, Inc., and individual contributors
 * as indicated by the @author tags. See the copyright.txt file in the
 * distribution for a full listing of individual contributors.
 *
 * This is free software; you can redistribute it and/or modify it
 * under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation; either version 2.1 of
 * the License, or (at your option) any later version.
 *
 * This software is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this software; if not, write to the Free
 * Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
 * 02110-1301 USA, or see the FSF site: http://www.fsf.org.
 */

package org.cdservice.model;

import com.netflix.hystrix.HystrixCommand;
import com.netflix.hystrix.HystrixCommandGroupKey;

import javax.persistence.EntityManager;
import javax.persistence.TypedQuery;
import java.util.Collections;
import java.util.List;

/**
 * @author <a href="mailto:gytis@redhat.com">Gytis Trikleris</a>
 */
public class GetCatalogListCommand extends HystrixCommand<List> {

    private final EntityManager em;

    private final Integer startPosition;

    private final Integer maxResult;

    public GetCatalogListCommand(EntityManager em, Integer startPosition, Integer maxResult) {
        super(HystrixCommandGroupKey.Factory.asKey("CatalogGroup"));
        this.em = em;
        this.startPosition = startPosition;
        this.maxResult = maxResult;
    }

    public List<Catalog> run() {
        TypedQuery<Catalog> findAllQuery = em
                .createQuery("SELECT DISTINCT c FROM Catalog c ORDER BY c.id", Catalog.class);
        if (startPosition != null) {
            findAllQuery.setFirstResult(startPosition);
        }
        if (maxResult != null) {
            findAllQuery.setMaxResults(maxResult);
        }
        return findAllQuery.getResultList();
    }

    public List<Catalog> getFallback() {
        Catalog catalog = new Catalog();
        catalog.setArtist("Fallback");
        catalog.setTitle("This is a circuit breaker");
        return Collections.singletonList(catalog);
    }

}
