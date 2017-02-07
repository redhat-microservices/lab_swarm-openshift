# To reproduce

mvn clean wildfly-swarm:run -Dbackend.url=http://localhost:8080/rest/catalogs/ 

next, open browser at this address : http://localhost:8081/scripts/services/CatalogFactory.js

We will get 

```
angular.module('cdservice').factory('CatalogResource', function ($resource, config) {
  return $resource(':CatalogId', { CatalogId: '@id' }, {
    'queryAll': {
      method: 'GET',
      isArray: true
    }, 'query': { method: 'GET', isArray: false }, 'update': { method: 'PUT' }
  });
});
```

and not 

```
angular.module('cdservice').factory('CatalogResource', function ($resource) {
  return $resource('http://localhost:8080/rest/catalogs/:CatalogId', { CatalogId: '@id' }, {
    'queryAll': {
      method: 'GET',
      isArray: true
    }, 'query': { method: 'GET', isArray: false }, 'update': { method: 'PUT' }
  });
});
```

