/// A generic exception for http error from solr
class SolrClientException implements Exception {
  String message;
  SolrClientException(this.message);
}
