import 'package:mysql1/mysql1.dart';

final today = DateTime.now();
final firstDay = DateTime(today.year, today.month - 10, today.day);
final lastDay = DateTime(today.year, today.month + 10, today.day);

class Mysql {
  static String host = '74.207.234.113',
      user = 'esseee',
      password = 'essee1234',
      db = 'mydb';
  static int port = 3306;

  Mysql();

  Future<MySqlConnection> getConnection() async {
    var settings = ConnectionSettings(
        host: host,
        port: port,
        user: user,
        password: password,
        db: db
    );
    return await MySqlConnection.connect(settings);
  }
}

String getNowDateTime() {
  return DateTime.now().toString().split(".")[0];
}