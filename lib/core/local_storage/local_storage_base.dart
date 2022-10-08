import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalStorageBase {
  save({required String key, required Map<String,dynamic> value});

  Map<String, dynamic> read({required String key});
}

class LocalStorage extends LocalStorageBase {
  final SharedPreferences sharedPreferences;

  LocalStorage({required this.sharedPreferences});

  @override
  save({required String key, required Map<String,dynamic> value}) {
    sharedPreferences.setString(key, jsonEncode(value));
  }

  @override
  Map<String, dynamic> read({required String key}) {
    var result = sharedPreferences.getString(key);
    if (result == null) throw NullThrownError();
    return jsonDecode(result);
  }
}
