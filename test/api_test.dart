import 'dart:core';
import 'dart:convert';

import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import 'package:solr_dart/solr_dart.dart';
import 'fixture_helper.dart';

class MockHTTPClient extends Mock implements http.Client {}

// URIs for solr api
final PING_URI =
    Uri.parse('http://127.0.0.1:8983/solr/gettingstarted/admin/ping');
final QUERY_URI = Uri.parse('http://127.0.0.1:8983/solr/gettingstarted/query');
final UPDATE_URI =
    Uri.parse('http://127.0.0.1:8983/sorl/gettingstarted/update');

void main() async {
  SolrClient client;
  var fixtures = await loadAllFixtures('gettingstarted');

  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  setUp(() {
    client = SolrClient(core: 'gettingstarted');
    client.httpClient = MockHTTPClient();
  });

  group('API tests', () {
    test('Ping should work', () async {
      when(client.httpClient.get(PING_URI))
          .thenAnswer((_) async => http.Response(fixtures['ping'], 200));
      var response = await client.ping();

      expect(response['status'], 'OK');
    });

    test('Simple Search', () async {
      var queryJson = '{"query":"*"}';
      when(client.httpClient.post(QUERY_URI, body: queryJson, headers: headers))
          .thenAnswer(
              (_) async => http.Response(fixtures['simple_query'], 200));

      var query = Query(query: '*');
      Map<String, dynamic> response = await client.search(query);
      expect(response['response']['numFound'], 50);
    });
  });

  group('Update API', () {
    test('Adding a new object', () {});

    test('Delete a document by ID', () async {
      var json = '{"delete":{"id":"1","commitWithin":5000}}';
      when(client.httpClient.post(UPDATE_URI, body: json, headers: headers))
          .thenAnswer((_) async => http.Response(fixtures['delete'], 200));

      var response = await client.delete(id: "1", commitWithin: 5000);
      expect(response["responseHeader"]["status"], 0);
    });
  });
}
