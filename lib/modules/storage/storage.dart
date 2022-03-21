import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';


const __storage = FlutterSecureStorage();

class Storage {

  static Future<String?> getValue (key) async {
    return __storage.read(key: key);
  }

  static Future<void> setValue (String key, String value) async {
    return __storage.write(key: key, value: value);
  }

  static String jsonEnc (dynamic data) {
    return json.encode(data);
  }

  static dynamic jsonDec (String? str) {
    if (str == null) {
      return "";
    }
    else {
      return json.decode(str);
    }
  }

  static Future<dynamic> fetchTasks() {
    return getValue(Keys.tasks).then((v) => (jsonDec(v))["tasks"]);
  }
}

class Keys {
  static String login = "loginStatus";
  static String tasks = "tasks";
  static String taskNum = "globalTaskNum";
  static String weekNum = "globalWeekNum";
}