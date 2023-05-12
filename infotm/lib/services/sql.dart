import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:infotm/models/address.dart';
import 'package:infotm/models/pin.dart';
import 'package:mysql_client/mysql_client.dart';

import 'constants.dart';

class SqlService {
  static final pool = MySQLConnectionPool(
      host: "35.211.208.184",
      port: 3306,
      userName: 'infotm',
      password: 'qt88I45d[BubbdgN',
      maxConnections: 10,
      databaseName: 'infotm',
      secure: true,
      timeoutMs: 2000);

  SqlService._privateConstructor();
  static final SqlService instance = SqlService._privateConstructor();

  static Future<List<Pin>> getAllPins() async {
    List<Pin> pins = [];
    var pinQuery = await pool.execute("SELECT * FROM Pins").timeout(
        Constants.sqlTimeoutDuration,
        onTimeout: () => throw TimeoutException(Constants.sqlTimeoutMessage));

    for (var row in pinQuery.rows) {
      int pinId = row.typedColByName<int>("id")!;
      double latitude = row.typedColByName<double>("latitude")!;
      double longitude = row.typedColByName<double>("longitude")!;
      String pinType = row.typedColByName<String>("type") ?? '';
      String? name = row.typedColByName<String>("name");
      String addressString = row.typedColByName<String>("address") ?? '{}';
      Address? address = Address.fromJson(jsonDecode(addressString));
      String? scheduleStart = row.typedColByName<String>("schedule_start");
      String? scheduleEnd = row.typedColByName<String>("schedule_end");

      PinType pt = PinType.values.firstWhere(
          (e) => e.toString() == 'PinType.$pinType',
          orElse: (() => PinType.other));

      pins.add(Pin(
          id: pinId,
          latitude: latitude,
          longitude: longitude,
          type: pt,
          name: name,
          address: address,
          scheduleStart: scheduleStart,
          scheduleEnd: scheduleEnd));
    }

    return pins;
  }

  static void createUserFromFirebaseUser(User user) {}

  static Future<bool> getUserAdminStatus(String uid) async {
    bool isAdmin = false;
    try {
      var res = await pool.execute(
          "SELECT is_admin FROM Users WHERE uid = :uid", {
        uid: uid
      }).timeout(Constants.sqlTimeoutDuration,
          onTimeout: () => throw TimeoutException(Constants.sqlTimeoutMessage));

      isAdmin = res.rows.first.typedColByName<bool>("is_admin")!;
    } catch (e) {
      return false;
    }

    return isAdmin;
  }

  static Future<void> addUserToDatabase(String uid, bool isAdmin) async {
    await pool.execute(
        "INSERT INTO `Users` (`uid`, `is_admin`) VALUES (:uid, :is_admin)", {
      "uid": uid,
      "is_admin": isAdmin,
    }).timeout(Constants.sqlTimeoutDuration,
        onTimeout: () => throw TimeoutException(Constants.sqlTimeoutMessage));
  }
}
