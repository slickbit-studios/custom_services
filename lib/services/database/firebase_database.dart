import 'package:firebase_database/firebase_database.dart';

class DatabaseNode {
  final DatabaseReference _query;

  DatabaseNode() : _query = FirebaseDatabase.instance.ref();

  DatabaseNode._withQuery(DatabaseReference query) : _query = query;

  DatabaseNode getChildNode(String key) {
    var child = _query.child(key);
    return DatabaseNode._withQuery(child);
  }

  Future<int> get intValue async {
    try {
      return (await _query.once()).snapshot.value as int;
    } catch (err) {
      throw 'Failed to get int value from database at node ${_query.path}';
    }
  }

  Future<bool> get boolValue async {
    try {
      return (await _query.once()).snapshot.value as bool;
    } catch (err) {
      throw 'Failed to get bool value from database at node ${_query.path}';
    }
  }

  Future<String> get stringValue async {
    try {
      return (await _query.once()).snapshot.value as String;
    } catch (err) {
      throw 'Failed to get String value from database at node ${_query.path}';
    }
  }
}
