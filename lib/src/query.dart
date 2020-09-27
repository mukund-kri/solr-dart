import 'dart:convert';

/// Query class holds the information to create the json part of the API
/// sent to solr
class Query {
  String query;
  int offset;
  int limit;
  String sort;

  Query({this.query, this.offset, this.limit, this.sort});

  /// Convert query parameters [Map<String, dynamic>] compatable with dart:convert
  /// functions
  Map<String, dynamic> toJson() {
    var queryParamMap = Map<String, dynamic>();

    if (this.query != null) queryParamMap['query'] = query;
    if (this.offset != null) queryParamMap['offset'] = offset;
    if (this.limit != null) queryParamMap['limit'] = limit;
    if (this.sort != null) queryParamMap['sort'] = sort;

    return queryParamMap;
  }

  /// Convience getter to get the final json string that is sent as data in
  /// http requests
  String get json {
    return jsonEncode(toJson());
  }
}
