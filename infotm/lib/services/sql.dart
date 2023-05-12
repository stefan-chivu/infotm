import 'package:mysql_client/mysql_client.dart';

class SqlService {
  static final pool = MySQLConnectionPool(
      host: "http://35.211.208.184/",
      port: 3306,
      userName: 'infotm',
      password: 'qt88I45d[BubbdgN',
      maxConnections: 10,
      databaseName: 'infotm',
      secure: true,
      timeoutMs: 2000);

  SqlService._privateConstructor();
  static final SqlService instance = SqlService._privateConstructor();
}
