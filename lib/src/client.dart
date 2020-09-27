import 'dart:core';
import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

import './exceptions.dart';

Map<String, String> apiRequestHeaders = {
  'Content-type': 'application/json',
  'Accept': 'application/json',
};

class SolrClient {
  // All fields are private. Don't want the end user to change during runtime
  String _core;
  String _rootPath;

  bool _needAuth = false;
  Uri _baseUri;

  @visibleForTesting
  var httpClient = http.Client();

  SolrClient(
      {String host = '127.0.0.1',
      int port = 8983,
      @required String core,
      String rootPath = 'solr',
      String protocol = 'http',
      String user,
      String password})
      : _core = core,
        _rootPath = rootPath,
        assert(core != null),
        assert(port != null) {
    if (user != null && password != null) {
      _needAuth = true;
    }

    if (_needAuth) {
      this._baseUri = Uri(
          scheme: protocol,
          host: host,
          port: port,
          userInfo: '$user:$password');
    } else {
      this._baseUri = Uri(scheme: protocol, host: host, port: port);
    }
  }

  String get host => _baseUri.host;
  int get port => _baseUri.port;
  String get core => _core;
  String get rootPath => _rootPath;
  String get protocol => _baseUri.scheme;
  String get userInfor => _baseUri.userInfo;
  bool get needAuth => _needAuth;

  // PUBLIC API --------------------------------------------------------

  /// ping'ing as solr core gives returns back a basic helth check
  Future<Map<String, dynamic>> ping() async {
    var pingUri =
        _baseUri.replace(pathSegments: [_rootPath, _core, 'admin', 'ping']);

    var response = await httpClient.get(pingUri);

    if (response.statusCode != 200)
      throw SolrClientException('Wrong url or core does not exist');

    return jsonDecode(response.body);
  }

  /// search the index using a [Query].
  ///
  /// Takes in the a [Query] object, which has all the paramters for the query.
  /// Returns the result of the query as a [Map]. This map is just the decoded
  /// JSON response from the Solr server.
  Future<Map<String, dynamic>> search(query) async {
    var searchUrl = _baseUri.replace(pathSegments: [_rootPath, _core, 'query']);
    var response = await httpClient.post(searchUrl,
        body: query.json, headers: apiRequestHeaders);

    if (response.statusCode != 200)
      throw SolrClientException('Wrong url or core does not exist');

    return jsonDecode(response.body);
  }
}
