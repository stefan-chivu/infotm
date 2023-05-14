import 'package:infotm/models/isar_itinerary.dart';
import 'package:infotm/models/isar_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:isar/isar.dart';

class IsarService {
  static late final Isar isar;
  static late IsarUser isarUser;
  static late IsarItinerary isarItinerary;

  IsarService._privateConstructor();
  static final IsarService instance = IsarService._privateConstructor();

  static Future<void> openSchemas() async {
    isar =
        await Isar.open([IsarUserSchema, IsarItinerarySchema], inspector: true);
    await initUser();
  }

  static Future<void> initUser() async {
    isarUser = await isar.isarUsers.get(0) ??
        IsarUser(
          uid: '',
          email: '',
          isAdmin: false,
        );
    isarItinerary = IsarItinerary(itinerary: '');
    await isar.writeTxn(() async {
      await isar.isarUsers.put(isarUser);
      await isar.isarItinerarys.put(isarItinerary);
    });
  }

  static Future<void> createUserFromFirestoreUser(
      User user, bool isAdmin) async {
    await isar.writeTxn(() async {
      await isar.isarUsers.delete(isarUser.id);
      IsarUser isarUserFromFirestoreUser = IsarUser(
        uid: user.uid,
        email: user.email ?? "",
        isAdmin: isAdmin,
      );

      isarUser = isarUserFromFirestoreUser;
      await isar.isarUsers.put(isarUser);
    });
  }

  static Future<void> setUser(IsarUser user) async {
    isarUser = user;
    await isar.writeTxn(() async {
      await isar.isarUsers.put(user);
    });
  }

  static Future<void> setItinerary(String jsonItinerary) async {
    isarItinerary.itinerary = jsonItinerary;

    await isar.writeTxn(() async {
      await isar.isarItinerarys.put(isarItinerary);
    });
  }

  static Future<void> updateUser() async {
    await isar.writeTxn(() async {
      await isar.isarUsers.put(isarUser);
    });
  }

  static Future<void> deleteLocalUser() async {
    await isar.writeTxn(() async {
      await isar.isarUsers.delete(isarUser.id);
      await isar.isarItinerarys.filter().idGreaterThan(-1).deleteAll();
    });
    await initUser();
  }

  static String getUid() {
    return isarUser.uid;
  }

  static bool getAdminStatus() {
    return isarUser.isAdmin;
  }
}
