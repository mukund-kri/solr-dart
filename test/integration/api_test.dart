/*
 * Running tests on a live solr server. Read the documation before you try
 * to run these tests.
 */

import 'package:http/http.dart';
import 'package:test/test.dart';

import 'package:solr_dart/solr_dart.dart';

void main() {
  group('API integration:', () {
    SolrClient client;
    SolrClient nonExistantCoreClient;

    setUp(() {
      client = SolrClient(core: 'gettingstarted');
      nonExistantCoreClient = SolrClient(core: 'nonexistant');
    });

    test('Ping test', () async {
      var response = await client.ping();
      expect(response['status'], 'OK');
    });

    /// pinging a non existant core throws Not found
    test('Ping a core that does not exist', () {
      expect(
          () => nonExistantCoreClient.ping(),
          throwsA(isA<SolrClientException>().having((error) => error.message,
              'message', 'Wrong url or core does not exist')));
    });

    test('Simple Search', () async {
      var query = Query(query: '*');
      var response = await client.search(query);
      expect(response['response']['numFound'], 50);
    });

    test('Simple Search on non existant core', () async {
      var query = Query(query: '*');
      expect(
          () => client.search(query),
          throwsA(isA<SolrClientException>().having((error) => error.message,
              'message', 'Wrong url or core does not exist')));
    });

    test('Query with filter', () async {
      var query = Query(query: '*', filter: ['id:USD']);
      var response = client.search(query);
    });

    test('Delete a doc from the index', () async {
      var client = SolrClient(core: 'gettingstarted');
      var response = client.delete(id: "1", commitWithin: 5000);

      expect(response['responseHeader']['status'], 0);
    });

    test('test adding a document', () async {
      var doc = {'id': 'TEST1', 'text': 'testing solr'};
      var client = SolrClient(core: 'gettingstarted');

      // Add a new doc
      var response = client.add(doc: doc, commitWithin: 100);

      // test the response

      // Finally delete the newly create doc
      response = client.delete(id: "1", commitWithin: 5000);
    });
  }, skip: false);
}
