import 'package:test/test.dart';

import 'package:solr_dart/solr_dart.dart';

void main() {
  group('Connection Initialization:', () {
    test('Core is required', () {
      expect(() => SolrClient(), throwsA(isA<AssertionError>()));
    });

    test('Connection with no paramters execept core', () {
      var client = SolrClient(core: 'test');

      expect(client.host, '127.0.0.1');
      expect(client.port, 8983);
      expect(client.rootPath, 'solr');
      expect(client.protocol, 'http');

      expect(client.needAuth, false);
    });

    test('Both user name and password is required for auth', () {
      var client = SolrClient(user: 'test', password: 'password', core: 'test');
      expect(client.needAuth, true);

      client = SolrClient(user: 'test', core: 'test');
      expect(client.needAuth, false);

      client = SolrClient(password: 'password', core: 'test');
      expect(client.needAuth, false);
    });
  });

}
