angular.module('cdservice').factory('CatalogResource', function ($resource,$http) {

  var serviceUrl = $http.get("service.json")
    .success(function (data) {
      console.log("Resource : " + data['cd-service'] + ':CatalogId');
      return data['cd-service'].toString();
    })
    .error(function () {
      console.log('could not find service.json ....');
    });
  //var resource = $resource('http://localhost:8080/rest/catalogs/:CatalogId', {CatalogId: '@id'}, {
  var resource = $resource(serviceUrl + ':CatalogId', {CatalogId: '@id'}, {
    'queryAll': {
      method: 'GET',
      isArray: true
    }, 'query': {method: 'GET', isArray: false}, 'update': {method: 'PUT'}
  });
  return resource;
});