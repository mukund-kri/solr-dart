import 'package:test/test.dart';

import 'package:solr_dart/solr_dart.dart';

void main() {
  group('Query Construction: ', () {
    test('toJson', () {
      var query = Query(query: '*.*');
      expect(query.toJson(), {'query': '*.*'});
    });
    test('Basic query to json string', () {
      var query = Query(query: '*.*');
      expect(query.json, '{"query":"*.*"}');
    });

    test('Parameters query, offset, limit, sort', () {
      var query = Query(query: 'memory', offset: 0, limit: 10, sort: 'asc');

      expect(query.toJson(), {"query":"memory","offset":0,"limit":10,"sort":"asc"});
      expect(query.json, '{"query":"memory","offset":0,"limit":10,"sort":"asc"}');
    });
  });
}
