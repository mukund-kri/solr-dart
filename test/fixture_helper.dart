import 'dart:io';

import 'package:path/path.dart' as p;

var fixturesRootDir = 'test/fixtures';

/// Load a fixture json
///
/// Given a [fixtureName] locate the fixture file, read JSON from that file
/// and return JSON
Future<String> fixture(String fixtureName) async {
  var fixtureFileName = p.join(fixturesRootDir, '$fixtureName.json');
  return File(fixtureFileName).readAsString();
}

/// Load all the json files avaliable in a sub-directory of [test/fixtures]
/// as fixtures.
///
/// Takes a single parameters [dirName] which should be a sub-directory of
/// `test/fixtures` and returns a Map of fixture name -> fixture json.
Future<Map<String, String>> loadAllFixtures(String dirName) async {
  var result = Map<String, String>();
  var fixtureDir = Directory(p.join(fixturesRootDir, dirName));

  await for (var file in fixtureDir.list()) {
    if (file is File && p.extension(file.path) == '.json') {
      var fixureName = p.basenameWithoutExtension(file.path);
      var fixureJson = await (file as File).readAsString();
      result[fixureName] = fixureJson;
    }
  }

  return result;
}

void main() async {
  // var result = await loadAllFixtures('other');
  var result = await fixture('other/ping');
  print(result);
}
