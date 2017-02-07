angular.module('cdservice').factory('CatalogResource', function ($resource) {
  return $resource('${cdfront.url}:CatalogId', { CatalogId: '@id' }, {
    'queryAll': {
      method: 'GET',
      isArray: true
    }, 'query': { method: 'GET', isArray: false }, 'update': { method: 'PUT' }
  });
});
